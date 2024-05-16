-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_move_to_combat_vector_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local AttackIntensity = require("scripts/utilities/attack_intensity")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local BtMoveToCombatVectorAction = class("BtMoveToCombatVectorAction", "BtNode")

BtMoveToCombatVectorAction.TIME_TO_FIRST_EVALUATE = {
	0.5,
	0.75,
}
BtMoveToCombatVectorAction.CONSECUTIVE_EVALUATE_INTERVAL = {
	0.5,
	0.8,
}

BtMoveToCombatVectorAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
	scratchpad.navigation_extension = navigation_extension
	scratchpad.stagger_component = Blackboard.write_component(blackboard, "stagger")

	local combat_vector_component = blackboard.combat_vector

	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.combat_vector_component = combat_vector_component
	scratchpad.perception_component = blackboard.perception

	local run_speed = action_data.speed

	navigation_extension:set_enabled(true, run_speed)

	scratchpad.time_to_next_evaluate = t + math.random_range(BtMoveToCombatVectorAction.TIME_TO_FIRST_EVALUATE[1], BtMoveToCombatVectorAction.TIME_TO_FIRST_EVALUATE[2])
	scratchpad.current_combat_vector_position = Vector3Box()

	self:_move_to_combat_vector(scratchpad, combat_vector_component, navigation_extension)
end

BtMoveToCombatVectorAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	if scratchpad.stagger_duration then
		MinionMovement.stop_running_stagger(scratchpad)
	end

	scratchpad.navigation_extension:set_enabled(false)
end

local DEFAULT_ATTACK_INTENSITY_TYPE = "ranged"
local DEFAULT_ELITE_ATTACK_INTENSITY_TYPE = "elite_ranged"
local MIN_COMBAT_VECTOR_DISTANCE_CHANGE_SQ = 9

BtMoveToCombatVectorAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local combat_vector_component = scratchpad.combat_vector_component
	local wanted_position = combat_vector_component.position:unbox()
	local current_combat_vector_position = scratchpad.current_combat_vector_position:unbox()
	local distance_sq = Vector3.distance_squared(current_combat_vector_position, wanted_position)

	if distance_sq > MIN_COMBAT_VECTOR_DISTANCE_CHANGE_SQ then
		local navigation_extension = scratchpad.navigation_extension

		self:_move_to_combat_vector(scratchpad, combat_vector_component, navigation_extension)
	end

	if action_data.running_stagger_duration then
		MinionMovement.update_running_stagger(unit, t, dt, scratchpad, action_data)
	end

	local should_evaluate = not scratchpad.running_stagger_block_evaluate and t >= scratchpad.time_to_next_evaluate
	local behavior_component = scratchpad.behavior_component
	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)
	local target_unit = scratchpad.perception_component.target_unit

	if should_start_idle or should_be_idling then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)
		end

		MinionMovement.rotate_towards_target_unit(unit, scratchpad)

		if should_evaluate then
			scratchpad.time_to_next_evaluate = t + math.random_range(BtMoveToCombatVectorAction.CONSECUTIVE_EVALUATE_INTERVAL[1], BtMoveToCombatVectorAction.CONSECUTIVE_EVALUATE_INTERVAL[2])
		end

		return "running", should_evaluate
	end

	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		self:_start_move_anim(unit, t, behavior_component, scratchpad, action_data)
	end

	if scratchpad.is_anim_driven and scratchpad.start_rotation_timing and t >= scratchpad.start_rotation_timing then
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

	if should_evaluate then
		scratchpad.time_to_next_evaluate = t + math.random_range(BtMoveToCombatVectorAction.CONSECUTIVE_EVALUATE_INTERVAL[1], BtMoveToCombatVectorAction.CONSECUTIVE_EVALUATE_INTERVAL[2])
	end

	local is_elite = breed.tags.elite
	local attack_intensity_type = action_data.attack_intensity_type or is_elite and DEFAULT_ELITE_ATTACK_INTENSITY_TYPE or DEFAULT_ATTACK_INTENSITY_TYPE
	local attack_allowed = AttackIntensity.minion_can_attack(unit, attack_intensity_type, target_unit)

	if attack_allowed then
		return "running", should_evaluate
	else
		return "running"
	end
end

BtMoveToCombatVectorAction._move_to_combat_vector = function (self, scratchpad, combat_vector_component, navigation_extension)
	local wanted_position = combat_vector_component.position:unbox()

	navigation_extension:move_to(wanted_position)
	scratchpad.current_combat_vector_position:store(wanted_position)
end

BtMoveToCombatVectorAction._start_move_anim = function (self, unit, t, behavior_component, scratchpad, action_data)
	local animation_extension = scratchpad.animation_extension
	local start_move_anim_events = action_data.start_move_anim_events
	local start_move_event

	if start_move_anim_events then
		local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)

		start_move_event = start_move_anim_events[moving_direction_name]

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
		start_move_event = action_data.move_anim_event

		animation_extension:anim_event(start_move_event)
	end

	local start_move_event_anim_speed_duration = action_data.start_move_event_anim_speed_durations and action_data.start_move_event_anim_speed_durations[start_move_event]

	if start_move_event_anim_speed_duration then
		scratchpad.start_move_event_anim_speed_duration = t + start_move_event_anim_speed_duration
	end

	behavior_component.move_state = "moving"
end

return BtMoveToCombatVectorAction
