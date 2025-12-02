-- chunkname: @scripts/settings/impact_fx/impact_fx_blunt_heavy.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local ImpactFxHelper = require("scripts/utilities/impact_fx_helper")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local hit_types = SurfaceMaterialSettings.hit_types
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
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true,
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true,
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true,
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_gen",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_reduced_damage",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_no_damage",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
			},
		},
		blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_no_damage",
			},
		},
		shove = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_player_push_unarmored",
			},
		},
	},
	vfx = {
		blocked = nil,
		dead = nil,
		shove = nil,
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
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
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
		},
	},
	blood_ball = {
		blocked = nil,
		damage_negated = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = blood_ball,
		died = blood_ball,
		weakspot_damage = blood_ball,
		damage = blood_ball,
		damage_reduced = blood_ball,
		dead = blood_ball,
	},
}
local armored = {
	sfx = {
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_armor_break",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true,
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_armor_break",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_armor",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_armor",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_reduced_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_armor",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_no_damage",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
			},
		},
		blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_no_damage",
			},
		},
		shove = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_player_push_armored",
			},
		},
	},
	vfx = {
		blocked = nil,
		dead = nil,
		shove = nil,
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
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
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
		},
	},
	blood_ball = {
		blocked = nil,
		damage_negated = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = blood_ball,
		died = blood_ball,
		weakspot_damage = blood_ball,
		damage = blood_ball,
		damage_reduced = blood_ball,
		dead = blood_ball,
	},
}
local super_armor = {
	sfx = {
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_armor_break",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true,
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_armor_break",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_armor",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_armor",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_reduced_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_armor",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_melee_super_armor_no_damage",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
			},
		},
		blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_melee_super_armor_no_damage",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_no_damage",
			},
		},
		shove = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_player_push_super_armor",
			},
		},
	},
	vfx = {
		blocked = nil,
		dead = nil,
		shove = nil,
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
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
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
		},
	},
	blood_ball = {
		blocked = nil,
		damage_negated = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = blood_ball,
		died = blood_ball,
		weakspot_damage = blood_ball,
		damage = blood_ball,
		damage_reduced = blood_ball,
		dead = blood_ball,
	},
}
local disgustingly_resilient = {
	sfx = {
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_resilient",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true,
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_resilient",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_hit_addon_bone",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true,
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_resilient",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_reduced_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_resilient",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_no_damage",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
			},
		},
		blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_no_damage",
			},
		},
		shove = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_player_push_resilient",
			},
		},
	},
	vfx = {
		blocked = nil,
		dead = nil,
		shove = nil,
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
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
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
		},
	},
	blood_ball = {
		blocked = nil,
		damage_negated = nil,
		dead = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = disgusting_blood_ball,
		died = disgusting_blood_ball,
		weakspot_damage = disgusting_blood_ball,
		damage = disgusting_blood_ball,
		damage_reduced = disgusting_blood_ball,
	},
}
local resistant = table.clone(unarmored)
local berserker = table.clone(unarmored)
local player
local surface_fx = {}
local default_surface_fx = {
	[hit_types.stop] = {
		vfx = nil,
		sfx = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/melee_hits_blunt_no_damage",
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
