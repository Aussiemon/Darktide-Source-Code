local ContentBlueprints = require("scripts/ui/views/inventory_view/inventory_view_content_blueprints")
local Definitions = require("scripts/ui/views/inventory_weapons_view/inventory_weapons_view_definitions")
local InventoryWeaponsViewSettings = require("scripts/ui/views/inventory_weapons_view/inventory_weapons_view_settings")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local MasterItems = require("scripts/backend/master_items")
local UISettings = require("scripts/settings/ui/ui_settings")
local ItemGridViewBase = require("scripts/ui/views/item_grid_view_base/item_grid_view_base")
local ViewElementWeaponActions = require("scripts/ui/view_elements/view_element_weapon_actions/view_element_weapon_actions")
local ViewElementWeaponStats = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats")
local ItemUtils = require("scripts/utilities/items")
local TextUtilities = require("scripts/utilities/ui/text")
local InventoryWeaponsView = class("InventoryWeaponsView", "ItemGridViewBase")

InventoryWeaponsView.init = function (self, settings, context)
	self._selected_slot = context.selected_slot
	self._preview_player = context.player or Managers.player:local_player(1)
	self._preview_profile_equipped_items = context.preview_profile_equipped_items
	self._is_own_player = self._preview_player == Managers.player:local_player(1)

	InventoryWeaponsView.super.init(self, Definitions, settings, context)

	self._parent = context and context.parent
	self._pass_input = false
	self._pass_draw = false
end

InventoryWeaponsView.character_level = function (self)
	local profile = self._preview_player:profile()
	local profile_level = profile.current_level

	return profile_level
end

InventoryWeaponsView.on_enter = function (self)
	InventoryWeaponsView.super.on_enter(self)

	local selected_slot = self._selected_slot

	if selected_slot then
		self:_fetch_inventory_items(selected_slot)
	end

	self:_register_button_callbacks()
	self:_setup_input_legend()
	self:_setup_background_world()
	self:_setup_item_grid_materials()

	local profile = self._preview_player:profile()
	local profile_archetype = profile.archetype
	local archetype_name = profile_archetype.name

	self:_setup_background_frames_by_archetype(archetype_name)
end

InventoryWeaponsView._setup_background_frames_by_archetype = function (self, archetype_name)
	local inventory_frames_by_archetype = UISettings.inventory_frames_by_archetype
	local frame_textures = inventory_frames_by_archetype[archetype_name]
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.corner_top_left.content.texture = frame_textures.right_upper
	widgets_by_name.corner_bottom_left.content.texture = frame_textures.left_lower
	widgets_by_name.corner_top_right.content.texture = frame_textures.right_upper
	widgets_by_name.corner_bottom_right.content.texture = frame_textures.right_lower
end

InventoryWeaponsView._setup_item_grid_materials = function (self)
	local grid_divider_top = self:_grid_widget_by_name("grid_divider_top")
	grid_divider_top.content.texture = "content/ui/materials/frames/item_list_top"
	grid_divider_top.style.texture.size = {
		652,
		118
	}
	local grid_divider_bottom = self:_grid_widget_by_name("grid_divider_bottom")
	grid_divider_bottom.content.texture = "content/ui/materials/frames/item_list_lower"
	grid_divider_bottom.style.texture.size = {
		640,
		36
	}
	local grid_divider_title = self:_grid_widget_by_name("grid_divider_title")
	grid_divider_title.style.texture.color[1] = 0
	local grid_title_background = self:_grid_widget_by_name("grid_title_background")
	grid_title_background.alpha_multiplier = 0
	local title_text = self:_grid_widget_by_name("title_text")
	title_text.style.text.offset[2] = 4
end

InventoryWeaponsView._setup_weapon_actions = function (self)
	if not self._weapon_actions then
		local reference_name = "weapon_actions"
		local layer = 11
		local title_height = 70
		local edge_padding = 4
		local grid_width = 420
		local grid_height = 840
		local grid_size = {
			grid_width - edge_padding,
			grid_height
		}
		local grid_spacing = {
			0,
			0
		}
		local mask_size = {
			grid_width + 40,
			grid_height
		}
		local context = {
			scrollbar_width = 7,
			ignore_blur = true,
			grid_spacing = grid_spacing,
			grid_size = grid_size,
			mask_size = mask_size,
			title_height = title_height,
			edge_padding = edge_padding
		}
		self._weapon_actions = self:_add_element(ViewElementWeaponActions, reference_name, layer, context)

		self:_update_weapon_actions_position()
	end
end

InventoryWeaponsView.on_resolution_modified = function (self, scale)
	InventoryWeaponsView.super.on_resolution_modified(self, scale)
	self:_update_weapon_actions_position()
end

InventoryWeaponsView._update_weapon_actions_position = function (self)
	if not self._weapon_actions then
		return
	end

	local position = self:_scenegraph_world_position("weapon_actions_pivot")

	self._weapon_actions:set_pivot_offset(position[1], position[2])
end

InventoryWeaponsView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

InventoryWeaponsView._register_button_callbacks = function (self)
	local widgets_by_name = self._widgets_by_name
	local equip_button = widgets_by_name.equip_button
	equip_button.content.hotspot.pressed_callback = callback(self, "cb_on_equip_pressed")
end

InventoryWeaponsView.cb_switch_tab = function (self, index)
	InventoryWeaponsView.super.cb_switch_tab(self, index)

	local tabs_content = self._tabs_content
	local tab_content = tabs_content[index]
	local slot_types = tab_content.slot_types
	local display_name = tab_content.display_name

	self:_present_layout_by_slot_filter(slot_types, display_name)
end

InventoryWeaponsView.cb_on_discard_held = function (self)
	local selected_grid_widget = self:selected_grid_widget()

	if selected_grid_widget and not selected_grid_widget.content.equipped then
		self._update_item_discard = true
	end
end

InventoryWeaponsView.is_selected_item_equipped = function (self)
	local selected_grid_widget = self:selected_grid_widget()

	if selected_grid_widget and selected_grid_widget.content.equipped then
		return true
	end
end

InventoryWeaponsView.cb_on_close_pressed = function (self)
	self:_handle_back_pressed()
end

InventoryWeaponsView._set_preview_widgets_visibility = function (self, visible)
	InventoryWeaponsView.super._set_preview_widgets_visibility(self, visible)

	local widgets_by_name = self._widgets_by_name
	widgets_by_name.equip_button.content.visible = visible
end

InventoryWeaponsView._preview_element = function (self, element)
	InventoryWeaponsView.super._preview_element(self, element)
end

InventoryWeaponsView.sort_items = function (self)
	local sort_options = self._sort_options

	if sort_options then
		local num_options = #sort_options
		local current_index = self._selected_sort_option_index
		local next_index = math.index_wrapper(current_index + 1, num_options)

		self:trigger_sort_index(next_index)
	end
end

InventoryWeaponsView.cb_on_sort_button_pressed = function (self, option)
	InventoryWeaponsView.super.cb_on_sort_button_pressed(self, option)
	self._item_grid:set_expire_time(self._current_rotation_end)
end

InventoryWeaponsView.update = function (self, dt, t, input_service)
	if self._on_discard_anim_complete_cb then
		input_service = input_service:null_service()
	end

	self:_update_equip_button_status(dt)
	self:_update_item_discard_progress(dt)
	self:_update_grid_widgets(dt, t, input_service)

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	return InventoryWeaponsView.super.update(self, dt, t, input_service)
end

InventoryWeaponsView._handle_input = function (self, input_service)
	if input_service:get("confirm_pressed") then
		self:cb_on_equip_pressed()
	end
end

InventoryWeaponsView._handle_back_pressed = function (self)
	local view_name = "inventory_weapons_view"

	Managers.ui:close_view(view_name)
end

InventoryWeaponsView.cb_on_customize_pressed = function (self)
	self._customize_view_opened = true

	Managers.ui:open_view("inventory_weapon_cosmetics_view", nil, nil, nil, nil, {
		player = self._preview_player,
		preview_item = self._previewed_item
	})
end

InventoryWeaponsView.cb_on_inspect_pressed = function (self)
	self._inpect_view_opened = true

	Managers.ui:open_view("inventory_weapon_details_view", nil, nil, nil, nil, {
		player = self._preview_player,
		preview_item = self._previewed_item
	})
end

InventoryWeaponsView.cb_on_equip_pressed = function (self)
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
	self:_handle_back_pressed()
end

InventoryWeaponsView._setup_background_world = function (self)
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
		local viewport_name = InventoryWeaponsViewSettings.viewport_name
		local viewport_type = InventoryWeaponsViewSettings.viewport_type
		local viewport_layer = InventoryWeaponsViewSettings.viewport_layer
		local shading_environment = InventoryWeaponsViewSettings.shading_environment

		instance._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
		instance:_unregister_event(default_camera_event_id)
	end

	self:_register_event(default_camera_event_id)

	local world_name = InventoryWeaponsViewSettings.world_name
	local world_layer = InventoryWeaponsViewSettings.world_layer
	local world_timer_name = InventoryWeaponsViewSettings.timer_name
	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)
	local level_name = InventoryWeaponsViewSettings.level_name

	self._world_spawner:spawn_level(level_name)
end

InventoryWeaponsView.world_spawner = function (self)
	return self._world_spawner
end

InventoryWeaponsView.on_exit = function (self)
	if self._weapon_actions then
		self:_remove_element("weapon_actions")

		self._weapon_actions = nil
	end

	if self._store_promise then
		self._store_promise:cancel()

		self._store_promise = nil
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	if self._inpect_view_opened then
		self._inpect_view_opened = nil

		if Managers.ui:view_active("inventory_weapon_details_view") then
			Managers.ui:close_view("inventory_weapon_details_view")
		end
	end

	if self._customize_view_opened then
		self._customize_view_opened = nil

		if Managers.ui:view_active("inventory_weapon_cosmetics_view") then
			Managers.ui:close_view("inventory_weapon_cosmetics_view")
		end
	end

	Managers.event:trigger("event_equip_local_changes")

	if self._is_equipped_weapon_changed then
		local selected_slot = self._selected_slot

		if selected_slot then
			local selected_slot_name = selected_slot.name
			local item_slot_settings = ItemSlotSettings[selected_slot_name]

			if item_slot_settings.slot_type == "weapon" then
				Managers.event:trigger("event_change_wield_slot", selected_slot_name)
			end
		end
	end

	InventoryWeaponsView.super.on_exit(self)
end

InventoryWeaponsView._fetch_inventory_items = function (self, selected_slot)
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local character_id = player:character_id()
	local slot_name = selected_slot.name
	local slot_filter = {
		slot_name
	}

	Managers.data_service.gear:fetch_inventory(character_id, slot_filter):next(function (items)
		if self._destroyed then
			return
		end

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
				local valid = true

				if valid and slots then
					for j = 1, #slots do
						if slots[j] == slot_name then
							layout[#layout + 1] = {
								widget_type = "item",
								item = item,
								slot = selected_slot
							}
						end
					end
				end
			end
		end

		self._offer_items_layout = layout
		local slot_display_name = selected_slot and selected_slot.display_name

		self:_present_layout_by_slot_filter(nil, slot_display_name)

		local start_index = #layout > 0 and 1
		local equipped_item = start_index and self:equipped_item_in_slot(slot_name)

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

InventoryWeaponsView._calc_text_size = function (self, widget, text_and_style_id)
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

InventoryWeaponsView._get_item_from_inventory = function (self, wanted_item)
	local inventory_items = self._inventory_items
	local wanted_item_gear_id = wanted_item and wanted_item.gear_id

	for _, item in ipairs(inventory_items) do
		local gear_id = item.gear_id

		if gear_id == wanted_item_gear_id then
			return item
		end
	end

	return wanted_item
end

InventoryWeaponsView._item_valid_by_current_profile = function (self, item)
	local player = self._preview_player
	local profile = player:profile()
	local archetype = profile.archetype
	local archetype_name = archetype.name
	local breed_name = archetype.breed
	local breed_valid = not item.breeds or table.contains(item.breeds, breed_name)
	local archetype_valid = not item.archetypes or table.contains(item.archetypes, archetype_name)

	if archetype_valid and breed_valid then
		return true
	end

	return false
end

InventoryWeaponsView._equip_item = function (self, slot_name, item)
	if self._equip_button_disabled then
		return
	end

	local equipped_slot_item = self:equipped_item_in_slot(slot_name)

	if not equipped_slot_item or equipped_slot_item.gear_id ~= item.gear_id then
		Managers.event:trigger("event_inventory_view_equip_item", slot_name, item)

		self._is_equipped_weapon_changed = true
	end

	self:_play_sound(UISoundEvents.weapons_select_weapon)
end

InventoryWeaponsView.equipped_item_in_slot = function (self, slot_name)
	local slot_item = self._preview_profile_equipped_items[slot_name]
	local item = slot_item and self:_get_item_from_inventory(slot_item)

	return item
end

InventoryWeaponsView._update_grid_widgets = function (self, dt, t, input_service)
	local discard_anim_progress = 0
	local discard_anim_duration = self._discard_anim_duration

	if discard_anim_duration then
		discard_anim_progress = 1 - discard_anim_duration / InventoryWeaponsViewSettings.item_discard_anim_duration

		if discard_anim_progress >= 1 then
			self._discard_anim_duration = nil
		else
			self._discard_anim_duration = math.max(discard_anim_duration - dt, 0)
		end
	end

	local widgets = self:grid_widgets()

	if widgets then
		local previewed_item = self._previewed_item
		local discard_item_hold_progress = self._discard_item_hold_progress
		local previous_widget_offset, first_discarded_item_index = nil
		local list_discard_offset_corrected = false
		local num_widgets = #widgets

		for i = 1, num_widgets do
			local widget = widgets[i]
			local offset = widget.offset
			local default_offset = widget.default_offset
			local style = widget.style
			local content = widget.content
			local element = content.element
			local discarded = content.discarded
			local item = element.item

			if item then
				local is_selected = previewed_item and previewed_item.gear_id == item.gear_id
				style.salvage_circle.material_values.progress = is_selected and discard_item_hold_progress or 0
			end

			if discarded then
				widget.alpha_multiplier = math.easeInCubic(1 - discard_anim_progress)
			end

			if first_discarded_item_index and first_discarded_item_index < i then
				local move_progress = math.easeInCubic(discard_anim_progress or 1)
				local offset_difference_height = previous_widget_offset[2] - default_offset[2]
				offset[2] = default_offset[2] + offset_difference_height * move_progress
			end

			if not first_discarded_item_index and discarded then
				first_discarded_item_index = i
			end

			previous_widget_offset = default_offset
		end

		if discard_anim_progress and discard_anim_progress == 1 and self._on_discard_anim_complete_cb then
			self._on_discard_anim_complete_cb()

			self._on_discard_anim_complete_cb = nil
		end
	end
end

InventoryWeaponsView._discard_items = function (self, item)
	local gear_id = item.gear_id
	local backend_interface = Managers.backend.interfaces
	local delete_promise = backend_interface.gear:delete_gear(gear_id)

	delete_promise:next(function (result)
		local rewards = result and result.rewards

		if rewards then
			local credits_amount = rewards[1] and rewards[1].amount or 0
			local credits_amount_text = TextUtilities.format_currency(credits_amount) .. " "
			local localization_key = "loc_notification_title_credits_added"
			local localized_text = Localize(localization_key, true, {
				credits_amount = credits_amount_text
			})

			Managers.event:trigger("event_add_notification_message", "default", localized_text)
		end
	end)
end

InventoryWeaponsView._mark_item_for_discard = function (self, grid_index)
	local grid_widgets = self:grid_widgets()
	local widget = grid_widgets[grid_index]
	local content = widget.content
	local element = content.element
	local item = element.item
	local gear_id = item.gear_id
	local inventory_items = self._inventory_items

	for i = 1, #inventory_items do
		if inventory_items[i].gear_id == gear_id then
			table.remove(self._inventory_items, i)

			break
		end
	end

	content.discarded = true
	local item_grid = self._item_grid
	local grid = item_grid:grid()
	local new_grid_index = nil
	local last_interactable_grid_index = grid:last_interactable_grid_index() - 1

	if last_interactable_grid_index > 0 then
		if grid_index <= last_interactable_grid_index then
			new_grid_index = grid_index
		else
			new_grid_index = grid_index - 1
		end
	end

	self._discard_anim_duration = InventoryWeaponsViewSettings.item_discard_anim_duration

	self._on_discard_anim_complete_cb = function ()
		local length_scrolled = grid:length_scrolled()
		local widget_to_remove = self:grid_widgets()[grid_index]

		grid:remove_widget(widget_to_remove)

		local new_scroll_progress = grid:scroll_progress_by_length(length_scrolled)

		grid:clear_scroll_progress()

		local new_element = new_grid_index and self:element_by_index(new_grid_index)

		if new_element then
			local new_selection_item = new_element.item

			self:focus_on_item(new_selection_item)
		else
			self:_stop_previewing()
		end
	end

	self:_discard_items(item)
end

InventoryWeaponsView._stop_previewing = function (self)
	InventoryWeaponsView.super._stop_previewing(self)

	if self._weapon_actions then
		self._weapon_actions:stop_presenting()
	end
end

InventoryWeaponsView._preview_item = function (self, item)
	InventoryWeaponsView.super._preview_item(self, item)

	local slots = item.slots

	if slots and (table.find(slots, "slot_primary") or table.find(slots, "slot_secondary")) and self._weapon_actions then
		self._weapon_actions:present_item(item)
	end
end

InventoryWeaponsView._update_equip_button_status = function (self)
	local previewed_item = self._previewed_item

	if not previewed_item then
		return
	end

	local disable_button = not previewed_item
	local level_requirement_met = true

	if not disable_button then
		local selected_slot = self._selected_slot
		local selected_slot_name = selected_slot.name
		local equipped_item = self:equipped_item_in_slot(selected_slot_name)
		disable_button = equipped_item and equipped_item.gear_id == previewed_item.gear_id

		if not disable_button then
			local required_level = ItemUtils.character_level(previewed_item)
			local character_level = self:character_level()
			level_requirement_met = required_level and required_level <= character_level

			if not level_requirement_met then
				disable_button = true
			end
		end
	end

	if self._equip_button_disabled ~= disable_button then
		self._equip_button_disabled = disable_button
		local button = self._widgets_by_name.equip_button
		local button_content = button.content
		button_content.hotspot.disabled = disable_button

		if level_requirement_met then
			button_content.text = string.upper(disable_button and Localize("loc_weapon_inventory_equipped_button") or Localize("loc_weapon_inventory_equip_button"))
		else
			button_content.text = string.upper(Localize("loc_weapon_inventory_equip_button"))
		end
	end
end

InventoryWeaponsView._update_item_discard_progress = function (self, dt)
	if self._update_item_discard and self:selected_grid_index() then
		self._update_item_discard = nil

		if not self._discard_item_timer then
			self._discard_item_timer = 0
		end

		local time = self._discard_item_timer + dt
		local progress = math.min(time / InventoryWeaponsViewSettings.item_discard_hold_duration, 1)
		self._discard_item_hold_progress = progress

		if progress < 1 then
			self._discard_item_timer = time
		else
			self._discard_item_timer = nil
			self._discard_item_hold_progress = nil
			local selected_grid_index = self:selected_grid_index()

			if selected_grid_index then
				self:_mark_item_for_discard(selected_grid_index)
			end
		end
	elseif self._discard_item_timer then
		self._discard_item_timer = nil
		self._discard_item_hold_progress = nil
	end
end

return InventoryWeaponsView
