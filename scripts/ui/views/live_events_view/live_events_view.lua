-- chunkname: @scripts/ui/views/live_events_view/live_events_view.lua

require("scripts/ui/views/base_view")

local LiveEvents = require("scripts/settings/live_event/live_events")
local MasterItems = require("scripts/backend/master_items")
local WalletSettings = require("scripts/settings/wallet_settings")
local RaritySettings = require("scripts/settings/item/rarity_settings")
local InputDevice = require("scripts/managers/input/input_device")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local TextUtilities = require("scripts/utilities/ui/text")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UISettings = require("scripts/settings/ui/ui_settings")
local Definitions = require("scripts/ui/views/live_events_view/live_events_view_definitions")
local Styles = require("scripts/ui/views/live_events_view/live_events_view_styles")
local Settings = require("scripts/ui/views/live_events_view/live_events_view_settings")
local Templates = require("scripts/ui/views/live_events_view/live_events_view_templates")
local LiveEventsView = class("LiveEventsView", "BaseView")
local HISTORY_LIMIT = Settings.live_events_history_limit or 3
local HISTORY_ENTRIES = Settings.live_events_history_entries or nil

local function _apply_package_item_icon_cb_func(widget, item)
	local icon_style = widget.style.icon
	local material_values = icon_style.material_values
	local widget_content = widget.content
	local item_type = item.item_type or "default"
	local item_display_materials = Settings.ui_item_display_materials

	widget_content.icon = item_display_materials[item_type] or item_display_materials.default

	local item_display_sizes = Settings.ui_item_display_sizes
	local inverse_scale = RESOLUTION_LOOKUP.inverse_scale
	local icon_size = item_display_sizes[item_type] or item_display_sizes.default

	icon_style.size = icon_size
	material_values.icon_size = icon_size

	local item_display_offsets = Settings.ui_item_display_offsets

	icon_style.offset = item_display_offsets[item_type] or item_display_offsets.default

	if item.icon_material and item.icon_material ~= "" then
		widget.content.icon = item.icon_material
	else
		material_values.texture_map = item.icon
		material_values.texture_icon = item.icon
	end

	material_values.use_placeholder_texture = 0
	material_values.use_render_target = 0
	widget.dirty = true
end

local function _remove_package_item_icon_cb_func(widget, ui_renderer)
	UIWidget.set_visible(widget, ui_renderer, false)

	local icon_style = widget.style.icon

	icon_style.visible = false

	local material_values = icon_style.material_values

	material_values.texture_icon = nil
	material_values.texture_map = nil
	material_values.use_placeholder_texture = 1
end

local function _apply_live_item_icon_cb_func(widget, grid_index, rows, columns, render_target)
	local widget_style = widget.style
	local widget_content = widget.content

	widget_content.icon = "content/ui/materials/icons/items/containers/item_container_landscape"

	local icon_style = widget_style.icon

	icon_style.size = Settings.ui_item_display_sizes.default

	local material_values = icon_style.material_values

	material_values.use_placeholder_texture = 0
	material_values.use_render_target = 1
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.render_target = render_target
end

local function _remove_live_item_icon_cb_func(widget, ui_renderer)
	UIWidget.set_visible(widget, ui_renderer, false)

	local icon_style = widget.style.icon
	local material_values = icon_style.material_values

	material_values.use_placeholder_texture = 1
	material_values.render_target = nil
end

LiveEventsView.init = function (self, settings, context)
	local parent = context and context.parent

	self._parent = parent
	self._world_spawner = parent and parent._world_spawner
	self._selected_reward_index = 1
	self._selected_button_list_index = 1
	self._show_reward_tooltip = false

	LiveEventsView.super.init(self, Definitions, settings, context)
end

LiveEventsView.on_enter = function (self)
	if self._parent then
		self._parent:set_active_view_instance(self)

		local input_legend_entries = Settings.input_legend_entries

		if #input_legend_entries > 0 then
			for i = 1, #input_legend_entries do
				local input_legend = input_legend_entries[i]

				self._parent:add_input_legend_entry(input_legend)
			end
		end
	end

	self._local_player = Managers.player:local_player(1)
	self._pass_input = true
	self._pass_draw = true
	self._backend_interfaces = Managers.backend.interfaces
	self._backend_synced = false

	local events = Managers.live_event:events()
	local active_event_id = Managers.live_event:active_event_id()

	self._events = events
	self._active_event_id = active_event_id

	local progress_text_widget = self._widgets_by_name.progress_text

	progress_text_widget.visible = false

	self:_setup_events_button_list(events)
	self:_on_entry_selected(active_event_id, self._selected_button_list_index or 1)
	LiveEventsView.super.on_enter(self)
end

LiveEventsView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if self._button_list_widgets then
		for _, widget in pairs(self._button_list_widgets) do
			UIWidget.draw(widget, ui_renderer)
		end
	end

	if self._entry_widgets and not table.is_empty(self._entry_widgets) then
		local selected_event_id = self._selected_event_id
		local selected_event = self._events[selected_event_id] or LiveEvents[selected_event_id]
		local template_name = selected_event and selected_event.template_name or selected_event_id
		local template = Templates[template_name] or Templates.default

		if template.draw then
			template.draw(self, dt, t, ui_renderer, render_settings, input_service, self._entry_widgets)
		end
	end

	LiveEventsView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

LiveEventsView.update = function (self, dt, t, input_service)
	self:_update_reward_tooltip(dt, t, input_service)
	self:_handle_gamepad_input(dt, t, input_service)
	self:_update_button_list_widget_states()

	return LiveEventsView.super.update(self, dt, t, input_service)
end

LiveEventsView.on_exit = function (self)
	if self._entry_widgets then
		local selected_event = self._events[self._selected_event_id] or LiveEvents[self._selected_event_id]
		local template_name = selected_event.template_name or self._selected_event_id
		local template = Templates[template_name] or Templates.default

		if template and template.destroy then
			local ui_renderer = self._ui_renderer

			template.destroy(self, self._entry_widgets, ui_renderer)
		end
	end

	if self._offscreen_renderer then
		self:_destroy_renderer()
	end

	self._backend_interfaces = nil

	LiveEventsView.super.on_exit(self)
end

local system_name = "dialogue_system"

LiveEventsView.dialogue_system = function (self)
	local state_managers = Managers.state

	if state_managers then
		local extension_manager = state_managers.extension

		return extension_manager and extension_manager:has_system(system_name) and extension_manager:system(system_name)
	end
end

LiveEventsView._setup_events_button_list = function (self, events)
	local button_list_widgets = {}
	local button_index = 1

	for _, event in pairs(events) do
		local template_name = event.template_name
		local event_data = LiveEvents[template_name]

		if event_data then
			local button_widget = self:_create_entry_button_widget(event_data, template_name, button_index, event.id, event)

			button_widget.offset[2] = (button_index - 1) * Styles.spacing.button_spacing
			button_list_widgets[#button_list_widgets + 1] = button_widget
			button_index = button_index + 1
		end
	end

	local latest_button = button_list_widgets[#button_list_widgets]
	local latest_template_name = latest_button.content.template_name
	local start_index = 1

	if HISTORY_ENTRIES then
		for index, event_name in pairs(HISTORY_ENTRIES) do
			if event_name == latest_template_name then
				start_index = index

				break
			end
		end
	end

	if start_index then
		local start, end_index = start_index + 1, math.min(start_index + HISTORY_LIMIT - 1, #HISTORY_ENTRIES)

		for i = start, end_index do
			local template_name = HISTORY_ENTRIES[i]
			local event_data = LiveEvents[template_name]

			if event_data then
				local button_widget = self:_create_entry_button_widget(event_data, template_name, button_index)

				button_widget.offset[2] = (button_index - 1) * Styles.spacing.button_spacing
				button_list_widgets[#button_list_widgets + 1] = button_widget
				button_index = button_index + 1
			end
		end
	end

	self._button_list_widgets = button_list_widgets
end

LiveEventsView._create_entry_button_widget = function (self, event_data, template_name, button_index, event_id, optional_backend_data)
	local button_name = "event_button_" .. template_name

	if self._widgets_by_name[button_name] then
		button_name = "event_button_" .. template_name .. "duplicate_" .. Application.make_hash(template_name, event_id, math.random())
	end

	local button_content_override = {
		gamepad_action = "confirm_pressed",
		original_text = Localize(event_data.name),
		text = Localize(event_data.name),
		template_name = template_name,
		hotspot = {
			pressed_callback = callback(self, "_on_entry_selected", event_id or template_name, button_index),
		},
	}
	local button_definition = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "button_list_anchor", button_content_override, Styles.sizes.event_button_size)
	local button_widget = self:_create_widget(button_name, button_definition)

	return button_widget
end

LiveEventsView._on_entry_selected = function (self, event_id, button_index)
	if event_id == self._selected_event_id then
		return
	end

	if self._entry_widgets then
		local old_selected_event = self._events[self._selected_event_id] or LiveEvents[self._selected_event_id]
		local old_template_name = old_selected_event.template_name or self._selected_event_id
		local old_template = Templates[old_template_name] or Templates.default

		if old_template and old_template.destroy then
			local ui_renderer = self._ui_renderer

			old_template.destroy(self, self._entry_widgets, ui_renderer)
		end
	end

	self._selected_event_id = event_id
	self._selected_button_list_index = button_index or self._selected_button_list_index

	self:initilize_entry(event_id)
end

LiveEventsView.initilize_entry = function (self, event_id)
	local event = self._events[event_id]
	local event_data = event and LiveEvents[event.template_name] or LiveEvents[event_id]

	if not event_data then
		return
	end

	local template_name = event and event.template_name or event_data.id
	local template = Templates[template_name] or Templates.default
	local composition = template.composition
	local entry_widgets

	if composition and template.initialize then
		entry_widgets = template.initialize(self, composition, event, event_data)
	end

	self._entry_widgets = entry_widgets
end

LiveEventsView._set_current_event_progress = function (self, current_progress)
	self._selected_event_progress = current_progress
end

LiveEventsView._set_current_event_progress_text = function (self, current_progress, target_progress)
	local progress_text_widget = self._widgets_by_name.progress_text

	if not current_progress or not target_progress then
		progress_text_widget.visible = false

		return
	end

	progress_text_widget.content.progress_text = tostring(current_progress) .. " / " .. tostring(target_progress)
	progress_text_widget.visible = true
end

LiveEventsView._request_item_icon = function (self, widget, item, ui_renderer)
	self:_unload_item_icon(widget, ui_renderer)

	if item then
		self:_load_item_icon(widget, item)
	end
end

LiveEventsView._load_item_icon = function (self, widget, item)
	local on_load_callback_func, on_unload_callback_func
	local slots = item.slots

	if table.find(slots, "slot_insignia") or table.find(slots, "slot_portrait_frame") or table.find(slots, "slot_character_title") or table.find(slots, "slot_animation_emote_1") or table.find(slots, "slot_animation_emote_2") or table.find(slots, "slot_animation_emote_3") or table.find(slots, "slot_animation_emote_4") or table.find(slots, "slot_animation_emote_5") then
		on_load_callback_func = _apply_package_item_icon_cb_func
		on_unload_callback_func = _remove_package_item_icon_cb_func
	else
		on_load_callback_func = _apply_live_item_icon_cb_func
		on_unload_callback_func = _remove_live_item_icon_cb_func
	end

	local on_load = callback(on_load_callback_func, widget)
	local on_unload = callback(on_unload_callback_func, widget)
	local icon_load_id = Managers.ui:load_item_icon(item, on_load, nil, nil, true, on_unload)

	widget.content.icon_load_id = icon_load_id
end

LiveEventsView._unload_item_icon = function (self, widget, ui_renderer)
	local icon_load_id = widget.content.icon_load_id

	if icon_load_id then
		Managers.ui:unload_item_icon(icon_load_id, ui_renderer)

		widget.content.icon_load_id = nil
	end
end

LiveEventsView._update_button_list_widget_states = function (self)
	if not self._button_list_widgets or not self._selected_button_list_index then
		return
	end

	for index, widget in pairs(self._button_list_widgets) do
		local content = widget.content
		local hotspot = content.hotspot

		if hotspot then
			local is_selected = index == self._selected_button_list_index

			hotspot.is_selected = is_selected
		end
	end
end

LiveEventsView._update_reward_tooltip = function (self, dt, t, input_service, ui_renderer)
	local visible = false
	local reward_tooltip_widget = self._widgets_by_name.reward_info_tooltip
	local reward_tooltip_content = reward_tooltip_widget.content
	local reward_tooltip_style = reward_tooltip_widget.style
	local entry_reward_widgets = self._entry_widgets and self._entry_widgets.rewards
	local reward_widgets = entry_reward_widgets and entry_reward_widgets.rewards

	if reward_widgets then
		for i = 1, #reward_widgets do
			local reward_widget = reward_widgets[i]
			local hotspot = reward_widget.content.hotspot

			if hotspot and (hotspot.is_hover or InputDevice.gamepad_active and hotspot.is_selected and self._show_reward_tooltip) then
				local reward = reward_widget.content.reward

				if reward then
					if reward.type == "item" then
						local item = reward_widget.content.item
						local item_type = item.item_type or "default"
						local item_type_localization_lookup = UISettings.item_type_localization_lookup

						reward_tooltip_content.reward_tooltip_type = Localize(item_type_localization_lookup[item_type] or "loc_item_type_default")
						reward_tooltip_content.reward_tooltip_info = Localize(item.display_name)

						local rarity_settings = RaritySettings[item.rarity] or RaritySettings[0]

						reward_tooltip_content.reward_tooltip_rarity = string.format("{#color(%d, %d, %d)}%s{#reset()}", rarity_settings.color[2], rarity_settings.color[3], rarity_settings.color[4], Localize(rarity_settings.display_name))
						reward_tooltip_style.reward_tooltip_info.visible = true
						reward_tooltip_style.reward_tooltip_rarity.visible = true
						reward_tooltip_content.reward_tooltip_target_xp = tostring(self._selected_event_progress) .. " / " .. tostring(reward_widget.content.tier_xp)
						reward_tooltip_style.reward_tooltip_target_xp.visible = true
					else
						local currency_settings = WalletSettings[reward.currency]

						reward_tooltip_content.reward_tooltip_type = tostring(reward.amount) .. " " .. Localize(currency_settings.display_name)
						reward_tooltip_content.reward_tooltip_rarity = ""
						reward_tooltip_style.reward_tooltip_rarity.visible = false
						reward_tooltip_style.reward_tooltip_info.visible = false
						reward_tooltip_content.reward_tooltip_target_xp = tostring(self._selected_event_progress) .. " / " .. tostring(reward_widget.content.tier_xp)
						reward_tooltip_style.reward_tooltip_target_xp.visible = true
					end
				elseif not reward and reward_widget.content.item then
					local item = reward_widget.content.item
					local item_type = item.item_type or "default"
					local item_type_localization_lookup = UISettings.item_type_localization_lookup

					reward_tooltip_content.reward_tooltip_type = Localize(item_type_localization_lookup[item_type] or "loc_item_type_default")
					reward_tooltip_content.reward_tooltip_info = Localize(item.display_name)

					local rarity_settings = RaritySettings[item.rarity] or RaritySettings[0]

					reward_tooltip_content.reward_tooltip_rarity = string.format("{#color(%d, %d, %d)}%s{#reset()}", rarity_settings.color[2], rarity_settings.color[3], rarity_settings.color[4], Localize(rarity_settings.display_name))
					reward_tooltip_style.reward_tooltip_info.visible = true
					reward_tooltip_style.reward_tooltip_rarity.visible = true
					reward_tooltip_style.reward_tooltip_target_xp.visible = false
					reward_tooltip_content.reward_tooltip_target_xp = ""
				end

				visible = true

				break
			end
		end
	end

	if visible then
		local inverse_scale = RESOLUTION_LOOKUP.inverse_scale
		local scale = RESOLUTION_LOOKUP.scale

		if InputDevice.gamepad_active then
			local selected_reward_widget = reward_widgets[self._selected_reward_index]

			if selected_reward_widget then
				local widget_position = selected_reward_widget.offset
				local widget_size = Styles.sizes.reward_size
				local reward_tooltip_size = Styles.sizes.tooltip_size
				local rewards_box_node = self._ui_scenegraph.rewards_box
				local rewards_box_world_position = rewards_box_node.world_position
				local tooltip_size = Styles.sizes.tooltip_size
				local w, h = RESOLUTION_LOOKUP.width * inverse_scale, RESOLUTION_LOOKUP.height * inverse_scale
				local x = rewards_box_world_position[1] + widget_position[1] + widget_size[1] + tooltip_size[1] * 0.5 + 20

				if w < x + tooltip_size[1] * 0.5 then
					x = rewards_box_world_position[1] + widget_position[1] - tooltip_size[1] * 0.5 - 20
				end

				local x = math.clamp(x, 0, w - tooltip_size[1] * 0.5)
				local y = rewards_box_world_position[2] + widget_position[2] + widget_size[2] * 0.5

				self:_set_scenegraph_position("reward_tooltip", x, y)
			end
		else
			local cursor_name = "cursor"
			local cursor_position = input_service:get(cursor_name)
			local x, y = Vector3.to_elements(cursor_position)
			local tooltip_size = Styles.sizes.tooltip_size
			local x, y = x * inverse_scale, y * inverse_scale
			local w, h = RESOLUTION_LOOKUP.width * inverse_scale, RESOLUTION_LOOKUP.height * inverse_scale

			if w < x + tooltip_size[1] then
				x = x - tooltip_size[1] * 0.5 - 10
			else
				x = x + tooltip_size[1] * 0.5 + 10
			end

			y = math.clamp(y, tooltip_size[2], h - tooltip_size[2])

			local node_x = x
			local node_y = y - tooltip_size[2] * 0.5 - 25

			self:_set_scenegraph_position("reward_tooltip", node_x, node_y)
		end
	end

	reward_tooltip_widget.visible = visible
end

LiveEventsView._handle_gamepad_input = function (self, dt, t, input_service)
	if not InputDevice.gamepad_active then
		return
	end

	if self._button_list_widgets and #self._button_list_widgets > 0 then
		if input_service:get("navigate_up_continuous") then
			local new_selected_index = self._selected_button_list_index - 1

			if new_selected_index < 1 then
				new_selected_index = #self._button_list_widgets
			end

			self._selected_button_list_index = new_selected_index
		elseif input_service:get("navigate_down_continuous") then
			local new_selected_index = self._selected_button_list_index + 1

			if new_selected_index > #self._button_list_widgets then
				new_selected_index = 1
			end

			self._selected_button_list_index = new_selected_index
		elseif input_service:get("confirm_pressed") then
			local selected_widget = self._button_list_widgets[self._selected_button_list_index]

			if selected_widget and selected_widget.content and selected_widget.content.hotspot and selected_widget.content.hotspot.pressed_callback then
				selected_widget.content.hotspot.pressed_callback()
			end
		end
	end

	local entry_reward_widgets = self._entry_widgets and self._entry_widgets.rewards
	local reward_widgets = entry_reward_widgets and entry_reward_widgets.rewards

	if reward_widgets and #reward_widgets > 0 then
		if self._selected_reward_index > #reward_widgets then
			self._selected_reward_index = 1
		end

		if input_service:get("navigate_left_continuous") then
			local new_selected_index = self._selected_reward_index - 1

			if new_selected_index < 1 then
				new_selected_index = #reward_widgets
			end

			self._selected_reward_index = new_selected_index
		elseif input_service:get("navigate_right_continuous") then
			local new_selected_index = self._selected_reward_index + 1

			if new_selected_index > #reward_widgets then
				new_selected_index = 1
			end

			self._selected_reward_index = new_selected_index
		end
	end

	if reward_widgets then
		for i = 1, #reward_widgets do
			local widget = reward_widgets[i]
			local hotspot = widget.content.hotspot

			if hotspot then
				hotspot.is_selected = i == self._selected_reward_index
				widget.dirty = true
			end
		end
	end
end

LiveEventsView._callback_show_reward_tooltip = function (self)
	self._show_reward_tooltip = true
end

LiveEventsView._callback_hide_reward_tooltip = function (self)
	self._show_reward_tooltip = false
end

return LiveEventsView
