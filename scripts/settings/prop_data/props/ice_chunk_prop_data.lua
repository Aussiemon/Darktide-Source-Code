-- chunkname: @scripts/settings/prop_data/props/ice_chunk_prop_data.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local armor_types = ArmorSettings.types
local hit_effect_armor_type = ArmorSettings.hit_effect_types
local breed_types = BreedSettings.types
local hit_zone_names = HitZone.hit_zone_names
local prop_data = {
	hit_mass = 50,
	name = "ice_chunk",
	breed_type = breed_types.objective_prop,
	armor_type = armor_types.disgustingly_resilient,
	hit_effect_armor_override = hit_effect_armor_type.prop_ice_chunk,
	hit_zones = {
		{
			name = hit_zone_names.center_mass,
			actors = {
				"c_destructible",
				"c_destructible_ice_01",
				"c_destructible_ice_02",
				"c_destructible_ice_03",
				"c_destructible_ice_04",
				"c_destructible_ice_05",
			},
		},
	},
	hitzone_damage_multiplier = {
		ranged = {
			[hit_zone_names.center_mass] = 0.15,
		},
	},
	tags = {
		objective = true,
	},
}

return prop_data
