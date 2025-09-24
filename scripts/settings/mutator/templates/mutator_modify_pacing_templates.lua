-- chunkname: @scripts/settings/mutator/templates/mutator_modify_pacing_templates.lua

local HordeCompositions = require("scripts/managers/pacing/horde_pacing/horde_compositions")
local RoamerPacks = require("scripts/settings/roamer/roamer_packs")
local mutator_templates = {
	mutator_more_specials = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			max_alive_specials_multiplier = 2,
			specials_timer_modifier = 0.25,
		},
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
				2,
			},
		},
	},
	mutator_waves_of_specials = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			chance_of_coordinated_strike = 1,
			max_alive_specials_multiplier = 1.6,
			specials_move_timer_when_challenge_rating_above = 12,
			specials_timer_modifier = 0.75,
			max_of_same_override = {
				chaos_hound = 4,
				chaos_poxwalker_bomber = 4,
				cultist_flamer = 3,
				cultist_mutant = 6,
				renegade_flamer = 3,
				renegade_grenadier = 4,
				renegade_netgunner = 3,
				renegade_sniper = 5,
			},
		},
	},
	mutator_more_hordes = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			horde_timer_modifier = 0.1,
			required_horde_travel_distance = 1,
		},
	},
	mutator_more_hordes_02 = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			horde_timer_modifier = 0.75,
			required_horde_travel_distance = 20,
		},
	},
	mutator_more_monsters = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			monster_spawn_type = "monsters",
			monsters_per_travel_distance = 120,
			monster_breed_name = {
				"chaos_plague_ogryn",
			},
		},
	},
	mutator_more_witches = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			monster_spawn_type = "witches",
			monsters_per_travel_distance = {
				90,
				160,
			},
			monster_breed_name = {
				"chaos_daemonhost",
			},
		},
	},
	mutator_more_captains = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			monster_spawn_type = "captains",
			monsters_per_travel_distance = {
				120,
				240,
			},
			monster_breed_name = {
				"renegade_captain",
			},
		},
	},
	mutator_live_abhuman_monster = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			monster_spawn_type = "monsters",
			monsters_per_travel_distance = {
				90,
				160,
			},
			monster_breed_name = {
				"chaos_plague_ogryn",
			},
		},
	},
	mutator_live_abhuman_replacement = {
		class = "scripts/managers/mutator/mutators/mutator_replace_breed",
		init_replacement_breed = {
			breed_replacement = {
				renegade_berzerker = "chaos_ogryn_bulwark",
				renegade_executor = "chaos_ogryn_executor",
				renegade_gunner = "chaos_ogryn_gunner",
			},
		},
	},
	havoc_mutator_more_captains_01 = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			monster_spawn_type = "captains",
			monsters_per_travel_distance = {
				240,
				360,
			},
			monster_breed_name = {
				"MUTATOR_CAPTAIN",
			},
		},
	},
	havoc_mutator_more_captains_02 = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			monster_spawn_type = "captains",
			monsters_per_travel_distance = {
				120,
				240,
			},
			monster_breed_name = {
				"MUTATOR_CAPTAIN",
			},
		},
	},
	havoc_mutator_more_hordes_01 = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			required_horde_travel_distance = 60,
		},
	},
	havoc_mutator_more_hordes_02 = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			required_horde_travel_distance = 30,
		},
	},
	havoc_mutator_monster_specials_01 = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			specials_monster_spawn_config = {
				chance_to_spawn_monster = 0.05,
				max_monsters = 1,
				health_modifiers = {
					chaos_beast_of_nurgle = 0.4,
					chaos_plague_ogryn = 0.4,
					chaos_spawn = 0.4,
				},
				max_monster_duration = {
					550,
					600,
				},
				breeds = {
					"chaos_plague_ogryn",
					"chaos_beast_of_nurgle",
					"chaos_spawn",
				},
			},
		},
	},
	havoc_mutator_monster_specials_02 = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			specials_monster_spawn_config = {
				chance_to_spawn_monster = 0.1,
				max_monsters = 1,
				health_modifiers = {
					chaos_beast_of_nurgle = 0.4,
					chaos_plague_ogryn = 0.4,
					chaos_spawn = 0.4,
				},
				max_monster_duration = {
					450,
					500,
				},
				breeds = {
					"chaos_plague_ogryn",
					"chaos_beast_of_nurgle",
					"chaos_spawn",
				},
			},
		},
	},
	mutator_decreased_horde_pacing_stinger = {
		class = "scripts/managers/mutator/mutators/mutator_base",
	},
	mutator_more_boss_patrols = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			boss_patrols_per_travel_distance = {
				60,
				120,
			},
		},
	},
	mutator_more_encampments = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			encampments_override_chance = 0.3,
			num_encampments_override = 6,
		},
	},
	mutator_add_resistance = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			modify_resistance = 1,
		},
	},
	mutator_add_challenge = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			modify_challenge = 1,
		},
	},
	mutator_subtract_resistance = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			modify_resistance = -1,
		},
	},
	mutator_subtract_resistance_02 = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			modify_resistance = -2,
		},
	},
	mutator_travel_distance_spawning_specials = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
	},
	mutator_travel_distance_spawning_hordes = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
	},
	mutator_move_specials_timer_when_horde_active = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
	},
	mutator_move_specials_timer_when_monster_active = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
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
				5,
			},
		},
	},
	mutator_set_min_resistance = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			set_resistance = 1,
		},
	},
	mutator_set_max_resistance = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			set_resistance = 5,
		},
	},
	mutator_set_min_challenge = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			set_challenge = 1,
		},
	},
	mutator_set_max_challenge = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			set_challenge = 6,
		},
	},
	mutator_no_encampments = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			encampments_override_chance = 0,
			num_encampments_override = 0,
		},
	},
	mutator_only_none_roamer_packs = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_all_roamer_packs = {
				renegade = RoamerPacks.renegade_traitor_mix_none,
				cultist = RoamerPacks.cultist_infected_mix_none,
			},
		},
	},
	mutator_low_roamer_amount = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_num_roamer_range = {
				1,
				2,
			},
		},
	},
	mutator_no_hordes = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			horde_timer_modifier = 99999,
		},
	},
	mutator_renegade_flamer_none_packs = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_roamer_packs = {
				none = {
					renegade = RoamerPacks.renegade_flamers_mutator,
					cultist = RoamerPacks.renegade_flamers_mutator,
				},
			},
		},
	},
	mutator_only_traitor_guard_faction = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_faction = "renegade",
		},
	},
	mutator_only_cultist_faction = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_faction = "cultist",
		},
	},
	mutator_toxic_gas = {
		class = "scripts/managers/mutator/mutators/mutator_toxic_gas",
		gas_settings = {
			num_gas_clouds = 10,
			cloud_spawn_distance_range = {
				80,
				140,
			},
		},
	},
	mutator_toxic_gas_volumes = {
		class = "scripts/managers/mutator/mutators/mutator_toxic_gas_volumes",
		theme_settings = {
			theme_tag = "toxic_gas",
		},
		gas_settings = {
			num_gas_clouds = 10,
			cloud_spawn_distance_range = {
				80,
				140,
			},
		},
	},
	mutator_toxic_gas_twins = {
		class = "scripts/managers/mutator/mutators/mutator_toxic_gas_twins",
		gas_settings = {
			num_gas_clouds = 10,
			cloud_spawn_distance_range = {
				80,
				140,
			},
		},
	},
	mutator_half_boss_health = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			monster_health_modifier = 0.5,
		},
	},
	mutator_only_melee_roamers = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_roamer_packs = {
				low = {
					renegade = RoamerPacks.renegade_melee_low,
					cultist = RoamerPacks.cultist_melee_low,
				},
				high = {
					renegade = RoamerPacks.renegade_melee_high,
					cultist = RoamerPacks.cultist_melee_high,
				},
			},
		},
	},
	mutator_only_melee_terror_events = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			replace_terror_event_tags = {
				villains = {
					close = "melee",
					far = "melee",
				},
			},
		},
	},
	mutator_only_melee_trickle_hordes = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_trickle_horde_compositions = {
				renegade = {
					none = {
						HordeCompositions.renegade_trickle_melee,
					},
					low = {
						HordeCompositions.renegade_trickle_melee,
					},
					high = {
						HordeCompositions.renegade_trickle_melee_elites,
					},
					poxwalkers = {
						HordeCompositions.renegade_trickle_melee,
					},
				},
				cultist = {
					none = {
						HordeCompositions.cultist_trickle_melee,
					},
					low = {
						HordeCompositions.cultist_trickle_melee,
					},
					high = {
						HordeCompositions.cultist_trickle_melee_elites,
					},
					poxwalkers = {
						HordeCompositions.cultist_trickle_melee,
					},
				},
			},
		},
	},
	mutator_only_ranged_roamers = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_roamer_packs = {
				none = {
					renegade = RoamerPacks.renegade_far_low_no_melee_ogryns,
					cultist = RoamerPacks.cultist_far_low_no_melee_ogryns,
				},
				low = {
					renegade = RoamerPacks.renegade_close_low_no_melee_ogryns,
					cultist = RoamerPacks.cultist_close_low_no_melee_ogryns,
				},
				high = {
					renegade = RoamerPacks.renegade_far_high_no_melee_ogryns,
					cultist = RoamerPacks.cultist_far_high_no_melee_ogryns,
				},
			},
		},
	},
	mutator_only_ranged_trickle_hordes = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_trickle_horde_compositions = {
				renegade = {
					none = {
						HordeCompositions.renegade_trickle_riflemen,
					},
					low = {
						HordeCompositions.renegade_trickle_riflemen,
					},
					high = {
						HordeCompositions.renegade_trickle_riflemen_high,
					},
					poxwalkers = {
						HordeCompositions.renegade_trickle_riflemen,
					},
				},
				cultist = {
					none = {
						HordeCompositions.cultist_trickle_assaulters,
					},
					low = {
						HordeCompositions.cultist_trickle_assaulters,
					},
					high = {
						HordeCompositions.cultist_trickle_assaulters_high,
					},
					poxwalkers = {
						HordeCompositions.cultist_trickle_assaulters,
					},
				},
			},
		},
	},
	mutator_modify_challenge_resistance_scale_six_one = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			modify_challenge_resistance_scale = {
				{
					3,
					1,
				},
				{
					4,
					1,
				},
				{
					5,
					2,
				},
				{
					6,
					2,
				},
				{
					6,
					3,
				},
			},
		},
		client_dummy_challenge = {
			3,
			4,
			5,
			6,
			6,
		},
	},
	mutator_monster_specials = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			specials_monster_spawn_config = {
				chance_to_spawn_monster = 0.2,
				max_monsters = 2,
				health_modifiers = {
					chaos_beast_of_nurgle = 0.4,
					chaos_plague_ogryn = 0.4,
					chaos_spawn = 0.4,
				},
				max_monster_duration = {
					90,
					180,
				},
				breeds = {
					"chaos_plague_ogryn",
					"chaos_beast_of_nurgle",
					"chaos_spawn",
				},
			},
		},
	},
	mutator_live_event_only_beast = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			specials_monster_spawn_config = {
				chance_to_spawn_monster = 0.2,
				max_monsters = 2,
				max_monster_duration = {
					180,
					600,
				},
				breeds = {
					"chaos_beast_of_nurgle",
				},
			},
		},
	},
	mutator_no_monsters = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			num_monsters_override = 0,
		},
	},
	mutator_no_witches = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			num_witches_override = 0,
		},
	},
	mutator_no_boss_patrols = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			num_boss_patrol_override = 0,
		},
	},
	mutator_more_ogryns = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			tag_limit_bonus = {
				elite = 8,
				ogryn = 8,
			},
		},
	},
	mutator_more_elites = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			tag_limit_bonus = {
				elite = 20,
			},
		},
	},
	mutator_increase_terror_event_points = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			terror_event_point_multiplier = 0.25,
		},
	},
	mutator_always_allow_all_spawn_types = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_allowed_spawn_types = {
				build_up_tension_low = {
					hordes = true,
					monsters = true,
					roamers = true,
					specials = true,
					terror_events = true,
					trickle_hordes = true,
				},
				build_up_tension = {
					hordes = true,
					monsters = true,
					roamers = true,
					specials = true,
					terror_events = true,
					trickle_hordes = true,
				},
				build_up_tension_high = {
					hordes = true,
					monsters = true,
					roamers = true,
					specials = true,
					terror_events = true,
					trickle_hordes = true,
				},
				sustain_tension_peak = {
					hordes = true,
					monsters = true,
					roamers = true,
					specials = true,
					terror_events = true,
					trickle_hordes = true,
				},
				tension_peak_fade = {
					hordes = true,
					monsters = true,
					roamers = true,
					specials = true,
					terror_events = true,
					trickle_hordes = true,
				},
				relax = {
					hordes = true,
					monsters = true,
					roamers = true,
					specials = true,
					terror_events = true,
					trickle_hordes = true,
				},
			},
		},
	},
	mutator_auric_tension_modifier = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			tension_modifier = 0.5,
		},
	},
	mutator_reduced_ramp_duration = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			ramp_duration_modifier = 0.5,
		},
	},
	mutator_reduced_ramp_duration_low = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			ramp_duration_modifier = 0.75,
		},
	},
	mutator_darkness_los = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
	},
	mutator_ventilation_purge_los = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
	},
	mutator_single_twin = {
		class = "scripts/managers/mutator/mutators/mutator_base",
	},
	mutator_havoc_armored_infected = {
		class = "scripts/managers/mutator/mutators/mutator_replace_breed",
		init_replacement_breed = {
			breed_replacement = {
				chaos_newly_infected = "chaos_armored_infected",
				chaos_poxwalker = "chaos_armored_infected",
			},
		},
	},
	mutator_maelstrom_mutated_poxwalker = {
		class = "scripts/managers/mutator/mutators/mutator_replace_breed",
		init_replacement_breed = {
			breed_replacement = {
				chaos_newly_infected = "chaos_lesser_mutated_poxwalker",
				chaos_poxwalker = "chaos_mutated_poxwalker",
			},
		},
	},
	mutator_communication_hack_event = {
		class = "scripts/managers/mutator/mutators/mutator_nurgle_warp",
		compositions = {
			{
				"renegade_radio_operator",
				"renegade_netgunner",
				"renegade_executor",
				"renegade_executor",
			},
		},
	},
	mutator_live_event_plasma_gunner_replacement = {
		class = "scripts/managers/mutator/mutators/mutator_replace_breed",
		init_replacement_breed = {
			breed_replacement = {
				renegade_gunner = "renegade_plasma_gunner",
			},
		},
	},
}

return mutator_templates
