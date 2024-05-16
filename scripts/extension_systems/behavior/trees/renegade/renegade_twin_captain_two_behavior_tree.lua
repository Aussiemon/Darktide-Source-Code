-- chunkname: @scripts/extension_systems/behavior/trees/renegade/renegade_twin_captain_two_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.renegade_twin_captain_two
local KICK = {
	"BtMeleeAttackAction",
	condition = "is_aggroed_in_combat_range",
	name = "kick",
	action_data = action_data.kick,
	condition_args = {
		combat_ranges = {
			close = true,
			melee = true,
		},
	},
}
local DASH = {
	"BtDashAction",
	condition = "is_aggroed",
	name = "dash",
	action_data = action_data.dash,
}
local RANDOM_DASH = {
	"BtDashAction",
	condition = "is_empowered",
	name = "random_dash",
	action_data = action_data.random_dash,
}
local DASH_AND_SWEEP = {
	"BtSequenceNode",
	action_data = action_data.dash_and_sweep,
	{
		"BtDashAction",
		name = "dash_fast",
		action_data = action_data.dash_fast,
	},
	{
		"BtMeleeAttackAction",
		name = "power_sword_melee_sweep",
		action_data = action_data.power_sword_melee_sweep,
	},
	condition = "is_aggroed",
	name = "dash_and_sweep",
}
local EMPOWERED_DASH_AND_SWEEP = {
	"BtSequenceNode",
	action_data = action_data.empowered_dash_and_sweep,
	{
		"BtDashAction",
		name = "random_dash_short",
		action_data = action_data.random_dash_short,
	},
	{
		"BtMeleeAttackAction",
		name = "power_sword_melee_sweep",
		action_data = action_data.power_sword_melee_sweep,
	},
	{
		"BtDashAction",
		name = "random_dash_short",
		action_data = action_data.random_dash_short,
	},
	{
		"BtMeleeAttackAction",
		name = "power_sword_melee_sweep",
		action_data = action_data.power_sword_melee_sweep,
	},
	{
		"BtDashAction",
		name = "random_dash_short",
		action_data = action_data.random_dash_short,
	},
	{
		"BtMeleeAttackAction",
		name = "power_sword_melee_sweep",
		action_data = action_data.power_sword_melee_sweep,
	},
	{
		"BtDashAction",
		name = "random_dash_short",
		action_data = action_data.random_dash_short,
	},
	{
		"BtMeleeAttackAction",
		name = "power_sword_melee_sweep",
		action_data = action_data.power_sword_melee_sweep,
	},
	condition = "is_empowered",
	name = "empowered_dash_and_sweep",
}
local ATTACK_SWEEP = {
	"BtMeleeAttackAction",
	name = "power_sword_melee_sweep",
	action_data = action_data.power_sword_melee_sweep,
}
local MOVING_ATTACK_SWEEP = {
	"BtMeleeAttackAction",
	name = "power_sword_moving_melee_sweep",
	action_data = action_data.power_sword_moving_melee_sweep,
}
local SHIELD_DOWN_RECHARGE = {
	"BtRenegadeTwinCaptainShieldDownAction",
	condition = "renegade_twin_captain_shield_down_recharge",
	name = "shield_down_recharge",
	action_data = action_data.shield_down_recharge,
}
local COMBAT = {
	"BtRandomUtilityNode",
	{
		"BtMeleeFollowTargetAction",
		name = "melee_follow",
		action_data = action_data.melee_follow,
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
		action_data = action_data.power_sword_melee_combo_attack,
	},
	MOVING_ATTACK_SWEEP,
	condition = "is_aggroed",
	name = "combat",
}
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
		"BtRenegadeTwinCaptainDisappearAction",
		condition = "renegade_twin_captain_should_disappear_instant",
		name = "disappear_instant",
		action_data = action_data.disappear_instant,
	},
	{
		"BtRenegadeTwinCaptainDisappearAction",
		condition = "renegade_twin_captain_should_disappear",
		name = "disappear",
		action_data = action_data.disappear,
	},
	{
		"BtTwinCaptainDisappearIdleAction",
		condition = "twin_captain_disappear_idle",
		name = "disappear_idle",
		action_data = action_data.disappear_idle,
	},
	{
		"BtStaggerAction",
		condition = "is_staggered",
		name = "stagger",
		action_data = action_data.stagger,
	},
	SHIELD_DOWN_RECHARGE,
	{
		"BtTwinCaptainIntroAction",
		condition = "has_move_to_position",
		name = "intro",
		action_data = action_data.intro,
	},
	{
		"BtBlockedAction",
		condition = "is_blocked",
		name = "blocked",
		action_data = action_data.blocked,
	},
	COMBAT,
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle,
	},
	name = "renegade_twin_captain_two",
}

return behavior_tree
