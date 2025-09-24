-- chunkname: @scripts/settings/effects/minion_line_effects.lua

local line_effects = {
	renegade_twin_captain_las_pistol_lasbeam = {
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_imperial_guards",
		vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam",
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
	renegade_lasbeam = {
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby_husk",
		vfx = "content/fx/particles/enemies/lasgun_beam_enemy",
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger_enemy",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger_enemy",
			},
			interval = {
				distance = 5,
				increase = 0,
			},
		},
	},
	renegade_gunner_lasbeam = {
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby_husk",
		vfx = "content/fx/particles/enemies/lasgun_beam_enemy",
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger_enemy",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger_enemy",
			},
			interval = {
				distance = 5,
				increase = 0,
			},
		},
	},
	renegade_sniper_lasbeam = {
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby_husk",
		vfx = "content/fx/particles/enemies/renegade_sniper/renegade_sniper_beam",
		vfx_width = 5.5,
		emitters = {
			vfx = {
				default = "content/fx/particles/enemies/renegade_sniper/renegade_sniper_beam_emitter",
				start = "content/fx/particles/enemies/renegade_sniper/renegade_sniper_beam_emitter",
			},
			interval = {
				distance = 4,
				increase = 0,
			},
		},
	},
	renegade_assault_lasbeam = {
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby_husk",
		vfx = "content/fx/particles/enemies/lasgun_beam_enemy",
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger_enemy",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger_enemy",
			},
			interval = {
				distance = 5,
				increase = 0,
			},
		},
	},
	cultist_autogun_bullet = {
		sfx = "wwise/events/weapon/play_shared_combat_weapon_bullet_flyby_small_husk",
		emitters = {
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
	renegade_heavy_stubber_bullet = {
		sfx = "wwise/events/weapon/play_shared_combat_weapon_bolter_bullet_flyby_husk",
		emitters = {
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
	renegade_pellet = {
		sfx = "wwise/events/weapon/play_shared_combat_weapon_bullet_flyby_small_husk",
		vfx = "content/fx/particles/weapons/rifles/shotgun/shotgun_tracer_trail",
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
	renegade_captain_pellet = {
		sfx = "wwise/events/weapon/play_shared_combat_weapon_bullet_flyby_small_husk",
		vfx = "content/fx/particles/weapons/rifles/shotgun/shotgun_tracer_trail",
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
	renegade_captain_boltshell = {
		sfx = "wwise/events/weapon/play_shared_combat_weapon_bolter_bullet_flyby",
		vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam",
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
	renegade_captain_plasma_beam = {
		keep_aligned = true,
		sfx = "wwise/events/weapon/play_shared_combat_weapon_plasma_flyby",
		vfx = "content/fx/particles/weapons/rifles/plasma_gun/plasma_beam_orange",
		vfx_width = 0.06,
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/plasma_gun/plasma_beam_linger_orange",
				start = "content/fx/particles/weapons/rifles/plasma_gun/plasma_beam_linger_orange",
			},
			interval = {
				distance = 2.5,
				increase = 0,
			},
		},
	},
}

return line_effects
