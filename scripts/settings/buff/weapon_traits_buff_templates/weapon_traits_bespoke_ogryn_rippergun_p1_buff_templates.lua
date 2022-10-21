local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}
local rippergun_continuous_fire_step = 3
templates.weapon_trait_bespoke_ogryn_rippergun_p1_suppression_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.suppression_on_close_kill)
templates.weapon_trait_bespoke_ogryn_rippergun_p1_increase_close_damage_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.increase_close_damage_on_close_kill)
templates.weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_close_range_kills = table.clone(BaseWeaponTraitBuffTemplates.toughness_recovery_on_close_kill)
templates.weapon_trait_bespoke_ogryn_rippergun_p1_armor_rending_bayonette = table.merge({
	check_proc_func = CheckProcFunctions.on_melee_hit
}, BaseWeaponTraitBuffTemplates.targets_receive_rending_debuff)
templates.weapon_trait_bespoke_ogryn_rippergun_p1_stacking_crit_bonus_on_continuous_fire = table.merge({
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.01
	},
	continuous_fire_step = rippergun_continuous_fire_step
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_continuous_fire = table.merge({
	stat_buffs = {
		[stat_buffs.toughness_extra_regen_rate] = 0.1
	},
	continuous_fire_step = rippergun_continuous_fire_step
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_ogryn_rippergun_p1_power_bonus_on_continuous_fire = table.merge({
	stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.02
	},
	continuous_fire_step = rippergun_continuous_fire_step
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_ogryn_rippergun_p1_bleed_on_crit = table.clone(BaseWeaponTraitBuffTemplates.bleed_on_crit_ranged)

return templates
