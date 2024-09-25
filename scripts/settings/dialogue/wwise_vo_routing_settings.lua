-- chunkname: @scripts/settings/dialogue/wwise_vo_routing_settings.lua

local wwise_vo_routing_settings = {}

wwise_vo_routing_settings[0] = {
	display_name = "Player Voice",
	is_default = true,
	local_player_routing_key = 3,
	wwise_event_path = "wwise/events/vo/play_sfx_es_player_vo",
	wwise_sound_source = "es_vo_prio_1",
}
wwise_vo_routing_settings[1] = {
	display_name = "2D Vox Voice",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_mission_giver_vo",
	wwise_sound_source = "es_mission_giver_vo",
}
wwise_vo_routing_settings[2] = {
	display_name = "Enemy Voice",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_enemy_vo",
	wwise_sound_source = "es_enemy_vo",
}
wwise_vo_routing_settings[3] = {
	display_name = "Local Player Voice",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_player_vo_2d",
	wwise_sound_source = "es_player_vo_2d",
}
wwise_vo_routing_settings[4] = {
	display_name = "DEPRECATED DO NOT USE",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_player_vo_2d",
	wwise_sound_source = "es_player_vo_2d",
}
wwise_vo_routing_settings[5] = {
	display_name = "Cutscene VO 3D",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_cutscene_vo",
	wwise_sound_source = "es_cutscene_vo",
}
wwise_vo_routing_settings[6] = {
	display_name = "Elite Chaos Ogryn Executor",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_chaos_ogryn_executor_vo",
	wwise_sound_source = "es_chaos_ogryn_executor_vo",
}
wwise_vo_routing_settings[7] = {
	display_name = "Named Captain",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_captain_vo",
	wwise_sound_source = "es_traitor_captain_vo",
}
wwise_vo_routing_settings[8] = {
	display_name = "Elite Chaos Ogryn Heavy Gunner",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_chaos_ogryn_heavy_gunner_vo",
	wwise_sound_source = "es_chaos_ogryn_heavy_gunner_vo",
}
wwise_vo_routing_settings[9] = {
	display_name = "Elite Chaos Ogryn Bulwark",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_chaos_ogryn_bulwark_vo",
	wwise_sound_source = "es_chaos_ogryn_bulwark_vo",
}
wwise_vo_routing_settings[10] = {
	display_name = "Elite Traitor Executor",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_enforcer_executor_vo",
	wwise_sound_source = "es_traitor_enforcer_executor_vo",
}
wwise_vo_routing_settings[11] = {
	display_name = "Elite Traitor Gunner",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_gunner_vo",
	wwise_sound_source = "es_traitor_gunner_vo",
}
wwise_vo_routing_settings[12] = {
	display_name = "Elite Traitor Shocktrooper",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_scout_shocktrooper_vo",
	wwise_sound_source = "es_traitor_scout_shocktrooper_vo",
}
wwise_vo_routing_settings[13] = {
	display_name = "Elite Traitor Grenadier",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_grenadier_vo",
	wwise_sound_source = "es_traitor_grenadier_vo",
}
wwise_vo_routing_settings[14] = {
	display_name = "Elite Traitor Netgunner",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_netgunner_vo",
	wwise_sound_source = "es_traitor_netgunner_vo",
}
wwise_vo_routing_settings[15] = {
	display_name = "Witch Daemonhost",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_daemonhost_vo",
	wwise_sound_source = "es_daemonhost_vo",
}
wwise_vo_routing_settings[16] = {
	display_name = "Roamer Traitor Trenchfighter",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_guard_trenchfighter_vo",
	wwise_sound_source = "es_traitor_guard_trenchfighter_vo",
}
wwise_vo_routing_settings[17] = {
	display_name = "Roamer Traitor SMG Rusher",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_guard_smg_rusher_vo",
	wwise_sound_source = "es_traitor_guard_smg_rusher_vo",
}
wwise_vo_routing_settings[18] = {
	display_name = "Roamer Traitor Rifleman",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_guard_rifleman_vo",
	wwise_sound_source = "es_traitor_guard_rifleman_vo",
}
wwise_vo_routing_settings[19] = {
	display_name = "Generic NPC",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_npc_vo",
	wwise_sound_source = "es_npc_vo",
}
wwise_vo_routing_settings[20] = {
	display_name = "Chaos Newly Infected",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_enemy_chaos_newly_infected_vo",
	wwise_sound_source = "es_enemy_chaos_newly_infected_vo",
}
wwise_vo_routing_settings[21] = {
	display_name = "Tech Priest 2D Vox Voice",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_mission_giver_tech_priest_vo",
	wwise_sound_source = "es_mission_giver_tech_priest_vo",
}
wwise_vo_routing_settings[22] = {
	display_name = "Vocator A - Speaker",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_vocator_vo",
	wwise_sound_source = "es_vocator_vo",
}
wwise_vo_routing_settings[23] = {
	display_name = "Special Cultist Flamer",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_cultist_flamer_vo",
	wwise_sound_source = "es_cultist_flamer_vo",
}
wwise_vo_routing_settings[24] = {
	display_name = "Player Ability VO",
	is_default = false,
	local_player_routing_key = 35,
	wwise_event_path = "wwise/events/vo/play_sfx_es_ability_vo",
	wwise_sound_source = "es_ability_vo",
}
wwise_vo_routing_settings[25] = {
	display_name = "Special Cultist Grenadier",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_cultist_grenadier_vo",
	wwise_sound_source = "es_cultist_grenadier_vo",
}
wwise_vo_routing_settings[26] = {
	display_name = "Elite Cultist Gunner",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_cultist_gunner_vo",
	wwise_sound_source = "es_cultist_gunner_vo",
}
wwise_vo_routing_settings[27] = {
	display_name = "Elite Cultist Shocktrooper",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_cultist_shocktrooper_vo",
	wwise_sound_source = "es_cultist_shocktrooper_vo",
}
wwise_vo_routing_settings[28] = {
	display_name = "Elite Cultist Berzerker",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_cultist_berzerker_vo",
	wwise_sound_source = "es_cultist_berzerker_vo",
}
wwise_vo_routing_settings[29] = {
	display_name = "Player Ability VO dly",
	is_default = false,
	local_player_routing_key = 36,
	wwise_event_path = "wwise/events/vo/play_sfx_es_ability_vo_dly",
	wwise_sound_source = "es_ability_vo_dly",
}
wwise_vo_routing_settings[30] = {
	display_name = "Player Ability VO dly+rev",
	is_default = false,
	local_player_routing_key = 37,
	wwise_event_path = "wwise/events/vo/play_sfx_es_ability_vo_dly_rev",
	wwise_sound_source = "es_ability_vo_dly_rev",
}
wwise_vo_routing_settings[31] = {
	display_name = "Player Ability VO rev",
	is_default = false,
	local_player_routing_key = 38,
	wwise_event_path = "wwise/events/vo/play_sfx_es_ability_vo_rev",
	wwise_sound_source = "es_ability_vo_rev",
}
wwise_vo_routing_settings[32] = {
	display_name = "Daemonhost Priority VO",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_daemonhost_priority_vo",
	wwise_sound_source = "es_daemonhost_priority_vo",
}
wwise_vo_routing_settings[33] = {
	display_name = "Roamer Cultist Rusher",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_cultist_rusher_vo",
	wwise_sound_source = "es_cultist_rusher_vo",
}
wwise_vo_routing_settings[34] = {
	display_name = "Roamer Cultist Melee",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_cultist_melee_vo",
	wwise_sound_source = "es_cultist_melee_vo",
}
wwise_vo_routing_settings[35] = {
	display_name = "Player Ability VO 2d",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_ability_vo_2d",
	wwise_sound_source = "es_ability_vo_2d",
}
wwise_vo_routing_settings[36] = {
	display_name = "Player Ability VO dly 2d",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_ability_vo_dly_2d",
	wwise_sound_source = "es_ability_vo_dly_2d",
}
wwise_vo_routing_settings[37] = {
	display_name = "Player Ability VO dly+rev 2d",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_ability_vo_dly_rev_2d",
	wwise_sound_source = "es_ability_vo_dly_rev_2d",
}
wwise_vo_routing_settings[38] = {
	display_name = "Player Ability VO rev 2d",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_ability_vo_rev_2d",
	wwise_sound_source = "es_ability_vo_rev_2d",
}
wwise_vo_routing_settings[39] = {
	display_name = "Named Captain Important",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_captain_vo_important",
	wwise_sound_source = "es_traitor_captain_vo_important",
}
wwise_vo_routing_settings[40] = {
	display_name = "VO for UI or menu",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_menu_vo",
	wwise_sound_source = "es_menu_vo",
}
wwise_vo_routing_settings[41] = {
	display_name = "Mission Briefing VO",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_mission_briefing_vo",
	wwise_sound_source = "es_mission_briefing_vo",
}
wwise_vo_routing_settings[42] = {
	display_name = "Training Ground Psyker VO",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_training_ground_psyker_vo",
	wwise_sound_source = "es_training_ground_psyker_vo",
}
wwise_vo_routing_settings[43] = {
	display_name = "Chaos Newly Infected Assault VO",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_enemy_chaos_newly_infected_assault_vo",
	wwise_sound_source = "es_enemy_chaos_newly_infected_assault_vo",
}
wwise_vo_routing_settings[44] = {
	display_name = "Special Traitor Flamer VO",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_guard_flamer_vo",
	wwise_sound_source = "es_traitor_guard_flamer_vo",
}
wwise_vo_routing_settings[45] = {
	display_name = "Medicae Servitor VO",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_medicae_servitor_vo",
	wwise_sound_source = "es_medicae_servitor_vo",
}
wwise_vo_routing_settings[46] = {
	display_name = "Elite Cultist Berzerker Assault",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_cultist_berzerker_assault_vo",
	wwise_sound_source = "es_cultist_berzerker_assault_vo",
}
wwise_vo_routing_settings[47] = {
	display_name = "Elite Traitor Berzerker VO",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_berzerker_vo",
	wwise_sound_source = "es_traitor_berzerker_vo",
}
wwise_vo_routing_settings[48] = {
	display_name = "Elite Traitor Berzerker Assault",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_berzerker_assault_vo",
	wwise_sound_source = "es_traitor_berzerker_assault_vo",
}
wwise_vo_routing_settings[49] = {
	display_name = "Special Cultist Grenadier Skulking",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_cultist_grenadier_skulking_vo",
	wwise_sound_source = "es_cultist_grenadier_skulking_vo",
}
wwise_vo_routing_settings[50] = {
	display_name = "NPC Mission VO",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_npc_mission_vo",
	wwise_sound_source = "es_npc_mission_vo",
}
wwise_vo_routing_settings[51] = {
	display_name = "Captain Twin VO",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_traitor_captain_vo_important_twin",
	wwise_sound_source = "es_traitor_captain_vo_important_twin",
}
wwise_vo_routing_settings[52] = {
	display_name = "Warp Echo VO",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_warp_echo_vo",
	wwise_sound_source = "es_warp_echo",
}
wwise_vo_routing_settings[53] = {
	display_name = "NPC Mission Giver VO",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_npc_mission_giver_vo",
	wwise_sound_source = "es_npc_mission_giver_vo",
}
wwise_vo_routing_settings[54] = {
	display_name = "NPC PA VO",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_npc_pa_vo",
	wwise_sound_source = "es_npc_pa_vo",
}
wwise_vo_routing_settings[55] = {
	display_name = "Named Cultist Captain Important",
	is_default = false,
	wwise_event_path = "wwise/events/vo/play_sfx_es_cultist_captain_vo_important",
	wwise_sound_source = "es_cultist_captain_vo_important",
}

return settings("wwise_vo_routing_settings", wwise_vo_routing_settings)
