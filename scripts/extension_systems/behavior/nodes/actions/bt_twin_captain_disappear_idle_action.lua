-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_twin_captain_disappear_idle_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local Vo = require("scripts/utilities/vo")
local BtTwinCaptainDisappearIdleAction = class("BtTwinCaptainDisappearIdleAction", "BtNode")

BtTwinCaptainDisappearIdleAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local disappear_index = behavior_component.disappear_index

	scratchpad.behavior_component = behavior_component

	local events = action_data.anim_events[disappear_index]
	local event = Animation.random_event(events)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(event)

	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	local perception_component = blackboard.perception

	scratchpad.perception_component = perception_component
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")

	local vo_event = action_data.vo_event

	scratchpad.duration = t + action_data.durations[event]

	if vo_event and perception_component.aggro_state == "passive" then
		Vo.enemy_vo_event(unit, vo_event)
	end

	scratchpad.vo_trigger_t = t + action_data.vo_trigger_timings[event]
end

BtTwinCaptainDisappearIdleAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if not action_data.ignore_rotate_towards_target then
		MinionMovement.rotate_towards_target_unit(unit, scratchpad)
	end

	if scratchpad.vo_trigger_t and t >= scratchpad.vo_trigger_t then
		local breed_name = ScriptUnit.extension(unit, "unit_data_system"):breed().name

		Vo.enemy_generic_vo_event(unit, "escape", breed_name)

		scratchpad.vo_trigger_t = nil
	end

	if scratchpad.duration and t >= scratchpad.duration then
		scratchpad.behavior_component.should_disappear_instant = true

		local health_extension = ScriptUnit.has_extension(unit, "health_system")

		health_extension:set_invulnerable(true)

		return "done"
	end

	return "running"
end

return BtTwinCaptainDisappearIdleAction
