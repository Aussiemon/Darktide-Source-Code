-- chunkname: @scripts/settings/prop_data/props/train_cogitator_prop_data.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local armor_types = ArmorSettings.types
local hit_effect_armor_type = ArmorSettings.hit_effect_types
local breed_types = BreedSettings.types
local hit_zone_names = HitZone.hit_zone_names
local prop_data = {
	name = "train_cogitator",
	hit_mass = 50,
	breed_type = breed_types.objective_prop,
	armor_type = armor_types.armored,
	hit_effect_armor_override = hit_effect_armor_type.prop_train_cogitator,
	hit_zones = {
		{
			name = hit_zone_names.center_mass,
			actors = {
				"c_destructible",
				"c_intact_destructible",
				"c_intact",
				"c_broken"
			}
		}
	},
	hitzone_damage_multiplier = {
		ranged = {
			[hit_zone_names.center_mass] = 0.5
		}
	},
	tags = {
		objective = true
	}
}

return prop_data
