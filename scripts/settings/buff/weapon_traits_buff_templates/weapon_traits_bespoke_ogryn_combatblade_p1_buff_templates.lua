-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_ogryn_combatblade_p1_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

templates.weapon_trait_bespoke_ogryn_combatblade_p1_crit_chance_on_push = {
	allow_proc_while_active = true,
	predicted = false,
	class_name = "proc_buff",
	active_duration = 3,
	proc_events = {
		[proc_events.on_push_finish] = 1
	},
	proc_stat_buffs = {
		[stat_buffs.melee_critical_strike_chance] = 0.01
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		return params.num_hit_units and params.num_hit_units > 0
	end
}
templates.weapon_trait_bespoke_ogryn_combatblade_p1_increase_power_on_kill_parent = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_kill_parent)
templates.weapon_trait_bespoke_ogryn_combatblade_p1_increase_power_on_kill_parent.child_buff_template = "weapon_trait_bespoke_ogryn_combatblade_p1_increase_power_on_kill_child"
templates.weapon_trait_bespoke_ogryn_combatblade_p1_increase_power_on_kill_child = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_kill_child)
templates.weapon_trait_bespoke_ogryn_combatblade_p1_increased_attack_cleave_on_multiple_hits = table.clone(BaseWeaponTraitBuffTemplates.increased_attack_cleave_on_multiple_hits)
templates.weapon_trait_bespoke_ogryn_combatblade_p1_increased_power_on_weapon_special_follow_up_hits = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_finish] = 1
	},
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.1
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return ConditionalFunctions.is_item_slot_wielded(template_data, template_context) and template_data.active
	end,
	specific_proc_func = {
		[proc_events.on_hit] = function (params, template_data, template_context)
			if ConditionalFunctions.is_item_slot_wielded(template_data, template_context) and CheckProcFunctions.on_melee_weapon_special_hit(params) then
				template_data.active = true
				template_data.number_of_attacks_left = 4
			end
		end,
		[proc_events.on_sweep_finish] = function (params, template_data, template_context)
			if ConditionalFunctions.is_item_slot_wielded(template_data, template_context) and template_data.active then
				template_data.number_of_attacks_left = template_data.number_of_attacks_left - 1

				if template_data.number_of_attacks_left <= 0 then
					template_data.active = false
				end
			end
		end
	},
	check_active_func = function (template_data, template_context)
		return ConditionalFunctions.is_item_slot_wielded(template_data, template_context) and template_data.active
	end
}
templates.weapon_trait_bespoke_ogryn_combatblade_p1_pass_past_armor_on_heavy_attack = {
	class_name = "proc_buff",
	predicted = false,
	force_predicted_proc = true,
	keywords = {
		keywords.fully_charged_attacks_infinite_cleave
	},
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_sweep_finish] = 1
	},
	conditional_keywords = {
		keywords.ignore_armor_aborts_attack
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.active and ConditionalFunctions.is_item_slot_wielded(template_data, template_context)
	end,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	specific_proc_func = {
		[proc_events.on_sweep_start] = function (params, template_data, template_context)
			if params.is_heavy and ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				template_data.active = true
			end
		end,
		[proc_events.on_sweep_finish] = function (params, template_data, template_context)
			template_data.active = false
		end
	},
	check_active_func = function (template_data, template_context)
		return ConditionalFunctions.is_item_slot_wielded(template_data, template_context) and template_data.active
	end
}
templates.weapon_trait_bespoke_ogryn_combatblade_p1_infinite_melee_cleave_on_crit = table.clone(BaseWeaponTraitBuffTemplates.infinite_melee_cleave_on_crit)
templates.weapon_trait_bespoke_ogryn_combatblade_p1_toughness_recovery_on_chained_attacks = table.clone(BaseWeaponTraitBuffTemplates.toughness_recovery_on_chained_attacks)
templates.weapon_trait_bespoke_ogryn_combatblade_p1_toughness_recovery_on_multiple_hits = table.clone(BaseWeaponTraitBuffTemplates.toughness_recovery_on_multiple_hits)
templates.weapon_trait_bespoke_ogryn_combatblade_p1_windup_increases_power_parent = table.clone(BaseWeaponTraitBuffTemplates.windup_increases_power_parent)
templates.weapon_trait_bespoke_ogryn_combatblade_p1_windup_increases_power_parent.child_buff_template = "weapon_trait_bespoke_ogryn_combatblade_p1_windup_increases_power_child"
templates.weapon_trait_bespoke_ogryn_combatblade_p1_windup_increases_power_child = table.clone(BaseWeaponTraitBuffTemplates.windup_increases_power_child)

return templates
