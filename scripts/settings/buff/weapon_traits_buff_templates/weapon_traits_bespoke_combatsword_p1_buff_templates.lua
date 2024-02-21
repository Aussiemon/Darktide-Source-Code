local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_combatsword_p1_chained_hits_increases_melee_cleave_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_melee_cleave_parent)
templates.weapon_trait_bespoke_combatsword_p1_chained_hits_increases_melee_cleave_parent.child_buff_template = "weapon_trait_bespoke_combatsword_p1_chained_hits_increases_melee_cleave_child"
templates.weapon_trait_bespoke_combatsword_p1_chained_hits_increases_melee_cleave_child = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_melee_cleave_child)
templates.weapon_trait_bespoke_combatsword_p1_chained_hits_increases_crit_chance_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_crit_chance_parent)
templates.weapon_trait_bespoke_combatsword_p1_chained_hits_increases_crit_chance_parent.child_buff_template = "weapon_trait_bespoke_combatsword_p1_chained_hits_increases_crit_chance_child"
templates.weapon_trait_bespoke_combatsword_p1_chained_hits_increases_crit_chance_child = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_crit_chance_child)
templates.weapon_trait_bespoke_combatsword_p1_increased_attack_cleave_on_multiple_hits = table.clone(BaseWeaponTraitBuffTemplates.increased_attack_cleave_on_multiple_hits)
templates.weapon_trait_bespoke_combatsword_p1_increased_melee_damage_on_multiple_hits = table.clone(BaseWeaponTraitBuffTemplates.increased_melee_damage_on_multiple_hits)
templates.weapon_trait_bespoke_combatsword_p1_infinite_melee_cleave_on_crit = table.clone(BaseWeaponTraitBuffTemplates.infinite_melee_cleave_on_crit)
templates.weapon_trait_bespoke_combatsword_p1_stacking_increase_impact_on_hit_parent = table.clone(BaseWeaponTraitBuffTemplates.stacking_increase_impact_on_hit_parent)
templates.weapon_trait_bespoke_combatsword_p1_stacking_increase_impact_on_hit_child = table.clone(BaseWeaponTraitBuffTemplates.stacking_increase_impact_on_hit_child)
templates.weapon_trait_bespoke_combatsword_p1_stacking_increase_impact_on_hit_parent.child_buff_template = "weapon_trait_bespoke_combatsword_p1_stacking_increase_impact_on_hit_child"
templates.weapon_trait_bespoke_combatsword_p1_staggered_targets_receive_increased_stagger_debuff = table.clone(BaseWeaponTraitBuffTemplates.staggered_targets_receive_increased_stagger_debuff)
templates.weapon_trait_bespoke_combatsword_p1_staggered_targets_receive_increased_damage_debuff = table.clone(BaseWeaponTraitBuffTemplates.staggered_targets_receive_increased_damage_debuff)
templates.weapon_trait_bespoke_combatsword_p1_increase_stagger_per_hit_in_sweep_parent = {
	class_name = "weapon_trait_parent_proc_buff",
	child_buff_template = "weapon_trait_bespoke_combatsword_p1_increase_stagger_per_hit_in_sweep_child",
	predicted = false,
	stacks_to_remove = 5,
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_finish] = 1
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1
	},
	clear_child_stacks_proc_events = {
		[proc_events.on_sweep_start] = true,
		[proc_events.on_sweep_finish] = true
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	specific_check_proc_func = {
		[proc_events.on_sweep_start] = function (params, template_data, template_context, t)
			return true
		end,
		[proc_events.on_hit] = function (params, template_data, template_context, t)
			return CheckProcFunctions.on_item_match(params, template_data, template_context, t) and template_data.active
		end,
		[proc_events.on_sweep_finish] = function (params, template_data, template_context, t)
			return true
		end
	},
	specific_proc_func = {
		[proc_events.on_sweep_start] = function (params, template_data, template_context)
			template_data.active = ConditionalFunctions.is_item_slot_wielded(template_data, template_context)
		end,
		[proc_events.on_sweep_finish] = function (params, template_data, template_context)
			template_data.active = false
		end
	}
}
templates.weapon_trait_bespoke_combatsword_p1_increase_stagger_per_hit_in_sweep_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.melee_impact_modifier] = 1
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
templates.weapon_trait_bespoke_combatsword_p1_consecutive_hits_increases_stagger_parent = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_stagger_parent)
templates.weapon_trait_bespoke_combatsword_p1_consecutive_hits_increases_stagger_child = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_stagger_child)
templates.weapon_trait_bespoke_combatsword_p1_consecutive_hits_increases_stagger_parent.child_buff_template = "weapon_trait_bespoke_combatsword_p1_consecutive_hits_increases_stagger_child"

return templates
