-- chunkname: @scripts/settings/dialogue/wwise_actor_mixer_effect_settings.lua

local wwise_actor_mixer_effect_settings = {
	nodes = {
		first_person = 829615387,
		third_person = 251258888,
	},
	slots = {
		slot_0 = 0,
		slot_1 = 1,
		slot_2 = 2,
		slot_3 = 3,
	},
	effects = {
		convulsion_tube = 2770168059,
		distortion = 3517175118,
		futzbox = 2539875412,
		harmonizer = 41385646,
		radio = 1900893695,
		robo = 3059733992,
		tremolo = 3427672561,
		tube = 2689776681,
		voicebox = 3168121006,
	},
	presets = {
		default = {
			slot_0 = "voicebox",
			slot_1 = "robo",
			slot_2 = "futzbox",
		},
		tube_distortion = {
			slot_0 = "convulsion_tube",
			slot_1 = "tube",
			slot_2 = "distortion",
		},
	},
}

return settings("WwiseActorMixerEffectSettings", wwise_actor_mixer_effect_settings)
