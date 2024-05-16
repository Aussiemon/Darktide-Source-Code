-- chunkname: @scripts/settings/equipment/weapon_templates/thumpers/settings_templates/thumper_recoil_templates.lua

local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

recoil_templates.default_thumper_assault = {
	still = {
		decay_grace = 0.35,
		new_influence_percent = 0.75,
		rise_duration = 0.12,
		rise = {
			0.75,
		},
		decay = {
			idle = 0.5,
			shooting = 1.4,
		},
		offset_range = {
			{
				pitch = {
					0.15,
					0.2,
				},
				yaw = {
					-0.09,
					-0.03,
				},
			},
		},
		offset_limit = {
			pitch = 3,
			yaw = 3,
		},
	},
	moving = {
		inherits = {
			"default_thumper_assault",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"default_thumper_assault",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_thumper_assault",
			"still",
		},
	},
}

return {
	base_templates = recoil_templates,
	overrides = overrides,
}
