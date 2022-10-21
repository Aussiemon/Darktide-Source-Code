local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local AggroStates = PerceptionSettings.aggro_states
local monster_pacing_template = {
	name = "renegade_monsters",
	resistance_templates = {
		{
			num_spawns = {
				witches = 0,
				monsters = {
					0,
					1
				}
			},
			breed_names = {
				monsters = {
					"chaos_plague_ogryn"
				},
				witches = {
					"chaos_daemonhost"
				}
			},
			aggro_states = {
				chaos_plague_ogryn = AggroStates.aggroed,
				chaos_beast_of_nurgle = AggroStates.aggroed
			},
			pause_pacing_on_spawn = {
				chaos_plague_ogryn = {
					hordes = 60,
					trickle_hordes = 40,
					specials = 50
				}
			},
			despawn_distance_when_passive = {
				chaos_daemonhost = 65
			}
		},
		{
			num_spawns = {
				monsters = {
					0,
					1
				},
				witches = {
					0,
					1
				}
			},
			breed_names = {
				monsters = {
					"chaos_plague_ogryn"
				},
				witches = {
					"chaos_daemonhost"
				}
			},
			aggro_states = {
				chaos_plague_ogryn = AggroStates.aggroed,
				chaos_beast_of_nurgle = AggroStates.aggroed
			},
			pause_pacing_on_spawn = {
				chaos_plague_ogryn = {
					hordes = 60,
					trickle_hordes = 30,
					specials = 30
				}
			},
			despawn_distance_when_passive = {
				chaos_daemonhost = 65
			}
		},
		{
			num_spawns = {
				monsters = {
					0,
					1
				},
				witches = {
					0,
					1
				}
			},
			breed_names = {
				monsters = {
					"chaos_plague_ogryn"
				},
				witches = {
					"chaos_daemonhost"
				}
			},
			aggro_states = {
				chaos_plague_ogryn = AggroStates.aggroed,
				chaos_beast_of_nurgle = AggroStates.aggroed
			},
			pause_pacing_on_spawn = {
				chaos_plague_ogryn = {
					hordes = 40,
					trickle_hordes = 20,
					specials = 20
				}
			},
			despawn_distance_when_passive = {
				chaos_daemonhost = 65
			}
		},
		{
			num_spawns = {
				monsters = {
					1,
					2
				},
				witches = {
					0,
					1
				}
			},
			breed_names = {
				monsters = {
					"chaos_plague_ogryn"
				},
				witches = {
					"chaos_daemonhost"
				}
			},
			aggro_states = {
				chaos_plague_ogryn = AggroStates.aggroed,
				chaos_beast_of_nurgle = AggroStates.aggroed
			},
			pause_pacing_on_spawn = {
				chaos_plague_ogryn = {
					hordes = 20,
					trickle_hordes = 15,
					specials = 15
				}
			},
			despawn_distance_when_passive = {
				chaos_daemonhost = 65
			}
		},
		{
			num_spawns = {
				monsters = 2,
				witches = {
					0,
					1
				}
			},
			breed_names = {
				monsters = {
					"chaos_plague_ogryn"
				},
				witches = {
					"chaos_daemonhost"
				}
			},
			aggro_states = {
				chaos_plague_ogryn = AggroStates.aggroed,
				chaos_beast_of_nurgle = AggroStates.aggroed
			},
			pause_pacing_on_spawn = {},
			despawn_distance_when_passive = {
				chaos_daemonhost = 65
			}
		}
	}
}

return monster_pacing_template
