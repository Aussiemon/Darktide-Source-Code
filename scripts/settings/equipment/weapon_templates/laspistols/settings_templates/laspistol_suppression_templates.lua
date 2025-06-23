-- chunkname: @scripts/settings/equipment/weapon_templates/laspistols/settings_templates/laspistol_suppression_templates.lua

local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.default_laspistol_killshot = {
	still = {
		delay = 0.2,
		decay_time = 0.6,
		immediate_sway = {
			{
				pitch = {
					lerp_perfect = 0.1,
					lerp_basic = 0.2
				},
				yaw = {
					lerp_perfect = 0.1,
					lerp_basic = 0.2
				}
			},
			{
				pitch = {
					lerp_perfect = 0.15,
					lerp_basic = 0.3
				},
				yaw = {
					lerp_perfect = 0.15,
					lerp_basic = 0.3
				}
			},
			{
				pitch = {
					lerp_perfect = 0.2,
					lerp_basic = 0.4
				},
				yaw = {
					lerp_perfect = 0.2,
					lerp_basic = 0.4
				}
			},
			{
				pitch = {
					lerp_perfect = 0.3,
					lerp_basic = 0.5
				},
				yaw = {
					lerp_perfect = 0.3,
					lerp_basic = 0.5
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_laspistol_killshot",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_laspistol_killshot",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_laspistol_killshot",
			"still"
		}
	}
}
suppression_templates.hip_laspistol_killshot = {
	still = {
		delay = 0.2,
		decay_time = 0.6,
		immediate_spread = {
			{
				pitch = {
					lerp_perfect = 0.1,
					lerp_basic = 0.2
				},
				yaw = {
					lerp_perfect = 0.1,
					lerp_basic = 0.2
				}
			},
			{
				pitch = {
					lerp_perfect = 0.15,
					lerp_basic = 0.3
				},
				yaw = {
					lerp_perfect = 0.15,
					lerp_basic = 0.3
				}
			},
			{
				pitch = {
					lerp_perfect = 0.2,
					lerp_basic = 0.4
				},
				yaw = {
					lerp_perfect = 0.2,
					lerp_basic = 0.4
				}
			},
			{
				pitch = {
					lerp_perfect = 0.3,
					lerp_basic = 0.5
				},
				yaw = {
					lerp_perfect = 0.3,
					lerp_basic = 0.5
				}
			}
		}
	},
	moving = {
		inherits = {
			"hip_laspistol_killshot",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"hip_laspistol_killshot",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"hip_laspistol_killshot",
			"still"
		}
	}
}

return {
	base_templates = suppression_templates,
	overrides = overrides
}
