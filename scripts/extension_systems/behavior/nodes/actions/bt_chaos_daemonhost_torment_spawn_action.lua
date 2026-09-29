-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_chaos_daemonhost_torment_spawn_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local ChaosDaemonhostSettings = require("scripts/settings/monster/chaos_daemonhost_settings")
local STAGES = ChaosDaemonhostSettings.stages
local BtChaosDaemonhostTormentSpawnAction = class("BtChaosDaemonhostTormentSpawnAction", "BtNode")

BtChaosDaemonhostTormentSpawnAction.init_values = function (self, blackboard, action_data, node_data)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.spawned_in = false
end

BtChaosDaemonhostTormentSpawnAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.spawned_in = true
	behavior_component.move_state = "idle"

	local spawn_component = blackboard.spawn

	GameSession.set_game_object_field(spawn_component.game_session, spawn_component.game_object_id, "stage", STAGES.aggroed)

	local anim_event = Animation.random_event(action_data.anim_events)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(anim_event)

	scratchpad.done_t = t + action_data.durations[anim_event]

	local fx_system = Managers.state.extension:system("fx_system")
	local position = POSITION_LOOKUP[unit]

	fx_system:trigger_wwise_event(action_data.wwise_spawn_event, position)
	fx_system:trigger_vfx(action_data.spawn_vfx, position, Unit.local_rotation(unit, 1))
end

BtChaosDaemonhostTormentSpawnAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if t >= scratchpad.done_t then
		return "done"
	end

	return "running"
end

return BtChaosDaemonhostTormentSpawnAction
