-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_forcestaff_p2_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FireStepFunctions = require("scripts/settings/buff/fire_step_functions")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_forcestaff_p2_suppression_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.suppression_on_close_kill)
templates.weapon_trait_bespoke_forcestaff_p2_hipfire_while_sprinting = table.clone(BaseWeaponTraitBuffTemplates.hipfire_while_sprinting)
templates.weapon_trait_bespoke_forcestaff_p2_warp_charge_critical_strike_chance_bonus = table.merge({
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.02,
	},
}, BaseWeaponTraitBuffTemplates.warpcharge_stepped_bonus)
templates.weapon_trait_bespoke_forcestaff_p2_uninterruptable_while_charging = table.clone(BaseWeaponTraitBuffTemplates.uninterruptable_while_charging)
templates.weapon_trait_bespoke_forcestaff_p2_uninterruptable_while_charging.uninteruptable_actions = {
	action_charge_flame = true,
}
templates.weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks = table.clone(BaseWeaponTraitBuffTemplates.faster_charge_on_chained_secondary_attacks)
templates.weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks.charge_actions = {
	action_charge_flame = true,
	action_shoot_charged_flame = true,
}
templates.weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks_parent = table.clone(BaseWeaponTraitBuffTemplates.faster_charge_on_chained_secondary_attacks_parent)
templates.weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks_parent.child_buff_template = "weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks_child"
templates.weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks_child = table.clone(BaseWeaponTraitBuffTemplates.faster_charge_on_chained_secondary_attacks_child)
templates.weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks_parent.specific_check_proc_funcs = {
	[proc_events.on_action_start] = function (params, template_data, template_context)
		local action_settings = params.action_settings
		local name = action_settings.name

		return name and name == "action_shoot_charged_flame"
	end,
}
templates.weapon_trait_bespoke_forcestaff_p2_burned_targets_receive_rending_debuff = table.clone(BaseWeaponTraitBuffTemplates.burned_targets_receive_rending_debuff)
templates.weapon_trait_bespoke_forcestaff_p2_chance_to_explode_elites_on_kill = table.merge(table.clone(BaseWeaponTraitBuffTemplates.chance_to_explode_elites_on_kill), {
	proc_data = {
		fire_buff_id = "warp_fire",
		explosion_template = ExplosionTemplates.trait_buff_forcestaff_p2_minion_explosion,
		validation_keywords = {
			keywords.warpfire_burning,
		},
	},
})
templates.weapon_trait_bespoke_forcestaff_p2_power_bonus_on_continuous_fire = table.merge({
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.02,
	},
	continuous_fire_step_func = FireStepFunctions.default_continuous_fire_step_func,
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)

return templates
