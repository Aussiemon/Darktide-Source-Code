﻿-- chunkname: @scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay.lua

local Blueprints = require("scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay_blueprints")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local Definitions = require("scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay_definitions")
local ElementSettings = require("scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay_settings")
local InputDevice = require("scripts/managers/input/input_device")
local MissionTypes = require("scripts/settings/mission/mission_types")
local TextUtils = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local HudElementTacticalOverlay = class("HudElementTacticalOverlay", "HudElementBase")
local default_mission_type_icon = "content/ui/materials/icons/mission_types/mission_type_side"
local _text_extra_options = {}

local function _text_width(ui_renderer, text, style)
	local text_extra_options = _text_extra_options

	table.clear(text_extra_options)
	UIFonts.get_font_options_by_style(style, text_extra_options)

	local width = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, style.size, text_extra_options)

	return math.round(width)
end

HudElementTacticalOverlay.init = function (self, parent, draw_layer, start_scale, optional_context)
	HudElementTacticalOverlay.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._context = table.add_missing(optional_context or {}, ElementSettings.default_context)
	self._difficulty_manager = Managers.state.difficulty
	self._mission_manager = Managers.state.mission
	self._circumstance_manager = Managers.state.circumstance
	self._backend_interfaces = Managers.backend.interfaces
	self._contract_data = {}

	self:_fetch_task_list()

	self._preferred_page = Managers.save:account_data().right_panel_category
	self._right_panel_entries = {}
	self._tracked_achievements = 0
	self._grid_overrides = {}

	self:_setup_left_panel_widgets()
	self:_setup_right_panel_widgets()
	self:on_resolution_modified()
	Managers.event:register(self, "reroll_contracts", "reroll_contracts")
end

HudElementTacticalOverlay.destroy = function (self, ui_renderer)
	Managers.event:unregister(self, "reroll_contracts")

	local contracts_promise = self._contracts_promise

	if contracts_promise and contracts_promise:is_pending() then
		contracts_promise:cancel()
	end

	Managers.save:account_data().right_panel_category = self._right_panel_key

	self:_delete_tab_bar(ui_renderer)

	for page_key, _ in pairs(self._right_panel_entries) do
		self:_delete_right_panel_widgets(page_key, ui_renderer)
	end

	HudElementTacticalOverlay.super.destroy(self, ui_renderer)
end

HudElementTacticalOverlay.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	local ignore_hud_input = true
	local is_input_blocked = Managers.ui:using_input(ignore_hud_input)

	HudElementTacticalOverlay.super.update(self, dt, t, ui_renderer, render_settings, is_input_blocked and input_service:null_service() or input_service)

	local service_type = "Ingame"

	input_service = is_input_blocked and input_service:null_service() or Managers.input:get_input_service(service_type)

	local active = false

	if not input_service:is_null_service() and input_service:get("tactical_overlay_hold") then
		active = true
	end

	if active and input_service:get("tactical_overlay_swap") then
		self:_switch_right_grid(ui_renderer)
	end

	local right_panel_grid = self._right_panel_grid

	if right_panel_grid then
		right_panel_grid:update(dt, t, input_service)
	end

	self:_update_contracts(dt, ui_renderer)
	self:_update_achievements(dt, ui_renderer)
	self:_update_live_event(dt, ui_renderer)
	self:_update_right_panel_widgets(ui_renderer)

	if self._gamepad_active ~= InputDevice.gamepad_active then
		self._gamepad_active = InputDevice.gamepad_active

		self:_update_right_hint()
	end

	if active and not self._active then
		Managers.event:trigger("event_set_tactical_overlay_state", true)
		self:_sync_mission_info()
		self:_sync_circumstance_info()
		self:_update_left_panel_elements(ui_renderer)
		self:_start_animation("enter", self._left_panel_widgets)
		Managers.telemetry_reporters:reporter("tactical_overlay"):register_event(self._tracked_achievements)
	elseif self._active and not active then
		Managers.event:trigger("event_set_tactical_overlay_state", false)
		self:_start_animation("exit", self._left_panel_widgets)
	end

	if self._active then
		self:_update_materials_collected()
		self:_update_right_timer_text(dt, t, ui_renderer)
	end

	self._active = active

	self:_update_visibility(dt)
end

HudElementTacticalOverlay._update_left_panel_elements = function (self, ui_renderer)
	local total_size = 0
	local margin = 20
	local scenegraph = self._ui_scenegraph

	total_size = total_size + scenegraph.mission_info_panel.size[2]

	local circumstance_info_widget = self._widgets_by_name.circumstance_info

	if circumstance_info_widget.visible == true then
		local title_margin = 20

		total_size = total_size + margin + title_margin

		self:set_scenegraph_position("circumstance_info_panel", nil, total_size)

		local circumstance_info_content = circumstance_info_widget.content
		local circumstance_name_style = circumstance_info_widget.style.circumstance_name
		local circumstance_name_font_options = UIFonts.get_font_options_by_style(circumstance_name_style)
		local _, circumstance_name_height = UIRenderer.text_size(ui_renderer, circumstance_info_content.circumstance_name, circumstance_name_style.font_type, circumstance_name_style.font_size, {
			circumstance_name_style.size[1],
			1000,
		}, circumstance_name_font_options)
		local description_margin = 5
		local min_height = circumstance_info_widget.style.icon.size[2]
		local title_height = math.max(min_height, circumstance_name_height)

		circumstance_name_style.size[2] = title_height

		local circumstance_description_style = circumstance_info_widget.style.circumstance_description
		local circumstance_description_font_options = UIFonts.get_font_options_by_style(circumstance_description_style)
		local _, circumstance_description_height = UIRenderer.text_size(ui_renderer, circumstance_info_content.circumstance_description, circumstance_description_style.font_type, circumstance_description_style.font_size, {
			circumstance_description_style.size[1],
			1000,
		}, circumstance_description_font_options)

		circumstance_description_style.offset[2] = title_height + circumstance_name_style.offset[2] + description_margin
		circumstance_description_style.size[2] = circumstance_description_height

		local circumstance_height = circumstance_description_style.offset[2] + circumstance_description_style.size[2] + circumstance_info_widget.style.icon.offset[2]

		self:_set_scenegraph_size("circumstance_info_panel", nil, circumstance_height)

		total_size = total_size + circumstance_height
	end

	total_size = total_size + margin

	self:set_scenegraph_position("crafting_pickup_pivot", nil, total_size)

	local diamantine_pos = scenegraph.plasteel_info_panel.size[2] + 5

	self:set_scenegraph_position("diamantine_info_panel", nil, diamantine_pos)

	total_size = total_size + diamantine_pos
	total_size = total_size + scenegraph.diamantine_info_panel.size[2]

	self:_set_scenegraph_size("left_panel", nil, total_size)
end

HudElementTacticalOverlay._set_contracts = function (self, optional_data)
	self._contract_data = optional_data
	self._contracts_fetched = optional_data ~= nil
	self._contracts_promise = nil
end

HudElementTacticalOverlay._fetch_task_list = function (self)
	local player_manager = Managers.player
	local player = player_manager:local_player(1)
	local character_id = player:character_id()

	if not math.is_uuid(character_id) then
		self:_set_contracts()

		return
	end

	local is_event_complete = Managers.narrative:is_event_complete("level_unlock_contract_store_visited")
	local show_right_side = self._context.show_right_side
	local should_request = is_event_complete and show_right_side

	if not should_request then
		self:_set_contracts()

		return
	end

	self._contracts_promise = self._backend_interfaces.contracts:get_current_contract(character_id, nil, should_request)

	self._contracts_promise:next(function (data)
		self:_set_contracts(data)
	end):catch(function (error)
		if error.code ~= 404 then
			Log.warning("HudElementTacticalOverlay", "Failed to fetch contracts with error: %s", table.tostring(error, 5))
		end

		self:_set_contracts()
	end)
end

HudElementTacticalOverlay._update_right_grid_size = function (self)
	local current_key = self._right_panel_key
	local should_be_visible = current_key ~= nil
	local grid = self._right_panel_grid
	local height = should_be_visible and grid:length() + ElementSettings.buffer or 0
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.right_grid_background.style.rect.size[2] = height
	widgets_by_name.right_grid_stick.style.rect.size[2] = height
	widgets_by_name.right_input_hint.style.hint.offset[2] = height + 2
end

HudElementTacticalOverlay._update_right_hint = function (self)
	local entries = self._right_panel_entries
	local content = self._widgets_by_name.right_input_hint.content

	if table.size(entries) > 1 then
		content.hint = TextUtils.localize_with_button_hint("tactical_overlay_swap", "loc_hud_tactical_overlay_cycle_tab", nil, "Ingame", nil, nil, true)
	else
		content.hint = ""
	end
end

HudElementTacticalOverlay._update_right_timer_text = function (self, dt, t, ui_renderer)
	local right_timer_function = self._right_timer_function

	if not right_timer_function then
		return
	end

	local timer_value = right_timer_function(t)
	local last_seen_value = self._last_seen_time

	if not last_seen_value or math.floor(timer_value) ~= math.floor(last_seen_value) then
		self._last_seen_time = timer_value

		local timer_widget = self._widgets_by_name.right_timer
		local timer_text = TextUtils.format_time_span_localized(timer_value, true)

		timer_widget.content.time_left = timer_text
		timer_widget.style.time_name.offset[1] = -(2 * ElementSettings.buffer + _text_width(ui_renderer, timer_text, timer_widget.style.time_name))
	end
end

HudElementTacticalOverlay._update_right_timer = function (self)
	local timer_widget = self._widgets_by_name.right_timer

	self._last_seen_time = nil

	local current_key = self._right_panel_key

	if not current_key then
		self._right_timer_function = nil
		timer_widget.visible = false

		return
	end

	local page_settings = self:_get_page(current_key)
	local timer_data = page_settings.timer

	if timer_data == nil then
		self._right_timer_function = nil
		timer_widget.visible = false

		return
	end

	self._right_timer_function = timer_data.func
	timer_widget.visible = true
	timer_widget.content.time_name = Localize(timer_data.loc_key)
	timer_widget.content.time_left = ""
end

HudElementTacticalOverlay._delete_tab_bar = function (self, ui_renderer)
	local tab_bar_widgets = self._tab_bar_widgets
	local tab_bar_widgets_size = tab_bar_widgets and #tab_bar_widgets or 0

	for i = 1, tab_bar_widgets_size do
		local name = string.format("tab_%d", i)

		self:_unregister_widget_name(name)
		UIWidget.destroy(ui_renderer, tab_bar_widgets[i])
	end

	self._tab_bar_widgets = nil
end

HudElementTacticalOverlay._get_page = function (self, page_key)
	local grid_overrides = self._grid_overrides

	return grid_overrides[page_key] or ElementSettings.right_panel_grids[page_key]
end

HudElementTacticalOverlay._update_right_tab_bar = function (self, ui_renderer)
	self:_update_right_hint()
	self:_update_right_timer()
	self:_delete_tab_bar(ui_renderer)

	local entries = self._right_panel_entries
	local current_key = self._right_panel_key
	local widgets_by_name = self._widgets_by_name

	if table.size(entries) > 0 then
		widgets_by_name.right_header_stick.content.visible = true
		widgets_by_name.right_header_background.content.visible = true

		local definitions = {}
		local tab_bar_widgets = {}
		local ordered_keys = ElementSettings.right_panel_order
		local total_width = ElementSettings.buffer - ElementSettings.internal_buffer
		local selected_blueprint, selected_definition, selected_config

		for _, page_key in ipairs(ordered_keys) do
			if entries[page_key] then
				local page_settings = self:_get_page(page_key)
				local blueprint_type = page_settings.icon.blueprint_type
				local blueprint = Blueprints[blueprint_type]
				local definition = definitions[blueprint_type] or UIWidget.create_definition(blueprint.pass_template, "right_panel_header", nil, blueprint.size)

				definitions[blueprint_type] = definition

				local selected = current_key == page_key
				local config = {
					is_left = false,
					value = page_settings.icon.value,
					selected = selected,
				}
				local index = #tab_bar_widgets + 1
				local name = string.format("tab_%d", index)
				local widget = self:_create_widget(name, definition)
				local init_function = blueprint.init

				if init_function then
					init_function(self, widget, config, ui_renderer)
				end

				tab_bar_widgets[index] = widget
				total_width = total_width + widget.content.size[1] + ElementSettings.internal_buffer

				if selected then
					selected_blueprint, selected_definition, selected_config = blueprint, definition, table.clone(config)
				end
			end
		end

		local current_width = 0

		for i = 1, #tab_bar_widgets do
			local widget = tab_bar_widgets[i]

			widget.offset[1] = ElementSettings.right_grid_width - total_width + current_width
			current_width = current_width + widget.content.size[1] + ElementSettings.internal_buffer
		end

		if selected_definition and selected_blueprint and selected_config then
			local index = #tab_bar_widgets + 1
			local name = string.format("tab_%d", index)
			local widget = self:_create_widget(name, selected_definition)
			local init_function = selected_blueprint.init

			if init_function then
				selected_config.is_left = true

				init_function(self, widget, selected_config, ui_renderer)
			end

			tab_bar_widgets[index] = widget
			widget.offset[1] = -widget.content.size[1]
		end

		self._tab_bar_widgets = tab_bar_widgets
	else
		widgets_by_name.right_header_stick.content.visible = false
		widgets_by_name.right_header_background.content.visible = false
	end

	local title_widget = widgets_by_name.right_header_title
	local selected_page = self:_get_page(current_key)
	local selected_title = selected_page and Localize(selected_page.loc_key) or ""

	title_widget.content.text = Utf8.upper(selected_title)
end

HudElementTacticalOverlay._override_right_panel_category = function (self, key, data, ui_renderer)
	local original = ElementSettings.right_panel_grids[key]

	self._grid_overrides[key] = data and table.add_missing_recursive(data, original)

	if ui_renderer then
		self:_update_right_tab_bar(ui_renderer)
	end
end

HudElementTacticalOverlay._swap_right_grid = function (self, page_key, ui_renderer)
	self._right_panel_key = page_key

	if self._preferred_page == page_key then
		self._preferred_page = nil
	end

	local widgets = self._right_panel_entries[page_key] or {}

	self._right_panel_grid = UIWidgetGrid:new(widgets, nil, self._ui_scenegraph, "right_panel_content", "down", ElementSettings.right_grid_spacing)

	self:_update_right_grid_size()
	self:_update_right_tab_bar(ui_renderer)
end

HudElementTacticalOverlay._delete_right_panel_widgets = function (self, page_key, ui_renderer, is_update)
	local widgets = self._right_panel_entries[page_key]
	local widgets_size = widgets and #widgets or 0

	for i = 1, widgets_size do
		local name = string.format("%s_%d", page_key, i)

		self:_unregister_widget_name(name)
		UIWidget.destroy(ui_renderer, widgets[i])
	end

	self._right_panel_entries[page_key] = nil

	local current_key = self._right_panel_key

	if not is_update and current_key == page_key then
		self:_switch_right_grid(ui_renderer)
	else
		self:_update_right_tab_bar(ui_renderer)
	end
end

HudElementTacticalOverlay._create_right_panel_widgets = function (self, page_key, configs, ui_renderer)
	self:_delete_right_panel_widgets(page_key, ui_renderer, true)

	local definitions = {}
	local widgets = {}

	for i = 1, #configs do
		local config = configs[i]
		local blueprint_type = config.blueprint
		local blueprint = Blueprints[blueprint_type]
		local definition = definitions[blueprint_type] or UIWidget.create_definition(blueprint.pass_template, "right_panel_content", nil, blueprint.size)

		definitions[blueprint_type] = definition

		local name = string.format("%s_%d", page_key, i)
		local widget = self:_create_widget(name, definition)
		local init_function = blueprint.init

		if init_function then
			init_function(self, widget, config, ui_renderer)
		end

		widget.blueprint_type = blueprint_type
		widgets[i] = widget
	end

	self._right_panel_entries[page_key] = widgets

	local current_key = self._right_panel_key
	local is_empty = current_key == nil
	local is_current = page_key == current_key
	local is_preferred = page_key == self._preferred_page
	local should_swap = is_empty or is_current or is_preferred

	if should_swap then
		self:_swap_right_grid(page_key, ui_renderer)
	else
		self:_update_right_tab_bar(ui_renderer)
	end

	return widgets
end

HudElementTacticalOverlay._setup_contracts = function (self, contracts_data, ui_renderer)
	local page_key = "contracts"
	local tasks = contracts_data.tasks
	local configs = {}

	for i = 1, #tasks do
		configs[i] = {
			blueprint = "contract",
			task = tasks[i],
			reward = table.nested_get(tasks[i], "reward", "amount"),
		}
	end

	if #tasks == 0 then
		self:_delete_right_panel_widgets(page_key, ui_renderer)

		return
	end

	self:_create_right_panel_widgets(page_key, configs, ui_renderer)
end

HudElementTacticalOverlay._on_right_panel_widgets = function (self, key, func_name, ...)
	local updated_key = key or self._right_panel_key
	local contract_widgets = self._right_panel_entries[updated_key]
	local widget_count = contract_widgets and #contract_widgets or 0

	for i = 1, widget_count do
		local widget = contract_widgets[i]
		local blueprint_type = widget.blueprint_type
		local blueprint = Blueprints[blueprint_type]
		local func = blueprint[func_name]

		if func then
			func(self, widget, ...)
		end
	end
end

HudElementTacticalOverlay._update_right_panel_widgets = function (self, ui_renderer, desired_page)
	return self:_on_right_panel_widgets(desired_page, "update", ui_renderer)
end

HudElementTacticalOverlay._setup_live_event = function (self, ui_renderer)
	local live_event_id = Managers.live_event:active_event_id()

	self._live_event_id = live_event_id

	local page_key = "event"
	local template = Managers.live_event:active_template()
	local event_name = template.name
	local event_description = template.description
	local configs = {
		{
			blueprint = "title",
			text = Localize(event_name),
		},
		{
			blueprint = "header",
			text = Localize("loc_event_briefing"),
		},
		{
			blueprint = "body",
			text = Localize(event_description),
		},
	}
	local tiers = Managers.live_event:active_tiers()
	local tier_count = tiers and #tiers or 0
	local max_tiers = ElementSettings.max_live_event_tiers
	local shown_tiers = math.min(max_tiers, tier_count)

	if shown_tiers > 0 then
		configs[#configs + 1] = {
			blueprint = "header",
			text = Localize("loc_event_objectives"),
		}
	end

	local progress = Managers.live_event:active_progress()
	local start_from = tier_count - shown_tiers + 1

	while start_from > 1 and progress < tiers[start_from - 1].target do
		start_from = start_from - 1
	end

	local end_at = start_from + shown_tiers - 1

	for i = start_from, end_at do
		local tier = tiers[i]

		configs[#configs + 1] = {
			blueprint = "event_tier",
			target = tier.target,
			rewards = tier.rewards,
		}
	end

	local remaining_tiers = tier_count - end_at

	if remaining_tiers > 0 then
		configs[#configs + 1] = {
			blueprint = "divider",
			text = Localize("loc_tactical_overlay_extra_entries", true, {
				amount = remaining_tiers,
			}),
		}
	end

	self:_create_right_panel_widgets(page_key, configs, ui_renderer)
end

HudElementTacticalOverlay._update_live_event = function (self, dt, ui_renderer)
	local current_live_event_id = self._live_event_id
	local backend_live_event_id = Managers.live_event:active_event_id()
	local show_right_side = self._context.show_right_side
	local wrong_event_id = current_live_event_id ~= backend_live_event_id and backend_live_event_id ~= nil
	local should_create = show_right_side and wrong_event_id

	if should_create then
		self:_setup_live_event(ui_renderer)
	end
end

HudElementTacticalOverlay.reroll_contracts = function (self)
	local contracts_promise = self._contracts_promise

	if contracts_promise and contracts_promise:is_pending() then
		contracts_promise:cancel()
	end

	self:_fetch_task_list()
end

HudElementTacticalOverlay._update_contracts = function (self, dt, ui_renderer)
	local show_right_side = self._context.show_right_side
	local has_data = self._contracts_fetched
	local should_create = show_right_side and has_data

	if should_create then
		self:_setup_contracts(self._contract_data, ui_renderer)

		self._contracts_fetched = false
	end
end

HudElementTacticalOverlay._setup_achievements = function (self, ui_renderer)
	local page_key = "achievements"
	local save_data = Managers.save:account_data()
	local favorite_achievements = save_data.favorite_achievements
	local configs = {}
	local current_achievements = {}

	for i = 1, #favorite_achievements do
		local id = favorite_achievements[i]

		if Managers.achievements:achievement_definition(id) then
			configs[#configs + 1] = {
				blueprint = "achievement",
				id = id,
			}
			current_achievements[i] = id
		end
	end

	self._current_achievements = current_achievements
	self._tracked_achievements = #favorite_achievements

	if #favorite_achievements == 0 then
		self:_delete_right_panel_widgets(page_key, ui_renderer)

		return
	end

	self:_create_right_panel_widgets(page_key, configs, ui_renderer)
end

HudElementTacticalOverlay._update_achievements = function (self, dt, ui_renderer)
	local save_data = Managers.save:account_data()
	local favorite_achievements = save_data.favorite_achievements
	local current_achievements = self._current_achievements
	local has_achievements = current_achievements ~= nil
	local updated_achievements = has_achievements and not table.array_equals(current_achievements, favorite_achievements)
	local show_right_side = self._context.show_right_side
	local should_update = show_right_side and (not has_achievements or updated_achievements)

	if should_update then
		self:_setup_achievements(ui_renderer)
	end
end

HudElementTacticalOverlay._switch_right_grid = function (self, ui_renderer)
	local current_key = self._right_panel_key
	local ordered_names = ElementSettings.right_panel_order
	local current_index = current_key and table.index_of(ordered_names, current_key) or 0

	for delta = 1, #ordered_names do
		local index = current_index + delta

		while index > #ordered_names do
			index = index - #ordered_names
		end

		local key = ordered_names[index]
		local has_entry = self._right_panel_entries[key] ~= nil

		if has_entry and key ~= current_key then
			self:_swap_right_grid(key, ui_renderer)
		end

		if has_entry then
			return
		end
	end

	self._right_panel_key = nil

	self:_update_right_grid_size()
	self:_update_right_tab_bar(ui_renderer)
end

HudElementTacticalOverlay._set_difficulty_icons = function (self, difficulty_value)
	local danger_info_widget = self._widgets_by_name.danger_info
	local visible = difficulty_value ~= 0 and self._context.show_left_side_details

	danger_info_widget.visible = visible

	local danger_info_style = danger_info_widget.style
	local difficulty_icon_style = danger_info_style.difficulty_icon

	difficulty_icon_style.amount = difficulty_value
end

HudElementTacticalOverlay._setup_left_panel_widgets = function (self)
	local definitions = {
		widget_definitions = self._definitions.left_panel_widgets_definitions,
	}

	self._left_panel_widgets = {}

	self:_create_widgets(definitions, self._left_panel_widgets, self._widgets_by_name)
end

HudElementTacticalOverlay._sync_mission_info = function (self)
	local challenge = self._difficulty_manager:get_challenge()

	self:_set_difficulty_icons(challenge)

	local mission_info_widget = self._widgets_by_name.mission_info
	local mission_info_content = mission_info_widget.content
	local mission_info_style = mission_info_widget.style
	local mission = self._mission_manager:mission()
	local mission_name = mission.mission_name
	local type = mission.mission_type
	local mission_type = MissionTypes[type]
	local mission_type_icon = mission_type and mission_type.icon or default_mission_type_icon

	mission_info_content.icon = mission_type_icon
	mission_info_content.mission_name = Utf8.upper(Localize(mission_name))

	local show_mission_type = mission_type and self._context.show_left_side_details

	if show_mission_type then
		local mission_type_name = mission_type.name

		mission_info_content.mission_type = Localize(mission_type_name)
		mission_info_style.mission_name.offset[2] = 15
	else
		mission_info_content.mission_type = ""
		mission_info_style.mission_name.offset[2] = 30
	end
end

HudElementTacticalOverlay._sync_circumstance_info = function (self)
	local circumstance_name = self._circumstance_manager:circumstance_name()
	local circumstance_info_widget = self._widgets_by_name.circumstance_info

	if circumstance_name ~= "default" then
		local circumstance_info_content = circumstance_info_widget.content
		local circumstance_template = CircumstanceTemplates[circumstance_name]

		if not circumstance_template then
			circumstance_info_widget.visible = false

			return
		end

		local circumstance_ui_settings = circumstance_template.ui

		if circumstance_ui_settings then
			local circumstance_icon = circumstance_ui_settings.icon
			local circumstance_display_name = circumstance_ui_settings.display_name
			local circumstance_description = circumstance_ui_settings.description

			circumstance_info_content.icon = circumstance_icon
			circumstance_info_content.circumstance_name = Localize(circumstance_display_name)
			circumstance_info_content.circumstance_description = Localize(circumstance_description)
			circumstance_info_widget.visible = true
		else
			circumstance_info_widget.visible = false
		end
	else
		circumstance_info_widget.visible = false
	end
end

HudElementTacticalOverlay._update_visibility = function (self, dt)
	local draw = self._active
	local alpha_speed = 4
	local alpha_multiplier = self._alpha_multiplier or 0

	if draw then
		alpha_multiplier = math.min(alpha_multiplier + dt * alpha_speed, 1)
	else
		alpha_multiplier = math.max(alpha_multiplier - dt * alpha_speed, 0)
	end

	self._alpha_multiplier = alpha_multiplier
end

HudElementTacticalOverlay._setup_right_panel_widgets = function (self)
	local definitions = {
		widget_definitions = self._definitions.right_panel_widgets_definitions,
	}

	self._right_panel_widgets = {}

	self:_create_widgets(definitions, self._right_panel_widgets, self._widgets_by_name)
	self:_update_right_tab_bar()
end

HudElementTacticalOverlay._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if self._alpha_multiplier ~= 0 then
		local alpha_multiplier = render_settings.alpha_multiplier

		render_settings.alpha_multiplier = self._alpha_multiplier

		HudElementTacticalOverlay.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

		render_settings.alpha_multiplier = alpha_multiplier

		local left_panel_widgets = self._left_panel_widgets
		local num_left_panel_widget = #left_panel_widgets

		for i = 1, num_left_panel_widget do
			local widget = left_panel_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end

		local right_panel_widgets = self._right_panel_widgets
		local num_right_panel_widget = #right_panel_widgets

		for i = 1, num_right_panel_widget do
			local widget = right_panel_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end

		local current_grid_page = self._right_panel_key
		local current_grid = self._right_panel_entries[current_grid_page]
		local current_grid_size = current_grid and #current_grid or 0

		for i = 1, current_grid_size do
			local widget = current_grid[i]

			UIWidget.draw(widget, ui_renderer)
		end

		local tab_bar_widgets = self._tab_bar_widgets
		local tab_bar_widgets_size = tab_bar_widgets and #tab_bar_widgets or 0

		for i = 1, tab_bar_widgets_size do
			local widget = tab_bar_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end
end

HudElementTacticalOverlay._total_materials_collected = function (self, material_type)
	local pickup_system = Managers.state.extension:system("pickup_system")
	local collected_materials = pickup_system:get_collected_materials()
	local small_value = Managers.backend:session_setting("craftingMaterials", material_type, "small", "value")
	local large_value = Managers.backend:session_setting("craftingMaterials", material_type, "large", "value")
	local small_count = collected_materials[material_type] and collected_materials[material_type].small or 0
	local large_count = collected_materials[material_type] and collected_materials[material_type].large or 0

	return small_count * small_value + large_count * large_value
end

HudElementTacticalOverlay._update_materials_collected = function (self)
	local show_details = self._context.show_left_side_details
	local plasteel_info_widget = self._widgets_by_name.plasteel_info
	local plasteel_info_content = plasteel_info_widget.content

	plasteel_info_widget.visible = show_details
	plasteel_info_content.plasteel_amount_id = self:_total_materials_collected("plasteel")

	local diamantine_info_widget = self._widgets_by_name.diamantine_info
	local diamantine_info_content = diamantine_info_widget.content

	diamantine_info_widget.visible = show_details
	diamantine_info_content.diamantine_amount_id = self:_total_materials_collected("diamantine")
end

HudElementTacticalOverlay.on_resolution_modified = function (self)
	local w = RESOLUTION_LOOKUP.width * RESOLUTION_LOOKUP.inverse_scale
	local h = RESOLUTION_LOOKUP.height * RESOLUTION_LOOKUP.inverse_scale

	self:_set_scenegraph_size("background", w, h)
	HudElementTacticalOverlay.super.on_resolution_modified(self)
end

return HudElementTacticalOverlay
