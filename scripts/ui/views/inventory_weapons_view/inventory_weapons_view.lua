-- chunkname: @scripts/ui/views/inventory_weapons_view/inventory_weapons_view.lua

require("scripts/ui/views/item_grid_view_base/item_grid_view_base")

local ContentBlueprints = require("scripts/ui/views/inventory_view/inventory_view_content_blueprints")
local Definitions = require("scripts/ui/views/inventory_weapons_view/inventory_weapons_view_definitions")
local InventoryWeaponsViewSettings = require("scripts/ui/views/inventory_weapons_view/inventory_weapons_view_settings")
local ItemGridViewBase = require("scripts/ui/views/item_grid_view_base/item_grid_view_base")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local ProfileUtils = require("scripts/utilities/profile_utils")
local TextUtilities = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementWeaponActions = require("scripts/ui/view_elements/view_element_weapon_actions/view_element_weapon_actions")
local ViewElementDiscardItems = require("scripts/ui/view_elements/view_element_discard_items/view_element_discard_items")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local InventoryWeaponsView = class("InventoryWeaponsView", "ItemGridViewBase")

InventoryWeaponsView.init = function (self, settings, context)
	self._selected_slot = context.selected_slot
	self._preview_player = context.player or Managers.player:local_player(1)
	self._preview_profile_equipped_items = context.preview_profile_equipped_items
	self._is_own_player = self._preview_player == Managers.player:local_player(1)
	self.item_type = context.item_type

	InventoryWeaponsView.super.init(self, Definitions, settings, context)

	self._parent = context.parent
	self._pass_input = false
	self._pass_draw = false
end

InventoryWeaponsView.on_enter = function (self)
	InventoryWeaponsView.super.on_enter(self)

	local selected_slot = self._selected_slot

	if selected_slot then
		self:_fetch_inventory_items(selected_slot)
	end

	self:_register_event("event_replace_list_item", "event_replace_list_item")
	self:_register_event("event_switch_mark_complete", "event_switch_mark_complete")
	self:_register_event("event_discard_items", "event_discard_items")
	self:_register_button_callbacks()
	self:_setup_input_legend()
	self:_setup_background_world()
	self:_setup_item_grid_materials()
	self:_setup_weapon_options()

	local profile = self._preview_player:profile()
	local profile_archetype = profile.archetype
	local archetype_name = profile_archetype.name

	self:_setup_background_frames_by_archetype(archetype_name)
end

InventoryWeaponsView.event_switch_mark_complete = function (self, item)
	local selected_slot = self._selected_slot
	local gear_id = item.gear_id

	if item.slots[1] == selected_slot.name then
		for i = 1, #self._inventory_items do
			local inventory_item = self._inventory_items[i]

			if inventory_item.gear_id == gear_id then
				self._inventory_items[i] = item

				break
			end
		end

		local layout, index = self:_get_offer_item_layout_by_gear_id(gear_id)

		if layout then
			layout.item = item
		end

		local slot_display_name = selected_slot and selected_slot.display_name

		self:event_replace_list_item(item)
	end
end

InventoryWeaponsView._setup_background_frames_by_archetype = function (self, archetype_name)
	local inventory_frames_by_archetype = UISettings.inventory_frames_by_archetype
	local frame_textures = inventory_frames_by_archetype[archetype_name]
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.corner_bottom_left.content.texture = frame_textures.left_lower
	widgets_by_name.corner_bottom_right.content.texture = frame_textures.right_lower
end

InventoryWeaponsView._setup_item_grid_materials = function (self)
	local grid_divider_top = self:_grid_widget_by_name("grid_divider_top")

	grid_divider_top.content.texture = "content/ui/materials/frames/item_list_top"
	grid_divider_top.style.texture.size = {
		652,
		118,
	}

	local grid_divider_bottom = self:_grid_widget_by_name("grid_divider_bottom")

	grid_divider_bottom.content.texture = "content/ui/materials/frames/item_list_lower"
	grid_divider_bottom.style.texture.size = {
		640,
		36,
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
			grid_height,
		}
		local grid_spacing = {
			0,
			0,
		}
		local mask_size = {
			grid_width + 40,
			grid_height,
		}
		local context = {
			ignore_blur = true,
			scrollbar_width = 7,
			grid_spacing = grid_spacing,
			grid_size = grid_size,
			mask_size = mask_size,
			title_height = title_height,
			edge_padding = edge_padding,
		}

		self._weapon_actions = self:_add_element(ViewElementWeaponActions, reference_name, layer, context)

		self:_update_weapon_actions_position()
	end
end

InventoryWeaponsView.on_resolution_modified = function (self, scale)
	InventoryWeaponsView.super.on_resolution_modified(self, scale)
	self:_update_weapon_actions_position()

	if self._discard_items_element then
		local discard_items_position = self:_scenegraph_world_position("weapon_discard_pivot")

		self._discard_items_element:set_pivot_offset(discard_items_position[1], discard_items_position[2])
	end
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

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment, nil, legend_input.use_mouse_hold)
	end
end

InventoryWeaponsView._register_button_callbacks = function (self)
	local widgets_by_name = self._widgets_by_name
	local equip_button = widgets_by_name.equip_button

	equip_button.content.hotspot.pressed_callback = callback(self, "cb_on_equip_pressed")
	self._widgets_by_name.discard_button.content.hotspot.pressed_callback = callback(self, "cb_on_discard_button_pressed")
end

InventoryWeaponsView.cb_switch_tab = function (self, index)
	InventoryWeaponsView.super.cb_switch_tab(self, index)
end

InventoryWeaponsView.cb_on_discard_pressed = function (self)
	self._selected_items = {}

	if self._item_compare_toggled then
		self:cb_on_toggle_item_compare()
	end

	if self._weapon_options_element then
		self._weapon_options_element:set_visibility(false)
	end

	if self._discard_items_element then
		self:_remove_element("discard_items")

		self._discard_items_element = nil
		self._widgets_by_name.discard_button.content.visible = false
		self._widgets_by_name.equip_button.content.visible = true

		local sort_options = self._sort_options
		local new_layout = self._offer_items_layout

		if sort_options then
			local sort_index = self._selected_sort_option_index or 1
			local selected_sort_option = sort_options[sort_index]
			local selected_sort_function = selected_sort_option.sort_function

			table.sort(new_layout, selected_sort_function)
		end

		self:present_grid_layout(new_layout, function ()
			local widgets = self._item_grid:widgets()

			for i = 1, #widgets do
				local widget = widgets[i]

				widget.content.multi_selected = false
			end

			local index

			if self._preselected_item then
				index = self:item_grid_index(self._preselected_item)
				self._preselected_item = nil
			end

			index = index or self._item_grid:first_interactable_grid_index()

			local widget = index and self:widget_by_index(index)

			if widget then
				local element = widget.content.element

				self._item_grid:select_grid_index(index)

				local scrollbar_animation_progress = self._item_grid:get_scrollbar_percentage_by_index(index) or 0

				self._item_grid:set_scrollbar_progress(scrollbar_animation_progress, true)
				self._item_grid:disable_input(false)

				local item = element and element.item

				if item then
					self:_preview_item(item)
				end
			end
		end)

		local widget_index = self:selected_grid_index()
		local widget = self:selected_grid_widget()

		self:_play_sound(UISoundEvents.weapons_discard_exit)
	else
		local selected_slot = self._selected_slot
		local selected_slot_name = selected_slot.name
		local new_layout = {}
		local items = {}
		local equipped_item = self:equipped_item_in_slot(selected_slot_name)

		for index, layout in ipairs(self._offer_items_layout) do
			local item = layout.item

			if not equipped_item or equipped_item and item and item.gear_id ~= equipped_item.gear_id then
				new_layout[#new_layout + 1] = layout
				items[#items + 1] = layout.item
			end
		end

		self._discard_items_element = self:_add_element(ViewElementDiscardItems, "discard_items", 1, {
			items = items,
			selection_callback = callback(self, "_mark_items_to_sell"),
			unselection_callback = callback(self, "_unmark_items_to_sell"),
		})

		local discard_items_position = self:_scenegraph_world_position("weapon_discard_pivot")

		self._discard_items_element:set_pivot_offset(discard_items_position[1], discard_items_position[2])

		local sort_options = self._sort_options

		if sort_options then
			local sort_index = self._selected_sort_option_index or 1
			local selected_sort_option = sort_options[sort_index]
			local selected_sort_function = selected_sort_option.sort_function

			table.sort(new_layout, selected_sort_function)
		end

		self._preselected_item = self._previewed_item

		self:present_grid_layout(new_layout, function ()
			self:_stop_previewing()
		end)

		self._widgets_by_name.discard_button.content.visible = true
		self._widgets_by_name.equip_button.content.visible = false

		self._item_grid:select_grid_widget()

		if self._selected_options then
			self:cb_on_options_pressed()
		end

		if not self._using_cursor_navigation then
			self._discard_items_element:disable_input(true)
		else
			self._discard_items_element:disable_input(false)
		end

		self:_play_sound(UISoundEvents.weapons_discard_enter)
	end
end

InventoryWeaponsView.cb_on_discard_button_pressed = function (self)
	if not self._selected_items or table.is_empty(self._selected_items) then
		return
	end

	if self._discard_items_element:visible() then
		local new_layout = {}

		for gear_id, _ in pairs(self._selected_items) do
			local layout = self:_get_offer_item_layout_by_gear_id(gear_id)

			if layout then
				new_layout[#new_layout + 1] = layout
			end
		end

		local sort_options = self._sort_options

		if sort_options then
			local sort_index = self._selected_sort_option_index or 1
			local selected_sort_option = sort_options[sort_index]
			local selected_sort_function = selected_sort_option.sort_function

			table.sort(new_layout, selected_sort_function)
		end

		self:present_grid_layout(new_layout, function ()
			self._item_grid:disable_input(false)
			self._item_grid:select_first_index()

			local widgets = self._item_grid:widgets()

			for i = 1, #widgets do
				local widget = widgets[i]

				widget.content.multi_selected = false
			end
		end)

		self._widgets_by_name.discard_button.content.original_text = Utf8.upper(Localize("loc_confirm"))

		if not self._using_cursor_navigation then
			self._discard_items_element:disable_input(true)
		else
			self._discard_items_element:disable_input(false)
		end

		self._discard_items_element:set_visibility(false)
		self:_play_sound(UISoundEvents.weapons_discard_continue)
	else
		local gear_ids = {}

		for gear_id, item in pairs(self._selected_items) do
			gear_ids[#gear_ids + 1] = gear_id
		end

		Managers.event:trigger("event_discard_items", gear_ids)

		self._selected_items = {}

		local widgets = self._item_grid:widgets()

		for i = 1, #widgets do
			local widget = widgets[i]

			widget.content.multi_selected = false
		end

		self:_play_sound(UISoundEvents.weapons_discard_complete)
	end
end

InventoryWeaponsView._mark_items_to_sell = function (self, items)
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

InventoryWeaponsView._unmark_items_to_sell = function (self, items)
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

InventoryWeaponsView._item_hover_update = function (self)
	local widget = self._item_grid:hovered_widget()
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

InventoryWeaponsView.cb_on_favorite_pressed = function (self)
	local widget

	if self._discard_items_element and self._using_cursor_navigation then
		widget = self._item_grid and self._item_grid:hovered_widget()
	else
		widget = self._item_grid and self._item_grid:selected_grid_widget()
	end

	local gear_id = widget and widget.content.element and widget.content.element.item and widget.content.element.item.gear_id
	local is_favorite = ItemUtils.is_item_id_favorited(gear_id)

	if self._discard_items_element and not is_favorite and widget.content.multi_selected then
		local element = widget.content.element

		self:cb_on_grid_entry_left_pressed(widget, element)
	end

	ItemUtils.set_item_id_as_favorite(gear_id, not is_favorite)

	if self._discard_items_element then
		self._discard_items_element:refresh()
	end
end

InventoryWeaponsView.cb_on_grid_entry_left_pressed = function (self, widget, element)
	if self._discard_items_element then
		if self._destroyed or not self._discard_items_element:visible() then
			return
		end

		local item = element.item
		local is_favorite = ItemUtils.is_item_id_favorited(element.item.gear_id)

		if is_favorite then
			return
		end

		if not self._selected_items[item.gear_id] then
			self._selected_items[item.gear_id] = true
			widget.content.multi_selected = true

			self:_play_sound(UISoundEvents.mastery_select_weapon)
		else
			self._selected_items[item.gear_id] = nil
			widget.content.multi_selected = false

			self:_play_sound(UISoundEvents.weapons_select_weapon)
		end
	else
		local function cb_func()
			if self._destroyed then
				return
			end

			local item = element.item

			if Managers.ui:using_cursor_navigation() then
				if item and item ~= self._previewed_item then
					local widget_index = self._item_grid:widget_index(widget) or 1

					self._item_grid:focus_grid_index(widget_index)
				end
			else
				self:cb_on_equip_pressed()
			end
		end

		self._update_callback_on_grid_entry_left_pressed = callback(cb_func)
	end
end

InventoryWeaponsView.is_selected_item_equipped = function (self)
	local selected_grid_widget = self:selected_grid_widget()

	if selected_grid_widget and selected_grid_widget.content.equipped then
		return true
	end
end

InventoryWeaponsView.is_selected_item_favorited = function (self)
	local selected_grid_widget = self:selected_grid_widget()

	if selected_grid_widget then
		local content = selected_grid_widget.content
		local element = content.element
		local item = element and element.item
		local gear_id = item and item.gear_id

		return gear_id and ItemUtils.is_item_id_favorited(gear_id)
	end
end

InventoryWeaponsView.cb_on_close_pressed = function (self)
	self:_handle_back_pressed()
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

InventoryWeaponsView.update = function (self, dt, t, input_service)
	if self._on_discard_anim_complete_cb then
		input_service = input_service:null_service()
	end

	self:_update_equip_button_status(dt)
	self:_update_discard_button_status(dt)

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	if self._item_grid and self._discard_items_element then
		self:_item_hover_update()
	end

	return InventoryWeaponsView.super.update(self, dt, t, input_service)
end

InventoryWeaponsView._handle_input = function (self, input_service)
	if not self._using_cursor_navigation then
		if self._weapon_options_element and self._weapon_options_element:visible() then
			if input_service:get("navigate_left_continuous") and not self._weapon_options_element:input_disabled() then
				self:cb_on_options_pressed()
			elseif input_service:get("navigate_right_continuous") and self._weapon_options_element:input_disabled() then
				self:cb_on_options_pressed()
			end
		elseif self._discard_items_element and self._discard_items_element:visible() then
			if input_service:get("navigate_left_continuous") and not self._discard_items_element:input_disabled() then
				self._discard_items_element:disable_input(true)
				self._item_grid:disable_input(false)

				if self._selected_item_index then
					self._item_grid:select_grid_index(self._selected_item_index)
				else
					self._item_grid:select_first_index()
				end

				self._selected_item_index = nil

				local selected_widget = self:selected_grid_widget()
				local item = selected_widget and selected_widget.content.element and selected_widget.content.element.item

				if item then
					self:_preview_item(item)
				end
			elseif input_service:get("navigate_right_continuous") and self._discard_items_element:input_disabled() then
				local item = self:previewed_item()

				self._discard_items_element:disable_input(false)
				self._discard_items_element:select_first_index()
				self._item_grid:disable_input(true)

				self._selected_item_index = self._item_grid:selected_grid_index()

				self._item_grid:select_grid_index()
				self:_stop_previewing()
			elseif input_service:get("gamepad_secondary_action_pressed") then
				self:cb_on_discard_button_pressed()
			end
		elseif self._discard_items_element and input_service:get("gamepad_secondary_action_pressed") then
			self:cb_on_discard_button_pressed()
		end
	end
end

InventoryWeaponsView._handle_back_pressed = function (self)
	if not self._discard_items_element then
		local view_name = "inventory_weapons_view"

		Managers.ui:close_view(view_name)
	elseif self._discard_items_element:visible() then
		self:cb_on_discard_pressed()
	else
		local new_layout = {}
		local new_items = {}
		local selected_slot = self._selected_slot
		local selected_slot_name = selected_slot.name
		local equipped_item = self:equipped_item_in_slot(selected_slot_name)

		for index, layout in ipairs(self._offer_items_layout) do
			local item = layout.item

			if not equipped_item or equipped_item and item and item.gear_id ~= equipped_item.gear_id then
				new_layout[#new_layout + 1] = layout
				new_items[#new_items + 1] = item
			end
		end

		local sort_options = self._sort_options

		if sort_options then
			local sort_index = self._selected_sort_option_index or 1
			local selected_sort_option = sort_options[sort_index]
			local selected_sort_function = selected_sort_option.sort_function

			table.sort(new_layout, selected_sort_function)
		end

		self:present_grid_layout(new_layout, function ()
			local widgets = self._item_grid:widgets()

			for i = 1, #widgets do
				local widget = widgets[i]
				local gear_id = widget.content.element.item.gear_id

				if self._selected_items[gear_id] then
					widget.content.multi_selected = true
				end
			end
		end)

		self._widgets_by_name.discard_button.content.original_text = Utf8.upper(Localize("loc_alias_view_hotkey_item_discard"))

		self._discard_items_element:refresh(new_items)
		self._discard_items_element:set_visibility(true)
		self:_play_sound(UISoundEvents.weapons_discard_back)
	end
end

InventoryWeaponsView.cb_on_customize_pressed = function (self)
	if not Managers.ui:view_active("inventory_weapon_cosmetics_view") then
		self._customize_view_opened = true

		Managers.ui:open_view("inventory_weapon_cosmetics_view", nil, nil, nil, nil, {
			player = self._preview_player,
			preview_item = self._previewed_item,
			parent = self._parent,
			new_items_gear_ids = self._parent and self._parent._new_items_gear_ids,
		})
	end
end

InventoryWeaponsView.cb_on_options_pressed = function (self)
	self._selected_options = not self._selected_options

	self._weapon_options_element:disable_input(not self._selected_options)
	self._item_grid:disable_input(self._selected_options)

	if self._selected_options then
		self._weapon_options_element:select_first_index()
	else
		self._weapon_options_element:select_grid_index()
	end
end

InventoryWeaponsView._on_navigation_input_changed = function (self)
	if self._using_cursor_navigation then
		if self._weapon_options_element then
			self._weapon_options_element:disable_input(false)
			self._weapon_options_element:select_grid_index()
		end

		if self._discard_items_element then
			self._discard_items_element:disable_input(false)

			self._selected_item_index = nil

			self._item_grid:select_grid_index()
			self:_stop_previewing()
		end

		self._item_grid:disable_input(false)
	elseif self._weapon_options_element and self._weapon_options_element:visible() then
		local selected_options = self._selected_options

		self._weapon_options_element:disable_input(not selected_options)
		self._item_grid:disable_input(selected_options)

		if selected_options then
			self._weapon_options_element:select_first_index()
		end
	elseif self._discard_items_element then
		if self._discard_items_element:visible() and self._item_grid:input_disabled() then
			if self._selected_item_index then
				self._item_grid:select_grid_index(self._selected_item_index)

				self._selected_item_index = nil
			else
				self._item_grid:select_first_index()
			end
		end

		self._discard_items_element:disable_input(true)
		self._item_grid:disable_input(false)
	end
end

InventoryWeaponsView.cb_on_inspect_pressed = function (self)
	if not Managers.ui:view_active("inventory_weapon_details_view") then
		self._inpect_view_opened = true

		Managers.ui:open_view("inventory_weapon_details_view", nil, nil, nil, nil, {
			player = self._preview_player,
			preview_item = self._previewed_item,
		})
	end
end

InventoryWeaponsView.cb_on_marks_pressed = function (self)
	if not Managers.ui:view_active("inventory_weapon_marks_view") then
		self._marks_view_opened = true

		Managers.ui:open_view("inventory_weapon_marks_view", nil, nil, nil, nil, {
			player = self._preview_player,
			preview_item = self._previewed_item,
			parent = self._parent,
			new_items_gear_ids = self._parent and self._parent._new_items_gear_ids,
		})
	end
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

	self:_play_sound(UISoundEvents.default_menu_exit)
	InventoryWeaponsView.super.on_exit(self)
end

InventoryWeaponsView._fetch_inventory_items = function (self, selected_slot)
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local character_id = player:character_id()
	local slot_name = selected_slot.name
	local slot_filter = {
		slot_name,
	}

	Managers.data_service.gear:fetch_inventory(character_id, slot_filter):next(function (items)
		if self._destroyed then
			return
		end

		self._inventory_items = items

		local layout = {}

		for gear_id, item in pairs(items) do
			if self:_item_valid_by_current_profile(item) then
				local slots = item.slots
				local valid = true
				local gear_id = item.gear_id
				local is_new = self._context and self._context.new_items_gear_ids and self._context.new_items_gear_ids[gear_id]
				local remove_new_marker_callback

				if is_new then
					remove_new_marker_callback = self._parent and callback(self._parent, "remove_new_item_mark")
				end

				local widget_type = "item"

				if valid and slots then
					for j = 1, #slots do
						if slots[j] == slot_name then
							layout[#layout + 1] = {
								item = item,
								slot = selected_slot,
								widget_type = widget_type,
								new_item_marker = is_new,
								remove_new_marker_callback = remove_new_marker_callback,
							}
						end
					end
				end
			end
		end

		self._offer_items_layout = layout

		local slot_display_name = selected_slot and selected_slot.display_name
		local start_index = #layout > 0 and 1
		local equipped_item = start_index and self:equipped_item_in_slot(slot_name)

		if equipped_item then
			start_index = self:item_grid_index(equipped_item) or start_index

			if start_index then
				self._selected_gear_id = equipped_item and equipped_item.gear_id
			end
		else
			local first_item = self:first_grid_item()

			if first_item then
				self._selected_gear_id = first_item and first_item.gear_id
			end
		end

		self:_present_layout_by_slot_filter(nil, nil, slot_display_name)
	end)
end

InventoryWeaponsView._setup_weapon_options = function (self)
	if ItemUtils.is_weapon(self.item_type) then
		local button_size = self._definitions.blueprints.button.size
		local top_padding = 30
		local grid_size = {
			button_size[1],
			(button_size[2] + 20) * 3 + top_padding,
		}
		local grid_options = {
			edge_padding = 40,
			scrollbar_width = 7,
			title_height = 0,
			use_is_focused_for_navigation = false,
			use_select_on_focused = true,
			use_terminal_background = true,
			grid_spacing = {
				10,
				10,
			},
			grid_size = grid_size,
			mask_size = {
				grid_size[1] + 40,
				grid_size[2] + 40,
			},
			top_padding = top_padding,
		}

		self._weapon_options_element = self:_add_element(ViewElementGrid, "weapon_options", 10, grid_options)

		local layout = {
			{
				display_icon = "",
				widget_type = "button",
				display_name = Localize("loc_inventory_weapon_button_marks"),
				callback = callback(self, "cb_on_marks_pressed"),
			},
			{
				display_icon = "",
				widget_type = "button",
				display_name = Localize("loc_inventory_weapon_button_cosmetics"),
				callback = callback(self, "cb_on_customize_pressed"),
			},
			{
				display_icon = "",
				widget_type = "button",
				display_name = Localize("loc_inventory_weapon_button_inspect"),
				callback = callback(self, "cb_on_inspect_pressed"),
			},
		}

		self._weapon_options_element:update_dividers("content/ui/materials/frames/marks_top", {
			413.28,
			58.8,
		}, {
			0,
			-20,
			20,
		})
		self._weapon_options_element:present_grid_layout(layout, self._definitions.blueprints)
		self._weapon_options_element:disable_input(true)
		self._weapon_options_element:set_visibility(false)
	end
end

InventoryWeaponsView._calc_text_size = function (self, widget, text_and_style_id)
	local text = widget.content[text_and_style_id]
	local text_style = widget.style[text_and_style_id]
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local size = text_style.size or widget.content.size or {
		self:_scenegraph_size(widget.scenegraph_id),
	}

	return UIRenderer.text_size(self._ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)
end

InventoryWeaponsView.event_replace_list_item = function (self, item)
	self:replace_item_instance(item)

	if self._previewed_item and item and self._previewed_item.gear_id == item.gear_id then
		self:_preview_item(item)
	end
end

InventoryWeaponsView._get_offer_item_layout_by_gear_id = function (self, gear_id)
	local offer_items_layout = self._offer_items_layout

	if offer_items_layout then
		for i = 1, #offer_items_layout do
			local offer = offer_items_layout[i]

			if offer.item and offer.item.gear_id and offer.item.gear_id == gear_id then
				return offer, i
			end
		end
	end
end

InventoryWeaponsView.replace_item_instance = function (self, item)
	local gear_id = item.gear_id
	local inventory_items = self._inventory_items

	if inventory_items and inventory_items[gear_id] then
		inventory_items[gear_id] = item
	end

	local layout, index = self:_get_offer_item_layout_by_gear_id(item.gear_id)

	if index then
		self._offer_items_layout[index].item = item
	end

	local widgets = self:grid_widgets()

	if widgets then
		for i = 1, #widgets do
			local widget = widgets[i]
			local widget_item = widget.content.element.item

			if widget_item and widget_item.gear_id == gear_id then
				widget.content.element.item = item

				self:force_update_grid_widget_icon(i)

				break
			end
		end
	end
end

InventoryWeaponsView._get_item_from_inventory = function (self, wanted_item)
	local inventory_items = self._inventory_items
	local wanted_item_gear_id = wanted_item and wanted_item.gear_id

	for gear_id, item in ipairs(inventory_items) do
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

InventoryWeaponsView._on_double_click = function (self, widget, element)
	local selected_slot = self._selected_slot

	if not selected_slot then
		return
	end

	local previewed_item = self._previewed_item

	if not previewed_item then
		return
	end

	if widget.content.discarded then
		return
	end

	local selected_slot_name = selected_slot.name

	self:_equip_item(selected_slot_name, previewed_item)
end

InventoryWeaponsView._fetch_item_compare_slot_name = function (self, item)
	local selected_slot = self._selected_slot

	if selected_slot then
		local selected_slot_name = selected_slot.name

		if selected_slot_name then
			return selected_slot_name
		end
	end

	local slots = item and item.slots
	local slot_name = slots and slots[1]

	return slot_name
end

InventoryWeaponsView._equip_item = function (self, slot_name, item)
	if self._equip_button_disabled then
		return
	end

	local ITEM_TYPES = UISettings.ITEM_TYPES
	local item_type = item.item_type
	local add_item = false

	if item_type == ITEM_TYPES.GADGET then
		local slots = item.slots

		if not self:is_item_equipped_in_any_slot(item, slots) then
			add_item = true
		end
	else
		local equipped_slot_item = self:equipped_item_in_slot(slot_name)

		if not equipped_slot_item or equipped_slot_item.gear_id ~= item.gear_id then
			add_item = true
		end
	end

	if add_item then
		if item_type == ITEM_TYPES.WEAPON_RANGED or item_type == ITEM_TYPES.WEAPON_MELEE then
			self:_play_sound(UISoundEvents.weapons_equip_weapon)
		elseif item_type == ITEM_TYPES.GADGET then
			self:_play_sound(UISoundEvents.weapons_equip_gadget)
		elseif item_type == ITEM_TYPES.EMOTE or item_type == ITEM_TYPES.END_OF_ROUND then
			self:_play_sound(UISoundEvents.apparel_equip_small)
		elseif item_type == ITEM_TYPES.PORTRAIT_FRAME or item_type == ITEM_TYPES.CHARACTER_INSIGNIA then
			self:_play_sound(UISoundEvents.apparel_equip_frame)
		else
			self:_play_sound(UISoundEvents.apparel_equip)
		end

		local item_gear_id = item and item.gear_id
		local active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()

		if active_profile_preset_id then
			ProfileUtils.save_item_id_for_profile_preset(active_profile_preset_id, slot_name, item_gear_id)
		end

		Managers.event:trigger("event_inventory_view_equip_item", slot_name, item)

		self._is_equipped_weapon_changed = true
	end
end

InventoryWeaponsView.has_equipped_item_in_any_slot = function (self, slots)
	for i = 1, #slots do
		local slot_name = slots[i]

		if self:equipped_item_in_slot(slot_name) then
			return true
		end
	end

	return false
end

InventoryWeaponsView.is_item_equipped_in_any_slot = function (self, item, slots)
	for i = 1, #slots do
		local slot_name = slots[i]
		local equipped_item = self:equipped_item_in_slot(slot_name)

		if equipped_item and equipped_item.gear_id == item.gear_id then
			return true
		end
	end

	return false
end

InventoryWeaponsView.equipped_item_in_slot = function (self, slot_name)
	local slot_item = self._preview_profile_equipped_items[slot_name]
	local item = slot_item and self:_get_item_from_inventory(slot_item)

	return item
end

InventoryWeaponsView.event_discard_items = function (self, gear_ids)
	local inventory_items = self._inventory_items

	for i = 1, #gear_ids do
		local gear_id = gear_ids[i]

		if inventory_items[gear_id] then
			inventory_items[gear_id] = nil
		end

		local layout, index = self:_get_offer_item_layout_by_gear_id(gear_id)

		if index then
			table.remove(self._offer_items_layout, index)
		end
	end

	self:cb_on_close_pressed()
end

InventoryWeaponsView._stop_previewing = function (self)
	InventoryWeaponsView.super._stop_previewing(self)

	if self._weapon_actions then
		self._weapon_actions:stop_presenting()
	end

	if self._weapon_options_element then
		self._weapon_options_element:set_visibility(false)
	end
end

InventoryWeaponsView._preview_item = function (self, item)
	InventoryWeaponsView.super._preview_item(self, item)

	local slots = item and item.slots

	if slots and (table.find(slots, "slot_primary") or table.find(slots, "slot_secondary")) then
		if self._weapon_actions then
			self._weapon_actions:present_item(item)
		end

		if self._weapon_options_element and not self._discard_items_element and not self._item_compare_toggled then
			self._weapon_options_element:set_visibility(true)
		end
	end
end

InventoryWeaponsView._update_equip_button_status = function (self)
	local previewed_item = self._previewed_item

	if not previewed_item then
		return
	end

	local disable_button = not previewed_item
	local discard_item = self._update_item_discard

	if discard_item then
		disable_button = true
	end

	if not disable_button then
		local grid_index = self:selected_grid_index()
		local grid_widgets = self:grid_widgets()
		local widget = grid_widgets[grid_index]

		if widget then
			local content = widget.content

			if content.discarded then
				disable_button = true
				discard_item = true
			end
		end
	end

	local level_requirement_met = true

	if not disable_button then
		local selected_slot = self._selected_slot
		local selected_slot_name = selected_slot.name

		if previewed_item.item_type == UISettings.ITEM_TYPES.GADGET then
			local slots = previewed_item.slots

			if self:is_item_equipped_in_any_slot(previewed_item, slots) then
				disable_button = true
			end
		else
			local equipped_item = self:equipped_item_in_slot(selected_slot_name)

			disable_button = equipped_item and equipped_item.gear_id == previewed_item.gear_id
		end

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

		if level_requirement_met and not discard_item then
			button_content.text = Utf8.upper(disable_button and Localize("loc_weapon_inventory_equipped_button") or Localize("loc_weapon_inventory_equip_button"))
		else
			button_content.text = Utf8.upper(Localize("loc_weapon_inventory_equip_button"))
		end
	end
end

InventoryWeaponsView._update_discard_button_status = function (self, dt)
	self._widgets_by_name.discard_button.content.hotspot.disabled = not self._selected_items or table.is_empty(self._selected_items)
end

InventoryWeaponsView._cb_on_present = function (self)
	InventoryWeaponsView.super._cb_on_present(self)

	if self._selected_items and not table.is_empty(self._selected_items) and self._discard_items_element and self._discard_items_element:visible() then
		local widgets = self._item_grid:widgets()

		for i = 1, #widgets do
			local widget = widgets[i]
			local gear_id = widget.content.element.item.gear_id

			if self._selected_items[gear_id] then
				widget.content.multi_selected = true
			end
		end
	end
end

InventoryWeaponsView.cb_on_toggle_item_compare = function (self)
	InventoryWeaponsView.super.cb_on_toggle_item_compare(self)

	if self._weapon_options_element then
		self._weapon_options_element:set_visibility(not self._item_compare_toggled)
	end
end

InventoryWeaponsView._update_weapon_stats_position = function (self, scenegraph_id, weapon_stats)
	InventoryWeaponsView.super._update_weapon_stats_position(self, scenegraph_id, weapon_stats)

	if self._weapon_options_element then
		local position = self:_scenegraph_world_position(scenegraph_id)

		self._weapon_options_element:set_pivot_offset(position[1] + 20, position[2])
	end
end

return InventoryWeaponsView
