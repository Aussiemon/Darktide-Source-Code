-- chunkname: @scripts/extension_systems/behavior/trees/cultist/cultist_gunner_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.cultist_gunner
local COVER_COMBAT = {
	"BtSequenceNode",
	condition_args = {
		combat_ranges = {
			far = true,
		},
	},
	{
		"BtMoveToCoverAction",
		name = "move_to_cover",
		action_data = action_data.move_to_cover,
	},
	{
		"BtInCoverAction",
		name = "in_cover",
		action_data = action_data.in_cover,
	},
	condition = "has_cover",
	name = "has_cover",
}
local SUPPRESSED = {
	"BtSequenceNode",
	{
		"BtSuppressedAction",
		name = "suppressed",
		action_data = action_data.suppressed,
	},
	{
		"BtMoveToCombatVectorAction",
		name = "move_to_combat_vector",
		action_data = action_data.move_to_combat_vector,
	},
	condition = "is_suppressed",
	name = "suppressed",
}
local COMBAT = {
	"BtRandomUtilityNode",
	{
		"BtMeleeAttackAction",
		name = "bayonet_melee_attack",
		action_data = action_data.bayonet_melee_attack,
	},
	{
		"BtShootAction",
		condition = "has_clear_shot",
		name = "shoot_spray_n_pray",
		action_data = action_data.shoot_spray_n_pray,
	},
	{
		"BtMoveToCombatVectorAction",
		name = "move_to_combat_vector",
		action_data = action_data.move_to_combat_vector,
	},
	condition = "is_aggroed",
	name = "combat",
}
local SPECIAL_ACTION = {
	"BtSelectorNode",
	{
		"BtUseStimAction",
		name = "use_stim",
		action_data = action_data.use_stim,
	},
	condition = "minion_can_use_special_action",
	name = "use_special_action",
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
	SPECIAL_ACTION,
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
	COVER_COMBAT,
	SUPPRESSED,
	COMBAT,
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
	name = "cultist_gunner",
}

return behavior_tree
