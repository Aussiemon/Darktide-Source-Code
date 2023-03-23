local ArmorSettings = require("scripts/settings/damage/armor_settings")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local ImpactFxHelper = require("scripts/utilities/impact_fx_helper")
local armor_types = ArmorSettings.types
local hit_types = SurfaceMaterialSettings.hit_types
local default_armor_decal = {
	extents = {
		min = {
			x = 0.25,
			y = 0.25
		},
		max = {
			x = 0.25,
			y = 0.25
		}
	},
	units = {
		"content/fx/units/vfx_decal_plasma_scorchmark"
	}
}
local unarmored = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_grenade_hits_unarmored",
				append_husk_to_event_name = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_grenade_hits_unarmored",
				append_husk_to_event_name = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_grenade_hits_unarmored",
				append_husk_to_event_name = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_grenade_hits_unarmored",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_grenade_hits_unarmored",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_grenade_hits_damage_negate",
				append_husk_to_event_name = false
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/play_grenade_hits_damage_negate",
				append_husk_to_event_name = false
			}
		},
		blocked = {
			{
				event = "wwise/events/weapon/play_grenade_hits_damage_negate",
				append_husk_to_event_name = false
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/play_grenade_hits_unarmored",
				append_husk_to_event_name = true
			}
		}
	},
	vfx = {},
	linked_decal = {
		weakspot_died = default_armor_decal,
		died = default_armor_decal,
		weakspot_damage = default_armor_decal,
		damage = default_armor_decal,
		damage_reduced = default_armor_decal
	},
	blood_ball = {}
}
local armored = table.clone(unarmored)
local super_armor = table.clone(unarmored)
local disgustingly_resilient = table.clone(unarmored)
local resistant = table.clone(unarmored)
local berserker = table.clone(unarmored)
local prop_armor = table.clone(armored)
local player = table.clone(unarmored)
local default_surface_decal = {
	Vector3(0.2, 0.2, 0.2),
	Vector3(0.2, 0.2, 0.2),
	{
		"content/fx/units/decal_cross_01"
	}
}
local default_surface_fx = {
	sfx = {
		{
			group = "surface_material",
			append_husk_to_event_name = true,
			event = "wwise/events/weapon/play_grenade_surface_impact",
			normal_rotation = true
		}
	},
	vfx = {}
}
local surface_decal = {}

return {
	armor = {
		[armor_types.armored] = armored,
		[armor_types.berserker] = berserker,
		[armor_types.disgustingly_resilient] = disgustingly_resilient,
		[armor_types.player] = player,
		[armor_types.resistant] = resistant,
		[armor_types.super_armor] = super_armor,
		[armor_types.unarmored] = unarmored,
		[armor_types.prop_armor] = prop_armor
	},
	surface = {
		[hit_types.stop] = default_surface_fx,
		[hit_types.penetration_entry] = default_surface_fx,
		[hit_types.penetration_exit] = default_surface_fx
	},
	surface_decal = surface_decal
}
