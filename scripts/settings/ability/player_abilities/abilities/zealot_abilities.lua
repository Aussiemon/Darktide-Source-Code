-- chunkname: @scripts/settings/ability/player_abilities/abilities/zealot_abilities.lua

local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local maniac_talent_settings = TalentSettings.zealot_2
local preacher_talent_settings = TalentSettings.zealot_3
local base_dash = {
	ability_group = "zealot_dash",
	ability_template = "zealot_dash",
	ability_type = "combat_ability",
	hud_icon = "content/ui/textures/icons/abilities/hud/zealot/zealot_ability_chastise_the_wicked",
	icon = "content/ui/materials/icons/abilities/combat/default",
	max_charges = 1,
	ability_template_tweak_data = {
		lunge_template_name = LungeTemplates.zealot_dash.name,
	},
	cooldown = maniac_talent_settings.combat_ability.cooldown,
	archetypes = {
		"zealot",
	},
}
local improved_dash = table.clone(base_dash)

improved_dash.hud_icon = "content/ui/textures/icons/abilities/hud/zealot/zealot_attack_speed_post_ability"

local improved_double_dash = table.clone(base_dash)

improved_double_dash.max_charges = 2
improved_double_dash.hud_icon = "content/ui/textures/icons/abilities/hud/zealot/zealot_attack_speed_post_ability"

local abilities = {
	zealot_targeted_dash = base_dash,
	zealot_targeted_dash_improved = improved_dash,
	zealot_targeted_dash_improved_double = improved_double_dash,
	zealot_relic = {
		ability_group = "bolstering_prayer",
		ability_type = "combat_ability",
		can_be_previously_wielded_to = false,
		cooldown = 60,
		hud_icon = "content/ui/textures/icons/abilities/hud/zealot/zealot_ability_bolstering_prayer",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		inventory_item_name = "content/items/weapons/player/preacher_relic",
		max_charges = 1,
		archetypes = {
			"zealot",
		},
		pause_cooldown_settings = {
			pause_fulfilled_func = function (context)
				local inventory_component = context.inventory_component
				local wielded_slot = inventory_component.wielded_slot

				return wielded_slot ~= "slot_combat_ability"
			end,
		},
	},
	zealot_invisibility = {
		ability_group = "zealot_invisibility",
		ability_template = "zealot_invisibility",
		ability_type = "combat_ability",
		cooldown = 30,
		hud_icon = "content/ui/textures/icons/abilities/hud/zealot/zealot_ability_stealth",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		max_charges = 1,
		ability_template_tweak_data = {
			buff_to_add = "zealot_invisibility",
		},
		archetypes = {
			"zealot",
		},
	},
	zealot_invisibility_improved = {
		ability_group = "zealot_invisibility",
		ability_template = "zealot_invisibility",
		ability_type = "combat_ability",
		cooldown = 30,
		hud_icon = "content/ui/textures/icons/abilities/hud/zealot/zealot_ability_stealth",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		max_charges = 1,
		ability_template_tweak_data = {
			buff_to_add = "zealot_invisibility_increased_duration",
		},
		archetypes = {
			"zealot",
		},
	},
	zealot_shock_grenade = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/grenade_shock",
		stat_buff = "extra_max_amount_of_grenades",
		max_charges = maniac_talent_settings.grenade.max_charges,
		archetypes = {
			"zealot",
		},
	},
	zealot_fire_grenade = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/grenade_fire",
		stat_buff = "extra_max_amount_of_grenades",
		max_charges = preacher_talent_settings.grenade.max_charges,
		archetypes = {
			"zealot",
		},
	},
	zealot_throwing_knives = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/zealot_throwing_knives",
		max_charges = 12,
		stat_buff = "extra_max_amount_of_grenades",
		archetypes = {
			"zealot",
		},
	},
}

return abilities
