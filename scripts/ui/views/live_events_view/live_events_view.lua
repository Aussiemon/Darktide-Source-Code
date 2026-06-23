-- chunkname: @scripts/ui/views/live_events_view/live_events_view.lua

require("scripts/ui/views/base_view")

local LiveEvents = require("scripts/settings/live_event/live_events")
local MasterItems = require("scripts/backend/master_items")
local WalletSettings = require("scripts/settings/wallet_settings")
local RaritySettings = require("scripts/settings/item/rarity_settings")
local InputDevice = require("scripts/managers/input/input_device")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local PromiseContainer = require("scripts/utilities/ui/promise_container")
local LiveEventManager = require("scripts/managers/live_event/live_event_manager")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local TextUtilities = require("scripts/utilities/ui/text")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
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
	self._selected_entry_page = 1
	self._entry_widgets = {}

	LiveEventsView.super.init(self, Definitions, settings, context)

	self._promise_container = PromiseContainer:new()
	self._temp_progression_data = {}

	self:_create_offscreen_renderer()
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
	local active_events = Managers.live_event:get_active_events() or {}
	local sorted_ids = LiveEventManager.sorted_active_event_ids(active_events)
	local active_event_id = #sorted_ids > 0 and sorted_ids[1] or nil

	self._events = events

	self:_setup_events_button_list(events)

	local left_navigation_arrow_widget = self._widgets_by_name.navigation_arrow_left
	local right_navigation_arrow_widget = self._widgets_by_name.navigation_arrow_right

	left_navigation_arrow_widget.content.hotspot.pressed_callback = callback(self, "_on_previous_page_pressed")
	right_navigation_arrow_widget.content.hotspot.pressed_callback = callback(self, "_on_next_page_pressed")

	if active_event_id then
		self:_on_entry_selected(active_event_id, self._selected_button_list_index or 1)
	end

	Managers.event:register(self, "event_leftover_pledge_result", "_on_leftover_pledge_result")
	LiveEventsView.super.on_enter(self)
end

LiveEventsView.draw = function (self, dt, t, input_service, layer)
	local render_scale = self._render_scale
	local render_settings = self._render_settings
	local ui_renderer = self._ui_renderer
	local offscreen_renderer = self._offscreen_renderer

	render_settings.start_layer = layer or 1
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale

	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_renderer, render_settings)

	if self._button_list_widgets then
		for _, widget in pairs(self._button_list_widgets) do
			UIWidget.draw(widget, ui_renderer)
		end
	end

	UIRenderer.end_pass(ui_renderer)

	render_settings.start_layer = (layer or 1) + 1

	UIRenderer.begin_pass(offscreen_renderer, ui_scenegraph, input_service, dt, render_settings)

	if self._entry_data and not table.is_empty(self._entry_data) then
		for page_index, page_data in pairs(self._entry_data) do
			local data = page_data.data
			local page_widgets = page_data.widgets

			if data.draw then
				data.draw(self, dt, t, offscreen_renderer, render_settings, input_service, page_widgets)
			end
		end
	end

	UIRenderer.end_pass(offscreen_renderer)
end

LiveEventsView.update = function (self, dt, t, input_service)
	self:_update_reward_tooltip(dt, t, input_service)
	self:_handle_gamepad_input(dt, t, input_service)
	self:_handle_page_scroll(dt, t)
	self:_update_button_list_widget_states()
	self:_update_entries(dt, t, input_service)

	return LiveEventsView.super.update(self, dt, t, input_service)
end

LiveEventsView._update_entries = function (self, dt, t, input_service)
	if self._entry_data and not table.is_empty(self._entry_data) then
		for page_index, page_data in pairs(self._entry_data) do
			local data = page_data.data
			local page_widgets = page_data.widgets

			if data.update then
				data.update(self, dt, t, input_service, page_widgets)
			end
		end
	end
end

LiveEventsView.on_exit = function (self)
	self:_clear_entries()
	Managers.event:unregister(self, "event_leftover_pledge_result")

	if self._offscreen_renderer then
		self:_destroy_offscreen_renderer()
	end

	self._backend_interfaces = nil

	self._promise_container:delete()
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
	local event_button_id_list = {}
	local button_index = 1
	local server_time = Managers.backend:get_server_time()

	for _, event in pairs(events) do
		local template_name = event.template_name
		local event_data = LiveEvents[template_name]

		if event_data then
			local starts_at, ends_at = event.starts_at, event.ends_at
			local has_values = starts_at and ends_at
			local is_active = has_values and starts_at <= server_time and server_time <= ends_at

			if is_active then
				local button_widget = self:_create_entry_button_widget(event_data, template_name, button_index, event.id, event)

				button_widget.offset[2] = (button_index - 1) * Styles.spacing.button_spacing
				button_list_widgets[#button_list_widgets + 1] = button_widget
				button_index = button_index + 1
				event_button_id_list[template_name] = true
			elseif starts_at and server_time < starts_at then
				event_button_id_list[template_name] = true
			end
		end
	end

	for i = 1, #HISTORY_ENTRIES do
		local template_name = HISTORY_ENTRIES[i]

		if not event_button_id_list[template_name] then
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

	self:_clear_entries()

	self._selected_entry_page = 1
	self._selected_event_id = event_id
	self._selected_button_list_index = button_index or self._selected_button_list_index

	local backend_event_data = self._events[self._selected_event_id]
	local local_event_data = LiveEvents[self._selected_event_id]
	local template_name = backend_event_data and backend_event_data.template_name or self._selected_event_id
	local template = Templates[template_name] or Templates.default
	local pages = template and template.pages

	if not pages then
		return
	end

	local entry_data = {}

	for page_index, page_data in ipairs(pages) do
		entry_data[page_index] = {}

		local entry_page = entry_data[page_index]

		entry_page.data = page_data

		local composition = page_data and page_data.composition
		local page_widgets = {}
		local page_height = 0

		if composition and page_data.initialize then
			page_widgets, page_height = page_data.initialize(self, composition, backend_event_data, local_event_data, page_index)
		end

		entry_page.widgets = page_widgets
		entry_page.height = page_height
	end

	self:set_entries_scenegraph_size(nil, entry_data[self._selected_entry_page] and entry_data[self._selected_entry_page].height or 0)

	self._entry_data = entry_data

	local left_navigation_arrow_widget = self._widgets_by_name.navigation_arrow_left
	local right_navigation_arrow_widget = self._widgets_by_name.navigation_arrow_right

	left_navigation_arrow_widget.visible = #pages > 1
	right_navigation_arrow_widget.visible = #pages > 1
end

LiveEventsView._clear_entries = function (self)
	if not self._entry_data or table.is_empty(self._entry_data) then
		return
	end

	for page_index, page_data in pairs(self._entry_data) do
		local data = page_data.data
		local page_widgets = page_data.widgets

		if data.destroy then
			local ui_renderer = self._offscreen_renderer or self._ui_renderer

			data.destroy(self, page_widgets, ui_renderer)
		end
	end
end

LiveEventsView._on_next_page_pressed = function (self)
	if self._page_side_scroll_right_anim_id then
		return
	end

	if self._page_side_scroll_left_anim_id then
		self:_stop_animation(self._page_side_scroll_left_anim_id)

		self._page_side_scroll_left_anim_id = nil
	end

	local selected_event_id = self._selected_event_id
	local selected_event = self._events[selected_event_id] or LiveEvents[selected_event_id]
	local template_name = selected_event and selected_event.template_name or selected_event_id
	local template = Templates[template_name] or Templates.default
	local pages = template and template.pages

	if not pages then
		return
	end

	local num_pages = #pages

	if num_pages <= 1 then
		return
	end

	local next_page = self._selected_entry_page + 1

	if num_pages < next_page then
		next_page = 1
	end

	local entry_data = self._entry_data and self._entry_data[next_page]

	self:set_entries_scenegraph_size(nil, entry_data and entry_data.height or 0)

	self._selected_entry_page = next_page
end

LiveEventsView._on_previous_page_pressed = function (self)
	if self._page_side_scroll_left_anim_id then
		return
	end

	if self._page_side_scroll_right_anim_id then
		self:_stop_animation(self._page_side_scroll_right_anim_id)

		self._page_side_scroll_right_anim_id = nil
	end

	local selected_event_id = self._selected_event_id
	local selected_event = self._events[selected_event_id] or LiveEvents[selected_event_id]
	local template_name = selected_event and selected_event.template_name or selected_event_id
	local template = Templates[template_name] or Templates.default
	local pages = template and template.pages

	if not pages then
		return
	end

	local num_pages = #pages

	if num_pages <= 1 then
		return
	end

	local previous_page = self._selected_entry_page - 1

	if previous_page < 1 then
		previous_page = num_pages
	end

	self._selected_entry_page = previous_page

	local entry_data = self._entry_data and self._entry_data[previous_page]

	self:set_entries_scenegraph_size(nil, entry_data and entry_data.height or 0)
end

LiveEventsView._handle_page_scroll = function (self, dt, t)
	local target_x = Settings.default_entry_width * (self._selected_entry_page - 1) * -1
	local current_x = self._ui_scenegraph.entries.local_position[1]
	local new_x = math.lerp(current_x, target_x, dt * 10)

	self._ui_scenegraph.entries.local_position[1] = new_x
	self._ui_scenegraph.rewards_anchor.local_position[1] = new_x
	self._ui_scenegraph.event_progress_bar.local_position[1] = new_x

	UIScenegraph.update_scenegraph(self._ui_scenegraph, self._render_scale)
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
	local entry_data = self._entry_data and self._entry_data[self._selected_entry_page]
	local entry_page_widgets = entry_data and entry_data.widgets
	local entry_reward_widgets = entry_page_widgets and entry_page_widgets.rewards
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

	local current_selected_page = self._selected_entry_page
	local entry_data = self._entry_data and self._entry_data[current_selected_page]
	local entry_page_widgets = entry_data and entry_data.widgets
	local entry_reward_widgets = entry_page_widgets and entry_page_widgets.rewards
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

LiveEventsView._callback_on_faction_stat_update = function (self, stat_name, stat_value)
	local selected_event_id = self._selected_event_id
	local selected_event = self._events[selected_event_id] or LiveEvents[selected_event_id]

	if not selected_event then
		return
	end

	local event_id = selected_event.template_name or selected_event_id
	local global_stat_settings = Settings.global_stats_settings[event_id]

	if global_stat_settings then
		local global_stats = global_stat_settings.stats

		if global_stats and global_stats[stat_name] then
			local temp_progression_data = self:get_temp_progression_data()
			local temp_event_data = temp_progression_data[event_id] or {}

			if temp_event_data and not table.is_empty(temp_event_data) then
				local page_idx = temp_event_data.page_idx or 1
				local entry_data = self._entry_data and self._entry_data[page_idx]
				local entry_page_widgets = entry_data and entry_data.widgets
				local entry_body_widget = entry_page_widgets and entry_page_widgets.entry_body

				if entry_body_widget then
					local content = entry_body_widget.content
					local temp_stat_value = temp_event_data[stat_name] or 0

					if temp_stat_value and temp_stat_value ~= stat_value then
						if stat_value < temp_stat_value then
							content["target_" .. stat_name] = temp_stat_value
						else
							content["target_" .. stat_name] = stat_value
							temp_event_data[stat_name] = nil
						end
					end
				end
			else
				local entry_data = self._entry_data and self._entry_data[self._selected_entry_page]
				local entry_page_widgets = entry_data and entry_data.widgets
				local entry_body_widget = entry_page_widgets and entry_page_widgets.entry_body

				if entry_body_widget then
					local content = entry_body_widget.content

					content["target_" .. stat_name] = stat_value
				end
			end
		end
	end
end

LiveEventsView.get_temp_progression_data = function (self)
	return self._temp_progression_data
end

LiveEventsView._on_leftover_pledge_result = function (self, success, amount, faction_network)
	local selected_event_id = self._selected_event_id
	local selected_event = selected_event_id and (self._events[selected_event_id] or LiveEvents[selected_event_id])

	if not selected_event then
		return
	end

	local event_id = selected_event.template_name or selected_event_id
	local event_settings = LiveEvents[event_id]
	local faction_network_lookup = event_settings and event_settings.faction_network_lookup
	local faction_key = faction_network_lookup and faction_network_lookup[faction_network + 1]
	local choice_page_data

	if self._entry_data then
		for _, page_data in pairs(self._entry_data) do
			local page_widgets = page_data.widgets

			if page_widgets and page_widgets.left_side_choice_widget then
				choice_page_data = page_data

				break
			end
		end
	end

	if not choice_page_data then
		return
	end

	local page_widgets = choice_page_data.widgets
	local left_button = page_widgets.left_side_choice_widget
	local right_button = page_widgets.right_side_choice_widget

	if left_button then
		left_button.content.resource_button_hotspot.choice_made = nil
	end

	if right_button then
		right_button.content.resource_button_hotspot.choice_made = nil
	end

	if not success then
		return
	end

	local entry_body = page_widgets.entry_body
	local content = entry_body and entry_body.content
	local global_stat_settings = Settings.global_stats_settings[event_id]
	local global_stats = global_stat_settings and global_stat_settings.stats
	local global_stat_name = global_stats and faction_key and global_stats[faction_key]

	if global_stat_name and content then
		local temp_progression_data = self:get_temp_progression_data()

		temp_progression_data[event_id] = {
			page_idx = self._selected_entry_page,
			[global_stat_name] = (content[global_stat_name] or 0) + amount,
		}
	end

	if content then
		content.resource_collected = 0
	end
end

LiveEventsView._callback_show_reward_tooltip = function (self)
	self._show_reward_tooltip = true
end

LiveEventsView._callback_hide_reward_tooltip = function (self)
	self._show_reward_tooltip = false
end

LiveEventsView.set_entries_scenegraph_size = function (self, width, height)
	self:_set_scenegraph_size("entries_anchor", width, height)
	self:_set_scenegraph_size("entries_mask", width, height)
	self:_set_scenegraph_size("entries", width, height)
end

LiveEventsView._create_offscreen_renderer = function (self)
	local world_layer = 10
	local world_name = self.__class_name .. "_ui_offscreen_world"
	local world = Managers.ui:create_world(world_name, world_layer, nil)
	local viewport_name = self.__class_name .. "_offscreen_viewport"
	local viewport_type = "overlay_offscreen"
	local viewport_layer = 1
	local viewport = Managers.ui:create_viewport(world, viewport_name, viewport_type, viewport_layer)
	local renderer_name = self.__class_name .. "_offscreen_renderer"

	self._offscreen_renderer = Managers.ui:create_renderer(renderer_name, world)
	self._offscreen_world = {
		name = world_name,
		world = world,
		viewport = viewport,
		viewport_name = viewport_name,
		renderer_name = renderer_name,
	}
end

LiveEventsView._destroy_offscreen_renderer = function (self)
	if self._offscreen_renderer then
		self._offscreen_renderer = nil
	end

	local world_data = self._offscreen_world

	if world_data then
		Managers.ui:destroy_renderer(world_data.renderer_name)
		ScriptWorld.destroy_viewport(world_data.world, world_data.viewport_name)
		Managers.ui:destroy_world(world_data.world)

		self._offscreen_world = nil
	end
end

return LiveEventsView
