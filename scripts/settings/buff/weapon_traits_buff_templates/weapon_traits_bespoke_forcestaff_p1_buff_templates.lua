local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local WarpCharge = require("scripts/utilities/warp_charge")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {
	weapon_trait_bespoke_forcestaff_p1_vents_warpcharge_on_weakspot_hits = table.clone(BaseWeaponTraitBuffTemplates.vents_warpcharge_on_weakspot_hits),
	weapon_trait_bespoke_forcestaff_p1_suppression_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.suppression_on_close_kill),
	weapon_trait_bespoke_forcestaff_p1_hipfire_while_sprinting = table.clone(BaseWeaponTraitBuffTemplates.hipfire_while_sprinting),
	weapon_trait_bespoke_forcestaff_p1_followup_shots_ranged_damage = table.clone(BaseWeaponTraitBuffTemplates.followup_shots_ranged_damage)
}
templates.weapon_trait_bespoke_forcestaff_p1_followup_shots_ranged_damage.conditional_stat_buffs = {
	[stat_buffs.charge_level_modifier] = 0.05
}
templates.weapon_trait_bespoke_forcestaff_p1_warpfire_on_crits = table.clone(BaseWeaponTraitBuffTemplates.warpfire_on_crits)
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
templates.weapon_trait_bespoke_forcestaff_p1_uninterruptable_while_charging = table.clone(BaseWeaponTraitBuffTemplates.uninterruptable_while_charging)
templates.weapon_trait_bespoke_forcestaff_p1_uninterruptable_while_charging.uninteruptable_actions = {
	action_charge_explosion = true
}
templates.weapon_trait_bespoke_forcestaff_p1_faster_charge_on_chained_secondary_attacks = table.clone(BaseWeaponTraitBuffTemplates.faster_charge_on_chained_secondary_attacks)
templates.weapon_trait_bespoke_forcestaff_p1_faster_charge_on_chained_secondary_attacks.charge_actions = {
	action_trigger_explosion = true,
	action_charge_explosion = true
}
templates.weapon_trait_bespoke_forcestaff_p1_double_shot_on_crit = table.clone(BaseWeaponTraitBuffTemplates.double_shot_on_crit)

return templates
