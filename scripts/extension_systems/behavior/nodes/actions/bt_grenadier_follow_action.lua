require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local MinionMovement = require("scripts/utilities/minion_movement")
local Trajectory = require("scripts/utilities/trajectory")
local Vo = require("scripts/utilities/vo")
local BtGrenadierFollowAction = class("BtGrenadierFollowAction", "BtNode")

BtGrenadierFollowAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn
	scratchpad.physics_world = spawn_component.physics_world
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.combat_vector_extension = ScriptUnit.extension(unit, "combat_vector_system")
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.navigation_extension = navigation_extension
	local combat_vector_component = blackboard.combat_vector
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.combat_vector_component = combat_vector_component
	scratchpad.perception_component = blackboard.perception
	scratchpad.throw_grenade_component = Blackboard.write_component(blackboard, "throw_grenade")
	local run_speed = action_data.speed

	navigation_extension:set_enabled(true, run_speed)

	local randomized_throw_directions = {}

	self:_calculate_throw_directions(randomized_throw_directions)

	scratchpad.randomized_throw_directions = randomized_throw_directions
	scratchpad.throw_direction_index = 1
	scratchpad.num_failed_attempts = 0
	scratchpad.skulking_vo_interval_t = DialogueBreedSettings[breed.name].skulking_vo_interval_t
	scratchpad.next_skulk_vo_t = t + scratchpad.skulking_vo_interval_t
	scratchpad.check_grenade_trajectory_t = t + action_data.check_grenade_trajectory_frequency
	scratchpad.current_combat_vector_position = Vector3Box()

	self:_move_to_combat_vector(scratchpad, combat_vector_component, navigation_extension)
end

BtGrenadierFollowAction.init_values = function (self, blackboard)
	local throw_grenade_component = Blackboard.write_component(blackboard, "throw_grenade")

	throw_grenade_component.throw_direction:store(0, 0, 0)
	throw_grenade_component.throw_position:store(0, 0, 0)
	throw_grenade_component.wanted_rotation:store(0, 0, 0, 0)

	throw_grenade_component.next_throw_at_t = 0
	throw_grenade_component.anim_event = ""
end

BtGrenadierFollowAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	scratchpad.navigation_extension:set_enabled(false)
end

local MIN_COMBAT_VECTOR_DISTANCE_CHANGE_SQ = 9
local NUM_FAILED_ATTEMPTS_FOR_NEW_LOCATION = 10

BtGrenadierFollowAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local perception_component = scratchpad.perception_component
	local target_distance = perception_component.target_distance
	local has_line_of_sight = perception_component.has_line_of_sight
	local next_throw_at_t = scratchpad.throw_grenade_component.next_throw_at_t
	local should_check_trajectory = next_throw_at_t <= t and (action_data.min_distance_from_target <= target_distance or not has_line_of_sight)
	local behavior_component = scratchpad.behavior_component
	local move_state = behavior_component.move_state

	if should_check_trajectory and scratchpad.check_grenade_trajectory_t < t then
		local has_trajectory = self:_check_grenade_trajectory(unit, blackboard, scratchpad, action_data)

		if has_trajectory then
			return "done"
		else
			scratchpad.check_grenade_trajectory_t = t + action_data.check_grenade_trajectory_frequency
			scratchpad.num_failed_attempts = scratchpad.num_failed_attempts + 1

			if NUM_FAILED_ATTEMPTS_FOR_NEW_LOCATION <= scratchpad.num_failed_attempts and move_state == "idle" then
				scratchpad.combat_vector_extension:look_for_new_location(action_data.new_location_min_dist, action_data.new_location_max_dist, action_data.new_location_combat_range)

				scratchpad.num_failed_attempts = 0
			end
		end
	end

	local combat_vector_component = scratchpad.combat_vector_component
	local wanted_position = combat_vector_component.position:unbox()
	local current_combat_vector_position = scratchpad.current_combat_vector_position:unbox()
	local distance_sq = Vector3.distance_squared(current_combat_vector_position, wanted_position)

	if MIN_COMBAT_VECTOR_DISTANCE_CHANGE_SQ < distance_sq then
		self:_move_to_combat_vector(scratchpad, combat_vector_component, scratchpad.navigation_extension)
	end

	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)

	if should_start_idle or should_be_idling then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)
		end

		local target_unit = scratchpad.perception_component.target_unit
		local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

		scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)

		return "running"
	end

	if move_state ~= "moving" then
		self:_start_move_anim(unit, t, behavior_component, scratchpad, action_data)
	end

	if scratchpad.is_anim_driven and scratchpad.start_rotation_timing and scratchpad.start_rotation_timing <= t then
		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
	end

	local vo_event = action_data.vo_event

	if vo_event and scratchpad.next_skulk_vo_t < t then
		Vo.enemy_generic_vo_event(unit, vo_event, breed.name)

		scratchpad.next_skulk_vo_t = t + scratchpad.skulking_vo_interval_t
	end

	return "running"
end

local MAX_TRIES = 20
local SECTIONS = 20
local COLLISION_FILTER = "filter_minion_shooting_geometry"

BtGrenadierFollowAction._check_grenade_trajectory = function (self, unit, blackboard, scratchpad, action_data)
	local target_unit = scratchpad.perception_component.target_unit
	local target_position = POSITION_LOOKUP[target_unit]
	local throw_target_position = nil
	local i = 1

	while i < MAX_TRIES and not throw_target_position do
		throw_target_position = self:_get_throw_position(target_position, scratchpad, action_data)
		i = i + 1
	end

	if throw_target_position == nil then
		return false
	end

	local self_position = POSITION_LOOKUP[unit]
	local distance_to_target = Vector3.distance(self_position, target_position)
	local throw_anim_events = action_data.throw_anim_events
	local throw_distance_thresholds = action_data.throw_distance_thresholds
	local throw_anim_event = nil

	if distance_to_target < throw_distance_thresholds.close then
		throw_anim_event = Animation.random_event(throw_anim_events.close)
	elseif distance_to_target < throw_distance_thresholds.medium then
		throw_anim_event = Animation.random_event(throw_anim_events.medium)
	else
		throw_anim_event = Animation.random_event(throw_anim_events.long)
	end

	local flat_target_direction = Vector3.flat(throw_target_position - self_position)
	local wanted_rotation = Quaternion.look(flat_target_direction)
	local scale = Unit.world_scale(unit, 1)
	local throw_node_local_offset = action_data.throw_node_local_offset[throw_anim_event]:unbox()
	local rotated_root_world_pose = Matrix4x4.from_quaternion_position_scale(wanted_rotation, self_position, scale)
	local throw_node_position = Matrix4x4.transform(rotated_root_world_pose, throw_node_local_offset)
	local throw_config = action_data.throw_config
	local projectile_template = throw_config.projectile_template
	local locomotion_template = projectile_template.locomotion_template
	local throw_parameters = locomotion_template.throw_parameters.throw
	local integrator_parameters = locomotion_template.integrator_parameters
	local speed = throw_parameters.speed_inital
	local gravity = integrator_parameters.gravity
	local acceptable_accuracy = throw_config.acceptable_accuracy
	local target_velocity = MinionMovement.target_velocity(target_unit)
	local angle_to_hit_target, estimated_position = Trajectory.angle_to_hit_moving_target(throw_node_position, throw_target_position, speed, target_velocity, gravity, acceptable_accuracy)

	if angle_to_hit_target == nil then
		return false
	end

	local velocity, time_in_flight = Trajectory.get_trajectory_velocity(throw_node_position, estimated_position, gravity, speed, angle_to_hit_target)
	local trajectory_is_ok = Trajectory.check_trajectory_collisions(scratchpad.physics_world, throw_node_position, estimated_position, gravity, speed, angle_to_hit_target, SECTIONS, COLLISION_FILTER, time_in_flight)

	if trajectory_is_ok then
		local throw_direction = Vector3.normalize(velocity)
		local throw_grenade_component = scratchpad.throw_grenade_component

		throw_grenade_component.throw_direction:store(throw_direction)
		throw_grenade_component.throw_position:store(throw_node_position)
		throw_grenade_component.wanted_rotation:store(wanted_rotation)

		throw_grenade_component.anim_event = throw_anim_event

		return true
	else
		return false
	end
end

local THROW_POSITION_Z_OFFSET = 3
local RAYCAST_Z_OFFSET = 0.1

BtGrenadierFollowAction._get_throw_position = function (self, target_position, scratchpad, action_data)
	local physics_world = scratchpad.physics_world
	local range = math.random_range(action_data.throw_position_distance[1], action_data.throw_position_distance[2])
	local throw_direction_index = scratchpad.throw_direction_index
	local randomized_throw_directions = scratchpad.randomized_throw_directions
	local randomized_direction = randomized_throw_directions[throw_direction_index]:unbox()
	local z_offset = Vector3(0, 0, RAYCAST_Z_OFFSET)
	target_position = target_position + z_offset
	local randomized_position = target_position + randomized_direction * range
	local check_z_position = randomized_position + Vector3(0, 0, THROW_POSITION_Z_OFFSET)
	local hit, hit_position = self:_ray_cast(physics_world, check_z_position, randomized_position)
	local wanted_position = nil

	if hit then
		wanted_position = hit_position + z_offset
	else
		wanted_position = randomized_position
	end

	if throw_direction_index == #randomized_throw_directions then
		scratchpad.throw_direction_index = 1

		table.shuffle(randomized_throw_directions)
	else
		scratchpad.throw_direction_index = scratchpad.throw_direction_index + 1
	end

	local target_is_obscured = self:_ray_cast(physics_world, wanted_position, target_position)

	if not target_is_obscured then
		return wanted_position
	end
end

BtGrenadierFollowAction._ray_cast = function (self, physics_world, from, to)
	local to_target = to - from
	local direction = Vector3.normalize(to_target)
	local distance = Vector3.length(to_target)
	local result, hit_position, hit_distance, normal, _ = PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", COLLISION_FILTER)

	return result, hit_position, hit_distance, normal
end

BtGrenadierFollowAction._move_to_combat_vector = function (self, scratchpad, combat_vector_component, navigation_extension)
	local wanted_position = combat_vector_component.position:unbox()

	navigation_extension:move_to(wanted_position)
	scratchpad.current_combat_vector_position:store(wanted_position)
end

BtGrenadierFollowAction._start_move_anim = function (self, unit, t, behavior_component, scratchpad, action_data)
	local animation_extension = scratchpad.animation_extension
	local start_move_anim_events = action_data.start_move_anim_events

	if start_move_anim_events then
		local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)
		local start_move_event = start_move_anim_events[moving_direction_name]

		animation_extension:anim_event(start_move_event)

		if moving_direction_name ~= "fwd" then
			MinionMovement.set_anim_driven(scratchpad, true)

			local start_rotation_timing = action_data.start_move_rotation_timings[start_move_event]
			scratchpad.start_rotation_timing = t + start_rotation_timing
			scratchpad.move_start_anim_event_name = start_move_event
		else
			scratchpad.start_rotation_timing = nil
			scratchpad.move_start_anim_event_name = nil
		end
	elseif action_data.move_anim_event then
		local move_event = action_data.move_anim_event

		animation_extension:anim_event(move_event)
	end

	behavior_component.move_state = "moving"
end

local RADIANS_RANGE = math.two_pi
local RADIANS_PER_DIRECTION = math.degrees_to_radians(10)
local NUM_DIRECTIONS = RADIANS_RANGE / RADIANS_PER_DIRECTION

BtGrenadierFollowAction._calculate_throw_directions = function (self, randomized_directions)
	local current_radians = -(RADIANS_RANGE / 2)

	for i = 1, NUM_DIRECTIONS, 1 do
		current_radians = current_radians + RADIANS_PER_DIRECTION
		local direction = Vector3(math.sin(current_radians), math.cos(current_radians), 0)
		randomized_directions[i] = Vector3Box(direction)
	end

	table.shuffle(randomized_directions)

	return randomized_directions
end

return BtGrenadierFollowAction
