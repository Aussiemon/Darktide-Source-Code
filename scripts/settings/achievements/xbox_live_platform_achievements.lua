local XboxLivePlatformAchievements = {
	backend_to_platform = {
		path_of_trust_1 = 2,
		unlock_contracts = 10,
		unlock_gadgets = 9,
		ogryn_2_killed_corruptor_with_grenade_impact = 26,
		hack_perfect = 23,
		mission_difficulty_objectives_4 = 22,
		mission_difficulty_objectives_2 = 21,
		flawless_mission_2 = 13,
		path_of_trust_5 = 7,
		psyker_2_perils_of_the_warp_elite_kills = 34,
		zelot_2_kill_mutant_charger_with_melee_while_dashing = 35,
		consecutive_dodge_2 = 15,
		consecutive_headshots = 16,
		assists_3 = 20,
		path_of_trust_4 = 6,
		flawless_team = 19,
		fast_enemies_2 = 18,
		psyker_2_edge_kills_last_2_sec = 32,
		enemies_2 = 24,
		veteran_2_no_melee_damage_taken = 31,
		path_of_trust_6 = 8,
		ogryn_2_bull_rushed_100_enemies = 28,
		zealot_2_kills_of_shocked_enemies_last_15 = 37,
		multi_class_1 = 11,
		zealot_2_stagger_sniper_with_grenade_distance = 36,
		prologue = 1,
		fast_blocks_2 = 14,
		path_of_trust_3 = 5,
		veteran_2_weakspot_hits_during_volley_fire_alternate_fire = 30,
		veteran_2_unbounced_grenade_kills = 29,
		psyker_2_smite_hound_mid_leap = 33,
		banish_daemonhost = 25,
		path_of_trust_2 = 4,
		ogryn_2_bull_rushed_charging_ogryn = 27,
		multi_class_2 = 12,
		boss_fast_2 = 17
	},
	show_progress = {
		[36.0] = true,
		[15.0] = true,
		[16.0] = true,
		[37.0] = true,
		[20.0] = true,
		[24.0] = true,
		[28.0] = true,
		[32.0] = true,
		[14.0] = true
	},
	platform_to_backend = {}
}

for backend_id, platform_id in pairs(XboxLivePlatformAchievements.backend_to_platform) do
	XboxLivePlatformAchievements.platform_to_backend[platform_id] = backend_id
end

return XboxLivePlatformAchievements
