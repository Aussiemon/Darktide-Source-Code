require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local ChaosHoundSettings = require("scripts/settings/specials/chaos_hound_settings")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local MinionMovement = require("scripts/utilities/minion_movement")
local NavQueries = require("scripts/utilities/nav_queries")
local Trajectory = require("scripts/utilities/trajectory")
local Vo = require("scripts/utilities/vo")
local BtChaosHoundApproachAction = class("BtChaosHoundApproachAction", "BtNode")

BtChaosHoundApproachAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = navigation_extension
	local stagger_component = Blackboard.write_component(blackboard, "stagger")
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = blackboard.perception
	scratchpad.stagger_component = stagger_component
	local speed = action_data.speed

	navigation_extension:set_enabled(true, speed)

	scratchpad.original_rotation_speed = locomotion_extension:rotation_speed()

	locomotion_extension:set_rotation_speed(action_data.rotation_speed)

	scratchpad.side_system = Managers.state.extension:system("side_system")
	local spawn_component = blackboard.spawn
	scratchpad.physics_world = spawn_component.physics_world
	stagger_component.controlled_stagger = false
	scratchpad.check_leap_t = 0
	scratchpad.num_failed_leap_checks = 0
	scratchpad.trigger_player_alert_vo_t = 0

	MinionMovement.init_find_ranged_position(scratchpad, action_data)
end

BtChaosHoundApproachAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local locomotion_extension = scratchpad.locomotion_extension

	if scratchpad.stagger_duration then
		scratchpad.animation_extension:anim_event("stagger_finished")
		locomotion_extension:set_affected_by_gravity(false)
		locomotion_extension:set_movement_type("snap_to_navmesh")
	end

	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)
	scratchpad.navigation_extension:set_enabled(false)
end

local IDLE_DURATION = 2
local MAX_FAILED_LEAP_CHECKS = 5
local NUM_FAILED_ATTEMPTS_TO_MANUAL_MOVE = 3
local UPDATE_TARGET_DISTANCE_SQ = 1

BtChaosHoundApproachAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local behavior_component = scratchpad.behavior_component
	local perception_component = scratchpad.perception_component
	local move_state = behavior_component.move_state
	local target_unit = perception_component.target_unit
	local target_distance = perception_component.target_distance
	local too_close_distance = action_data.too_close_distance
	local is_in_stagger = scratchpad.stagger_duration and t <= scratchpad.stagger_duration

	if not is_in_stagger and target_distance <= too_close_distance then
		if move_state == "moving" then
			behavior_component.move_state = ""
		end

		self:_set_pounce_cooldown(unit, breed, scratchpad, target_unit, blackboard, t)

		return "failed"
	end

	if scratchpad.trigger_player_alert_vo_t < t and target_distance < action_data.trigger_player_alert_vo_distance then
		Vo.pouncing_alert_event(target_unit, breed)

		scratchpad.trigger_player_alert_vo_t = t + action_data.trigger_player_alert_vo_frequency
	end

	local navigation_extension = scratchpad.navigation_extension

	if scratchpad.check_leap_t < t then
		local can_start_leap, is_long_leap = self:_can_start_leap(unit, scratchpad, action_data, perception_component, t)

		if can_start_leap then
			if not is_long_leap then
				navigation_extension:set_enabled(false)
			end

			return "done"
		elseif MAX_FAILED_LEAP_CHECKS <= scratchpad.num_failed_leap_checks then
			self:_set_pounce_cooldown(unit, breed, scratchpad, target_unit, blackboard, t)

			return "failed"
		end
	end

	local find_move_position_attempts = scratchpad.find_move_position_attempts

	if NUM_FAILED_ATTEMPTS_TO_MANUAL_MOVE <= find_move_position_attempts then
		self:_move_to_target(scratchpad)
	else
		local target_position = POSITION_LOOKUP[target_unit]
		local destination = navigation_extension:destination()
		local target_to_destination_distance_sq = Vector3.distance_squared(target_position, destination)
		local force_move = UPDATE_TARGET_DISTANCE_SQ < target_to_destination_distance_sq

		MinionMovement.update_move_to_ranged_position(unit, t, scratchpad, action_data, target_unit, nil, nil, nil, force_move)
	end

	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)

	if (should_start_idle or should_be_idling) and not is_in_stagger then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)

			scratchpad.idle_duration = t + IDLE_DURATION
		elseif scratchpad.idle_duration and scratchpad.idle_duration <= t then
			self:_set_pounce_cooldown(unit, breed, scratchpad, target_unit, blackboard, t)

			return "failed"
		end

		return "running"
	end

	if move_state ~= "moving" then
		self:_start_move_anim(unit, scratchpad, action_data, t)
	end

	if scratchpad.is_anim_driven and scratchpad.start_rotation_timing and scratchpad.start_rotation_timing <= t then
		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
	end

	if scratchpad.start_move_event_anim_speed_duration then
		if t < scratchpad.start_move_event_anim_speed_duration then
			MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
		else
			navigation_extension:set_max_speed(action_data.speed)

			scratchpad.start_move_event_anim_speed_duration = nil
		end
	end

	local is_following_path = navigation_extension:is_following_path()

	if is_following_path then
		self:_update_anim_lean_variable(unit, scratchpad, action_data, dt)
	end

	self:_update_ground_normal_rotation(unit, target_unit, scratchpad)

	local done_with_running_stagger = MinionMovement.update_running_stagger(unit, t, dt, scratchpad, action_data)

	if done_with_running_stagger then
		self:_start_move_anim(unit, scratchpad, action_data, t)
		self:_move_to_target(scratchpad)
	end

	return "running"
end

local ABOVE = 1
local BELOW = 2
local NAV_Z_CORRECTION = 0.1
local TRAJECTORY_FAILED_COOLDOWN = 0.25

BtChaosHoundApproachAction._can_start_leap = function (self, unit, scratchpad, action_data, perception_component, t)
	if not perception_component.has_line_of_sight then
		return false, false
	end

	local leave_distance = action_data.leave_distance
	local target_distance = perception_component.target_distance
	local is_in_stagger = scratchpad.stagger_duration and t <= scratchpad.stagger_duration

	if is_in_stagger or leave_distance <= target_distance then
		return false, false
	end

	local target_unit = perception_component.target_unit
	local target_position = POSITION_LOOKUP[target_unit]
	local navigation_extension = scratchpad.navigation_extension
	local nav_world = navigation_extension:nav_world()
	local traverse_logic = navigation_extension:traverse_logic()
	local target_position_on_nav_mesh = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, target_position, ABOVE, BELOW)

	if not target_position_on_nav_mesh then
		return false, false
	end

	local position = POSITION_LOOKUP[unit]
	local raycango = GwNavQueries.raycango(nav_world, position, target_position_on_nav_mesh, traverse_logic)

	if not raycango then
		return false, false
	end

	local leap_start_position = nil
	local current_speed = Vector3.length(scratchpad.locomotion_extension:current_velocity())
	local use_long_leap = ChaosHoundSettings.long_leap_min_speed <= current_speed and ChaosHoundSettings.short_distance <= target_distance

	if use_long_leap then
		local target_direction = Vector3.normalize(target_position - position)
		local offset_position = position + target_direction * ChaosHoundSettings.long_leap_start_offset_distance
		local offset_position_on_nav_mesh = NavQueries.position_on_mesh(nav_world, offset_position, 1, 1, traverse_logic)

		if not offset_position_on_nav_mesh then
			return false, false
		end

		local can_reach_start_position = GwNavQueries.raycango(nav_world, position, offset_position_on_nav_mesh, traverse_logic)

		if not can_reach_start_position then
			return false, false
		end

		leap_start_position = offset_position_on_nav_mesh + Vector3(0, 0, NAV_Z_CORRECTION)
	else
		leap_start_position = position + Vector3(0, 0, NAV_Z_CORRECTION)
	end

	local target_node_name = ChaosHoundSettings.leap_target_node_name
	local target_node = Unit.node(target_unit, target_node_name)
	local leap_target_position = Unit.world_position(target_unit, target_node) + Vector3(0, 0, ChaosHoundSettings.leap_target_z_offset)
	local is_dodging, _ = Dodge.is_dodging(target_unit)
	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local target_locomotion_component = target_unit_data_extension:read_component("locomotion")
	local target_velocity = is_dodging and Vector3.zero() or target_locomotion_component.velocity_current
	local success = self:_check_leap(scratchpad.physics_world, leap_start_position, leap_target_position, target_velocity)

	if not success then
		scratchpad.check_leap_t = t + TRAJECTORY_FAILED_COOLDOWN
		scratchpad.num_failed_leap_checks = scratchpad.num_failed_leap_checks + 1

		return false, false
	end

	return true, use_long_leap
end

BtChaosHoundApproachAction._check_leap = function (self, physics_world, start_position, target_position, target_velocity)
	local speed = ChaosHoundSettings.leap_speed
	local gravity = ChaosHoundSettings.leap_gravity
	local acceptable_accuracy = ChaosHoundSettings.leap_acceptable_accuracy
	local angle_to_hit_target, est_pos = Trajectory.angle_to_hit_moving_target(start_position, target_position, speed, target_velocity, gravity, acceptable_accuracy)

	if not angle_to_hit_target then
		return false
	end

	local _, time_in_flight = Trajectory.get_trajectory_velocity(start_position, est_pos, gravity, speed, angle_to_hit_target)
	time_in_flight = math.min(time_in_flight, ChaosHoundSettings.leap_max_time_in_flight)
	local debug = nil
	local num_sections = ChaosHoundSettings.leap_num_sections
	local collision_filter = ChaosHoundSettings.leap_collision_filter
	local radius = ChaosHoundSettings.leap_radius
	local relax_distance = ChaosHoundSettings.collision_radius
	local trajectory_is_ok = Trajectory.check_trajectory_collisions(physics_world, start_position, est_pos, gravity, speed, angle_to_hit_target, num_sections, collision_filter, time_in_flight, debug, radius, relax_distance)

	return trajectory_is_ok
end

BtChaosHoundApproachAction._start_move_anim = function (self, unit, scratchpad, action_data, t)
	local stagger_component = scratchpad.stagger_component

	if stagger_component.controlled_stagger then
		stagger_component.controlled_stagger = false
	end

	local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)
	local start_move_anim_events = action_data.start_move_anim_events
	local start_move_event = start_move_anim_events[moving_direction_name]

	scratchpad.animation_extension:anim_event(start_move_event)

	if moving_direction_name ~= "fwd" then
		MinionMovement.set_anim_driven(scratchpad, true)

		local start_rotation_timing = action_data.start_move_rotation_timings[start_move_event]
		scratchpad.start_rotation_timing = t + start_rotation_timing
		scratchpad.move_start_anim_event_name = start_move_event
	else
		scratchpad.start_rotation_timing = nil
		scratchpad.move_start_anim_event_name = nil
	end

	local start_move_event_anim_speed_duration = action_data.start_move_event_anim_speed_durations and action_data.start_move_event_anim_speed_durations[start_move_event]

	if start_move_event_anim_speed_duration then
		scratchpad.start_move_event_anim_speed_duration = t + start_move_event_anim_speed_duration
	end

	scratchpad.behavior_component.move_state = "moving"
end

local LATERAL = 2

BtChaosHoundApproachAction._move_to_target = function (self, scratchpad)
	local navigation_extension = scratchpad.navigation_extension
	local nav_world = navigation_extension:nav_world()
	local traverse_logic = navigation_extension:traverse_logic()
	local target_unit = scratchpad.perception_component.target_unit
	local wanted_position = POSITION_LOOKUP[target_unit]
	local goal_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, wanted_position, ABOVE, BELOW, LATERAL)

	if goal_position then
		navigation_extension:move_to(goal_position)
	end
end

BtChaosHoundApproachAction._update_anim_lean_variable = function (self, unit, scratchpad, action_data, dt)
	local lean_value = MinionMovement.get_lean_animation_variable_value(unit, scratchpad, action_data, dt)

	if lean_value then
		local lean_variable_name = action_data.lean_variable_name

		scratchpad.animation_extension:set_variable(lean_variable_name, lean_value)
	end
end

local TO_OFFSET_UP_DISTANCE = 2

BtChaosHoundApproachAction._update_ground_normal_rotation = function (self, unit, target_unit, scratchpad)
	local self_position = POSITION_LOOKUP[unit]
	local offset_up = Vector3.up()
	local self_rotation = Unit.local_rotation(unit, 1)
	local forward = Vector3.normalize(Quaternion.forward(self_rotation))
	local from_position_1 = self_position + offset_up + forward
	local physics_world = scratchpad.physics_world
	local to_position_1 = from_position_1 - offset_up * TO_OFFSET_UP_DISTANCE
	local hit_1, hit_position_1 = self:_ray_cast(physics_world, from_position_1, to_position_1)

	if not hit_1 then
		return
	end

	local from_position_2 = self_position + offset_up - forward
	local to_position_2 = from_position_2 - offset_up * TO_OFFSET_UP_DISTANCE
	local hit_2, hit_position_2 = self:_ray_cast(physics_world, from_position_2, to_position_2)

	if not hit_2 then
		return
	end

	local locomotion_extension = scratchpad.locomotion_extension
	local wanted_direction = Vector3.normalize(hit_position_1 - hit_position_2)
	local current_velocity = locomotion_extension:current_velocity()
	local velocity_normalized = Vector3.normalize(current_velocity)

	Vector3.set_xyz(wanted_direction, velocity_normalized.x, velocity_normalized.y, wanted_direction.z)

	local wanted_rotation = Quaternion.look(wanted_direction)

	locomotion_extension:set_wanted_rotation(wanted_rotation)
end

local COLLISION_FILTER = "filter_minion_line_of_sight_check"

BtChaosHoundApproachAction._ray_cast = function (self, physics_world, from, to)
	local to_target = to - from
	local direction = Vector3.normalize(to_target)
	local distance = Vector3.length(to_target)
	local result, hit_position, hit_distance, normal, _ = PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", COLLISION_FILTER)

	return result, hit_position, hit_distance, normal
end

BtChaosHoundApproachAction._set_pounce_cooldown = function (self, unit, breed, scratchpad, target_unit, blackboard, t)
	local cooldown = Managers.state.difficulty:get_table_entry_by_challenge(MinionDifficultySettings.cooldowns.chaos_hound_pounce_fail)
	local pounce_component = Blackboard.write_component(blackboard, "pounce")
	pounce_component.pounce_cooldown = t + cooldown

	self:_add_threat_to_other_targets(unit, breed, scratchpad, target_unit)
end

BtChaosHoundApproachAction._add_threat_to_other_targets = function (self, unit, breed, scratchpad, excluded_target)
	local side_system = scratchpad.side_system
	local side = side_system.side_by_unit[unit]
	local valid_enemy_player_units = side.valid_enemy_player_units
	local num_enemies = #valid_enemy_player_units
	local perception_extension = ScriptUnit.extension(unit, "perception_system")
	local max_threat = breed.threat_config.max_threat

	for i = 1, num_enemies do
		local target_unit = valid_enemy_player_units[i]

		if target_unit ~= excluded_target then
			perception_extension:add_threat(target_unit, max_threat)
		end
	end
end

return BtChaosHoundApproachAction
