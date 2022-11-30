require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local AttackIntensity = require("scripts/utilities/attack_intensity")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local Vo = require("scripts/utilities/vo")
local BtShootAction = class("BtShootAction", "BtNode")
local SHOOT_NOT_ALLOWED_REEVALUATE_RANGE = {
	0.25,
	0.75
}
local DEFAULT_NOT_ALLOWED_COOLDOWN = 0.5

BtShootAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.animation_extension = animation_extension
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
	local perception_component = Blackboard.write_component(blackboard, "perception")
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = perception_component
	scratchpad.combat_vector_component = blackboard.combat_vector

	MinionAttack.init_scratchpad_shooting_variables(unit, scratchpad, action_data, blackboard, breed)

	local target_unit = perception_component.target_unit
	local attack_allowed = AttackIntensity.minion_can_attack(unit, action_data.attack_intensity_type, target_unit)

	if attack_allowed then
		local vo_event = action_data.vo_event

		if vo_event then
			Vo.enemy_generic_vo_event(unit, vo_event, breed.name)
		end

		self:_start_aiming(unit, t, scratchpad, action_data)
	else
		if action_data.new_combat_vector_position_on_cooldown then
			local combat_vector_extension = ScriptUnit.extension(unit, "combat_vector_system")

			combat_vector_extension:look_for_new_location(action_data.new_combat_vector_position_min_distance)
		end

		scratchpad.behavior_component.move_state = "attacking"
		local not_allowed_cooldown = action_data.not_allowed_cooldown or DEFAULT_NOT_ALLOWED_COOLDOWN

		self:_start_cooldown(unit, t, scratchpad, action_data, not_allowed_cooldown)

		if not action_data.cooldown_anim_events and action_data.idle_anim_events then
			local idle_anim_event = Animation.random_event(action_data.idle_anim_events)

			animation_extension:anim_event(idle_anim_event)
		end

		scratchpad.should_reevaluate_in_t = t + math.random_range(SHOOT_NOT_ALLOWED_REEVALUATE_RANGE[1], SHOOT_NOT_ALLOWED_REEVALUATE_RANGE[2])
	end

	scratchpad.original_rotation_speed = locomotion_extension:rotation_speed()
	local rotation_speed = action_data.rotation_speed

	if rotation_speed then
		locomotion_extension:set_rotation_speed(rotation_speed)
	end

	if action_data.strafe_shoot_ranged_position_fallback then
		MinionMovement.init_find_ranged_position(scratchpad, action_data)
	end

	scratchpad.strafe_anim_switch_duration = 0

	if action_data.cover_crouch_check then
		local cover_system = Managers.state.extension:system("cover_system")
		scratchpad.cover_system = cover_system
	end
end

BtShootAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local state = scratchpad.state
	local perception_component = scratchpad.perception_component

	if state == "aiming" then
		MinionPerception.set_target_lock(unit, perception_component, false)
	elseif scratchpad.shooting then
		MinionAttack.stop_shooting(unit, scratchpad)
	end

	if scratchpad.is_anim_rotation_driven then
		MinionMovement.set_anim_rotation_driven(scratchpad, false)
	end

	scratchpad.navigation_extension:set_enabled(false)

	local reposition_if_not_clear_shot = action_data.reposition_if_not_clear_shot

	if reposition_if_not_clear_shot then
		local target_unit = perception_component.target_unit
		local has_clear_shot = ALIVE[target_unit] and self:_has_clear_shot(unit, scratchpad, action_data)

		if not has_clear_shot then
			local min_distance = action_data.min_clear_shot_combat_vector_distance
			local combat_vector_extension = ScriptUnit.extension(unit, "combat_vector_system")

			combat_vector_extension:look_for_new_location(min_distance)
		end
	end

	scratchpad.locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)
end

local MIN_NEEDED_PATH_DISTANCE = 5

BtShootAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local state = scratchpad.state

	if scratchpad.attempting_multi_target_switch then
		scratchpad.attempting_multi_target_switch = false
		local perception_component = scratchpad.perception_component

		if perception_component.target_changed then
			MinionPerception.switched_multi_target_unit(scratchpad, t, action_data.multi_target_config)
		end

		if scratchpad.shooting then
			MinionPerception.set_target_lock(unit, perception_component, true)
		end
	end

	local is_anim_rotation_driven = scratchpad.is_anim_rotation_driven

	if is_anim_rotation_driven and scratchpad.start_rotation_timing and scratchpad.start_rotation_timing <= t then
		local destination = POSITION_LOOKUP[scratchpad.perception_component.target_unit]
		local ignore_set_anim_driven = true

		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t, destination, ignore_set_anim_driven)
		MinionMovement.set_anim_rotation(unit, scratchpad)
	end

	local has_line_of_sight = scratchpad.perception_component.has_line_of_sight

	if has_line_of_sight and action_data.can_strafe_shoot and state == "shooting" and (not scratchpad.next_try_to_strafe_shoot or scratchpad.next_try_to_strafe_shoot <= t) then
		self:_try_start_strafe_shooting(unit, t, scratchpad, action_data, breed)
	end

	if state == "aiming" then
		self:_update_aiming(unit, t, scratchpad, action_data)
	elseif state == "shooting" then
		self:_update_shooting(unit, t, scratchpad, action_data)
	elseif state == "trying_to_strafe_shoot" then
		self:_update_trying_to_strafe_shoot(unit, t, scratchpad, action_data)
	elseif state == "strafe_shooting" then
		self:_update_strafe_shooting(unit, t, scratchpad, action_data)
	elseif state == "cooldown" then
		local done = self:_update_cooldown(unit, t, scratchpad, action_data, breed)

		if action_data.exit_after_cooldown and done then
			return "done"
		elseif done then
			return "running", true
		end
	end

	if scratchpad.should_reevaluate_in_t and scratchpad.should_reevaluate_in_t <= t then
		scratchpad.should_reevaluate = true
		scratchpad.should_reevaluate_in_t = nil
	end

	return "running", scratchpad.should_reevaluate
end

local DEFAULT_COVER_IGNORE_CROUCH_DISTANCE = 5
local DEFAULT_NUM_AGGROED_FOR_FRIENDLY_FIRE_CALLOUT = 8

BtShootAction._start_aiming = function (self, unit, t, scratchpad, action_data)
	local shoot_turn_anims = action_data.shoot_turn_anims
	local triggered_turn_anim = nil

	if shoot_turn_anims then
		local rotation = Unit.local_rotation(unit, 1)
		local forward = Quaternion.forward(rotation)
		local right = Quaternion.right(rotation)
		local position = POSITION_LOOKUP[unit]
		local target_position = POSITION_LOOKUP[scratchpad.perception_component.target_unit]
		local direction = Vector3.flat(Vector3.normalize(target_position - position))
		local relative_direction_name = MinionMovement.get_relative_direction_name(right, forward, direction)
		local turn_anim_events = shoot_turn_anims[relative_direction_name]

		if turn_anim_events then
			local turn_anim_event = Animation.random_event(turn_anim_events)
			local start_move_rotation_timings = action_data.start_move_rotation_timings
			local start_rotation_timing = start_move_rotation_timings[turn_anim_event]
			scratchpad.start_rotation_timing = t + start_rotation_timing
			scratchpad.move_start_anim_event_name = turn_anim_event
			scratchpad.current_aim_anim_event = turn_anim_event
			triggered_turn_anim = true

			MinionMovement.set_anim_rotation_driven(scratchpad, true)
			scratchpad.animation_extension:anim_event(turn_anim_event)
		end
	end

	if not triggered_turn_anim then
		local aim_anim_events = action_data.aim_anim_events or "aim"
		local aim_event = Animation.random_event(aim_anim_events)

		if scratchpad.cover_system and aim_event == "aim_crouching" then
			local nearby_cover_slots = scratchpad.cover_system:find_cover_slots(POSITION_LOOKUP[unit], DEFAULT_COVER_IGNORE_CROUCH_DISTANCE)

			if #nearby_cover_slots > 0 then
				aim_event = action_data.cover_crouch_check_replacement_anim_event
			end
		end

		local current_aim_anim_event = scratchpad.current_aim_anim_event

		if not current_aim_anim_event or aim_event ~= current_aim_anim_event then
			scratchpad.animation_extension:anim_event(aim_event)

			scratchpad.current_aim_anim_event = aim_event
		end
	end

	scratchpad.behavior_component.move_state = "attacking"
	local aim_durations = action_data.aim_duration[scratchpad.current_aim_anim_event]
	local diff_aim_durations = Managers.state.difficulty:get_table_entry_by_challenge(aim_durations)
	local aim_duration = math.random_range(diff_aim_durations[1], diff_aim_durations[2])
	scratchpad.state = "aiming"
	scratchpad.aim_duration = t + aim_duration

	if action_data.aim_rotation_anims and not triggered_turn_anim then
		MinionMovement.set_anim_rotation_driven(scratchpad, true)
	end

	MinionPerception.set_target_lock(unit, scratchpad.perception_component, true)

	local friendly_fire_callout_vo_event = action_data.friendly_fire_callout_vo_event

	if friendly_fire_callout_vo_event then
		local num_aggroed_minions = Managers.state.pacing:num_aggroed_minions()

		if DEFAULT_NUM_AGGROED_FOR_FRIENDLY_FIRE_CALLOUT <= num_aggroed_minions then
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local breed = unit_data_extension:breed()

			Vo.enemy_generic_vo_event(unit, friendly_fire_callout_vo_event, breed.name)
		end
	end

	local before_shoot_effect_template_timing = action_data.before_shoot_effect_template_timing

	if before_shoot_effect_template_timing and not scratchpad.before_shoot_effect_template_timing then
		scratchpad.before_shoot_effect_template_timing = scratchpad.aim_duration - before_shoot_effect_template_timing
	end
end

local AIM_TURN_DOT_THRESHOLD = 0.75
local AIM_TURN_FWD_DOT_THRESHOLD = 0.9

BtShootAction._update_aim_turning = function (self, unit, scratchpad, aim_dot, flat_to_target, aim_rotation_anims)
	local animation_extension = scratchpad.animation_extension
	local current_aim_rotation_direction_name = scratchpad.current_aim_rotation_direction_name

	if aim_dot < AIM_TURN_DOT_THRESHOLD then
		local unit_rotation = Unit.local_rotation(unit, 1)
		local unit_forward = Quaternion.forward(unit_rotation)
		local is_to_the_left = Vector3.cross(unit_forward, flat_to_target).z > 0

		if is_to_the_left and current_aim_rotation_direction_name ~= "left" then
			animation_extension:anim_event(aim_rotation_anims.left)

			scratchpad.current_aim_rotation_direction_name = "left"
		elseif not is_to_the_left and current_aim_rotation_direction_name ~= "right" then
			animation_extension:anim_event(aim_rotation_anims.right)

			scratchpad.current_aim_rotation_direction_name = "right"
		end
	elseif current_aim_rotation_direction_name ~= "fwd" and AIM_TURN_FWD_DOT_THRESHOLD < aim_dot then
		animation_extension:anim_event(aim_rotation_anims.fwd)

		scratchpad.current_aim_rotation_direction_name = "fwd"
	end

	local is_facing_target = scratchpad.current_aim_rotation_direction_name == "fwd"

	return is_facing_target
end

BtShootAction._update_aiming = function (self, unit, t, scratchpad, action_data)
	MinionAttack.aim_at_target(unit, scratchpad, t, action_data)

	local attack_delay = MinionAttack.get_attack_delay(unit)
	local aim_duration = math.max(scratchpad.aim_duration - t, 0)
	local time_left_to_start_shooting = aim_duration + attack_delay

	if time_left_to_start_shooting == 0 and not scratchpad.rotation_duration then
		local perception_component = scratchpad.perception_component
		local target_unit = perception_component.target_unit
		local attack_allowed = action_data.skip_attack_intensity_during_aim or AttackIntensity.minion_can_attack(unit, action_data.attack_intensity_type, target_unit)

		if attack_allowed then
			if scratchpad.is_anim_rotation_driven then
				local aim_rotation_anims = action_data.aim_rotation_anims

				if not aim_rotation_anims then
					MinionMovement.set_anim_rotation_driven(scratchpad, false)
				else
					local current_aim_rotation_direction_name = scratchpad.current_aim_rotation_direction_name

					if current_aim_rotation_direction_name and current_aim_rotation_direction_name ~= "fwd" then
						scratchpad.animation_extension:anim_event(aim_rotation_anims.fwd)

						scratchpad.current_aim_rotation_direction_name = "fwd"
					end
				end
			end

			MinionPerception.set_target_lock(unit, perception_component, false)
			self:_start_shooting(unit, t, scratchpad, action_data)
		else
			scratchpad.should_reevaluate = true
		end
	end
end

BtShootAction._start_shooting = function (self, unit, t, scratchpad, action_data)
	local shoot_template = action_data.shoot_template
	local shoot_delay = action_data.before_shoot_effect_template_timing or shoot_template.scope_reflection_timing

	MinionAttack.start_shooting(unit, scratchpad, t, action_data, shoot_delay)

	scratchpad.state = "shooting"

	if action_data.aim_rotation_anims and not scratchpad.is_anim_rotation_driven then
		MinionMovement.set_anim_rotation_driven(scratchpad, true)
	end
end

BtShootAction._update_shooting = function (self, unit, t, scratchpad, action_data)
	local _, aim_dot, flat_to_target = MinionAttack.aim_at_target(unit, scratchpad, t, action_data)
	local aim_rotation_anims = action_data.aim_rotation_anims

	if aim_dot and aim_rotation_anims then
		self:_update_aim_turning(unit, scratchpad, aim_dot, flat_to_target, aim_rotation_anims)
	end

	if not aim_dot or aim_dot < 0 then
		return false
	end

	local multi_target_config = action_data.multi_target_config
	local fired_shot, fired_last_shot = MinionAttack.update_shooting(unit, scratchpad, t, action_data)

	if multi_target_config and fired_shot and not fired_last_shot then
		local is_target_locked = true

		MinionPerception.evaluate_multi_target_switch(unit, scratchpad, t, multi_target_config, is_target_locked)
	end

	if fired_last_shot then
		if scratchpad.is_anim_rotation_driven then
			MinionMovement.set_anim_rotation_driven(scratchpad, false)

			local current_aim_rotation_direction_name = scratchpad.current_aim_rotation_direction_name

			if current_aim_rotation_direction_name and current_aim_rotation_direction_name ~= "fwd" then
				scratchpad.animation_extension:anim_event(aim_rotation_anims.fwd)

				scratchpad.current_aim_rotation_direction_name = "fwd"
			end
		end

		self:_start_cooldown(unit, t, scratchpad, action_data)

		return true
	end

	return false
end

local MAX_TRYING_TO_START_STRAFE_SHOOT_DURATION = 3
local MIN_COMBAT_VECTOR_DISTANCE_CHANGE_SQ = 9
local TRY_TO_STRAFE_SHOOT_COOLDOWN = {
	3,
	6
}

BtShootAction._try_start_strafe_shooting = function (self, unit, t, scratchpad, action_data, breed)
	local combat_vector_component = scratchpad.combat_vector_component
	local combat_vector_position = combat_vector_component.position:unbox()
	local wanted_position = combat_vector_position
	local perception_component = scratchpad.perception_component
	local target_distance = perception_component.target_distance
	local self_position = POSITION_LOOKUP[unit]
	local distance = Vector3.distance(self_position, combat_vector_position)
	local target_unit = perception_component.target_unit
	local target_position = POSITION_LOOKUP[perception_component.target_unit]
	local target_to_combat_vector_distance = Vector3.distance(combat_vector_position, target_position)

	if distance < action_data.strafe_shoot_distance or target_distance < target_to_combat_vector_distance then
		local ranged_position = action_data.strafe_shoot_ranged_position_fallback and MinionMovement.find_ranged_position(unit, t, scratchpad, action_data, target_unit)

		if ranged_position and action_data.strafe_shoot_distance < Vector3.distance(ranged_position, self_position) then
			wanted_position = ranged_position
		else
			return
		end
	end

	local previous_strafe_shoot_position = scratchpad.previous_strafe_shoot_position

	if previous_strafe_shoot_position then
		local previous_distance_sq = Vector3.distance_squared(wanted_position, previous_strafe_shoot_position:unbox())

		if previous_distance_sq < MIN_COMBAT_VECTOR_DISTANCE_CHANGE_SQ then
			return
		end
	end

	local navigation_extension = scratchpad.navigation_extension

	navigation_extension:set_enabled(true, action_data.strafe_speed or breed.walk_speed)
	navigation_extension:stop()
	navigation_extension:move_to(wanted_position)

	if scratchpad.previous_strafe_shoot_position then
		scratchpad.previous_strafe_shoot_position:store(wanted_position)
	else
		scratchpad.previous_strafe_shoot_position = Vector3Box(wanted_position)
	end

	scratchpad.state = "trying_to_strafe_shoot"
	scratchpad.trying_to_start_strafe_shooting_duration = t + MAX_TRYING_TO_START_STRAFE_SHOOT_DURATION
	scratchpad.next_try_to_strafe_shoot = t + math.random_range(TRY_TO_STRAFE_SHOOT_COOLDOWN[1], TRY_TO_STRAFE_SHOOT_COOLDOWN[2])
end

BtShootAction._update_trying_to_strafe_shoot = function (self, unit, t, scratchpad, action_data)
	local navigation_extension = scratchpad.navigation_extension
	local done = self:_update_shooting(unit, t, scratchpad, action_data)

	if done then
		navigation_extension:set_enabled(false)

		return
	end

	local is_following_path = navigation_extension:is_following_path()

	if not is_following_path then
		if scratchpad.trying_to_start_strafe_shooting_duration < t then
			navigation_extension:set_enabled(false)

			scratchpad.state = "shooting"
		end

		return
	end

	local has_upcoming_smart_object, _ = navigation_extension:path_distance_to_next_smart_object(MIN_NEEDED_PATH_DISTANCE)

	if has_upcoming_smart_object then
		navigation_extension:set_enabled(false)

		scratchpad.state = "shooting"

		return
	end

	scratchpad.moving_direction_name = nil
	scratchpad.state = "strafe_shooting"

	if scratchpad.is_anim_rotation_driven then
		MinionMovement.set_anim_rotation_driven(scratchpad, false)
	end
end

local STRAFE_ANIM_SWITCH_DURATION = 0.25

BtShootAction._update_strafe_shooting = function (self, unit, t, scratchpad, action_data)
	local navigation_extension = scratchpad.navigation_extension
	local is_following_path = navigation_extension:is_following_path()
	local has_upcoming_smart_object = is_following_path and navigation_extension:path_distance_to_next_smart_object(MIN_NEEDED_PATH_DISTANCE)

	if not is_following_path or has_upcoming_smart_object then
		self:_stop_strafe_shooting(unit, t, scratchpad, action_data)

		return
	end

	local target_unit = scratchpad.perception_component.target_unit

	MinionAttack.aim_at_target(unit, scratchpad, t, action_data)

	if not scratchpad.shooting then
		local attack_allowed = AttackIntensity.minion_can_attack(unit, action_data.attack_intensity_type, target_unit)

		if attack_allowed then
			local shoot_template = action_data.shoot_template
			local scope_reflection_timing = shoot_template.scope_reflection_timing

			MinionAttack.start_shooting(unit, scratchpad, t, action_data, scope_reflection_timing)
		else
			scratchpad.should_reevaluate = true
		end
	end

	local self_position = POSITION_LOOKUP[unit]
	local target_position = POSITION_LOOKUP[target_unit]
	local rotation = Quaternion.look(target_position - self_position)
	local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad, nil, rotation)

	if moving_direction_name ~= scratchpad.moving_direction_name and scratchpad.strafe_anim_switch_duration <= t then
		local strafe_anim_events = action_data.strafe_anim_events
		local start_move_event = strafe_anim_events[moving_direction_name]

		scratchpad.animation_extension:anim_event(start_move_event)

		scratchpad.moving_direction_name = moving_direction_name
		scratchpad.current_aim_anim_event = start_move_event
		local strafe_speeds = action_data.strafe_speeds
		local strafe_speed = strafe_speeds and strafe_speeds[start_move_event]

		if strafe_speed then
			navigation_extension:set_max_speed(strafe_speed)
		end

		scratchpad.strafe_anim_switch_duration = t + STRAFE_ANIM_SWITCH_DURATION
	end

	local current_strafe_direction = scratchpad.moving_direction_name
	local current_node, next_node_in_path = scratchpad.navigation_extension:current_and_next_node_positions_in_path()
	local destination = next_node_in_path or current_node
	local flat_direction = Vector3.normalize(Vector3.flat(destination - self_position))
	local wanted_rotation = nil

	if current_strafe_direction == "fwd" then
		wanted_rotation = Quaternion.look(flat_direction)
	elseif current_strafe_direction == "left" then
		wanted_rotation = Quaternion.look(Vector3.cross(flat_direction, Vector3.up()))
	elseif current_strafe_direction == "right" then
		wanted_rotation = Quaternion.look(-Vector3.cross(flat_direction, Vector3.up()))
	else
		wanted_rotation = Quaternion.look(-flat_direction)
	end

	scratchpad.locomotion_extension:set_wanted_rotation(wanted_rotation)

	local has_reached_destination = navigation_extension:has_reached_destination()

	if has_reached_destination then
		self:_stop_strafe_shooting(unit, t, scratchpad, action_data)
	elseif scratchpad.shooting then
		local fired_shot, fired_last_shot = MinionAttack.update_shooting(unit, scratchpad, t, action_data)

		if fired_last_shot then
			local attack_allowed = AttackIntensity.minion_can_attack(unit, action_data.attack_intensity_type, target_unit)

			if attack_allowed then
				local cooldown_range = action_data.shoot_cooldown
				local diff_cooldown_range = Managers.state.difficulty:get_table_entry_by_challenge(cooldown_range)
				local first_shoot_timing = math.random_range(diff_cooldown_range[1], diff_cooldown_range[2])

				MinionAttack.start_shooting(unit, scratchpad, t, action_data, first_shoot_timing)

				if action_data.exit_after_cooldown then
					scratchpad.should_reevaluate = true
				end
			else
				scratchpad.should_reevaluate = true
			end
		end

		local multi_target_config = action_data.multi_target_config

		if multi_target_config and fired_shot and not fired_last_shot then
			local is_target_locked = true

			MinionPerception.evaluate_multi_target_switch(unit, scratchpad, t, multi_target_config, is_target_locked)
		end
	end
end

BtShootAction._stop_strafe_shooting = function (self, unit, t, scratchpad, action_data)
	scratchpad.navigation_extension:set_enabled(false)
	scratchpad.animation_extension:anim_event(action_data.strafe_end_anim_event)

	if scratchpad.shooting then
		scratchpad.state = "shooting"

		if action_data.aim_rotation_anims then
			MinionMovement.set_anim_rotation_driven(scratchpad, true)
		end
	else
		self:_start_aiming(unit, t, scratchpad, action_data)
	end
end

local DEFAULT_COOLDOWN_ANIM_EVENT = "idle"

BtShootAction._start_cooldown = function (self, unit, t, scratchpad, action_data, optional_cooldown_duration)
	local cooldown_range = action_data.shoot_cooldown
	local cooldown = optional_cooldown_duration

	if not cooldown then
		local diff_cooldown_range = Managers.state.difficulty:get_table_entry_by_challenge(cooldown_range)
		cooldown = math.random_range(diff_cooldown_range[1], diff_cooldown_range[2])
	end

	scratchpad.cooldown = t + cooldown
	scratchpad.state = "cooldown"
	local behavior_component = scratchpad.behavior_component

	if not scratchpad.current_aim_anim_event then
		if behavior_component.move_state ~= "idle" then
			local cooldown_anim_events = action_data.cooldown_anim_events or DEFAULT_COOLDOWN_ANIM_EVENT
			local cooldown_anim_event = Animation.random_event(cooldown_anim_events)

			scratchpad.animation_extension:anim_event(cooldown_anim_event)
		end
	else
		local out_of_aim_anim = action_data.out_of_aim_anim_event

		if out_of_aim_anim then
			scratchpad.animation_extension:anim_event(out_of_aim_anim)

			scratchpad.current_aim_anim_event = nil
		end
	end

	behavior_component.move_state = "idle"
	local cooldown_vo_event = action_data.cooldown_vo_event

	if cooldown_vo_event then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()

		Vo.enemy_generic_vo_event(unit, cooldown_vo_event, breed.name)
	end
end

BtShootAction._update_cooldown = function (self, unit, t, scratchpad, action_data, breed)
	local target_unit = scratchpad.perception_component.target_unit

	MinionAttack.aim_at_target(unit, scratchpad, t, action_data)

	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

	scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)

	if scratchpad.cooldown < t then
		local attack_allowed = AttackIntensity.minion_can_attack(unit, action_data.attack_intensity_type, target_unit)

		if attack_allowed then
			self:_start_aiming(unit, t, scratchpad, action_data)

			local vo_event = action_data.vo_event

			if vo_event then
				Vo.enemy_generic_vo_event(unit, vo_event, breed.name)
			end
		end

		return true
	end
end

BtShootAction._has_clear_shot = function (self, unit, scratchpad, action_data)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local line_of_sight_id = action_data.clear_shot_line_of_sight_id
	local perception_extension = scratchpad.perception_extension
	local has_clear_shot = perception_extension:has_line_of_sight_by_id(target_unit, line_of_sight_id)

	return has_clear_shot
end

return BtShootAction
