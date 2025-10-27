-- chunkname: @scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay.lua

local Blueprints = require("scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay_blueprints")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local HavocSettings = require("scripts/settings/havoc_settings")
local Definitions = require("scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay_definitions")
local ElementSettings = require("scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay_settings")
local InputDevice = require("scripts/managers/input/input_device")
local MissionTypes = require("scripts/settings/mission/mission_types")
local TextUtils = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local InputUtils = require("scripts/managers/input/input_utils")
local HordeBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local MissionBuffsParser = require("scripts/ui/constant_elements/elements/mission_buffs/utilities/mission_buffs_parser")
local CharacterSheet = require("scripts/utilities/character_sheet")
local MasterItems = require("scripts/backend/master_items")
local Items = require("scripts/utilities/items")
local TalentLayoutParser = require("scripts/ui/views/talent_builder_view/utilities/talent_layout_parser")
local TalentBuilderViewSettings = require("scripts/ui/views/talent_builder_view/talent_builder_view_settings")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local HudElementTacticalOverlay = class("HudElementTacticalOverlay", "HudElementBase")
local default_mission_type_icon = "content/ui/materials/icons/mission_types/mission_type_side"
local default_material = "content/ui/materials/base/ui_default_base"
local default_texture = "content/ui/textures/placeholder_texture"
local default_gradient = "content/ui/textures/color_ramps/talent_ability"
local default_title = ""
local default_description = ""
local _text_extra_options = {}

local function _text_width(ui_renderer, text, style)
	local text_extra_options = _text_extra_options

	table.clear(text_extra_options)
	UIFonts.get_font_options_by_style(style, text_extra_options)

	local width = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, style.size, text_extra_options)

	return math.round(width)
end

HudElementTacticalOverlay.init = function (self, parent, draw_layer, start_scale, optional_context)
	HudElementTacticalOverlay.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._context = table.add_missing(optional_context or {}, ElementSettings.default_context)
	self._difficulty_manager = Managers.state.difficulty
	self._mission_manager = Managers.state.mission
	self._circumstance_manager = Managers.state.circumstance
	self._backend_interfaces = Managers.backend.interfaces
	self._contract_data = {}
	self._game_mode_name = Managers.state.game_mode:game_mode_name()

	self:_fetch_task_list()

	self._havoc_data = Managers.state.difficulty:get_parsed_havoc_data()
	self._preferred_page = Managers.save:account_data().right_panel_category
	self._right_panel_entries = {}
	self._tracked_achievements = 0
	self._grid_overrides = {}

	self:_setup_left_panel_widgets()
	self:_setup_right_panel_widgets()
	self:on_resolution_modified()

	self._using_input = false

	self:_create_resource_renderer()
	Managers.event:register(self, "reroll_contracts", "reroll_contracts")
	Managers.event:register(self, "event_tactical_overlay_change_using_input", "set_using_input")
end

HudElementTacticalOverlay.destroy = function (self, ui_renderer)
	Managers.event:unregister(self, "reroll_contracts")
	Managers.event:unregister(self, "event_tactical_overlay_change_using_input")

	local contracts_promise = self._contracts_promise

	if contracts_promise and contracts_promise:is_pending() then
		contracts_promise:cancel()
	end

	Managers.save:account_data().right_panel_category = self._right_panel_key

	self:_delete_tab_bar(ui_renderer)

	for page_key, _ in pairs(self._right_panel_entries) do
		self:_delete_right_panel_widgets(page_key, ui_renderer)
	end

	self:_destroy_resource_renderer()
	HudElementTacticalOverlay.super.destroy(self, ui_renderer)
end

HudElementTacticalOverlay._create_resource_renderer = function (self)
	local buffs_renderer_name = self.__class_name .. "tactical_overlay_buffs_renderer"
	local resource_renderer_name = self.__class_name .. "tactical_overlay_resource_renderer"
	local material_name = "content/ui/materials/render_target_masks/ui_render_target_straight_blur"
	local timer_name = "ui"
	local world_layer = self._draw_layer + 1
	local world_name = self.__class_name .. "_ui_tactical_overlay_world"
	local world = Managers.ui:create_world(world_name, world_layer, timer_name)
	local viewport_name = self.__class_name .. "_ui_tactical_overlay_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1

	self._viewport = Managers.ui:create_viewport(world, viewport_name, viewport_type, viewport_layer)
	self._buffs_renderer = Managers.ui:create_renderer(buffs_renderer_name, world)

	local gui = self._buffs_renderer.gui
	local gui_retained = self._buffs_renderer.gui_retained

	self._resource_renderer = Managers.ui:create_renderer(resource_renderer_name, world, true, gui, gui_retained, material_name)
	self._world = world
end

HudElementTacticalOverlay._add_class_buffs_data = function (self, display_buffs, profile)
	local class_loadout = {
		ability = {},
		blitz = {},
		aura = {},
		passives = {},
		coherency = {},
		special_rules = {},
		buff_template_tiers = {},
		iconics = {},
		modifiers = {},
	}

	CharacterSheet.class_loadout(profile, class_loadout)

	local category_id = "talents"

	for talent_type, talent_data in pairs(class_loadout) do
		if talent_type == "ability" or talent_type == "blitz" or talent_type == "aura" then
			local talent_type_lookup = talent_type

			if talent_type == "blitz" then
				talent_type_lookup = "tactical"
			end

			local settings_by_node_type = TalentBuilderViewSettings.settings_by_node_type[talent_type_lookup]

			if settings_by_node_type then
				local frame = settings_by_node_type.frame
				local icon_mask = settings_by_node_type.icon_mask
				local title = talent_data.talent and talent_data.talent.display_name and Localize(talent_data.talent.display_name)
				local description = talent_data.talent and TalentLayoutParser.talent_description(talent_data.talent, 1)
				local modifiers = class_loadout.modifiers[talent_type]
				local icon = talent_data.icon or talent_data.large_icon

				display_buffs[#display_buffs + 1] = {
					material = "content/ui/materials/frames/talents/talent_icon_container",
					title = title,
					description = description,
					material_values = {
						texture_map = "",
						gradient_map = settings_by_node_type and settings_by_node_type.gradient_map,
						frame = frame,
						icon_mask = icon_mask,
						icon = icon,
					},
					category = category_id,
					sub_category = talent_type,
					size = {
						65,
						65,
					},
					offset = {
						-5,
						-5,
					},
				}

				if modifiers then
					for i = 1, #modifiers do
						local modifier_talent = modifiers[i]
						local modifier_title = modifier_talent.display_name and Localize(modifier_talent.display_name)
						local modifier_description = TalentLayoutParser.talent_description(modifier_talent, 1)
						local modifier_icon = modifier_talent.icon or modifier_talent.large_icon

						if talent_type == "ability" and class_loadout.combat_ability then
							modifier_icon = class_loadout.combat_ability.hud_icon or modifier_icon
						else
							modifier_icon = talent_type == "blitz" and class_loadout.grenade_ability and class_loadout.grenade_ability.hud_icon or modifier_icon
						end

						display_buffs[#display_buffs + 1] = {
							material = "content/ui/materials/frames/talents/talent_icon_container",
							title = modifier_title,
							description = modifier_description,
							material_values = {
								texture_map = "",
								gradient_map = settings_by_node_type and settings_by_node_type.gradient_map,
								frame = frame,
								icon_mask = icon_mask,
								icon = modifier_icon,
							},
							category = category_id,
							sub_category = talent_type,
							size = {
								40,
								40,
							},
							offset = {
								15,
								-5,
							},
						}
					end
				end
			end
		end
	end
end

HudElementTacticalOverlay._add_items_buffs_data = function (self, display_buffs, profile)
	local category_id = "items"

	for slot, item in pairs(profile.loadout) do
		local is_weapon = Items.is_weapon(item.item_type)

		if is_weapon and item.traits then
			for i = 1, #item.traits do
				local trait = item.traits[i]
				local trait_id = trait.id
				local trait_value = trait.value
				local trait_rarity = trait.rarity
				local trait_item = MasterItems.get_item(trait_id)
				local display_name = trait_item.display_name
				local title = Localize(display_name)
				local texture_icon, texture_frame = Items.trait_textures(trait_item, trait_rarity)
				local description = Items.trait_description(trait_item, trait_rarity, trait_value)

				display_buffs[#display_buffs + 1] = {
					material = "content/ui/materials/icons/traits/traits_container",
					title = title,
					material_values = {
						icon = texture_icon,
						frame = texture_frame,
					},
					description = description,
					category = category_id,
					sub_category = string.lower(item.item_type),
					icon_color = Color.terminal_text_header(255, true),
					item = trait_item,
				}
			end
		end
	end
end

HudElementTacticalOverlay._add_player_buffs = function (self)
	local extensions = self._parent:player_extensions()
	local buff_extension = extensions and extensions.buff
	local buffs = buff_extension:buffs()
	local display_buffs = {}

	if not buffs then
		return display_buffs
	end

	local player_manager = Managers.player
	local player = player_manager:local_player(1)
	local profile = player and player:profile()
	local display_buffs = {}

	self:_add_class_buffs_data(display_buffs, profile)
	self:_add_items_buffs_data(display_buffs, profile)

	for i = 1, #buffs do
		local buff = buffs[i]

		if not buff:is_negative() then
			local buff_template = buff:template()
			local buff_hud_data = buff:get_hud_data()
			local buff_category = buff_template and buff_template.buff_category
			local buff_name = buff_hud_data.title
			local buff_description = buff_hud_data.description
			local buff_icon = buff_template and buff_template.icon
			local buff_hud_icon = buff_hud_data and buff_hud_data.hud_icon
			local buff_hud_icon_gradient_map = buff_hud_data and buff_hud_data.hud_icon_gradient_map
			local is_talent = buff_category == "talents" or buff_category == "talents_secondary"
			local is_gadget = buff_category == "gadget"
			local is_weapon = buff_category == "weapon_traits"
			local is_generic = buff_category == "generic"
			local is_aura = buff_category == "aura"
			local is_horde = buff_category == "hordes_buff"
			local is_horde_sub_buff = buff_category == "hordes_sub_buff"
			local is_live_event_buff = buff_category == "live_event"
			local has_hud = buff:has_hud()
			local is_active = buff_hud_data.show

			if not is_generic and not is_weapon and not is_gadget and not is_aura and not is_talent and not is_horde_sub_buff and not is_live_event_buff or has_hud then
				local skip_buff = buff_template.skip_tactical_overlay
				local material

				if buff_icon == "content/ui/materials/icons/abilities/default" or not buff_icon then
					material = default_material
				else
					material = buff_icon
				end

				local texture, gradient, material_values

				if buff_hud_icon and buff_hud_icon_gradient_map then
					material = "content/ui/materials/icons/buffs/hud/buff_container_with_background"
					material_values = {
						opacity = 1,
						progress = 1,
						texture_map = "",
						talent_icon = buff_hud_icon,
						gradient_map = buff_hud_icon_gradient_map,
					}
				elseif buff_hud_icon then
					texture = buff_hud_icon
				else
					texture = default_texture
					gradient = default_gradient
				end

				local title = buff_name and buff_name ~= "" and buff_name or default_title
				local description = buff_description and buff_description ~= "" and buff_description or default_description
				local category_id, sub_category_id, size, offset

				if is_live_event_buff then
					category_id = "live_event"
					material = "content/ui/materials/frames/talents/talent_icon_container"
					material_values = {
						intensity = 0,
						saturation = 1,
						texture_map = "",
						icon = buff_hud_icon,
						gradient_map = buff_hud_icon_gradient_map,
						frame = buff_template.frame,
						icon_mask = buff_template.icon_mask,
					}
					texture = ""
					size = {
						60,
						60,
					}
					offset = {
						-10,
						-10,
					}
				elseif is_horde then
					category_id = "horde"

					local buff_data = HordeBuffsData[buff_name]

					sub_category_id = buff_data.is_family_buff and "hordes_minor_buff" or "hordes_major_buff"
					title = buff_data and buff_data.title and buff_data.title ~= "" and Localize(buff_data.title) or title
					description = buff_data and MissionBuffsParser.get_formated_buff_description(buff_data, Color.ui_terminal(255, true)) or description
					material = "content/ui/materials/frames/talents/talent_icon_container"
					material_values = {
						frame = "content/ui/textures/frames/horde/hex_frame_horde",
						icon_mask = "content/ui/textures/frames/horde/hex_frame_horde_mask",
						intensity = 0,
						saturation = 1,
						texture_map = "",
						icon = buff_data and buff_data.icon and buff_data.icon ~= "" and buff_data.icon or default_texture,
						gradient_map = buff_data and buff_data.gradient and buff_data.gradient ~= "" and buff_data.gradient or default_gradient,
					}
					texture = ""
					size = {
						60,
						60,
					}
					offset = {
						-10,
						-10,
					}
				elseif is_talent or is_aura then
					local found_buff = false
					local buff_related_talent = buff_template.related_talents and buff_template.related_talents[1]

					for player_archetype, archetype_talents in pairs(ArchetypeTalents) do
						for talent_name, definition in pairs(archetype_talents) do
							local talent_buff_passive_template_name = definition.passive and definition.passive.buff_template_name
							local talent_buff_coherency_template_name = definition.coherency and definition.coherency.buff_template_name

							if talent_buff_passive_template_name == buff_name or talent_buff_coherency_template_name == buff_name or talent_name == buff_related_talent then
								title = definition.display_name and Localize(definition.display_name) or title
								description = TalentLayoutParser.talent_description(definition, 1) or description

								for j = 1, #display_buffs do
									local display_buff = display_buffs[j]

									if display_buff.category == "talents" then
										local trait_title = display_buff.title

										if trait_title == title then
											if is_active then
												display_buff.category = "active_buffs"
												display_buff.material = "content/ui/materials/icons/buffs/hud/buff_container_with_background"
												display_buff.texture = ""
												display_buff.gradient = nil
												display_buff.material_values = {
													opacity = 1,
													progress = 1,
													texture_map = "",
													talent_icon = buff_hud_icon,
													gradient_map = buff_hud_icon_gradient_map,
												}
												display_buff.size = nil
												display_buff.offset = nil
											end

											skip_buff = true

											break
										end
									end
								end

								if not skip_buff and is_talent then
									category_id = "talents"
									sub_category_id = "other_talents"
								end

								found_buff = true

								break
							end
						end

						if found_buff then
							break
						end
					end
				elseif is_weapon then
					if is_active then
						for j = 1, #display_buffs do
							local display_buff = display_buffs[j]

							if display_buff.category == "items" then
								local trait_name = display_buff.item.trait
								local trait_name_added_suffix = string.format("%s_parent", trait_name)

								if buff_template.name == trait_name or buff_template.name == trait_name_added_suffix then
									display_buff.category = "active_buffs"
									display_buff.material = "content/ui/materials/icons/buffs/hud/buff_container_with_background"
									display_buff.texture = ""
									display_buff.gradient = nil
									display_buff.material_values = {
										opacity = 1,
										progress = 1,
										texture_map = "",
										talent_icon = buff_hud_icon,
										gradient_map = buff_hud_icon_gradient_map,
									}
								end
							end
						end
					end

					skip_buff = true
				end

				if not is_horde and not is_live_event_buff and is_active then
					category_id = "active_buffs"
					sub_category_id = sub_category_id or "other_buffs"
				end

				if not skip_buff then
					display_buffs[#display_buffs + 1] = {
						material = material,
						texture = texture,
						gradient = gradient,
						material_values = material_values,
						title = title,
						description = description,
						category = category_id,
						sub_category = sub_category_id,
						size = size,
					}
				end
			end
		end
	end

	return display_buffs
end

HudElementTacticalOverlay._generate_buffs_layout = function (self, display_buffs)
	local buffs_category_prio = {
		"horde",
		"live_event",
		"active_buffs",
		"talents",
		"items",
		"default",
	}
	local buffs_category_talents_prio = {
		"ability",
		"aura",
		"blitz",
		"other_talents",
	}
	local buff_title_display_name = {
		active_buffs = Localize("loc_horde_tactical_overlay_category_active"),
		horde = Localize("loc_horde_tactical_overlay_category_sefoni"),
		items = Localize("loc_horde_tactical_overlay_category_loadout"),
		talents = Localize("loc_horde_tactical_overlay_category_talents"),
		default = Localize("loc_horde_tactical_overlay_category_misc"),
	}
	local active_live_event_name = Managers.live_event:get_active_event_name()

	if active_live_event_name then
		buff_title_display_name.live_event = Localize(active_live_event_name)
	end

	local buff_sub_title_display_name = {
		default = "",
		hordes_major_buff = Localize("loc_horde_tactical_overlay_build_major"),
		hordes_minor_buff = Localize("loc_horde_tactical_overlay_build_lesser"),
		weapon_ranged = Localize("loc_tactical_overlay_build_ranged"),
		weapon_melee = Localize("loc_tactical_overlay_build_melee"),
		blitz = Localize("loc_tactical_overlay_build_blitz"),
		ability = Localize("loc_tactical_overlay_build_ability"),
		aura = Localize("loc_tactical_overlay_build_aura"),
		other_talents = Localize("loc_tactical_overlay_build_talents_other"),
		other_buffs = Localize("loc_tactical_overlay_build_other"),
	}
	local sorted_buffs = {}

	for i = 1, #display_buffs do
		local display_buff = display_buffs[i]
		local category = display_buff.category or "default"
		local sub_category = display_buff.sub_category or "default"

		if not sorted_buffs[category] then
			sorted_buffs[category] = {}
		end

		if not sorted_buffs[category][sub_category] then
			sorted_buffs[category][sub_category] = {}
		end

		local index = #sorted_buffs[category][sub_category] + 1

		sorted_buffs[category][sub_category][index] = display_buff
	end

	local layout = {}

	for i = 1, #buffs_category_prio do
		local category = buffs_category_prio[i]

		if sorted_buffs[category] then
			if #layout > 0 then
				layout[#layout + 1] = {
					blueprint = "buff_spacing",
				}
			end

			local buff_title_display_name = buff_title_display_name[category] or buff_title_display_name.default

			layout[#layout + 1] = {
				blueprint = "buff_title",
				title = buff_title_display_name,
			}
			layout[#layout + 1] = {
				blueprint = "buff_spacing",
			}

			for sub_category, buffs in pairs(sorted_buffs[category]) do
				local buff_sub_title_display_name = buff_sub_title_display_name[sub_category] or buff_sub_title_display_name.default

				if buff_sub_title_display_name ~= "" then
					layout[#layout + 1] = {
						blueprint = "buff_sub_title",
						title = buff_sub_title_display_name,
					}
				end

				for j = 1, #buffs do
					local buff = buffs[j]

					layout[#layout + 1] = {
						blueprint = "buff",
						title = buff.title,
						description = buff.description,
						texture = buff.texture,
						gradient = buff.gradient,
						material_values = buff.material_values,
						material = buff.material,
						icon_color = buff.icon_color,
						icon_size = buff.size,
						icon_offset = buff.offset,
					}
				end
			end
		end
	end

	return layout
end

HudElementTacticalOverlay._setup_buffs_presentation = function (self, ui_renderer)
	local extensions = self._parent:player_extensions()
	local buff_extension = extensions and extensions.buff

	if buff_extension then
		local display_buffs = self:_add_player_buffs()
		local layout = self:_generate_buffs_layout(display_buffs)
		local layout_size = #layout

		self._buffs_layout_size = layout_size

		if layout_size > 0 then
			local widgets, alignment_widgets = self:_create_buff_panel_widgets(layout, ui_renderer)

			self._buff_panel_widgets = widgets
			self._buff_panel_grid = UIWidgetGrid:new(widgets, alignment_widgets, self._ui_scenegraph, "buff_panel", "down", {
				0,
				0,
			})

			local scrollbar_widget = self._widgets_by_name.buff_panel_scrollbar
			local grid_content_scenegraph_id = "buff_panel_content"

			self._buff_panel_grid:assign_scrollbar(scrollbar_widget, grid_content_scenegraph_id)
			self._buff_panel_grid:set_scrollbar_progress(0)

			if self._buff_panel_grid:can_scroll() then
				local ingame_service_name = "Ingame"

				Managers.ui:add_inputs_in_use_by_ui("tactical_overlay_scroll_down", ingame_service_name)
				Managers.ui:add_inputs_in_use_by_ui("tactical_overlay_scroll_up", ingame_service_name)
			end

			self._widgets_by_name.buff_panel_background.content.visible = true

			self:_update_buff_input_text()
		end
	end
end

HudElementTacticalOverlay._update_buff_input_text = function (self)
	if self._buff_panel_grid then
		local service_type = "Ingame"
		local action = "tactical_overlay_scroll"
		local input_icon = {
			keyboard = "",
			mouse = "",
			ps4_controller = "",
			xbox_controller = "",
		}
		local last_pressed_device = Managers.input:last_pressed_device()
		local device_type = last_pressed_device and last_pressed_device:type()

		self._widgets_by_name.buff_panel_scrollbar_input_icon.content.visible = self._buff_panel_grid:can_scroll()
		self._widgets_by_name.buff_panel_scrollbar.content.visible = self._buff_panel_grid:can_scroll()
		self._widgets_by_name.buff_panel_scrollbar_input_icon.content.text = input_icon[device_type] or ""
	else
		self._widgets_by_name.buff_panel_scrollbar_input_icon.content.visible = false
	end
end

HudElementTacticalOverlay._remove_buffs_presentation = function (self)
	if self._buff_panel_grid then
		local ingame_service_name = "Ingame"

		Managers.ui:remove_inputs_in_use_by_ui("tactical_overlay_scroll_down", ingame_service_name)
		Managers.ui:remove_inputs_in_use_by_ui("tactical_overlay_scroll_up", ingame_service_name)

		self._widgets_by_name.buff_panel_scrollbar_input_icon.content.visible = false
		self._widgets_by_name.buff_panel_background.content.visible = false
		self._widgets_by_name.buff_panel_scrollbar.content.visible = false
	end

	if self._buff_panel_widgets then
		for i = 1, #self._buff_panel_widgets do
			local widget = self._buff_panel_widgets[i]

			self:_unregister_widget_name(widget.name)
			UIWidget.destroy(self._resource_renderer, widget)
		end

		self._buff_panel_widgets = nil
	end

	self._buffs_layout_size = nil
	self._buff_panel_grid = nil
end

HudElementTacticalOverlay._create_buff_panel_widgets = function (self, configs, ui_renderer)
	local definitions = {}
	local widgets = {}
	local alignment_widgets = {}

	for i = 1, #configs do
		local config = configs[i]
		local blueprint_type = config.blueprint
		local blueprint = Blueprints[blueprint_type]

		if blueprint.pass_template then
			local definition = definitions[blueprint_type] or UIWidget.create_definition(blueprint.pass_template, "buff_panel_content", nil, blueprint.size)

			definitions[blueprint_type] = definition

			local name = string.format("buff_panel_widget_%d", i)
			local widget = self:_create_widget(name, definition)
			local init_function = blueprint.init

			if init_function then
				init_function(self, widget, config, ui_renderer)
			end

			widget.blueprint_type = blueprint_type
			widgets[#widgets + 1] = widget
			alignment_widgets[#alignment_widgets + 1] = widget
		else
			widgets[#widgets + 1] = nil
			alignment_widgets[#alignment_widgets + 1] = blueprint
		end
	end

	return widgets, alignment_widgets
end

HudElementTacticalOverlay._destroy_resource_renderer = function (self)
	if self._world then
		local world_name = self.__class_name .. "_ui_tactical_overlay_world"
		local viewport_name = self.__class_name .. "_ui_tactical_overlay_viewport"
		local buffs_renderer_name = self.__class_name .. "tactical_overlay_buffs_renderer"
		local resource_renderer_name = self.__class_name .. "tactical_overlay_resource_renderer"

		Managers.ui:destroy_renderer(resource_renderer_name)
		Managers.ui:destroy_renderer(buffs_renderer_name)
		ScriptWorld.destroy_viewport(self._world, viewport_name)
		Managers.ui:destroy_world(self._world)

		self._world = nil
		self._viewport = nil
		self._resource_renderer = nil
		self._buffs_renderer = nil
	end
end

HudElementTacticalOverlay._buffs_navigation = function (self, dt, t, input_service)
	local scrollbar_widget = self._widgets_by_name.buff_panel_scrollbar
	local ignore_hud_input = true
	local is_input_blocked = Managers.ui:using_input(ignore_hud_input)

	if scrollbar_widget and not input_service:is_null_service() then
		local content = scrollbar_widget.content
		local axis = content.axis or 2
		local service_type = "Ingame"

		input_service = Managers.input:get_input_service(service_type)

		local scroll_axis = 0
		local scroll_multiplier = 0.8
		local using_controler = not Managers.ui:using_cursor_navigation()

		if using_controler then
			if input_service:get("tactical_overlay_scroll_down") then
				scroll_axis = -1
			elseif input_service:get("tactical_overlay_scroll_up") then
				scroll_axis = 1
			end

			scroll_multiplier = 0.2
		elseif input_service:get("wield_scroll_down") then
			scroll_axis = -1
		elseif input_service:get("wield_scroll_up") then
			scroll_axis = 1
		end

		local scroll_amount = (content.scroll_amount or 0.1) * scroll_multiplier

		if scroll_axis ~= 0 then
			local current_scroll_direction = scroll_axis > 0 and -1 or 1
			local previous_scroll_add = content.scroll_add or 0

			if content.current_scroll_direction and content.current_scroll_direction ~= current_scroll_direction then
				previous_scroll_add = 0
			end

			content.current_scroll_direction = current_scroll_direction
			content.scroll_add = previous_scroll_add + scroll_amount
		end

		local scroll_add = content.scroll_add

		if scroll_add then
			local speed = content.scroll_speed or 10
			local step = scroll_add * (dt * speed)

			if math.abs(scroll_add) > scroll_amount / 500 then
				content.scroll_add = math.max(scroll_add - step * 1.5, 0)
			else
				content.scroll_add = nil
			end

			local current_scroll_direction = content.current_scroll_direction or 0
			local current_scroll_value = content.scroll_value or content.value or 0

			content.scroll_value = math.clamp(current_scroll_value + step * current_scroll_direction, 0, 1)
			content.value = content.scroll_value
		end
	end
end

HudElementTacticalOverlay.set_using_input = function (self, value)
	self._using_input = value
end

HudElementTacticalOverlay.using_input = function (self)
	return self._active and self._using_input
end

HudElementTacticalOverlay.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	local ignore_hud_input = true
	local is_input_blocked = Managers.ui:using_input(ignore_hud_input)

	HudElementTacticalOverlay.super.update(self, dt, t, ui_renderer, render_settings, is_input_blocked and input_service:null_service() or input_service)

	local service_type = "Ingame"

	input_service = is_input_blocked and input_service:null_service() or Managers.input:get_input_service(service_type)

	local active = false

	if not input_service:is_null_service() and input_service:get("tactical_overlay_hold") then
		active = true
	end

	if active and input_service:get("tactical_overlay_swap") then
		self:_switch_right_grid(ui_renderer)
	end

	local right_panel_grid = self._right_panel_grid

	if right_panel_grid then
		right_panel_grid:update(dt, t, input_service)
	end

	local buff_panel_grid = self._buff_panel_grid

	if buff_panel_grid then
		buff_panel_grid:update(dt, t, input_service)
	end

	self:_update_contracts(dt, ui_renderer)
	self:_update_achievements(dt, ui_renderer)
	self:_update_live_event(dt, ui_renderer)
	self:_update_right_panel_widgets(ui_renderer)

	if self._gamepad_active ~= InputDevice.gamepad_active then
		self._gamepad_active = InputDevice.gamepad_active

		self:_update_right_hint()
		self:_update_buff_input_text()
	end

	if active and not self._active then
		Managers.event:trigger("event_set_tactical_overlay_state", true)
		self:_sync_mission_info()

		if self._havoc_data then
			self:_setup_havoc_mutators()
		else
			self:_sync_circumstance_info()
		end

		self:_update_left_panel_elements(ui_renderer)
		self:_start_animation("enter", self._left_panel_widgets)
		Managers.telemetry_reporters:reporter("tactical_overlay"):register_event(self._tracked_achievements)
	elseif self._active and not active then
		Managers.event:trigger("event_set_tactical_overlay_state", false)
		self:_start_animation("exit", self._left_panel_widgets)
	end

	if self._active then
		self:_update_materials_collected()
		self:_update_right_timer_text(dt, t, ui_renderer)

		if self._game_mode_name ~= "hub" and self._game_mode_name ~= "prologue_hub" and not self._buffs_layout_size then
			self:_setup_buffs_presentation(ui_renderer)
		end

		self:_buffs_navigation(dt, t, input_service)
	elseif self._buffs_layout_size then
		self:_remove_buffs_presentation()
	end

	self._active = active

	self:_update_visibility(dt)
end

HudElementTacticalOverlay._update_left_panel_elements = function (self, ui_renderer)
	local margin = 20
	local scenegraph = self._ui_scenegraph
	local circumstance_info_widget = self._widgets_by_name.circumstance_info

	if circumstance_info_widget.visible == true then
		local title_margin = 20
		local circumstance_info_content = circumstance_info_widget.content
		local circumstance_name_style = circumstance_info_widget.style.circumstance_name
		local circumstance_name_font_options = UIFonts.get_font_options_by_style(circumstance_name_style)
		local _, circumstance_name_height = UIRenderer.text_size(ui_renderer, circumstance_info_content.circumstance_name, circumstance_name_style.font_type, circumstance_name_style.font_size, {
			circumstance_name_style.size[1],
			1000,
		}, circumstance_name_font_options)
		local description_margin = 5
		local min_height = circumstance_info_widget.style.icon.size[2]
		local title_height = math.max(min_height, circumstance_name_height)

		circumstance_name_style.size[2] = title_height

		local circumstance_description_style = circumstance_info_widget.style.circumstance_description
		local circumstance_description_font_options = UIFonts.get_font_options_by_style(circumstance_description_style)
		local _, circumstance_description_height = UIRenderer.text_size(ui_renderer, circumstance_info_content.circumstance_description, circumstance_description_style.font_type, circumstance_description_style.font_size, {
			circumstance_description_style.size[1],
			1000,
		}, circumstance_description_font_options)

		circumstance_description_style.offset[2] = title_height + circumstance_name_style.offset[2] + description_margin
		circumstance_description_style.size[2] = circumstance_description_height

		local circumstance_height = circumstance_description_style.offset[2] + circumstance_description_style.size[2] + circumstance_info_widget.style.icon.offset[2]

		self:_set_scenegraph_size("circumstance_info_panel", nil, circumstance_height)
	end

	local havoc_circumstance_info = self._widgets_by_name.havoc_circumstance_info

	if havoc_circumstance_info.visible == true then
		local title_margin = 20
		local circumstance_info_content = havoc_circumstance_info.content
		local circumstance_name_style = havoc_circumstance_info.style.circumstance_name_01
		local circumstance_name_font_options = UIFonts.get_font_options_by_style(circumstance_name_style)
		local _, circumstance_name_height = UIRenderer.text_size(ui_renderer, circumstance_info_content.circumstance_name_01, circumstance_name_style.font_type, circumstance_name_style.font_size, {
			circumstance_name_style.size[1],
			1000,
		}, circumstance_name_font_options)
		local description_margin = 5
		local min_height = havoc_circumstance_info.style.icon_01.size[2]
		local title_height = math.max(min_height, circumstance_name_height)

		circumstance_name_style.size[2] = title_height

		local num_displayed_mutators = havoc_circumstance_info.num_displayed_mutators
		local mutator_height = num_displayed_mutators * 90 + title_height + title_margin * 2 + description_margin

		self:_set_scenegraph_size("circumstance_info_panel", nil, mutator_height)
	end

	local currencies_width = 110
	local total_currencies_width = 0
	local diamantine_offset = currencies_width + 20

	self._widgets_by_name.diamantine_info.offset[1] = diamantine_offset
	total_currencies_width = diamantine_offset + currencies_width

	self:_set_scenegraph_size("crafting_pickup_panel", total_currencies_width, nil)
end

HudElementTacticalOverlay._set_contracts = function (self, optional_data)
	self._contract_data = optional_data
	self._contracts_fetched = optional_data ~= nil
	self._contracts_promise = nil
end

HudElementTacticalOverlay._fetch_task_list = function (self)
	local player_manager = Managers.player
	local player = player_manager:local_player(1)
	local character_id = player:character_id()

	if not math.is_uuid(character_id) then
		self:_set_contracts()

		return
	end

	local is_event_complete = Managers.narrative:is_event_complete("level_unlock_contract_store_visited")
	local show_right_side = self._context.show_right_side
	local should_request = is_event_complete and show_right_side

	if not should_request then
		self:_set_contracts()

		return
	end

	self._contracts_promise = self._backend_interfaces.contracts:get_current_contract(character_id, nil, should_request)

	self._contracts_promise:next(function (data)
		self:_set_contracts(data)
	end):catch(function (error)
		if error.code ~= 404 then
			Log.warning("HudElementTacticalOverlay", "Failed to fetch contracts with error: %s", table.tostring(error, 5))
		end

		self:_set_contracts()
	end)
end

HudElementTacticalOverlay._update_right_grid_size = function (self)
	local current_key = self._right_panel_key
	local should_be_visible = current_key ~= nil
	local grid = self._right_panel_grid
	local height = should_be_visible and grid:length() + ElementSettings.buffer or 0
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.right_grid_background.style.rect.size[2] = height
	widgets_by_name.right_grid_stick.style.rect.size[2] = height
	widgets_by_name.right_input_hint.style.hint.offset[2] = height + 2
end

HudElementTacticalOverlay._update_right_hint = function (self)
	local entries = self._right_panel_entries
	local content = self._widgets_by_name.right_input_hint.content

	if table.size(entries) > 1 then
		content.hint = TextUtils.localize_with_button_hint("tactical_overlay_swap", "loc_hud_tactical_overlay_cycle_tab", nil, "Ingame", nil, nil, true)
	else
		content.hint = ""
	end
end

HudElementTacticalOverlay._update_right_timer_text = function (self, dt, t, ui_renderer)
	local right_timer_function = self._right_timer_function

	if not right_timer_function then
		return
	end

	local timer_value = right_timer_function(t)
	local last_seen_value = self._last_seen_time

	if not last_seen_value or math.floor(timer_value) ~= math.floor(last_seen_value) then
		self._last_seen_time = timer_value

		local timer_text

		if timer_value >= 0 then
			timer_text = TextUtils.format_time_span_localized(timer_value, true)
		else
			timer_text = Localize("loc_live_event_expired")
		end

		local timer_widget = self._widgets_by_name.right_timer

		timer_widget.content.time_left = timer_text
		timer_widget.style.time_name.offset[1] = -(2 * ElementSettings.buffer + _text_width(ui_renderer, timer_text, timer_widget.style.time_name))
	end
end

HudElementTacticalOverlay._update_right_timer = function (self)
	local timer_widget = self._widgets_by_name.right_timer

	self._last_seen_time = nil

	local current_key = self._right_panel_key

	if not current_key then
		self._right_timer_function = nil
		timer_widget.visible = false

		return
	end

	local page_settings = self:_get_page(current_key)
	local timer_data = page_settings.timer

	if timer_data == nil then
		self._right_timer_function = nil
		timer_widget.visible = false

		return
	end

	self._right_timer_function = timer_data.func
	timer_widget.visible = true
	timer_widget.content.time_name = Localize(timer_data.loc_key)
	timer_widget.content.time_left = ""
end

HudElementTacticalOverlay._delete_tab_bar = function (self, ui_renderer)
	local tab_bar_widgets = self._tab_bar_widgets
	local tab_bar_widgets_size = tab_bar_widgets and #tab_bar_widgets or 0

	for i = 1, tab_bar_widgets_size do
		local name = string.format("tab_%d", i)

		self:_unregister_widget_name(name)
		UIWidget.destroy(ui_renderer, tab_bar_widgets[i])
	end

	self._tab_bar_widgets = nil
end

HudElementTacticalOverlay._get_page = function (self, page_key)
	local grid_overrides = self._grid_overrides

	return grid_overrides[page_key] or ElementSettings.right_panel_grids[page_key]
end

HudElementTacticalOverlay._update_right_tab_bar = function (self, ui_renderer)
	self:_update_right_hint()
	self:_update_right_timer()
	self:_delete_tab_bar(ui_renderer)

	local entries = self._right_panel_entries
	local current_key = self._right_panel_key
	local widgets_by_name = self._widgets_by_name

	if table.size(entries) > 0 then
		widgets_by_name.right_header_stick.content.visible = true
		widgets_by_name.right_header_background.content.visible = true

		local definitions = {}
		local tab_bar_widgets = {}
		local ordered_keys = ElementSettings.right_panel_order
		local total_width = ElementSettings.buffer - ElementSettings.internal_buffer
		local selected_blueprint, selected_definition, selected_config

		for _, page_key in ipairs(ordered_keys) do
			if entries[page_key] then
				local page_settings = self:_get_page(page_key)
				local blueprint_type = page_settings.icon.blueprint_type
				local blueprint = Blueprints[blueprint_type]
				local definition = definitions[blueprint_type] or UIWidget.create_definition(blueprint.pass_template, "right_panel_header", nil, blueprint.size)

				definitions[blueprint_type] = definition

				local selected = current_key == page_key
				local config = {
					is_left = false,
					value = page_settings.icon.value,
					selected = selected,
				}
				local index = #tab_bar_widgets + 1
				local name = string.format("tab_%d", index)
				local widget = self:_create_widget(name, definition)
				local init_function = blueprint.init

				if init_function then
					init_function(self, widget, config, ui_renderer)
				end

				tab_bar_widgets[index] = widget
				total_width = total_width + widget.content.size[1] + ElementSettings.internal_buffer

				if selected then
					selected_blueprint, selected_definition, selected_config = blueprint, definition, table.clone(config)
				end
			end
		end

		local current_width = 0

		for i = 1, #tab_bar_widgets do
			local widget = tab_bar_widgets[i]

			widget.offset[1] = ElementSettings.right_grid_width - total_width + current_width
			current_width = current_width + widget.content.size[1] + ElementSettings.internal_buffer
		end

		if selected_definition and selected_blueprint and selected_config then
			local index = #tab_bar_widgets + 1
			local name = string.format("tab_%d", index)
			local widget = self:_create_widget(name, selected_definition)
			local init_function = selected_blueprint.init

			if init_function then
				selected_config.is_left = true

				init_function(self, widget, selected_config, ui_renderer)
			end

			tab_bar_widgets[index] = widget
			widget.offset[1] = -widget.content.size[1]
		end

		self._tab_bar_widgets = tab_bar_widgets
	else
		widgets_by_name.right_header_stick.content.visible = false
		widgets_by_name.right_header_background.content.visible = false
	end

	local title_widget = widgets_by_name.right_header_title
	local selected_page = self:_get_page(current_key)
	local selected_title = selected_page and Localize(selected_page.loc_key) or ""

	title_widget.content.text = Utf8.upper(selected_title)
end

HudElementTacticalOverlay._override_right_panel_category = function (self, key, data, ui_renderer)
	local original = ElementSettings.right_panel_grids[key]

	self._grid_overrides[key] = data and table.add_missing_recursive(data, original)

	if ui_renderer then
		self:_update_right_tab_bar(ui_renderer)
	end
end

HudElementTacticalOverlay._swap_right_grid = function (self, page_key, ui_renderer)
	self._right_panel_key = page_key

	if self._preferred_page == page_key then
		self._preferred_page = nil
	end

	local widgets = self._right_panel_entries[page_key] or {}

	self._right_panel_grid = UIWidgetGrid:new(widgets, nil, self._ui_scenegraph, "right_panel_content", "down", ElementSettings.right_grid_spacing)

	self:_update_right_grid_size()
	self:_update_right_tab_bar(ui_renderer)
end

HudElementTacticalOverlay._delete_right_panel_widgets = function (self, page_key, ui_renderer, is_update)
	local widgets = self._right_panel_entries[page_key]
	local widgets_size = widgets and #widgets or 0

	for i = 1, widgets_size do
		local name = string.format("%s_%d", page_key, i)

		self:_unregister_widget_name(name)
		UIWidget.destroy(ui_renderer, widgets[i])
	end

	self._right_panel_entries[page_key] = nil

	local current_key = self._right_panel_key

	if not is_update and current_key == page_key then
		self:_switch_right_grid(ui_renderer)
	else
		self:_update_right_tab_bar(ui_renderer)
	end
end

HudElementTacticalOverlay._create_right_panel_widgets = function (self, page_key, configs, ui_renderer)
	self:_delete_right_panel_widgets(page_key, ui_renderer, true)

	local definitions = {}
	local widgets = {}

	for i = 1, #configs do
		local config = configs[i]
		local blueprint_type = config.blueprint
		local blueprint = Blueprints[blueprint_type]
		local definition = definitions[blueprint_type] or UIWidget.create_definition(blueprint.pass_template, "right_panel_content", nil, blueprint.size)

		definitions[blueprint_type] = definition

		local name = string.format("%s_%d", page_key, i)
		local widget = self:_create_widget(name, definition)
		local init_function = blueprint.init

		if init_function then
			init_function(self, widget, config, ui_renderer)
		end

		widget.blueprint_type = blueprint_type
		widgets[i] = widget
	end

	self._right_panel_entries[page_key] = widgets

	local current_key = self._right_panel_key
	local is_empty = current_key == nil
	local is_current = page_key == current_key
	local is_preferred = page_key == self._preferred_page
	local should_swap = is_empty or is_current or is_preferred

	if should_swap then
		self:_swap_right_grid(page_key, ui_renderer)
	else
		self:_update_right_tab_bar(ui_renderer)
	end

	return widgets
end

HudElementTacticalOverlay._setup_contracts = function (self, contracts_data, ui_renderer)
	local page_key = "contracts"
	local tasks = contracts_data.tasks
	local configs = {}

	for i = 1, #tasks do
		configs[i] = {
			blueprint = "contract",
			task = tasks[i],
			reward = table.nested_get(tasks[i], "reward", "amount"),
		}
	end

	if #tasks == 0 then
		self:_delete_right_panel_widgets(page_key, ui_renderer)

		return
	end

	self:_create_right_panel_widgets(page_key, configs, ui_renderer)
end

HudElementTacticalOverlay._on_right_panel_widgets = function (self, key, func_name, ...)
	local updated_key = key or self._right_panel_key
	local contract_widgets = self._right_panel_entries[updated_key]
	local widget_count = contract_widgets and #contract_widgets or 0

	for i = 1, widget_count do
		local widget = contract_widgets[i]
		local blueprint_type = widget.blueprint_type
		local blueprint = Blueprints[blueprint_type]
		local func = blueprint[func_name]

		if func then
			func(self, widget, ...)
		end
	end
end

HudElementTacticalOverlay._update_right_panel_widgets = function (self, ui_renderer, desired_page)
	return self:_on_right_panel_widgets(desired_page, "update", ui_renderer)
end

HudElementTacticalOverlay._setup_live_event = function (self, ui_renderer)
	local live_event_id = Managers.live_event:active_event_id()

	self._live_event_id = live_event_id

	local page_key = "event"
	local template = Managers.live_event:active_template()
	local event_name = template.name
	local event_description = template.description
	local configs = {
		{
			blueprint = "title",
			text = Localize(event_name),
		},
		{
			blueprint = "header",
			text = Localize("loc_event_briefing"),
		},
		{
			blueprint = "body",
			text = Localize(event_description),
		},
	}
	local tiers = Managers.live_event:active_tiers()
	local tier_count = tiers and #tiers or 0
	local max_tiers = ElementSettings.max_live_event_tiers
	local shown_tiers = math.min(max_tiers, tier_count)

	if shown_tiers > 0 then
		configs[#configs + 1] = {
			blueprint = "header",
			text = Localize("loc_event_objectives"),
		}
	end

	local progress = Managers.live_event:active_progress()
	local start_from = tier_count - shown_tiers + 1

	while start_from > 1 and progress < tiers[start_from - 1].target do
		start_from = start_from - 1
	end

	local end_at = start_from + shown_tiers - 1

	for i = start_from, end_at do
		local tier = tiers[i]

		configs[#configs + 1] = {
			blueprint = "event_tier",
			target = tier.target,
			rewards = tier.rewards,
		}
	end

	local remaining_tiers = tier_count - end_at

	if remaining_tiers > 0 then
		configs[#configs + 1] = {
			blueprint = "divider",
			text = Localize("loc_tactical_overlay_extra_entries", true, {
				amount = remaining_tiers,
			}),
		}
	end

	self:_create_right_panel_widgets(page_key, configs, ui_renderer)
end

HudElementTacticalOverlay._update_live_event = function (self, dt, ui_renderer)
	local current_live_event_id = self._live_event_id
	local backend_live_event_id = Managers.live_event:active_event_id()
	local show_right_side = self._context.show_right_side
	local wrong_event_id = current_live_event_id ~= backend_live_event_id and backend_live_event_id ~= nil
	local should_create = show_right_side and wrong_event_id

	if should_create then
		self:_setup_live_event(ui_renderer)
	end
end

HudElementTacticalOverlay.reroll_contracts = function (self)
	local contracts_promise = self._contracts_promise

	if contracts_promise and contracts_promise:is_pending() then
		contracts_promise:cancel()
	end

	self:_fetch_task_list()
end

HudElementTacticalOverlay._update_contracts = function (self, dt, ui_renderer)
	local show_right_side = self._context.show_right_side
	local has_data = self._contracts_fetched
	local should_create = show_right_side and has_data

	if should_create then
		self:_setup_contracts(self._contract_data, ui_renderer)

		self._contracts_fetched = false
	end
end

HudElementTacticalOverlay._setup_achievements = function (self, ui_renderer)
	local page_key = "achievements"
	local save_data = Managers.save:account_data()
	local favorite_achievements = save_data.favorite_achievements
	local configs = {}
	local current_achievements = {}

	for i = 1, #favorite_achievements do
		local id = favorite_achievements[i]

		if Managers.achievements:achievement_definition(id) then
			configs[#configs + 1] = {
				blueprint = "achievement",
				id = id,
			}
			current_achievements[i] = id
		end
	end

	self._current_achievements = current_achievements
	self._tracked_achievements = #favorite_achievements

	if #favorite_achievements == 0 then
		self:_delete_right_panel_widgets(page_key, ui_renderer)

		return
	end

	self:_create_right_panel_widgets(page_key, configs, ui_renderer)
end

HudElementTacticalOverlay._update_achievements = function (self, dt, ui_renderer)
	local save_data = Managers.save:account_data()
	local favorite_achievements = save_data.favorite_achievements
	local current_achievements = self._current_achievements
	local has_achievements = current_achievements ~= nil
	local updated_achievements = has_achievements and not table.array_equals(current_achievements, favorite_achievements)
	local show_right_side = self._context.show_right_side
	local should_update = show_right_side and (not has_achievements or updated_achievements)

	if should_update then
		self:_setup_achievements(ui_renderer)
	end
end

HudElementTacticalOverlay._switch_right_grid = function (self, ui_renderer)
	local current_key = self._right_panel_key
	local ordered_names = ElementSettings.right_panel_order
	local current_index = current_key and table.index_of(ordered_names, current_key) or 0

	for delta = 1, #ordered_names do
		local index = current_index + delta

		while index > #ordered_names do
			index = index - #ordered_names
		end

		local key = ordered_names[index]
		local has_entry = self._right_panel_entries[key] ~= nil

		if has_entry and key ~= current_key then
			self:_swap_right_grid(key, ui_renderer)
		end

		if has_entry then
			return
		end
	end

	self._right_panel_key = nil

	self:_update_right_grid_size()
	self:_update_right_tab_bar(ui_renderer)
end

HudElementTacticalOverlay._set_difficulty_icons = function (self)
	local danger_settings = self._difficulty_manager:get_danger_settings()
	local danger_index = danger_settings and danger_settings.index or 0
	local danger_info_widget = self._widgets_by_name.danger_info
	local havoc_rank_info = self._widgets_by_name.havoc_rank_info

	havoc_rank_info.visible = false

	local visible = danger_index ~= 0 and self._context.show_left_side_details

	danger_info_widget.visible = visible
	danger_info_widget.content.difficulty_icon = danger_settings and danger_settings.icon or "content/ui/materials/icons/difficulty/flat/difficulty_skull_uprising"
	danger_info_widget.content.difficulty_name = danger_settings and Utf8.upper(Localize(danger_settings.display_name)) or "N/A"

	local danger_info_style = danger_info_widget.style
	local difficulty_icon_style = danger_info_style.difficulty_icon

	difficulty_icon_style.amount = danger_index
end

HudElementTacticalOverlay._havoc_rank = function (self)
	local havoc_rank_info = self._widgets_by_name.havoc_rank_info
	local danger_info = self._widgets_by_name.danger_info

	danger_info.visible = false

	local data = self._havoc_data
	local visible = self._context.show_left_side_details

	havoc_rank_info.visible = visible

	local havoc_content = havoc_rank_info.content

	havoc_content.havoc_rank = Utf8.upper(data.havoc_rank)
	havoc_content.havoc_text = Utf8.upper("Havoc Order rank:  ")
end

HudElementTacticalOverlay._setup_havoc_mutators = function (self)
	local mutators = self._havoc_data.circumstances
	local havoc_circumstance_info = self._widgets_by_name.havoc_circumstance_info
	local circumstance_info_widget = self._widgets_by_name.circumstance_info

	circumstance_info_widget.visible = false

	local num_displayed_mutators = 0

	for i = 1, #mutators do
		local mutator_data = mutators[i]

		num_displayed_mutators = num_displayed_mutators + 1

		local circumstance_info_content = havoc_circumstance_info.content
		local circumstance_template = CircumstanceTemplates[mutator_data]
		local circumstance_ui_settings = circumstance_template.ui
		local circumstance_icon = circumstance_ui_settings.icon
		local circumstance_display_name = circumstance_ui_settings.display_name
		local circumstance_description = circumstance_ui_settings.description

		circumstance_info_content.icon = circumstance_icon

		local circumstance_icon_identifer = "icon_0" .. i

		circumstance_info_content[circumstance_icon_identifer] = circumstance_icon

		local title = Localize(circumstance_display_name)
		local circumstance_name_identifer = "circumstance_name_0" .. i

		circumstance_info_content[circumstance_name_identifer] = title

		local description = Localize(circumstance_description)
		local circumstance_description_identifier = "circumstance_description_0" .. i

		circumstance_info_content[circumstance_description_identifier] = description
		havoc_circumstance_info.visible = true
	end

	havoc_circumstance_info.num_displayed_mutators = num_displayed_mutators

	if num_displayed_mutators ~= 4 then
		for i = num_displayed_mutators + 1, 4 do
			local circumstance_icon_identifer = "icon_0" .. i
			local icon_style = havoc_circumstance_info.style[circumstance_icon_identifer]

			icon_style.visible = false

			local circumstance_name_identifer = "circumstance_name_0" .. i
			local name_style = havoc_circumstance_info.style[circumstance_name_identifer]

			name_style.visible = false

			local circumstance_description_identifier = "circumstance_description_0" .. i
			local description_style = havoc_circumstance_info.style[circumstance_description_identifier]

			description_style.visible = false
		end
	end
end

HudElementTacticalOverlay._setup_left_panel_widgets = function (self)
	local definitions = {
		widget_definitions = self._definitions.left_panel_widgets_definitions,
	}

	self._left_panel_widgets = {}

	self:_create_widgets(definitions, self._left_panel_widgets, self._widgets_by_name)
end

HudElementTacticalOverlay._sync_mission_info = function (self)
	if self._havoc_data then
		self:_havoc_rank()
	else
		self:_set_difficulty_icons()
	end

	local mission_info_widget = self._widgets_by_name.mission_info
	local mission_info_content = mission_info_widget.content
	local mission_info_style = mission_info_widget.style
	local mission = self._mission_manager:mission()
	local mission_name = mission.mission_name
	local type = mission.mission_type
	local mission_type = MissionTypes[type]
	local mission_type_icon = mission_type and mission_type.icon or default_mission_type_icon

	mission_info_content.icon = mission_type_icon
	mission_info_content.mission_name = Utf8.upper(Localize(mission_name))

	local show_mission_type = mission_type and self._context.show_left_side_details

	if show_mission_type then
		local mission_type_name = mission_type.name

		mission_info_content.mission_type = Localize(mission_type_name)
		mission_info_style.mission_name.offset[2] = 15
	else
		mission_info_content.mission_type = ""
		mission_info_style.mission_name.offset[2] = 30
	end
end

HudElementTacticalOverlay._sync_circumstance_info = function (self)
	local circumstance_name = self._circumstance_manager:circumstance_name()
	local circumstance_info_widget = self._widgets_by_name.circumstance_info
	local havoc_circumstance_info = self._widgets_by_name.havoc_circumstance_info

	havoc_circumstance_info.visible = false

	if circumstance_name ~= "default" then
		local circumstance_info_content = circumstance_info_widget.content
		local circumstance_template = CircumstanceTemplates[circumstance_name]

		if not circumstance_template then
			circumstance_info_widget.visible = false

			return
		end

		local circumstance_ui_settings = circumstance_template.ui

		if circumstance_ui_settings then
			local circumstance_icon = circumstance_ui_settings.icon
			local circumstance_display_name = circumstance_ui_settings.display_name
			local circumstance_description = circumstance_ui_settings.description

			circumstance_info_content.icon = circumstance_icon
			circumstance_info_content.circumstance_name = Localize(circumstance_display_name)
			circumstance_info_content.circumstance_description = Localize(circumstance_description)
			circumstance_info_widget.visible = true
		else
			circumstance_info_widget.visible = false
		end
	else
		circumstance_info_widget.visible = false
	end
end

HudElementTacticalOverlay._update_visibility = function (self, dt)
	local draw = self._active
	local alpha_speed = 4
	local alpha_multiplier = self._alpha_multiplier or 0

	if draw then
		alpha_multiplier = math.min(alpha_multiplier + dt * alpha_speed, 1)
	else
		alpha_multiplier = math.max(alpha_multiplier - dt * alpha_speed, 0)
	end

	self._alpha_multiplier = alpha_multiplier
end

HudElementTacticalOverlay._setup_right_panel_widgets = function (self)
	local definitions = {
		widget_definitions = self._definitions.right_panel_widgets_definitions,
	}

	self._right_panel_widgets = {}

	self:_create_widgets(definitions, self._right_panel_widgets, self._widgets_by_name)
	self:_update_right_tab_bar()
end

HudElementTacticalOverlay.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if self._alpha_multiplier ~= 0 then
		HudElementTacticalOverlay.super.draw(self, dt, t, ui_renderer, render_settings, input_service)

		local ui_scenegraph = self._ui_scenegraph

		if self._resource_renderer then
			local base_render_pass = self._resource_renderer.base_render_pass
			local render_target = self._resource_renderer.render_target

			UIRenderer.clear_render_pass_queue(self._buffs_renderer)
			UIRenderer.add_render_pass(self._buffs_renderer, 0, base_render_pass, true, render_target)
			UIRenderer.add_render_pass(self._buffs_renderer, 1, "to_screen", false)
			UIRenderer.begin_pass(self._resource_renderer, ui_scenegraph, input_service, dt, render_settings)

			local widgets = self._buff_panel_widgets

			if widgets then
				for i = 1, #widgets do
					local widget = widgets[i]

					if self._buff_panel_grid:is_widget_visible(widget) then
						UIWidget.draw(widget, self._resource_renderer)
					end
				end
			end

			UIRenderer.end_pass(self._resource_renderer)
			self:_draw_render_target(self._buffs_renderer, render_settings)
		end
	end
end

HudElementTacticalOverlay._draw_render_target = function (self, ui_renderer, render_settings)
	local gui = ui_renderer.gui
	local material = self._resource_renderer.render_target_material
	local base_render_pass = self._resource_renderer.base_render_pass
	local scale = render_settings.scale or 1
	local size = self:scenegraph_size("buff_panel_mask")
	local position = self:scenegraph_world_position("buff_panel_mask")
	local start_layer = render_settings.start_layer
	local gui_position = Vector3(position[1] * scale, position[2] * scale, (position[3] or 0) + start_layer)
	local gui_size = Vector2(size[1] * scale, size[2] * scale)

	Gui.bitmap(gui, material, "render_pass", "to_screen", gui_position, gui_size)
end

HudElementTacticalOverlay._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if self._alpha_multiplier ~= 0 then
		local alpha_multiplier = render_settings.alpha_multiplier

		render_settings.alpha_multiplier = self._alpha_multiplier

		HudElementTacticalOverlay.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

		render_settings.alpha_multiplier = alpha_multiplier

		local left_panel_widgets = self._left_panel_widgets
		local num_left_panel_widget = #left_panel_widgets

		for i = 1, num_left_panel_widget do
			local widget = left_panel_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end

		local right_panel_widgets = self._right_panel_widgets
		local num_right_panel_widget = #right_panel_widgets

		for i = 1, num_right_panel_widget do
			local widget = right_panel_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end

		local current_grid_page = self._right_panel_key
		local current_grid = self._right_panel_entries[current_grid_page]
		local current_grid_size = current_grid and #current_grid or 0

		for i = 1, current_grid_size do
			local widget = current_grid[i]

			UIWidget.draw(widget, ui_renderer)
		end

		local tab_bar_widgets = self._tab_bar_widgets
		local tab_bar_widgets_size = tab_bar_widgets and #tab_bar_widgets or 0

		for i = 1, tab_bar_widgets_size do
			local widget = tab_bar_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end
end

HudElementTacticalOverlay._total_materials_collected = function (self, material_type)
	local pickup_system = Managers.state.extension:system("pickup_system")
	local collected_materials = pickup_system:get_collected_materials()
	local small_value = Managers.backend:session_setting("craftingMaterials", material_type, "small", "value")
	local large_value = Managers.backend:session_setting("craftingMaterials", material_type, "large", "value")
	local small_count = collected_materials[material_type] and collected_materials[material_type].small or 0
	local large_count = collected_materials[material_type] and collected_materials[material_type].large or 0

	return TextUtils.format_currency(small_count * small_value + large_count * large_value)
end

HudElementTacticalOverlay._update_materials_collected = function (self)
	local show_details = self._context.show_left_side_details
	local plasteel_info_widget = self._widgets_by_name.plasteel_info
	local plasteel_info_content = plasteel_info_widget.content

	plasteel_info_widget.visible = show_details
	plasteel_info_content.amount_id = self:_total_materials_collected("plasteel")

	local diamantine_info_widget = self._widgets_by_name.diamantine_info
	local diamantine_info_content = diamantine_info_widget.content

	diamantine_info_widget.visible = show_details
	diamantine_info_content.amount_id = self:_total_materials_collected("diamantine")
end

HudElementTacticalOverlay.on_resolution_modified = function (self)
	local w = RESOLUTION_LOOKUP.width * RESOLUTION_LOOKUP.inverse_scale
	local h = RESOLUTION_LOOKUP.height * RESOLUTION_LOOKUP.inverse_scale

	self:_set_scenegraph_size("background", w, h)
	HudElementTacticalOverlay.super.on_resolution_modified(self)
end

HudElementTacticalOverlay.set_visible = function (self, visible, ui_renderer, use_retained_mode)
	if not visible and self._active then
		self._active = false

		Managers.event:trigger("event_set_tactical_overlay_state", false)

		if self._buffs_layout_size then
			self:_remove_buffs_presentation()
		end
	end
end

return HudElementTacticalOverlay
