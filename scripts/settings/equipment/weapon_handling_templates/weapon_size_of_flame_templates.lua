-- chunkname: @scripts/settings/equipment/weapon_handling_templates/weapon_size_of_flame_templates.lua

local weapon_size_of_flame_templates = {
	flamer_p1_m1 = {
		range = {
			lerp_perfect = 25,
			lerp_basic = 15
		},
		spread_angle = {
			lerp_perfect = 10,
			lerp_basic = 5
		},
		suppression_cone_radius = {
			lerp_perfect = 20,
			lerp_basic = 10
		}
	},
	forcestaff_p2_m1 = {
		range = {
			lerp_perfect = 17.5,
			lerp_basic = 10
		},
		spread_angle = {
			lerp_perfect = 15,
			lerp_basic = 7.5
		},
		suppression_cone_radius = {
			lerp_perfect = 20,
			lerp_basic = 10
		}
	}
}

return settings("WeaponSizeOfFlameTemplates", weapon_size_of_flame_templates)
