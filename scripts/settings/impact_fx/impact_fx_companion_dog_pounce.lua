-- chunkname: @scripts/settings/impact_fx/impact_fx_companion_dog_pounce.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local unarmored = {
	sfx = {
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_flesh",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_bone_heavy_addon",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_flesh",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_bone_heavy_addon_dead",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_flesh",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_hit_addon_flesh",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_flesh",
			},
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_melee_hits_blood_add",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_flesh",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_flesh",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_armour",
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
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_flesh",
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
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
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
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		shove = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
	},
}
local armored = {
	sfx = {
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_armour",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_bone_heavy_addon",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_armour",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_bone_heavy_addon_dead",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_armour",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_hit_addon_flesh",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_armour",
			},
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_melee_hits_blood_add",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_armour",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_physical_slap_armor",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_armour",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_physical_slap_armor",
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
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_armour",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_physical_slap_armor",
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
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
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
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		shove = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
	},
}
local super_armor = {
	sfx = {
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_armour",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_bone_heavy_addon",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_armour",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_bone_heavy_addon_dead",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_armour",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_hit_addon_flesh",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_armour",
			},
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_melee_hits_blood_add",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_armour",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_physical_slap_armor",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_armour",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_physical_slap_armor",
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
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_armour",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_melee_hits_physical_slap_armor",
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
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
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
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		shove = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
	},
}
local disgustingly_resilient = {
	sfx = {
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_flesh",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_bone_heavy_addon",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_flesh",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_hit_bone_heavy_addon_dead",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_flesh",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_weapon_hit_addon_flesh",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_flesh",
			},
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_melee_hits_blood_add",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_flesh",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_flesh",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_armour",
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
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_companion_pounce_flesh",
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
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
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
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
		shove = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
		},
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
