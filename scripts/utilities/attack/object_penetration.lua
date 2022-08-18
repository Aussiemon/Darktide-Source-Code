-- Decompilation Error: _run_step(_unwarp_expressions, node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
local ObjectPenetration = {}
local STEP_DISTANCE = 0.5

ObjectPenetration.test_for_penetration = function (physics_world, entry_position, direction, depth)
	local step_hit = nil
	local steps_taken = 0

	repeat

		-- Decompilation error in this vicinity:
		local cast_pos = entry_position + direction * STEP_DISTANCE * steps_taken
		step_hit = PhysicsWorld.raycast(physics_world, cast_pos, direction, STEP_DISTANCE, "any", "types", "statics", "collision_filter", "filter_player_character_shooting_statics")
		steps_taken = steps_taken + 1

		break
	until not step_hit

	local exit_position, exit_normal, exit_unit = nil

	if not step_hit and steps_taken > 0 then
		local cast_pos = entry_position + direction * STEP_DISTANCE * steps_taken
		local hit, position, _, normal, hit_actor = PhysicsWorld.raycast(physics_world, cast_pos, -direction, STEP_DISTANCE * steps_taken, "closest", "types", "statics", "collision_filter", "filter_player_character_shooting_statics")

		if hit then
			exit_position = position
			exit_normal = normal
			exit_unit = Actor.unit(hit_actor)
		end
	end

	return exit_position, exit_normal, exit_unit
end

return ObjectPenetration
