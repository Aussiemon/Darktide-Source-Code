-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_powermaul_p3_buff_templates.lua

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local Breeds = require("scripts/settings/breed/breeds")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local attack_types = AttackSettings.attack_types
local damage_efficiencies = AttackSettings.damage_efficiencies
local stagger_results = AttackSettings.stagger_results
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_powermaul_p3_block_has_chance_to_stun = {
	allow_proc_while_active = false,
	child_buff_template = "powermaul_p3_block_has_chance_to_stun_child",
	child_duration = 5,
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_perfect_block] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_perfect_block] = 1,
	},
	conditional_proc_func = function (template_data, template_context, t)
		local stacks = template_context.buff_extension:current_stacks("powermaul_p3_block_has_chance_to_stun_child")

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
templates.powermaul_p3_block_has_chance_to_stun_child = {
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
templates.weapon_trait_bespoke_powermaul_p3_stagger_bonus_damage = table.clone(BaseWeaponTraitBuffTemplates.stagger_bonus_damage)
templates.weapon_trait_bespoke_powermaul_p3_power_bonus_scaled_on_stamina = table.clone(BaseWeaponTraitBuffTemplates.power_bonus_scaled_on_stamina)
templates.weapon_trait_bespoke_powermaul_p3_stacking_increase_impact_on_hit_parent = table.clone(BaseWeaponTraitBuffTemplates.stacking_increase_impact_on_hit_parent)
templates.weapon_trait_bespoke_powermaul_p3_stacking_increase_impact_on_hit_child = table.clone(BaseWeaponTraitBuffTemplates.stacking_increase_impact_on_hit_child)
templates.weapon_trait_bespoke_powermaul_p3_stacking_increase_impact_on_hit_parent.child_buff_template = "weapon_trait_bespoke_powermaul_p3_stacking_increase_impact_on_hit_child"
templates.weapon_trait_bespoke_powermaul_p3_staggering_hits_has_chance_to_stun = {
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
		local is_valid_target = CheckProcFunctions.on_elite_or_special_hit(params, template_data, template_context)

		return stagger_result == stagger_results.stagger and damage_efficiency == damage_efficiencies.full and is_valid_target
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
templates.weapon_trait_bespoke_powermaul_p3_targets_receive_rending_debuff = table.clone(BaseWeaponTraitBuffTemplates.targets_receive_rending_debuff)
templates.weapon_trait_bespoke_powermaul_p3_toughness_recovery_on_chained_attacks = table.clone(BaseWeaponTraitBuffTemplates.toughness_recovery_on_chained_attacks)
templates.weapon_trait_bespoke_powermaul_p3_enhanced_arc_jumps_angle = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.chain_lightning_powermaul_max_angle] = math.degrees_to_radians(10),
		[stat_buffs.chain_lightning_powermaul_max_jumps] = 1,
		[stat_buffs.chain_lightning_powermaul_max_radius] = 0.5,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_powermaul_p3_arc_has_killing_blow_chance = {
	class_name = "proc_buff",
	hide_icon_in_hud = true,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	target_buff_data = {
		killing_blow_chance = 0.2,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		if not CheckProcFunctions.on_item_match(params, template_data, template_context) then
			return false
		end

		local attacked_unit = params.attacked_unit

		if not HEALTH_ALIVE[attacked_unit] then
			return false
		end

		if params.attack_type ~= attack_types.arc then
			return false
		end

		local breed_name = params.breed_name
		local target_breed = breed_name and Breeds[breed_name]

		if target_breed then
			local tags = target_breed.tags
			local excluded = tags and (tags.captain or tags.monster or tags.ogryn or tags.cultist_captain)

			if excluded then
				return false
			end
		else
			return false
		end

		local template_override_data = template_context.template_override_data
		local target_buff_data = template_override_data and template_override_data.target_buff_data or template_data.target_buff_data
		local killing_blow_chance = target_buff_data.killing_blow_chance
		local random_value = math.random()

		return random_value < killing_blow_chance
	end,
	proc_func = function (params, template_data, template_context)
		local damage_profile = DamageProfileTemplates.chain_lightning_killing_blow
		local attacked_unit = params.attacked_unit
		local attack_direction = params.attack_direction:unbox()
		local hit_world_position_box = params.hit_world_position
		local hit_world_position = hit_world_position_box and hit_world_position_box:unbox()

		Attack.execute(attacked_unit, damage_profile, "power_level", DEFAULT_POWER_LEVEL, "instakill", true, "attack_direction", attack_direction, "hit_world_position", hit_world_position, "hit_zone_name", params.hit_zone_name, "damage_type", params.damage_type, "attack_type", params.attack_type, "attacking_unit", template_context.unit)
	end,
}

return templates
