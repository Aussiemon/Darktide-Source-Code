LightControllerFlickerSettings = LightControllerFlickerSettings or {}
LightControllerFlickerSettings.default = {
	octaves = 5,
	frequency_multiplier = 1,
	min_value = 0.1,
	persistance = 1,
	translation = {
		jitter_multiplier_z = 0,
		octaves = 0,
		frequency_multiplier = 0,
		jitter_multiplier_xy = 0,
		persistance = 0
	}
}
LightControllerFlickerSettings.default2 = {
	octaves = 2,
	frequency_multiplier = 1,
	min_value = 0.2,
	persistance = 2,
	translation = {
		jitter_multiplier_z = 0,
		octaves = 0,
		frequency_multiplier = 0,
		jitter_multiplier_xy = 0,
		persistance = 0
	}
}
LightControllerFlickerSettings.moving_expensive = {
	octaves = 5,
	frequency_multiplier = 1,
	min_value = 0.1,
	persistance = 1,
	translation = {
		jitter_multiplier_z = 0,
		octaves = 5,
		frequency_multiplier = 1,
		jitter_multiplier_xy = 1,
		persistance = 1
	}
}

return LightControllerFlickerSettings
