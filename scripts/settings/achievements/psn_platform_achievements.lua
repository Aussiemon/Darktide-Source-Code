-- chunkname: @scripts/settings/achievements/psn_platform_achievements.lua

local PSNPlatformAchievements = {}

PSNPlatformAchievements.backend_to_platform = {
	path_of_trust_1 = 2,
	unlock_contracts = 9,
	unlock_gadgets = 8,
	ogryn_2_killed_corruptor_with_grenade_impact = 25,
	hack_perfect = 22,
	mission_difficulty_objectives_4 = 21,
	mission_difficulty_objectives_2 = 20,
	flawless_mission_2 = 12,
	path_of_trust_5 = 6,
	psyker_2_perils_of_the_warp_elite_kills = 33,
	zelot_2_kill_mutant_charger_with_melee_while_dashing = 34,
	consecutive_dodge_2 = 14,
	consecutive_headshots = 15,
	assists_3 = 19,
	path_of_trust_4 = 5,
	flawless_team = 18,
	fast_enemies_2 = 17,
	psyker_2_edge_kills_last_2_sec = 31,
	enemies_2 = 23,
	veteran_2_no_melee_damage_taken = 30,
	path_of_trust_6 = 7,
	ogryn_2_bull_rushed_100_enemies = 27,
	zealot_2_kills_of_shocked_enemies_last_15 = 36,
	multi_class_1 = 10,
	zealot_2_stagger_sniper_with_grenade_distance = 35,
	prologue = 1,
	fast_blocks_2 = 13,
	path_of_trust_3 = 4,
	veteran_2_weakspot_hits_during_volley_fire_alternate_fire = 29,
	veteran_2_unbounced_grenade_kills = 28,
	psyker_2_smite_hound_mid_leap = 32,
	banish_daemonhost = 24,
	path_of_trust_2 = 3,
	ogryn_2_bull_rushed_charging_ogryn = 26,
	multi_class_2 = 11,
	boss_fast_2 = 16
}
PSNPlatformAchievements.show_progress = {
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	true,
	true,
	true,
	true,
	nil,
	true,
	true,
	true,
	true,
	true,
	nil,
	true,
	nil,
	nil,
	nil,
	true,
	nil,
	nil,
	nil,
	true,
	[36] = true,
	[35] = true
}
PSNPlatformAchievements.platform_to_backend = {}

for backend_id, platform_id in pairs(PSNPlatformAchievements.backend_to_platform) do
	PSNPlatformAchievements.platform_to_backend[platform_id] = backend_id
end

return PSNPlatformAchievements
