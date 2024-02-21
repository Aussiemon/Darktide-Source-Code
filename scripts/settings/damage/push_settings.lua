local push_settings = {
	default_max_push_speed = 4,
	push_templates = {
		block_broken = {
			speed = 3.5,
			max_speed_override = 3
		},
		toughness = {
			speed = 1.5
		},
		very_light = {
			speed = 1.2
		},
		gunner_very_light = {
			speed = 0.6
		},
		gunner_light = {
			speed = 0.8
		},
		ogryn_very_light = {
			speed = 0.25
		},
		light = {
			speed = 2.5,
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
		renegade_captain_shotgun = {
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
		melee_executor_default = {
			speed = 6,
			max_speed_override = 6,
			push_through_block = true,
			ignore_stun_immunity = true
		},
		ogryn_executor_push = {
			speed = 8,
			max_speed_override = 8,
			push_through_block = true,
			ignore_stun_immunity = true
		},
		shield_push = {
			speed = 8,
			max_speed_override = 8,
			ignore_stun_immunity = true
		},
		chaos_hound_push = {
			speed = 4,
			max_speed_override = 4
		},
		chaos_ogryn_gunner_bullet = {
			speed = 2,
			max_speed_override = 2
		},
		chaos_ogryn_gunner_bullet_ogryn = {
			speed = 0.5,
			max_speed_override = 2
		},
		renegade_captain = {
			speed = 10,
			max_speed_override = 6,
			push_through_block = true,
			ignore_stun_immunity = true
		},
		renegade_captain_light = {
			speed = 6,
			max_speed_override = 4,
			push_through_block = true,
			ignore_stun_immunity = true
		},
		renegade_captain_heavy = {
			push_through_block = true,
			max_speed_override = 6,
			speed = 12,
			abort_stickyness = true,
			ignore_stun_immunity = true
		},
		daemonhost = {
			speed = 8,
			max_speed_override = 6,
			push_through_block = true,
			ignore_stun_immunity = true
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
		renegade_flamer_push = {
			speed = 5.5,
			max_speed_override = 4
		},
		shocktrooper_frag = {
			speed = 12,
			max_speed_override = 6,
			push_through_block = true
		},
		renegade_grenadier_frag = {
			speed = 8,
			max_speed_override = 6,
			push_through_block = true
		},
		chaos_hound_pounced_push = {
			speed = 10,
			max_speed_override = 8
		},
		plague_ogryn_charge = {
			speed = 12,
			max_speed_override = 9,
			push_through_block = true,
			ignore_stun_immunity = true
		},
		plague_ogryn_light = {
			speed = 5.5,
			max_speed_override = 5,
			push_through_block = true,
			ignore_stun_immunity = true
		},
		plague_ogryn_medium = {
			speed = 9,
			max_speed_override = 9,
			push_through_block = true,
			ignore_stun_immunity = true
		},
		chaos_spawn_light = {
			speed = 5.5,
			max_speed_override = 5,
			push_through_block = true
		},
		chaos_spawn_leap = {
			speed = 8,
			max_speed_override = 8,
			push_through_block = true
		},
		ranged_light = {
			speed = 1,
			max_speed_override = 2,
			dont_trigger_on_toughness = true
		},
		ranged_light_auto = {
			speed = 0.1,
			dont_trigger_on_toughness = true
		},
		ogryn_ranged_light_auto = {
			speed = 0.05,
			dont_trigger_on_toughness = true
		},
		beast_of_nurgle_move_push = {
			speed = 8,
			max_speed_override = 7,
			push_through_block = true,
			ignore_stun_immunity = true
		},
		chaos_spawn_tentacle = {
			speed = 10,
			max_speed_override = 10,
			push_through_block = {
				speed = 6,
				max_speed_override = 6
			}
		},
		chaos_spawn_combo = {
			speed = 7,
			max_speed_override = 7,
			push_through_block = true,
			ignore_stun_immunity = true
		},
		chaos_spawn_combo_heavy = {
			speed = 9,
			max_speed_override = 9,
			push_through_block = true,
			ignore_stun_immunity = true
		},
		ogryn_shovel_special = {
			speed = 3,
			max_speed_override = 4
		},
		twin_dash = {
			speed = 12,
			max_speed_override = 6,
			push_through_block = true,
			ignore_stun_immunity = true
		},
		twin_dash_light = {
			speed = 8,
			max_speed_override = 6,
			push_through_block = true,
			ignore_stun_immunity = true
		},
		twin_grenade = {
			speed = 8,
			max_speed_override = 8,
			ignore_stun_immunity = true
		},
		renegade_twin_captain_sweep = {
			speed = 10,
			max_speed_override = 6,
			push_through_block = true,
			ignore_stun_immunity = true
		},
		renegade_twin_captain_combo = {
			speed = 6,
			max_speed_override = 4,
			push_through_block = true,
			ignore_stun_immunity = true
		}
	}
}

return settings("PushSettings", push_settings)
