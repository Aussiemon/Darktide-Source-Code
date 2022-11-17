local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local FixedFrame = require("scripts/utilities/fixed_frame")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local keywords = BuffSettings.keywords
local templates = {
	weapon_trait_bespoke_stubrevolver_p1_hipfire_while_sprinting = table.clone(BaseWeaponTraitBuffTemplates.hipfire_while_sprinting),
	weapon_trait_bespoke_stubrevolver_p1_reload_speed_on_slide = table.clone(BaseWeaponTraitBuffTemplates.reload_speed_on_slide),
	weapon_trait_bespoke_stubrevolver_p1_suppression_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.suppression_on_close_kill),
	weapon_trait_bespoke_stubrevolver_p1_crit_chance_based_on_aim_time = table.clone(BaseWeaponTraitBuffTemplates.chance_based_on_aim_time),
	weapon_trait_bespoke_stubrevolver_p1_chained_weakspot_hits_increases_power_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_weakspot_hits_increases_power_ranged_parent)
}
templates.weapon_trait_bespoke_stubrevolver_p1_chained_weakspot_hits_increases_power_parent.child_buff_template = "weapon_trait_bespoke_stubrevolver_p1_chained_weakspot_hits_increases_power_child"
templates.weapon_trait_bespoke_stubrevolver_p1_chained_weakspot_hits_increases_power_child = table.clone(BaseWeaponTraitBuffTemplates.chained_weakspot_hits_increases_power_child)
templates.weapon_trait_bespoke_stubrevolver_p1_crit_chance_based_on_ammo_left = table.clone(BaseWeaponTraitBuffTemplates.crit_chance_based_on_ammo_left)
templates.weapon_trait_bespoke_stubrevolver_p1_crit_chance_bonus_on_melee_kills = {
	predicted = false,
	class_name = "proc_buff",
	active_duration = 2,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	proc_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.05
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_melee_kill
}
templates.weapon_trait_bespoke_stubrevolver_p1_toughness_on_elite_kills = table.clone(BaseWeaponTraitBuffTemplates.toughness_on_elite_kills)
templates.weapon_trait_bespoke_stubrevolver_p1_followup_shots_ranged_damage = table.clone(BaseWeaponTraitBuffTemplates.followup_shots_ranged_damage)
templates.weapon_trait_bespoke_stubrevolver_p1_rending_on_crit = table.clone(BaseWeaponTraitBuffTemplates.rending_on_crit)

return templates
