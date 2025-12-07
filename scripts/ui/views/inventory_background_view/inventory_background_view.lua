-- chunkname: @scripts/ui/views/inventory_background_view/inventory_background_view.lua

local Breeds = require("scripts/settings/breed/breeds")
local Definitions = require("scripts/ui/views/inventory_background_view/inventory_background_view_definitions")
local InventoryBackgroundViewSettings = require("scripts/ui/views/inventory_background_view/inventory_background_view_settings")
local Items = require("scripts/utilities/items")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local MasterItems = require("scripts/backend/master_items")
local Mastery = require("scripts/utilities/mastery")
local PlayerProgressionUnlocks = require("scripts/settings/player/player_progression_unlocks")
local ProfileUtils = require("scripts/utilities/profile_utils")
local Promise = require("scripts/foundation/utilities/promise")
local ScriptCamera = require("scripts/foundation/utilities/script_camera")
local TalentLayoutParser = require("scripts/ui/views/talent_builder_view/utilities/talent_layout_parser")
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
local ITEM_TYPES = UISettings.ITEM_TYPES
local ALLOWED_DUPLICATE_SLOTS = InventoryBackgroundViewSettings.allowed_duplicate_slots
local ALLOWED_EMPTY_SLOTS = InventoryBackgroundViewSettings.allowed_empty_slots
local IGNORED_SLOTS = InventoryBackgroundViewSettings.ignored_validation_slots
local InventoryBackgroundView = class("InventoryBackgroundView", "BaseView")

InventoryBackgroundView.init = function (self, settings, context)
	self._context = context

	local player = context and context.player or self:_player()

	if not player or player.__deleted then
		return
	end

	self._preview_player = player
	self.show_locked_cosmetics = true
	self._is_own_player = self._preview_player == self:_player()
	self._is_readonly = context and context.is_readonly

	local profile = self._preview_player and self._preview_player:profile()

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

	local player = self._preview_player

	if not player or player.__deleted then
		self:_handle_back_pressed()

		return
	end

	local profile = player:profile()
	local player_unit = player.player_unit
	local unit_data = ScriptUnit.has_extension(player_unit, "unit_data_system")
	local inventory_component = unit_data and unit_data:read_component("inventory")
	local wielded_slot = inventory_component and inventory_component.wielded_slot ~= "slot_unarmed" and inventory_component.wielded_slot or "slot_primary"

	self:_set_preview_wield_slot_name(wielded_slot)

	self._has_empty_talent_nodes = false
	self._has_empty_specialization_talent_nodes = false

	self:_register_event("event_inventory_view_equip_item", "event_inventory_view_equip_item")
	self:_register_event("event_equip_local_changes", "event_equip_local_changes")
	self:_register_event("event_force_refresh_inventory", "event_force_refresh_inventory")
	self:_register_event("event_change_wield_slot", "event_change_wield_slot")
	self:_register_event("event_discard_items", "event_discard_items")
	self:_register_event("event_player_profile_updated", "event_player_profile_updated")
	self:_register_event("event_player_talent_node_updated", "event_player_talent_node_updated")
	self:_register_event("event_player_specialization_talent_node_updated", "event_player_specialization_talent_node_updated")
	self:_register_event("event_item_icon_updated", "event_item_icon_updated")
	self:_register_event("event_switch_mark", "event_switch_mark")
	self:_register_event("event_mastery_traits_update", "event_mastery_traits_update")
	self:_setup_input_legend()
	self:_setup_background_world()

	local profile_archetype = profile.archetype

	self:_setup_background_frames_by_archetype(profile)

	local talent_layout_file_path = profile_archetype and profile_archetype.talent_layout_file_path

	self._active_talent_loadout = talent_layout_file_path and require(talent_layout_file_path)

	local specialization_talent_layout_file_path = profile_archetype and profile_archetype.specialization_talent_layout_file_path

	self._active_specialization_talent_loadout = specialization_talent_layout_file_path and require(specialization_talent_layout_file_path)
	self._talent_icons_package_id = Managers.data_service.talents:load_icons_for_profile(profile, "InventoryBackgroundView")
	self._specialization_talents_icons_package_id = Managers.data_service.specialization_talent:load_icons_for_profile(profile, "InventoryBackgroundView")
	self._widgets_by_name.character_insigna.content.visible = false
end

InventoryBackgroundView._valid_slot_for_archetype = function (self, slot_name)
	if not ItemSlotSettings[slot_name] then
		return false
	end

	if IGNORED_SLOTS[slot_name] then
		return false
	end

	if not ItemSlotSettings[slot_name].equipped_in_inventory then
		return false
	end

	if not ItemSlotSettings[slot_name].archetype_restrictions then
		return true
	end

	local player = self._preview_player
	local profile = player:profile()
	local profile_archetype = profile.archetype
	local archetype_name = profile_archetype.name

	return not not table.find(ItemSlotSettings[slot_name].archetype_restrictions, archetype_name)
end

InventoryBackgroundView.event_switch_mark = function (self, gear_id, mark_id, item)
	Managers.data_service.mastery:switch_mark(gear_id, mark_id):next(function (data)
		if self._destroyed then
			return
		end

		Managers.data_service.gear:invalidate_gear_cache()

		local player = self._preview_player
		local character_id = player:character_id()

		return Managers.data_service.gear:fetch_inventory(character_id)
	end):next(function (items)
		self._inventory_items = items

		local item
		local inventory_items = self._inventory_items

		for _, inventory_item in pairs(inventory_items) do
			if inventory_item.gear_id == gear_id then
				item = inventory_item

				break
			end
		end

		if item then
			local slot = item.slots[1]
			local presets = ProfileUtils.get_profile_presets()

			if presets then
				for i = 1, #presets do
					local preset = presets[i]
					local loadout = preset and preset.loadout
					local preset_gear_id = loadout and loadout[slot]

					if preset_gear_id and preset_gear_id == gear_id then
						loadout[slot] = item.gear_id
					end
				end
			end

			if self._current_profile_equipped_items[slot].gear_id == gear_id then
				self._current_profile_equipped_items[slot] = item
			end

			if self._preview_profile_equipped_items[slot].gear_id == gear_id then
				self._preview_profile_equipped_items[slot] = item
			end

			local profile = self._presentation_profile
			local loadout = profile and profile.loadout

			if loadout and loadout[slot] and loadout[slot].gear_id == gear_id then
				loadout[slot] = item
			end

			Managers.event:trigger("event_switch_mark_complete", item)
		end
	end)
end

InventoryBackgroundView._setup_background_frames_by_archetype = function (self, profile)
	local archetype = profile.archetype
	local inventory_frames_by_archetype = UISettings.inventory_frames_by_archetype
	local frame_textures = inventory_frames_by_archetype[archetype.name]

	if frame_textures.by_home_planet then
		local planet = profile.lore.backstory.planet

		frame_textures = frame_textures.by_home_planet[planet] or frame_textures
	end

	local widgets_by_name = self._widgets_by_name

	widgets_by_name.corner_top_left.content.texture = frame_textures.left_upper
	widgets_by_name.corner_bottom_left.content.texture = frame_textures.left_lower
	widgets_by_name.corner_top_right.content.texture = frame_textures.right_upper
	widgets_by_name.corner_bottom_right.content.texture = frame_textures.right_lower
end

InventoryBackgroundView._set_player_profile_information = function (self, player)
	local profile = player:profile()
	local character_name = player:name()
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
	local load_cb = callback(self, "_cb_set_player_icon", profile)
	local unload_cb = callback(self, "_cb_unset_player_icon")
	local icon_load_id = Managers.ui:load_profile_portrait(profile, load_cb, nil, unload_cb)

	self._portrait_loaded_info = {
		icon_load_id = icon_load_id,
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

InventoryBackgroundView._cb_set_player_icon = function (self, profile, grid_index, rows, columns, render_target)
	local widget = self._widgets_by_name.character_portrait

	widget.content.texture = self:_get_player_portrait_frame_material(profile)

	local material_values = widget.style.texture_portrait.material_values

	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.texture_icon = render_target
end

InventoryBackgroundView._cb_unset_player_icon = function (self, widget)
	local portrait_widget = self._widgets_by_name.character_portrait
	local material_values = portrait_widget.style.texture_portrait.material_values

	material_values.use_placeholder_texture = nil
	material_values.rows = nil
	material_values.columns = nil
	material_values.grid_index = nil
	material_values.texture_icon = nil
	portrait_widget.content.texture = "content/ui/materials/base/ui_portrait_frame_base_no_render"
end

InventoryBackgroundView._request_player_frame = function (self, item, ui_renderer)
	self:_unload_portrait_frame(ui_renderer)

	if item then
		self:_load_portrait_frame(item)
	end
end

InventoryBackgroundView._load_portrait_frame = function (self, item)
	local cb = callback(self, "_cb_set_player_frame")
	local icon_load_id = Managers.ui:load_item_icon(item, cb)

	self._frame_loaded_info = {
		icon_load_id = icon_load_id,
	}
end

InventoryBackgroundView._unload_portrait_frame = function (self, ui_renderer)
	local frame_loaded_info = self._frame_loaded_info

	if not frame_loaded_info then
		return
	end

	local widget = self._widgets_by_name.character_portrait

	if not self.destroyed then
		widget.content.texture = UISettings.portrait_frame_default_material

		local material_values = widget.style.texture_portrait.material_values

		material_values.portrait_frame_texture = "content/ui/textures/nameplates/portrait_frames/default"
	end

	UIWidget.set_visible(widget, ui_renderer, false)

	local icon_load_id = frame_loaded_info.icon_load_id

	Managers.ui:unload_item_icon(icon_load_id)

	self._frame_loaded_info = nil
end

InventoryBackgroundView._cb_set_player_frame = function (self, item)
	local widget = self._widgets_by_name.character_portrait
	local material_values = widget.style.texture_portrait.material_values

	if item.icon_material and item.icon_material ~= "" then
		if material_values.portrait_frame_texture then
			material_values.portrait_frame_texture = nil
		end

		widget.content.texture = item.icon_material
	else
		widget.content.texture = UISettings.portrait_frame_default_material
		material_values.portrait_frame_texture = item.icon
	end
end

InventoryBackgroundView._request_player_insignia = function (self, item, ui_renderer)
	self:_unload_insignia(ui_renderer)

	if item then
		self:_load_insignia(item)
	end
end

InventoryBackgroundView._load_insignia = function (self, item)
	local cb = callback(self, "_cb_set_player_insignia")
	local icon_load_id = Managers.ui:load_item_icon(item, cb)

	self._insignia_loaded_info = {
		icon_load_id = icon_load_id,
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

	UIWidget.set_visible(widget, ui_renderer, false)

	local icon_load_id = insignia_loaded_info.icon_load_id

	Managers.ui:unload_item_icon(icon_load_id)

	self._insignia_loaded_info = nil
	widget.content.visible = false
end

InventoryBackgroundView._cb_set_player_insignia = function (self, item)
	local widget = self._widgets_by_name.character_insigna
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

InventoryBackgroundView._get_player_portrait_frame_material = function (self, profile)
	local frame_material = UISettings.portrait_frame_default_material

	if profile and type(profile) == "table" then
		local loadout = profile.loadout

		if loadout then
			local frame_item = loadout.slot_portrait_frame

			if frame_item and frame_item.icon_material and frame_item.icon_material ~= "" then
				frame_material = frame_item.icon_material
			end
		end
	end

	return frame_material
end

InventoryBackgroundView._fetch_character_progression = function (self, player)
	if self._character_progression_promise then
		return
	end

	self._fetching_character_progression = true

	local profiles_promise
	local character_id = player:character_id()
	local authenticated = Managers.backend:authenticated()

	if authenticated then
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
	local experience_fraction_number = not is_nan and experience_fraction or 0

	if duration then
		self._experience_fraction_duration_time = 0
		self._experience_fraction_duration_delay = duration
		self._target_experience_fraction = experience_fraction_number
		experience_fraction_number = 0
	end

	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.character_experience

	widget.content.progress = experience_fraction_number
	self._current_experience_fraction = experience_fraction_number
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
			if self:_valid_slot_for_archetype(slot_name) then
				local item = loadout[slot_name]
				local equipped_item = preview_profile_equipped_items[slot_name]

				if item ~= equipped_item then
					preview_profile_equipped_items[slot_name] = item
					original_equips[slot_name] = item
					current_equips[slot_name] = item
				end
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
	self:_set_preview_wield_slot_name(slot_name)
	self:_update_presentation_wield_item()
end

InventoryBackgroundView.event_discard_items = function (self, gear_ids)
	local local_changes_promise = self:_equip_local_changes()
	local delete_promise

	if local_changes_promise then
		delete_promise = local_changes_promise:next(function ()
			return Managers.data_service.gear:delete_gear_batch(gear_ids)
		end)
	else
		delete_promise = Managers.data_service.gear:delete_gear_batch(gear_ids)
	end

	delete_promise:next(function (result)
		local total_rewards = {}

		if result then
			for ii = 1, #result do
				local operation = result[ii]
				local rewards = operation.rewards

				for jj = 1, #rewards do
					local reward = rewards[jj]
					local reward_type = reward.type

					total_rewards[reward_type] = (total_rewards[reward_type] or 0) + reward.amount
				end

				local gear_id = operation.gearId

				if gear_id then
					self._inventory_items[gear_id] = nil
				end
			end
		end

		if not table.is_empty(total_rewards) then
			Managers.event:trigger("event_force_wallet_update")

			for reward_type, reward_amount in pairs(total_rewards) do
				Managers.event:trigger("event_add_notification_message", "currency", {
					currency = reward_type,
					amount = reward_amount,
				})
			end
		end

		self:_update_loadout_validation()
	end)
end

InventoryBackgroundView.event_player_talent_node_updated = function (self, equipped_talents)
	self:_update_has_empty_talent_nodes(equipped_talents, self._current_profile_equipped_specialization_talents)

	self._current_profile_equipped_talents = equipped_talents

	self:_update_presets_missing_warning_marker()
end

InventoryBackgroundView.event_player_specialization_talent_node_updated = function (self, equipped_talents)
	self:_update_has_empty_talent_nodes(self._current_profile_equipped_talents, equipped_talents)

	self._current_profile_equipped_specialization_talents = equipped_talents

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
	local valid_item_change = item_gear_id and previous_item_gear_id and item_gear_id ~= previous_item_gear_id or type(item) == "table" and item.always_owned and type(previous_item) == "table" and item.name ~= previous_item.name or (item_gear_id or type(item) == "table" and item.always_owned) and not previous_item_gear_id or type(previous_item) == "table" and not not not item or force_update

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
	local current_preset_id = ProfileUtils.get_active_profile_preset_id()
	local current_preset = current_preset_id and ProfileUtils.get_profile_preset(current_preset_id)

	for slot_name, slot_data in pairs(ItemSlotSettings) do
		if self:_valid_slot_for_archetype(slot_name) and not self._invalid_slots[slot_name] and not self._duplicated_slots[slot_name] then
			local previous_item = original_equips[slot_name]
			local item = preview_loadout[slot_name]
			local item_gear_id = type(item) == "table" and item.gear_id or type(item) == "string" and item
			local previous_item_gear_id = type(previous_item) == "table" and previous_item.gear_id or type(previous_item) == "string" and previous_item
			local valid_item_change = item_gear_id and previous_item_gear_id and item_gear_id ~= previous_item_gear_id or type(item) == "table" and item.always_owned and type(previous_item) == "table" and item.name ~= previous_item.name or (item_gear_id or type(item) == "table" and item.always_owned) and not previous_item_gear_id or type(previous_item) == "table" and not not not item or item_gear_id and previous_item_gear_id and item_gear_id == previous_item_gear_id and previous_item.name ~= item.name

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

			if current_preset and self._modified_slots[slot_name] then
				ProfileUtils.save_item_id_for_profile_preset(current_preset_id, slot_name, item_gear_id)
			end
		end
	end

	local promises = {}

	if equip_items and not table.is_empty(equip_items_by_slot) then
		promises[#promises + 1] = Items.equip_slot_items(equip_items_by_slot)
	end

	if equip_items and not table.is_empty(equip_local_items_by_slot) then
		promises[#promises + 1] = Items.equip_slot_master_items(equip_local_items_by_slot)
	end

	if equip_items and not table.is_empty(unequip_slots) then
		promises[#promises + 1] = Items.unequip_slots(unequip_slots)
	end

	if #promises > 0 then
		return Promise.all(unpack(promises))
	end
end

InventoryBackgroundView._handle_back_pressed = function (self)
	self:_switch_active_view(nil)
	Managers.ui:close_view(self.view_name)
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

InventoryBackgroundView.cb_on_help_pressed = function (self)
	local active_view = self._active_view
	local view_instance = Managers.ui:view_instance(active_view)

	view_instance:cb_on_help_pressed()
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
	local slot_name = self._preview_wield_slot_name

	slot_name = slot_name == "slot_primary" and "slot_secondary" or "slot_primary"

	self:_play_sound(UISoundEvents.weapons_swap)
	self:_set_preview_wield_slot_name(slot_name)
	self:_update_presentation_wield_item()
end

InventoryBackgroundView.has_new_items_by_type = function (self, item_type)
	return not not self._new_items_gear_ids_by_type[item_type] and not not not table.is_empty(self._new_items_gear_ids_by_type[item_type])
end

InventoryBackgroundView._update_has_empty_talent_nodes = function (self, optional_talent_nodes, optional_specialization_talent_nodes)
	local player = self:_player()
	local profile = player:profile()

	if profile then
		self._has_empty_talent_nodes = TalentLayoutParser.profile_percent_points_used(profile, optional_talent_nodes) < 1
		self._has_empty_specialization_talent_nodes = TalentLayoutParser.profile_percent_specialization_points_used(profile, optional_specialization_talent_nodes) < 1
	end
end

InventoryBackgroundView._setup_top_panel = function (self)
	local reference_name = "top_panel"
	local layer = 100

	self._top_panel = self:_add_element(ViewElementMenuPanel, reference_name, layer)

	local player = self._preview_player
	local profile = player:profile()
	local profile_archetype = profile.archetype
	local archetype_name = profile_archetype.name
	local is_ogryn = archetype_name == "ogryn"
	local has_slot_companion_gear_full = profile.loadout.slot_companion_gear_full
	local inventory_view = {
		display_name = "loc_inventory_view_display_name",
		view_name = "inventory_view",
		update = function (content, style, dt)
			content.hotspot.disabled = not self:is_inventory_synced()

			if not self._is_own_player or self._is_readonly then
				return false
			end

			local has_new_items = false

			if self:has_new_items_by_type(ITEM_TYPES.WEAPON_MELEE) then
				has_new_items = true
			elseif self:has_new_items_by_type(ITEM_TYPES.WEAPON_RANGED) then
				has_new_items = true
			elseif self:has_new_items_by_type(ITEM_TYPES.GADGET) then
				has_new_items = true
			end

			content.show_alert = has_new_items
			content.show_warning = self:_has_loadout_slot(self._invalid_slots)
			content.show_modified = self:_has_loadout_slot(self._modified_slots)
		end,
		view_context = {
			tabs = {
				{
					allow_item_hover_information = true,
					is_grid_layout = false,
					telemetry_name = "inventory_view_loadout",
					ui_animation = "loadout_on_enter",
					draw_wallet = self._is_own_player and not self._is_readonly,
					camera_settings = {
						{
							"event_inventory_set_target_camera_offset",
							0,
							0,
							0,
						},
						{
							"event_inventory_set_target_camera_rotation",
							false,
						},
						{
							"event_inventory_set_camera_default_focus",
						},
					},
					layout = {
						{
							default_icon = "content/ui/materials/icons/items/weapons/melee/empty",
							loadout_slot = true,
							scenegraph_id = "slot_primary",
							slot_title = "loc_inventory_title_slot_primary",
							widget_type = "item_slot",
							slot = ItemSlotSettings.slot_primary,
							navigation_grid_indices = {
								1,
								1,
							},
							item_type = ITEM_TYPES.WEAPON_MELEE,
							has_new_items_update_callback = function (item_type)
								return self:has_new_items_by_type(item_type)
							end,
						},
						{
							default_icon = "content/ui/materials/icons/items/weapons/ranged/empty",
							loadout_slot = true,
							scenegraph_id = "slot_secondary",
							slot_title = "loc_inventory_title_slot_secondary",
							widget_type = "item_slot",
							slot = ItemSlotSettings.slot_secondary,
							navigation_grid_indices = {
								2,
								1,
							},
							item_type = ITEM_TYPES.WEAPON_RANGED,
							has_new_items_update_callback = function (item_type)
								return self:has_new_items_by_type(item_type)
							end,
						},
						{
							display_name = "loc_inventory_loadout_group_attachments",
							scenegraph_id = "slot_attachments_header",
							widget_type = "item_sub_header",
							item_type = ITEM_TYPES.GADGET,
							size = {
								840,
								50,
							},
							new_indicator_width_offset = {
								183,
								-20,
								4,
							},
							has_new_items_update_callback = function (item_type)
								return self:has_new_items_by_type(item_type)
							end,
						},
						{
							default_icon = "content/ui/materials/icons/items/attachments/defensive/empty",
							loadout_slot = true,
							scenegraph_id = "slot_attachment_1",
							slot_title = "loc_inventory_title_slot_attachment_1",
							widget_type = "gadget_item_slot",
							slot = ItemSlotSettings.slot_attachment_1,
							required_level = PlayerProgressionUnlocks.gadget_slot_1,
							navigation_grid_indices = {
								3,
								1,
							},
							item_type = ITEM_TYPES.GADGET,
							has_new_items_update_callback = function (item_type)
								return self:has_new_items_by_type(item_type)
							end,
						},
						{
							default_icon = "content/ui/materials/icons/items/attachments/tactical/empty",
							loadout_slot = true,
							scenegraph_id = "slot_attachment_2",
							slot_title = "loc_inventory_title_slot_attachment_2",
							widget_type = "gadget_item_slot",
							slot = ItemSlotSettings.slot_attachment_2,
							required_level = PlayerProgressionUnlocks.gadget_slot_2,
							navigation_grid_indices = {
								3,
								2,
							},
							item_type = ITEM_TYPES.GADGET,
							has_new_items_update_callback = function (item_type)
								return self:has_new_items_by_type(item_type)
							end,
						},
						{
							default_icon = "content/ui/materials/icons/items/attachments/utility/empty",
							loadout_slot = true,
							scenegraph_id = "slot_attachment_3",
							slot_title = "loc_inventory_title_slot_attachment_3",
							widget_type = "gadget_item_slot",
							slot = ItemSlotSettings.slot_attachment_3,
							required_level = PlayerProgressionUnlocks.gadget_slot_3,
							navigation_grid_indices = {
								3,
								3,
							},
							item_type = ITEM_TYPES.GADGET,
							has_new_items_update_callback = function (item_type)
								return self:has_new_items_by_type(item_type)
							end,
						},
						{
							display_name = "loc_inventory_loadout_group_primary_weapon",
							scenegraph_id = "slot_primary_header",
							widget_type = "item_sub_header",
							item_type = ITEM_TYPES.WEAPON_MELEE,
							size = {
								840,
								50,
							},
							new_indicator_width_offset = {
								243,
								-22,
								4,
							},
							has_new_items_update_callback = function (item_type)
								return self:has_new_items_by_type(item_type)
							end,
						},
						{
							display_name = "loc_inventory_loadout_group_secondary_weapon",
							scenegraph_id = "slot_secondary_header",
							widget_type = "item_sub_header",
							item_type = ITEM_TYPES.WEAPON_RANGED,
							size = {
								840,
								50,
							},
							new_indicator_width_offset = {
								211,
								-20,
								4,
							},
							has_new_items_update_callback = function (item_type)
								return self:has_new_items_by_type(item_type)
							end,
						},
						{
							scenegraph_id = "loadout_frame",
							texture = "content/ui/materials/frames/loadout_main",
							widget_type = "texture",
							size = {
								840,
								840,
							},
						},
						{
							scenegraph_id = "loadout_background_1",
							texture = "content/ui/materials/backgrounds/terminal_basic",
							widget_type = "texture",
							size = {
								640,
								380,
							},
							color = Color.terminal_grid_background(nil, true),
						},
						{
							scenegraph_id = "loadout_background_2",
							texture = "content/ui/materials/backgrounds/terminal_basic",
							widget_type = "texture",
							size = {
								700,
								320,
							},
							color = Color.terminal_grid_background(nil, true),
						},
					},
				},
			},
		},
	}
	local cosmetic_tabs_layout = {
		{
			default_icon = "content/ui/materials/icons/items/gears/head/empty",
			loadout_slot = true,
			scenegraph_id = "slot_gear_head",
			slot_icon = "content/ui/materials/icons/item_types/beveled/headgears",
			slot_title = "loc_inventory_title_slot_gear_head",
			widget_type = "gear_item_slot",
			slot = ItemSlotSettings.slot_gear_head,
			navigation_grid_indices = {
				1,
				1,
			},
			item_type = ITEM_TYPES.GEAR_HEAD,
			has_new_items_update_callback = function (item_type)
				return self:has_new_items_by_type(item_type)
			end,
		},
		{
			default_icon = "content/ui/materials/icons/items/gears/arms/empty",
			loadout_slot = true,
			scenegraph_id = "slot_gear_upperbody",
			slot_icon = "content/ui/materials/icons/item_types/beveled/upper_bodies",
			slot_title = "loc_inventory_title_slot_gear_upperbody",
			widget_type = "gear_item_slot",
			slot = ItemSlotSettings.slot_gear_upperbody,
			navigation_grid_indices = {
				2,
				1,
			},
			item_type = ITEM_TYPES.GEAR_UPPERBODY,
			has_new_items_update_callback = function (item_type)
				return self:has_new_items_by_type(item_type)
			end,
		},
		{
			default_icon = "content/ui/materials/icons/items/gears/legs/empty",
			loadout_slot = true,
			scenegraph_id = "slot_gear_lowerbody",
			slot_icon = "content/ui/materials/icons/item_types/beveled/lower_bodies",
			slot_title = "loc_inventory_title_slot_gear_lowerbody",
			widget_type = "gear_item_slot",
			slot = ItemSlotSettings.slot_gear_lowerbody,
			navigation_grid_indices = {
				3,
				1,
			},
			item_type = ITEM_TYPES.GEAR_LOWERBODY,
			has_new_items_update_callback = function (item_type)
				return self:has_new_items_by_type(item_type)
			end,
		},
		{
			default_icon = "content/ui/materials/icons/items/gears/legs/empty",
			loadout_slot = true,
			scenegraph_id = "slot_gear_extra_cosmetic",
			slot_icon = "content/ui/materials/icons/item_types/beveled/accessories",
			slot_title = "loc_inventory_title_slot_gear_extra_cosmetic",
			widget_type = "gear_item_slot",
			slot = ItemSlotSettings.slot_gear_extra_cosmetic,
			navigation_grid_indices = {
				1,
				2,
			},
			initial_rotation = math.pi,
			item_type = ITEM_TYPES.GEAR_EXTRA_COSMETIC,
			has_new_items_update_callback = function (item_type)
				return self:has_new_items_by_type(item_type)
			end,
		},
		{
			default_icon = "content/ui/materials/icons/items/gears/legs/empty",
			loadout_slot = true,
			scenegraph_id = "slot_portrait_frame",
			slot_title = "loc_inventory_title_slot_portrait_frame",
			widget_type = "ui_item_slot",
			slot = ItemSlotSettings.slot_portrait_frame,
			navigation_grid_indices = {
				2,
				2,
			},
			item_type = ITEM_TYPES.PORTRAIT_FRAME,
			has_new_items_update_callback = function (item_type)
				return self:has_new_items_by_type(item_type)
			end,
		},
		{
			default_icon = "content/ui/materials/icons/items/gears/legs/empty",
			loadout_slot = true,
			scenegraph_id = "slot_insignia",
			slot_title = "loc_inventory_title_slot_insignia",
			widget_type = "ui_item_slot",
			slot = ItemSlotSettings.slot_insignia,
			navigation_grid_indices = {
				3,
				2,
			},
			item_type = ITEM_TYPES.CHARACTER_INSIGNIA,
			has_new_items_update_callback = function (item_type)
				return self:has_new_items_by_type(item_type)
			end,
		},
		{
			default_icon = "content/ui/materials/icons/items/gears/head/empty",
			loadout_slot = true,
			scenegraph_id = "slot_character_title",
			slot_icon = "content/ui/materials/icons/item_types/beveled/headgears",
			slot_title = "loc_inventory_title_slot_character_title",
			widget_type = "character_title_item_slot",
			slot = ItemSlotSettings.slot_character_title,
			navigation_grid_indices = {
				4,
				1,
			},
			item_type = ITEM_TYPES.CHARACTER_TITLE,
			has_new_items_update_callback = function (item_type)
				return self:has_new_items_by_type(item_type)
			end,
		},
	}

	if has_slot_companion_gear_full then
		cosmetic_tabs_layout[#cosmetic_tabs_layout + 1] = {
			default_icon = "content/ui/materials/icons/items/gears/legs/empty",
			loadout_slot = true,
			scenegraph_id = "slot_companion_gear_full",
			slot_icon = "content/ui/materials/icons/item_types/beveled/companion_gear_full",
			slot_title = "loc_inventory_title_slot_companion_gear_full",
			widget_type = "gear_item_slot",
			slot = ItemSlotSettings.slot_companion_gear_full,
			navigation_grid_indices = {
				3,
				1,
			},
			item_type = ITEM_TYPES.COMPANION_GEAR_FULL,
			has_new_items_update_callback = function (item_type)
				return self:has_new_items_by_type(item_type)
			end,
		}
	end

	if not self._is_readonly then
		cosmetic_tabs_layout[#cosmetic_tabs_layout + 1] = {
			default_icon = "content/ui/materials/icons/items/gears/legs/empty",
			display_name = "loc_inventory_title_slot_animation_end_of_round",
			loadout_slot = true,
			scenegraph_id = "button_expressions",
			slot_title = "loc_inventory_title_slot_animation_end_of_round",
			widget_type = "pose_item_slot",
			size = {
				64,
				64,
			},
			slot = ItemSlotSettings.slot_animation_end_of_round,
			navigation_grid_indices = {
				6,
				3,
			},
			item_type = ITEM_TYPES.END_OF_ROUND,
			has_new_items_update_callback = function (item_type)
				return self:has_new_items_by_type(item_type)
			end,
		}
		cosmetic_tabs_layout[#cosmetic_tabs_layout + 1] = {
			animation_event_name_suffix = "_instant",
			default_icon = "content/ui/materials/icons/items/gears/legs/empty",
			disable_rotation_input = false,
			display_name = "loc_inventory_title_slot_animation_emote_1",
			loadout_slot = true,
			scenegraph_id = "button_emote_1",
			slot_title = "loc_inventory_title_slot_animation_emote_1",
			widget_type = "emote_item_slot",
			size = {
				64,
				64,
			},
			slot = ItemSlotSettings.slot_animation_emote_1,
			navigation_grid_indices = {
				1,
				3,
			},
			animation_event_variable_data = {
				index = "in_menu",
				value = 1,
			},
			item_type = ITEM_TYPES.EMOTE,
			has_new_items_update_callback = function (item_type)
				return self:has_new_items_by_type(item_type)
			end,
		}
		cosmetic_tabs_layout[#cosmetic_tabs_layout + 1] = {
			animation_event_name_suffix = "_instant",
			default_icon = "content/ui/materials/icons/items/gears/legs/empty",
			disable_rotation_input = false,
			display_name = "loc_inventory_title_slot_animation_emote_2",
			loadout_slot = true,
			scenegraph_id = "button_emote_2",
			slot_title = "loc_inventory_title_slot_animation_emote_2",
			widget_type = "emote_item_slot",
			size = {
				64,
				64,
			},
			slot = ItemSlotSettings.slot_animation_emote_2,
			navigation_grid_indices = {
				2,
				3,
			},
			animation_event_variable_data = {
				index = "in_menu",
				value = 1,
			},
			item_type = ITEM_TYPES.EMOTE,
			has_new_items_update_callback = function (item_type)
				return self:has_new_items_by_type(item_type)
			end,
		}
		cosmetic_tabs_layout[#cosmetic_tabs_layout + 1] = {
			animation_event_name_suffix = "_instant",
			default_icon = "content/ui/materials/icons/items/gears/legs/empty",
			disable_rotation_input = false,
			display_name = "loc_inventory_title_slot_animation_emote_3",
			loadout_slot = true,
			scenegraph_id = "button_emote_3",
			slot_title = "loc_inventory_title_slot_animation_emote_3",
			widget_type = "emote_item_slot",
			size = {
				64,
				64,
			},
			slot = ItemSlotSettings.slot_animation_emote_3,
			navigation_grid_indices = {
				3,
				3,
			},
			animation_event_variable_data = {
				index = "in_menu",
				value = 1,
			},
			item_type = ITEM_TYPES.EMOTE,
			has_new_items_update_callback = function (item_type)
				return self:has_new_items_by_type(item_type)
			end,
		}
		cosmetic_tabs_layout[#cosmetic_tabs_layout + 1] = {
			animation_event_name_suffix = "_instant",
			default_icon = "content/ui/materials/icons/items/gears/legs/empty",
			disable_rotation_input = false,
			display_name = "loc_inventory_title_slot_animation_emote_4",
			loadout_slot = true,
			scenegraph_id = "button_emote_4",
			slot_title = "loc_inventory_title_slot_animation_emote_4",
			widget_type = "emote_item_slot",
			size = {
				64,
				64,
			},
			slot = ItemSlotSettings.slot_animation_emote_4,
			navigation_grid_indices = {
				2,
				3,
			},
			animation_event_variable_data = {
				index = "in_menu",
				value = 1,
			},
			item_type = ITEM_TYPES.EMOTE,
			has_new_items_update_callback = function (item_type)
				return self:has_new_items_by_type(item_type)
			end,
		}
		cosmetic_tabs_layout[#cosmetic_tabs_layout + 1] = {
			animation_event_name_suffix = "_instant",
			default_icon = "content/ui/materials/icons/items/gears/legs/empty",
			disable_rotation_input = false,
			display_name = "loc_inventory_title_slot_animation_emote_5",
			loadout_slot = true,
			scenegraph_id = "button_emote_5",
			slot_title = "loc_inventory_title_slot_animation_emote_5",
			widget_type = "emote_item_slot",
			size = {
				64,
				64,
			},
			slot = ItemSlotSettings.slot_animation_emote_5,
			navigation_grid_indices = {
				5,
				3,
			},
			animation_event_variable_data = {
				index = "in_menu",
				value = 1,
			},
			item_type = ITEM_TYPES.EMOTE,
			has_new_items_update_callback = function (item_type)
				return self:has_new_items_by_type(item_type)
			end,
		}
	end

	local inventory_cosmetics_view = {
		display_name = "loc_cosmetics_view_display_name",
		view_name = "inventory_view",
		update = function (content, style, dt)
			content.hotspot.disabled = not self:is_inventory_synced()

			if not self._is_own_player or self._is_readonly then
				return false
			end

			local has_new_items = false

			if self:has_new_items_by_type(ITEM_TYPES.GEAR_HEAD) then
				has_new_items = true
			elseif self:has_new_items_by_type(ITEM_TYPES.GEAR_UPPERBODY) then
				has_new_items = true
			elseif self:has_new_items_by_type(ITEM_TYPES.GEAR_LOWERBODY) then
				has_new_items = true
			elseif self:has_new_items_by_type(ITEM_TYPES.GEAR_EXTRA_COSMETIC) then
				has_new_items = true
			elseif self:has_new_items_by_type(ITEM_TYPES.COMPANION_GEAR_FULL) then
				has_new_items = true
			elseif self:has_new_items_by_type(ITEM_TYPES.PORTRAIT_FRAME) then
				has_new_items = true
			elseif self:has_new_items_by_type(ITEM_TYPES.CHARACTER_INSIGNIA) then
				has_new_items = true
			elseif self:has_new_items_by_type(ITEM_TYPES.CHARACTER_TITLE) then
				has_new_items = true
			elseif self:has_new_items_by_type(ITEM_TYPES.EMOTE) then
				has_new_items = true
			elseif self:has_new_items_by_type(ITEM_TYPES.END_OF_ROUND) then
				has_new_items = true
			end

			content.show_alert = has_new_items
			content.show_warning = self:_has_cosmetic_slot(self._invalid_slots)
			content.show_modified = self:_has_cosmetic_slot(self._modified_slots)
		end,
		view_context = {
			tabs = {
				{
					allow_item_hover_information = true,
					display_name = "tab1",
					draw_wallet = false,
					icon = "content/ui/materials/icons/item_types/outfits",
					is_grid_layout = false,
					telemetry_name = "inventory_view_cosmetics",
					ui_animation = "cosmetics_on_enter",
					camera_settings = {
						{
							"event_inventory_set_target_camera_offset",
							is_ogryn and 1.2 or 0.85,
							0,
							0,
						},
						{
							"event_inventory_set_target_camera_rotation",
							false,
						},
						{
							"event_inventory_set_camera_default_focus",
						},
					},
					item_hover_information_offset = {
						0,
					},
					layout = cosmetic_tabs_layout,
				},
			},
		},
	}

	self._views_settings = {
		inventory_view,
		inventory_cosmetics_view,
	}

	if self._is_own_player and not self._is_readonly then
		self._views_settings[#self._views_settings + 1] = {
			display_name = "loc_masteries_view_display_name",
			view_name = "masteries_overview_view",
			update = function (content, style, dt)
				content.show_alert = self._has_mastery_points_available
			end,
			context = {
				can_exit = true,
				player_mode = true,
			},
			enter = function ()
				if self._transition_animation_id and self:_is_animation_active(self._transition_animation_id) then
					self.transition_animation_id = self:_stop_animation(self._transition_animation_id)
				end

				self.transition_animation_id = self:_start_animation("transition_fade", self._widgets_by_name, self)

				self:_remove_profile_presets()
			end,
			leave = function ()
				if self._transition_animation_id and self:_is_animation_active(self._transition_animation_id) then
					self.transition_animation_id = self:_stop_animation(self._transition_animation_id)
				end

				self.transition_animation_id = self:_start_animation("transition_fade", self._widgets_by_name, self)

				self:_setup_profile_presets()

				return {
					force_instant_camera = true,
				}
			end,
			view_context = {
				can_exit = true,
				draw_wallet = false,
				player_mode = true,
				mastery_traits = self._mastery_traits,
				camera_settings = {
					{
						"event_mastery_set_camera",
						true,
					},
				},
			},
		}
	end

	self:_update_has_empty_talent_nodes()

	self._views_settings[#self._views_settings + 1] = {
		display_name = "loc_talent_view_display_name",
		view_name = "talent_builder_view",
		update = function (content, style, dt)
			content.hotspot.disabled = not self:is_inventory_synced()

			if not self._is_own_player or self._is_readonly then
				return
			end

			content.show_alert = self._has_empty_talent_nodes
			content.show_modified = self._warning_talent
		end,
		context = {
			can_exit = true,
			player_mode = true,
		},
		enter = function ()
			if self._transition_animation_id and self:_is_animation_active(self._transition_animation_id) then
				self.transition_animation_id = self:_stop_animation(self._transition_animation_id)
			end

			self.transition_animation_id = self:_start_animation("transition_fade", self._widgets_by_name, self)
		end,
		leave = function ()
			if self._transition_animation_id and self:_is_animation_active(self._transition_animation_id) then
				self.transition_animation_id = self:_stop_animation(self._transition_animation_id)
			end

			self.transition_animation_id = self:_start_animation("transition_fade", self._widgets_by_name, self)

			return {
				force_instant_camera = true,
			}
		end,
		view_context = {
			can_exit = true,
			player_mode = true,
			camera_settings = {
				{
					"event_inventory_set_target_camera_offset",
					is_ogryn and 5.2 or 3.5,
					0,
					0,
				},
				{
					"event_inventory_set_target_camera_rotation",
					false,
				},
				{
					"event_inventory_set_camera_default_focus",
				},
			},
		},
	}

	if profile_archetype.specialization_talent_layout_file_path then
		local specialization_required_level = 5

		self._views_settings[#self._views_settings + 1] = {
			display_name = "loc_broker_stimm_builder_view_display_name",
			view_name = "broker_stimm_builder_view",
			update = function (content, style, dt)
				content.hotspot.disabled = not self:is_inventory_synced()

				if not self._preview_player or self._preview_player:profile().current_level < specialization_required_level then
					content.hotspot.disabled = true
					content.context_text = Localize("loc_requires_level", true, {
						level = specialization_required_level,
					})
				else
					content.context_text = nil
				end

				if not self._is_own_player or self._is_readonly then
					return
				end

				content.show_alert = self._has_empty_specialization_talent_nodes
				content.show_modified = self._warning_talent
			end,
			context = {
				can_exit = true,
				player_mode = true,
			},
			enter = function ()
				if self._transition_animation_id and self:_is_animation_active(self._transition_animation_id) then
					self.transition_animation_id = self:_stop_animation(self._transition_animation_id)
				end

				self.transition_animation_id = self:_start_animation("transition_fade", self._widgets_by_name, self)
			end,
			leave = function ()
				if self._transition_animation_id and self:_is_animation_active(self._transition_animation_id) then
					self.transition_animation_id = self:_stop_animation(self._transition_animation_id)
				end

				self.transition_animation_id = self:_start_animation("transition_fade", self._widgets_by_name, self)

				return {
					force_instant_camera = true,
				}
			end,
			view_context = {
				can_exit = true,
				player_mode = true,
				camera_settings = {
					{
						"event_inventory_set_target_camera_offset",
						is_ogryn and 5.2 or 3.5,
						0,
						0,
					},
					{
						"event_inventory_set_target_camera_rotation",
						false,
					},
					{
						"event_inventory_set_camera_default_focus",
					},
				},
			},
		}
	end

	local views_settings = self._views_settings

	for i = 1, #views_settings do
		local settings = views_settings[i]
		local view_name = settings.view_name
		local display_name
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
	local previous_panel_context_changes

	if old_settings and old_settings.leave then
		previous_panel_context_changes = old_settings.leave()
	end

	local settings = views_settings[index]
	local view_name = settings.view_name

	view_name = settings.resolve_function and settings.resolve_function() or view_name

	local new_view_context = table.clone(settings.view_context)
	local view_context = table.merge_recursive(new_view_context, previous_panel_context_changes or {})

	self:_switch_active_view(view_name, view_context)

	if index ~= old_top_panel_selection_index and not index then
		local actieve_view = self._active_view

		if actieve_view and Managers.ui:view_active(actieve_view) then
			Managers.ui:close_view(actieve_view)
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
	return self._active_view ~= "talent_builder_view" and self._active_view ~= "masteries_overview_view" and self._active_view ~= "broker_stimm_builder_view"
end

InventoryBackgroundView._force_select_panel_index = function (self, index)
	self:_on_panel_option_pressed(index)
	self._top_panel:set_selected_panel_index(index)
end

InventoryBackgroundView._switch_active_view = function (self, view_name, additional_context_data)
	if not view_name then
		return
	end

	local active_view = self._active_view

	if active_view == view_name and additional_context_data and Managers.ui:view_active(active_view) and Managers.ui:view_instance(active_view):supports_changeable_context() then
		self._active_view_context.changeable_context = additional_context_data

		return
	end

	if active_view and Managers.ui:view_active(active_view) then
		Managers.ui:close_view(active_view)

		if active_view == "talent_builder_view" then
			self:_check_toggle_companion()
		end
	end

	local context = {
		parent = self,
		player = self._preview_player,
		player_level = self._player_level,
		preview_profile_equipped_items = self._preview_profile_equipped_items,
		current_profile_equipped_items = self._current_profile_equipped_items,
		current_profile_equipped_talents = self._current_profile_equipped_talents,
		current_profile_equipped_specialization_talents = self._current_profile_equipped_specialization_talents,
		changeable_context = additional_context_data,
		is_readonly = self._is_readonly,
	}

	self._active_view = view_name
	self._active_view_context = context

	if not Managers.ui:view_active(view_name) then
		Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
	end
end

InventoryBackgroundView._setup_profile_presets = function (self)
	self._profile_presets_element = self:_add_element(ViewElementProfilePresets, "profile_presets", 90, nil, "profile_presets_pivot")

	self:_register_event("event_on_profile_preset_changed")
	self:_register_event("event_on_player_preset_created")
	self:_register_event("event_player_save_changes_to_current_preset")

	local current_preset_id = ProfileUtils.get_active_profile_preset_id()
	local current_preset = current_preset_id and ProfileUtils.get_profile_preset(current_preset_id)

	if current_preset then
		local preset_loadout = current_preset.loadout

		if preset_loadout then
			for slot_name, item in pairs(self._preview_profile_equipped_items) do
				if self:_valid_slot_for_archetype(slot_name) then
					local preset_item_gear_id = preset_loadout[slot_name]
					local item_gear_id = item and item.gear_id

					if item_gear_id ~= preset_item_gear_id then
						local preset_item = self:_get_inventory_item_by_id(preset_item_gear_id)

						Log.warning("InventoryBackgroundView", "Deselecting active preset due to previewed item %s in slot %s not matching expected item %s", item and item.name or nil, slot_name, preset_item and preset_item.name or nil)
						self._profile_presets_element:remove_active_profile_preset()

						current_preset = nil

						break
					end
				end
			end
		end
	end

	self:event_on_profile_preset_changed(current_preset)
end

InventoryBackgroundView._remove_profile_presets = function (self)
	if self._profile_presets_element then
		self:_remove_element("profile_presets")

		self._profile_presets_element = nil
	end
end

local talent_pages = {
	"_active_talent_loadout",
}

table.insert(talent_pages, "_active_specialization_talent_loadout")

local cached_talents = {
	"_current_profile_equipped_talents",
}

table.insert(cached_talents, "_current_profile_equipped_specialization_talents")

InventoryBackgroundView.event_on_player_preset_created = function (self, profile_preset_id)
	local active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()
	local active_profile_preset = active_profile_preset_id and ProfileUtils.get_profile_preset(active_profile_preset_id)

	if profile_preset_id == active_profile_preset_id then
		return
	end

	local new_loadout, new_talents, new_talents_version
	local player = self._preview_player
	local profile = player:profile()

	if active_profile_preset then
		local loadout = active_profile_preset.loadout
		local talents = active_profile_preset.talents

		new_loadout = loadout and table.create_copy(nil, loadout) or {}
		new_talents = talents and table.create_copy(nil, talents) or {}
		new_talents_version = active_profile_preset.talents_version
	else
		new_loadout = {}
		new_talents = {}
		new_talents_version = TalentLayoutParser.talents_version(profile)

		for i = 1, #talent_pages do
			local active_layout = self[talent_pages[i]]

			if active_layout then
				local current_profile_equipped_talents = self[cached_talents[i]]

				if current_profile_equipped_talents then
					table.merge(new_talents, current_profile_equipped_talents)
				else
					local selected_nodes = profile.selected_nodes

					if selected_nodes then
						local nodes = active_layout.nodes

						for i = 1, #nodes do
							local node = nodes[i]
							local widget_name = node.widget_name
							local node_tier = selected_nodes[widget_name]

							if node_tier then
								new_talents[widget_name] = node_tier
							end
						end
					end
				end
			end
		end

		local loadout = profile.loadout

		for slot_name, item in pairs(loadout) do
			if self:_valid_slot_for_archetype(slot_name) and item.gear_id then
				new_loadout[slot_name] = item.gear_id
			end
		end

		local presentation_loadout = self._preview_profile_equipped_items

		for slot_name, item in pairs(presentation_loadout) do
			if self:_valid_slot_for_archetype(slot_name) and item.gear_id then
				new_loadout[slot_name] = item.gear_id
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
	local player = self._preview_player
	local profile = player:profile()
	local active_talents_version = TalentLayoutParser.talents_version(profile)
	local previously_active_profile_preset_id = self._active_profile_preset_id

	if previously_active_profile_preset_id then
		local all_talents = {}

		TalentLayoutParser.filter_layout_talents(profile, "talent_layout_file_path", self._current_profile_equipped_talents, all_talents)
		TalentLayoutParser.filter_layout_talents(profile, "specialization_talent_layout_file_path", self._current_profile_equipped_specialization_talents, all_talents)
		ProfileUtils.save_talent_nodes_for_profile_preset(previously_active_profile_preset_id, all_talents, active_talents_version)
	end

	if profile_preset and profile_preset.loadout then
		local equipped_previous_slots = {}

		for slot_name, gear_id in pairs(self._preview_profile_equipped_items) do
			if self:_valid_slot_for_archetype(slot_name) and not profile_preset.loadout[slot_name] then
				equipped_previous_slots[slot_name] = true
			end
		end

		for slot_name, gear_id in pairs(profile_preset.loadout) do
			local item = self:_get_inventory_item_by_id(gear_id)

			self:_equip_slot_item(slot_name, item, true)
		end

		for slot_name, _ in pairs(equipped_previous_slots) do
			self:_equip_slot_item(slot_name, nil, true)
		end
	end

	if profile_preset then
		local active_talent_version = TalentLayoutParser.talents_version(profile)

		if TalentLayoutParser.is_same_version(profile_preset.talents_version, active_talent_version) then
			self._current_profile_equipped_talents = profile_preset.talents and TalentLayoutParser.filter_layout_talents(profile, "talent_layout_file_path", profile_preset.talents) or {}
			self._current_profile_equipped_specialization_talents = profile_preset.talents and TalentLayoutParser.filter_layout_talents(profile, "specialization_talent_layout_file_path", profile_preset.talents) or {}
		else
			self._current_profile_equipped_talents = {}
			self._current_profile_equipped_specialization_talents = {}
		end
	else
		self:_apply_current_talents_to_profile()
		self:_apply_current_specialization_talents_to_profile()
	end

	self._active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()

	self:_update_loadout_validation()
	self:_update_presentation_wield_item()
	self:_check_toggle_companion()

	if not table.is_empty(self._invalid_slots) or not table.is_empty(self._duplicated_slots) or not table.is_empty(self._modified_slots) then
		Managers.event:trigger("event_add_notification_message", "alert", {
			text = Localize("loc_inventory_error_loadout_items"),
		})
	end
end

InventoryBackgroundView._has_loadout_slot = function (self, slots)
	local has_loadout_slot = false

	if slots.slot_primary or slots.slot_secondary or slots.slot_attachment_1 or slots.slot_attachment_2 or slots.slot_attachment_3 then
		has_loadout_slot = true
	end

	return has_loadout_slot
end

InventoryBackgroundView._has_cosmetic_slot = function (self, slots)
	local has_cosmetic_slot = false

	if slots.slot_gear_head or slots.slot_gear_upperbody or slots.slot_gear_lowerbody or slots.slot_gear_extra_cosmetic or slots.slot_insignia or slots.slot_portrait_frame or slots.slot_character_title or slots.slot_animation_emote_1 or slots.slot_animation_emote_2 or slots.slot_animation_emote_3 or slots.slot_animation_emote_4 or slots.slot_animation_emote_5 or slots.slot_animation_emote_5 or slots.slot_animation_end_of_round then
		has_cosmetic_slot = true
	end

	return has_cosmetic_slot
end

InventoryBackgroundView._update_presets_missing_warning_marker = function (self)
	local presets = ProfileUtils.get_profile_presets()

	if not presets or #presets == 0 then
		local show_warning = not table.is_empty(self._invalid_slots) or not table.is_empty(self._duplicated_slots)
		local show_modified = not table.is_empty(self._modified_slots)

		self._profile_presets_element:set_current_profile_loadout_status(show_warning, show_modified)
	else
		local player = self._preview_player
		local profile = player:profile()
		local active_talent_version = TalentLayoutParser.talents_version(profile)
		local active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()

		for i = 1, #presets do
			local preset = presets[i]
			local loadout = preset and preset.loadout

			if loadout then
				local active_preset = preset.id == active_profile_preset_id
				local is_read_only = not active_preset
				local invalid_slots, modified_slots, duplicated_slots = self:_validate_loadout(loadout, is_read_only)
				local show_warning = not table.is_empty(invalid_slots) or not table.is_empty(duplicated_slots)
				local show_modified = not table.is_empty(modified_slots)
				local warning_talent = false
				local preset_talents_version = preset.talents_version

				if not preset_talents_version or not TalentLayoutParser.is_same_version(active_talent_version, preset_talents_version) then
					show_modified = true
					warning_talent = true
				end

				self._profile_presets_element:show_profile_preset_missing_items_warning(show_warning, show_modified, preset.id)

				if active_preset then
					self._invalid_slots = table.merge(table.merge({}, invalid_slots), duplicated_slots)
					self._modified_slots = modified_slots
					self._warning_talent = warning_talent

					self._profile_presets_element:set_current_profile_loadout_status(show_warning, show_modified)
				end
			end
		end
	end
end

InventoryBackgroundView.remove_new_item_mark = function (self, item)
	local gear_id = item.gear_id
	local item_type = item.item_type

	Items.unmark_item_id_as_new(gear_id)

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

local BREED_TO_EVENT_SUFFIX = {
	human = "human",
	ogryn = "ogryn",
}

InventoryBackgroundView._setup_background_world = function (self)
	local player = self._preview_player
	local player_profile = player:profile()
	local archetype = player_profile.archetype
	local breed_name = archetype.breed
	local event_suffix = BREED_TO_EVENT_SUFFIX[breed_name] or breed_name
	local default_camera_event_id = "event_register_inventory_default_camera_" .. event_suffix

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

	local mastery_camera_event_id = "event_register_inventory_mastery_camera"

	self[mastery_camera_event_id] = function (self, camera_unit)
		self._mastery_camera = camera_unit

		self:_unregister_event(mastery_camera_event_id)
	end

	self:_register_event(mastery_camera_event_id)

	self._item_camera_by_slot_name = {}

	for slot_name, slot in pairs(ItemSlotSettings) do
		if self:_valid_slot_for_archetype(slot_name) and slot.slot_type == "gear" then
			local item_camera_event_id = "event_register_inventory_item_camera_" .. event_suffix .. "_" .. slot_name

			self[item_camera_event_id] = function (self, camera_unit)
				self._item_camera_by_slot_name[slot_name] = camera_unit

				self:_unregister_event(item_camera_event_id)
			end

			self:_register_event(item_camera_event_id)
		end
	end

	self:_register_event("event_register_companion_spawn_point")
	self:_register_event("event_register_character_spawn_point")

	local world_name = InventoryBackgroundViewSettings.world_name
	local world_layer = InventoryBackgroundViewSettings.world_layer
	local world_timer_name = InventoryBackgroundViewSettings.timer_name

	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	local level_name = InventoryBackgroundViewSettings.level_name

	self._world_spawner:spawn_level(level_name)
	self:_register_event("event_inventory_set_target_camera_offset")
	self:_register_event("event_inventory_set_target_camera_rotation")
	self:_register_event("event_inventory_set_camera_item_slot_focus")
	self:_register_event("event_inventory_set_camera_default_focus")
	self:_register_event("event_mastery_set_camera")
	self:_update_viewport_resolution()
end

InventoryBackgroundView.world_spawner = function (self)
	return self._world_spawner
end

InventoryBackgroundView.spawn_point_unit = function (self)
	return self._spawn_point_unit
end

InventoryBackgroundView.companion_spawn_point_unit = function (self)
	return self._companion_spawn_point_unit
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

InventoryBackgroundView.event_register_companion_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_companion_spawn_point")

	self._companion_spawn_point_unit = spawn_point_unit

	if self._context then
		self._context.companion_spawn_point_unit = spawn_point_unit
	end
end

InventoryBackgroundView.event_register_character_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_character_spawn_point")

	self._spawn_point_unit = spawn_point_unit

	if self._context then
		self._context.spawn_point_unit = spawn_point_unit
	end
end

InventoryBackgroundView.event_inventory_set_camera_item_slot_focus = function (self, slot_name, instant_change)
	local world_spawner = self._world_spawner
	local slot_camera = self._item_camera_by_slot_name[slot_name] or self._default_camera_unit

	world_spawner:interpolate_to_camera(slot_camera, 1, instant_change and 0 or InventoryBackgroundViewSettings.camera_time, math.easeCubic)
end

InventoryBackgroundView.event_mastery_set_camera = function (self, instant_change)
	local world_spawner = self._world_spawner
	local camera = self._mastery_camera

	world_spawner:interpolate_to_camera(camera, 1, instant_change and 0 or InventoryBackgroundViewSettings.camera_time, math.easeCubic)
end

InventoryBackgroundView.event_inventory_set_camera_default_focus = function (self, instant_change)
	self._world_spawner:reset_target_camera_fov(instant_change and 0 or InventoryBackgroundViewSettings.camera_time, math.easeCubic)
end

InventoryBackgroundView.event_inventory_set_target_camera_rotation = function (self, rotation, instant_change)
	self._world_spawner:set_target_camera_rotation(rotation, instant_change and 0 or InventoryBackgroundViewSettings.camera_time, math.easeCubic)
end

InventoryBackgroundView.event_inventory_set_target_camera_offset = function (self, x, y, z, instant_change)
	self._world_spawner:set_target_camera_offset(x, y, z, instant_change and 0 or InventoryBackgroundViewSettings.camera_time, math.easeCubic)
end

InventoryBackgroundView.on_exit = function (self)
	self:_unload_portrait_icon()
	self:_unload_portrait_frame(self._ui_renderer)
	self:_unload_insignia(self._ui_renderer)
	Managers.data_service.talents:release_icons(self._talent_icons_package_id)
	Managers.data_service.talents:release_icons(self._specialization_talents_icons_package_id)

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

	if not self._is_readonly and self:is_inventory_synced() then
		self:_equip_local_changes()
		self:_save_current_talents_to_profile_preset()
		self:_apply_current_talents_to_profile()
		self:_apply_current_specialization_talents_to_profile()
	end
end

InventoryBackgroundView._save_current_talents_to_profile_preset = function (self)
	if not self._is_own_player or self._is_readonly then
		return
	end

	local active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()

	if active_profile_preset_id then
		local player = self._preview_player
		local profile = player:profile()
		local active_talents_version = TalentLayoutParser.talents_version(profile)
		local all_talents = {}

		TalentLayoutParser.filter_layout_talents(profile, "talent_layout_file_path", self._current_profile_equipped_talents, all_talents)
		TalentLayoutParser.filter_layout_talents(profile, "specialization_talent_layout_file_path", self._current_profile_equipped_specialization_talents, all_talents)
		ProfileUtils.save_talent_nodes_for_profile_preset(active_profile_preset_id, all_talents, active_talents_version)
	end
end

InventoryBackgroundView._check_toggle_companion = function (self)
	if self._profile_spawner then
		local talent_nodes = self._active_talent_loadout
		local nodes = talent_nodes.nodes
		local talents_by_talent_name = {}

		for node_id, node in pairs(nodes) do
			local widget_name = node.widget_name
			local talent_name = node.talent

			if talent_name and self._current_profile_equipped_talents and self._current_profile_equipped_talents[widget_name] and self._current_profile_equipped_talents[widget_name] > 0 then
				talents_by_talent_name[talent_name] = self._current_profile_equipped_talents[widget_name]
			end
		end

		local talent_profile = {
			archetype = self._presentation_profile.archetype,
			talents = talents_by_talent_name,
		}
		local is_companion_visible = self:_is_companion_visible(talent_profile)

		if is_companion_visible ~= self._profile_spawner:is_companion_showing() then
			local profile = self._presentation_profile

			self:_spawn_profile(profile, is_companion_visible)
		end
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
		local node_tiers = self._current_profile_equipped_talents

		if node_tiers then
			local player = self._preview_player
			local talent_service = Managers.data_service.talents

			talent_service:set_talents_v2(player, active_talent_loadout, node_tiers)
		end
	end
end

InventoryBackgroundView._apply_current_specialization_talents_to_profile = function (self)
	if not self._is_own_player or self._is_readonly then
		return
	end

	local active_talent_loadout = self._active_specialization_talent_loadout

	if active_talent_loadout then
		local node_tiers = self._current_profile_equipped_specialization_talents

		if node_tiers then
			local player = self._preview_player
			local talent_service = Managers.data_service.specialization_talent

			talent_service:set_specialization_talents(player, active_talent_loadout, node_tiers)
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

	if profile_presets_element and profile_presets_element:has_profile_presets() then
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
		input_service = input_service:null_service()
	end

	InventoryBackgroundView.super.draw(self, dt, t, input_service, layer)
end

InventoryBackgroundView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	InventoryBackgroundView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

InventoryBackgroundView.update = function (self, dt, t, input_service)
	if not self._preview_player or self._preview_player.__deleted then
		self:_handle_back_pressed()

		return
	end

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

	if self._mastery_previous_state then
		self:_check_mastery_sync_status()
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

InventoryBackgroundView._spawn_profile = function (self, profile, is_companion_visible)
	local profile_spawner = self._profile_spawner

	if profile_spawner then
		profile_spawner:destroy()

		self._profile_spawner = nil
	end

	local world = self._world_spawner:world()
	local camera = self._world_spawner:camera()
	local unit_spawner = self._world_spawner:unit_spawner()

	profile_spawner = UIProfileSpawner:new("InventoryBackgroundView", world, camera, unit_spawner)

	local ignored_slots = InventoryBackgroundViewSettings.ignored_slots

	for ii = 1, #ignored_slots do
		local slot_name = ignored_slots[ii]

		profile_spawner:ignore_slot(slot_name)
	end

	local CharacterSheet = require("scripts/utilities/character_sheet")
	local camera_position = ScriptCamera.position(camera)
	local spawn_point_unit = self._spawn_point_unit
	local spawn_position = Unit.world_position(spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(spawn_point_unit, 1)
	local companion_spawn_position = self._companion_spawn_point_unit and Unit.world_position(self._companion_spawn_point_unit, 1)
	local companion_spawn_rotation = self._companion_spawn_point_unit and Unit.world_rotation(self._companion_spawn_point_unit, 1)

	camera_position.z = 0

	local selected_archetype = profile.archetype
	local breed_name = selected_archetype.breed
	local breed_settings = Breeds[breed_name]
	local inventory_state_machine = breed_settings.inventory_state_machine
	local companion_data = {
		position = companion_spawn_position,
		rotation = companion_spawn_rotation,
	}

	profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation, nil, inventory_state_machine, nil, nil, nil, nil, nil, nil, nil, companion_data)

	if is_companion_visible == nil then
		is_companion_visible = self:_is_companion_visible(profile)
	end

	profile_spawner:toggle_companion(is_companion_visible)

	self._profile_spawner = profile_spawner
	self._spawned_profile = profile

	self:_update_presentation_wield_item()
end

InventoryBackgroundView._is_companion_visible = function (self, profile)
	return ProfileUtils.has_companion(profile)
end

InventoryBackgroundView._set_preview_wield_slot_name = function (self, slot_name)
	local settings = InventoryBackgroundViewSettings

	if not table.array_contains(settings.allowed_slots, slot_name) then
		slot_name = settings.default_slot
	end

	self._preview_wield_slot_name = slot_name
end

InventoryBackgroundView._update_presentation_wield_item = function (self)
	if not self._profile_spawner then
		return
	end

	local slot_name = self._preview_wield_slot_name
	local preview_profile_equipped_items = self._preview_profile_equipped_items
	local presentation_inventory = preview_profile_equipped_items
	local slot_item = presentation_inventory[slot_name]

	self._profile_spawner:wield_slot(slot_name)

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

	ui_weapon_spawner:start_presentation(item, spawn_position, spawn_rotation, nil, nil, true, nil, nil)

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

InventoryBackgroundView.event_force_refresh_inventory = function (self)
	local player = self._preview_player
	local character_id = player:character_id()

	Managers.data_service.gear:fetch_inventory(character_id):next(function (items)
		if self._destroyed then
			return
		end

		self._inventory_items = items
	end)
end

InventoryBackgroundView._fetch_inventory_items = function (self)
	local player = self._preview_player
	local character_id = player:character_id()

	Managers.data_service.gear:fetch_inventory(character_id):next(function (items)
		if self._destroyed then
			return
		end

		self._inventory_items = items

		return Managers.data_service.mastery:get_all_masteries()
	end):next(function (masteries_data)
		self._syncing_mastery = {}
		self.masteries_data = masteries_data
		self._mastery_traits = Managers.data_service.mastery:get_all_traits_data(masteries_data)

		Managers.data_service.mastery:check_and_claim_all_masteries_levels(masteries_data):next(function (data)
			if self._destroyed then
				return
			end

			for id, mastery_data in pairs(data) do
				self.masteries_data[id] = mastery_data
			end

			for id, mastery_data in pairs(masteries_data) do
				self._syncing_mastery[id] = nil
			end

			self._has_mastery_points_available = Mastery.has_available_points(self.masteries_data, self._mastery_traits)
		end)

		self._has_mastery_points_available = Mastery.has_available_points(self.masteries_data, self._mastery_traits)
		self._inventory_synced = true

		for id, mastery_data in pairs(masteries_data) do
			local claiming = Managers.data_service.mastery:is_mastery_claim_in_progress(id)

			self._syncing_mastery[id] = claiming or nil
		end

		self:_check_mastery_sync_status()
	end):catch(function ()
		Managers.event:trigger("event_add_notification_message", "alert", {
			text = Localize("loc_popup_description_backend_error"),
		})
		self:cb_on_close_pressed()
	end)
end

InventoryBackgroundView.event_mastery_traits_update = function (self, mastery_id, traits_data)
	local mastery_data = self.masteries_data[mastery_id]

	if mastery_data then
		for i = 1, #self._mastery_traits[mastery_id] do
			local traits = self._mastery_traits[mastery_id][i]

			if traits.trait_name == traits_data.trait_name then
				if traits.trait_status[traits_data.rarity] then
					traits.trait_status[traits_data.rarity] = "seen"
				end

				break
			end
		end

		self._has_mastery_points_available = Mastery.has_available_points(self.masteries_data, self._mastery_traits)
	end
end

InventoryBackgroundView._check_mastery_sync_status = function (self)
	self._mastery_previous_state = self._mastery_previous_state or {}

	for id, mastery_data in pairs(self.masteries_data) do
		mastery_data.syncing = self._syncing_mastery[id]

		if self._mastery_previous_state[id] ~= mastery_data.syncing then
			if not mastery_data.syncing then
				Managers.event:trigger("event_mastery_updated", id)
			end

			self._mastery_previous_state[id] = mastery_data.syncing
		end
	end

	local all_claimed = table.is_empty(self._syncing_mastery)

	if all_claimed then
		self._mastery_previous_state = nil
	end
end

InventoryBackgroundView._validate_loadout = function (self, loadout, read_only)
	local invalid_slots = {}
	local modified_slots = {}
	local duplicated_slots = {}
	local only_show_slot_as_invalid = {}

	if not self._is_own_player or self._is_readonly then
		return invalid_slots, modified_slots, duplicated_slots
	end

	for slot_name, slot_data in pairs(ItemSlotSettings) do
		if not self:_valid_slot_for_archetype(slot_name) then
			-- Nothing
		else
			local item_data = loadout[slot_name]
			local gear_id = type(item_data) == "table" and item_data.gear_id
			local item = gear_id and self:_get_inventory_item_by_id(gear_id) or self:_get_inventory_item_by_id(item_data)
			local fallback_item = MasterItems.find_fallback_item(slot_name)

			if not item and (type(item_data) ~= "table" or not item_data.always_owned) then
				invalid_slots[slot_name] = true
			elseif item and not item.always_owned and fallback_item and item.name == fallback_item.name then
				invalid_slots[slot_name] = true
			else
				for checked_slot_name, checked_load_data in pairs(loadout) do
					local checked_gear_id = type(checked_load_data) == "table" and checked_load_data.gear_id or type(checked_load_data) == "string" and checked_load_data
					local item_gear_id = type(item_data) == "table" and item_data.gear_id or type(item_data) == "string" and item_data

					if checked_gear_id == item_gear_id and checked_slot_name ~= slot_name and not invalid_slots[slot_name] and (not ALLOWED_DUPLICATE_SLOTS[checked_slot_name] or not ALLOWED_DUPLICATE_SLOTS[slot_name]) then
						duplicated_slots[checked_slot_name] = true

						goto label_1_0
					end
				end

				local player = self._preview_player
				local profile = player:profile()
				local item_or_nil = type(item_data) == "table" and self:_get_inventory_item_by_id(gear_id) or self:_get_inventory_item_by_id(item_data)

				if item_or_nil then
					local compatible_profile = Items.is_item_compatible_with_profile(item_or_nil, profile)

					if not compatible_profile then
						only_show_slot_as_invalid[slot_name] = true
						invalid_slots[slot_name] = true
					end
				end
			end
		end

		::label_1_0::
	end

	for removed_slot_name, _ in pairs(invalid_slots) do
		if not only_show_slot_as_invalid[removed_slot_name] then
			local starting_item = self._starting_profile_equipped_items and self._starting_profile_equipped_items[removed_slot_name]
			local valid_stored_item = self._valid_profile_equipped_items and self._valid_profile_equipped_items[removed_slot_name]

			starting_item = starting_item and self:_get_inventory_item_by_id(starting_item.gear_id)
			valid_stored_item = valid_stored_item and self:_get_inventory_item_by_id(valid_stored_item.gear_id)

			local fallback_item = MasterItems.find_fallback_item(removed_slot_name)
			local starting_item_valid = starting_item and (starting_item.always_owned or fallback_item and fallback_item.name ~= starting_item.name)
			local valid_stored_item_valid = valid_stored_item and (valid_stored_item.always_owned or fallback_item and fallback_item.name ~= valid_stored_item.name)

			if not read_only then
				if starting_item_valid then
					self:_equip_slot_item(removed_slot_name, starting_item, true)
				elseif valid_stored_item_valid then
					self:_equip_slot_item(removed_slot_name, valid_stored_item, true)
				end
			end

			if starting_item_valid or valid_stored_item_valid then
				invalid_slots[removed_slot_name] = nil
				modified_slots[removed_slot_name] = true
			elseif fallback_item then
				if not read_only then
					self:_equip_slot_item(removed_slot_name, fallback_item, true)
				end

				if fallback_item.always_owned then
					invalid_slots[removed_slot_name] = nil
					modified_slots[removed_slot_name] = true
				end
			else
				if ALLOWED_EMPTY_SLOTS[removed_slot_name] then
					invalid_slots[removed_slot_name] = nil
					modified_slots[removed_slot_name] = nil
				end

				if not read_only then
					self:_equip_slot_item(removed_slot_name, nil, true)
				end
			end
		end
	end

	if not read_only then
		self._invalid_slots = invalid_slots
		self._modified_slots = modified_slots
		self._duplicated_slots = duplicated_slots
	end

	return invalid_slots, modified_slots, duplicated_slots
end

InventoryBackgroundView._get_valid_new_items = function (self, inventory_items)
	local save_manager = Managers.save
	local character_id = self._preview_player:character_id()
	local profile = self._preview_player:profile()
	local archetype = self._preview_player:archetype_name()
	local character_data = character_id and save_manager and save_manager:character_data(character_id)

	if not character_data then
		return {}
	end

	local account_new_items_data = save_manager and save_manager:account_data()

	account_new_items_data = account_new_items_data and account_new_items_data.new_account_items_by_archetype[archetype] or {}

	local new_gear_items = {}
	local new_gear_items_by_type = {}
	local new_item_lists = {
		{
			is_character_data = true,
			data = character_data.new_items,
		},
		{
			data = account_new_items_data,
		},
	}

	for i = 1, #new_item_lists do
		local new_items_list = new_item_lists[i]
		local new_items = new_items_list.data

		for gear_id, _ in pairs(new_items) do
			local item = inventory_items[gear_id]

			if not item then
				Items.unmark_item_id_as_new(gear_id)
			else
				local compatible_profile = Items.is_item_compatible_with_profile(item, profile)

				if compatible_profile then
					new_gear_items[gear_id] = true

					local item_type = item.item_type

					if item_type then
						new_gear_items_by_type[item_type] = new_gear_items_by_type[item_type] or {}
						new_gear_items_by_type[item_type][gear_id] = true
					end
				elseif new_items_list.is_character_data then
					Items.unmark_item_id_as_new(gear_id)
				end
			end
		end
	end

	return new_gear_items, new_gear_items_by_type
end

InventoryBackgroundView.is_inventory_synced = function (self)
	return self._inventory_synced == nil and not self._check_for_loadout_update_timeout
end

InventoryBackgroundView._get_inventory_item_by_id = function (self, gear_id)
	if not gear_id then
		return
	end

	local inventory_items = self._inventory_items

	for _, item in pairs(inventory_items) do
		if item.gear_id == gear_id then
			return item
		end
	end
end

InventoryBackgroundView._update_loadout_validation = function (self)
	if self._profile_presets_element then
		self._profile_presets_element:sync_profiles_states()
		self:_update_presets_missing_warning_marker()
	elseif self._current_profile_equipped_items then
		self:_validate_loadout(self._current_profile_equipped_items)
	end

	self:_update_valid_items_list()
end

InventoryBackgroundView._update_valid_items_list = function (self)
	self._valid_profile_equipped_items = self._valid_profile_equipped_items or {}

	for slot_name, item in pairs(self._current_profile_equipped_items) do
		local valid_item = self:_get_inventory_item_by_id(item.gear_id) or item.always_owned

		if valid_item and not self._invalid_slots[slot_name] and not self._modified_slots[slot_name] and not self._duplicated_slots[slot_name] then
			self._valid_profile_equipped_items[slot_name] = item
		end
	end
end

return InventoryBackgroundView
