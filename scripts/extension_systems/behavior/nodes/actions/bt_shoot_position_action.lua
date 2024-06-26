-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_shoot_position_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local Vo = require("scripts/utilities/vo")
local BtShootPositionAction = class("BtShootPositionAction", "BtNode")

BtShootPositionAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
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

	local vo_event = action_data.vo_event

	if vo_event then
		Vo.enemy_generic_vo_event(unit, vo_event, breed.name)
	end

	self:_start_aiming(unit, t, scratchpad, action_data)

	scratchpad.original_rotation_speed = locomotion_extension:rotation_speed()

	local rotation_speed = action_data.rotation_speed

	if rotation_speed then
		locomotion_extension:set_rotation_speed(rotation_speed)
	end
end

BtShootPositionAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local state, perception_component = scratchpad.state, scratchpad.perception_component

	if state == "aiming" then
		MinionPerception.set_target_lock(unit, perception_component, false)
	elseif scratchpad.shooting then
		MinionAttack.stop_shooting(unit, scratchpad)
	end

	if scratchpad.is_anim_rotation_driven then
		MinionMovement.set_anim_rotation_driven(scratchpad, false)
	end

	scratchpad.locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)
end

BtShootPositionAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local state = scratchpad.state
	local is_anim_rotation_driven = scratchpad.is_anim_rotation_driven

	if is_anim_rotation_driven and scratchpad.start_rotation_timing and t >= scratchpad.start_rotation_timing then
		local destination = POSITION_LOOKUP[scratchpad.perception_component.target_unit]
		local ignore_set_anim_driven = true

		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t, destination, ignore_set_anim_driven)
		MinionMovement.set_anim_rotation(unit, scratchpad)
	end

	if state == "aiming" then
		self:_update_aiming(unit, t, scratchpad, action_data)
	elseif state == "shooting" then
		self:_update_shooting(unit, t, scratchpad, action_data)
	end

	return "running", scratchpad.should_reevaluate
end

local DEFAULT_NUM_AGGROED_FOR_FRIENDLY_FIRE_CALLOUT = 8

BtShootPositionAction._start_aiming = function (self, unit, t, scratchpad, action_data)
	local shoot_turn_anims = action_data.shoot_turn_anims
	local triggered_turn_anim

	if shoot_turn_anims then
		local rotation = Unit.local_rotation(unit, 1)
		local forward = Quaternion.forward(rotation)
		local right = Quaternion.right(rotation)
		local position = POSITION_LOOKUP[unit]
		local target_position = scratchpad.perception_component.target_position:unbox()
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

	local friendly_fire_callout_vo_event = action_data.friendly_fire_callout_vo_event

	if friendly_fire_callout_vo_event then
		local num_aggroed_minions = Managers.state.pacing:num_aggroed_minions()

		if num_aggroed_minions >= DEFAULT_NUM_AGGROED_FOR_FRIENDLY_FIRE_CALLOUT then
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

BtShootPositionAction._update_aim_turning = function (self, unit, scratchpad, aim_dot, flat_to_target, aim_rotation_anims)
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
	elseif current_aim_rotation_direction_name ~= "fwd" and aim_dot >= AIM_TURN_FWD_DOT_THRESHOLD then
		animation_extension:anim_event(aim_rotation_anims.fwd)

		scratchpad.current_aim_rotation_direction_name = "fwd"
	end

	local is_facing_target = scratchpad.current_aim_rotation_direction_name == "fwd"

	return is_facing_target
end

BtShootPositionAction._update_aiming = function (self, unit, t, scratchpad, action_data)
	local target_position = scratchpad.perception_component.target_position:unbox()

	MinionAttack.aim_at_position(unit, scratchpad, t, action_data, target_position)

	local attack_delay = MinionAttack.get_attack_delay(unit)
	local aim_duration = math.max(scratchpad.aim_duration - t, 0)
	local time_left_to_start_shooting = aim_duration + attack_delay

	if time_left_to_start_shooting == 0 and not scratchpad.rotation_duration then
		local perception_component = scratchpad.perception_component

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
	end
end

BtShootPositionAction._start_shooting = function (self, unit, t, scratchpad, action_data)
	local shoot_template = action_data.shoot_template
	local shoot_delay = action_data.before_shoot_effect_template_timing or shoot_template.scope_reflection_timing

	MinionAttack.start_shooting(unit, scratchpad, t, action_data, shoot_delay)

	scratchpad.state = "shooting"
	scratchpad.num_shots = math.huge

	if action_data.aim_rotation_anims and not scratchpad.is_anim_rotation_driven then
		MinionMovement.set_anim_rotation_driven(scratchpad, true)
	end
end

BtShootPositionAction._update_shooting = function (self, unit, t, scratchpad, action_data)
	local target_position = scratchpad.perception_component.target_position:unbox()
	local _, aim_dot, flat_to_target = MinionAttack.aim_at_position(unit, scratchpad, t, action_data, target_position)
	local aim_rotation_anims = action_data.aim_rotation_anims

	if aim_dot and aim_rotation_anims then
		self:_update_aim_turning(unit, scratchpad, aim_dot, flat_to_target, aim_rotation_anims)
	end

	if aim_dot < 0 then
		return false
	end

	MinionAttack.update_shooting(unit, scratchpad, t, action_data)

	return false
end

return BtShootPositionAction
