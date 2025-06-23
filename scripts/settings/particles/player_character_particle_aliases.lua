-- chunkname: @scripts/settings/particles/player_character_particle_aliases.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_types = ArmorSettings.types
local hit_effect_types = ArmorSettings.hit_effect_types
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
				[armor_types.void_shield] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_void_shield_01",
				[hit_effect_types.prop_druglab_tank] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[hit_effect_types.prop_ice_chunk] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[hit_effect_types.prop_train_cogitator] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01"
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
				[armor_types.void_shield] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_void_shield_01",
				[hit_effect_types.prop_druglab_tank] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[hit_effect_types.prop_ice_chunk] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[hit_effect_types.prop_train_cogitator] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01"
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
				[armor_types.void_shield] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_void_shield_01",
				[hit_effect_types.prop_druglab_tank] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[hit_effect_types.prop_ice_chunk] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[hit_effect_types.prop_train_cogitator] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01"
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
				[armor_types.void_shield] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_void_shield_01",
				[hit_effect_types.prop_druglab_tank] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[hit_effect_types.prop_ice_chunk] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[hit_effect_types.prop_train_cogitator] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01"
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
				[armor_types.void_shield] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_void_shield_01",
				[hit_effect_types.prop_druglab_tank] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[hit_effect_types.prop_ice_chunk] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[hit_effect_types.prop_train_cogitator] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01"
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
				[armor_types.void_shield] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_void_shield_01",
				[hit_effect_types.prop_druglab_tank] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[hit_effect_types.prop_ice_chunk] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[hit_effect_types.prop_train_cogitator] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01"
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
				[armor_types.void_shield] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_void_shield_01",
				[hit_effect_types.prop_druglab_tank] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[hit_effect_types.prop_ice_chunk] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[hit_effect_types.prop_train_cogitator] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01"
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
				[armor_types.void_shield] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_void_shield_01",
				[hit_effect_types.prop_druglab_tank] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[hit_effect_types.prop_ice_chunk] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[hit_effect_types.prop_train_cogitator] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01"
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
				[armor_types.void_shield] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_void_shield_01",
				[hit_effect_types.prop_druglab_tank] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[hit_effect_types.prop_ice_chunk] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01",
				[hit_effect_types.prop_train_cogitator] = "content/fx/particles/impacts/weapons/chainsword/chainsword_grinding_sparks_loop_01"
			},
			powermaul_p1_m1 = {
				default = "content/fx/particles/enemies/buff_chainlightning"
			},
			powermaul_p1_m2 = {
				default = "content/fx/particles/enemies/buff_chainlightning"
			},
			powermaul_p2_m1 = {
				default = "content/fx/particles/enemies/buff_chainlightning"
			},
			powermaul_p2_m2 = {
				default = "content/fx/particles/enemies/buff_chainlightning"
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
			plasmagun_p1_m1 = "content/fx/particles/weapons/rifles/plasma_gun/plasma_gun_charge",
			psyker_smite = "content/fx/particles/abilities/psyker_smite_chargeup_hands_01",
			lasgun_p2_m2 = "content/fx/particles/weapons/rifles/lasgun/lasgun_chargeup",
			psyker_chain_lightning = "content/fx/particles/abilities/chainlightning_charge_loop",
			forcestaff_p2_m1 = "content/fx/particles/weapons/flame_staff/psyker_flame_staff_charge",
			lasgun_p2_m1 = "content/fx/particles/weapons/rifles/lasgun/lasgun_chargeup",
			forcestaff_p4_m1 = "content/fx/particles/weapons/bfg_staff/psyker_bfg_projectile_charge_01",
			forcestaff_p3_m1 = "content/fx/particles/weapons/force_staff/force_staff_chainlightning_charging_hands",
			lasgun_p2_m3 = "content/fx/particles/weapons/rifles/lasgun/lasgun_chargeup"
		}
	},
	ranged_charging_done = {
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			psyker_chain_lightning = "content/fx/particles/abilities/chainlightning/protectorate_chainlightning_charge_done",
			lasgun_p2_m2 = "content/fx/particles/weapons/rifles/lasgun/lasgun_chargefull",
			lasgun_p2_m1 = "content/fx/particles/weapons/rifles/lasgun/lasgun_chargefull",
			forcestaff_p4_m1 = "content/fx/particles/weapons/bfg_staff/psyker_bfg_projectile_charge_done_01",
			lasgun_p2_m3 = "content/fx/particles/weapons/rifles/lasgun/lasgun_chargefull"
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
	force_weapon_block = {
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			default = "content/fx/particles/weapons/swords/forcesword/psyker_block"
		}
	},
	psyker_hand_effects_arm_cage = {
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			psyker_chain_lightning = "content/fx/particles/abilities/chainlightning/protectorate_chainlightning_hands_charge",
			default = "content/fx/particles/abilities/chainlightning/protectorate_chainlightning_hands_charge",
			forcesword_2h_p1_m1 = "content/fx/particles/weapons/foce_sword/forcesword_2h_charge",
			forcesword_2h_p1_m2 = "content/fx/particles/weapons/foce_sword/forcesword_2h_charge"
		}
	},
	psyker_hand_effects_fingers = {
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			psyker_chain_lightning = "content/fx/particles/abilities/chainlightning/chainlightning_fingertips",
			default = "content/fx/particles/abilities/chainlightning/chainlightning_fingertips",
			forcesword_2h_p1_m1 = "content/fx/particles/weapons/foce_sword/forcesword_2h_wisps_fingerstips",
			forcesword_2h_p1_m2 = "content/fx/particles/weapons/foce_sword/forcesword_2h_wisps_fingerstips"
		}
	},
	vfx_weapon_special_start = {
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			powermaul_p1_m2 = "content/fx/particles/weapons/shock_maul/powermaul_1h_activate_mesh",
			powersword_2h_p1_m2 = "content/fx/particles/weapons/swords/powersword_2h/powersword_2h_activate_mesh",
			powersword_p1_m1 = "content/fx/particles/weapons/swords/powersword_1h_activate_mesh",
			powersword_p1_m2 = "content/fx/particles/weapons/swords/powersword_1h_activate_mesh",
			powermaul_p1_m1 = "content/fx/particles/weapons/shock_maul/powermaul_1h_activate_mesh",
			powermaul_shield_p1_m1 = "content/fx/particles/weapons/shields/arbites_shield_weapon_special_01",
			powermaul_shield_p1_m2 = "content/fx/particles/weapons/shields/arbites_shield_weapon_special_01",
			thunderhammer_2h_p1_m1 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_oneoff",
			powermaul_p2_m2 = "content/fx/particles/weapons/shock_maul/powermaul_1h_activate_mesh",
			powersword_2h_p1_m1 = "content/fx/particles/weapons/swords/powersword_2h/powersword_2h_activate_mesh",
			thunderhammer_2h_p1_m2 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_oneoff",
			powermaul_p2_m1 = "content/fx/particles/weapons/shock_maul/powermaul_1h_activate_mesh"
		}
	},
	weapon_special_end = {
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			powersword_2h_p1_m1 = "content/fx/particles/weapons/swords/powersword_2h/powersword_2h_decharge_01",
			powersword_2h_p1_m2 = "content/fx/particles/weapons/swords/powersword_2h/powersword_2h_decharge_01"
		}
	},
	weapon_special_custom = {
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			thunderhammer_2h_p1_m2 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_peak_discharge",
			thunderhammer_2h_p1_m1 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_peak_discharge"
		}
	},
	wind_slash = {
		no_default = true,
		switch = {
			"wielded_weapon_template",
			"level"
		},
		particles = {
			forcesword_2h_p1_m1 = {
				high = "content/fx/particles/weapons/foce_sword/forcesword_2h_special_high",
				middle = "content/fx/particles/weapons/foce_sword/forcesword_2h_special_middle",
				low = "content/fx/particles/weapons/foce_sword/forcesword_2h_special_low"
			},
			forcesword_2h_p1_m2 = {
				high = "content/fx/particles/weapons/foce_sword/forcesword_2h_special_high",
				middle = "content/fx/particles/weapons/foce_sword/forcesword_2h_special_middle",
				low = "content/fx/particles/weapons/foce_sword/forcesword_2h_special_low"
			}
		}
	},
	wind_slash_stage_interfacing = {
		no_default = true,
		switch = {
			"wielded_weapon_template",
			"stage"
		},
		particles = {
			forcesword_2h_p1_m1 = {
				high = "content/fx/particles/weapons/foce_sword/forcesword_2h_stage2",
				middle = "content/fx/particles/weapons/foce_sword/forcesword_2h_stage2"
			},
			forcesword_2h_p1_m2 = {
				high = "content/fx/particles/weapons/foce_sword/forcesword_2h_stage2",
				middle = "content/fx/particles/weapons/foce_sword/forcesword_2h_stage2"
			}
		}
	},
	wind_slash_stage_screen_space = {
		no_default = true,
		switch = {
			"wielded_weapon_template",
			"stage"
		},
		particles = {
			forcesword_2h_p1_m1 = {
				high = "content/fx/particles/weapons/screenspace/forcesword_2h_screenspace_stage3",
				middle = "content/fx/particles/weapons/screenspace/forcesword_2h_screenspace_stage2"
			},
			forcesword_2h_p1_m2 = {
				high = "content/fx/particles/weapons/screenspace/forcesword_2h_screenspace_stage3",
				middle = "content/fx/particles/weapons/screenspace/forcesword_2h_screenspace_stage2"
			}
		}
	},
	wind_slash_stage_loop = {
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			forcesword_2h_p1_m1 = "content/fx/particles/weapons/foce_sword/forcesword_2h_stage2_loop",
			forcesword_2h_p1_m2 = "content/fx/particles/weapons/foce_sword/forcesword_2h_stage2_loop"
		}
	},
	weapon_special_loop = {
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			powermaul_2h_p1_m1 = "content/fx/particles/weapons/power_maul/power_maul_activated_2hand",
			chainsword_2h_p1_m2 = "content/fx/particles/weapons/swords/chainsword/chainsword_weapon_special_activate_smoke",
			chainaxe_p1_m3 = "content/fx/particles/weapons/swords/chainsword/chain_axe_special_weapon_activate_sparks_smoke",
			chainsword_p1_m2 = "content/fx/particles/weapons/swords/chainsword/chainsword_weapon_special_activate_smoke",
			chainaxe_p1_m2 = "content/fx/particles/weapons/swords/chainsword/chain_axe_special_weapon_activate_sparks_smoke",
			powermaul_shield_p1_m1 = "content/fx/particles/abilities/chainlightning/protectorate_chainlightning_attack_hands_fp",
			chainsword_2h_p1_m3 = "content/fx/particles/weapons/swords/chainsword/chainsword_weapon_special_activate_smoke",
			thunderhammer_2h_p1_m1 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_linger",
			powermaul_p2_m2 = "content/fx/particles/weapons/power_maul/power_maul_p2_weapon_special_01",
			powersword_p1_m1 = "content/fx/particles/weapons/swords/powersword_1h_activate_mesh_loop",
			chainsword_p1_m1 = "content/fx/particles/weapons/swords/chainsword/chainsword_weapon_special_activate_smoke",
			ogryn_powermaul_p1_m1 = "content/fx/particles/weapons/power_maul/power_maul_activated",
			thunderhammer_2h_p1_m2 = "content/fx/particles/weapons/hammers/thunder_hammer_activate_linger",
			chainaxe_p1_m1 = "content/fx/particles/weapons/swords/chainsword/chain_axe_special_weapon_activate_sparks_smoke",
			chainsword_2h_p1_m1 = "content/fx/particles/weapons/swords/chainsword/chainsword_weapon_special_activate_smoke",
			powersword_2h_p1_m2 = "content/fx/particles/weapons/swords/powersword_2h/powersword_2h_activate_mesh_loop",
			powersword_p1_m2 = "content/fx/particles/weapons/swords/powersword_1h_activate_mesh_loop",
			powermaul_shield_p1_m2 = "content/fx/particles/abilities/chainlightning/protectorate_chainlightning_attack_hands_fp",
			powersword_2h_p1_m1 = "content/fx/particles/weapons/swords/powersword_2h/powersword_2h_activate_mesh_loop",
			chainsword_p1_m3 = "content/fx/particles/weapons/swords/chainsword/chainsword_weapon_special_activate_smoke",
			powermaul_p2_m1 = "content/fx/particles/weapons/power_maul/power_maul_p2_weapon_special_01"
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
			powersword_2h_p1_m1 = {
				high = "content/fx/particles/weapons/swords/powersword_2h/powersword_2h_overload_01",
				critical = "content/fx/particles/weapons/swords/powersword_2h/powersword_2h_overload_critical_01"
			},
			powersword_2h_p1_m2 = {
				high = "content/fx/particles/weapons/swords/powersword_2h/powersword_2h_overload_01",
				critical = "content/fx/particles/weapons/swords/powersword_2h/powersword_2h_overload_critical_01"
			}
		}
	},
	chain_lightning_hand = {
		switch = {
			"wielded_weapon_template",
			"power"
		},
		particles = {
			default = "content/fx/particles/weapons/force_staff/force_staff_chainlightning_attacking_hands",
			forcestaff_p3_m1 = "content/fx/particles/weapons/force_staff/force_staff_chainlightning_attacking_hands"
		}
	},
	chain_lightning_to_target = {
		switch = {
			"wielded_weapon_template",
			"power"
		},
		particles = {
			default = "content/fx/particles/abilities/chainlightning/protectorate_chainlightning_attack_hands_fp",
			psyker_chain_lightning = "content/fx/particles/abilities/chainlightning/protectorate_chainlightning_attack_hands_fp"
		}
	},
	chain_lightning_link = {
		switch = {
			"wielded_weapon_template",
			"power"
		},
		particles = {
			default = "content/fx/particles/weapons/force_staff/force_staff_chainlightning_attacking_link_03",
			forcestaff_p3_m1 = {
				no_target = "content/fx/particles/weapons/force_staff/force_staff_chainlightning_attacking_link_01",
				mid = "content/fx/particles/weapons/force_staff/force_staff_chainlightning_attacking_link_02",
				low = "content/fx/particles/weapons/force_staff/force_staff_chainlightning_attacking_link_01",
				high = "content/fx/particles/weapons/force_staff/force_staff_chainlightning_attacking_link_03"
			},
			psyker_chain_lightning = {
				no_target = "content/fx/particles/abilities/chainlightning/protectorate_chainlightning_attack_looping_no_target",
				high = "content/fx/particles/abilities/chainlightning/protectorate_chainlightning_bfg_01",
				low = "content/fx/particles/abilities/chainlightning/protectorate_chainlightning_attack_looping_01"
			}
		}
	},
	chain_lightning_impact = {
		no_default = true,
		switch = {
			"wielded_weapon_template",
			"power"
		},
		particles = {
			forcestaff_p3_m1 = "content/fx/particles/weapons/force_staff/force_staff_chainlightning_impact_looping",
			psyker_chain_lightning = "content/fx/particles/abilities/chainlightning/protectorate_chainlightning_impact_looping"
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
			powersword_2h_p1_m1 = {
				["true"] = "content/fx/particles/weapons/swords/powersword_p1_m1_trail"
			},
			powersword_2h_p1_m2 = {
				["true"] = "content/fx/particles/weapons/swords/powersword_p1_m1_trail"
			},
			thunderhammer_2h_p1_m1 = {
				["true"] = "content/fx/particles/weapons/hammers/thunder_hammer_trail"
			},
			thunderhammer_2h_p1_m2 = {
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
			zealot_relic = "content/fx/particles/abilities/zealot_relic_emit_01",
			servo_skull = "content/fx/particles/interacts/servoskull_visibility_hover",
			syringe_ability_boost_pocketable = "content/fx/particles/pocketables/syringe_ability_boost_bubbles",
			flamer_p1_m1 = "content/fx/particles/weapons/rifles/zealot_flamer/zealot_flamer_pilot_light",
			powermaul_p1_m1 = "content/fx/particles/weapons/shock_maul/powermaul_1h_looping_mesh",
			powermaul_shield_p1_m1 = "content/fx/particles/weapons/shock_maul/powermaul_1h_looping_mesh",
			powermaul_shield_p1_m2 = "content/fx/particles/weapons/shock_maul/powermaul_1h_looping_mesh",
			syringe_power_boost_pocketable = "content/fx/particles/pocketables/syringe_power_boost_bubbles",
			powermaul_p2_m2 = "content/fx/particles/weapons/shock_maul/powermaul_1h_looping_mesh",
			syringe_speed_boost_pocketable = "content/fx/particles/pocketables/syringe_speed_boost_bubbles",
			syringe_corruption_pocketable = "content/fx/particles/pocketables/syringe_corruption_heal_bubbles",
			psyker_throwing_knives = "content/fx/particles/abilities/psyker_throwing_knife_idle",
			powermaul_p2_m1 = "content/fx/particles/weapons/shock_maul/powermaul_1h_looping_mesh",
			grimoire_pocketable = "content/fx/particles/interacts/grimoire_idle",
			powermaul_p1_m2 = "content/fx/particles/weapons/shock_maul/powermaul_1h_looping_mesh"
		}
	},
	conditional_equipped_item_passive = {
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			powermaul_shield_p1_m2 = "content/fx/particles/weapons/shields/arbites_shield_chargeup_lightnings_01",
			powermaul_shield_p1_m1 = "content/fx/particles/weapons/shields/arbites_shield_chargeup_lightnings_01"
		}
	},
	melee_blocked_attack = {
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			default = "content/fx/particles/weapons/swords/chainsword/impact_metal_parry_01",
			chainsword_p1_m1 = "content/fx/particles/weapons/swords/chainsword/impact_metal_parry_01",
			forcesword_2h_p1_m1 = "content/fx/particles/abilities/psyker_block_impact_01",
			chainsword_p1_m2 = "content/fx/particles/weapons/swords/chainsword/impact_metal_parry_01",
			thunderhammer_2h_p1_m2 = "content/fx/particles/weapons/swords/chainsword/impact_metal_parry_01",
			forcesword_p1_m3 = "content/fx/particles/abilities/psyker_block_impact_01",
			forcesword_p1_m1 = "content/fx/particles/abilities/psyker_block_impact_01",
			thunderhammer_2h_p1_m1 = "content/fx/particles/weapons/swords/chainsword/impact_metal_parry_01",
			forcesword_2h_p1_m2 = "content/fx/particles/abilities/psyker_block_impact_01",
			chainsword_p1_m3 = "content/fx/particles/weapons/swords/chainsword/impact_metal_parry_01",
			forcesword_p1_m2 = "content/fx/particles/abilities/psyker_block_impact_01"
		}
	},
	ranged_blocked_attack = {
		switch = {
			"wielded_weapon_template"
		},
		particles = {
			default = "content/fx/particles/weapons/swords/chainsword/impact_metal_parry_01",
			forcesword_2h_p1_m2 = "content/fx/particles/abilities/psyker_block_impact_01",
			forcesword_2h_p1_m1 = "content/fx/particles/abilities/psyker_block_impact_01",
			forcesword_p1_m1 = "content/fx/particles/abilities/psyker_block_impact_01",
			forcesword_p1_m2 = "content/fx/particles/abilities/psyker_block_impact_01",
			forcesword_p1_m3 = "content/fx/particles/abilities/psyker_block_impact_01"
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
