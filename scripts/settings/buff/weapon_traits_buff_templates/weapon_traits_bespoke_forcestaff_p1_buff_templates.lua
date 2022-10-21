local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local WarpCharge = require("scripts/utilities/warp_charge")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {
	weapon_trait_bespoke_forcestaff_p1_vents_warpcharge_on_weakspot_hits = {
		vent_percentage = 0.05,
		predicted = false,
		max_stacks = 1,
		class_name = "proc_buff",
		proc_events = {
			[proc_events.on_hit] = 1
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local warp_charge_component = unit_data_extension:write_component("warp_charge")
			template_data.warp_charge_component = warp_charge_component
			template_data.counter = 0
		end,
		check_proc_func = CheckProcFunctions.on_weakspot_hit,
		proc_func = function (params, template_data, template_context)
			local warp_charge_component = template_data.warp_charge_component
			local buff_template = template_context.template
			local override_data = template_context.template_override_data
			local remove_percentage = override_data.vent_percentage or buff_template.vent_percentage

			WarpCharge.decrease_immediate(remove_percentage, warp_charge_component, template_context.unit)
		end
	},
	weapon_trait_bespoke_forcestaff_p1_suppression_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.suppression_on_close_kill),
	weapon_trait_bespoke_forcestaff_p1_hipfire_while_sprinting = table.clone(BaseWeaponTraitBuffTemplates.hipfire_while_sprinting),
	weapon_trait_bespoke_forcestaff_p1_followup_shots_ranged_damage = table.clone(BaseWeaponTraitBuffTemplates.followup_shots_ranged_damage)
}
templates.weapon_trait_bespoke_forcestaff_p1_followup_shots_ranged_damage.conditional_stat_buffs = {
	[stat_buffs.charge_level_modifier] = 0.05
}
local _warp_fire_buff = "psyker_biomancer_warpfire_debuff"
templates.weapon_trait_bespoke_forcestaff_p1_warpfire_on_crits = {
	predicted = false,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_ranged_crit_hit,
	proc_func = function (params, template_data, template_context, t)
		local attacked_unit = params.attacked_unit
		local attacked_unit_buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

		if attacked_unit_buff_extension then
			attacked_unit_buff_extension:add_internally_controlled_buff(_warp_fire_buff, t, "owner_unit", template_context.unit, "buff_lerp_value", 1)
		end
	end
}
templates.weapon_trait_bespoke_forcestaff_p1_warp_charge_critical_strike_chance_bonus = table.merge({
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.02
	}
}, BaseWeaponTraitBuffTemplates.warpcharge_stepped_bonus)
templates.weapon_trait_bespoke_forcestaff_p1_rend_armor_on_aoe_charge = {
	predicted = false,
	max_num_stacks = 6,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local weapon_action_component = unit_data_extension:read_component("weapon_action")
		template_data.weapon_action_component = weapon_action_component
	end,
	check_proc_func = function (params, template_data, template_context, t)
		local weapon_action_component = template_data.weapon_action_component
		local current_action_name = weapon_action_component.current_action_name

		return current_action_name == "action_trigger_explosion"
	end,
	proc_func = function (params, template_data, template_context, t)
		local attacked_unit = params.attacked_unit
		local attacked_unit_buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

		if attacked_unit_buff_extension then
			local template = template_context.template
			local override_data = template_context.template_override_data
			local max_num_stacks = override_data.max_num_stacks or template.max_num_stacks
			local charge_level = params.charge_level or 0
			local number_of_render_buffs_to_add = math.round(charge_level * max_num_stacks)

			if number_of_render_buffs_to_add > 0 then
				attacked_unit_buff_extension:add_internally_controlled_buff_with_stacks("rending_debuff", number_of_render_buffs_to_add, t, "owner_unit", template_context.unit)
			end
		end
	end
}
templates.weapon_trait_bespoke_forcestaff_p1_uninterruptable_while_charging = {
	max_num_stacks = 6,
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	conditional_keywords = {
		keywords.uninterruptible,
		keywords.stun_immune
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local weapon_action_component = unit_data_extension:read_component("weapon_action")
		template_data.weapon_action_component = weapon_action_component
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local weapon_action_component = template_data.weapon_action_component
		local current_action_name = weapon_action_component.current_action_name

		return current_action_name == "action_charge_explosion"
	end
}
templates.weapon_trait_bespoke_forcestaff_p1_faster_charge_on_chained_secondary_attacks = {
	predicted = false,
	stack_offset = -1,
	max_stacks = 1,
	class_name = "stepped_stat_buff",
	stat_buffs = {
		[stat_buffs.charge_up_time] = -0.04
	},
	conditional_stepped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = unit and ScriptUnit.has_extension(unit, "unit_data_system")
		template_data.weapon_action_component = unit_data_extension and unit_data_extension:read_component("weapon_action")
	end,
	min_max_step_func = function (template_data, template_context)
		return 0, 5
	end,
	bonus_step_func = function (template_data, template_context)
		local weapon_action_component = template_data.weapon_action_component
		local current_action_name = weapon_action_component.current_action_name

		if current_action_name == "action_charge_explosion" or current_action_name == "action_trigger_explosion" then
			local combo_count = weapon_action_component.combo_count
			local steps_semi = math.round(combo_count)

			return steps_semi
		end

		return 0
	end
}
templates.weapon_trait_bespoke_forcestaff_p1_double_shot_on_crit = {
	class_name = "buff",
	predicted = false,
	max_stacks = 1,
	conditional_keywords = {
		keywords.critical_hit_second_projectile
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}

return templates
