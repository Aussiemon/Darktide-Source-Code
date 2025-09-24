-- chunkname: @scripts/extension_systems/behavior/trees/renegade/renegade_executor_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.renegade_executor
local MELEE_COMBAT = {
	"BtRandomUtilityNode",
	{
		"BtMeleeFollowTargetAction",
		name = "follow",
		action_data = action_data.follow,
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
		condition = "attack_allowed",
		name = "melee_cleave_attack",
		condition_args = {
			attack_type = "melee",
		},
		action_data = action_data.melee_cleave_attack,
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
	{
		"BtMeleeAttackAction",
		condition = "moving_attack_allowed",
		name = "moving_melee_cleave_attack",
		condition_args = {
			attack_type = "moving_melee",
		},
		action_data = action_data.moving_melee_cleave_attack,
	},
	condition = "is_aggroed",
	name = "melee_combat",
}
local SPECIAL_ACTION = {
	"BtSelectorNode",
	{
		"BtUseStimAction",
		name = "use_stim",
		action_data = action_data.use_stim,
	},
	condition = "minion_can_use_special_action",
	name = "use_special_action",
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
		{
			"BtSmashObstacleAction",
			condition = "at_smashable_obstacle_smart_object",
			name = "smash_obstacle",
			action_data = action_data.smash_obstacle,
		},
		condition = "at_smart_object",
		name = "smart_object",
	},
	SPECIAL_ACTION,
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
	name = "renegade_executor",
}

return behavior_tree
