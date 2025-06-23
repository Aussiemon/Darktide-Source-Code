-- chunkname: @scripts/settings/impact_fx/impact_fx_grenade_frag_ogryn.lua

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
			y = 0.25
		},
		max = {
			x = 0.25,
			y = 0.25
		}
	},
	units = {
		"content/fx/units/weapons/vfx_decal_plasma_scorchmark"
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
local armored = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_grenade_hits_armored",
				append_husk_to_event_name = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_grenade_hits_armored",
				append_husk_to_event_name = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_grenade_hits_armored",
				append_husk_to_event_name = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_grenade_hits_armored",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_grenade_hits_armored",
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
				event = "wwise/events/weapon/play_grenade_hits_armored",
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
local super_armor = table.clone(armored)
local disgustingly_resilient = table.clone(unarmored)
local resistant = table.clone(unarmored)
local berserker = table.clone(armored)
local player = table.clone(unarmored)
local surface_fx = {
	snow = {
		[hit_types.stop] = {
			vfx = {
				{
					normal_rotation = true,
					effects = {
						"content/fx/particles/impacts/surfaces/impact_snow_grenade"
					}
				}
			}
		}
	},
	snow_frosty = {
		[hit_types.stop] = {
			vfx = {
				{
					normal_rotation = true,
					effects = {
						"content/fx/particles/impacts/surfaces/impact_snow_grenade"
					}
				}
			}
		}
	}
}
local default_surface_fx = {
	[hit_types.stop] = {
		sfx = {
			{
				group = "surface_material",
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_grenade_surface_impact_large",
				normal_rotation = true
			}
		}
	},
	[hit_types.penetration_entry] = nil,
	[hit_types.penetration_exit] = nil
}

ImpactFxHelper.create_missing_surface_fx(surface_fx, default_surface_fx)

return {
	armor = {
		[armor_types.armored] = armored,
		[armor_types.berserker] = berserker,
		[armor_types.disgustingly_resilient] = disgustingly_resilient,
		[armor_types.player] = player,
		[armor_types.resistant] = resistant,
		[armor_types.super_armor] = super_armor,
		[armor_types.unarmored] = unarmored
	},
	surface = surface_fx
}
