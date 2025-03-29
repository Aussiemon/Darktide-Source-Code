-- chunkname: @scripts/extension_systems/behavior/trees/cultist/cultist_assault_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.cultist_assault
local COVER_COMBAT = {
	"BtRandomUtilityNode",
	condition_args = {
		combat_ranges = {
			far = true,
		},
	},
	{
		"BtSequenceNode",
		action_data = action_data.has_cover,
		{
			"BtMoveToCoverAction",
			name = "move_to_cover",
			action_data = action_data.move_to_cover,
		},
		{
			"BtInCoverAction",
			name = "in_cover",
			action_data = action_data.in_cover,
		},
		name = "has_cover",
	},
	{
		"BtShootAction",
		condition = "is_not_suppressed",
		name = "move_to_cover_shoot",
		action_data = action_data.move_to_cover_shoot,
	},
	condition = "has_cover",
	name = "cover_combat",
}
local FAR_COMBAT = {
	"BtRandomUtilityNode",
	condition_args = {
		combat_ranges = {
			far = true,
		},
	},
	{
		"BtRangedFollowTargetAction",
		condition = "not_assaulting",
		name = "follow",
		action_data = action_data.follow,
	},
	{
		"BtRangedFollowTargetAction",
		name = "assault",
		action_data = action_data.assault,
	},
	{
		"BtShootAction",
		name = "shoot",
		action_data = action_data.shoot,
	},
	condition = "is_aggroed_in_combat_range",
	name = "far_combat",
}
local SUPPRESSED = {
	"BtSequenceNode",
	{
		"BtSuppressedAction",
		name = "suppressed",
		action_data = action_data.suppressed,
	},
	{
		"BtMoveToCombatVectorAction",
		name = "move_to_combat_vector",
		action_data = action_data.move_to_combat_vector,
	},
	condition = "is_suppressed",
	name = "suppressed",
}
local CLOSE_COMBAT = {
	"BtSelectorNode",
	condition_args = {
		combat_ranges = {
			close = true,
		},
	},
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
			"BtShootAction",
			name = "shoot_close",
			action_data = action_data.shoot_close,
		},
		name = "close_combat_utility",
	},
	condition = "is_aggroed_in_combat_range",
	name = "close_combat",
}
local MELEE_COMBAT = {
	"BtSelectorNode",
	condition_args = {
		combat_ranges = {
			melee = true,
		},
	},
	{
		"BtCombatIdleAction",
		condition = "should_use_combat_idle",
		name = "melee_combat_idle",
		condition_args = {
			attack_type = "melee",
			override_distance = 3,
		},
		action_data = action_data.melee_combat_idle,
	},
	{
		"BtRandomUtilityNode",
		{
			"BtMeleeFollowTargetAction",
			name = "melee_follow",
			action_data = action_data.melee_follow,
		},
		{
			"BtMeleeAttackAction",
			condition = "attack_allowed",
			name = "melee_attack",
			condition_args = {
				attack_type = "melee",
			},
			action_data = action_data.melee_attack,
		},
		{
			"BtMeleeAttackAction",
			condition = "moving_attack_allowed",
			name = "moving_melee_attack",
			condition_args = {
				attack_type = "moving_melee",
			},
			action_data = action_data.moving_melee_attack,
		},
		name = "combat",
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
		"BtBlockedAction",
		condition = "is_blocked",
		name = "blocked",
		action_data = action_data.blocked,
	},
	{
		"BtSwitchWeaponAction",
		condition = "should_switch_weapon",
		name = "switch_weapon",
		action_data = action_data.switch_weapon,
	},
	COVER_COMBAT,
	SUPPRESSED,
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
	name = "cultist_assault",
}

return behavior_tree
