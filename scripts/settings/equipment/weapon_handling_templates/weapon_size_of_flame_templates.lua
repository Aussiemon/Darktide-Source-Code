local weapon_size_of_flame_templates = {
	flamer_p1_m1 = {
		range = {
			lerp_perfect = 25,
			lerp_basic = 18
		},
		spread_angle = {
			lerp_perfect = 15,
			lerp_basic = 10
		},
		suppression_cone_radius = {
			lerp_perfect = 25,
			lerp_basic = 15
		}
	}
}

return settings("WeaponSizeOfFlameTemplates", weapon_size_of_flame_templates)
