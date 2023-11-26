﻿-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_ogryn_heavystubber_p1_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local FireStepFunctions = require("scripts/settings/buff/fire_step_functions")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

templates.weapon_trait_bespoke_ogryn_heavystubber_p1_toughness_on_continuous_fire = table.merge({
	toughness_fixed_percentage = 0.1,
	continuous_fire_step_func = FireStepFunctions.toughness_regen_continuous_fire_step_func
}, BaseWeaponTraitBuffTemplates.toughness_on_continuous_fire)
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_power_bonus_on_continuous_fire = table.merge({
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.02
	},
	continuous_fire_step_func = FireStepFunctions.default_continuous_fire_step_func
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_increase_power_on_close_kill_parent = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_close_kill_parent)
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_increase_power_on_close_kill_child = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_close_kill_child)
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_increase_power_on_close_kill_parent.child_buff_template = "weapon_trait_bespoke_ogryn_heavystubber_p1_increase_power_on_close_kill_child"
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_increased_suppression_on_continuous_fire = table.merge({
	conditional_stat_buffs = {
		[stat_buffs.suppression_dealt] = 0.5,
		[stat_buffs.damage_vs_suppressed] = 0.06
	},
	continuous_fire_step_func = FireStepFunctions.suppression_continuous_fire_step_func
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_parent = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_ranged_power_parent)
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_child = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_ranged_power_child)
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_parent.child_buff_template = "weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_child"
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_movement_speed_on_continous_fire = table.merge({
	conditional_stat_buffs = {
		[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.5,
		[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.5
	},
	continuous_fire_step_func = FireStepFunctions.movement_speed_continuous_fire_step_func
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_ammo_from_reserve_on_crit = table.clone(BaseWeaponTraitBuffTemplates.move_ammo_from_reserve_to_clip_on_crit)

return templates
