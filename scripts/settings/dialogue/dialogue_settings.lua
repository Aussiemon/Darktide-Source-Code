-- chunkname: @scripts/settings/dialogue/dialogue_settings.lua

local DialogueSettings = {}

DialogueSettings.default_rule_path = "dialogues/generated/"
DialogueSettings.default_voSources_path = "dialogues/generated/"
DialogueSettings.default_lookup_path = "dialogues/generated/"
DialogueSettings.auto_load_files = {
	"gameplay_vo",
	"mission_giver_vo",
	"conversations_core",
	"guidance_vo",
	"enemy_vo",
	"event_vo_fortification",
	"event_vo_kill",
	"event_vo_demolition",
	"event_vo_delivery",
	"asset_vo",
	"event_vo_survive",
	"event_vo_hacking",
	"event_vo_scan",
	"on_demand_vo",
	"class_rework",
}
DialogueSettings.menu_vo_files = {
	"conversations_hub",
}
DialogueSettings.level_specific_load_files = {
	om_hub_01 = {
		"mission_vo_om_hub_01",
		"cutscenes_vo",
	},
	om_hub_02 = {
		"mission_vo_om_hub_02",
		"cutscenes_vo",
	},
	om_basic_combat_01 = {
		"on_demand_vo",
		"training_grounds",
	},
	hub_ship = {
		"cutscenes_vo",
		"conversations_hub",
	},
	prologue = {
		"cutscenes_vo",
		"enemy_vo",
		"mission_vo_prologue",
	},
	dm_forge = {
		"mission_vo_dm_forge",
	},
	lm_rails = {
		"mission_vo_lm_rails",
	},
	lm_cooling = {
		"mission_vo_lm_cooling",
	},
	fm_cargo = {
		"mission_vo_fm_cargo",
	},
	fm_armoury = {
		"mission_vo_fm_armoury",
	},
	cm_raid = {
		"mission_vo_cm_raid",
	},
	fm_resurgence = {
		"mission_vo_fm_resurgence",
	},
	hm_complex = {
		"mission_vo_hm_complex",
	},
	cm_archives = {
		"mission_vo_cm_archives",
	},
	km_station = {
		"mission_vo_km_station",
	},
	hm_strain = {
		"mission_vo_hm_strain",
	},
	lm_scavenge = {
		"mission_vo_lm_scavenge",
	},
	dm_propaganda = {
		"mission_vo_dm_propaganda",
	},
	dm_stockpile = {
		"mission_vo_dm_stockpile",
	},
	km_enforcer = {
		"mission_vo_km_enforcer",
	},
	hm_cartel = {
		"mission_vo_hm_cartel",
	},
	cm_habs = {
		"mission_vo_cm_habs_remake",
	},
	dm_rise = {
		"mission_vo_dm_rise",
	},
	km_enforcer_twins = {
		"mission_vo_km_enforcer_twins",
	},
	tg_shooting_range = {
		"meat_grinder_vo",
	},
}
DialogueSettings.player_load_files = {
	ogryn_a = {
		"ogryn_a",
	},
	ogryn_b = {
		"ogryn_b",
	},
	ogryn_c = {
		"ogryn_c",
	},
	psyker_female_a = {
		"psyker_a",
		"psyker_female_a",
	},
	psyker_female_b = {
		"psyker_b",
		"psyker_female_b",
	},
	psyker_female_c = {
		"psyker_c",
		"psyker_female_c",
	},
	psyker_male_a = {
		"psyker_a",
		"psyker_male_a",
	},
	psyker_male_b = {
		"psyker_b",
		"psyker_male_b",
	},
	psyker_male_c = {
		"psyker_c",
		"psyker_male_c",
	},
	veteran_female_a = {
		"veteran_a",
		"veteran_female_a",
	},
	veteran_female_b = {
		"veteran_b",
		"veteran_female_b",
	},
	veteran_female_c = {
		"veteran_c",
		"veteran_female_c",
	},
	veteran_male_a = {
		"veteran_a",
		"veteran_male_a",
	},
	veteran_male_b = {
		"veteran_b",
		"veteran_male_b",
	},
	veteran_male_c = {
		"veteran_c",
		"veteran_male_c",
	},
	zealot_female_a = {
		"zealot_a",
		"zealot_female_a",
	},
	zealot_female_b = {
		"zealot_b",
		"zealot_female_b",
	},
	zealot_female_c = {
		"zealot_c",
		"zealot_female_c",
	},
	zealot_male_a = {
		"zealot_a",
		"zealot_male_a",
	},
	zealot_male_b = {
		"zealot_b",
		"zealot_male_b",
	},
	zealot_male_c = {
		"zealot_c",
		"zealot_male_c",
	},
}
DialogueSettings.blocked_auto_load_files = {
	hub_ship = true,
	om_basic_combat_01 = true,
	prologue = true,
	tg_shooting_range = true,
	tutorial = true,
}
DialogueSettings.ranged_special_kill_threshold = 20
DialogueSettings.friends_close_distance = 25
DialogueSettings.friends_distant_distance = 40
DialogueSettings.enemies_close_distance = 10
DialogueSettings.enemies_distant_distance = 40
DialogueSettings.dialogue_level_start_delay = 120
DialogueSettings.story_ticker_enabled = true
DialogueSettings.story_start_delay = 173
DialogueSettings.story_tick_time = 5.1
DialogueSettings.short_story_ticker_enabled = true
DialogueSettings.short_story_start_delay = 181
DialogueSettings.short_story_tick_time = 3.9
DialogueSettings.decaying_tension_delay = 2
DialogueSettings.npc_story_ticker_enabled = true
DialogueSettings.npc_story_ticker_start_delay = 127
DialogueSettings.npc_story_tick_time = 10
DialogueSettings.store_npc_cooldown_time = 5
DialogueSettings.sound_event_default_length = 3.4567
DialogueSettings.knocked_down_vo_interval = 11
DialogueSettings.netted_vo_start_delay_t = 1
DialogueSettings.netted_vo_interval_t = 3
DialogueSettings.pounced_vo_start_delay_t = 0.2
DialogueSettings.pounced_vo_interval_t = 3
DialogueSettings.monster_tough_to_kill_vo_health_percent = 0.6
DialogueSettings.monster_critical_health_percent_vo = 0.3
DialogueSettings.monster_near_death_health_percent_vo = 0.2
DialogueSettings.heavy_land_on_air_threshold = 0.7
DialogueSettings.raycast_enemy_check_interval = 0.25
DialogueSettings.hear_enemy_check_interval = 10
DialogueSettings.enemy_proximity_distance = 30
DialogueSettings.enemy_proximity_distance_heard = 30
DialogueSettings.seen_enemy_precision = 0.999
DialogueSettings.health_hog_health_before_healing = 0.8
DialogueSettings.ammo_hog_pickup_share = 0.7
DialogueSettings.friendly_fire_bullet_counter = 4
DialogueSettings.heard_speak_distance = 25
DialogueSettings.default_voice_switch_group = "voice_profile"
DialogueSettings.player_vce_light_damage_threshold = 55
DialogueSettings.surrounded_vo_slot_percent = 0.3
DialogueSettings.distance_culled_wwise_routes = {
	[19] = 20,
	[45] = 15,
	[50] = 25,
}
DialogueSettings.dynamic_smart_tags = table.enum("aggroed", "renegade_netgunner", "seen_netgunner_flee")
DialogueSettings.manual_subtitles = table.enum("loc_captain_twin_male_a__mission_twins_arrival_04_a_01")
DialogueSettings.manual_subtitle_data = {
	{
		duration = 9.26,
		speaker_name = "captain_twin_male_a",
	},
}

return DialogueSettings
