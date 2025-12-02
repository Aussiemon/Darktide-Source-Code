-- chunkname: @scripts/settings/effects/player_line_effects.lua

local line_effects = {
	lasbeam = {
		keep_aligned = true,
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby",
		vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam",
		vfx_crit = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_crit",
		vfx_width = 0.1,
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
			},
			interval = {
				distance = 5,
				increase = 0,
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
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
			},
			interval = {
				distance = 5,
				increase = 0,
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
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
			},
			interval = {
				distance = 5,
				increase = 0,
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
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
			},
			interval = {
				distance = 5,
				increase = 0,
			},
		},
		emitters_crit = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/laspistol/lasgun_heavy_beam_crit_trail",
				start = "content/fx/particles/weapons/rifles/laspistol/lasgun_heavy_beam_crit_trail",
			},
			interval = {
				distance = 5,
				increase = 0,
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
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
			},
			interval = {
				distance = 5,
				increase = 0,
			},
		},
		emitters_crit = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail",
			},
			interval = {
				distance = 5,
				increase = 0,
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
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
			},
			interval = {
				distance = 5,
				increase = 0,
			},
		},
		emitters_crit = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail",
			},
			interval = {
				distance = 5,
				increase = 0,
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
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_krieg_linger",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_krieg_linger",
			},
			interval = {
				distance = 4.5,
				increase = 0,
			},
		},
		emitters_crit = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail",
			},
			interval = {
				distance = 5,
				increase = 0,
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
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_krieg_linger_bfg",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_krieg_linger_bfg",
			},
			interval = {
				distance = 4.5,
				increase = 0,
			},
		},
		emitters_crit = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail",
			},
			interval = {
				distance = 5,
				increase = 0,
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
			vfx = {
				default = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail",
				start = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail",
			},
			interval = {
				distance = 5,
				increase = 0,
			},
		},
		emitters_crit = {
			vfx = {
				default = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_heavy_trail",
				start = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_heavy_trail",
			},
			interval = {
				distance = 5,
				increase = 0,
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
			vfx = {
				default = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail",
				start = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail",
			},
			interval = {
				distance = 5,
				increase = 0,
			},
		},
		emitters_crit = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail_3p",
				start = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail_3p",
			},
			interval = {
				distance = 5,
				increase = 0,
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
			vfx = {
				default = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail",
				start = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail",
			},
			interval = {
				distance = 5,
				increase = 0,
			},
		},
		emitters_crit = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail_3p",
				start = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail_3p",
			},
			interval = {
				distance = 5,
				increase = 0,
			},
		},
	},
	pellet_trail = {
		keep_aligned = true,
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/shotgun/shotgun_trail_smoke",
				start = "content/fx/particles/weapons/rifles/shotgun/shotgun_trail_smoke",
			},
			interval = {
				distance = 5,
				increase = 0,
			},
		},
	},
	shotgun_slug_trail = {
		keep_aligned = true,
		vfx = "content/fx/particles/weapons/rifles/shotgun/shotgun_tracer_trail",
		vfx_width = 0.025,
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/shotgun/shotgun_slug_trail",
				start = "content/fx/particles/weapons/rifles/shotgun/shotgun_slug_trail",
			},
			interval = {
				distance = 5,
				increase = 0,
			},
		},
	},
	shotgun_incendiary_trail = {
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/shotgun/shotgun_incendiary_trail_smoke",
				start = "content/fx/particles/weapons/rifles/shotgun/shotgun_incendiary_trail_smoke",
			},
			interval = {
				distance = 5,
				increase = 0,
			},
		},
	},
	pellet_trail_shock = {
		keep_aligned = true,
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/shotgun/shotgun_trail_smoke",
				start = "content/fx/particles/weapons/rifles/shotgun/shotgun_trail_smoke",
			},
			interval = {
				distance = 5,
				increase = 0,
			},
		},
	},
	ripper_trail = {
		keep_aligned = true,
		vfx = "content/fx/particles/weapons/rifles/shotgun/shotgun_tracer_trail",
		vfx_width = 0.015,
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/shotgun/shotgun_trail_smoke",
				start = "content/fx/particles/weapons/rifles/shotgun/shotgun_trail_smoke",
			},
			interval = {
				distance = 5,
				increase = 0,
			},
		},
	},
	boltshell = {
		sfx = "wwise/events/weapon/play_shared_combat_weapon_bolter_bullet_flyby",
		vfx = "content/fx/particles/weapons/rifles/bolter/bolter_trail",
		vfx_width = 0.25,
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/bolter/bolter_smoke_trail",
				start = "content/fx/particles/weapons/rifles/bolter/bolter_smoke_trail",
			},
			interval = {
				distance = 1,
				increase = 0,
			},
		},
	},
	plasma_beam = {
		keep_aligned = true,
		sfx = "wwise/events/weapon/play_shared_combat_weapon_plasma_flyby",
		vfx = "content/fx/particles/weapons/rifles/plasma_gun/plasma_beam",
		vfx_width = 0.06,
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/plasma_gun/plasma_beam_linger",
				start = "content/fx/particles/weapons/rifles/plasma_gun/plasma_beam_linger",
			},
			interval = {
				distance = 5,
				increase = 0,
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
			vfx = {
				default = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail",
				start = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail",
			},
			interval = {
				distance = 5,
				increase = 0,
			},
		},
		emitters_crit = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail_3p",
				start = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail_3p",
			},
			interval = {
				distance = 5,
				increase = 0,
			},
		},
	},
}

return line_effects
