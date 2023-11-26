-- chunkname: @scripts/extension_systems/behavior/trees/renegade/renegade_rifleman_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.renegade_rifleman
local COVER_COMBAT = {
	"BtRandomUtilityNode",
	condition_args = {
		combat_ranges = {
			far = true
		}
	},
	{
		"BtSequenceNode",
		action_data = action_data.has_cover,
		{
			"BtMoveToCoverAction",
			name = "move_to_cover",
			action_data = action_data.move_to_cover
		},
		{
			"BtInCoverAction",
			name = "in_cover",
			action_data = action_data.in_cover
		},
		name = "has_cover"
	},
	{
		"BtShootAction",
		name = "move_to_cover_shoot",
		condition = "is_not_suppressed",
		action_data = action_data.move_to_cover_shoot
	},
	name = "cover_combat",
	condition = "has_cover"
}
local FAR_COMBAT = {
	"BtRandomUtilityNode",
	condition_args = {
		combat_ranges = {
			far = true
		}
	},
	{
		"BtMoveToCombatVectorAction",
		name = "move_to_combat_vector_far",
		action_data = action_data.move_to_combat_vector_far
	},
	{
		"BtShootAction",
		name = "shoot",
		action_data = action_data.shoot
	},
	{
		"BtCombatIdleAction",
		name = "far_combat_idle",
		condition = "attack_not_allowed",
		condition_args = {
			attack_type = "ranged"
		},
		action_data = action_data.far_combat_idle
	},
	name = "far_combat",
	condition = "is_aggroed_in_combat_range"
}
local CLOSE_COMBAT = {
	"BtRandomUtilityNode",
	condition_args = {
		combat_ranges = {
			close = true
		}
	},
	{
		"BtCombatIdleAction",
		name = "close_combat_idle",
		condition = "attack_not_allowed",
		condition_args = {
			attack_type = "ranged"
		},
		action_data = action_data.close_combat_idle
	},
	{
		"BtMoveToCombatVectorAction",
		name = "move_to_combat_vector",
		action_data = action_data.move_to_combat_vector
	},
	{
		"BtShootAction",
		name = "shoot",
		action_data = action_data.shoot
	},
	name = "close_combat",
	condition = "is_aggroed_in_combat_range"
}
local MELEE_COMBAT = {
	"BtRandomUtilityNode",
	condition_args = {
		combat_ranges = {
			melee = true
		}
	},
	{
		"BtMeleeAttackAction",
		name = "bayonet_charge_attack",
		condition = "moving_attack_allowed",
		condition_args = {
			attack_type = "moving_melee"
		},
		action_data = action_data.bayonet_charge_attack
	},
	{
		"BtMeleeFollowTargetAction",
		name = "melee_follow",
		action_data = action_data.melee_follow
	},
	{
		"BtCombatIdleAction",
		name = "melee_combat_idle",
		condition = "should_use_combat_idle",
		action_data = action_data.melee_combat_idle
	},
	{
		"BtMeleeAttackAction",
		name = "melee_attack",
		condition = "attack_allowed",
		condition_args = {
			attack_type = "melee"
		},
		action_data = action_data.melee_attack
	},
	name = "melee_combat",
	condition = "is_aggroed_in_combat_range"
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
	{
		"BtBlockedAction",
		name = "blocked",
		condition = "is_blocked",
		action_data = action_data.blocked
	},
	{
		"BtSwitchWeaponAction",
		name = "switch_weapon",
		condition = "should_switch_weapon",
		action_data = action_data.switch_weapon
	},
	COVER_COMBAT,
	{
		"BtSuppressedAction",
		name = "suppressed",
		condition = "is_suppressed",
		action_data = action_data.suppressed
	},
	MELEE_COMBAT,
	FAR_COMBAT,
	CLOSE_COMBAT,
	{
		"BtAlertedAction",
		name = "alerted",
		condition = "is_alerted",
		action_data = action_data.alerted
	},
	{
		"BtPatrolAction",
		name = "patrol",
		condition = "should_patrol",
		action_data = action_data.patrol
	},
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle
	},
	name = "renegade_rifleman"
}

return behavior_tree
