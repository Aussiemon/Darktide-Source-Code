local ObjectPenetration = {}
local STEP_DISTANCE = 0.5

ObjectPenetration.test_for_penetration = function (physics_world, entry_position, direction, depth)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-7, warpins: 1 ---
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 8-8, warpins: 2 ---
	local step_hit = nil
	local steps_taken = 0
	local step_distance = math.min(depth * 0.75, STEP_DISTANCE)
	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #2 9-28, warpins: 1 ---
	local cast_pos = entry_position + direction * step_distance * steps_taken
	step_hit = PhysicsWorld.raycast(physics_world, cast_pos, direction, step_distance, "any", "types", "statics", "collision_filter", "filter_player_character_shooting_raycast_statics")
	steps_taken = steps_taken + 1

	--- END OF BLOCK #2 ---

	if depth < steps_taken * step_distance then
	JUMP TO BLOCK #3
	else
	JUMP TO BLOCK #4
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #3 29-29, warpins: 1 ---
	break

	--- END OF BLOCK #3 ---




	-- Decompilation error in this vicinity:
	--- BLOCK #4 30-31, warpins: 1 ---
	--- END OF BLOCK #4 ---

	slot4 = if not step_hit then
	JUMP TO BLOCK #5
	else
	JUMP TO BLOCK #1
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #5 32-34, warpins: 2 ---
	local exit_position, exit_normal, exit_unit = nil
	--- END OF BLOCK #5 ---

	slot4 = if not step_hit then
	JUMP TO BLOCK #6
	else
	JUMP TO BLOCK #9
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #6 35-37, warpins: 1 ---
	--- END OF BLOCK #6 ---

	if steps_taken > 0 then
	JUMP TO BLOCK #7
	else
	JUMP TO BLOCK #9
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #7 38-54, warpins: 1 ---
	local cast_pos = entry_position + direction * step_distance * steps_taken
	local hit, position, _, normal, hit_actor = PhysicsWorld.raycast(physics_world, cast_pos, -direction, step_distance * steps_taken, "closest", "types", "statics", "collision_filter", "filter_player_character_shooting_raycast_statics")
	--- END OF BLOCK #7 ---

	slot11 = if hit then
	JUMP TO BLOCK #8
	else
	JUMP TO BLOCK #9
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #8 55-61, warpins: 1 ---
	exit_position = position
	exit_normal = normal
	exit_unit = Actor.unit(hit_actor)

	--- END OF BLOCK #8 ---

	FLOW; TARGET BLOCK #9



	-- Decompilation error in this vicinity:
	--- BLOCK #9 62-65, warpins: 4 ---
	return exit_position, exit_normal, exit_unit
	--- END OF BLOCK #9 ---



end

return ObjectPenetration
