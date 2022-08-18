local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local AggroStates = PerceptionSettings.aggro_states
local monster_pacing_template = {
	name = "renegade_monsters",
	resistance_templates = {
		{
			num_spawns = 1,
			breed_names = {
				monsters = {
					"chaos_plague_ogryn"
				},
				witches = {
					"chaos_daemonhost"
				}
			},
			aggro_states = {
				chaos_plague_ogryn = AggroStates.aggroed
			},
			pause_pacing_on_spawn = {
				chaos_plague_ogryn = {
					hordes = 60,
					trickle_hordes = 40,
					specials = 60
				}
			}
		},
		{
			num_spawns = 1,
			breed_names = {
				monsters = {
					"chaos_plague_ogryn"
				},
				witches = {
					"chaos_daemonhost"
				}
			},
			aggro_states = {
				chaos_plague_ogryn = AggroStates.aggroed
			},
			pause_pacing_on_spawn = {
				chaos_plague_ogryn = {
					hordes = 60,
					trickle_hordes = 30,
					specials = 30
				}
			}
		},
		{
			num_spawns = 1,
			breed_names = {
				monsters = {
					"chaos_plague_ogryn"
				},
				witches = {
					"chaos_daemonhost"
				}
			},
			aggro_states = {
				chaos_plague_ogryn = AggroStates.aggroed
			},
			pause_pacing_on_spawn = {
				chaos_plague_ogryn = {
					hordes = 40,
					trickle_hordes = 20,
					specials = 20
				}
			}
		},
		{
			num_spawns = 2,
			breed_names = {
				monsters = {
					"chaos_plague_ogryn"
				},
				witches = {
					"chaos_daemonhost"
				}
			},
			aggro_states = {
				chaos_plague_ogryn = AggroStates.aggroed
			},
			pause_pacing_on_spawn = {
				chaos_plague_ogryn = {
					hordes = 20,
					trickle_hordes = 15,
					specials = 15
				}
			}
		},
		{
			num_spawns = 2,
			breed_names = {
				monsters = {
					"chaos_plague_ogryn"
				},
				witches = {
					"chaos_daemonhost"
				}
			},
			aggro_states = {
				chaos_plague_ogryn = AggroStates.aggroed
			},
			pause_pacing_on_spawn = {}
		}
	}
}

return monster_pacing_template
