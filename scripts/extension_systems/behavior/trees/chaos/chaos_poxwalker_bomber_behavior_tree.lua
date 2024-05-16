-- chunkname: @scripts/extension_systems/behavior/trees/chaos/chaos_poxwalker_bomber_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.chaos_poxwalker_bomber
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtSequenceNode",
		{
			"BtChaosPoxwalkerExplodeAction",
			name = "explode",
			action_data = action_data.explode,
		},
		{
			"BtDieAction",
			enter_hook = "poxwalker_bomber_death_enter",
			name = "death",
			action_data = action_data.death,
		},
		condition = "poxwalker_bomber_is_dead",
		name = "death_sequence",
	},
	{
		"BtExitSpawnerAction",
		condition = "is_exiting_spawner",
		name = "exit_spawner",
		action_data = action_data.exit_spawner,
	},
	{
		"BtSelectorNode",
		{
			"BtTeleportAction",
			condition = "at_teleport_smart_object",
			name = "teleport",
			action_data = action_data.teleport,
		},
		{
			"BtClimbAction",
			condition = "at_climb_smart_object",
			enter_hook = "poxwalker_bomber_jump_explode_check",
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
		"BtStaggerAction",
		condition = "is_staggered",
		leave_hook = "poxwalker_bomber_lunge_stagger_check",
		name = "stagger",
		action_data = action_data.stagger,
	},
	{
		"BtPoxwalkerBomberApproachAction",
		condition = "is_aggroed",
		name = "approach",
		action_data = action_data.approach,
	},
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle,
	},
	name = "chaos_poxwalker_bomber",
}

return behavior_tree
