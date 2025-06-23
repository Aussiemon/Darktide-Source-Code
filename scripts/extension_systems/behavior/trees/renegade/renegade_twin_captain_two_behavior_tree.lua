-- chunkname: @scripts/extension_systems/behavior/trees/renegade/renegade_twin_captain_two_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.renegade_twin_captain_two
local KICK = {
	"BtMeleeAttackAction",
	name = "kick",
	condition = "is_aggroed_in_combat_range",
	action_data = action_data.kick,
	condition_args = {
		combat_ranges = {
			melee = true,
			close = true
		}
	}
}
local DASH = {
	"BtDashAction",
	name = "dash",
	condition = "is_aggroed",
	action_data = action_data.dash
}
local RANDOM_DASH = {
	"BtDashAction",
	name = "random_dash",
	condition = "is_empowered",
	action_data = action_data.random_dash
}
local DASH_AND_SWEEP = {
	"BtSequenceNode",
	action_data = action_data.dash_and_sweep,
	{
		"BtDashAction",
		name = "dash_fast",
		action_data = action_data.dash_fast
	},
	{
		"BtMeleeAttackAction",
		name = "power_sword_melee_sweep",
		action_data = action_data.power_sword_melee_sweep
	},
	name = "dash_and_sweep",
	condition = "is_aggroed"
}
local EMPOWERED_DASH_AND_SWEEP = {
	"BtSequenceNode",
	action_data = action_data.empowered_dash_and_sweep,
	{
		"BtDashAction",
		name = "random_dash_short",
		action_data = action_data.random_dash_short
	},
	{
		"BtMeleeAttackAction",
		name = "power_sword_melee_sweep",
		action_data = action_data.power_sword_melee_sweep
	},
	{
		"BtDashAction",
		name = "random_dash_short",
		action_data = action_data.random_dash_short
	},
	{
		"BtMeleeAttackAction",
		name = "power_sword_melee_sweep",
		action_data = action_data.power_sword_melee_sweep
	},
	{
		"BtDashAction",
		name = "random_dash_short",
		action_data = action_data.random_dash_short
	},
	{
		"BtMeleeAttackAction",
		name = "power_sword_melee_sweep",
		action_data = action_data.power_sword_melee_sweep
	},
	{
		"BtDashAction",
		name = "random_dash_short",
		action_data = action_data.random_dash_short
	},
	{
		"BtMeleeAttackAction",
		name = "power_sword_melee_sweep",
		action_data = action_data.power_sword_melee_sweep
	},
	name = "empowered_dash_and_sweep",
	condition = "is_empowered"
}
local ATTACK_SWEEP = {
	"BtMeleeAttackAction",
	name = "power_sword_melee_sweep",
	action_data = action_data.power_sword_melee_sweep
}
local MOVING_ATTACK_SWEEP = {
	"BtMeleeAttackAction",
	name = "power_sword_moving_melee_sweep",
	action_data = action_data.power_sword_moving_melee_sweep
}
local SHIELD_DOWN_RECHARGE = {
	"BtRenegadeTwinCaptainShieldDownAction",
	name = "shield_down_recharge",
	condition = "renegade_twin_captain_shield_down_recharge",
	action_data = action_data.shield_down_recharge
}
local COMBAT = {
	"BtRandomUtilityNode",
	{
		"BtMeleeFollowTargetAction",
		name = "melee_follow",
		action_data = action_data.melee_follow
	},
	KICK,
	DASH,
	RANDOM_DASH,
	ATTACK_SWEEP,
	DASH_AND_SWEEP,
	EMPOWERED_DASH_AND_SWEEP,
	{
		"BtMeleeAttackAction",
		name = "power_sword_melee_combo_attack",
		action_data = action_data.power_sword_melee_combo_attack
	},
	MOVING_ATTACK_SWEEP,
	condition = "is_aggroed",
	name = "combat"
}
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
		"BtRenegadeTwinCaptainDisappearAction",
		name = "disappear_instant",
		condition = "renegade_twin_captain_should_disappear_instant",
		action_data = action_data.disappear_instant
	},
	{
		"BtRenegadeTwinCaptainDisappearAction",
		name = "disappear",
		condition = "renegade_twin_captain_should_disappear",
		action_data = action_data.disappear
	},
	{
		"BtTwinCaptainDisappearIdleAction",
		name = "disappear_idle",
		condition = "twin_captain_disappear_idle",
		action_data = action_data.disappear_idle
	},
	{
		"BtStaggerAction",
		name = "stagger",
		condition = "is_staggered",
		action_data = action_data.stagger
	},
	SHIELD_DOWN_RECHARGE,
	{
		"BtTwinCaptainIntroAction",
		name = "intro",
		condition = "has_move_to_position",
		action_data = action_data.intro
	},
	{
		"BtBlockedAction",
		name = "blocked",
		condition = "is_blocked",
		action_data = action_data.blocked
	},
	COMBAT,
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle
	},
	name = "renegade_twin_captain_two"
}

return behavior_tree
