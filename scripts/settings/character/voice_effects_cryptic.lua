-- chunkname: @scripts/settings/character/voice_effects_cryptic.lua

local voice_effect_cryptic = {
	matrix = {
		{
			display_name = "loc_cryptic_voice_effect_01",
			range = {
				max = 100,
				min = 0,
			},
		},
		{
			display_name = "loc_cryptic_voice_effect_02",
			range = {
				max = 100,
				min = 0,
			},
		},
	},
	slider = {
		display_name = "loc_cryptic_voice_effect_03",
		range = {
			max = 100,
			min = 0,
		},
	},
}

return settings("VoiceEffectsCryptic", voice_effect_cryptic)
