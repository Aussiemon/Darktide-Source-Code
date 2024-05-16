-- chunkname: @scripts/settings/impact_fx/impact_fx_blunt_thunder.lua

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
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_shared_gore_blood_small",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_thunder_hammer_cleave",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_shared_gore_blood_small",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_thunder_hammer_cleave",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_thunder_hammer_cleave",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_shared_gore_blood_small",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_thunder_hammer_cleave",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_shared_gore_blood_small",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_thunder_hammer_cleave",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
		},
		stopped = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weapon_addon_hit_thunderhammer_sparks",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_shared_gore_blood_small",
			},
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_player_wpn_refl_thunder",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
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
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_melee_01",
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
			{
				effects = {
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_thunder_hammer_default",
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
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_thunder_hammer_default",
				},
			},
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_melee_01",
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
			{
				effects = {
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_thunder_hammer_default",
				},
			},
		},
		damage = {
			{
				normal_rotation = false,
				reverse = false,
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_small_01",
				},
			},
			{
				normal_rotation = false,
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
			{
				effects = {
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_thunder_hammer_default",
				},
			},
		},
		stopped = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_small_01",
				},
			},
			{
				normal_rotation = false,
				reverse = true,
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_reduced_damage_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_thunder_hammer_default",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
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
		dead = {
			{
				normal_rotation = false,
				reverse = true,
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
		weakspot_died = blood_ball,
		died = blood_ball,
		weakspot_damage = blood_ball,
		damage = blood_ball,
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
				event = "wwise/events/weapon/play_combat_shared_gore_blood_small",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_thunder_hammer_cleave",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				event = "wwise/events/weapon/play_combat_shared_gore_blood_small",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_thunder_hammer_cleave",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_thunder_hammer_cleave",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				event = "wwise/events/weapon/play_combat_shared_gore_blood_small",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_thunder_hammer_cleave",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				event = "wwise/events/weapon/play_combat_shared_gore_blood_small",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_thunder_hammer_cleave",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
		},
		stopped = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weapon_addon_hit_thunderhammer_sparks",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_shared_gore_blood_small",
			},
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_player_wpn_refl_thunder",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
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
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_thunder_hammer_default",
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
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_thunder_hammer_default",
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
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_thunder_hammer_default",
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
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_thunder_hammer_default",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate",
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
		stopped = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_small_01",
				},
			},
			{
				normal_rotation = false,
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
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_thunder_hammer_default",
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
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
		},
		shove = {
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate",
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
		stopped = blood_ball,
		dead = blood_ball,
	},
}
local super_armor = table.clone(armored)
local disgustingly_resilient = {
	sfx = {
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_shared_gore_blood_small",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_thunder_hammer_cleave",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_shared_gore_blood_small",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_thunder_hammer_cleave",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_thunder_hammer_cleave",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_shared_gore_blood_small",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_thunder_hammer_cleave",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weapon_addon_hit_thunderhammer_sparks",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
		},
		stopped = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_heavy",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weapon_addon_hit_thunderhammer_sparks",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_shared_gore_blood_small",
			},
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_player_wpn_refl_thunder",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
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
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_thunder_hammer_default",
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
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_thunder_hammer_default",
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
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_thunder_hammer_default",
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
				normal_rotation = false,
				reverse = true,
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_reduced_damage_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_thunder_hammer_default",
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
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_thunder_hammer_default",
				},
			},
		},
		stopped = {
			{
				normal_rotation = false,
				reverse = true,
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_small_01",
				},
			},
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
					"content/fx/particles/impacts/weapons/thunder_hammer/impact_thunder_hammer_default",
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
		dead = {
			{
				normal_rotation = false,
				reverse = true,
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_reduced_damage_01",
				},
			},
		},
	},
	blood_ball = {
		weakspot_died = disgusting_blood_ball,
		died = disgusting_blood_ball,
		weakspot_damage = disgusting_blood_ball,
		damage = disgusting_blood_ball,
		stopped = disgusting_blood_ball,
		dead = disgusting_blood_ball,
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
