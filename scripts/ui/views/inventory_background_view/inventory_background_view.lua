local Breeds = require("scripts/settings/breed/breeds")
local Definitions = require("scripts/ui/views/inventory_background_view/inventory_background_view_definitions")
local InventoryBackgroundViewSettings = require("scripts/ui/views/inventory_background_view/inventory_background_view_settings")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local PlayerProgressionUnlocks = require("scripts/settings/player/player_progression_unlocks")
local ProfileUtils = require("scripts/utilities/profile_utils")
local Promise = require("scripts/foundation/utilities/promise")
local ScriptCamera = require("scripts/foundation/utilities/script_camera")
local UICharacterProfilePackageLoader = require("scripts/managers/ui/ui_character_profile_package_loader")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWeaponSpawner = require("scripts/managers/ui/ui_weapon_spawner")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementMenuPanel = require("scripts/ui/view_elements/view_element_menu_panel/view_element_menu_panel")
local ViewElementProfilePresets = require("scripts/ui/view_elements/view_element_profile_presets/view_element_profile_presets")
local Views = require("scripts/ui/views/views")
local InventoryBackgroundView = class("InventoryBackgroundView", "BaseView")

InventoryBackgroundView.init = function (self, settings, context)
	self._context = context
	self.show_locked_cosmetics = true
	local player = context and context.player or self:_player()
	self._preview_player = player
	self._is_own_player = self._preview_player == self:_player()
	self._is_readonly = context and context.is_readonly
	local profile = self._preview_player:profile()
	self._player_level = profile.current_level
	self._inventory_items = {}
	self._new_items_gear_ids = {}
	self._new_items_gear_ids_by_type = {}
	self._invalid_slots = {}
	self._modified_slots = {}
	self._duplicated_slots = {}
	self._inventory_synced = false

	self:_fetch_inventory_items()
	InventoryBackgroundView.super.init(self, Definitions, settings, context)

	self._pass_draw = false
end

InventoryBackgroundView.on_enter = function (self)
	InventoryBackgroundView.super.on_enter(self)

	local context = self._context
	local player = self._preview_player
	local profile = player:profile()
	local player_unit = player.player_unit
	local unit_data = ScriptUnit.has_extension(player_unit, "unit_data_system")
	local inventory_component = unit_data and unit_data:read_component("inventory")
	local wielded_slot = inventory_component and inventory_component.wielded_slot ~= "slot_unarmed" and inventory_component.wielded_slot or "slot_primary"

	self:_set_preview_wield_slot_id(wielded_slot)

	self._show_talents_tab = false
	self._has_empty_talent_nodes = false

	self:_register_event("event_inventory_view_equip_item", "event_inventory_view_equip_item")
	self:_register_event("event_equip_local_changes", "event_equip_local_changes")
	self:_register_event("event_change_wield_slot", "event_change_wield_slot")
	self:_register_event("event_discard_item", "event_discard_item")
	self:_register_event("event_player_profile_updated", "event_player_profile_updated")
	self:_register_event("event_player_talent_node_updated", "event_player_talent_node_updated")
	self:_register_event("event_item_icon_updated", "event_item_icon_updated")
	self:_setup_input_legend()
	self:_setup_background_world()

	local profile_archetype = profile.archetype
	local archetype_name = profile_archetype.name

	self:_setup_background_frames_by_archetype(archetype_name)

	local talent_layout_file_path = profile_archetype and profile_archetype.talent_layout_file_path
	self._active_talent_loadout = talent_layout_file_path and require(talent_layout_file_path)
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
	local character_archetype_title = ProfileUtils.character_archetype_title(profile)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.character_name.content.text = character_name
	widgets_by_name.character_archetype_title.content.text = character_archetype_title
	widgets_by_name.character_level.content.text = tostring(current_level)
	widgets_by_name.character_level_next.content.text = ""

	self:_set_experience_bar(0, 0)
	self:_fetch_character_progression(player)
	self:_request_player_icon()
end

InventoryBackgroundView._set_player_profile_title = function (self, profile)
	local scenegraph_definition = self._definitions.scenegraph_definition
	local player_title = ProfileUtils.character_title(profile)

	if not player_title or player_title == "" then
		local character_name_pos = scenegraph_definition.character_name_no_title.position

		self:_set_scenegraph_position("character_name", character_name_pos[1], character_name_pos[2], character_name_pos[3])

		local character_archetype_title_pos = scenegraph_definition.character_archetype_title_no_title.position

		self:_set_scenegraph_position("character_archetype_title", character_archetype_title_pos[1], character_archetype_title_pos[2], character_archetype_title_pos[3])
	else
		local character_name_pos = scenegraph_definition.character_name.position

		self:_set_scenegraph_position("character_name", character_name_pos[1], character_name_pos[2], character_name_pos[3])

		local character_archetype_title_pos = scenegraph_definition.character_archetype_title.position

		self:_set_scenegraph_position("character_archetype_title", character_archetype_title_pos[1], character_archetype_title_pos[2], character_archetype_title_pos[3])
	end

	if player_title then
		local widgets_by_name = self._widgets_by_name
		widgets_by_name.character_title.content.text = player_title
	end
end

InventoryBackgroundView._request_player_icon = function (self)
	local material_values = self._widgets_by_name.character_portrait.style.texture_portrait.material_values
	material_values.use_placeholder_texture = 1

	self:_load_portrait_icon()
end

InventoryBackgroundView._load_portrait_icon = function (self)
	local profile = self._presentation_profile
	local load_cb = callback(self, "_cb_set_player_icon")
	local unload_cb = callback(self, "_cb_unset_player_icon")
	local icon_load_id = Managers.ui:load_profile_portrait(profile, load_cb, nil, unload_cb)
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
	local widget = self._widgets_by_name.character_portrait
	widget.content.texture = "content/ui/materials/base/ui_portrait_frame_base"
	local material_values = widget.style.texture_portrait.material_values
	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.texture_icon = render_target
end

InventoryBackgroundView._cb_unset_player_icon = function (self, widget)
	local widget = self._widgets_by_name.character_portrait
	local material_values = widget.style.texture_portrait.material_values
	material_values.use_placeholder_texture = nil
	material_values.rows = nil
	material_values.columns = nil
	material_values.grid_index = nil
	material_values.texture_icon = nil
	widget.content.texture = "content/ui/materials/base/ui_portrait_frame_base_no_render"
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
		local material_values = widget.style.texture_portrait.material_values
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
	local icon = nil

	if item.icon then
		icon = item.icon
	else
		icon = "content/ui/textures/nameplates/portrait_frames/default"
	end

	local widget = self._widgets_by_name.character_portrait
	local material_values = widget.style.texture_portrait.material_values
	material_values.portrait_frame_texture = icon
end

InventoryBackgroundView._request_player_insignia = function (self, item, ui_renderer)
	self:_unload_insignia(ui_renderer)
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
		widget.content.icon = "content/ui/materials/base/ui_default_base"
		local material_values = widget.style.texture_insignia.material_values
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
	local widget = self._widgets_by_name.character_insigna
	local profile = self._presentation_profile
	local loadout = profile and profile.loadout
	local icon_style = widget.style.texture_insignia
	local material_values = icon_style.material_values

	if item.icon_material and item.icon_material ~= "" then
		widget.content.texture_insignia = item.icon_material
		material_values.texture_map = nil
		material_values.use_placeholder_texture = 0
		material_values.use_render_target = 0
		widget.content.use_placeholder_texture = material_values.use_placeholder_texture
	else
		material_values.texture_map = item.icon
		widget.content.use_placeholder_texture = material_values.use_placeholder_texture
	end

	material_values.use_placeholder_texture = 0
	material_values.use_render_target = 0
	widget.content.visible = (item.icon or item.icon_material) and true or false
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
	self:_update_loadout_validation()
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
	local local_changes_promise = self:_equip_local_changes()
	local delete_promise = nil

	if local_changes_promise then
		delete_promise = local_changes_promise:next(function ()
			return Managers.data_service.gear:delete_gear(gear_id)
		end)
	else
		delete_promise = Managers.data_service.gear:delete_gear(gear_id)
	end

	delete_promise:next(function (result)
		self._inventory_items[gear_id] = nil
		local rewards = result and result.rewards

		if rewards then
			local credits_amount = rewards[1] and rewards[1].amount or 0

			Managers.event:trigger("event_force_wallet_update")
			Managers.event:trigger("event_add_notification_message", "currency", {
				currency = "credits",
				amount = credits_amount
			})
		end

		self:_update_loadout_validation()
	end)
end

InventoryBackgroundView.event_player_talent_node_updated = function (self, equipped_talents)
	self:_update_has_empty_talent_nodes(equipped_talents)

	self._current_profile_equipped_talents = equipped_talents

	self:_update_presets_missing_warning_marker()
end

InventoryBackgroundView.event_player_profile_updated = function (self)
	self:_update_has_empty_talent_nodes()
end

InventoryBackgroundView.event_item_icon_updated = function (self, item)
	local presentation_loadout = self._preview_profile_equipped_items

	for slot_name, slot_item in pairs(presentation_loadout) do
		if slot_item and item and slot_item.gear_id == item.gear_id then
			local force_update = true

			self:_equip_slot_item(slot_name, item, force_update)
			self:_update_loadout_validation()

			break
		end
	end
end

InventoryBackgroundView._equip_slot_item = function (self, slot_name, item, force_update)
	local presentation_loadout = self._preview_profile_equipped_items
	local current_loadout = self._current_profile_equipped_items
	local previous_item = current_loadout[slot_name]
	local item_gear_id = type(item) == "table" and item.gear_id or type(item) == "string" and item
	local previous_item_gear_id = type(previous_item) == "table" and previous_item.gear_id or type(previous_item) == "string" and previous_item
	local valid_item_change = item_gear_id and previous_item_gear_id and item_gear_id ~= previous_item_gear_id or type(item) == "table" and item.always_owned and type(previous_item) == "table" and item.name ~= previous_item.name or (item_gear_id or type(item) == "table" and item.always_owned) and not previous_item_gear_id or type(previous_item) == "table" and not item or force_update

	if valid_item_change then
		presentation_loadout[slot_name] = item
		local player_profile = self._presentation_profile

		if player_profile then
			current_loadout[slot_name] = item
		end
	end
end

InventoryBackgroundView._equip_local_changes = function (self)
	if not self._is_own_player or self._is_readonly then
		return
	end

	local profile_loadout = self._presentation_profile.loadout
	local preview_loadout = self._preview_profile_equipped_items
	local original_equips = self._starting_profile_equipped_items
	local equip_items_by_slot = {}
	local equip_local_items_by_slot = {}
	local unequip_slots = {}
	local equip_items = false

	for slot_name, slot_data in pairs(ItemSlotSettings) do
		if slot_data.equipped_in_inventory and not self._invalid_slots[slot_name] and not self._duplicated_slots[slot_name] then
			local previous_item = original_equips[slot_name]
			local item = preview_loadout[slot_name]
			local item_gear_id = type(item) == "table" and item.gear_id or type(item) == "string" and item
			local previous_item_gear_id = type(previous_item) == "table" and previous_item.gear_id or type(previous_item) == "string" and previous_item
			local valid_item_change = item_gear_id and previous_item_gear_id and item_gear_id ~= previous_item_gear_id or type(item) == "table" and item.always_owned and type(previous_item) == "table" and item.name ~= previous_item.name or (item_gear_id or type(item) == "table" and item.always_owned) and not previous_item_gear_id or type(previous_item) == "table" and not not not item

			if valid_item_change then
				if item then
					if item.always_owned then
						equip_local_items_by_slot[slot_name] = item
					else
						local valid_item = self:_get_inventory_item_by_id(item.gear_id)

						if valid_item then
							equip_items_by_slot[slot_name] = item
						end
					end
				else
					unequip_slots[slot_name] = true
				end

				profile_loadout[slot_name] = item
				self._player_spawned = false
				equip_items = true
			end
		end
	end

	local promises = {}

	if equip_items and not table.is_empty(equip_items_by_slot) then
		promises[#promises + 1] = ItemUtils.equip_slot_items(equip_items_by_slot)
	end

	if equip_items and not table.is_empty(equip_local_items_by_slot) then
		promises[#promises + 1] = ItemUtils.equip_slot_master_items(equip_local_items_by_slot)
	end

	if equip_items and not table.is_empty(unequip_slots) then
		promises[#promises + 1] = ItemUtils.unequip_slots(unequip_slots)
	end

	if #promises > 0 then
		return Promise.all(unpack(promises))
	end
end

InventoryBackgroundView._handle_back_pressed = function (self)
	self:_switch_active_view(nil)

	local view_name = "inventory_background_view"

	Managers.ui:close_view(view_name)
end

InventoryBackgroundView.cb_on_close_pressed = function (self)
	if self:can_exit() then
		self:_handle_back_pressed()
	end
end

InventoryBackgroundView.cb_on_clear_all_talents_pressed = function (self)
	local active_view = self._active_view
	local view_instance = Managers.ui:view_instance(active_view)

	view_instance:cb_on_clear_all_talents_pressed()
end

InventoryBackgroundView.cb_on_item_stats_toggled = function (self)
	local active_view = self._active_view
	local view_instance = Managers.ui:view_instance(active_view)
	local do_save = true

	view_instance:on_item_stats_toggled(nil, do_save)
end

InventoryBackgroundView.is_item_stats_toggled = function (self)
	local active_view = self._active_view
	local view_instance = Managers.ui:view_instance(active_view)

	return view_instance and view_instance.is_item_stats_toggled and view_instance:is_item_stats_toggled() or false
end

InventoryBackgroundView.cb_on_weapon_swap_pressed = function (self)
	local slot_name = self._preview_wield_slot_id
	slot_name = slot_name == "slot_primary" and "slot_secondary" or "slot_primary"

	self:_play_sound(UISoundEvents.weapons_swap)
	self:_set_preview_wield_slot_id(slot_name)
	self:_update_presentation_wield_item()
end

InventoryBackgroundView.has_new_items_by_type = function (self, item_type)
	return self._new_items_gear_ids_by_type[item_type] and not not not table.is_empty(self._new_items_gear_ids_by_type[item_type])
end

InventoryBackgroundView._update_has_empty_talent_nodes = function (self, optional_selected_nodes)
	local has_empty_talent_nodes = false
	local player = self:_player()
	local profile = player:profile()

	if profile then
		local talent_points = profile.talent_points or 0
		local points_spent = 0

		for widget_name, points_spent_on_node in pairs(optional_selected_nodes or profile.selected_nodes) do
			points_spent = points_spent + points_spent_on_node
		end

		if points_spent < talent_points then
			has_empty_talent_nodes = true
		end
	end

	self._has_empty_talent_nodes = has_empty_talent_nodes
end

InventoryBackgroundView._setup_top_panel = function (self)
	local reference_name = "top_panel"
	local layer = 90
	self._top_panel = self:_add_element(ViewElementMenuPanel, reference_name, layer)
	local player = self._preview_player
	local profile = player:profile()
	local profile_archetype = profile.archetype
	local archetype_name = profile_archetype.name
	local is_ogryn = archetype_name == "ogryn"
	self._views_settings = {
		{
			view_name = "inventory_view",
			display_name = "loc_inventory_view_display_name",
			update = function (content, style, dt)
				content.hotspot.disabled = not self:is_inventory_synced()

				if not self._is_own_player or self._is_readonly then
					return false
				end

				local ITEM_TYPES = UISettings.ITEM_TYPES
				local has_new_items = false

				if self:has_new_items_by_type(ITEM_TYPES.WEAPON_MELEE) then
					has_new_items = true
				elseif self:has_new_items_by_type(ITEM_TYPES.WEAPON_RANGED) then
					has_new_items = true
				elseif self:has_new_items_by_type(ITEM_TYPES.GADGET) then
					has_new_items = true
				end

				content.show_alert = has_new_items
			end,
			view_context = {
				tabs = {
					{
						ui_animation = "loadout_on_enter",
						is_grid_layout = false,
						allow_item_hover_information = true,
						draw_wallet = self._is_own_player and not self._is_readonly,
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
								scenegraph_id = "slot_primary",
								loadout_slot = true,
								widget_type = "item_slot",
								default_icon = "content/ui/materials/icons/items/weapons/melee/empty",
								slot = ItemSlotSettings.slot_primary,
								navigation_grid_indices = {
									1,
									1
								},
								item_type = UISettings.ITEM_TYPES.WEAPON_MELEE,
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
							},
							{
								slot_title = "loc_inventory_title_slot_secondary",
								scenegraph_id = "slot_secondary",
								loadout_slot = true,
								widget_type = "item_slot",
								default_icon = "content/ui/materials/icons/items/weapons/ranged/empty",
								slot = ItemSlotSettings.slot_secondary,
								navigation_grid_indices = {
									2,
									1
								},
								item_type = UISettings.ITEM_TYPES.WEAPON_RANGED,
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
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
									183,
									-20,
									4
								},
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
							},
							{
								scenegraph_id = "slot_attachment_1",
								loadout_slot = true,
								slot_title = "loc_inventory_title_slot_attachment_1",
								widget_type = "gadget_item_slot",
								default_icon = "content/ui/materials/icons/items/attachments/defensive/empty",
								slot = ItemSlotSettings.slot_attachment_1,
								required_level = PlayerProgressionUnlocks.gadget_slot_1,
								navigation_grid_indices = {
									3,
									1
								},
								item_type = UISettings.ITEM_TYPES.GADGET,
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
							},
							{
								scenegraph_id = "slot_attachment_2",
								loadout_slot = true,
								slot_title = "loc_inventory_title_slot_attachment_2",
								widget_type = "gadget_item_slot",
								default_icon = "content/ui/materials/icons/items/attachments/tactical/empty",
								slot = ItemSlotSettings.slot_attachment_2,
								required_level = PlayerProgressionUnlocks.gadget_slot_2,
								navigation_grid_indices = {
									3,
									2
								},
								item_type = UISettings.ITEM_TYPES.GADGET,
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
							},
							{
								scenegraph_id = "slot_attachment_3",
								loadout_slot = true,
								slot_title = "loc_inventory_title_slot_attachment_3",
								widget_type = "gadget_item_slot",
								default_icon = "content/ui/materials/icons/items/attachments/utility/empty",
								slot = ItemSlotSettings.slot_attachment_3,
								required_level = PlayerProgressionUnlocks.gadget_slot_3,
								navigation_grid_indices = {
									3,
									3
								},
								item_type = UISettings.ITEM_TYPES.GADGET,
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
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
									243,
									-22,
									4
								},
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
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
									211,
									-20,
									4
								},
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
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
				content.hotspot.disabled = not self:is_inventory_synced()

				if not self._is_own_player or self._is_readonly then
					return false
				end

				local ITEM_TYPES = UISettings.ITEM_TYPES
				local has_new_items = false

				if self:has_new_items_by_type(ITEM_TYPES.GEAR_HEAD) then
					has_new_items = true
				elseif self:has_new_items_by_type(ITEM_TYPES.GEAR_UPPERBODY) then
					has_new_items = true
				elseif self:has_new_items_by_type(ITEM_TYPES.GEAR_LOWERBODY) then
					has_new_items = true
				elseif self:has_new_items_by_type(ITEM_TYPES.GEAR_EXTRA_COSMETIC) then
					has_new_items = true
				end

				content.show_alert = has_new_items
			end,
			view_context = {
				tabs = {
					{
						ui_animation = "cosmetics_on_enter",
						display_name = "tab1",
						draw_wallet = false,
						allow_item_hover_information = true,
						icon = "content/ui/materials/icons/item_types/outfits",
						is_grid_layout = false,
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
							0
						},
						layout = {
							{
								slot_title = "loc_inventory_title_slot_character_title",
								scenegraph_id = "slot_character_title",
								loadout_slot = true,
								slot_icon = "content/ui/materials/icons/item_types/beveled/headgears",
								widget_type = "character_title_item_slot",
								default_icon = "content/ui/materials/icons/items/gears/head/empty",
								slot = ItemSlotSettings.slot_character_title,
								navigation_grid_indices = {
									4,
									1
								},
								item_type = UISettings.ITEM_TYPES.CHARACTER_TITLE,
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
							},
							{
								slot_title = "loc_inventory_title_slot_gear_head",
								scenegraph_id = "slot_gear_head",
								loadout_slot = true,
								slot_icon = "content/ui/materials/icons/item_types/beveled/headgears",
								widget_type = "gear_item_slot",
								default_icon = "content/ui/materials/icons/items/gears/head/empty",
								slot = ItemSlotSettings.slot_gear_head,
								navigation_grid_indices = {
									1,
									1
								},
								item_type = UISettings.ITEM_TYPES.GEAR_HEAD,
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
							},
							{
								slot_title = "loc_inventory_title_slot_gear_upperbody",
								scenegraph_id = "slot_gear_upperbody",
								loadout_slot = true,
								slot_icon = "content/ui/materials/icons/item_types/beveled/upper_bodies",
								widget_type = "gear_item_slot",
								default_icon = "content/ui/materials/icons/items/gears/arms/empty",
								slot = ItemSlotSettings.slot_gear_upperbody,
								navigation_grid_indices = {
									2,
									1
								},
								item_type = UISettings.ITEM_TYPES.GEAR_UPPERBODY,
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
							},
							{
								slot_title = "loc_inventory_title_slot_gear_lowerbody",
								scenegraph_id = "slot_gear_lowerbody",
								loadout_slot = true,
								slot_icon = "content/ui/materials/icons/item_types/beveled/lower_bodies",
								widget_type = "gear_item_slot",
								default_icon = "content/ui/materials/icons/items/gears/legs/empty",
								slot = ItemSlotSettings.slot_gear_lowerbody,
								navigation_grid_indices = {
									3,
									1
								},
								item_type = UISettings.ITEM_TYPES.GEAR_LOWERBODY,
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
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
								initial_rotation = math.pi,
								item_type = UISettings.ITEM_TYPES.GEAR_EXTRA_COSMETIC,
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
							},
							{
								slot_title = "loc_inventory_title_slot_portrait_frame",
								scenegraph_id = "slot_portrait_frame",
								loadout_slot = true,
								widget_type = "ui_item_slot",
								default_icon = "content/ui/materials/icons/items/gears/legs/empty",
								slot = ItemSlotSettings.slot_portrait_frame,
								navigation_grid_indices = {
									2,
									2
								},
								item_type = UISettings.ITEM_TYPES.PORTRAIT_FRAME,
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
							},
							{
								slot_title = "loc_inventory_title_slot_insignia",
								scenegraph_id = "slot_insignia",
								loadout_slot = true,
								widget_type = "ui_item_slot",
								default_icon = "content/ui/materials/icons/items/gears/legs/empty",
								slot = ItemSlotSettings.slot_insignia,
								navigation_grid_indices = {
									3,
									2
								},
								item_type = UISettings.ITEM_TYPES.CHARACTER_INSIGNIA,
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
							},
							not self._is_readonly and {
								scenegraph_id = "button_expressions",
								slot_title = "loc_inventory_title_slot_animation_end_of_round",
								display_name = "loc_inventory_title_slot_animation_end_of_round",
								loadout_slot = true,
								widget_type = "pose_item_slot",
								default_icon = "content/ui/materials/icons/items/gears/legs/empty",
								size = {
									64,
									64
								},
								slot = ItemSlotSettings.slot_animation_end_of_round,
								navigation_grid_indices = {
									6,
									3
								},
								item_type = UISettings.ITEM_TYPES.END_OF_ROUND,
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
							} or nil,
							not self._is_readonly and {
								scenegraph_id = "button_emote_1",
								slot_title = "loc_inventory_title_slot_animation_emote_1",
								display_name = "loc_inventory_title_slot_animation_emote_1",
								loadout_slot = true,
								disable_rotation_input = false,
								widget_type = "emote_item_slot",
								default_icon = "content/ui/materials/icons/items/gears/legs/empty",
								animation_event_name_suffix = "_instant",
								size = {
									64,
									64
								},
								slot = ItemSlotSettings.slot_animation_emote_1,
								navigation_grid_indices = {
									1,
									3
								},
								animation_event_variable_data = {
									index = "in_menu",
									value = 1
								},
								item_type = UISettings.ITEM_TYPES.EMOTE,
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
							} or nil,
							not self._is_readonly and {
								scenegraph_id = "button_emote_2",
								slot_title = "loc_inventory_title_slot_animation_emote_2",
								display_name = "loc_inventory_title_slot_animation_emote_2",
								loadout_slot = true,
								disable_rotation_input = false,
								widget_type = "emote_item_slot",
								default_icon = "content/ui/materials/icons/items/gears/legs/empty",
								animation_event_name_suffix = "_instant",
								size = {
									64,
									64
								},
								slot = ItemSlotSettings.slot_animation_emote_2,
								navigation_grid_indices = {
									2,
									3
								},
								animation_event_variable_data = {
									index = "in_menu",
									value = 1
								},
								item_type = UISettings.ITEM_TYPES.EMOTE,
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
							} or nil,
							not self._is_readonly and {
								scenegraph_id = "button_emote_3",
								slot_title = "loc_inventory_title_slot_animation_emote_3",
								display_name = "loc_inventory_title_slot_animation_emote_3",
								loadout_slot = true,
								disable_rotation_input = false,
								widget_type = "emote_item_slot",
								default_icon = "content/ui/materials/icons/items/gears/legs/empty",
								animation_event_name_suffix = "_instant",
								size = {
									64,
									64
								},
								slot = ItemSlotSettings.slot_animation_emote_3,
								navigation_grid_indices = {
									3,
									3
								},
								animation_event_variable_data = {
									index = "in_menu",
									value = 1
								},
								item_type = UISettings.ITEM_TYPES.EMOTE,
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
							} or nil,
							not self._is_readonly and {
								scenegraph_id = "button_emote_4",
								slot_title = "loc_inventory_title_slot_animation_emote_4",
								display_name = "loc_inventory_title_slot_animation_emote_4",
								loadout_slot = true,
								disable_rotation_input = false,
								widget_type = "emote_item_slot",
								default_icon = "content/ui/materials/icons/items/gears/legs/empty",
								animation_event_name_suffix = "_instant",
								size = {
									64,
									64
								},
								slot = ItemSlotSettings.slot_animation_emote_4,
								navigation_grid_indices = {
									4,
									3
								},
								animation_event_variable_data = {
									index = "in_menu",
									value = 1
								},
								item_type = UISettings.ITEM_TYPES.EMOTE,
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
							} or nil,
							not self._is_readonly and {
								scenegraph_id = "button_emote_5",
								slot_title = "loc_inventory_title_slot_animation_emote_5",
								display_name = "loc_inventory_title_slot_animation_emote_5",
								loadout_slot = true,
								disable_rotation_input = false,
								widget_type = "emote_item_slot",
								default_icon = "content/ui/materials/icons/items/gears/legs/empty",
								animation_event_name_suffix = "_instant",
								size = {
									64,
									64
								},
								slot = ItemSlotSettings.slot_animation_emote_5,
								navigation_grid_indices = {
									5,
									3
								},
								animation_event_variable_data = {
									index = "in_menu",
									value = 1
								},
								item_type = UISettings.ITEM_TYPES.EMOTE,
								has_new_items_update_callback = function (item_type)
									return self:has_new_items_by_type(item_type)
								end
							} or nil
						}
					}
				}
			}
		}
	}

	self:_update_has_empty_talent_nodes()

	self._views_settings[#self._views_settings + 1] = {
		view_name = "talent_builder_view",
		display_name = "loc_talent_view_display_name",
		update = function (content, style, dt)
			content.hotspot.disabled = not self:is_inventory_synced()

			if not self._is_own_player or self._is_readonly then
				return
			end

			content.show_alert = self._has_empty_talent_nodes
		end,
		context = {
			can_exit = true,
			player_mode = true
		},
		view_context = {
			can_exit = true,
			player_mode = true,
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
	local views_settings = self._views_settings

	for i = 1, #views_settings do
		local settings = views_settings[i]
		local view_name = settings.view_name
		local display_name = nil
		local display_name_loc_key = settings.display_name

		if not display_name_loc_key and settings.unlocalized_display_name then
			display_name = settings.unlocalized_display_name
		else
			if not display_name_loc_key then
				local view_settings = Views[view_name]
				display_name_loc_key = view_settings.display_name
			end

			display_name = Localize(display_name_loc_key)
		end

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
	local old_settings = old_top_panel_selection_index and views_settings[old_top_panel_selection_index]

	if old_settings and old_settings.leave then
		old_settings.leave()
	end

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

	if not self._using_cursor_navigation then
		self:_play_sound(UISoundEvents.tab_button_pressed)
	end

	if settings.enter then
		settings.enter()
	end
end

InventoryBackgroundView._can_swap_weapon = function (self)
	return self._active_view ~= "talent_builder_view"
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
				current_profile_equipped_talents = self._current_profile_equipped_talents,
				changeable_context = additional_context_data,
				is_readonly = self._is_readonly
			}
			self._active_view = view_name
			self._active_view_context = context

			if not Managers.ui:view_active(view_name) then
				Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
			end
		end
	end
end

InventoryBackgroundView._setup_profile_presets = function (self)
	self._profile_presets_element = self:_add_element(ViewElementProfilePresets, "profile_presets", 90, nil, "profile_presets_pivot")

	self:_register_event("event_on_profile_preset_changed")
	self:_register_event("event_on_player_preset_created")
	self:_register_event("event_player_save_changes_to_current_preset")

	local current_preset_id = ProfileUtils.get_active_profile_preset_id()
	local current_preset = current_preset_id and ProfileUtils.get_profile_preset(current_preset_id)

	self:event_on_profile_preset_changed(current_preset)
end

InventoryBackgroundView._remove_profile_presets = function (self)
	if self._profile_presets_element then
		self:_remove_element("profile_presets")

		self._profile_presets_element = nil
	end
end

InventoryBackgroundView.event_on_player_preset_created = function (self, profile_preset_id)
	local active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()
	local active_profile_preset = active_profile_preset_id and ProfileUtils.get_profile_preset(active_profile_preset_id)

	if profile_preset_id == active_profile_preset_id then
		return
	end

	local new_loadout = {}
	local new_talents, new_talents_version = nil
	local player = self._preview_player
	local profile = player:profile()
	local active_layout = self._active_talent_loadout
	local active_layout_version = active_layout.version

	if active_profile_preset then
		local loadout = active_profile_preset.loadout
		local talents = active_profile_preset.talents
		new_loadout = loadout and table.create_copy(nil, loadout) or {}
		new_talents = talents and table.create_copy(nil, talents) or {}
		new_talents_version = active_profile_preset.talents_version
	else
		local loadout = profile.loadout
		new_talents_version = active_layout_version
		local current_profile_equipped_talents = self._current_profile_equipped_talents

		if current_profile_equipped_talents then
			new_talents = table.clone(current_profile_equipped_talents)
		else
			local selected_nodes = profile.selected_nodes

			if selected_nodes then
				local nodes = active_layout.nodes
				new_talents = {}

				for node_index_s, points_spent_on_node in pairs(selected_nodes) do
					local node_index = tonumber(node_index_s)
					local node = nodes[node_index]
					local node_name = node.widget_name
					new_talents[node_name] = points_spent_on_node
				end
			else
				new_talents = {}
			end
		end

		for slot_id, item in pairs(loadout) do
			local slot = ItemSlotSettings[slot_id]

			if slot.equipped_in_inventory and item.gear_id then
				new_loadout[slot_id] = item.gear_id
			end
		end

		local presentation_loadout = self._preview_profile_equipped_items

		for slot_id, item in pairs(presentation_loadout) do
			local slot = ItemSlotSettings[slot_id]

			if slot.equipped_in_inventory and item.gear_id then
				new_loadout[slot_id] = item.gear_id
			end
		end
	end

	local new_profile_preset = ProfileUtils.get_profile_preset(profile_preset_id)
	new_profile_preset.loadout = new_loadout
	new_profile_preset.talents = new_talents
	new_profile_preset.talents_version = new_talents_version

	Managers.save:queue_save()
end

InventoryBackgroundView.event_on_profile_preset_changed = function (self, profile_preset, on_preset_deleted)
	local active_layout = self._active_talent_loadout
	local active_layout_version = active_layout.version
	local previously_active_profile_preset_id = self._active_profile_preset_id

	if previously_active_profile_preset_id then
		local current_profile_equipped_talents = self._current_profile_equipped_talents

		ProfileUtils.save_talent_nodes_for_profile_preset(previously_active_profile_preset_id, current_profile_equipped_talents, active_layout_version)
	end

	if profile_preset and profile_preset.loadout then
		for slot_id, gear_id in pairs(profile_preset.loadout) do
			local item = self:_get_inventory_item_by_id(gear_id)

			if item then
				self:_equip_slot_item(slot_id, item)
			end
		end
	end

	if profile_preset then
		local active_talent_loadout = self._active_talent_loadout
		local active_talent_version = active_talent_loadout.version

		if profile_preset.talents_version == active_talent_version then
			self._current_profile_equipped_talents = profile_preset.talents or {}
		else
			self._current_profile_equipped_talents = {}
		end
	else
		self:_apply_current_talents_to_profile()
	end

	self._active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()

	self:_update_loadout_validation()
	self:_update_presentation_wield_item()

	if not table.is_empty(self._invalid_slots) or not table.is_empty(self._duplicated_slots) or not table.is_empty(self._modified_slots) then
		Managers.event:trigger("event_add_notification_message", "alert", {
			text = Localize("loc_inventory_error_loadout_items")
		})
	end
end

InventoryBackgroundView._update_presets_missing_warning_marker = function (self)
	local presets = ProfileUtils.get_profile_presets()

	if not presets or #presets == 0 then
		local show_warning = not table.is_empty(self._invalid_slots) or not table.is_empty(self._duplicated_slots)
		local show_modified = not table.is_empty(self._modified_slots)

		self._profile_presets_element:set_current_profile_loadout_status(show_warning, show_modified)
	else
		local active_talent_loadout = self._active_talent_loadout
		local active_talent_version = active_talent_loadout.version
		local active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()

		for i = 1, #presets do
			local preset = presets[i]
			local loadout = presets and preset.loadout

			if loadout then
				local active_preset = preset.id == active_profile_preset_id
				local is_read_only = not active_preset
				local invalid_slots, modified_slots, duplicated_slots = self:_validate_loadout(loadout, is_read_only)
				local show_warning = not table.is_empty(invalid_slots) or not table.is_empty(duplicated_slots)
				local show_modified = not table.is_empty(modified_slots)
				local preset_talents_version = preset.talents_version

				if not preset_talents_version or active_talent_version ~= preset_talents_version then
					show_warning = true
				end

				self._profile_presets_element:show_profile_preset_missing_items_warning(show_warning, show_modified, preset.id)

				if active_preset then
					self._profile_presets_element:set_current_profile_loadout_status(show_warning, show_modified)
				end
			end
		end
	end
end

InventoryBackgroundView.remove_new_item_mark = function (self, item)
	local gear_id = item.gear_id
	local item_type = item.item_type

	ItemUtils.unmark_item_id_as_new(gear_id)

	if item_type then
		self._new_items_gear_ids_by_type[item_type][gear_id] = nil
	end

	self._new_items_gear_ids[gear_id] = nil
end

InventoryBackgroundView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 90)
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

	if self._entered and not self._is_readonly and self:is_inventory_synced() then
		self:_equip_local_changes()
		self:_save_current_talents_to_profile_preset()
		self:_apply_current_talents_to_profile()
	end
end

InventoryBackgroundView._save_current_talents_to_profile_preset = function (self)
	if not self._is_own_player or self._is_readonly then
		return
	end

	local active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()

	if active_profile_preset_id then
		local active_layout = self._active_talent_loadout
		local active_layout_version = active_layout.version
		local current_profile_equipped_talents = self._current_profile_equipped_talents

		ProfileUtils.save_talent_nodes_for_profile_preset(active_profile_preset_id, current_profile_equipped_talents, active_layout_version)
	end
end

InventoryBackgroundView.event_player_save_changes_to_current_preset = function (self)
	self:_save_current_talents_to_profile_preset()
end

InventoryBackgroundView._apply_current_talents_to_profile = function (self)
	if not self._is_own_player or self._is_readonly then
		return
	end

	local active_talent_loadout = self._active_talent_loadout

	if active_talent_loadout then
		local points_spent_on_nodes = self._current_profile_equipped_talents

		if points_spent_on_nodes then
			local player = self._preview_player
			local talent_service = Managers.data_service.talents

			talent_service:set_talents_v2(player, active_talent_loadout, points_spent_on_nodes)
		end
	end
end

InventoryBackgroundView.can_exit = function (self)
	if self:profile_preset_handling_input() then
		return false
	end

	local active_view = self._active_view
	local view_instance = active_view and Managers.ui:view_instance(active_view)

	if view_instance and view_instance.can_exit and not view_instance:can_exit() then
		return false
	end

	return InventoryBackgroundView.super.can_exit(self)
end

InventoryBackgroundView._handle_input = function (self, input_service, dt, t)
	if self._profile_presets_element then
		self:_update_profile_preset_hold_input(input_service, dt)

		if self:profile_preset_handling_input() then
			input_service = input_service:null_service()
		end
	end
end

InventoryBackgroundView.cb_on_profile_preset_cycle = function (self)
	local profile_presets_element = self._profile_presets_element

	if not profile_presets_element and not profile_presets_element:has_active_profile_preset() then
		return
	end

	profile_presets_element:cycle_next_profile_preset()
end

InventoryBackgroundView.cb_on_profile_preset_add = function (self)
	self._profile_preset_legend_input_pressed_add = true
end

InventoryBackgroundView.cb_on_profile_preset_customize = function (self)
	self._profile_preset_legend_input_pressed_customize = true
end

InventoryBackgroundView.can_add_profile_preset = function (self)
	local profile_presets_element = self._profile_presets_element

	if profile_presets_element and profile_presets_element:can_add_profile_preset() then
		return true
	end

	return false
end

InventoryBackgroundView.is_preset_costumization_open = function (self)
	local profile_presets_element = self._profile_presets_element

	if profile_presets_element and profile_presets_element:is_costumization_open() then
		return true
	end

	return false
end

InventoryBackgroundView.can_customize_profile_preset = function (self)
	local profile_presets_element = self._profile_presets_element

	if profile_presets_element and profile_presets_element:has_active_profile_preset() then
		return true
	end

	return false
end

InventoryBackgroundView.can_cycle_profile_preset = function (self)
	local profile_presets_element = self._profile_presets_element

	if profile_presets_element and profile_presets_element:has_active_profile_preset() then
		return true
	end

	return false
end

InventoryBackgroundView.profile_preset_handling_input = function (self)
	local profile_presets_element = self._profile_presets_element

	return profile_presets_element and profile_presets_element:handling_input()
end

InventoryBackgroundView._update_profile_preset_hold_input = function (self, input_service, dt)
	if self._profile_preset_legend_input_pressed_add or self._profile_preset_legend_input_pressed_customize then
		local profile_presets_element = self._profile_presets_element

		if input_service:get("hotkey_item_profile_preset_input_1_hold") or input_service:get("left_hold") then
			self._profile_preset_input_hold_timer = (self._profile_preset_input_hold_timer or 0) + dt

			if self._profile_preset_legend_input_pressed_customize and profile_presets_element:has_active_profile_preset() and self._profile_preset_input_hold_timer >= 0.75 then
				self._profile_preset_legend_input_pressed_add = false
				self._profile_preset_legend_input_pressed_customize = false
				self._profile_preset_input_hold_timer = 0

				if profile_presets_element then
					profile_presets_element:customize_active_profile_presets()
				end
			end
		elseif self._profile_preset_input_hold_timer and self._profile_preset_input_hold_timer > 0 then
			if self._profile_preset_legend_input_pressed_add and self._profile_preset_input_hold_timer <= 0.25 and profile_presets_element then
				profile_presets_element:cb_add_new_profile_preset()
			end

			self._profile_preset_legend_input_pressed_add = false
			self._profile_preset_legend_input_pressed_customize = false
			self._profile_preset_input_hold_timer = 0
		end
	end
end

InventoryBackgroundView.draw = function (self, dt, t, input_service, layer)
	if not self:is_inventory_synced() then
		input_service:null_service()
	end

	InventoryBackgroundView.super.draw(self, dt, t, input_service, layer)
end

InventoryBackgroundView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	InventoryBackgroundView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

InventoryBackgroundView.update = function (self, dt, t, input_service)
	local profile_preset_handling_input = self:profile_preset_handling_input()
	local active_view = self._active_view
	local view_instance = active_view and Managers.ui:view_instance(active_view)

	if view_instance and view_instance.block_input then
		view_instance:block_input(profile_preset_handling_input)
	end

	if Managers.ui:get_client_loadout_waiting_state() then
		input_service = input_service:null_service()

		if not self._check_for_loadout_update_timeout or self._check_for_loadout_update_timeout < InventoryBackgroundViewSettings.loadout_update_timeout and self._is_own_player then
			self._check_for_loadout_update_timeout = self._check_for_loadout_update_timeout and self._check_for_loadout_update_timeout + dt or 0
		else
			Managers.ui:update_client_loadout_waiting_state(false)

			self._check_for_loadout_update_timeout = nil
		end
	elseif self._check_for_loadout_update_timeout then
		self._check_for_loadout_update_timeout = nil
	end

	self._widgets_by_name.loading.content.visible = not self:is_inventory_synced()

	if self._inventory_synced == false then
		input_service = input_service:null_service()
	elseif self._inventory_synced == true and not self._check_for_loadout_update_timeout then
		input_service = input_service:null_service()
		self._inventory_synced = nil

		self:_setup_inventory()
	elseif self:is_inventory_synced() then
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

				self:_request_player_insignia(insignia_item, self._ui_renderer)
			end

			local title_item = loadout.slot_character_title
			local title_item_gear_id = title_item and title_item.gear_id

			if title_item_gear_id ~= self._title_item_gear_id then
				self._title_item_gear_id = title_item_gear_id

				self:_set_player_profile_title(profile)
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
	end

	local pass_input, pass_draw = InventoryBackgroundView.super.update(self, dt, t, input_service)

	return pass_input, pass_draw
end

InventoryBackgroundView._setup_inventory = function (self)
	local profile = self._preview_player:profile()
	self._presentation_profile = table.clone_instance(profile)
	local player_loadout = self._presentation_profile.loadout
	self._preview_profile_equipped_items = player_loadout
	self._starting_profile_equipped_items = self._context and self._context.starting_profile_equipped_items or table.clone_instance(player_loadout)
	self._current_profile_equipped_items = self._context and self._context.current_profile_equipped_items or table.clone_instance(player_loadout)

	self:_update_valid_items_list()

	self._widgets_by_name.loading.content.visible = false

	self:_setup_top_panel()
	self:_force_select_panel_index(1)
	self:_set_player_profile_information(self._preview_player)

	if self._is_own_player and not self._is_readonly then
		self:_setup_profile_presets()
		self:_update_loadout_validation()

		local items = self._inventory_items
		local new_items, new_items_by_type = self:_get_valid_new_items(items)
		self._new_items_gear_ids = new_items
		self._new_items_gear_ids_by_type = new_items_by_type
	end

	self:_update_equipped_items()
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
	local breed_name = selected_archetype and selected_archetype.breed or profile.breed
	local breed_settings = Breeds[breed_name]
	local inventory_state_machine = breed_settings.inventory_state_machine

	self._profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation, nil, inventory_state_machine)

	self._spawned_profile = profile

	self:_update_presentation_wield_item()
end

InventoryBackgroundView._set_preview_wield_slot_id = function (self, slot_id)
	local settings = InventoryBackgroundViewSettings

	if not table.array_contains(settings.allowed_slots, slot_id) then
		slot_id = settings.default_slot
	end

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

InventoryBackgroundView._fetch_inventory_items = function (self)
	local player = self._preview_player
	local character_id = player:character_id()

	Managers.data_service.gear:fetch_inventory(character_id):next(function (items)
		if self._destroyed then
			return
		end

		self._inventory_items = items
		self._inventory_synced = true
	end):catch(function ()
		Managers.event:trigger("event_add_notification_message", "alert", {
			text = Localize("loc_popup_description_backend_error")
		})
		self:cb_on_close_pressed()
	end)
end

InventoryBackgroundView._validate_loadout = function (self, loadout, read_only)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-7, warpins: 1 ---
	local invalid_slots = {}
	local modified_slots = {}
	local duplicated_slots = {}
	local only_show_slot_as_invalid = {}

	if not self._is_own_player or self._is_readonly then

		-- Decompilation error in this vicinity:
		--- BLOCK #2 11-14, warpins: 2 ---
		return invalid_slots, modified_slots, duplicated_slots
		--- END OF BLOCK #2 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #1 8-10, warpins: 1 ---
	--- END OF BLOCK #1 ---

	slot7 = if self._is_readonly then
	JUMP TO BLOCK #2
	else
	JUMP TO BLOCK #3
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #2 11-14, warpins: 2 ---
	return invalid_slots, modified_slots, duplicated_slots

	--- END OF BLOCK #2 ---




	-- Decompilation error in this vicinity:
	--- BLOCK #3 15-18, warpins: 2 ---
	--- END OF BLOCK #3 ---

	for slot_name, item_data in pairs(loadout)

	LOOP BLOCK #4
	GO OUT TO BLOCK #52



	-- Decompilation error in this vicinity:
	--- BLOCK #4 19-23, warpins: 1 ---
	--- END OF BLOCK #4 ---

	slot12 = if not ItemSlotSettings[slot_name].equipped_in_inventory then
	JUMP TO BLOCK #5
	else
	JUMP TO BLOCK #6
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #5 24-24, warpins: 1 ---
	--- END OF BLOCK #5 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #51



	-- Decompilation error in this vicinity:
	--- BLOCK #6 25-29, warpins: 1 ---
	--- END OF BLOCK #6 ---

	if type(item_data)

	 == "table" then
	JUMP TO BLOCK #7
	else
	JUMP TO BLOCK #8
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #7 30-31, warpins: 1 ---
	slot12 = item_data.gear_id
	--- END OF BLOCK #7 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #10



	-- Decompilation error in this vicinity:
	--- BLOCK #8 32-33, warpins: 1 ---
	slot12 = false
	--- END OF BLOCK #8 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #10



	-- Decompilation error in this vicinity:
	--- BLOCK #9 34-34, warpins: 0 ---
	local gear_id = true

	--- END OF BLOCK #9 ---

	FLOW; TARGET BLOCK #10



	-- Decompilation error in this vicinity:
	--- BLOCK #10 35-36, warpins: 3 ---
	--- END OF BLOCK #10 ---

	slot12 = if gear_id then
	JUMP TO BLOCK #11
	else
	JUMP TO BLOCK #12
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #11 37-42, warpins: 1 ---
	--- END OF BLOCK #11 ---

	slot13 = if not self:_get_inventory_item_by_id(gear_id)

	 then
	JUMP TO BLOCK #12
	else
	JUMP TO BLOCK #13
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #12 43-46, warpins: 2 ---
	local item = self:_get_inventory_item_by_id(item_data)
	--- END OF BLOCK #12 ---

	FLOW; TARGET BLOCK #13



	-- Decompilation error in this vicinity:
	--- BLOCK #13 47-52, warpins: 2 ---
	local fallback_item = MasterItems.find_fallback_item(slot_name)

	--- END OF BLOCK #13 ---

	slot13 = if not item then
	JUMP TO BLOCK #14
	else
	JUMP TO BLOCK #17
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #14 53-57, warpins: 1 ---
	--- END OF BLOCK #14 ---

	if type(item_data)

	 == "table" then
	JUMP TO BLOCK #15
	else
	JUMP TO BLOCK #16
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #15 58-60, warpins: 1 ---
	--- END OF BLOCK #15 ---

	slot15 = if not item_data.always_owned then
	JUMP TO BLOCK #16
	else
	JUMP TO BLOCK #17
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #16 61-63, warpins: 2 ---
	invalid_slots[slot_name] = true
	--- END OF BLOCK #16 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #51



	-- Decompilation error in this vicinity:
	--- BLOCK #17 64-65, warpins: 2 ---
	--- END OF BLOCK #17 ---

	slot13 = if not item then
	JUMP TO BLOCK #18
	else
	JUMP TO BLOCK #20
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #18 66-67, warpins: 1 ---
	--- END OF BLOCK #18 ---

	slot14 = if not fallback_item then
	JUMP TO BLOCK #19
	else
	JUMP TO BLOCK #20
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #19 68-70, warpins: 1 ---
	invalid_slots[slot_name] = true
	--- END OF BLOCK #19 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #51



	-- Decompilation error in this vicinity:
	--- BLOCK #20 71-72, warpins: 2 ---
	--- END OF BLOCK #20 ---

	slot13 = if item then
	JUMP TO BLOCK #21
	else
	JUMP TO BLOCK #25
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #21 73-75, warpins: 1 ---
	--- END OF BLOCK #21 ---

	slot15 = if not item.always_owned then
	JUMP TO BLOCK #22
	else
	JUMP TO BLOCK #25
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #22 76-77, warpins: 1 ---
	--- END OF BLOCK #22 ---

	slot14 = if fallback_item then
	JUMP TO BLOCK #23
	else
	JUMP TO BLOCK #25
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #23 78-81, warpins: 1 ---
	--- END OF BLOCK #23 ---

	if item.name == fallback_item.name then
	JUMP TO BLOCK #24
	else
	JUMP TO BLOCK #25
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #24 82-84, warpins: 1 ---
	invalid_slots[slot_name] = true
	--- END OF BLOCK #24 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #51



	-- Decompilation error in this vicinity:
	--- BLOCK #25 85-89, warpins: 4 ---
	local allowed_duplicates = {
		slot_animation_emote_3 = true,
		slot_animation_emote_5 = true,
		slot_animation_emote_4 = true,
		slot_animation_emote_1 = true,
		slot_animation_emote_2 = true
	}

	--- END OF BLOCK #25 ---

	FLOW; TARGET BLOCK #26



	-- Decompilation error in this vicinity:
	--- BLOCK #26 90-94, warpins: 1 ---
	--- END OF BLOCK #26 ---

	if type(checked_load_data)
	 == "table" then
	JUMP TO BLOCK #27
	else
	JUMP TO BLOCK #28
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #27 95-97, warpins: 1 ---
	--- END OF BLOCK #27 ---

	slot21 = if not checked_load_data.gear_id then
	JUMP TO BLOCK #28
	else
	JUMP TO BLOCK #32
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #28 98-102, warpins: 2 ---
	--- END OF BLOCK #28 ---

	if type(checked_load_data)

	 == "string" then
	JUMP TO BLOCK #29
	else
	JUMP TO BLOCK #30
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #29 103-104, warpins: 1 ---
	slot21 = checked_load_data
	--- END OF BLOCK #29 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #32



	-- Decompilation error in this vicinity:
	--- BLOCK #30 105-106, warpins: 1 ---
	slot21 = false
	--- END OF BLOCK #30 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #32



	-- Decompilation error in this vicinity:
	--- BLOCK #31 107-107, warpins: 0 ---
	local checked_gear_id = true

	--- END OF BLOCK #31 ---

	FLOW; TARGET BLOCK #32



	-- Decompilation error in this vicinity:
	--- BLOCK #32 108-112, warpins: 4 ---
	--- END OF BLOCK #32 ---

	if type(item_data)
	 == "table" then
	JUMP TO BLOCK #33
	else
	JUMP TO BLOCK #34
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #33 113-115, warpins: 1 ---
	--- END OF BLOCK #33 ---

	slot22 = if not item_data.gear_id then
	JUMP TO BLOCK #34
	else
	JUMP TO BLOCK #38
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #34 116-120, warpins: 2 ---
	--- END OF BLOCK #34 ---

	if type(item_data)

	 == "string" then
	JUMP TO BLOCK #35
	else
	JUMP TO BLOCK #36
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #35 121-122, warpins: 1 ---
	slot22 = item_data
	--- END OF BLOCK #35 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #38



	-- Decompilation error in this vicinity:
	--- BLOCK #36 123-124, warpins: 1 ---
	slot22 = false
	--- END OF BLOCK #36 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #38



	-- Decompilation error in this vicinity:
	--- BLOCK #37 125-125, warpins: 0 ---
	local item_gear_id = true
	--- END OF BLOCK #37 ---

	FLOW; TARGET BLOCK #38



	-- Decompilation error in this vicinity:
	--- BLOCK #38 126-127, warpins: 4 ---
	--- END OF BLOCK #38 ---

	if checked_gear_id == item_gear_id then
	JUMP TO BLOCK #39
	else
	JUMP TO BLOCK #44
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #39 128-129, warpins: 1 ---
	--- END OF BLOCK #39 ---

	if checked_slot_name ~= slot_name then
	JUMP TO BLOCK #40
	else
	JUMP TO BLOCK #44
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #40 130-132, warpins: 1 ---
	--- END OF BLOCK #40 ---

	slot23 = if not invalid_slots[slot_name] then
	JUMP TO BLOCK #41
	else
	JUMP TO BLOCK #44
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #41 133-135, warpins: 1 ---
	--- END OF BLOCK #41 ---

	slot23 = if allowed_duplicates[checked_slot_name] then
	JUMP TO BLOCK #42
	else
	JUMP TO BLOCK #43
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #42 136-138, warpins: 1 ---
	--- END OF BLOCK #42 ---

	slot23 = if not allowed_duplicates[slot_name] then
	JUMP TO BLOCK #43
	else
	JUMP TO BLOCK #44
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #43 139-141, warpins: 2 ---
	duplicated_slots[checked_slot_name] = true
	--- END OF BLOCK #43 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #51



	-- Decompilation error in this vicinity:
	--- BLOCK #44 142-143, warpins: 5 ---
	--- END OF BLOCK #44 ---




	-- Decompilation error in this vicinity:
	--- BLOCK #45 144-152, warpins: 1 ---
	local player = self._preview_player
	local profile = player:profile()

	--- END OF BLOCK #45 ---

	if type(item_data)
	 == "table" then
	JUMP TO BLOCK #46
	else
	JUMP TO BLOCK #47
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #46 153-158, warpins: 1 ---
	--- END OF BLOCK #46 ---

	slot18 = if not self:_get_inventory_item_by_id(gear_id)

	 then
	JUMP TO BLOCK #47
	else
	JUMP TO BLOCK #48
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #47 159-162, warpins: 2 ---
	local item = self:_get_inventory_item_by_id(item_data)
	--- END OF BLOCK #47 ---

	FLOW; TARGET BLOCK #48



	-- Decompilation error in this vicinity:
	--- BLOCK #48 163-164, warpins: 2 ---
	--- END OF BLOCK #48 ---

	slot18 = if item then
	JUMP TO BLOCK #49
	else
	JUMP TO BLOCK #51
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #49 165-171, warpins: 1 ---
	local compatible_profile = ItemUtils.is_item_compatible_with_profile(item, profile)
	--- END OF BLOCK #49 ---

	slot19 = if not compatible_profile then
	JUMP TO BLOCK #50
	else
	JUMP TO BLOCK #51
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #50 172-176, warpins: 1 ---
	only_show_slot_as_invalid[slot_name] = true
	invalid_slots[slot_name] = true
	--- END OF BLOCK #50 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #51



	-- Decompilation error in this vicinity:
	--- BLOCK #51 177-178, warpins: 9 ---
	--- END OF BLOCK #51 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #52 179-182, warpins: 1 ---
	--- END OF BLOCK #52 ---

	FLOW; TARGET BLOCK #53



	-- Decompilation error in this vicinity:
	--- BLOCK #53 183-185, warpins: 1 ---
	--- END OF BLOCK #53 ---

	slot12 = if not only_show_slot_as_invalid[removed_slot_id] then
	JUMP TO BLOCK #54
	else
	JUMP TO BLOCK #91
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #54 186-188, warpins: 1 ---
	--- END OF BLOCK #54 ---

	slot12 = if self._starting_profile_equipped_items then
	JUMP TO BLOCK #55
	else
	JUMP TO BLOCK #56
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #55 189-190, warpins: 1 ---
	local starting_item = self._starting_profile_equipped_items[removed_slot_id]
	--- END OF BLOCK #55 ---

	FLOW; TARGET BLOCK #56



	-- Decompilation error in this vicinity:
	--- BLOCK #56 191-193, warpins: 2 ---
	--- END OF BLOCK #56 ---

	slot13 = if self._valid_profile_equipped_items then
	JUMP TO BLOCK #57
	else
	JUMP TO BLOCK #58
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #57 194-195, warpins: 1 ---
	local valid_stored_item = self._valid_profile_equipped_items[removed_slot_id]
	--- END OF BLOCK #57 ---

	FLOW; TARGET BLOCK #58



	-- Decompilation error in this vicinity:
	--- BLOCK #58 196-197, warpins: 2 ---
	--- END OF BLOCK #58 ---

	slot12 = if starting_item then
	JUMP TO BLOCK #59
	else
	JUMP TO BLOCK #60
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #59 198-202, warpins: 1 ---
	starting_item = self:_get_inventory_item_by_id(starting_item.gear_id)
	--- END OF BLOCK #59 ---

	FLOW; TARGET BLOCK #60



	-- Decompilation error in this vicinity:
	--- BLOCK #60 203-204, warpins: 2 ---
	--- END OF BLOCK #60 ---

	slot13 = if valid_stored_item then
	JUMP TO BLOCK #61
	else
	JUMP TO BLOCK #62
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #61 205-209, warpins: 1 ---
	valid_stored_item = self:_get_inventory_item_by_id(valid_stored_item.gear_id)
	--- END OF BLOCK #61 ---

	FLOW; TARGET BLOCK #62



	-- Decompilation error in this vicinity:
	--- BLOCK #62 210-215, warpins: 2 ---
	local fallback_item = MasterItems.find_fallback_item(removed_slot_id)
	--- END OF BLOCK #62 ---

	slot15 = if starting_item then
	JUMP TO BLOCK #63
	else
	JUMP TO BLOCK #68
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #63 216-218, warpins: 1 ---
	--- END OF BLOCK #63 ---

	slot15 = if not starting_item.always_owned then
	JUMP TO BLOCK #64
	else
	JUMP TO BLOCK #68
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #64 219-220, warpins: 1 ---
	--- END OF BLOCK #64 ---

	slot15 = if fallback_item then
	JUMP TO BLOCK #65
	else
	JUMP TO BLOCK #68
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #65 221-224, warpins: 1 ---
	--- END OF BLOCK #65 ---

	if fallback_item.name == starting_item.name then
	JUMP TO BLOCK #66
	else
	JUMP TO BLOCK #67
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #66 225-226, warpins: 1 ---
	slot15 = false
	--- END OF BLOCK #66 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #68



	-- Decompilation error in this vicinity:
	--- BLOCK #67 227-227, warpins: 1 ---
	local starting_item_valid = true
	--- END OF BLOCK #67 ---

	FLOW; TARGET BLOCK #68



	-- Decompilation error in this vicinity:
	--- BLOCK #68 228-229, warpins: 5 ---
	--- END OF BLOCK #68 ---

	slot16 = if valid_stored_item then
	JUMP TO BLOCK #69
	else
	JUMP TO BLOCK #74
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #69 230-232, warpins: 1 ---
	--- END OF BLOCK #69 ---

	slot16 = if not valid_stored_item.always_owned then
	JUMP TO BLOCK #70
	else
	JUMP TO BLOCK #74
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #70 233-234, warpins: 1 ---
	--- END OF BLOCK #70 ---

	slot16 = if fallback_item then
	JUMP TO BLOCK #71
	else
	JUMP TO BLOCK #74
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #71 235-238, warpins: 1 ---
	--- END OF BLOCK #71 ---

	if fallback_item.name == valid_stored_item.name then
	JUMP TO BLOCK #72
	else
	JUMP TO BLOCK #73
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #72 239-240, warpins: 1 ---
	slot16 = false
	--- END OF BLOCK #72 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #74



	-- Decompilation error in this vicinity:
	--- BLOCK #73 241-241, warpins: 1 ---
	local valid_stored_item_valid = true

	--- END OF BLOCK #73 ---

	FLOW; TARGET BLOCK #74



	-- Decompilation error in this vicinity:
	--- BLOCK #74 242-243, warpins: 5 ---
	--- END OF BLOCK #74 ---

	slot2 = if not read_only then
	JUMP TO BLOCK #75
	else
	JUMP TO BLOCK #79
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #75 244-245, warpins: 1 ---
	--- END OF BLOCK #75 ---

	slot15 = if starting_item_valid then
	JUMP TO BLOCK #76
	else
	JUMP TO BLOCK #77
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #76 246-252, warpins: 1 ---
	self:_equip_slot_item(removed_slot_id, starting_item, true)
	--- END OF BLOCK #76 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #79



	-- Decompilation error in this vicinity:
	--- BLOCK #77 253-254, warpins: 1 ---
	--- END OF BLOCK #77 ---

	slot16 = if valid_stored_item_valid then
	JUMP TO BLOCK #78
	else
	JUMP TO BLOCK #79
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #78 255-260, warpins: 1 ---
	self:_equip_slot_item(removed_slot_id, valid_stored_item, true)

	--- END OF BLOCK #78 ---

	FLOW; TARGET BLOCK #79



	-- Decompilation error in this vicinity:
	--- BLOCK #79 261-262, warpins: 4 ---
	--- END OF BLOCK #79 ---

	slot15 = if not starting_item_valid then
	JUMP TO BLOCK #80
	else
	JUMP TO BLOCK #81
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #80 263-264, warpins: 1 ---
	--- END OF BLOCK #80 ---

	slot16 = if valid_stored_item_valid then
	JUMP TO BLOCK #81
	else
	JUMP TO BLOCK #82
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #81 265-269, warpins: 2 ---
	invalid_slots[removed_slot_id] = nil
	modified_slots[removed_slot_id] = true

	--- END OF BLOCK #81 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #91



	-- Decompilation error in this vicinity:
	--- BLOCK #82 270-271, warpins: 1 ---
	--- END OF BLOCK #82 ---

	slot14 = if fallback_item then
	JUMP TO BLOCK #83
	else
	JUMP TO BLOCK #87
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #83 272-273, warpins: 1 ---
	--- END OF BLOCK #83 ---

	slot2 = if not read_only then
	JUMP TO BLOCK #84
	else
	JUMP TO BLOCK #85
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #84 274-279, warpins: 1 ---
	self:_equip_slot_item(removed_slot_id, fallback_item, true)

	--- END OF BLOCK #84 ---

	FLOW; TARGET BLOCK #85



	-- Decompilation error in this vicinity:
	--- BLOCK #85 280-282, warpins: 2 ---
	--- END OF BLOCK #85 ---

	slot17 = if fallback_item.always_owned then
	JUMP TO BLOCK #86
	else
	JUMP TO BLOCK #91
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #86 283-287, warpins: 1 ---
	invalid_slots[removed_slot_id] = nil
	modified_slots[removed_slot_id] = true

	--- END OF BLOCK #86 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #91



	-- Decompilation error in this vicinity:
	--- BLOCK #87 288-294, warpins: 1 ---
	--- END OF BLOCK #87 ---

	slot17 = if string.find(removed_slot_id, "slot_attachment")

	 then
	JUMP TO BLOCK #88
	else
	JUMP TO BLOCK #89
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #88 295-298, warpins: 1 ---
	invalid_slots[removed_slot_id] = nil
	modified_slots[removed_slot_id] = true

	--- END OF BLOCK #88 ---

	FLOW; TARGET BLOCK #89



	-- Decompilation error in this vicinity:
	--- BLOCK #89 299-300, warpins: 2 ---
	--- END OF BLOCK #89 ---

	slot2 = if not read_only then
	JUMP TO BLOCK #90
	else
	JUMP TO BLOCK #91
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #90 301-306, warpins: 1 ---
	self:_equip_slot_item(removed_slot_id, nil, true)

	--- END OF BLOCK #90 ---

	FLOW; TARGET BLOCK #91



	-- Decompilation error in this vicinity:
	--- BLOCK #91 307-308, warpins: 7 ---
	--- END OF BLOCK #91 ---




	-- Decompilation error in this vicinity:
	--- BLOCK #92 309-310, warpins: 1 ---
	--- END OF BLOCK #92 ---

	slot2 = if not read_only then
	JUMP TO BLOCK #93
	else
	JUMP TO BLOCK #94
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #93 311-313, warpins: 1 ---
	self._invalid_slots = invalid_slots
	self._modified_slots = modified_slots
	self._duplicated_slots = duplicated_slots

	--- END OF BLOCK #93 ---

	FLOW; TARGET BLOCK #94



	-- Decompilation error in this vicinity:
	--- BLOCK #94 314-317, warpins: 2 ---
	return invalid_slots, modified_slots, duplicated_slots
	--- END OF BLOCK #94 ---



end

InventoryBackgroundView._get_valid_new_items = function (self, inventory_items)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-16, warpins: 1 ---
	local save_manager = Managers.save
	local character_id = self._preview_player:character_id()
	local profile = self._preview_player:profile()
	local archetype = self._preview_player:archetype_name()
	--- END OF BLOCK #0 ---

	slot6 = if character_id then
	JUMP TO BLOCK #1
	else
	JUMP TO BLOCK #3
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #1 17-18, warpins: 1 ---
	--- END OF BLOCK #1 ---

	slot6 = if save_manager then
	JUMP TO BLOCK #2
	else
	JUMP TO BLOCK #3
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #2 19-22, warpins: 1 ---
	local character_data = save_manager:character_data(character_id)

	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 23-24, warpins: 3 ---
	--- END OF BLOCK #3 ---

	slot6 = if not character_data then
	JUMP TO BLOCK #4
	else
	JUMP TO BLOCK #5
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #4 25-26, warpins: 1 ---
	return {}

	--- END OF BLOCK #4 ---

	FLOW; TARGET BLOCK #5



	-- Decompilation error in this vicinity:
	--- BLOCK #5 27-28, warpins: 2 ---
	--- END OF BLOCK #5 ---

	slot7 = if save_manager then
	JUMP TO BLOCK #6
	else
	JUMP TO BLOCK #7
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #6 29-31, warpins: 1 ---
	local account_new_items_data = save_manager:account_data()
	--- END OF BLOCK #6 ---

	FLOW; TARGET BLOCK #7



	-- Decompilation error in this vicinity:
	--- BLOCK #7 32-33, warpins: 2 ---
	--- END OF BLOCK #7 ---

	slot7 = if account_new_items_data then
	JUMP TO BLOCK #8
	else
	JUMP TO BLOCK #9
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #8 34-37, warpins: 1 ---
	--- END OF BLOCK #8 ---

	slot7 = if not account_new_items_data.new_account_items_by_archetype[archetype] then
	JUMP TO BLOCK #9
	else
	JUMP TO BLOCK #10
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #9 38-38, warpins: 2 ---
	account_new_items_data = {}
	--- END OF BLOCK #9 ---

	FLOW; TARGET BLOCK #10



	-- Decompilation error in this vicinity:
	--- BLOCK #10 39-52, warpins: 2 ---
	local new_gear_items = {}
	local new_gear_items_by_type = {}
	local new_item_lists = {}
	new_item_lists[1] = {
		is_character_data = true,
		data = character_data.new_items
	}
	new_item_lists[2] = {
		data = account_new_items_data
	}
	--- END OF BLOCK #10 ---

	for i=1, #new_item_lists, 1
	LOOP BLOCK #11
	GO OUT TO BLOCK #23


	-- Decompilation error in this vicinity:
	--- BLOCK #11 53-58, warpins: 2 ---
	local new_items_list = new_item_lists[i]
	local new_items = new_items_list.data

	--- END OF BLOCK #11 ---

	for gear_id, _ in pairs(new_items)


	LOOP BLOCK #12
	GO OUT TO BLOCK #22



	-- Decompilation error in this vicinity:
	--- BLOCK #12 59-61, warpins: 1 ---
	local item = inventory_items[gear_id]

	--- END OF BLOCK #12 ---

	slot22 = if not item then
	JUMP TO BLOCK #13
	else
	JUMP TO BLOCK #14
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #13 62-66, warpins: 1 ---
	ItemUtils.unmark_item_id_as_new(gear_id)

	--- END OF BLOCK #13 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #21



	-- Decompilation error in this vicinity:
	--- BLOCK #14 67-73, warpins: 1 ---
	local compatible_profile = ItemUtils.is_item_compatible_with_profile(item, profile)
	--- END OF BLOCK #14 ---

	slot23 = if compatible_profile then
	JUMP TO BLOCK #15
	else
	JUMP TO BLOCK #19
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #15 74-78, warpins: 1 ---
	new_gear_items[gear_id] = true
	local item_type = item.item_type
	--- END OF BLOCK #15 ---

	slot24 = if item_type then
	JUMP TO BLOCK #16
	else
	JUMP TO BLOCK #21
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #16 79-81, warpins: 1 ---
	--- END OF BLOCK #16 ---

	slot25 = if not new_gear_items_by_type[item_type] then
	JUMP TO BLOCK #17
	else
	JUMP TO BLOCK #18
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #17 82-82, warpins: 1 ---
	slot25 = {}
	--- END OF BLOCK #17 ---

	FLOW; TARGET BLOCK #18



	-- Decompilation error in this vicinity:
	--- BLOCK #18 83-87, warpins: 2 ---
	new_gear_items_by_type[item_type] = slot25
	new_gear_items_by_type[item_type][gear_id] = true

	--- END OF BLOCK #18 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #21



	-- Decompilation error in this vicinity:
	--- BLOCK #19 88-90, warpins: 1 ---
	--- END OF BLOCK #19 ---

	slot24 = if new_items_list.is_character_data then
	JUMP TO BLOCK #20
	else
	JUMP TO BLOCK #21
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #20 91-94, warpins: 1 ---
	ItemUtils.unmark_item_id_as_new(gear_id)

	--- END OF BLOCK #20 ---

	FLOW; TARGET BLOCK #21



	-- Decompilation error in this vicinity:
	--- BLOCK #21 95-96, warpins: 6 ---
	--- END OF BLOCK #21 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #11



	-- Decompilation error in this vicinity:
	--- BLOCK #22 97-97, warpins: 1 ---
	--- END OF BLOCK #22 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #10



	-- Decompilation error in this vicinity:
	--- BLOCK #23 98-100, warpins: 1 ---
	return new_gear_items, new_gear_items_by_type
	--- END OF BLOCK #23 ---



end

InventoryBackgroundView.is_inventory_synced = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	--- END OF BLOCK #0 ---

	if self._inventory_synced == nil then
	JUMP TO BLOCK #1
	else
	JUMP TO BLOCK #2
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #1 4-6, warpins: 1 ---
	slot1 = not self._check_for_loadout_update_timeout
	--- END OF BLOCK #1 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #4



	-- Decompilation error in this vicinity:
	--- BLOCK #2 7-8, warpins: 1 ---
	slot1 = false
	--- END OF BLOCK #2 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #4



	-- Decompilation error in this vicinity:
	--- BLOCK #3 9-9, warpins: 0 ---
	slot1 = true

	--- END OF BLOCK #3 ---

	FLOW; TARGET BLOCK #4



	-- Decompilation error in this vicinity:
	--- BLOCK #4 10-10, warpins: 3 ---
	return slot1
	--- END OF BLOCK #4 ---



end

InventoryBackgroundView._get_inventory_item_by_id = function (self, gear_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	--- END OF BLOCK #0 ---

	slot1 = if not gear_id then
	JUMP TO BLOCK #1
	else
	JUMP TO BLOCK #2
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #1 3-3, warpins: 1 ---
	return

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 4-8, warpins: 2 ---
	local inventory_items = self._inventory_items

	--- END OF BLOCK #2 ---

	for _, item in pairs(inventory_items)


	LOOP BLOCK #3
	GO OUT TO BLOCK #6



	-- Decompilation error in this vicinity:
	--- BLOCK #3 9-11, warpins: 1 ---
	--- END OF BLOCK #3 ---

	if item.gear_id == gear_id then
	JUMP TO BLOCK #4
	else
	JUMP TO BLOCK #5
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #4 12-12, warpins: 1 ---
	return item
	--- END OF BLOCK #4 ---

	FLOW; TARGET BLOCK #5



	-- Decompilation error in this vicinity:
	--- BLOCK #5 13-14, warpins: 3 ---
	--- END OF BLOCK #5 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #6 15-15, warpins: 1 ---
	return
	--- END OF BLOCK #6 ---



end

InventoryBackgroundView._update_loadout_validation = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	--- END OF BLOCK #0 ---

	slot1 = if self._profile_presets_element then
	JUMP TO BLOCK #1
	else
	JUMP TO BLOCK #2
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #1 4-11, warpins: 1 ---
	self._profile_presets_element:sync_profiles_states()
	self:_update_presets_missing_warning_marker()
	--- END OF BLOCK #1 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #4



	-- Decompilation error in this vicinity:
	--- BLOCK #2 12-14, warpins: 1 ---
	--- END OF BLOCK #2 ---

	slot1 = if self._current_profile_equipped_items then
	JUMP TO BLOCK #3
	else
	JUMP TO BLOCK #4
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #3 15-18, warpins: 1 ---
	self:_validate_loadout(self._current_profile_equipped_items)
	--- END OF BLOCK #3 ---

	FLOW; TARGET BLOCK #4



	-- Decompilation error in this vicinity:
	--- BLOCK #4 19-22, warpins: 3 ---
	self:_update_valid_items_list()

	return
	--- END OF BLOCK #4 ---



end

InventoryBackgroundView._update_valid_items_list = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	--- END OF BLOCK #0 ---

	slot1 = if not self._valid_profile_equipped_items then
	JUMP TO BLOCK #1
	else
	JUMP TO BLOCK #2
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #1 4-4, warpins: 1 ---
	slot1 = {}
	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 5-9, warpins: 2 ---
	self._valid_profile_equipped_items = slot1

	--- END OF BLOCK #2 ---

	for slot_name, item in pairs(self._current_profile_equipped_items)

	LOOP BLOCK #3
	GO OUT TO BLOCK #11



	-- Decompilation error in this vicinity:
	--- BLOCK #3 10-15, warpins: 1 ---
	--- END OF BLOCK #3 ---

	slot6 = if not self:_get_inventory_item_by_id(item.gear_id)

	 then
	JUMP TO BLOCK #4
	else
	JUMP TO BLOCK #5
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #4 16-16, warpins: 1 ---
	local valid_item = item.always_owned
	--- END OF BLOCK #4 ---

	FLOW; TARGET BLOCK #5



	-- Decompilation error in this vicinity:
	--- BLOCK #5 17-18, warpins: 2 ---
	--- END OF BLOCK #5 ---

	slot6 = if valid_item then
	JUMP TO BLOCK #6
	else
	JUMP TO BLOCK #10
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #6 19-22, warpins: 1 ---
	--- END OF BLOCK #6 ---

	slot7 = if not self._invalid_slots[slot_name] then
	JUMP TO BLOCK #7
	else
	JUMP TO BLOCK #10
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #7 23-26, warpins: 1 ---
	--- END OF BLOCK #7 ---

	slot7 = if not self._modified_slots[slot_name] then
	JUMP TO BLOCK #8
	else
	JUMP TO BLOCK #10
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #8 27-30, warpins: 1 ---
	--- END OF BLOCK #8 ---

	slot7 = if not self._duplicated_slots[slot_name] then
	JUMP TO BLOCK #9
	else
	JUMP TO BLOCK #10
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #9 31-32, warpins: 1 ---
	self._valid_profile_equipped_items[slot_name] = item

	--- END OF BLOCK #9 ---

	FLOW; TARGET BLOCK #10



	-- Decompilation error in this vicinity:
	--- BLOCK #10 33-34, warpins: 6 ---
	--- END OF BLOCK #10 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #11 35-35, warpins: 1 ---
	return
	--- END OF BLOCK #11 ---



end

return InventoryBackgroundView
