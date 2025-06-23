-- chunkname: @scripts/extension_systems/behavior/trees/renegade/renegade_twin_captain_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.renegade_twin_captain
local KICK = {
	"BtMeleeAttackAction",
	name = "kick",
	condition = "is_aggroed_in_combat_range",
	action_data = action_data.kick,
	condition_args = {
		combat_ranges = {
			melee = true,
			close = true
		}
	}
}
local SHIELD_DOWN_RECHARGE = {
	"BtRenegadeTwinCaptainShieldDownAction",
	name = "shield_down_recharge",
	condition = "renegade_twin_captain_shield_down_recharge",
	action_data = action_data.shield_down_recharge
}
local VOID_SHIELD_EXPLOSION = {
	"BtVoidShieldExplosionAction",
	name = "void_shield_explosion",
	condition = "twin_captain_void_shield_explosion",
	action_data = action_data.void_shield_explosion
}
local CLOSE_COMBAT = {
	"BtRandomUtilityNode",
	condition_args = {
		combat_ranges = {
			far = true,
			close = true
		}
	},
	{
		"BtMeleeAttackAction",
		name = "kick",
		condition = "is_aggroed_in_combat_range",
		action_data = action_data.kick,
		condition_args = {
			combat_ranges = {
				melee = true,
				close = true
			}
		}
	},
	{
		"BtRangedFollowTargetAction",
		name = "ranged_follow",
		action_data = action_data.ranged_follow
	},
	{
		"BtShootAction",
		name = "plasma_pistol_shoot",
		action_data = action_data.plasma_pistol_shoot
	},
	VOID_SHIELD_EXPLOSION,
	{
		"BtQuickGrenadeThrowAction",
		name = "multiple_quick_throw_grenade_empowered",
		condition = "is_empowered",
		action_data = action_data.multiple_quick_throw_grenade_empowered,
		enter_hook = {
			hook = "captain_grenade_enter"
		},
		leave_hook = {
			hook = "captain_grenade_exit",
			args = {
				exit_anim_states = action_data.exit_anim_states
			}
		}
	},
	{
		"BtRandomUtilityNode",
		action_data = action_data.throw_grenade,
		{
			"BtQuickGrenadeThrowAction",
			name = "quick_throw_grenade",
			action_data = action_data.quick_throw_grenade,
			enter_hook = {
				hook = "captain_grenade_enter"
			},
			leave_hook = {
				hook = "captain_grenade_exit",
				args = {
					exit_anim_states = action_data.exit_anim_states
				}
			}
		},
		{
			"BtQuickGrenadeThrowAction",
			name = "multiple_quick_throw_grenade",
			action_data = action_data.multiple_quick_throw_grenade,
			enter_hook = {
				hook = "captain_grenade_enter"
			},
			leave_hook = {
				hook = "captain_grenade_exit",
				args = {
					exit_anim_states = action_data.exit_anim_states
				}
			}
		},
		name = "throw_grenade",
		condition = "can_throw_grenade"
	},
	name = "plasma_pistol_combat",
	condition = "is_aggroed_in_combat_range_or_running"
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
		"BtRenegadeTwinCaptainDisappearAction",
		name = "disappear_instant",
		condition = "renegade_twin_captain_should_disappear_instant",
		action_data = action_data.disappear_instant
	},
	{
		"BtRenegadeTwinCaptainDisappearAction",
		name = "disappear",
		condition = "renegade_twin_captain_should_disappear",
		action_data = action_data.disappear
	},
	{
		"BtTwinCaptainDisappearIdleAction",
		name = "disappear_idle",
		condition = "twin_captain_disappear_idle",
		action_data = action_data.disappear_idle
	},
	{
		"BtStaggerAction",
		name = "stagger",
		condition = "is_staggered",
		action_data = action_data.stagger
	},
	SHIELD_DOWN_RECHARGE,
	{
		"BtTwinCaptainIntroAction",
		name = "intro",
		condition = "has_move_to_position",
		action_data = action_data.intro
	},
	CLOSE_COMBAT,
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle
	},
	name = "renegade_twin_captain"
}

return behavior_tree
