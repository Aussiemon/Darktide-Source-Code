-- chunkname: @scripts/settings/mutator/templates/mutator_extra_trickle_templates.lua

local HordeCompositions = require("scripts/managers/pacing/horde_pacing/horde_compositions")
local mutator_templates = {
	mutator_chaos_hounds = {
		class = "scripts/managers/mutator/mutators/mutator_extra_trickle_hordes",
		trickle_horde_templates = {
			{
				cant_be_ramped = true,
				ignore_disallowance = true,
				min_players_alive = 2,
				not_during_terror_events = true,
				num_trickle_hordes_active_for_cooldown = 20,
				optional_num_tries = 6,
				stinger = "wwise/events/minions/play_chaos_hound_spawn_stinger_circumstance",
				stinger_duration = 5,
				horde_compositions = {
					trickle_horde = {
						renegade = {
							none = {
								HordeCompositions.mutator_chaos_hounds,
							},
							low = {
								HordeCompositions.mutator_chaos_hounds,
							},
							high = {
								HordeCompositions.mutator_chaos_hounds,
							},
							poxwalkers = {
								HordeCompositions.mutator_chaos_hounds,
							},
						},
						cultist = {
							none = {
								HordeCompositions.mutator_chaos_hounds,
							},
							low = {
								HordeCompositions.mutator_chaos_hounds,
							},
							high = {
								HordeCompositions.mutator_chaos_hounds,
							},
							poxwalkers = {
								HordeCompositions.mutator_chaos_hounds,
							},
						},
					},
				},
				trickle_horde_travel_distance_range = {
					140,
					250,
				},
				trickle_horde_cooldown = {
					40,
					45,
				},
				optional_main_path_offset = {
					40,
					60,
				},
				pause_pacing_on_spawn = {
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 20,
						specials = 20,
						trickle_hordes = 30,
					},
					{
						trickle_hordes = 20,
					},
					{
						trickle_hordes = 10,
					},
				},
				num_trickle_waves = {
					{
						1,
						1,
					},
					{
						1,
						1,
					},
					{
						1,
						2,
					},
					{
						1,
						2,
					},
					{
						1,
						2,
					},
				},
				time_between_waves = {
					7,
					10,
				},
				group_sound_event_names = {
					start = "wwise/events/minions/play_chaos_hound_group_sound",
					stop = "wwise/events/minions/stop_chaos_hound_group_sound",
				},
			},
		},
	},
	exp_mutator_chaos_hounds = {
		class = "scripts/managers/mutator/mutators/mutator_expedition_extra_trickle_hordes",
		ui = {
			category_name = "loc_expedition_map_heretic_intel",
			description = "loc_expeditions_modifier_enemy_hunting_grounds_description",
			display_name = "loc_expeditions_modifier_enemy_hunting_grounds",
			icon = "content/ui/materials/mission_board/circumstances/hunting_grounds_01",
		},
		trickle_horde_templates = {
			{
				cant_be_ramped = true,
				ignore_disallowance = true,
				min_players_alive = 1,
				not_during_terror_events = true,
				num_trickle_hordes_active_for_cooldown = 2,
				optional_num_tries = 6,
				stinger = "wwise/events/minions/play_chaos_hound_spawn_stinger_circumstance",
				stinger_duration = 5,
				horde_compositions = {
					trickle_horde = {
						renegade = {
							none = {
								HordeCompositions.mutator_chaos_hounds,
							},
							undetected = {
								HordeCompositions.mutator_chaos_hounds,
							},
							alert = {
								HordeCompositions.mutator_chaos_hounds,
							},
							detected = {
								HordeCompositions.mutator_chaos_hounds,
							},
							max = {
								HordeCompositions.mutator_chaos_hounds,
							},
						},
						cultist = {
							none = {
								HordeCompositions.mutator_chaos_hounds,
							},
							undetected = {
								HordeCompositions.mutator_chaos_hounds,
							},
							alert = {
								HordeCompositions.mutator_chaos_hounds,
							},
							detected = {
								HordeCompositions.mutator_chaos_hounds,
							},
							max = {
								HordeCompositions.mutator_chaos_hounds,
							},
						},
					},
				},
				trickle_horde_travel_distance_range = {
					45,
					85,
				},
				trickle_horde_cooldown = {
					45,
					65,
				},
				optional_main_path_offset = {
					40,
					60,
				},
				optional_mutator_params = {
					always_patrol = true,
					externally_controlled_patrol = true,
					mutator_name = "exp_mutator_chaos_hounds",
					optional_horde_type = "mutator_trickle_horde",
					skip_heat_override = true,
					spawn_aggro_state = "passive",
				},
				group_sound_event_names = {
					start = "wwise/events/minions/play_chaos_hound_group_sound",
					stop = "wwise/events/minions/stop_chaos_hound_group_sound",
				},
			},
		},
	},
	exp_mutator_rotten_armor = {
		class = "scripts/managers/mutator/mutators/mutator_expedition_extra_trickle_hordes",
		ui = {
			category_name = "loc_expedition_map_heretic_intel",
			description = "loc_expeditions_modifier_enemy_rotten_armour_description",
			display_name = "loc_expeditions_modifier_enemy_rotten_armour",
			icon = "content/ui/materials/icons/circumstances/havoc_pj/havoc_mutator_rotten_armor",
		},
		trickle_horde_templates = {
			{
				cant_be_ramped = true,
				ignore_disallowance = true,
				min_players_alive = 1,
				not_during_terror_events = true,
				num_trickle_hordes_active_for_cooldown = 2,
				optional_num_tries = 6,
				stinger = "wwise/events/minions/play_chaos_hound_spawn_stinger_circumstance",
				stinger_duration = 5,
				horde_compositions = {
					trickle_horde = {
						renegade = {
							none = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							undetected = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							alert = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							detected = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							max = {
								HordeCompositions.mutator_live_rotten_armor,
							},
						},
						cultist = {
							none = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							undetected = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							alert = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							detected = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							max = {
								HordeCompositions.mutator_live_rotten_armor,
							},
						},
					},
				},
				trickle_horde_travel_distance_range = {
					45,
					60,
				},
				trickle_horde_cooldown = {
					25,
					35,
				},
				optional_main_path_offset = {
					40,
					60,
				},
				optional_mutator_params = {
					always_patrol = true,
					externally_controlled_patrol = true,
					mutator_name = "exp_mutator_rotten_armor",
					skip_heat_override = true,
					spawn_aggro_state = "passive",
				},
				group_sound_event_names = {
					start = "wwise/events/minions/play_chaos_hound_group_sound",
					stop = "wwise/events/minions/stop_chaos_hound_group_sound",
				},
			},
		},
	},
	mutator_snipers = {
		class = "scripts/managers/mutator/mutators/mutator_extra_trickle_hordes",
		trickle_horde_templates = {
			{
				cant_be_ramped = true,
				disallow_spawning_too_close_to_other_spawn = true,
				ignore_disallowance = true,
				min_players_alive = 2,
				not_during_terror_events = true,
				num_trickle_hordes_active_for_cooldown = 20,
				optional_num_tries = 6,
				stinger = "wwise/events/minions/play_minion_special_sniper_spawn_circumstance",
				stinger_duration = 8,
				horde_compositions = {
					trickle_horde = {
						renegade = {
							none = {
								HordeCompositions.mutator_snipers,
							},
							low = {
								HordeCompositions.mutator_snipers,
							},
							high = {
								HordeCompositions.mutator_snipers,
							},
							poxwalkers = {
								HordeCompositions.mutator_snipers,
							},
						},
						cultist = {
							none = {
								HordeCompositions.mutator_snipers,
							},
							low = {
								HordeCompositions.mutator_snipers,
							},
							high = {
								HordeCompositions.mutator_snipers,
							},
							poxwalkers = {
								HordeCompositions.mutator_snipers,
							},
						},
					},
				},
				trickle_horde_travel_distance_range = {
					110,
					230,
				},
				trickle_horde_cooldown = {
					40,
					45,
				},
				optional_main_path_offset = {
					30,
					70,
				},
				pause_pacing_on_spawn = {
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						trickle_hordes = 20,
					},
					{
						trickle_hordes = 10,
					},
				},
				num_trickle_waves = {
					{
						4,
						7,
					},
					{
						5,
						8,
					},
					{
						6,
						9,
					},
					{
						7,
						10,
					},
					{
						9,
						14,
					},
				},
				time_between_waves = {
					2,
					5,
				},
			},
		},
	},
	mutator_live_abhuman_trickle = {
		class = "scripts/managers/mutator/mutators/mutator_extra_trickle_hordes",
		trickle_horde_templates = {
			{
				cant_be_ramped = true,
				disallow_spawning_too_close_to_other_spawn = true,
				ignore_disallowance = true,
				min_players_alive = 2,
				not_during_terror_events = true,
				num_trickle_hordes_active_for_cooldown = 20,
				optional_num_tries = 6,
				stinger = "wwise/events/minions/play_mutator_abhuman_spawn_stinger",
				stinger_duration = 8,
				horde_compositions = {
					trickle_horde = {
						renegade = {
							none = {
								HordeCompositions.mutator_live_abhuman,
							},
							low = {
								HordeCompositions.mutator_live_abhuman,
							},
							high = {
								HordeCompositions.mutator_live_abhuman,
							},
							poxwalkers = {
								HordeCompositions.mutator_live_abhuman,
							},
						},
						cultist = {
							none = {
								HordeCompositions.mutator_live_abhuman,
							},
							low = {
								HordeCompositions.mutator_live_abhuman,
							},
							high = {
								HordeCompositions.mutator_live_abhuman,
							},
							poxwalkers = {
								HordeCompositions.mutator_live_abhuman,
							},
						},
					},
				},
				trickle_horde_travel_distance_range = {
					110,
					230,
				},
				trickle_horde_cooldown = {
					40,
					45,
				},
				optional_main_path_offset = {
					30,
					70,
				},
				pause_pacing_on_spawn = {
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						trickle_hordes = 20,
					},
					{
						trickle_hordes = 10,
					},
				},
				num_trickle_waves = {
					{
						1,
						1,
					},
					{
						1,
						1,
					},
					{
						1,
						2,
					},
					{
						2,
						3,
					},
					{
						3,
						4,
					},
				},
				time_between_waves = {
					15,
					25,
				},
			},
		},
	},
	mutator_live_rotten_armor_trickle_horde = {
		class = "scripts/managers/mutator/mutators/mutator_extra_trickle_hordes",
		trickle_horde_templates = {
			{
				cant_be_ramped = true,
				disallow_spawning_too_close_to_other_spawn = true,
				ignore_disallowance = true,
				min_players_alive = 2,
				not_during_terror_events = true,
				num_trickle_hordes_active_for_cooldown = 20,
				optional_num_tries = 6,
				stinger = "wwise/events/minions/play_mutator_abhuman_spawn_stinger",
				stinger_duration = 8,
				horde_compositions = {
					trickle_horde = {
						renegade = {
							none = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							low = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							high = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							poxwalkers = {
								HordeCompositions.mutator_live_rotten_armor,
							},
						},
						cultist = {
							none = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							low = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							high = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							poxwalkers = {
								HordeCompositions.mutator_live_rotten_armor,
							},
						},
					},
				},
				trickle_horde_travel_distance_range = {
					110,
					230,
				},
				trickle_horde_cooldown = {
					40,
					45,
				},
				optional_main_path_offset = {
					30,
					70,
				},
				pause_pacing_on_spawn = {
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						trickle_hordes = 20,
					},
					{
						trickle_hordes = 10,
					},
				},
				num_trickle_waves = {
					{
						1,
						1,
					},
					{
						1,
						1,
					},
					{
						1,
						2,
					},
					{
						2,
						3,
					},
					{
						3,
						4,
					},
				},
				time_between_waves = {
					15,
					25,
				},
			},
		},
	},
	mutator_exp_rotten_armor_trickle_horde = {
		class = "scripts/managers/mutator/mutators/mutator_extra_trickle_hordes",
		trickle_horde_templates = {
			{
				cant_be_ramped = true,
				disallow_spawning_too_close_to_other_spawn = true,
				ignore_disallowance = true,
				min_players_alive = 1,
				not_during_terror_events = true,
				num_trickle_hordes_active_for_cooldown = 20,
				optional_num_tries = 6,
				stinger = "wwise/events/minions/play_mutator_abhuman_spawn_stinger",
				stinger_duration = 8,
				horde_compositions = {
					trickle_horde = {
						renegade = {
							none = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							undetected = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							alert = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							detected = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							max = {
								HordeCompositions.mutator_live_rotten_armor,
							},
						},
						cultist = {
							none = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							undetected = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							alert = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							detected = {
								HordeCompositions.mutator_live_rotten_armor,
							},
							max = {
								HordeCompositions.mutator_live_rotten_armor,
							},
						},
					},
				},
				trickle_horde_travel_distance_range = {
					60,
					80,
				},
				trickle_horde_cooldown = {
					40,
					45,
				},
				optional_main_path_offset = {
					30,
					70,
				},
				pause_pacing_on_spawn = {
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						trickle_hordes = 20,
					},
					{
						trickle_hordes = 10,
					},
				},
				num_trickle_waves = {
					{
						1,
						1,
					},
					{
						1,
						1,
					},
					{
						1,
						2,
					},
					{
						2,
						3,
					},
					{
						3,
						4,
					},
				},
				time_between_waves = {
					15,
					25,
				},
			},
		},
	},
	mutator_cultist_grenadier = {
		class = "scripts/managers/mutator/mutators/mutator_extra_trickle_hordes",
		trickle_horde_templates = {
			{
				cant_be_ramped = true,
				disallow_spawning_too_close_to_other_spawn = true,
				ignore_disallowance = true,
				not_during_terror_events = true,
				num_trickle_hordes_active_for_cooldown = 20,
				optional_num_tries = 6,
				stinger = "wwise/events/minions/play_minion_special_grenadier_spawn",
				stinger_duration = 8,
				horde_compositions = {
					trickle_horde = {
						renegade = {
							none = {
								HordeCompositions.mutator_cultist_grenadier,
							},
							low = {
								HordeCompositions.mutator_cultist_grenadier,
							},
							high = {
								HordeCompositions.mutator_cultist_grenadier,
							},
							poxwalkers = {
								HordeCompositions.mutator_cultist_grenadier,
							},
						},
						cultist = {
							none = {
								HordeCompositions.mutator_cultist_grenadier,
							},
							low = {
								HordeCompositions.mutator_cultist_grenadier,
							},
							high = {
								HordeCompositions.mutator_cultist_grenadier,
							},
							poxwalkers = {
								HordeCompositions.mutator_cultist_grenadier,
							},
						},
					},
				},
				trickle_horde_travel_distance_range = {
					110,
					230,
				},
				trickle_horde_cooldown = {
					40,
					45,
				},
				optional_main_path_offset = {
					30,
					70,
				},
				pause_pacing_on_spawn = {
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						trickle_hordes = 20,
					},
					{
						trickle_hordes = 10,
					},
				},
				num_trickle_waves = {
					{
						4,
						7,
					},
					{
						5,
						8,
					},
					{
						6,
						9,
					},
					{
						7,
						10,
					},
					{
						9,
						14,
					},
				},
				time_between_waves = {
					2,
					5,
				},
			},
		},
	},
	mutator_renegade_grenadier = {
		class = "scripts/managers/mutator/mutators/mutator_extra_trickle_hordes",
		trickle_horde_templates = {
			{
				cant_be_ramped = true,
				disallow_spawning_too_close_to_other_spawn = true,
				ignore_disallowance = true,
				not_during_terror_events = true,
				num_trickle_hordes_active_for_cooldown = 20,
				optional_num_tries = 6,
				stinger = "wwise/events/minions/play_minion_special_grenadier_spawn",
				stinger_duration = 8,
				horde_compositions = {
					trickle_horde = {
						renegade = {
							none = {
								HordeCompositions.mutator_renegade_grenadier,
							},
							low = {
								HordeCompositions.mutator_renegade_grenadier,
							},
							high = {
								HordeCompositions.mutator_renegade_grenadier,
							},
							poxwalkers = {
								HordeCompositions.mutator_renegade_grenadier,
							},
						},
						cultist = {
							none = {
								HordeCompositions.mutator_renegade_grenadier,
							},
							low = {
								HordeCompositions.mutator_renegade_grenadier,
							},
							high = {
								HordeCompositions.mutator_renegade_grenadier,
							},
							poxwalkers = {
								HordeCompositions.mutator_renegade_grenadier,
							},
						},
					},
				},
				trickle_horde_travel_distance_range = {
					110,
					230,
				},
				trickle_horde_cooldown = {
					40,
					45,
				},
				optional_main_path_offset = {
					30,
					70,
				},
				pause_pacing_on_spawn = {
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						trickle_hordes = 20,
					},
					{
						trickle_hordes = 10,
					},
				},
				num_trickle_waves = {
					{
						3,
						4,
					},
					{
						3,
						4,
					},
					{
						3,
						4,
					},
					{
						3,
						4,
					},
					{
						3,
						4,
					},
				},
				time_between_waves = {
					2,
					5,
				},
			},
		},
	},
	mutator_extra_shocktrooper = {
		class = "scripts/managers/mutator/mutators/mutator_extra_trickle_hordes",
		trickle_horde_templates = {
			{
				cant_be_ramped = true,
				disallow_spawning_too_close_to_other_spawn = true,
				ignore_disallowance = true,
				not_during_terror_events = true,
				num_trickle_hordes_active_for_cooldown = 20,
				optional_main_path_offset = 50,
				optional_num_tries = 6,
				horde_compositions = {
					trickle_horde = {
						renegade = {
							none = {
								HordeCompositions.mutator_renegade_shocktrooper,
							},
							low = {
								HordeCompositions.mutator_renegade_shocktrooper,
							},
							high = {
								HordeCompositions.mutator_renegade_shocktrooper,
							},
							poxwalkers = {
								HordeCompositions.mutator_renegade_shocktrooper,
							},
						},
						cultist = {
							none = {
								HordeCompositions.mutator_cultist_shocktrooper,
							},
							low = {
								HordeCompositions.mutator_cultist_shocktrooper,
							},
							high = {
								HordeCompositions.mutator_cultist_shocktrooper,
							},
							poxwalkers = {
								HordeCompositions.mutator_cultist_shocktrooper,
							},
						},
					},
				},
				trickle_horde_travel_distance_range = {
					110,
					190,
				},
				trickle_horde_cooldown = {
					30,
					45,
				},
				pause_pacing_on_spawn = {
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						trickle_hordes = 20,
					},
					{
						trickle_hordes = 10,
					},
				},
				num_trickle_waves = {
					{
						1,
						1,
					},
					{
						1,
						1,
					},
					{
						1,
						2,
					},
					{
						1,
						3,
					},
					{
						2,
						3,
					},
				},
				time_between_waves = {
					1,
					3,
				},
			},
		},
	},
	mutator_extra_grenadiers = {
		class = "scripts/managers/mutator/mutators/mutator_extra_trickle_hordes",
		trickle_horde_templates = {
			{
				cant_be_ramped = true,
				disallow_spawning_too_close_to_other_spawn = true,
				ignore_disallowance = true,
				not_during_terror_events = true,
				num_trickle_hordes_active_for_cooldown = 20,
				optional_num_tries = 6,
				horde_compositions = {
					trickle_horde = {
						renegade = {
							none = {
								HordeCompositions.mutator_renegade_grenadier,
							},
							low = {
								HordeCompositions.mutator_renegade_grenadier,
							},
							high = {
								HordeCompositions.mutator_renegade_grenadier,
							},
							poxwalkers = {
								HordeCompositions.mutator_renegade_grenadier,
							},
						},
						cultist = {
							none = {
								HordeCompositions.mutator_cultist_grenadier,
							},
							low = {
								HordeCompositions.mutator_cultist_grenadier,
							},
							high = {
								HordeCompositions.mutator_cultist_grenadier,
							},
							poxwalkers = {
								HordeCompositions.mutator_cultist_grenadier,
							},
						},
					},
				},
				trickle_horde_travel_distance_range = {
					120,
					140,
				},
				trickle_horde_cooldown = {
					40,
					45,
				},
				pause_pacing_on_spawn = {
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						trickle_hordes = 20,
					},
					{
						trickle_hordes = 10,
					},
				},
				optional_main_path_offset = {
					-60,
					60,
				},
				num_trickle_waves = {
					{
						1,
						1,
					},
					{
						1,
						1,
					},
					{
						1,
						2,
					},
					{
						1,
						3,
					},
					{
						2,
						3,
					},
				},
				time_between_waves = {
					1,
					3,
				},
			},
		},
	},
	mutator_poxwalker_bombers = {
		class = "scripts/managers/mutator/mutators/mutator_extra_trickle_hordes",
		trickle_horde_templates = {
			{
				cant_be_ramped = true,
				disallow_spawning_too_close_to_other_spawn = true,
				ignore_disallowance = true,
				not_during_terror_events = true,
				num_trickle_hordes_active_for_cooldown = 20,
				optional_num_tries = 6,
				spawn_max_health_modifier = 0.9,
				horde_compositions = {
					trickle_horde = {
						renegade = {
							none = {
								HordeCompositions.mutator_poxwalker_bombers,
							},
							low = {
								HordeCompositions.mutator_poxwalker_bombers,
							},
							high = {
								HordeCompositions.mutator_poxwalker_bombers,
							},
							poxwalkers = {
								HordeCompositions.mutator_poxwalker_bombers,
							},
						},
						cultist = {
							none = {
								HordeCompositions.mutator_poxwalker_bombers,
							},
							low = {
								HordeCompositions.mutator_poxwalker_bombers,
							},
							high = {
								HordeCompositions.mutator_poxwalker_bombers,
							},
							poxwalkers = {
								HordeCompositions.mutator_poxwalker_bombers,
							},
						},
					},
				},
				trickle_horde_travel_distance_range = {
					60,
					180,
				},
				trickle_horde_cooldown = {
					40,
					45,
				},
				pause_pacing_on_spawn = {
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						trickle_hordes = 20,
					},
					{
						trickle_hordes = 10,
					},
				},
				optional_main_path_offset = {
					-60,
					60,
				},
				num_trickle_waves = {
					{
						4,
						7,
					},
					{
						5,
						8,
					},
					{
						6,
						9,
					},
					{
						7,
						10,
					},
					{
						9,
						14,
					},
				},
				time_between_waves = {
					0.25,
					1,
				},
			},
		},
	},
	mutator_mutants = {
		class = "scripts/managers/mutator/mutators/mutator_extra_trickle_hordes",
		trickle_horde_templates = {
			{
				cant_be_ramped = true,
				disallow_spawning_too_close_to_other_spawn = true,
				ignore_disallowance = true,
				min_players_alive = 2,
				not_during_terror_events = true,
				num_trickle_hordes_active_for_cooldown = 20,
				optional_num_tries = 6,
				horde_compositions = {
					trickle_horde = {
						renegade = {
							none = {
								HordeCompositions.mutator_mutants,
							},
							low = {
								HordeCompositions.mutator_mutants,
							},
							high = {
								HordeCompositions.mutator_mutants,
							},
							poxwalkers = {
								HordeCompositions.mutator_mutants,
							},
						},
						cultist = {
							none = {
								HordeCompositions.mutator_mutants,
							},
							low = {
								HordeCompositions.mutator_mutants,
							},
							high = {
								HordeCompositions.mutator_mutants,
							},
							poxwalkers = {
								HordeCompositions.mutator_mutants,
							},
						},
					},
				},
				trickle_horde_travel_distance_range = {
					60,
					180,
				},
				trickle_horde_cooldown = {
					40,
					45,
				},
				pause_pacing_on_spawn = {
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						trickle_hordes = 20,
					},
					{
						trickle_hordes = 10,
					},
				},
				optional_main_path_offset = {
					-60,
					60,
				},
				num_trickle_waves = {
					{
						4,
						8,
					},
					{
						5,
						9,
					},
					{
						6,
						11,
					},
					{
						7,
						13,
					},
					{
						9,
						15,
					},
				},
				time_between_waves = {
					0.25,
					1,
				},
			},
		},
	},
	mutator_riflemen = {
		class = "scripts/managers/mutator/mutators/mutator_extra_trickle_hordes",
		trickle_horde_templates = {
			{
				ignore_disallowance = true,
				not_during_terror_events = true,
				num_trickle_hordes_active_for_cooldown = 20,
				optional_main_path_offset = 50,
				optional_num_tries = 6,
				stinger = "wwise/events/minions/play_chaos_hound_spawn_stinger_circumstance",
				stinger_duration = 8,
				horde_compositions = {
					trickle_horde = {
						renegade = {
							none = {
								HordeCompositions.mutator_riflemen,
							},
							low = {
								HordeCompositions.mutator_riflemen,
							},
							high = {
								HordeCompositions.mutator_riflemen,
							},
							poxwalkers = {
								HordeCompositions.mutator_riflemen,
							},
						},
						cultist = {
							none = {
								HordeCompositions.mutator_riflemen,
							},
							low = {
								HordeCompositions.mutator_riflemen,
							},
							high = {
								HordeCompositions.mutator_riflemen,
							},
							poxwalkers = {
								HordeCompositions.mutator_riflemen,
							},
						},
					},
				},
				trickle_horde_travel_distance_range = {
					110,
					230,
				},
				trickle_horde_cooldown = {
					40,
					45,
				},
				pause_pacing_on_spawn = {
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						trickle_hordes = 20,
					},
					{
						trickle_hordes = 10,
					},
				},
			},
		},
	},
}

return mutator_templates
