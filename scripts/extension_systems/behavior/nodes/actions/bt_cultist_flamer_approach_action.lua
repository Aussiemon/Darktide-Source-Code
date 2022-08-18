require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local BtCultistFlamerApproachAction = class("BtCultistFlamerApproachAction", "BtNode")
local DEFAULT_MIN_MOVE_DURATION = 0.5

BtCultistFlamerApproachAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local perception_component = blackboard.perception
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = perception_component
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
	scratchpad.navigation_extension = navigation_extension
	local run_speed = action_data.speed

	navigation_extension:set_enabled(true, run_speed)
	MinionMovement.init_find_ranged_position(scratchpad, action_data)

	if action_data.effect_template then
		local fx_system = Managers.state.extension:system("fx_system")
		scratchpad.fx_system = fx_system
		scratchpad.global_effect_id = fx_system:start_template_effect(action_data.effect_template, unit)
	end

	scratchpad.min_move_duration = t + (DEFAULT_MIN_MOVE_DURATION or action_data.min_move_duration)
end

BtCultistFlamerApproachAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	if scratchpad.global_effect_id then
		scratchpad.fx_system:stop_template_effect(scratchpad.global_effect_id)
	end

	scratchpad.navigation_extension:set_enabled(false)
end

BtCultistFlamerApproachAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local distance_to_target = perception_component.target_distance
	local force_move = distance_to_target <= action_data.min_range

	if distance_to_target < action_data.wanted_distance and action_data.min_range < distance_to_target then
		local clear_shot_line_of_sight_id = action_data.clear_shot_line_of_sight_id
		local has_clear_shot = scratchpad.perception_extension:has_line_of_sight_by_id(target_unit, clear_shot_line_of_sight_id)

		if perception_component.has_line_of_sight and has_clear_shot and scratchpad.min_move_duration < t then
			return "done"
		end

		force_move = true
	end

	MinionMovement.update_move_to_ranged_position(unit, t, scratchpad, action_data, target_unit, nil, nil, nil, force_move)

	local behavior_component = scratchpad.behavior_component
	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)

	if should_start_idle or should_be_idling then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)
		else
			self:_rotate_towards_target_unit(unit, scratchpad, target_unit)
		end

		return "running"
	end

	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		self:_start_move_anim(unit, t, behavior_component, scratchpad, action_data)
	end

	if scratchpad.is_anim_driven and scratchpad.start_rotation_timing and scratchpad.start_rotation_timing <= t then
		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
	end

	return "running"
end

BtCultistFlamerApproachAction._start_move_anim = function (self, unit, t, behavior_component, scratchpad, action_data)
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

BtCultistFlamerApproachAction._rotate_towards_target_unit = function (self, unit, scratchpad, target_unit)
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)
	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_wanted_rotation(flat_rotation)
end

return BtCultistFlamerApproachAction
