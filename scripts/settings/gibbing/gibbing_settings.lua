-- chunkname: @scripts/settings/gibbing/gibbing_settings.lua

local HitZone = require("scripts/utilities/attack/hit_zone")
local hit_zone_names = HitZone.hit_zone_names
local gibbing_settings = {}

gibbing_settings.gibbing_thresholds = {
	medium = 2,
	impossible = 4,
	always = 0,
	infinite = 10,
	light = 1,
	heavy = 3
}
gibbing_settings.character_size = {
	small = 0,
	medium = 1,
	large = 2
}
gibbing_settings.gib_push_force = {
	ranged_heavy = 1.5,
	force_assault = 1,
	force_bfg = 1,
	sawing_light = 0.6,
	force_demolition = 1,
	sawing_heavy = 1,
	sawing_medium = 0.8,
	ranged_medium = 1,
	blunt_light = 0.75,
	force_sword = 1,
	explosive = 1,
	ranged_light = 0.8,
	explosive_heavy = 1.5,
	blunt_heavy = 1
}
gibbing_settings.gibbing_power = gibbing_settings.gibbing_thresholds
gibbing_settings.max_extra_hit_zone_gibs = 3
gibbing_settings.gibbing_types = table.enum("default", "ballistic", "explosion", "plasma", "crushing", "sawing", "boltshell", "laser", "warp", "warp_lightning", "warp_shard", "fire")
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
