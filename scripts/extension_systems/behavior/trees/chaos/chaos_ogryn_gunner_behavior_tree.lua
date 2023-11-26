-- chunkname: @scripts/extension_systems/behavior/trees/chaos/chaos_ogryn_gunner_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.chaos_ogryn_gunner
local COMBAT = {
	"BtRandomUtilityNode",
	{
		"BtMeleeAttackAction",
		name = "melee_attack",
		action_data = action_data.melee_attack
	},
	{
		"BtMeleeAttackAction",
		name = "melee_attack_push",
		action_data = action_data.melee_attack_push
	},
	{
		"BtShootAction",
		name = "shoot",
		condition = "has_clear_shot",
		action_data = action_data.shoot
	},
	{
		"BtMoveToCombatVectorAction",
		name = "move_to_combat_vector",
		action_data = action_data.move_to_combat_vector
	},
	condition = "is_aggroed",
	name = "combat"
}
local CLIMB_ENTER_HOOK = {
	hook = "unwield_slot",
	args = {
		slot_name = "slot_ranged_weapon"
	}
}
local CLIMB_LEAVE_HOOK = {
	hook = "wield_slot",
	args = {
		slot_name = "slot_ranged_weapon"
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
		"BtSuppressedAction",
		name = "suppressed",
		condition = "is_suppressed",
		action_data = action_data.suppressed
	},
	COMBAT,
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
	name = "chaos_ogryn_gunner"
}

return behavior_tree
