-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_companion_approach_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local CompanionDogLocomotionSettings = require("scripts/settings/companion/companion_dog_locomotion_settings")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionMovement = require("scripts/utilities/minion_movement")
local NavQueries = require("scripts/utilities/nav_queries")
local dog_leap_settings = CompanionDogLocomotionSettings.dog_leap_settings
local lean_settings = CompanionDogLocomotionSettings.leaning
local BtCompanionApproachAction = class("BtCompanionApproachAction", "BtNode")

BtCompanionApproachAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = navigation_extension
	scratchpad.pounce_component = Blackboard.write_component(blackboard, "pounce")
	scratchpad.pounce_component.use_fast_jump = false
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = Blackboard.write_component(blackboard, "perception")

	local speed = action_data.speed

	navigation_extension:set_enabled(true, speed)

	scratchpad.original_rotation_speed = locomotion_extension:rotation_speed()

	locomotion_extension:set_rotation_speed(action_data.rotation_speed)

	scratchpad.side_system = Managers.state.extension:system("side_system")

	local follow_component = Blackboard.write_component(blackboard, "follow")

	scratchpad.follow_component = follow_component

	local spawn_component = blackboard.spawn

	scratchpad.physics_world = spawn_component.physics_world
	scratchpad.check_leap_t = 0
	scratchpad.num_failed_leap_checks = 0
	scratchpad.trigger_player_alert_vo_t = 0

	local nav_world = navigation_extension:nav_world()

	scratchpad.nav_world = nav_world

	if action_data.adapt_speed then
		scratchpad.current_speed_timer = 0
	end

	scratchpad.forbid_fast_jump_t = t + action_data.forbid_fast_jump_t
	scratchpad.pushed_enemies = {}
end

BtCompanionApproachAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	scratchpad.locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)
	scratchpad.navigation_extension:set_enabled(false)
end

local IDLE_DURATION = 2

BtCompanionApproachAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if action_data.push_enemies_damage_profile then
		MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, unit, nil, action_data.push_ignored_breeds)
	end

	local behavior_component, perception_component = scratchpad.behavior_component, scratchpad.perception_component
	local move_state, target_unit = behavior_component.move_state, perception_component.target_unit
	local navigation_extension = scratchpad.navigation_extension

	if scratchpad.is_anim_driven and scratchpad.start_rotation_timing and t >= scratchpad.start_rotation_timing then
		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
	end

	if scratchpad.start_move_event_anim_speed_duration then
		if t < scratchpad.start_move_event_anim_speed_duration then
			MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
		else
			if not action_data.adapt_speed then
				navigation_extension:set_max_speed(action_data.speed)
			end

			scratchpad.start_move_event_anim_speed_duration = nil
		end
	end

	if scratchpad.move_to_position and not scratchpad.is_anim_driven and not scratchpad.start_move_event_anim_speed_duration and action_data.adapt_speed then
		local speed_threshold = 0

		MinionMovement.smooth_speed_based_on_distance(unit, scratchpad, dt, action_data, breed, false, speed_threshold)
	end

	local animation_speed_thresholds = breed.get_animation_speed_thresholds and breed.get_animation_speed_thresholds() or breed.animation_speed_thresholds

	if not scratchpad.is_anim_driven and not scratchpad.start_move_event_anim_speed_duration and animation_speed_thresholds then
		MinionMovement.companion_select_movement_animation(unit, scratchpad, dt, action_data, breed)
	end

	local is_following_path = scratchpad.navigation_extension:is_following_path()

	if is_following_path then
		self:_update_anim_lean_variable(unit, scratchpad, action_data, dt)
	end

	MinionMovement.update_ground_normal_rotation(unit, scratchpad, nil, 0.7)

	local can_start_leap = self:_can_start_leap(unit, scratchpad, action_data, perception_component, t)

	if can_start_leap then
		if not scratchpad.skip_fast_jump and t > scratchpad.forbid_fast_jump_t then
			local found_flat_direction = Vector3.normalize(Vector3.flat(POSITION_LOOKUP[target_unit] - POSITION_LOOKUP[unit]))
			local wanted_flat_direction = Vector3.normalize(Quaternion.forward(Unit.local_rotation(unit, 1)))

			if Vector3.equal(found_flat_direction, Vector3.zero()) then
				scratchpad.pounce_component.use_fast_jump = false
			else
				local angle = Vector3.angle(found_flat_direction, wanted_flat_direction)
				local speed = Vector3.length(scratchpad.locomotion_extension:current_velocity())

				if angle <= action_data.max_angle_for_fast_jump and speed > action_data.fast_jump_speed_threshold then
					scratchpad.pounce_component.use_fast_jump = true
				else
					scratchpad.pounce_component.use_fast_jump = false
				end
			end
		end

		if not scratchpad.pounce_component.use_fast_jump then
			navigation_extension:set_enabled(false)
		end

		return "done"
	end

	self:_move_to_target(scratchpad)

	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)

	if should_start_idle or should_be_idling then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)

			scratchpad.idle_duration = t + IDLE_DURATION
		elseif scratchpad.idle_duration and t >= scratchpad.idle_duration then
			return "failed"
		end

		return "running"
	end

	if move_state ~= "moving" then
		self:_start_move_anim(unit, scratchpad, action_data, t)
	end

	return "running"
end

local ABOVE, BELOW, LATERAL = 1, 2, 0.3
local NAV_Z_CORRECTION = 0.1

BtCompanionApproachAction._can_start_leap = function (self, unit, scratchpad, action_data, perception_component, t)
	local leap_leave_distance = dog_leap_settings.leap_leave_distance
	local target_distance = perception_component.target_distance

	if leap_leave_distance <= target_distance then
		return false, false
	end

	local target_unit = perception_component.target_unit
	local target_position = POSITION_LOOKUP[target_unit]
	local navigation_extension = scratchpad.navigation_extension
	local nav_world, traverse_logic = navigation_extension:nav_world(), navigation_extension:traverse_logic()
	local target_position_on_nav_mesh = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, target_position, ABOVE, BELOW, LATERAL)

	if not target_position_on_nav_mesh then
		return false, false
	end

	local position = POSITION_LOOKUP[unit]
	local raycango = GwNavQueries.raycango(nav_world, position, target_position_on_nav_mesh, traverse_logic)

	if not raycango then
		return false, false
	end

	local target_node_name = dog_leap_settings.leap_target_node_name
	local target_node = Unit.node(target_unit, target_node_name)
	local leap_target_position = Unit.world_position(target_unit, target_node) + Vector3(0, 0, dog_leap_settings.leap_target_z_offset)
	local target_locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local target_velocity = target_locomotion_extension:current_velocity()
	local leap_start_position = POSITION_LOOKUP[unit] + Vector3(0, 0, dog_leap_settings.leap_target_start_z_offset)
	local distance = Vector3.length(Vector3.flat(leap_target_position - leap_start_position))
	local success = distance < action_data.force_check_leap_distance or self:_check_leap(scratchpad.physics_world, leap_start_position, leap_target_position, target_velocity)

	if not success then
		return false, false
	end

	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local target_unit_breed = target_unit_data_extension:breed()
	local companion_pounce_setting = target_unit_breed.companion_pounce_setting
	local required_token = companion_pounce_setting.required_token

	if required_token then
		local required_token_name = required_token.name
		local token_extension = ScriptUnit.has_extension(target_unit, "token_system")

		if token_extension and token_extension:is_token_free_or_mine(unit, required_token_name) then
			token_extension:assign_token(unit, required_token_name)
		else
			return false, false
		end
	end

	return true
end

BtCompanionApproachAction._check_leap = function (self, physics_world, start_position, target_position, target_velocity)
	local collision_filter = dog_leap_settings.leap_collision_filter
	local radius = dog_leap_settings.leap_ray_trace_radius
	local hit_numbers = 1
	local has_hit = PhysicsWorld.linear_sphere_sweep(physics_world, start_position, target_position, radius, hit_numbers, "types", "both", "collision_filter", collision_filter)

	return not has_hit
end

BtCompanionApproachAction._start_move_anim = function (self, unit, scratchpad, action_data, t)
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

BtCompanionApproachAction._move_to_target = function (self, scratchpad)
	local navigation_extension = scratchpad.navigation_extension
	local nav_world, traverse_logic = navigation_extension:nav_world(), navigation_extension:traverse_logic()
	local target_unit = scratchpad.perception_component.target_unit
	local wanted_position = POSITION_LOOKUP[target_unit]
	local goal_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, wanted_position, ABOVE, BELOW, LATERAL)

	if goal_position then
		navigation_extension:move_to(goal_position)

		scratchpad.move_to_position = Vector3Box(goal_position)
	end
end

BtCompanionApproachAction._update_anim_lean_variable = function (self, unit, scratchpad, action_data, dt)
	local lean_value = MinionMovement.get_lean_animation_variable_value(unit, scratchpad, lean_settings, dt)

	if lean_value then
		local lean_variable_name = lean_settings.lean_variable_name

		scratchpad.animation_extension:set_variable(lean_variable_name, lean_value)
	end
end

return BtCompanionApproachAction
