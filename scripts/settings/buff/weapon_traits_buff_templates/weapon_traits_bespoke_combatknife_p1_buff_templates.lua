﻿-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_combatknife_p1_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local proc_events = BuffSettings.proc_events
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

templates.weapon_trait_bespoke_combatknife_p1_stacking_rending_on_weakspot_parent = table.clone(BaseWeaponTraitBuffTemplates.stacking_rending_on_weakspot_parent)
templates.weapon_trait_bespoke_combatknife_p1_stacking_rending_on_weakspot_parent.child_buff_template = "weapon_trait_bespoke_combatknife_p1_stacking_rending_on_weakspot_child"
templates.weapon_trait_bespoke_combatknife_p1_stacking_rending_on_weakspot_child = table.clone(BaseWeaponTraitBuffTemplates.stacking_rending_on_weakspot_child)
templates.weapon_trait_bespoke_combatknife_p1_chained_weakspot_hits_increases_power_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_weakspot_hits_increases_power_parent)
templates.weapon_trait_bespoke_combatknife_p1_chained_weakspot_hits_increases_power_parent.child_buff_template = "weapon_trait_bespoke_combatknife_p1_chained_weakspot_hits_increases_power_child"
templates.weapon_trait_bespoke_combatknife_p1_chained_weakspot_hits_increases_power_child = table.clone(BaseWeaponTraitBuffTemplates.chained_weakspot_hits_increases_power_child)
templates.weapon_trait_bespoke_combatknife_p1_heavy_chained_hits_increases_killing_blow_chance_parent = table.clone(BaseWeaponTraitBuffTemplates.heavy_chained_hits_increases_killing_blow_chance_parent)
templates.weapon_trait_bespoke_combatknife_p1_heavy_chained_hits_increases_killing_blow_chance_parent.child_buff_template = "weapon_trait_bespoke_combatknife_p1_heavy_chained_hits_increases_killing_blow_chance_child"
templates.weapon_trait_bespoke_combatknife_p1_heavy_chained_hits_increases_killing_blow_chance_child = table.clone(BaseWeaponTraitBuffTemplates.heavy_chained_hits_increases_killing_blow_chance_child)
templates.weapon_trait_bespoke_combatknife_p1_dodge_grants_finesse_bonus = table.clone(BaseWeaponTraitBuffTemplates.dodge_grants_finesse_bonus)
templates.weapon_trait_bespoke_combatknife_p1_dodge_grants_critical_strike_chance = table.clone(BaseWeaponTraitBuffTemplates.dodge_grants_critical_strike_chance)
templates.weapon_trait_bespoke_combatknife_p1_bleed_on_crit = table.clone(BaseWeaponTraitBuffTemplates.bleed_on_crit_melee)
templates.weapon_trait_bespoke_combatknife_p1_bleed_on_crit.target_buff_data.allow_weapon_special = false
templates.weapon_trait_bespoke_combatknife_p1_bleed_on_non_weakspot_hit = table.clone(BaseWeaponTraitBuffTemplates.bleed_on_non_weakspot_hit_melee)
templates.weapon_trait_bespoke_combatknife_p1_rending_on_backstab = table.clone(BaseWeaponTraitBuffTemplates.rending_on_backstab)
templates.weapon_trait_bespoke_combatknife_p1_increased_weakspot_damage_against_bleeding = table.clone(BaseWeaponTraitBuffTemplates.increased_weakspot_damage_against_bleeding)
templates.weapon_trait_bespoke_combatknife_p1_increased_crit_chance_on_staggered_weapon_special_hit_parent = table.clone(BaseWeaponTraitBuffTemplates.increased_crit_chance_on_staggered_weapon_special_hit_parent)
templates.weapon_trait_bespoke_combatknife_p1_increased_crit_chance_on_staggered_weapon_special_hit_parent.child_buff_template = "weapon_trait_bespoke_combatknife_p1_increased_crit_chance_on_staggered_weapon_special_hit_child"
templates.weapon_trait_bespoke_combatknife_p1_increased_crit_chance_on_staggered_weapon_special_hit_child = table.clone(BaseWeaponTraitBuffTemplates.increased_crit_chance_on_staggered_weapon_special_hit_child)

return templates
