local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local MinionState = require("scripts/utilities/minion_state")
local ConditionalFunctionTemplates = require("scripts/settings/buff/conditional_function_templates")
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local CheckProcFunctionTemplates = {
	on_kill_weakspot = function (params)
		if params.result ~= attack_results.died then
			return false
		end

		if not params.hit_weakspot then
			return false
		end

		return true
	end,
	on_kill = function (params)
		if params.result ~= attack_results.died then
			return false
		end

		return true
	end,
	on_elite_kill = function (params)
		if params.result ~= attack_results.died then
			return false
		end

		if not params.tags or not params.tags.elite then
			return false
		end

		return true
	end,
	on_special_kill = function (params)
		if params.result ~= attack_results.died then
			return false
		end

		if not params.tags or not params.tags.special then
			return false
		end

		return true
	end,
	on_ranged_kill = function (params)
		if params.result ~= attack_results.died then
			return false
		end

		if params.attack_type ~= attack_types.ranged then
			return false
		end

		return true
	end,
	on_melee_kill = function (params)
		if params.result ~= attack_results.died then
			return false
		end

		if params.attack_type ~= attack_types.melee then
			return false
		end

		return true
	end,
	on_sticky_kill = function (params)
		local sticky = params.sticky_attack

		if not sticky then
			return false
		end

		if not params.result == attack_results.died then
			return false
		end

		return true
	end,
	on_weapon_special_kill = function (params)
		if params.result ~= attack_results.died then
			return false
		end

		if not params.weapon_special then
			return false
		end

		return true
	end,
	on_special_smite_kill = function (params)
		local killed = params.result == attack_results.died

		if not killed then
			return false
		end

		local sticky = params.sticky_attack
		local smite = params.damage_type == damage_types.smite

		if not smite and not sticky then
			return false
		end

		local is_melee = params.attack_type == attack_types.melee

		if not is_melee then
			return false
		end

		return true
	end,
	on_smite_attack = function (params)
		return params.damage_type == damage_types.smite
	end,
	on_smite_kill = function (params)
		if params.damage_type ~= damage_types.smite then
			return false
		end

		if params.result ~= attack_results.died then
			return false
		end

		return true
	end
}
local warp_damage_types = {
	"biomancer_soul",
	"smite",
	"electrocution",
	"force_staff_single_target",
	"psyker_biomancer_discharge",
	"warpfire",
	"warp"
}

CheckProcFunctionTemplates.on_warp_kill = function (params)
	if params.result ~= attack_results.died then
		return false
	end

	local damage_type = params.damage_type

	if warp_damage_types[damage_type] then
		return true
	end

	return false
end

CheckProcFunctionTemplates.on_block_broken = function (params)
	return params.block_broken
end

CheckProcFunctionTemplates.on_crit = function (params)
	if not params.is_critical_strike then
		return false
	end

	return true
end

CheckProcFunctionTemplates.on_ranged_hit = function (params)
	return params.attack_type == attack_types.ranged
end

CheckProcFunctionTemplates.on_melee_hit = function (params)
	return params.attack_type == attack_types.melee
end

CheckProcFunctionTemplates.on_melee_crit_hit = function (params)
	if not params.is_critical_strike then
		return false
	end

	return params.attack_type == attack_types.melee
end

CheckProcFunctionTemplates.on_explosion_hit = function (params)
	return params.attack_type == attack_types.explosion
end

CheckProcFunctionTemplates.on_heavy_hit = function (params)
	local melee_attack_strength = params.melee_attack_strength

	return melee_attack_strength and melee_attack_strength == "heavy"
end

CheckProcFunctionTemplates.on_weakspot_hit = function (params)
	return params.hit_weakspot
end

CheckProcFunctionTemplates.on_ranged_weakspot_kills = function (params)
	return CheckProcFunctionTemplates.on_weakspot_hit(params) and CheckProcFunctionTemplates.on_ranged_kill(params)
end

CheckProcFunctionTemplates.on_alternative_fire_hit = function (params)
	return params.alternative_fire
end

CheckProcFunctionTemplates.on_ranged_hit_weakspot = function (params)
	local hit_weakspot = params.hit_weakspot

	if not hit_weakspot then
		return false
	end

	local attack_type = params.attack_type
	local valid_attack_type = attack_type == attack_types.ranged

	return valid_attack_type
end

CheckProcFunctionTemplates.on_stagger_hit = function (params)
	local attacked_unit = params.attacked_unit

	return MinionState.is_staggered(attacked_unit)
end

CheckProcFunctionTemplates.on_meelee_stagger_hit = function (params)
	return CheckProcFunctionTemplates.on_melee_hit and CheckProcFunctionTemplates.on_stagger_hit
end

CheckProcFunctionTemplates.on_ranged_stagger_hit = function (params)
	return CheckProcFunctionTemplates.on_ranged_hit(params) and CheckProcFunctionTemplates.on_stagger_hit(params)
end

CheckProcFunctionTemplates.on_chain_lightning_hit = function (params)
	return params.damage_type == damage_types.electrocution
end

CheckProcFunctionTemplates.would_die = function (params, template_data, template_context)
	local unit = template_context.unit
	local health_extension = ScriptUnit.extension(unit, "health_system")
	local current_health = health_extension:current_damaged_health()
	local is_going_to_die = current_health <= 1

	return is_going_to_die
end

CheckProcFunctionTemplates.check_item_slot = function (params, template_data, template_context)
	local item_slot_name = template_context.item_slot_name

	if not item_slot_name then
		return true
	end

	local attack_item_slot_origin = params.item_slot_origin

	if attack_item_slot_origin then
		local is_slot_active = attack_item_slot_origin == item_slot_name

		return is_slot_active
	end

	local attack_instigator_unit = params.attack_instigator_unit
	local is_instegator_alive = attack_instigator_unit and ALIVE[attack_instigator_unit]
	local projetile_damage_extension = is_instegator_alive and ScriptUnit.has_extension(attack_instigator_unit, "projectile_damage_system")

	if not projetile_damage_extension then
		return ConditionalFunctionTemplates.is_item_slot_wielded(template_data, template_context)
	end

	local projectile_origin_item_slot = projetile_damage_extension:get_origin_item_slot()
	local is_slot_active = projectile_origin_item_slot == item_slot_name

	return is_slot_active
end

CheckProcFunctionTemplates.on_melee_and_check_item_slot = function (params, template_data, template_context)
	return CheckProcFunctionTemplates.on_melee_hit(params) and CheckProcFunctionTemplates.check_item_slot(params, template_data, template_context)
end

CheckProcFunctionTemplates.on_ranged_and_check_item_slot = function (params, template_data, template_context)
	return CheckProcFunctionTemplates.on_ranged_hit(params) and CheckProcFunctionTemplates.check_item_slot(params, template_data, template_context)
end

CheckProcFunctionTemplates.on_explosion_and_check_item_slot = function (params, template_data, template_context)
	return CheckProcFunctionTemplates.on_explosion_hit(params) and CheckProcFunctionTemplates.check_item_slot(params, template_data, template_context)
end

return CheckProcFunctionTemplates
