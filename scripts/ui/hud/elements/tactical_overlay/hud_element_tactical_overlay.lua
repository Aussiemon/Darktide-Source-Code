local Definitions = require("scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay_definitions")
local DangerSettings = require("scripts/settings/difficulty/danger_settings")
local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local MissionTypes = require("scripts/settings/mission/mission_types")
local UIWidget = require("scripts/managers/ui/ui_widget")
local HudElementTacticalOverlay = class("HudElementTacticalOverlay", "HudElementBase")
local default_mission_type_icon = "content/ui/materials/icons/mission_types/mission_type_08"
local default_mission_type_name = "loc_mission_type_default"

HudElementTacticalOverlay.init = function (self, parent, draw_layer, start_scale, definitions)
	HudElementTacticalOverlay.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._difficulty_manager = Managers.state.difficulty
	self._mission_manager = Managers.state.mission
	self._circumstance_manager = Managers.state.circumstance

	self:_setup_left_panel_widgets()
	self:on_resolution_modified()
end

HudElementTacticalOverlay.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementTacticalOverlay.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	local service_type = "Ingame"
	input_service = Managers.input:get_input_service(service_type)
	local active = false

	if input_service:get("tactical_overlay_hold") then
		active = true
	end

	if active and not self._active then
		Managers.event:trigger("event_set_tactical_overlay_state", true)
		self:_sync_mission_info()
		self:_sync_circumstance_info()
		self:_start_animation("enter_left", self._left_panel_widgets)
	elseif self._active and not active then
		Managers.event:trigger("event_set_tactical_overlay_state", false)
		self:_start_animation("exit_left", self._left_panel_widgets)
	end

	self._active = active

	self:_update_visibility(dt)
end

HudElementTacticalOverlay._set_difficulty_icons = function (self, style, difficulty_value)
	local difficulty_icon_style = style.difficulty_icon
	difficulty_icon_style.amount = difficulty_value
end

HudElementTacticalOverlay._setup_left_panel_widgets = function (self)
	local definitions = {
		widget_definitions = self._definitions.left_panel_widgets_definitions
	}
	self._left_panel_widgets = {}

	self:_create_widgets(definitions, self._left_panel_widgets, self._widgets_by_name)
end

HudElementTacticalOverlay._sync_mission_info = function (self)
	local danger_info_widget = self._widgets_by_name.danger_info
	local challenge = self._difficulty_manager:get_challenge()
	local danger_info_style = danger_info_widget.style

	self:_set_difficulty_icons(danger_info_style, challenge)

	local mission_info_widget = self._widgets_by_name.mission_info
	local mission = self._mission_manager:mission()
	local mission_name = mission.mission_name
	local type = mission.mission_type
	local mission_type = MissionTypes[type]
	local mission_info_content = mission_info_widget.content
	local mission_type_name = mission_type and mission_type.name or default_mission_type_name
	local mission_type_icon = mission_type and mission_type.icon or default_mission_type_icon
	mission_info_content.icon = mission_type_icon
	mission_info_content.mission_type = Localize(mission_type_name)
	mission_info_content.mission_name = Utf8.upper(Localize(mission_name))
end

HudElementTacticalOverlay._sync_circumstance_info = function (self)
	local circumstance_name = self._circumstance_manager:circumstance_name()
	local circumstance_info_widget = self._widgets_by_name.circumstance_info
	local resistance = self._difficulty_manager:get_resistance()
	local challenge = self._difficulty_manager:get_challenge()
	local danger = DangerSettings.calculate_danger(challenge, resistance)
	local danger_settings = DangerSettings.by_index[danger]

	if resistance ~= danger_settings.expected_resistance and circumstance_name == "default" then
		if danger_settings.expected_resistance < resistance then
			circumstance_name = "dummy_more_resistance_01"
		else
			circumstance_name = "dummy_less_resistance_01"
		end
	end

	if circumstance_name ~= "default" then
		local circumstance_info_content = circumstance_info_widget.content
		local circumstance_template = CircumstanceTemplates[circumstance_name]

		if not circumstance_template then
			circumstance_info_widget.visible = false

			return
		end

		local circumstance_ui_settings = circumstance_template.ui
		local circumstance_icon = circumstance_ui_settings.icon
		local circumstance_name = circumstance_ui_settings.display_name
		local circumstance_description = circumstance_ui_settings.description
		circumstance_info_content.icon = circumstance_icon
		circumstance_info_content.circumstance_name = Localize(circumstance_name)
		circumstance_info_content.circumstance_description = Localize(circumstance_description)
		circumstance_info_widget.visible = true
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
	end
end

HudElementTacticalOverlay.on_resolution_modified = function (self)
	local w = RESOLUTION_LOOKUP.width * RESOLUTION_LOOKUP.inverse_scale
	local h = RESOLUTION_LOOKUP.height * RESOLUTION_LOOKUP.inverse_scale

	self:_set_scenegraph_size("background", w, h)
	HudElementTacticalOverlay.super.on_resolution_modified(self)
end

return HudElementTacticalOverlay
