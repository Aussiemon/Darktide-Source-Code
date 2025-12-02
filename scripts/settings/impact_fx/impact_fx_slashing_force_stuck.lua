-- chunkname: @scripts/settings/impact_fx/impact_fx_slashing_force_stuck.lua

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
		dead = nil,
		shove = nil,
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_gen",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true,
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_gen",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true,
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_gen",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_light_gen",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_reduced_damage",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
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
		weakspot_died = blood_ball,
		died = blood_ball,
		weakspot_damage = blood_ball,
		damage = blood_ball,
		damage_reduced = blood_ball,
	},
}
local armored = {
	sfx = {
		blocked = nil,
		shove = nil,
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_gen",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true,
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_armor_break",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_gen",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_gen",
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
				event = "wwise/events/weapon/melee_hits_sword_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_armor",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_reduced_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_armor",
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
				event = "wwise/events/weapon/melee_hits_sword_no_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_armor",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_armor",
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
		weakspot_died = nil,
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
		damage_negated = {
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
		weakspot_died = blood_ball,
		died = blood_ball,
		weakspot_damage = blood_ball,
		damage = blood_ball,
		damage_reduced = blood_ball,
	},
}
local super_armor = {
	sfx = {
		blocked = nil,
		shove = nil,
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_armor_break",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_gen",
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
				event = "wwise/events/weapon/melee_hits_sword_gen",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_gen",
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
				event = "wwise/events/weapon/melee_hits_sword_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_armor",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_reduced_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_armor",
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
				event = "wwise/events/weapon/play_hit_indicator_melee_slashing_super_armor_no_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_armor",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_armor",
			},
		},
	},
	vfx = {
		blocked = nil,
		damage_reduced = nil,
		dead = nil,
		died = nil,
		shove = nil,
		weakspot_died = nil,
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
		weakspot_died = blood_ball,
		died = blood_ball,
		weakspot_damage = blood_ball,
		damage = blood_ball,
		damage_reduced = blood_ball,
	},
}
local disgustingly_resilient = {
	sfx = {
		blocked = nil,
		shove = nil,
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_gen",
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
				event = "wwise/events/weapon/melee_hits_sword_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_resilient",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_resilient",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_reduced_damage",
			},
		},
		damage_negated = {},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_indicator_melee_slashing_super_armor_no_damage",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_sword_reduced_damage",
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
		weakspot_died = nil,
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_weakspot_melee_01",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_01",
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
	},
	blood_ball = {
		blocked = nil,
		damage_negated = nil,
		damage_reduced = nil,
		dead = nil,
		died = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = nil,
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
