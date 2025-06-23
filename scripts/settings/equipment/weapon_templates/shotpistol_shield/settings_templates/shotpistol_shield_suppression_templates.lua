-- chunkname: @scripts/settings/equipment/weapon_templates/shotpistol_shield/settings_templates/shotpistol_shield_suppression_templates.lua

local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.default_shotpistol_shield_ads = {
	still = {
		delay = 0.2,
		decay_time = 0.6,
		immediate_sway = {
			{
				pitch = {
					lerp_perfect = 0.75,
					lerp_basic = 1.25
				},
				yaw = {
					lerp_perfect = 0.7,
					lerp_basic = 1.25
				}
			},
			{
				pitch = {
					lerp_perfect = 0.4,
					lerp_basic = 1.5
				},
				yaw = {
					lerp_perfect = 0.25,
					lerp_basic = 1.5
				}
			},
			{
				pitch = {
					lerp_perfect = 0.2,
					lerp_basic = 1.3
				},
				yaw = {
					lerp_perfect = 1.5,
					lerp_basic = 1.2
				}
			},
			{
				pitch = {
					lerp_perfect = 0.2,
					lerp_basic = 1.3
				},
				yaw = {
					lerp_perfect = 0.2,
					lerp_basic = 1.3
				}
			},
			{
				pitch = {
					lerp_perfect = 0.3,
					lerp_basic = 1.4
				},
				yaw = {
					lerp_perfect = 0.3,
					lerp_basic = 1.4
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_shotpistol_shield_ads",
			"still"
		},
		immediate_sway = {
			{
				pitch = {
					lerp_perfect = 0.75,
					lerp_basic = 1.25
				},
				yaw = {
					lerp_perfect = 0.7,
					lerp_basic = 1.25
				}
			},
			{
				pitch = {
					lerp_perfect = 0.4,
					lerp_basic = 1.5
				},
				yaw = {
					lerp_perfect = 0.25,
					lerp_basic = 1.5
				}
			},
			{
				pitch = {
					lerp_perfect = 0.2,
					lerp_basic = 1.3
				},
				yaw = {
					lerp_perfect = 1.5,
					lerp_basic = 1.2
				}
			},
			{
				pitch = {
					lerp_perfect = 0.2,
					lerp_basic = 1.3
				},
				yaw = {
					lerp_perfect = 0.2,
					lerp_basic = 1.3
				}
			},
			{
				pitch = {
					lerp_perfect = 0.3,
					lerp_basic = 1.4
				},
				yaw = {
					lerp_perfect = 0.3,
					lerp_basic = 1.4
				}
			}
		}
	},
	crouch_still = {
		inherits = {
			"default_shotpistol_shield_ads",
			"still"
		},
		immediate_sway = {
			{
				pitch = {
					lerp_perfect = 0.75,
					lerp_basic = 1.25
				},
				yaw = {
					lerp_perfect = 0.7,
					lerp_basic = 1.25
				}
			},
			{
				pitch = {
					lerp_perfect = 0.4,
					lerp_basic = 1.5
				},
				yaw = {
					lerp_perfect = 0.25,
					lerp_basic = 1.5
				}
			},
			{
				pitch = {
					lerp_perfect = 0.2,
					lerp_basic = 1.3
				},
				yaw = {
					lerp_perfect = 1.5,
					lerp_basic = 1.2
				}
			},
			{
				pitch = {
					lerp_perfect = 0.2,
					lerp_basic = 1.3
				},
				yaw = {
					lerp_perfect = 0.2,
					lerp_basic = 1.3
				}
			},
			{
				pitch = {
					lerp_perfect = 0.3,
					lerp_basic = 1.4
				},
				yaw = {
					lerp_perfect = 0.3,
					lerp_basic = 1.4
				}
			}
		}
	},
	crouch_moving = {
		inherits = {
			"default_shotpistol_shield_ads",
			"still"
		},
		immediate_sway = {
			{
				pitch = {
					lerp_perfect = 0.75,
					lerp_basic = 1.25
				},
				yaw = {
					lerp_perfect = 0.7,
					lerp_basic = 1.25
				}
			},
			{
				pitch = {
					lerp_perfect = 0.4,
					lerp_basic = 1.5
				},
				yaw = {
					lerp_perfect = 0.25,
					lerp_basic = 1.5
				}
			},
			{
				pitch = {
					lerp_perfect = 0.2,
					lerp_basic = 1.3
				},
				yaw = {
					lerp_perfect = 1.5,
					lerp_basic = 1.2
				}
			},
			{
				pitch = {
					lerp_perfect = 0.2,
					lerp_basic = 1.3
				},
				yaw = {
					lerp_perfect = 0.2,
					lerp_basic = 1.3
				}
			},
			{
				pitch = {
					lerp_perfect = 0.3,
					lerp_basic = 1.4
				},
				yaw = {
					lerp_perfect = 0.3,
					lerp_basic = 1.4
				}
			}
		}
	}
}

return {
	base_templates = suppression_templates,
	overrides = overrides
}
