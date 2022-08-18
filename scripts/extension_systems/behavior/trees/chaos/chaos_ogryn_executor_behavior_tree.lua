local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.chaos_ogryn_executor
local MELEE_COMBAT = {
	"BtRandomUtilityNode",
	{
		"BtMeleeFollowTargetAction",
		name = "follow",
		action_data = action_data.follow
	},
	{
		"BtCombatIdleAction",
		name = "combat_idle",
		condition = "should_use_combat_idle",
		action_data = action_data.combat_idle
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
	{
		"BtMeleeAttackAction",
		name = "melee_attack_punch",
		condition = "attack_allowed",
		condition_args = {
			attack_type = "melee"
		},
		action_data = action_data.melee_attack_punch
	},
	{
		"BtMeleeAttackAction",
		name = "melee_attack_pommel",
		condition = "attack_allowed",
		condition_args = {
			attack_type = "melee"
		},
		action_data = action_data.melee_attack_pommel
	},
	{
		"BtMeleeAttackAction",
		name = "melee_attack_kick",
		condition = "attack_allowed",
		condition_args = {
			attack_type = "melee"
		},
		action_data = action_data.melee_attack_kick
	},
	{
		"BtMeleeAttackAction",
		name = "melee_attack_cleave",
		condition = "attack_allowed",
		condition_args = {
			attack_type = "melee"
		},
		action_data = action_data.melee_attack_cleave
	},
	{
		"BtMeleeAttackAction",
		name = "moving_melee_attack",
		condition = "moving_attack_allowed",
		condition_args = {
			attack_type = "moving_melee"
		},
		action_data = action_data.moving_melee_attack
	},
	{
		"BtMeleeAttackAction",
		name = "moving_melee_attack_cleave",
		condition = "moving_attack_allowed",
		condition_args = {
			attack_type = "moving_melee"
		},
		action_data = action_data.moving_melee_attack_cleave
	},
	condition = "is_aggroed",
	name = "melee_combat"
}
local CLIMB_ENTER_HOOK = {
	hook = "unwield_slot",
	args = {
		slot_name = "slot_melee_weapon"
	}
}
local CLIMB_LEAVE_HOOK = {
	hook = "wield_slot",
	args = {
		slot_name = "slot_melee_weapon"
	}
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
			action_data = action_data.climb,
			enter_hook = CLIMB_ENTER_HOOK,
			leave_hook = CLIMB_LEAVE_HOOK
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
		{
			"BtSmashObstacleAction",
			name = "smash_obstacle",
			condition = "at_smashable_obstacle_smart_object",
			action_data = action_data.smash_obstacle
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
	MELEE_COMBAT,
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
	name = "chaos_ogryn_executor"
}

return behavior_tree
