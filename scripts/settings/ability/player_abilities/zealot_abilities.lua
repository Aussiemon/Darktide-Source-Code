local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local maniac_talent_settings = TalentSettings.zealot_2
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
		cooldown = maniac_talent_settings.combat_ability.cooldown,
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
		max_charges = maniac_talent_settings.grenade.max_charges,
		archetypes = {
			"zealot"
		}
	}
}

return abilities
