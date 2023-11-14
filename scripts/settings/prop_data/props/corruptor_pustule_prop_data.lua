local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local armor_types = ArmorSettings.types
local breed_types = BreedSettings.types
local hit_zone_names = HitZone.hit_zone_names
local prop_data = {
	name = "corruptor_pustule",
	hit_mass = 0.5,
	breed_type = breed_types.living_prop,
	armor_type = armor_types.disgustingly_resilient,
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
			[hit_zone_names.center_mass] = 2
		}
	},
	tags = {
		objective = true
	}
}

return prop_data
