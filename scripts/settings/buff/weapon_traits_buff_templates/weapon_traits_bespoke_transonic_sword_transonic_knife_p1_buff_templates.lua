-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_transonic_sword_transonic_knife_p1_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_chained_hits_increases_crit_chance_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_crit_chance_parent)
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_chained_hits_increases_crit_chance_parent.child_buff_template = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_chained_hits_increases_crit_chance_child"
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_chained_hits_increases_crit_chance_child = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_crit_chance_child)
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_dodge_grants_critical_strike_chance = table.clone(BaseWeaponTraitBuffTemplates.dodge_grants_critical_strike_chance_low_duration)
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_dodge_grants_finesse_bonus = table.clone(BaseWeaponTraitBuffTemplates.dodge_grants_finesse_bonus)
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_elite_kills_grants_stackable_melee_power_parent = {
	allow_proc_while_active = true,
	child_buff_template = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_elite_kills_grants_stackable_melee_power_child",
	child_duration = 5,
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 1,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_kill] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	specific_check_proc_funcs = {
		[proc_events.on_kill] = CheckProcFunctions.on_elite_or_special_kill,
	},
}
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_elite_kills_grants_stackable_melee_power_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 3,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.melee_power_level_modifier] = 0.125,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_increased_attack_cleave_on_multiple_hits = table.clone(BaseWeaponTraitBuffTemplates.increased_attack_cleave_on_multiple_hits)
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_increased_melee_damage_on_multiple_hits = table.clone(BaseWeaponTraitBuffTemplates.increased_melee_damage_on_multiple_hits)
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_pass_past_armor_on_crit = table.clone(BaseWeaponTraitBuffTemplates.pass_past_armor_on_crit)
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_rending_on_multiple_hits_parent = table.clone(BaseWeaponTraitBuffTemplates.rending_on_multiple_hits_parent)
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_rending_on_multiple_hits_parent.child_buff_template = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_rending_on_multiple_hits_child"
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_rending_on_multiple_hits_child = table.clone(BaseWeaponTraitBuffTemplates.rending_on_multiple_hits_child)
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_increased_power_on_weapon_special_follow_up_hits = {
	class_name = "proc_buff",
	force_predicted_proc = true,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_finish] = 1,
	},
	conditional_stat_buffs = {
		[stat_buffs.melee_power_level_modifier] = 0.1,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return ConditionalFunctions.is_item_slot_wielded(template_data, template_context) and template_data.active
	end,
	specific_proc_func = {
		[proc_events.on_hit] = function (params, template_data, template_context)
			if not CheckProcFunctions.on_item_match(params, template_data, template_context) then
				return false
			end

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
		end,
	},
	check_active_func = function (template_data, template_context)
		return ConditionalFunctions.is_item_slot_wielded(template_data, template_context) and template_data.active
	end,
	visual_stack_count = function (template_data, template_context)
		return template_data.number_of_attacks_left or 1
	end,
}

return templates
