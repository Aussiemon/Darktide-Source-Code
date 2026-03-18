-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_in_vortex_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionPerception = require("scripts/utilities/minion_perception")
local BtInVortex = class("BtInVortex", "BtNode")

BtInVortex.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	scratchpad.perception_component = Blackboard.write_component(blackboard, "perception")
	behavior_component.move_state = "disabled"
	scratchpad.behavior_component = behavior_component

	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	navigation_extension:set_enabled(false)

	scratchpad.visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

	self:_start_loop_anim(unit, blackboard, action_data, scratchpad)
end

BtInVortex.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	return "running"
end

BtInVortex.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local vortex_landing = "vortex_landing"
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(vortex_landing)

	scratchpad.animation_extension = animation_extension

	local perception_component = scratchpad.perception_component

	if perception_component and perception_component.lock_target then
		MinionPerception.set_target_lock(unit, perception_component, false)
	end
end

BtInVortex._start_loop_anim = function (self, unit, blackboard, action_data, scratchpad)
	local vortex_loop = "vortex_loop"
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(vortex_loop)

	scratchpad.animation_extension = animation_extension
end

return BtInVortex
