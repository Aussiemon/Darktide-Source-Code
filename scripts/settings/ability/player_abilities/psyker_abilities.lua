local TalentSettings = require("scripts/settings/buff/talent_settings")
local biomancer_talent_settings = TalentSettings.psyker_2
local protectorate_talent_settings = TalentSettings.psyker_3
local abilities = {
	psyker_discharge_shout = {
		ability_template = "psyker_shout",
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_biomancer_hud",
		ability_type = "combat_ability",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		cooldown = biomancer_talent_settings.combat_ability.cooldown,
		max_charges = biomancer_talent_settings.combat_ability.max_charges,
		archetypes = {
			"psyker"
		}
	},
	psyker_psychic_fortress = {
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_protectorate_hud",
		ability_template = "psyker_stance",
		cooldown = 30,
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		ability_type = "combat_ability",
		max_charges = 1,
		ability_template_tweak_data = {
			buff_to_add = "psyker_psychic_fortress"
		},
		archetypes = {
			"psyker"
		}
	},
	psyker_psychic_fortress_duration_increased = {
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_protectorate_hud",
		ability_template = "psyker_stance",
		cooldown = 30,
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		ability_type = "combat_ability",
		max_charges = 1,
		ability_template_tweak_data = {
			buff_to_add = "psyker_psychic_fortress_duration_increased"
		},
		archetypes = {
			"psyker"
		}
	},
	psyker_force_field = {
		can_be_wielded_when_depleted = false,
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_protectorate_hud",
		inventory_item_name = "content/items/weapons/player/psyker_shield",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		ability_type = "combat_ability",
		max_charges = protectorate_talent_settings.combat_ability.max_charges,
		cooldown = protectorate_talent_settings.combat_ability.cooldown,
		archetypes = {
			"psyker"
		}
	},
	psyker_force_field_increased_charges = {
		can_be_wielded_when_depleted = false,
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_protectorate_hud",
		inventory_item_name = "content/items/weapons/player/psyker_shield",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		ability_type = "combat_ability",
		max_charges = protectorate_talent_settings.combat_ability_1.max_charges,
		cooldown = protectorate_talent_settings.combat_ability_1.cooldown,
		archetypes = {
			"psyker"
		}
	},
	psyker_force_field_dome = {
		can_be_wielded_when_depleted = false,
		hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_protectorate_hud",
		inventory_item_name = "content/items/weapons/player/psyker_shield_dome",
		cooldown = 30,
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		ability_type = "combat_ability",
		max_charges = 1,
		archetypes = {
			"psyker"
		}
	},
	psyker_smite = {
		inventory_item_name = "content/items/weapons/player/psyker_smite",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		ability_type = "grenade_ability",
		icon = "content/ui/materials/icons/abilities/combat/default",
		max_charges = biomancer_talent_settings.grenade.max_charges,
		cooldown = biomancer_talent_settings.grenade.cooldown,
		archetypes = {
			"psyker"
		}
	},
	psyker_chain_lightning = {
		can_be_wielded_when_depleted = true,
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		ability_type = "grenade_ability",
		inventory_item_name = "content/items/weapons/player/psyker_chain_lightning",
		icon = "content/ui/materials/icons/abilities/combat/default",
		max_charges = protectorate_talent_settings.grenade.max_charges,
		archetypes = {
			"psyker"
		}
	}
}

return abilities
