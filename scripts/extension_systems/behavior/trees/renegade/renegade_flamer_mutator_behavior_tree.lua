﻿-- chunkname: @scripts/extension_systems/behavior/trees/renegade/renegade_flamer_mutator_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.renegade_flamer_mutator
local MELEE_COMBAT = {
	"BtMeleeAttackAction",
	condition = "is_aggroed_in_combat_range",
	name = "melee_attack",
	condition_args = {
		combat_ranges = {
			melee = true,
		},
	},
	action_data = action_data.melee_attack,
}
local COMBAT = {
	"BtSequenceNode",
	{
		"BtFlamerApproachAction",
		name = "follow",
		action_data = action_data.follow,
	},
	{
		"BtShootLiquidBeamAction",
		name = "shoot",
		action_data = action_data.shoot,
	},
	condition = "is_aggroed",
	name = "combat",
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
	MELEE_COMBAT,
	COMBAT,
	{
		"BtAlertedAction",
		condition = "is_alerted",
		name = "alerted",
		action_data = action_data.alerted,
	},
	{
		"BtRenegadeFlamerPatrolAction",
		condition = "should_patrol",
		name = "aggroed_patrol",
		action_data = action_data.aggroed_patrol,
	},
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle,
	},
	name = "renegade_flamer_mutator",
}

return behavior_tree
