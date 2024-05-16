-- chunkname: @scripts/extension_systems/behavior/trees/cultist/cultist_shocktrooper_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.cultist_shocktrooper
local FAR_COMBAT = {
	"BtRangedFollowTargetAction",
	condition = "is_aggroed_in_combat_range",
	name = "assault",
	condition_args = {
		combat_ranges = {
			far = true,
		},
	},
	action_data = action_data.assault,
}
local CLOSE_COMBAT = {
	"BtSelectorNode",
	{
		"BtRunStopAndShootAction",
		condition = "should_run_stop_and_shoot",
		leave_hook = "reset_enter_combat_range_flag",
		name = "run_stop_and_shoot",
		action_data = action_data.run_stop_and_shoot,
	},
	{
		"BtRandomUtilityNode",
		{
			"BtMoveToCombatVectorAction",
			name = "move_to_combat_vector",
			action_data = action_data.move_to_combat_vector,
		},
		{
			"BtStepShootAction",
			condition = "should_step_shoot",
			name = "step_shoot",
			condition_args = {
				attack_type = "elite_shotgun",
			},
			action_data = action_data.step_shoot,
		},
		{
			"BtShootAction",
			name = "shoot",
			action_data = action_data.shoot,
		},
		{
			"BtRangedFollowTargetAction",
			name = "ranged_follow_no_los",
			action_data = action_data.ranged_follow_no_los,
		},
		{
			"BtMeleeAttackAction",
			name = "bayonet_melee_attack",
			action_data = action_data.bayonet_melee_attack,
		},
		name = "close_combat_utility",
	},
	condition = "is_aggroed",
	name = "combat",
}
local MELEE_COMBAT = {
	"BtRandomUtilityNode",
	condition_args = {
		combat_ranges = {
			melee = true,
		},
	},
	{
		"BtMeleeAttackAction",
		condition = "moving_attack_allowed",
		name = "bayonet_charge_attack",
		condition_args = {
			attack_type = "moving_melee",
		},
		action_data = action_data.bayonet_charge_attack,
	},
	{
		"BtMeleeFollowTargetAction",
		name = "melee_follow",
		action_data = action_data.melee_follow,
	},
	{
		"BtCombatIdleAction",
		condition = "should_use_combat_idle",
		name = "melee_combat_idle",
		action_data = action_data.melee_combat_idle,
	},
	{
		"BtMeleeAttackAction",
		condition = "attack_allowed",
		name = "bayonet_melee_attack",
		condition_args = {
			attack_type = "melee",
		},
		action_data = action_data.bayonet_melee_attack,
	},
	condition = "is_aggroed_in_combat_range",
	name = "melee_combat",
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
		"BtBlockedAction",
		condition = "is_blocked",
		name = "blocked",
		action_data = action_data.blocked,
	},
	MELEE_COMBAT,
	FAR_COMBAT,
	CLOSE_COMBAT,
	{
		"BtAlertedAction",
		condition = "is_alerted",
		name = "alerted",
		action_data = action_data.alerted,
	},
	{
		"BtPatrolAction",
		condition = "should_patrol",
		name = "patrol",
		action_data = action_data.patrol,
	},
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle,
	},
	name = "cultist_shocktrooper",
}

return behavior_tree
