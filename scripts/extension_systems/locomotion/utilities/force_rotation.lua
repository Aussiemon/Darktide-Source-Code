-- chunkname: @scripts/extension_systems/locomotion/utilities/force_rotation.lua

local ForceRotation = {}

ForceRotation.start = function (locomotion_force_rotation_component, locomotion_steering_component, force_rotation, start_rotation, start_time, duration)
	locomotion_force_rotation_component.use_force_rotation = true
	locomotion_steering_component.target_rotation = force_rotation
	locomotion_force_rotation_component.start_rotation = start_rotation
	locomotion_force_rotation_component.start_time = start_time
	locomotion_force_rotation_component.end_time = start_time + duration
end

ForceRotation.get_rotation = function (locomotion_force_rotation_component, locomotion_steering_component, t)
	local start_rotation = locomotion_force_rotation_component.start_rotation
	local force_rotation = locomotion_steering_component.target_rotation
	local start_time = locomotion_force_rotation_component.start_time
	local end_time = locomotion_force_rotation_component.end_time
	local lerp_t = start_time ~= end_time and math.smoothstep(t, start_time, end_time) or 1
	local rotation = Quaternion.lerp(start_rotation, force_rotation, lerp_t)

	return rotation, lerp_t
end

ForceRotation.stop = function (locomotion_force_rotation_component)
	locomotion_force_rotation_component.use_force_rotation = false
end

return ForceRotation
