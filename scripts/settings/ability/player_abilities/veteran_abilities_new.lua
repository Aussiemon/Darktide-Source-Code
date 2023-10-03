local TalentSettings = require("scripts/settings/talent/talent_settings_new")
local shock_trooper_talent_settings = TalentSettings.veteran_1
local ranger_talent_settings = TalentSettings.veteran_2
local squad_leader_talent_settings = TalentSettings.veteran_3
local base_ability = {
	required_weapon_type = "ranged",
	stat_buff = "ability_extra_charges",
	hud_icon = "content/ui/textures/icons/abilities/hud/veteran/veteran_ability_volley_fire",
	ability_template = "veteran_combat_ability",
	ability_type = "combat_ability",
	icon = "content/ui/materials/icons/abilities/ultimate/default",
	cooldown = ranger_talent_settings.combat_ability.cooldown,
	max_charges = ranger_talent_settings.combat_ability.max_charges,
	archetypes = {
		"veteran"
	},
	ability_template_tweak_data = {
		class_tag = "base"
	},
	pause_cooldown_settings = {
		pause_fulfilled_func = function (context)
			local buff_extension = context.buff_extension

			if buff_extension:has_active_buff_with_buff_template("veteran_combat_ability_stance_master") then
				return false
			end

			if buff_extension:has_buff_using_buff_template("veteran_combat_ability_outlines_effect") then
				return false
			end

			return true
		end
	}
}
local abilities = {
	veteran_frag_grenade = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		stat_buff = "extra_max_amount_of_grenades",
		inventory_item_name = "content/items/weapons/player/grenade_frag",
		icon = "content/ui/materials/icons/abilities/combat/default",
		max_charges = ranger_talent_settings.grenade.max_charges,
		archetypes = {
			"veteran"
		}
	},
	veteran_smoke_grenade = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		stat_buff = "extra_max_amount_of_grenades",
		inventory_item_name = "content/items/weapons/player/grenade_smoke",
		icon = "content/ui/materials/icons/abilities/combat/default",
		max_charges = shock_trooper_talent_settings.grenade.max_charges,
		archetypes = {
			"veteran"
		}
	},
	veteran_krak_grenade = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		stat_buff = "extra_max_amount_of_grenades",
		inventory_item_name = "content/items/weapons/player/grenade_krak",
		icon = "content/ui/materials/icons/abilities/combat/default",
		max_charges = squad_leader_talent_settings.grenade.max_charges,
		archetypes = {
			"veteran"
		}
	},
	veteran_combat_ability_stance = table.clone(base_ability)
}
abilities.veteran_combat_ability_stance.hud_icon = "content/ui/textures/icons/abilities/hud/veteran/veteran_ability_volley_fire_stance"
abilities.veteran_combat_ability_stance.ability_template_tweak_data.class_tag = "ranger"
abilities.veteran_combat_ability_stance.ability_template_tweak_data.wield_secondary_slot = true
abilities.veteran_combat_ability_stealth = table.clone(base_ability)
abilities.veteran_combat_ability_stealth.required_weapon_type = nil
abilities.veteran_combat_ability_stealth.hud_icon = "content/ui/textures/icons/abilities/hud/veteran/veteran_ability_undercover"
abilities.veteran_combat_ability_stealth.ability_template_tweak_data.class_tag = "shock_trooper"
abilities.veteran_combat_ability_stealth.cooldown = shock_trooper_talent_settings.combat_ability.cooldown
abilities.veteran_combat_ability_shout = table.clone(base_ability)
abilities.veteran_combat_ability_shout.hud_icon = "content/ui/textures/icons/abilities/hud/veteran/veteran_ability_voice_of_command"
abilities.veteran_combat_ability_shout.ability_template_tweak_data.class_tag = "squad_leader"
abilities.veteran_combat_ability_shout.cooldown = squad_leader_talent_settings.combat_ability.cooldown
abilities.veteran_combat_ability_shout.required_weapon_type = nil

return abilities
