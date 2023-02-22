local TalentSettings = require("scripts/settings/buff/talent_settings")
local ranger_talent_settings = TalentSettings.veteran_2
local abilities = {
	veteran_ranger_ranged_stance = {
		required_weapon_type = "ranged",
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_grunt_hud",
		ability_template = "ranged_stance",
		ability_type = "combat_ability",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		ability_template_tweak_data = {
			buff_to_add = "veteran_ranger_ranged_stance"
		},
		cooldown = ranger_talent_settings.combat_ability.cooldown,
		max_charges = ranger_talent_settings.combat_ability.max_charges,
		archetypes = {
			"veteran"
		}
	},
	veteran_ranger_ranged_stance_headhunter = {
		required_weapon_type = "ranged",
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_grunt_hud",
		ability_template = "ranged_stance",
		ability_type = "combat_ability",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		ability_template_tweak_data = {
			buff_to_add = "veteran_ranger_ranged_stance_headhunter"
		},
		cooldown = ranger_talent_settings.combat_ability.cooldown,
		max_charges = ranger_talent_settings.combat_ability.max_charges,
		archetypes = {
			"veteran"
		}
	},
	veteran_ranger_ranged_stance_big_game_hunter = {
		required_weapon_type = "ranged",
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_grunt_hud",
		ability_template = "ranged_stance",
		ability_type = "combat_ability",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		ability_template_tweak_data = {
			buff_to_add = "veteran_ranger_ranged_stance_big_game_hunter"
		},
		cooldown = ranger_talent_settings.combat_ability.cooldown,
		max_charges = ranger_talent_settings.combat_ability.max_charges,
		archetypes = {
			"veteran"
		}
	},
	veteran_ranger_ranged_stance_weapon_handling_improved = {
		required_weapon_type = "ranged",
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_grunt_hud",
		ability_template = "ranged_stance",
		ability_type = "combat_ability",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		ability_template_tweak_data = {
			buff_to_add = "veteran_ranger_ranged_stance_weapon_handling_improved"
		},
		cooldown = ranger_talent_settings.combat_ability.cooldown,
		max_charges = ranger_talent_settings.combat_ability.max_charges,
		archetypes = {
			"veteran"
		}
	},
	veteran_ranger_ranged_stance_rending = {
		required_weapon_type = "ranged",
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_grunt_hud",
		ability_template = "ranged_stance",
		ability_type = "combat_ability",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		ability_template_tweak_data = {
			buff_to_add = "veteran_ranger_ranged_stance_rending"
		},
		cooldown = ranger_talent_settings.combat_ability.cooldown,
		max_charges = ranger_talent_settings.combat_ability.max_charges,
		archetypes = {
			"veteran"
		}
	},
	veteran_ranger_frag_grenade = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		stat_buff = "extra_max_amount_of_grenades",
		inventory_item_name = "content/items/weapons/player/grenade_frag",
		icon = "content/ui/materials/icons/abilities/combat/default",
		max_charges = ranger_talent_settings.grenade.max_charges,
		archetypes = {
			"veteran"
		}
	}
}

return abilities
