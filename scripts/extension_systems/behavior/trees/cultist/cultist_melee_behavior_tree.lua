local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.cultist_melee
local FAR_COMBAT = {
	"BtMeleeFollowTargetAction",
	name = "follow",
	condition = "is_aggroed_in_combat_range",
	condition_args = {
		combat_ranges = {
			far = true
		}
	},
	action_data = action_data.follow
}
local CLOSE_COMBAT = {
	"BtSelectorNode",
	{
		"BtMeleeFollowTargetAction",
		name = "assault_follow",
		action_data = action_data.assault_follow
	},
	name = "close_combat",
	condition = "is_aggroed_in_combat_range",
	condition_args = {
		combat_ranges = {
			close = true
		}
	}
}
local MELEE_COMBAT = {
	"BtSelectorNode",
	{
		"BtCombatIdleAction",
		name = "combat_idle",
		condition = "should_use_combat_idle",
		action_data = action_data.combat_idle
	},
	{
		"BtRandomUtilityNode",
		{
			"BtMeleeFollowTargetAction",
			name = "follow",
			action_data = action_data.follow
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
		name = "combat"
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
	FAR_COMBAT,
	CLOSE_COMBAT,
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
	name = "cultist_melee"
}

return behavior_tree
