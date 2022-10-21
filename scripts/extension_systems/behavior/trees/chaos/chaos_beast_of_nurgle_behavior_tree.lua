local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.chaos_beast_of_nurgle
local HUNT = {
	"BtSequenceNode",
	{
		"BtBeastOfNurgleMovementAction",
		name = "movement",
		action_data = action_data.movement
	},
	condition = "is_aggroed",
	name = "hunting"
}
local VOMIT_OR_CONSUME = {
	"BtSequenceNode",
	{
		"BtBeastOfNurgleAlignAction",
		name = "align",
		action_data = action_data.align
	},
	{
		"BtSelectorNode",
		{
			"BtBeastOfNurgleConsumeAction",
			leave_hook = "beast_of_nurgle_set_consume_cooldown",
			name = "consume",
			condition = "beast_of_nurgle_should_eat",
			action_data = action_data.consume
		},
		{
			"BtShootLiquidBeamAction",
			name = "vomit",
			leave_hook = "beast_of_nurgle_set_vomit_cooldown",
			action_data = action_data.vomit
		},
		name = "eat_or_vomit"
	},
	name = "vomiting",
	condition = "beast_of_nurgle_should_vomit",
	condition_args = {
		wanted_distance = 10
	}
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
		leave_hook = "beast_of_nurgle_set_consume_cooldown",
		action_data = action_data.consume
	},
	condition = "beast_of_nurgle_has_consume_target",
	name = "dashing_and_consuming"
}
local SPIT_OUT_CONSUMED_UNIT = {
	"BtSequenceNode",
	{
		"BtBeastOfNurgleSpitOutAction",
		name = "spit_out",
		leave_hook = "beast_of_nurgle_set_consume_cooldown",
		action_data = action_data.spit_out
	},
	condition = "beast_of_nurgle_has_spit_out_target",
	name = "spit_out"
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
	{
		"BtRunAwayAction",
		name = "run_away",
		leave_hook = "beast_of_nurgle_force_spit_out",
		action_data = action_data.run_away
	},
	condition = "beast_of_nurgle_wants_to_run_away",
	name = "run_away_sequence"
}
local TARGET_CHANGED = {
	"BtSequenceNode",
	{
		"BtBeastOfNurgleAlignAction",
		name = "align",
		action_data = action_data.align
	},
	{
		"BtBeastOfNurgleAlignAction",
		name = "change_target",
		leave_hook = "beast_of_nurgle_reset_change_target_flag",
		action_data = action_data.change_target
	},
	condition = "beast_of_nurgle_wants_to_play_change_target",
	name = "target_changed_sequence"
}
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtDieAction",
		enter_hook = "beast_of_nurgle_stagger_enter",
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
		"BtStaggerAction",
		enter_hook = "beast_of_nurgle_stagger_enter",
		name = "stagger",
		condition = "is_staggered",
		action_data = action_data.stagger
	},
	SPIT_OUT_CONSUMED_UNIT,
	DASH_AND_CONSUME,
	MELEE_PUSH_BACK_ATTACKS,
	TARGET_CHANGED,
	RUN_AWAY,
	{
		"BtBeastOfNurgleConsumeMinionAction",
		name = "consume_minion",
		condition = "beast_of_nurgle_can_consume_minion",
		action_data = action_data.consume_minion
	},
	VOMIT_OR_CONSUME,
	HUNT,
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle
	},
	name = "chaos_beast_of_nurgle"
}

return behavior_tree
