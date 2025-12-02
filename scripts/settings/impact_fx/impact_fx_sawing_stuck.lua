-- chunkname: @scripts/settings/impact_fx/impact_fx_sawing_stuck.lua

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
		damage_negated = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_chainsword_hit_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_chainsword_hit_impact",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_chainsword_hit_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_chainsword_hit_impact",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_chainsword_hit_impact",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_chain_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_chain_add",
			},
		},
	},
	vfx = {
		blocked = nil,
		damage_negated = nil,
		damage_reduced = nil,
		dead = nil,
		shield_blocked = nil,
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
	},
	blood_ball = {
		blocked = nil,
		damage_negated = nil,
		damage_reduced = nil,
		dead = nil,
		shield_blocked = nil,
		shove = nil,
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
				event = "wwise/events/weapon/play_combat_weapon_chainsword_hit_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_chainsword_hit_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_chainsword_hit_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_chainsword_hit_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_chainsword_hit_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_chainsword_hit_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_chainsword_hit_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_chainsword_hit_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_chain_gen",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_chain_add",
			},
		},
		shove = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_chainsword_hit_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
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
					"content/fx/particles/impacts/weapons/chainsword/chainsword_armor_sparks_01",
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
					"content/fx/particles/impacts/weapons/chainsword/chainsword_armor_sparks_01",
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
					"content/fx/particles/impacts/weapons/chainsword/chainsword_armor_sparks_01",
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
					"content/fx/particles/impacts/weapons/chainsword/chainsword_armor_sparks_01",
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
					"content/fx/particles/impacts/weapons/chainsword/chainsword_armor_sparks_01",
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
		blocked = nil,
		damage_negated = nil,
		damage_reduced = nil,
		dead = nil,
		died = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = nil,
		weakspot_damage = blood_ball,
		damage = blood_ball,
	},
}
local super_armor = table.clone(armored)
local disgustingly_resilient = {
	sfx = {
		blocked = nil,
		damage_reduced = nil,
		dead = nil,
		died = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = nil,
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_chainsword_hit_res",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_chainsword_hit_impact",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_chainsword_hit_res",
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
		shield_blocked = nil,
		shove = nil,
		weakspot_died = disgusting_blood_ball,
		died = disgusting_blood_ball,
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
