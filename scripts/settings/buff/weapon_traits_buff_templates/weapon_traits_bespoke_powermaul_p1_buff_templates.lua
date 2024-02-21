local AttackSettings = require("scripts/settings/damage/attack_settings")
local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local stagger_results = AttackSettings.stagger_results
local damage_efficiencies = AttackSettings.damage_efficiencies
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_powermaul_p1_stacking_increase_impact_on_hit_parent = table.clone(BaseWeaponTraitBuffTemplates.stacking_increase_impact_on_hit_parent)
templates.weapon_trait_bespoke_powermaul_p1_stacking_increase_impact_on_hit_child = table.clone(BaseWeaponTraitBuffTemplates.stacking_increase_impact_on_hit_child)
templates.weapon_trait_bespoke_powermaul_p1_stacking_increase_impact_on_hit_parent.child_buff_template = "weapon_trait_bespoke_powermaul_p1_stacking_increase_impact_on_hit_child"
templates.weapon_trait_bespoke_powermaul_p1_consecutive_hits_increases_stagger_parent = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_stagger_parent)
templates.weapon_trait_bespoke_powermaul_p1_consecutive_hits_increases_stagger_child = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_stagger_child)
templates.weapon_trait_bespoke_powermaul_p1_consecutive_hits_increases_stagger_parent.child_buff_template = "weapon_trait_bespoke_powermaul_p1_consecutive_hits_increases_stagger_child"
templates.weapon_trait_bespoke_powermaul_p1_staggered_targets_receive_increased_damage_debuff = table.clone(BaseWeaponTraitBuffTemplates.staggered_targets_receive_increased_damage_debuff)
templates.weapon_trait_bespoke_powermaul_p1_staggered_targets_receive_increased_stagger_debuff = table.clone(BaseWeaponTraitBuffTemplates.staggered_targets_receive_increased_stagger_debuff)
templates.weapon_trait_bespoke_powermaul_p1_rending_vs_staggered = table.clone(BaseWeaponTraitBuffTemplates.rending_vs_staggered)
templates.weapon_trait_bespoke_powermaul_p1_negate_stagger_reduction_on_weakspot = table.clone(BaseWeaponTraitBuffTemplates.negate_stagger_reduction_on_weakspot)
templates.weapon_trait_bespoke_powermaul_p1_windup_increases_power_parent = table.clone(BaseWeaponTraitBuffTemplates.windup_increases_power_parent)
templates.weapon_trait_bespoke_powermaul_p1_windup_increases_power_parent.child_buff_template = "weapon_trait_bespoke_powermaul_p1_windup_increases_power_child"
templates.weapon_trait_bespoke_powermaul_p1_windup_increases_power_child = table.clone(BaseWeaponTraitBuffTemplates.windup_increases_power_child)
templates.weapon_trait_bespoke_powermaul_p1_block_has_chance_to_stun = {
	cooldown_duration = 5,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_block] = 0.25
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	proc_func = function (params, template_data, template_context, t)
		local attacking_unit = params.attacking_unit
		local attacking_unit_buff_extension = ScriptUnit.has_extension(attacking_unit, "buff_system")

		if attacking_unit_buff_extension then
			attacking_unit_buff_extension:add_internally_controlled_buff("power_maul_stun", t)
		end
	end
}
templates.weapon_trait_bespoke_powermaul_p1_staggering_hits_has_chance_to_stun = {
	cooldown_duration = 5,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
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
	end
}
templates.weapon_trait_bespoke_powermaul_p1_damage_bonus_vs_electrocuded = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.damage_vs_electrocuted] = 0.5
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}

return templates
