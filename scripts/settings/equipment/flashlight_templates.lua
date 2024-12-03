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
local led_flicker = {
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
local incandescent_flicker = {
	chance = 0.45,
	fade_out = true,
	frequence_multiplier = 0.5,
	min_octave_percentage = 0.25,
	octaves = 2,
	persistance = 12,
	duration = {
		max = 4,
		min = 3,
	},
	interval = {
		max = 20,
		min = 10,
	},
}
local worn_incandescent_flicker = {
	chance = 0.5,
	fade_out = true,
	frequence_multiplier = 0.75,
	min_octave_percentage = 0.35,
	octaves = 3,
	persistance = 12,
	duration = {
		max = 4,
		min = 2.5,
	},
	interval = {
		max = 20,
		min = 10,
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
flashlight_templates.lasgun_p1 = {
	light = {
		first_person = {
			cast_shadows = true,
			color_temperature = 7300,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_01",
			intensity = 8,
			spot_reflector = false,
			volumetric_intensity = 0.1,
			spot_angle = {
				max = 1.3,
				min = 0,
			},
			falloff = {
				far = 70,
				near = 0,
			},
		},
		third_person = {
			cast_shadows = true,
			color_temperature = 7000,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_01",
			intensity = 8,
			spot_reflector = false,
			volumetric_intensity = 0.6,
			spot_angle = {
				max = 0.9,
				min = 0,
			},
			falloff = {
				far = 30,
				near = 0,
			},
		},
	},
	flicker = led_flicker,
}
flashlight_templates.lasgun_p3 = {
	light = {
		first_person = {
			cast_shadows = true,
			color_temperature = 7900,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_01",
			intensity = 10,
			spot_reflector = false,
			volumetric_intensity = 0.1,
			spot_angle = {
				max = 1.2,
				min = 0,
			},
			falloff = {
				far = 70,
				near = 0,
			},
		},
		third_person = {
			cast_shadows = true,
			color_temperature = 7500,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_01",
			intensity = 10,
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
	flicker = led_flicker,
}
flashlight_templates.autogun_p1 = {
	light = {
		first_person = {
			cast_shadows = true,
			color_temperature = 6200,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_03",
			intensity = 18,
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
		},
		third_person = {
			cast_shadows = true,
			color_temperature = 6200,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_03",
			intensity = 18,
			spot_reflector = false,
			volumetric_intensity = 0.6,
			spot_angle = {
				max = 0.8,
				min = 0,
			},
			falloff = {
				far = 25,
				near = 0,
			},
		},
	},
	flicker = incandescent_flicker,
}
flashlight_templates.autopistol_p1 = {
	light = {
		first_person = {
			cast_shadows = true,
			color_temperature = 5900,
			ies_profile = "content/environment/ies_profiles/narrow/narrow_05",
			intensity = 16,
			spot_reflector = false,
			volumetric_intensity = 0.1,
			spot_angle = {
				max = 0.8,
				min = 0,
			},
			falloff = {
				far = 45,
				near = 0,
			},
		},
		third_person = {
			cast_shadows = true,
			color_temperature = 5900,
			ies_profile = "content/environment/ies_profiles/narrow/narrow_05",
			intensity = 16,
			spot_reflector = false,
			volumetric_intensity = 0.6,
			spot_angle = {
				max = 0.6,
				min = 0,
			},
			falloff = {
				far = 25,
				near = 0,
			},
		},
	},
	flicker = incandescent_flicker,
}
flashlight_templates.ogryn_heavy_stubber_p2 = {
	light = {
		first_person = {
			cast_shadows = true,
			color_temperature = 4400,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_02",
			intensity = 10,
			spot_reflector = false,
			volumetric_intensity = 0.1,
			spot_angle = {
				max = 1.2,
				min = 0,
			},
			falloff = {
				far = 35,
				near = 0,
			},
		},
		third_person = {
			cast_shadows = true,
			color_temperature = 4400,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_02",
			intensity = 10,
			spot_reflector = false,
			volumetric_intensity = 0.6,
			spot_angle = {
				max = 0.9,
				min = 0,
			},
			falloff = {
				far = 20,
				near = 0,
			},
		},
	},
	flicker = worn_incandescent_flicker,
}

return settings("FlashlightTemplates", flashlight_templates)
