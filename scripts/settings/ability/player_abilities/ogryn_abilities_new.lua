local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local TalentSettings = require("scripts/settings/talent/talent_settings_new")
local bonebreaker_talent_settings = TalentSettings.ogryn_2
local gunlugger_talent_settings = TalentSettings.ogryn_1
local abilities = {
	ogryn_charge = {
		hud_icon = "content/ui/textures/icons/abilities/hud/ogryn/ogryn_ability_bull_rush",
		ability_template = "ogryn_charge",
		icon = "content/ui/materials/icons/abilities/combat/default",
		ability_type = "combat_ability",
		ability_template_tweak_data = {
			lunge_template_name = LungeTemplates.ogryn_charge.name
		},
		cooldown = bonebreaker_talent_settings.combat_ability.cooldown,
		max_charges = bonebreaker_talent_settings.combat_ability.max_charges,
		archetypes = {
			"ogryn"
		}
	},
	ogryn_charge_cooldown_reduction = {
		hud_icon = "content/ui/textures/icons/abilities/hud/ogryn/ogryn_ability_bull_rush",
		ability_template = "ogryn_charge",
		icon = "content/ui/materials/icons/abilities/combat/default",
		ability_type = "combat_ability",
		ability_template_tweak_data = {
			lunge_template_name = LungeTemplates.ogryn_charge.name
		},
		cooldown = bonebreaker_talent_settings.combat_ability_3.cooldown,
		max_charges = bonebreaker_talent_settings.combat_ability_3.max_charges,
		archetypes = {
			"ogryn"
		}
	},
	ogryn_charge_damage = {
		hud_icon = "content/ui/textures/icons/abilities/hud/ogryn/ogryn_ability_bull_rush",
		ability_template = "ogryn_charge",
		icon = "content/ui/materials/icons/abilities/combat/default",
		ability_type = "combat_ability",
		ability_template_tweak_data = {
			lunge_template_name = LungeTemplates.ogryn_charge_damage.name
		},
		cooldown = bonebreaker_talent_settings.combat_ability_1.cooldown,
		max_charges = bonebreaker_talent_settings.combat_ability_1.max_charges,
		archetypes = {
			"ogryn"
		}
	},
	ogryn_charge_increased_distance = {
		hud_icon = "content/ui/textures/icons/abilities/hud/ogryn/ogryn_longer_charge",
		ability_template = "ogryn_charge",
		icon = "content/ui/materials/icons/abilities/combat/default",
		ability_type = "combat_ability",
		ability_template_tweak_data = {
			lunge_template_name = LungeTemplates.ogryn_charge_increased_distance.name
		},
		cooldown = bonebreaker_talent_settings.combat_ability_2.cooldown,
		max_charges = bonebreaker_talent_settings.combat_ability_2.max_charges,
		archetypes = {
			"ogryn"
		}
	},
	ogryn_charge_bleed = {
		hud_icon = "content/ui/textures/icons/abilities/hud/ogryn/ogryn_ability_bull_rush",
		ability_template = "ogryn_charge",
		icon = "content/ui/materials/icons/abilities/combat/default",
		ability_type = "combat_ability",
		ability_template_tweak_data = {
			lunge_template_name = LungeTemplates.ogryn_charge_bleed.name
		},
		cooldown = bonebreaker_talent_settings.combat_ability_3.cooldown,
		max_charges = bonebreaker_talent_settings.combat_ability_3.max_charges,
		archetypes = {
			"ogryn"
		}
	},
	ogryn_ranged_stance = {
		required_weapon_type = "ranged",
		hud_icon = "content/ui/textures/icons/abilities/hud/ogryn/ogryn_ability_speshul_ammo",
		ability_template = "ogryn_gunlugger_stance",
		ability_type = "combat_ability",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		ability_template_tweak_data = {
			buff_to_add = "ogryn_ranged_stance"
		},
		cooldown = gunlugger_talent_settings.combat_ability.cooldown,
		max_charges = gunlugger_talent_settings.combat_ability.max_charges,
		archetypes = {
			"ogryn"
		}
	},
	ogryn_taunt_shout = {
		ability_template = "ogryn_taunt_shout",
		hud_icon = "content/ui/textures/icons/abilities/hud/ogryn/ogryn_ability_taunt",
		ability_type = "combat_ability",
		cooldown = 45,
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		max_charges = 1,
		archetypes = {
			"ogryn"
		}
	},
	ogryn_grenade_frag = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		stat_buff = "extra_max_amount_of_grenades",
		inventory_item_name = "content/items/weapons/player/grenade_ogryn_frag",
		icon = "content/ui/materials/icons/abilities/combat/default",
		show_in_friendly_hud = true,
		max_charges = 1,
		archetypes = {
			"ogryn"
		}
	},
	ogryn_grenade_box = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		stat_buff = "extra_max_amount_of_grenades",
		inventory_item_name = "content/items/weapons/player/grenade_box_ogryn",
		icon = "content/ui/materials/icons/abilities/combat/default",
		show_in_friendly_hud = true,
		max_charges = 2,
		archetypes = {
			"ogryn"
		}
	},
	ogryn_grenade_box_cluster = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		stat_buff = "extra_max_amount_of_grenades",
		inventory_item_name = "content/items/weapons/player/grenade_box_ogryn_cluster",
		icon = "content/ui/materials/icons/abilities/combat/default",
		show_in_friendly_hud = true,
		max_charges = 2,
		archetypes = {
			"ogryn"
		}
	},
	ogryn_grenade_friend_rock = {
		inventory_item_name = "content/items/weapons/player/grenade_ogryn_friend_rock",
		show_in_friendly_hud = false,
		stat_buff = "extra_max_amount_of_grenades",
		cooldown = 45,
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		ability_type = "grenade_ability",
		icon = "content/ui/materials/icons/abilities/combat/default",
		max_charges = 4,
		archetypes = {
			"ogryn"
		}
	}
}

return abilities
