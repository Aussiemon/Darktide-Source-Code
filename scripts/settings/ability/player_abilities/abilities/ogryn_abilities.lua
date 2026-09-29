-- chunkname: @scripts/settings/ability/player_abilities/abilities/ogryn_abilities.lua

local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local bonebreaker_talent_settings = TalentSettings.ogryn_2
local gunlugger_talent_settings = TalentSettings.ogryn_1
local abilities = {
	ogryn_charge = {
		ability_group = "ogryn_charge",
		ability_template = "ogryn_charge",
		hud_icon = "content/ui/textures/icons/abilities/hud/ogryn/ogryn_ability_bull_rush",
		icon = "content/ui/materials/icons/abilities/combat/default",
		resource_regen_per_second = 1,
		usage_cost_type = "charges",
		ability_template_tweak_data = {
			lunge_template_name = LungeTemplates.ogryn_charge.name,
		},
		cooldown = bonebreaker_talent_settings.combat_ability.cooldown,
		max_charges = bonebreaker_talent_settings.combat_ability.max_charges,
		resource_cost_per_charge = bonebreaker_talent_settings.combat_ability.cooldown,
		archetypes = {
			"ogryn",
		},
	},
	ogryn_charge_cooldown_reduction = {
		ability_group = "ogryn_charge",
		ability_template = "ogryn_charge",
		hud_icon = "content/ui/textures/icons/abilities/hud/ogryn/ogryn_ability_bull_rush",
		icon = "content/ui/materials/icons/abilities/combat/default",
		resource_regen_per_second = 1,
		usage_cost_type = "charges",
		ability_template_tweak_data = {
			lunge_template_name = LungeTemplates.ogryn_charge.name,
		},
		cooldown = bonebreaker_talent_settings.combat_ability_3.cooldown,
		max_charges = bonebreaker_talent_settings.combat_ability_3.max_charges,
		resource_cost_per_charge = bonebreaker_talent_settings.combat_ability_3.cooldown,
		archetypes = {
			"ogryn",
		},
	},
	ogryn_charge_damage = {
		ability_group = "ogryn_charge",
		ability_template = "ogryn_charge",
		hud_icon = "content/ui/textures/icons/abilities/hud/ogryn/ogryn_ability_bull_rush",
		icon = "content/ui/materials/icons/abilities/combat/default",
		resource_regen_per_second = 1,
		usage_cost_type = "charges",
		ability_template_tweak_data = {
			lunge_template_name = LungeTemplates.ogryn_charge_damage.name,
		},
		cooldown = bonebreaker_talent_settings.combat_ability_1.cooldown,
		max_charges = bonebreaker_talent_settings.combat_ability_1.max_charges,
		resource_cost_per_charge = bonebreaker_talent_settings.combat_ability_1.cooldown,
		archetypes = {
			"ogryn",
		},
	},
	ogryn_charge_increased_distance = {
		ability_group = "ogryn_charge",
		ability_template = "ogryn_charge",
		hud_icon = "content/ui/textures/icons/abilities/hud/ogryn/ogryn_longer_charge",
		icon = "content/ui/materials/icons/abilities/combat/default",
		resource_regen_per_second = 1,
		usage_cost_type = "charges",
		ability_template_tweak_data = {
			lunge_template_name = LungeTemplates.ogryn_charge_increased_distance.name,
		},
		cooldown = bonebreaker_talent_settings.combat_ability_2.cooldown,
		max_charges = bonebreaker_talent_settings.combat_ability_2.max_charges,
		resource_cost_per_charge = bonebreaker_talent_settings.combat_ability_2.cooldown,
		archetypes = {
			"ogryn",
		},
	},
	ogryn_charge_bleed = {
		ability_group = "ogryn_charge",
		ability_template = "ogryn_charge",
		hud_icon = "content/ui/textures/icons/abilities/hud/ogryn/ogryn_ability_bull_rush",
		icon = "content/ui/materials/icons/abilities/combat/default",
		resource_regen_per_second = 1,
		usage_cost_type = "charges",
		ability_template_tweak_data = {
			lunge_template_name = LungeTemplates.ogryn_charge_bleed.name,
		},
		cooldown = bonebreaker_talent_settings.combat_ability_3.cooldown,
		max_charges = bonebreaker_talent_settings.combat_ability_3.max_charges,
		resource_cost_per_charge = bonebreaker_talent_settings.combat_ability_3.cooldown,
		archetypes = {
			"ogryn",
		},
	},
	ogryn_ranged_stance = {
		ability_group = "ogryn_gunlugger_stance",
		ability_template = "ogryn_gunlugger_stance",
		hud_icon = "content/ui/textures/icons/abilities/hud/ogryn/ogryn_ability_speshul_ammo",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		required_weapon_type = "ranged",
		resource_regen_per_second = 1,
		usage_cost_type = "charges",
		ability_template_tweak_data = {
			buff_to_add = "ogryn_ranged_stance",
		},
		cooldown = gunlugger_talent_settings.combat_ability.cooldown,
		max_charges = gunlugger_talent_settings.combat_ability.max_charges,
		resource_cost_per_charge = gunlugger_talent_settings.combat_ability.cooldown,
		archetypes = {
			"ogryn",
		},
	},
	ogryn_taunt_shout = {
		ability_group = "ogryn_taunt_shout",
		ability_template = "ogryn_taunt_shout",
		cooldown = 50,
		hud_icon = "content/ui/textures/icons/abilities/hud/ogryn/ogryn_ability_taunt",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		max_charges = 1,
		resource_cost_per_charge = 50,
		resource_regen_per_second = 1,
		usage_cost_type = "charges",
		ability_template_tweak_data = {
			buff_to_add = "ogryn_repeat_taunt",
		},
		archetypes = {
			"ogryn",
		},
	},
	ogryn_grenade_frag = {
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/grenade_ogryn_frag",
		max_charges = 1,
		only_uses_charges = true,
		stat_buff = "extra_max_amount_of_grenades",
		usage_cost_type = "charges",
		archetypes = {
			"ogryn",
		},
	},
	ogryn_grenade_box = {
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/grenade_box_ogryn",
		max_charges = 3,
		only_uses_charges = true,
		stat_buff = "extra_max_amount_of_grenades",
		usage_cost_type = "charges",
		archetypes = {
			"ogryn",
		},
	},
	ogryn_grenade_box_cluster = {
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/grenade_box_ogryn_cluster",
		max_charges = 3,
		only_uses_charges = true,
		stat_buff = "extra_max_amount_of_grenades",
		usage_cost_type = "charges",
		archetypes = {
			"ogryn",
		},
	},
	ogryn_grenade_friend_rock = {
		cooldown = 45,
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/grenade_ogryn_friend_rock",
		max_charges = 4,
		resource_cost_per_charge = 45,
		resource_regen_per_second = 1,
		stat_buff = "extra_max_amount_of_grenades",
		usage_cost_type = "charges",
		archetypes = {
			"ogryn",
		},
	},
}

return abilities
