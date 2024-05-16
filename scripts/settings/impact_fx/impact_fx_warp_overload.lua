-- chunkname: @scripts/settings/impact_fx/impact_fx_warp_overload.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local unarmored, armored, super_armor, disgustingly_resilient, resistant, berserker
local player = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d",
				only_1p = true,
			},
		},
		died = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d",
				only_1p = true,
			},
		},
		weakspot_damage = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d",
				only_1p = true,
			},
		},
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
		damage_negated = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d",
				only_1p = true,
			},
		},
		toughness_absorbed = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d",
				only_1p = true,
			},
		},
		shield_blocked = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d",
				only_1p = true,
			},
		},
		blocked = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d",
				only_1p = true,
			},
		},
		dead = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d",
				only_1p = true,
			},
		},
		shove = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d",
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
		[armor_types.armored] = armored,
		[armor_types.berserker] = berserker,
		[armor_types.disgustingly_resilient] = disgustingly_resilient,
		[armor_types.player] = player,
		[armor_types.resistant] = resistant,
		[armor_types.super_armor] = super_armor,
		[armor_types.unarmored] = unarmored,
	},
}
