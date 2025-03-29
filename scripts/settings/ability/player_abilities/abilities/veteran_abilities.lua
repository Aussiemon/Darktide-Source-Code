-- chunkname: @scripts/settings/ability/player_abilities/abilities/veteran_abilities.lua

local TalentSettings = require("scripts/settings/talent/talent_settings")
local shock_trooper_talent_settings = TalentSettings.veteran_1
local ranger_talent_settings = TalentSettings.veteran_2
local squad_leader_talent_settings = TalentSettings.veteran_3
local base_ability = {
	ability_group = "veteran_combat_ability",
	ability_template = "veteran_combat_ability",
	ability_type = "combat_ability",
	hud_icon = "content/ui/textures/icons/abilities/hud/veteran/veteran_ability_volley_fire",
	icon = "content/ui/materials/icons/abilities/ultimate/default",
	required_weapon_type = "ranged",
	stat_buff = "ability_extra_charges",
	cooldown = ranger_talent_settings.combat_ability.cooldown,
	max_charges = ranger_talent_settings.combat_ability.max_charges,
	archetypes = {
		"veteran",
	},
	ability_template_tweak_data = {
		class_tag = "base",
	},
	pause_cooldown_settings = {
		pause_fulfilled_func = function (context)
			return true
		end,
	},
}
local abilities = {
	veteran_frag_grenade = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/grenade_frag",
		stat_buff = "extra_max_amount_of_grenades",
		max_charges = ranger_talent_settings.grenade.max_charges,
		archetypes = {
			"veteran",
		},
	},
	veteran_smoke_grenade = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/grenade_smoke",
		stat_buff = "extra_max_amount_of_grenades",
		max_charges = shock_trooper_talent_settings.grenade.max_charges,
		archetypes = {
			"veteran",
		},
	},
	veteran_krak_grenade = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/grenade_krak",
		stat_buff = "extra_max_amount_of_grenades",
		max_charges = squad_leader_talent_settings.grenade.max_charges,
		archetypes = {
			"veteran",
		},
	},
}

abilities.veteran_combat_ability_stance = table.clone(base_ability)
abilities.veteran_combat_ability_stance.ability_group = "volley_fire_stance"
abilities.veteran_combat_ability_stance.hud_icon = "content/ui/textures/icons/abilities/hud/veteran/veteran_ability_volley_fire_stance"
abilities.veteran_combat_ability_stance.ability_template_tweak_data.class_tag = "ranger"
abilities.veteran_combat_ability_stance.ability_template_tweak_data.wield_secondary_slot = true
abilities.veteran_combat_ability_stance_improved = table.clone(abilities.veteran_combat_ability_stance)
abilities.veteran_combat_ability_stance_improved.ability_group = "volley_fire_stance"
abilities.veteran_combat_ability_stance_improved.hud_icon = "content/ui/textures/icons/abilities/hud/veteran/veteran_ability_volley_fire"
abilities.veteran_combat_ability_stealth = table.clone(base_ability)
abilities.veteran_combat_ability_stealth.ability_group = "veteran_stealth"
abilities.veteran_combat_ability_stealth.ability_template = "veteran_stealth_combat_ability"
abilities.veteran_combat_ability_stealth.required_weapon_type = nil
abilities.veteran_combat_ability_stealth.hud_icon = "content/ui/textures/icons/abilities/hud/veteran/veteran_ability_undercover"
abilities.veteran_combat_ability_stealth.ability_template_tweak_data.class_tag = "shock_trooper"
abilities.veteran_combat_ability_stealth.cooldown = shock_trooper_talent_settings.combat_ability.cooldown
abilities.veteran_combat_ability_shout = table.clone(base_ability)
abilities.veteran_combat_ability_shout.ability_group = "voice_of_command"
abilities.veteran_combat_ability_shout.hud_icon = "content/ui/textures/icons/abilities/hud/veteran/veteran_ability_voice_of_command"
abilities.veteran_combat_ability_shout.ability_template_tweak_data.class_tag = "squad_leader"
abilities.veteran_combat_ability_shout.cooldown = squad_leader_talent_settings.combat_ability.cooldown
abilities.veteran_combat_ability_shout.required_weapon_type = nil

return abilities
