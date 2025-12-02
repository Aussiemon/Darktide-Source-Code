-- chunkname: @scripts/settings/impact_fx/impact_fx_shock_mine.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local ImpactFxHelper = require("scripts/utilities/impact_fx_helper")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local hit_types = SurfaceMaterialSettings.hit_types
local default_armor_decal = {
	extents = {
		min = {
			x = 0.25,
			y = 0.25,
		},
		max = {
			x = 0.25,
			y = 0.25,
		},
	},
	units = {
		"content/fx/units/weapons/vfx_decal_plasma_scorchmark",
	},
}
local unarmored = {
	sfx = {
		shove = nil,
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_grenade_hits_unarmored",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_grenade_hits_unarmored",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_grenade_hits_unarmored",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_grenade_hits_unarmored",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_grenade_hits_unarmored",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_grenade_hits_damage_negate",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_grenade_hits_damage_negate",
			},
		},
		blocked = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_grenade_hits_damage_negate",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_grenade_hits_unarmored",
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
	},
	linked_decal = {
		blocked = nil,
		damage_negated = nil,
		dead = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = default_armor_decal,
		died = default_armor_decal,
		weakspot_damage = default_armor_decal,
		damage = default_armor_decal,
		damage_reduced = default_armor_decal,
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
local armored = table.clone(unarmored)
local super_armor = table.clone(unarmored)
local disgustingly_resilient = table.clone(unarmored)
local resistant = table.clone(unarmored)
local berserker = table.clone(unarmored)
local player = table.clone(unarmored)
local surface_fx = {
	snow = {
		[hit_types.stop] = {
			sfx = nil,
			vfx = {
				{
					normal_rotation = true,
					effects = {
						"content/fx/particles/impacts/surfaces/impact_snow_grenade",
					},
				},
			},
		},
	},
	snow_frosty = {
		[hit_types.stop] = {
			sfx = nil,
			vfx = {
				{
					normal_rotation = true,
					effects = {
						"content/fx/particles/impacts/surfaces/impact_snow_grenade",
					},
				},
			},
		},
	},
}
local default_surface_fx = {
	[hit_types.stop] = {
		vfx = nil,
		sfx = {
			{
				event = "wwise/events/weapon/play_adamant_shockmine_drop_impact",
				group = "surface_material",
				normal_rotation = true,
			},
		},
	},
	[hit_types.penetration_entry] = nil,
	[hit_types.penetration_exit] = nil,
}

ImpactFxHelper.create_missing_surface_fx(surface_fx, default_surface_fx)

return {
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
	surface = surface_fx,
}
