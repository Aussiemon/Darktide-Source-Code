local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local maniac_talent_settings = TalentSettings.zealot_2
local preacher_talent_settings = TalentSettings.zealot_3
local abilities = {
	zealot_dash = {
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_maniac_hud",
		ability_template = "dash",
		cooldown = 10,
		icon = "content/ui/materials/icons/abilities/combat/default",
		ability_type = "combat_ability",
		max_charges = 2,
		ability_template_tweak_data = {
			lunge_template_name = LungeTemplates.zealot_dash.name
		},
		archetypes = {
			"zealot"
		}
	},
	zealot_targeted_dash = {
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_maniac_hud",
		ability_template = "targeted_dash",
		cooldown = 10,
		icon = "content/ui/materials/icons/abilities/combat/default",
		ability_type = "combat_ability",
		max_charges = 1,
		ability_template_tweak_data = {
			lunge_template_name = LungeTemplates.zealot_dash.name
		},
		archetypes = {
			"zealot"
		}
	},
	zealot_maniac_targeted_dash = {
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_maniac_hud",
		ability_template = "targeted_dash",
		icon = "content/ui/materials/icons/abilities/combat/default",
		ability_type = "combat_ability",
		ability_template_tweak_data = {
			lunge_template_name = LungeTemplates.zealot_dash.name
		},
		cooldown = maniac_talent_settings.combat_ability.cooldown,
		max_charges = maniac_talent_settings.combat_ability.max_charges,
		archetypes = {
			"zealot"
		}
	},
	zealot_maniac_targeted_dash_improved = {
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_maniac_hud",
		ability_template = "targeted_dash",
		icon = "content/ui/materials/icons/abilities/combat/default",
		ability_type = "combat_ability",
		ability_template_tweak_data = {
			lunge_template_name = LungeTemplates.zealot_dash.name
		},
		cooldown = maniac_talent_settings.combat_ability_3.cooldown,
		max_charges = maniac_talent_settings.combat_ability_3.max_charges,
		archetypes = {
			"zealot"
		}
	},
	zealot_maniac_shock_grenade = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		stat_buff = "extra_max_amount_of_grenades",
		inventory_item_name = "content/items/weapons/player/grenade_shock",
		icon = "content/ui/materials/icons/abilities/combat/default",
		max_charges = maniac_talent_settings.combat_ability.max_charges,
		archetypes = {
			"zealot"
		}
	},
	zealot_maniac_shock_grenade_increased_amount = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		stat_buff = "extra_max_amount_of_grenades",
		inventory_item_name = "content/items/weapons/player/grenade_shock",
		icon = "content/ui/materials/icons/abilities/combat/default",
		max_charges = maniac_talent_settings.mixed_1.max_charges,
		archetypes = {
			"zealot"
		}
	},
	zealot_preacher_fire_grenade = {
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
	zealot_preacher_fire_grenade_increased_amount = {
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
	zealot_shout = {
		ability_template = "zealot_shout",
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_preacher_hud",
		ability_type = "combat_ability",
		cooldown = 25,
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		max_charges = 1,
		archetypes = {
			"zealot"
		}
	},
	zealot_preacher_relic = {
		can_be_wielded_when_depleted = false,
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_protectorate_hud",
		inventory_item_name = "content/items/weapons/player/preacher_relic",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		ability_type = "combat_ability",
		max_charges = preacher_talent_settings.combat_ability.max_charges,
		cooldown = preacher_talent_settings.combat_ability.cooldown,
		archetypes = {
			"psyker"
		}
	},
	zealot_preacher_relic_more_charges = {
		can_be_wielded_when_depleted = false,
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_protectorate_hud",
		inventory_item_name = "content/items/weapons/player/preacher_relic",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		ability_type = "combat_ability",
		max_charges = preacher_talent_settings.combat_ability_1.max_charges,
		cooldown = preacher_talent_settings.combat_ability_1.cooldown,
		archetypes = {
			"psyker"
		}
	},
	zealot_invisibility = {
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_preacher_hud",
		ability_template = "zealot_invisibility",
		cooldown = 30,
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		ability_type = "combat_ability",
		max_charges = 1,
		ability_template_tweak_data = {
			buff_to_add = "zealot_pious_stabguy_invisibility"
		},
		archetypes = {
			"psyker",
			"veteran",
			"zealot",
			"ogryn"
		}
	},
	zealot_invisibility_improved = {
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_preacher_hud",
		ability_template = "zealot_invisibility",
		cooldown = 30,
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		ability_type = "combat_ability",
		max_charges = 1,
		ability_template_tweak_data = {
			buff_to_add = "zealot_pious_stabguy_invisibility_increased_duration"
		},
		archetypes = {
			"psyker",
			"veteran",
			"zealot",
			"ogryn"
		}
	}
}

return abilities
