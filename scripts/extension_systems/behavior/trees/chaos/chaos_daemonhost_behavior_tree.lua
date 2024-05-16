-- chunkname: @scripts/extension_systems/behavior/trees/chaos/chaos_daemonhost_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.chaos_daemonhost
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtChaosDaemonhostDieAction",
		condition = "daemonhost_wants_to_leave",
		name = "death_leave",
		action_data = action_data.death_leave,
	},
	{
		"BtChaosDaemonhostDieAction",
		condition = "is_dead",
		name = "death",
		action_data = action_data.death,
	},
	{
		"BtSelectorNode",
		{
			"BtTeleportAction",
			condition = "at_teleport_smart_object",
			name = "teleport",
		},
		{
			"BtClimbAction",
			condition = "at_climb_smart_object",
			name = "climb",
			action_data = action_data.climb,
		},
		{
			"BtJumpAcrossAction",
			condition = "at_jump_smart_object",
			name = "jump_across",
			action_data = action_data.jump_across,
		},
		{
			"BtSmashObstacleAction",
			condition = "at_smashable_obstacle_smart_object",
			name = "smash_obstacle",
			action_data = action_data.smash_obstacle,
		},
		{
			"BtOpenDoorAction",
			condition = "at_door_smart_object",
			name = "open_door",
			action_data = action_data.open_door,
		},
		condition = "at_smart_object",
		name = "smart_object",
	},
	{
		"BtSequenceNode",
		action_data = action_data.warp_grab_teleport,
		{
			"BtWarpTeleportAction",
			name = "warp_teleport",
			action_data = action_data.warp_teleport,
		},
		{
			"BtChaosDaemonhostWarpGrabAction",
			name = "warp_grab",
			action_data = action_data.warp_grab,
		},
		condition = "daemonhost_can_warp_grab",
		name = "warp_grab_teleport",
	},
	{
		"BtStaggerAction",
		condition = "is_staggered",
		name = "stagger",
		action_data = action_data.stagger,
	},
	{
		"BtRandomUtilityNode",
		{
			"BtWarpTeleportAction",
			name = "warp_teleport",
			action_data = action_data.warp_teleport,
		},
		{
			"BtMeleeFollowTargetAction",
			name = "follow",
			action_data = action_data.follow,
		},
		{
			"BtMeleeAttackAction",
			name = "melee_attack",
			action_data = action_data.melee_attack,
		},
		{
			"BtChaosDaemonhostWarpSweepAction",
			condition = "daemonhost_can_warp_sweep",
			name = "warp_sweep",
			action_data = action_data.warp_sweep,
		},
		{
			"BtMeleeAttackAction",
			name = "combo_attack",
			action_data = action_data.combo_attack,
		},
		condition = "is_aggroed",
		name = "melee_combat",
	},
	{
		"BtChaosDaemonhostPassiveAction",
		condition = "daemonhost_is_passive",
		name = "passive",
		action_data = action_data.passive,
	},
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle,
	},
	name = "chaos_daemonhost",
}

return behavior_tree
