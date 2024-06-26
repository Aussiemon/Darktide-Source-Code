﻿-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_combatsword_p2_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_combatsword_p2_increased_attack_cleave_on_multiple_hits = table.clone(BaseWeaponTraitBuffTemplates.increased_attack_cleave_on_multiple_hits)
templates.weapon_trait_bespoke_combatsword_p2_increased_melee_damage_on_multiple_hits = table.clone(BaseWeaponTraitBuffTemplates.increased_melee_damage_on_multiple_hits)
templates.weapon_trait_bespoke_combatsword_p2_chained_hits_increases_melee_cleave_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_melee_cleave_parent)
templates.weapon_trait_bespoke_combatsword_p2_chained_hits_increases_melee_cleave_parent.child_buff_template = "weapon_trait_bespoke_combatsword_p2_chained_hits_increases_melee_cleave_child"
templates.weapon_trait_bespoke_combatsword_p2_chained_hits_increases_melee_cleave_child = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_melee_cleave_child)
templates.weapon_trait_bespoke_combatsword_p2_increase_power_on_hit_parent = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_hit_parent)
templates.weapon_trait_bespoke_combatsword_p2_increase_power_on_hit_parent.child_buff_template = "weapon_trait_bespoke_combatsword_p2_increase_power_on_hit_child"
templates.weapon_trait_bespoke_combatsword_p2_increase_power_on_hit_child = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_hit_child)
templates.weapon_trait_bespoke_combatsword_p2_infinite_melee_cleave_on_weakspot_kill = table.clone(BaseWeaponTraitBuffTemplates.infinite_melee_cleave_on_weakspot_kill)
templates.weapon_trait_bespoke_combatsword_p2_pass_past_armor_on_crit = table.clone(BaseWeaponTraitBuffTemplates.pass_past_armor_on_crit)
templates.weapon_trait_bespoke_combatsword_p2_rending_on_multiple_hits_parent = table.clone(BaseWeaponTraitBuffTemplates.rending_on_multiple_hits_parent)
templates.weapon_trait_bespoke_combatsword_p2_rending_on_multiple_hits_parent.child_buff_template = "weapon_trait_bespoke_combatsword_p2_rending_on_multiple_hits_child"
templates.weapon_trait_bespoke_combatsword_p2_rending_on_multiple_hits_child = table.clone(BaseWeaponTraitBuffTemplates.rending_on_multiple_hits_child)
templates.weapon_trait_bespoke_combatsword_p2_windup_increases_power_parent = table.clone(BaseWeaponTraitBuffTemplates.windup_increases_power_parent)
templates.weapon_trait_bespoke_combatsword_p2_windup_increases_power_parent.child_buff_template = "weapon_trait_bespoke_combatsword_p2_windup_increases_power_child"
templates.weapon_trait_bespoke_combatsword_p2_windup_increases_power_child = table.clone(BaseWeaponTraitBuffTemplates.windup_increases_power_child)
templates.weapon_trait_bespoke_combatsword_p2_increased_crit_chance_on_weakspot_kill = {
	active_duration = 3,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.melee_critical_strike_chance] = 0.1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_weakspot_kill),
}

return templates
