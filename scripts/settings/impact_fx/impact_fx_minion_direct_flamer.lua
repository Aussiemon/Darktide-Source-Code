-- chunkname: @scripts/settings/impact_fx/impact_fx_minion_direct_flamer.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local blood_ball = {
	"content/decals/blood_ball/blood_ball",
}
local disgusting_blood_ball = {
	"content/decals/blood_ball/blood_ball_poxwalker",
}
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
		weakspot_damage = nil,
		weakspot_died = nil,
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
		shield_blocked = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = blood_ball,
		died = blood_ball,
		dead = blood_ball,
	},
}
local armored = table.clone(unarmored)
local super_armor = table.clone(unarmored)
local disgustingly_resilient = table.clone(unarmored)

disgustingly_resilient.blood_ball = {
	blocked = nil,
	damage = nil,
	damage_negated = nil,
	damage_reduced = nil,
	shield_blocked = nil,
	shove = nil,
	weakspot_damage = nil,
	weakspot_died = disgusting_blood_ball,
	died = disgusting_blood_ball,
	dead = disgusting_blood_ball,
}

local resistant = table.clone(unarmored)
local berserker = table.clone(unarmored)
local player = {
	sfx = {
		blocked = nil,
		dead = nil,
		died = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = nil,
		damage = {
			{
				event = "wwise/events/player/play_player_get_hit_bullet_laser",
				hit_direction_interface = true,
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored_husk",
				only_3p = true,
			},
		},
		damage_reduced = {
			{
				event = "wwise/events/player/play_player_get_hit_bullet_laser",
				hit_direction_interface = true,
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_armored_husk",
				only_3p = true,
			},
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated_husk",
				only_3p = true,
			},
		},
		toughness_absorbed = {
			{
				event = "wwise/events/player/play_toughness_hits",
				hit_direction_interface = true,
			},
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated_husk",
				only_3p = true,
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
		weakspot_damage = nil,
		weakspot_died = nil,
		toughness_absorbed = {},
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
	surface = nil,
	surface_decal = nil,
	surface_overrides = nil,
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
