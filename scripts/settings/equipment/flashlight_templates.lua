-- chunkname: @scripts/settings/equipment/flashlight_templates.lua

local default_flicker = {
	chance = 0.35,
	fade_out = true,
	frequence_multiplier = 2,
	min_octave_percentage = 0.25,
	octaves = 8,
	persistance = 3,
	duration = {
		max = 3,
		min = 2,
	},
	interval = {
		max = 30,
		min = 15,
	},
}
local flashlight_templates = {}

flashlight_templates.default = {
	light = {
		first_person = {
			cast_shadows = true,
			color_temperature = 8000,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_02",
			intensity = 12,
			spot_reflector = false,
			volumetric_intensity = 0.1,
			spot_angle = {
				max = 1.1,
				min = 0,
			},
			falloff = {
				far = 70,
				near = 0,
			},
		},
		third_person = {
			cast_shadows = true,
			color_temperature = 8000,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_02",
			intensity = 12,
			spot_reflector = false,
			volumetric_intensity = 0.6,
			spot_angle = {
				max = 0.8,
				min = 0,
			},
			falloff = {
				far = 30,
				near = 0,
			},
		},
	},
	flicker = default_flicker,
}
flashlight_templates.killshot = {
	light = {
		first_person = {
			cast_shadows = true,
			color_temperature = 8000,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_02",
			intensity = 12,
			spot_reflector = false,
			volumetric_intensity = 0.1,
			spot_angle = {
				max = 1.1,
				min = 0,
			},
			falloff = {
				far = 70,
				near = 0,
			},
			flicker = default_flicker,
		},
		third_person = {
			cast_shadows = true,
			color_temperature = 8000,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_02",
			intensity = 12,
			spot_reflector = false,
			volumetric_intensity = 0.6,
			spot_angle = {
				max = 0.8,
				min = 0,
			},
			falloff = {
				far = 30,
				near = 0,
			},
			flicker = default_flicker,
		},
	},
	flicker = default_flicker,
}
flashlight_templates.assault = {
	light = {
		first_person = {
			cast_shadows = true,
			color_temperature = 7000,
			ies_profile = "content/environment/ies_profiles/narrow/narrow_05",
			intensity = 20,
			spot_reflector = false,
			volumetric_intensity = 0.1,
			spot_angle = {
				max = 1.1,
				min = 0,
			},
			falloff = {
				far = 45,
				near = 0,
			},
			flicker = default_flicker,
		},
		third_person = {
			cast_shadows = true,
			color_temperature = 7000,
			ies_profile = "content/environment/ies_profiles/narrow/narrow_05",
			intensity = 20,
			spot_reflector = false,
			volumetric_intensity = 0.6,
			spot_angle = {
				max = 1.1,
				min = 0,
			},
			falloff = {
				far = 25,
				near = 0,
			},
			flicker = default_flicker,
		},
	},
	flicker = default_flicker,
}

return settings("FlashlightTemplates", flashlight_templates)
