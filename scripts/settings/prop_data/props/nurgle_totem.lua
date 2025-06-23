-- chunkname: @scripts/settings/prop_data/props/nurgle_totem.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local armor_types = ArmorSettings.types
local hit_effect_armor_type = ArmorSettings.hit_effect_types
local breed_types = BreedSettings.types
local hit_zone_names = HitZone.hit_zone_names
local prop_data = {
	name = "nurgle_totem",
	hit_mass = 50,
	breed_type = breed_types.objective_prop,
	armor_type = armor_types.super_armor,
	hit_effect_armor_override = hit_effect_armor_type.nurgle_totem,
	hit_zones = {
		{
			name = hit_zone_names.center_mass,
			actors = {
				"c_destructible"
			}
		}
	},
	hitzone_damage_multiplier = {
		melee = {
			[hit_zone_names.center_mass] = 0.45
		},
		ranged = {
			[hit_zone_names.center_mass] = 0.05
		}
	},
	tags = {}
}

return prop_data
