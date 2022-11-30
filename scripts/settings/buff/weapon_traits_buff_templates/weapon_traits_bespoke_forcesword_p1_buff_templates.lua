local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local WarpCharge = require("scripts/utilities/warp_charge")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {
	weapon_trait_bespoke_forcesword_p1_guaranteed_melee_crit_on_activated_kill = table.clone(BaseWeaponTraitBuffTemplates.base_weapon_trait_add_buff_after_activated_kill)
}
templates.weapon_trait_bespoke_forcesword_p1_guaranteed_melee_crit_on_activated_kill.buff_to_add = "weapon_trait_bespoke_forcesword_p1_guaranteed_melee_crit_on_activated_kill_effect"
templates.weapon_trait_bespoke_forcesword_p1_guaranteed_melee_crit_on_activated_kill_effect = table.clone(BaseWeaponTraitBuffTemplates.base_weapon_trait_guaranteed_melee_crit_on_activated_kill)
templates.weapon_trait_bespoke_forcesword_p1_guaranteed_melee_crit_on_activated_kill_effect.duration = 5
templates.weapon_trait_bespoke_forcesword_p1_can_block_ranged = {
	class_name = "buff",
	predicted = false,
	keywords = {
		keywords.can_block_ranged
	},
	stat_buffs = {
		[stat_buffs.block_cost_ranged_multiplier] = 1
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
templates.weapon_trait_bespoke_forcesword_p1_warp_charge_power_bonus = table.merge({
	stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.05
	}
}, BaseWeaponTraitBuffTemplates.warpcharge_stepped_bonus)
templates.weapon_trait_bespoke_forcesword_p1_chained_hits_increases_crit_chance_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_crit_chance_parent)
templates.weapon_trait_bespoke_forcesword_p1_chained_hits_increases_crit_chance_parent.child_buff_template = "weapon_trait_bespoke_forcesword_p1_chained_hits_increases_crit_chance_child"
templates.weapon_trait_bespoke_forcesword_p1_chained_hits_increases_crit_chance_child = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_crit_chance_child)
templates.weapon_trait_bespoke_forcesword_p1_chained_hits_increases_crit_chance_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_crit_chance_parent)
templates.weapon_trait_bespoke_forcesword_p1_chained_hits_increases_crit_chance_parent.child_buff_template = "weapon_trait_bespoke_forcesword_p1_chained_hits_increases_crit_chance_child"
templates.weapon_trait_bespoke_forcesword_p1_chained_hits_increases_crit_chance_child = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_crit_chance_child)
templates.weapon_trait_bespoke_forcesword_p1_stacking_rending_on_weakspot_parent = table.clone(BaseWeaponTraitBuffTemplates.stacking_rending_on_weakspot_parent)
templates.weapon_trait_bespoke_forcesword_p1_stacking_rending_on_weakspot_parent.child_buff_template = "weapon_trait_bespoke_forcesword_p1_stacking_rending_on_weakspot_child"
templates.weapon_trait_bespoke_forcesword_p1_stacking_rending_on_weakspot_child = table.clone(BaseWeaponTraitBuffTemplates.stacking_rending_on_weakspot_child)
templates.weapon_trait_bespoke_forcesword_p1_increase_power_on_kill_parent = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_kill_parent)
templates.weapon_trait_bespoke_forcesword_p1_increase_power_on_kill_parent.child_buff_template = "weapon_trait_bespoke_forcesword_p1_increase_power_on_kill_child"
templates.weapon_trait_bespoke_forcesword_p1_increase_power_on_kill_child = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_kill_child)
templates.weapon_trait_bespoke_forcesword_p1_dodge_grants_finesse_bonus = table.clone(BaseWeaponTraitBuffTemplates.dodge_grants_finesse_bonus)
templates.weapon_trait_bespoke_forcesword_p1_dodge_grants_critical_strike_chance = table.clone(BaseWeaponTraitBuffTemplates.dodge_grants_critical_strike_chance)
templates.weapon_trait_bespoke_forcesword_p1_elite_kills_grants_stackable_power_parent = table.merge({
	buff_to_add = "weapon_trait_bespoke_forcesword_p1_elite_kills_grants_stackable_power_child",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_elite_kill
}, BaseWeaponTraitBuffTemplates.base_weapon_trait_add_buff_after_proc)
templates.weapon_trait_bespoke_forcesword_p1_elite_kills_grants_stackable_power_child = {
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = 5,
	duration = 5,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.05
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
templates.weapon_trait_bespoke_forcesword_p1_chained_hits_increases_crit_chance_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_crit_chance_parent)
templates.weapon_trait_bespoke_forcesword_p1_chained_hits_increases_crit_chance_parent.child_buff_template = "weapon_trait_bespoke_forcesword_p1_chained_hits_increases_crit_chance_child"
templates.weapon_trait_bespoke_forcesword_p1_chained_hits_increases_crit_chance_child = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_crit_chance_child)
templates.weapon_trait_bespoke_forcesword_p1_chained_weakspot_hits_increases_power_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_weakspot_hits_increases_power_parent)
templates.weapon_trait_bespoke_forcesword_p1_chained_weakspot_hits_increases_power_parent.child_buff_template = "weapon_trait_bespoke_forcesword_p1_chained_weakspot_hits_increases_power_child"
templates.weapon_trait_bespoke_forcesword_p1_chained_weakspot_hits_increases_power_child = table.clone(BaseWeaponTraitBuffTemplates.chained_weakspot_hits_increases_power_child)
templates.weapon_trait_bespoke_forcesword_p1_chained_hits_vents_warpcharge = {
	predicted = false,
	vent_percentage = 0.05,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_sweep_finish] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local warp_charge_component = unit_data_extension:write_component("warp_charge")
		template_data.warp_charge_component = warp_charge_component
		template_data.counter = 0
	end,
	proc_func = function (params, template_data, template_context)
		local active = params.hit_weakspot and params.combo_count > 0
		local current_counter = template_data.counter

		if active then
			current_counter = current_counter + 1
		else
			current_counter = 1
		end

		template_data.counter = current_counter

		if current_counter > 1 then
			local warp_charge_component = template_data.warp_charge_component
			local buff_template = template_context.template
			local override_data = template_context.template_override_data
			local remove_percentage = override_data.vent_percentage or buff_template.vent_percentage

			WarpCharge.decrease_immediate(remove_percentage, warp_charge_component, template_context.unit)
		end
	end
}
templates.weapon_trait_bespoke_forcesword_p1_warp_burninating_on_crit = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_crit,
	dot_data = {
		max_stacks = 10,
		dot_buff_name = "warp_fire",
		num_stacks_on_proc = 1
	},
	start_func = function (template_data, template_context)
		local template = template_context.template
		local dot_data = template.dot_data
		local template_override_data = template_context.template_override_data
		local override_dot_data = template_override_data.dot_data
		template_data.dot_buff_name = override_dot_data and override_dot_data.dot_buff_name or dot_data.dot_buff_name
		template_data.num_stacks_on_proc = override_dot_data and override_dot_data.num_stacks_on_proc or dot_data.num_stacks_on_proc
		template_data.max_stacks = override_dot_data and override_dot_data.max_stacks or dot_data.max_stacks
	end,
	proc_func = function (params, template_data, template_context, t)
		local attacked_unit = params.attacked_unit
		local attacked_buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

		if attacked_buff_extension then
			local dot_buff_name = template_data.dot_buff_name
			local num_stacks_on_proc = template_data.num_stacks_on_proc
			local max_stacks = template_data.max_stacks
			local current_stacks = attacked_buff_extension:current_stacks(dot_buff_name)
			local stacks_to_add = math.min(num_stacks_on_proc, math.max(max_stacks - current_stacks, 0))

			if stacks_to_add == 0 then
				attacked_buff_extension:refresh_duration_of_stacking_buff(dot_buff_name, t)
			else
				local owner_unit = template_context.owner_unit
				local source_item = template_context.source_item

				for i = 1, stacks_to_add do
					attacked_buff_extension:add_internally_controlled_buff(dot_buff_name, t, "owner_unit", owner_unit, "source_item", source_item)
				end
			end
		end
	end
}

return templates
