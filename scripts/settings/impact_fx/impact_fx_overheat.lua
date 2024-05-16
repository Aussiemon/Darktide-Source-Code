-- chunkname: @scripts/settings/impact_fx/impact_fx_overheat.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local player = {
	sfx = {
		damage = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d",
				only_1p = true,
			},
		},
		damage_reduced = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d",
				only_1p = true,
			},
		},
		toughness_absorbed = {
			{
				event = "wwise/events/player/play_toughness_hits",
				only_1p = true,
			},
		},
	},
	vfx = {},
	linked_decal = {},
	blood_ball = {},
}

return {
	armor = {
		[armor_types.player] = player,
	},
}
