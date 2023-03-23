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
		"content/fx/units/vfx_decal_lasgun_scorchmark"
	}
}
local blood_ball = {
	"content/decals/blood_ball/blood_ball"
}
local disgusting_blood_ball = {
	"content/decals/blood_ball/blood_ball_poxwalker"
}
local unarmored = {
	sfx = {},
	vfx = {},
	linked_decal = {},
	blood_ball = {
		weakspot_died = blood_ball,
		died = blood_ball,
		dead = blood_ball
	}
}
local armored = table.clone(unarmored)
local super_armor = table.clone(unarmored)
local disgustingly_resilient = table.clone(unarmored)
local resistant = table.clone(unarmored)
local berserker = table.clone(unarmored)
local prop_armor = table.clone(armored)
local player = {
	sfx = {
		damage = {
			{
				event = "wwise/events/player/play_player_get_hit_bullet_laser",
				hit_direction_interface = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored_husk",
				only_3p = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/player/play_player_get_hit_bullet_laser",
				hit_direction_interface = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_armored_husk",
				only_3p = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated_husk",
				only_3p = true
			}
		},
		toughness_absorbed = {
			{
				event = "wwise/events/player/play_toughness_hits",
				hit_direction_interface = true
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated_husk",
				only_3p = true
			}
		}
	},
	vfx = {
		toughness_absorbed = {}
	},
	linked_decal = {},
	blood_ball = {}
}
local default_surface_fx = {}
local surface_decal = {}

ImpactFxHelper.create_missing_surface_decals(surface_decal)

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
		[hit_types.penetration_exit] = nil
	},
	surface_decal = surface_decal
}
