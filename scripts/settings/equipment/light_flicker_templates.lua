local light_flicker_templates = {
	default = {
		min_octave_percentage = 0.25,
		frequence_multiplier = 2,
		persistance = 3,
		chance = 0.35,
		fade_out = true,
		octaves = 8,
		duration = {
			max = 3,
			min = 2
		},
		interval = {
			max = 30,
			min = 15
		}
	}
}

return settings("LightFlickerTemplates", light_flicker_templates)
