-- chunkname: @scripts/settings/components/light_controller_flicker.lua

LightControllerFlickerSettings = LightControllerFlickerSettings or {}
LightControllerFlickerSettings.default = {
	frequency_multiplier = 1,
	min_value = 0.1,
	octaves = 5,
	persistance = 1,
	translation = {
		frequency_multiplier = 0,
		jitter_multiplier_xy = 0,
		jitter_multiplier_z = 0,
		octaves = 0,
		persistance = 0,
	},
}
LightControllerFlickerSettings.default2 = {
	frequency_multiplier = 1,
	min_value = 0.2,
	octaves = 2,
	persistance = 2,
	translation = {
		frequency_multiplier = 0,
		jitter_multiplier_xy = 0,
		jitter_multiplier_z = 0,
		octaves = 0,
		persistance = 0,
	},
}
LightControllerFlickerSettings.moving_expensive = {
	frequency_multiplier = 1,
	min_value = 0.1,
	octaves = 5,
	persistance = 1,
	translation = {
		frequency_multiplier = 1,
		jitter_multiplier_xy = 1,
		jitter_multiplier_z = 0,
		octaves = 5,
		persistance = 1,
	},
}

return LightControllerFlickerSettings
