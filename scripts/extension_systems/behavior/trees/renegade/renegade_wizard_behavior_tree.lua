-- chunkname: @scripts/extension_systems/behavior/trees/renegade/renegade_wizard_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.renegade_wizard
local defensive_summon = {
	"BtSelectorNode",
	condition_args = {
		ability = "summon",
	},
	{
		"BtSequenceNode",
		{
			"BtWizardTeleportAction",
			name = "warp_teleport",
			action_data = action_data.warp_teleport,
		},
		{
			"BtSummonMinionsAction",
			name = "summon",
			action_data = action_data.summon,
		},
		{
			"BtWizardTeleportAction",
			name = "warp_teleport",
			action_data = action_data.warp_teleport,
		},
		condition = "can_summon_minions",
		name = "teleport_to",
	},
	condition = "boss_allowed_to_use_ability",
	name = "summon_minions",
}
local abilites = {
	"BtSelectorNode",
	{
		"BtWizardUpheavalAction",
		condition = "boss_allowed_to_use_ability",
		name = "upheaval",
		condition_args = {
			ability = "upheaval",
		},
		action_data = action_data.upheaval,
	},
	{
		"BtWizardSpawnTeethAction",
		condition = "boss_allowed_to_use_ability",
		name = "spawn_teeth",
		condition_args = {
			ability = "teeth",
		},
		action_data = action_data.spawn_teeth,
	},
	{
		"BtWizardBossCircleDanceAction",
		condition = "boss_allowed_to_use_ability",
		name = "dance",
		condition_args = {
			ability = "dance",
		},
		action_data = action_data.dance,
	},
	{
		"BtWizardBossIntroAction",
		condition = "boss_allowed_to_use_ability",
		name = "intro",
		condition_args = {
			ability = "intro",
		},
		action_data = action_data.intro,
	},
	{
		"BtWizardExhuastedAction",
		condition = "boss_allowed_to_use_ability",
		name = "exhausted",
		condition_args = {
			ability = "exhausted",
		},
		action_data = action_data.exhausted,
	},
	{
		"BtWizardForcePushAction",
		condition = "boss_allowed_to_use_ability",
		name = "force_push",
		condition_args = {
			ability = "force_push",
		},
		action_data = action_data.force_push,
	},
	condition = "is_aggroed",
	name = "abilites",
}
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtWizardDieAction",
		name = "death",
		state = "dead",
		action_data = action_data.death,
	},
	{
		"BtDisableAction",
		condition = "is_minion_disabled",
		exit_state = "base",
		name = "disable",
		state = "disabled",
		action_data = action_data.disable,
	},
	{
		"BtExitSpawnerAction",
		condition = "is_exiting_spawner",
		exit_state = "base",
		name = "exit_spawner",
		state = "exiting_spawner",
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
	{
		"BtStaggerAction",
		condition = "is_staggered",
		name = "stagger",
		action_data = action_data.stagger,
	},
	{
		"BtWizardTeleportAction",
		condition = "allowed_to_teleport",
		leave_hook = "wizard_boss_leave_dive_bomb",
		name = "warp_teleport",
		action_data = action_data.warp_teleport,
	},
	abilites,
	{
		"BtWizardShootAction",
		condition = "boss_is_aggroed_and_allowed_to_use_bas_ability",
		name = "shoot",
		action_data = action_data.shoot,
	},
	defensive_summon,
	{
		"BtWizardIdleAction",
		name = "idle",
		action_data = action_data.idle,
	},
	name = "renegade_wizard",
}

return behavior_tree
