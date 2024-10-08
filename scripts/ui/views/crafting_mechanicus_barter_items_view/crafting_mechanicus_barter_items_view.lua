-- chunkname: @scripts/ui/views/crafting_mechanicus_barter_items_view/crafting_mechanicus_barter_items_view.lua

local CraftingMechanicusBarterItemsViewDefinitions = require("scripts/ui/views/crafting_mechanicus_barter_items_view/crafting_mechanicus_barter_items_view_definitions")
local CraftingMechanicusBarterItemsViewSettings = require("scripts/ui/views/crafting_mechanicus_barter_items_view/crafting_mechanicus_barter_items_view_settings")
local CraftingSettings = require("scripts/settings/item/crafting_mechanicus_settings")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ContentBlueprints = require("scripts/ui/views/masteries_overview_view/masteries_overview_view_blueprints")
local Items = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Mastery = require("scripts/utilities/mastery")
local Promise = require("scripts/foundation/utilities/promise")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewElementCraftingRecipe = require("scripts/ui/view_elements/view_element_crafting_recipe/view_element_crafting_recipe")
local ViewElementDiscardItems = require("scripts/ui/view_elements/view_element_discard_items/view_element_discard_items")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local ViewElementWeaponStats = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WeaponUnlockSettings = require("scripts/settings/weapon_unlock_settings_new")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local RaritySettings = require("scripts/settings/item/rarity_settings")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local CraftingMechanicusBarterItemsView = class("CraftingMechanicusBarterItemsView", "BaseView")

CraftingMechanicusBarterItemsView.init = function (self, settings, context)
	self._parent = context.parent
	self._selected_items = {}

	CraftingMechanicusBarterItemsView.super.init(self, CraftingMechanicusBarterItemsViewDefinitions, settings, context)

	self._pass_input = true
	self._pass_draw = true
end

CraftingMechanicusBarterItemsView.on_enter = function (self)
	CraftingMechanicusBarterItemsView.super.on_enter(self)
	self._parent:set_active_view_instance(self)

	local character_id = self:_player():character_id()
	local item_type_filter_list = {
		"WEAPON_MELEE",
		"WEAPON_RANGED",
	}

	self._inventory_promise = Managers.data_service.gear:fetch_inventory(character_id, nil, item_type_filter_list)

	self._inventory_promise:next(callback(self, "_cb_fetch_inventory_items"))
	self:_setup_button_callbacks()
	self:_setup_background_world()
	self:_setup_description()
end

CraftingMechanicusBarterItemsView._setup_background_world = function (self)
	local default_camera_event_id = "event_register_default_camera"

	self[default_camera_event_id] = function (instance, camera_unit)
		if instance._context then
			instance._context.camera_unit = camera_unit
		end

		instance._default_camera_unit = camera_unit

		local viewport_name = CraftingMechanicusBarterItemsViewSettings.viewport_name
		local viewport_type = CraftingMechanicusBarterItemsViewSettings.viewport_type
		local viewport_layer = CraftingMechanicusBarterItemsViewSettings.viewport_layer
		local shading_environment = CraftingMechanicusBarterItemsViewSettings.shading_environment

		instance._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
		instance:_unregister_event(default_camera_event_id)
	end

	self:_register_event(default_camera_event_id)

	local world_name = CraftingMechanicusBarterItemsViewSettings.world_name
	local world_layer = CraftingMechanicusBarterItemsViewSettings.world_layer
	local world_timer_name = CraftingMechanicusBarterItemsViewSettings.timer_name

	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	local level_name = CraftingMechanicusBarterItemsViewSettings.level_name

	self._world_spawner:spawn_level(level_name)
end

CraftingMechanicusBarterItemsView.world_spawner = function (self)
	return self._world_spawner
end

CraftingMechanicusBarterItemsView._setup_button_callbacks = function (self)
	self._widgets_by_name.confirm_button.content.hotspot.pressed_callback = callback(self, "_confirm_pressed")
end

CraftingMechanicusBarterItemsView._setup_description = function (self)
	local sacrifice_operation_costs = Managers.data_service.crafting:get_sacrifice_mastery_costs()
	local min_rarity = sacrifice_operation_costs.minimumRarity and sacrifice_operation_costs.minimumRarity + 1 or 1
	local settings = RaritySettings[min_rarity]
	local rarity_color = settings.color
	local rarity_text = Localize("loc_color_value_fomat_key", true, {
		value = Localize(settings.display_name),
		r = rarity_color[2],
		g = rarity_color[3],
		b = rarity_color[4],
	})

	self._widgets_by_name.sacrifice_intro.content.description = Localize("loc_mastery_crafting_sacrifice_weapon_select_description", true, {
		rarity = rarity_text,
	})
end

CraftingMechanicusBarterItemsView.cb_on_favorite_pressed = function (self)
	local widget

	if self._using_cursor_navigation then
		widget = self._item_grid and self._item_grid:hovered_widget()
	else
		widget = self._item_grid and self._item_grid:selected_grid_widget()
	end

	local gear_id = widget and widget.content.element and widget.content.element.item and widget.content.element.item.gear_id
	local is_favorite = Items.is_item_id_favorited(gear_id)

	if not is_favorite and widget.content.multi_selected then
		local element = widget.content.element

		self:cb_on_grid_entry_left_pressed(widget, element)
	end

	Items.set_item_id_as_favorite(gear_id, not is_favorite)

	if self._discard_items_element then
		self._discard_items_element:refresh()
	end
end

CraftingMechanicusBarterItemsView._setup_masteries = function (self, available_masteries)
	local layout = {}
	local player = self:_player()
	local profile = player:profile()
	local profile_archetype = profile.archetype
	local archetype_name = profile_archetype.name
	local archetype_weapon_unlocks = WeaponUnlockSettings[archetype_name]

	return Managers.data_service.mastery:get_all_masteries():next(function (masteries_data)
		local masteries = {}
		local weapon_patterns = UISettings.weapon_patterns

		for id, mastery_data in pairs(masteries_data) do
			repeat
				local display_name = weapon_patterns[id] and Localize(weapon_patterns[id].display_name)
				local master_item_name = weapon_patterns[id] and Mastery.get_default_mark_for_mastery(mastery_data)
				local master_item = master_item_name and MasterItems.get_item(master_item_name)

				if master_item then
					local allowed_archetypes = master_item.archetypes

					if not table.contains(allowed_archetypes, archetype_name) then
						break
					end

					local weapon_level_requirement

					for weapon_level, weapon_list in ipairs(archetype_weapon_unlocks) do
						if table.contains(weapon_list, master_item_name) then
							weapon_level_requirement = weapon_level

							break
						end
					end

					if weapon_level_requirement == nil then
						weapon_level_requirement = 1
					end

					local hud_icon = master_item.hud_icon

					hud_icon = hud_icon or "content/ui/materials/icons/weapons/hud/combat_blade_01"

					local mastery_level = mastery_data.mastery_level or 0
					local mastery_xp = mastery_data.current_xp or 0
					local mastery_start_exp = mastery_data.start_xp or 0
					local mastery_end_exp = mastery_data.end_xp or 0
					local mastery_max_level = Mastery.get_mastery_max_level(mastery_data)
					local expertise_level = Mastery.get_current_expertise_cap(mastery_data)

					layout[#layout + 1] = {
						widget_type = "weapon_pattern",
						icon = hud_icon,
						display_name = display_name,
						slot = master_item.slots[1],
						mastery_id = id,
						mastery_level = mastery_level,
						mastery_max_level = mastery_max_level,
						weapon_level_requirement = weapon_level_requirement,
						expertise_level = expertise_level,
					}

					table.sort(layout, function (a, b)
						local a_level = a.weapon_level_requirement
						local b_level = b.weapon_level_requirement
						local a_name = a.display_name
						local b_name = b.display_name

						if a_level < b_level then
							return false
						elseif b_level < a_level then
							return true
						else
							return a_name < b_name
						end
					end)

					masteries[id] = {
						display_name = display_name,
						mastery_level = mastery_level,
						mastery_max_level = mastery_max_level,
						current_xp = mastery_xp,
						icon = hud_icon,
						milestones = mastery_data.milestones,
						start_xp = mastery_start_exp,
						end_xp = mastery_end_exp,
						mastery_id = id,
						claimed_level = mastery_data.claimed_level,
					}
				end
			until true
		end

		self._masteries = masteries

		return layout
	end)
end

CraftingMechanicusBarterItemsView.on_resolution_modified = function (self, scale)
	if self._item_grid then
		local item_grid_position = self:_scenegraph_world_position("item_grid_pivot")

		self._item_grid:set_pivot_offset(item_grid_position[1], item_grid_position[2])
	end

	if self._patterns_tab_menu_element then
		local patterns_tab_menu_position = self:_scenegraph_world_position("patterns_grid_tab_panel")

		self._patterns_tab_menu_element:set_pivot_offset(patterns_tab_menu_position[1], patterns_tab_menu_position[2])
	end

	if self._weapon_stats then
		local weapon_stats_position = self:_scenegraph_world_position("weapon_stats_pivot")

		self._weapon_stats:set_pivot_offset(weapon_stats_position[1], weapon_stats_position[2])
	end

	if self._discard_items_element then
		local discard_items_position = self:_scenegraph_world_position("weapon_discard_pivot")

		self._discard_items_element:set_pivot_offset(discard_items_position[1], discard_items_position[2])
	end

	if self._patterns_grid then
		local patterns_grid_position = self:_scenegraph_world_position("patterns_grid_pivot")

		self._patterns_grid:set_pivot_offset(patterns_grid_position[1], patterns_grid_position[2])
	end

	CraftingMechanicusBarterItemsView.super.on_resolution_modified(self, scale)
end

CraftingMechanicusBarterItemsView.on_back_pressed = function (self)
	local current_state = self._ui_state

	if self._ui_state == "select_weapon" then
		self:_change_state("select_pattern")
	elseif self._ui_state == "sacrifice_weapon" then
		self:_change_state("select_weapon")
	end

	return current_state ~= "select_pattern"
end

CraftingMechanicusBarterItemsView.update = function (self, dt, t, input_service)
	if self._item_grid then
		self:_item_hover_update()
	end

	if self._ui_state_next_frame then
		self._ui_state = self._ui_state_next_frame
		self._ui_state_next_frame = nil

		if self._ui_state == "select_pattern" then
			self:_reset_master_xp_increase()
		else
			self:_update_mastery_xp_increase()
		end
	end

	return CraftingMechanicusBarterItemsView.super.update(self, dt, t, input_service)
end

CraftingMechanicusBarterItemsView._handle_input = function (self, input_service)
	if not self._using_cursor_navigation then
		if self._ui_state == "select_pattern" then
			local selected_index = self._patterns_grid:selected_grid_index()

			if self._selected_pattern_index ~= selected_index then
				self._selected_pattern_index = selected_index

				local widgets = self._patterns_grid:widgets()
				local widget = widgets[selected_index]
				local element = widget.content.element
				local mastery_id = element.mastery_id

				self._selected_pattern = mastery_id

				self:cb_pattern_on_grid_entry_left_pressed(widget, element)
			elseif input_service:get("confirm_pressed") and self._widgets_by_name.confirm_button.content.visible and not self._widgets_by_name.confirm_button.content.hotspot.disabled then
				self._widgets_by_name.confirm_button.content.hotspot.pressed_callback()
			end
		elseif self._ui_state == "select_weapon" then
			if input_service:get("navigate_left_continuous") and not self._discard_items_element:input_disabled() then
				self._discard_items_element:disable_input(true)
				self._item_grid:disable_input(false)
				self._item_grid:select_grid_index(self._selected_item_index or 1)

				local selected_index = self._item_grid:selected_grid_index()

				self._item_grid:scroll_to_grid_index(selected_index)

				self._selected_item_index = nil
			elseif input_service:get("navigate_right_continuous") and self._discard_items_element:input_disabled() then
				self._discard_items_element:disable_input(false)
				self._discard_items_element:select_first_index()
				self._item_grid:disable_input(true)

				self._selected_item_index = self._item_grid:selected_grid_index()

				self._item_grid:select_grid_index()
				self._weapon_stats:stop_presenting()
			elseif input_service:get("secondary_action_pressed") and self._widgets_by_name.confirm_button.content.visible and not self._widgets_by_name.confirm_button.content.hotspot.disabled then
				self._widgets_by_name.confirm_button.content.hotspot.pressed_callback()
			end
		elseif self._ui_state == "sacrifice_weapon" and input_service:get("secondary_action_pressed") and self._widgets_by_name.confirm_button.content.visible and not self._widgets_by_name.confirm_button.content.hotspot.disabled then
			self._widgets_by_name.confirm_button.content.hotspot.pressed_callback()
		end
	end
end

CraftingMechanicusBarterItemsView.cb_on_recipe_button_pressed = function (self, _, config)
	self._parent:previously_active_view_name()
	self._parent:go_to_crafting_view(config.recipe.view_name, self._previewed_item)
end

CraftingMechanicusBarterItemsView.on_exit = function (self)
	if self._inventory_promise then
		self._inventory_promise:cancel()

		self._inventory_promise = nil
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	CraftingMechanicusBarterItemsView.super.on_exit(self)
end

CraftingMechanicusBarterItemsView._cb_fetch_inventory_items = function (self, items)
	if self._destroyed then
		return
	end

	local layout = {}
	local filtered_items = {}

	for item_id, item in pairs(items) do
		local slots = item.slots

		if not item.no_crafting and slots then
			local slot_name = slots[1]
			local equipped_item = self:equipped_item_in_slot(slot_name)
			local expertise_text, has_expertise = Items.expertise_level(item, true)
			local expertise_level = expertise_text and expertise_text ~= "" and tonumber(expertise_text) or 0
			local sacrifice_operation_costs = Managers.data_service.crafting:get_sacrifice_mastery_costs()
			local min_rarity = sacrifice_operation_costs.minimumRarity and sacrifice_operation_costs.minimumRarity + 1 or 0
			local min_expertise_level = sacrifice_operation_costs.minimumExpertiseLevel or 0
			local is_invalid_item_for_operation = equipped_item.gear_id == item.gear_id or not item.rarity or min_rarity > item.rarity or not has_expertise or expertise_level < min_expertise_level

			if item.parent_pattern and not is_invalid_item_for_operation then
				filtered_items[item.gear_id] = item
				layout[item.gear_id] = {
					widget_type = "item",
					item = item,
					slot = {
						name = slot_name,
					},
				}
			end
		end
	end

	self._offer_items_layout = layout

	local edge_padding = 44
	local grid_width = 645
	local grid_height = 850
	local grid_size = {
		grid_width - edge_padding,
		grid_height,
	}
	local grid_spacing = {
		10,
		10,
	}
	local mask_size = {
		grid_width + 40,
		grid_height,
	}
	local grid_settings = {
		scroll_start_margin = 0,
		scrollbar_horizontal_offset = -8,
		scrollbar_vertical_margin = 0,
		scrollbar_vertical_offset = 0,
		scrollbar_width = 7,
		show_loading_overlay = true,
		title_height = 0,
		top_padding = 0,
		use_is_focused_for_navigation = false,
		use_item_categories = false,
		use_select_on_focused = false,
		use_terminal_background = true,
		widget_icon_load_margin = 0,
		grid_spacing = grid_spacing,
		grid_size = grid_size,
		mask_size = mask_size,
		edge_padding = edge_padding,
	}

	self._item_grid = self:_add_element(ViewElementGrid, "item_grid", 1, grid_settings)

	local position = self:_scenegraph_world_position("item_grid_pivot")

	self._item_grid:set_pivot_offset(position[1], position[2])
	self._item_grid:set_loading_state(false)
	self._item_grid:set_color_intensity_multiplier(0.7)
	self._item_grid:set_visibility(false)

	self._filtered_offer_items_layout = {}

	self._item_grid:present_grid_layout({})
	self:_setup_sort_options()

	local padding = 12
	local width, height = 530, 920
	local weapon_stats_settings = {
		ignore_blur = true,
		scrollbar_width = 7,
		title_height = 70,
		use_parent_world = false,
		using_custom_gamepad_navigation = false,
		grid_spacing = {
			0,
			0,
		},
		grid_size = {
			width - padding,
			height,
		},
		mask_size = {
			width + 40,
			height,
		},
		edge_padding = padding,
	}

	self._weapon_stats = self:_add_element(ViewElementWeaponStats, "weapon_stats", 1, weapon_stats_settings)

	local weapon_stats_position = self:_scenegraph_world_position("weapon_stats_pivot")

	self._weapon_stats:set_pivot_offset(weapon_stats_position[1], weapon_stats_position[2])

	self._discard_items_element = self:_add_element(ViewElementDiscardItems, "discard_items", 1, {
		items = filtered_items,
		selection_callback = callback(self, "_mark_items_to_sell"),
		unselection_callback = callback(self, "_unmark_items_to_sell"),
	})

	local discard_items_position = self:_scenegraph_world_position("weapon_discard_pivot")

	self._discard_items_element:set_pivot_offset(discard_items_position[1], discard_items_position[2])
	self._discard_items_element:set_visibility(false)
	self:_setup_masteries():next(function (layout)
		if self._destroyed then
			return
		end

		local edge_padding = 44
		local grid_width = 640
		local grid_height = 830
		local grid_size = {
			grid_width - edge_padding,
			grid_height,
		}
		local grid_spacing = {
			10,
			10,
		}
		local mask_size = {
			grid_width + 40,
			grid_height - 40,
		}
		local pattern_grid_settings = {
			hide_dividers = true,
			scroll_start_margin = 80,
			scrollbar_horizontal_offset = -8,
			scrollbar_vertical_margin = 80,
			scrollbar_vertical_offset = 33,
			scrollbar_width = 7,
			show_loading_overlay = true,
			title_height = 0,
			top_padding = 80,
			use_is_focused_for_navigation = false,
			use_item_categories = false,
			use_select_on_focused = false,
			use_terminal_background = true,
			widget_icon_load_margin = 0,
			grid_spacing = grid_spacing,
			grid_size = grid_size,
			mask_size = mask_size,
			edge_padding = edge_padding,
		}

		self._patterns_grid = self:_add_element(ViewElementGrid, "patterns_grid", 1, pattern_grid_settings)
		self._widgets_by_name.patterns_grid_panels.content.visible = true
		self._patterns_layout = layout

		local position = self:_scenegraph_world_position("patterns_grid_pivot")

		self._patterns_grid:set_pivot_offset(position[1], position[2])

		local tabs_content = {
			{
				hide_display_name = true,
				icon = "content/ui/materials/icons/item_types/melee_weapons",
				display_name = Localize("loc_glossary_term_melee_weapons"),
				slot_types = {
					"slot_primary",
				},
			},
			{
				hide_display_name = true,
				icon = "content/ui/materials/icons/item_types/ranged_weapons",
				display_name = Localize("loc_glossary_term_ranged_weapons"),
				slot_types = {
					"slot_secondary",
				},
			},
		}

		self:_setup_menu_tabs(tabs_content)
		self._patterns_grid:set_loading_state(false)
		self:_change_state("select_pattern")

		self._widgets_by_name.confirm_button.content.visible = true
	end)
end

CraftingMechanicusBarterItemsView._setup_sort_options = function (self)
	self._sort_options = {
		{
			display_name = Localize("loc_inventory_item_grid_sort_title_format_high_low", true, {
				sort_name = Localize("loc_inventory_item_grid_sort_title_item_power"),
			}),
			sort_function = Items.sort_comparator({
				">",
				Items.compare_item_level,
				"<",
				Items.compare_item_name,
				"<",
				Items.compare_item_rarity,
			}),
		},
		{
			display_name = Localize("loc_inventory_item_grid_sort_title_format_low_high", true, {
				sort_name = Localize("loc_inventory_item_grid_sort_title_item_power"),
			}),
			sort_function = Items.sort_comparator({
				"<",
				Items.compare_item_level,
				"<",
				Items.compare_item_name,
				"<",
				Items.compare_item_rarity,
			}),
		},
		{
			display_name = Localize("loc_inventory_item_grid_sort_title_format_high_low", true, {
				sort_name = Localize("loc_inventory_item_grid_sort_title_rarity"),
			}),
			sort_function = Items.sort_comparator({
				">",
				Items.compare_item_rarity,
				">",
				Items.compare_item_level,
				"<",
				Items.compare_item_name,
			}),
		},
		{
			display_name = Localize("loc_inventory_item_grid_sort_title_format_low_high", true, {
				sort_name = Localize("loc_inventory_item_grid_sort_title_rarity"),
			}),
			sort_function = Items.sort_comparator({
				"<",
				Items.compare_item_rarity,
				">",
				Items.compare_item_level,
				"<",
				Items.compare_item_name,
			}),
		},
		{
			display_name = Localize("loc_inventory_item_grid_sort_title_format_increasing_letters", true, {
				sort_name = Localize("loc_inventory_item_grid_sort_title_name"),
			}),
			sort_function = Items.sort_comparator({
				"<",
				Items.compare_item_name,
				"<",
				Items.compare_item_level,
				"<",
				Items.compare_item_rarity,
			}),
		},
		{
			display_name = Localize("loc_inventory_item_grid_sort_title_format_decreasing_letters", true, {
				sort_name = Localize("loc_inventory_item_grid_sort_title_name"),
			}),
			sort_function = Items.sort_comparator({
				">",
				Items.compare_item_name,
				"<",
				Items.compare_item_level,
				"<",
				Items.compare_item_rarity,
			}),
		},
	}

	if self._sort_options and #self._sort_options > 0 then
		local sort_callback = callback(self, "cb_on_sort_button_pressed")

		self._item_grid:setup_sort_button(self._sort_options, sort_callback)
	end
end

CraftingMechanicusBarterItemsView.cb_on_sort_button_pressed = function (self, option)
	local option_sort_index
	local sort_options = self._sort_options

	for i = 1, #sort_options do
		if sort_options[i] == option then
			option_sort_index = i

			break
		end
	end

	if option_sort_index ~= self._selected_sort_option_index then
		self._selected_sort_option_index = option_sort_index
		self._selected_sort_option = option

		local sort_function = option.sort_function

		self:_sort_grid_layout(sort_function)
	end
end

CraftingMechanicusBarterItemsView._sort_grid_layout = function (self, sort_function)
	local layout = table.append({}, self._filtered_offer_items_layout)

	if sort_function and #layout > 1 then
		table.sort(layout, sort_function)
	end

	if self._current_present_grid_layout_callback then
		self._current_present_grid_layout_callback(self, layout)
	end
end

CraftingMechanicusBarterItemsView._mark_items_to_sell = function (self, items)
	if items and #items > 0 then
		local widgets = self._item_grid:widgets()

		for i = 1, #items do
			local item = items[i]
			local gear_id = item.gear_id

			for ii = 1, #widgets do
				local widget = widgets[ii]
				local element = widget.content.element

				if element and element.item and element.item.gear_id == gear_id and not widget.content.multi_selected then
					self:cb_on_grid_entry_left_pressed(widget, element)

					break
				end
			end
		end
	end
end

CraftingMechanicusBarterItemsView._unmark_items_to_sell = function (self, items)
	if items and #items > 0 then
		local widgets = self._item_grid:widgets()

		for i = 1, #items do
			local item = items[i]
			local gear_id = item.gear_id

			for ii = 1, #widgets do
				local widget = widgets[ii]
				local element = widget.content.element

				if element and element.item and element.item.gear_id == gear_id and widget.content.multi_selected then
					self:cb_on_grid_entry_left_pressed(widget, element)

					break
				end
			end
		end
	end
end

CraftingMechanicusBarterItemsView._setup_menu_tabs = function (self, content)
	local tab_menu_settings = {
		button_spacing = 4,
		fixed_button_size = false,
		horizontal_alignment = "center",
		layer = 80,
		button_size = {
			70,
			60,
		},
		button_offset = {
			0,
			2,
		},
		icon_size = {
			60,
			60,
		},
		button_template = ButtonPassTemplates.item_category_sort_button,
		input_label_offset = {
			50,
			5,
		},
	}
	local id = "pattern_tab_menu"
	local layer = 20
	local tab_menu_element = self:_add_element(ViewElementTabMenu, id, layer, tab_menu_settings)

	self._patterns_tab_menu_element = tab_menu_element

	local input_action_left = "navigate_primary_left_pressed"
	local input_action_right = "navigate_primary_right_pressed"

	tab_menu_element:set_input_actions(input_action_left, input_action_right)

	local tab_button_template = table.clone(tab_menu_settings.button_template or ButtonPassTemplates.tab_menu_button_icon)

	tab_button_template[1].style = {
		on_hover_sound = UISoundEvents.tab_secondary_button_hovered,
		on_pressed_sound = UISoundEvents.tab_secondary_button_pressed,
	}

	local tab_ids = {}

	for i = 1, #content do
		local tab_content = content[i]
		local display_name = tab_content.display_name
		local display_icon = tab_content.icon
		local pressed_callback = callback(self, "cb_switch_tab", i)
		local tab_id = tab_menu_element:add_entry(display_name, pressed_callback, tab_button_template, display_icon)

		tab_ids[i] = tab_id
	end

	tab_menu_element:set_is_handling_navigation_input(true)

	self._tabs_content = content
	self._tab_ids = tab_ids

	local position = self:_scenegraph_world_position("patterns_grid_tab_panel")

	tab_menu_element:set_pivot_offset(position[1], position[2])
	self:cb_switch_tab(1)
end

CraftingMechanicusBarterItemsView.cb_switch_tab = function (self, index)
	if index ~= self._patterns_tab_menu_element:selected_index() then
		self._patterns_tab_menu_element:set_selected_index(index)

		local tabs_content = self._tabs_content
		local tab_content = tabs_content[index]
		local slot_types = tab_content.slot_types
		local display_name = tab_content.display_name

		self._selected_pattern_index = nil
		self._selected_pattern = nil

		self:_present_pattern_layout(slot_types)

		self._widgets_by_name.patterns_grid_panels.content.display_name = tab_content.display_name
	end
end

CraftingMechanicusBarterItemsView._present_pattern_layout = function (self, slot_filter)
	local layout = self._patterns_layout

	if layout then
		local filtered_layout = {}

		for i = #layout, 1, -1 do
			local entry = layout[i]
			local slot = entry.slot

			if slot_filter and not table.is_empty(slot_filter) and slot and table.find(slot_filter, slot) then
				filtered_layout[#filtered_layout + 1] = entry
			end
		end

		local on_present_callback = callback(self, "_cb_pattern_on_present")
		local left_click_callback = callback(self, "cb_pattern_on_grid_entry_left_pressed")
		local grid_width = 320
		local grid_height = 800
		local edge_padding = 44
		local grid_size = {
			grid_width - edge_padding,
			grid_height,
		}
		local spacing_entry = {
			widget_type = "spacing_vertical",
		}

		table.insert(filtered_layout, 1, spacing_entry)
		table.insert(filtered_layout, #filtered_layout + 1, spacing_entry)

		local grow_direction = "down"

		self._patterns_grid:present_grid_layout(filtered_layout, ContentBlueprints, left_click_callback, nil, nil, grow_direction, on_present_callback, nil)
	end
end

CraftingMechanicusBarterItemsView._present_items_layout = function (self, layout, present_callback)
	local left_click_callback = callback(self, "cb_on_grid_entry_left_pressed")
	local generate_blueprints_function = require("scripts/ui/view_content_blueprints/item_blueprints")
	local grid_size = {
		640,
		800,
	}
	local ItemContentBlueprints = generate_blueprints_function(grid_size)
	local spacing_entry = {
		widget_type = "spacing_vertical",
	}

	table.insert(layout, 1, spacing_entry)
	table.insert(layout, #layout + 1, spacing_entry)

	local grow_direction = self._grow_direction or "down"

	self._item_grid:set_color_intensity_multiplier(1)

	local sort_options = self._sort_options
	local sort_index = self._selected_sort_option_index or 1
	local selected_sort_option = sort_options[sort_index]
	local selected_sort_function = selected_sort_option.sort_function

	self._current_present_grid_layout_callback = function (self, new_layout)
		self._item_grid:present_grid_layout(new_layout, ItemContentBlueprints, left_click_callback, nil, nil, grow_direction, function ()
			local mastery_id = self._selected_pattern

			self:_present_mastery(mastery_id)

			if present_callback then
				present_callback()
			end

			self:_update_mastery_xp_increase()
		end)
	end

	self:_sort_grid_layout(selected_sort_function)
end

CraftingMechanicusBarterItemsView._present_sacrifice_layout = function (self, layout)
	local generate_blueprints_function = require("scripts/ui/view_content_blueprints/item_blueprints")
	local grid_size = {
		640,
		900,
	}
	local ItemContentBlueprints = generate_blueprints_function(grid_size)
	local spacing_entry = {
		widget_type = "spacing_vertical",
	}

	table.insert(layout, 1, spacing_entry)
	table.insert(layout, #layout + 1, spacing_entry)

	local grow_direction = self._grow_direction or "down"
	local sort_options = self._sort_options
	local sort_index = self._selected_sort_option_index or 1
	local selected_sort_option = sort_options[sort_index]
	local selected_sort_function = selected_sort_option.sort_function

	self._current_present_grid_layout_callback = function (self, new_layout)
		self._item_grid:present_grid_layout(new_layout, ItemContentBlueprints, nil, nil, nil, nil, function ()
			if not self._using_cursor_navigation then
				self._item_grid:select_first_index()

				local widget = self._item_grid:selected_grid_widget()
				local item = widget and widget.content.element and widget.content.element.item

				if item then
					self._weapon_stats:present_item(item)
				end
			end
		end)
	end

	self:_sort_grid_layout(selected_sort_function)
end

CraftingMechanicusBarterItemsView.cb_on_grid_entry_left_pressed = function (self, widget, element)
	if self._destroyed or self._ui_state == "select_pattern" then
		return
	end

	local current_selection_count = table.size(self._selected_items)

	if widget.content.warning_message and widget.content.warning_message ~= "" then
		return
	end

	local is_favorite = Items.is_item_id_favorited(element.item.gear_id)

	if is_favorite then
		return
	end

	local item = element.item

	if item then
		if not self._selected_items[item.gear_id] then
			self._selected_items[item.gear_id] = item
			widget.content.multi_selected = true

			self:_play_sound(UISoundEvents.mastery_select_weapon)
		else
			self._selected_items[item.gear_id] = nil
			widget.content.multi_selected = false

			self:_play_sound(UISoundEvents.weapons_select_weapon)
		end
	end

	self:_update_mastery_xp_increase()
end

CraftingMechanicusBarterItemsView._reset_master_xp_increase = function (self)
	local mastery_id = self._selected_pattern
	local mastery_data = self._masteries[mastery_id]
	local mastery_max_level = mastery_data.mastery_max_level
	local exp_per_level = Mastery.get_weapon_xp_per_level(mastery_data)
	local mastery_current_xp = mastery_data.current_xp
	local is_max_level = mastery_max_level <= mastery_data.mastery_level
	local mastery_level = mastery_data.mastery_level
	local next_level = math.min(mastery_level + 1, mastery_max_level)
	local mastery_start_exp = is_max_level and exp_per_level[mastery_level - 1] or exp_per_level[mastery_level]
	local mastery_end_exp = exp_per_level[next_level]

	mastery_current_xp = not is_max_level and mastery_current_xp or mastery_end_exp

	local mastery_info_widget = self._widgets_by_name.mastery_info
	local info_content = mastery_info_widget.content
	local info_style = mastery_info_widget.style

	info_content.visible = true

	local mastery_experience_added_color = info_style.mastery_experience.default_color
	local mastery_experience_level_color = info_style.mastery_experience.default_color
	local mastery_level_added_color = info_style.mastery_level.default_color
	local mastery_end_exp_adjusted = mastery_end_exp - mastery_start_exp
	local mastery_current_xp_adjusted = mastery_current_xp - mastery_start_exp
	local mastery_current_experience_text = string.format("{#color(%d,%d,%d)}%d{#reset()}", mastery_experience_added_color[2], mastery_experience_added_color[3], mastery_experience_added_color[4], mastery_current_xp_adjusted)
	local mastery_next_experience_text = string.format("{#color(%d,%d,%d)}%d{#reset()}", mastery_experience_level_color[2], mastery_experience_level_color[3], mastery_experience_level_color[4], mastery_end_exp_adjusted)
	local mastery_current_level_text = string.format("{#color(%d,%d,%d)}%d{#reset()}", mastery_level_added_color[2], mastery_level_added_color[3], mastery_level_added_color[4], mastery_level)
	local mastery_level_text = Localize("loc_mastery_level_current_max", true, {
		current = mastery_current_level_text,
		max = mastery_max_level,
	})
	local mastery_experience_text = Localize("loc_mastery_exp_current_next", true, {
		current = mastery_current_experience_text,
		next = mastery_next_experience_text,
	})

	info_content.mastery_level = mastery_level_text
	info_content.mastery_experience = mastery_experience_text
	info_content.added_exp = ""

	local mastery_info_width, mastery_info_height = self:_scenegraph_size("mastery_info")
	local bar_progress, bar_new_progress

	bar_progress = (is_max_level or mastery_end_exp_adjusted == 0) and 1 or mastery_current_xp_adjusted == 0 and 0 or math.ilerp(mastery_start_exp, mastery_end_exp, mastery_data.current_xp)
	bar_new_progress = is_max_level and 1 or 0
	info_style.experience_bar_new.size[1] = math.lerp(info_style.experience_bar.offset[1] * 2, mastery_info_width, bar_new_progress)
	info_style.experience_bar.size[1] = math.lerp(info_style.experience_bar.offset[1] * 2, mastery_info_width, bar_progress)
	info_style.experience_bar.visible = mastery_data.mastery_level == mastery_level

	local widgets = self._item_grid:widgets()

	if widgets then
		for i = 1, #widgets do
			local widget = widgets[i]

			if widget.content and widget.content.hotspot and not widget.content.multi_selected then
				widget.content.warning_message = is_max_level and Localize("loc_mastery_alert_max_mastery") or ""
			end
		end
	end

	self._new_xp_data = nil
end

CraftingMechanicusBarterItemsView._update_mastery_xp_increase = function (self)
	local added_xp = 0
	local mastery_id = self._selected_pattern
	local mastery_data = self._masteries[mastery_id]
	local mastery_max_level = mastery_data.mastery_max_level
	local is_max_level = mastery_max_level <= mastery_data.mastery_level
	local sacrifice_operation_costs = Managers.data_service.crafting:get_sacrifice_mastery_costs()
	local sacrifice_muiltiplier = sacrifice_operation_costs.sacrifice_muiltiplier or 6
	local min_expertise_level = sacrifice_operation_costs.minimumExpertiseLevel or 0
	local base_mastery_award = sacrifice_operation_costs.baseReward or 25
	local xp_per_expertise_level = sacrifice_operation_costs.masteryXpPerExpertiseLevel or 30

	for id, item in pairs(self._selected_items) do
		local text_expertise_level = Items.expertise_level(item, true)
		local expertise_level = tonumber(text_expertise_level)
		local is_same_mastery = item.parent_pattern and item.parent_pattern == mastery_id
		local bonus_multiplier = is_same_mastery and sacrifice_muiltiplier or 1
		local item_xp = base_mastery_award + ((expertise_level - min_expertise_level) / Items.get_expertise_multiplier() + 1) * xp_per_expertise_level

		item_xp = item_xp * bonus_multiplier
		added_xp = added_xp + item_xp
	end

	local mastery_current_xp = mastery_data.current_xp + added_xp
	local mastery_level = Mastery.get_level_by_xp(mastery_data, mastery_current_xp)
	local exp_per_level = Mastery.get_weapon_xp_per_level(mastery_data)
	local next_level = math.min(mastery_level + 1, mastery_max_level)

	is_max_level = mastery_max_level <= mastery_level

	local mastery_start_exp = is_max_level and exp_per_level[mastery_level - 1] or exp_per_level[mastery_level]
	local mastery_end_exp = exp_per_level[next_level]

	mastery_current_xp = not is_max_level and mastery_current_xp or mastery_end_exp

	local mastery_info_widget = self._widgets_by_name.mastery_info
	local info_content = mastery_info_widget.content
	local info_style = mastery_info_widget.style

	info_content.visible = true

	local mastery_experience_added_color = added_xp > 0 and Color.ui_blue_light(255, true) or info_style.mastery_experience.default_color
	local mastery_experience_level_color = mastery_level > mastery_data.mastery_level and Color.ui_blue_light(255, true) or info_style.mastery_experience.default_color
	local mastery_level_added_color = mastery_level > mastery_data.mastery_level and Color.ui_blue_light(255, true) or info_style.mastery_level.default_color
	local mastery_end_exp_adjusted = mastery_end_exp - mastery_start_exp
	local mastery_current_xp_adjusted = mastery_current_xp - mastery_start_exp
	local mastery_current_experience_text = string.format("{#color(%d,%d,%d)}%d{#reset()}", mastery_experience_added_color[2], mastery_experience_added_color[3], mastery_experience_added_color[4], mastery_current_xp_adjusted)
	local mastery_next_experience_text = string.format("{#color(%d,%d,%d)}%d{#reset()}", mastery_experience_level_color[2], mastery_experience_level_color[3], mastery_experience_level_color[4], mastery_end_exp_adjusted)
	local mastery_current_level_text = string.format("{#color(%d,%d,%d)}%d{#reset()}", mastery_level_added_color[2], mastery_level_added_color[3], mastery_level_added_color[4], mastery_level)
	local mastery_level_text = Localize("loc_mastery_level_current_max", true, {
		current = mastery_current_level_text,
		max = mastery_max_level,
	})
	local mastery_experience_text = Localize("loc_mastery_exp_current_next", true, {
		current = mastery_current_experience_text,
		next = mastery_next_experience_text,
	})

	info_content.mastery_level = mastery_level_text
	info_content.mastery_experience = mastery_experience_text
	info_content.added_exp = added_xp > 0 and Localize("loc_eor_card_mastery_added_exp", true, {
		exp = added_xp,
	}) or ""

	local mastery_info_width, mastery_info_height = self:_scenegraph_size("mastery_info")
	local bar_progress, bar_new_progress

	bar_progress = (is_max_level or mastery_end_exp_adjusted == 0) and 1 or mastery_current_xp_adjusted == 0 and 0 or math.ilerp(mastery_start_exp, mastery_end_exp, mastery_data.current_xp)
	bar_new_progress = is_max_level and 1 or added_xp == 0 and 0 or math.ilerp(mastery_start_exp, mastery_end_exp, mastery_current_xp)
	info_style.experience_bar_new.size[1] = math.lerp(info_style.experience_bar.offset[1] * 2, mastery_info_width, bar_new_progress)
	info_style.experience_bar.size[1] = math.lerp(info_style.experience_bar.offset[1] * 2, mastery_info_width, bar_progress)
	info_style.experience_bar.visible = mastery_data.mastery_level == mastery_level

	local widgets = self._item_grid:widgets()

	if widgets then
		for i = 1, #widgets do
			local widget = widgets[i]

			if widget.content and widget.content.hotspot and not widget.content.multi_selected then
				widget.content.warning_message = is_max_level and Localize("loc_mastery_alert_max_mastery") or ""
			end
		end
	end

	self._new_xp_data = nil

	if added_xp > 0 then
		self._new_xp_data = {
			mastery_level = mastery_level,
			mastery_xp = mastery_current_xp,
			mastery_start_exp = mastery_start_exp,
			mastery_end_exp = mastery_start_exp,
		}
	end

	if self._ui_state == "select_weapon" then
		self._widgets_by_name.confirm_button.content.hotspot.disabled = added_xp <= 0
	end
end

CraftingMechanicusBarterItemsView._cb_pattern_on_present = function (self)
	local new_selection_index = self._selected_pattern_index
	local grid_widgets = self._patterns_grid:widgets()

	if new_selection_index then
		self._patterns_grid:select_grid_index(new_selection_index)
	else
		self._patterns_grid:select_first_index()
	end

	self._patterns_grid:scroll_to_grid_index(new_selection_index or 1, true)

	local selected_widget = grid_widgets[self._patterns_grid:selected_grid_index()]

	if selected_widget then
		selected_widget.content.hotspot.pressed_callback()
	end
end

CraftingMechanicusBarterItemsView.cb_pattern_on_grid_entry_left_pressed = function (self, widget, element)
	local widget_index = self._patterns_grid:widget_index(widget) or 1

	self._selected_pattern_index = widget_index

	self._patterns_grid:select_grid_index(widget_index)

	local mastery_id = element.mastery_id

	self._selected_pattern = mastery_id
	self._widgets_by_name.confirm_button.content.hotspot.disabled = self:character_level() < element.weapon_level_requirement

	self:_present_mastery(mastery_id)
	self:_reset_master_xp_increase()
end

CraftingMechanicusBarterItemsView.equipped_item_in_slot = function (self, slot_name)
	local player = self:_player()
	local profile = player:profile()
	local loadout = profile.loadout
	local slot_item = loadout[slot_name]

	return slot_item
end

CraftingMechanicusBarterItemsView._on_navigation_input_changed = function (self)
	if self._using_cursor_navigation then
		if self._ui_state == "select_weapon" then
			self._discard_items_element:disable_input(false)

			self._selected_item_index = nil
		end

		if self._item_grid then
			self._item_grid:disable_input(false)

			if self._item_grid:grid() then
				self._item_grid:select_grid_index()
			end
		end
	elseif self._ui_state == "select_weapon" then
		if self._item_grid then
			if self._selected_item_index then
				self._item_grid:select_grid_index(self._selected_item_index)
				self._item_grid:scroll_to_grid_index(self._selected_item_index)

				self._selected_item_index = nil
			else
				self._item_grid:select_first_index()
				self._item_grid:scroll_to_grid_index(1)
			end

			local widget = self._item_grid:selected_grid_widget()
			local item = widget and widget.content.element and widget.content.element.item

			if item then
				self._weapon_stats:present_item(item)
			end

			self._item_grid:disable_input(false)
		end

		self._discard_items_element:disable_input(true)
	elseif self._ui_state == "sacrifice_weapon" then
		self._item_grid:select_first_index()

		local widget = self._item_grid:selected_grid_widget()
		local item = widget and widget.content.element and widget.content.element.item

		if item then
			self._weapon_stats:present_item(item)
		end
	end
end

CraftingMechanicusBarterItemsView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

CraftingMechanicusBarterItemsView.ui_renderer = function (self)
	return self._ui_renderer
end

CraftingMechanicusBarterItemsView._present_mastery = function (self, mastery_id)
	if not mastery_id then
		self._widgets_by_name.mastery_info.content.visible = false

		return
	end

	local mastery_data = self._masteries[mastery_id]
	local mastery_display_name = mastery_data.display_name
	local mastery_icon = mastery_data.icon
	local mastery_info_widget = self._widgets_by_name.mastery_info
	local info_content = mastery_info_widget.content
	local info_style = mastery_info_widget.style

	info_content.visible = true

	if mastery_icon then
		info_content.icon = mastery_icon
	end

	info_content.display_name = mastery_display_name
end

CraftingMechanicusBarterItemsView._item_hover_update = function (self)
	local widget

	if self._using_cursor_navigation then
		widget = self._item_grid and self._item_grid:hovered_widget()
	else
		widget = self._item_grid and self._item_grid:selected_grid_widget()
	end

	local item = widget and widget.content.element and widget.content.element.item

	if self._currently_hovered_item ~= item then
		if self._weapon_stats then
			self._weapon_stats:stop_presenting()
		end

		self._currently_hovered_item = item

		if self._weapon_stats and item then
			self._weapon_stats:present_item(item)
		end
	end
end

CraftingMechanicusBarterItemsView._change_state = function (self, state_name)
	self._widgets_by_name.sacrifice_intro.content.visible = false
	self._widgets_by_name.patterns_grid_panels.content.visible = false
	self._widgets_by_name.mastery_info.content.visible = false

	self._patterns_grid:set_visibility(false)
	self._patterns_tab_menu_element:set_visibility(false)
	self._discard_items_element:set_visibility(false)
	self._item_grid:set_visibility(false)
	self._patterns_tab_menu_element:disable_input(true)
	self._patterns_grid:disable_input(true)
	self._item_grid:disable_input(true)
	self._discard_items_element:disable_input(true)
	self._weapon_stats:stop_presenting()

	self._ui_state_next_frame = state_name

	if self._previous_selected_pattern ~= self._selected_pattern then
		self._previous_selected_pattern = self._selected_pattern
		self._selected_items = {}
	end

	self._ui_scenegraph.mastery_info.vertical_alignment = "top"

	if state_name == "select_pattern" then
		self._widgets_by_name.patterns_grid_panels.content.visible = true
		self._widgets_by_name.sacrifice_intro.content.visible = true

		local mastery_id = self._selected_pattern

		self:_present_mastery(mastery_id)

		local sacrifice_title_text = self._widgets_by_name.sacrifice_intro.content.display_name
		local sacrifice_title_style = self._widgets_by_name.sacrifice_intro.style.display_name
		local sacrifice_title_font_data = UIFonts.data_by_type(sacrifice_title_style.font_type)
		local sacrifice_title_text_options = UIFonts.get_font_options_by_style(sacrifice_title_style)
		local sacrifice_description_text = self._widgets_by_name.sacrifice_intro.content.description
		local sacrifice_description_style = self._widgets_by_name.sacrifice_intro.style.description
		local sacrifice_description_font_data = UIFonts.data_by_type(sacrifice_description_style.font_type)
		local sacrifice_description_text_options = UIFonts.get_font_options_by_style(sacrifice_description_style)
		local _, sacrifice_intro_title_height = UIRenderer.text_size(self._ui_renderer, sacrifice_title_text, sacrifice_title_style.font_type, sacrifice_title_style.font_size, {
			650,
			2000,
		}, sacrifice_title_text_options)
		local _, sacrifice_description_text_height = UIRenderer.text_size(self._ui_renderer, sacrifice_description_text, sacrifice_description_style.font_type, sacrifice_description_style.font_size, {
			650,
			2000,
		}, sacrifice_description_text_options)
		local text_margin = 60
		local mastery_info_height = sacrifice_intro_title_height + sacrifice_description_text_height + text_margin

		self:_set_scenegraph_size("mastery_info_details", 650, mastery_info_height)
		self:_set_scenegraph_position("mastery_info_details", 760, nil)

		self._ui_scenegraph.mastery_info.vertical_alignment = "bottom"

		local mastery_info_start_position = self._ui_scenegraph.mastery_info_details.position[2] - mastery_info_height - 20

		self:_set_scenegraph_position("mastery_info", 760, mastery_info_start_position)
		self:_set_scenegraph_size("mastery_info", 650, 240)
		self:_set_scenegraph_position("confirm_button", 900, 920)

		self._widgets_by_name.mastery_info.style.icon.size = {
			self._widgets_by_name.mastery_info.style.icon.original_size[1],
			self._widgets_by_name.mastery_info.style.icon.original_size[2],
		}
		self._widgets_by_name.mastery_info.style.icon.offset[2] = self._widgets_by_name.mastery_info.style.icon.original_offset[2]
		self._widgets_by_name.confirm_button.content.original_text = Utf8.upper(Localize("loc_continue"))
		self._widgets_by_name.confirm_button.content.hotspot.on_pressed_sound = UISoundEvents.default_click
		self._widgets_by_name.confirm_button.content.gamepad_action = "confirm_pressed"
		self._widgets_by_name.confirm_button.content.hotspot.disabled = not self._selected_pattern

		self._patterns_grid:set_visibility(true)
		self._patterns_tab_menu_element:set_visibility(true)
		self._patterns_tab_menu_element:disable_input(false)
		self._patterns_grid:disable_input(false)
	elseif state_name == "select_weapon" then
		self._discard_items_element:set_visibility(true)

		if self._using_cursor_navigation then
			self._discard_items_element:disable_input(false)
		end

		self:_set_scenegraph_position("mastery_info", 1320, 100)
		self:_set_scenegraph_size("mastery_info", 500, 190)
		self:_set_scenegraph_position("confirm_button", 840, 900)

		self._widgets_by_name.mastery_info.style.icon.size = {
			self._widgets_by_name.mastery_info.style.icon.original_size[1] * 0.6,
			self._widgets_by_name.mastery_info.style.icon.original_size[2] * 0.6,
		}
		self._widgets_by_name.mastery_info.style.icon.offset[2] = self._widgets_by_name.mastery_info.style.icon.original_offset[2] - 10

		local mastery_id = self._selected_pattern

		self._widgets_by_name.confirm_button.content.original_text = Utf8.upper(Localize("loc_continue"))
		self._widgets_by_name.confirm_button.content.hotspot.on_pressed_sound = UISoundEvents.default_click
		self._widgets_by_name.confirm_button.content.gamepad_action = "secondary_action_pressed"

		local item_layout = {}

		for gear_id, layout in pairs(self._offer_items_layout) do
			item_layout[#item_layout + 1] = layout
		end

		self._filtered_offer_items_layout = item_layout

		self:_present_items_layout(item_layout, function ()
			local widgets = self._item_grid:widgets()

			if not self._using_cursor_navigation then
				self._item_grid:select_first_index()

				local selected_index = self._item_grid:selected_grid_index()

				self._item_grid:scroll_to_grid_index(selected_index)
			end

			for i = 1, #widgets do
				local widget = widgets[i]
				local gear_id = widget.content.element.item.gear_id

				if self._selected_items[gear_id] then
					widget.content.multi_selected = true
				end
			end
		end)
		self:_present_mastery(mastery_id)
		self._item_grid:set_visibility(true)
		self._item_grid:disable_input(false)
	elseif state_name == "sacrifice_weapon" then
		local mastery_id = self._selected_pattern
		local item_layout = {}

		for gear_id, layout in pairs(self._offer_items_layout) do
			if self._selected_items[gear_id] then
				item_layout[#item_layout + 1] = layout
			end
		end

		self._filtered_offer_items_layout = item_layout

		self:_present_sacrifice_layout(item_layout)
		self:_present_mastery(mastery_id)
		self:_set_scenegraph_position("confirm_button", 840, 900)

		self._widgets_by_name.mastery_info.style.icon.size = {
			self._widgets_by_name.mastery_info.style.icon.original_size[1] * 0.6,
			self._widgets_by_name.mastery_info.style.icon.original_size[2] * 0.6,
		}
		self._widgets_by_name.mastery_info.style.icon.offset[2] = self._widgets_by_name.mastery_info.style.icon.original_offset[2] - 10
		self._widgets_by_name.confirm_button.content.original_text = Utf8.upper(Localize("loc_mastery_button_sacrifice_weapon"))
		self._widgets_by_name.confirm_button.content.hotspot.on_pressed_sound = UISoundEvents.default_click
		self._widgets_by_name.confirm_button.content.gamepad_action = "secondary_action_pressed"

		self._item_grid:set_visibility(true)
		self._item_grid:disable_input(false)
	end
end

CraftingMechanicusBarterItemsView._confirm_pressed = function (self)
	if self._ui_state == "select_pattern" then
		self:_change_state("select_weapon")
	elseif self._ui_state == "select_weapon" then
		self:_change_state("sacrifice_weapon")
	elseif self._ui_state == "sacrifice_weapon" then
		self:_complete_purchase()
	end
end

CraftingMechanicusBarterItemsView._complete_purchase = function (self)
	if not self._selected_items or table.is_empty(self._selected_items) then
		return
	end

	self._widgets_by_name.confirm_button.content.hotspot.on_pressed_sound = UISoundEvents.crafting_view_sacrifice_weapon

	local gear_ids = {}

	for gear_id, item in pairs(self._selected_items) do
		gear_ids[#gear_ids + 1] = gear_id
	end

	local mastery_id = self._selected_pattern

	self._widgets_by_name.confirm_button.content.hotspot.disabled = true

	Managers.data_service.crafting:extract_weapon_mastery(mastery_id, gear_ids):next(function (data)
		for i = 1, #data.gear_ids do
			local gear_id = data.gear_ids[i]

			self._offer_items_layout[gear_id] = nil
		end

		self._selected_items = {}

		if data.amount > 0 then
			local added_xp = data.amount
			local mastery_data = self._masteries[mastery_id]
			local mastery_max_level = mastery_data.mastery_max_level
			local mastery_current_xp = mastery_data.current_xp
			local exp_per_level = Mastery.get_weapon_xp_per_level(mastery_data)
			local mastery_xp = mastery_current_xp + added_xp
			local mastery_level = Mastery.get_level_by_xp(mastery_data, mastery_xp)
			local next_level = math.min(mastery_level + 1, mastery_max_level)
			local is_max_level = mastery_max_level <= mastery_level
			local mastery_start_exp = is_max_level and exp_per_level[next_level - 1] or exp_per_level[mastery_level]
			local mastery_end_exp = exp_per_level[next_level]

			mastery_current_xp = not is_max_level and mastery_current_xp or mastery_end_exp

			for i = 1, #self._patterns_layout do
				local mastery_layout = self._patterns_layout[i]

				if mastery_layout.mastery_id == mastery_id then
					mastery_layout.mastery_level = mastery_level

					break
				end
			end

			self._masteries[mastery_id].mastery_level = mastery_level
			self._masteries[mastery_id].current_xp = mastery_xp
			self._masteries[mastery_id].start_xp = mastery_start_exp
			self._masteries[mastery_id].end_xp = mastery_end_exp

			Managers.data_service.mastery:claim_levels_by_new_exp(self._masteries[mastery_id]):next(function (data)
				local new_claim_level = data and data.claimed_level

				if new_claim_level then
					self._masteries[mastery_id].claimed_level = new_claim_level
				end
			end)
		end

		local selected_tab_index = self._patterns_tab_menu_element:selected_index()
		local tabs_content = self._tabs_content
		local tab_content = tabs_content[selected_tab_index]
		local slot_types = tab_content.slot_types
		local filtered_items = {}

		for id, layout in pairs(self._offer_items_layout) do
			filtered_items[#filtered_items + 1] = layout.item
		end

		self:_present_pattern_layout(slot_types)
		self._discard_items_element:refresh(filtered_items)
		self:_change_state("select_weapon")
		Managers.event:trigger("event_add_notification_message", "default", Localize("loc_notification_sacrifice_complete"))
	end):catch(function ()
		Managers.event:trigger("event_add_notification_message", "alert", {
			text = Localize("loc_popup_description_backend_error"),
		})
	end)
end

return CraftingMechanicusBarterItemsView
