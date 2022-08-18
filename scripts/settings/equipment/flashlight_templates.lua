local flashlight_templates = {
	default = {
		spot_reflector = false,
		cast_shadows = true,
		intensity = 10,
		volumetric_intensity = 0.1,
		spot_angle = {
			max = 35,
			min = 0
		},
		falloff = {
			far = 70,
			near = 0
		}
	}
}

return settings("FlashlightTemplates", flashlight_templates)
