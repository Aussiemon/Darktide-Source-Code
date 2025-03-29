-- chunkname: @scripts/extension_systems/behavior/trees/chaos/chaos_ogryn_executor_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.chaos_ogryn_executor
local MELEE_COMBAT = {
	"BtRandomUtilityNode",
	{
		"BtMeleeFollowTargetAction",
		name = "follow",
		action_data = action_data.follow,
	},
	{
		"BtCombatIdleAction",
		condition = "should_use_combat_idle",
		name = "combat_idle",
		action_data = action_data.combat_idle,
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
		name = "melee_attack_punch",
		condition_args = {
			attack_type = "melee",
		},
		action_data = action_data.melee_attack_punch,
	},
	{
		"BtMeleeAttackAction",
		condition = "attack_allowed",
		name = "melee_attack_pommel",
		condition_args = {
			attack_type = "melee",
		},
		action_data = action_data.melee_attack_pommel,
	},
	{
		"BtMeleeAttackAction",
		condition = "attack_allowed",
		name = "melee_attack_kick",
		condition_args = {
			attack_type = "melee",
		},
		action_data = action_data.melee_attack_kick,
	},
	{
		"BtMeleeAttackAction",
		condition = "attack_allowed",
		name = "melee_attack_cleave",
		condition_args = {
			attack_type = "melee",
		},
		action_data = action_data.melee_attack_cleave,
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
		name = "moving_melee_attack_cleave",
		condition_args = {
			attack_type = "moving_melee",
		},
		action_data = action_data.moving_melee_attack_cleave,
	},
	condition = "is_aggroed",
	name = "melee_combat",
}
local CLIMB_ENTER_HOOK = {
	hook = "unwield_slot",
	args = {
		slot_name = "slot_melee_weapon",
	},
}
local CLIMB_LEAVE_HOOK = {
	hook = "wield_slot",
	args = {
		slot_name = "slot_melee_weapon",
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
			enter_hook = CLIMB_ENTER_HOOK,
			leave_hook = CLIMB_LEAVE_HOOK,
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
	name = "chaos_ogryn_executor",
}

return behavior_tree
