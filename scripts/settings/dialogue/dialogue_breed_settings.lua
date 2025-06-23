-- chunkname: @scripts/settings/dialogue/dialogue_breed_settings.lua

local dialogue_breed_settings = {}

dialogue_breed_settings.voice_classes_2d = {
	"sergeant",
	"pilot",
	"tech_priest",
	"explicator",
	"training_ground_psyker",
	"purser",
	"contract_vendor",
	"shipmistress",
	"enemy_nemesis_wolfer",
	"enemy_ritualist",
	"enemy_wolfer_adjutant",
	"interrogator",
	"barber",
	"enginseer",
	"boon_vendor",
	"tertium_noble",
	"cargo_pilot",
	"travelling_salesman",
	"commissar",
	"adamant_officer"
}
dialogue_breed_settings.voice_classes_npc = dialogue_breed_settings.voice_classes_2d
dialogue_breed_settings.chaos_hound = {
	trigger_seen_vo = true,
	vo_class_name = "chaos_hound",
	trigger_heard_vo = true,
	is_network_synced = false,
	has_dialogue_extension = false,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy"
}
dialogue_breed_settings.chaos_hound_mutator = table.clone(dialogue_breed_settings.chaos_hound)
dialogue_breed_settings.chaos_plague_ogryn = {
	trigger_seen_vo = true,
	vo_class_name = "chaos_plague_ogryn",
	trigger_heard_vo = true,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy"
}
dialogue_breed_settings.chaos_beast_of_nurgle = {
	trigger_seen_vo = true,
	vo_class_name = "chaos_beast_of_nurgle",
	trigger_heard_vo = true,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy"
}
dialogue_breed_settings.chaos_poxwalker = {
	trigger_seen_vo = false,
	vo_class_name = "chaos_poxwalker",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = false,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "enemy"
}
dialogue_breed_settings.chaos_mutated_poxwalker = {
	trigger_seen_vo = false,
	vo_class_name = "chaos_poxwalker",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = false,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "enemy"
}
dialogue_breed_settings.chaos_lesser_mutated_poxwalker = {
	trigger_seen_vo = false,
	vo_class_name = "chaos_poxwalker",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = false,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "enemy"
}
dialogue_breed_settings.voice_preview = {
	trigger_seen_vo = false,
	is_network_synced = false,
	vo_class_name = "voice_preview",
	trigger_heard_vo = false,
	has_dialogue_extension = false,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voices = {
		"voice_preview"
	}
}
dialogue_breed_settings.chaos_poxwalker_bomber = {
	trigger_seen_vo = true,
	vo_class_name = "chaos_poxwalker_bomber",
	trigger_heard_vo = true,
	is_network_synced = false,
	has_dialogue_extension = false,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy"
}
dialogue_breed_settings.chaos_newly_infected = {
	trigger_seen_vo = false,
	vo_class_name = "enemy_chaos_newly_infected",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "switch_voice_enemy_chaos_newly_infected",
	wwise_voices = {
		"enemy_chaos_newly_infected_male_e",
		"enemy_chaos_newly_infected_male_f",
		"enemy_chaos_newly_infected_male_g",
		"enemy_chaos_newly_infected_male_h",
		"enemy_chaos_newly_infected_male_i"
	}
}
dialogue_breed_settings.chaos_armored_infected = {
	trigger_seen_vo = false,
	vo_class_name = "enemy_chaos_armored_infected",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "switch_voice_enemy_chaos_newly_infected",
	wwise_voices = {
		"enemy_chaos_armored_infected_male_a",
		"enemy_chaos_armored_infected_male_b",
		"enemy_chaos_armored_infected_male_c",
		"enemy_chaos_newly_infected_male_e",
		"enemy_chaos_newly_infected_male_f",
		"enemy_chaos_newly_infected_male_g",
		"enemy_chaos_newly_infected_male_h",
		"enemy_chaos_newly_infected_male_i",
		"enemy_chaos_armored_infected_male_a",
		"enemy_chaos_armored_infected_male_b"
	}
}
dialogue_breed_settings.chaos_daemonhost = {
	trigger_seen_vo = true,
	vo_class_name = "enemy_daemonhost",
	trigger_heard_vo = true,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "switch_voice_enemy_chaos_daemonhost",
	wwise_voices = {
		"enemy_daemonhost_a"
	}
}
dialogue_breed_settings.chaos_mutator_daemonhost = {
	trigger_seen_vo = true,
	vo_class_name = "enemy_daemonhost",
	trigger_heard_vo = true,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "switch_voice_enemy_chaos_daemonhost",
	wwise_voices = {
		"enemy_daemonhost_a"
	}
}
dialogue_breed_settings.chaos_spawn = {
	trigger_seen_vo = true,
	vo_class_name = "chaos_spawn",
	trigger_heard_vo = true,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy"
}
dialogue_breed_settings.human = {
	trigger_seen_vo = false,
	vo_class_name = "veteran",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "player",
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
		"zealot_male_c",
		"adamant_male_a",
		"adamant_male_b",
		"adamant_male_c",
		"adamant_female_a",
		"adamant_female_b",
		"adamant_female_c"
	}
}
dialogue_breed_settings.mission_giver = {
	trigger_seen_vo = false,
	vo_class_name = "sergeant_a",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "mission_giver",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"sergeant_a",
		"sergeant_b",
		"sergeant_c",
		"pilot_a",
		"tech_priest_a",
		"tech_priest_b",
		"explicator_a",
		"purser_a",
		"contract_vendor_a",
		"shipmistress_a",
		"enemy_nemesis_wolfer_a",
		"enemy_ritualist_a",
		"enemy_wolfer_adjutant_a",
		"enemy_wolfer_adjutant_b",
		"enemy_wolfer_adjutant_c",
		"enemy_wolfer_adjutant_d",
		"enemy_wolfer_adjutant_e",
		"dreg_lector_a",
		"interrogator_a",
		"training_ground_psyker_a",
		"enginseer_a",
		"barber_a",
		"boon_vendor_a",
		"tertium_noble_a",
		"tertium_noble_b",
		"travelling_salesman_a",
		"travelling_salesman_b",
		"travelling_salesman_c",
		"cargo_pilot_a",
		"commissar_a",
		"adamant_officer_a"
	}
}
dialogue_breed_settings.sergeant = {
	trigger_seen_vo = false,
	vo_class_name = "sergeant",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"sergeant_a",
		"sergeant_b",
		"sergeant_c"
	}
}
dialogue_breed_settings.explicator = {
	trigger_seen_vo = false,
	vo_class_name = "explicator",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	level_requirement = 0,
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"explicator_a"
	}
}
dialogue_breed_settings.pilot = {
	trigger_seen_vo = false,
	vo_class_name = "pilot",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"pilot_a"
	}
}
dialogue_breed_settings.tech_priest = {
	trigger_seen_vo = false,
	vo_class_name = "tech_priest",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	level_requirement = 4,
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"tech_priest_a",
		"tech_priest_b"
	}
}
dialogue_breed_settings.enginseer = {
	trigger_seen_vo = false,
	vo_class_name = "enginseer",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"enginseer_a"
	}
}
dialogue_breed_settings.purser = {
	trigger_seen_vo = false,
	vo_class_name = "purser",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	level_requirement = 0,
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"purser_a"
	},
	opinion_settings = {
		ogryn_c = "likes_character",
		veteran_male_b = "likes_character",
		zealot_female_c = "likes_character",
		psyker_male_b = "likes_character",
		ogryn_a = "likes_character",
		psyker_female_c = "likes_character",
		ogryn_b = "likes_character",
		zealot_male_a = "likes_character",
		veteran_female_c = "likes_character",
		zealot_male_b = "likes_character",
		zealot_male_c = "likes_character",
		veteran_male_c = "likes_character",
		adamant_female_c = "likes_character",
		adamant_female_a = "likes_character",
		adamant_male_b = "likes_character",
		psyker_female_b = "likes_character",
		adamant_male_c = "likes_character",
		psyker_female_a = "likes_character",
		adamant_female_b = "likes_character",
		psyker_male_a = "likes_character",
		zealot_female_a = "likes_character",
		veteran_female_a = "likes_character",
		zealot_female_b = "likes_character",
		psyker_male_c = "likes_character",
		veteran_male_a = "likes_character",
		veteran_female_b = "likes_character",
		adamant_male_a = "likes_character"
	}
}
dialogue_breed_settings.interrogator = {
	trigger_seen_vo = false,
	vo_class_name = "interrogator",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"interrogator_a"
	}
}
dialogue_breed_settings.shipmistress = {
	trigger_seen_vo = false,
	vo_class_name = "shipmistress",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"shipmistress_a"
	}
}
dialogue_breed_settings.boon_vendor = {
	trigger_seen_vo = false,
	vo_class_name = "boon_vendor",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"boon_vendor_a"
	},
	opinion_settings = {
		zealot_female_b = "likes_character",
		veteran_male_b = "dislikes_character",
		zealot_female_c = "likes_character",
		psyker_male_b = "dislikes_character",
		ogryn_a = "likes_character",
		psyker_female_c = "dislikes_character",
		ogryn_b = "dislikes_character",
		zealot_male_a = "likes_character",
		zealot_male_c = "likes_character",
		zealot_male_b = "likes_character",
		veteran_male_c = "dislikes_character",
		veteran_female_c = "dislikes_character",
		adamant_female_c = "likes_character",
		adamant_female_a = "likes_character",
		adamant_male_b = "likes_character",
		psyker_female_b = "dislikes_character",
		adamant_male_c = "likes_character",
		psyker_female_a = "dislikes_character",
		adamant_female_b = "likes_character",
		psyker_male_a = "dislikes_character",
		zealot_female_a = "likes_character",
		veteran_female_a = "likes_character",
		ogryn_c = "likes_character",
		psyker_male_c = "dislikes_character",
		veteran_male_a = "likes_character",
		veteran_female_b = "dislikes_character",
		adamant_male_a = "likes_character"
	}
}
dialogue_breed_settings.tertium_noble = {
	trigger_seen_vo = false,
	vo_class_name = "tertium_noble",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"tertium_noble_a",
		"tertium_noble_b"
	}
}
dialogue_breed_settings.enemy_nemesis_wolfer = {
	trigger_seen_vo = false,
	vo_class_name = "enemy_nemesis_wolfer",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"enemy_nemesis_wolfer_a"
	}
}
dialogue_breed_settings.enemy_wolfer_adjutant = {
	trigger_seen_vo = false,
	vo_class_name = "enemy_wolfer_adjutant",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"enemy_wolfer_adjutant_a",
		"enemy_wolfer_adjutant_b",
		"enemy_wolfer_adjutant_c",
		"enemy_wolfer_adjutant_d",
		"enemy_wolfer_adjutant_e"
	}
}
dialogue_breed_settings.dreg_lector = {
	trigger_seen_vo = false,
	vo_class_name = "dreg_lector",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"dreg_lector_a"
	}
}
dialogue_breed_settings.enemy_ritualist = {
	trigger_seen_vo = false,
	vo_class_name = "enemy_ritualist",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"enemy_ritualist_a"
	}
}
dialogue_breed_settings.confessional = {
	trigger_seen_vo = false,
	vo_class_name = "confessional",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"confessional_a"
	}
}
dialogue_breed_settings.vocator = {
	trigger_seen_vo = false,
	vo_class_name = "vocator",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"vocator_a",
		"vocator_b",
		"mourningstar_confessor_a",
		"mourningstar_wing_commander_a",
		"shipmistress_a",
		"sergeant_a"
	},
	random_talk_settings = {
		trigger_id = "random_talk",
		mission_update_enabled = false,
		enabled = true,
		random_talk_tick_time_t = 67,
		random_talk_start_delay_t = 131
	}
}
dialogue_breed_settings.mourningstar_servitor = {
	trigger_seen_vo = false,
	vo_class_name = "mourningstar_servitor",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
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
		random_talk_start_delay_t = 131
	}
}
dialogue_breed_settings.ogryn = {
	trigger_seen_vo = false,
	vo_class_name = "ogryn",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "player",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"ogryn_a",
		"ogryn_b",
		"ogryn_c"
	}
}
dialogue_breed_settings.renegade_assault = {
	trigger_seen_vo = false,
	vo_class_name = "renegade_assault",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "switch_voice_enemy_traitor_guard_smg_rusher",
	wwise_voices = {
		"enemy_traitor_guard_smg_rusher_a",
		"enemy_traitor_guard_smg_rusher_b"
	}
}
dialogue_breed_settings.renegade_executor = {
	trigger_seen_vo = true,
	vo_class_name = "enemy_traitor_enforcer_executor",
	trigger_heard_vo = false,
	no_damage_vo_event = "no_damage_taunt",
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	is_network_synced = false,
	wwise_voice_switch_group = "switch_voice_enemy_traitor_enforcer_executor",
	wwise_voices = {
		"enemy_traitor_enforcer_executor_a"
	}
}
dialogue_breed_settings.renegade_grenadier = {
	trigger_seen_vo = true,
	vo_class_name = "renegade_grenadier",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	spawn_vo_event = "spawned",
	wwise_voice_switch_group = "switch_voice_enemy_traitor_grenadier",
	wwise_voices = {
		"enemy_grenadier_a"
	}
}
dialogue_breed_settings.renegade_gunner = {
	trigger_seen_vo = true,
	vo_class_name = "renegade_gunner",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "switch_voice_enemy_traitor_gunner",
	wwise_voices = {
		"enemy_traitor_gunner_a"
	}
}
dialogue_breed_settings.renegade_radio_operator = {
	trigger_seen_vo = true,
	vo_class_name = "renegade_radio_operator",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "switch_voice_enemy_traitor_gunner",
	wwise_voices = {
		"enemy_traitor_gunner_a"
	}
}
dialogue_breed_settings.renegade_melee = {
	trigger_seen_vo = false,
	vo_class_name = "renegade_melee",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "switch_voice_enemy_traitor_trenchfighter",
	wwise_voices = {
		"enemy_traitor_trenchfighter_a",
		"enemy_traitor_trenchfighter_b"
	}
}
dialogue_breed_settings.chaos_ogryn_executor = {
	trigger_seen_vo = false,
	vo_class_name = "chaos_ogryn_executor",
	trigger_heard_vo = false,
	no_damage_vo_event = "no_damage_taunt",
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	is_network_synced = false,
	stop_vce_event = "wwise/events/minions/stop_all_chaos_ogryn_executor_vce",
	wwise_voice_switch_group = "switch_voice_enemy_chaos_ogryn_armoured_executor",
	wwise_voices = {
		"enemy_chaos_ogryn_armoured_executor_a"
	}
}
dialogue_breed_settings.chaos_ogryn_bulwark = {
	trigger_seen_vo = true,
	vo_class_name = "chaos_ogryn_bulwark",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "enemy_voice_profile",
	wwise_voices = {
		"enemy_chaos_ogryn_bulwark_a"
	}
}
dialogue_breed_settings.chaos_ogryn_gunner = {
	trigger_seen_vo = true,
	vo_class_name = "enemy_chaos_ogryn_heavy_gunner",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "enemy_voice_profile",
	wwise_voices = {
		"enemy_chaos_ogryn_heavy_gunner_a"
	}
}
dialogue_breed_settings.renegade_captain = {
	randomize_voice = true,
	is_network_synced = false,
	trigger_heard_vo = false,
	trigger_seen_vo = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	vo_class_name = "renegade_captain",
	spawn_vo_event = "taunt",
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
}
dialogue_breed_settings.cultist_captain = {
	randomize_voice = true,
	is_network_synced = false,
	trigger_heard_vo = false,
	trigger_seen_vo = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	vo_class_name = "cultist_captain",
	spawn_vo_event = "taunt",
	wwise_voice_switch_group = "switch_voice_enemy_captain",
	wwise_voices = {
		"enemy_champion_infested_a",
		"enemy_champion_brute_a",
		"enemy_champion_preacher_a"
	},
	vo_events = {
		event_trickle_wave_spawned = "reinforcements"
	}
}
dialogue_breed_settings.renegade_twin_captain = {
	randomize_voice = true,
	is_network_synced = false,
	trigger_heard_vo = false,
	trigger_seen_vo = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	vo_class_name = "captain_twin_male",
	prop_name = "voice_over_2d",
	spawn_vo_event = "taunt",
	wwise_voice_switch_group = "switch_voice_enemy_captain",
	wwise_voices = {
		"captain_twin_male_a"
	},
	vo_events = {
		event_trickle_wave_spawned = "reinforcements"
	}
}
dialogue_breed_settings.renegade_twin_captain_two = {
	randomize_voice = true,
	is_network_synced = true,
	trigger_heard_vo = false,
	trigger_seen_vo = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	vo_class_name = "captain_twin_female",
	prop_name = "voice_over_2d",
	spawn_vo_event = "taunt",
	wwise_voice_switch_group = "switch_voice_enemy_captain",
	wwise_voices = {
		"captain_twin_female_a"
	},
	vo_events = {
		event_trickle_wave_spawned = "reinforcements"
	}
}
dialogue_breed_settings.renegade_rifleman = {
	trigger_seen_vo = false,
	vo_class_name = "renegade_rifleman",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "switch_voice_enemy_traitor_guard_rifleman",
	wwise_voices = {
		"enemy_traitor_guard_rifleman_male_a",
		"enemy_traitor_guard_rifleman_male_b",
		"enemy_traitor_guard_rifleman_female_a",
		"enemy_traitor_guard_rifleman_female_b"
	}
}
dialogue_breed_settings.renegade_netgunner = {
	trigger_seen_vo = true,
	vo_class_name = "enemy_traitor_netgunner",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	spawn_vo_event = "spawned",
	wwise_voice_switch_group = "switch_voice_enemy_traitor_netgunner",
	wwise_voices = {
		"enemy_traitor_netgunner_a"
	}
}
dialogue_breed_settings.renegade_sniper = {
	trigger_seen_vo = true,
	vo_class_name = "enemy_traitor_guard_sniper",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "switch_voice_enemy_traitor_sniper",
	wwise_voices = {
		"enemy_traitor_guard_sniper_a"
	}
}
dialogue_breed_settings.renegade_shocktrooper = {
	trigger_seen_vo = true,
	vo_class_name = "renegade_shocktrooper",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "switch_voice_enemy_traitor_shocktrooper",
	wwise_voices = {
		"enemy_traitor_scout_shocktrooper_a"
	}
}
dialogue_breed_settings.renegade_flamer = {
	trigger_seen_vo = true,
	vo_class_name = "renegade_flamer",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	spawn_vo_event = "spawned",
	wwise_voice_switch_group = "switch_voice_enemy_traitor_flamer",
	wwise_voices = {
		"enemy_traitor_guard_flamer_a"
	}
}
dialogue_breed_settings.renegade_flamer_mutator = {
	trigger_seen_vo = true,
	vo_class_name = "renegade_flamer",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	spawn_vo_event = "spawned",
	wwise_voice_switch_group = "switch_voice_enemy_traitor_flamer_mutator",
	wwise_voices = {
		"enemy_traitor_guard_flamer_a",
		"enemy_traitor_guard_flamer_mutator_b",
		"enemy_traitor_guard_flamer_mutator_c",
		"enemy_traitor_guard_flamer_mutator_d"
	}
}
dialogue_breed_settings.unknown_breed_name = {
	trigger_seen_vo = false,
	is_network_synced = false,
	trigger_heard_vo = false,
	vo_class_name = "unknown",
	has_dialogue_extension = false,
	vo_triggers_enemy_kill_query = false
}
dialogue_breed_settings.cultist_shocktrooper = {
	trigger_seen_vo = true,
	vo_class_name = "cultist_shocktrooper",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "switch_voice_enemy_cultist_shocktrooper",
	wwise_voices = {
		"enemy_cultist_shocktrooper_a"
	}
}
dialogue_breed_settings.cultist_melee = {
	trigger_seen_vo = false,
	vo_class_name = "cultist_melee",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "switch_voice_enemy_cultist_melee_fighter",
	wwise_voices = {
		"enemy_cultist_melee_fighter_a",
		"enemy_cultist_melee_fighter_b",
		"enemy_cultist_melee_fighter_c"
	}
}
dialogue_breed_settings.cultist_ritualist = table.clone(dialogue_breed_settings.cultist_melee)
dialogue_breed_settings.chaos_mutator_ritualist = table.clone(dialogue_breed_settings.cultist_ritualist)
dialogue_breed_settings.cultist_assault = {
	trigger_seen_vo = false,
	vo_class_name = "cultist_assault",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "switch_voice_enemy_cultist_rusher",
	wwise_voices = {
		"enemy_cultist_rusher_male_a",
		"enemy_cultist_rusher_male_b"
	}
}
dialogue_breed_settings.cultist_gunner = {
	trigger_seen_vo = true,
	vo_class_name = "cultist_gunner",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "switch_enemy_cultist_gunner",
	wwise_voices = {
		"enemy_cultist_gunner_a"
	}
}
dialogue_breed_settings.cultist_grenadier = {
	trigger_seen_vo = true,
	vo_class_name = "cultist_grenadier",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	spawn_vo_event = "spawned",
	wwise_voice_switch_group = "switch_voice_enemy_cultist_grenadier",
	wwise_voices = {
		"enemy_cultist_grenadier_a",
		"enemy_cultist_grenadier_b"
	}
}
dialogue_breed_settings.cultist_flamer = {
	trigger_seen_vo = true,
	vo_class_name = "cultist_flamer",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	spawn_vo_event = "spawned",
	wwise_voice_switch_group = "switch_voice_enemy_cultist_flamer",
	wwise_voices = {
		"enemy_cultist_flamer_a"
	}
}
dialogue_breed_settings.cultist_mutant = {
	trigger_seen_vo = true,
	vo_class_name = "cultist_mutant",
	wwise_voice_switch_group = "enemy_voice_profile",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = false,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy"
}
dialogue_breed_settings.cultist_mutant_mutator = table.clone(dialogue_breed_settings.cultist_mutant)
dialogue_breed_settings.cultist_berzerker = {
	trigger_seen_vo = true,
	vo_class_name = "cultist_berzerker",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "switch_voice_enemy_cultist_berzerker",
	wwise_voices = {
		"enemy_cultist_berzerker_a",
		"enemy_cultist_berzerker_b"
	}
}
dialogue_breed_settings.renegade_berzerker = {
	trigger_seen_vo = true,
	vo_class_name = "renegade_berzerker",
	trigger_heard_vo = false,
	is_network_synced = false,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "enemy",
	wwise_voice_switch_group = "switch_voice_enemy_traitor_berzerker",
	wwise_voices = {
		"enemy_traitor_berzerker_a",
		"enemy_traitor_berzerker_b"
	}
}
dialogue_breed_settings.contract_vendor = {
	trigger_seen_vo = false,
	vo_class_name = "contract_vendor",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	level_requirement = 11,
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
		adamant_female_c = "likes_character",
		adamant_female_a = "likes_character",
		adamant_male_b = "likes_character",
		psyker_female_b = "dislikes_character",
		adamant_male_c = "likes_character",
		psyker_female_a = "likes_character",
		adamant_female_b = "likes_character",
		psyker_male_a = "likes_character",
		zealot_female_a = "likes_character",
		veteran_female_a = "likes_character",
		zealot_female_b = "dislikes_character",
		psyker_male_c = "likes_character",
		veteran_male_a = "likes_character",
		veteran_female_b = "dislikes_character",
		adamant_male_a = "likes_character"
	}
}
dialogue_breed_settings.credit_store_servitor = {
	trigger_seen_vo = false,
	vo_class_name = "credit_store_servitor",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	level_requirement = 2,
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"credit_store_servitor_a",
		"credit_store_servitor_b",
		"credit_store_servitor_c"
	}
}
dialogue_breed_settings.training_ground_psyker = {
	trigger_seen_vo = false,
	is_network_synced = true,
	trigger_heard_vo = false,
	vo_class_name = "training_ground_psyker",
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	level_requirement = 0,
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
		adamant_female_c = "dislikes_character",
		adamant_female_a = "dislikes_character",
		adamant_male_b = "dislikes_character",
		psyker_female_b = "likes_character",
		adamant_male_c = "dislikes_character",
		psyker_female_a = "likes_character",
		adamant_female_b = "dislikes_character",
		psyker_male_a = "likes_character",
		zealot_female_a = "dislikes_character",
		veteran_female_a = "dislikes_character",
		ogryn_c = "dislikes_character",
		psyker_male_c = "likes_character",
		veteran_male_a = "dislikes_character",
		veteran_female_b = "dislikes_character",
		adamant_male_a = "dislikes_character"
	}
}
dialogue_breed_settings.medicae_servitor = {
	trigger_seen_vo = false,
	vo_class_name = "medicae_servitor",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"medicae_servitor_a",
		"medicae_servitor_b"
	}
}
dialogue_breed_settings.archive_servitor = {
	trigger_seen_vo = false,
	vo_class_name = "archive_servitor",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"archive_servitor_a"
	}
}
dialogue_breed_settings.mourningstar_soldier = {
	trigger_seen_vo = false,
	vo_class_name = "mourningstar_soldier",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"mourningstar_initiate_a",
		"mourningstar_initiate_b",
		"mourningstar_soldier_female_a",
		"mourningstar_soldier_male_a",
		"mourningstar_soldier_male_b",
		"mourningstar_soldier_male_c",
		"mourningstar_soldier_male_d",
		"mourningstar_soldier_male_e",
		"mourningstar_soldier_male_f",
		"mourningstar_soldier_male_g",
		"mourningstar_soldier_male_h",
		"mourningstar_officer_male_a",
		"mourningstar_officer_male_b",
		"steelhead_a",
		"steelhead_b"
	}
}
dialogue_breed_settings.barber = {
	trigger_seen_vo = false,
	vo_class_name = "barber",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	level_requirement = 0,
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"barber_a"
	}
}
dialogue_breed_settings.reject_npc = {
	trigger_seen_vo = false,
	vo_class_name = "reject_npc",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	level_requirement = 0,
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"reject_npc_a",
		"reject_npc_servitor_a"
	}
}
dialogue_breed_settings.mourningstar_hadron_servitor = {
	trigger_seen_vo = false,
	vo_class_name = "mourningstar_hadron_servitor",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"mourningstar_hadron_servitor_a"
	}
}
dialogue_breed_settings.warp_echo = {
	trigger_seen_vo = false,
	vo_class_name = "warp_echo",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"warp_echo_moebian_a",
		"warp_echo_moebian_b"
	}
}
dialogue_breed_settings.past = {
	trigger_seen_vo = false,
	vo_class_name = "past",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"fx",
		"past_alpha_a",
		"past_armourer_a",
		"past_auspex_operator_a",
		"past_brother_a",
		"past_cartel_tough_a",
		"past_cartel_tough_c",
		"past_enemy_nemesis_wolfer_a",
		"past_enginseer_a",
		"past_explicator_a",
		"past_explicator_b",
		"past_interrogator_a",
		"past_interrogator_b",
		"past_legion_captain_a",
		"past_legion_commissar_a",
		"past_legion_trooper_a",
		"past_legion_trooper_b",
		"past_legion_trooper_c",
		"past_magos_biologis_a",
		"past_matriarch_a",
		"past_mourningstar_officer_a",
		"past_ragged_king_a",
		"past_sergeant_a",
		"past_shipmistress_a",
		"past_tech_priest_a",
		"past_tertium_enforcer_a",
		"past_tertium_enforcer_b",
		"past_world_eater_a",
		"past_young_explicator_a",
		"past_young_sergeant_a"
	}
}
dialogue_breed_settings.cargo_pilot = {
	trigger_seen_vo = false,
	vo_class_name = "cargo_pilot",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"cargo_pilot_a"
	}
}
dialogue_breed_settings.travelling_salesman = {
	trigger_seen_vo = false,
	vo_class_name = "travelling_salesman",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"travelling_salesman_a, travelling_salesman_b, travelling_salesman_c"
	}
}
dialogue_breed_settings.commissar = {
	trigger_seen_vo = false,
	vo_class_name = "commissar",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"commissar_a"
	}
}
dialogue_breed_settings.adamant_officer = {
	trigger_seen_vo = false,
	vo_class_name = "adamant_officer",
	trigger_heard_vo = false,
	is_network_synced = true,
	has_dialogue_extension = true,
	vo_triggers_enemy_kill_query = false,
	dialogue_memory_faction_name = "npc",
	prop_name = "voice_over_2d",
	wwise_voice_switch_group = "voice_profile",
	wwise_voices = {
		"adamant_officer_a"
	},
	opinion_settings = {
		ogryn_c = "dislikes_character",
		veteran_male_b = "dislikes_character",
		zealot_female_c = "dislikes_character",
		psyker_male_b = "dislikes_character",
		ogryn_a = "dislikes_character",
		psyker_female_c = "dislikes_character",
		ogryn_b = "dislikes_character",
		zealot_male_a = "dislikes_character",
		veteran_female_c = "dislikes_character",
		zealot_male_b = "dislikes_character",
		zealot_male_c = "dislikes_character",
		veteran_male_c = "dislikes_character",
		adamant_female_c = "likes_character",
		adamant_female_a = "likes_character",
		adamant_male_b = "likes_character",
		psyker_female_b = "dislikes_character",
		adamant_male_c = "likes_character",
		psyker_female_a = "dislikes_character",
		adamant_female_b = "likes_character",
		psyker_male_a = "dislikes_character",
		zealot_female_a = "dislikes_character",
		veteran_female_a = "dislikes_character",
		zealot_female_b = "dislikes_character",
		psyker_male_c = "dislikes_character",
		veteran_male_a = "dislikes_character",
		veteran_female_b = "dislikes_character",
		adamant_male_a = "likes_character"
	}
}
dialogue_breed_settings.companion_dog = {
	trigger_seen_vo = true,
	vo_class_name = "companion_dog",
	trigger_heard_vo = true,
	is_network_synced = false,
	has_dialogue_extension = false,
	vo_triggers_enemy_kill_query = true,
	dialogue_memory_faction_name = "npc"
}

return settings("DialogueBreedSettings", dialogue_breed_settings)
