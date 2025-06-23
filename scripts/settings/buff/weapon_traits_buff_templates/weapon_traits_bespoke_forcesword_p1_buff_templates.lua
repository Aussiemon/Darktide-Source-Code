﻿-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_forcesword_p1_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local WarpCharge = require("scripts/utilities/warp_charge")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_forcesword_p1_guaranteed_melee_crit_on_activated_kill = table.clone(BaseWeaponTraitBuffTemplates.guaranteed_melee_crit_on_activated_kill)
templates.weapon_trait_bespoke_forcesword_p1_guaranteed_melee_crit_on_activated_kill.buff_data.internal_buff_name = "weapon_trait_bespoke_forcesword_p1_guaranteed_melee_crit_on_activated_kill_effect"
templates.weapon_trait_bespoke_forcesword_p1_guaranteed_melee_crit_on_activated_kill_effect = table.clone(BaseWeaponTraitBuffTemplates.guaranteed_melee_crit_on_activated_kill_effect)
templates.weapon_trait_bespoke_forcesword_p1_can_block_ranged = table.clone(BaseWeaponTraitBuffTemplates.can_block_ranged)
templates.weapon_trait_bespoke_forcesword_p1_warp_charge_power_bonus = table.merge({
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.05
	}
}, BaseWeaponTraitBuffTemplates.warpcharge_stepped_bonus)
templates.weapon_trait_bespoke_forcesword_p1_stacking_rending_on_weakspot_parent = table.clone(BaseWeaponTraitBuffTemplates.stacking_rending_on_weakspot_parent)
templates.weapon_trait_bespoke_forcesword_p1_stacking_rending_on_weakspot_parent.child_buff_template = "weapon_trait_bespoke_forcesword_p1_stacking_rending_on_weakspot_child"
templates.weapon_trait_bespoke_forcesword_p1_stacking_rending_on_weakspot_child = table.clone(BaseWeaponTraitBuffTemplates.stacking_rending_on_weakspot_child)
templates.weapon_trait_bespoke_forcesword_p1_increase_power_on_kill_parent = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_kill_parent)
templates.weapon_trait_bespoke_forcesword_p1_increase_power_on_kill_parent.child_buff_template = "weapon_trait_bespoke_forcesword_p1_increase_power_on_kill_child"
templates.weapon_trait_bespoke_forcesword_p1_increase_power_on_kill_child = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_kill_child)
templates.weapon_trait_bespoke_forcesword_p1_dodge_grants_finesse_bonus = table.clone(BaseWeaponTraitBuffTemplates.dodge_grants_finesse_bonus)
templates.weapon_trait_bespoke_forcesword_p1_dodge_grants_critical_strike_chance = table.clone(BaseWeaponTraitBuffTemplates.dodge_grants_critical_strike_chance)
templates.weapon_trait_bespoke_forcesword_p1_elite_kills_grants_stackable_power_parent = {
	child_duration = 7,
	predicted = false,
	child_buff_template = "weapon_trait_bespoke_forcesword_p1_elite_kills_grants_stackable_power_child",
	allow_proc_while_active = true,
	stacks_to_remove = 1,
	class_name = "weapon_trait_parent_proc_buff",
	proc_events = {
		[proc_events.on_kill] = 1
	},
	add_child_proc_events = {
		[proc_events.on_kill] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	specific_check_proc_funcs = {
		[proc_events.on_kill] = CheckProcFunctions.on_elite_kill
	}
}
templates.weapon_trait_bespoke_forcesword_p1_elite_kills_grants_stackable_power_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 3,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.125
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
templates.weapon_trait_bespoke_forcesword_p1_chained_hits_increases_crit_chance_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_crit_chance_parent)
templates.weapon_trait_bespoke_forcesword_p1_chained_hits_increases_crit_chance_parent.child_buff_template = "weapon_trait_bespoke_forcesword_p1_chained_hits_increases_crit_chance_child"
templates.weapon_trait_bespoke_forcesword_p1_chained_hits_increases_crit_chance_child = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_crit_chance_child)
templates.weapon_trait_bespoke_forcesword_p1_chained_weakspot_hits_increases_power_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_weakspot_hits_increases_power_parent)
templates.weapon_trait_bespoke_forcesword_p1_chained_weakspot_hits_increases_power_parent.child_buff_template = "weapon_trait_bespoke_forcesword_p1_chained_weakspot_hits_increases_power_child"
templates.weapon_trait_bespoke_forcesword_p1_chained_weakspot_hits_increases_power_child = table.clone(BaseWeaponTraitBuffTemplates.chained_weakspot_hits_increases_power_child)
templates.weapon_trait_bespoke_forcesword_p1_warp_burninating_on_crit = table.clone(BaseWeaponTraitBuffTemplates.warp_burninating_on_crits_melee)
templates.weapon_trait_bespoke_forcesword_p1_chained_hits_vents_warpcharge = {
	vent_percentage = 0.05,
	predicted = false,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_sweep_finish] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_weakspot_hit,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local warp_charge_component = unit_data_extension:write_component("warp_charge")

		template_data.warp_charge_component = warp_charge_component
		template_data.counter = 0
	end,
	proc_func = function (params, template_data, template_context)
		local active = params.hit_weakspot and params.combo_count > 0
		local current_counter = template_data.counter

		if active then
			current_counter = current_counter + 1
		else
			current_counter = 1
		end

		template_data.counter = current_counter

		if current_counter > 1 then
			local warp_charge_component = template_data.warp_charge_component
			local buff_template = template_context.template
			local override_data = template_context.template_override_data
			local remove_percentage = override_data.vent_percentage or buff_template.vent_percentage

			WarpCharge.decrease_immediate(remove_percentage, warp_charge_component, template_context.unit)
		end
	end
}

return templates
