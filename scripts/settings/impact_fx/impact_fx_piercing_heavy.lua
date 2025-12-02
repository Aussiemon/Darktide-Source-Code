-- chunkname: @scripts/settings/impact_fx/impact_fx_piercing_heavy.lua

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
				event = "wwise/events/weapon/melee_hits_blunt_impact_add",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy",
			},
			{
				event = "wwise/events/weapon/play_hit_bone_heavy_addon_dead",
				only_1p = true,
			},
		},
		died = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_impact_add",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy",
			},
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_impact_add",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy",
			},
			{
				event = "wwise/events/weapon/play_hit_bone_heavy_addon",
				only_1p = true,
			},
		},
		damage = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_impact_add",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy",
			},
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_impact_add",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_no_damage",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_no_damage",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy_armour_shield",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy_armour_shield",
			},
		},
		blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy_armour",
			},
		},
		dead = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_impact_add",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy",
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
		blocked = nil,
		weakspot_died = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_impact_add",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_hit_bone_heavy_addon_dead",
				only_1p = true,
			},
		},
		died = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_impact_add",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_axe_armor_break",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy",
			},
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_impact_add",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_axe_armor",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy",
			},
			{
				event = "wwise/events/weapon/play_hit_bone_heavy_addon",
				only_1p = true,
			},
		},
		damage = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_impact_add",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_axe_armor",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy_armour",
			},
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_impact_add",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_axe_armor",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy_armour",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy_armour_shield",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_reduced_damage",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_shield",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy_armour_shield",
			},
		},
		dead = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_impact_add",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy_armour",
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
local super_armor = table.clone(armored)
local disgustingly_resilient = {
	sfx = {
		blocked = nil,
		weakspot_died = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_impact_add",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_axe_res",
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy",
			},
			{
				event = "wwise/events/weapon/play_hit_bone_heavy_addon_dead",
				only_1p = true,
			},
		},
		died = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_impact_add",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_axe_res",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy",
			},
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_impact_add",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy",
			},
			{
				event = "wwise/events/weapon/play_hit_bone_heavy_addon",
				only_1p = true,
			},
		},
		damage = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_impact_add",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_axe_res",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy",
			},
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_impact_add",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_axe_res",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/melee_hits_blunt_no_damage",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy_armour_shield",
			},
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
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy_armour_shield",
			},
		},
		dead = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_impact_add",
				only_1p = true,
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_axe_res",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_piercing_heavy",
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
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/gib_head_bits_01",
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
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_weakspot_01",
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
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_squirt_01",
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
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_small_01",
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
		blocked = nil,
		damage_negated = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = disgusting_blood_ball,
		died = disgusting_blood_ball,
		weakspot_damage = disgusting_blood_ball,
		damage = disgusting_blood_ball,
		damage_reduced = disgusting_blood_ball,
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
