-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_powersword_p1_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local keywords = BuffSettings.keywords
local templates = {}

templates.weapon_trait_bespoke_powersword_p1_chained_hits_increases_melee_cleave_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_melee_cleave_parent)
templates.weapon_trait_bespoke_powersword_p1_chained_hits_increases_melee_cleave_parent.child_buff_template = "weapon_trait_bespoke_powersword_p1_chained_hits_increases_melee_cleave_child"
templates.weapon_trait_bespoke_powersword_p1_chained_hits_increases_melee_cleave_child = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_melee_cleave_child)
templates.weapon_trait_bespoke_powersword_p1_increased_melee_damage_on_multiple_hits = table.clone(BaseWeaponTraitBuffTemplates.increased_melee_damage_on_multiple_hits)
templates.weapon_trait_bespoke_powersword_p1_infinite_melee_cleave_on_weakspot_kill = table.clone(BaseWeaponTraitBuffTemplates.infinite_melee_cleave_on_weakspot_kill)
templates.weapon_trait_bespoke_powersword_p1_increase_power_on_kill_parent = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_kill_parent)
templates.weapon_trait_bespoke_powersword_p1_increase_power_on_kill_parent.child_buff_template = "weapon_trait_bespoke_powersword_p1_increase_power_on_kill_child"
templates.weapon_trait_bespoke_powersword_p1_increase_power_on_kill_child = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_kill_child)
templates.weapon_trait_bespoke_powersword_p1_targets_receive_rending_debuff_on_weapon_special_attacks = table.clone(BaseWeaponTraitBuffTemplates.targets_receive_rending_debuff_on_weapon_special_attacks)
templates.weapon_trait_bespoke_powersword_p1_pass_past_armor_on_weapon_special = table.clone(BaseWeaponTraitBuffTemplates.pass_past_armor_on_weapon_special)
templates.weapon_trait_bespoke_powersword_p1_extended_activation_duration_on_chained_attacks = {
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	class_name = "stepped_stat_buff",
	conditional_stat_buffs = {
		[stat_buffs.weapon_special_max_activations] = 1
	},
	conditional_stepped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.all(ConditionalFunctions.is_item_slot_wielded, function (template_data, template_context)
		local inventory_slot_component = template_data.inventory_slot_component
		local special_active = inventory_slot_component.special_active

		return special_active
	end),
	buff_data = {
		extra_hits_max = 2
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = unit and ScriptUnit.has_extension(unit, "unit_data_system")

		template_data.shooting_status_component = unit_data_extension and unit_data_extension:read_component("shooting_status")
		template_data.weapon_action_component = unit_data_extension and unit_data_extension:read_component("weapon_action")
		template_data.weapon_action_component = unit_data_extension and unit_data_extension:read_component("weapon_action")

		local item_slot_name = template_context.item_slot_name

		template_data.inventory_slot_component = unit_data_extension and unit_data_extension:read_component(item_slot_name)
	end,
	min_max_step_func = function (template_data, template_context)
		local template = template_context.template
		local buff_data = template.buff_data
		local template_override_data = template_context.template_override_data
		local override_buff_data = template_override_data and template_override_data.buff_data
		local extra_hits_max = override_buff_data and override_buff_data.extra_hits_max or buff_data.extra_hits_max or 1

		return 0, extra_hits_max
	end,
	bonus_step_func = function (template_data, template_context)
		local weapon_action_component = template_data.weapon_action_component
		local combo_count = weapon_action_component.combo_count

		return combo_count
	end
}

return templates
