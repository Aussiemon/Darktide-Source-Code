-- chunkname: @scripts/extension_systems/behavior/trees/renegade/renegade_radio_operator_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.renegade_radio_operator
local COVER_COMBAT = {
	"BtSequenceNode",
	condition_args = {
		combat_ranges = {
			far = true
		}
	},
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
	name = "has_cover",
	condition = "has_cover"
}
local SUPPRESSED = {
	"BtSequenceNode",
	{
		"BtSuppressedAction",
		name = "suppressed",
		action_data = action_data.suppressed
	},
	{
		"BtMoveToCombatVectorAction",
		name = "move_to_combat_vector",
		action_data = action_data.move_to_combat_vector
	},
	condition = "is_suppressed",
	name = "suppressed"
}
local COMBAT = {
	"BtRandomUtilityNode",
	{
		"BtMeleeAttackAction",
		name = "melee_attack",
		action_data = action_data.melee_attack
	},
	{
		"BtShootAction",
		name = "shoot_spray_n_pray",
		condition = "has_clear_shot",
		action_data = action_data.shoot_spray_n_pray
	},
	{
		"BtMoveToCombatVectorAction",
		name = "move_to_combat_vector",
		action_data = action_data.move_to_combat_vector
	},
	{
		"BtMoveToCombatVectorAction",
		name = "escape_to_combat_vector",
		action_data = action_data.escape_to_combat_vector
	},
	condition = "is_aggroed",
	name = "combat"
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
	{
		"BtBlockedAction",
		name = "blocked",
		condition = "is_blocked",
		action_data = action_data.blocked
	},
	{
		"BtSummonMinionsAction",
		name = "summon",
		condition = "can_summon_timer_only",
		action_data = action_data.summon
	},
	COVER_COMBAT,
	SUPPRESSED,
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
	name = "renegade_radio_operator"
}

return behavior_tree
