local ViewElementPerksItemBlueprints = require("scripts/ui/view_elements/view_element_perks_item/view_element_perks_item_blueprints")
local ViewElementPerksItemDefinitions = require("scripts/ui/view_elements/view_element_perks_item/view_element_perks_item_definitions")
local RankSettings = require("scripts/settings/item/rank_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIAnimation = require("scripts/managers/ui/ui_animation")
local InputDevice = require("scripts/managers/input/input_device")

require("scripts/ui/view_elements/view_element_grid/view_element_grid")

local ViewElementPerksItem = class("ViewElementPerksItem", "ViewElementGrid")

ViewElementPerksItem.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	self._reference_name = "ViewElementPerksItem_" .. tostring(self)
	local definitions = ViewElementPerksItemDefinitions

	ViewElementPerksItem.super.init(self, parent, draw_layer, start_scale, definitions.menu_settings, definitions)
	self:present_grid_layout({}, ViewElementPerksItemBlueprints)
	self:_setup_tabs()

	self._ui_animations = {}
	self._alpha_multiplier = optional_menu_settings and optional_menu_settings.do_animations and 0 or 1
	self._do_animations = optional_menu_settings and optional_menu_settings.do_animations
	self._active = not self._do_animations
end

ViewElementPerksItem.destroy = function (self, ui_renderer)
	local backend_promise = self._backend_promise

	if backend_promise and backend_promise:is_pending() then
		backend_promise:cancel()

		self._backend_promise = nil
	end

	if self._weapon_stats then
		self._weapon_stats:destroy()

		self._weapon_stats = nil
	end

	ViewElementPerksItem.super.destroy(self, ui_renderer)
end

ViewElementPerksItem.show_overlay = function (self, show)
	local widget = self._widgets_by_name.overlay
	local style = widget.style
	local color = style.overlay.color
	local ui_scenegraph = self._ui_scenegraph
	local func = UIAnimation.function_by_time
	local target = color
	local target_index = 1
	local from = color[1]
	local to = show and 128 or 0
	local duration = 0.5
	local easing = math.easeOutCubic
	self._ui_animations.pivot = UIAnimation.init(func, target, target_index, from, to, duration, easing)
end

ViewElementPerksItem.clear_marks = function (self)
	local widgets = self:widgets()

	for i = 1, #widgets do
		local recipe_widget = widgets[i]
		local content = recipe_widget.content
		content.marked = false
	end

	self._marked_widget = nil
	self._marked_perk_item = nil
end

ViewElementPerksItem.cb_on_grid_entry_left_pressed = function (self, widget, config)
	if not self._active then
		return
	end

	local perk_item = config.perk_item

	if self._marked_perk_item == perk_item then
		perk_item = nil
		widget = nil
	end

	self._marked_widget = widget
	self._marked_perk_item = perk_item
	local external_left_click_callback = self._external_left_click_callback

	if external_left_click_callback then
		external_left_click_callback(widget, config)
	end

	local recipe_widgets = self:widgets()

	for i = 1, #recipe_widgets do
		local recipe_widget = recipe_widgets[i]
		local content = recipe_widget.content
		content.marked = widget and recipe_widget == widget or false
	end

	if widget or self._using_cursor_navigation then
		self:select_grid_widget(widget)
	end
end

ViewElementPerksItem.marked_perk_item = function (self)
	return self._marked_perk_item
end

ViewElementPerksItem._on_perk_hover = function (self, config)
	self._hovered_perk_item = config.perk_item
end

ViewElementPerksItem.start_animation = function (self)
	local ui_scenegraph = self._ui_scenegraph
	local func = UIAnimation.function_by_time
	local target = ui_scenegraph.pivot.local_position
	local target_index = 1
	local from = self._pivot_offset[1] - 500
	local to = self._pivot_offset[1]
	local duration = 0.5
	local easing = math.easeOutCubic
	self._ui_animations.pivot = UIAnimation.init(func, target, target_index, from, to, duration, easing)
	local func = UIAnimation.function_by_time
	local target = self
	local target_index = "_alpha_multiplier"
	local from = 0
	local to = 1
	local duration = 0.5
	local easing = math.easeInCubic
	self._ui_animations.alpha_multiplier = UIAnimation.init(func, target, target_index, from, to, duration, easing)
end

ViewElementPerksItem.disable = function (self)
	self._disabled = true

	self:select_grid_index(nil)
end

ViewElementPerksItem.enable = function (self)
	self._disabled = false

	if not self._using_cursor_navigation then
		self:select_best_widget()
	end
end

ViewElementPerksItem.hide = function (self)
	self._active = false
end

ViewElementPerksItem.show = function (self)
	self._active = true
end

ViewElementPerksItem.active = function (self)
	return self._active and not self._disabled
end

ViewElementPerksItem.select_best_widget = function (self, allow_only_marked_widget)
	local marked_perk_item = self._marked_perk_item
	local marked_perk_item_id = marked_perk_item and marked_perk_item.name
	local marked_perk_item_rarity = marked_perk_item and marked_perk_item.rarity
	local widget_to_select = nil
	local recipe_widgets = self:widgets()

	for i = 1, #recipe_widgets do
		local recipe_widget = recipe_widgets[i]
		local content = recipe_widget.content
		local config = content.config
		local perk_item = config and config.perk_item

		if perk_item then
			local perk_item_id = perk_item.name
			local perk_item_rarity = perk_item.rarity

			if not widget_to_select and not allow_only_marked_widget then
				widget_to_select = recipe_widget
			end

			local marked = perk_item_id == marked_perk_item_id and perk_item_rarity == marked_perk_item_rarity

			if marked then
				widget_to_select = recipe_widget
			end

			content.marked = marked
		end
	end

	self:select_grid_widget(widget_to_select)

	return widget_to_select
end

ViewElementPerksItem.set_alpha_multiplier = function (self, alpha_multiplier)
	self._alpha_multiplier = alpha_multiplier or 0
end

ViewElementPerksItem.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if self._disabled or self._backend_promise ~= nil then
		input_service = input_service:null_service()
	end

	local old_alpha_multiplier = render_settings.alpha_multiplier
	local alpha_multiplier = self._active and self._alpha_multiplier or 0
	render_settings.alpha_multiplier = render_settings.alpha_multiplier * alpha_multiplier

	ViewElementPerksItem.super.draw(self, dt, t, ui_renderer, render_settings, input_service)

	render_settings.alpha_multiplier = old_alpha_multiplier
	local previous_layer = render_settings.start_layer
	render_settings.start_layer = (previous_layer or 0) + self._draw_layer
end

ViewElementPerksItem._update_animations = function (self, dt, t)
	local ui_animations = self._ui_animations

	for key, ui_animation in pairs(ui_animations) do
		UIAnimation.update(ui_animation, dt)

		if UIAnimation.completed(ui_animation) then
			ui_animations[key] = nil
		end
	end

	if self._ui_animations.pivot then
		self._update_scenegraph = true
	end
end

ViewElementPerksItem.present_perks = function (self, item_masterid, ingredients, external_left_click_callback, do_animation)
	self._ingredients = ingredients
	self._external_left_click_callback = external_left_click_callback
	self._backend_promise = Managers.data_service.crafting:get_item_crafting_metadata(item_masterid)

	return self._backend_promise:next(function (data)
		self._perks_by_rank = data.perks

		self:_switch_to_rank_tab(RankSettings.max_perk_rank, true)

		if self._do_animations then
			self:start_animation()
		end

		self._active = true
		self._disabled = false
		self._backend_promise = nil
	end)
end

ViewElementPerksItem._setup_tabs = function (self)
	local tab_settings = {
		num_tabs = RankSettings.max_perk_rank
	}
	local widget_definitions = ViewElementPerksItemDefinitions.create_tab_widgets(tab_settings)
	local widgets_by_name = self._widgets_by_name
	local widgets = self._widgets

	for i = 1, #widget_definitions do
		local name = "rank_" .. i
		local definition = widget_definitions[i]
		local widget = UIWidget.init(name, definition)
		widgets_by_name[name] = widget
		widgets[#widgets + 1] = widget
	end
end

ViewElementPerksItem._switch_to_rank_tab = function (self, rank, initializing)
	self._rank = rank

	self:_update_tabs()
	self:_present(initializing)
end

ViewElementPerksItem.update = function (self, dt, t, input_service)
	if not self._active then
		return
	end

	if self._disabled or self._backend_promise ~= nil then
		input_service = input_service:null_service()
	end

	self:_handle_input(dt, t, input_service)
	self:_update_animations(dt, t)
	ViewElementPerksItem.super.update(self, dt, t, input_service)
end

ViewElementPerksItem._update_tabs = function (self)
	local current_rank = self._rank
	local widgets_by_name = self._widgets_by_name

	for i = 1, RankSettings.max_perk_rank do
		local widget_name = "rank_" .. i
		local widget = widgets_by_name[widget_name]
		local content = widget.content
		content.selected = current_rank == i
	end
end

ViewElementPerksItem._handle_input = function (self, dt, t, input_service)
	if InputDevice.gamepad_active then
		local old_rank = self._rank
		local new_rank = old_rank

		if input_service:get("navigate_primary_left_pressed") then
			new_rank = math.clamp(self._rank - 1, 1, RankSettings.max_perk_rank)
		elseif input_service:get("navigate_primary_right_pressed") then
			new_rank = math.clamp(self._rank + 1, 1, RankSettings.max_perk_rank)
		elseif input_service:get("next") and type(self._parent.remove_next_ingredient) == "function" then
			self._parent:remove_next_ingredient()
		end

		if new_rank ~= old_rank then
			self:_switch_to_rank_tab(new_rank)
		end
	else
		local widgets_by_name = self._widgets_by_name

		for i = 1, RankSettings.max_perk_rank do
			local widget_name = "rank_" .. i
			local widget = widgets_by_name[widget_name]

			if widget then
				local content = widget.content
				local hotspot = content.hotspot

				if hotspot.on_pressed then
					self:_switch_to_rank_tab(i)

					return
				end
			end
		end
	end
end

ViewElementPerksItem.ingredients = function (self)
	return self._ingredients
end

ViewElementPerksItem._present = function (self, first_presentation)
	if not self._perks_by_rank then
		return
	end

	local rank = self._rank
	local perks_data = self._perks_by_rank[self._rank].perks
	local layout = {
		[#layout + 1] = {
			widget_type = "spacing_vertical_small"
		}
	}

	for i = 1, #perks_data do
		local perk_name = perks_data[i]
		local MasterItems = require("scripts/backend/master_items")
		local perk_item = table.clone_instance(MasterItems.get_item(perk_name))
		perk_item.rarity = rank
		layout[#layout + 1] = {
			widget_type = "perk",
			perk_item = perk_item,
			perk_rarity = rank
		}
	end

	layout[#layout + 1] = {
		widget_type = "spacing_vertical"
	}
	local left_click_callback = callback(self, "cb_on_grid_entry_left_pressed")
	local on_present_callback = not first_presentation and callback(self, "_cb_present_grid_layout")

	self:present_grid_layout(layout, ViewElementPerksItemBlueprints, left_click_callback, nil, nil, nil, on_present_callback)
end

ViewElementPerksItem._cb_present_grid_layout = function (self)
	if self._marked_perk_item or not self._using_cursor_navigation then
		local allow_only_marked_widget = self._using_cursor_navigation

		self:select_best_widget(allow_only_marked_widget)
	end
end

ViewElementPerksItem._on_navigation_input_changed = function (self)
	ViewElementPerksItem.super._on_navigation_input_changed(self)

	if not self._using_cursor_navigation and not self._disabled then
		self:select_best_widget()
	end
end

return ViewElementPerksItem
