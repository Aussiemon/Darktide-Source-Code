local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.chaos_hound
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtDieAction",
		name = "death",
		condition = "is_dead",
		action_data = action_data.death
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
		name = "stagger",
		condition = "is_staggered",
		action_data = action_data.stagger
	},
	{
		"BtSelectorNode",
		{
			"BtSequenceNode",
			{
				"BtChaosHoundApproachAction",
				name = "approach_target",
				action_data = action_data.approach_target
			},
			{
				"BtChaosHoundLeapAction",
				name = "leap",
				action_data = action_data.leap
			},
			{
				"BtChaosHoundTargetPouncedAction",
				name = "target_pounced",
				condition = "has_pounce_target",
				action_data = action_data.target_pounced
			},
			condition = "chaos_hound_can_pounce",
			name = "leap_sequence"
		},
		{
			"BtChaosHoundSkulkAction",
			name = "skulking",
			condition = "chaos_hound_pounce_is_on_cooldown",
			action_data = action_data.skulking
		},
		condition = "chaos_hound_is_aggroed",
		name = "combat"
	},
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle
	},
	name = "chaos_hound"
}

return behavior_tree
