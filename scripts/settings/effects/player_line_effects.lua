-- chunkname: @scripts/settings/effects/player_line_effects.lua

local line_effects = {
	lasbeam = {
		keep_aligned = true,
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby",
		vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam",
		vfx_crit = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_crit",
		vfx_width = 0.1,
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				},
			},
		},
	},
	lasbeam_pistol = {
		keep_aligned = true,
		link = true,
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby",
		vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam",
		vfx_crit = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_crit",
		vfx_width = 0.1,
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				},
			},
		},
	},
	lasbeam_pistol_ads = {
		keep_aligned = true,
		link = false,
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby",
		vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam",
		vfx_crit = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_crit",
		vfx_width = 0.1,
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				},
			},
		},
	},
	lasbeam_heavy_pistol = {
		keep_aligned = true,
		link = true,
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby",
		vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam",
		vfx_crit = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_crit",
		vfx_width = 0.375,
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				},
			},
			critical_strike = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				},
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/laspistol/lasgun_heavy_beam_crit_trail",
				},
			},
		},
	},
	lasbeam_killshot = {
		keep_aligned = true,
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby",
		vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam",
		vfx_crit = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_crit",
		vfx_width = 0.4,
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				},
			},
			critical_strike = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				},
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail",
				},
			},
		},
	},
	lasbeam_elysian = {
		keep_aligned = true,
		link = true,
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby",
		vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_elysian",
		vfx_crit = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_crit",
		vfx_width = 0.1,
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				},
			},
			critical_strike = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				},
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail",
				},
			},
		},
	},
	lasbeam_charged = {
		keep_aligned = true,
		link = true,
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby",
		vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_krieg_charged",
		vfx_crit = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_crit",
		vfx_width = 0.55,
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_krieg_linger",
				},
			},
			critical_strike = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_krieg_linger",
				},
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail",
				},
			},
		},
	},
	lasbeam_bfg = {
		keep_aligned = true,
		link = true,
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby",
		vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_krieg_charged",
		vfx_crit = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_crit",
		vfx_width = 0.95,
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_krieg_linger_bfg",
				},
			},
			critical_strike = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_krieg_linger_bfg",
				},
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail",
				},
			},
		},
	},
	heavy_stubpistol_bullet = {
		keep_aligned = true,
		vfx = "content/fx/particles/weapons/rifles/autogun/autogun_tracer_trail",
		vfx_crit = "content/fx/particles/weapons/rifles/autogun/autogun_tracer_trail",
		vfx_width = 0.0022,
		moving_sfx = {
			distance_offset = 2,
			duration = 0.8,
			early_stop_event_alias = "flyby_stop",
			event_alias = "flyby",
			husk_only = true,
		},
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail",
				},
			},
			critical_strike = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail",
				},
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_heavy_trail",
				},
			},
		},
	},
	autogun_bullet = {
		keep_aligned = true,
		vfx = "content/fx/particles/weapons/rifles/autogun/autogun_tracer_trail",
		vfx_crit = "content/fx/particles/weapons/rifles/autogun/autogun_tracer_trail",
		vfx_width = 0.0022,
		moving_sfx = {
			distance_offset = 2,
			duration = 0.8,
			early_stop_event_alias = "flyby_stop",
			event_alias = "flyby",
			husk_only = true,
		},
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail",
				},
			},
			critical_strike = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail",
				},
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail_3p",
				},
			},
		},
	},
	heavy_stubber_bullet = {
		keep_aligned = true,
		vfx_crit = "content/fx/particles/weapons/rifles/ogryn_heavystubber/heavystubber_tracer_trail",
		vfx_width = 0.12,
		moving_sfx = {
			distance_offset = 2,
			duration = 0.8,
			early_stop_event_alias = "flyby_stop",
			event_alias = "flyby",
			husk_only = true,
		},
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail",
				},
			},
			critical_strike = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail",
				},
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail_3p",
				},
			},
		},
	},
	pellet_trail = {
		keep_aligned = true,
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/shotgun/shotgun_trail_smoke",
				},
			},
		},
	},
	shotgun_slug_trail = {
		keep_aligned = true,
		vfx = "content/fx/particles/weapons/rifles/shotgun/shotgun_tracer_trail",
		vfx_width = 0.025,
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/shotgun/shotgun_slug_trail",
				},
			},
		},
	},
	shotgun_incendiary_trail = {
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/shotgun/shotgun_incendiary_trail_smoke",
				},
			},
		},
	},
	pellet_trail_shock = {
		keep_aligned = true,
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/shotgun/shotgun_trail_smoke",
				},
			},
		},
	},
	ripper_trail = {
		keep_aligned = true,
		vfx = "content/fx/particles/weapons/rifles/shotgun/shotgun_tracer_trail",
		vfx_width = 0.015,
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/shotgun/shotgun_trail_smoke",
				},
			},
		},
	},
	boltshell = {
		sfx = "wwise/events/weapon/play_shared_combat_weapon_bolter_bullet_flyby",
		vfx = "content/fx/particles/weapons/rifles/bolter/bolter_trail",
		vfx_width = 0.25,
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/bolter/bolter_smoke_trail",
				},
			},
		},
	},
	plasma_beam = {
		keep_aligned = true,
		sfx = "wwise/events/weapon/play_shared_combat_weapon_plasma_flyby",
		vfx = "content/fx/particles/weapons/rifles/plasma_gun/plasma_beam",
		vfx_width = 0.06,
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/plasma_gun/plasma_beam_linger",
				},
			},
		},
	},
	arc_beam = {
		keep_aligned = true,
		sfx = "wwise/events/weapon/play_shared_combat_weapon_plasma_flyby",
		vfx = "content/fx/particles/weapons/rifles/arc_rifle/arc_rifle_beam",
		vfx_width = 0.06,
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/arc_rifle/arc_rifle_beamlinger",
				},
				{
					emitter_type = "fill",
					particle_length = 1,
					vfx = "content/fx/particles/weapons/rifles/arc_rifle/arc_rifle_lightning",
				},
				{
					emitter_type = "random",
					end_offset_percentage = 9,
					start_offset_percentage = 0,
					vfx = "content/fx/particles/weapons/rifles/arc_rifle/arc_rifle_lightning",
				},
			},
		},
	},
	phosphor_beam = {
		keep_aligned = true,
		sfx = "wwise/events/weapon/play_shared_combat_weapon_plasma_flyby",
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/bolter/bolter_smoke_trail",
				},
				{
					emitter_type = "random",
					end_offset_percentage = 0.1,
					start_offset_percentage = 0,
					vfx = "content/fx/particles/weapons/pistols/phosphorpistol/phosphor_pistol_shot_trail",
				},
			},
		},
	},
	galvanic_beam = {
		keep_aligned = true,
		sfx = "wwise/events/weapon/play_shared_combat_weapon_plasma_flyby",
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/bolter/bolter_smoke_trail",
				},
				{
					emitter_type = "random",
					end_offset_percentage = 0.1,
					start_offset_percentage = 0,
					vfx = "content/fx/particles/weapons/rifles/galvanic/galvanic_rifle_shot_trail",
				},
			},
		},
	},
	needle_trail = {
		keep_aligned = true,
		vfx = "content/fx/particles/weapons/rifles/autogun/autogun_tracer_trail",
		vfx_crit = "content/fx/particles/weapons/rifles/autogun/autogun_tracer_trail",
		vfx_width = 0.0022,
		moving_sfx = {
			distance_offset = 2,
			duration = 0.8,
			early_stop_event_alias = "flyby_stop",
			event_alias = "flyby",
			husk_only = true,
		},
		emitters = {
			default = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail",
				},
			},
			critical_strike = {
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail",
				},
				{
					emitter_type = "fill",
					particle_length = 5,
					vfx = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail_3p",
				},
			},
		},
	},
}

return line_effects
