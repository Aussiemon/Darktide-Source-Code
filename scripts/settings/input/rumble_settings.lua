local rumble_settings = {
	reload_start = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.2,
				sustain = 1,
				sustain_level = 0.1,
				attack = 0.3,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.1,
				sustain = 1,
				sustain_level = 0.2,
				attack = 0.3,
				frequency = 0,
				period = math.huge
			}
		}
	},
	handgun_fire = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 1,
				sustain = 0.25,
				sustain_level = 0.5,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 1,
				sustain = 0.25,
				sustain_level = 0.5,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			}
		}
	}
}

return settings("RumbleSettings", rumble_settings)
