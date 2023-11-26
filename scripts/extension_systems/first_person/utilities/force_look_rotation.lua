-- chunkname: @scripts/extension_systems/first_person/utilities/force_look_rotation.lua

local FixedFrame = require("scripts/utilities/fixed_frame")
local ForceLookRotation = {}

ForceLookRotation.start = function (force_look_rotation_component, current_rotation, wanted_pitch, wanted_yaw, start_time, duration)
	local yaw, pitch, _ = Quaternion.to_yaw_pitch_roll(current_rotation)

	force_look_rotation_component.use_force_look_rotation = true
	force_look_rotation_component.start_yaw = yaw
	force_look_rotation_component.start_pitch = pitch
	force_look_rotation_component.wanted_yaw = wanted_yaw
	force_look_rotation_component.wanted_pitch = wanted_pitch
	force_look_rotation_component.start_time = start_time
	force_look_rotation_component.end_time = FixedFrame.clamp_to_fixed_time(start_time + duration)
end

ForceLookRotation.yaw_pitch_offset = function (force_look_rotation_component)
	local use_force_look_rotation = force_look_rotation_component.use_force_look_rotation

	if not use_force_look_rotation then
		return 0, 0
	end

	local start_time = force_look_rotation_component.start_time
	local end_time = force_look_rotation_component.end_time
	local start_yaw = force_look_rotation_component.start_yaw
	local start_pitch = force_look_rotation_component.start_pitch
	local wanted_yaw = force_look_rotation_component.wanted_yaw
	local wanted_pitch = force_look_rotation_component.wanted_pitch
	local t = Managers.time:time("gameplay")
	local dt = Managers.time:delta_time("gameplay")
	local lerp_t = math.smoothstep(t, start_time, end_time)

	lerp_t = math.ease_out_exp(lerp_t)

	local yaw_override = math.lerp(start_yaw, start_yaw + wanted_yaw, lerp_t) - start_yaw
	local pitch_override = math.lerp(start_pitch, start_pitch + wanted_pitch, lerp_t) - start_pitch

	return yaw_override * dt, pitch_override * dt
end

ForceLookRotation.stop = function (force_look_rotation_component)
	force_look_rotation_component.use_force_look_rotation = false
	force_look_rotation_component.start_yaw = 0
	force_look_rotation_component.start_pitch = 0
	force_look_rotation_component.wanted_pitch = 0
	force_look_rotation_component.wanted_yaw = 0
	force_look_rotation_component.start_time = 0
	force_look_rotation_component.end_time = 0
end

return ForceLookRotation
