local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local WarpCharge = require("scripts/utilities/warp_charge")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {
	weapon_trait_bespoke_forcestaff_p2_suppression_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.suppression_on_close_kill),
	weapon_trait_bespoke_forcestaff_p2_hipfire_while_sprinting = table.clone(BaseWeaponTraitBuffTemplates.hipfire_while_sprinting),
	weapon_trait_bespoke_forcestaff_p2_warp_charge_critical_strike_chance_bonus = table.merge({
		stat_buffs = {
			[stat_buffs.critical_strike_chance] = 0.02
		}
	}, BaseWeaponTraitBuffTemplates.warpcharge_stepped_bonus),
	weapon_trait_bespoke_forcestaff_p2_uninterruptable_while_charging = table.clone(BaseWeaponTraitBuffTemplates.uninterruptable_while_charging)
}
templates.weapon_trait_bespoke_forcestaff_p2_uninterruptable_while_charging.uninteruptable_actions = {
	action_charge_flame = true
}
templates.weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks = table.clone(BaseWeaponTraitBuffTemplates.faster_charge_on_chained_secondary_attacks)
templates.weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks.charge_actions = {
	action_charge_flame = true,
	action_shoot_charged_flame = true
}

return templates
