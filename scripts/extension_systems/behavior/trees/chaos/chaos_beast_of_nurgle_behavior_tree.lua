-- chunkname: @scripts/extension_systems/behavior/trees/chaos/chaos_beast_of_nurgle_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.chaos_beast_of_nurgle
local HUNT = {
	"BtSequenceNode",
	{
		"BtBeastOfNurgleMovementAction",
		name = "movement",
		action_data = action_data.movement
	},
	condition = "beast_of_nurgle_movement",
	name = "hunting"
}
local VOMIT = {
	"BtSequenceNode",
	condition_args = {
		wanted_distance = 10
	},
	{
		"BtBeastOfNurgleAlignAction",
		name = "align",
		action_data = action_data.align
	},
	{
		"BtShootLiquidBeamAction",
		name = "vomit",
		leave_hook = "beast_of_nurgle_set_vomit_cooldown",
		action_data = action_data.vomit
	},
	name = "vomiting",
	condition = "beast_of_nurgle_should_vomit"
}
local CONSUME = {
	"BtSequenceNode",
	{
		"BtBeastOfNurgleAlignAction",
		name = "align",
		action_data = action_data.align
	},
	{
		"BtBeastOfNurgleConsumeAction",
		name = "consume",
		action_data = action_data.consume
	},
	condition = "beast_of_nurgle_should_eat",
	name = "consuming"
}
local DASH_AND_CONSUME = {
	"BtSequenceNode",
	{
		"BtBeastOfNurgleMovementAction",
		name = "fast_movement",
		action_data = action_data.fast_movement
	},
	{
		"BtBeastOfNurgleConsumeAction",
		name = "consume",
		action_data = action_data.consume
	},
	condition = "beast_of_nurgle_has_consume_target",
	name = "dashing_and_consuming"
}
local SPIT_OUT_CONSUMED_UNIT = {
	"BtSequenceNode",
	action_data = action_data.spit_out,
	{
		"BtBeastOfNurgleSpitOutAction",
		name = "spit_out",
		leave_hook = "beast_of_nurgle_set_consume_cooldown",
		action_data = action_data.spit_out
	},
	name = "spit_out",
	condition = "beast_of_nurgle_has_spit_out_target"
}
local MELEE_PUSH_BACK_ATTACKS = {
	"BtSelectorNode",
	{
		"BtMeleeAttackAction",
		leave_hook = "beast_of_nurgle_set_melee_aoe_cooldown",
		name = "melee_attack_body_slam_aoe",
		condition = "beast_of_nurgle_melee_body_slam_aoe",
		action_data = action_data.melee_attack_body_slam_aoe
	},
	{
		"BtMeleeAttackAction",
		leave_hook = "beast_of_nurgle_set_melee_cooldown",
		name = "melee_attack_fwd_left",
		condition = "beast_of_nurgle_melee_tail_whip",
		condition_args = {
			check_fwd_left = true
		},
		action_data = action_data.melee_attack_fwd_left
	},
	{
		"BtMeleeAttackAction",
		leave_hook = "beast_of_nurgle_set_melee_cooldown",
		name = "melee_attack_fwd_right",
		condition = "beast_of_nurgle_melee_tail_whip",
		condition_args = {
			check_fwd_right = true
		},
		action_data = action_data.melee_attack_fwd_right
	},
	{
		"BtMeleeAttackAction",
		leave_hook = "beast_of_nurgle_set_melee_cooldown",
		name = "melee_attack_bwd",
		condition = "beast_of_nurgle_melee_tail_whip",
		condition_args = {
			check_bwd = true
		},
		action_data = action_data.melee_attack_bwd
	},
	{
		"BtMeleeAttackAction",
		leave_hook = "beast_of_nurgle_set_melee_cooldown",
		name = "melee_attack_left",
		condition = "beast_of_nurgle_melee_tail_whip",
		condition_args = {
			check_left = true
		},
		action_data = action_data.melee_attack_left
	},
	{
		"BtMeleeAttackAction",
		leave_hook = "beast_of_nurgle_set_melee_cooldown",
		name = "melee_attack_right",
		condition = "beast_of_nurgle_melee_tail_whip",
		condition_args = {
			check_right = true
		},
		action_data = action_data.melee_attack_right
	},
	condition = "beast_of_nurgle_can_melee",
	name = "melee_push_back_attacks"
}
local RUN_AWAY = {
	"BtSequenceNode",
	action_data = action_data.run_away,
	{
		"BtRunAwayAction",
		name = "run_away",
		leave_hook = "beast_of_nurgle_force_spit_out",
		action_data = action_data.run_away
	},
	name = "run_away",
	condition = "beast_of_nurgle_wants_to_run_away"
}
local ALERTED = {
	"BtSequenceNode",
	{
		"BtBeastOfNurgleAlignAction",
		name = "align",
		action_data = action_data.align
	},
	{
		"BtBeastOfNurgleAlignAction",
		name = "alerted",
		leave_hook = "beast_of_nurgle_reset_alerted",
		action_data = action_data.alerted
	},
	condition = "beast_of_nurgle_wants_to_play_alerted",
	name = "alerted_sequence"
}
local TARGET_CHANGED = {
	"BtChangeTargetAction",
	name = "change_target",
	condition = "beast_of_nurgle_wants_to_play_change_target",
	action_data = action_data.change_target
}
local behavior_tree = {
	"BtSelectorNode",
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
		"BtBeastOfNurgleDieAction",
		enter_hook = "beast_of_nurgle_stagger_enter",
		name = "death",
		condition = "is_dead",
		action_data = action_data.death
	},
	{
		"BtStaggerAction",
		enter_hook = "beast_of_nurgle_stagger_enter",
		name = "stagger",
		condition = "beast_of_nurgle_normal_stagger",
		action_data = action_data.stagger
	},
	{
		"BtStaggerAction",
		enter_hook = "beast_of_nurgle_stagger_enter",
		name = "weakspot_stagger",
		condition = "beast_of_nurgle_weakspot_stagger",
		action_data = action_data.weakspot_stagger
	},
	SPIT_OUT_CONSUMED_UNIT,
	DASH_AND_CONSUME,
	MELEE_PUSH_BACK_ATTACKS,
	ALERTED,
	TARGET_CHANGED,
	RUN_AWAY,
	{
		"BtBeastOfNurgleConsumeMinionAction",
		name = "consume_minion",
		condition = "beast_of_nurgle_can_consume_minion",
		action_data = action_data.consume_minion
	},
	CONSUME,
	VOMIT,
	HUNT,
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle
	},
	name = "chaos_beast_of_nurgle"
}

return behavior_tree
