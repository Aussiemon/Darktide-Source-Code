-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_ranged_explosive_buff_templates.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Toughness = require("scripts/utilities/toughness/toughness")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

local function _is_hitting_3_or_more_check(params, template_data, template_context)
	local is_slot_ok = CheckProcFunctions.check_item_slot(params, template_data, template_context)

	if not is_slot_ok then
		return false
	end

	local number_of_hit_units = params.number_of_hit_units
	local is_enugh_hits = number_of_hit_units >= 3

	return is_enugh_hits
end

templates.weapon_traits_ranged_explosive_wield_explosion_restore_toughness_buff = {
	class_name = "proc_buff",
	cooldown_duration = 10,
	predicted = false,
	proc_events = {
		[proc_events.on_explosion_hit] = 1,
	},
	check_proc_func = _is_hitting_3_or_more_check,
	proc_func = function (params, template_data, template_context)
		local player_unit = template_context.unit
		local toughness_percentage = 0.2

		Toughness.replenish_percentage(player_unit, toughness_percentage)
	end,
}
templates.weapon_traits_ranged_explosive_wield_explosion_heal_corruption_buff = {
	class_name = "proc_buff",
	cooldown_duration = 10,
	predicted = false,
	proc_events = {
		[proc_events.on_explosion_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local health_extension = ScriptUnit.extension(unit, "health_system")

		template_data.health_extension = health_extension
	end,
	check_proc_func = _is_hitting_3_or_more_check,
	proc_func = function (params, template_data, template_context)
		local health_extension = template_data.health_extension
		local corruption_value = 20

		health_extension:reduce_permanent_damage(corruption_value)
	end,
}
templates.weapon_traits_ranged_explosive_wield_explosion_increase_damage_buff = {
	active_duration = 5,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_explosion_hit] = 0.1,
	},
	proc_stat_buffs = {
		[stat_buffs.damage] = 0.1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = _is_hitting_3_or_more_check,
}
templates.weapon_traits_ranged_explosive_wield_explosion_increase_impact_buff = {
	active_duration = 5,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_explosion_hit] = 0.1,
	},
	proc_stat_buffs = {
		[stat_buffs.explosion_impact_modifier] = 0.1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = _is_hitting_3_or_more_check,
}
templates.weapon_traits_ranged_explosive_wield_explosion_increased_crit_chance_buff = {
	active_duration = 5,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_explosion_hit] = 0.1,
	},
	proc_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = _is_hitting_3_or_more_check,
}
templates.weapon_traits_ranged_explosive_wield_explosion_increased_unarmored_damage_buff = {
	active_duration = 5,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_explosion_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.unarmored_damage] = 0.1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = _is_hitting_3_or_more_check,
}
templates.weapon_traits_ranged_explosive_wield_explosion_increased_armored_damage_buff = {
	active_duration = 5,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_explosion_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.armored_damage] = 0.1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = _is_hitting_3_or_more_check,
}
templates.weapon_traits_ranged_explosive_wield_explosion_increased_resistant_damage_buff = {
	active_duration = 5,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_explosion_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.resistant_damage] = 0.1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = _is_hitting_3_or_more_check,
}
templates.weapon_traits_ranged_explosive_wield_explosion_increased_berserker_damage_buff = {
	active_duration = 5,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_explosion_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.berserker_damage] = 0.1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = _is_hitting_3_or_more_check,
}
templates.weapon_traits_ranged_explosive_wield_explosion_increased_super_armor_damage_buff = {
	active_duration = 5,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_explosion_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.super_armor_damage] = 0.1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = _is_hitting_3_or_more_check,
}
templates.weapon_traits_ranged_explosive_wield_explosion_increased_disgustingly_resilient_damage_buff = {
	active_duration = 5,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_explosion_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.disgustingly_resilient_damage] = 0.1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = _is_hitting_3_or_more_check,
}
templates.weapon_traits_ranged_explosive_wield_bleed_on_hit_buff = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
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
	end,
}

return templates
