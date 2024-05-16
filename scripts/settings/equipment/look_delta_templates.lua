-- chunkname: @scripts/settings/equipment/look_delta_templates.lua

local look_delta_templates = {}

look_delta_templates.default = {
	shooting = {
		deadzone_x = 0.025,
		deadzone_x_lerp_constant = 0.2,
		deadzone_y = 0.025,
		deadzone_y_lerp_constant = 0.2,
		delta_x_modifier = 1.5,
		delta_y_modifier = 1.5,
		lerp_constant_x_func = function (look_delta_x)
			return 0.9 * (0.15 + 0.85 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.9
		end,
	},
	idle = {
		deadzone_x = 0.025,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0.025,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 20,
		delta_y_modifier = -15,
		lerp_constant_x_func = function (look_delta_x)
			return 0.03 * (0.5 + 0.5 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.05
		end,
	},
	inspect = {
		deadzone_x = 0,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 3.3,
		delta_y_modifier = 2.5,
		lerp_constant_x_func = function (look_delta_x)
			return 0.1
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.1
		end,
	},
}
look_delta_templates.lasgun_rifle = {
	shooting = {
		deadzone_x = 0.025,
		deadzone_x_lerp_constant = 0.2,
		deadzone_y = 0.025,
		deadzone_y_lerp_constant = 0.2,
		delta_x_modifier = 75,
		delta_y_modifier = 25,
		pitch_multiplier = 0.2,
		yaw_multiplier = 0.2,
		lerp_constant_x_func = function (look_delta_x)
			return 0.75 * (0.5 + 0.5 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.75
		end,
	},
	idle = {
		deadzone_x = 0.025,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0.025,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 20,
		delta_y_modifier = 15,
		lerp_constant_x_func = function (look_delta_x)
			return 0.03 * (0.5 + 0.5 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.05
		end,
	},
	inspect = {
		deadzone_x = 0,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 3.3,
		delta_y_modifier = 2.5,
		lerp_constant_x_func = function (look_delta_x)
			return 0.1
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.1
		end,
	},
}
look_delta_templates.lasgun_p3_rifle = {
	shooting = {
		deadzone_x = 0.025,
		deadzone_x_lerp_constant = 1,
		deadzone_y = 0.025,
		deadzone_y_lerp_constant = 1,
		delta_x_modifier = -100,
		delta_y_modifier = 100,
		pitch_multiplier = 0.2,
		yaw_multiplier = 0.2,
		lerp_constant_x_func = function (look_delta_x)
			return 0.75 * (0.5 + 0.5 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.75
		end,
	},
	idle = {
		deadzone_x = 0.025,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0.025,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 20,
		delta_y_modifier = 15,
		lerp_constant_x_func = function (look_delta_x)
			return 0.03 * (0.5 + 0.5 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.05
		end,
	},
	inspect = {
		deadzone_x = 0,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 3.3,
		delta_y_modifier = 2.5,
		lerp_constant_x_func = function (look_delta_x)
			return 0.1
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.1
		end,
	},
}
look_delta_templates.laspistol = {
	shooting = {
		deadzone_x = 0.025,
		deadzone_x_lerp_constant = 0.2,
		deadzone_y = 0.025,
		deadzone_y_lerp_constant = 0.2,
		delta_x_modifier = 75,
		delta_y_modifier = 100,
		pitch_multiplier = 1,
		yaw_multiplier = 1,
		lerp_constant_x_func = function (look_delta_x)
			return 0.2 * (0.75 + 0.25 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.2
		end,
	},
	idle = {
		deadzone_x = 0.025,
		deadzone_x_lerp_constant = 0.08,
		deadzone_y = 0.025,
		deadzone_y_lerp_constant = 0.11,
		delta_x_modifier = 5,
		delta_y_modifier = 6,
		lerp_constant_x_func = function (look_delta_x)
			return 0.1 * (0.25 + 0.75 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.1 * (0.25 + 0.75 * (1 - math.min(math.abs(look_delta_y * look_delta_y), 1)))
		end,
	},
	inspect = {
		deadzone_x = 0,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 3.3,
		delta_y_modifier = 2.5,
		lerp_constant_x_func = function (look_delta_x)
			return 0.1
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.1
		end,
	},
}
look_delta_templates.bolter = {
	shooting = {
		deadzone_x = 0.025,
		deadzone_x_lerp_constant = 0.2,
		deadzone_y = 0.025,
		deadzone_y_lerp_constant = 0.2,
		delta_x_modifier = 75,
		delta_y_modifier = 50,
		pitch_multiplier = 1,
		yaw_multiplier = 1,
		lerp_constant_x_func = function (look_delta_x)
			return 0.85 * (0.25 + 0.75 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.85
		end,
	},
	idle = {
		deadzone_x = 0.025,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0.025,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 20,
		delta_y_modifier = 15,
		lerp_constant_x_func = function (look_delta_x)
			return 0.03 * (0.5 + 0.5 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.05
		end,
	},
	inspect = {
		deadzone_x = 0,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 3.3,
		delta_y_modifier = 2.5,
		lerp_constant_x_func = function (look_delta_x)
			return 0.1
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.1
		end,
	},
}
look_delta_templates.autogun = {
	shooting = {
		deadzone_x = 0.025,
		deadzone_x_lerp_constant = 0.2,
		deadzone_y = 0.025,
		deadzone_y_lerp_constant = 0.2,
		delta_x_modifier = 45,
		delta_y_modifier = 30,
		lerp_constant_x_func = function (look_delta_x)
			return 0.65 * (0.15 + 0.85 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.65
		end,
	},
	idle = {
		deadzone_x = 0.025,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0.025,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 20,
		delta_y_modifier = -15,
		lerp_constant_x_func = function (look_delta_x)
			return 0.03 * (0.5 + 0.5 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.05
		end,
	},
	inspect = {
		deadzone_x = 0,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 3.3,
		delta_y_modifier = 2.5,
		lerp_constant_x_func = function (look_delta_x)
			return 0.1
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.1
		end,
	},
}
look_delta_templates.autopistol = {
	shooting = {
		deadzone_x = 0.025,
		deadzone_x_lerp_constant = 0.2,
		deadzone_y = 0.025,
		deadzone_y_lerp_constant = 0.2,
		delta_x_modifier = 2.5,
		delta_y_modifier = 2.5,
		lerp_constant_x_func = function (look_delta_x)
			return 0.9 * (0.15 + 0.85 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.9
		end,
	},
	idle = {
		deadzone_x = 0.025,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0.025,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 20,
		delta_y_modifier = -15,
		lerp_constant_x_func = function (look_delta_x)
			return 0.03 * (0.5 + 0.5 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.05
		end,
	},
	inspect = {
		deadzone_x = 0,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 3.3,
		delta_y_modifier = 2.5,
		lerp_constant_x_func = function (look_delta_x)
			return 0.1
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.1
		end,
	},
}
look_delta_templates.stub_pistol = {
	shooting = {
		deadzone_x = 0.025,
		deadzone_x_lerp_constant = 0.2,
		deadzone_y = 0.025,
		deadzone_y_lerp_constant = 0.2,
		delta_x_modifier = 10,
		delta_y_modifier = 10,
		lerp_constant_x_func = function (look_delta_x)
			return 0.9 * (0.15 + 0.85 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.9
		end,
	},
	idle = {
		deadzone_x = 0.025,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0.025,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 20,
		delta_y_modifier = -15,
		lerp_constant_x_func = function (look_delta_x)
			return 0.03 * (0.5 + 0.5 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.05
		end,
	},
	inspect = {
		deadzone_x = 0,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 5.3,
		delta_y_modifier = 4.5,
		lerp_constant_x_func = function (look_delta_x)
			return 0.1
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.1
		end,
	},
}
look_delta_templates.stub_pistol_aiming = {
	shooting = {
		deadzone_x = 0.15,
		deadzone_x_lerp_constant = 0.3,
		deadzone_y = 0.1,
		deadzone_y_lerp_constant = 0.3,
		delta_x_modifier = 0.1,
		delta_y_modifier = 0.05,
		lerp_constant_x_func = function (look_delta_x)
			return 0.6 * (0.5 + 0.5 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.5
		end,
	},
	idle = {
		deadzone_x = 0.05,
		deadzone_x_lerp_constant = 0.1,
		deadzone_y = 0.05,
		deadzone_y_lerp_constant = 0.1,
		delta_x_modifier = 10,
		delta_y_modifier = 15,
		lerp_constant_x_func = function (look_delta_x)
			return 0.075 * (0.25 + 0.75 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.05
		end,
	},
	inspect = {
		deadzone_x = 0,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 3.3,
		delta_y_modifier = 2.5,
		lerp_constant_x_func = function (look_delta_x)
			return 0.1
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.1
		end,
	},
}
look_delta_templates.default_aiming = {
	shooting = {
		deadzone_x = 0.15,
		deadzone_x_lerp_constant = 0.3,
		deadzone_y = 0.1,
		deadzone_y_lerp_constant = 0.3,
		delta_x_modifier = 25.1,
		delta_y_modifier = 15.05,
		lerp_constant_x_func = function (look_delta_x)
			return 0.6 * (0.5 + 0.5 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.5
		end,
	},
	idle = {
		deadzone_x = 0.05,
		deadzone_x_lerp_constant = 0.1,
		deadzone_y = 0.05,
		deadzone_y_lerp_constant = 0.1,
		delta_x_modifier = -8.75,
		delta_y_modifier = 11.25,
		lerp_constant_x_func = function (look_delta_x)
			return 0.075 * (0.25 + 0.75 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.05
		end,
	},
	inspect = {
		deadzone_x = 0,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 3.3,
		delta_y_modifier = 2.5,
		lerp_constant_x_func = function (look_delta_x)
			return 0.1
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.1
		end,
	},
}
look_delta_templates.laspistol_holo_aiming = {
	shooting = {
		deadzone_x = 0.15,
		deadzone_x_lerp_constant = 0.3,
		deadzone_y = 0.1,
		deadzone_y_lerp_constant = 0.3,
		delta_x_modifier = 75,
		delta_y_modifier = 25,
		pitch_multiplier = 0.2,
		yaw_multiplier = 0.2,
		lerp_constant_x_func = function (look_delta_x)
			return 0.6 * (0.5 + 0.5 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.5
		end,
	},
	idle = {
		deadzone_x = 0.2,
		deadzone_x_lerp_constant = 0.07,
		deadzone_y = 0.02,
		deadzone_y_lerp_constant = 0.1,
		delta_x_modifier = 10,
		delta_y_modifier = 10,
		pitch_multiplier = 0.2,
		yaw_multiplier = 0.05,
		lerp_constant_x_func = function (look_delta_x)
			return 0.75 * (0.25 + 0.75 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.5
		end,
	},
	inspect = {
		deadzone_x = 0,
		deadzone_x_lerp_constant = 0.01,
		deadzone_y = 0,
		deadzone_y_lerp_constant = 0.025,
		delta_x_modifier = 3.3,
		delta_y_modifier = 2.5,
		lerp_constant_x_func = function (look_delta_x)
			return 0.1
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.1
		end,
	},
}
look_delta_templates.lasgun_holo_aiming = {
	shooting = {
		deadzone_x = 0.15,
		deadzone_x_lerp_constant = 0.3,
		deadzone_y = 0.1,
		deadzone_y_lerp_constant = 0.3,
		delta_x_modifier = 75,
		delta_y_modifier = 25,
		pitch_multiplier = 0.2,
		yaw_multiplier = 0.2,
		lerp_constant_x_func = function (look_delta_x)
			return 0.6 * (0.5 + 0.5 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.5
		end,
	},
	idle = {
		deadzone_x = 0.05,
		deadzone_x_lerp_constant = 0.1,
		deadzone_y = 0.05,
		deadzone_y_lerp_constant = 0.1,
		delta_x_modifier = 75,
		delta_y_modifier = 25,
		pitch_multiplier = 0.2,
		yaw_multiplier = 0.2,
		lerp_constant_x_func = function (look_delta_x)
			return 0.075 * (0.25 + 0.75 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.05
		end,
	},
	inspect = {
		deadzone_x = 0,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 3.3,
		delta_y_modifier = 2.5,
		lerp_constant_x_func = function (look_delta_x)
			return 0.1
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.1
		end,
	},
}
look_delta_templates.lasgun_brace_light = {
	shooting = {
		deadzone_x = 0.1,
		deadzone_x_lerp_constant = 0.5,
		deadzone_y = 0.05,
		deadzone_y_lerp_constant = 0.5,
		delta_x_modifier = 5,
		delta_y_modifier = 3,
		lerp_constant_x_func = function (look_delta_x)
			return 0.5 * (0.15 + 0.85 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.5
		end,
	},
	idle = {
		deadzone_x = 0.05,
		deadzone_x_lerp_constant = 0.1,
		deadzone_y = 0.05,
		deadzone_y_lerp_constant = 0.1,
		delta_x_modifier = -2.25,
		delta_y_modifier = 2.25,
		lerp_constant_x_func = function (look_delta_x)
			return 0.075 * (0.25 + 0.75 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.05
		end,
	},
	inspect = {
		deadzone_x = 0,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 3.3,
		delta_y_modifier = 2.5,
		lerp_constant_x_func = function (look_delta_x)
			return 0.1
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.1
		end,
	},
}
look_delta_templates.default_lasgun_spraynpray = table.clone(look_delta_templates.lasgun_brace_light)
look_delta_templates.auspex_scanner = {
	shooting = {
		deadzone_x = 0.025,
		deadzone_x_lerp_constant = 0.2,
		deadzone_y = 0.025,
		deadzone_y_lerp_constant = 0.2,
		delta_x_modifier = 1.5,
		delta_y_modifier = 1.5,
		lerp_constant_x_func = function (look_delta_x)
			return 0.9 * (0.15 + 0.85 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.9
		end,
	},
	idle = {
		deadzone_x = 0.025,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0.025,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 20,
		delta_y_modifier = -15,
		lerp_constant_x_func = function (look_delta_x)
			return 0.03 * (0.5 + 0.5 * (1 - math.min(math.abs(look_delta_x * look_delta_x), 1)))
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.05
		end,
	},
	inspect = {
		deadzone_x = 0,
		deadzone_x_lerp_constant = 0.05,
		deadzone_y = 0,
		deadzone_y_lerp_constant = 0.075,
		delta_x_modifier = 3.3,
		delta_y_modifier = 2.5,
		no_look_delta_clamp = true,
		lerp_constant_x_func = function (look_delta_x)
			return 0.1
		end,
		lerp_constant_y_func = function (look_delta_y)
			return 0.1
		end,
	},
}

for name, template in pairs(look_delta_templates) do
	template.name = name
end

return settings("LookDeltaTemplates", look_delta_templates)
