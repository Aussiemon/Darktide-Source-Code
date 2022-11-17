local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}
local autopistol_continuous_fire_step = 5
templates.weapon_trait_bespoke_autopistol_p1_stacking_crit_bonus_on_continuous_fire = table.merge({
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.01
	},
	continuous_fire_step = autopistol_continuous_fire_step
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_autopistol_p1_toughness_on_continuous_fire = table.merge({
	stat_buffs = {
		[stat_buffs.toughness_extra_regen_rate] = 0.5
	},
	continuous_fire_step = autopistol_continuous_fire_step
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_autopistol_p1_power_bonus_on_continuous_fire = table.merge({
	stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.02
	},
	continuous_fire_step = autopistol_continuous_fire_step
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_autopistol_p1_reload_speed_on_slide = table.clone(BaseWeaponTraitBuffTemplates.reload_speed_on_slide)
templates.weapon_trait_bespoke_autopistol_p1_suppression_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.suppression_on_close_kill)
templates.weapon_trait_bespoke_autopistol_p1_hipfire_while_sprinting = table.clone(BaseWeaponTraitBuffTemplates.hipfire_while_sprinting)
templates.weapon_trait_bespoke_autopistol_p1_allow_flanking_and_increased_damage_when_flanking = table.clone(BaseWeaponTraitBuffTemplates.allow_flanking_and_increased_damage_when_flanking)
templates.weapon_trait_bespoke_autopistol_p1_followup_shots_ranged_damage = table.clone(BaseWeaponTraitBuffTemplates.followup_shots_ranged_damage)
templates.weapon_trait_bespoke_autopistol_p1_recoil_reduction_and_suppression_increase_on_close_kills = {
	predicted = false,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	active_duration = 2,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	proc_stat_buffs = {
		[stat_buffs.recoil_modifier] = -0.5,
		[stat_buffs.suppression_dealt] = 0.5
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_ranged_close_kill
}
templates.weapon_trait_bespoke_autopistol_p1_stacking_power_bonus_on_staggering_enemies_parent = table.clone(BaseWeaponTraitBuffTemplates.stacking_power_bonus_on_staggering_enemies_parent)
templates.weapon_trait_bespoke_autopistol_p1_stacking_power_bonus_on_staggering_enemies_parent.child_buff_template = "weapon_trait_bespoke_autopistol_p1_stacking_power_bonus_on_staggering_enemies_child"
templates.weapon_trait_bespoke_autopistol_p1_stacking_power_bonus_on_staggering_enemies_child = table.clone(BaseWeaponTraitBuffTemplates.stacking_power_bonus_on_staggering_enemies_child)

return templates
