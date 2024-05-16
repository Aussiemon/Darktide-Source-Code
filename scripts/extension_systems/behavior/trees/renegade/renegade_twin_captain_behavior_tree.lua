-- chunkname: @scripts/extension_systems/behavior/trees/renegade/renegade_twin_captain_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.renegade_twin_captain
local KICK = {
	"BtMeleeAttackAction",
	condition = "is_aggroed_in_combat_range",
	name = "kick",
	action_data = action_data.kick,
	condition_args = {
		combat_ranges = {
			close = true,
			melee = true,
		},
	},
}
local SHIELD_DOWN_RECHARGE = {
	"BtRenegadeTwinCaptainShieldDownAction",
	condition = "renegade_twin_captain_shield_down_recharge",
	name = "shield_down_recharge",
	action_data = action_data.shield_down_recharge,
}
local VOID_SHIELD_EXPLOSION = {
	"BtVoidShieldExplosionAction",
	condition = "twin_captain_void_shield_explosion",
	name = "void_shield_explosion",
	action_data = action_data.void_shield_explosion,
}
local CLOSE_COMBAT = {
	"BtRandomUtilityNode",
	condition_args = {
		combat_ranges = {
			close = true,
			far = true,
		},
	},
	{
		"BtMeleeAttackAction",
		condition = "is_aggroed_in_combat_range",
		name = "kick",
		action_data = action_data.kick,
		condition_args = {
			combat_ranges = {
				close = true,
				melee = true,
			},
		},
	},
	{
		"BtRangedFollowTargetAction",
		name = "ranged_follow",
		action_data = action_data.ranged_follow,
	},
	{
		"BtShootAction",
		name = "plasma_pistol_shoot",
		action_data = action_data.plasma_pistol_shoot,
	},
	VOID_SHIELD_EXPLOSION,
	{
		"BtQuickGrenadeThrowAction",
		condition = "is_empowered",
		name = "multiple_quick_throw_grenade_empowered",
		action_data = action_data.multiple_quick_throw_grenade_empowered,
		enter_hook = {
			hook = "captain_grenade_enter",
		},
		leave_hook = {
			hook = "captain_grenade_exit",
			args = {
				exit_anim_states = action_data.exit_anim_states,
			},
		},
	},
	{
		"BtRandomUtilityNode",
		action_data = action_data.throw_grenade,
		{
			"BtQuickGrenadeThrowAction",
			name = "quick_throw_grenade",
			action_data = action_data.quick_throw_grenade,
			enter_hook = {
				hook = "captain_grenade_enter",
			},
			leave_hook = {
				hook = "captain_grenade_exit",
				args = {
					exit_anim_states = action_data.exit_anim_states,
				},
			},
		},
		{
			"BtQuickGrenadeThrowAction",
			name = "multiple_quick_throw_grenade",
			action_data = action_data.multiple_quick_throw_grenade,
			enter_hook = {
				hook = "captain_grenade_enter",
			},
			leave_hook = {
				hook = "captain_grenade_exit",
				args = {
					exit_anim_states = action_data.exit_anim_states,
				},
			},
		},
		condition = "can_throw_grenade",
		name = "throw_grenade",
	},
	condition = "is_aggroed_in_combat_range_or_running",
	name = "plasma_pistol_combat",
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
		},
		{
			"BtJumpAcrossAction",
			condition = "at_jump_smart_object",
			name = "jump_across",
			action_data = action_data.jump_across,
		},
		{
			"BtSmashObstacleAction",
			condition = "at_smashable_obstacle_smart_object",
			name = "smash_obstacle",
			action_data = action_data.smash_obstacle,
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
		"BtRenegadeTwinCaptainDisappearAction",
		condition = "renegade_twin_captain_should_disappear_instant",
		name = "disappear_instant",
		action_data = action_data.disappear_instant,
	},
	{
		"BtRenegadeTwinCaptainDisappearAction",
		condition = "renegade_twin_captain_should_disappear",
		name = "disappear",
		action_data = action_data.disappear,
	},
	{
		"BtTwinCaptainDisappearIdleAction",
		condition = "twin_captain_disappear_idle",
		name = "disappear_idle",
		action_data = action_data.disappear_idle,
	},
	{
		"BtStaggerAction",
		condition = "is_staggered",
		name = "stagger",
		action_data = action_data.stagger,
	},
	SHIELD_DOWN_RECHARGE,
	{
		"BtTwinCaptainIntroAction",
		condition = "has_move_to_position",
		name = "intro",
		action_data = action_data.intro,
	},
	CLOSE_COMBAT,
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle,
	},
	name = "renegade_twin_captain",
}

return behavior_tree
