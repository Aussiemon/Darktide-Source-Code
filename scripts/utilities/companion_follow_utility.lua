-- chunkname: @scripts/utilities/companion_follow_utility.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local CompanionDogSettings = require("scripts/utilities/companion/companion_dog_settings")
local NavQueries = require("scripts/utilities/nav_queries")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local CompanionFollowUtility = {}
local MOVEMENT_DIRECTION = table.enum("none", "right", "left")
local valid_prioritized_positions = {}

CompanionFollowUtility.companion_has_follow_position = function (unit, blackboard, scratchpad, condition_args, action_data, is_running, dt)
	local follow_component = Blackboard.write_component(blackboard, "follow")
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local locomotion_extension = ScriptUnit.extension(blackboard.behavior.owner_unit, "locomotion_system")
	local dog_owner_follow_config, dog_forward_follow_config, dog_lrb_follow_config = action_data.dog_owner_follow_config, action_data.dog_forward_follow_config, action_data.dog_lrb_follow_config

	if follow_component.current_movement_type == "none" then
		follow_component.speed_reference = 0
	end

	local gameplay_time = Managers.time:time("gameplay")

	if (follow_component.current_adaptive_angle_check_left > 0 or follow_component.current_adaptive_angle_check_right > 0) and gameplay_time > follow_component.adaptive_angle_enlarge_t then
		follow_component.current_adaptive_angle_check_left = math.max(follow_component.current_adaptive_angle_check_left - 1, 0)
		follow_component.current_adaptive_angle_check_right = math.max(follow_component.current_adaptive_angle_check_right - 1, 0)
		follow_component.adaptive_angle_enlarge_t = gameplay_time + dog_forward_follow_config.seconds_to_enlarge_adaptive_angle
	end

	local movement_vector

	if follow_component.current_position_cooldown ~= -1 then
		local t = Managers.time:time("gameplay")

		if t <= follow_component.current_position_cooldown then
			return is_running and behavior_component.has_move_to_position or false
		else
			follow_component.current_position_cooldown = -1
		end
	end

	local current_owner_cooldown = blackboard.follow.current_owner_cooldown
	local found_position = false
	local current_scratchpad
	local owner_unit_data_extension = ScriptUnit.extension(behavior_component.owner_unit, "unit_data_system")

	if current_owner_cooldown == -1 then
		current_scratchpad = CompanionFollowUtility._create_scratchpad_follow_flrb(unit, blackboard, scratchpad, condition_args, action_data, is_running, dt)

		if CompanionFollowUtility._owner_has_forward_velocity(unit, blackboard, scratchpad, condition_args, action_data, is_running) then
			behavior_component.should_skip_start_anim = false
			current_scratchpad.follow_config = dog_forward_follow_config
			movement_vector = Vector3.flat(locomotion_extension:current_velocity())

			if follow_component.current_movement_type ~= "forward" then
				follow_component.last_referenced_vector:store(movement_vector)
			end

			follow_component.current_movement_type = "forward"
		else
			if action_data.override_lrb_to_use_owner_speed then
				current_scratchpad.follow_config = dog_lrb_follow_config
				movement_vector = Vector3.flat(locomotion_extension:current_velocity())
			else
				behavior_component.should_skip_start_anim = true
				current_scratchpad.follow_config = dog_lrb_follow_config

				local first_person = owner_unit_data_extension:read_component("first_person")
				local look_rotation = first_person.rotation

				movement_vector = Vector3.normalize(Vector3.flat(Quaternion.forward(look_rotation)))
			end

			if follow_component.current_movement_type ~= "lrb" then
				follow_component.last_referenced_vector:store(movement_vector)
			end

			follow_component.current_movement_type = "lrb"
		end

		current_scratchpad.max_angle_per_check = current_scratchpad.follow_config.max_angle_per_second * action_data.reset_position_timer

		local sprint_character_state_component = owner_unit_data_extension:read_component("sprint_character_state")

		if not Sprint.is_in_start_slowdown(behavior_component.owner_unit, sprint_character_state_component) then
			follow_component.speed_reference = Vector3.length(movement_vector)
		end

		found_position = CompanionFollowUtility.calculate_flrb_position(unit, current_scratchpad, dt, movement_vector, action_data)
	end

	if not found_position and follow_component.current_movement_type == "lrb" then
		if action_data.override_lrb_to_use_owner_speed then
			follow_component.current_movement_type = "none"
		else
			current_scratchpad = CompanionFollowUtility._create_scratchpad_follow_owner(unit, blackboard, scratchpad, condition_args, action_data, is_running)
			current_scratchpad.follow_config = dog_owner_follow_config
			found_position = CompanionFollowUtility.calculate_follow_owner_position(unit, blackboard, current_scratchpad, condition_args, action_data, is_running, dt)

			if found_position then
				follow_component.current_movement_type = "owner"
			else
				follow_component.current_movement_type = "none"
			end
		end
	end

	if not found_position and follow_component.current_movement_type == "forward" then
		follow_component.current_movement_type = "none"
	end

	local t = Managers.time:time("gameplay")

	follow_component.current_position_cooldown = t + action_data.reset_position_timer

	return found_position
end

CompanionFollowUtility.companion_has_position_around_owner = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local current_scratchpad = CompanionFollowUtility._create_scratchpad_follow_owner(unit, blackboard, scratchpad, condition_args, action_data, is_running)

	return CompanionFollowUtility._calculate_position_around_owner(unit, current_scratchpad, action_data) ~= nil
end

CompanionFollowUtility.calculate_flrb_position = function (unit, scratchpad, dt, velocity, action_data)
	local behavior_component = scratchpad.behavior_component
	local follow_component = scratchpad.follow_component
	local self_position, move_to_position = POSITION_LOOKUP[unit], behavior_component.move_to_position:unbox()
	local current_direction, new_position_calculated
	local owner_unit = behavior_component.owner_unit
	local last_referenced_vector = follow_component.last_referenced_vector:unbox()
	local angle_between_velocities = Vector3.angle(last_referenced_vector, velocity, true)

	if math.radians_to_degrees(angle_between_velocities) > scratchpad.max_angle_per_check then
		local rotation = CompanionFollowUtility._calculate_rotation_given_velocities(scratchpad, velocity)
		local new_stored_velocity = Quaternion.rotate(rotation, last_referenced_vector)

		follow_component.last_referenced_vector:store(new_stored_velocity)

		move_to_position, current_direction, new_position_calculated = CompanionFollowUtility._calculate_new_flrb_position(owner_unit, unit, new_stored_velocity, scratchpad.follow_config, scratchpad.locomotion_extension:current_velocity(), scratchpad.last_direction, scratchpad, action_data)
	else
		follow_component.last_referenced_vector:store(velocity)

		move_to_position, current_direction, new_position_calculated = CompanionFollowUtility._calculate_new_flrb_position(owner_unit, unit, velocity, scratchpad.follow_config, scratchpad.locomotion_extension:current_velocity(), scratchpad.last_direction, scratchpad, action_data)
	end

	if move_to_position then
		behavior_component.move_to_position:store(move_to_position)

		behavior_component.has_move_to_position = true

		local owner_unit_position = POSITION_LOOKUP[behavior_component.owner_unit]
		local follow_aim_entry = CompanionFollowUtility.follow_aim_entry(scratchpad, action_data, velocity)
		local aim_target_position = follow_aim_entry == "player" and owner_unit_position or move_to_position

		CompanionFollowUtility.set_up_aim_target(unit, scratchpad, aim_target_position)
	end

	return new_position_calculated
end

CompanionFollowUtility._calculate_new_flrb_position = function (owner_unit, companion_unit, current_velocity, follow_config, companion_velocity, current_movement_direction, scratchpad, action_data)
	local initial_position = POSITION_LOOKUP[owner_unit]
	local normalized_velocity = Vector3.normalize(current_velocity)
	local speed_length = scratchpad.follow_component.speed_reference
	local speed_length_normalized = math.normalize_01(speed_length, follow_config.min_owner_speed, follow_config.max_owner_speed)
	local speed_length_normalized_for_angle = 1 - speed_length_normalized
	local current_move_to_position = scratchpad.behavior_component.move_to_position:unbox()
	local companion_position = current_move_to_position + companion_velocity * follow_config.seconds_for_movement_prediction
	local follow_component = scratchpad.follow_component
	local current_adaptive_angle_check_left = follow_component.current_adaptive_angle_check_left
	local current_adaptive_angle_check_right = follow_component.current_adaptive_angle_check_right
	local numbers_of_adaptive_angle_checks = follow_config.numbers_of_adaptive_angle_checks
	local has_found_left_angle, has_found_right_angle, has_left_hit, has_right_hit = false, false, false, false
	local left_position, right_position = Vector3.zero(), Vector3.zero()

	while true do
		local min_angle_left, max_angle_left, min_angle_right, max_angle_right = CompanionFollowUtility.get_max_front_side_angle(scratchpad, nil, follow_config)
		local movement_angle_left = math.degrees_to_radians(math.lerp(min_angle_left, max_angle_left, speed_length_normalized_for_angle))
		local movement_angle_right = math.degrees_to_radians(math.lerp(min_angle_right, max_angle_right, speed_length_normalized_for_angle))
		local left_rotation = Quaternion(Vector3.up(), movement_angle_left)
		local right_rotation = Quaternion(Vector3.up(), -movement_angle_right)
		local inner_circle_distance = math.lerp(follow_config.inner_circle_min_distance, follow_config.inner_circle_max_distance, speed_length_normalized)
		local outer_circle_distance = math.lerp(follow_config.outer_circle_min_distance, follow_config.outer_circle_max_distance, speed_length_normalized)
		local distance_offset = (outer_circle_distance - inner_circle_distance) * 0.5
		local distance = inner_circle_distance + distance_offset
		local left_vector = Vector3.normalize(Quaternion.rotate(left_rotation, normalized_velocity)) * distance

		left_position = not has_found_left_angle and left_vector + initial_position or left_position

		local right_vector = Vector3.normalize(Quaternion.rotate(right_rotation, normalized_velocity)) * distance

		right_position = not has_found_right_angle and right_vector + initial_position or right_position

		local temp_has_left_hit, temp_has_right_hit = CompanionFollowUtility._ray_trace_movement_check(scratchpad, initial_position, left_position, right_position)

		if not has_found_left_angle then
			has_left_hit = temp_has_left_hit
		end

		if not has_found_right_angle then
			has_right_hit = temp_has_right_hit
		end

		if not has_left_hit or not has_right_hit then
			local nav_distances = {
				4,
				4,
				0.25,
				0,
			}
			local new_positions_after_check = CompanionFollowUtility._look_for_valid_position(owner_unit, action_data, scratchpad, not has_left_hit, not has_right_hit, left_position, right_position, nav_distances)
			local size = table.size(new_positions_after_check)

			if size > 0 then
				has_found_left_angle = has_found_left_angle or new_positions_after_check.first_position ~= nil
				has_found_right_angle = has_found_right_angle or new_positions_after_check.second_position ~= nil
			end
		end

		local should_continue = numbers_of_adaptive_angle_checks and current_adaptive_angle_check_left < numbers_of_adaptive_angle_checks and current_adaptive_angle_check_right < numbers_of_adaptive_angle_checks

		if has_found_left_angle and has_found_right_angle then
			break
		elseif not numbers_of_adaptive_angle_checks then
			return nil, nil, false
		elseif should_continue then
			current_adaptive_angle_check_left = not has_found_left_angle and math.clamp(current_adaptive_angle_check_left + 1, 0, numbers_of_adaptive_angle_checks) or current_adaptive_angle_check_left
			current_adaptive_angle_check_right = not has_found_right_angle and math.clamp(current_adaptive_angle_check_right + 1, 0, numbers_of_adaptive_angle_checks) or current_adaptive_angle_check_right
			follow_component.current_adaptive_angle_check_left = current_adaptive_angle_check_left
			follow_component.current_adaptive_angle_check_right = current_adaptive_angle_check_right

			local gameplay_time = Managers.time:time("gameplay")

			follow_component.adaptive_angle_enlarge_t = gameplay_time + follow_config.seconds_to_enlarge_adaptive_angle
		elseif not should_continue and not has_found_left_angle and not has_found_right_angle then
			return nil, nil, false
		else
			break
		end
	end

	local nav_distances = {
		4,
		4,
		0.25,
		0,
	}
	local is_left_valid = true
	local is_right_valid = true

	is_left_valid = is_left_valid and not has_left_hit
	is_right_valid = is_right_valid and not has_right_hit

	local new_positions_after_check = CompanionFollowUtility._look_for_valid_position(owner_unit, action_data, scratchpad, is_left_valid, is_right_valid, left_position, right_position, nav_distances)
	local follow_left_direction
	local size = table.size(new_positions_after_check)

	if size > 0 then
		if size > 1 then
			local companion_distance_left_position = Vector3.length(new_positions_after_check.first_position - companion_position)
			local companion_distance_right_position = Vector3.length(new_positions_after_check.second_position - companion_position)

			follow_left_direction = current_movement_direction == MOVEMENT_DIRECTION.left or companion_distance_left_position <= companion_distance_right_position and current_movement_direction == MOVEMENT_DIRECTION.none
		else
			follow_left_direction = new_positions_after_check.first_position or false
		end

		local nav_new_position = follow_left_direction and new_positions_after_check.first_position or new_positions_after_check.second_position

		return nav_new_position, follow_left_direction and MOVEMENT_DIRECTION.left or MOVEMENT_DIRECTION.right, true
	else
		return nil, nil, false
	end
end

CompanionFollowUtility.calculate_follow_owner_position = function (unit, blackboard, scratchpad, condition_args, action_data, is_running, dt)
	local behavior_component = scratchpad.behavior_component
	local follow_component = scratchpad.follow_component
	local owner_unit = behavior_component.owner_unit
	local player_position = POSITION_LOOKUP[owner_unit]
	local companion_position = POSITION_LOOKUP[unit]
	local flat_direction = Vector3.normalize(Vector3.flat(scratchpad.owner_locomotion_extension:current_velocity()))
	local front_offset, back_offset = 5, 2
	local front_position = player_position + front_offset * flat_direction
	local back_position = player_position - back_offset * flat_direction
	local has_front_hit, has_back_hit = CompanionFollowUtility._ray_trace_movement_check(scratchpad, player_position, front_position, back_position)

	if has_front_hit and has_back_hit then
		return false
	end

	local nav_distances = {
		4,
		4,
		0.25,
		0,
	}
	local new_positions_after_check = CompanionFollowUtility._look_for_valid_position(owner_unit, action_data, scratchpad, not has_front_hit, not has_back_hit, front_position, back_position, nav_distances)
	local size = table.size(new_positions_after_check)

	if size > 0 then
		local new_position

		if size > 1 then
			local companion_vector = Vector3.normalize(Vector3.flat(companion_position - player_position))
			local dot_product = Vector3.dot(flat_direction, companion_vector, false)

			if dot_product > 0 then
				new_position = new_positions_after_check.first_position
			else
				new_position = new_positions_after_check.second_position
			end
		else
			new_position = new_positions_after_check.first_position or new_positions_after_check.second_position
		end

		behavior_component.move_to_position:store(new_position)

		behavior_component.has_move_to_position = true

		local owner_unit_position = POSITION_LOOKUP[behavior_component.owner_unit]
		local follow_aim_entry = CompanionFollowUtility.follow_aim_entry(scratchpad, action_data, Vector3.zero())
		local aim_target_position = follow_aim_entry == "player" and owner_unit_position or new_position

		CompanionFollowUtility.set_up_aim_target(unit, scratchpad, aim_target_position)
	else
		return false
	end

	local current_owner_cooldown = follow_component.current_owner_cooldown

	if current_owner_cooldown == -1 then
		return true
	end

	local t = Managers.time:time("gameplay")
	local last_owner_cooldown_time = follow_component.last_owner_cooldown_time

	last_owner_cooldown_time = last_owner_cooldown_time == -1 and t or last_owner_cooldown_time

	local follow_owner_cooldown = action_data.follow_owner_cooldown

	current_owner_cooldown = math.clamp(current_owner_cooldown + (t - last_owner_cooldown_time), 0, follow_owner_cooldown)
	follow_component.current_owner_cooldown = follow_owner_cooldown <= current_owner_cooldown and -1 or current_owner_cooldown
	follow_component.last_owner_cooldown_time = follow_owner_cooldown <= current_owner_cooldown and -1 or t

	return true
end

CompanionFollowUtility._calculate_position_around_owner = function (unit, scratchpad, action_data)
	local owner_position = POSITION_LOOKUP[scratchpad.owner_unit]
	local outer_circle_distance = action_data.idle_circle_distances.outer_circle_distance
	local inner_circle_distance = action_data.idle_circle_distances.inner_circle_distance
	local distance_from_owner = action_data.distance_from_owner or inner_circle_distance + (outer_circle_distance - inner_circle_distance) * 0.5
	local nav_distances = {
		4,
		4,
		0.25,
		0,
	}
	local valid_positions

	valid_positions, valid_prioritized_positions = CompanionFollowUtility.select_points_around_center_with_owner_forward(unit, scratchpad, action_data, owner_position, distance_from_owner, nav_distances, false, 1)

	local behavior_component = scratchpad.behavior_component
	local num_valid_positions = #valid_positions
	local new_position

	if num_valid_positions > 0 then
		new_position = valid_positions[1]

		if num_valid_positions ~= 1 then
			local owner_velocity = Vector3.flat(ScriptUnit.extension(scratchpad.owner_unit, "locomotion_system"):current_velocity())
			local index_new_position

			if not Vector3.equal(owner_velocity, Vector3.zero()) then
				owner_velocity = Vector3.normalize(owner_velocity) * distance_from_owner

				local position_to_avoid = owner_position + owner_velocity
				local index_point_to_avoid = CompanionFollowUtility._calculate_index_of_closest_point_to_reference_point(valid_positions, position_to_avoid)

				table.remove(valid_positions, index_point_to_avoid)

				index_new_position = CompanionFollowUtility._calculate_index_of_closest_point_to_reference_point(valid_positions, POSITION_LOOKUP[unit])
				new_position = valid_positions[index_new_position]
			else
				local num_valid_prioritized_positions = #valid_prioritized_positions

				if num_valid_prioritized_positions > 0 then
					index_new_position = CompanionFollowUtility._calculate_index_of_closest_point_to_reference_point(valid_prioritized_positions, POSITION_LOOKUP[unit])
					new_position = valid_prioritized_positions[index_new_position]
				else
					index_new_position = CompanionFollowUtility._calculate_index_of_closest_point_to_reference_point(valid_positions, POSITION_LOOKUP[unit])
					new_position = valid_positions[index_new_position]
				end
			end
		end

		behavior_component.has_move_to_position = true
		behavior_component.should_skip_start_anim = true

		behavior_component.move_to_position:store(new_position)
	end

	return new_position
end

CompanionFollowUtility.manage_direction_timer = function (scratchpad, dt, action_data)
	local direction_timer = scratchpad.follow_config.direction_timer

	scratchpad.current_direction_timer = math.clamp(scratchpad.current_direction_timer + dt, 0, direction_timer)

	if direction_timer <= scratchpad.current_direction_timer then
		scratchpad.last_direction = MOVEMENT_DIRECTION.none
		scratchpad.current_direction_timer = 0
	end
end

CompanionFollowUtility.select_points_around_another_center = function (unit, scratchpad, action_data, center, forward_vector, nav_distances, stop_at_first, debug_draw_timer)
	local valid_positions = {}

	valid_prioritized_positions = {}

	local angle_checks = 360 / (action_data.angle_rotation_for_check or scratchpad.follow_config.angle_rotation_for_check)
	local angle_radians = math.degrees_to_radians(action_data.angle_rotation_for_check or scratchpad.follow_config.angle_rotation_for_check)
	local nav_world, traverse_logic = scratchpad.navigation_extension:nav_world(), scratchpad.navigation_extension:traverse_logic()
	local owner_nav_new_position = NavQueries.position_on_mesh(nav_world, POSITION_LOOKUP[scratchpad.owner_unit], nav_distances[1], nav_distances[2], traverse_logic)

	for i = 1, angle_checks do
		local current_angle = math.fmod(angle_radians * i, 2 * math.pi)
		local rotation = Quaternion(Vector3.up(), current_angle)
		local pos_before_nav_check = center + Quaternion.rotate(rotation, forward_vector)
		local new_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, pos_before_nav_check, nav_distances[1], nav_distances[2], nav_distances[3], nav_distances[4])

		if new_position then
			local ray_can_go = owner_nav_new_position and GwNavQueries.raycango(nav_world, owner_nav_new_position, new_position, traverse_logic)

			if ray_can_go then
				table.insert(valid_positions, new_position)
			end
		end

		if new_position and action_data.angle_to_prioritize then
			local lower_degree_angle = action_data.angle_to_prioritize[1]
			local upper_degree_angle = action_data.angle_to_prioritize[2]
			local lower_angle = lower_degree_angle > 0 and math.degrees_to_radians(lower_degree_angle) or math.degrees_to_radians(lower_degree_angle + 360)
			local higher_angle = upper_degree_angle > 0 and math.degrees_to_radians(upper_degree_angle) or math.degrees_to_radians(upper_degree_angle + 360)
			local is_angle_valid

			if lower_angle <= higher_angle then
				is_angle_valid = lower_angle <= current_angle and current_angle <= higher_angle
			else
				is_angle_valid = lower_angle <= current_angle or current_angle <= higher_angle
			end

			if is_angle_valid then
				table.insert(valid_prioritized_positions, new_position)
			end
		end

		if stop_at_first and new_position then
			return valid_positions, valid_prioritized_positions
		end
	end

	return valid_positions, valid_prioritized_positions
end

CompanionFollowUtility.select_points_around_center_with_owner_forward = function (unit, scratchpad, action_data, center, distance, nav_distances, stop_at_first, draw_debug_timer)
	local owner_unit_data_extension = ScriptUnit.extension(scratchpad.owner_unit, "unit_data_system")
	local first_person = owner_unit_data_extension:read_component("first_person")
	local look_rotation = first_person.rotation
	local forward_vector = Vector3.normalize(Vector3.flat(Quaternion.forward(look_rotation))) * distance

	return CompanionFollowUtility.select_points_around_another_center(unit, scratchpad, action_data, center, forward_vector, nav_distances, stop_at_first, draw_debug_timer)
end

CompanionFollowUtility._look_for_valid_position = function (owner_unit, action_data, scratchpad, is_first_valid, is_second_valid, first_position, second_position, nav_distances)
	local is_both_valid = is_first_valid and is_second_valid
	local new_positions = {}

	if is_both_valid then
		new_positions.first_position = first_position
		new_positions.second_position = second_position
	elseif is_first_valid then
		new_positions.first_position = first_position
	else
		new_positions.second_position = second_position
	end

	local new_positions_after_check = {}

	for key, position in pairs(new_positions) do
		local new_position = new_positions[key]
		local nav_world, traverse_logic = scratchpad.navigation_extension:nav_world(), scratchpad.navigation_extension:traverse_logic()
		local nav_new_position = NavQueries.position_on_mesh(nav_world, new_position, nav_distances[1], nav_distances[2], traverse_logic)

		if nav_new_position then
			new_positions_after_check[key] = nav_new_position
		end
	end

	return new_positions_after_check
end

CompanionFollowUtility._ray_trace_movement_check = function (scratchpad, initial_position, first_position, second_position)
	local position_offset = Vector3(0, 0, 0.5)
	local trace_position = initial_position + position_offset
	local first_trace_position = first_position + position_offset
	local second_trace_position = second_position + position_offset
	local spawn_component = scratchpad.spawn_component
	local physics_world = spawn_component.physics_world
	local first_trace_direction = first_trace_position - trace_position
	local second_trace_direction = second_trace_position - trace_position
	local has_first_hit, _, _, first_hit_normal = PhysicsWorld.raycast(physics_world, trace_position, first_trace_direction, Vector3.length(first_trace_direction), "closest", "collision_filter", "filter_simple_geometry")
	local has_second_hit, _, _, second_hit_normal = PhysicsWorld.raycast(physics_world, trace_position, second_trace_direction, Vector3.length(second_trace_direction), "closest", "collision_filter", "filter_simple_geometry")

	if has_first_hit and first_hit_normal then
		local dot_product = Vector3.dot(first_hit_normal, Vector3.up())
		local cone_cos = math.cos(math.degrees_to_radians(70))

		has_first_hit = not (cone_cos <= dot_product)
	end

	if has_second_hit and second_hit_normal then
		local dot_product = Vector3.dot(second_hit_normal, Vector3.up())
		local cone_cos = math.cos(math.degrees_to_radians(70))

		has_second_hit = not (cone_cos <= dot_product)
	end

	return has_first_hit, has_second_hit
end

CompanionFollowUtility._calculate_index_of_closest_point_to_reference_point = function (valid_positions, reference_point)
	local index = 1
	local current_distance = Vector3.length(valid_positions[index] - reference_point)

	for i = 2, #valid_positions do
		local new_distance = Vector3.length(valid_positions[i] - reference_point)

		if new_distance < current_distance then
			current_distance = new_distance
			index = i
		end
	end

	return index
end

CompanionFollowUtility._calculate_rotation_given_velocities = function (scratchpad, velocity)
	local follow_component = scratchpad.follow_component
	local last_referenced_vector = follow_component.last_referenced_vector:unbox()
	local velocity_quaternion = Quaternion.look(Vector3.flat(velocity), Vector3.up())
	local velocity_right_vector = Quaternion.right(velocity_quaternion)
	local dot_product = Vector3.dot(last_referenced_vector, velocity_right_vector, true)

	if dot_product > 0 then
		return Quaternion(Vector3.up(), math.degrees_to_radians(scratchpad.max_angle_per_check))
	else
		return Quaternion(Vector3.up(), math.degrees_to_radians(-scratchpad.max_angle_per_check))
	end
end

CompanionFollowUtility._is_inside_inner_cone = function (owner, position, current_velocity, follow_config)
	local initial_position = POSITION_LOOKUP[owner]
	local min_angle = math.degrees_to_radians(follow_config.front_angle)
	local min_angle_rotation = Quaternion(Vector3.up(), min_angle)
	local opposite_min_angle_rotation = Quaternion(Vector3.up(), -min_angle)
	local opposite_direction_right = Vector3.normalize(Quaternion.rotate(min_angle_rotation, current_velocity))
	local opposite_direction_left = Vector3.normalize(Quaternion.rotate(opposite_min_angle_rotation, current_velocity))
	local current_vector = Vector3.normalize(position - initial_position)
	local cross_product1 = Vector3.cross(opposite_direction_left, current_vector)
	local cross_product2 = Vector3.cross(current_vector, opposite_direction_right)
	local is_inside_cone = Vector3.dot(cross_product1, cross_product2) >= 0

	return is_inside_cone
end

CompanionFollowUtility._get_forward_direction = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local behavior_component = blackboard.behavior
	local owner_unit = behavior_component.owner_unit
	local owner_locomotion_extension = ScriptUnit.extension(owner_unit, "locomotion_system")
	local owner_unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	local first_person = owner_unit_data_extension:read_component("first_person")
	local look_rotation = first_person.rotation
	local owner_forward_vector = Vector3.normalize(Vector3.flat(Quaternion.forward(look_rotation)))

	return owner_forward_vector, owner_locomotion_extension
end

CompanionFollowUtility._owner_has_forward_velocity = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local owner_forward_vector, owner_locomotion_extension = CompanionFollowUtility._get_forward_direction(unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local dot_product = Vector3.dot(owner_forward_vector, Vector3.normalize(owner_locomotion_extension:current_velocity()))

	return dot_product > 0.05
end

CompanionFollowUtility._owner_has_backward_velocity = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local owner_forward_vector, owner_locomotion_extension = CompanionFollowUtility._get_forward_direction(unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local dot_product = Vector3.dot(-owner_forward_vector, Vector3.normalize(owner_locomotion_extension:current_velocity()))

	return dot_product > 0.05
end

CompanionFollowUtility._create_scratchpad_follow_flrb = function (unit, blackboard, scratchpad, condition_args, action_data, is_running, dt)
	local current_scratchpad = {}
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	current_scratchpad.behavior_component = behavior_component

	local follow_component = Blackboard.write_component(blackboard, "follow")

	current_scratchpad.follow_component = follow_component

	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	current_scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	current_scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	current_scratchpad.navigation_extension = navigation_extension

	local aim_component = Blackboard.write_component(blackboard, "aim")

	current_scratchpad.aim_component = aim_component

	local spawn_component = Blackboard.write_component(blackboard, "spawn")

	current_scratchpad.spawn_component = spawn_component

	local owner_unit = behavior_component.owner_unit

	current_scratchpad.owner_unit = owner_unit
	current_scratchpad.owner_locomotion_extension = ScriptUnit.extension(owner_unit, "locomotion_system")
	current_scratchpad.current_direction_timer = 0
	current_scratchpad.last_direction = MOVEMENT_DIRECTION.none

	return current_scratchpad
end

CompanionFollowUtility._create_scratchpad_follow_owner = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local current_scratchpad = {}
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	current_scratchpad.behavior_component = behavior_component

	local follow_component = Blackboard.write_component(blackboard, "follow")

	current_scratchpad.follow_component = follow_component

	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	current_scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	current_scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	current_scratchpad.navigation_extension = navigation_extension

	local owner_unit = behavior_component.owner_unit

	current_scratchpad.owner_locomotion_extension = ScriptUnit.extension(owner_unit, "locomotion_system")

	local spawn_component = Blackboard.write_component(blackboard, "spawn")

	current_scratchpad.spawn_component = spawn_component

	local aim_component = Blackboard.write_component(blackboard, "aim")

	current_scratchpad.aim_component = aim_component
	current_scratchpad.owner_unit = owner_unit

	return current_scratchpad
end

CompanionFollowUtility.set_up_aim_target = function (unit, scratchpad, aim_target_position)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local unit_breed = unit_data_extension:breed()
	local aim_node_name = unit_breed.aim_config.target_node
	local aim_node = Unit.node(unit, aim_node_name)
	local aim_node_position = Unit.world_position(unit, aim_node)
	local aim_position = Vector3(aim_target_position.x, aim_target_position.y, aim_node_position.z)

	scratchpad.aim_component.controlled_aim_position:store(aim_position)
end

CompanionFollowUtility.follow_aim_entry = function (scratchpad, action_data, velocity)
	local follow_config = scratchpad.follow_config
	local follow_aim = follow_config and follow_config.follow_aim or action_data.follow_aim
	local companion_speed = Vector3.length(velocity)
	local follow_aim_entry

	for key, value in pairs(follow_aim) do
		if companion_speed >= value[1] and companion_speed < value[2] then
			follow_aim_entry = key

			break
		end
	end

	return follow_aim_entry
end

CompanionFollowUtility.get_max_front_side_angle = function (scratchpad, blackboard, follow_config)
	local front_angle_left = follow_config.front_angle
	local side_angle_left = 90 - follow_config.side_angle
	local front_angle_right = follow_config.front_angle
	local side_angle_right = 90 - follow_config.side_angle
	local numbers_of_adaptive_angle_checks = follow_config.numbers_of_adaptive_angle_checks

	if not numbers_of_adaptive_angle_checks then
		return front_angle_left, side_angle_left, front_angle_right, side_angle_right
	end

	local front_angle_adaptive_angle = front_angle_left / numbers_of_adaptive_angle_checks
	local side_angle_adaptive_angle = side_angle_left / numbers_of_adaptive_angle_checks
	local follow_component = scratchpad and scratchpad.follow_component or blackboard and blackboard.follow
	local current_adaptive_angle_check_left = follow_component.current_adaptive_angle_check_left
	local current_adaptive_angle_check_right = follow_component.current_adaptive_angle_check_right

	front_angle_left = front_angle_left - front_angle_adaptive_angle * current_adaptive_angle_check_left
	side_angle_left = side_angle_left - side_angle_adaptive_angle * current_adaptive_angle_check_left
	front_angle_right = front_angle_right - front_angle_adaptive_angle * current_adaptive_angle_check_right
	side_angle_right = side_angle_right - side_angle_adaptive_angle * current_adaptive_angle_check_right

	return front_angle_left, side_angle_left, front_angle_right, side_angle_right
end

CompanionFollowUtility.follow_config = function (blackboard, action_data)
	local follow_component = blackboard.follow

	if not follow_component then
		return nil
	end

	local current_movement_type = follow_component.current_movement_type

	return current_movement_type == "forward" and action_data.dog_forward_follow_config or current_movement_type == "lrb" and action_data.dog_lrb_follow_config or current_movement_type == "owner" and action_data.dog_owner_follow_config
end

return CompanionFollowUtility
