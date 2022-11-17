local HitZone = require("scripts/utilities/attack/hit_zone")
local hit_zone_names = HitZone.hit_zone_names
local gibbing_settings = {
	gibbing_thresholds = {
		medium = 2,
		impossible = 4,
		always = 0,
		infinite = 10,
		light = 1,
		heavy = 3
	},
	character_size = {
		small = 0,
		medium = 1,
		large = 2
	},
	gib_push_force = {
		ranged_heavy = 800,
		force_assault = 250,
		force_bfg = 800,
		sawing_light = 200,
		force_demolition = 400,
		sawing_heavy = 800,
		sawing_medium = 600,
		ranged_medium = 400,
		blunt_light = 400,
		force_sword = 600,
		explosive = 800,
		ranged_light = 200,
		blunt_heavy = 600
	}
}
gibbing_settings.gibbing_power = gibbing_settings.gibbing_thresholds
gibbing_settings.max_extra_hit_zone_gibs = 3
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
	[hit_zone_names.torso] = 1,
	[hit_zone_names.tongue] = 1
}

return settings("GibbingSettings", gibbing_settings)
