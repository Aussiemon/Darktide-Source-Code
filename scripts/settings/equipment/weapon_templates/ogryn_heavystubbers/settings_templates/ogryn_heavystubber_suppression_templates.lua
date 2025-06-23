-- chunkname: @scripts/settings/equipment/weapon_templates/ogryn_heavystubbers/settings_templates/ogryn_heavystubber_suppression_templates.lua

local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.default_ogryn_heavystubber_assault = {
	still = {
		delay = 1,
		decay_time = 0.25,
		immediate_spread = {
			{
				pitch = {
					lerp_perfect = 3,
					lerp_basic = 6
				},
				yaw = {
					lerp_perfect = 3,
					lerp_basic = 6
				}
			},
			{
				pitch = {
					lerp_perfect = 2.5,
					lerp_basic = 5.5
				},
				yaw = {
					lerp_perfect = 2.5,
					lerp_basic = 5.5
				}
			},
			{
				pitch = {
					lerp_perfect = 2,
					lerp_basic = 5
				},
				yaw = {
					lerp_perfect = 2,
					lerp_basic = 5
				}
			},
			{
				pitch = {
					lerp_perfect = 1.5,
					lerp_basic = 4.5
				},
				yaw = {
					lerp_perfect = 1.5,
					lerp_basic = 4.5
				}
			},
			{
				pitch = {
					lerp_perfect = 1,
					lerp_basic = 4
				},
				yaw = {
					lerp_perfect = 1,
					lerp_basic = 4
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_ogryn_heavystubber_assault",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_ogryn_heavystubber_assault",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_ogryn_heavystubber_assault",
			"still"
		}
	}
}

return {
	base_templates = suppression_templates,
	overrides = overrides
}
