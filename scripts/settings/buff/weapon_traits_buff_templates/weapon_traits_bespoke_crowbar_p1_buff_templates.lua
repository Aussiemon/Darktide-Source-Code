-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_crowbar_p1_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_crowbar_p1_chained_hits_increases_power_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_power_parent)
templates.weapon_trait_bespoke_crowbar_p1_chained_hits_increases_power_parent.child_buff_template = "weapon_trait_bespoke_crowbar_p1_chained_hits_increases_power_child"
templates.weapon_trait_bespoke_crowbar_p1_chained_hits_increases_power_child = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_power_child)
templates.weapon_trait_bespoke_crowbar_p1_consecutive_hits_increases_stagger_parent = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_stagger_parent)
templates.weapon_trait_bespoke_crowbar_p1_consecutive_hits_increases_stagger_child = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_stagger_child)
templates.weapon_trait_bespoke_crowbar_p1_consecutive_hits_increases_stagger_parent.child_buff_template = "weapon_trait_bespoke_crowbar_p1_consecutive_hits_increases_stagger_child"
templates.weapon_trait_bespoke_crowbar_p1_power_bonus_on_first_attack = table.clone(BaseWeaponTraitBuffTemplates.power_bonus_on_first_attack)
templates.weapon_trait_bespoke_crowbar_p1_power_bonus_scaled_on_stamina = table.clone(BaseWeaponTraitBuffTemplates.power_bonus_scaled_on_stamina)
templates.weapon_trait_bespoke_crowbar_p1_stacking_increase_impact_on_hit_parent = table.clone(BaseWeaponTraitBuffTemplates.stacking_increase_impact_on_hit_parent)
templates.weapon_trait_bespoke_crowbar_p1_stacking_increase_impact_on_hit_child = table.clone(BaseWeaponTraitBuffTemplates.stacking_increase_impact_on_hit_child)
templates.weapon_trait_bespoke_crowbar_p1_stacking_increase_impact_on_hit_parent.child_buff_template = "weapon_trait_bespoke_crowbar_p1_stacking_increase_impact_on_hit_child"
templates.weapon_trait_bespoke_crowbar_p1_increased_weakspot_damage_on_push = {
	active_duration = 3,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_push_finish] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.weakspot_damage] = 0.01,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		return params.num_hit_units and params.num_hit_units > 0
	end,
}
templates.weapon_trait_bespoke_crowbar_p1_staggered_targets_receive_increased_stagger_debuff = table.clone(BaseWeaponTraitBuffTemplates.staggered_targets_receive_increased_stagger_debuff)
templates.weapon_trait_bespoke_crowbar_p1_rending_vs_staggered = table.clone(BaseWeaponTraitBuffTemplates.rending_vs_staggered)
templates.weapon_trait_bespoke_crowbar_p1_pass_past_armor_on_heavy_attack = {
	class_name = "proc_buff",
	force_predicted_proc = true,
	predicted = false,
	keywords = {
		keywords.fully_charged_attacks_infinite_cleave,
	},
	stat_buffs = {
		[stat_buffs.melee_fully_charged_damage] = 0.025,
	},
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_sweep_finish] = 1,
	},
	conditional_keywords = {
		keywords.ignore_armor_aborts_attack,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.active and ConditionalFunctions.is_item_slot_wielded(template_data, template_context)
	end,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	specific_proc_func = {
		[proc_events.on_sweep_start] = function (params, template_data, template_context)
			if params.is_heavy and ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				template_data.active = true
			end
		end,
		[proc_events.on_sweep_finish] = function (params, template_data, template_context)
			template_data.active = false
		end,
	},
	check_active_func = function (template_data, template_context)
		return ConditionalFunctions.is_item_slot_wielded(template_data, template_context) and template_data.active
	end,
}
templates.weapon_trait_bespoke_crowbar_p1_elite_kills_grants_stackable_power_parent = {
	allow_proc_while_active = true,
	child_buff_template = "weapon_trait_bespoke_crowbar_p1_elite_kills_grants_stackable_power_child",
	child_duration = 7,
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 1,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_kill] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	specific_check_proc_funcs = {
		[proc_events.on_kill] = CheckProcFunctions.on_elite_or_special_kill,
	},
}
templates.weapon_trait_bespoke_crowbar_p1_elite_kills_grants_stackable_power_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 3,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.125,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_crowbar_p1_targets_receive_rending_debuff_on_weapon_special = table.clone(BaseWeaponTraitBuffTemplates.targets_receive_rending_debuff)

templates.weapon_trait_bespoke_crowbar_p1_targets_receive_rending_debuff_on_weapon_special.check_proc_func = function (params, template_data, template_context)
	if not CheckProcFunctions.on_item_match(params, template_data, template_context) then
		return false
	elseif not CheckProcFunctions.on_melee_hit(params, template_data, template_context) then
		return false
	elseif params.damage_type == "blunt" then
		return false
	end

	return true
end

templates.weapon_trait_bespoke_crowbar_p1_targets_receive_rending_debuff_on_weapon_special.conditional_proc_func = ConditionalFunctions.melee_weapon_special_active
templates.weapon_trait_bespoke_crowbar_p1_crit_chance_on_push = {
	active_duration = 3,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_push_finish] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.melee_critical_strike_chance] = 0.01,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		return params.num_hit_units and params.num_hit_units > 0
	end,
}

return templates
