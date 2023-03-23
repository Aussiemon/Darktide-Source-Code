local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.chaos_poxwalker_bomber
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtSequenceNode",
		{
			"BtChaosPoxwalkerExplodeAction",
			name = "explode",
			action_data = action_data.explode
		},
		{
			"BtDieAction",
			enter_hook = "poxwalker_bomber_death_enter",
			name = "death",
			action_data = action_data.death
		},
		condition = "poxwalker_bomber_is_dead",
		name = "death_sequence"
	},
	{
		"BtExitSpawnerAction",
		name = "exit_spawner",
		condition = "is_exiting_spawner",
		action_data = action_data.exit_spawner
	},
	{
		"BtSelectorNode",
		{
			"BtTeleportAction",
			name = "teleport",
			condition = "at_teleport_smart_object",
			action_data = action_data.teleport
		},
		{
			"BtClimbAction",
			enter_hook = "poxwalker_bomber_jump_explode_check",
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
		"BtStaggerAction",
		leave_hook = "poxwalker_bomber_lunge_stagger_check",
		name = "stagger",
		condition = "is_staggered",
		action_data = action_data.stagger
	},
	{
		"BtPoxwalkerBomberApproachAction",
		name = "approach",
		condition = "is_aggroed",
		action_data = action_data.approach
	},
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle
	},
	name = "chaos_poxwalker_bomber"
}

return behavior_tree
