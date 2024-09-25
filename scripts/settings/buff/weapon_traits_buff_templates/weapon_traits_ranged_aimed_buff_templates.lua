-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_ranged_aimed_buff_templates.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Toughness = require("scripts/utilities/toughness/toughness")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_ranged_aimed_wield_on_weakspot_hit_increase_damage_buff = {
	active_duration = 3,
	class_name = "proc_buff",
	cooldown_duration = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 0.05,
	},
	proc_stat_buffs = {
		[stat_buffs.damage] = 0.1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		return ConditionalFunctions.is_alternative_fire(template_data, template_context) and CheckProcFunctions.on_weakspot_hit(params)
	end,
}
templates.weapon_trait_ranged_aimed_wield_on_weakspot_hit_increase_impact_buff = {
	active_duration = 3,
	class_name = "proc_buff",
	cooldown_duration = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 0.05,
	},
	proc_stat_buffs = {
		[stat_buffs.ranged_impact_modifier] = 0.1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		return ConditionalFunctions.is_alternative_fire(template_data, template_context) and CheckProcFunctions.on_weakspot_hit(params)
	end,
}
templates.weapon_trait_ranged_aimed_wield_on_weakspot_hit_apply_bleeding_buff = {
	class_name = "proc_buff",
	cooldown_duration = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		return ConditionalFunctions.is_alternative_fire(template_data, template_context) and CheckProcFunctions.on_weakspot_hit(params)
	end,
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local buff_to_add = "weapon_trait_ranged_aimed_wield_on_weakspot_hit_apply_bleeding_temporary_buff"
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		local t = FixedFrame.get_latest_fixed_time()

		buff_extension:add_internally_controlled_buff(buff_to_add, t)
	end,
}
templates.weapon_trait_ranged_aimed_wield_on_weakspot_hit_apply_bleeding_temporary_buff = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	duration = 3,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_alternative_fire_hit,
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
templates.weapon_trait_ranged_aimed_wield_on_weakspot_kill_restore_toughness_buff = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		return ConditionalFunctions.is_alternative_fire(template_data, template_context) and CheckProcFunctions.on_weakspot_kill(params)
	end,
	proc_func = function (params, template_data, template_context)
		local player_unit = template_context.unit
		local toughness_percentage = 0.05

		Toughness.replenish_percentage(player_unit, toughness_percentage)
	end,
}
templates.weapon_trait_ranged_aimed_wield_on_weakspot_kill_heal_corruption_buff = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local health_extension = ScriptUnit.extension(unit, "health_system")

		template_data.health_extension = health_extension
	end,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		return ConditionalFunctions.is_alternative_fire(template_data, template_context) and CheckProcFunctions.on_weakspot_kill(params)
	end,
	proc_func = function (params, template_data, template_context)
		local health_extension = template_data.health_extension
		local corruption_value = 20

		health_extension:reduce_permanent_damage(corruption_value)
	end,
}
templates.weapon_trait_ranged_aimed_wield_while_aiming_increased_attack_buff = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.damage] = 0.1,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
			return
		end

		return true
	end,
}
templates.weapon_trait_ranged_aimed_wield_while_aiming_increased_impact_buff = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.ranged_impact_modifier] = 0.1,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
			return
		end

		return true
	end,
}
templates.weapon_trait_ranged_aimed_wield_while_aiming_finesse_bonus_buff = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.finesse_modifier_bonus] = 0.1,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
			return
		end

		return true
	end,
}
templates.weapon_trait_ranged_aimed_wield_while_aiming_increased_crit_chance_buff = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.1,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
			return
		end

		return true
	end,
}
templates.weapon_trait_ranged_aimed_wield_while_aiming_increased_unarmored_damage_buff = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.unarmored_damage] = 0.1,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
			return
		end

		return true
	end,
}
templates.weapon_trait_ranged_aimed_wield_while_aiming_increased_armored_damage_buff = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.armored_damage] = 0.1,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
			return
		end

		return true
	end,
}
templates.weapon_trait_ranged_aimed_wield_while_aiming_increased_resistant_damage_buff = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.resistant_damage] = 0.1,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
			return
		end

		return true
	end,
}
templates.weapon_trait_ranged_aimed_wield_while_aiming_increased_berserker_damage_buff = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.berserker_damage] = 0.1,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
			return
		end

		return true
	end,
}
templates.weapon_trait_ranged_aimed_wield_while_aiming_increased_super_armor_damage_buff = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.super_armor_damage] = 0.1,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
			return
		end

		return true
	end,
}
templates.weapon_trait_ranged_aimed_wield_while_aiming_increased_disgustingly_resilient_damage_buff = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.disgustingly_resilient_damage] = 0.1,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
			return
		end

		return true
	end,
}
templates.weapon_trait_ranged_aimed_wield_on_enter_ads_increase_damage_buff = {
	active_duration = 3,
	class_name = "proc_buff",
	cooldown_duration = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_alternative_fire_start] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.damage] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_aimed_wield_on_enter_ads_increase_impact_buff = {
	active_duration = 3,
	class_name = "proc_buff",
	cooldown_duration = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_alternative_fire_start] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.ranged_impact_modifier] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_aimed_wield_on_enter_ads_apply_bleeding_buff = {
	class_name = "proc_buff",
	cooldown_duration = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_alternative_fire_start] = 0.05,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local buff_to_add = "weapon_trait_ranged_aimed_wield_on_enter_ads_apply_bleeding_temporary_buff"
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		local t = FixedFrame.get_latest_fixed_time()

		buff_extension:add_internally_controlled_buff(buff_to_add, t)
	end,
}
templates.weapon_trait_ranged_aimed_wield_on_enter_ads_apply_bleeding_temporary_buff = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	duration = 3,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_alternative_fire_hit,
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
templates.weapon_trait_ranged_aimed_wield_on_enter_ads_finesse_bonus_buff = {
	active_duration = 3,
	class_name = "proc_buff",
	cooldown_duration = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_alternative_fire_start] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.finesse_modifier_bonus] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_aimed_wield_on_enter_ads_increased_unarmored_damage_buff = {
	active_duration = 3,
	class_name = "proc_buff",
	cooldown_duration = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_alternative_fire_start] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.unarmored_damage] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_aimed_wield_on_enter_ads_increased_armored_damage_buff = {
	active_duration = 3,
	class_name = "proc_buff",
	cooldown_duration = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_alternative_fire_start] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.armored_damage] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_aimed_wield_on_enter_ads_increased_resistant_damage_buff = {
	active_duration = 3,
	class_name = "proc_buff",
	cooldown_duration = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_alternative_fire_start] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.resistant_damage] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_aimed_wield_on_enter_ads_increased_berserker_damage_buff = {
	active_duration = 3,
	class_name = "proc_buff",
	cooldown_duration = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_alternative_fire_start] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.berserker_damage] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_aimed_wield_on_enter_ads_increased_super_armor_damage_buff = {
	active_duration = 3,
	class_name = "proc_buff",
	cooldown_duration = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_alternative_fire_start] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.super_armor_damage] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_aimed_wield_on_enter_ads_increased_disgustingly_resilient_damage_buff = {
	active_duration = 3,
	class_name = "proc_buff",
	cooldown_duration = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_alternative_fire_start] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.disgustingly_resilient_damage] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}

return templates
