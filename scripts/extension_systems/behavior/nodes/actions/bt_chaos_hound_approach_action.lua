require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local MinionMovement = require("scripts/utilities/minion_movement")
local NavQueries = require("scripts/utilities/nav_queries")
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

	scratchpad.state = "approaching"
	scratchpad.side_system = Managers.state.extension:system("side_system")
	local spawn_component = blackboard.spawn
	scratchpad.physics_world = spawn_component.physics_world
	stagger_component.controlled_stagger = false
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

local UPDATE_TARGET_DISTANCE_SQ = 1
local IDLE_DURATION = 2
local NUM_FAILED_ATTEMPTS_TO_MANUAL_MOVE = 3

BtChaosHoundApproachAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local target_position = POSITION_LOOKUP[target_unit]
	local destination = scratchpad.navigation_extension:destination()
	local target_to_destination_distance_sq = Vector3.distance_squared(target_position, destination)
	local force_move = false

	if UPDATE_TARGET_DISTANCE_SQ < target_to_destination_distance_sq then
		force_move = true
	end

	local find_move_position_attempts = scratchpad.find_move_position_attempts

	if NUM_FAILED_ATTEMPTS_TO_MANUAL_MOVE <= find_move_position_attempts then
		self:_move_to_target(scratchpad)
	else
		MinionMovement.update_move_to_ranged_position(unit, t, scratchpad, action_data, target_unit, nil, nil, nil, force_move)
	end

	local distance_to_target = perception_component.target_distance

	if scratchpad.trigger_player_alert_vo_t < t and distance_to_target < action_data.trigger_player_alert_vo_distance then
		Vo.pouncing_alert_event(target_unit, breed)

		scratchpad.trigger_player_alert_vo_t = t + action_data.trigger_player_alert_vo_frequency
	end

	local behavior_component = scratchpad.behavior_component
	local is_in_stagger = scratchpad.stagger_duration and t <= scratchpad.stagger_duration
	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)

	if (should_start_idle or should_be_idling) and not is_in_stagger then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)

			scratchpad.idle_duration = t + IDLE_DURATION
		elseif scratchpad.idle_duration and scratchpad.idle_duration <= t then
			self:_set_pounce_cooldown(unit, breed, scratchpad, target_unit, blackboard, t)

			return "done"
		end

		return "running"
	end

	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		self:_start_move_anim(unit, scratchpad, action_data, t)
	end

	if scratchpad.is_anim_driven and scratchpad.start_rotation_timing and scratchpad.start_rotation_timing <= t then
		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
	end

	local navigation_extension = scratchpad.navigation_extension

	if scratchpad.start_move_event_anim_speed_duration then
		if t < scratchpad.start_move_event_anim_speed_duration then
			MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
		else
			navigation_extension:set_max_speed(action_data.speed)

			scratchpad.start_move_event_anim_speed_duration = nil
		end
	end

	local state = scratchpad.state

	if state == "approaching" then
		local can_start_leap = self:_can_start_leap(unit, scratchpad, action_data, perception_component, t)

		if can_start_leap then
			local too_close_distance = action_data.too_close_distance

			if distance_to_target <= too_close_distance then
				self:_set_pounce_cooldown(unit, breed, scratchpad, target_unit, blackboard, t)
			end

			return "done"
		end

		self:_update_anim_lean_variable(unit, scratchpad, action_data, dt)
		self:_update_ground_normal_rotation(unit, target_unit, scratchpad, false)

		local done_with_running_stagger = MinionMovement.update_running_stagger(unit, t, dt, scratchpad, action_data)

		if done_with_running_stagger then
			self:_start_move_anim(unit, scratchpad, action_data, t)
			self:_move_to_target(scratchpad)
		end
	end

	return "running"
end

local ABOVE = 1
local BELOW = 2

BtChaosHoundApproachAction._can_start_leap = function (self, unit, scratchpad, action_data, perception_component, t)
	local leave_distance = action_data.leave_distance
	local distance_to_target = perception_component.target_distance
	local target_unit = perception_component.target_unit
	local target_position = POSITION_LOOKUP[target_unit]
	local is_in_stagger = scratchpad.stagger_duration and t <= scratchpad.stagger_duration

	if is_in_stagger or leave_distance <= distance_to_target then
		return false
	end

	local self_position = POSITION_LOOKUP[unit]
	local navigation_extension = scratchpad.navigation_extension
	local nav_world = navigation_extension:nav_world()
	local traverse_logic = navigation_extension:traverse_logic()
	local target_position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, target_position, ABOVE, BELOW)

	if not target_position_on_navmesh then
		return false
	end

	local raycango = GwNavQueries.raycango(nav_world, self_position, target_position_on_navmesh, traverse_logic)

	if not raycango then
		return false
	end

	local los_from_position = POSITION_LOOKUP[unit] + Vector3.up()
	local los_to_position = target_position + Vector3.up()

	if self:_line_of_sight_check(los_from_position, los_to_position, scratchpad.physics_world) then
		return true
	end
end

BtChaosHoundApproachAction._line_of_sight_check = function (self, from, to, physics_world)
	local vector = to - from
	local distance = Vector3.length(vector)
	local direction = Vector3.normalize(vector)
	local hit = PhysicsWorld.raycast(physics_world, from, direction, distance, "all", "types", "both", "collision_filter", "filter_minion_line_of_sight_check")

	return not hit
end

BtChaosHoundApproachAction._start_move_anim = function (self, unit, scratchpad, action_data, t)
	local stagger_component = scratchpad.stagger_component

	if stagger_component.controlled_stagger then
		stagger_component.controlled_stagger = false
	end

	local animation_extension = scratchpad.animation_extension
	local start_move_anim_events = action_data.start_move_anim_events
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

	local success = goal_position ~= nil

	return success
end

BtChaosHoundApproachAction._update_anim_lean_variable = function (self, unit, scratchpad, action_data, dt)
	local is_following_path = scratchpad.navigation_extension:is_following_path()

	if not is_following_path then
		return
	end

	local lean_value = MinionMovement.get_lean_animation_variable_value(unit, scratchpad, action_data, dt)

	if lean_value then
		local lean_variable_name = action_data.lean_variable_name

		scratchpad.animation_extension:set_variable(lean_variable_name, lean_value)
	end
end

local TO_OFFSET_UP_DISTANCE = 2

BtChaosHoundApproachAction._update_ground_normal_rotation = function (self, unit, target_unit, scratchpad, towards_target)
	local physics_world = scratchpad.physics_world
	local self_position = POSITION_LOOKUP[unit]
	local offset_up = Vector3.up()
	local self_rotation = Unit.local_rotation(unit, 1)
	local forward = Vector3.normalize(Quaternion.forward(self_rotation))
	local from_position_1 = self_position + offset_up + forward
	local to_position_1 = from_position_1 - offset_up * TO_OFFSET_UP_DISTANCE
	local _, hit_position_1 = self:_ray_cast(physics_world, from_position_1, to_position_1)
	local from_position_2 = self_position + offset_up - forward
	local to_position_2 = from_position_2 - offset_up * TO_OFFSET_UP_DISTANCE
	local _, hit_position_2 = self:_ray_cast(physics_world, from_position_2, to_position_2)

	if hit_position_1 and hit_position_2 then
		local locomotion_extension = scratchpad.locomotion_extension
		local current_velocity = locomotion_extension:current_velocity()
		local velocity_normalized = Vector3.normalize(current_velocity)
		local wanted_direction = Vector3.normalize(hit_position_1 - hit_position_2)
		wanted_direction[1] = velocity_normalized[1]
		wanted_direction[2] = velocity_normalized[2]
		local wanted_rotation = Quaternion.look(wanted_direction)

		locomotion_extension:set_wanted_rotation(wanted_rotation)
	end
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
	local cooldown = Managers.state.difficulty:get_table_entry_by_challenge(MinionDifficultySettings.cooldowns.chaos_hound_pounce)
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
