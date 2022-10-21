local player_difficulty_settings = {
	specialization_wounds = {
		none = {
			1,
			1,
			1,
			1,
			1
		},
		veteran_2 = {
			4,
			3,
			3,
			2,
			2
		},
		ogryn_2 = {
			5,
			4,
			4,
			3,
			3
		},
		zealot_2 = {
			4,
			3,
			3,
			2,
			2
		},
		psyker_2 = {
			4,
			3,
			3,
			2,
			2
		}
	}
}

return settings("PlayerDifficultySettings", player_difficulty_settings)
