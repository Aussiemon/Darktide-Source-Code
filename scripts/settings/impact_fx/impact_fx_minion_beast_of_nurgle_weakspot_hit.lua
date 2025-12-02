-- chunkname: @scripts/settings/impact_fx/impact_fx_minion_beast_of_nurgle_weakspot_hit.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local unarmored = {
	sfx = {
		blocked = nil,
		damage = nil,
		damage_negated = nil,
		damage_reduced = nil,
		dead = nil,
		died = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/minions/play_beast_of_nurgle_weakspot_hit",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/minions/play_beast_of_nurgle_weakspot_hit",
			},
		},
	},
}
local armored = table.clone(unarmored)
local super_armor = table.clone(unarmored)
local disgustingly_resilient = table.clone(unarmored)
local resistant = table.clone(unarmored)
local berserker = table.clone(unarmored)
local player = table.clone(unarmored)

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
