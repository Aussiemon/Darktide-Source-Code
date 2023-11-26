-- chunkname: @scripts/extension_systems/behavior/trees/cultist/cultist_grenadier_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.cultist_grenadier
local FAR_COMBAT = {
	"BtSequenceNode",
	condition_args = {
		combat_ranges = {
			far = true
		}
	},
	{
		"BtGrenadierFollowAction",
		name = "follow",
		action_data = action_data.follow
	},
	{
		"BtGrenadierThrowAction",
		name = "throw_grenade",
		action_data = action_data.throw_grenade
	},
	name = "far_combat",
	condition = "is_aggroed_in_combat_range_or_running"
}
local CLOSE_COMBAT = {
	"BtRandomUtilityNode",
	condition_args = {
		combat_ranges = {
			close = true
		}
	},
	{
		"BtQuickGrenadeThrowAction",
		name = "quick_throw_grenade",
		condition = "can_throw_grenade",
		action_data = action_data.quick_throw_grenade
	},
	{
		"BtMoveToCombatVectorAction",
		name = "move_to_combat_vector",
		action_data = action_data.move_to_combat_vector
	},
	{
		"BtMeleeAttackAction",
		name = "melee_attack",
		action_data = action_data.melee_attack
	},
	name = "close_combat",
	condition = "is_aggroed_in_combat_range_or_running"
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
	CLOSE_COMBAT,
	FAR_COMBAT,
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle
	},
	name = "cultist_grenadier"
}

return behavior_tree
