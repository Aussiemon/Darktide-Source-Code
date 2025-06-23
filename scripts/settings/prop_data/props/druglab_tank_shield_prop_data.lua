-- chunkname: @scripts/settings/prop_data/props/druglab_tank_shield_prop_data.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local armor_types = ArmorSettings.types
local breed_types = BreedSettings.types
local hit_zone_names = HitZone.hit_zone_names
local prop_data = {
	name = "druglab_tank_shield",
	diminishing_returns_damage = true,
	hit_mass = 1000,
	breed_type = breed_types.prop,
	armor_type = armor_types.void_shield,
	hit_zones = {
		{
			name = hit_zone_names.center_mass,
			actors = {
				"c_destructible"
			}
		}
	},
	tags = {}
}

return prop_data
