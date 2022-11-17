local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {
	weapon_trait_bespoke_autogun_p1_consecutive_hits_increases_close_damage_parent = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_close_damage_parent),
	weapon_trait_bespoke_autogun_p1_consecutive_hits_increases_close_damage_child = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_close_damage_child)
}
templates.weapon_trait_bespoke_autogun_p1_consecutive_hits_increases_close_damage_parent.child_buff_template = "weapon_trait_bespoke_autogun_p1_consecutive_hits_increases_close_damage_child"
templates.weapon_trait_bespoke_autogun_p1_hipfire_while_sprinting = table.clone(BaseWeaponTraitBuffTemplates.hipfire_while_sprinting)
templates.weapon_trait_bespoke_autogun_p1_increase_power_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_close_kill)
templates.weapon_trait_bespoke_autogun_p1_increase_close_damage_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.increase_close_damage_on_close_kill)
templates.weapon_trait_bespoke_autogun_p1_increase_damage_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.increase_damage_on_close_kill)
templates.weapon_trait_bespoke_autogun_p1_suppression_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.suppression_on_close_kill)
templates.weapon_trait_bespoke_autogun_p1_count_as_dodge_vs_ranged_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.count_as_dodge_vs_ranged_on_close_kill)
templates.weapon_trait_bespoke_autogun_p1_reload_speed_on_dodge = {
	predicted = false,
	class_name = "proc_buff",
	active_duration = 2,
	proc_events = {
		[proc_events.on_dodge_start] = 1
	},
	proc_stat_buffs = {
		[stat_buffs.reload_speed] = 0.5
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
templates.weapon_trait_bespoke_autogun_p1_reload_speed_on_slide = table.clone(BaseWeaponTraitBuffTemplates.reload_speed_on_slide)
templates.weapon_trait_bespoke_autogun_p1_increased_sprint_speed = table.clone(BaseWeaponTraitBuffTemplates.increased_sprint_speed)
templates.weapon_trait_bespoke_autogun_p1_allow_flanking_and_increased_damage_when_flanking = table.clone(BaseWeaponTraitBuffTemplates.allow_flanking_and_increased_damage_when_flanking)
templates.weapon_trait_bespoke_autogun_p1_followup_shots_ranged_damage = table.clone(BaseWeaponTraitBuffTemplates.followup_shots_ranged_damage)
templates.weapon_trait_bespoke_autogun_p1_followup_shots_ranged_weakspot_damage = table.clone(BaseWeaponTraitBuffTemplates.followup_shots_ranged_weakspot_damage)
templates.weapon_trait_bespoke_autogun_p1_improved_sprint_dodge = {
	predicted = false,
	active_time_offset = 0.2,
	class_name = "active_time_offset_proc_buff",
	active_duration = 1,
	proc_events = {
		[proc_events.on_sprint_dodge] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}

return templates
