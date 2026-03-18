-- chunkname: @scripts/utilities/valkyrie_aid.lua

local ValkyrieAid = {}

ValkyrieAid.call_attack_aid = function (aid_pos, side_id)
	local safe_dist = math.huge
	local soft_cap_extents = Managers.state.out_of_bounds:soft_cap_extents()

	for i = 1, 3 do
		safe_dist = math.min(safe_dist, soft_cap_extents[i])
	end

	safe_dist = safe_dist - 1

	local flat_pos = Vector3.flat(aid_pos)
	local spawn_pos

	if Vector3.dot(flat_pos, flat_pos) < 0.001 then
		spawn_pos = Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), math.random(0, math.pi * 2)), Vector3.forward()) * safe_dist
	else
		spawn_pos = Vector3.normalize(Vector3.flat(aid_pos)) * safe_dist
	end

	spawn_pos = spawn_pos + Vector3(0, 0, 50)
	spawn_pos[1] = math.clamp(spawn_pos[1], -soft_cap_extents[1] + 1, soft_cap_extents[1] - 1)
	spawn_pos[2] = math.clamp(spawn_pos[2], -soft_cap_extents[2] + 1, soft_cap_extents[2] - 1)
	spawn_pos[3] = math.clamp(spawn_pos[3], -soft_cap_extents[3] + 1, soft_cap_extents[3] - 1)

	local to_target = aid_pos - spawn_pos
	local unit = Managers.state.minion_spawn:spawn_minion("attack_valkyrie", spawn_pos, Quaternion.look(to_target), side_id)

	return unit
end

return ValkyrieAid
