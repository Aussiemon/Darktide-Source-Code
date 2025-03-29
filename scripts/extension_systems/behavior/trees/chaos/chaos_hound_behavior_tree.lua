-- chunkname: @scripts/extension_systems/behavior/trees/chaos/chaos_hound_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.chaos_hound
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtDieAction",
		condition = "is_dead",
		name = "death",
		action_data = action_data.death,
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
		name = "stagger",
		action_data = action_data.stagger,
	},
	{
		"BtSelectorNode",
		{
			"BtSequenceNode",
			{
				"BtChaosHoundApproachAction",
				name = "approach_target",
				action_data = action_data.approach_target,
			},
			{
				"BtChaosHoundLeapAction",
				name = "leap",
				action_data = action_data.leap,
			},
			{
				"BtChaosHoundTargetPouncedAction",
				condition = "has_pounce_target",
				name = "target_pounced",
				action_data = action_data.target_pounced,
			},
			condition = "chaos_hound_can_pounce",
			name = "leap_sequence",
		},
		{
			"BtChaosHoundSkulkAction",
			condition = "chaos_hound_pounce_is_on_cooldown",
			name = "skulking",
			action_data = action_data.skulking,
		},
		condition = "chaos_hound_is_aggroed",
		name = "combat",
	},
	{
		"BtChaosHoundRoamAction",
		condition = "is_passive",
		name = "roaming",
		action_data = action_data.roaming,
	},
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle,
	},
	name = "chaos_hound",
}

return behavior_tree
