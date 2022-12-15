local wwise_vo_routing_settings = {
	[0] = {
		wwise_sound_source = "es_vo_prio_1",
		display_name = "Player Voice",
		is_default = true,
		wwise_event_path = "wwise/events/vo/play_sfx_es_player_vo",
		local_player_routing_key = 3
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_mission_giver_vo",
		display_name = "2D Vox Voice",
		wwise_sound_source = "es_mission_giver_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_enemy_vo",
		display_name = "Enemy Voice",
		wwise_sound_source = "es_enemy_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_player_vo_2d",
		display_name = "Local Player Voice",
		wwise_sound_source = "es_player_vo_2d"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_enemy_specials_vo",
		display_name = "Enemy VO - Specials/Elites",
		wwise_sound_source = "es_enemy_specials_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_cutscene_vo",
		display_name = "Cutscene VO 3D",
		wwise_sound_source = "es_cutscene_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_chaos_ogryn_executor_vo",
		display_name = "Elite Chaos Ogryn Executor",
		wwise_sound_source = "es_chaos_ogryn_executor_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_captain_vo",
		display_name = "Named Captain",
		wwise_sound_source = "es_traitor_captain_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_chaos_ogryn_heavy_gunner_vo",
		display_name = "Elite Chaos Ogryn Heavy Gunner",
		wwise_sound_source = "es_chaos_ogryn_heavy_gunner_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_chaos_ogryn_bulwark_vo",
		display_name = "Elite Chaos Ogryn Bulwark",
		wwise_sound_source = "es_chaos_ogryn_bulwark_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_enforcer_executor_vo",
		display_name = "Elite Traitor Executor",
		wwise_sound_source = "es_traitor_enforcer_executor_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_gunner_vo",
		display_name = "Elite Traitor Gunner",
		wwise_sound_source = "es_traitor_gunner_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_scout_shocktrooper_vo",
		display_name = "Elite Traitor Shocktrooper",
		wwise_sound_source = "es_traitor_scout_shocktrooper_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_grenadier_vo",
		display_name = "Elite Traitor Grenadier",
		wwise_sound_source = "es_traitor_grenadier_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_netgunner_vo",
		display_name = "Elite Traitor Netgunner",
		wwise_sound_source = "es_traitor_netgunner_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_daemonhost_vo",
		display_name = "Witch Daemonhost",
		wwise_sound_source = "es_daemonhost_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_guard_trenchfighter_vo",
		display_name = "Roamer Traitor Trenchfighter",
		wwise_sound_source = "es_traitor_guard_trenchfighter_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_guard_smg_rusher_vo",
		display_name = "Roamer Traitor SMG Rusher",
		wwise_sound_source = "es_traitor_guard_smg_rusher_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_guard_rifleman_vo",
		display_name = "Roamer Traitor Rifleman",
		wwise_sound_source = "es_traitor_guard_rifleman_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_npc_vo",
		display_name = "Generic NPC",
		wwise_sound_source = "es_npc_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_enemy_chaos_newly_infected_vo",
		display_name = "Chaos Newly Infected",
		wwise_sound_source = "es_enemy_chaos_newly_infected_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_mission_giver_tech_priest_vo",
		display_name = "Tech Priest 2D Vox Voice",
		wwise_sound_source = "es_mission_giver_tech_priest_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_vocator_vo",
		display_name = "Vocator A - Speaker",
		wwise_sound_source = "es_vocator_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_cultist_flamer_vo",
		display_name = "Special Cultist Flamer",
		wwise_sound_source = "es_cultist_flamer_vo"
	},
	{
		wwise_sound_source = "es_ability_vo",
		display_name = "Player Ability VO",
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_ability_vo",
		local_player_routing_key = 35
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_cultist_grenadier_vo",
		display_name = "Special Cultist Grenadier",
		wwise_sound_source = "es_cultist_grenadier_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_cultist_gunner_vo",
		display_name = "Elite Cultist Gunner",
		wwise_sound_source = "es_cultist_gunner_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_cultist_shocktrooper_vo",
		display_name = "Elite Cultist Shocktrooper",
		wwise_sound_source = "es_cultist_shocktrooper_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_cultist_berzerker_vo",
		display_name = "Elite Cultist Berzerker",
		wwise_sound_source = "es_cultist_berzerker_vo"
	},
	{
		wwise_sound_source = "es_ability_vo_dly",
		display_name = "Player Ability VO dly",
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_ability_vo_dly",
		local_player_routing_key = 36
	},
	{
		wwise_sound_source = "es_ability_vo_dly_rev",
		display_name = "Player Ability VO dly+rev",
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_ability_vo_dly_rev",
		local_player_routing_key = 37
	},
	{
		wwise_sound_source = "es_ability_vo_rev",
		display_name = "Player Ability VO rev",
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_ability_vo_rev",
		local_player_routing_key = 38
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_daemonhost_priority_vo",
		display_name = "Daemonhost Priority VO",
		wwise_sound_source = "es_daemonhost_priority_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_cultist_rusher_vo",
		display_name = "Roamer Cultist Rusher",
		wwise_sound_source = "es_cultist_rusher_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_cultist_melee_vo",
		display_name = "Roamer Cultist Melee",
		wwise_sound_source = "es_cultist_melee_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_ability_vo_2d",
		display_name = "Player Ability VO 2d",
		wwise_sound_source = "es_ability_vo_2d"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_ability_vo_dly_2d",
		display_name = "Player Ability VO dly 2d",
		wwise_sound_source = "es_ability_vo_dly_2d"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_ability_vo_dly_rev_2d",
		display_name = "Player Ability VO dly+rev 2d",
		wwise_sound_source = "es_ability_vo_dly_rev_2d"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_ability_vo_rev_2d",
		display_name = "Player Ability VO rev 2d",
		wwise_sound_source = "es_ability_vo_rev_2d"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_captain_vo_important",
		display_name = "Named Captain Important",
		wwise_sound_source = "es_traitor_captain_vo_important"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_menu_vo",
		display_name = "VO for UI or menu",
		wwise_sound_source = "es_menu_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_mission_briefing_vo",
		display_name = "Mission Briefing VO",
		wwise_sound_source = "es_mission_briefing_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_training_ground_psyker_vo",
		display_name = "Training Ground Psyker VO",
		wwise_sound_source = "es_training_ground_psyker_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_enemy_chaos_newly_infected_assault_vo",
		display_name = "Chaos Newly Infected Assault VO",
		wwise_sound_source = "es_enemy_chaos_newly_infected_assault_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_guard_flamer_vo",
		display_name = "Special Traitor Flamer VO",
		wwise_sound_source = "es_traitor_guard_flamer_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_medicae_servitor_vo",
		display_name = "Medicae Servitor VO",
		wwise_sound_source = "es_medicae_servitor_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_cultist_berzerker_assault_vo",
		display_name = "Elite Cultist Berzerker Assault",
		wwise_sound_source = "es_cultist_berzerker_assault_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_berzerker_vo",
		display_name = "Elite Traitor Berzerker VO",
		wwise_sound_source = "es_traitor_berzerker_vo"
	},
	{
		is_default = false,
		wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_berzerker_assault_vo",
		display_name = "Elite Traitor Berzerker Assault",
		wwise_sound_source = "es_traitor_berzerker_assault_vo"
	}
}

return settings("wwise_vo_routing_settings", wwise_vo_routing_settings)
