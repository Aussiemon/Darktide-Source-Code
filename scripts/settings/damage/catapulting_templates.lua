local catapulting_templates = {
	plague_ogryn_catapult = {
		force = 12,
		z_force = 6,
		direction_from_node = "j_spine"
	},
	renegade_captain_kick_catapult = {
		force = 10,
		z_force = 3,
		direction_from_node = "j_spine"
	},
	renegade_captain_charge_catapult = {
		force = 10,
		z_force = 3,
		direction_from_node = "j_spine"
	},
	renegade_captain_void_shield_explosion_catapult = {
		force = 14,
		z_force = 4,
		direction_from_node = "j_spine"
	},
	renegade_captain_frag_grenade_close_catapult = {
		force = 12,
		z_force = 4,
		direction_from_node = "j_spine"
	},
	renegade_captain_powermaul_ground_slam_catapult = {
		force = 14,
		z_force = 4,
		direction_from_node = "j_spine"
	},
	barrel_explosion = {
		force = 12,
		z_force = 6,
		direction_from_node = "j_spine",
		use_hit_position = true
	},
	twin_gas_grenade_explosion = {
		force = 7,
		z_force = 4,
		direction_from_node = "j_spine",
		use_hit_position = true
	},
	corruptor_emerge_explosion = {
		force = 12,
		z_force = 3,
		direction_from_node = "j_spine"
	},
	renegade_shocktrooper_frag_grenade_close_catapult = {
		force = 12,
		z_force = 4,
		direction_from_node = "j_spine"
	},
	poxwalker_bomber = {
		force = 11,
		z_force = 5,
		direction_from_node = "j_spine2"
	},
	poxwalker_bomber_close = {
		force = 13,
		z_force = 8,
		direction_from_node = "j_head"
	},
	breach_charge_catapult = {
		force = 8,
		z_force = 2,
		direction_from_node = "j_spine"
	}
}

return settings("CatapultingTemplates", catapulting_templates)
