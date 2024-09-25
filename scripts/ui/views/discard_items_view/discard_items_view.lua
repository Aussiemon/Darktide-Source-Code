-- chunkname: @scripts/ui/views/discard_items_view/discard_items_view.lua

local Definitions = require("scripts/ui/views/discard_items_view/discard_items_view_definitions")
local DiscardItemsViewSettings = require("scripts/ui/views/discard_items_view/discard_items_view_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local RaritySettings = require("scripts/settings/item/rarity_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local StepperPassTemplates = require("scripts/ui/pass_templates/stepper_pass_templates")
local DiscardItemsView = class("DiscardItemsView", "BaseView")

DiscardItemsView.init = function (self, settings, context)
	self._context = context
	self._content_alpha_multiplier = 0
	self._using_cursor_navigation = Managers.ui:using_cursor_navigation()

	DiscardItemsView.super.init(self, Definitions, settings, context)

	self._allow_close_hotkey = true
end

DiscardItemsView._setup_default_gui = function (self)
	local ui_manager = Managers.ui
	local reference_name = self.__class_name
	local timer_name = "ui"
	local world_layer = 101
	local world_name = reference_name .. "_ui_default_world"
	local view_name = self.view_name

	self._gui_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)

	local viewport_name = reference_name .. "_ui_default_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1

	self._gui_viewport = ui_manager:create_viewport(self._gui_world, viewport_name, viewport_type, viewport_layer)
	self._gui_viewport_name = viewport_name
	self._ui_default_renderer = ui_manager:create_renderer(reference_name .. "_ui_default_renderer", self._gui_world)
end

DiscardItemsView.trigger_on_exit_animation = function (self)
	if not self._window_close_anim_id then
		self._window_close_anim_id = self:_start_animation("on_exit", self._widgets_by_name, self)
	end
end

DiscardItemsView.on_exit_animation_done = function (self)
	return self._window_close_anim_id and self:_is_animation_completed(self._window_close_anim_id)
end

DiscardItemsView.on_enter = function (self)
	DiscardItemsView.super.on_enter(self)
	self:_setup_default_gui()

	local context = self._context

	self._items = context and context.items or {}
	self._items_by_rarity = self:_sort_items_by_rarity(self._items)

	local highest_item_level = 0

	for _, item in pairs(self._items) do
		local item_level = item.itemLevel or 0

		if highest_item_level < item_level then
			highest_item_level = item_level
		end
	end

	self._highest_item_level = highest_item_level + 1
	self._highest_item_level_cap = math.ceil(self._highest_item_level / 10 + 0.5) * 10
	self._current_rating_value = self._highest_item_level_cap

	self:_setup_window_title()
	self:_setup_buttons_interactions()
	self:_initialize_rarity_options()
	self:_initialize_description_text()
	self:_increment_rating_value(10)

	self._window_open_anim_id = self:_start_animation("on_enter", self._widgets_by_name, self)

	if not self._using_cursor_navigation then
		self:_set_selected_gamepad_navigation_index(1)
	end

	self:_update_items_to_discard()
end

DiscardItemsView._sort_items_by_rarity = function (self, items)
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

DiscardItemsView.on_exit = function (self)
	DiscardItemsView.super.on_exit(self)

	if self._ui_default_renderer then
		self._ui_default_renderer = nil

		if not self._ui_default_renderer_is_external then
			Managers.ui:destroy_renderer(self.__class_name .. "_ui_default_renderer")
		end

		if self._gui_world then
			local world = self._gui_world
			local viewport_name = self._gui_viewport_name

			ScriptWorld.destroy_viewport(world, viewport_name)
			Managers.ui:destroy_world(world)

			self._gui_viewport_name = nil
			self._gui_viewport = nil
			self._gui_world = nil
		end
	end

	Managers.ui:play_2d_sound(UISoundEvents.weapons_discard_release)
end

DiscardItemsView.draw = function (self, dt, t, input_service, layer)
	local render_scale = self._render_scale
	local render_settings = self._render_settings
	local ui_renderer = self._ui_default_renderer

	render_settings.start_layer = layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale

	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_renderer)
	UIRenderer.end_pass(ui_renderer)
	self:_draw_elements(dt, t, ui_renderer, render_settings, input_service)
end

DiscardItemsView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	return DiscardItemsView.super._draw_widgets(self, dt, t, input_service, ui_renderer)
end

DiscardItemsView.update = function (self, dt, t, input_service, layer)
	if self._cached_player_icon_material_values then
		self:_cb_set_player_icon(self._cached_player_icon_material_values.grid_index, self._cached_player_icon_material_values.rows, self._cached_player_icon_material_values.columns, self._cached_player_icon_material_values.render_target)
	end

	if self._window_open_anim_id and self:_is_animation_completed(self._window_open_anim_id) then
		self:_stop_animation(self._window_open_anim_id)

		self._window_open_anim_id = nil
	end

	if not self._window_open_anim_id then
		local widgets_by_name = self._widgets_by_name
		local ui_default_renderer = self._ui_default_renderer

		StepperPassTemplates.terminal_stepper.update(widgets_by_name.rating_stepper, ui_default_renderer, dt)
		ButtonPassTemplates.terminal_button_hold_small.update(self, widgets_by_name.discard_button, ui_default_renderer, dt)
	end

	return DiscardItemsView.super.update(self, dt, t, input_service, layer)
end

DiscardItemsView._setup_window_title = function (self)
	local context = self._context
	local custom_title = context and context.custom_title
	local text = custom_title or Localize("loc_discard_items_view_title_item")
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.window_title.content.text = text
end

DiscardItemsView._setup_buttons_interactions = function (self)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.rarity_checkbox_button_1.content.hotspot.pressed_callback = callback(self, "_on_rarity_button_pressed", widgets_by_name.rarity_checkbox_button_1, 1)
	widgets_by_name.rarity_checkbox_button_2.content.hotspot.pressed_callback = callback(self, "_on_rarity_button_pressed", widgets_by_name.rarity_checkbox_button_2, 2)
	widgets_by_name.rarity_checkbox_button_3.content.hotspot.pressed_callback = callback(self, "_on_rarity_button_pressed", widgets_by_name.rarity_checkbox_button_3, 3)
	widgets_by_name.rarity_checkbox_button_4.content.hotspot.pressed_callback = callback(self, "_on_rarity_button_pressed", widgets_by_name.rarity_checkbox_button_4, 4)
	widgets_by_name.rarity_checkbox_button_5.content.hotspot.pressed_callback = callback(self, "_on_rarity_button_pressed", widgets_by_name.rarity_checkbox_button_5, 5)
	widgets_by_name.discard_button.content.size = DiscardItemsViewSettings.discard_button_size

	ButtonPassTemplates.terminal_button_hold_small.init(self, widgets_by_name.discard_button, self._ui_default_renderer, {
		ignore_gamepad_on_text = true,
		text = Localize("loc_alias_view_hotkey_item_discard"),
		complete_function = callback(self, "_on_discard_pressed"),
		on_complete_sound = UISoundEvents.weapons_discard_complete,
		hold_sound = UISoundEvents.weapons_discard_hold,
		hold_release = UISoundEvents.weapons_discard_release,
	})

	widgets_by_name.rating_stepper.content.left_pressed_callback = callback(self, "_on_rating_stepper_left_pressed")
	widgets_by_name.rating_stepper.content.right_pressed_callback = callback(self, "_on_rating_stepper_right_pressed")
	widgets_by_name.close_button.content.hotspot.pressed_callback = callback(self, "_on_close_pressed")
	self._button_gamepad_navigation_list = {
		widgets_by_name.rarity_checkbox_button_1,
		widgets_by_name.rarity_checkbox_button_2,
		widgets_by_name.rarity_checkbox_button_3,
		widgets_by_name.rarity_checkbox_button_4,
		widgets_by_name.rarity_checkbox_button_5,
		widgets_by_name.rating_stepper,
		widgets_by_name.discard_button,
		widgets_by_name.close_button,
	}
end

DiscardItemsView._initialize_description_text = function (self)
	local widgets_by_name = self._widgets_by_name
	local key_value_color = Color.terminal_text_key_value(255, true)
	local text = Localize("loc_discard_items_view_favorite_info", true, {
		favorite_icon = Localize("loc_color_value_fomat_key", true, {
			value = "",
			r = key_value_color[2],
			g = key_value_color[3],
			b = key_value_color[4],
		}),
	})

	widgets_by_name.description.content.text = text
end

DiscardItemsView._initialize_rarity_options = function (self)
	local items_by_rarity = self._items_by_rarity
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
		local amount_text_string = "{#color(" .. amount_color[2] .. "," .. amount_color[3] .. "," .. amount_color[4] .. ");size(20)} (" .. tostring(num_items) .. ")"

		widget.content.original_text = Localize(settings.display_name) .. amount_text_string
		widget.style.text.default_color = table.clone(settings.color)
		widget.style.text.hover_color = table.clone(settings.color)
	end

	if initialize_selected_rarities then
		self._selected_rarities = selected_rarities
	end
end

DiscardItemsView._on_rarity_button_pressed = function (self, widget, rarity_index)
	widget.content.checked = not widget.content.checked
	self._selected_rarities[rarity_index] = widget.content.checked

	self:_update_items_to_discard()
end

DiscardItemsView._update_items_to_discard = function (self)
	local items_by_rarity = self._items_by_rarity
	local selected_rarities = self._selected_rarities
	local items_to_discard = {}
	local allowed_item_level = math.min(self._highest_item_level, self._current_rating_value or 0)

	for rarity_index, checked in ipairs(selected_rarities) do
		local items = items_by_rarity[rarity_index]

		if items and checked then
			for i = 1, #items do
				local item = items[i]
				local item_level = item.itemLevel

				if item_level and item_level < allowed_item_level then
					items_to_discard[#items_to_discard + 1] = item
				end
			end
		end
	end

	self._items_to_discard = #items_to_discard > 0 and items_to_discard or nil

	local item_amount_text = self._items_to_discard and tostring(#self._items_to_discard) or "0"

	self._widgets_by_name.discard_button.content.original_text = Localize("loc_discard_items_view_discard_button", true, {
		item_amount = item_amount_text,
	})
	self._widgets_by_name.discard_button.content.hotspot.disabled = not self._items_to_discard
end

DiscardItemsView._on_discard_pressed = function (self)
	local items_to_discard = self._items_to_discard

	if items_to_discard then
		Managers.event:trigger("event_discard_items", items_to_discard)

		for i = 1, #items_to_discard do
			local item = items_to_discard[i]
			local gear_id = item.gear_id
			local items = self._items

			for j = 1, #items do
				if items[j].gear_id == gear_id then
					table.remove(items, j)

					break
				end
			end

			local items_by_rarity = self._items_by_rarity

			for j = 1, 5 do
				local rarity_items = items_by_rarity[j]

				if rarity_items then
					for k = 1, #rarity_items do
						if rarity_items[k].gear_id == gear_id then
							table.remove(rarity_items, k)

							break
						end
					end
				end
			end
		end

		self:_initialize_rarity_options()
		self:_update_items_to_discard()
	end
end

DiscardItemsView._on_rating_stepper_left_pressed = function (self)
	self:_increment_rating_value(-10)
end

DiscardItemsView._on_rating_stepper_right_pressed = function (self)
	self:_increment_rating_value(10)
end

DiscardItemsView._increment_rating_value = function (self, add)
	local value = math.clamp((self._current_rating_value or 0) + add, 0, self._highest_item_level_cap)

	self._current_rating_value = value

	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.rating_stepper

	widget.content.original_text = tostring(math.min(value, self._highest_item_level))

	self:_update_items_to_discard()
end

DiscardItemsView._on_close_pressed = function (self)
	Managers.ui:close_view(self.view_name)
end

DiscardItemsView._on_navigation_input_changed = function (self)
	DiscardItemsView.super._on_navigation_input_changed(self)

	if self._using_cursor_navigation then
		if self._selected_gamepad_navigation_index then
			self:_set_selected_gamepad_navigation_index(nil)
		end
	elseif not self._selected_gamepad_navigation_index then
		self:_set_selected_gamepad_navigation_index(1)
	end
end

DiscardItemsView._set_selected_gamepad_navigation_index = function (self, index)
	self._selected_gamepad_navigation_index = index

	local button_gamepad_navigation_list = self._button_gamepad_navigation_list

	for i = 1, #button_gamepad_navigation_list do
		local widget = button_gamepad_navigation_list[i]

		widget.content.hotspot.is_selected = i == index
	end
end

DiscardItemsView._handle_button_gamepad_navigation = function (self, input_service)
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

DiscardItemsView._handle_input = function (self, input_service, dt, t)
	if not self._window_open_anim_id and not self._window_close_anim_id then
		self:_handle_button_gamepad_navigation(input_service)
	end
end

return DiscardItemsView
