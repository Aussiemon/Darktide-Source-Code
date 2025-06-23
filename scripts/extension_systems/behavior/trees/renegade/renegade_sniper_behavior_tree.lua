-- chunkname: @scripts/extension_systems/behavior/trees/renegade/renegade_sniper_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.renegade_sniper
local MELEE_COMBAT = {
	"BtMeleeAttackAction",
	name = "melee_attack",
	condition = "is_aggroed_in_combat_range",
	condition_args = {
		combat_ranges = {
			melee = true
		}
	},
	action_data = action_data.melee_attack
}
local COMBAT = {
	"BtRandomUtilityNode",
	{
		"BtSniperMovementAction",
		name = "movement",
		action_data = action_data.movement
	},
	{
		"BtSniperShootAction",
		name = "shoot",
		condition = "has_last_los_pos",
		action_data = action_data.shoot
	},
	condition = "is_aggroed",
	name = "COMBAT"
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
		"BtDisableAction",
		name = "disable",
		condition = "is_minion_disabled",
		action_data = action_data.disable
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
	MELEE_COMBAT,
	COMBAT,
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle
	},
	name = "renegade_sniper"
}

return behavior_tree
