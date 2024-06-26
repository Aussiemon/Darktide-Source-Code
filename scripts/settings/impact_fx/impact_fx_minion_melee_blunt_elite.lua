﻿-- chunkname: @scripts/settings/impact_fx/impact_fx_minion_melee_blunt_elite.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local blood_ball = {
	"content/decals/blood_ball/blood_ball",
}
local unarmored, armored, super_armor, disgustingly_resilient, resistant, berserker
local player = {
	sfx = {
		damage = {
			{
				event = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			},
			{
				event = "wwise/events/player/play_player_get_hit_blunt",
				hit_direction_interface = true,
			},
			{
				event = "wwise/events/player/play_player_get_hit_blunt_husk",
				only_3p = true,
			},
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			},
			{
				event = "wwise/events/player/play_player_get_hit_blunt",
				hit_direction_interface = true,
			},
			{
				event = "wwise/events/player/play_player_get_hit_blunt_husk",
				only_3p = true,
			},
		},
		toughness_absorbed_melee = {
			{
				event = "wwise/events/player/play_toughness_hits_melee",
				hit_direction_interface = true,
			},
			{
				event = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			},
			{
				event = "wwise/events/player/play_player_get_hit_blunt",
				hit_direction_interface = true,
			},
			{
				event = "wwise/events/player/play_player_get_hit_blunt_husk",
				only_3p = true,
			},
		},
	},
	vfx = {
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
					only_3p = true,
				},
			},
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked",
					only_3p = true,
				},
			},
		},
	},
	blood_ball = {
		died = blood_ball,
		damage = blood_ball,
	},
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
