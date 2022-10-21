local XboxLivePlatformAchievements = {
	backend_to_platform = {
		boss_fast_1 = 17,
		fast_blocks_1 = 14,
		fast_enemies_1 = 18,
		flawless_team = 19,
		assists_1 = 20,
		consecutive_headshots = 16,
		path_of_trust_1 = 2,
		hack_perfect = 23,
		prologue = 1,
		flawless_mission_1 = 13,
		consecutive_dodge_1 = 15
	},
	show_progress = {
		[36.0] = true,
		[15.0] = true,
		[16.0] = true,
		[24.0] = true,
		[20.0] = true,
		[37.0] = true,
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
