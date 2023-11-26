-- chunkname: @scripts/settings/equipment/flashlight_templates.lua

local default_flicker = {
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
local flashlight_templates = {}

flashlight_templates.default = {
	light = {
		first_person = {
			intensity = 12,
			cast_shadows = true,
			spot_reflector = false,
			color_temperature = 8000,
			volumetric_intensity = 0.1,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_02",
			spot_angle = {
				max = 1.1,
				min = 0
			},
			falloff = {
				far = 70,
				near = 0
			}
		},
		third_person = {
			intensity = 12,
			cast_shadows = true,
			spot_reflector = false,
			color_temperature = 8000,
			volumetric_intensity = 0.6,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_02",
			spot_angle = {
				max = 0.8,
				min = 0
			},
			falloff = {
				far = 30,
				near = 0
			}
		}
	},
	flicker = default_flicker
}
flashlight_templates.killshot = {
	light = {
		first_person = {
			spot_reflector = false,
			intensity = 12,
			color_temperature = 8000,
			cast_shadows = true,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_02",
			volumetric_intensity = 0.1,
			spot_angle = {
				max = 1.1,
				min = 0
			},
			falloff = {
				far = 70,
				near = 0
			},
			flicker = default_flicker
		},
		third_person = {
			spot_reflector = false,
			intensity = 12,
			color_temperature = 8000,
			cast_shadows = true,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_02",
			volumetric_intensity = 0.6,
			spot_angle = {
				max = 0.8,
				min = 0
			},
			falloff = {
				far = 30,
				near = 0
			},
			flicker = default_flicker
		}
	},
	flicker = default_flicker
}
flashlight_templates.assault = {
	light = {
		first_person = {
			spot_reflector = false,
			intensity = 20,
			color_temperature = 7000,
			cast_shadows = true,
			ies_profile = "content/environment/ies_profiles/narrow/narrow_05",
			volumetric_intensity = 0.1,
			spot_angle = {
				max = 1.1,
				min = 0
			},
			falloff = {
				far = 45,
				near = 0
			},
			flicker = default_flicker
		},
		third_person = {
			spot_reflector = false,
			intensity = 20,
			color_temperature = 7000,
			cast_shadows = true,
			ies_profile = "content/environment/ies_profiles/narrow/narrow_05",
			volumetric_intensity = 0.6,
			spot_angle = {
				max = 1.1,
				min = 0
			},
			falloff = {
				far = 25,
				near = 0
			},
			flicker = default_flicker
		}
	},
	flicker = default_flicker
}

return settings("FlashlightTemplates", flashlight_templates)
