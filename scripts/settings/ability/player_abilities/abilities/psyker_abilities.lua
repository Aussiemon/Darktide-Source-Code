-- chunkname: @scripts/settings/ability/player_abilities/abilities/psyker_abilities.lua

local TalentSettings = require("scripts/settings/talent/talent_settings")
local biomancer_talent_settings = TalentSettings.psyker_2
local protectorate_talent_settings = TalentSettings.psyker_3
local base_shout = {
	ability_group = "psyker_shout",
	hud_icon = "content/ui/textures/icons/abilities/hud/psyker/psyker_ability_discharge",
	ability_template = "psyker_shout",
	icon = "content/ui/materials/icons/abilities/ultimate/default",
	ability_type = "combat_ability",
	cooldown = biomancer_talent_settings.combat_ability.cooldown,
	max_charges = biomancer_talent_settings.combat_ability.max_charges,
	archetypes = {
		"psyker"
	}
}
local improved_shout = table.clone(base_shout)

improved_shout.hud_icon = "content/ui/textures/icons/abilities/hud/psyker/psyker_shout_vent_warp_charge"

local abilities = {
	psyker_discharge_shout = base_shout,
	psyker_discharge_shout_improved = improved_shout,
	psyker_force_field = {
		ability_group = "psyker_shield",
		stat_buff = "ability_extra_charges",
		inventory_item_name = "content/items/weapons/player/psyker_shield",
		can_be_previously_wielded_to = false,
		can_be_wielded_when_depleted = false,
		hud_icon = "content/ui/textures/icons/abilities/hud/psyker/psyker_ability_warp_barrier",
		ability_type = "combat_ability",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		max_charges = protectorate_talent_settings.combat_ability.max_charges,
		cooldown = protectorate_talent_settings.combat_ability.cooldown,
		archetypes = {
			"psyker"
		}
	},
	psyker_force_field_increased_charges = {
		inventory_item_name = "content/items/weapons/player/psyker_shield",
		ability_group = "psyker_shield",
		can_be_previously_wielded_to = false,
		can_be_wielded_when_depleted = false,
		hud_icon = "content/ui/textures/icons/abilities/hud/psyker/psyker_ability_warp_barrier",
		ability_type = "combat_ability",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		max_charges = protectorate_talent_settings.combat_ability_1.max_charges,
		cooldown = protectorate_talent_settings.combat_ability_1.cooldown,
		archetypes = {
			"psyker"
		}
	},
	psyker_force_field_dome = {
		ability_group = "psyker_shield",
		stat_buff = "ability_extra_charges",
		inventory_item_name = "content/items/weapons/player/psyker_shield_dome",
		can_be_previously_wielded_to = false,
		can_be_wielded_when_depleted = false,
		hud_icon = "content/ui/textures/icons/abilities/hud/psyker/psyker_sphere_shield",
		ability_type = "combat_ability",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		max_charges = protectorate_talent_settings.combat_ability.max_charges,
		cooldown = protectorate_talent_settings.combat_ability.cooldown,
		archetypes = {
			"psyker"
		}
	},
	psyker_overcharge_stance = {
		hud_icon = "content/ui/textures/icons/abilities/hud/psyker/psyker_ability_overcharge_stance",
		ability_group = "psyker_overcharge_stance",
		cooldown = 25,
		ability_template = "psyker_overcharge_stance",
		ability_type = "combat_ability",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		max_charges = 1,
		ability_template_tweak_data = {
			buff_to_add = "psyker_overcharge_stance"
		},
		archetypes = {
			"psyker"
		},
		pause_cooldown_settings = {
			pause_fulfilled_func = function (context)
				local buff_extension = context.buff_extension

				if buff_extension:has_buff_using_buff_template("psyker_overcharge_stance") then
					return false
				end

				return true
			end
		}
	},
	psyker_smite = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		exclude_from_persistant_player_data = true,
		inventory_item_name = "content/items/weapons/player/psyker_smite",
		icon = "content/ui/materials/icons/abilities/combat/default",
		can_be_previously_wielded_to = true,
		max_charges = 0,
		archetypes = {
			"psyker"
		}
	},
	psyker_chain_lightning = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		exclude_from_persistant_player_data = true,
		inventory_item_name = "content/items/weapons/player/psyker_chain_lightning",
		icon = "content/ui/materials/icons/abilities/combat/default",
		can_be_previously_wielded_to = true,
		max_charges = 0,
		archetypes = {
			"psyker"
		}
	},
	psyker_throwing_knives = {
		cooldown = 3,
		stat_buff = "extra_max_amount_of_grenades",
		inventory_item_name = "content/items/weapons/player/psyker_throwing_knives",
		can_be_previously_wielded_to = true,
		can_be_wielded_when_depleted = true,
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		ability_type = "grenade_ability",
		icon = "content/ui/materials/icons/abilities/combat/default",
		max_charges = 10,
		archetypes = {
			"psyker"
		}
	}
}

return abilities
