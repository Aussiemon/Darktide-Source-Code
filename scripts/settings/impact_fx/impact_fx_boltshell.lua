-- chunkname: @scripts/settings/impact_fx/impact_fx_boltshell.lua

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
		blocked = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_death",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true,
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_death",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true,
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot",
				only_1p = true,
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_lasgun_ricochet",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
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
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
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
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
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
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		dead = {
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		shove = {
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
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
		shield_blocked = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = blood_ball,
		died = blood_ball,
	},
}
local armored = {
	sfx = {
		shove = nil,
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_armored",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_death",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot_armored",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true,
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_armored_death",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true,
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_armored",
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot_armored",
				only_1p = true,
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_armored",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_armored",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_armored",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated",
				only_1p = true,
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_armored",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated",
				only_1p = true,
			},
		},
		blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_armored",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated",
				only_1p = true,
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
		},
	},
	vfx = {
		shove = nil,
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
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
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
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
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
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
		shield_blocked = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = blood_ball,
		died = blood_ball,
	},
}
local super_armor = {
	sfx = {
		shove = nil,
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_armored",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_armored_death",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot_armored",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true,
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_armored_death",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true,
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_armored",
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot_armored",
				only_1p = true,
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_armored",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_armored",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_armored",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated",
				only_1p = true,
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_armored",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated",
				only_1p = true,
			},
		},
		blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_armored",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated",
				only_1p = true,
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
		},
	},
	vfx = {
		shove = nil,
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/surfaces/impact_super_armor",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/surfaces/impact_super_armor",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/surfaces/impact_super_armor",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/surfaces/impact_super_armor",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/surfaces/impact_super_armor",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/boltpistol/boltpistol_impact_armor_nodamage_01",
				},
			},
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/surfaces/impact_super_armor",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
				},
			},
		},
	},
	linked_decal = {
		blocked = nil,
		damage_negated = nil,
		damage_reduced = nil,
		dead = nil,
		died = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = nil,
		weakspot_damage = default_armor_decal,
		damage = default_armor_decal,
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
local disgustingly_resilient = {
	sfx = {
		blocked = nil,
		shove = nil,
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_death",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true,
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_death",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true,
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot",
				only_1p = true,
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_lasgun_ricochet",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
		},
	},
	vfx = {
		shove = nil,
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_ranged_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/bolter/bolter_impact",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_ranged_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/bolter/bolter_impact",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01",
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
					"content/fx/particles/weapons/rifles/bolter/bolter_impact",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_ranged_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/bolter/bolter_impact",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_ranged_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/bolter/bolter_impact",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/bolter/bolter_impact",
				},
			},
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/bolter/bolter_impact",
				},
			},
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/bolter/bolter_impact",
				},
			},
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_ranged_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/bolter/bolter_impact",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01",
				},
			},
		},
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
		shield_blocked = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = disgusting_blood_ball,
		died = disgusting_blood_ball,
	},
}
local resistant = table.clone(unarmored)
local berserker = table.clone(unarmored)
local player = {
	sfx = {
		died = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = nil,
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
		},
		blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
			},
		},
	},
	vfx = {
		blocked = nil,
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
			{
				effects = {
					"content/fx/particles/weapons/rifles/bolter/bolter_impact",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/surfaces/impact_super_armor",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/bolter/bolter_impact",
				},
			},
		},
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
local surface_fx = {}
local default_surface_fx = {
	[hit_types.stop] = {
		sfx = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_explosive_gen",
				group = "surface_material",
				normal_rotation = true,
			},
		},
		vfx = {
			{
				normal_rotation = true,
				effects = {
					"content/fx/particles/impacts/surfaces/impact_concrete_03",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/bolter/bolter_impact",
				},
			},
		},
	},
	[hit_types.penetration_entry] = {
		sfx = nil,
		vfx = {
			{
				normal_rotation = true,
				effects = {
					"content/fx/particles/impacts/surfaces/impact_concrete_03",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/bolter/bolter_impact",
				},
			},
		},
	},
	[hit_types.penetration_exit] = nil,
}

ImpactFxHelper.create_missing_surface_fx(surface_fx, default_surface_fx)

local surface_decal = {
	brick = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 0.5,
					y = 0.5,
				},
				max = {
					x = 0.6,
					y = 0.6,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_concrete_small_01",
				"content/fx/units/weapons/boltgun_concrete_medium_01",
				"content/fx/units/weapons/boltgun_concrete_large_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.5,
					y = 0.5,
				},
				max = {
					x = 0.6,
					y = 0.6,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_concrete_small_01",
				"content/fx/units/weapons/boltgun_concrete_medium_01",
				"content/fx/units/weapons/boltgun_concrete_large_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.5,
					y = 0.5,
				},
				max = {
					x = 0.6,
					y = 0.6,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_concrete_small_01",
				"content/fx/units/weapons/boltgun_concrete_medium_01",
				"content/fx/units/weapons/boltgun_concrete_large_01",
			},
		},
	},
	concrete = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 0.5,
					y = 0.5,
				},
				max = {
					x = 0.6,
					y = 0.6,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_concrete_small_01",
				"content/fx/units/weapons/boltgun_concrete_medium_01",
				"content/fx/units/weapons/boltgun_concrete_large_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.5,
					y = 0.5,
				},
				max = {
					x = 0.6,
					y = 0.6,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_concrete_small_01",
				"content/fx/units/weapons/boltgun_concrete_medium_01",
				"content/fx/units/weapons/boltgun_concrete_large_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.5,
					y = 0.5,
				},
				max = {
					x = 0.6,
					y = 0.6,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_concrete_small_01",
				"content/fx/units/weapons/boltgun_concrete_medium_01",
				"content/fx/units/weapons/boltgun_concrete_large_01",
			},
		},
	},
	metal_solid = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2,
				},
				max = {
					x = 0.2,
					y = 0.2,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_metal_small_01",
				"content/fx/units/weapons/boltgun_metal_medium_01",
				"content/fx/units/weapons/boltgun_metal_large_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2,
				},
				max = {
					x = 0.2,
					y = 0.2,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_metal_small_01",
				"content/fx/units/weapons/boltgun_metal_medium_01",
				"content/fx/units/weapons/boltgun_metal_large_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2,
				},
				max = {
					x = 0.2,
					y = 0.2,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_metal_small_01",
				"content/fx/units/weapons/boltgun_metal_medium_01",
				"content/fx/units/weapons/boltgun_metal_large_01",
			},
		},
	},
	metal_sheet = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2,
				},
				max = {
					x = 0.2,
					y = 0.2,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_metal_small_01",
				"content/fx/units/weapons/boltgun_metal_medium_01",
				"content/fx/units/weapons/boltgun_metal_large_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2,
				},
				max = {
					x = 0.2,
					y = 0.2,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_metal_small_01",
				"content/fx/units/weapons/boltgun_metal_medium_01",
				"content/fx/units/weapons/boltgun_metal_large_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2,
				},
				max = {
					x = 0.2,
					y = 0.2,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_metal_small_01",
				"content/fx/units/weapons/boltgun_metal_medium_01",
				"content/fx/units/weapons/boltgun_metal_large_01",
			},
		},
	},
	metal_catwalk = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2,
				},
				max = {
					x = 0.2,
					y = 0.2,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_metal_small_01",
				"content/fx/units/weapons/boltgun_metal_medium_01",
				"content/fx/units/weapons/boltgun_metal_large_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2,
				},
				max = {
					x = 0.2,
					y = 0.2,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_metal_small_01",
				"content/fx/units/weapons/boltgun_metal_medium_01",
				"content/fx/units/weapons/boltgun_metal_large_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2,
				},
				max = {
					x = 0.2,
					y = 0.2,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_metal_small_01",
				"content/fx/units/weapons/boltgun_metal_medium_01",
				"content/fx/units/weapons/boltgun_metal_large_01",
			},
		},
	},
	cloth = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 0.4,
					y = 0.4,
				},
				max = {
					x = 0.4,
					y = 0.4,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_cloth_large_01",
				"content/fx/units/weapons/small_caliber_cloth_medium_01",
				"content/fx/units/weapons/small_caliber_cloth_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.4,
					y = 0.4,
				},
				max = {
					x = 0.4,
					y = 0.4,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_cloth_large_01",
				"content/fx/units/weapons/small_caliber_cloth_medium_01",
				"content/fx/units/weapons/small_caliber_cloth_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.4,
					y = 0.4,
				},
				max = {
					x = 0.4,
					y = 0.4,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_cloth_large_01",
				"content/fx/units/weapons/small_caliber_cloth_medium_01",
				"content/fx/units/weapons/small_caliber_cloth_small_01",
			},
		},
	},
	glass_breakable = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 0.8,
					y = 0.8,
				},
				max = {
					x = 0.8,
					y = 0.8,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_large_01",
				"content/fx/units/weapons/small_caliber_glass_medium_01",
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.8,
					y = 0.8,
				},
				max = {
					x = 0.8,
					y = 0.8,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_large_01",
				"content/fx/units/weapons/small_caliber_glass_medium_01",
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.8,
					y = 0.8,
				},
				max = {
					x = 0.8,
					y = 0.8,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_large_01",
				"content/fx/units/weapons/small_caliber_glass_medium_01",
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
	},
	glass_unbreakable = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 0.8,
					y = 0.8,
				},
				max = {
					x = 0.8,
					y = 0.8,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_large_01",
				"content/fx/units/weapons/small_caliber_glass_medium_01",
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.8,
					y = 0.8,
				},
				max = {
					x = 0.8,
					y = 0.8,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_large_01",
				"content/fx/units/weapons/small_caliber_glass_medium_01",
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.8,
					y = 0.8,
				},
				max = {
					x = 0.8,
					y = 0.8,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_large_01",
				"content/fx/units/weapons/small_caliber_glass_medium_01",
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
	},
	nurgle_flesh = NO_SURFACE_DECAL,
	wood_solid = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 0.4,
					y = 0.4,
				},
				max = {
					x = 0.4,
					y = 0.4,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01",
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.4,
					y = 0.4,
				},
				max = {
					x = 0.4,
					y = 0.4,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01",
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.4,
					y = 0.4,
				},
				max = {
					x = 0.4,
					y = 0.4,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01",
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
	},
	wood_plywood = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 0.4,
					y = 0.4,
				},
				max = {
					x = 0.4,
					y = 0.4,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01",
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.4,
					y = 0.4,
				},
				max = {
					x = 0.4,
					y = 0.4,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01",
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.4,
					y = 0.4,
				},
				max = {
					x = 0.4,
					y = 0.4,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01",
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
	},
}

ImpactFxHelper.create_missing_surface_decals(surface_decal)

return {
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
	surface_decal = surface_decal,
}
