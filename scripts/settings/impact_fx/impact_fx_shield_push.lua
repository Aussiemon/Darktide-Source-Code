local ArmorSettings = require("scripts/settings/damage/armor_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local unarmored, armored, super_armor, disgustingly_resilient, resistant, berserker = nil
local player = {
	sfx = {
		damage = {
			{
				event = "wwise/events/weapon/play_weapon_large_metal_shield_slam",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_weapon_large_metal_shield_slam",
				append_husk_to_event_name = true
			}
		}
	},
	vfx = {},
	blood_ball = {}
}

return {
	armor = {
		[armor_types.armored] = armored,
		[armor_types.berserker] = berserker,
		[armor_types.disgustingly_resilient] = disgustingly_resilient,
		[armor_types.player] = player,
		[armor_types.resistant] = resistant,
		[armor_types.super_armor] = super_armor,
		[armor_types.unarmored] = unarmored
	}
}
