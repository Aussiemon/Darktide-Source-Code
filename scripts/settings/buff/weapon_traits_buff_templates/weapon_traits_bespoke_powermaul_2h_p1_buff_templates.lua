﻿-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_powermaul_2h_p1_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local keywords = BuffSettings.keywords
local templates = {}

templates.weapon_trait_bespoke_powermaul_2h_p1_stacking_increase_impact_on_hit_parent = table.clone(BaseWeaponTraitBuffTemplates.stacking_increase_impact_on_hit_parent)
templates.weapon_trait_bespoke_powermaul_2h_p1_stacking_increase_impact_on_hit_child = table.clone(BaseWeaponTraitBuffTemplates.stacking_increase_impact_on_hit_child)
templates.weapon_trait_bespoke_powermaul_2h_p1_stacking_increase_impact_on_hit_parent.child_buff_template = "weapon_trait_bespoke_powermaul_2h_p1_stacking_increase_impact_on_hit_child"
templates.weapon_trait_bespoke_powermaul_2h_p1_consecutive_hits_increases_stagger_parent = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_stagger_parent)
templates.weapon_trait_bespoke_powermaul_2h_p1_consecutive_hits_increases_stagger_child = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_stagger_child)
templates.weapon_trait_bespoke_powermaul_2h_p1_consecutive_hits_increases_stagger_parent.child_buff_template = "weapon_trait_bespoke_powermaul_2h_p1_consecutive_hits_increases_stagger_child"
templates.weapon_trait_bespoke_powermaul_2h_p1_staggered_targets_receive_increased_damage_debuff = table.clone(BaseWeaponTraitBuffTemplates.staggered_targets_receive_increased_damage_debuff)
templates.weapon_trait_bespoke_powermaul_2h_p1_staggered_targets_receive_increased_stagger_debuff = table.clone(BaseWeaponTraitBuffTemplates.staggered_targets_receive_increased_stagger_debuff)
templates.weapon_trait_bespoke_powermaul_2h_p1_taunt_target_on_hit = table.clone(BaseWeaponTraitBuffTemplates.taunt_target_on_staggered_hit)
templates.weapon_trait_bespoke_powermaul_2h_p1_taunt_target_on_hit_child = table.clone(BaseWeaponTraitBuffTemplates.taunt_target_child)
templates.weapon_trait_bespoke_powermaul_2h_p1_taunt_target_on_hit.child_buff_template = "weapon_trait_bespoke_powermaul_2h_p1_taunt_target_on_hit_child"
templates.weapon_trait_bespoke_powermaul_2h_p1_rending_vs_staggered = table.clone(BaseWeaponTraitBuffTemplates.rending_vs_staggered)

return templates
