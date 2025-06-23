﻿-- chunkname: @scripts/settings/impact_fx/impact_fx_ogryn_physical.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local unarmored = {
	sfx = {
		damage = {
			{
				event = "wwise/events/weapon/play_player_push_unarmored",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_player_push_unarmored",
				append_husk_to_event_name = true
			}
		}
	},
	vfx = {},
	blood_ball = {}
}
local armored = {
	sfx = {
		damage = {
			{
				event = "wwise/events/weapon/play_player_push_armored",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_player_push_armored",
				append_husk_to_event_name = true
			}
		}
	},
	vfx = {},
	blood_ball = {}
}
local super_armor = {
	sfx = {
		damage = {
			{
				event = "wwise/events/weapon/play_player_push_super_armor",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_player_push_super_armor",
				append_husk_to_event_name = true
			}
		}
	},
	vfx = {},
	blood_ball = {}
}
local disgustingly_resilient = {
	sfx = {
		damage = {
			{
				event = "wwise/events/weapon/play_player_push_resilient",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_player_push_resilient",
				append_husk_to_event_name = true
			}
		}
	},
	vfx = {},
	blood_ball = {}
}
local resistant = table.clone(disgustingly_resilient)
local berserker = table.clone(disgustingly_resilient)
local player

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
