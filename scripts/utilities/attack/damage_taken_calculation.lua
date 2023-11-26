-- chunkname: @scripts/utilities/attack/damage_taken_calculation.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FriendlyFire = require("scripts/utilities/attack/friendly_fire")
local Health = require("scripts/utilities/health")
local ToughnessDepleted = require("scripts/utilities/toughness/toughness_depleted")
local ToughnessSettings = require("scripts/settings/toughness/toughness_settings")
local attack_results = AttackSettings.attack_results
local damage_types = DamageSettings.damage_types
local health_settings = AttackSettings.health_settings
local shield_settings = AttackSettings.shield_settings
local toughness_template_types = ToughnessSettings.template_types
local buff_keywords = BuffSettings.keywords
local _calculate_shield_damage, _calculate_toughness_damage, _calculate_toughness_damage_player, _calculate_toughness_damage_minion, _calculate_health_damage, _calculate_health_damage_player, _calculate_health_damage_minion
local DamageTakenCalculation = {}

DamageTakenCalculation.get_calculation_parameters = function (attacked_unit, attacked_breed_or_nil, damage_profile, attacking_unit, attacking_unit_owner_unit, hit_actor, attacker_buff_extension)
	local side_system = Managers.state.extension:system("side_system")
	local is_ally = side_system:is_ally(attacked_unit, attacking_unit_owner_unit)
	local damage_allowed = not is_ally or FriendlyFire.is_enabled(attacking_unit_owner_unit, attacked_unit) or damage_profile.override_allow_friendly_fire
	local is_player = Breed.is_player(attacked_breed_or_nil)
	local is_minion = Breed.is_minion(attacked_breed_or_nil)
	local is_living_prop = Breed.is_living_prop(attacked_breed_or_nil)
	local health_setting = is_player and health_settings.player or (is_minion or is_living_prop) and health_settings.minion
	local health_extension = ScriptUnit.extension(attacked_unit, "health_system")
	local is_invulnerable = health_extension:is_invulnerable()
	local current_health_damage = health_extension:damage_taken()
	local current_permanent_damage = health_extension:permanent_damage_taken()
	local max_health = health_extension:max_health()
	local max_wounds = health_extension:max_wounds()
	local toughness_exension = ScriptUnit.has_extension(attacked_unit, "toughness_system")
	local toughness_template, weapon_toughness_template

	if toughness_exension then
		toughness_template, weapon_toughness_template = toughness_exension:toughness_templates()
	end

	local current_toughness_damage = toughness_exension and toughness_exension:toughness_damage() or 0
	local movement_state

	if is_player then
		local unit_data_extension = ScriptUnit.extension(attacked_unit, "unit_data_system")
		local movement_state_component = unit_data_extension:read_component("movement_state")

		movement_state = movement_state_component and movement_state_component.method
	end

	local shield_extension = ScriptUnit.has_extension(attacked_unit, "shield_system")
	local shield_setting

	if shield_extension then
		local can_shield_block = shield_extension:can_block_attack(damage_profile, attacking_unit, attacking_unit_owner_unit, hit_actor)

		shield_setting = can_shield_block and shield_settings.block_all
	end

	local buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")
	local attacked_unit_stat_buffs = buff_extension and buff_extension:stat_buffs()
	local attacked_unit_keywords = buff_extension and buff_extension:keywords()
	local attacking_unit_stat_buffs = attacker_buff_extension and attacker_buff_extension:stat_buffs()

	return is_invulnerable, damage_allowed, health_setting, current_health_damage, current_permanent_damage, max_health, max_wounds, toughness_template, weapon_toughness_template, current_toughness_damage, movement_state, shield_setting, attacked_unit_stat_buffs, attacked_unit_keywords, attacking_unit_stat_buffs
end

DamageTakenCalculation.calculate_attack_result = function (damage_amount, damage_profile, attack_type, attack_direction, instakill, is_invulnerable, damage_allowed, health_setting, current_health_damage, current_permanent_damage, max_health, max_wounds, toughness_template, weapon_toughness_template, current_toughness_damage, movement_state, shield_setting, attacked_unit_stat_buffs, attacked_unit_keywords, attacked_unit, damage_type, attacking_unit_stat_buffs)
	if not damage_allowed then
		return attack_results.friendly_fire, 0, 0, 0, damage_amount
	end

	local remaining_damage = damage_amount
	local remaining_permanent_damage = 0
	local damage_absorbed = 0
	local toughness_damage = 0
	local attack_result, shield_attack_result, shield_damage_absorbed

	shield_attack_result, remaining_damage, shield_damage_absorbed = _calculate_shield_damage(remaining_damage, damage_profile, shield_setting, instakill)
	damage_absorbed = damage_absorbed + shield_damage_absorbed

	if shield_attack_result then
		attack_result = shield_attack_result
	end

	if remaining_damage > 0 then
		local toughness_attack_result, toughness_damage_absorbed

		toughness_attack_result, remaining_damage, toughness_damage, toughness_damage_absorbed = _calculate_toughness_damage(remaining_damage, damage_profile, attack_type, attack_direction, toughness_template, weapon_toughness_template, current_toughness_damage, movement_state, attacked_unit_stat_buffs, attacked_unit_keywords, instakill, attacked_unit)
		damage_absorbed = damage_absorbed + toughness_damage_absorbed

		if toughness_attack_result then
			attack_result = attack_result or toughness_attack_result
		end
	end

	if remaining_damage > 0 then
		local health_attack_result

		health_attack_result, remaining_damage, remaining_permanent_damage = _calculate_health_damage(remaining_damage, damage_profile, damage_type, current_health_damage, current_permanent_damage, max_health, max_wounds, instakill, is_invulnerable, attacked_unit_stat_buffs, attacked_unit_keywords, health_setting, attacking_unit_stat_buffs)

		if health_attack_result then
			attack_result = attack_result or health_attack_result
		end
	end

	attack_result = attack_result or attack_results.damaged

	return attack_result, remaining_damage, remaining_permanent_damage, toughness_damage, damage_absorbed
end

function _calculate_shield_damage(damage_amount, damage_profile, shield_setting, instakill)
	local ignore_shield = damage_profile.ignore_shield or instakill
	local block_damage = shield_setting == shield_settings.block_all

	if not ignore_shield and block_damage then
		return attack_results.shield_blocked, 0, damage_amount
	end

	return nil, damage_amount, 0
end

function _calculate_toughness_damage(damage_amount, damage_profile, attack_type, attack_direction, toughness_template, weapon_toughness_template, current_toughness_damage, movement_state, attacked_unit_stat_buffs, attacked_unit_keywords, instakill, attacked_unit)
	local ignore_toughness = damage_profile.ignore_toughness or instakill

	if not ignore_toughness then
		local toughness_template_type = toughness_template and toughness_template.template_type

		if toughness_template_type == toughness_template_types.player then
			return _calculate_toughness_damage_player(damage_amount, damage_profile, attack_type, attack_direction, toughness_template, weapon_toughness_template, current_toughness_damage, movement_state, attacked_unit_stat_buffs, attacked_unit_keywords, instakill, attacked_unit)
		elseif toughness_template_type == toughness_template_types.minion then
			return _calculate_toughness_damage_minion(damage_amount, damage_profile, attack_type, attack_direction, toughness_template, current_toughness_damage, attacked_unit_stat_buffs, instakill)
		end
	end

	return nil, damage_amount, 0, 0
end

function _calculate_toughness_damage_player(damage_amount, damage_profile, attack_type, attack_direction, toughness_template, weapon_toughness_template, current_toughness_damage, movement_state, attacked_unit_stat_buffs, attacked_unit_keywords, instakill, attacked_unit)
	local toughness_bonus_flat = attacked_unit_stat_buffs.toughness_bonus_flat or 0
	local toughness_extra = attacked_unit_stat_buffs.toughness or 0
	local toughness_bonus = attacked_unit_stat_buffs.toughness_bonus or 1
	local template_max_toughness = toughness_template.max
	local max_toughness = (template_max_toughness + toughness_extra) * toughness_bonus + toughness_bonus_flat
	local toughness_before_damage = max_toughness - current_toughness_damage

	if max_toughness <= current_toughness_damage then
		return nil, damage_amount, 0, 0
	end

	local melee_attack = attack_type == "melee"
	local ranged_attack = attack_type == "ranged"
	local remaining_damage = 0
	local toughness_damage, absorbed_attack, toughness_broken
	local zealot_toughness = attacked_unit_keywords.zealot_toughness
	local toughness_melee_damage_modifier = weapon_toughness_template and weapon_toughness_template.melee_damage_modifier or toughness_template.melee_damage_modifier or 1
	local damage_modifier = toughness_template.state_damage_modifiers[movement_state] or 1
	local toughness_multiplier = damage_profile.toughness_multiplier or 1
	local weapon_toughness_multiplier = weapon_toughness_template and weapon_toughness_template.toughness_damage_modifier or 1

	damage_modifier = damage_modifier + toughness_multiplier * weapon_toughness_multiplier - 1

	local buff_toughness_damage_taken_multiplier = attacked_unit_stat_buffs and attacked_unit_stat_buffs.toughness_damage_taken_multiplier or 1
	local buff_toughness_damage_taken_modifier = attacked_unit_stat_buffs and attacked_unit_stat_buffs.toughness_damage_taken_modifier or 1
	local damage_buff_multiplier = buff_toughness_damage_taken_multiplier * buff_toughness_damage_taken_modifier

	damage_modifier = damage_modifier * damage_buff_multiplier
	toughness_damage = math.clamp(damage_amount * damage_modifier, 0, max_toughness)

	local current_toughness_percent = 1 - current_toughness_damage / max_toughness or 0
	local has_bolstered_toughness = current_toughness_percent >= 1 and toughness_bonus_flat > 0

	if melee_attack then
		local melee_toughness_multiplier = damage_profile.melee_toughness_multiplier or 1

		current_toughness_damage = math.clamp(current_toughness_damage - toughness_bonus_flat, 0, current_toughness_damage)
		toughness_damage = math.clamp(toughness_damage * melee_toughness_multiplier * toughness_melee_damage_modifier, 0, max_toughness)

		local bleedthrough_toughness_damage = damage_amount

		if damage_profile.on_depleted_toughness_function_override_name then
			local remaining_toughness = max_toughness - current_toughness_damage

			bleedthrough_toughness_damage = math.min(damage_amount, remaining_toughness)
		end

		local toughness_melee_spillover_modifier = toughness_template.melee_spillover_modifier or 1
		local toughness_factor_spillover_modifier = has_bolstered_toughness and 1 or damage_profile.toughness_factor_spillover_modifier or 1
		local toughness_factor = current_toughness_percent * max_toughness / max_toughness * toughness_factor_spillover_modifier
		local bleedthrough_damage = math.lerp(bleedthrough_toughness_damage * 1, bleedthrough_toughness_damage * 0, math.min(toughness_factor, 1) * toughness_melee_spillover_modifier)

		absorbed_attack = max_toughness > current_toughness_damage + toughness_damage
		toughness_broken = not absorbed_attack and toughness_before_damage > 0 or false

		if toughness_broken and damage_profile.on_depleted_toughness_function_override_name then
			if has_bolstered_toughness then
				remaining_damage = 0
			else
				local toughness_depleted_func = ToughnessDepleted[damage_profile.on_depleted_toughness_function_override_name]

				remaining_damage = toughness_depleted_func(current_toughness_damage, max_toughness, damage_amount)
			end
		end

		remaining_damage = remaining_damage + bleedthrough_damage
	else
		if not ranged_attack and not damage_profile.ignore_depleting_toughness then
			toughness_damage = max_toughness
		end

		absorbed_attack = max_toughness > current_toughness_damage + toughness_damage
		toughness_broken = not absorbed_attack and toughness_before_damage > 0

		if toughness_broken then
			if has_bolstered_toughness then
				remaining_damage = 0
			elseif damage_profile.on_depleted_toughness_function_override_name then
				local toughness_depleted_func = ToughnessDepleted[damage_profile.on_depleted_toughness_function_override_name]

				remaining_damage = toughness_depleted_func(current_toughness_damage, max_toughness, damage_amount)
			elseif weapon_toughness_template and weapon_toughness_template.optional_on_depleted_function_name_override then
				local toughness_depleted_func = ToughnessDepleted[weapon_toughness_template.optional_on_depleted_function_name_override]

				remaining_damage = toughness_depleted_func(current_toughness_damage, max_toughness, damage_amount)
			else
				remaining_damage = toughness_template.on_depleted_function(current_toughness_damage, max_toughness, damage_amount)
			end
		else
			remaining_damage = 0
		end
	end

	local attack_result = absorbed_attack and melee_attack and attack_results.toughness_absorbed_melee or absorbed_attack and attack_results.toughness_absorbed or toughness_broken and attack_results.toughness_broken
	local absorbed_damage = damage_amount - remaining_damage

	return attack_result, remaining_damage, toughness_damage, absorbed_damage
end

function _calculate_toughness_damage_minion(damage_amount, damage_profile, attack_type, attack_direction, toughness_template, current_toughness_damage, attacked_unit_stat_buffs, instakill)
	local max_toughness = Managers.state.difficulty:get_table_entry_by_challenge(toughness_template.max)

	if damage_profile.skip_minion_toughness then
		return nil, damage_amount, 0, 0
	end

	if max_toughness <= current_toughness_damage then
		return nil, damage_amount, 0, 0
	end

	local max_hit_percent = Managers.state.difficulty:get_table_entry_by_challenge(toughness_template.max_hit_percent)
	local clamped_damage_amount = damage_amount

	if max_hit_percent then
		local max_damage = math.round(max_toughness * max_hit_percent)

		clamped_damage_amount = math.min(max_damage, damage_amount)
	end

	local absorbed_attack = max_toughness > current_toughness_damage + damage_amount
	local attack_result = absorbed_attack and attack_results.toughness_absorbed

	return attack_result, 0, clamped_damage_amount, damage_amount
end

function _calculate_health_damage(damage_amount, damage_profile, damage_type, current_health_damage, current_permanent_damage, max_health, max_wounds, instakill, is_invulnerable, attacked_unit_stat_buffs, attacked_unit_keywords, health_setting, attacking_unit_stat_buffs)
	if health_setting == health_settings.player then
		return _calculate_health_damage_player(damage_amount, damage_profile, damage_type, current_health_damage, current_permanent_damage, max_health, max_wounds, instakill, is_invulnerable, attacked_unit_stat_buffs, attacked_unit_keywords, attacking_unit_stat_buffs)
	elseif health_setting == health_settings.minion then
		return _calculate_health_damage_minion(damage_amount, damage_profile, damage_type, current_health_damage, current_permanent_damage, max_health, max_wounds, instakill, is_invulnerable, attacked_unit_stat_buffs, attacked_unit_keywords)
	end

	return attack_results.damaged, damage_amount, 0
end

function _calculate_health_damage_player(damage_amount, damage_profile, damage_type, current_health_damage, current_permanent_damage, max_health, max_wounds, instakill, is_invulnerable, attacked_unit_stat_buffs, attacked_unit_keywords, attacking_unit_stat_buffs)
	if is_invulnerable then
		return attack_results.damaged, 0, 0
	end

	local permanent_damage_profile_ratio = damage_profile and damage_profile.permanent_damage_ratio or 0
	local permanent_damage_buff_ratio = attacked_unit_stat_buffs and attacked_unit_stat_buffs.permanent_damage_taken or 0
	local permanent_damage_buff_resistance = attacked_unit_stat_buffs and attacked_unit_stat_buffs.permanent_damage_converter_resistance or 0
	local permament_damage_attacker_buff_ratio = attacking_unit_stat_buffs and attacking_unit_stat_buffs.permanent_damage_ratio or 0
	local permanent_damage_ratio = math.clamp(permanent_damage_profile_ratio + permanent_damage_buff_ratio + permament_damage_attacker_buff_ratio * (1 - permanent_damage_buff_resistance), 0, 1)
	local is_grimoire_damage = damage_type == damage_types.grimoire
	local buff_corruption_taken_grimoire_multiplier = is_grimoire_damage and attacked_unit_stat_buffs and attacked_unit_stat_buffs.corruption_taken_grimoire_multiplier or 1
	local buff_corruption_taken_multiplier = attacked_unit_stat_buffs and attacked_unit_stat_buffs.corruption_taken_multiplier or 1

	buff_corruption_taken_multiplier = math.max(0, buff_corruption_taken_multiplier)

	local permanent_damage = damage_amount * permanent_damage_ratio * buff_corruption_taken_multiplier * buff_corruption_taken_grimoire_multiplier
	local health_damage = damage_amount * (1 - permanent_damage_ratio)

	if max_health - (current_permanent_damage + permanent_damage) < 1 then
		permanent_damage = math.max(0, max_health - current_permanent_damage - 1)
	end

	if current_health_damage < current_permanent_damage + permanent_damage then
		health_damage = health_damage + (current_permanent_damage + permanent_damage) - current_health_damage
	end

	local has_health_segement_buff = attacked_unit_keywords and attacked_unit_keywords[buff_keywords.health_segment_breaking_reduce_damage_taken]

	if has_health_segement_buff then
		local _, current_segement_health = Health.number_of_health_segements_damage_taken(current_health_damage, max_health, max_wounds)

		if current_segement_health < health_damage then
			local damage_taken_multiplier = attacked_unit_stat_buffs.health_segment_damage_taken_multiplier

			health_damage = health_damage * damage_taken_multiplier
		end
	end

	local remaining_health = max_health - current_health_damage - health_damage
	local will_die = remaining_health <= 0
	local attack_result = will_die and attack_results.knock_down or attack_results.damaged

	return attack_result, health_damage, permanent_damage
end

function _calculate_health_damage_minion(damage_amount, damage_type, damage_profile, current_health_damage, current_permanent_damage, max_health, max_wounds, instakill, is_invulnerable, attacked_unit_stat_buffs, attacked_unit_keywords)
	if is_invulnerable then
		return attack_results.damaged, 0, 0
	end

	local remaining_health = max_health - current_health_damage - damage_amount
	local will_die = remaining_health <= 0
	local attack_result = will_die and attack_results.died or attack_results.damaged

	return attack_result, damage_amount, 0
end

return DamageTakenCalculation
