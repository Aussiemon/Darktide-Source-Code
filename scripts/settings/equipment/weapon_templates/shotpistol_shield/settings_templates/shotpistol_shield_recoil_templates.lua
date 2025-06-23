-- chunkname: @scripts/settings/equipment/weapon_templates/shotpistol_shield/settings_templates/shotpistol_shield_recoil_templates.lua

local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

recoil_templates.default_shotpistol_shield_ads = {
	still = {
		camera_recoil_percentage = 0.2,
		decay_grace = 0.2,
		new_influence_percent = 1,
		rise_duration = 0.13,
		rise = {
			0.85,
			0.95,
			0.7,
			0.75,
			0.8,
			0.65
		},
		decay = {
			shooting = 1.2,
			idle = 2
		},
		offset_range = {
			{
				pitch = {
					0.04375,
					0.04875
				},
				yaw = {
					-0.02,
					0.02
				}
			}
		},
		offset_limit = {
			yaw = 2,
			pitch = 2
		},
		visual_recoil_settings = {
			intensity = 12,
			lerp_scalar = 1,
			yaw_intensity = 8
		}
	},
	moving = {
		new_influence_percent = 0.75,
		inherits = {
			"default_shotpistol_shield_ads",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.6,
		inherits = {
			"default_shotpistol_shield_ads",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.8,
		inherits = {
			"default_shotpistol_shield_ads",
			"still"
		}
	}
}
recoil_templates.default_shotpistol_shield_hip = {
	still = {
		camera_recoil_percentage = 0.2,
		decay_grace = 0.2,
		new_influence_percent = 1,
		rise_duration = 0.13,
		rise = {
			0.85,
			0.95,
			0.7,
			0.75,
			0.8,
			0.65
		},
		decay = {
			shooting = 1.2,
			idle = 2
		},
		offset_range = {
			{
				pitch = {
					0.04375,
					0.04875
				},
				yaw = {
					-0.02,
					0.02
				}
			}
		},
		offset_limit = {
			yaw = 2,
			pitch = 2
		},
		visual_recoil_settings = {
			intensity = 12,
			lerp_scalar = 1,
			yaw_intensity = 8
		}
	},
	moving = {
		new_influence_percent = 0.75,
		inherits = {
			"default_shotpistol_shield_ads",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.6,
		inherits = {
			"default_shotpistol_shield_ads",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.8,
		inherits = {
			"default_shotpistol_shield_ads",
			"still"
		}
	}
}

return {
	base_templates = recoil_templates,
	overrides = overrides
}
