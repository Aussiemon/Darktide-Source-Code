﻿-- chunkname: @scripts/settings/impact_fx/impact_fx_knife.lua

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
				event = "wwise/events/weapon/melee_hits_knife_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_gen",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_death_knife",
				only_1p = true,
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_gen",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_reduced_damage",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_melee_slashing_super_armor_no_damage",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_shield",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_reduced_damage",
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
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01",
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
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01",
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
				reverse = true,
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_reduced_damage_01",
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
				reverse = true,
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_reduced_damage_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked",
				},
			},
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked",
				},
			},
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked",
				},
			},
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_small_01",
				},
			},
		},
		shove = {
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
		},
	},
	blood_ball = {
		weakspot_died = blood_ball,
		died = blood_ball,
		weakspot_damage = blood_ball,
		damage = blood_ball,
		damage_reduced = blood_ball,
	},
}
local armored = {
	sfx = {
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_armor_break",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_armor_break",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_gen",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_death_knife",
				only_1p = true,
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_armor",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_armor",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_reduced_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_armor",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_melee_slashing_super_armor_no_damage",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_shield",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_reduced_damage",
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
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_reduced_damage_01",
				},
			},
		},
		shove = {
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
		},
	},
	blood_ball = {
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
				event = "wwise/events/weapon/melee_hits_knife_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_resilient",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_resilient",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_death_knife",
				only_1p = true,
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_resilient",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_reduced_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_resilient",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_melee_slashing_super_armor_no_damage",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_shield",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_reduced_damage",
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
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01",
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
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_01",
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
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01",
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
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked",
				},
			},
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked",
				},
			},
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked",
				},
			},
		},
		dead = {
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
		},
		shove = {
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
		},
	},
	blood_ball = {
		weakspot_damage = disgusting_blood_ball,
		damage = disgusting_blood_ball,
		damage_reduced = disgusting_blood_ball,
	},
}
local resistant = table.clone(unarmored)
local berserker = {
	sfx = {
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_gen",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_death_knife",
				only_1p = true,
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_gen",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_reduced_damage",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_melee_slashing_super_armor_no_damage",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_shield",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_knife_reduced_damage",
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
					"content/fx/particles/impacts/impact_sweat_01",
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
			{
				effects = {
					"content/fx/particles/impacts/impact_sweat_01",
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
					"content/fx/particles/impacts/impact_sweat_01",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/impact_sweat_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_reduced_damage_01",
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
					"content/fx/particles/impacts/impact_sweat_01",
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
					"content/fx/particles/impacts/impact_sweat_01",
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
					"content/fx/particles/impacts/impact_sweat_01",
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
		shove = {
			{
				effects = {
					"content/fx/particles/impacts/impact_sweat_01",
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
