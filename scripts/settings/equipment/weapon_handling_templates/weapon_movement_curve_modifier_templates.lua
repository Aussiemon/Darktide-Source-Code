local weapon_movement_curve_modifier_templates = {
	default = {
		modifier = {
			lerp_perfect = 1,
			lerp_basic = 0.5
		}
	},
	lasgun_p1_m1 = {
		modifier = {
			lerp_perfect = 1,
			lerp_basic = 0.25
		}
	},
	lasgun_p1_m2 = {
		modifier = {
			lerp_perfect = 1.25,
			lerp_basic = 0.5
		}
	},
	chainsword_p1_m1 = {
		modifier = {
			lerp_perfect = 1.5,
			lerp_basic = 0.5
		}
	},
	combataxe_p1_m1 = {
		modifier = {
			lerp_perfect = 1.5,
			lerp_basic = 0.5
		}
	},
	forcesword_p1_m1 = {
		modifier = {
			lerp_perfect = 1.25,
			lerp_basic = 0.5
		}
	},
	thumper_p1_m2 = {
		modifier = {
			lerp_perfect = 1.25,
			lerp_basic = 0.5
		}
	},
	autopistol_p1_m1 = {
		modifier = {
			lerp_perfect = 1.5,
			lerp_basic = 0.5
		}
	},
	ogryn_club_p1_m1 = {
		modifier = {
			lerp_perfect = 1.5,
			lerp_basic = 0.5
		}
	}
}

return settings("WeaponCurveModifierTemplates", weapon_movement_curve_modifier_templates)
