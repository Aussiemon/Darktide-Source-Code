-- chunkname: @scripts/settings/prop_data/props/hazard_sphere_prop_data.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local armor_types = ArmorSettings.types
local hit_effect_armor_type = ArmorSettings.hit_effect_types
local breed_types = BreedSettings.types
local hit_zone_names = HitZone.hit_zone_names
local prop_data = {
	name = "hazard_sphere",
	hit_mass = 1,
	breed_type = breed_types.prop,
	armor_type = armor_types.armored,
	hit_effect_armor_override = hit_effect_armor_type.prop_armored,
	hit_zones = {
		{
			name = hit_zone_names.center_mass,
			actors = {
				"c_intact",
				"c_intact_destructible",
				"c_broken"
			}
		},
		{
			name = hit_zone_names.center_mass,
			actors = {
				"c_dynamic_cable_01_static_intact",
				"c_dynamic_cable_02_intact",
				"c_dynamic_cable_03_intact"
			}
		}
	},
	tags = {
		tags = {
			hazard = true
		}
	}
}

return prop_data
