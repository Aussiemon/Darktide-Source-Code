local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.chaos_newly_infected
local FAR_AND_CLOSE_COMBAT = {
	"BtSelectorNode",
	{
		"BtMeleeFollowTargetAction",
		name = "follow",
		condition = "is_suppressed",
		action_data = action_data.follow
	},
	{
		"BtMeleeFollowTargetAction",
		name = "assault_follow",
		action_data = action_data.assault_follow
	},
	name = "far_and_close_combat",
	condition = "is_aggroed_in_combat_range",
	condition_args = {
		combat_ranges = {
			far = true,
			close = true
		}
	}
}
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
		name = "moving_melee_attack",
		condition = "moving_attack_allowed",
		condition_args = {
			attack_type = "moving_melee"
		},
		action_data = action_data.moving_melee_attack
	},
	{
		"BtMeleeAttackAction",
		name = "running_melee_attack",
		condition = "moving_attack_allowed",
		condition_args = {
			attack_type = "moving_melee"
		},
		action_data = action_data.running_melee_attack
	},
	name = "melee_combat",
	condition = "is_aggroed_in_combat_range",
	condition_args = {
		combat_ranges = {
			melee = true
		}
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
	MELEE_COMBAT,
	FAR_AND_CLOSE_COMBAT,
	{
		"BtAlertedAction",
		name = "alerted",
		condition = "is_alerted",
		action_data = action_data.alerted
	},
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle
	},
	name = "chaos_newly_infected"
}

return behavior_tree
