-- chunkname: @scripts/extension_systems/behavior/trees/chaos/chaos_beast_of_nurgle_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.chaos_beast_of_nurgle
local HUNT = {
	"BtBeastOfNurgleMovementAction",
	condition = "beast_of_nurgle_movement",
	name = "movement",
	action_data = action_data.movement,
}
local VOMIT = {
	"BtSequenceNode",
	condition_args = {
		wanted_distance = 10,
	},
	{
		"BtBeastOfNurgleAlignAction",
		name = "align",
		action_data = action_data.align,
	},
	{
		"BtShootLiquidBeamAction",
		leave_hook = "beast_of_nurgle_set_vomit_cooldown",
		name = "vomit",
		action_data = action_data.vomit,
	},
	condition = "beast_of_nurgle_should_vomit",
	name = "vomiting",
}
local CONSUME = {
	"BtSequenceNode",
	{
		"BtBeastOfNurgleAlignAction",
		name = "align",
		action_data = action_data.align,
	},
	{
		"BtBeastOfNurgleConsumeAction",
		name = "consume",
		action_data = action_data.consume,
	},
	condition = "beast_of_nurgle_should_eat",
	name = "consuming",
}
local DASH_AND_CONSUME = {
	"BtSequenceNode",
	{
		"BtBeastOfNurgleMovementAction",
		name = "fast_movement",
		action_data = action_data.fast_movement,
	},
	{
		"BtBeastOfNurgleConsumeAction",
		name = "consume",
		action_data = action_data.consume,
	},
	condition = "beast_of_nurgle_has_consume_target",
	name = "dashing_and_consuming",
}
local SPIT_OUT_CONSUMED_UNIT = {
	"BtBeastOfNurgleSpitOutAction",
	condition = "beast_of_nurgle_has_spit_out_target",
	leave_hook = "beast_of_nurgle_set_consume_cooldown",
	name = "spit_out",
	action_data = action_data.spit_out,
}
local MELEE_PUSH_BACK_ATTACKS = {
	"BtSelectorNode",
	{
		"BtMeleeAttackAction",
		condition = "beast_of_nurgle_melee_body_slam_aoe",
		leave_hook = "beast_of_nurgle_set_melee_aoe_cooldown",
		name = "melee_attack_body_slam_aoe",
		action_data = action_data.melee_attack_body_slam_aoe,
	},
	{
		"BtMeleeAttackAction",
		condition = "beast_of_nurgle_melee_tail_whip",
		leave_hook = "beast_of_nurgle_set_melee_cooldown",
		name = "melee_attack_fwd_left",
		condition_args = {
			check_fwd_left = true,
		},
		action_data = action_data.melee_attack_fwd_left,
	},
	{
		"BtMeleeAttackAction",
		condition = "beast_of_nurgle_melee_tail_whip",
		leave_hook = "beast_of_nurgle_set_melee_cooldown",
		name = "melee_attack_fwd_right",
		condition_args = {
			check_fwd_right = true,
		},
		action_data = action_data.melee_attack_fwd_right,
	},
	{
		"BtMeleeAttackAction",
		condition = "beast_of_nurgle_melee_tail_whip",
		leave_hook = "beast_of_nurgle_set_melee_cooldown",
		name = "melee_attack_bwd",
		condition_args = {
			check_bwd = true,
		},
		action_data = action_data.melee_attack_bwd,
	},
	{
		"BtMeleeAttackAction",
		condition = "beast_of_nurgle_melee_tail_whip",
		leave_hook = "beast_of_nurgle_set_melee_cooldown",
		name = "melee_attack_left",
		condition_args = {
			check_left = true,
		},
		action_data = action_data.melee_attack_left,
	},
	{
		"BtMeleeAttackAction",
		condition = "beast_of_nurgle_melee_tail_whip",
		leave_hook = "beast_of_nurgle_set_melee_cooldown",
		name = "melee_attack_right",
		condition_args = {
			check_right = true,
		},
		action_data = action_data.melee_attack_right,
	},
	condition = "beast_of_nurgle_can_melee",
	name = "melee_push_back_attacks",
}
local RUN_AWAY = {
	"BtRunAwayAction",
	condition = "beast_of_nurgle_wants_to_run_away",
	leave_hook = "beast_of_nurgle_force_spit_out",
	name = "run_away",
	action_data = action_data.run_away,
}
local ALERTED = {
	"BtSequenceNode",
	{
		"BtBeastOfNurgleAlignAction",
		name = "align",
		action_data = action_data.align,
	},
	{
		"BtBeastOfNurgleAlignAction",
		leave_hook = "beast_of_nurgle_reset_alerted",
		name = "alerted",
		action_data = action_data.alerted,
	},
	condition = "beast_of_nurgle_wants_to_play_alerted",
	name = "alerted_sequence",
}
local TARGET_CHANGED = {
	"BtChangeTargetAction",
	condition = "beast_of_nurgle_wants_to_play_change_target",
	name = "change_target",
	action_data = action_data.change_target,
}
local behavior_tree = {
	"BtSelectorNode",
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
		"BtBeastOfNurgleDieAction",
		condition = "is_dead",
		enter_hook = "beast_of_nurgle_stagger_enter",
		name = "death",
		action_data = action_data.death,
	},
	{
		"BtStaggerAction",
		condition = "beast_of_nurgle_normal_stagger",
		enter_hook = "beast_of_nurgle_stagger_enter",
		name = "stagger",
		action_data = action_data.stagger,
	},
	{
		"BtStaggerAction",
		condition = "beast_of_nurgle_weakspot_stagger",
		enter_hook = "beast_of_nurgle_stagger_enter",
		name = "weakspot_stagger",
		action_data = action_data.weakspot_stagger,
	},
	SPIT_OUT_CONSUMED_UNIT,
	DASH_AND_CONSUME,
	MELEE_PUSH_BACK_ATTACKS,
	ALERTED,
	TARGET_CHANGED,
	RUN_AWAY,
	{
		"BtBeastOfNurgleConsumeMinionAction",
		condition = "beast_of_nurgle_can_consume_minion",
		name = "consume_minion",
		action_data = action_data.consume_minion,
	},
	CONSUME,
	VOMIT,
	HUNT,
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle,
	},
	name = "chaos_beast_of_nurgle",
}

return behavior_tree
