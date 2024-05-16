-- chunkname: @scripts/settings/achievements/steam_platform_achievements.lua

local SteamPlatformAchievements = {}

SteamPlatformAchievements.backend_to_platform = {
	assists_3 = "assists_3",
	banish_daemonhost = "banish_daemonhost",
	boss_fast_2 = "boss_fast_2",
	consecutive_dodge_2 = "consecutive_dodge_2",
	consecutive_headshots = "consecutive_headshots",
	enemies_2 = "enemies_2",
	fast_blocks_2 = "fast_blocks_2",
	fast_enemies_2 = "fast_enemies_2",
	flawless_mission_2 = "flawless_mission_2",
	flawless_team = "flawless_team",
	hack_perfect = "hack_perfect",
	mission_difficulty_objectives_2 = "mission_difficulty_objectives_2",
	mission_difficulty_objectives_4 = "mission_difficulty_objectives_4",
	multi_class_1 = "multi_class_1",
	multi_class_2 = "multi_class_2",
	ogryn_2_bull_rushed_100_enemies = "ogryn_2_bull_rushed_100_enemies",
	ogryn_2_bull_rushed_charging_ogryn = "ogryn_2_bull_rushed_charging_ogryn",
	ogryn_2_killed_corruptor_with_grenade_impact = "ogryn_2_killed_corruptor_with_grenade_impact",
	path_of_trust_1 = "path_of_trust_1",
	path_of_trust_2 = "path_of_trust_2",
	path_of_trust_3 = "path_of_trust_3",
	path_of_trust_4 = "path_of_trust_4",
	path_of_trust_5 = "path_of_trust_5",
	path_of_trust_6 = "path_of_trust_6",
	prologue = "prologue",
	psyker_2_edge_kills_last_2_sec = "psyker_2_edge_kills_last_2_sec",
	psyker_2_perils_of_the_warp_elite_kills = "psyker_2_perils_of_the_warp_elite_kills",
	psyker_2_smite_hound_mid_leap = "psyker_2_smite_hound_mid_leap",
	unlock_contracts = "unlock_contracts",
	unlock_gadgets = "unlock_gadgets",
	veteran_2_no_melee_damage_taken = "veteran_2_no_melee_damage_taken",
	veteran_2_unbounced_grenade_kills = "veteran_2_unbounced_grenade_kills",
	veteran_2_weakspot_hits_during_volley_fire_alternate_fire = "veteran_2_weakspot_hits_during_volley_fire_alternate_fire",
	zealot_2_kills_of_shocked_enemies_last_15 = "zealot_2_kills_of_shocked_enemies_last_15",
	zealot_2_stagger_sniper_with_grenade_distance = "zealot_2_stagger_sniper_with_grenade_distance",
	zelot_2_kill_mutant_charger_with_melee_while_dashing = "zelot_2_kill_mutant_charger_with_melee_while_dashing",
}
SteamPlatformAchievements.platform_to_stat = {
	assists_3 = "total_player_assists",
	consecutive_dodge_2 = "max_dodges_in_a_row",
	consecutive_headshots = "max_head_shot_in_a_row",
	enemies_2 = "total_kills",
	fast_blocks_2 = "max_damage_blocked_last_20_sec",
	fast_enemies_2 = "max_kills_last_60_sec",
	flawless_mission_2 = "max_flawless_mission_in_a_row",
	flawless_team = "team_flawless_missions",
	mission_difficulty_objectives_2 = "mission_difficulty_2_objectives",
	mission_difficulty_objectives_4 = "mission_difficulty_4_objectives",
	ogryn_2_bull_rushed_100_enemies = "max_ogryn_2_lunge_number_of_enemies_hit",
	psyker_2_edge_kills_last_2_sec = "max_psyker_2_edge_kills_last_2_sec",
	zealot_2_kills_of_shocked_enemies_last_15 = "max_zealot_2_kills_of_shocked_enemies_last_15",
	zealot_2_stagger_sniper_with_grenade_distance = "max_zealot_2_stagger_sniper_with_grenade_distance",
}
SteamPlatformAchievements.platform_to_backend = {}

for backend_id, platform_id in pairs(SteamPlatformAchievements.backend_to_platform) do
	SteamPlatformAchievements.platform_to_backend[platform_id] = backend_id
end

return SteamPlatformAchievements
