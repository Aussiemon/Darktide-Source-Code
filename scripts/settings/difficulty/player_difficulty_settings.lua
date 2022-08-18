local player_difficulty_settings = {
	wounds = {
		veteran = {
			4,
			3,
			3,
			2,
			2
		},
		ogryn = {
			5,
			4,
			4,
			3,
			3
		},
		zealot = {
			4,
			3,
			3,
			2,
			2
		},
		psyker = {
			4,
			3,
			3,
			2,
			2
		}
	}
}

return settings("PlayerDifficultySettings", player_difficulty_settings)
