-- chunkname: @scripts/extension_systems/behavior/trees/cultist/cultist_grenadier_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.cultist_grenadier
local FAR_COMBAT = {
	"BtSequenceNode",
	condition_args = {
		combat_ranges = {
			far = true,
		},
	},
	{
		"BtGrenadierFollowAction",
		name = "follow",
		action_data = action_data.follow,
	},
	{
		"BtGrenadierThrowAction",
		name = "throw_grenade",
		action_data = action_data.throw_grenade,
	},
	condition = "is_aggroed_in_combat_range_or_running",
	name = "far_combat",
}
local CLOSE_COMBAT = {
	"BtRandomUtilityNode",
	condition_args = {
		combat_ranges = {
			close = true,
		},
	},
	{
		"BtQuickGrenadeThrowAction",
		condition = "can_throw_grenade",
		name = "quick_throw_grenade",
		action_data = action_data.quick_throw_grenade,
	},
	{
		"BtMoveToCombatVectorAction",
		name = "move_to_combat_vector",
		action_data = action_data.move_to_combat_vector,
	},
	{
		"BtMeleeAttackAction",
		name = "melee_attack",
		action_data = action_data.melee_attack,
	},
	condition = "is_aggroed_in_combat_range_or_running",
	name = "close_combat",
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
	CLOSE_COMBAT,
	FAR_COMBAT,
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle,
	},
	name = "cultist_grenadier",
}

return behavior_tree
