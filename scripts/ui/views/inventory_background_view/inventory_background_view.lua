local Breeds = require("scripts/settings/breed/breeds")
local Definitions = require("scripts/ui/views/inventory_background_view/inventory_background_view_definitions")
local InventoryBackgroundViewSettings = require("scripts/ui/views/inventory_background_view/inventory_background_view_settings")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local PlayerSpecializationUtils = require("scripts/utilities/player_specialization/player_specialization")
local ProfileUtils = require("scripts/utilities/profile_utils")
local Promise = require("scripts/foundation/utilities/promise")
local ScriptCamera = require("scripts/foundation/utilities/script_camera")
local UICharacterProfilePackageLoader = require("scripts/managers/ui/ui_character_profile_package_loader")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWeaponSpawner = require("scripts/managers/ui/ui_weapon_spawner")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementMenuPanel = require("scripts/ui/view_elements/view_element_menu_panel/view_element_menu_panel")
local Views = require("scripts/ui/views/views")
local PlayerProgressionUnlocks = require("scripts/settings/player/player_progression_unlocks")
local InventoryBackgroundView = class("InventoryBackgroundView", "BaseView")

InventoryBackgroundView.init = function (self, settings, context)
	self._context = context

	InventoryBackgroundView.super.init(self, Definitions, settings)

	self._pass_draw = false
end

InventoryBackgroundView.on_enter = function (self)
	InventoryBackgroundView.super.on_enter(self)

	local context = self._context
	local player = context and context.player or self:_player()
	local profile = player:profile()
	self._presentation_profile = table.clone_instance(profile)
	local player_loadout = self._presentation_profile.loadout
	self._preview_profile_equipped_items = player_loadout
	self._starting_profile_equipped_items = context and context.starting_profile_equipped_items or table.clone_instance(player_loadout)
	self._current_profile_equipped_items = context and context.current_profile_equipped_items or table.clone_instance(player_loadout)
	local player_unit = player.player_unit
	local unit_data = ScriptUnit.has_extension(player_unit, "unit_data_system")
	local inventory_component = unit_data and unit_data:read_component("inventory")
	local wielded_slot = inventory_component and inventory_component.wielded_slot ~= "slot_unarmed" and inventory_component.wielded_slot or "slot_primary"

	self:_set_preview_wield_slot_id(wielded_slot)

	self._player_level = profile.current_level
	self._preview_player = player
	self._is_own_player = self._preview_player == self:_player()
	self._show_talents_tab = false
	self._is_readonly = context and context.is_readonly
	self._has_empty_talent_groups = false

	self:_update_equipped_items()
	self:_register_event("event_inventory_view_equip_item", "event_inventory_view_equip_item")
	self:_register_event("event_equip_local_changes", "event_equip_local_changes")
	self:_register_event("event_change_wield_slot", "event_change_wield_slot")
	self:_register_event("event_discard_item", "event_discard_item")
	self:_register_event("event_player_profile_updated", "event_player_profile_updated")
	self:_register_event("event_item_icon_updated", "event_item_icon_updated")
	self:_setup_top_panel()
	self:_setup_input_legend()
	self:_setup_background_world()
	self:_force_select_panel_index(1)
	self:_set_player_profile_information(player)

	local profile_archetype = profile.archetype
	local archetype_name = profile_archetype.name

	self:_setup_background_frames_by_archetype(archetype_name)

	self._talent_icons_package_id = Managers.data_service.talents:load_icons_for_profile(profile, "InventoryBackgroundView")
	self._widgets_by_name.character_insigna.content.visible = false
end

InventoryBackgroundView._setup_background_frames_by_archetype = function (self, archetype_name)
	local inventory_frames_by_archetype = UISettings.inventory_frames_by_archetype
	local frame_textures = inventory_frames_by_archetype[archetype_name]
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.corner_top_left.content.texture = frame_textures.left_upper
	widgets_by_name.corner_bottom_left.content.texture = frame_textures.left_lower
	widgets_by_name.corner_top_right.content.texture = frame_textures.right_upper
	widgets_by_name.corner_bottom_right.content.texture = frame_textures.right_lower
end

InventoryBackgroundView._set_player_profile_information = function (self, player)
	local profile = player:profile()
	local character_name = ProfileUtils.character_name(profile)
	local current_level = profile.current_level
	local character_title = ProfileUtils.character_title(profile)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.character_name.content.text = character_name
	widgets_by_name.character_title.content.text = character_title
	widgets_by_name.character_level.content.text = tostring(current_level)
	widgets_by_name.character_level_next.content.text = ""

	self:_set_experience_bar(0, 0)
	self:_fetch_character_progression(player)
	self:_request_player_icon()
end

InventoryBackgroundView._request_player_icon = function (self)
	local material_values = self._widgets_by_name.character_portrait.style.texture.material_values
	material_values.use_placeholder_texture = 1

	self:_load_portrait_icon()
end

InventoryBackgroundView._load_portrait_icon = function (self)
	local profile = self._presentation_profile
	local cb = callback(self, "_cb_set_player_icon")
	local icon_load_id = Managers.ui:load_profile_portrait(profile, cb)
	self._portrait_loaded_info = {
		icon_load_id = icon_load_id
	}
end

InventoryBackgroundView._unload_portrait_icon = function (self)
	local portrait_loaded_info = self._portrait_loaded_info

	if not portrait_loaded_info then
		return
	end

	local icon_load_id = portrait_loaded_info.icon_load_id

	Managers.ui:unload_profile_portrait(icon_load_id)

	self._portrait_loaded_info = nil
end

InventoryBackgroundView._cb_set_player_icon = function (self, grid_index, rows, columns, render_target)
	local material_values = self._widgets_by_name.character_portrait.style.texture.material_values
	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.texture_icon = render_target
end

InventoryBackgroundView._request_player_frame = function (self, item, ui_renderer)
	self:_unload_portrait_frame(ui_renderer)
	self:_load_portrait_frame(item)
end

InventoryBackgroundView._load_portrait_frame = function (self, item)
	local cb = callback(self, "_cb_set_player_frame")
	local icon_load_id = Managers.ui:load_item_icon(item, cb)
	self._frame_loaded_info = {
		icon_load_id = icon_load_id
	}
end

InventoryBackgroundView._unload_portrait_frame = function (self, ui_renderer)
	local frame_loaded_info = self._frame_loaded_info

	if not frame_loaded_info then
		return
	end

	local widget = self._widgets_by_name.character_portrait

	if not self.destroyed then
		local material_values = widget.style.texture.material_values
		material_values.portrait_frame_texture = "content/ui/textures/nameplates/portrait_frames/default"
	end

	if ui_renderer then
		UIWidget.set_visible(widget, ui_renderer, false)
		UIWidget.set_visible(widget, ui_renderer, true)
	end

	local icon_load_id = frame_loaded_info.icon_load_id

	Managers.ui:unload_item_icon(icon_load_id)

	self._frame_loaded_info = nil
end

InventoryBackgroundView._cb_set_player_frame = function (self, item)
	local profile = self._presentation_profile
	local loadout = profile and profile.loadout
	local icon = nil

	if item.icon then
		icon = item.icon
	else
		icon = "content/ui/textures/nameplates/portrait_frames/default"
	end

	local widget = self._widgets_by_name.character_portrait
	local material_values = widget.style.texture.material_values
	material_values.portrait_frame_texture = icon
end

InventoryBackgroundView._request_player_insignia = function (self, item)
	self:_unload_insignia()
	self:_load_insignia(item)
end

InventoryBackgroundView._load_insignia = function (self, item)
	local cb = callback(self, "_cb_set_player_insignia")
	local icon_load_id = Managers.ui:load_item_icon(item, cb)
	self._insignia_loaded_info = {
		icon_load_id = icon_load_id
	}
end

InventoryBackgroundView._unload_insignia = function (self, ui_renderer)
	local insignia_loaded_info = self._insignia_loaded_info

	if not insignia_loaded_info then
		return
	end

	local widget = self._widgets_by_name.character_insigna

	if not self.destroyed then
		local material_values = widget.style.texture.material_values
		material_values.texture_map = "content/ui/textures/nameplates/insignias/default"
	end

	if ui_renderer then
		UIWidget.set_visible(widget, ui_renderer, false)
		UIWidget.set_visible(widget, ui_renderer, true)
	end

	local icon_load_id = insignia_loaded_info.icon_load_id

	Managers.ui:unload_item_icon(icon_load_id)

	self._insignia_loaded_info = nil
	widget.content.visible = false
end

InventoryBackgroundView._cb_set_player_insignia = function (self, item)
	local profile = self._presentation_profile
	local loadout = profile and profile.loadout
	local icon = nil

	if item.icon then
		icon = item.icon
		local material_values = self._widgets_by_name.character_insigna.style.texture.material_values
		material_values.texture_map = icon
	end

	self._widgets_by_name.character_insigna.content.visible = icon and true or false
end

InventoryBackgroundView._fetch_character_progression = function (self, player)
	if self._character_progression_promise then
		return
	end

	self._fetching_character_progression = true
	local profiles_promise = nil
	local character_id = player:character_id()

	if Managers.backend:authenticated() then
		local backend_interface = Managers.backend.interfaces
		profiles_promise = backend_interface.progression:get_progression("character", character_id):next(function (results)
			local progression_data = results
			local current_level_experience = progression_data and progression_data.currentXpInLevel or 0
			local needed_level_experience = progression_data and progression_data.neededXpForNextLevel or 0
			local normalized_progress = needed_level_experience > 0 and current_level_experience / (current_level_experience + needed_level_experience) or 0

			return normalized_progress
		end):catch(function (error)
			Log.error("InventoryBackgroundView", "Error fetching character progression: %s", error)
		end)
	else
		profiles_promise = Promise.new()
		local level_experience_progress = 0

		profiles_promise:resolve(level_experience_progress)
	end

	profiles_promise:next(function (level_progress)
		level_progress = level_progress or 0

		self:_set_experience_bar(level_progress, 2)

		self._character_progression_promise = nil
		self._fetching_character_progression = false
		self._dirty_character_list = true
	end):catch(function (error)
		self._character_progression_promise = nil

		Log.error("InventoryBackgroundView", "Error fetching character progression: %s", error)

		self._fetching_character_progression = false
	end)

	self._character_progression_promise = profiles_promise
end

InventoryBackgroundView._set_experience_bar = function (self, experience_fraction, duration)
	local is_nan = experience_fraction ~= experience_fraction
	local experience_fraction = not is_nan and experience_fraction or 0

	if duration then
		self._experience_fraction_duration_time = 0
		self._experience_fraction_duration_delay = duration
		self._target_experience_fraction = experience_fraction
		experience_fraction = 0
	end

	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.character_experience
	widget.content.progress = experience_fraction
	self._current_experience_fraction = experience_fraction
end

InventoryBackgroundView._update_experience_bar_fill_animation = function (self, dt)
	local current_time = self._experience_fraction_duration_time

	if not current_time then
		return
	end

	local anim_duration = self._experience_fraction_duration_delay
	local target_fraction = self._target_experience_fraction
	current_time = current_time + dt
	local time_progress = math.clamp(current_time / anim_duration, 0, 1)
	local anim_progress = math.ease_out_exp(time_progress)
	local anim_fraction = target_fraction * anim_progress

	self:_set_experience_bar(anim_fraction)

	if anim_progress < 1 then
		self._experience_fraction_duration_time = current_time
	else
		self._experience_fraction_duration_time = nil
		self._experience_fraction_duration_delay = nil
	end
end

InventoryBackgroundView._update_equipped_items = function (self)
	local player_profile = self._presentation_profile

	if player_profile then
		local loadout = player_profile.loadout
		local preview_profile_equipped_items = self._preview_profile_equipped_items
		local original_equips = self._starting_profile_equipped_items
		local current_equips = self._current_profile_equipped_items

		for slot_name, slot in pairs(ItemSlotSettings) do
			local item = loadout[slot_name]
			local equipped_item = preview_profile_equipped_items[slot_name]

			if item ~= equipped_item then
				preview_profile_equipped_items[slot_name] = item
				original_equips[slot_name] = item
				current_equips[slot_name] = item
			end
		end

		self:_update_presentation_wield_item()
	end
end

InventoryBackgroundView.event_inventory_view_equip_item = function (self, slot_name, item, force_update)
	self:_equip_slot_item(slot_name, item, force_update)
end

InventoryBackgroundView.event_equip_local_changes = function (self)
	self:_equip_local_changes()
end

InventoryBackgroundView.event_change_wield_slot = function (self, slot_name)
	self:_set_preview_wield_slot_id(slot_name)
	self:_update_presentation_wield_item()
end

InventoryBackgroundView.event_discard_item = function (self, item)
	local gear_id = item.gear_id
	local backend_interface = Managers.backend.interfaces
	local local_changes_promise = self:_equip_local_changes()
	local delete_promise = nil

	if local_changes_promise then
		delete_promise = local_changes_promise:next(function ()
			return backend_interface.gear:delete_gear(gear_id)
		end)
	else
		delete_promise = backend_interface.gear:delete_gear(gear_id)
	end

	delete_promise:next(function (result)
		local rewards = result and result.rewards

		if rewards then
			local credits_amount = rewards[1] and rewards[1].amount or 0

			Managers.event:trigger("event_force_wallet_update")
			Managers.event:trigger("event_add_notification_message", "currency", {
				currency = "credits",
				amount = credits_amount
			})
		end
	end)
end

InventoryBackgroundView.event_player_profile_updated = function (self)
	self:_update_has_empty_talents_groups()
end

InventoryBackgroundView.event_item_icon_updated = function (self, item)
	local presentation_loadout = self._preview_profile_equipped_items

	for slot_name, slot_item in pairs(presentation_loadout) do
		if slot_item and item and slot_item.gear_id == item.gear_id then
			local force_update = true

			self:_equip_slot_item(slot_name, item, force_update)

			break
		end
	end
end

InventoryBackgroundView._equip_slot_item = function (self, slot_name, item, force_update)
	local presentation_loadout = self._preview_profile_equipped_items
	local current_loadout = self._current_profile_equipped_items
	local previous_item = current_loadout[slot_name]
	local unequip_item = not item and previous_item
	local valid_item_change = not unequip_item and item.gear_id and (not previous_item or previous_item.gear_id ~= item.gear_id) or force_update

	if unequip_item or valid_item_change then
		presentation_loadout[slot_name] = item
		local player_profile = self._presentation_profile

		if player_profile then
			current_loadout[slot_name] = item
		end
	end
end

InventoryBackgroundView._equip_local_changes = function (self)
	local profile_loadout = self._presentation_profile.loadout
	local preview_loadout = self._preview_profile_equipped_items
	local original_equips = self._starting_profile_equipped_items
	local equip_items_by_slot = {}
	local equip_items = false

	for slot_name, item in pairs(preview_loadout) do
		local item_slot_settings = ItemSlotSettings[slot_name]

		if item_slot_settings and item_slot_settings.equipped_in_inventory then
			local previous_item = original_equips[slot_name]
			local unequip_item = not item and previous_item
			local valid_item_change = not unequip_item and item.gear_id and (not previous_item or previous_item.gear_id ~= item.gear_id)
			local slot_has_changes = unequip_item or valid_item_change

			if slot_has_changes then
				equip_items_by_slot[slot_name] = item
				profile_loadout[slot_name] = item
				self._player_spawned = false
				equip_items = true
			end
		end
	end

	if equip_items then
		return ItemUtils.equip_slot_items(equip_items_by_slot)
	end
end

InventoryBackgroundView._handle_back_pressed = function (self)
	self:_switch_active_view(nil)

	local view_name = "inventory_background_view"

	Managers.ui:close_view(view_name)
end

InventoryBackgroundView.cb_on_close_pressed = function (self)
	self:_handle_back_pressed()
end

InventoryBackgroundView.cb_on_weapon_swap_pressed = function (self)
	local slot_name = self._preview_wield_slot_id
	slot_name = slot_name == "slot_primary" and "slot_secondary" or "slot_primary"

	self:_set_preview_wield_slot_id(slot_name)
	self:_update_presentation_wield_item()
end

InventoryBackgroundView._update_has_empty_talents_groups = function (self)
	if self._is_readonly or not self._show_talents_tab then
		return
	end

	local profile = self._preview_player:profile()
	local profile_archetype = profile.archetype
	local specialization_name = profile.specialization
	local selected_talents = profile.talents
	local player_level = self._player_level
	self._has_empty_talent_groups = PlayerSpecializationUtils.has_empty_talent_groups(profile_archetype, specialization_name, player_level, selected_talents)
end

InventoryBackgroundView._setup_top_panel = function (self)
	local reference_name = "top_panel"
	local layer = 60
	self._top_panel = self:_add_element(ViewElementMenuPanel, reference_name, layer)
	local profile = self._presentation_profile
	local profile_archetype = profile.archetype
	local archetype_name = profile_archetype.name
	local is_ogryn = archetype_name == "ogryn"
	self._views_settings = {
		{
			view_name = "inventory_view",
			display_name = "loc_inventory_view_display_name",
			update = function (content, style, dt)
				local has_new_items_by_type = ItemUtils.has_new_items_by_type
				local ITEM_TYPES = UISettings.ITEM_TYPES
				local has_new_items = false

				if has_new_items_by_type(ITEM_TYPES.WEAPON_MELEE) then
					has_new_items = true
				elseif has_new_items_by_type(ITEM_TYPES.WEAPON_RANGED) then
					has_new_items = true
				elseif has_new_items_by_type(ITEM_TYPES.GADGET) then
					has_new_items = true
				end

				content.show_alert = has_new_items
			end,
			view_context = {
				tabs = {
					{
						is_grid_layout = false,
						ui_animation = "loadout_on_enter",
						allow_item_hover_information = true,
						camera_settings = {
							{
								"event_inventory_set_camera_position_axis_offset",
								"x",
								0,
								0.5,
								math.easeCubic
							},
							{
								"event_inventory_set_camera_position_axis_offset",
								"y",
								0,
								0.5,
								math.easeCubic
							},
							{
								"event_inventory_set_camera_position_axis_offset",
								"z",
								0,
								0.5,
								math.easeCubic
							},
							{
								"event_inventory_set_camera_rotation_axis_offset",
								"x",
								0,
								0.5,
								math.easeCubic
							},
							{
								"event_inventory_set_camera_rotation_axis_offset",
								"y",
								0,
								0.5,
								math.easeCubic
							},
							{
								"event_inventory_set_camera_rotation_axis_offset",
								"z",
								0,
								0.5,
								math.easeCubic
							}
						},
						layout = {
							{
								slot_title = "loc_inventory_title_slot_primary",
								loadout_slot = true,
								scenegraph_id = "slot_primary",
								default_icon = "content/ui/materials/icons/items/weapons/melee/empty",
								widget_type = "item_slot",
								slot = ItemSlotSettings.slot_primary,
								navigation_grid_indices = {
									1,
									1
								}
							},
							{
								slot_title = "loc_inventory_title_slot_secondary",
								loadout_slot = true,
								scenegraph_id = "slot_secondary",
								default_icon = "content/ui/materials/icons/items/weapons/ranged/empty",
								widget_type = "item_slot",
								slot = ItemSlotSettings.slot_secondary,
								navigation_grid_indices = {
									2,
									1
								}
							},
							{
								scenegraph_id = "slot_attachments_header",
								display_name = "loc_inventory_loadout_group_attachments",
								widget_type = "item_sub_header",
								item_type = UISettings.ITEM_TYPES.GADGET,
								size = {
									840,
									50
								},
								new_indicator_width_offset = {
									225,
									-10,
									4
								}
							},
							{
								slot_title = "loc_inventory_title_slot_attachment_1",
								loadout_slot = true,
								default_icon = "content/ui/materials/icons/items/attachments/defensive/empty",
								scenegraph_id = "slot_attachment_1",
								widget_type = "gadget_item_slot",
								slot = ItemSlotSettings.slot_attachment_1,
								required_level = PlayerProgressionUnlocks.gadget_slot_1,
								navigation_grid_indices = {
									3,
									1
								}
							},
							{
								slot_title = "loc_inventory_title_slot_attachment_2",
								loadout_slot = true,
								default_icon = "content/ui/materials/icons/items/attachments/tactical/empty",
								scenegraph_id = "slot_attachment_2",
								widget_type = "gadget_item_slot",
								slot = ItemSlotSettings.slot_attachment_2,
								required_level = PlayerProgressionUnlocks.gadget_slot_2,
								navigation_grid_indices = {
									3,
									2
								}
							},
							{
								slot_title = "loc_inventory_title_slot_attachment_3",
								loadout_slot = true,
								default_icon = "content/ui/materials/icons/items/attachments/utility/empty",
								scenegraph_id = "slot_attachment_3",
								widget_type = "gadget_item_slot",
								slot = ItemSlotSettings.slot_attachment_3,
								required_level = PlayerProgressionUnlocks.gadget_slot_3,
								navigation_grid_indices = {
									3,
									3
								}
							},
							{
								scenegraph_id = "slot_primary_header",
								display_name = "loc_inventory_loadout_group_primary_weapon",
								widget_type = "item_sub_header",
								item_type = UISettings.ITEM_TYPES.WEAPON_MELEE,
								size = {
									840,
									50
								},
								new_indicator_width_offset = {
									285,
									-10,
									4
								}
							},
							{
								scenegraph_id = "slot_secondary_header",
								display_name = "loc_inventory_loadout_group_secondary_weapon",
								widget_type = "item_sub_header",
								item_type = UISettings.ITEM_TYPES.WEAPON_RANGED,
								size = {
									840,
									50
								},
								new_indicator_width_offset = {
									256,
									-10,
									4
								}
							},
							{
								texture = "content/ui/materials/frames/loadout_main",
								scenegraph_id = "loadout_frame",
								widget_type = "texture",
								size = {
									840,
									840
								}
							},
							{
								texture = "content/ui/materials/backgrounds/terminal_basic",
								scenegraph_id = "loadout_background_1",
								widget_type = "texture",
								size = {
									640,
									380
								},
								color = Color.terminal_grid_background(nil, true)
							},
							{
								texture = "content/ui/materials/backgrounds/terminal_basic",
								scenegraph_id = "loadout_background_2",
								widget_type = "texture",
								size = {
									700,
									320
								},
								color = Color.terminal_grid_background(nil, true)
							}
						}
					}
				}
			}
		},
		{
			view_name = "inventory_view",
			display_name = "loc_cosmetics_view_display_name",
			update = function (content, style, dt)
				local has_new_items_by_type = ItemUtils.has_new_items_by_type
				local ITEM_TYPES = UISettings.ITEM_TYPES
				local has_new_items = false

				if has_new_items_by_type(ITEM_TYPES.GEAR_HEAD) then
					has_new_items = true
				elseif has_new_items_by_type(ITEM_TYPES.GEAR_UPPERBODY) then
					has_new_items = true
				elseif has_new_items_by_type(ITEM_TYPES.GEAR_LOWERBODY) then
					has_new_items = true
				elseif has_new_items_by_type(ITEM_TYPES.GEAR_EXTRA_COSMETIC) then
					has_new_items = true
				end

				content.show_alert = has_new_items
			end,
			view_context = {
				tabs = {
					{
						is_grid_layout = false,
						ui_animation = "cosmetics_on_enter",
						display_name = "tab1",
						allow_item_hover_information = true,
						icon = "content/ui/materials/icons/item_types/outfits",
						camera_settings = {
							{
								"event_inventory_set_camera_position_axis_offset",
								"x",
								is_ogryn and 1.2 or 0.85,
								0.5,
								math.easeCubic
							},
							{
								"event_inventory_set_camera_position_axis_offset",
								"y",
								0,
								0.5,
								math.easeCubic
							},
							{
								"event_inventory_set_camera_position_axis_offset",
								"z",
								0,
								0.5,
								math.easeCubic
							},
							{
								"event_inventory_set_camera_rotation_axis_offset",
								"x",
								0,
								0.5,
								math.easeCubic
							},
							{
								"event_inventory_set_camera_rotation_axis_offset",
								"y",
								0,
								0.5,
								math.easeCubic
							},
							{
								"event_inventory_set_camera_rotation_axis_offset",
								"z",
								0,
								0.5,
								math.easeCubic
							}
						},
						item_hover_information_offset = {
							657
						},
						layout = {
							{
								slot_icon = "content/ui/materials/icons/item_types/beveled/headgears",
								slot_title = "loc_inventory_title_slot_gear_head",
								loadout_slot = true,
								default_icon = "content/ui/materials/icons/items/gears/head/empty",
								scenegraph_id = "slot_gear_head",
								widget_type = "gear_item_slot",
								slot = ItemSlotSettings.slot_gear_head,
								navigation_grid_indices = {
									1,
									1
								}
							},
							{
								slot_icon = "content/ui/materials/icons/item_types/beveled/upper_bodies",
								slot_title = "loc_inventory_title_slot_gear_upperbody",
								loadout_slot = true,
								default_icon = "content/ui/materials/icons/items/gears/arms/empty",
								scenegraph_id = "slot_gear_upperbody",
								widget_type = "gear_item_slot",
								slot = ItemSlotSettings.slot_gear_upperbody,
								navigation_grid_indices = {
									2,
									1
								}
							},
							{
								slot_icon = "content/ui/materials/icons/item_types/beveled/lower_bodies",
								slot_title = "loc_inventory_title_slot_gear_lowerbody",
								loadout_slot = true,
								default_icon = "content/ui/materials/icons/items/gears/legs/empty",
								scenegraph_id = "slot_gear_lowerbody",
								widget_type = "gear_item_slot",
								slot = ItemSlotSettings.slot_gear_lowerbody,
								navigation_grid_indices = {
									3,
									1
								}
							},
							{
								slot_title = "loc_inventory_title_slot_gear_extra_cosmetic",
								scenegraph_id = "slot_gear_extra_cosmetic",
								loadout_slot = true,
								slot_icon = "content/ui/materials/icons/item_types/beveled/accessories",
								widget_type = "gear_item_slot",
								default_icon = "content/ui/materials/icons/items/gears/legs/empty",
								slot = ItemSlotSettings.slot_gear_extra_cosmetic,
								navigation_grid_indices = {
									1,
									2
								},
								initial_rotation = math.pi
							},
							{
								slot_title = "loc_inventory_title_slot_portrait_frame",
								loadout_slot = true,
								scenegraph_id = "slot_portrait_frame",
								default_icon = "content/ui/materials/icons/items/gears/legs/empty",
								widget_type = "ui_item_slot",
								slot = ItemSlotSettings.slot_portrait_frame,
								navigation_grid_indices = {
									2,
									2
								}
							},
							{
								slot_title = "loc_inventory_title_slot_insignia",
								loadout_slot = true,
								scenegraph_id = "slot_insignia",
								default_icon = "content/ui/materials/icons/items/gears/legs/empty",
								widget_type = "ui_item_slot",
								slot = ItemSlotSettings.slot_insignia,
								navigation_grid_indices = {
									3,
									2
								}
							},
							{
								scenegraph_id = "button_expressions",
								slot_title = "loc_inventory_title_slot_animation_end_of_round",
								display_name = "loc_inventory_title_slot_animation_end_of_round",
								loadout_slot = true,
								widget_type = "list_button_with_background",
								default_icon = "content/ui/materials/icons/items/gears/legs/empty",
								size = {
									500,
									60
								},
								slot = ItemSlotSettings.slot_animation_end_of_round,
								navigation_grid_indices = {
									4,
									2
								}
							}
						}
					}
				}
			}
		}
	}
	local player_level = self._player_level
	local show_talents_tab = PlayerSpecializationUtils.specialization_level_requirement() <= player_level

	if self._is_readonly or not self._is_own_player then
		show_talents_tab = show_talents_tab and profile.specialization ~= "none"
	end

	self._show_talents_tab = show_talents_tab

	if show_talents_tab then
		self:_update_has_empty_talents_groups()

		self._views_settings[#self._views_settings + 1] = {
			view_name = "talents_view",
			display_name = "loc_talents_view_display_name",
			update = function (content, style, dt)
				content.show_alert = self._has_empty_talent_groups
			end,
			view_context = {
				camera_settings = {
					{
						"event_inventory_set_camera_position_axis_offset",
						"x",
						is_ogryn and 5.2 or 3.5,
						0.5,
						math.easeCubic
					},
					{
						"event_inventory_set_camera_position_axis_offset",
						"y",
						0,
						0.5,
						math.easeCubic
					},
					{
						"event_inventory_set_camera_position_axis_offset",
						"z",
						0,
						0.5,
						math.easeCubic
					},
					{
						"event_inventory_set_camera_rotation_axis_offset",
						"x",
						0,
						0.5,
						math.easeCubic
					},
					{
						"event_inventory_set_camera_rotation_axis_offset",
						"y",
						0,
						0.5,
						math.easeCubic
					},
					{
						"event_inventory_set_camera_rotation_axis_offset",
						"z",
						0,
						0.5,
						math.easeCubic
					}
				}
			}
		}
	end

	local views_settings = self._views_settings

	for i = 1, #views_settings do
		local settings = views_settings[i]
		local view_name = settings.view_name
		local display_name_loc_key = settings.display_name

		if not display_name_loc_key then
			local view_settings = Views[view_name]
			display_name_loc_key = view_settings.display_name
		end

		local display_name = self:_localize(display_name_loc_key)

		local function entry_callback_function()
			self:_on_panel_option_pressed(i)
		end

		local optional_update_function = settings.update
		local cb = callback(entry_callback_function)

		self._top_panel:add_entry(display_name, cb, optional_update_function)
	end

	self._top_panel:set_is_handling_navigation_input(true)
end

InventoryBackgroundView._on_panel_option_pressed = function (self, index)
	local old_top_panel_selection_index = self._top_panel:selected_index()

	if index == old_top_panel_selection_index then
		return
	end

	local views_settings = self._views_settings
	local settings = views_settings[index]
	local view_name = settings.view_name

	if settings.resolve_function then
		view_name = settings.resolve_function() or view_name
	end

	local view_context = settings.view_context

	self:_switch_active_view(view_name, view_context)

	if index ~= old_top_panel_selection_index and not index then
		if self._active_view and Managers.ui:view_active(self._active_view) then
			Managers.ui:close_view(self._active_view)
		end

		self._active_view = nil
		self._active_view_context = nil
	end
end

InventoryBackgroundView._force_select_panel_index = function (self, index)
	self:_on_panel_option_pressed(index)
	self._top_panel:set_selected_panel_index(index)
end

InventoryBackgroundView._switch_active_view = function (self, view_name, additional_context_data)
	if view_name then
		local active_view = self._active_view

		if active_view == view_name then
			if additional_context_data then
				self._active_view_context.changeable_context = additional_context_data
			end
		elseif view_name ~= active_view then
			if active_view and Managers.ui:view_active(active_view) then
				Managers.ui:close_view(active_view)
			end

			local context = {
				parent = self,
				player = self._preview_player,
				player_level = self._player_level,
				preview_profile_equipped_items = self._preview_profile_equipped_items,
				current_profile_equipped_items = self._current_profile_equipped_items,
				changeable_context = additional_context_data,
				is_readonly = self._is_readonly
			}
			self._active_view = view_name
			self._active_view_context = context

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
		end
	end
end

InventoryBackgroundView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 60)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

InventoryBackgroundView._load_profile = function (self, profile)
	if self._loading_profile then
		self._loading_profile_loader:destroy()

		self._loading_profile_loader = nil
		self._loading_profile = nil
	end

	self._item_definitions = MasterItems.get_cached()
	self._profile_loader_index = (self._profile_loader_index or 0) + 1
	local reference_name = self.__class_name .. "_profile_loader_" .. tostring(self._profile_loader_index)
	local character_profile_loader = UICharacterProfilePackageLoader:new(reference_name, self._item_definitions)

	character_profile_loader:load_profile(profile)

	self._loading_profile = profile
	self._loading_profile_loader = character_profile_loader
	local profile_archetype = profile.archetype
	local archetype_name = profile_archetype.name
	local is_ogryn = archetype_name == "ogryn"
	local camera_position_default_offset = self._camera_position_default_offset
	camera_position_default_offset[1] = is_ogryn and 0 or 0
	camera_position_default_offset[2] = is_ogryn and -1.5 or 0
	camera_position_default_offset[3] = is_ogryn and 0.5 or 0
end

InventoryBackgroundView._setup_background_world = function (self)
	local player = self._preview_player
	local player_profile = player:profile()
	local archetype = player_profile.archetype
	local breed_name = archetype.breed
	local default_camera_event_id = "event_register_inventory_default_camera_" .. breed_name

	self[default_camera_event_id] = function (self, camera_unit)
		if self._context then
			self._context.camera_unit = camera_unit
		end

		self._default_camera_unit = camera_unit
		local viewport_name = InventoryBackgroundViewSettings.viewport_name
		local viewport_type = InventoryBackgroundViewSettings.viewport_type
		local viewport_layer = InventoryBackgroundViewSettings.viewport_layer
		local shading_environment = InventoryBackgroundViewSettings.shading_environment

		self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
		self:_unregister_event(default_camera_event_id)
	end

	self:_register_event(default_camera_event_id)

	self._item_camera_by_slot_id = {}

	for slot_name, slot in pairs(ItemSlotSettings) do
		if slot.slot_type == "gear" then
			local item_camera_event_id = "event_register_inventory_item_camera_" .. breed_name .. "_" .. slot_name

			self[item_camera_event_id] = function (self, camera_unit)
				self._item_camera_by_slot_id[slot_name] = camera_unit

				self:_unregister_event(item_camera_event_id)
			end

			self:_register_event(item_camera_event_id)
		end
	end

	self:_register_event("event_register_character_spawn_point")

	local world_name = InventoryBackgroundViewSettings.world_name
	local world_layer = InventoryBackgroundViewSettings.world_layer
	local world_timer_name = InventoryBackgroundViewSettings.timer_name
	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)
	local level_name = InventoryBackgroundViewSettings.level_name

	self._world_spawner:spawn_level(level_name)
	self:_register_event("event_inventory_set_camera_position_axis_offset")
	self:_register_event("event_inventory_set_camera_rotation_axis_offset")
	self:_register_event("event_inventory_set_camera_item_slot_focus")
	self:_register_event("event_inventory_set_camera_node_focus")
	self:_update_viewport_resolution()
end

InventoryBackgroundView.world_spawner = function (self)
	return self._world_spawner
end

InventoryBackgroundView.spawn_point_unit = function (self)
	return self._spawn_point_unit
end

InventoryBackgroundView.on_resolution_modified = function (self)
	InventoryBackgroundView.super.on_resolution_modified(self)

	if self._world_spawner then
		self:_update_viewport_resolution()
	end
end

InventoryBackgroundView._update_viewport_resolution = function (self)
	self:_force_update_scenegraph()

	local scale = self._render_scale
	local scenegraph = self._ui_scenegraph
	local id = "screen"
	local x_scale, y_scale, w_scale, h_scale = UIScenegraph.get_scenegraph_id_screen_scale(scenegraph, id, scale)

	self._world_spawner:set_viewport_size(w_scale, h_scale)
	self._world_spawner:set_viewport_position(x_scale, y_scale)
end

InventoryBackgroundView.event_register_character_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_character_spawn_point")

	self._spawn_point_unit = spawn_point_unit

	if self._context then
		self._context.spawn_point_unit = spawn_point_unit
	end
end

InventoryBackgroundView.event_inventory_set_camera_item_slot_focus = function (self, slot_name, time, func_ptr)
	local world_spawner = self._world_spawner
	local slot_camera = self._item_camera_by_slot_id[slot_name] or self._default_camera_unit
	local camera_world_position = Unit.world_position(slot_camera, 1)
	local camera_world_rotation = Unit.world_rotation(slot_camera, 1)
	local boxed_camera_start_position = world_spawner:boxed_camera_start_position()
	local default_camera_world_position = Vector3.from_array(boxed_camera_start_position)

	world_spawner:set_camera_position_axis_offset("x", camera_world_position.x - default_camera_world_position.x, time, func_ptr)
	world_spawner:set_camera_position_axis_offset("y", camera_world_position.y - default_camera_world_position.y, time, func_ptr)
	world_spawner:set_camera_position_axis_offset("z", camera_world_position.z - default_camera_world_position.z, time, func_ptr)

	local boxed_camera_start_rotation = world_spawner:boxed_camera_start_rotation()
	local default_camera_world_rotation = boxed_camera_start_rotation:unbox()
	local default_camera_world_rotation_x, default_camera_world_rotation_y, default_camera_world_rotation_z = Quaternion.to_euler_angles_xyz(default_camera_world_rotation)
	local camera_world_rotation_x, camera_world_rotation_y, camera_world_rotation_z = Quaternion.to_euler_angles_xyz(camera_world_rotation)

	world_spawner:set_camera_rotation_axis_offset("x", camera_world_rotation_x - default_camera_world_rotation_x, time, func_ptr)
	world_spawner:set_camera_rotation_axis_offset("y", camera_world_rotation_y - default_camera_world_rotation_y, time, func_ptr)
	world_spawner:set_camera_rotation_axis_offset("z", camera_world_rotation_z - default_camera_world_rotation_z, time, func_ptr)
end

InventoryBackgroundView.event_inventory_set_camera_node_focus = function (self, node_name, time, func_ptr)
	if node_name then
		local profile_spawner = self._profile_spawner
		local world_spawner = self._world_spawner
		local base_world_position = profile_spawner:node_world_position(1)
		local node_world_position = profile_spawner:node_world_position(node_name)
		local target_position = node_world_position - base_world_position

		world_spawner:set_camera_position_axis_offset("x", target_position.x, time, func_ptr)
		world_spawner:set_camera_position_axis_offset("y", target_position.y, time, func_ptr)
		world_spawner:set_camera_position_axis_offset("z", target_position.z, time, func_ptr)
	end
end

InventoryBackgroundView.event_inventory_set_camera_rotation_axis_offset = function (self, axis, value, animation_time, func_ptr)
	self._world_spawner:set_camera_rotation_axis_offset(axis, value, animation_time, func_ptr)
end

InventoryBackgroundView.event_inventory_set_camera_position_axis_offset = function (self, axis, value, animation_time, func_ptr)
	self._world_spawner:set_camera_position_axis_offset(axis, value, animation_time, func_ptr)
end

InventoryBackgroundView.on_exit = function (self)
	self:_unload_portrait_icon()
	self:_unload_portrait_frame(self._ui_renderer)
	self:_unload_insignia(self._ui_renderer)
	Managers.data_service.talents:release_icons(self._talent_icons_package_id)

	if self._active_view then
		if Managers.ui:view_active(self._active_view) then
			Managers.ui:close_view(self._active_view)
		end

		self._active_view = nil
		self._active_view_context = nil
	end

	if self._ui_weapon_spawner then
		self._ui_weapon_spawner:destroy()

		self._ui_weapon_spawner = nil
	end

	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	InventoryBackgroundView.super.on_exit(self)
	self:_equip_local_changes()
end

InventoryBackgroundView._handle_input = function (self, input_service)
	return
end

InventoryBackgroundView.update = function (self, dt, t, input_service)
	self:_update_experience_bar_fill_animation(dt)

	if not self._player_spawned and self._spawn_point_unit and self._default_camera_unit then
		local profile = self._presentation_profile

		self:_spawn_profile(profile)

		self._player_spawned = true
	end

	local profile = self._presentation_profile
	local loadout = profile and profile.loadout

	if loadout then
		local frame_item = loadout.slot_portrait_frame
		local frame_item_gear_id = frame_item and frame_item.gear_id

		if frame_item_gear_id ~= self._frame_item_gear_id then
			self._frame_item_gear_id = frame_item_gear_id

			self:_request_player_frame(frame_item, self._ui_renderer)
		end

		local insignia_item = loadout.slot_insignia
		local insignia_item_gear_id = insignia_item and insignia_item.gear_id

		if insignia_item_gear_id ~= self._insignia_item_gear_id then
			self._insignia_item_gear_id = insignia_item_gear_id

			self:_request_player_insignia(insignia_item)
		end
	end

	local profile_spawner = self._profile_spawner

	if profile_spawner then
		profile_spawner:update(dt, t, input_service)
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	self:_check_profile_changes()

	return InventoryBackgroundView.super.update(self, dt, t, input_service)
end

InventoryBackgroundView._check_profile_changes = function (self)
	local profile = self._preview_player:profile()
	local loadout = self._current_profile_equipped_items
	local presentation_loadout = self._preview_profile_equipped_items

	for slot_name, item in pairs(loadout) do
		local item_slot_settings = ItemSlotSettings[slot_name]
		local loadout_item = presentation_loadout[slot_name]

		if item_slot_settings.equipped_in_inventory and loadout_item.gear_id ~= item.gear_id then
			if not self._is_own_player then
				self._presentation_profile = table.clone_instance(profile)

				self:_update_equipped_items()

				self._player_spawned = false
			end

			break
		end
	end
end

InventoryBackgroundView._spawn_profile = function (self, profile)
	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	local world = self._world_spawner:world()
	local camera = self._world_spawner:camera()
	local unit_spawner = self._world_spawner:unit_spawner()
	self._profile_spawner = UIProfileSpawner:new("InventoryBackgroundView", world, camera, unit_spawner)
	local ignored_slots = InventoryBackgroundViewSettings.ignored_slots

	for i = 1, #ignored_slots do
		local slot_name = ignored_slots[i]

		self._profile_spawner:ignore_slot(slot_name)
	end

	local camera_position = ScriptCamera.position(camera)
	local spawn_position = Unit.world_position(self._spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(self._spawn_point_unit, 1)
	camera_position.z = 0
	local selected_archetype = profile.archetype
	local archetype_name = selected_archetype.name
	local breed_name = selected_archetype and selected_archetype.breed or profile.breed
	local breed_settings = Breeds[breed_name]
	local inventory_state_machine = breed_settings.inventory_state_machine

	self._profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation, nil, inventory_state_machine)

	local animation_duration = 0.01
	self._spawned_profile = profile

	self:_update_presentation_wield_item()
end

InventoryBackgroundView._set_preview_wield_slot_id = function (self, slot_id)
	self._preview_wield_slot_id = slot_id
end

InventoryBackgroundView._update_presentation_wield_item = function (self)
	if not self._profile_spawner then
		return
	end

	local slot_id = self._preview_wield_slot_id
	local preview_profile_equipped_items = self._preview_profile_equipped_items
	local presentation_inventory = preview_profile_equipped_items
	local slot_item = presentation_inventory[slot_id]

	self._profile_spawner:wield_slot(slot_id)

	local item_inventory_animation_event = slot_item and slot_item.inventory_animation_event or "inventory_idle_default"

	if item_inventory_animation_event then
		self._profile_spawner:assign_animation_event(item_inventory_animation_event)
	end
end

InventoryBackgroundView.start_present_item = function (self, item)
	if self._ui_weapon_spawner then
		self._ui_weapon_spawner:destroy()

		self._ui_weapon_spawner = nil
	end

	local world_spawner = self._world_spawner
	local world = world_spawner:world()
	local camera = world_spawner:camera()
	local unit_spawner = world_spawner:unit_spawner()
	local spawn_position = self:_get_spawn_position()
	local spawn_rotation = Quaternion.axis_angle(Vector3.up(), math.pi / 2)
	local previewer_reference_name = self._reference_name
	local ui_weapon_spawner = UIWeaponSpawner:new(previewer_reference_name, world, camera, unit_spawner)

	ui_weapon_spawner:start_presentation(item, spawn_position, spawn_rotation)

	local ignore_spin_randomness = true

	ui_weapon_spawner:activate_auto_spin(ignore_spin_randomness)

	self._ui_weapon_spawner = ui_weapon_spawner
end

InventoryBackgroundView.stop_presenting_current_item = function (self)
	if self._ui_weapon_spawner then
		self._ui_weapon_spawner:destroy()

		self._ui_weapon_spawner = nil
	end
end

InventoryBackgroundView.set_item_position = function (self, position)
	if self._ui_weapon_spawner then
		self._ui_weapon_spawner:set_position(position)
	end
end

return InventoryBackgroundView
