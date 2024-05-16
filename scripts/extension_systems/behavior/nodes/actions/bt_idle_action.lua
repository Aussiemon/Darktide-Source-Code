-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_idle_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local Vo = require("scripts/utilities/vo")
local BtIdleAction = class("BtIdleAction", "BtNode")

BtIdleAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	if behavior_component.move_state ~= "idle" then
		local events = action_data.anim_events
		local event = Animation.random_event(events)
		local animation_extension = ScriptUnit.extension(unit, "animation_system")

		animation_extension:anim_event(event)

		behavior_component.move_state = "idle"
	end

	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	local perception_component = blackboard.perception

	scratchpad.perception_component = perception_component
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")

	local vo_event = action_data.vo_event

	if vo_event and perception_component.aggro_state == "passive" then
		Vo.enemy_vo_event(unit, vo_event)
	end
end

BtIdleAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if not action_data.ignore_rotate_towards_target then
		MinionMovement.rotate_towards_target_unit(unit, scratchpad)
	end

	return "running"
end

return BtIdleAction
