local line_effects = {
	lasbeam = {
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby",
		vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam",
		vfx_width = 0.1,
		keep_aligned = true,
		vfx_crit = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_crit",
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger"
			},
			interval = {
				distance = 5,
				increase = 0
			}
		}
	},
	lasbeam_pistol = {
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby",
		vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam",
		vfx_width = 0.1,
		keep_aligned = true,
		vfx_crit = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_crit",
		link = true,
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger"
			},
			interval = {
				distance = 5,
				increase = 0
			}
		}
	},
	lasbeam_pistol_ads = {
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby",
		vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam",
		vfx_width = 0.1,
		keep_aligned = true,
		vfx_crit = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_crit",
		link = false,
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger"
			},
			interval = {
				distance = 5,
				increase = 0
			}
		}
	},
	lasbeam_killshot = {
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby",
		vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam",
		vfx_width = 0.4,
		keep_aligned = true,
		vfx_crit = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_crit",
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger"
			},
			interval = {
				distance = 5,
				increase = 0
			}
		},
		emitters_crit = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail"
			},
			interval = {
				distance = 5,
				increase = 0
			}
		}
	},
	lasbeam_elysian = {
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby",
		vfx_crit = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_crit",
		vfx_width = 0.1,
		keep_aligned = true,
		vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_elysian",
		link = true,
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_standard_linger"
			},
			interval = {
				distance = 5,
				increase = 0
			}
		},
		emitters_crit = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail"
			},
			interval = {
				distance = 5,
				increase = 0
			}
		}
	},
	lasbeam_charged = {
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby",
		vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_krieg_charged",
		vfx_width = 0.55,
		keep_aligned = true,
		vfx_crit = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_crit",
		link = true,
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_krieg_linger",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_krieg_linger"
			},
			interval = {
				distance = 4.5,
				increase = 0
			}
		},
		emitters_crit = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail"
			},
			interval = {
				distance = 5,
				increase = 0
			}
		}
	},
	lasbeam_bfg = {
		sfx = "wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby",
		vfx = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_krieg_charged",
		vfx_width = 0.95,
		keep_aligned = true,
		vfx_crit = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_crit",
		link = true,
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_krieg_linger_bfg",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_beam_krieg_linger_bfg"
			},
			interval = {
				distance = 4.5,
				increase = 0
			}
		},
		emitters_crit = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail",
				start = "content/fx/particles/weapons/rifles/lasgun/lasgun_crit_trail"
			},
			interval = {
				distance = 5,
				increase = 0
			}
		}
	},
	autogun_bullet = {
		vfx = "content/fx/particles/weapons/rifles/autogun/autogun_tracer_trail",
		vfx_width = 0.0022,
		keep_aligned = true,
		vfx_crit = "content/fx/particles/weapons/rifles/autogun/autogun_tracer_trail",
		moving_sfx = {
			distance_offset = 2,
			duration = 0.8,
			early_stop_event_alias = "flyby_stop",
			event_alias = "flyby"
		},
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail",
				start = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail"
			},
			interval = {
				distance = 5,
				increase = 0
			}
		},
		emitters_crit = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail_3p",
				start = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail_3p"
			},
			interval = {
				distance = 5,
				increase = 0
			}
		}
	},
	heavy_stubber_bullet = {
		vfx_width = 0.12,
		vfx_crit = "content/fx/particles/weapons/rifles/ogryn_heavystubber/heavystubber_tracer_trail",
		keep_aligned = true,
		moving_sfx = {
			distance_offset = 2,
			duration = 0.8,
			early_stop_event_alias = "flyby_stop",
			event_alias = "flyby"
		},
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail",
				start = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail"
			},
			interval = {
				distance = 5,
				increase = 0
			}
		},
		emitters_crit = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail_3p",
				start = "content/fx/particles/weapons/rifles/autogun/autogun_smoke_trail_3p"
			},
			interval = {
				distance = 5,
				increase = 0
			}
		}
	},
	pellet_trail = {
		keep_aligned = true,
		vfx = "content/fx/particles/weapons/rifles/shotgun/shotgun_tracer_trail",
		vfx_width = 0.025,
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/shotgun/shotgun_trail_smoke",
				start = "content/fx/particles/weapons/rifles/shotgun/shotgun_trail_smoke"
			},
			interval = {
				distance = 5,
				increase = 0
			}
		}
	},
	shotgun_slug_trail = {
		keep_aligned = true,
		vfx = "content/fx/particles/weapons/rifles/shotgun/shotgun_tracer_trail",
		vfx_width = 0.025,
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/shotgun/shotgun_trail_smoke",
				start = "content/fx/particles/weapons/rifles/shotgun/shotgun_trail_smoke"
			},
			interval = {
				distance = 5,
				increase = 0
			}
		}
	},
	shotgun_incendiary_trail = {
		keep_aligned = true,
		vfx = "content/fx/particles/weapons/rifles/shotgun/shotgun_incendiary_projectile",
		vfx_width = 0.025,
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/shotgun/shotgun_trail_smoke",
				start = "content/fx/particles/weapons/rifles/shotgun/shotgun_trail_smoke"
			},
			interval = {
				distance = 5,
				increase = 0
			}
		}
	},
	ripper_trail = {
		keep_aligned = true,
		vfx = "content/fx/particles/weapons/rifles/shotgun/shotgun_tracer_trail",
		vfx_width = 0.015,
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/shotgun/shotgun_trail_smoke",
				start = "content/fx/particles/weapons/rifles/shotgun/shotgun_trail_smoke"
			},
			interval = {
				distance = 5,
				increase = 0
			}
		}
	},
	boltshell = {
		sfx = "wwise/events/weapon/play_shared_combat_weapon_bolter_bullet_flyby",
		vfx = "content/fx/particles/weapons/rifles/bolter/bolter_trail",
		vfx_width = 0.25,
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/bolter/bolter_smoke_trail",
				start = "content/fx/particles/weapons/rifles/bolter/bolter_smoke_trail"
			},
			interval = {
				distance = 1,
				increase = 0
			}
		}
	},
	plasma_beam = {
		sfx = "wwise/events/weapon/play_shared_combat_weapon_plasma_flyby",
		vfx_width = 0.06,
		keep_aligned = true,
		vfx = "content/fx/particles/weapons/rifles/plasma_gun/plasma_beam",
		emitters = {
			vfx = {
				default = "content/fx/particles/weapons/rifles/plasma_gun/plasma_beam_linger",
				start = "content/fx/particles/weapons/rifles/plasma_gun/plasma_beam_linger"
			},
			interval = {
				distance = 5,
				increase = 0
			}
		}
	}
}

return line_effects
