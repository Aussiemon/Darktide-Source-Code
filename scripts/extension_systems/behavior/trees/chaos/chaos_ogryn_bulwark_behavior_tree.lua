-- chunkname: @scripts/extension_systems/behavior/trees/chaos/chaos_ogryn_bulwark_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.chaos_ogryn_bulwark
local FAR_COMBAT = {
	"BtMeleeFollowTargetAction",
	condition = "is_aggroed_in_combat_range",
	name = "far_follow",
	condition_args = {
		combat_ranges = {
			far = true,
		},
	},
	action_data = action_data.far_follow,
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
		name = "combat_idle",
		action_data = action_data.combat_idle,
	},
	{
		"BtRandomUtilityNode",
		{
			"BtMeleeFollowTargetAction",
			name = "follow",
			action_data = action_data.follow,
		},
		{
			"BtMeleeAttackAction",
			condition = "attack_allowed",
			name = "shield_push",
			condition_args = {
				attack_type = "melee",
			},
			action_data = action_data.shield_push,
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
local CLIMB_ENTER_HOOK = {
	hook = "bulwark_climb_enter",
	args = {
		slot_name = "slot_shield",
	},
}
local CLIMB_LEAVE_HOOK = {
	hook = "bulwark_climb_leave",
	args = {
		slot_name = "slot_shield",
	},
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
			enter_hook = CLIMB_ENTER_HOOK,
			leave_hook = CLIMB_LEAVE_HOOK,
		},
		{
			"BtJumpAcrossAction",
			condition = "at_jump_smart_object",
			enter_hook = "deactivate_shield_blocking",
			leave_hook = "activate_shield_blocking",
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
			enter_hook = "deactivate_shield_blocking",
			leave_hook = "activate_shield_blocking",
			name = "smash_obstacle",
			action_data = action_data.smash_obstacle,
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
	FAR_COMBAT,
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
	name = "chaos_ogryn_bulwark",
}

return behavior_tree
