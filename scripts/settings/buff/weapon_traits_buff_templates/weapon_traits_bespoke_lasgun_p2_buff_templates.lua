local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local Suppression = require("scripts/utilities/attack/suppression")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {
	weapon_trait_bespoke_lasgun_p2_burninating_on_crit = table.clone(BaseWeaponTraitBuffTemplates.burninating_on_crit_ranged),
	weapon_trait_bespoke_lasgun_p2_negate_stagger_reduction_on_weakspot = table.clone(BaseWeaponTraitBuffTemplates.negate_stagger_reduction_on_weakspot),
	weapon_trait_bespoke_lasgun_p2_crit_chance_based_on_aim_time = table.clone(BaseWeaponTraitBuffTemplates.chance_based_on_aim_time),
	weapon_trait_bespoke_lasgun_p2_followup_shots_ranged_damage = table.clone(BaseWeaponTraitBuffTemplates.followup_shots_ranged_damage),
	weapon_trait_bespoke_lasgun_p2_stagger_count_bonus_damage = table.clone(BaseWeaponTraitBuffTemplates.stagger_count_bonus_damage)
}
local _shooting_actions = {
	action_shoot_hip_quick = true,
	action_shoot_zoomed_start = true,
	action_zoom_shoot_charged = true,
	action_shoot_hip_charged = true,
	action_zoom_shoot_quick = true,
	action_shoot_hip_start = true
}
templates.weapon_trait_bespoke_lasgun_p2_faster_charge_on_chained_secondary_attacks = {
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	class_name = "stepped_stat_buff",
	conditional_stat_buffs = {
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

		if _shooting_actions[current_action_name] then
			local combo_count = weapon_action_component.combo_count
			local steps_semi = math.round(combo_count)

			return steps_semi
		end

		return 0
	end
}

return templates
