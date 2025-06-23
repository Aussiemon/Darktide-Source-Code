-- chunkname: @scripts/ui/hud/elements/damage_indicator/hud_element_damage_indicator.lua

local definition_path = "scripts/ui/hud/elements/damage_indicator/hud_element_damage_indicator_definitions"
local AttackSettings = require("scripts/settings/damage/attack_settings")
local HudElementDamageIndicatorSettings = require("scripts/ui/hud/elements/damage_indicator/hud_element_damage_indicator_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local attack_results = AttackSettings.attack_results
local HudElementDamageIndicator = class("HudElementDamageIndicator", "HudElementBase")

HudElementDamageIndicator.init = function (self, parent, draw_layer, start_scale, definitions)
	local definitions = require(definition_path)

	HudElementDamageIndicator.super.init(self, parent, draw_layer, start_scale, definitions)

	self._indicators = {}
	self._indicator_widget = self:_create_widget("indicator", definitions.indicator_definition)

	Managers.event:register(self, "spawn_hud_damage_indicator", "_spawn_indicator")
end

HudElementDamageIndicator.destroy = function (self, ui_renderer)
	HudElementDamageIndicator.super.destroy(self, ui_renderer)
	Managers.event:unregister(self, "spawn_hud_damage_indicator")
end

HudElementDamageIndicator._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	HudElementDamageIndicator.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
	self:_draw_indicators(dt, t, ui_renderer)
end

HudElementDamageIndicator._get_player_direction_angle = function (self)
	local camera = self._parent:player_camera()

	if not camera then
		return
	end

	local camera_rotation = Camera.local_rotation(camera)
	local camera_forward = Quaternion.forward(camera_rotation)

	camera_forward.z = 0
	camera_forward = Vector3.normalize(camera_forward)

	local camera_right = Vector3.cross(camera_forward, Vector3.up())
	local direction = Vector3.forward()
	local forward_dot_dir = Vector3.dot(camera_forward, direction)
	local right_dot_dir = Vector3.dot(camera_right, -direction)
	local angle = math.atan2(right_dot_dir, forward_dot_dir)

	return angle + math.pi
end

HudElementDamageIndicator._spawn_indicator = function (self, angle, attack_result)
	local t = Managers.ui:get_time()
	local duration = HudElementDamageIndicatorSettings.life_time
	local player_angle = self:_get_player_direction_angle()

	self._indicators[#self._indicators + 1] = {
		angle = player_angle + angle,
		time = t + duration,
		duration = duration,
		attack_result = attack_result
	}
end

HudElementDamageIndicator._draw_indicators = function (self, dt, t, ui_renderer)
	local indicators = self._indicators
	local num_indicators = #indicators

	if num_indicators < 1 then
		return
	end

	local widget = self._indicator_widget
	local widget_offset = widget.offset
	local background_style = widget.style.background
	local background_pivot = background_style.pivot
	local front_style = widget.style.front
	local front_pivot = front_style.pivot
	local center_distance = HudElementDamageIndicatorSettings.center_distance
	local pulse_distance = HudElementDamageIndicatorSettings.pulse_distance
	local pulse_speed_multiplier = HudElementDamageIndicatorSettings.pulse_speed_multiplier
	local size = HudElementDamageIndicatorSettings.size
	local player_angle = self:_get_player_direction_angle()

	for i = num_indicators, 1, -1 do
		local indicator = indicators[i]

		if not indicator then
			return
		end

		local time = indicator.time

		if t <= time then
			local duration = indicator.duration
			local progress = (time - t) / duration
			local anim_progress = math.ease_out_exp(1 - progress)
			local hit_progress = math.clamp(anim_progress * pulse_speed_multiplier, 0, 1)

			widget.alpha_multiplier = progress

			local angle = player_angle - indicator.angle

			background_style.angle = angle
			front_style.angle = angle

			local attack_result = indicator.attack_result
			local indicator_colors_lookup = HudElementDamageIndicatorSettings.indicator_colors_lookup
			local indicator_colors = indicator_colors_lookup[attack_result] or indicator_colors_lookup.default

			background_style.color = indicator_colors.background
			front_style.color = indicator_colors.front

			local distance = center_distance - (pulse_distance - pulse_distance * hit_progress)

			widget_offset[2] = -distance + size[2] * 0.5
			widget_offset[3] = math.min(i, 50)
			background_pivot[2] = distance
			front_pivot[2] = distance

			UIWidget.draw(widget, ui_renderer)
		else
			table.remove(indicators, i)
		end
	end
end

return HudElementDamageIndicator
