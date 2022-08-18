local DialogueSettings = {
	default_rule_path = "dialogues/generated/",
	default_voSources_path = "dialogues/generated/",
	default_lookup_path = "dialogues/generated/",
	auto_load_files = {
		"gameplay_vo",
		"mission_giver_vo",
		"conversations_core",
		"guidance_vo",
		"enemy_vo",
		"event_vo_demolition",
		"event_vo_delivery",
		"asset_vo",
		"event_vo_survive",
		"event_vo_hacking",
		"on_demand_vo"
	},
	menu_vo_files = {
		"conversations_hub"
	},
	level_specific_load_files = {
		hub_ship = {
			"cutscenes_vo",
			"on_demand_vo",
			"conversations_hub"
		},
		dm_forge = {
			"mission_vo_dm_forge"
		},
		lm_rails = {
			"mission_vo_lm_rails"
		},
		lm_cooling = {
			"mission_vo_lm_cooling"
		}
	},
	blocked_auto_load_files = {
		hub_ship = true,
		prologue = true,
		tutorial = true
	},
	default_pre_vo_waiting_time = 0,
	mission_brief_vo_waiting_time = 1,
	max_view_distance = 50,
	default_view_distance = 30,
	default_hear_distance = 10,
	death_discover_distance = 40,
	discover_enemy_attack_distance = 25,
	see_vortex_distance = 30,
	view_event_trigger_interval = 1,
	seen_recently_threshold = 15,
	ranged_special_kill_threshold = 20,
	observer_view_distance = 8,
	friends_close_distance = 30,
	friends_distant_distance = 40,
	enemies_close_distance = 15,
	enemies_distant_distance = 40,
	knocked_down_broadcast_range = 40,
	pounced_down_broadcast_range = 40,
	suicide_run_broadcast_range = 40,
	grabbed_broadcast_range = 40,
	armor_hit_broadcast_range = 7,
	dialogue_level_start_delay = 120,
	story_ticker_enabled = true,
	story_start_delay = 173,
	story_tick_time = 5.1,
	short_story_ticker_enabled = true,
	short_story_start_delay = 181,
	short_story_tick_time = 3.9,
	npc_story_ticker_enabled = true,
	npc_story_ticker_start_delay = 120,
	npc_story_tick_time = 600,
	mission_update_tick_time = 15,
	ambush_delay = 4,
	vector_delay = 6,
	sound_event_default_length = 3.4567,
	heavy_combat_inensity_threshold = 80,
	heavy_damage_threshold = 100,
	knocked_down_vo_interval = 8,
	pounced_vo_start_delay_t = 1,
	pounced_vo_interval_t = 3,
	monster_tough_to_kill_vo_health_percent = 0.6,
	monster_critical_health_percent_vo = 0.3,
	monster_near_death_health_percent_vo = 0.2,
	heavy_land_on_air_threshold = 0.7,
	bunny_jumping = {
		tick_time = 5,
		jump_threshold = 6
	},
	raycast_enemy_check_interval = 0.25,
	hear_enemy_check_interval = 10,
	special_proximity_distance = 30,
	special_proximity_distance_heard = 30,
	guidance_wrong_way_distance = 30,
	health_hog_health_before_healing = 0.8,
	ammo_hog_pickup_share = 0.8
}
HealthTriggerSettings = {
	levels = {
		0.2,
		0.5,
		1
	},
	rapid_health_loss = {
		tick_time = 2,
		tick_loss_threshold = 0.2
	}
}
DialogueSettings.heard_speak_default_distance = 25
DialogueSettings.max_hear_distance = math.max(DialogueSettings.heard_speak_default_distance, DialogueSettings.knocked_down_broadcast_range, DialogueSettings.pounced_down_broadcast_range, DialogueSettings.death_discover_distance)

return DialogueSettings
