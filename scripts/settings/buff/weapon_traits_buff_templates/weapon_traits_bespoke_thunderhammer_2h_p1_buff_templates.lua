﻿-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_thunderhammer_2h_p1_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_thunderhammer_2h_p1_hit_mass_consumption_reduction_on_kill = {
	active_duration = 2,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.consumed_hit_mass_modifier] = 0.5,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_kill),
}
templates.weapon_trait_bespoke_thunderhammer_2h_p1_stacking_increase_impact_on_hit_parent = table.clone(BaseWeaponTraitBuffTemplates.stacking_increase_impact_on_hit_parent)
templates.weapon_trait_bespoke_thunderhammer_2h_p1_stacking_increase_impact_on_hit_child = table.clone(BaseWeaponTraitBuffTemplates.stacking_increase_impact_on_hit_child)
templates.weapon_trait_bespoke_thunderhammer_2h_p1_stacking_increase_impact_on_hit_parent.child_buff_template = "weapon_trait_bespoke_thunderhammer_2h_p1_stacking_increase_impact_on_hit_child"
templates.weapon_trait_bespoke_thunderhammer_2h_p1_staggered_targets_receive_increased_stagger_debuff = table.clone(BaseWeaponTraitBuffTemplates.staggered_targets_receive_increased_stagger_debuff)
templates.weapon_trait_bespoke_thunderhammer_2h_p1_staggered_targets_receive_increased_damage_debuff = table.clone(BaseWeaponTraitBuffTemplates.staggered_targets_receive_increased_damage_debuff)
templates.weapon_trait_bespoke_thunderhammer_2h_p1_toughness_recovery_on_multiple_hits = table.clone(BaseWeaponTraitBuffTemplates.toughness_recovery_on_multiple_hits)
templates.weapon_trait_bespoke_thunderhammer_2h_p1_targets_receive_rending_debuff = table.clone(BaseWeaponTraitBuffTemplates.targets_receive_rending_debuff)
templates.weapon_trait_bespoke_thunderhammer_2h_p1_windup_increases_power_parent = table.clone(BaseWeaponTraitBuffTemplates.windup_increases_power_parent)
templates.weapon_trait_bespoke_thunderhammer_2h_p1_windup_increases_power_parent.child_buff_template = "weapon_trait_bespoke_thunderhammer_2h_p1_windup_increases_power_child"
templates.weapon_trait_bespoke_thunderhammer_2h_p1_windup_increases_power_child = table.clone(BaseWeaponTraitBuffTemplates.windup_increases_power_child)
templates.weapon_trait_bespoke_thunderhammer_2h_p1_increase_power_on_hit_parent = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_hit_parent)
templates.weapon_trait_bespoke_thunderhammer_2h_p1_increase_power_on_hit_parent.child_buff_template = "weapon_trait_bespoke_thunderhammer_2h_p1_increase_power_on_hit_child"
templates.weapon_trait_bespoke_thunderhammer_2h_p1_increase_power_on_hit_child = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_hit_child)
templates.weapon_trait_bespoke_thunderhammer_2h_p1_increase_power_on_kill_parent = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_kill_parent)
templates.weapon_trait_bespoke_thunderhammer_2h_p1_increase_power_on_kill_parent.child_buff_template = "weapon_trait_bespoke_thunderhammer_2h_p1_increase_power_on_kill_child"
templates.weapon_trait_bespoke_thunderhammer_2h_p1_increase_power_on_kill_child = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_kill_child)
templates.weapon_trait_bespoke_thunderhammer_2h_p1_consecutive_hits_increases_stagger_parent = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_stagger_parent)
templates.weapon_trait_bespoke_thunderhammer_2h_p1_consecutive_hits_increases_stagger_child = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_stagger_child)
templates.weapon_trait_bespoke_thunderhammer_2h_p1_consecutive_hits_increases_stagger_parent.child_buff_template = "weapon_trait_bespoke_thunderhammer_2h_p1_consecutive_hits_increases_stagger_child"

return templates
