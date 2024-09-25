-- chunkname: @scripts/ui/view_elements/view_element_discard_items/view_element_discard_items.lua

local Definitions = require("scripts/ui/view_elements/view_element_discard_items/view_element_discard_items_definitions")
local ViewElementDiscardItemsSettings = require("scripts/ui/view_elements/view_element_discard_items/view_element_discard_items_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local RaritySettings = require("scripts/settings/item/rarity_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local StepperPassTemplates = require("scripts/ui/pass_templates/stepper_pass_templates")
local ItemUtils = require("scripts/utilities/items")
local ViewElementDiscardItems = class("ViewElementDiscardItems", "ViewElementBase")

ViewElementDiscardItems.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	ViewElementDiscardItems.super.init(self, parent, draw_layer, start_scale, Definitions)

	local items = optional_menu_settings and optional_menu_settings.items
	local display_name = optional_menu_settings and optional_menu_settings.display_name
	local selection_callback = optional_menu_settings.selection_callback
	local unselection_callback = optional_menu_settings.unselection_callback

	self:_initialize_all(items, display_name, selection_callback, unselection_callback)

	local highest_item_level = 0

	for _, item in pairs(self._items) do
		local item_expertise = ItemUtils.expertise_level(item, true)
		local expertise_value = tonumber(item_expertise)
		local item_level = expertise_value or 0

		if highest_item_level < item_level then
			highest_item_level = item_level
		end
	end

	self._highest_item_level = highest_item_level + 1 * ItemUtils.get_expertise_multiplier()
	self._highest_item_level_cap = self._highest_item_level
	self._current_rating_value = self._highest_item_level_cap
	self._pivot_offset = {
		0,
		0,
	}

	self:_setup_buttons_interactions()
	self:_initialize_description_text()

	if not self._using_cursor_navigation then
		self:_set_selected_gamepad_navigation_index(1)
	end

	self:_update_items_to_discard()

	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.rating_stepper

	widget.content.original_text = tostring(self._highest_item_level)
end

ViewElementDiscardItems._initialize_all = function (self, items, display_name, selection_callback, unselected_callback)
	self._items = items or self._items or {}
	self._display_name = display_name or self._display_name or Localize("loc_discard_items_view_title_item")
	self._selection_callback = selection_callback or self._selection_callback
	self._unselection_callback = unselected_callback or self._unselection_callback
	self._items_by_rarity = self:_sort_items_by_rarity(self._items)

	local highest_item_level = 0

	for _, item in pairs(self._items) do
		local item_expertise = ItemUtils.expertise_level(item, true)
		local expertise_value = tonumber(item_expertise)
		local item_level = expertise_value or 0

		if highest_item_level < item_level then
			highest_item_level = item_level
		end
	end

	self._highest_item_level = highest_item_level + 1 * ItemUtils.get_expertise_multiplier()
	self._highest_item_level_cap = self._highest_item_level
	self._current_rating_value = self._highest_item_level_cap
	self._pivot_offset = {
		0,
		0,
	}

	self:_setup_buttons_interactions()
	self:_initialize_description_text()

	if not self._using_cursor_navigation then
		self:_set_selected_gamepad_navigation_index(1)
	end

	self:_update_items_to_discard()

	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.rating_stepper

	widget.content.original_text = tostring(self._highest_item_level)
end

ViewElementDiscardItems._sort_items_by_rarity = function (self, items)
	local items_by_rarity = {}

	for _, item in pairs(items) do
		local rarity = item.rarity

		if rarity then
			if not items_by_rarity[rarity] then
				items_by_rarity[rarity] = {}
			end

			items_by_rarity[rarity][#items_by_rarity[rarity] + 1] = item
		end
	end

	return items_by_rarity
end

ViewElementDiscardItems._update_selected_items_by_rarity = function (self)
	local items_by_rarity = self._items_by_rarity
	local current_rating_value = self._current_rating_value
	local selected_items_by_rarity = {}

	for rarity, items in pairs(items_by_rarity) do
		selected_items_by_rarity[rarity] = {}

		for index, item in ipairs(items) do
			local gear_id = item.gear_id

			if self:_can_discard_item(item) and not ItemUtils.is_item_id_favorited(gear_id) then
				selected_items_by_rarity[rarity][#selected_items_by_rarity[rarity] + 1] = item
			end
		end
	end

	return selected_items_by_rarity
end

ViewElementDiscardItems.update = function (self, dt, t, input_service)
	if self._input_disabled then
		input_service = input_service:null_service()
	end

	if input_service and not input_service:is_null_service() then
		self:_handle_input(input_service, dt, t)
	end

	return ViewElementDiscardItems.super.update(self, dt, t, input_service)
end

ViewElementDiscardItems.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if self._input_disabled then
		input_service = input_service:null_service()
	end

	StepperPassTemplates.terminal_stepper.update(self._widgets_by_name.rating_stepper, ui_renderer, dt, t, input_service)
	ViewElementDiscardItems.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

ViewElementDiscardItems._setup_buttons_interactions = function (self)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.rarity_checkbox_button_1.content.hotspot.pressed_callback = callback(self, "_on_rarity_button_pressed", widgets_by_name.rarity_checkbox_button_1, 1)
	widgets_by_name.rarity_checkbox_button_2.content.hotspot.pressed_callback = callback(self, "_on_rarity_button_pressed", widgets_by_name.rarity_checkbox_button_2, 2)
	widgets_by_name.rarity_checkbox_button_3.content.hotspot.pressed_callback = callback(self, "_on_rarity_button_pressed", widgets_by_name.rarity_checkbox_button_3, 3)
	widgets_by_name.rarity_checkbox_button_4.content.hotspot.pressed_callback = callback(self, "_on_rarity_button_pressed", widgets_by_name.rarity_checkbox_button_4, 4)
	widgets_by_name.rarity_checkbox_button_5.content.hotspot.pressed_callback = callback(self, "_on_rarity_button_pressed", widgets_by_name.rarity_checkbox_button_5, 5)
	widgets_by_name.rating_stepper.content.left_pressed_callback = callback(self, "_on_rating_stepper_left_pressed")
	widgets_by_name.rating_stepper.content.right_pressed_callback = callback(self, "_on_rating_stepper_right_pressed")
	widgets_by_name.select_button.content.hotspot.pressed_callback = callback(self, "_on_select_pressed")
	widgets_by_name.unselect_button.content.hotspot.pressed_callback = callback(self, "_on_unselect_pressed")
	self._button_gamepad_navigation_list = {
		widgets_by_name.rarity_checkbox_button_1,
		widgets_by_name.rarity_checkbox_button_2,
		widgets_by_name.rarity_checkbox_button_3,
		widgets_by_name.rarity_checkbox_button_4,
		widgets_by_name.rarity_checkbox_button_5,
		widgets_by_name.rating_stepper,
		widgets_by_name.select_button,
		widgets_by_name.unselect_button,
	}
end

ViewElementDiscardItems._initialize_description_text = function (self)
	local widgets_by_name = self._widgets_by_name
	local key_value_color = Color.terminal_text_header(255, true)
	local text = Localize("loc_discard_items_view_favorite_info", true, {
		favorite_icon = Localize("loc_color_value_fomat_key", true, {
			value = "",
			r = key_value_color[2],
			g = key_value_color[3],
			b = key_value_color[4],
		}),
	})

	widgets_by_name.description.content.text = text
end

ViewElementDiscardItems._initialize_rarity_options = function (self)
	local items_by_rarity = self._items_by_rarity
	local selected_items_by_rarity = self._selected_items_by_rarity
	local widgets_by_name = self._widgets_by_name
	local amount_color = Color.terminal_text_body_sub_header(255, true)
	local initialize_selected_rarities = self._selected_rarities == nil
	local selected_rarities = initialize_selected_rarities and {}

	for i = 1, 5 do
		local rarity_index = i
		local widget = widgets_by_name["rarity_checkbox_button_" .. rarity_index]
		local settings = RaritySettings[rarity_index]

		if initialize_selected_rarities then
			selected_rarities[rarity_index] = false
		end

		local items = items_by_rarity[rarity_index]
		local num_items = items and #items or 0
		local selected_items = selected_items_by_rarity[rarity_index]
		local num_selected_items = selected_items and #selected_items or 0
		local amount_text_string = string.format("{#color(%d,%d,%d)}(%d) [%d]", amount_color[2], amount_color[3], amount_color[4], num_selected_items, num_items)

		widget.content.original_text = Localize(settings.display_name) .. amount_text_string
		widget.style.text.default_color = table.clone(settings.color)
		widget.style.text.hover_color = table.clone(settings.color)

		if num_items == 0 then
			widget.content.hotspot.disabled = true
		end
	end

	if initialize_selected_rarities then
		self._selected_rarities = selected_rarities
	end
end

ViewElementDiscardItems._on_rarity_button_pressed = function (self, widget, rarity_index)
	widget.content.checked = not widget.content.checked
	self._selected_rarities[rarity_index] = widget.content.checked

	self:_update_items_to_discard()
end

ViewElementDiscardItems.refresh = function (self, items)
	if items then
		self._selected_rarities = {}
		self._items_to_discard = {}
		self._widgets_by_name.rarity_checkbox_button_1.content.checked = false
		self._widgets_by_name.rarity_checkbox_button_2.content.checked = false
		self._widgets_by_name.rarity_checkbox_button_3.content.checked = false
		self._widgets_by_name.rarity_checkbox_button_4.content.checked = false
		self._widgets_by_name.rarity_checkbox_button_5.content.checked = false
	end

	self:_initialize_all(items)
end

ViewElementDiscardItems._update_items_to_discard = function (self)
	local items_by_rarity = self._items_by_rarity
	local selected_rarities = self._selected_rarities
	local items_to_discard = {}

	self._selected_items_by_rarity = self:_update_selected_items_by_rarity()

	if selected_rarities then
		for rarity_index, checked in pairs(selected_rarities) do
			local items = self._selected_items_by_rarity[rarity_index]

			if items and checked then
				for i = 1, #items do
					local item = items[i]

					items_to_discard[#items_to_discard + 1] = item
				end
			end
		end
	end

	self._items_to_discard = #items_to_discard > 0 and items_to_discard or nil

	local item_amount = self._items_to_discard and #self._items_to_discard or 0

	self._widgets_by_name.selection_value.content.value = Localize("loc_premium_store_num_items", true, {
		count = item_amount,
	})

	self:_initialize_rarity_options()
end

ViewElementDiscardItems._can_discard_item = function (self, item)
	local allowed_item_level = math.min(self._highest_item_level, self._current_rating_value or 0)
	local item_expertise = ItemUtils.expertise_level(item, true)
	local expertise_value = tonumber(item_expertise)

	return expertise_value and expertise_value < allowed_item_level
end

ViewElementDiscardItems.add_items = function (self)
	return
end

ViewElementDiscardItems._on_select_pressed = function (self)
	local items_to_discard = self._items_to_discard

	if items_to_discard and self._selection_callback then
		self._selection_callback(items_to_discard)
	end
end

ViewElementDiscardItems._on_unselect_pressed = function (self)
	local items_to_discard = self._items_to_discard

	if items_to_discard and self._unselection_callback then
		self._unselection_callback(items_to_discard)
	end
end

ViewElementDiscardItems._on_rating_stepper_left_pressed = function (self)
	self:_increment_rating_value(-1 * ItemUtils.get_expertise_multiplier())
end

ViewElementDiscardItems._on_rating_stepper_right_pressed = function (self)
	self:_increment_rating_value(1 * ItemUtils.get_expertise_multiplier())
end

ViewElementDiscardItems._increment_rating_value = function (self, add)
	local value = math.clamp((self._current_rating_value or 0) + add, 0, self._highest_item_level_cap)

	self._current_rating_value = value

	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.rating_stepper

	widget.content.original_text = tostring(math.min(value, self._highest_item_level_cap))

	self:_update_items_to_discard()
end

ViewElementDiscardItems._on_navigation_input_changed = function (self)
	ViewElementDiscardItems.super._on_navigation_input_changed(self)

	if self._using_cursor_navigation then
		self:_set_selected_gamepad_navigation_index(nil)
	elseif not self._input_disabled then
		self:_set_selected_gamepad_navigation_index(self._selected_gamepad_navigation_index or 1)
	end
end

ViewElementDiscardItems._set_selected_gamepad_navigation_index = function (self, index)
	local button_gamepad_navigation_list = self._button_gamepad_navigation_list
	local new_available_index

	self._selected_gamepad_navigation_index = self._selected_gamepad_navigation_index or -1

	if not index then
		new_available_index = index
	elseif self._selected_gamepad_navigation_index == index then
		return
	elseif index > self._selected_gamepad_navigation_index then
		for i = index, #self._button_gamepad_navigation_list do
			local widget = button_gamepad_navigation_list[i]

			if not widget.content.hotspot.disabled then
				new_available_index = i

				break
			end
		end
	else
		for i = index, 1, -1 do
			local widget = button_gamepad_navigation_list[i]

			if not widget.content.hotspot.disabled then
				new_available_index = i

				break
			end
		end
	end

	if not new_available_index and index then
		return
	end

	self._selected_gamepad_navigation_index = new_available_index

	for i = 1, #button_gamepad_navigation_list do
		local widget = button_gamepad_navigation_list[i]

		widget.content.hotspot.is_selected = false

		if not widget.content.hotspot.disabled then
			widget.content.hotspot.is_selected = i == new_available_index
		end
	end
end

ViewElementDiscardItems._handle_button_gamepad_navigation = function (self, input_service)
	local selected_gamepad_navigation_index = self._selected_gamepad_navigation_index

	if not selected_gamepad_navigation_index then
		return
	end

	local button_gamepad_navigation_list = self._button_gamepad_navigation_list
	local new_index

	if input_service:get("navigate_up_continuous") then
		new_index = math.max(selected_gamepad_navigation_index - 1, 1)
	elseif input_service:get("navigate_down_continuous") then
		new_index = math.min(selected_gamepad_navigation_index + 1, #button_gamepad_navigation_list)
	end

	if new_index and new_index ~= selected_gamepad_navigation_index then
		self:_set_selected_gamepad_navigation_index(new_index)
		self:_play_sound(UISoundEvents.default_mouse_hover)
	end
end

ViewElementDiscardItems._handle_input = function (self, input_service, dt, t)
	self:_handle_button_gamepad_navigation(input_service)
end

ViewElementDiscardItems.set_pivot_offset = function (self, x, y)
	self._pivot_offset[1] = x or self._pivot_offset[1]
	self._pivot_offset[2] = y or self._pivot_offset[2]

	self:_set_scenegraph_position("pivot", x, y)
end

ViewElementDiscardItems.select_first_index = function (self)
	self:_set_selected_gamepad_navigation_index(1)
end

ViewElementDiscardItems.disable_input = function (self, disabled)
	self._input_disabled = disabled

	local index = not disabled and self._selected_gamepad_navigation_index or nil
	local button_gamepad_navigation_list = self._button_gamepad_navigation_list

	for i = 1, #button_gamepad_navigation_list do
		local widget = button_gamepad_navigation_list[i]

		widget.content.hotspot.is_selected = false

		if not widget.content.hotspot.disabled then
			widget.content.hotspot.is_selected = i == index
		end
	end
end

ViewElementDiscardItems.input_disabled = function (self)
	return self._input_disabled
end

return ViewElementDiscardItems
