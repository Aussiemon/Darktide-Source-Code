local ContentBlueprints = require("scripts/ui/views/inventory_view/inventory_view_content_blueprints")
local Definitions = require("scripts/ui/views/inventory_cosmetics_view/inventory_cosmetics_view_definitions")
local InventoryCosmeticsViewSettings = require("scripts/ui/views/inventory_cosmetics_view/inventory_cosmetics_view_settings")
local ItemGridViewBase = require("scripts/ui/views/item_grid_view_base/item_grid_view_base")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local ProfileUtils = require("scripts/utilities/profile_utils")
local ScriptCamera = require("scripts/foundation/utilities/script_camera")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementPlayerPanel = require("scripts/ui/view_elements/view_element_player_panel/view_element_player_panel")
local WIDGET_TYPE_BY_SLOT = {
	slot_gear_head = "gear_item",
	slot_animation_end_of_round = "gear_item",
	slot_animation_emote_4 = "ui_item",
	slot_gear_extra_cosmetic = "gear_item",
	slot_animation_emote_1 = "ui_item",
	slot_animation_emote_5 = "ui_item",
	slot_insignia = "ui_item",
	slot_portrait_frame = "ui_item",
	slot_animation_emote_3 = "ui_item",
	slot_gear_lowerbody = "gear_item",
	slot_gear_upperbody = "gear_item",
	slot_animation_emote_2 = "ui_item"
}
local InventoryCosmeticsView = class("InventoryCosmeticsView", "ItemGridViewBase")

InventoryCosmeticsView.init = function (self, settings, context)
	self._context = context
	self._selected_slot = context.debug and {
		name = "slot_insignia"
	} or context.selected_slot
	self._selected_slots = context.selected_slots or {
		context.selected_slot
	}
	self._initial_rotation = context.initial_rotation
	self._disable_rotation_input = context.disable_rotation_input
	self._animation_event_name_suffix = context.animation_event_name_suffix
	self._animation_event_variable_data = context.animation_event_variable_data
	self.item_type = context.item_type
	self._preview_player = context.debug and Managers.player:local_player(1) or context.player
	self._preview_profile_equipped_items = context.preview_profile_equipped_items
	self._current_profile_equipped_items = context.current_profile_equipped_items or {}
	self._is_own_player = self._preview_player == Managers.player:local_player(1)
	self._is_readonly = context and context.is_readonly
	local player = self._preview_player
	local profile = player:profile()
	self._presentation_profile = context.debug and {} or table.clone_instance(profile)
	self._presentation_profile.character_id = "cosmetics_view_preview_character"
	self._presentation_profile.loadout = context.debug and {
		slot_insignia = UISettings.insignia_default_texture
	} or self._preview_profile_equipped_items and table.clone_instance(self._preview_profile_equipped_items)
	self._camera_zoomed_in = true
	self._initialize_zoom = true
	self._sort_options = {
		{
			display_name = Localize("loc_inventory_item_grid_sort_title_name") .. " ",
			sort_function = ItemUtils.sort_comparator({
				">",
				ItemUtils.compare_item_name,
				">",
				ItemUtils.compare_item_rarity,
				">",
				ItemUtils.compare_item_level
			})
		},
		{
			display_name = Localize("loc_inventory_item_grid_sort_title_name") .. " ",
			sort_function = ItemUtils.sort_comparator({
				"<",
				ItemUtils.compare_item_name,
				">",
				ItemUtils.compare_item_rarity,
				">",
				ItemUtils.compare_item_level
			})
		}
	}

	InventoryCosmeticsView.super.init(self, Definitions, settings)

	self._pass_input = false
	self._pass_draw = false
	self._parent = context and context.parent
end

InventoryCosmeticsView.on_enter = function (self)
	InventoryCosmeticsView.super.on_enter(self)
	self:_stop_previewing()

	self._inventory_items = {}
	local selected_slots = self._selected_slots

	if selected_slots then
		self:_fetch_inventory_items(selected_slots)

		local spawn_player = false

		for i = 1, #selected_slots do
			local slot = selected_slots[i]
			local selected_slot_name = slot.name

			if selected_slot_name ~= "slot_insignia" and selected_slot_name ~= "slot_portrait_frame" then
				spawn_player = true

				break
			end
		end

		self._spawn_player = spawn_player
	end

	self:_register_button_callbacks()
	self:_setup_input_legend()
	self:_setup_background_world()
end

InventoryCosmeticsView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

InventoryCosmeticsView._set_preview_widgets_visibility = function (self, visible, allow_equip_button)
	InventoryCosmeticsView.super._set_preview_widgets_visibility(self, visible)

	local widgets_by_name = self._widgets_by_name
	widgets_by_name.equip_button.content.visible = allow_equip_button and true or visible
	widgets_by_name.display_name_divider2.content.visible = visible
end

InventoryCosmeticsView._stop_previewing = function (self)
	InventoryCosmeticsView.super._stop_previewing(self)
	self:_set_preview_widgets_visibility(false)

	if self._player_panel then
		self:_remove_element("player_panel")

		self._player_panel = nil
	end

	if self._spawned_prop_item_slot then
		local presentation_profile = self._presentation_profile
		local presentation_loadout = presentation_profile.loadout
		presentation_loadout[self._spawned_prop_item_slot] = nil
		self._spawned_prop_item_slot = nil
	end
end

InventoryCosmeticsView._spawn_profile = function (self, profile, initial_rotation, disable_rotation_input)
	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	local world = self._world_spawner:world()
	local camera = self._world_spawner:camera()
	local unit_spawner = self._world_spawner:unit_spawner()
	self._profile_spawner = UIProfileSpawner:new("InventoryCosmeticsView", world, camera, unit_spawner)

	if disable_rotation_input then
		self._profile_spawner:disable_rotation_input()
	end

	local camera_position = ScriptCamera.position(camera)
	local spawn_position = Unit.world_position(self._spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(self._spawn_point_unit, 1)

	if initial_rotation then
		local character_initial_rotation = Quaternion.axis_angle(Vector3(0, 0, 1), initial_rotation)
		spawn_rotation = Quaternion.multiply(character_initial_rotation, spawn_rotation)
	end

	camera_position.z = 0

	self._profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation)

	local selected_archetype = profile.archetype
	local archetype_name = selected_archetype.name
	local animation_duration = 0.01
	local world_spawner = self._world_spawner

	if archetype_name == "ogryn" then
		world_spawner:set_camera_position_axis_offset("x", -0.5, animation_duration, math.easeOutCubic)
		world_spawner:set_camera_position_axis_offset("y", -1.5, animation_duration, math.easeOutCubic)
		world_spawner:set_camera_position_axis_offset("z", 0.5, animation_duration, math.easeOutCubic)
	else
		world_spawner:set_camera_position_axis_offset("x", 0, animation_duration, math.easeOutCubic)
		world_spawner:set_camera_position_axis_offset("y", 0, animation_duration, math.easeOutCubic)
		world_spawner:set_camera_position_axis_offset("z", 0, animation_duration, math.easeOutCubic)
	end

	self._spawned_profile = profile
end

local ANIMATION_SLOTS_MAP = {
	slot_animation_emote_3 = true,
	slot_animation_end_of_round = true,
	slot_animation_emote_4 = true,
	slot_animation_emote_5 = true,
	slot_animation_emote_1 = true,
	slot_animation_emote_2 = true
}

InventoryCosmeticsView._preview_element = function (self, element)
	self:_stop_previewing()

	local item = element.item
	local item_display_name = item.display_name

	if string.match(item_display_name, "unarmed") then
		return
	end

	self._previewed_item = item
	local slots = item.slots or {}
	local item_name = item.name
	local gear_id = item.gear_id or item_name

	if item then
		local selected_slot = self._selected_slot
		local selected_slot_name = selected_slot and selected_slot.name
		local presentation_profile = self._presentation_profile
		local presentation_loadout = presentation_profile.loadout
		presentation_loadout[selected_slot_name] = item
		local animation_slot = ANIMATION_SLOTS_MAP[selected_slot_name]

		if animation_slot then
			local item_state_machine = item.state_machine
			local item_animation_event = item.animation_event
			local item_face_animation_event = item.face_animation_event
			local animation_event_name_suffix = self._animation_event_name_suffix
			local animation_event = item_animation_event

			if animation_event_name_suffix then
				animation_event = animation_event .. animation_event_name_suffix
			end

			self._profile_spawner:assign_state_machine(item_state_machine, animation_event, item_face_animation_event)

			local animation_event_variable_data = self._animation_event_variable_data

			if animation_event_variable_data then
				local index = animation_event_variable_data.index
				local value = animation_event_variable_data.value

				self._profile_spawner:assign_animation_variable(index, value)
			end

			local prop_item_key = item.prop_item
			local prop_item = prop_item_key and prop_item_key ~= "" and MasterItems.get_item(prop_item_key)

			if prop_item then
				local prop_item_slot = prop_item.slots[1]
				presentation_loadout[prop_item_slot] = prop_item

				self._profile_spawner:wield_slot(prop_item_slot)

				self._spawned_prop_item_slot = prop_item_slot
			end
		end

		if selected_slot_name == "slot_portrait_frame" or selected_slot_name == "slot_insignia" then
			InventoryCosmeticsView.super._preview_element(self, element)
			self:_set_preview_widgets_visibility(false, true)
		else
			local display_name = ItemUtils.display_name(item)
			local widgets_by_name = self._widgets_by_name
			widgets_by_name.display_name.content.text = display_name

			self:_set_preview_widgets_visibility(true)
		end
	end
end

InventoryCosmeticsView._update_player_panel_position = function (self)
	if not self._player_panel then
		return
	end

	local position = self:_scenegraph_world_position("player_panel_pivot")

	self._player_panel:set_pivot_offset(position[1], position[2])
end

InventoryCosmeticsView._register_button_callbacks = function (self)
	local widgets_by_name = self._widgets_by_name
	local equip_button = widgets_by_name.equip_button
	equip_button.content.hotspot.pressed_callback = callback(self, "cb_on_equip_pressed")
end

InventoryCosmeticsView.cb_on_camera_zoom_toggled = function (self, id, input_pressed, instant)
	self._camera_zoomed_in = not self._camera_zoomed_in

	if self._camera_zoomed_in then
		self:_play_sound(UISoundEvents.apparel_zoom_in)
	else
		self:_play_sound(UISoundEvents.apparel_zoom_out)
	end

	self:_trigger_zoom_logic(instant)
end

InventoryCosmeticsView._trigger_zoom_logic = function (self, instant, optional_slot_name)
	local selected_slot = self._selected_slot
	local selected_slot_name = optional_slot_name or selected_slot and selected_slot.name
	local func_ptr = math.easeCubic
	local world_spawner = self._world_spawner
	local duration = instant and 0 or 1

	if self._camera_zoomed_in then
		self:_set_camera_item_slot_focus(selected_slot_name, duration, func_ptr)
	else
		world_spawner:set_camera_position_axis_offset("x", 0, duration, func_ptr)
		world_spawner:set_camera_position_axis_offset("y", 0, duration, func_ptr)
		world_spawner:set_camera_position_axis_offset("z", 0, duration, func_ptr)
		world_spawner:set_camera_rotation_axis_offset("x", 0, duration, func_ptr)
		world_spawner:set_camera_rotation_axis_offset("y", 0, duration, func_ptr)
		world_spawner:set_camera_rotation_axis_offset("z", 0, duration, func_ptr)
	end
end

InventoryCosmeticsView.cb_on_equip_pressed = function (self)
	local selected_slot = self._selected_slot

	if not selected_slot then
		return
	end

	local previewed_item = self._previewed_item

	if not previewed_item then
		return
	end

	local selected_slot_name = selected_slot.name

	self:_equip_item(selected_slot_name, previewed_item)
end

InventoryCosmeticsView.on_exit = function (self)
	if self._world_spawner then
		self._world_spawner:set_camera_blur(0, 0)
	end

	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	if not self._has_equipped_item then
		self:_play_sound(UISoundEvents.default_menu_exit)
	end

	InventoryCosmeticsView.super.on_exit(self)
end

InventoryCosmeticsView._verify_items = function (self, source_items, owned_gear)
	local selected_slot = self._selected_slot
	local selected_slot_name = selected_slot.name
	local verified_items = {}
	local owned_gear_by_master_id = {}

	if owned_gear then
		for gear_id, item in pairs(owned_gear) do
			local item_name = item.name
			owned_gear_by_master_id[item_name] = item
		end
	end

	for item_name, item in pairs(source_items) do
		local slots = item.slots

		if slots then
			for i = 1, #slots do
				local slot_name = slots[i]

				if selected_slot_name == slot_name then
					if owned_gear_by_master_id[item_name] then
						verified_items[item_name] = owned_gear_by_master_id[item_name]

						break
					end

					if item.always_owned then
						verified_items[item_name] = item
					end

					break
				end
			end
		end
	end

	return verified_items
end

InventoryCosmeticsView._fetch_inventory_items = function (self, selected_slots)
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local character_id = player:character_id()
	local filter = {}

	for i = 1, #selected_slots do
		local slot = selected_slots[i]
		local slot_name = slot.name
		filter[#filter + 1] = slot_name
	end

	local selected_slot = self._selected_slot
	local selected_slot_name = selected_slot.name

	Managers.data_service.gear:fetch_inventory(character_id, filter):next(function (items)
		if self._destroyed then
			return
		end

		local item_definitions = MasterItems.get_cached()
		items = self:_verify_items(item_definitions, items)
		local items_array = {}

		for gear_id, item in pairs(items) do
			items_array[#items_array + 1] = item
		end

		self._inventory_items = items_array
		local layout = {}

		for i = 1, #items_array do
			local item = items_array[i]

			if self:_item_valid_by_current_profile(item) then
				local slots = item.slots

				if slots then
					local valid = true

					if valid then
						layout[#layout + 1] = {
							item = item,
							slot = selected_slot,
							widget_type = WIDGET_TYPE_BY_SLOT[selected_slot_name]
						}
					end
				end
			end
		end

		local first_selected_slot = selected_slots[1]
		self._offer_items_layout = layout
		local slot_display_name = selected_slot and selected_slot.display_name

		self:_present_layout_by_slot_filter(nil, slot_display_name)

		local start_index = #layout > 0 and 1
		local equipped_item = start_index and self:equipped_item_in_slot(selected_slot_name)

		if equipped_item then
			start_index = self:item_grid_index(equipped_item) or start_index

			if start_index then
				self:focus_on_item(equipped_item)
			end
		else
			local instant_scroll = true
			local scrollbar_animation_progress = 0

			self:focus_grid_index(start_index, scrollbar_animation_progress, instant_scroll)
		end
	end)
end

InventoryCosmeticsView._calc_text_size = function (self, widget, text_and_style_id)
	local text = widget.content[text_and_style_id]
	local text_style = widget.style[text_and_style_id]
	local text_options = UIFonts.get_font_options_by_style(text_style)

	if not text_style.size and not widget.content.size then
		local size = {
			self:_scenegraph_size(widget.scenegraph_id)
		}
	end

	return UIRenderer.text_size(self._ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)
end

InventoryCosmeticsView._get_item_from_inventory = function (self, wanted_item)
	local inventory_items = self._inventory_items
	local wanted_item_gear_id = wanted_item.gear_id
	local wanted_item_name = wanted_item.name

	for _, item in ipairs(inventory_items) do
		local gear_id = item.gear_id
		local item_name = item.name

		if wanted_item_gear_id then
			if gear_id and gear_id == wanted_item_gear_id then
				return item
			end
		elseif wanted_item_name and wanted_item_name == item_name then
			return item
		end
	end

	return wanted_item
end

InventoryCosmeticsView._item_valid_by_current_profile = function (self, item)
	local player = self._preview_player
	local profile = player:profile()
	local archetype = profile.archetype
	local lore = profile.lore
	local backstory = lore.backstory
	local crime = backstory.crime
	local archetype_name = archetype.name
	local breed_name = archetype.breed
	local breed_valid = not item.breeds or table.contains(item.breeds, breed_name)
	local crime_valid = not item.crimes or table.contains(item.crimes, crime)
	local no_crimes = item.crimes == nil or table.is_empty(item.crimes)
	local archetype_valid = not item.archetypes or table.contains(item.archetypes, archetype_name)

	if archetype_valid and breed_valid and (no_crimes or crime_valid) then
		return true
	end

	return false
end

InventoryCosmeticsView._on_double_click = function (self, widget, element)
	local selected_slot = self._selected_slot

	if not selected_slot then
		return
	end

	local previewed_item = self._previewed_item

	if not previewed_item then
		return
	end

	local selected_slot_name = selected_slot.name

	self:_equip_item(selected_slot_name, previewed_item)
end

InventoryCosmeticsView._equip_item = function (self, slot_name, item)
	if self._equip_button_disabled then
		return
	end

	local equipped_slot_item = self:equipped_item_in_slot(slot_name)

	if not equipped_slot_item or equipped_slot_item.gear_id ~= item.gear_id then
		self._has_equipped_item = true

		if item then
			local item_type = item.item_type
			local ITEM_TYPES = UISettings.ITEM_TYPES

			if item_type == ITEM_TYPES.GEAR_LOWERBODY or item_type == ITEM_TYPES.GEAR_UPPERBODY or item_type == ITEM_TYPES.END_OF_ROUND then
				self:_play_sound(UISoundEvents.apparel_equip)
			elseif item_type == ITEM_TYPES.GEAR_HEAD or item_type == ITEM_TYPES.GEAR_EXTRA_COSMETIC then
				self:_play_sound(UISoundEvents.apparel_equip_small)
			elseif item_type == ITEM_TYPES.PORTRAIT_FRAME or item_type == ITEM_TYPES.CHARACTER_INSIGNIA then
				self:_play_sound(UISoundEvents.apparel_equip_frame)
			else
				self:_play_sound(UISoundEvents.apparel_equip)
			end
		end

		local item_gear_id = item and item.gear_id
		local active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()

		if active_profile_preset_id then
			ProfileUtils.save_item_id_for_profile_preset(active_profile_preset_id, slot_name, item_gear_id)
		end

		Managers.event:trigger("event_inventory_view_equip_item", slot_name, item)
	end
end

InventoryCosmeticsView.equipped_item_in_slot = function (self, slot_name)
	local current_loadout = self._current_profile_equipped_items
	local slot_item = current_loadout[slot_name]
	local item = slot_item and self:_get_item_from_inventory(slot_item)

	return item
end

InventoryCosmeticsView._clear_widgets = function (self, widgets)
	if widgets then
		for i = 1, #widgets do
			local widget = widgets[i]
			local widget_name = widget.name

			if self:has_widget(widget_name) then
				self:_unregister_widget_name(widget_name)
			end
		end

		table.clear(widgets)
	end
end

InventoryCosmeticsView._handle_input = function (self, input_service)
	if input_service:get("confirm_pressed") then
		self:cb_on_equip_pressed()
	end
end

InventoryCosmeticsView._handle_back_pressed = function (self)
	local view_name = "inventory_cosmetics_view"

	Managers.ui:close_view(view_name)
end

InventoryCosmeticsView._update_equip_button_status = function (self)
	local previewed_item = self._previewed_item
	local disable_button = not previewed_item

	if not disable_button then
		local selected_slot = self._selected_slot
		local selected_slot_name = selected_slot and selected_slot.name
		local equipped_item = selected_slot_name and self:equipped_item_in_slot(selected_slot_name)
		disable_button = equipped_item and equipped_item.gear_id == previewed_item.gear_id
	end

	if self._equip_button_disabled ~= disable_button then
		self._equip_button_disabled = disable_button
		local button = self._widgets_by_name.equip_button
		local button_content = button.content
		button_content.hotspot.disabled = disable_button
		button_content.text = Utf8.upper(disable_button and Localize("loc_weapon_inventory_equipped_button") or Localize("loc_weapon_inventory_equip_button"))
	end
end

InventoryCosmeticsView.cb_on_close_pressed = function (self)
	self:_handle_back_pressed()
end

InventoryCosmeticsView.profile_preset_handling_input = function (self)
	local view_name = "inventory_background_view"
	local ui_manager = Managers.ui

	if ui_manager:view_active(view_name) then
		local view_instance = ui_manager:view_instance(view_name)

		return view_instance:profile_preset_handling_input()
	end
end

InventoryCosmeticsView.draw = function (self, dt, t, input_service, layer)
	if self:profile_preset_handling_input() then
		input_service = input_service:null_service()
	end

	InventoryCosmeticsView.super.draw(self, dt, t, input_service, layer)
end

InventoryCosmeticsView.update = function (self, dt, t, input_service)
	if self:profile_preset_handling_input() then
		input_service = input_service:null_service()
	end

	if self._spawn_player then
		if not self._player_spawned and self._spawn_point_unit and self._default_camera_unit then
			local profile = self._presentation_profile
			local initial_rotation = self._initial_rotation
			local disable_rotation_input = self._disable_rotation_input

			self:_spawn_profile(profile, initial_rotation, disable_rotation_input)

			self._player_spawned = true
			self._spawn_player = false
			local selected_slot = self._selected_slot
			local selected_slot_name = selected_slot and selected_slot.name

			self:_trigger_zoom_logic(true, selected_slot_name)
		end

		if self._player_spawned and not self._initialize_zoom then
			self._initialize_zoom = false
		end
	end

	self:_update_equip_button_status(dt)

	local profile_spawner = self._profile_spawner

	if profile_spawner then
		profile_spawner:update(dt, t, input_service)
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	return InventoryCosmeticsView.super.update(self, dt, t, input_service)
end

InventoryCosmeticsView._get_weapon_spawn_position_normalized = function (self)
	self:_force_update_scenegraph()

	local scale = nil
	local pivot_world_position = self:_scenegraph_world_position("weapon_pivot", scale)
	local parent_world_position = self:_scenegraph_world_position("weapon_viewport", scale)
	local viewport_width, viewport_height = self:_scenegraph_size("weapon_viewport", scale)
	local scale_x = (pivot_world_position[1] - parent_world_position[1]) / viewport_width
	local scale_y = 1 - (pivot_world_position[2] - parent_world_position[2]) / viewport_height

	return scale_x, scale_y
end

InventoryCosmeticsView.on_resolution_modified = function (self, scale)
	InventoryCosmeticsView.super.on_resolution_modified(self, scale)
end

InventoryCosmeticsView._setup_background_world = function (self)
	local player = self._preview_player
	local player_profile = player:profile()
	local archetype = player_profile.archetype
	local breed_name = archetype.breed
	local default_camera_event_id = "event_register_cosmetics_preview_default_camera_" .. breed_name

	self[default_camera_event_id] = function (instance, camera_unit)
		if instance._context then
			instance._context.camera_unit = camera_unit
		end

		instance._default_camera_unit = camera_unit
		local viewport_name = InventoryCosmeticsViewSettings.viewport_name
		local viewport_type = InventoryCosmeticsViewSettings.viewport_type
		local viewport_layer = InventoryCosmeticsViewSettings.viewport_layer
		local shading_environment = InventoryCosmeticsViewSettings.shading_environment

		instance._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
		instance:_unregister_event(default_camera_event_id)
	end

	self:_register_event(default_camera_event_id)

	self._item_camera_by_slot_id = {}

	for slot_name, slot in pairs(ItemSlotSettings) do
		if slot.slot_type == "gear" then
			local item_camera_event_id = "event_register_cosmetics_preview_item_camera_" .. breed_name .. "_" .. slot_name

			self[item_camera_event_id] = function (instance, camera_unit)
				instance._item_camera_by_slot_id[slot_name] = camera_unit

				instance:_unregister_event(item_camera_event_id)
			end

			self:_register_event(item_camera_event_id)
		end
	end

	self:_register_event("event_register_cosmetics_preview_character_spawn_point")

	local world_name = InventoryCosmeticsViewSettings.world_name
	local world_layer = InventoryCosmeticsViewSettings.world_layer
	local world_timer_name = InventoryCosmeticsViewSettings.timer_name
	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)
	local level_name = InventoryCosmeticsViewSettings.level_name

	self._world_spawner:spawn_level(level_name)
end

InventoryCosmeticsView.world_spawner = function (self)
	return self._world_spawner
end

InventoryCosmeticsView.spawn_point_unit = function (self)
	return self._spawn_point_unit
end

InventoryCosmeticsView.event_register_cosmetics_preview_character_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_cosmetics_preview_character_spawn_point")

	self._spawn_point_unit = spawn_point_unit

	if self._context then
		self._context.spawn_point_unit = spawn_point_unit
	end
end

InventoryCosmeticsView._set_camera_item_slot_focus = function (self, slot_name, time, func_ptr)
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

InventoryCosmeticsView._set_camera_node_focus = function (self, node_name, time, func_ptr)
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

InventoryCosmeticsView._set_camera_position_axis_offset = function (self, axis, value, animation_time, func_ptr)
	self._world_spawner:set_camera_position_axis_offset(axis, value, animation_time, func_ptr)
end

InventoryCosmeticsView._set_camera_rotation_axis_offset = function (self, axis, value, animation_time, func_ptr)
	self._world_spawner:set_camera_rotation_axis_offset(axis, value, animation_time, func_ptr)
end

return InventoryCosmeticsView
