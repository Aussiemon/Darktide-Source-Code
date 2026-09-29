-- chunkname: @scripts/settings/ability/player_abilities/abilities/adamant_abilities.lua

local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local adamant_talent_settings = TalentSettings.adamant
local abilities = {
	adamant_shout = {
		ability_group = "adamant_shout",
		ability_template = "adamant_shout",
		hud_icon = "content/ui/textures/icons/abilities/hud/adamant/adamant_ability_shout",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		resource_regen_per_second = 1,
		usage_cost_type = "charges",
		ability_template_tweak_data = {
			shout_target_template = "adamant_shout",
			forward_range = adamant_talent_settings.combat_ability.shout.far_range
		},
		cooldown = adamant_talent_settings.combat_ability.shout.cooldown,
		max_charges = adamant_talent_settings.combat_ability.shout.max_charges,
		resource_cost_per_charge = adamant_talent_settings.combat_ability.shout.cooldown,
		archetypes = {
			"adamant"
		}
	},
	adamant_shout_improved = {
		ability_group = "adamant_shout",
		ability_template = "adamant_shout",
		hud_icon = "content/ui/textures/icons/abilities/hud/adamant/adamant_ability_shout_improved",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		resource_regen_per_second = 1,
		usage_cost_type = "charges",
		ability_template_tweak_data = {
			shout_target_template = "adamant_shout_improved",
			forward_range = adamant_talent_settings.combat_ability.shout_improved.far_range
		},
		cooldown = adamant_talent_settings.combat_ability.shout_improved.cooldown,
		max_charges = adamant_talent_settings.combat_ability.shout_improved.max_charges,
		resource_cost_per_charge = adamant_talent_settings.combat_ability.shout_improved.cooldown,
		archetypes = {
			"adamant"
		}
	},
	adamant_charge = {
		ability_group = "adamant_charge",
		ability_template = "adamant_charge",
		hud_icon = "content/ui/textures/icons/abilities/hud/adamant/adamant_ability_charge",
		icon = "content/ui/materials/icons/abilities/combat/default",
		resource_regen_per_second = 1,
		usage_cost_type = "charges",
		ability_template_tweak_data = {
			lunge_template_name = LungeTemplates.adamant_charge.name
		},
		cooldown = adamant_talent_settings.combat_ability.charge.cooldown,
		max_charges = adamant_talent_settings.combat_ability.charge.max_charges,
		resource_cost_per_charge = adamant_talent_settings.combat_ability.charge.cooldown,
		archetypes = {
			"adamant"
		}
	},
	adamant_stance = {
		ability_group = "adamant_stance",
		ability_template = "adamant_stance",
		hud_icon = "content/ui/textures/icons/abilities/hud/adamant/adamant_ability_stance",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		resource_regen_per_second = 1,
		usage_cost_type = "charges",
		cooldown = adamant_talent_settings.combat_ability.stance.cooldown,
		max_charges = adamant_talent_settings.combat_ability.stance.max_charges,
		resource_cost_per_charge = adamant_talent_settings.combat_ability.stance.cooldown,
		archetypes = {
			"adamant"
		},
		ability_template_tweak_data = {
			buff_to_add = "adamant_hunt_stance"
		}
	},
	adamant_area_buff_drone = {
		ability_group = "adamant_area_buff_drone",
		can_be_previously_wielded_to = false,
		can_be_wielded_when_depleted = false,
		hud_icon = "content/ui/textures/icons/abilities/hud/adamant/adamant_ability_area_buff_drone",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/drone_area_buff",
		max_charges = 1,
		resource_regen_per_second = 1,
		usage_cost_type = "charges",
		cooldown = adamant_talent_settings.blitz_ability.drone.cooldown,
		resource_cost_per_charge = adamant_talent_settings.blitz_ability.drone.cooldown,
		archetypes = {
			"adamant"
		}
	},
	adamant_grenade = {
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/grenade_adamant",
		only_uses_charges = true,
		stat_buff = "extra_max_amount_of_grenades",
		usage_cost_type = "charges",
		max_charges = adamant_talent_settings.blitz_ability.grenade.base_charges,
		archetypes = {
			"adamant"
		}
	},
	adamant_grenade_improved = {
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/grenade_adamant",
		only_uses_charges = true,
		stat_buff = "extra_max_amount_of_grenades",
		usage_cost_type = "charges",
		max_charges = adamant_talent_settings.blitz_ability.grenade.improved_charges,
		archetypes = {
			"adamant"
		}
	},
	adamant_whistle = {
		ability_group = "adamant_whistle",
		ability_template = "adamant_whistle",
		hud_icon = "content/ui/materials/icons/throwables/hud/adamant_whistle",
		icon = "content/ui/materials/icons/abilities/combat/default",
		resource_regen_per_second = 1,
		stat_buff = "extra_max_amount_of_grenades",
		usage_cost_type = "charges",
		hud_configuration = {
			uses_ammunition = true
		},
		max_charges = adamant_talent_settings.blitz_ability.whistle.charges,
		cooldown = adamant_talent_settings.blitz_ability.whistle.cooldown,
		resource_cost_per_charge = adamant_talent_settings.blitz_ability.whistle.cooldown,
		archetypes = {
			"adamant"
		}
	},
	adamant_shock_mine = {
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/mine_shock",
		max_charges = 2,
		only_uses_charges = true,
		stat_buff = "extra_max_amount_of_grenades",
		usage_cost_type = "charges",
		archetypes = {
			"adamant"
		}
	}
}

return abilities
