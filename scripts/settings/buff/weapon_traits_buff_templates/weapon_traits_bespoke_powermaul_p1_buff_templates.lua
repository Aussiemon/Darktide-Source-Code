-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_powermaul_p1_buff_templates.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local stagger_results = AttackSettings.stagger_results
local damage_efficiencies = AttackSettings.damage_efficiencies
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local buff_keywords = BuffSettings.keywords
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
templates.block_has_chance_to_stun_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.melee_power_level_modifier] = 0.2,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_powermaul_p1_staggering_hits_has_chance_to_stun = {
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
templates.weapon_trait_bespoke_powermaul_p1_damage_bonus_vs_electrocuted = {
	class_name = "buff",
	hide_icon_in_hud = true,
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.damage_vs_electrocuted] = 0.5,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_powermaul_p1_hitting_electrocuted_spreads = {
	class_name = "proc_buff",
	heavy_proc = 2,
	hide_icon_in_hud = true,
	light_proc = 1,
	predicted = false,
	special_proc = 3,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_start] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		template_data.can_proc = true

		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase
		template_data.broadphase_results = {}

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
	end,
	specific_proc_func = {
		on_sweep_start = function (params, template_data, template_context, t)
			template_data.can_proc = true
		end,
		on_hit = function (params, template_data, template_context, t)
			if not template_data.can_proc then
				return
			end

			local attacked_unit = params.attacked_unit
			local has_extension = ScriptUnit.has_extension
			local target_buff_extension = attacked_unit and has_extension(attacked_unit, "buff_system")

			if not target_buff_extension then
				return
			end

			local is_target_electrocuted = target_buff_extension:has_keyword(buff_keywords.electrocuted)

			if not is_target_electrocuted then
				return
			end

			local position = Unit.alive(attacked_unit) and POSITION_LOOKUP[attacked_unit] or params.hit_world_position and params.hit_world_position:unbox()

			if not position then
				return
			end

			local melee_attack_strength = params.melee_attack_strength

			if not melee_attack_strength then
				return
			end

			local override_data = template_context.template_override_data
			local weapon_special = params.weapon_special

			if not weapon_special then
				return
			end

			local template = template_context.template
			local hits_allowed = override_data.special_proc or template.special_proc
			local broadphase = template_data.broadphase
			local enemy_side_names = template_data.enemy_side_names
			local broadphase_results = template_data.broadphase_results

			table.clear(broadphase_results)

			local distance = 3
			local num_results = broadphase.query(broadphase, position, distance, broadphase_results, enemy_side_names)

			for ii = 1, num_results do
				local hit_unit = broadphase_results[ii]

				if hit_unit ~= attacked_unit then
					local buff_extension = has_extension(hit_unit, "buff_system")

					if buff_extension then
						buff_extension:add_internally_controlled_buff("power_maul_stun", t)
					end

					hits_allowed = hits_allowed - 1

					if hits_allowed == 0 then
						break
					end
				end
			end

			template_data.can_proc = false
		end,
	},
}

return templates
