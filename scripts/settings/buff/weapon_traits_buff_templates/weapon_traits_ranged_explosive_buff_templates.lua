-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_ranged_explosive_buff_templates.lua

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

local function is_hiting_3_or_more_check(params, template_data, template_context)
	local is_slot_ok = CheckProcFunctions.check_item_slot(params, template_data, template_context)

	if not is_slot_ok then
		return false
	end

	local number_of_hit_units = params.number_of_hit_units
	local is_enugh_hits = number_of_hit_units >= 3

	return is_enugh_hits
end

templates.weapon_traits_ranged_explosive_wield_explosion_restore_toughness_buff = {
	cooldown_duration = 10,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[buff_proc_events.on_explosion_hit] = 1
	},
	check_proc_func = is_hiting_3_or_more_check,
	proc_func = function (params, template_data, template_context)
		local player_unit = template_context.unit
		local toughness_percentage = 0.2

		Toughness.replenish_percentage(player_unit, toughness_percentage)
	end
}
templates.weapon_traits_ranged_explosive_wield_explosion_heal_coruption_buff = {
	cooldown_duration = 10,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[buff_proc_events.on_explosion_hit] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local health_extension = ScriptUnit.extension(unit, "health_system")

		template_data.health_extension = health_extension
	end,
	check_proc_func = is_hiting_3_or_more_check,
	proc_func = function (params, template_data, template_context)
		local health_extension = template_data.health_extension
		local corruption_value = 20

		health_extension:reduce_permanent_damage(corruption_value)
	end
}
templates.weapon_traits_ranged_explosive_wield_explosion_increase_damage_buff = {
	predicted = false,
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[buff_proc_events.on_explosion_hit] = 0.1
	},
	proc_stat_buffs = {
		[buff_stat_buffs.damage] = 0.1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = is_hiting_3_or_more_check
}
templates.weapon_traits_ranged_explosive_wield_explosion_increase_impact_buff = {
	predicted = false,
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[buff_proc_events.on_explosion_hit] = 0.1
	},
	proc_stat_buffs = {
		[buff_stat_buffs.explosion_impact_modifier] = 0.1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = is_hiting_3_or_more_check
}
templates.weapon_traits_ranged_explosive_wield_explosion_increased_crit_chance_buff = {
	predicted = false,
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[buff_proc_events.on_explosion_hit] = 0.1
	},
	proc_stat_buffs = {
		[buff_stat_buffs.critical_strike_chance] = 0.1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = is_hiting_3_or_more_check
}
templates.weapon_traits_ranged_explosive_wield_explosion_increased_unarmored_damage_buff = {
	predicted = false,
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[buff_proc_events.on_explosion_hit] = 1
	},
	proc_stat_buffs = {
		[buff_stat_buffs.unarmored_damage] = 0.1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = is_hiting_3_or_more_check
}
templates.weapon_traits_ranged_explosive_wield_explosion_increased_armored_damage_buff = {
	predicted = false,
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[buff_proc_events.on_explosion_hit] = 1
	},
	proc_stat_buffs = {
		[buff_stat_buffs.armored_damage] = 0.1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = is_hiting_3_or_more_check
}
templates.weapon_traits_ranged_explosive_wield_explosion_increased_resistant_damage_buff = {
	predicted = false,
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[buff_proc_events.on_explosion_hit] = 1
	},
	proc_stat_buffs = {
		[buff_stat_buffs.resistant_damage] = 0.1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = is_hiting_3_or_more_check
}
templates.weapon_traits_ranged_explosive_wield_explosion_increased_berserker_damage_buff = {
	predicted = false,
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[buff_proc_events.on_explosion_hit] = 1
	},
	proc_stat_buffs = {
		[buff_stat_buffs.berserker_damage] = 0.1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = is_hiting_3_or_more_check
}
templates.weapon_traits_ranged_explosive_wield_explosion_increased_super_armor_damage_buff = {
	predicted = false,
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[buff_proc_events.on_explosion_hit] = 1
	},
	proc_stat_buffs = {
		[buff_stat_buffs.super_armor_damage] = 0.1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = is_hiting_3_or_more_check
}
templates.weapon_traits_ranged_explosive_wield_explosion_increased_disgustingly_resilient_damage_buff = {
	predicted = false,
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[buff_proc_events.on_explosion_hit] = 1
	},
	proc_stat_buffs = {
		[buff_stat_buffs.disgustingly_resilient_damage] = 0.1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = is_hiting_3_or_more_check
}
templates.weapon_traits_ranged_explosive_wield_bleed_on_hit_buff = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[buff_proc_events.on_hit] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_explosion_and_check_item_slot,
	proc_func = function (params, template_data, template_context)
		local attacked_unit = params.attacked_unit
		local attacked_unit_buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

		if attacked_unit_buff_extension then
			local bleeding_dot_buff_name = "bleed"
			local t = FixedFrame.get_latest_fixed_time()

			attacked_unit_buff_extension:add_internally_controlled_buff(bleeding_dot_buff_name, t, "owner_unit", template_context.unit)
		end
	end
}

return templates
