local HitZone = require("scripts/utilities/attack/hit_zone")
local hit_zone_names = HitZone.hit_zone_names
local gibbing_settings = {
	gibbing_thresholds = {
		medium = 2,
		impossible = 4,
		always = 0,
		light = 1,
		heavy = 3
	}
}
gibbing_settings.gibbing_power = gibbing_settings.gibbing_thresholds
gibbing_settings.gibbing_types = table.enum("default", "ballistic", "explosion", "plasma", "crushing", "sawing", "boltshell", "laser", "warp", "fire")
gibbing_settings.gib_push_force_multipliers = {
	[hit_zone_names.head] = 0.25,
	[hit_zone_names.upper_left_arm] = 0.75,
	[hit_zone_names.upper_right_arm] = 0.75,
	[hit_zone_names.lower_left_arm] = 0.75,
	[hit_zone_names.lower_right_arm] = 0.75,
	[hit_zone_names.upper_left_leg] = 0.75,
	[hit_zone_names.upper_right_leg] = 0.75,
	[hit_zone_names.lower_left_leg] = 0.75,
	[hit_zone_names.lower_right_leg] = 0.75,
	[hit_zone_names.center_mass] = 1,
	[hit_zone_names.torso] = 1
}
gibbing_settings.gib_overrides = {
	head = {
		default = {},
		crushing = {},
		sawing = {}
	},
	upper_left_arm = {
		default = {
			conditional = {
				{},
				{}
			}
		}
	},
	upper_right_arm = {
		default = {
			conditional = {
				{},
				{}
			}
		}
	},
	upper_left_leg = {
		default = {
			conditional = {
				{},
				{}
			}
		}
	},
	upper_right_leg = {
		default = {
			conditional = {
				{},
				{}
			}
		}
	},
	lower_left_arm = {
		default = {}
	},
	lower_right_arm = {
		default = {}
	},
	lower_left_leg = {
		default = {}
	},
	lower_right_leg = {
		default = {}
	},
	torso = {
		default = {},
		ballistic = {},
		plasma = {},
		sawing = {}
	},
	center_mass = {
		plasma = {},
		explosion = {},
		sawing = {}
	}
}

return settings("GibbingSettings", gibbing_settings)
