-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_saw_p1_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_saw_p1_chained_hits_increases_power_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_power_parent)
templates.weapon_trait_bespoke_saw_p1_chained_hits_increases_power_parent.child_buff_template = "weapon_trait_bespoke_saw_p1_chained_hits_increases_power_child"
templates.weapon_trait_bespoke_saw_p1_chained_hits_increases_power_child = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_power_child)
templates.weapon_trait_bespoke_saw_p1_chained_hits_increases_crit_chance_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_crit_chance_parent)
templates.weapon_trait_bespoke_saw_p1_chained_hits_increases_crit_chance_parent.child_buff_template = "weapon_trait_bespoke_saw_p1_chained_hits_increases_crit_chance_child"
templates.weapon_trait_bespoke_saw_p1_chained_hits_increases_crit_chance_child = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_crit_chance_child)
templates.weapon_trait_bespoke_saw_p1_stacking_finesse_on_one_hit_kill_parent = {
	child_buff_template = "weapon_trait_bespoke_saw_p1_stacking_finesse_on_one_hit_kill_child",
	child_duration = 8,
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 5,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_kill] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_one_hit_kill),
}
templates.weapon_trait_bespoke_saw_p1_stacking_finesse_on_one_hit_kill_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.melee_finesse_modifier_bonus] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_saw_p1_power_bonus_on_first_attack = table.clone(BaseWeaponTraitBuffTemplates.power_bonus_on_first_attack)
templates.weapon_trait_bespoke_saw_p1_consecutive_melee_hits_same_target_increases_melee_power_parent = table.clone(BaseWeaponTraitBuffTemplates.consecutive_melee_hits_same_target_increases_melee_power_parent)
templates.weapon_trait_bespoke_saw_p1_consecutive_melee_hits_same_target_increases_melee_power_child = table.clone(BaseWeaponTraitBuffTemplates.consecutive_melee_hits_same_target_increases_melee_power_child)
templates.weapon_trait_bespoke_saw_p1_consecutive_melee_hits_same_target_increases_melee_power_parent.child_buff_template = "weapon_trait_bespoke_saw_p1_consecutive_melee_hits_same_target_increases_melee_power_child"
templates.weapon_trait_bespoke_saw_p1_bleed_on_crit = table.clone(BaseWeaponTraitBuffTemplates.bleed_on_crit_melee)
templates.weapon_trait_bespoke_saw_p1_bleed_on_non_weakspot_hit = table.clone(BaseWeaponTraitBuffTemplates.bleed_on_non_weakspot_hit_melee)
templates.weapon_trait_bespoke_saw_p1_increased_weakspot_damage_against_toxin_status = table.clone(BaseWeaponTraitBuffTemplates.increased_weakspot_damage_against_toxin_status)
templates.weapon_trait_bespoke_saw_p1_hit_mass_consumption_reduction_on_kill = {
	active_duration = 3,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.consumed_hit_mass_modifier] = 0.5,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_kill),
}
templates.weapon_trait_bespoke_saw_p1_chained_hits_increases_melee_cleave_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_melee_cleave_parent)
templates.weapon_trait_bespoke_saw_p1_chained_hits_increases_melee_cleave_parent.child_buff_template = "weapon_trait_bespoke_saw_p1_chained_hits_increases_melee_cleave_child"
templates.weapon_trait_bespoke_saw_p1_chained_hits_increases_melee_cleave_child = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_melee_cleave_child)

return templates
