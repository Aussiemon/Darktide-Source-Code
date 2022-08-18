local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local armor_types = ArmorSettings.types
local breed_types = BreedSettings.types
local hit_zone_names = HitZone.hit_zone_names
local prop_data = {
	name = "hazard_prop",
	hit_mass = 0,
	debug_color_name = "antique_white",
	breed_type = breed_types.prop,
	armor_type = armor_types.prop_armor,
	hit_zones = {
		{
			name = hit_zone_names.center_mass,
			actors = {
				"c_intact",
				"c_broken"
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
