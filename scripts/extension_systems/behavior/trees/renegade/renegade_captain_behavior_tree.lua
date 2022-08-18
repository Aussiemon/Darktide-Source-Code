local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.renegade_captain
local HELLGUN = {
	"BtRandomUtilityNode",
	{
		"BtRangedFollowTargetAction",
		name = "ranged_follow",
		action_data = action_data.ranged_follow
	},
	{
		"BtShootAction",
		name = "hellgun_shoot",
		action_data = action_data.hellgun_shoot,
		enter_hook = {
			hook = "set_scratchpad_value",
			args = {
				value = true,
				field = "is_blocking_captain_special_actions"
			}
		},
		leave_hook = {
			hook = "set_scratchpad_value",
			args = {
				value = false,
				field = "is_blocking_captain_special_actions"
			}
		}
	},
	{
		"BtShootAction",
		name = "hellgun_spray_and_pray",
		action_data = action_data.hellgun_spray_and_pray,
		enter_hook = {
			hook = "set_scratchpad_value",
			args = {
				value = true,
				field = "is_blocking_captain_special_actions"
			}
		},
		leave_hook = {
			hook = "set_scratchpad_value",
			args = {
				value = false,
				field = "is_blocking_captain_special_actions"
			}
		}
	},
	name = "hellgun_combat",
	condition = "slot_wielded",
	condition_args = {
		slot_name = "slot_hellgun"
	}
}
local NETGUN = {
	"BtSelectorNode",
	{
		"BtSequenceNode",
		{
			"BtRenegadeNetgunnerApproachAction",
			name = "approach_target",
			action_data = action_data.approach_target
		},
		{
			"BtShootNetAction",
			name = "shoot_net",
			action_data = action_data.shoot_net,
			leave_hook = {
				hook = "set_component_value",
				args = {
					value = true,
					field = "force_next_phase",
					component_name = "phase"
				}
			}
		},
		condition = "can_shoot_net",
		name = "net_sequence_far"
	},
	name = "netgun_combat",
	condition = "slot_wielded",
	condition_args = {
		slot_name = "slot_netgun"
	}
}
local BOLT_PISTOL = {
	"BtRandomUtilityNode",
	{
		"BtRangedFollowTargetAction",
		name = "ranged_follow",
		action_data = action_data.ranged_follow
	},
	{
		"BtShootAction",
		name = "bolt_pistol_shoot",
		action_data = action_data.bolt_pistol_shoot,
		enter_hook = {
			hook = "set_scratchpad_value",
			args = {
				value = true,
				field = "is_blocking_captain_special_actions"
			}
		},
		leave_hook = {
			hook = "set_scratchpad_value",
			args = {
				value = false,
				field = "is_blocking_captain_special_actions"
			}
		}
	},
	name = "bolt_pistol_combat",
	condition = "slot_wielded",
	condition_args = {
		slot_name = "slot_bolt_pistol"
	}
}
local PLASMA_PISTOL = {
	"BtRandomUtilityNode",
	{
		"BtRangedFollowTargetAction",
		name = "ranged_follow",
		action_data = action_data.ranged_follow
	},
	{
		"BtShootAction",
		name = "plasma_pistol_shoot",
		action_data = action_data.plasma_pistol_shoot,
		enter_hook = {
			hook = "set_scratchpad_value",
			args = {
				value = true,
				field = "is_blocking_captain_special_actions"
			}
		},
		leave_hook = {
			hook = "set_scratchpad_value",
			args = {
				value = false,
				field = "is_blocking_captain_special_actions"
			}
		}
	},
	{
		"BtShootAction",
		name = "plasma_pistol_shoot_volley",
		action_data = action_data.plasma_pistol_shoot_volley,
		enter_hook = {
			hook = "set_scratchpad_value",
			args = {
				value = true,
				field = "is_blocking_captain_special_actions"
			}
		},
		leave_hook = {
			hook = "set_scratchpad_value",
			args = {
				value = false,
				field = "is_blocking_captain_special_actions"
			}
		}
	},
	name = "plasma_pistol_combat",
	condition = "slot_wielded",
	condition_args = {
		slot_name = "slot_plasma_pistol"
	}
}
local SHOTGUN = {
	"BtRandomUtilityNode",
	{
		"BtRangedFollowTargetAction",
		name = "ranged_follow",
		action_data = action_data.ranged_follow
	},
	{
		"BtShootAction",
		name = "shotgun_shoot",
		action_data = action_data.shotgun_shoot,
		enter_hook = {
			hook = "set_scratchpad_value",
			args = {
				value = true,
				field = "is_blocking_captain_special_actions"
			}
		},
		leave_hook = {
			hook = "set_scratchpad_value",
			args = {
				value = false,
				field = "is_blocking_captain_special_actions"
			}
		}
	},
	name = "shotgun_combat",
	condition = "slot_wielded",
	condition_args = {
		slot_name = "slot_shotgun"
	}
}
local POWER_SWORD = {
	"BtSelectorNode",
	{
		"BtRandomUtilityNode",
		{
			"BtMeleeFollowTargetAction",
			name = "melee_follow_power_sword",
			action_data = action_data.melee_follow_power_sword
		},
		{
			"BtMeleeAttackAction",
			name = "power_sword_melee_combo_attack",
			action_data = action_data.power_sword_melee_combo_attack,
			enter_hook = {
				hook = "set_scratchpad_value",
				args = {
					value = true,
					field = "is_blocking_captain_special_actions"
				}
			},
			leave_hook = {
				hook = "set_scratchpad_value",
				args = {
					value = false,
					field = "is_blocking_captain_special_actions"
				}
			}
		},
		{
			"BtMeleeAttackAction",
			name = "power_sword_melee_sweep",
			action_data = action_data.power_sword_melee_sweep,
			enter_hook = {
				hook = "set_scratchpad_value",
				args = {
					value = true,
					field = "is_blocking_captain_special_actions"
				}
			},
			leave_hook = {
				hook = "set_scratchpad_value",
				args = {
					value = false,
					field = "is_blocking_captain_special_actions"
				}
			}
		},
		{
			"BtMeleeAttackAction",
			name = "power_sword_moving_melee_attack",
			action_data = action_data.power_sword_moving_melee_attack,
			enter_hook = {
				hook = "set_scratchpad_value",
				args = {
					value = true,
					field = "is_blocking_captain_special_actions"
				}
			},
			leave_hook = {
				hook = "set_scratchpad_value",
				args = {
					value = false,
					field = "is_blocking_captain_special_actions"
				}
			}
		},
		{
			"BtMeleeAttackAction",
			name = "power_sword_melee_attack",
			action_data = action_data.power_sword_melee_attack,
			enter_hook = {
				hook = "set_scratchpad_value",
				args = {
					value = true,
					field = "is_blocking_captain_special_actions"
				}
			},
			leave_hook = {
				hook = "set_scratchpad_value",
				args = {
					value = false,
					field = "is_blocking_captain_special_actions"
				}
			}
		},
		name = "power_sword_melee_combat"
	},
	{
		"BtCombatIdleAction",
		name = "melee_combat_idle",
		condition = "should_use_combat_idle",
		condition_args = {
			attack_type = "melee"
		},
		action_data = action_data.melee_combat_idle
	},
	name = "power_sword_combat",
	condition = "slot_wielded",
	condition_args = {
		slot_name = "slot_power_sword"
	}
}
local POWERMAUL = {
	"BtSelectorNode",
	{
		"BtRandomUtilityNode",
		{
			"BtMeleeFollowTargetAction",
			name = "melee_follow_powermaul",
			action_data = action_data.melee_follow_powermaul
		},
		{
			"BtMeleeAttackAction",
			name = "powermaul_melee_attack",
			action_data = action_data.powermaul_melee_attack,
			enter_hook = {
				hook = "set_scratchpad_value",
				args = {
					value = true,
					field = "is_blocking_captain_special_actions"
				}
			},
			leave_hook = {
				hook = "set_scratchpad_value",
				args = {
					value = false,
					field = "is_blocking_captain_special_actions"
				}
			}
		},
		{
			"BtMeleeAttackAction",
			name = "powermaul_melee_cleave",
			action_data = action_data.powermaul_melee_cleave,
			enter_hook = {
				hook = "set_scratchpad_value",
				args = {
					value = true,
					field = "is_blocking_captain_special_actions"
				}
			},
			leave_hook = {
				hook = "set_scratchpad_value",
				args = {
					value = false,
					field = "is_blocking_captain_special_actions"
				}
			}
		},
		{
			"BtMeleeAttackAction",
			name = "powermaul_moving_melee_cleave",
			action_data = action_data.powermaul_moving_melee_cleave,
			enter_hook = {
				hook = "set_scratchpad_value",
				args = {
					value = true,
					field = "is_blocking_captain_special_actions"
				}
			},
			leave_hook = {
				hook = "set_scratchpad_value",
				args = {
					value = false,
					field = "is_blocking_captain_special_actions"
				}
			}
		},
		{
			"BtMeleeAttackAction",
			name = "powermaul_ground_slam",
			action_data = action_data.powermaul_ground_slam,
			enter_hook = {
				hook = "set_scratchpad_value",
				args = {
					value = true,
					field = "is_blocking_captain_special_actions"
				}
			},
			leave_hook = {
				hook = "set_scratchpad_value",
				args = {
					value = false,
					field = "is_blocking_captain_special_actions"
				}
			}
		},
		{
			"BtMeleeAttackAction",
			name = "powermaul_pommel",
			action_data = action_data.powermaul_pommel,
			enter_hook = {
				hook = "set_scratchpad_value",
				args = {
					value = true,
					field = "is_blocking_captain_special_actions"
				}
			},
			leave_hook = {
				hook = "set_scratchpad_value",
				args = {
					value = false,
					field = "is_blocking_captain_special_actions"
				}
			}
		},
		name = "powermaul_melee_combat"
	},
	{
		"BtCombatIdleAction",
		name = "melee_combat_idle",
		condition = "should_use_combat_idle",
		condition_args = {
			attack_type = "melee"
		},
		action_data = action_data.melee_combat_idle
	},
	name = "powermaul_combat",
	condition = "slot_wielded",
	condition_args = {
		slot_name = "slot_powermaul"
	}
}
local CHARGE = {
	"BtChargeAction",
	name = "charge",
	action_data = action_data.charge,
	enter_hook = {
		hook = "captain_charge_enter"
	},
	leave_hook = {
		hook = "captain_charge_exit",
		args = {
			exit_anim_states = action_data.exit_anim_states
		}
	}
}
local VOID_SHIELD_EXPLOSION = {
	"BtVoidShieldExplosionAction",
	name = "void_shield_explosion",
	action_data = action_data.void_shield_explosion,
	enter_hook = {
		hook = "set_component_value",
		args = {
			value = true,
			field = "lock",
			component_name = "phase"
		}
	},
	leave_hook = {
		hook = "set_component_value",
		args = {
			value = false,
			field = "lock",
			component_name = "phase"
		}
	}
}
local FIRE_GRENADE = {
	"BtQuickGrenadeThrowAction",
	name = "throw_fire_grenade",
	action_data = action_data.throw_fire_grenade,
	enter_hook = {
		hook = "captain_grenade_enter"
	},
	leave_hook = {
		hook = "captain_grenade_exit",
		args = {
			exit_anim_states = action_data.exit_anim_states
		}
	}
}
local FRAG_GRENADE = {
	"BtQuickGrenadeThrowAction",
	name = "throw_frag_grenade",
	action_data = action_data.throw_frag_grenade,
	enter_hook = {
		hook = "captain_grenade_enter"
	},
	leave_hook = {
		hook = "captain_grenade_exit",
		args = {
			exit_anim_states = action_data.exit_anim_states
		}
	}
}
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
local PUNCH = {
	"BtMeleeAttackAction",
	name = "punch",
	condition = "is_aggroed_in_combat_range",
	action_data = action_data.punch,
	condition_args = {
		combat_ranges = {
			melee = true,
			close = true
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
		"BtSwitchWeaponAction",
		name = "switch_weapon",
		condition = "should_switch_weapon",
		action_data = action_data.switch_weapon
	},
	{
		"BtSelectorNode",
		{
			"BtRandomUtilityNode",
			KICK,
			PUNCH,
			FIRE_GRENADE,
			FRAG_GRENADE,
			CHARGE,
			VOID_SHIELD_EXPLOSION,
			condition = "captain_can_use_special_actions",
			name = "renegade_captain_specials"
		},
		POWERMAUL,
		POWER_SWORD,
		HELLGUN,
		BOLT_PISTOL,
		PLASMA_PISTOL,
		NETGUN,
		SHOTGUN,
		condition = "is_aggroed",
		name = "renegade_captain_combat"
	},
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle
	},
	name = "renegade_captain"
}

return behavior_tree
