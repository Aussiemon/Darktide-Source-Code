-- chunkname: @scripts/utilities/animation.lua

local Animation = {}

Animation.random_event = function (event, seed)
	if type(event) == "table" then
		local index

		if seed then
			seed, index = math.next_random(seed, 1, #event)
		else
			index = math.random(1, #event)
		end

		return event[index], seed
	else
		return event, seed
	end
end

Animation.calculate_anim_rotation_scale = function (unit, target_pos, rotation_sign, rotation_radians)
	local unit_pos = POSITION_LOOKUP[unit]
	local unit_rot = Unit.local_rotation(unit, 1)
	local forward_dir = Quaternion.forward(unit_rot)
	local target_dir = Vector3.normalize(target_pos - unit_pos)
	local unit_rot_radians = math.atan2(forward_dir.y, forward_dir.x)
	local target_rot_radians = math.atan2(target_dir.y, target_dir.x)
	local unit_to_target_rot_radians = target_rot_radians - unit_rot_radians

	unit_to_target_rot_radians = unit_to_target_rot_radians * rotation_sign

	if unit_to_target_rot_radians < 0 then
		unit_to_target_rot_radians = unit_to_target_rot_radians + 2 * math.pi
	end

	local rotation_scale = unit_to_target_rot_radians / rotation_radians

	return rotation_scale
end

return Animation
