-- chunkname: @scripts/settings/impact_fx/impact_fx_throwing_knife_zealot.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local ImpactFxHelper = require("scripts/utilities/impact_fx_helper")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local hit_types = SurfaceMaterialSettings.hit_types
local default_armor_decal
local blood_ball = {
	"content/decals/blood_ball/blood_ball",
}
local disgusting_blood_ball = {
	"content/decals/blood_ball/blood_ball_poxwalker",
}
local unarmored = {
	sfx = {
		weakspot_died = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_death_knife",
				only_1p = true,
			},
		},
		died = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_death_knife",
				only_1p = true,
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_death_knife",
				only_1p = true,
			},
		},
		damage = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife_negate",
			},
		},
		dead = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
		},
	},
	vfx = {
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_ranged_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_ranged_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_small_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_reduced_damage_01",
				},
			},
		},
	},
	linked_decal = {
		weakspot_died = default_armor_decal,
		died = default_armor_decal,
		weakspot_damage = default_armor_decal,
		damage = default_armor_decal,
		damage_reduced = default_armor_decal,
	},
	blood_ball = {
		weakspot_died = blood_ball,
		died = blood_ball,
		weakspot_damage = blood_ball,
		damage = blood_ball,
	},
}
local armored = {
	sfx = {
		weakspot_died = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_death_knife",
				only_1p = true,
			},
		},
		died = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
		},
		damage = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife_armored",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife_armored",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife_negate",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife_negate",
			},
		},
		blocked = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife_negate",
			},
		},
		dead = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
		},
	},
	vfx = {
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/autogun/autogun_impact_armored",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/autogun/autogun_impact_armored",
				},
			},
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/autogun/autogun_impact_armored",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_small_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/autogun/autogun_impact_armored",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_reduced_damage_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/autogun/autogun_impact_armored",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_reduced_damage_01",
				},
			},
		},
	},
	linked_decal = {
		weakspot_died = default_armor_decal,
		died = default_armor_decal,
		weakspot_damage = default_armor_decal,
		damage = default_armor_decal,
		damage_reduced = default_armor_decal,
	},
	blood_ball = {
		weakspot_died = blood_ball,
		died = blood_ball,
	},
}
local super_armor = table.clone(armored)
local disgustingly_resilient = {
	sfx = {
		weakspot_died = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_death_knife",
				only_1p = true,
			},
		},
		died = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_death_knife",
				only_1p = true,
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
		},
		damage = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife_negate",
			},
		},
		dead = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
		},
	},
	vfx = {
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_ranged_01",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_01",
				},
			},
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_ranged_01",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_small_01",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_small_01",
				},
			},
		},
	},
	linked_decal = {
		weakspot_died = default_armor_decal,
		died = default_armor_decal,
		weakspot_damage = default_armor_decal,
		damage = default_armor_decal,
		damage_reduced = default_armor_decal,
	},
	blood_ball = {
		weakspot_died = disgusting_blood_ball,
		died = disgusting_blood_ball,
	},
}
local resistant = table.clone(unarmored)
local berserker = table.clone(unarmored)
local player = {
	sfx = {
		weakspot_died = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
		},
		died = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
		},
		damage = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_throwing_knife_negate",
			},
		},
	},
	vfx = {
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/surfaces/impact_super_armor",
				},
			},
		},
	},
	linked_decal = {},
	blood_ball = {},
}
local surface_fx = {}
local default_surface_fx = {
	[hit_types.stop] = {
		sfx = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_sharp_object",
				group = "surface_material",
				normal_rotation = true,
			},
		},
		vfx = {
			{
				normal_rotation = true,
				effects = {
					"content/fx/particles/impacts/weapons/autogun/autogun_impact_wall",
				},
			},
		},
	},
	[hit_types.penetration_entry] = {
		sfx = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_bullet_hits_sharp_object",
				group = "surface_material",
				normal_rotation = true,
			},
		},
		vfx = {
			{
				normal_rotation = true,
				effects = {
					"content/fx/particles/impacts/weapons/autogun/autogun_impact_wall",
				},
			},
		},
	},
	[hit_types.penetration_exit] = nil,
}

ImpactFxHelper.create_missing_surface_fx(surface_fx, default_surface_fx)

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
	},
	surface = surface_fx,
	surface_decal = surface_decal,
}
