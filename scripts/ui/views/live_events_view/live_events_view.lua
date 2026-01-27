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
local LiveEventsView = class("LiveEventsView", "BaseView")

local function _apply_package_item_icon_cb_func(widget, item)
	local icon_style = widget.style.icon
	local material_values = icon_style.material_values
	local widget_content = widget.content
	local item_type = item.item_type or "default"
	local item_display_materials = Settings.ui_item_display_materials

	widget_content.icon = item_display_materials[item_type] or item_display_materials.default

	local item_display_sizes = Settings.ui_item_display_sizes

	icon_style.size = item_display_sizes[item_type] or item_display_sizes.default

	local item_display_offsets = Settings.ui_item_display_offsets

	icon_style.offset = item_display_offsets[item_type] or item_display_offsets.default

	if item.icon_material and item.icon_material ~= "" then
		widget.content.icon = item.icon_material
		material_values.use_placeholder_texture = 0
		material_values.use_render_target = 0
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

	self:_setup_events_button_list(events)
	self:_on_entry_selected(active_event_id)
	LiveEventsView.super.on_enter(self)
end

LiveEventsView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if self._button_list_widgets then
		for _, widget in pairs(self._button_list_widgets) do
			UIWidget.draw(widget, ui_renderer)
		end
	end

	if self._reward_widgets then
		for _, widget in pairs(self._reward_widgets) do
			UIWidget.draw(widget, ui_renderer)
		end
	end

	if self._reward_line_widgets then
		for _, widget in pairs(self._reward_line_widgets) do
			UIWidget.draw(widget, ui_renderer)
		end
	end

	LiveEventsView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

LiveEventsView.update = function (self, dt, t, input_service)
	self:_update_reward_tooltip(dt, t, input_service)
	self:_handle_gamepad_input(dt, t, input_service)

	return LiveEventsView.super.update(self, dt, t, input_service)
end

LiveEventsView.on_exit = function (self)
	if self._reward_widgets then
		for _, widget in pairs(self._reward_widgets) do
			self:_unload_item_icon(widget, self._ui_renderer)
		end

		self._reward_widgets = nil
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
	local i = 1

	for _, event in pairs(events) do
		local template_name = event.template_name
		local event_data = LiveEvents[template_name]

		if event_data then
			local button_name = "event_button_" .. template_name

			if self._widgets_by_name[button_name] then
				button_name = "event_button_" .. template_name .. "duplicate_" .. i
			end

			local button_content_override = {
				gamepad_action = "confirm_pressed",
				original_text = Localize(event_data.name),
				text = Localize(event_data.name),
				hotspot = {
					pressed_callback = callback(self, "_on_entry_selected", event.id),
				},
			}
			local button_definition = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "button_list_anchor", button_content_override, Styles.sizes.event_button_size)
			local button_widget = self:_create_widget(button_name, button_definition)

			button_widget.offset[2] = (i - 1) * Styles.spacing.button_spacing
			button_list_widgets[#button_list_widgets + 1] = button_widget
			i = i + 1
		end
	end

	self._button_list_widgets = button_list_widgets
end

LiveEventsView._on_entry_selected = function (self, event_id)
	local entry_base_widget = self._widgets_by_name.entry_base
	local event = self._events[event_id]

	if not event then
		entry_base_widget.visible = false

		return
	end

	if event_id == self._selected_event_id then
		return
	end

	self._selected_event_id = event_id
	entry_base_widget.visible = true

	local base_content = entry_base_widget.content
	local base_style = entry_base_widget.style
	local template_name = event.template_name
	local event_data = LiveEvents[template_name]

	if not event_data then
		Log.warning("Missing LiveEvents data for event template " .. tostring(template_name))
	end

	local height = Styles.spacing.text_top_padding + Styles.spacing.event_name_height + 20

	base_content.event_name = event_data and Localize(event_data.name) or "n/a"

	if event_data and event_data.lore then
		local event_lore = Localize(event_data.lore)

		base_content.event_lore = event_lore

		local lore_text_style = base_style.event_lore
		local lore_text_height = TextUtilities.text_height(self._ui_renderer, event_lore, lore_text_style, lore_text_style.size, true)

		lore_text_style.size[2] = lore_text_height
		height = height + lore_text_height + 46
	else
		base_style.event_lore.visible = false
	end

	local event_description = event_data and Localize(event_data.description) or "n/a"

	base_content.event_description = event_description

	local description_text_height = TextUtilities.text_height(self._ui_renderer, event_description, Styles.texts.event_description, Styles.texts.event_description.size, true)
	local description_text_style = base_style.event_description

	description_text_style.size[2] = description_text_height
	description_text_style.offset[2] = height + 20
	height = height + description_text_height + 60

	if event_data and event_data.event_context then
		local event_context = Localize(event_data.event_context)

		base_content.event_context = event_context

		local context_text_style = base_style.event_context
		local context_text_height = TextUtilities.text_height(self._ui_renderer, event_context, context_text_style, context_text_style.size, true)

		context_text_style.size[2] = context_text_height
		context_text_style.offset[2] = height
		height = height + context_text_height + 20
	else
		base_style.event_context.visible = false
	end

	base_content.rewards_track_text = Localize("loc_mission_voting_view_salary") .. ":"
	base_style.rewards_track_text.offset[2] = height
	height = height + 10

	local should_increase_size = self:_create_reward_widgets(event)

	height = height + (should_increase_size and Styles.spacing.reward_track_spacing + Styles.sizes.reward_size[2] + 10 or Styles.spacing.reward_track_spacing)

	self:_set_scenegraph_size("entries_anchor", nil, height)

	entry_base_widget.dirty = true
end

LiveEventsView._create_reward_widgets = function (self, event)
	if self._reward_widgets then
		for _, widget in pairs(self._reward_widgets) do
			self:_unload_item_icon(widget, self._ui_renderer)
			self:_unregister_widget_name(widget.name)
		end

		table.clear(self._reward_widgets)
	end

	if self._reward_line_widgets then
		for _, widget in pairs(self._reward_line_widgets) do
			self:_unregister_widget_name(widget.name)
		end

		table.clear(self._reward_line_widgets)
	end

	local reward_widgets = {}
	local line_widgets = {}
	local tiers = event.tiers or {}
	local progress_bar_size = self._ui_scenegraph.event_progress_bar.size
	local bar_width = progress_bar_size[1]
	local rewards_box_width = self._ui_scenegraph.rewards_box.size[1]
	local num_tiers = #tiers
	local max_target_exp = tiers[num_tiers] and tiers[num_tiers].target or 1
	local should_increase_size = false
	local reward_start_x = -(#tiers * (Styles.sizes.reward_size[1] + 40)) / 2

	for k = 1, num_tiers do
		local tier = tiers[k]
		local rewards = tier.rewards or {}

		for j = 1, #rewards do
			local tier_index = k
			local reward_index = j
			local reward = rewards[j]
			local widget_definition = Definitions.create_reward_widget("rewards_box", reward, tier_index, reward_index)
			local target_line_definition = UIWidget.create_definition({
				{
					pass_type = "texture",
					style_id = "line",
					value = "content/ui/materials/mission_board/mission_line",
					value_id = "line",
					style = Styles.reward.bar_connection_line,
				},
			}, "event_progress_bar")
			local reward_widget = self:_create_widget("reward_widget_" .. tier_index .. "_" .. reward_index, widget_definition)
			local line_widget = self:_create_widget("reward_line_widget_" .. tier_index .. "_" .. reward_index, target_line_definition)

			line_widgets[#line_widgets + 1] = line_widget

			local tier_target_exp = tier.target or 1
			local rewards_spacing = tier_target_exp / max_target_exp * rewards_box_width
			local line_spacing = tier_target_exp / max_target_exp * bar_width
			local offset_x = rewards_spacing - 2

			reward_widgets[#reward_widgets + 1] = reward_widget
			reward_widget.offset[1] = offset_x - Styles.sizes.reward_size[1] / 2
			line_widget.offset[1] = line_spacing - 2

			local has_reward_with_same_target = false

			for m = 1, #reward_widgets do
				local widget = reward_widgets[m]
				local content = widget.content

				if content.tier_xp == tier.target and widget ~= reward_widget then
					has_reward_with_same_target = true
					should_increase_size = true

					break
				end
			end

			if has_reward_with_same_target then
				reward_widget.offset[2] = -(Styles.sizes.reward_size[2] + 10)
				line_widget.offset[2] = -(Styles.sizes.reward_size[2] + 10)
			else
				reward_widget.offset[2] = -(j - 1) * (Styles.sizes.reward_size[2] + 10)
				line_widget.offset[2] = -((j - 1) * (Styles.sizes.reward_size[2] + 10))
			end

			reward_widget.content.reward = reward
			reward_widget.content.tier_xp = tier.target

			if reward.type == "item" then
				local item = MasterItems.get_item(reward.id)

				self:_request_item_icon(reward_widget, item, self._ui_renderer)

				reward_widget.content.item = item
			else
				reward_widget.content.amount = reward.amount
				reward_widget.content.currency = reward.currency
			end
		end
	end

	self._reward_widgets = reward_widgets
	self._reward_line_widgets = line_widgets

	self:_setup_event_progress_bar(event)

	return should_increase_size
end

LiveEventsView._setup_event_progress_bar = function (self, event)
	local event_progress_bar_widget = self._widgets_by_name.event_progress_bar
	local event_progress_bar_content = event_progress_bar_widget.content
	local event_progress_bar_style = event_progress_bar_widget.style
	local current_progress = Managers.live_event:active_progress()
	local tiers = event.tiers or {}
	local num_tiers = #tiers
	local max_progress = tiers[num_tiers] and tiers[num_tiers].target or 1

	current_progress = math.clamp(current_progress, 0, max_progress)

	local actual_progress = math.clamp(current_progress / max_progress, 0, 1)

	event_progress_bar_content.progress = actual_progress or 0
	event_progress_bar_content.current_progress = actual_progress or 0
	event_progress_bar_content.max_progress = max_progress
	event_progress_bar_style.bar.color = Color.golden_rod(255, true)
	event_progress_bar_widget.dirty = true

	local progress_text_widget = self._widgets_by_name.progress_text
	local progress_text = string.format("%.0f%%", actual_progress * 100) .. " [" .. tostring(current_progress) .. "/" .. tostring(max_progress) .. "]"

	progress_text_widget.content.progress_text = progress_text
	progress_text_widget.dirty = true
	self._active_event_progress = current_progress
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

LiveEventsView._update_reward_tooltip = function (self, dt, t, input_service, ui_renderer)
	local visible = false
	local reward_tooltip_widget = self._widgets_by_name.reward_info_tooltip
	local reward_tooltip_content = reward_tooltip_widget.content
	local reward_tooltip_style = reward_tooltip_widget.style

	if self._reward_widgets then
		for i = 1, #self._reward_widgets do
			local reward_widget = self._reward_widgets[i]
			local hotspot = reward_widget.content.hotspot

			if hotspot and (hotspot.is_hover or InputDevice.gamepad_active and hotspot.is_selected and self._show_reward_tooltip) then
				local reward = reward_widget.content.reward

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
					reward_tooltip_content.reward_tooltip_target_xp = tostring(self._active_event_progress) .. " / " .. tostring(reward_widget.content.tier_xp) .. " XP"
				else
					local currency_settings = WalletSettings[reward.currency]

					reward_tooltip_content.reward_tooltip_type = tostring(reward.amount) .. " " .. Localize(currency_settings.display_name)
					reward_tooltip_content.reward_tooltip_rarity = ""
					reward_tooltip_style.reward_tooltip_rarity.visible = false
					reward_tooltip_style.reward_tooltip_info.visible = false
					reward_tooltip_content.reward_tooltip_target_xp = tostring(self._active_event_progress) .. " / " .. tostring(reward_widget.content.tier_xp) .. " XP"
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
			local selected_reward_widget = self._reward_widgets[self._selected_reward_index]

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

	if self._reward_widgets and #self._reward_widgets > 0 then
		if self._selected_reward_index > #self._reward_widgets then
			self._selected_reward_index = 1
		end

		if input_service:get("navigate_left_continuous") then
			local new_selected_index = self._selected_reward_index - 1

			if new_selected_index < 1 then
				new_selected_index = #self._reward_widgets
			end

			self._selected_reward_index = new_selected_index
		elseif input_service:get("navigate_right_continuous") then
			local new_selected_index = self._selected_reward_index + 1

			if new_selected_index > #self._reward_widgets then
				new_selected_index = 1
			end

			self._selected_reward_index = new_selected_index
		end
	end

	if self._button_list_widgets then
		for i = 1, #self._button_list_widgets do
			local widget = self._button_list_widgets[i]
			local hotspot = widget.content.hotspot

			if hotspot then
				hotspot.is_selected = i == self._selected_button_list_index
				widget.dirty = true
			end
		end
	end

	if self._reward_widgets then
		for i = 1, #self._reward_widgets do
			local widget = self._reward_widgets[i]
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
