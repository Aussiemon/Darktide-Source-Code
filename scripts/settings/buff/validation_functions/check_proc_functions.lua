local AttackSettings = require("scripts/settings/damage/attack_settings")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local MinionState = require("scripts/utilities/minion_state")
local attack_results = AttackSettings.attack_results
local stagger_results = AttackSettings.stagger_results
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local CLOSE_RANGE_RANGED = DamageSettings.ranged_close
local CLOSE_RANGE_SQUARED = CLOSE_RANGE_RANGED * CLOSE_RANGE_RANGED
local CheckProcFunctions = {
	on_kill = function (params)
		if params.attack_result ~= attack_results.died then
			return false
		end

		return true
	end,
	on_one_hit_kill = function (params)
		if params.attack_result ~= attack_results.died then
			return false
		end

		return params.one_hit_kill
	end,
	on_non_kill = function (params)
		if params.attack_result == attack_results.died then
			return false
		end

		return true
	end,
	on_weakspot_kill = function (params)
		if params.attack_result ~= attack_results.died then
			return false
		end

		if not params.hit_weakspot then
			return false
		end

		return true
	end,
	on_elite_kill = function (params)
		if params.attack_result ~= attack_results.died then
			return false
		end

		if not params.tags or not params.tags.elite then
			return false
		end

		return true
	end,
	on_special_kill = function (params)
		if params.attack_result ~= attack_results.died then
			return false
		end

		if not params.tags or not params.tags.special then
			return false
		end

		return true
	end,
	on_elite_or_special_kill = function (params)
		if params.attack_result ~= attack_results.died then
			return false
		end

		if not params.tags then
			return false
		end

		if not params.tags.elite and not params.tags.special then
			return false
		end

		return true
	end,
	on_ranged_kill = function (params)
		if params.attack_result ~= attack_results.died then
			return false
		end

		if params.attack_type ~= attack_types.ranged then
			return false
		end

		return true
	end,
	on_melee_kill = function (params)
		if params.attack_result ~= attack_results.died then
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

		if not params.attack_result == attack_results.died then
			return false
		end

		return true
	end,
	on_weapon_special_kill = function (params)
		if params.attack_result ~= attack_results.died then
			return false
		end

		if not params.weapon_special then
			return false
		end

		return true
	end,
	on_special_smite_kill = function (params)
		local killed = params.attack_result == attack_results.died

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

		if params.attack_result ~= attack_results.died then
			return false
		end

		return true
	end
}
local warp_damage_types = {
	electrocution = true,
	force_staff_bfg = true,
	smite = true,
	warp = true,
	psyker_biomancer_discharge = true,
	biomancer_soul = true,
	force_staff_single_target = true
}

CheckProcFunctions.on_warp_kill = function (params)
	if params.attack_result ~= attack_results.died then
		return false
	end

	local damage_type = params.damage_type

	if warp_damage_types[damage_type] then
		return true
	end

	return false
end

CheckProcFunctions.on_ranged_close_kill = function (params)
	if params.attack_result ~= attack_results.died then
		return false
	end

	if params.attack_type ~= attack_types.ranged then
		return false
	end

	local attacked_unit = params.attacked_unit

	if not Unit.alive(attacked_unit) then
		return
	end

	local attacking_unit = params.attacking_unit
	local attacked_pos = POSITION_LOOKUP[attacked_unit] or Unit.world_position(attacked_unit, 1)
	local attacking_pos = POSITION_LOOKUP[attacking_unit] or Unit.world_position(attacking_unit, 1)

	return Vector3.distance_squared(attacked_pos, attacking_pos) <= CLOSE_RANGE_SQUARED
end

CheckProcFunctions.on_block_broken = function (params)
	return params.block_broken
end

CheckProcFunctions.on_crit = function (params)
	if not params.is_critical_strike then
		return false
	end

	return true
end

CheckProcFunctions.on_crit_kills = function (params)
	return params.is_critical_strike and params.attack_result == attack_results.died
end

CheckProcFunctions.on_ranged_hit = function (params)
	return params.attack_type == attack_types.ranged
end

CheckProcFunctions.on_melee_hit = function (params)
	return params.attack_type == attack_types.melee
end

CheckProcFunctions.on_melee_weapon_special_hit = function (params)
	return params.weapon_special and params.attack_type == attack_types.melee
end

CheckProcFunctions.on_melee_crit_hit = function (params)
	return params.is_critical_strike and params.attack_type == attack_types.melee
end

CheckProcFunctions.on_multiple_melee_hit = function (params, template_data, template_context)
	if not CheckProcFunctions.on_melee_hit(params) then
		return false
	end

	local template_override_data = template_context.template_override_data
	local buff_data = template_override_data and template_override_data.buff_data or template_data.buff_data
	local required_num_hits = buff_data.required_num_hits
	local target_index = params.target_index

	return target_index and required_num_hits <= target_index
end

CheckProcFunctions.on_ranged_crit_hit = function (params)
	return params.is_critical_strike and params.attack_type == attack_types.ranged
end

CheckProcFunctions.on_explosion_hit = function (params)
	return params.attack_type == attack_types.explosion
end

CheckProcFunctions.on_heavy_hit = function (params)
	if params.is_heavy then
		return true
	end

	local melee_attack_strength = params.melee_attack_strength

	return melee_attack_strength and melee_attack_strength == "heavy"
end

CheckProcFunctions.on_weakspot_hit = function (params)
	return params.hit_weakspot
end

CheckProcFunctions.on_non_weakspot_hit = function (params)
	return not params.hit_weakspot
end

CheckProcFunctions.on_weakspot_crit = function (params)
	return params.hit_weakspot and params.is_critical_strike
end

CheckProcFunctions.on_ranged_weakspot_kills = function (params)
	return CheckProcFunctions.on_weakspot_hit(params) and CheckProcFunctions.on_ranged_kill(params)
end

CheckProcFunctions.on_alternative_fire_hit = function (params)
	return params.alternative_fire
end

CheckProcFunctions.on_ranged_hit_weakspot = function (params)
	return params.hit_weakspot and params.attack_type == attack_types.ranged
end

CheckProcFunctions.on_stagger_hit = function (params)
	local attacked_unit = params.attacked_unit

	return MinionState.is_minion(attacked_unit) and MinionState.is_staggered(attacked_unit)
end

CheckProcFunctions.on_staggering_hit = function (params)
	local stagger_result = params.stagger_result

	return stagger_result == stagger_results.stagger
end

CheckProcFunctions.on_meelee_stagger_hit = function (params)
	return CheckProcFunctions.on_melee_hit and CheckProcFunctions.on_stagger_hit
end

CheckProcFunctions.on_weapon_special_kill = function (params)
	return params.weapon_special and params.attack_result == attack_results.died
end

CheckProcFunctions.on_weapon_special_melee_stagger_hit = function (params)
	return CheckProcFunctions.on_melee_weapon_special_hit(params) and CheckProcFunctions.on_stagger_hit(params)
end

CheckProcFunctions.on_ranged_stagger_hit = function (params)
	return CheckProcFunctions.on_ranged_hit(params) and CheckProcFunctions.on_stagger_hit(params)
end

CheckProcFunctions.on_chain_lightning_hit = function (params)
	return params.damage_type == damage_types.electrocution
end

CheckProcFunctions.on_shoot_hit_multiple = function (params)
	return params.num_hit_units > 3
end

CheckProcFunctions.on_hit_all_pellets_on_same = function (params)
	return params.hit_all_pellets and params.num_hit_units == 1
end

CheckProcFunctions.would_die = function (params, template_data, template_context)
	local unit = template_context.unit
	local health_extension = ScriptUnit.extension(unit, "health_system")
	local current_health = health_extension:current_health()
	local is_going_to_die = current_health <= 1

	return is_going_to_die
end

CheckProcFunctions.check_item_slot = function (params, template_data, template_context)
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
		return ConditionalFunctions.is_item_slot_wielded(template_data, template_context)
	end

	local projectile_origin_item_slot = projetile_damage_extension:get_origin_item_slot()
	local is_slot_active = projectile_origin_item_slot == item_slot_name

	return is_slot_active
end

CheckProcFunctions.on_melee_and_check_item_slot = function (params, template_data, template_context)
	return CheckProcFunctions.on_melee_hit(params) and CheckProcFunctions.check_item_slot(params, template_data, template_context)
end

CheckProcFunctions.on_ranged_and_check_item_slot = function (params, template_data, template_context)
	return CheckProcFunctions.on_ranged_hit(params) and CheckProcFunctions.check_item_slot(params, template_data, template_context)
end

CheckProcFunctions.on_explosion_and_check_item_slot = function (params, template_data, template_context)
	return CheckProcFunctions.on_explosion_hit(params) and CheckProcFunctions.check_item_slot(params, template_data, template_context)
end

CheckProcFunctions.on_continues_fire_full_auto = function (params, template_data, template_context)
	return params.num_shots_fired > 1
end

CheckProcFunctions.on_continues_fire_semi_automatic = function (params, template_data, template_context)
	return params.combo_count > 1
end

return CheckProcFunctions
