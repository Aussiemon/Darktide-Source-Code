-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_combat_idle_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local Vo = require("scripts/utilities/vo")
local BtCombatIdleAction = class("BtCombatIdleAction", "BtNode")

BtCombatIdleAction.TIME_TO_FIRST_EVALUATE = {
	0.3,
	0.5
}
BtCombatIdleAction.CONSECUTIVE_EVALUATE_INTERVAL = {
	0.2,
	0.25
}

BtCombatIdleAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	if behavior_component.move_state ~= "idle" then
		local events = action_data.anim_events
		local event = Animation.random_event(events)
		local animation_extension = ScriptUnit.extension(unit, "animation_system")

		animation_extension:anim_event(event)

		behavior_component.move_state = "idle"
	end

	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.time_to_next_evaluate = t + math.random_range(BtCombatIdleAction.TIME_TO_FIRST_EVALUATE[1], BtCombatIdleAction.TIME_TO_FIRST_EVALUATE[2])

	local perception_component = blackboard.perception

	scratchpad.perception_component = perception_component
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")

	local vo_event = action_data.vo_event

	if vo_event then
		Vo.enemy_generic_vo_event(unit, vo_event, breed.name)
	end
end

BtCombatIdleAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if not action_data.dont_rotate_towards_target then
		MinionMovement.rotate_towards_target_unit(unit, scratchpad)
	end

	local should_evaluate

	if t > scratchpad.time_to_next_evaluate then
		should_evaluate = true

		local consecutive_evaluate_interval = BtCombatIdleAction.CONSECUTIVE_EVALUATE_INTERVAL

		scratchpad.time_to_next_evaluate = t + math.random_range(consecutive_evaluate_interval[1], consecutive_evaluate_interval[2])
	end

	return "running", should_evaluate
end

return BtCombatIdleAction
