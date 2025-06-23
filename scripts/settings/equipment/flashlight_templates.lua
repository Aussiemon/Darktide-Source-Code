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
local led_flicker = {
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
local incandescent_flicker = {
	min_octave_percentage = 0.25,
	frequence_multiplier = 0.5,
	persistance = 12,
	chance = 0.45,
	fade_out = true,
	octaves = 2,
	duration = {
		max = 4,
		min = 3
	},
	interval = {
		max = 20,
		min = 10
	}
}
local worn_incandescent_flicker = {
	min_octave_percentage = 0.35,
	frequence_multiplier = 0.75,
	persistance = 12,
	chance = 0.5,
	fade_out = true,
	octaves = 3,
	duration = {
		max = 4,
		min = 2.5
	},
	interval = {
		max = 20,
		min = 10
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
flashlight_templates.lasgun_p1 = {
	light = {
		first_person = {
			intensity = 8,
			cast_shadows = true,
			spot_reflector = false,
			color_temperature = 7300,
			volumetric_intensity = 0.1,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_01",
			spot_angle = {
				max = 1.3,
				min = 0
			},
			falloff = {
				far = 70,
				near = 0
			}
		},
		third_person = {
			intensity = 8,
			cast_shadows = true,
			spot_reflector = false,
			color_temperature = 7000,
			volumetric_intensity = 0.6,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_01",
			spot_angle = {
				max = 0.9,
				min = 0
			},
			falloff = {
				far = 30,
				near = 0
			}
		}
	},
	flicker = led_flicker
}
flashlight_templates.lasgun_p3 = {
	light = {
		first_person = {
			intensity = 10,
			cast_shadows = true,
			spot_reflector = false,
			color_temperature = 7900,
			volumetric_intensity = 0.1,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_01",
			spot_angle = {
				max = 1.2,
				min = 0
			},
			falloff = {
				far = 70,
				near = 0
			}
		},
		third_person = {
			intensity = 10,
			cast_shadows = true,
			spot_reflector = false,
			color_temperature = 7500,
			volumetric_intensity = 0.6,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_01",
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
	flicker = led_flicker
}
flashlight_templates.autogun_p1 = {
	light = {
		first_person = {
			intensity = 18,
			cast_shadows = true,
			spot_reflector = false,
			color_temperature = 6200,
			volumetric_intensity = 0.1,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_03",
			spot_angle = {
				max = 1.1,
				min = 0
			},
			falloff = {
				far = 45,
				near = 0
			}
		},
		third_person = {
			intensity = 18,
			cast_shadows = true,
			spot_reflector = false,
			color_temperature = 6200,
			volumetric_intensity = 0.6,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_03",
			spot_angle = {
				max = 0.8,
				min = 0
			},
			falloff = {
				far = 25,
				near = 0
			}
		}
	},
	flicker = incandescent_flicker
}
flashlight_templates.autopistol_p1 = {
	light = {
		first_person = {
			intensity = 16,
			cast_shadows = true,
			spot_reflector = false,
			color_temperature = 5900,
			volumetric_intensity = 0.1,
			ies_profile = "content/environment/ies_profiles/narrow/narrow_05",
			spot_angle = {
				max = 0.8,
				min = 0
			},
			falloff = {
				far = 45,
				near = 0
			}
		},
		third_person = {
			intensity = 16,
			cast_shadows = true,
			spot_reflector = false,
			color_temperature = 5900,
			volumetric_intensity = 0.6,
			ies_profile = "content/environment/ies_profiles/narrow/narrow_05",
			spot_angle = {
				max = 0.6,
				min = 0
			},
			falloff = {
				far = 25,
				near = 0
			}
		}
	},
	flicker = incandescent_flicker
}
flashlight_templates.ogryn_heavy_stubber_p2 = {
	light = {
		first_person = {
			intensity = 10,
			cast_shadows = true,
			spot_reflector = false,
			color_temperature = 4400,
			volumetric_intensity = 0.1,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_02",
			spot_angle = {
				max = 1.2,
				min = 0
			},
			falloff = {
				far = 35,
				near = 0
			}
		},
		third_person = {
			intensity = 10,
			cast_shadows = true,
			spot_reflector = false,
			color_temperature = 4400,
			volumetric_intensity = 0.6,
			ies_profile = "content/environment/ies_profiles/narrow/flashlight_custom_02",
			spot_angle = {
				max = 0.9,
				min = 0
			},
			falloff = {
				far = 20,
				near = 0
			}
		}
	},
	flicker = worn_incandescent_flicker
}

return settings("FlashlightTemplates", flashlight_templates)
