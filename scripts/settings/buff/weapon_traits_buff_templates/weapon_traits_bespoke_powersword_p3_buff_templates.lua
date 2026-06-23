-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_powersword_p3_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_powersword_p3_targets_receive_rending_debuff_on_weapon_special_attacks = table.clone(BaseWeaponTraitBuffTemplates.targets_receive_rending_debuff_on_weapon_special_attacks)
templates.weapon_trait_bespoke_powersword_p3_elite_kills_grants_stackable_melee_power_parent = {
	allow_proc_while_active = true,
	child_buff_template = "weapon_trait_bespoke_powersword_p3_elite_kills_grants_stackable_melee_power_child",
	child_duration = 5,
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
templates.weapon_trait_bespoke_powersword_p3_elite_kills_grants_stackable_melee_power_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 3,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.melee_power_level_modifier] = 0.125,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_powersword_p3_guaranteed_melee_crit_on_activated_kill = table.clone(BaseWeaponTraitBuffTemplates.guaranteed_melee_crit_on_activated_kill)
templates.weapon_trait_bespoke_powersword_p3_guaranteed_melee_crit_on_activated_kill.buff_data.internal_buff_name = "weapon_trait_bespoke_powersword_p3_guaranteed_melee_crit_on_activated_kill_effect_percentage_capped"
templates.weapon_trait_bespoke_powersword_p3_guaranteed_melee_crit_on_activated_kill_effect_percentage_capped = table.clone(BaseWeaponTraitBuffTemplates.guaranteed_melee_crit_on_activated_kill_effect_percentage_capped)
templates.weapon_trait_bespoke_powersword_p3_increased_crit_chance_on_weakspot_kill = {
	active_duration = 3,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.melee_critical_strike_chance] = 0.1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_weakspot_kill),
}
templates.weapon_trait_bespoke_powersword_p3_pass_past_armor_on_weapon_special = table.clone(BaseWeaponTraitBuffTemplates.pass_past_armor_on_weapon_special)
templates.weapon_trait_bespoke_powersword_p3_infinite_melee_cleave_on_crit = table.clone(BaseWeaponTraitBuffTemplates.infinite_melee_cleave_on_crit)
templates.weapon_trait_bespoke_powersword_p3_stacking_finesse_on_one_hit_kill_parent = {
	child_buff_template = "weapon_trait_bespoke_powersword_p3_stacking_finesse_on_one_hit_kill_child",
	child_duration = 4,
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
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_one_hit_kill),
}
templates.weapon_trait_bespoke_powersword_p3_stacking_finesse_on_one_hit_kill_child = {
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
templates.weapon_trait_bespoke_powersword_p3_refund_charge_on_weapon_special_weakspot_kill = {
	allow_proc_while_active = false,
	class_name = "proc_buff",
	cooldown_duration = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.inventory_slot_component = unit_data_extension:write_component("slot_primary")
	end,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_weakspot_kill, CheckProcFunctions.on_weapon_special_kill),
	proc_func = function (params, template_data, template_context)
		local inventory_slot_component = template_data.inventory_slot_component
		local current_num_charges = inventory_slot_component.num_special_charges
		local max_num_charges = inventory_slot_component.max_num_special_charges

		inventory_slot_component.num_special_charges = math.min(current_num_charges + 1, max_num_charges)
	end,
}

return templates
