-- chunkname: @scripts/extension_systems/behavior/trees/chaos/chaos_plague_ogryn_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.chaos_plague_ogryn
local COMBAT = {
	"BtRandomUtilityNode",
	{
		"BtMeleeAttackAction",
		name = "melee_slam",
		action_data = action_data.melee_slam,
	},
	{
		"BtMeleeAttackAction",
		name = "plague_stomp",
		action_data = action_data.plague_stomp,
	},
	{
		"BtMeleeAttackAction",
		condition = "moving_attack_allowed",
		name = "combo_attack",
		condition_args = {
			attack_type = "moving_melee",
		},
		action_data = action_data.combo_attack,
	},
	{
		"BtMeleeAttackAction",
		condition = "moving_attack_allowed",
		name = "catapult_attack",
		condition_args = {
			attack_type = "moving_melee",
		},
		action_data = action_data.catapult_attack,
	},
	{
		"BtChargeAction",
		name = "charge",
		action_data = action_data.charge,
	},
	{
		"BtMeleeFollowTargetAction",
		name = "follow",
		action_data = action_data.follow,
	},
	condition = "is_aggroed",
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
		"BtStaggerAction",
		condition = "is_staggered",
		name = "stagger",
		action_data = action_data.stagger,
	},
	{
		"BtChangeTargetAction",
		condition = "target_changed_and_valid",
		name = "change_target",
		action_data = action_data.change_target,
	},
	COMBAT,
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle,
	},
	name = "chaos_plague_ogryn",
}

return behavior_tree
