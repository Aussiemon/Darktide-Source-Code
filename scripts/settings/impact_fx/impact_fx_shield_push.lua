-- chunkname: @scripts/settings/impact_fx/impact_fx_shield_push.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local unarmored, armored, super_armor, disgustingly_resilient, resistant, berserker
local player = {
	sfx = {
		blocked = nil,
		damage_reduced = nil,
		dead = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = nil,
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weapon_large_metal_shield_slam",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weapon_large_metal_shield_slam",
			},
		},
	},
	vfx = {
		blocked = nil,
		damage = nil,
		damage_negated = nil,
		damage_reduced = nil,
		dead = nil,
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
		shield_blocked = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = nil,
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
