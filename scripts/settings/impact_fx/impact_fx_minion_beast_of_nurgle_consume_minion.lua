﻿-- chunkname: @scripts/settings/impact_fx/impact_fx_minion_beast_of_nurgle_consume_minion.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local unarmored = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_melee_hits_ogryn_punch_heavy_husk",
			},
		},
		died = {
			{
				event = "wwise/events/weapon/play_melee_hits_ogryn_punch_heavy_husk",
			},
		},
	},
	vfx = {
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/enemies/beast_of_nurgle/bon_minion_eat",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/enemies/beast_of_nurgle/bon_minion_eat",
				},
			},
		},
	},
}
local armored = table.clone(unarmored)
local berserker = table.clone(unarmored)
local disgustingly_resilient = table.clone(unarmored)
local player
local resistant = table.clone(unarmored)
local super_armor = table.clone(unarmored)

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
