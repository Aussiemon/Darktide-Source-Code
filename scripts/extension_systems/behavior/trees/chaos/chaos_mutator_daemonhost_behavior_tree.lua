-- chunkname: @scripts/extension_systems/behavior/trees/chaos/chaos_mutator_daemonhost_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.chaos_mutator_daemonhost
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtChaosDaemonhostDieAction",
		name = "death_leave",
		condition = "mutator_daemonhost_wants_to_leave",
		action_data = action_data.death_leave
	},
	{
		"BtChaosDaemonhostDieAction",
		name = "death",
		condition = "is_dead",
		action_data = action_data.death
	},
	{
		"BtSelectorNode",
		{
			"BtTeleportAction",
			condition = "at_teleport_smart_object",
			name = "teleport"
		},
		{
			"BtClimbAction",
			name = "climb",
			condition = "at_climb_smart_object",
			action_data = action_data.climb
		},
		{
			"BtJumpAcrossAction",
			name = "jump_across",
			condition = "at_jump_smart_object",
			action_data = action_data.jump_across
		},
		{
			"BtSmashObstacleAction",
			name = "smash_obstacle",
			condition = "at_smashable_obstacle_smart_object",
			action_data = action_data.smash_obstacle
		},
		{
			"BtOpenDoorAction",
			name = "open_door",
			condition = "at_door_smart_object",
			action_data = action_data.open_door
		},
		condition = "at_smart_object",
		name = "smart_object"
	},
	{
		"BtSequenceNode",
		action_data = action_data.warp_grab_teleport,
		{
			"BtWarpTeleportAction",
			name = "warp_teleport",
			action_data = action_data.warp_teleport
		},
		{
			"BtChaosDaemonhostWarpGrabAction",
			name = "warp_grab",
			action_data = action_data.warp_grab
		},
		name = "warp_grab_teleport",
		condition = "daemonhost_can_warp_grab"
	},
	{
		"BtStaggerAction",
		name = "stagger",
		condition = "is_staggered",
		action_data = action_data.stagger
	},
	{
		"BtRandomUtilityNode",
		{
			"BtWarpTeleportAction",
			name = "warp_teleport",
			action_data = action_data.warp_teleport
		},
		{
			"BtMeleeFollowTargetAction",
			name = "follow",
			action_data = action_data.follow
		},
		{
			"BtMeleeAttackAction",
			name = "melee_attack",
			action_data = action_data.melee_attack
		},
		{
			"BtChaosDaemonhostWarpSweepAction",
			name = "warp_sweep",
			condition = "daemonhost_can_warp_sweep",
			action_data = action_data.warp_sweep
		},
		{
			"BtMeleeAttackAction",
			name = "combo_attack",
			action_data = action_data.combo_attack
		},
		condition = "is_aggroed",
		name = "melee_combat"
	},
	{
		"BtChaosMutatorDaemonhostPassiveAction",
		name = "passive",
		condition = "daemonhost_is_passive",
		action_data = action_data.passive
	},
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle
	},
	name = "chaos_mutator_daemonhost"
}

return behavior_tree
