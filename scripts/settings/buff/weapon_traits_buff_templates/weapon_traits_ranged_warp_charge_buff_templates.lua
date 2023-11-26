-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_ranged_warp_charge_buff_templates.lua

local Ammo = require("scripts/utilities/ammo")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BuffUtils = require("scripts/settings/buff/buff_utils")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Health = require("scripts/utilities/health")
local PlayerUnitAction = require("scripts/extension_systems/visual_loadout/utilities/player_unit_action")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Toughness = require("scripts/utilities/toughness/toughness")
local ToughnessSettings = require("scripts/settings/toughness/toughness_settings")
local WarpCharge = require("scripts/utilities/warp_charge")
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events
local replenish_types = ToughnessSettings.replenish_types
local templates = {}

templates.weapon_trait_ranged_warp_charge_wield_increased_vent_speed = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.vent_warp_charge_speed] = 0.9
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		return true
	end
}
templates.weapon_trait_ranged_warp_charge_wield_reduced_vent_damage_taken = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.vent_warp_charge_damage_multiplier] = 0.9
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		return true
	end
}
templates.weapon_trait_ranged_warp_charge_wield_reduced_warp_charge_generation_firing = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.warp_charge_immediate_amount] = 0.9
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		return true
	end
}
templates.weapon_trait_ranged_warp_charge_wield_reduced_warp_charge_generation_charging = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.warp_charge_over_time_amount] = 0.9
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		return true
	end
}
templates.weapon_trait_ranged_warp_charge_wield_increased_charge_speed = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.charge_up_time] = -0.15
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		return true
	end
}
templates.weapon_trait_ranged_warp_charge_wield_increased_damage_on_full_charge = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.fully_charged_damage] = 0.1
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		return true
	end
}
templates.weapon_trait_ranged_warp_charge_wield_high_warp_charge_increased_charge_speed = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.charge_up_time] = -0.2
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		if not ConditionalFunctions.has_high_warp_charge(template_data, template_context) then
			return
		end

		return true
	end
}
templates.weapon_trait_ranged_warp_charge_wield_high_warp_charge_increased_damage_on_full_charge = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.fully_charged_damage] = 0.2
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		if not ConditionalFunctions.has_high_warp_charge(template_data, template_context) then
			return
		end

		return true
	end
}

return templates
