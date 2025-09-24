-- chunkname: @scripts/extension_systems/behavior/trees/renegade/renegade_netgunner_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.renegade_netgunner
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtDieAction",
		condition = "is_dead",
		name = "death",
		action_data = action_data.death,
	},
	{
		"BtDisableAction",
		condition = "is_minion_disabled",
		name = "disable",
		action_data = action_data.disable,
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
				"BtRenegadeNetgunnerApproachAction",
				name = "approach_target",
				action_data = action_data.approach_target,
			},
			{
				"BtShootNetAction",
				name = "shoot_net",
				action_data = action_data.shoot_net,
			},
			condition = "can_shoot_net",
			name = "net_sequence",
		},
		{
			"BtSequenceNode",
			{
				"BtReloadAction",
				name = "reload",
				action_data = action_data.reload,
			},
			{
				"BtRunAwayAction",
				leave_hook = "netgunner_reset_cooldown",
				name = "run_away",
				action_data = action_data.run_away,
			},
			condition = "netgunner_hit_target_with_alt_conditions",
			name = "reload_then_run_sequence_alt_mode",
		},
		{
			"BtSequenceNode",
			{
				"BtReloadAction",
				name = "reload",
				action_data = action_data.reload,
			},
			{
				"BtRunAwayAction",
				leave_hook = "netgunner_reset_cooldown",
				name = "run_away",
				action_data = action_data.run_away,
			},
			condition = "netgunner_hit_target",
			name = "reload_then_run_sequence",
		},
		{
			"BtSelectorNode",
			{
				"BtRunAwayAction",
				condition = "netgunner_is_on_cooldown",
				name = "run_away",
				action_data = action_data.run_away,
			},
			{
				"BtReloadAction",
				leave_hook = "netgunner_reset_cooldown",
				name = "reload",
				action_data = action_data.reload,
			},
			name = "run_then_reload",
		},
		condition = "is_aggroed",
		name = "attack_target",
	},
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle,
	},
	name = "renegade_netgunner",
}

return behavior_tree
