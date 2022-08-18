local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

recoil_templates.default_thumper_assault = {
	still = {
		new_influence_percent = 0.75,
		rise_duration = 0.15,
		rise = {
			0.75
		},
		decay = {
			shooting = 0.5,
			idle = 1.5
		},
		offset_range = {
			{
				pitch = {
					0.25,
					0.3
				},
				yaw = {
					-0.15,
					-0.1
				}
			}
		},
		offset_limit = {
			yaw = 3,
			pitch = 3
		}
	},
	moving = {
		inherits = {
			"default_thumper_assault",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_thumper_assault",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_thumper_assault",
			"still"
		}
	}
}

return {
	base_templates = recoil_templates,
	overrides = overrides
}
