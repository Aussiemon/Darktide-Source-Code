-- chunkname: @scripts/extension_systems/behavior/trees/chaos/chaos_spawn_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.chaos_spawn
local COMBAT = {
	"BtRandomUtilityNode",
	{
		"BtChaosSpawnGrabAction",
		condition = "chaos_spawn_should_grab",
		name = "grab",
		action_data = action_data.grab,
	},
	{
		"BtMeleeAttackAction",
		name = "claw_attack",
		action_data = action_data.claw_attack,
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
		"BtErraticFollowAction",
		name = "erratic_follow",
		action_data = action_data.erratic_follow,
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
		"BtSelectorNode",
		{
			"BtMeleeAttackAction",
			condition = "chaos_spawn_target_changed_close",
			name = "change_target_combo",
			action_data = action_data.change_target_combo,
		},
		{
			"BtChangeTargetAction",
			name = "change_target",
			action_data = action_data.change_target,
		},
		condition = "chaos_spawn_target_changed",
		name = "target_change",
	},
	{
		"BtLeapAction",
		condition = "chaos_spawn_should_leap",
		name = "leap",
		action_data = action_data.leap,
	},
	COMBAT,
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
	name = "chaos_spawn",
}

return behavior_tree
