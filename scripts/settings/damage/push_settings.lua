local push_settings = {
	default_max_push_speed = 4,
	push_templates = {
		toughness = {
			speed = 1.5
		},
		very_light = {
			speed = 1.2
		},
		light = {
			speed = 1,
			max_speed_override = 2
		},
		medium = {
			speed = 4,
			max_speed_override = 3
		},
		heavy = {
			speed = 5,
			max_speed_override = 3
		},
		shocktrooper_shotgun = {
			speed = 7,
			max_speed_override = 4
		},
		sniper_bullet = {
			speed = 12,
			max_speed_override = 8
		},
		grenadier_explosion = {
			speed = 4,
			max_speed_override = 4
		},
		ogryn_executor_push = {
			speed = 8,
			max_speed_override = 8,
			push_through_block = true
		},
		shield_push = {
			speed = 8,
			max_speed_override = 8
		},
		chaos_ogryn_gunner_bullet = {
			speed = 6,
			max_speed_override = 6
		},
		renegade_captain = {
			speed = 10,
			max_speed_override = 6,
			push_through_block = true
		},
		renegade_captain_light = {
			speed = 6,
			max_speed_override = 4,
			push_through_block = true
		},
		renegade_captain_heavy = {
			speed = 12,
			max_speed_override = 6,
			push_through_block = true
		},
		daemonhost = {
			speed = 8,
			max_speed_override = 6,
			push_through_block = true
		},
		daemonhost_offtarget = {
			speed = 14,
			max_speed_override = 10,
			push_through_block = true
		},
		cultist_flamer_push = {
			speed = 5.5,
			max_speed_override = 4
		},
		shocktrooper_frag = {
			speed = 12,
			max_speed_override = 6,
			push_through_block = true
		},
		chaos_hound_pounced_push = {
			speed = 10,
			max_speed_override = 8
		},
		plague_ogryn_charge = {
			speed = 14,
			max_speed_override = 8,
			push_through_block = true
		},
		plague_ogryn_light = {
			speed = 5.5,
			max_speed_override = 4,
			push_through_block = true
		},
		plague_ogryn_medium = {
			speed = 7,
			max_speed_override = 4,
			push_through_block = true
		}
	}
}

return settings("PushSettings", push_settings)
