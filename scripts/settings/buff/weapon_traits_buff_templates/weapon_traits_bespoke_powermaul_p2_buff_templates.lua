-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_powermaul_p2_buff_templates.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local damage_efficiencies = AttackSettings.damage_efficiencies
local proc_events = BuffSettings.proc_events
local stagger_results = AttackSettings.stagger_results
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_powermaul_p2_toughness_recovery_on_chained_attacks = table.clone(BaseWeaponTraitBuffTemplates.toughness_recovery_on_chained_attacks)
templates.weapon_trait_bespoke_powermaul_p2_staggered_targets_receive_increased_damage_debuff = table.clone(BaseWeaponTraitBuffTemplates.staggered_targets_receive_increased_damage_debuff)
templates.weapon_trait_bespoke_powermaul_p2_infinite_melee_cleave_on_weakspot_kill = table.clone(BaseWeaponTraitBuffTemplates.infinite_melee_cleave_on_weakspot_kill)
templates.weapon_trait_bespoke_powermaul_p2_staggered_targets_receive_increased_stagger_debuff = table.clone(BaseWeaponTraitBuffTemplates.staggered_targets_receive_increased_stagger_debuff)
templates.weapon_trait_bespoke_powermaul_p2_targets_receive_rending_debuff_on_weapon_special_attacks = table.clone(BaseWeaponTraitBuffTemplates.targets_receive_rending_debuff_on_weapon_special_attacks)
templates.weapon_trait_bespoke_powermaul_p2_pass_past_armor_on_crit = table.clone(BaseWeaponTraitBuffTemplates.pass_past_armor_on_crit)
templates.weapon_trait_bespoke_powermaul_p2_rending_vs_staggered = table.clone(BaseWeaponTraitBuffTemplates.rending_vs_staggered)
templates.weapon_trait_bespoke_powermaul_p2_extra_explosion_on_activated_attacks_on_armor = table.clone(BaseWeaponTraitBuffTemplates.extra_explosion_on_activated_attacks_on_armor)
templates.weapon_trait_bespoke_powermaul_p2_increase_power_on_kill_parent = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_kill_parent)
templates.weapon_trait_bespoke_powermaul_p2_increase_power_on_kill_parent.child_buff_template = "weapon_trait_bespoke_powermaul_p2_increase_power_on_kill_child"
templates.weapon_trait_bespoke_powermaul_p2_increase_power_on_kill_child = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_kill_child)
templates.weapon_trait_bespoke_powermaul_p2_negate_stagger_reduction_on_weakspot = table.clone(BaseWeaponTraitBuffTemplates.negate_stagger_reduction_on_weakspot)
templates.weapon_trait_bespoke_powermaul_p2_stagger_bonus_damage = table.clone(BaseWeaponTraitBuffTemplates.stagger_bonus_damage)
templates.weapon_trait_bespoke_powermaul_p2_staggering_hits_has_chance_to_stun = {
	class_name = "proc_buff",
	cooldown_duration = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		local damage_efficiency = params.damage_efficiency
		local stagger_result = params.stagger_result

		return stagger_result == stagger_results.stagger and damage_efficiency == damage_efficiencies.full
	end,
	proc_func = function (params, template_data, template_context, t)
		if template_context.is_server then
			local attacked_unit = params.attacked_unit
			local stick_to_buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

			if stick_to_buff_extension then
				stick_to_buff_extension:add_internally_controlled_buff("power_maul_stun", t)
			end
		end
	end,
}
templates.weapon_trait_bespoke_powermaul_p2_block_has_chance_to_stun = {
	allow_proc_while_active = false,
	child_buff_template = "block_has_chance_to_stun_child",
	child_duration = 3,
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_perfect_block] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_perfect_block] = 1,
	},
	conditional_proc_func = function (template_data, template_context, t)
		local stacks = template_context.buff_extension:current_stacks("block_has_chance_to_stun_child")

		if stacks > 1 then
			return false
		end

		return ConditionalFunctions.is_item_slot_wielded(template_data, template_context, t)
	end,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		return params.attack_type == "melee"
	end,
	proc_func = function (params, template_data, template_context, t)
		local attacking_unit = params.attacking_unit
		local attacking_unit_buff_extension = ScriptUnit.has_extension(attacking_unit, "buff_system")

		if attacking_unit_buff_extension then
			attacking_unit_buff_extension:add_internally_controlled_buff("power_maul_stun", t)
		end
	end,
}
templates.weapon_trait_bespoke_powermaul_p2_damage_bonus_vs_electrocuted = {
	class_name = "buff",
	hide_icon_in_hud = true,
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.damage_vs_electrocuted] = 0.5,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_powermaul_p2_stacking_increase_impact_on_hit_parent = table.clone(BaseWeaponTraitBuffTemplates.stacking_increase_impact_on_hit_parent)
templates.weapon_trait_bespoke_powermaul_p2_stacking_increase_impact_on_hit_child = table.clone(BaseWeaponTraitBuffTemplates.stacking_increase_impact_on_hit_child)
templates.weapon_trait_bespoke_powermaul_p2_stacking_increase_impact_on_hit_parent.child_buff_template = "weapon_trait_bespoke_powermaul_p2_stacking_increase_impact_on_hit_child"
templates.weapon_trait_bespoke_powermaul_p2_power_bonus_scaled_on_stamina = table.clone(BaseWeaponTraitBuffTemplates.power_bonus_scaled_on_stamina)
templates.weapon_trait_bespoke_powermaul_p2_consecutive_melee_hits_same_target_increases_melee_power_parent = table.clone(BaseWeaponTraitBuffTemplates.consecutive_melee_hits_same_target_increases_melee_power_parent)
templates.weapon_trait_bespoke_powermaul_p2_consecutive_melee_hits_same_target_increases_melee_power_child = table.clone(BaseWeaponTraitBuffTemplates.consecutive_melee_hits_same_target_increases_melee_power_child)
templates.weapon_trait_bespoke_powermaul_p2_consecutive_melee_hits_same_target_increases_melee_power_parent.child_buff_template = "weapon_trait_bespoke_powermaul_p2_consecutive_melee_hits_same_target_increases_melee_power_child"
templates.weapon_trait_bespoke_powermaul_p2_targets_receive_rending_debuff = table.clone(BaseWeaponTraitBuffTemplates.targets_receive_rending_debuff)

return templates
