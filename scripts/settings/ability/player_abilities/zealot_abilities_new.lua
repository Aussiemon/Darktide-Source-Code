local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local TalentSettings = require("scripts/settings/talent/talent_settings_new")
local maniac_talent_settings = TalentSettings.zealot_2
local preacher_talent_settings = TalentSettings.zealot_3
local abilities = {
	zealot_targeted_dash = {
		hud_icon = "content/ui/textures/icons/abilities/hud/zealot/zealot_ability_chastise_the_wicked",
		ability_template = "zealot_dash",
		icon = "content/ui/materials/icons/abilities/combat/default",
		ability_type = "combat_ability",
		max_charges = 1,
		ability_template_tweak_data = {
			lunge_template_name = LungeTemplates.zealot_dash.name
		},
		cooldown = maniac_talent_settings.combat_ability.cooldown,
		archetypes = {
			"zealot"
		}
	},
	zealot_targeted_dash_improved = {
		hud_icon = "content/ui/textures/icons/abilities/hud/zealot/zealot_ability_chastise_the_wicked",
		ability_template = "zealot_dash",
		icon = "content/ui/materials/icons/abilities/combat/default",
		ability_type = "combat_ability",
		max_charges = 2,
		ability_template_tweak_data = {
			lunge_template_name = LungeTemplates.zealot_dash.name
		},
		cooldown = maniac_talent_settings.combat_ability.cooldown,
		archetypes = {
			"zealot"
		}
	},
	zealot_relic = {
		inventory_item_name = "content/items/weapons/player/preacher_relic",
		cooldown = 60,
		can_be_previously_wielded_to = false,
		hud_icon = "content/ui/textures/icons/abilities/hud/zealot/zealot_ability_bolstering_prayer",
		ability_type = "combat_ability",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		max_charges = 1,
		archetypes = {
			"zealot"
		},
		pause_cooldown_settings = {
			pause_fulfilled_func = function (context)
				local inventory_component = context.inventory_component
				local wielded_slot = inventory_component.wielded_slot

				return wielded_slot ~= "slot_combat_ability"
			end
		}
	},
	zealot_invisibility = {
		hud_icon = "content/ui/textures/icons/abilities/hud/zealot/zealot_ability_stealth",
		ability_template = "zealot_invisibility",
		cooldown = 30,
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		ability_type = "combat_ability",
		max_charges = 1,
		ability_template_tweak_data = {
			buff_to_add = "zealot_invisibility"
		},
		archetypes = {
			"zealot"
		}
	},
	zealot_invisibility_improved = {
		hud_icon = "content/ui/textures/icons/abilities/hud/zealot/zealot_ability_stealth",
		ability_template = "zealot_invisibility",
		cooldown = 30,
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		ability_type = "combat_ability",
		max_charges = 1,
		ability_template_tweak_data = {
			buff_to_add = "zealot_invisibility_increased_duration"
		},
		archetypes = {
			"zealot"
		}
	},
	zealot_shock_grenade = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		stat_buff = "extra_max_amount_of_grenades",
		inventory_item_name = "content/items/weapons/player/grenade_shock",
		icon = "content/ui/materials/icons/abilities/combat/default",
		show_in_friendly_hud = true,
		max_charges = maniac_talent_settings.grenade.max_charges,
		archetypes = {
			"zealot"
		}
	},
	zealot_fire_grenade = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		stat_buff = "extra_max_amount_of_grenades",
		inventory_item_name = "content/items/weapons/player/grenade_fire",
		icon = "content/ui/materials/icons/abilities/combat/default",
		show_in_friendly_hud = true,
		max_charges = preacher_talent_settings.grenade.max_charges,
		archetypes = {
			"zealot"
		}
	},
	zealot_throwing_knives = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		stat_buff = "extra_max_amount_of_grenades",
		inventory_item_name = "content/items/weapons/player/zealot_throwing_knives",
		icon = "content/ui/materials/icons/abilities/combat/default",
		show_in_friendly_hud = false,
		max_charges = 12,
		archetypes = {
			"zealot"
		}
	}
}

return abilities
