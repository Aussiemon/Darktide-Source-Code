local HordeCompositions = require("scripts/managers/pacing/horde_pacing/horde_compositions")
local RoamerPacks = require("scripts/settings/roamer/roamer_packs")
local mutator_templates = {
	mutator_more_specials = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			max_alive_specials_multiplier = 2,
			specials_timer_modifier = 0.25
		}
	},
	mutator_more_alive_specials = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			chance_of_coordinated_strike = 0.2,
			max_alive_specials_multiplier = {
				1,
				1,
				1.25,
				1.25,
				1.5,
				2
			}
		}
	},
	mutator_waves_of_specials = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			max_alive_specials_multiplier = 2,
			chance_of_coordinated_strike = 1,
			specials_timer_modifier = 0.85,
			max_of_same_override = {
				cultist_mutant = 6,
				chaos_hound = 4,
				renegade_grenadier = 4,
				chaos_poxwalker_bomber = 4,
				renegade_netgunner = 3,
				renegade_sniper = 5,
				renegade_flamer = 3,
				cultist_flamer = 3
			}
		}
	},
	mutator_more_hordes = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			horde_timer_modifier = 0.1,
			required_horde_travel_distance = 1
		}
	},
	mutator_more_monsters = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			monsters_per_travel_distance = 120,
			monster_spawn_type = "monsters",
			monster_breed_name = {
				"chaos_plague_ogryn"
			}
		}
	},
	mutator_more_witches = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			monster_spawn_type = "witches",
			monsters_per_travel_distance = {
				90,
				160
			},
			monster_breed_name = {
				"chaos_daemonhost"
			}
		}
	},
	mutator_more_encampments = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			encampments_override_chance = 0.3,
			num_encampments_override = 6
		}
	},
	mutator_add_resistance = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			modify_resistance = 1
		}
	},
	mutator_subtract_resistance = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			modify_resistance = -1
		}
	},
	mutator_subtract_resistance_02 = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			modify_resistance = -2
		}
	},
	mutator_darkness_los = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing"
	},
	mutator_ventilation_purge_los = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing"
	},
	mutator_travel_distance_spawning_specials = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing"
	},
	mutator_travel_distance_spawning_hordes = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing"
	},
	mutator_move_specials_timer_when_horde_active = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing"
	},
	mutator_move_specials_timer_when_monster_active = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing"
	},
	mutator_specials_required_challenge_rating = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			specials_required_challenge_rating = {
				5,
				5,
				5,
				5,
				5,
				5
			}
		}
	},
	mutator_set_min_resistance = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			set_resistance = 1
		}
	},
	mutator_set_max_resistance = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			set_resistance = 5
		}
	},
	mutator_set_min_challenge = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			set_challenge = 1
		}
	},
	mutator_set_max_challenge = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			set_challenge = 6
		}
	},
	mutator_no_encampments = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			encampments_override_chance = 0,
			num_encampments_override = 0
		}
	},
	mutator_only_none_roamer_packs = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_all_roamer_packs = {
				renegade = RoamerPacks.renegade_traitor_mix_none,
				cultist = RoamerPacks.cultist_infected_mix_none
			}
		}
	},
	mutator_low_roamer_amount = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_num_roamer_range = {
				1,
				2
			}
		}
	},
	mutator_no_hordes = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			horde_timer_modifier = 99999
		}
	},
	mutator_renegade_flamer_none_packs = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_roamer_packs = {
				none = {
					renegade = RoamerPacks.renegade_flamers_mutator,
					cultist = RoamerPacks.renegade_flamers_mutator
				}
			}
		}
	},
	mutator_only_traitor_guard_faction = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_faction = "renegade"
		}
	},
	mutator_only_cultist_faction = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_faction = "cultist"
		}
	},
	mutator_toxic_gas = {
		class = "scripts/managers/mutator/mutators/mutator_toxic_gas",
		gas_settings = {
			num_gas_clouds = 10,
			cloud_spawn_distance_range = {
				80,
				140
			}
		}
	},
	mutator_toxic_gas_volumes = {
		class = "scripts/managers/mutator/mutators/mutator_toxic_gas_volumes",
		gas_settings = {
			num_gas_clouds = 10,
			cloud_spawn_distance_range = {
				80,
				140
			}
		}
	},
	mutator_toxic_gas_twins = {
		class = "scripts/managers/mutator/mutators/mutator_toxic_gas_twins",
		gas_settings = {
			num_gas_clouds = 10,
			cloud_spawn_distance_range = {
				80,
				140
			}
		}
	},
	mutator_half_boss_health = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			monster_health_modifier = 0.5
		}
	},
	mutator_only_melee_roamers = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_roamer_packs = {
				low = {
					renegade = RoamerPacks.renegade_melee_low,
					cultist = RoamerPacks.cultist_melee_low
				},
				high = {
					renegade = RoamerPacks.renegade_melee_high,
					cultist = RoamerPacks.cultist_melee_high
				}
			}
		}
	},
	mutator_only_melee_terror_events = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			replace_terror_event_tags = {
				far = "melee",
				close = "melee"
			}
		}
	},
	mutator_only_melee_trickle_hordes = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_trickle_horde_compositions = {
				renegade = {
					none = {
						HordeCompositions.renegade_trickle_melee
					},
					low = {
						HordeCompositions.renegade_trickle_melee
					},
					high = {
						HordeCompositions.renegade_trickle_melee_elites
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
						HordeCompositions.cultist_trickle_melee
					},
					high = {
						HordeCompositions.cultist_trickle_melee_elites
					},
					poxwalkers = {
						HordeCompositions.cultist_trickle_melee
					}
				}
			}
		}
	},
	mutator_only_ranged_roamers = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_roamer_packs = {
				none = {
					renegade = RoamerPacks.renegade_far_low_no_melee_ogryns,
					cultist = RoamerPacks.cultist_far_low_no_melee_ogryns
				},
				low = {
					renegade = RoamerPacks.renegade_close_low_no_melee_ogryns,
					cultist = RoamerPacks.cultist_close_low_no_melee_ogryns
				},
				high = {
					renegade = RoamerPacks.renegade_far_high_no_melee_ogryns,
					cultist = RoamerPacks.cultist_far_high_no_melee_ogryns
				}
			}
		}
	},
	mutator_only_ranged_terror_events = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			replace_terror_event_tags = {
				horde = "roamer",
				melee = {
					"far",
					"close"
				}
			}
		}
	},
	mutator_only_ranged_trickle_hordes = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_trickle_horde_compositions = {
				renegade = {
					none = {
						HordeCompositions.renegade_trickle_riflemen
					},
					low = {
						HordeCompositions.renegade_trickle_riflemen
					},
					high = {
						HordeCompositions.renegade_trickle_riflemen_high
					},
					poxwalkers = {
						HordeCompositions.renegade_trickle_riflemen
					}
				},
				cultist = {
					none = {
						HordeCompositions.cultist_trickle_assaulters
					},
					low = {
						HordeCompositions.cultist_trickle_assaulters
					},
					high = {
						HordeCompositions.cultist_trickle_assaulters_high
					},
					poxwalkers = {
						HordeCompositions.cultist_trickle_assaulters
					}
				}
			}
		}
	},
	mutator_modify_challenge_resistance_scale_six_one = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			modify_challenge_resistance_scale = {
				{
					3,
					1
				},
				{
					4,
					1
				},
				{
					5,
					1
				},
				{
					5,
					2
				},
				{
					6,
					2
				}
			}
		},
		client_dummy_challenge = {
			3,
			4,
			5,
			5,
			6
		}
	},
	mutator_monster_specials = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			specials_monster_spawn_config = {
				max_monsters = 2,
				chance_to_spawn_monster = 0.2,
				health_modifiers = {
					chaos_beast_of_nurgle = 0.25,
					chaos_spawn = 0.25,
					chaos_plague_ogryn = 0.25
				},
				breeds = {
					"chaos_plague_ogryn",
					"chaos_beast_of_nurgle",
					"chaos_spawn"
				}
			}
		}
	}
}

return mutator_templates
