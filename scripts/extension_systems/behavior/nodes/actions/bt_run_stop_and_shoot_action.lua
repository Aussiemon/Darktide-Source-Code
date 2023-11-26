-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_run_stop_and_shoot_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionMovement = require("scripts/utilities/minion_movement")
local Vo = require("scripts/utilities/vo")
local BtRunStopAndShootAction = class("BtRunStopAndShootAction", "BtNode")

BtRunStopAndShootAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.navigation_extension = navigation_extension
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")

	navigation_extension:set_enabled(true, breed.run_speed)

	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = Blackboard.write_component(blackboard, "perception")

	MinionAttack.init_scratchpad_shooting_variables(unit, scratchpad, action_data, blackboard, breed)

	local vo_event = action_data.vo_event

	if vo_event then
		Vo.enemy_generic_vo_event(unit, vo_event, breed.name)
	end

	self:_start_attacking(unit, t, scratchpad, action_data)
end

BtRunStopAndShootAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local state = scratchpad.state

	if state == "attacking" then
		MinionAttack.stop_shooting(unit, scratchpad)
	end

	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	else
		scratchpad.navigation_extension:set_enabled(false)
	end
end

BtRunStopAndShootAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local blend_timing = scratchpad.blend_timing

	if blend_timing and blend_timing <= t then
		MinionMovement.set_anim_driven(scratchpad, true)
		scratchpad.navigation_extension:set_enabled(false)

		scratchpad.blend_timing = nil
	end

	local is_anim_driven = scratchpad.is_anim_driven

	if is_anim_driven and scratchpad.start_rotation_timing and t >= scratchpad.start_rotation_timing then
		local target_unit = scratchpad.perception_component.target_unit
		local target_position = POSITION_LOOKUP[target_unit]

		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t, target_position)
	end

	if t > scratchpad.action_duration then
		return "done"
	end

	local has_valid_angle = MinionAttack.aim_at_target(unit, scratchpad, t, action_data)
	local state = scratchpad.state

	if state == "attacking" then
		if t > scratchpad.move_duration and not has_valid_angle then
			return "done"
		end

		self:_update_attacking(unit, t, scratchpad, action_data)
	elseif state == "cooldown" then
		local done = self:_update_cooldown(t, scratchpad)

		if done then
			return "done"
		end
	end

	return "running"
end

BtRunStopAndShootAction._start_attacking = function (self, unit, t, scratchpad, action_data)
	local chosen_anim = self:_start_move_anim(unit, t, scratchpad, action_data)
	local move_duration = action_data.move_durations[chosen_anim]

	scratchpad.state = "attacking"
	scratchpad.move_duration = t + move_duration

	local action_duration = action_data.action_duration[chosen_anim]

	scratchpad.action_duration = t + action_duration

	MinionAttack.start_shooting(unit, scratchpad, t, action_data, move_duration)
end

BtRunStopAndShootAction._update_attacking = function (self, unit, t, scratchpad, action_data)
	local _, fired_last_shot = MinionAttack.update_shooting(unit, scratchpad, t, action_data)

	if fired_last_shot then
		self:_start_cooldown(t, scratchpad, action_data)
	end
end

BtRunStopAndShootAction._start_cooldown = function (self, t, scratchpad, action_data)
	local cooldown_range = action_data.shoot_cooldown
	local diff_cooldown_range = Managers.state.difficulty:get_table_entry_by_challenge(cooldown_range)
	local cooldown = math.random_range(diff_cooldown_range[1], diff_cooldown_range[2])

	scratchpad.cooldown = t + cooldown
	scratchpad.state = "cooldown"
end

BtRunStopAndShootAction._update_cooldown = function (self, t, scratchpad)
	return t > scratchpad.cooldown
end

BtRunStopAndShootAction._start_move_anim = function (self, unit, t, scratchpad, action_data)
	local target_unit = scratchpad.perception_component.target_unit
	local target_position = POSITION_LOOKUP[target_unit]
	local current_node, next_node_in_path = scratchpad.navigation_extension:current_and_next_node_positions_in_path()
	local to_position = next_node_in_path or current_node
	local from_position = POSITION_LOOKUP[unit]
	local wanted_rotation = Quaternion.look(Vector3.normalize(to_position - from_position))
	local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad, target_position, wanted_rotation)
	local start_move_anim_events = action_data.start_move_anim_events
	local start_move_event = start_move_anim_events[moving_direction_name]

	scratchpad.animation_extension:anim_event(start_move_event)

	scratchpad.current_aim_anim_event = start_move_event

	local blend_timings = action_data.blend_timings
	local blend_duration = blend_timings[start_move_event]

	scratchpad.blend_timing = t + blend_duration

	if moving_direction_name ~= "fwd" then
		local start_rotation_timing = action_data.start_move_rotation_timings[start_move_event]

		scratchpad.start_rotation_timing = t + start_rotation_timing
		scratchpad.move_start_anim_event_name = start_move_event
	end

	local behavior_component = scratchpad.behavior_component

	behavior_component.move_state = "attacking"

	return start_move_event
end

return BtRunStopAndShootAction
