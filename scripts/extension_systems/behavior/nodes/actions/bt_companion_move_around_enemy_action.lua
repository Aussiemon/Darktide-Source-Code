-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_companion_move_around_enemy_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local MinionMovement = require("scripts/utilities/minion_movement")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local CompanionDogSettings = require("scripts/utilities/companion/companion_dog_settings")
local MinionAttack = require("scripts/utilities/minion_attack")
local BtCompanionMoveAroundEnemyAction = class("BtCompanionMoveAroundEnemyAction", "BtNode")
local lean_settings = CompanionDogSettings.leaning

BtCompanionMoveAroundEnemyAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = navigation_extension
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = Blackboard.write_component(blackboard, "perception")

	local speed = action_data.speed

	navigation_extension:set_enabled(true, speed)

	scratchpad.original_rotation_speed = locomotion_extension:rotation_speed()

	locomotion_extension:set_rotation_speed(action_data.rotation_speed)

	local follow_component = Blackboard.write_component(blackboard, "follow")

	scratchpad.follow_component = follow_component
	scratchpad.move_to_cooldown = 0
	scratchpad.force_idle = false

	local nav_world = navigation_extension:nav_world()

	scratchpad.nav_world = nav_world
	scratchpad.distance_sign = math.random(0, 1) == 0 and -1 or 1
	scratchpad.angle_sign = math.random(0, 1) == 0 and -1 or 1
	scratchpad.position_found = true
	scratchpad.switched_angle = 0
	scratchpad.distance_from_path = math.huge
	scratchpad.pushed_enemies = {}
end

BtCompanionMoveAroundEnemyAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	scratchpad.locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)
	scratchpad.navigation_extension:set_enabled(false)
end

local MAX_ANGLE_SWITCH = 1

BtCompanionMoveAroundEnemyAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if action_data.push_enemies_damage_profile then
		MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, unit, nil, action_data.push_ignored_breeds)
	end

	local behavior_component, perception_component = scratchpad.behavior_component, scratchpad.perception_component
	local move_state, target_unit = behavior_component.move_state, perception_component.target_unit

	if scratchpad.is_anim_driven and scratchpad.start_rotation_timing and t >= scratchpad.start_rotation_timing then
		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
	end

	if scratchpad.start_move_event_anim_speed_duration then
		if t < scratchpad.start_move_event_anim_speed_duration then
			MinionMovement.apply_animation_wanted_movement_speed(unit, scratchpad.navigation_extension, dt)
		else
			if not action_data.adapt_speed then
				scratchpad.navigation_extension:set_max_speed(action_data.speed)
			end

			scratchpad.start_move_event_anim_speed_duration = nil
		end
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

	if not scratchpad.force_move_to_target and (not scratchpad.new_position_cooldown_t or t > scratchpad.new_position_cooldown_t) then
		local navigation_extension = scratchpad.navigation_extension

		if not scratchpad.position_found then
			scratchpad.angle_sign = -scratchpad.angle_sign
			scratchpad.position_found = false

			if scratchpad.switched_angle >= MAX_ANGLE_SWITCH then
				local pounce_component = Blackboard.write_component(blackboard, "pounce")

				pounce_component.pounce_cooldown = 0

				return "failed"
			end

			scratchpad.switched_angle = scratchpad.switched_angle + 1
		elseif navigation_extension:is_following_path() then
			local path_distance = navigation_extension:remaining_distance_from_progress_to_end_of_path()

			scratchpad.angle_sign = path_distance > scratchpad.distance_from_path and -scratchpad.angle_sign or scratchpad.angle_sign

			if path_distance > scratchpad.distance_from_path then
				if scratchpad.switched_angle > MAX_ANGLE_SWITCH then
					local pounce_component = Blackboard.write_component(blackboard, "pounce")

					pounce_component.pounce_cooldown = 0

					return "failed"
				end

				scratchpad.switched_angle = scratchpad.switched_angle + 1
			end
		end

		local position_found = MinionMovement.update_move_around_target(unit, t, scratchpad, action_data, target_unit, scratchpad.distance_sign, scratchpad.angle_sign, scratchpad.force_move_to_target)

		if position_found then
			scratchpad.new_position_cooldown_t = t + action_data.new_position_cooldown
		end

		scratchpad.position_found = position_found
	end

	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)

	if scratchpad.force_idle or should_start_idle or should_be_idling then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)
		end

		return "running"
	end

	if move_state ~= "moving" then
		self:_start_move_anim(unit, scratchpad, action_data, t)
	end

	return "running"
end

BtCompanionMoveAroundEnemyAction._start_move_anim = function (self, unit, scratchpad, action_data, t)
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

BtCompanionMoveAroundEnemyAction._update_anim_lean_variable = function (self, unit, scratchpad, action_data, dt)
	local lean_value = MinionMovement.get_lean_animation_variable_value(unit, scratchpad, lean_settings, dt)

	if lean_value then
		local lean_variable_name = lean_settings.lean_variable_name

		scratchpad.animation_extension:set_variable(lean_variable_name, lean_value)
	end
end

return BtCompanionMoveAroundEnemyAction
