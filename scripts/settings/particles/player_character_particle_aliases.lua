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
				[armor_types.super_armor] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.disgustingly_resilient] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01",
				[armor_types.void_shield] = "content/fx/particles/impacts/flesh/poxwalker_blood_chainsword_loop_01"
			},
			chainaxe_p1_m1 = {
				default = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.unarmored] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.resistant] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.player] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.berserker] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
				[armor_types.super_armor] = "content/fx/particles/impacts/flesh/blood_chainsword_loop_01",
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
			ogryn_thumper_p1_m2 = "content/fx/particles/weapons/rifles/ogryn_thumper/ogryn_thumper_reload_smoke",
			plasmagun_p1_m1 = "content/fx/particles/weapons/rifles/plasma_gun/plasma_reload",
			lasgun_p1_m1 = "content/fx/particles/weapons/rifles/lasgun/lasgun_reload"
		}
	},
	ranged_charging = {
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			psyker_chain_lightning = "content/fx/particles/abilities/protectorate_chainlightning_charging_hands",
			lasgun_p2_m2 = "content/fx/particles/weapons/rifles/lasgun/lasgun_bfg_charging",
			plasmagun_p1_m1 = "content/fx/particles/weapons/rifles/plasma_gun/plasma_gun_charge",
			lasgun_p2_m1 = "content/fx/particles/weapons/rifles/lasgun/lasgun_bfg_charging"
		}
	},
	psyker_biomancer_soul = {
		switch = {},
		particles = {
			default = "content/fx/particles/abilities/biomancer_soul"
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
			powersword_p1_m1 = "content/fx/particles/weapons/swords/powersword_1h_activate",
			thunderhammer_2h_p1_m1 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_oneoff"
		}
	},
	weapon_special_custom = {
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			powersword_p1_m1 = "content/fx/particles/weapons/swords/powersword_1h_activate",
			thunderhammer_2h_p1_m1 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_peak_discharge"
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
			ogryn_powermaul_p1_m1 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_linger",
			chainaxe_p1_m1 = "content/fx/particles/weapons/swords/chainsword/chainsword_weapon_special_activate_smoke",
			thunderhammer_2h_p1_m1 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_linger"
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
				true = "content/fx/particles/weapons/hammers/thunder_hammer_trail"
			},
			thunderhammer_2h_p1_m1 = {
				true = "content/fx/particles/weapons/hammers/thunder_hammer_trail"
			}
		}
	},
	equipped_item_passive = {
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		particles = {
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
			"wielded_weapon_tFchaemplate"
		},
		particles = {
			default = "content/fx/particles/weapons/swords/chainsword/impact_metal_parry_01",
			chainsword_p1_m1 = "content/fx/particles/weapons/swords/chainsword/impact_metal_parry_01",
			forcesword_p1_m1 = "content/fx/particles/abilities/psyker_block_impact_01",
			thunderhammer_2h_p1_m1 = "content/fx/particles/weapons/swords/chainsword/impact_metal_parry_01"
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
