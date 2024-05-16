-- chunkname: @scripts/settings/impact_fx/impact_fx_power_sword_2h.lua

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
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_2h_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_2h_gen",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_2h_gen",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_reduced_damage",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_no_damage",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_reduced_damage",
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
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
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
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
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
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
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
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
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
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
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
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
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
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
				},
			},
		},
		blocked = {
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
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
				},
			},
		},
		dead = {
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
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
				},
			},
		},
		shove = {
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
				},
			},
		},
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
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_armor_break",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_armor_break",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_armor",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_armor",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_reduced_damage",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_no_damage",
				only_1p = true,
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_no_damage",
				only_1p = true,
			},
		},
		blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_no_damage",
				only_1p = true,
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_reduced_damage",
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
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
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
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
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
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
				},
			},
		},
		damage = {
			{
				reverse = true,
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_small_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
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
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
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
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
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
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
				},
			},
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
				},
			},
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_reduced_damage_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
				},
			},
		},
		shove = {
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
				},
			},
		},
	},
	blood_ball = {
		weakspot_died = blood_ball,
		died = blood_ball,
		weakspot_damage = blood_ball,
		damage = blood_ball,
	},
}
local super_armor = table.clone(armored)
local disgustingly_resilient = {
	sfx = {
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_resilient",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_resilient",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_resilient",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_reduced_damage",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_power_sword_2h_hit",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_reduced_damage",
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
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_weakspot_melee_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
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
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_small_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
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
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_weakspot_melee_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
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
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_small_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
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
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
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
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
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
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
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
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
				},
			},
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01",
				},
			},
		},
	},
	blood_ball = {
		weakspot_damage = disgusting_blood_ball,
		damage = disgusting_blood_ball,
	},
}
local resistant = table.clone(unarmored)
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
