-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_needlepistol_p1_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BrokerBuffUtils = require("scripts/settings/buff/broker_buff_utils")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_needlepistol_p1_hipfire_while_sprinting = table.clone(BaseWeaponTraitBuffTemplates.hipfire_while_sprinting)
templates.weapon_trait_bespoke_needlepistol_p1_count_as_dodge_vs_ranged_on_weakspot = table.clone(BaseWeaponTraitBuffTemplates.count_as_dodge_vs_ranged_on_weakspot)
templates.weapon_trait_bespoke_needlepistol_p1_chained_weakspot_hits_increases_crit_chance_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_weakspot_hits_increases_crit_chance_ranged_parent)
templates.weapon_trait_bespoke_needlepistol_p1_chained_weakspot_hits_increases_crit_chance_parent.child_buff_template = "weapon_trait_bespoke_needlepistol_p1_chained_weakspot_hits_increases_crit_chance_child"
templates.weapon_trait_bespoke_needlepistol_p1_chained_weakspot_hits_increases_crit_chance_child = table.clone(BaseWeaponTraitBuffTemplates.chained_weakspot_hits_increases_crit_chance_child)
templates.weapon_trait_bespoke_needlepistol_p1_dodge_grants_critical_strike_chance = table.clone(BaseWeaponTraitBuffTemplates.dodge_grants_critical_strike_chance)
templates.weapon_trait_bespoke_needlepistol_p1_increased_sprint_speed = table.clone(BaseWeaponTraitBuffTemplates.count_as_dodge_vs_ranged_while_sprinting)
templates.weapon_trait_bespoke_needlepistol_p1_suppression_negation_on_weakspot = table.clone(BaseWeaponTraitBuffTemplates.suppression_negation_on_weakspot)
templates.weapon_trait_bespoke_needlepistol_p1_toughness_on_elite_kills = table.clone(BaseWeaponTraitBuffTemplates.toughness_on_elite_kills)
templates.weapon_trait_bespoke_needlepistol_p1_crit_chance_bonus_on_melee_kills = table.clone(BaseWeaponTraitBuffTemplates.crit_chance_bonus_on_melee_kills)
templates.weapon_trait_bespoke_needlepistol_p1_consecutive_hits_increases_close_damage_parent = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_close_damage_parent)
templates.weapon_trait_bespoke_needlepistol_p1_consecutive_hits_increases_close_damage_child = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_close_damage_child)
templates.weapon_trait_bespoke_needlepistol_p1_consecutive_hits_increases_close_damage_parent.child_buff_template = "weapon_trait_bespoke_laspistol_p1_consecutive_hits_increases_close_damage_child"
templates.weapon_trait_bespoke_needlepistol_p1_target_hit_mass_reduction_on_weakspot_hits = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit] = 0.5,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_needlepistol_p1_reload_speed_on_slide_parent = {
	allow_proc_while_active = true,
	child_buff_template = "weapon_trait_bespoke_needlepistol_p1_reload_speed_on_slide_child",
	child_duration = 1,
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 5,
	start_func = BrokerBuffUtils.bespoke_needlepistol_close_range_kill_start,
	update_func = BrokerBuffUtils.bespoke_needlepistol_close_range_kill_update,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	add_child_proc_events = {
		[proc_events.on_kill] = 1,
		[proc_events.on_minion_death] = 1,
	},
	proc_events = {
		[proc_events.on_kill] = 1,
		[proc_events.on_hit] = 1,
		[proc_events.on_minion_death] = 1,
	},
	specific_check_proc_funcs = {
		[proc_events.on_kill] = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_ranged_close_kill),
		[proc_events.on_hit] = BrokerBuffUtils.bespoke_needlepistol_close_range_kill_check_proc_hit,
		[proc_events.on_minion_death] = BrokerBuffUtils.bespoke_needle_pistol_close_range_kill_check_proc_minion_death,
	},
	specific_proc_func = {
		[proc_events.on_hit] = BrokerBuffUtils.bespoke_needle_pistol_close_range_kill_proc_hit,
		[proc_events.on_minion_death] = BrokerBuffUtils.bespoke_needle_pistol_close_range_kill_proc_on_minion_death,
	},
}
templates.weapon_trait_bespoke_needlepistol_p1_reload_speed_on_slide_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	stat_buffs = {
		[stat_buffs.reload_speed] = 0.1,
	},
}

return templates
