-- chunkname: @scripts/settings/equipment/weapon_handling_templates/weapon_size_of_flame_templates.lua

local weapon_size_of_flame_templates = {
	flamer_p1_m1 = {
		range = {
			lerp_basic = 15,
			lerp_perfect = 25,
		},
		spread_angle = {
			lerp_basic = 5,
			lerp_perfect = 10,
		},
		suppression_cone_radius = {
			lerp_basic = 10,
			lerp_perfect = 20,
		},
	},
	forcestaff_p2_m1 = {
		range = {
			lerp_basic = 10,
			lerp_perfect = 17.5,
		},
		spread_angle = {
			lerp_basic = 7.5,
			lerp_perfect = 15,
		},
		suppression_cone_radius = {
			lerp_basic = 10,
			lerp_perfect = 20,
		},
	},
}

return settings("WeaponSizeOfFlameTemplates", weapon_size_of_flame_templates)
