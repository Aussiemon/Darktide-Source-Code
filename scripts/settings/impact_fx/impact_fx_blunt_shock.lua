-- chunkname: @scripts/settings/impact_fx/impact_fx_blunt_shock.lua

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
		weakspot_died = {
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
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_reduced_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_no_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
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
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
				},
			},
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
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
					"content/fx/particles/impacts/damage_blocked",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
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
					"content/fx/particles/impacts/damage_blocked",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
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
		blocked = nil,
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
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
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
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
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
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
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
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
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
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_no_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
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
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_blunt_metal_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_blunt_metal_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
				},
			},
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_blunt_metal_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_blunt_metal_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_blunt_metal_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
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
					"content/fx/particles/impacts/damage_blocked",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
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
					"content/fx/particles/impacts/damage_blocked",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
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
		blocked = nil,
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
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
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
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
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
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_armor",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_armor",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_melee_super_armor_no_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
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
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_blunt_metal_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_blunt_metal_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
				},
			},
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_blunt_metal_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_blunt_metal_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_blunt_metal_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
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
					"content/fx/particles/impacts/damage_blocked",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
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
					"content/fx/particles/impacts/damage_blocked",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
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
		blocked = nil,
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
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
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
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
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
				event = "wwise/events/weapon/play_powermaul_1h_hit",
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
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
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
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_no_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
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
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
				},
			},
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_weakspot_melee_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_small_01",
				},
			},
			{
				reverse = true,
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_reduced_damage_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_reduced_damage_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
				},
			},
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
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
local resistant = {
	sfx = {
		blocked = nil,
		weakspot_died = {
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
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
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
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_no_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_hit",
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
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
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
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
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
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
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
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
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
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
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
					"content/fx/particles/impacts/damage_blocked",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
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
					"content/fx/particles/impacts/damage_blocked",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/impact_shock_01",
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
local berserker = table.clone(unarmored)
local player

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
