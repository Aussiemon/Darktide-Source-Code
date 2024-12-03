-- chunkname: @scripts/settings/impact_fx/impact_fx_forcesword_force_slash_low.lua

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
				event = "wwise/events/weapon/play_melee_hit_forcesword_hit_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff_death",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hit_forcesword_hit_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff_death",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hit_forcesword_hit_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff_death",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hit_forcesword_hit_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_death",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_force_sword_cleave",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_reduced",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff",
			},
		},
		shove = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
				event = "wwise/events/weapon/play_melee_hit_forcesword_hit_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff_death",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hit_forcesword_hit_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff_death",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hit_forcesword_hit_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff_death",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hit_forcesword_hit_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff_armored",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff_armored",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_reduced",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff_armored",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff_armored",
			},
		},
		shove = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff_armored",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
				event = "wwise/events/weapon/play_melee_hit_forcesword_hit_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff_death",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hit_forcesword_hit_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff_death",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hit_forcesword_hit_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff_death",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hit_forcesword_hit_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_death",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_force_sword_cleave",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_reduced",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff",
			},
		},
		shove = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_force_staff",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
					"content/fx/particles/impacts/weapons/force_sword/force_sword_impact_02",
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
