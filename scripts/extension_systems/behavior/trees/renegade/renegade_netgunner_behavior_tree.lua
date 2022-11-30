local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.renegade_netgunner
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
				"BtRenegadeNetgunnerApproachAction",
				name = "approach_target",
				action_data = action_data.approach_target
			},
			{
				"BtShootNetAction",
				name = "shoot_net",
				action_data = action_data.shoot_net
			},
			condition = "can_shoot_net",
			name = "net_sequence"
		},
		{
			"BtSequenceNode",
			{
				"BtReloadAction",
				name = "reload",
				action_data = action_data.reload
			},
			{
				"BtRunAwayAction",
				name = "run_away",
				leave_hook = "netgunner_reset_cooldown",
				action_data = action_data.run_away
			},
			condition = "netgunner_hit_target",
			name = "reload_then_run_sequence"
		},
		{
			"BtSelectorNode",
			{
				"BtRunAwayAction",
				name = "run_away",
				condition = "netgunner_is_on_cooldown",
				action_data = action_data.run_away
			},
			{
				"BtReloadAction",
				name = "reload",
				leave_hook = "netgunner_reset_cooldown",
				action_data = action_data.reload
			},
			name = "run_then_reload"
		},
		condition = "is_aggroed",
		name = "attack_target"
	},
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle
	},
	name = "renegade_netgunner"
}

return behavior_tree
