-- chunkname: @scripts/settings/impact_fx/impact_fx_chaos_hound_tearing.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local blood_ball = {
	"content/decals/blood_ball/blood_ball",
}
local unarmored, armored, super_armor, disgustingly_resilient, resistant, berserker
local player = {
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
		damage_negated = nil,
		damage_reduced = nil,
		dead = nil,
		died = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = nil,
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
		},
	},
	blood_ball = {
		blocked = nil,
		damage_negated = nil,
		damage_reduced = nil,
		dead = nil,
		died = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = nil,
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
