-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_chaos_daemonhost_torment_die_action.lua

require("scripts/extension_systems/behavior/nodes/actions/bt_chaos_daemonhost_die_action")

local MinionMovement = require("scripts/utilities/minion_movement")
local BtChaosDaemonhostTormentDieAction = class("BtChaosDaemonhostTormentDieAction", "BtChaosDaemonhostDieAction")

BtChaosDaemonhostTormentDieAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local anim_driven_duration = scratchpad.anim_driven_duration

	if anim_driven_duration and anim_driven_duration <= t then
		scratchpad.anim_driven_duration = nil

		MinionMovement.set_anim_driven(scratchpad, false)
	end

	local duration = scratchpad.duration

	if duration <= t then
		if HEALTH_ALIVE[unit] then
			Managers.event:trigger("on_deamonhost_runs_event", unit, breed)
			self:_set_death_component(scratchpad, action_data)
		end

		self:_set_dead(unit, scratchpad, action_data)
	end

	return "running"
end

return BtChaosDaemonhostTormentDieAction
