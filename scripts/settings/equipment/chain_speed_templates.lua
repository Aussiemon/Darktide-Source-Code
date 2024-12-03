-- chunkname: @scripts/settings/equipment/chain_speed_templates.lua

local chain_speed_templates = {}

chain_speed_templates.chainaxe = {
	intensity_epsilon = 0.01,
	time_until_max_throttle = 0.3,
	time_until_min_throttle = 2.1,
	animation = {
		max = 100,
		min = 1,
	},
	sound = {
		max = 1,
		min = 0,
	},
	max_intensity = {
		activated = 1,
		activated_sawing = 1,
		idle = 1,
		sawing = 1,
	},
	intensity_variation = {
		activated = 0.2,
		activated_sawing = 0.2,
		idle = 0.05,
		sawing = 0.1,
	},
	haptic_vibration_intensity = {
		max = 35,
		min = 0,
	},
}
chain_speed_templates.chainsword = {
	intensity_epsilon = 0.01,
	time_until_max_throttle = 0.3,
	time_until_min_throttle = 2.1,
	animation = {
		max = 100,
		min = 1,
	},
	sound = {
		max = 1,
		min = 0,
	},
	max_intensity = {
		activated = 1,
		activated_sawing = 1,
		idle = 1,
		sawing = 1,
	},
	intensity_variation = {
		activated = 0.2,
		activated_sawing = 0.2,
		idle = 0.05,
		sawing = 0.1,
	},
	haptic_vibration_intensity = {
		max = 40,
		min = 0,
	},
}
chain_speed_templates.chainsword_2h = {
	intensity_epsilon = 0.01,
	time_until_max_throttle = 0.3,
	time_until_min_throttle = 2.1,
	animation = {
		max = 100,
		min = 1,
	},
	sound = {
		max = 1,
		min = 0,
	},
	max_intensity = {
		activated = 1,
		activated_sawing = 1,
		idle = 1,
		sawing = 1,
	},
	intensity_variation = {
		activated = 0.2,
		activated_sawing = 0.2,
		idle = 0.05,
		sawing = 0.1,
	},
	haptic_vibration_intensity = {
		max = 30,
		min = 0,
	},
}

return settings("ChainSpeedTemplates", chain_speed_templates)
