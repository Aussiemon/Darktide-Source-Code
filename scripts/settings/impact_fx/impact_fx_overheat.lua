-- chunkname: @scripts/settings/impact_fx/impact_fx_overheat.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local player = {
	sfx = {
		blocked = nil,
		damage_negated = nil,
		dead = nil,
		died = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = nil,
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
	vfx = {
		blocked = nil,
		damage = nil,
		damage_negated = nil,
		damage_reduced = nil,
		dead = nil,
		died = nil,
		shield_blocked = nil,
		shove = nil,
		toughness_absorbed = nil,
		weakspot_damage = nil,
		weakspot_died = nil,
	},
	linked_decal = {
		blocked = nil,
		damage = nil,
		damage_negated = nil,
		damage_reduced = nil,
		dead = nil,
		died = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = nil,
	},
	blood_ball = {
		blocked = nil,
		damage = nil,
		damage_negated = nil,
		damage_reduced = nil,
		dead = nil,
		died = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = nil,
	},
}

return {
	armor = {
		[armor_types.player] = player,
	},
}
