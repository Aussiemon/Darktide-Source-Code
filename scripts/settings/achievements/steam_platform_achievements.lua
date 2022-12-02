local SteamPlatformAchievements = {
	backend_to_platform = {
		path_of_trust_1 = "path_of_trust_1",
		unlock_contracts = "unlock_contracts",
		unlock_gadgets = "unlock_gadgets",
		ogryn_2_killed_corruptor_with_grenade_impact = "ogryn_2_killed_corruptor_with_grenade_impact",
		hack_perfect = "hack_perfect",
		mission_difficulty_objectives_4 = "mission_difficulty_objectives_4",
		mission_difficulty_objectives_2 = "mission_difficulty_objectives_2",
		flawless_mission_2 = "flawless_mission_2",
		path_of_trust_5 = "path_of_trust_5",
		psyker_2_perils_of_the_warp_elite_kills = "psyker_2_perils_of_the_warp_elite_kills",
		zelot_2_kill_mutant_charger_with_melee_while_dashing = "zelot_2_kill_mutant_charger_with_melee_while_dashing",
		consecutive_dodge_2 = "consecutive_dodge_2",
		consecutive_headshots = "consecutive_headshots",
		assists_3 = "assists_3",
		path_of_trust_4 = "path_of_trust_4",
		flawless_team = "flawless_team",
		fast_enemies_2 = "fast_enemies_2",
		psyker_2_edge_kills_last_2_sec = "psyker_2_edge_kills_last_2_sec",
		enemies_2 = "enemies_2",
		veteran_2_no_melee_damage_taken = "veteran_2_no_melee_damage_taken",
		path_of_trust_6 = "path_of_trust_6",
		ogryn_2_bull_rushed_100_enemies = "ogryn_2_bull_rushed_100_enemies",
		zealot_2_kills_of_shocked_enemies_last_15 = "zealot_2_kills_of_shocked_enemies_last_15",
		multi_class_1 = "multi_class_1",
		zealot_2_stagger_sniper_with_grenade_distance = "zealot_2_stagger_sniper_with_grenade_distance",
		prologue = "prologue",
		fast_blocks_2 = "fast_blocks_2",
		path_of_trust_3 = "path_of_trust_3",
		veteran_2_weakspot_hits_during_volley_fire_alternate_fire = "veteran_2_weakspot_hits_during_volley_fire_alternate_fire",
		veteran_2_unbounced_grenade_kills = "veteran_2_unbounced_grenade_kills",
		psyker_2_smite_hound_mid_leap = "psyker_2_smite_hound_mid_leap",
		banish_daemonhost = "banish_daemonhost",
		path_of_trust_2 = "path_of_trust_2",
		ogryn_2_bull_rushed_charging_ogryn = "ogryn_2_bull_rushed_charging_ogryn",
		multi_class_2 = "multi_class_2",
		boss_fast_2 = "boss_fast_2"
	},
	platform_to_stat = {
		flawless_mission_2 = "max_flawless_mission_in_a_row",
		ogryn_2_bull_rushed_100_enemies = "max_ogryn_2_lunge_number_of_enemies_hit",
		zealot_2_kills_of_shocked_enemies_last_15 = "max_zealot_2_kills_of_shocked_enemies_last_15",
		flawless_team = "team_flawless_missions",
		fast_enemies_2 = "max_kills_last_60_sec",
		enemies_2 = "total_kills",
		consecutive_dodge_2 = "max_dodges_in_a_row",
		psyker_2_edge_kills_last_2_sec = "max_psyker_2_edge_kills_last_2_sec",
		zealot_2_stagger_sniper_with_grenade_distance = "max_zealot_2_stagger_sniper_with_grenade_distance",
		mission_difficulty_objectives_2 = "mission_difficulty_2_objectives",
		mission_difficulty_objectives_4 = "mission_difficulty_4_objectives",
		fast_blocks_2 = "max_damage_blocked_last_20_sec",
		consecutive_headshots = "max_head_shot_in_a_row",
		assists_3 = "total_player_assists"
	},
	platform_to_backend = {}
}

for backend_id, platform_id in pairs(SteamPlatformAchievements.backend_to_platform) do
	SteamPlatformAchievements.platform_to_backend[platform_id] = backend_id
end

return SteamPlatformAchievements
