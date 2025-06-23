-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_plasmagun_p1_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local slot_configuration = PlayerCharacterConstants.slot_configuration
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_plasmagun_p1_toughness_on_elite_kills = table.clone(BaseWeaponTraitBuffTemplates.toughness_on_elite_kills)
templates.weapon_trait_bespoke_plasmagun_p1_targets_receive_rending_debuff = table.clone(BaseWeaponTraitBuffTemplates.targets_receive_rending_debuff)
templates.weapon_trait_bespoke_plasmagun_p1_targets_receive_rending_debuff.check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_ranged_hit)
templates.weapon_trait_bespoke_plasmagun_p1_power_bonus_on_continuous_fire = table.merge({
	use_combo = true,
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.02
	}
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_plasmagun_p1_lower_overheat_gives_faster_charge = {
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	class_name = "stepped_stat_buff",
	conditional_stat_buffs = {
		[stat_buffs.charge_up_time] = -0.01
	},
	conditional_stepped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	min_max_step_func = function (template_data, template_context)
		return 0, 5
	end,
	bonus_step_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")
		local wielded_slot = inventory_component.wielded_slot

		if wielded_slot == "none" or not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return 0
		end

		local wielded_slot_configuration = slot_configuration[wielded_slot]
		local slot_type = wielded_slot_configuration and wielded_slot_configuration.slot_type

		if slot_type == "weapon" and not ConditionalFunctions.is_reloading(template_data, template_context) then
			local slot_inventory_component = unit_data_extension:read_component(wielded_slot)
			local overheat_current_percentage = slot_inventory_component.overheat_current_percentage

			overheat_current_percentage = 1 - math.clamp01((overheat_current_percentage - 0.1) / 0.9)

			local steps = math.round(overheat_current_percentage * 5)

			return steps
		end

		return 0
	end
}
templates.weapon_trait_bespoke_plasmagun_p1_crit_chance_scaled_on_heat = {
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	class_name = "stepped_stat_buff",
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.01,
		[stat_buffs.ranged_critical_strike_damage] = 0.01
	},
	conditional_stepped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	min_max_step_func = function (template_data, template_context)
		return 0, 5
	end,
	bonus_step_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")
		local wielded_slot = inventory_component.wielded_slot

		if wielded_slot == "none" or not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return 0
		end

		local wielded_slot_configuration = slot_configuration[wielded_slot]
		local slot_type = wielded_slot_configuration and wielded_slot_configuration.slot_type

		if slot_type == "weapon" and not ConditionalFunctions.is_reloading(template_data, template_context) then
			local slot_inventory_component = unit_data_extension:read_component(wielded_slot)
			local overheat_current_percentage = slot_inventory_component.overheat_current_percentage

			overheat_current_percentage = math.clamp01((overheat_current_percentage - 0.1) / 0.9)

			local steps = math.round(overheat_current_percentage * 5)

			return steps
		end

		return 0
	end
}
templates.weapon_trait_bespoke_plasmagun_p1_power_bonus_scaled_on_heat = {
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	class_name = "stepped_stat_buff",
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.01
	},
	conditional_stepped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	min_max_step_func = function (template_data, template_context)
		return 0, 5
	end,
	bonus_step_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")
		local wielded_slot = inventory_component.wielded_slot

		if wielded_slot == "none" or not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return 0
		end

		local wielded_slot_configuration = slot_configuration[wielded_slot]
		local slot_type = wielded_slot_configuration and wielded_slot_configuration.slot_type

		if slot_type == "weapon" and not ConditionalFunctions.is_reloading(template_data, template_context) then
			local slot_inventory_component = unit_data_extension:read_component(wielded_slot)
			local overheat_current_percentage = slot_inventory_component.overheat_current_percentage

			overheat_current_percentage = math.clamp01((overheat_current_percentage - 0.1) / 0.9)

			local steps = math.round(overheat_current_percentage * 5)

			return steps
		end

		return 0
	end
}
templates.weapon_trait_bespoke_plasmagun_p1_reduced_overheat_on_critical_strike = {
	hide_icon_in_hud = true,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.overheat_immediate_amount_critical_strike] = 0.5
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
templates.weapon_trait_bespoke_plasmagun_p1_reduced_overheat_on_continuous_fire = table.merge({
	use_combo = true,
	conditional_stat_buffs = {
		[stat_buffs.overheat_amount] = 0.9
	}
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_plasmagun_p1_charge_level_increases_critical_strike_chance = table.clone(BaseWeaponTraitBuffTemplates.stacking_buff_on_charge_level)

return templates
