local InputDevice = require("scripts/managers/input/input_device")
local SmartTargeting = require("scripts/utilities/smart_targeting")
local AimAssist = {}
local MULTIPLIER_EPSILON = 0.0001
local _aim_assist_multiplier = nil

AimAssist.increase_ramp_multiplier = function (t, aim_assist_ramp_component, ramp_settings)
	if not ramp_settings then
		return
	end

	local multiplier = ramp_settings.ramp_multiplier
	local max_multiplier = ramp_settings.max_ramp_multiplier
	local delay = ramp_settings.ramp_decay_delay or 0
	local current_multiplier = aim_assist_ramp_component.multiplier
	local new_multiplier = math.min(current_multiplier + multiplier, max_multiplier)
	aim_assist_ramp_component.multiplier = new_multiplier
	aim_assist_ramp_component.decay_end_time = t + delay
end

AimAssist.reset_ramp_multiplier = function (aim_assist_ramp_component)
	aim_assist_ramp_component.multiplier = 0
	aim_assist_ramp_component.decay_end_time = 0
end

AimAssist.update_ramp_multiplier = function (dt, t, aim_assist_ramp_component)
	local multiplier = aim_assist_ramp_component.multiplier
	local decay_end_time = aim_assist_ramp_component.decay_end_time

	if decay_end_time <= t then
		multiplier = math.max(multiplier - dt, 0)
		aim_assist_ramp_component.multiplier = multiplier
	end
end

AimAssist.apply_aim_assist = function (main_t, main_dt, input, targeting_data, aim_assist_ramp_component, weapon_action_component, look_yaw, look_pitch, position)
	local last_pressed_device = InputDevice.last_pressed_device
	local gamepad_active = last_pressed_device and last_pressed_device:type() == "xbox_controller"
	local enable_aim_assist = gamepad_active
	enable_aim_assist = enable_aim_assist and targeting_data and not not targeting_data.unit

	if not enable_aim_assist then
		return look_yaw, look_pitch
	end

	local game_t = Managers.time:time("gameplay")
	local smart_targeting_template = SmartTargeting.smart_targeting_template(game_t, weapon_action_component)
	local aim_assist_settings = smart_targeting_template and smart_targeting_template.aim_assist

	if not aim_assist_settings or not aim_assist_settings.always_auto_aim then
		return look_yaw, look_pitch
	end

	local target_rotation = targeting_data.target_rotation:unbox()
	local aim_assist_multiplier = _aim_assist_multiplier(input, aim_assist_ramp_component, aim_assist_settings, gamepad_active)
	local yaw_lerp_t = math.clamp(main_dt * aim_assist_multiplier * 5, 0, 1)
	local pitch_lerp_t = math.clamp(main_dt * aim_assist_multiplier * aim_assist_multiplier * 25, 0, 1)
	local look_yaw_rotation = Quaternion(Vector3.up(), look_yaw)
	local look_pitch_rotation = Quaternion(Vector3.right(), look_pitch)
	local look_rotation = Quaternion.multiply(look_yaw_rotation, look_pitch_rotation)
	local horizontal_lerp = Quaternion.lerp(look_rotation, target_rotation, yaw_lerp_t)
	local vertical_lerp = Quaternion.lerp(look_rotation, target_rotation, pitch_lerp_t)
	local lerp_yaw = Quaternion.yaw(horizontal_lerp)
	local lerp_pitch = Quaternion.pitch(vertical_lerp)

	return lerp_yaw, lerp_pitch
end

function _aim_assist_multiplier(input, aim_assist_ramp_component, aim_assist_settings, gamepad_active)
	local base_multiplier = aim_assist_settings.base_multiplier
	local no_aim_input_multiplier = aim_assist_settings.no_aim_input_multiplier
	local ramp_multiplier = aim_assist_ramp_component.multiplier
	local multiplier = nil
	local input_alias = "look_raw_controller"
	local look_raw = input:get(input_alias)

	if Vector3.length_squared(look_raw) < MULTIPLIER_EPSILON then
		multiplier = math.min(no_aim_input_multiplier + ramp_multiplier, 1)
		local move = input:get("move")

		if Vector3.length_squared(move) < MULTIPLIER_EPSILON then
			multiplier = 0
		end
	end

	multiplier = multiplier or math.min(base_multiplier + ramp_multiplier, 1)

	return multiplier
end

return AimAssist
