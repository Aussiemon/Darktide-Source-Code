﻿-- chunkname: @scripts/extension_systems/behavior/trees/chaos/chaos_spawn_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.chaos_spawn
local COMBAT = {
	"BtRandomUtilityNode",
	{
		"BtChaosSpawnGrabAction",
		name = "grab",
		condition = "chaos_spawn_should_grab",
		action_data = action_data.grab
	},
	{
		"BtMeleeAttackAction",
		name = "claw_attack",
		action_data = action_data.claw_attack
	},
	{
		"BtMeleeAttackAction",
		name = "combo_attack",
		condition = "moving_attack_allowed",
		condition_args = {
			attack_type = "moving_melee"
		},
		action_data = action_data.combo_attack
	},
	{
		"BtErraticFollowAction",
		name = "erratic_follow",
		action_data = action_data.erratic_follow
	},
	condition = "is_aggroed",
	name = "melee_combat"
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
		name = "stagger",
		condition = "is_staggered",
		action_data = action_data.stagger
	},
	{
		"BtSelectorNode",
		{
			"BtMeleeAttackAction",
			name = "change_target_combo",
			condition = "chaos_spawn_target_changed_close",
			action_data = action_data.change_target_combo
		},
		{
			"BtChangeTargetAction",
			name = "change_target",
			action_data = action_data.change_target
		},
		condition = "chaos_spawn_target_changed",
		name = "target_change"
	},
	{
		"BtLeapAction",
		name = "leap",
		condition = "chaos_spawn_should_leap",
		action_data = action_data.leap
	},
	COMBAT,
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle
	},
	name = "chaos_spawn"
}

return behavior_tree
