local SteamPlatformAchievements = {
	backend_to_platform = {
		boss_fast_1 = "boss_fast_1",
		fast_blocks_1 = "fast_blocks_1",
		fast_enemies_1 = "fast_enemies_1",
		flawless_team = "flawless_team",
		assists_1 = "assists_1",
		consecutive_headshots = "consecutive_headshots",
		path_of_trust_1 = "path_of_trust_1",
		hack_perfect = "hack_perfect",
		prologue = "prologue",
		flawless_mission_1 = "flawless_mission_1",
		consecutive_dodge_1 = "consecutive_dodge_1"
	},
	platform_to_stat = {
		consecutive_headshots = "max_head_shot_in_a_row",
		consecutive_dodge_1 = "max_dodges_in_a_row",
		assists_1 = "total_player_assists",
		fast_blocks_1 = "max_damage_blocked_last_20_sec"
	},
	platform_to_backend = {}
}

for backend_id, platform_id in pairs(SteamPlatformAchievements.backend_to_platform) do
	SteamPlatformAchievements.platform_to_backend[platform_id] = backend_id
end

return SteamPlatformAchievements
