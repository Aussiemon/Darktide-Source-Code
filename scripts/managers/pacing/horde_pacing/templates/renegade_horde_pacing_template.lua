local HordeTemplates = require("scripts/managers/horde/horde_templates")
local HordeCompositions = require("scripts/managers/pacing/horde_pacing/horde_compositions")
local STINGER_SOUND_EVENTS = {
	renegade_large = "wwise/events/minions/play_minion_horde_poxwalker_ambush_3d",
	infected_medium = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
	infected_large = "wwise/events/minions/play_minion_horde_poxwalker_ambush_3d",
	renegade_medium = "wwise/events/minions/play_signal_horde_poxwalkers_3d"
}
local PRE_STINGER_DELAYS = {
	far_vector_horde = 7,
	ambush_horde = 7
}
local PRE_STINGER_SOUND_EVENTS = {
	renegade_large = "wwise/events/minions/play_minion_horde_poxwalker_ambush_2d",
	infected_medium = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
	infected_large = "wwise/events/minions/play_minion_horde_poxwalker_ambush_2d",
	renegade_medium = "wwise/events/minions/play_signal_horde_poxwalkers_2d"
}
local HORDE_GROUP_SOUND_EVENTS = {
	renegade_medium = {
		stop = "wwise/events/minions/stop_horde_group_sfx_poxwalkers",
		start = "wwise/events/minions/play_horde_group_sfx_poxwalkers"
	},
	infected_medium = {
		stop = "wwise/events/minions/stop_horde_group_sfx_newly_infected",
		start = "wwise/events/minions/play_horde_group_sfx_newly_infected"
	},
	renegade_large = {
		stop = "wwise/events/minions/stop_horde_group_sfx_poxwalkers",
		start = "wwise/events/minions/play_horde_group_sfx_poxwalkers"
	},
	infected_large = {
		stop = "wwise/events/minions/stop_horde_group_sfx_newly_infected",
		start = "wwise/events/minions/play_horde_group_sfx_newly_infected"
	}
}
local DEFAULT_TRICKLE_HORDE_COMPOSITIONS = {
	renegade = {
		none = {
			HordeCompositions.renegade_trickle_melee,
			HordeCompositions.renegade_trickle_riflemen
		},
		low = {
			HordeCompositions.renegade_trickle_melee,
			HordeCompositions.renegade_trickle_riflemen
		},
		high = {
			HordeCompositions.renegade_trickle_riflemen_high
		},
		poxwalkers = {
			HordeCompositions.renegade_trickle_melee
		}
	},
	cultist = {
		none = {
			HordeCompositions.cultist_trickle_melee
		},
		low = {
			HordeCompositions.cultist_trickle_assaulters,
			HordeCompositions.cultist_trickle_melee
		},
		high = {
			HordeCompositions.cultist_trickle_assaulters_high
		},
		poxwalkers = {
			HordeCompositions.cultist_trickle_melee
		}
	}
}
local HIGH_TRICKLE_HORDE_COMPOSITIONS = {
	renegade = {
		none = {
			HordeCompositions.renegade_trickle_melee,
			HordeCompositions.renegade_trickle_riflemen
		},
		low = {
			HordeCompositions.renegade_trickle_riflemen,
			HordeCompositions.renegade_trickle_assault
		},
		high = {
			HordeCompositions.renegade_trickle_riflemen_high,
			HordeCompositions.renegade_trickle_gunners,
			HordeCompositions.renegade_trickle_melee_elites
		},
		poxwalkers = {
			HordeCompositions.renegade_trickle_melee
		}
	},
	cultist = {
		none = {
			HordeCompositions.cultist_trickle_melee,
			HordeCompositions.cultist_trickle_assaulters
		},
		low = {
			HordeCompositions.cultist_trickle_melee,
			HordeCompositions.cultist_trickle_assaulters
		},
		high = {
			HordeCompositions.cultist_trickle_assaulters_high,
			HordeCompositions.cultist_trickle_gunners,
			HordeCompositions.cultist_trickle_melee_elites,
			HordeCompositions.cultist_trickle_ogryn_gunners,
			HordeCompositions.cultist_trickle_ogryn_bulwarks,
			HordeCompositions.cultist_trickle_ogryn_executors
		},
		poxwalkers = {
			HordeCompositions.cultist_trickle_melee
		}
	}
}
local horde_pacing_template = {
	name = "renegade_horde",
	resistance_templates = {
		{
			num_trickle_hordes_active_for_cooldown = 2,
			max_active_minions = 90,
			trigger_heard_dialogue = true,
			time_between_waves = 17,
			aggro_nearby_roamers_zone_range = 3,
			max_active_hordes = 3,
			max_active_minions_for_ambush = 50,
			horde_timer_range = {
				300,
				450
			},
			first_spawn_timer_modifer = {
				0.3,
				0.6
			},
			num_waves = {
				far_vector_horde = 3,
				ambush_horde = 1
			},
			travel_distance_required_for_horde = {
				170,
				210
			},
			horde_templates = {
				HordeTemplates.far_vector_horde,
				HordeTemplates.ambush_horde
			},
			horde_compositions = {
				far_vector_horde = {
					HordeCompositions.renegade_medium,
					HordeCompositions.infected_medium
				},
				ambush_horde = {
					HordeCompositions.infected_large
				},
				trickle_horde = DEFAULT_TRICKLE_HORDE_COMPOSITIONS,
				flood_horde = {
					HordeCompositions.renegade_flood
				}
			},
			stinger_sound_events = STINGER_SOUND_EVENTS,
			pre_stinger_sound_events = PRE_STINGER_SOUND_EVENTS,
			horde_group_sound_events = HORDE_GROUP_SOUND_EVENTS,
			pre_stinger_delays = PRE_STINGER_DELAYS,
			trickle_horde_travel_distance_range = {
				90,
				180
			},
			trickle_horde_cooldown = {
				40,
				45
			}
		},
		{
			num_trickle_hordes_active_for_cooldown = 3,
			max_active_minions = 90,
			trigger_heard_dialogue = true,
			time_between_waves = 15,
			aggro_nearby_roamers_zone_range = 3,
			max_active_hordes = 3,
			max_active_minions_for_ambush = 50,
			horde_timer_range = {
				260,
				420
			},
			first_spawn_timer_modifer = {
				0.3,
				0.6
			},
			num_waves = {
				far_vector_horde = 3,
				ambush_horde = 1
			},
			travel_distance_required_for_horde = {
				140,
				190
			},
			horde_templates = {
				HordeTemplates.far_vector_horde,
				HordeTemplates.ambush_horde
			},
			horde_compositions = {
				far_vector_horde = {
					HordeCompositions.renegade_medium,
					HordeCompositions.infected_medium
				},
				ambush_horde = {
					HordeCompositions.infected_large
				},
				trickle_horde = DEFAULT_TRICKLE_HORDE_COMPOSITIONS,
				flood_horde = {
					HordeCompositions.renegade_flood
				}
			},
			stinger_sound_events = STINGER_SOUND_EVENTS,
			pre_stinger_sound_events = PRE_STINGER_SOUND_EVENTS,
			horde_group_sound_events = HORDE_GROUP_SOUND_EVENTS,
			pre_stinger_delays = PRE_STINGER_DELAYS,
			trickle_horde_travel_distance_range = {
				70,
				140
			},
			trickle_horde_cooldown = {
				40,
				45
			}
		},
		{
			num_trickle_hordes_active_for_cooldown = 3,
			max_active_minions = 100,
			trigger_heard_dialogue = true,
			time_between_waves = 12,
			aggro_nearby_roamers_zone_range = 4,
			max_active_hordes = 3,
			max_active_minions_for_ambush = 60,
			horde_timer_range = {
				230,
				400
			},
			first_spawn_timer_modifer = {
				0.25,
				0.6
			},
			num_waves = {
				far_vector_horde = 3,
				ambush_horde = 1
			},
			travel_distance_required_for_horde = {
				100,
				150
			},
			horde_templates = {
				HordeTemplates.far_vector_horde,
				HordeTemplates.ambush_horde
			},
			horde_compositions = {
				far_vector_horde = {
					HordeCompositions.renegade_medium,
					HordeCompositions.infected_medium
				},
				ambush_horde = {
					HordeCompositions.infected_large
				},
				trickle_horde = DEFAULT_TRICKLE_HORDE_COMPOSITIONS,
				flood_horde = {
					HordeCompositions.renegade_flood
				}
			},
			stinger_sound_events = STINGER_SOUND_EVENTS,
			pre_stinger_sound_events = PRE_STINGER_SOUND_EVENTS,
			horde_group_sound_events = HORDE_GROUP_SOUND_EVENTS,
			pre_stinger_delays = PRE_STINGER_DELAYS,
			trickle_horde_travel_distance_range = {
				40,
				90
			},
			trickle_horde_cooldown = {
				40,
				45
			}
		},
		{
			num_trickle_hordes_active_for_cooldown = 3,
			max_active_minions = 110,
			trigger_heard_dialogue = true,
			time_between_waves = 12,
			aggro_nearby_roamers_zone_range = 5,
			max_active_hordes = 3,
			max_active_minions_for_ambush = 60,
			horde_timer_range = {
				210,
				340
			},
			first_spawn_timer_modifer = {
				0.2,
				0.6
			},
			num_waves = {
				far_vector_horde = 3,
				ambush_horde = 1
			},
			travel_distance_required_for_horde = {
				80,
				110
			},
			horde_templates = {
				HordeTemplates.far_vector_horde,
				HordeTemplates.ambush_horde
			},
			horde_compositions = {
				far_vector_horde = {
					HordeCompositions.renegade_medium,
					HordeCompositions.infected_medium
				},
				ambush_horde = {
					HordeCompositions.infected_large
				},
				trickle_horde = HIGH_TRICKLE_HORDE_COMPOSITIONS,
				flood_horde = {
					HordeCompositions.renegade_flood
				}
			},
			stinger_sound_events = STINGER_SOUND_EVENTS,
			pre_stinger_sound_events = PRE_STINGER_SOUND_EVENTS,
			horde_group_sound_events = HORDE_GROUP_SOUND_EVENTS,
			pre_stinger_delays = PRE_STINGER_DELAYS,
			trickle_horde_travel_distance_range = {
				40,
				75
			},
			trickle_horde_cooldown = {
				40,
				45
			}
		},
		{
			num_trickle_hordes_active_for_cooldown = 3,
			max_active_minions = 120,
			trigger_heard_dialogue = true,
			time_between_waves = 12,
			aggro_nearby_roamers_zone_range = 5,
			max_active_hordes = 3,
			max_active_minions_for_ambush = 70,
			horde_timer_range = {
				140,
				280
			},
			first_spawn_timer_modifer = {
				0.2,
				0.6
			},
			num_waves = {
				far_vector_horde = 3,
				ambush_horde = 1
			},
			travel_distance_required_for_horde = {
				60,
				100
			},
			horde_templates = {
				HordeTemplates.far_vector_horde,
				HordeTemplates.ambush_horde
			},
			horde_compositions = {
				far_vector_horde = {
					HordeCompositions.renegade_medium,
					HordeCompositions.infected_medium
				},
				ambush_horde = {
					HordeCompositions.infected_large
				},
				trickle_horde = HIGH_TRICKLE_HORDE_COMPOSITIONS,
				flood_horde = {
					HordeCompositions.renegade_flood
				}
			},
			stinger_sound_events = STINGER_SOUND_EVENTS,
			pre_stinger_sound_events = PRE_STINGER_SOUND_EVENTS,
			horde_group_sound_events = HORDE_GROUP_SOUND_EVENTS,
			pre_stinger_delays = PRE_STINGER_DELAYS,
			trickle_horde_travel_distance_range = {
				40,
				75
			},
			trickle_horde_cooldown = {
				40,
				45
			}
		}
	}
}

return horde_pacing_template
