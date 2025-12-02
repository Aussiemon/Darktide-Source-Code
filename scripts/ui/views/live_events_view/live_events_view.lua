-- chunkname: @scripts/ui/views/live_events_view/live_events_view.lua

require("scripts/ui/views/base_view")

local LiveEvents = require("scripts/settings/live_event/live_events")
local MasterItems = require("scripts/backend/master_items")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local TextUtilities = require("scripts/utilities/ui/text")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
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

	LiveEventsView.super.init(self, Definitions, settings, context)
end

LiveEventsView.on_enter = function (self)
	if self._parent then
		self._parent:set_active_view_instance(self)
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

	LiveEventsView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

LiveEventsView.update = function (self, dt, t, input_service)
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
		local button_content_override = {
			gamepad_action = "confirm_pressed",
			original_text = Localize(event_data.name),
			text = Localize(event_data.name),
			hotspot = {
				pressed_callback = callback(self, "_on_entry_selected", event.id),
			},
		}
		local button_definition = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "button_list_anchor", button_content_override, Styles.sizes.event_button_size)
		local button_widget = self:_create_widget("event_button_" .. template_name, button_definition)

		button_widget.offset[2] = (i - 1) * Styles.spacing.button_spacing
		button_list_widgets[#button_list_widgets + 1] = button_widget
		i = i + 1
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

	local height = Styles.spacing.text_top_padding + Styles.spacing.event_name_height

	base_content.event_name = event_data and Localize(event_data.name) or "n/a"

	if event_data and event_data.lore then
		local event_lore = Localize(event_data.lore)

		base_content.event_lore = event_lore

		local lore_text_style = base_style.event_lore
		local lore_text_height = TextUtilities.text_height(self._ui_renderer, event_lore, lore_text_style, lore_text_style.size, true)

		lore_text_style.size[2] = lore_text_height
		height = height + lore_text_height + 20
	else
		base_style.event_lore.visible = false
	end

	local event_description = event_data and Localize(event_data.description) or "n/a"

	base_content.event_description = event_description

	local description_text_height = TextUtilities.text_height(self._ui_renderer, event_description, Styles.texts.event_description, Styles.texts.event_description.size, true)
	local description_text_style = base_style.event_description

	description_text_style.size[2] = description_text_height
	description_text_style.offset[2] = height + 20
	height = height + description_text_height + 40

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

	self:_create_reward_widgets(event)

	height = height + Styles.spacing.reward_track_spacing

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

	local reward_widgets = {}
	local tiers = event.tiers or {}
	local progress_bar_size = self._ui_scenegraph.event_progress_bar.size
	local bar_width = progress_bar_size[1]
	local num_tiers = #tiers
	local max_target_exp = tiers[num_tiers] and tiers[num_tiers].target or 1
	local reward_start_x = -(#tiers * (Styles.sizes.reward_size[1] + 40)) / 2

	for k = 1, num_tiers do
		local tier = tiers[k]
		local rewards = tier.rewards or {}

		for j = 1, #rewards do
			local tier_index = k
			local reward_index = j
			local reward = rewards[j]
			local widget_definition = Definitions.create_reward_widget("event_progress_bar", reward, tier_index, reward_index)
			local reward_widget = self:_create_widget("reward_widget_" .. tier_index .. "_" .. reward_index, widget_definition)
			local tier_target_exp = tier.target or 1
			local spacing = tier_target_exp / max_target_exp * bar_width
			local offset_x = spacing - 2

			reward_widgets[#reward_widgets + 1] = reward_widget
			reward_widget.offset[1] = offset_x - Styles.sizes.reward_size[1] / 2
			reward_widget.offset[2] = -120

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

	self:_setup_event_progress_bar(event)
end

LiveEventsView._setup_event_progress_bar = function (self, event)
	local event_progress_bar_widget = self._widgets_by_name.event_progress_bar
	local event_progress_bar_content = event_progress_bar_widget.content
	local event_progress_bar_style = event_progress_bar_widget.style
	local current_progress = Managers.live_event:active_progress()
	local tiers = event.tiers or {}
	local num_tiers = #tiers
	local max_progress = tiers[num_tiers] and tiers[num_tiers].target or 1
	local actual_progress = current_progress / max_progress

	event_progress_bar_content.current_progress = actual_progress or 0
	event_progress_bar_content.max_progress = max_progress

	local progress_text = string.format("%.0f%%", actual_progress * 100) .. " [" .. tostring(current_progress) .. "/" .. tostring(max_progress) .. "]"

	event_progress_bar_content.progress_text = progress_text
	event_progress_bar_widget.dirty = true
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

return LiveEventsView
