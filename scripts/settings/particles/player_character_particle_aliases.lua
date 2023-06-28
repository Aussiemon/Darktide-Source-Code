local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_types = ArmorSettings.types
local particles = {
	melee_sticky_loop = {
		switch = {
			"wielded_weapon_template",
			"armor_type"
		},
		particles = {
			default = "content/fx/particles/impacts/weapons/force_sword/force_sword_stuck_looping",
			chainsword_p1_m1 = {
				default = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.unarmored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.resistant] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.player] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.berserker] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.armored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.super_armor] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[armor_types.disgustingly_resilient] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01",
				[armor_types.void_shield] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01"
			},
			chainsword_p1_m2 = {
				default = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.unarmored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.resistant] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.player] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.berserker] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.armored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.super_armor] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[armor_types.disgustingly_resilient] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01",
				[armor_types.void_shield] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01"
			},
			chainsword_p1_m3 = {
				default = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.unarmored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.resistant] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.player] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.berserker] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.armored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.super_armor] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[armor_types.disgustingly_resilient] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01",
				[armor_types.void_shield] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01"
			},
			chainsword_2h_p1_m1 = {
				default = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.unarmored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.resistant] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.player] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.berserker] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.armored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.super_armor] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[armor_types.disgustingly_resilient] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01",
				[armor_types.void_shield] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01"
			},
			chainsword_2h_p1_m2 = {
				default = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.unarmored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.resistant] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.player] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.berserker] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.armored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.super_armor] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[armor_types.disgustingly_resilient] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01",
				[armor_types.void_shield] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01"
			},
			chainsword_2h_p1_m3 = {
				default = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.unarmored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.resistant] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.player] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.berserker] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.armored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.super_armor] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[armor_types.disgustingly_resilient] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01",
				[armor_types.void_shield] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01"
			},
			chainaxe_p1_m1 = {
				default = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.unarmored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.resistant] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.player] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.berserker] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.armored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.super_armor] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[armor_types.disgustingly_resilient] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01",
				[armor_types.void_shield] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01"
			},
			chainaxe_p1_m2 = {
				default = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.unarmored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.resistant] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.player] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.berserker] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.armored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.super_armor] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[armor_types.disgustingly_resilient] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01",
				[armor_types.void_shield] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01"
			},
			chainaxe_p1_m3 = {
				default = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.unarmored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.resistant] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.player] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.berserker] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.armored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.super_armor] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[armor_types.disgustingly_resilient] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01",
				[armor_types.void_shield] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01"
			}
		}
	},
	clip_out = {
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			lasgun_p2_m3 = "content/fx/particles/weapons/rifles/lasgun/lasgun_reload",
			lasgun_p3_m2 = "content/fx/particles/weapons/rifles/lasgun/lasgun_reload",
			bot_zola_laspistol = "content/fx/particles/weapons/rifles/lasgun/lasgun_reload",
			lasgun_p2_m1 = "content/fx/particles/weapons/rifles/lasgun/lasgun_reload",
			laspistol_p1_m1 = "content/fx/particles/weapons/rifles/lasgun/lasgun_reload",
			lasgun_p1_m2 = "content/fx/particles/weapons/rifles/lasgun/lasgun_reload",
			lasgun_p3_m3 = "content/fx/particles/weapons/rifles/lasgun/lasgun_reload",
			lasgun_p3_m1 = "content/fx/particles/weapons/rifles/lasgun/lasgun_reload",
			lasgun_p2_m2 = "content/fx/particles/weapons/rifles/lasgun/lasgun_reload",
			ogryn_thumper_p1_m2 = "content/fx/particles/weapons/rifles/ogryn_thumper/ogryn_thumper_reload_smoke",
			plasmagun_p1_m1 = "content/fx/particles/weapons/rifles/plasma_gun/plasma_reload",
			lasgun_p1_m1 = "content/fx/particles/weapons/rifles/lasgun/lasgun_reload",
			lasgun_p1_m3 = "content/fx/particles/weapons/rifles/lasgun/lasgun_reload"
		}
	},
	ranged_charging = {
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			psyker_smite = "content/fx/particles/abilities/psyker_smite_chargeup_hands_01",
			forcestaff_p2_m1 = "content/fx/particles/weapons/flame_staff/psyker_flame_staff_charge",
			plasmagun_p1_m1 = "content/fx/particles/weapons/rifles/plasma_gun/plasma_gun_charge",
			lasgun_p2_m1 = "content/fx/particles/weapons/rifles/lasgun/lasgun_chargeup",
			forcestaff_p4_m1 = "content/fx/particles/weapons/bfg_staff/psyker_bfg_projectile_charge_01",
			lasgun_p2_m2 = "content/fx/particles/weapons/rifles/lasgun/lasgun_chargeup",
			forcestaff_p3_m1 = "content/fx/particles/abilities/protectorate_chainlightning_charging_hands",
			lasgun_p2_m3 = "content/fx/particles/weapons/rifles/lasgun/lasgun_chargeup"
		}
	},
	ranged_charging_done = {
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			lasgun_p2_m3 = "content/fx/particles/weapons/rifles/lasgun/lasgun_chargefull",
			lasgun_p2_m2 = "content/fx/particles/weapons/rifles/lasgun/lasgun_chargefull",
			forcestaff_p4_m1 = "content/fx/particles/weapons/bfg_staff/psyker_bfg_projectile_charge_done_01",
			lasgun_p2_m1 = "content/fx/particles/weapons/rifles/lasgun/lasgun_chargefull"
		}
	},
	psyker_biomancer_soul = {
		switch = {},
		particles = {
			default = "content/fx/particles/abilities/biomancer_soul"
		}
	},
	preacher_shield = {
		switch = {},
		particles = {
			default = "content/fx/particles/abilities/preacher/preacher_bubble_shield_3p"
		}
	},
	plasma_venting = {
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			default = "content/fx/particles/weapons/rifles/plasma_gun/plasma_vent_valve",
			plasmagun_p1_m1 = "content/fx/particles/weapons/rifles/plasma_gun/plasma_vent_valve"
		}
	},
	critical_health = {
		switch = {},
		particles = {
			default = "content/fx/particles/screenspace/toughness"
		}
	},
	psyker_smite_buildup = {
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			default = "content/fx/particles/abilities/psyker_smite_rmb_buildup"
		}
	},
	vfx_weapon_special_start = {
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			powersword_p1_m1 = "content/fx/particles/weapons/swords/powersword_1h_activate_mesh",
			thunderhammer_2h_p1_m1 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_oneoff",
			thunderhammer_2h_p1_m2 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_oneoff",
			thunderhammer_2h_p1_m3 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_oneoff",
			powersword_p1_m2 = "content/fx/particles/weapons/swords/powersword_1h_activate_mesh",
			powersword_p1_m3 = "content/fx/particles/weapons/swords/powersword_1h_activate_mesh"
		}
	},
	weapon_special_custom = {
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			powersword_p1_m1 = "content/fx/particles/weapons/swords/powersword_1h_activate_mesh",
			thunderhammer_2h_p1_m1 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_peak_discharge",
			thunderhammer_2h_p1_m2 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_peak_discharge",
			thunderhammer_2h_p1_m3 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_peak_discharge",
			powersword_p1_m2 = "content/fx/particles/weapons/swords/powersword_1h_activate_mesh",
			powersword_p1_m3 = "content/fx/particles/weapons/swords/powersword_1h_activate_mesh"
		}
	},
	weapon_special_loop = {
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			chainsword_2h_p1_m1 = "content/fx/particles/weapons/swords/chainsword/chainsword_weapon_special_activate_smoke",
			chainsword_p1_m1 = "content/fx/particles/weapons/swords/chainsword/chainsword_weapon_special_activate_smoke",
			chainaxe_p1_m3 = "content/fx/particles/weapons/swords/chainsword/chain_axe_special_weapon_activate_sparks_smoke",
			chainsword_p1_m2 = "content/fx/particles/weapons/swords/chainsword/chainsword_weapon_special_activate_smoke",
			chainsword_2h_p1_m3 = "content/fx/particles/weapons/swords/chainsword/chainsword_weapon_special_activate_smoke",
			chainaxe_p1_m2 = "content/fx/particles/weapons/swords/chainsword/chain_axe_special_weapon_activate_sparks_smoke",
			chainsword_2h_p1_m2 = "content/fx/particles/weapons/swords/chainsword/chainsword_weapon_special_activate_smoke",
			thunderhammer_2h_p1_m1 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_linger",
			powermaul_2h_p1_m1 = "content/fx/particles/weapons/power_maul/power_maul_activated_2hand",
			thunderhammer_2h_p1_m3 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_linger",
			ogryn_powermaul_p1_m1 = "content/fx/particles/weapons/power_maul/power_maul_activated",
			chainsword_p1_m3 = "content/fx/particles/weapons/swords/chainsword/chainsword_weapon_special_activate_smoke",
			thunderhammer_2h_p1_m2 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_linger",
			chainaxe_p1_m1 = "content/fx/particles/weapons/swords/chainsword/chain_axe_special_weapon_activate_sparks_smoke"
		}
	},
	weapon_overload_loop = {
		no_default = true,
		switch = {
			"wielded_weapon_template",
			"stage"
		},
		particles = {
			plasmagun_p1_m1 = {
				high = "content/fx/particles/weapons/rifles/plasma_gun/plasma_overcharge_level02",
				critical = "content/fx/particles/weapons/rifles/plasma_gun/plasma_overcharge_level03",
				low = "content/fx/particles/weapons/rifles/plasma_gun/plasma_overcharge_level01"
			},
			plasmagun_p2_m1 = {
				high = "content/fx/particles/weapons/rifles/plasma_gun/plasma_overcharge_level02",
				critical = "content/fx/particles/weapons/rifles/plasma_gun/plasma_overcharge_level03",
				low = "content/fx/particles/weapons/rifles/plasma_gun/plasma_overcharge_level01"
			}
		}
	},
	sweep_trail_extra = {
		no_default = true,
		switch = {
			"wielded_weapon_template",
			"special_active"
		},
		particles = {
			powersword_p1_m1 = {
				["true"] = "content/fx/particles/weapons/swords/powersword_p1_m1_trail"
			},
			powersword_p1_m2 = {
				["true"] = "content/fx/particles/weapons/swords/powersword_p1_m1_trail"
			},
			powersword_p1_m3 = {
				["true"] = "content/fx/particles/weapons/swords/powersword_p1_m1_trail"
			},
			thunderhammer_2h_p1_m1 = {
				["true"] = "content/fx/particles/weapons/hammers/thunder_hammer_trail"
			},
			thunderhammer_2h_p1_m2 = {
				["true"] = "content/fx/particles/weapons/hammers/thunder_hammer_trail"
			},
			thunderhammer_2h_p1_m3 = {
				["true"] = "content/fx/particles/weapons/hammers/thunder_hammer_trail"
			}
		}
	},
	equipped_item_passive = {
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			servo_skull = "content/fx/particles/interacts/servoskull_visibility_hover",
			grimoire_pocketable = "content/fx/particles/interacts/grimoire_idle",
			flamer_p1_m1 = "content/fx/particles/weapons/rifles/zealot_flamer/zealot_flamer_pilot_light"
		}
	},
	gunslinger_knife_gleam = {
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			default = "content/fx/particles/abilities/psyker_throwing_knife_equip"
		}
	},
	melee_blocked_attack = {
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			default = "content/fx/particles/weapons/swords/chainsword/impact_metal_parry_01",
			chainsword_p1_m1 = "content/fx/particles/weapons/swords/chainsword/impact_metal_parry_01",
			thunderhammer_2h_p1_m3 = "content/fx/particles/weapons/swords/chainsword/impact_metal_parry_01",
			forcesword_p1_m1 = "content/fx/particles/abilities/psyker_block_impact_01",
			chainsword_p1_m2 = "content/fx/particles/weapons/swords/chainsword/impact_metal_parry_01",
			forcesword_p1_m2 = "content/fx/particles/abilities/psyker_block_impact_01",
			forcesword_p1_m3 = "content/fx/particles/abilities/psyker_block_impact_01",
			thunderhammer_2h_p1_m1 = "content/fx/particles/weapons/swords/chainsword/impact_metal_parry_01",
			chainsword_p1_m3 = "content/fx/particles/weapons/swords/chainsword/impact_metal_parry_01",
			thunderhammer_2h_p1_m2 = "content/fx/particles/weapons/swords/chainsword/impact_metal_parry_01"
		}
	},
	ranged_blocked_attack = {
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			default = "content/fx/particles/weapons/swords/chainsword/impact_metal_parry_01",
			forcesword_p1_m2 = "content/fx/particles/abilities/psyker_block_impact_01",
			forcesword_p1_m3 = "content/fx/particles/abilities/psyker_block_impact_01",
			forcesword_p1_m1 = "content/fx/particles/abilities/psyker_block_impact_01"
		}
	},
	grimoire_smoke = {
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			default = "content/fx/particles/interacts/grimoire_idle"
		}
	},
	grimoire_throw = {
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			default = "content/fx/particles/interacts/grimoire_throw"
		}
	},
	grimoire_ogryn_throw = {
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			default = "content/fx/particles/interacts/grimoire_ogryn_throw"
		}
	},
	grimoire_discard = {
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			default = "content/fx/particles/interacts/grimoire_discard"
		}
	},
	grimoire_destroy = {
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			default = "content/fx/particles/interacts/grimoire_destroyed"
		}
	}
}

return particles
