-- chunkname: @scripts/extension_systems/behavior/trees/cultist/cultist_captain_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.cultist_captain
local HELLGUN = {
	"BtRandomUtilityNode",
	condition_args = {
		slot_name = "slot_hellgun",
	},
	{
		"BtRangedFollowTargetAction",
		name = "ranged_follow",
		action_data = action_data.ranged_follow,
	},
	{
		"BtShootAction",
		name = "hellgun_shoot",
		action_data = action_data.hellgun_shoot,
		enter_hook = {
			hook = "set_scratchpad_value",
			args = {
				field = "is_blocking_captain_special_actions",
				value = true,
			},
		},
		leave_hook = {
			hook = "set_scratchpad_value",
			args = {
				field = "is_blocking_captain_special_actions",
				value = false,
			},
		},
	},
	{
		"BtShootAction",
		name = "hellgun_spray_and_pray",
		action_data = action_data.hellgun_spray_and_pray,
		enter_hook = {
			hook = "set_scratchpad_value",
			args = {
				field = "is_blocking_captain_special_actions",
				value = true,
			},
		},
		leave_hook = {
			hook = "set_scratchpad_value",
			args = {
				field = "is_blocking_captain_special_actions",
				value = false,
			},
		},
	},
	condition = "slot_wielded",
	name = "hellgun_combat",
}
local NETGUN = {
	"BtSelectorNode",
	condition_args = {
		slot_name = "slot_netgun",
	},
	{
		"BtSequenceNode",
		{
			"BtRenegadeNetgunnerApproachAction",
			name = "approach_target",
			action_data = action_data.approach_target,
		},
		{
			"BtShootNetAction",
			name = "shoot_net",
			action_data = action_data.shoot_net,
			leave_hook = {
				hook = "set_component_value",
				args = {
					component_name = "phase",
					field = "force_next_phase",
					value = true,
				},
			},
		},
		condition = "can_shoot_net",
		name = "net_sequence_far",
	},
	condition = "slot_wielded",
	name = "netgun_combat",
}
local BOLT_PISTOL = {
	"BtRandomUtilityNode",
	condition_args = {
		slot_name = "slot_bolt_pistol",
	},
	{
		"BtRangedFollowTargetAction",
		name = "ranged_follow",
		action_data = action_data.ranged_follow,
	},
	{
		"BtShootAction",
		name = "bolt_pistol_shoot",
		action_data = action_data.bolt_pistol_shoot,
		enter_hook = {
			hook = "set_scratchpad_value",
			args = {
				field = "is_blocking_captain_special_actions",
				value = true,
			},
		},
		leave_hook = {
			hook = "set_scratchpad_value",
			args = {
				field = "is_blocking_captain_special_actions",
				value = false,
			},
		},
	},
	condition = "slot_wielded",
	name = "bolt_pistol_combat",
}
local PLASMA_PISTOL = {
	"BtRandomUtilityNode",
	condition_args = {
		slot_name = "slot_plasma_pistol",
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
		enter_hook = {
			hook = "set_scratchpad_value",
			args = {
				field = "is_blocking_captain_special_actions",
				value = true,
			},
		},
		leave_hook = {
			hook = "set_scratchpad_value",
			args = {
				field = "is_blocking_captain_special_actions",
				value = false,
			},
		},
	},
	{
		"BtShootAction",
		name = "plasma_pistol_shoot_volley",
		action_data = action_data.plasma_pistol_shoot_volley,
		enter_hook = {
			hook = "set_scratchpad_value",
			args = {
				field = "is_blocking_captain_special_actions",
				value = true,
			},
		},
		leave_hook = {
			hook = "set_scratchpad_value",
			args = {
				field = "is_blocking_captain_special_actions",
				value = false,
			},
		},
	},
	condition = "slot_wielded",
	name = "plasma_pistol_combat",
}
local SHOTGUN = {
	"BtRandomUtilityNode",
	condition_args = {
		slot_name = "slot_shotgun",
	},
	{
		"BtRangedFollowTargetAction",
		name = "ranged_follow",
		action_data = action_data.ranged_follow,
	},
	{
		"BtShootAction",
		name = "shotgun_shoot",
		action_data = action_data.shotgun_shoot,
		enter_hook = {
			hook = "set_scratchpad_value",
			args = {
				field = "is_blocking_captain_special_actions",
				value = true,
			},
		},
		leave_hook = {
			hook = "set_scratchpad_value",
			args = {
				field = "is_blocking_captain_special_actions",
				value = false,
			},
		},
	},
	condition = "slot_wielded",
	name = "shotgun_combat",
}
local POWER_SWORD = {
	"BtSelectorNode",
	condition_args = {
		slot_name = "slot_power_sword",
	},
	{
		"BtRandomUtilityNode",
		{
			"BtMeleeFollowTargetAction",
			name = "melee_follow_power_sword",
			action_data = action_data.melee_follow_power_sword,
		},
		{
			"BtMeleeAttackAction",
			name = "power_sword_melee_combo_attack",
			action_data = action_data.power_sword_melee_combo_attack,
			enter_hook = {
				hook = "set_scratchpad_value",
				args = {
					field = "is_blocking_captain_special_actions",
					value = true,
				},
			},
			leave_hook = {
				hook = "set_scratchpad_value",
				args = {
					field = "is_blocking_captain_special_actions",
					value = false,
				},
			},
		},
		{
			"BtMeleeAttackAction",
			name = "power_sword_melee_sweep",
			action_data = action_data.power_sword_melee_sweep,
			enter_hook = {
				hook = "set_scratchpad_value",
				args = {
					field = "is_blocking_captain_special_actions",
					value = true,
				},
			},
			leave_hook = {
				hook = "set_scratchpad_value",
				args = {
					field = "is_blocking_captain_special_actions",
					value = false,
				},
			},
		},
		{
			"BtMeleeAttackAction",
			name = "power_sword_moving_melee_attack",
			action_data = action_data.power_sword_moving_melee_attack,
			enter_hook = {
				hook = "set_scratchpad_value",
				args = {
					field = "is_blocking_captain_special_actions",
					value = true,
				},
			},
			leave_hook = {
				hook = "set_scratchpad_value",
				args = {
					field = "is_blocking_captain_special_actions",
					value = false,
				},
			},
		},
		{
			"BtMeleeAttackAction",
			name = "power_sword_melee_attack",
			action_data = action_data.power_sword_melee_attack,
			enter_hook = {
				hook = "set_scratchpad_value",
				args = {
					field = "is_blocking_captain_special_actions",
					value = true,
				},
			},
			leave_hook = {
				hook = "set_scratchpad_value",
				args = {
					field = "is_blocking_captain_special_actions",
					value = false,
				},
			},
		},
		name = "power_sword_melee_combat",
	},
	{
		"BtCombatIdleAction",
		condition = "should_use_combat_idle",
		name = "melee_combat_idle",
		condition_args = {
			attack_type = "melee",
		},
		action_data = action_data.melee_combat_idle,
	},
	condition = "slot_wielded",
	name = "power_sword_combat",
}
local POWERMAUL = {
	"BtSelectorNode",
	condition_args = {
		slot_name = "slot_powermaul",
	},
	{
		"BtRandomUtilityNode",
		{
			"BtMeleeFollowTargetAction",
			name = "melee_follow_powermaul",
			action_data = action_data.melee_follow_powermaul,
		},
		{
			"BtMeleeAttackAction",
			name = "powermaul_melee_attack",
			action_data = action_data.powermaul_melee_attack,
			enter_hook = {
				hook = "set_scratchpad_value",
				args = {
					field = "is_blocking_captain_special_actions",
					value = true,
				},
			},
			leave_hook = {
				hook = "set_scratchpad_value",
				args = {
					field = "is_blocking_captain_special_actions",
					value = false,
				},
			},
		},
		{
			"BtMeleeAttackAction",
			name = "powermaul_melee_cleave",
			action_data = action_data.powermaul_melee_cleave,
			enter_hook = {
				hook = "set_scratchpad_value",
				args = {
					field = "is_blocking_captain_special_actions",
					value = true,
				},
			},
			leave_hook = {
				hook = "set_scratchpad_value",
				args = {
					field = "is_blocking_captain_special_actions",
					value = false,
				},
			},
		},
		{
			"BtMeleeAttackAction",
			name = "powermaul_moving_melee_cleave",
			action_data = action_data.powermaul_moving_melee_cleave,
			enter_hook = {
				hook = "set_scratchpad_value",
				args = {
					field = "is_blocking_captain_special_actions",
					value = true,
				},
			},
			leave_hook = {
				hook = "set_scratchpad_value",
				args = {
					field = "is_blocking_captain_special_actions",
					value = false,
				},
			},
		},
		{
			"BtMeleeAttackAction",
			name = "powermaul_ground_slam",
			action_data = action_data.powermaul_ground_slam,
			enter_hook = {
				hook = "set_scratchpad_value",
				args = {
					field = "is_blocking_captain_special_actions",
					value = true,
				},
			},
			leave_hook = {
				hook = "set_scratchpad_value",
				args = {
					field = "is_blocking_captain_special_actions",
					value = false,
				},
			},
		},
		{
			"BtMeleeAttackAction",
			name = "powermaul_pommel",
			action_data = action_data.powermaul_pommel,
			enter_hook = {
				hook = "set_scratchpad_value",
				args = {
					field = "is_blocking_captain_special_actions",
					value = true,
				},
			},
			leave_hook = {
				hook = "set_scratchpad_value",
				args = {
					field = "is_blocking_captain_special_actions",
					value = false,
				},
			},
		},
		name = "powermaul_melee_combat",
	},
	{
		"BtCombatIdleAction",
		condition = "should_use_combat_idle",
		name = "melee_combat_idle",
		condition_args = {
			attack_type = "melee",
		},
		action_data = action_data.melee_combat_idle,
	},
	condition = "slot_wielded",
	name = "powermaul_combat",
}
local CHARGE = {
	"BtChargeAction",
	condition = "is_aggroed_in_combat_range",
	name = "charge",
	action_data = action_data.charge,
	condition_args = {
		combat_ranges = {
			melee = true,
		},
	},
	enter_hook = {
		hook = "captain_charge_enter",
	},
	leave_hook = {
		hook = "captain_charge_exit",
		args = {
			exit_anim_states = action_data.exit_anim_states,
		},
	},
}
local VOID_SHIELD_EXPLOSION = {
	"BtVoidShieldExplosionAction",
	name = "void_shield_explosion",
	action_data = action_data.void_shield_explosion,
	enter_hook = {
		hook = "set_component_value",
		args = {
			component_name = "phase",
			field = "lock",
			value = true,
		},
	},
	leave_hook = {
		hook = "set_component_value",
		args = {
			component_name = "phase",
			field = "lock",
			value = false,
		},
	},
}
local FIRE_GRENADE = {
	"BtQuickGrenadeThrowAction",
	name = "throw_fire_grenade",
	action_data = action_data.throw_fire_grenade,
	enter_hook = {
		hook = "captain_grenade_enter",
	},
	leave_hook = {
		hook = "captain_grenade_exit",
		args = {
			exit_anim_states = action_data.exit_anim_states,
		},
	},
}
local FRAG_GRENADE = {
	"BtQuickGrenadeThrowAction",
	name = "throw_frag_grenade",
	action_data = action_data.throw_frag_grenade,
	enter_hook = {
		hook = "captain_grenade_enter",
	},
	leave_hook = {
		hook = "captain_grenade_exit",
		args = {
			exit_anim_states = action_data.exit_anim_states,
		},
	},
}
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
local PUNCH = {
	"BtMeleeAttackAction",
	condition = "is_aggroed_in_combat_range",
	name = "punch",
	action_data = action_data.punch,
	condition_args = {
		combat_ranges = {
			close = true,
			melee = true,
		},
	},
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
	{
		"BtSwitchWeaponAction",
		condition = "should_switch_weapon",
		name = "switch_weapon",
		action_data = action_data.switch_weapon,
	},
	SPECIAL_ACTION,
	{
		"BtSelectorNode",
		{
			"BtRandomUtilityNode",
			KICK,
			PUNCH,
			FIRE_GRENADE,
			CHARGE,
			VOID_SHIELD_EXPLOSION,
			condition = "captain_can_use_special_actions",
			name = "renegade_captain_specials",
		},
		POWERMAUL,
		POWER_SWORD,
		HELLGUN,
		BOLT_PISTOL,
		PLASMA_PISTOL,
		NETGUN,
		SHOTGUN,
		condition = "is_aggroed",
		name = "renegade_captain_combat",
	},
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
	name = "cultist_captain",
}

return behavior_tree
