local abilities = {
	fire_grenade = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		stat_buff = "extra_max_amount_of_grenades",
		inventory_item_name = "content/items/weapons/player/grenade_fire",
		icon = "content/ui/materials/icons/abilities/combat/default",
		max_charges = 2,
		archetypes = {
			"veteran",
			"zealot"
		}
	},
	fire_grenade_increased_amount = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		stat_buff = "extra_max_amount_of_grenades",
		inventory_item_name = "content/items/weapons/player/grenade_fire",
		icon = "content/ui/materials/icons/abilities/combat/default",
		max_charges = 4,
		archetypes = {
			"veteran",
			"zealot"
		}
	},
	shock_grenade = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		stat_buff = "extra_max_amount_of_grenades",
		inventory_item_name = "content/items/weapons/player/grenade_shock",
		icon = "content/ui/materials/icons/abilities/combat/default",
		max_charges = 2,
		archetypes = {
			"zealot"
		}
	},
	shock_grenade_increased_amount = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		stat_buff = "extra_max_amount_of_grenades",
		inventory_item_name = "content/items/weapons/player/grenade_shock",
		icon = "content/ui/materials/icons/abilities/combat/default",
		max_charges = 4,
		archetypes = {
			"zealot"
		}
	},
	base_shout = {
		ability_template = "base_shout",
		hud_icon = "content/ui/materials/icons/abilities/default",
		ability_type = "combat_ability",
		cooldown = 30,
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		max_charges = 1,
		archetypes = {
			"psyker",
			"veteran",
			"zealot",
			"ogryn"
		}
	},
	base_invisibility = {
		hud_icon = "content/ui/materials/icons/abilities/default",
		ability_template = "base_stance",
		cooldown = 30,
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		ability_type = "combat_ability",
		max_charges = 1,
		ability_template_tweak_data = {
			buff_to_add = "shade_invisibility"
		},
		archetypes = {
			"psyker",
			"veteran",
			"zealot",
			"ogryn"
		}
	},
	base_combat_attack = {
		ability_template = "base_combat_attack",
		hud_icon = "content/ui/materials/icons/abilities/default",
		ability_type = "combat_ability",
		cooldown = 30,
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		max_charges = 1,
		archetypes = {
			"psyker",
			"veteran",
			"zealot",
			"ogryn"
		}
	}
}

return abilities
