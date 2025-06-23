-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_forcestaff_p3_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_forcestaff_p3_suppression_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.suppression_on_close_kill)
templates.weapon_trait_bespoke_forcestaff_p3_hipfire_while_sprinting = table.clone(BaseWeaponTraitBuffTemplates.hipfire_while_sprinting)
templates.weapon_trait_bespoke_forcestaff_p3_warp_charge_critical_strike_chance_bonus = table.merge({
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.02
	}
}, BaseWeaponTraitBuffTemplates.warpcharge_stepped_bonus)
templates.weapon_trait_bespoke_forcestaff_p3_uninterruptable_while_charging = table.clone(BaseWeaponTraitBuffTemplates.uninterruptable_while_charging)
templates.weapon_trait_bespoke_forcestaff_p3_uninterruptable_while_charging.uninterruptable_actions = {
	action_charge = true
}
templates.weapon_trait_bespoke_forcestaff_p3_faster_charge_on_chained_secondary_attacks = table.clone(BaseWeaponTraitBuffTemplates.faster_charge_on_chained_secondary_attacks)
templates.weapon_trait_bespoke_forcestaff_p3_faster_charge_on_chained_secondary_attacks.charge_actions = {
	action_charge = true,
	action_shoot_charged = true
}
templates.weapon_trait_bespoke_forcestaff_p3_faster_charge_on_chained_secondary_attacks_parent = table.clone(BaseWeaponTraitBuffTemplates.faster_charge_on_chained_secondary_attacks_parent)
templates.weapon_trait_bespoke_forcestaff_p3_faster_charge_on_chained_secondary_attacks_parent.child_buff_template = "weapon_trait_bespoke_forcestaff_p3_faster_charge_on_chained_secondary_attacks_child"
templates.weapon_trait_bespoke_forcestaff_p3_faster_charge_on_chained_secondary_attacks_child = table.clone(BaseWeaponTraitBuffTemplates.faster_charge_on_chained_secondary_attacks_child)
templates.weapon_trait_bespoke_forcestaff_p3_faster_charge_on_chained_secondary_attacks_parent.specific_check_proc_funcs = {
	[proc_events.on_action_start] = function (params, template_data, template_context)
		local action_settings = params.action_settings
		local name = action_settings.name

		return name and name == "action_shoot_charged"
	end
}
templates.weapon_trait_bespoke_forcestaff_p3_increased_max_jumps = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.chain_lightning_staff_max_jumps] = 1
	}
}
templates.weapon_trait_bespoke_forcestaff_p3_double_shot_on_crit = table.clone(BaseWeaponTraitBuffTemplates.double_shot_on_crit)
templates.weapon_trait_bespoke_forcestaff_p3_followup_shots_ranged_damage = table.clone(BaseWeaponTraitBuffTemplates.followup_shots_ranged_damage)
templates.weapon_trait_bespoke_forcestaff_p3_followup_shots_ranged_damage.conditional_stat_buffs = {
	[stat_buffs.charge_level_modifier] = 0.05
}
templates.weapon_trait_bespoke_forcestaff_p3_vents_warpcharge_on_weakspot_hits = table.clone(BaseWeaponTraitBuffTemplates.vents_warpcharge_on_weakspot_hits)

return templates
