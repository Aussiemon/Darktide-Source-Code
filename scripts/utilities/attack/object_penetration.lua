-- chunkname: @scripts/utilities/attack/object_penetration.lua

local ObjectPenetration = {}
local STEP_DISTANCE = 0.5

ObjectPenetration.test_for_penetration = function (physics_world, entry_position, direction, depth)
	local step_hit
	local steps_taken = 0
	local step_distance = math.min(depth * 0.75, STEP_DISTANCE)

	repeat
		local cast_pos = entry_position + direction * (step_distance * steps_taken)

		step_hit = PhysicsWorld.raycast(physics_world, cast_pos, direction, step_distance, "any", "types", "statics", "collision_filter", "filter_player_character_shooting_raycast_statics")
		steps_taken = steps_taken + 1

		if depth < steps_taken * step_distance then
			break
		end
	until not step_hit

	local exit_position, exit_normal, exit_unit

	if not step_hit and steps_taken > 0 then
		local cast_pos = entry_position + direction * step_distance * steps_taken
		local hit, position, _, normal, hit_actor = PhysicsWorld.raycast(physics_world, cast_pos, -direction, step_distance * steps_taken, "closest", "types", "statics", "collision_filter", "filter_player_character_shooting_raycast_statics")

		if hit then
			exit_position = position
			exit_normal = normal
			exit_unit = Actor.unit(hit_actor)
		end
	end

	return exit_position, exit_normal, exit_unit
end

return ObjectPenetration
