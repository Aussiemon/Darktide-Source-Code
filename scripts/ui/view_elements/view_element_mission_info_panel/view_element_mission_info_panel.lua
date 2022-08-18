local Blueprints = require("scripts/ui/view_elements/view_element_mission_info_panel/view_element_mission_info_panel_blueprints")
local Definitions = require("scripts/ui/view_elements/view_element_mission_info_panel/view_element_mission_info_panel_definition")
local MissionBoardSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local MissionInfoPanelStyles = require("scripts/ui/view_elements/view_element_mission_info_panel/view_element_mission_info_panel_styles")
local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local Missions = require("scripts/settings/mission/mission_templates")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local TextUtils = require("scripts/utilities/ui/text")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local Zones = require("scripts/settings/zones/zones")
local STATES = table.enum("none", "status_report", "mission_info", "transition_status_report", "transition_mission_info")
local ViewElementMissionInfoPanel = class("ViewElementMissionInfoPanel", "ViewElementBase")
local _table_clear = table.clear
local _floor = math.floor

local function _format_mission_timer_text(time_left)
	local timer_text = string.format("\ue007 %.2d:%.2d", _floor(time_left / 60) % 60, _floor(time_left) % 60)

	return tostring(timer_text)
end

function _clear_widgets_alpha(widgets)
	for i = 1, #widgets, 1 do
		local widget = widgets[i]
		widget.alpha_multiplier = 0
		widget.visible = false
	end
end

ViewElementMissionInfoPanel.init = function (self, parent, draw_layer, start_scale)
	ViewElementMissionInfoPanel.super.init(self, parent, draw_layer, start_scale, Definitions)

	local widgets = self._widgets
	local mission_header_definition = Definitions.widget_definitions.mission_header
	local old_mission_header = self:_create_widget("old_mission_header", mission_header_definition)
	old_mission_header.offset = {
		0,
		0,
		2
	}
	widgets[#widgets + 1] = old_mission_header
	self._new_mission_data = nil
	self._mission_data = nil
	self._new_happening_data = nil
	self._happening_data = nil
	self._formatted_happening_time_left = ""
	self._active_animation = nil
	self._state = STATES.none
	self._details_list_grid = nil
	self._old_details_list_grid = nil
	self._details_list_widgets = {}
	self._happening_list_widgets = {}
	self._list_widget_definitions = {}

	_clear_widgets_alpha(widgets)

	self._handled_mouse_input = false
	self._old_details_list_widgets = {}
	self._mission_info_animation_params = {
		target_heights = {}
	}
	self._status_report_animation_params = {
		target_heights = {}
	}

	self:_create_offscreen_renderer()
end

ViewElementMissionInfoPanel.destroy = function (self)
	self:_destroy_offscreen_renderer()
	ViewElementMissionInfoPanel.super.destroy(self)
end

ViewElementMissionInfoPanel.update = function (self, dt, t, input_service)
	ViewElementMissionInfoPanel.super.update(self, dt, t, input_service)
	self:_update_state(dt, t, input_service)

	if input_service:get("left_pressed") or input_service:get("right_pressed") then
		local interaction_widget = self._widgets_by_name.list_interaction
		local hotspot = interaction_widget.content.hotspot
		self._handled_mouse_input = hotspot.is_hover
	elseif self._handled_mouse_input then
		self._handled_mouse_input = false
	end
end

ViewElementMissionInfoPanel.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	ViewElementMissionInfoPanel.super.draw(self, dt, t, ui_renderer, render_settings, input_service)

	local widgets = nil
	local state = self._state

	if state == STATES.mission_info or state == STATES.transition_mission_info then
		widgets = self._details_list_widgets
	elseif state == STATES.status_report or state == STATES.transition_status_report then
		widgets = self._happening_list_widgets
	end

	if widgets then
		local offscreen_renderer = self._offscreen_renderer
		local grid = self._details_list_grid
		local old_grid = self._old_details_list_grid
		local old_widgets = self._old_details_list_widgets

		UIRenderer.begin_pass(offscreen_renderer, self._ui_scenegraph, input_service, dt, render_settings)

		if old_grid then
			self:_draw_list_widgets(old_grid, old_widgets, offscreen_renderer)
		end

		self:_draw_list_widgets(grid, widgets, offscreen_renderer)
		UIRenderer.end_pass(offscreen_renderer)
	end
end

ViewElementMissionInfoPanel.set_active_mission = function (self, new_mission_data, play_callback)
	local current_mission_data = self._mission_data

	if current_mission_data == new_mission_data then
		local next_mission = self._new_mission_data

		return not next_mission or next_mission == new_mission_data
	end

	self._new_mission_data = new_mission_data or StrictNil
	self._play_callback = play_callback

	return true
end

ViewElementMissionInfoPanel.set_report_data = function (self, happening_data)
	if happening_data ~= self._happening_data then
		self._new_happening_data = happening_data
	end
end

ViewElementMissionInfoPanel.has_handled_mouse_input = function (self)
	return self._handled_mouse_input
end

ViewElementMissionInfoPanel.formatted_happening_time_left = function (self)
	return self._formatted_happening_time_left
end

ViewElementMissionInfoPanel._cb_animation_complete = function (self, state)
	if state == STATES.none or state == STATES.status_report then
		self._clear_mission_data_flag = true
	end

	self:_set_state(state)

	self._active_animation = nil
	self._widgets_by_name.old_mission_header.visible = false
	self._old_details_list_grid = nil

	_table_clear(self._old_details_list_widgets)
end

ViewElementMissionInfoPanel._set_state = function (self, state)
	self._state = state
	self._widgets_by_name.play_button.content.hotspot.disabled = state ~= STATES.mission_info or self._mission_data.flags.locked
end

ViewElementMissionInfoPanel._create_offscreen_renderer = function (self)
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
		renderer_name = renderer_name
	}
end

ViewElementMissionInfoPanel._destroy_offscreen_renderer = function (self)
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

ViewElementMissionInfoPanel._setup_list_grid = function (self, widgets, alignment_widgets)
	local grid_scenegraph_id = "info_area_content"
	local interaction_scenegraph_id = "panel"
	local grid_direction = "down"
	local details_list_grid = UIWidgetGrid:new(widgets, alignment_widgets, self._ui_scenegraph, grid_scenegraph_id, grid_direction)
	local scrollbar_widget = self._widgets_by_name.panel_scrollbar
	scrollbar_widget.content.value = 0
	scrollbar_widget.content.scroll_value = nil

	details_list_grid:assign_scrollbar(scrollbar_widget, grid_scenegraph_id, interaction_scenegraph_id)

	self._old_details_list_grid = self._details_list_grid
	self._details_list_grid = details_list_grid

	return details_list_grid:length()
end

ViewElementMissionInfoPanel._create_list_widgets = function (self, content, num_items, widget_list, alignment_list)
	local scenegraph_id = "info_area_content"
	local blueprint_templates = Blueprints.templates
	local widget_definitions = self._list_widget_definitions
	local counter = self

	_table_clear(widget_list)
	_table_clear(alignment_list)

	local ui_renderer = self._offscreen_renderer

	for i = 1, num_items, 1 do
		local entry = content[i]
		local template_name = entry.template
		local template = blueprint_templates[template_name]

		fassert(template, "[MissionBoardDetailsView] - Could not find content blueprint for: %s", template_name)

		local widget_definition = widget_definitions[template_name]

		if not widget_definition and template.pass_template then
			widget_definition = UIWidget.create_definition(template.pass_template, scenegraph_id, nil, template.size, template.style)
			widget_definitions[template_name] = widget_definition
		end

		local alignment_widget = nil

		if widget_definition then
			local widget_name = scenegraph_id .. "_widget_" .. i
			local widget = UIWidget.init(widget_name, widget_definition)

			if template.init then
				template.init(widget, entry.widget_data, ui_renderer)
			end

			widget_list[#widget_list + 1] = widget
			alignment_widget = widget
		else
			alignment_widget = {
				size = {
					template.size[1],
					template.size[2]
				}
			}
		end

		alignment_list[#alignment_list + 1] = alignment_widget
	end
end

ViewElementMissionInfoPanel._clear_mission_data = function (self)
	local header_widget = self._widgets_by_name.mission_header
	local content = header_widget.content
	content.mission_title = ""
	content.type_and_zone = ""
	content.time_left = ""

	_table_clear(self._details_list_widgets)

	self._mission_data = nil
end

ViewElementMissionInfoPanel._draw_list_widgets = function (self, grid, widgets, ui_renderer)
	grid = self._details_list_grid

	for i = 1, #widgets, 1 do
		local widget = widgets[i]

		if grid:is_widget_visible(widget) then
			UIWidget.draw(widget, ui_renderer)
		end
	end
end

ViewElementMissionInfoPanel._update_state = function (self, dt, t, input_service)
	local state = self._state

	if state == STATES.mission_info then
		self:_update_state_mission(dt, t, input_service)
	elseif state == STATES.status_report then
		self:_update_status_report(dt, t, input_service)
	elseif state == STATES.none then
		self:_update_state_none(dt, t, input_service)
	end
end

ViewElementMissionInfoPanel._update_state_none = function (self, dt, t, input_service)
	local happening_data = self._new_happening_data or self._happening_data
	local new_mission_data = self._new_mission_data

	if self._clear_mission_data_flag then
		self._clear_mission_data_flag = false

		self:_clear_mission_data()
	elseif new_mission_data then
		if new_mission_data ~= StrictNil then
			self:_transition_to_state_mission_info(self._new_mission_data)
		end

		self._new_mission_data = nil
	elseif happening_data then
		self._new_happening_data = nil

		self:_transition_to_state_status_report(happening_data)
		self:_update_formatted_time(t)
	end
end

local _retract_window_animation_params = {}

ViewElementMissionInfoPanel._transition_to_state_none = function (self)
	local retract_window_animation_params = _retract_window_animation_params
	local current_state = self._state
	local next_state = (current_state == STATES.mission_info and STATES.transition_mission_info) or STATES.transition_status_report
	retract_window_animation_params.from_state = current_state
	self._active_animation = self:_start_animation("retract_window", nil, retract_window_animation_params, callback(self, "_cb_animation_complete", STATES.none))

	self:_set_state(next_state)
end

local _formatted_time_params = {}

ViewElementMissionInfoPanel._update_status_report = function (self, dt, t, input_service)
	if self._clear_mission_data_flag then
		self._clear_mission_data_flag = false

		self:_clear_mission_data()
	elseif self._new_mission_data or not self._happening_data then
		self:_transition_to_state_none()

		return
	elseif self._new_happening_data then
		local happening_data = self._new_happening_data
		self._new_happening_data = nil

		self:_transition_to_state_status_report(happening_data, t)
	end

	self:_update_formatted_time(t)

	local grid = self._details_list_grid

	grid:update(dt, t, input_service)
end

local _happening_list_alignments = {}

ViewElementMissionInfoPanel._transition_to_state_status_report = function (self, happening_data)
	local list_widgets = self._happening_list_widgets
	local happening_list_alignments = _happening_list_alignments

	if happening_data ~= self._happening_data then
		_table_clear(list_widgets)
		_table_clear(happening_list_alignments)

		local time_left_function = callback(self, "formatted_happening_time_left")
		local happening_list, num_items = Blueprints.utility_functions.prepare_report_data(happening_data, time_left_function)

		self:_create_list_widgets(happening_list, num_items, list_widgets, happening_list_alignments)

		self._happening_list_widgets = list_widgets
		self._happening_data = happening_data
	end

	local grid_height = self:_setup_list_grid(list_widgets, happening_list_alignments)
	local panel_styles = MissionInfoPanelStyles.panel
	local target_panel_height = math.clamp(grid_height, panel_styles.default_size[2], panel_styles.max_size[2])
	local status_report_animation_params = self._status_report_animation_params
	status_report_animation_params.is_event = happening_data.name and string.len(happening_data.name) > 1
	local target_heights = status_report_animation_params.target_heights
	target_heights.panel = target_panel_height
	target_heights.list_mask = target_panel_height
	target_heights.panel_scrollbar = target_panel_height + MissionInfoPanelStyles.panel.scroll_bar.height_addition
	self._active_animation = self:_start_animation("resize_report_window", nil, status_report_animation_params, callback(self, "_cb_animation_complete", STATES.status_report))

	self:_set_state(STATES.transition_status_report)
end

ViewElementMissionInfoPanel._update_formatted_time = function (self, t)
	local happening_data = self._happening_data
	local expiry_time = happening_data.expiry_game_time
	local time_left = expiry_time - t
	_formatted_time_params.time_left = TextUtils.format_time_span_long_form_localized(math.max(time_left, 0))
	self._formatted_happening_time_left = Localize("loc_mission_board_event_panel_time_left", true, _formatted_time_params)
end

ViewElementMissionInfoPanel._update_state_mission = function (self, dt, t, input_service)
	local new_mission_data = self._new_mission_data

	if new_mission_data then
		self._new_mission_data = nil

		if new_mission_data ~= StrictNil then
			self:_transition_to_state_mission_info(new_mission_data)
		else
			self:_transition_to_state_none()

			return
		end
	end

	local expiry_time = self._mission_data.expiry_game_time
	local time_left = expiry_time - t
	local formatted_time = _format_mission_timer_text(math.max(time_left, 0))
	local header_widget = self._widgets_by_name.mission_header
	header_widget.content.time_left = formatted_time
	local grid = self._details_list_grid

	grid:update(dt, t, input_service)
end

local _list_alignments = {}
local _banner_text_params = {}

ViewElementMissionInfoPanel._transition_to_state_mission_info = function (self, mission_data)
	self._mission_data = mission_data
	local new_list_widgets = self._old_details_list_widgets
	local old_list_widgets = self._details_list_widgets
	self._old_details_list_widgets = old_list_widgets

	assert(#new_list_widgets == 0)

	local list_alignments = _list_alignments

	_table_clear(list_alignments)

	local widgets_by_name = self._widgets_by_name
	local map_data = Missions[mission_data.map]
	local zone_data = Zones[map_data.zone_id]
	local main_objective_type_key = (map_data.objectives and MissionObjectiveTemplates[map_data.objectives].main_objective_type) or "default"
	local main_objective_type_name = MissionBoardSettings.main_objective_type_name[main_objective_type_key]
	local type_name = TextUtils.localize_to_title_case(main_objective_type_name)
	local zone_name = TextUtils.localize_to_title_case(zone_data.name)
	local old_header_widget = widgets_by_name.old_mission_header
	local new_header_content = old_header_widget.content
	local header_widget = widgets_by_name.mission_header
	old_header_widget.content = header_widget.content
	header_widget.content = new_header_content
	new_header_content.mission_title = (map_data.mission_name and TextUtils.localize_to_title_case(map_data.mission_name)) or mission_data.map
	new_header_content.type_and_zone = string.format("%s · %s", type_name, zone_name)

	if zone_data.images then
		new_header_content.zone_image = zone_data.images.mission_board_details
	end

	local mission_flags = mission_data.flags

	if mission_flags.locked then
		local banner_widget = widgets_by_name.header_banner
		_banner_text_params.required_level = mission_data.required_level
		banner_widget.content.text = Localize("loc_mission_board_view_required_level", true, _banner_text_params)
	end

	local details_list, num_items = Blueprints.utility_functions.prepare_details_data(mission_data, map_data)

	self:_create_list_widgets(details_list, num_items, new_list_widgets, list_alignments)

	local grid_height = self:_setup_list_grid(new_list_widgets, list_alignments)

	_clear_widgets_alpha(new_list_widgets)

	self._details_list_widgets = new_list_widgets
	local play_button = widgets_by_name.play_button
	local play_button_hotspot = play_button.content.hotspot
	play_button_hotspot.pressed_callback = self._play_callback
	play_button_hotspot.is_focused = self._play_callback ~= true
	local panel_styles = MissionInfoPanelStyles.panel
	local total_panel_height = header_widget.style.size[2] + grid_height
	total_panel_height = math.clamp(total_panel_height, panel_styles.default_size[2], panel_styles.max_size[2])
	local panel_header_height = MissionInfoPanelStyles.panel_header.size[2]
	local list_mask_height = total_panel_height - panel_header_height
	local mission_info_animation_params = self._mission_info_animation_params

	if self._state == STATES.mission_info then
		old_header_widget.visible = header_widget.visible
		old_header_widget.alpha_multiplier = header_widget.alpha_multiplier
		mission_info_animation_params.old_header_widget = old_header_widget
	end

	mission_info_animation_params.flags = mission_flags
	mission_info_animation_params.old_details_list_widgets = old_list_widgets
	mission_info_animation_params.new_details_list_widgets = new_list_widgets
	local target_heights = mission_info_animation_params.target_heights
	target_heights.panel = total_panel_height
	target_heights.panel_header = panel_header_height
	target_heights.list_mask = list_mask_height
	target_heights.panel_scrollbar = total_panel_height + MissionInfoPanelStyles.panel.scroll_bar.height_addition
	self._active_animation = self:_start_animation("resize_mission_window", nil, mission_info_animation_params, callback(self, "_cb_animation_complete", STATES.mission_info))

	self:_set_state(STATES.transition_mission_info)
end

return ViewElementMissionInfoPanel
