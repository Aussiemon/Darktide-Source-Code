local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local FireStepFunctions = require("scripts/settings/buff/fire_step_functions")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_bolter_p1_targets_receive_rending_debuff = table.clone(BaseWeaponTraitBuffTemplates.targets_receive_rending_debuff)
templates.weapon_trait_bespoke_bolter_p1_targets_receive_rending_debuff.check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_ranged_hit)
templates.weapon_trait_bespoke_bolter_p1_stacking_power_bonus_on_staggering_enemies_parent = table.clone(BaseWeaponTraitBuffTemplates.stacking_power_bonus_on_staggering_enemies_parent)
templates.weapon_trait_bespoke_bolter_p1_stacking_power_bonus_on_staggering_enemies_parent.child_buff_template = "weapon_trait_bespoke_bolter_p1_stacking_power_bonus_on_staggering_enemies_child"
templates.weapon_trait_bespoke_bolter_p1_stacking_power_bonus_on_staggering_enemies_child = table.clone(BaseWeaponTraitBuffTemplates.stacking_power_bonus_on_staggering_enemies_child)
templates.weapon_trait_bespoke_bolter_p1_crit_chance_based_on_aim_time = table.clone(BaseWeaponTraitBuffTemplates.chance_based_on_aim_time)
templates.weapon_trait_bespoke_bolter_p1_toughness_on_elite_kills = table.clone(BaseWeaponTraitBuffTemplates.toughness_on_elite_kills)
templates.weapon_trait_bespoke_bolter_p1_stacking_crit_bonus_on_continuous_fire = table.merge({
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.01
	},
	continuous_fire_step_func = FireStepFunctions.default_continuous_fire_step_func
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_bolter_p1_toughness_on_continuous_fire = table.merge({
	toughness_fixed_percentage = 0.1,
	continuous_fire_step_func = FireStepFunctions.toughness_regen_continuous_fire_step_func
}, BaseWeaponTraitBuffTemplates.toughness_on_continuous_fire)

return templates
