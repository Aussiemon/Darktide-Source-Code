local ArmorSettings = require("scripts/settings/damage/armor_settings")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local ImpactFxHelper = require("scripts/utilities/impact_fx_helper")
local armor_types = ArmorSettings.types
local hit_types = SurfaceMaterialSettings.hit_types
local player = {
	sfx = {
		damage = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d",
				only_1p = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d",
				only_1p = true
			}
		},
		toughness_absorbed = {
			{
				event = "wwise/events/player/play_toughness_hits",
				only_1p = true
			}
		}
	},
	vfx = {},
	linked_decal = {},
	blood_ball = {}
}

return {
	armor = {
		[armor_types.player] = player
	},
	surface = {}
}
