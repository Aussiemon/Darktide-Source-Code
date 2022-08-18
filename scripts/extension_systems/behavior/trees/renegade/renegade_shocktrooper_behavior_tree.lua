local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.renegade_shocktrooper
local FAR_COMBAT = {
	"BtRangedFollowTargetAction",
	name = "assault",
	condition = "is_aggroed_in_combat_range",
	condition_args = {
		combat_ranges = {
			far = true
		}
	},
	action_data = action_data.assault
}
local SUPPRESSED = {
	"BtSequenceNode",
	{
		"BtSuppressedAction",
		name = "suppressed",
		action_data = action_data.suppressed
	},
	{
		"BtMoveToCombatVectorAction",
		name = "move_to_combat_vector",
		action_data = action_data.move_to_combat_vector
	},
	condition = "is_suppressed",
	name = "suppressed"
}
local CLOSE_COMBAT = {
	"BtSelectorNode",
	{
		"BtRangedFollowTargetAction",
		name = "assault_close",
		condition = "is_suppressed",
		action_data = action_data.assault_close
	},
	{
		"BtRunStopAndShootAction",
		leave_hook = "reset_enter_combat_range_flag",
		name = "run_stop_and_shoot",
		condition = "should_run_stop_and_shoot",
		action_data = action_data.run_stop_and_shoot
	},
	{
		"BtRandomUtilityNode",
		{
			"BtMoveToCombatVectorAction",
			name = "move_to_combat_vector",
			action_data = action_data.move_to_combat_vector
		},
		{
			"BtStepShootAction",
			name = "step_shoot",
			condition = "should_step_shoot",
			condition_args = {
				attack_type = "elite_ranged"
			},
			action_data = action_data.step_shoot
		},
		{
			"BtShootAction",
			name = "shoot",
			action_data = action_data.shoot
		},
		{
			"BtRangedFollowTargetAction",
			name = "ranged_follow_no_los",
			action_data = action_data.ranged_follow_no_los
		},
		name = "close_combat_utility"
	},
	name = "close_combat",
	condition = "is_aggroed_in_combat_range",
	condition_args = {
		combat_ranges = {
			close = true
		}
	}
}
local MELEE_COMBAT = {
	"BtRandomUtilityNode",
	{
		"BtMeleeFollowTargetAction",
		name = "melee_follow",
		action_data = action_data.melee_follow
	},
	{
		"BtCombatIdleAction",
		name = "melee_combat_idle",
		condition = "should_use_combat_idle",
		action_data = action_data.melee_combat_idle
	},
	{
		"BtMeleeAttackAction",
		name = "melee_attack",
		condition = "attack_allowed",
		condition_args = {
			attack_type = "melee"
		},
		action_data = action_data.melee_attack
	},
	{
		"BtMeleeAttackAction",
		name = "moving_melee_attack",
		condition = "moving_attack_allowed",
		condition_args = {
			attack_type = "moving_melee"
		},
		action_data = action_data.moving_melee_attack
	},
	name = "melee_combat",
	condition = "is_aggroed_in_combat_range",
	condition_args = {
		combat_ranges = {
			melee = true
		}
	}
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
		"BtBlockedAction",
		name = "blocked",
		condition = "is_blocked",
		action_data = action_data.blocked
	},
	{
		"BtSwitchWeaponAction",
		name = "switch_weapon",
		condition = "should_switch_weapon",
		action_data = action_data.switch_weapon
	},
	MELEE_COMBAT,
	SUPPRESSED,
	FAR_COMBAT,
	CLOSE_COMBAT,
	{
		"BtAlertedAction",
		name = "alerted",
		condition = "is_alerted",
		action_data = action_data.alerted
	},
	{
		"BtPatrolAction",
		name = "patrol",
		condition = "should_patrol",
		action_data = action_data.patrol
	},
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle
	},
	name = "renegade_shocktrooper"
}

return behavior_tree
