local dialogue_breed_settings = {
	voice_classes_2d = {
		"sergeant",
		"pilot",
		"tech_priest",
		"explicator",
		"training_ground_psyker",
		"voice_preview"
	},
	voice_classes_npc = {
		"sergeant",
		"pilot",
		"tech_priest",
		"explicator",
		"training_ground_psyker"
	},
	chaos_hound = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = true,
		vo_class_name = "chaos_hound",
		vo_triggers_enemy_kill_query = true,
		has_dialogue_extension = false,
		can_trigger_vo = true,
		dialogue_memory_faction_name = "enemy"
	},
	chaos_plague_ogryn = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = true,
		vo_class_name = "chaos_plague_ogryn",
		vo_triggers_enemy_kill_query = true,
		has_dialogue_extension = true,
		can_trigger_vo = true,
		dialogue_memory_faction_name = "enemy"
	},
	chaos_plague_ogryn_sprayer = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = true,
		vo_class_name = "chaos_plague_ogryn_sprayer",
		vo_triggers_enemy_kill_query = true,
		has_dialogue_extension = true,
		can_trigger_vo = true,
		dialogue_memory_faction_name = "enemy"
	},
	chaos_beast_of_nurgle = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = true,
		vo_class_name = "chaos_beast_of_nurgle",
		vo_triggers_enemy_kill_query = true,
		has_dialogue_extension = true,
		can_trigger_vo = true,
		dialogue_memory_faction_name = "enemy"
	},
	chaos_poxwalker = {
		trigger_seen_vo = false,
		is_network_synced = false,
		trigger_heard_vo = false,
		vo_class_name = "chaos_poxwalker",
		vo_triggers_enemy_kill_query = false,
		has_dialogue_extension = false,
		can_trigger_vo = true,
		dialogue_memory_faction_name = "enemy"
	},
	voice_preview = {
		trigger_seen_vo = false,
		vo_class_name = "voice_preview",
		is_network_synced = false,
		trigger_heard_vo = false,
		has_dialogue_extension = false,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "npc",
		prop_name = "voice_over_2d",
		can_trigger_vo = true,
		wwise_voices = {
			"voice_preview"
		}
	},
	chaos_poxwalker_bomber = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = true,
		vo_class_name = "chaos_poxwalker_bomber",
		vo_triggers_enemy_kill_query = true,
		has_dialogue_extension = false,
		can_trigger_vo = true,
		dialogue_memory_faction_name = "enemy"
	},
	chaos_newly_infected = {
		trigger_seen_vo = false,
		is_network_synced = false,
		trigger_heard_vo = false,
		vo_class_name = "enemy_chaos_newly_infected",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "enemy",
		follow_vo_interval_t = 2,
		assault_vo_interval_t = 2,
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_voice_enemy_chaos_newly_infected",
		wwise_voices = {
			"enemy_chaos_newly_infected_male_e",
			"enemy_chaos_newly_infected_male_f",
			"enemy_chaos_newly_infected_male_g",
			"enemy_chaos_newly_infected_male_h",
			"enemy_chaos_newly_infected_male_i, "
		}
	},
	chaos_daemonhost = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = true,
		vo_class_name = "enemy_daemonhost",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = true,
		dialogue_memory_faction_name = "enemy",
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_voice_enemy_chaos_daemonhost",
		wwise_voices = {
			"enemy_daemonhost_a"
		}
	},
	human = {
		trigger_seen_vo = false,
		is_network_synced = true,
		trigger_heard_vo = false,
		vo_class_name = "veteran",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "player",
		can_trigger_vo = false,
		wwise_voice_switch_group = "voice_profile",
		wwise_voices = {
			"veteran_female_a",
			"veteran_female_b",
			"veteran_female_c",
			"veteran_male_a",
			"veteran_male_b",
			"veteran_male_c",
			"psyker_male_a",
			"psyker_male_b",
			"psyker_male_c",
			"psyker_female_a",
			"psyker_female_b",
			"psyker_female_c",
			"ogryn_a",
			"ogryn_b",
			"ogryn_c",
			"zealot_female_a",
			"zealot_female_b",
			"zealot_female_c",
			"zealot_male_a",
			"zealot_male_b",
			"zealot_male_c"
		}
	},
	mission_giver = {
		trigger_seen_vo = false,
		is_network_synced = true,
		trigger_heard_vo = false,
		vo_class_name = "sergeant_a",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "mission_giver",
		can_trigger_vo = true,
		wwise_voice_switch_group = "voice_profile",
		wwise_voices = {
			"sergeant_a",
			"pilot_a",
			"tech_priest_a",
			"explicator_a"
		}
	},
	sergeant = {
		trigger_seen_vo = false,
		is_network_synced = true,
		trigger_heard_vo = false,
		vo_class_name = "sergeant",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "npc",
		prop_name = "voice_over_2d",
		can_trigger_vo = true,
		wwise_voice_switch_group = "voice_profile",
		wwise_voices = {
			"sergeant_a"
		}
	},
	explicator = {
		trigger_seen_vo = false,
		is_network_synced = true,
		trigger_heard_vo = false,
		vo_class_name = "explicator",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "npc",
		level_requirement = 0,
		prop_name = "voice_over_2d",
		can_trigger_vo = true,
		wwise_voice_switch_group = "voice_profile",
		wwise_voices = {
			"explicator_a"
		}
	},
	pilot = {
		trigger_seen_vo = false,
		is_network_synced = true,
		trigger_heard_vo = false,
		vo_class_name = "pilot",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "npc",
		prop_name = "voice_over_2d",
		can_trigger_vo = true,
		wwise_voice_switch_group = "voice_profile",
		wwise_voices = {
			"pilot_a"
		}
	},
	tech_priest = {
		trigger_seen_vo = false,
		is_network_synced = true,
		trigger_heard_vo = false,
		vo_class_name = "tech_priest",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "npc",
		prop_name = "voice_over_2d",
		can_trigger_vo = true,
		wwise_voice_switch_group = "voice_profile",
		wwise_voices = {
			"tech_priest_a"
		}
	},
	interrogator = {
		trigger_seen_vo = false,
		is_network_synced = true,
		trigger_heard_vo = false,
		vo_class_name = "interrogator",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "npc",
		can_trigger_vo = true,
		wwise_voice_switch_group = "voice_profile",
		wwise_voices = {
			"interrogator_a"
		}
	},
	confessional = {
		trigger_seen_vo = false,
		is_network_synced = true,
		trigger_heard_vo = false,
		vo_class_name = "confessional",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "npc",
		can_trigger_vo = true,
		wwise_voice_switch_group = "voice_profile",
		wwise_voices = {
			"confessional_a"
		}
	},
	vocator = {
		trigger_seen_vo = false,
		is_network_synced = true,
		trigger_heard_vo = false,
		vo_class_name = "vocator",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "npc",
		prop_name = "voice_over_2d",
		can_trigger_vo = true,
		wwise_voice_switch_group = "voice_profile",
		wwise_voices = {
			"vocator_a",
			"vocator_b"
		},
		random_talk_settings = {
			trigger_id = "random_talk",
			mission_update_enabled = false,
			enabled = true,
			random_talk_tick_time_t = 67,
			mission_update_tick_time = 15,
			random_talk_start_delay_t = 131
		}
	},
	mourningstar_servitor = {
		trigger_seen_vo = false,
		is_network_synced = true,
		trigger_heard_vo = false,
		vo_class_name = "mourningstar_servitor",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "npc",
		prop_name = "voice_over_2d",
		can_trigger_vo = true,
		wwise_voice_switch_group = "voice_profile",
		wwise_voices = {
			"mourningstar_servitor_a",
			"mourningstar_servitor_b",
			"mourningstar_servitor_c",
			"mourningstar_servitor_d"
		},
		random_talk_settings = {
			trigger_id = "random_talk",
			mission_update_enabled = true,
			enabled = true,
			random_talk_tick_time_t = 67,
			mission_update_tick_time = 15,
			random_talk_start_delay_t = 131
		}
	},
	ogryn = {
		trigger_seen_vo = false,
		is_network_synced = true,
		trigger_heard_vo = false,
		vo_class_name = "ogryn",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "player",
		can_trigger_vo = false,
		wwise_voice_switch_group = "voice_profile",
		wwise_voices = {
			"ogryn_a",
			"ogryn_b",
			"ogryn_c"
		}
	},
	renegade_assault = {
		trigger_seen_vo = false,
		is_network_synced = false,
		trigger_heard_vo = true,
		vo_class_name = "renegade_assault",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "enemy",
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_voice_enemy_traitor_guard_smg_rusher",
		wwise_voices = {
			"enemy_traitor_guard_smg_rusher_a"
		}
	},
	renegade_executor = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = true,
		no_damage_vo_event = "no_damage_taunt",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = true,
		dialogue_memory_faction_name = "enemy",
		vo_class_name = "enemy_traitor_enforcer_executor",
		follow_vo_interval_t = 2,
		assault_vo_interval_t = 2,
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_voice_enemy_traitor_enforcer_executor",
		wwise_voices = {
			"enemy_traitor_enforcer_executor_a"
		}
	},
	renegade_grenadier = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = true,
		skulking_vo_interval_t = 2,
		vo_class_name = "renegade_grenadier",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = true,
		dialogue_memory_faction_name = "enemy",
		spawn_vo_event = "spawned",
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_voice_enemy_traitor_grenadier",
		wwise_voices = {
			"enemy_grenadier_a"
		}
	},
	renegade_gunner = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = true,
		vo_class_name = "renegade_gunner",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = true,
		dialogue_memory_faction_name = "enemy",
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_voice_enemy_traitor_gunner",
		wwise_voices = {
			"enemy_traitor_gunner_a"
		}
	},
	renegade_melee = {
		trigger_seen_vo = false,
		is_network_synced = false,
		trigger_heard_vo = false,
		vo_class_name = "renegade_melee",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "enemy",
		follow_vo_interval_t = 1,
		assault_vo_interval_t = 1,
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_voice_enemy_traitor_trenchfighter",
		wwise_voices = {
			"enemy_traitor_trenchfighter_a",
			"enemy_traitor_trenchfighter_b"
		}
	},
	chaos_ogryn_executor = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = true,
		no_damage_vo_event = "no_damage_taunt",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = true,
		dialogue_memory_faction_name = "enemy",
		vo_class_name = "chaos_ogryn_executor",
		follow_vo_interval_t = 3,
		stop_vce_event = "wwise/events/minions/stop_all_chaos_ogryn_executor_vce",
		assault_vo_interval_t = 3,
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_voice_enemy_chaos_ogryn_armoured_executor",
		wwise_voices = {
			"enemy_chaos_ogryn_armoured_executor_a"
		}
	},
	chaos_ogryn_bulwark = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = false,
		vo_class_name = "chaos_ogryn_bulwark",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "enemy",
		follow_vo_interval_t = 5,
		assault_vo_interval_t = 5,
		can_trigger_vo = true,
		wwise_voice_switch_group = "enemy_voice_profile",
		wwise_voices = {
			"enemy_chaos_ogryn_bulwark_a"
		}
	},
	chaos_ogryn_gunner = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = true,
		vo_class_name = "enemy_chaos_ogryn_heavy_gunner",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "enemy",
		can_trigger_vo = true,
		wwise_voice_switch_group = "enemy_voice_profile",
		wwise_voices = {
			"enemy_chaos_ogryn_heavy_gunner_a"
		}
	},
	renegade_captain = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = false,
		skulking_vo_interval_t = 2,
		randomize_voice = true,
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = true,
		dialogue_memory_faction_name = "enemy",
		follow_vo_interval_t = 1,
		assault_vo_interval_t = 1,
		vo_class_name = "renegade_captain",
		spawn_vo_event = "taunt",
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_voice_enemy_captain",
		wwise_voices = {
			"enemy_captain_officer_a",
			"enemy_captain_maniac_a",
			"enemy_captain_brute_a",
			"enemy_captain_sadist_b",
			"enemy_captain_spiritual_b"
		},
		vo_events = {
			event_trickle_wave_spawned = "reinforcements"
		}
	},
	renegade_rifleman = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = false,
		vo_class_name = "renegade_rifleman",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = true,
		dialogue_memory_faction_name = "enemy",
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_voice_enemy_traitor_guard_rifleman",
		wwise_voices = {
			"enemy_traitor_guard_rifleman_male_a",
			"enemy_traitor_guard_rifleman_male_b",
			"enemy_traitor_guard_rifleman_female_b",
			"enemy_traitor_guard_rifleman_female_b"
		}
	},
	renegade_netgunner = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = true,
		vo_class_name = "enemy_traitor_netgunner",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = true,
		dialogue_memory_faction_name = "enemy",
		spawn_vo_event = "spawned",
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_voice_enemy_traitor_netgunner",
		wwise_voices = {
			"enemy_traitor_netgunner_a"
		}
	},
	renegade_sniper = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = true,
		vo_class_name = "enemy_traitor_guard_sniper",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = true,
		dialogue_memory_faction_name = "enemy",
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_voice_enemy_traitor_sniper",
		wwise_voices = {
			"enemy_traitor_guard_sniper_a"
		}
	},
	renegade_shocktrooper = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = false,
		vo_class_name = "renegade_shocktrooper",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = true,
		dialogue_memory_faction_name = "enemy",
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_voice_enemy_traitor_shocktrooper",
		wwise_voices = {
			"enemy_traitor_scout_shocktrooper_a"
		}
	},
	renegade_flamer = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = false,
		vo_class_name = "renegade_flamer",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = true,
		dialogue_memory_faction_name = "enemy",
		spawn_vo_event = "spawned",
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_voice_enemy_traitor_flamer",
		wwise_voices = {
			"enemy_traitor_guard_flamer_a"
		}
	},
	unknown_breed_name = {
		trigger_seen_vo = false,
		trigger_heard_vo = false,
		is_network_synced = false,
		vo_class_name = "unknown",
		vo_triggers_enemy_kill_query = false,
		has_dialogue_extension = false,
		can_trigger_vo = false
	},
	cultist_shocktrooper = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = false,
		vo_class_name = "cultist_shocktrooper",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = true,
		dialogue_memory_faction_name = "enemy",
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_voice_enemy_cultist_shocktrooper",
		wwise_voices = {
			"enemy_cultist_shocktrooper_a"
		}
	},
	cultist_melee = {
		trigger_seen_vo = false,
		is_network_synced = false,
		trigger_heard_vo = false,
		vo_class_name = "cultist_melee",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "enemy",
		follow_vo_interval_t = 2,
		assault_vo_interval_t = 2,
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_voice_enemy_cultist_melee_fighter",
		wwise_voices = {
			"enemy_cultist_melee_fighter_a",
			"enemy_cultist_melee_fighter_b",
			"enemy_cultist_melee_fighter_c"
		}
	},
	cultist_assault = {
		trigger_seen_vo = false,
		is_network_synced = false,
		trigger_heard_vo = false,
		vo_class_name = "cultist_assault",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "enemy",
		follow_vo_interval_t = 2,
		assault_vo_interval_t = 2,
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_voice_enemy_cultist_rusher",
		wwise_voices = {
			"enemy_cultist_rusher_male_a",
			"enemy_cultist_rusher_male_b"
		}
	},
	cultist_gunner = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = true,
		vo_class_name = "cultist_gunner",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = true,
		dialogue_memory_faction_name = "enemy",
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_enemy_cultist_gunner",
		wwise_voices = {
			"enemy_cultist_gunner_a"
		}
	},
	cultist_grenadier = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = true,
		skulking_vo_interval_t = 2,
		vo_class_name = "cultist_grenadier",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = true,
		dialogue_memory_faction_name = "enemy",
		spawn_vo_event = "spawned",
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_enemy_cultist_grenadier",
		wwise_voices = {
			"enemy_cultist_grenadier_a"
		}
	},
	cultist_flamer = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = true,
		vo_class_name = "cultist_flamer",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = true,
		dialogue_memory_faction_name = "enemy",
		spawn_vo_event = "spawned",
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_voice_enemy_cultist_flamer",
		wwise_voices = {
			"enemy_cultist_flamer_a"
		}
	},
	cultist_mutant = {
		trigger_seen_vo = true,
		vo_class_name = "cultist_mutant",
		is_network_synced = false,
		trigger_heard_vo = true,
		has_dialogue_extension = false,
		vo_triggers_enemy_kill_query = true,
		dialogue_memory_faction_name = "enemy",
		can_trigger_vo = true,
		wwise_voice_switch_group = "enemy_voice_profile"
	},
	cultist_berzerker = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = true,
		vo_class_name = "cultist_berzerker",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = true,
		dialogue_memory_faction_name = "enemy",
		follow_vo_interval_t = 2,
		assault_vo_interval_t = 2,
		dialogue_source_name = "cultist_berzerker",
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_enemy_cultist_berzerker",
		wwise_voices = {
			"enemy_cultist_berzerker_a"
		}
	},
	renegade_berzerker = {
		trigger_seen_vo = true,
		is_network_synced = false,
		trigger_heard_vo = true,
		vo_class_name = "cultist_berzerker",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = true,
		dialogue_memory_faction_name = "enemy",
		follow_vo_interval_t = 2,
		assault_vo_interval_t = 2,
		dialogue_source_name = "cultist_berzerker",
		can_trigger_vo = true,
		wwise_voice_switch_group = "switch_enemy_cultist_berzerker",
		wwise_voices = {
			"enemy_cultist_berzerker_a"
		}
	},
	contract_vendor = {
		trigger_seen_vo = false,
		is_network_synced = true,
		trigger_heard_vo = false,
		vo_class_name = "contract_vendor",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "npc",
		level_requirement = 11,
		can_trigger_vo = true,
		wwise_voice_switch_group = "voice_profile",
		wwise_voices = {
			"contract_vendor_a"
		},
		opinion_settings = {
			ogryn_c = "likes_character",
			veteran_male_b = "dislikes_character",
			zealot_female_c = "dislikes_character",
			psyker_male_b = "dislikes_character",
			ogryn_a = "dislikes_character",
			psyker_female_c = "likes_character",
			ogryn_b = "dislikes_character",
			zealot_male_a = "likes_character",
			veteran_female_c = "dislikes_character",
			zealot_male_b = "dislikes_character",
			zealot_male_c = "dislikes_character",
			veteran_male_c = "dislikes_character",
			psyker_female_b = "dislikes_character",
			psyker_female_a = "likes_character",
			psyker_male_a = "likes_character",
			zealot_female_a = "likes_character",
			veteran_female_a = "likes_character",
			zealot_female_b = "dislikes_character",
			psyker_male_c = "likes_character",
			veteran_male_a = "likes_character",
			veteran_female_b = "dislikes_character"
		}
	},
	credit_store_servitor = {
		trigger_seen_vo = false,
		is_network_synced = true,
		trigger_heard_vo = false,
		vo_class_name = "credit_store_servitor",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "npc",
		level_requirement = 2,
		can_trigger_vo = true,
		wwise_voice_switch_group = "voice_profile",
		wwise_voices = {
			"credit_store_servitor_a",
			"credit_store_servitor_b",
			"credit_store_servitor_c"
		}
	},
	training_ground_psyker = {
		trigger_seen_vo = false,
		is_network_synced = true,
		trigger_heard_vo = false,
		vo_class_name = "training_ground_psyker",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "npc",
		level_requirement = 0,
		prop_name = "voice_over_2d",
		can_trigger_vo = true,
		wwise_voice_switch_group = "voice_profile",
		wwise_voices = {
			"training_ground_psyker_a"
		},
		opinion_settings = {
			psyker_male_b = "likes_character",
			veteran_male_b = "dislikes_character",
			zealot_female_c = "likes_character",
			zealot_male_c = "likes_character",
			ogryn_a = "likes_character",
			psyker_female_c = "likes_character",
			ogryn_b = "dislikes_character",
			veteran_male_c = "likes_character",
			zealot_male_a = "dislikes_character",
			zealot_male_b = "dislikes_character",
			zealot_female_b = "dislikes_character",
			veteran_female_c = "likes_character",
			psyker_female_b = "likes_character",
			psyker_female_a = "likes_character",
			psyker_male_a = "likes_character",
			zealot_female_a = "dislikes_character",
			veteran_female_a = "dislikes_character",
			ogryn_c = "dislikes_character",
			psyker_male_c = "likes_character",
			veteran_male_a = "dislikes_character",
			veteran_female_b = "dislikes_character"
		}
	},
	purser = {
		trigger_seen_vo = false,
		is_network_synced = true,
		trigger_heard_vo = false,
		vo_class_name = "purser",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "npc",
		level_requirement = 0,
		can_trigger_vo = true,
		wwise_voice_switch_group = "voice_profile",
		wwise_voices = {
			"purser_a"
		},
		opinion_settings = {
			ogryn_c = "dislikes_character",
			veteran_male_b = "likes_character",
			zealot_female_c = "dislikes_character",
			psyker_male_b = "likes_character",
			ogryn_a = "likes_character",
			psyker_female_c = "likes_character",
			ogryn_b = "likes_character",
			zealot_male_a = "dislikes_character",
			veteran_female_c = "dislikes_character",
			zealot_male_b = "likes_character",
			zealot_male_c = "dislikes_character",
			veteran_male_c = "dislikes_character",
			psyker_female_b = "likes_character",
			psyker_female_a = "dislikes_character",
			psyker_male_a = "dislikes_character",
			zealot_female_a = "dislikes_character",
			veteran_female_a = "dislikes_character",
			zealot_female_b = "likes_character",
			psyker_male_c = "likes_character",
			veteran_male_a = "dislikes_character",
			veteran_female_b = "likes_character"
		}
	},
	medicae_servitor = {
		trigger_seen_vo = false,
		is_network_synced = true,
		trigger_heard_vo = false,
		vo_class_name = "medicae_servitor",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "npc",
		subtitle_distance = 17,
		can_trigger_vo = true,
		wwise_voice_switch_group = "voice_profile",
		wwise_voices = {
			"medicae_servitor_a"
		}
	},
	mourningstar_soldier = {
		trigger_seen_vo = false,
		is_network_synced = true,
		trigger_heard_vo = false,
		vo_class_name = "mourningstar_soldier",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "npc",
		can_trigger_vo = true,
		wwise_voice_switch_group = "voice_profile",
		wwise_voices = {
			"mourningstar_soldier_male_a",
			"mourningstar_soldier_female_a",
			"mourningstar_initiate_a",
			"mourningstar_soldier_male_b",
			"mourningstar_soldier_male_f"
		}
	},
	barber = {
		trigger_seen_vo = false,
		is_network_synced = true,
		trigger_heard_vo = false,
		vo_class_name = "barber",
		has_dialogue_extension = true,
		vo_triggers_enemy_kill_query = false,
		dialogue_memory_faction_name = "npc",
		level_requirement = 0,
		can_trigger_vo = true,
		wwise_voice_switch_group = "voice_profile",
		wwise_voices = {
			"barber_a"
		}
	}
}

return settings("DialogueBreedSettings", dialogue_breed_settings)
