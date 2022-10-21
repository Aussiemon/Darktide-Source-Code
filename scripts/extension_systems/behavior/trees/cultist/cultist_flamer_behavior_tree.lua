local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.cultist_flamer
local MELEE_COMBAT = {
	"BtRandomUtilityNode",
	{
		"BtMeleeAttackAction",
		name = "melee_attack",
		action_data = action_data.melee_attack
	},
	name = "melee_combat",
	condition = "is_aggroed_in_combat_range",
	condition_args = {
		combat_ranges = {
			melee = true
		}
	}
}
local COMBAT = {
	"BtSequenceNode",
	{
		"BtCultistFlamerApproachAction",
		name = "follow",
		action_data = action_data.follow
	},
	{
		"BtShootLiquidBeamAction",
		name = "shoot",
		action_data = action_data.shoot
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
	MELEE_COMBAT,
	COMBAT,
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle
	},
	name = "cultist_flamer"
}

return behavior_tree
