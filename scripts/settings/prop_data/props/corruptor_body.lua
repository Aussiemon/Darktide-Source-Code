local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local armor_types = ArmorSettings.types
local breed_types = BreedSettings.types
local hit_zone_names = HitZone.hit_zone_names
local prop_data = {
	name = "corruptor_body",
	debug_color_name = "antique_white",
	hit_mass = 10,
	breed_type = breed_types.living_prop,
	armor_type = armor_types.disgustingly_resilient,
	hit_zones = {
		{
			name = hit_zone_names.head,
			actors = {
				"c_eye"
			}
		},
		{
			name = hit_zone_names.center_mass,
			actors = {
				"c_flesh"
			}
		},
		{
			name = hit_zone_names.corruptor_armor,
			actors = {
				"c_hatch",
				"c_metal"
			}
		}
	},
	hitzone_armor_override = {
		[hit_zone_names.corruptor_armor] = armor_types.super_armor
	},
	hitzone_damage_multiplier = {
		melee = {
			[hit_zone_names.head] = 3
		}
	},
	tags = {
		objective = true
	}
}

return prop_data
