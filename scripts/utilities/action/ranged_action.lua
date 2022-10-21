local Armor = require("scripts/utilities/attack/armor")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local Explosion = require("scripts/utilities/attack/explosion")
local HitMass = require("scripts/utilities/attack/hit_mass")
local attack_results = AttackSettings.attack_results
local RangedAction = {
	target_index = function (target_index, penetrated, penetration_config)
		local new_target_index = target_index + 1

		if penetrated and penetration_config.target_index_increase then
			new_target_index = target_index + penetration_config.target_index_increase
		end

		return new_target_index
	end,
	execute_attack = function (target_index, attacker_unit, hit_unit, hit_actor, hit_position, hit_distance, attack_direction, hit_normal, hit_zone_name_or_nil, damage_profile, lerp_values, power_level, charge_level, penetrated, damage_config, instakill, damage_type, is_critical_strike, weapon_item_or_nil)
		local dropoff_scalar = DamageProfile.dropoff_scalar(hit_distance, damage_profile, lerp_values)
		local attack_type = AttackSettings.attack_types.ranged
		local herding_template = damage_profile.herding_template
		local damage_dealt, attack_result, damage_efficiency, stagger_result, hit_weakspot = Attack.execute(hit_unit, damage_profile, "target_index", target_index, "power_level", power_level, "charge_level", charge_level, "dropoff_scalar", dropoff_scalar, "attack_direction", attack_direction, "instakill", instakill, "hit_zone_name", hit_zone_name_or_nil, "hit_actor", hit_actor, "hit_world_position", hit_position, "attacking_unit", attacker_unit, "attack_type", attack_type, "herding_template", herding_template, "damage_type", damage_type, "is_critical_strike", is_critical_strike, "item", weapon_item_or_nil)

		return damage_dealt, attack_result, damage_efficiency, hit_weakspot
	end,
	armor_explosion = function (is_server, world, physics_world, attacker_unit, hit_unit, hit_zone_name_or_nil, hit_position, hit_normal, hit_distance, attack_direction, damage_config, power_level, charge_level, weapon_item_or_nil, orgin_slot_or_nil)
		if not is_server then
			return false
		end

		local explosion_arming_distance = damage_config.explosion_arming_distance

		if explosion_arming_distance and hit_distance < explosion_arming_distance then
			return false
		end

		local impact_config = damage_config.impact
		local armor_explosion = impact_config.armor_explosion

		if not armor_explosion then
			return false
		end

		local unit_data_extension = ScriptUnit.has_extension(hit_unit, "unit_data_system")
		local breed_or_nil = unit_data_extension and unit_data_extension:breed()

		if not breed_or_nil then
			return false
		end

		local target_armor = Armor.armor_type(hit_unit, breed_or_nil, hit_zone_name_or_nil)
		local armor_explosion_template = armor_explosion[target_armor]

		if not armor_explosion_template then
			return false
		end

		local attack_type = AttackSettings.attack_types.explosion
		local estimated_unit_diameter = breed_or_nil.player_locomotion_constrain_radius or breed_or_nil.broadphase_radius or 1
		local estimated_exit_position = hit_position + attack_direction * estimated_unit_diameter

		Explosion.create_explosion(world, physics_world, estimated_exit_position, hit_normal, attacker_unit, armor_explosion_template, power_level, charge_level, attack_type, false, false, weapon_item_or_nil, orgin_slot_or_nil)

		return true
	end,
	hitmass_explosion = function (is_server, world, physics_world, hit_mass_budget_attack, hit_mass_budget_impact, attacker_unit, hit_unit, hit_position, hit_normal, hit_distance, attack_direction, damage_config, attack_result, power_level, charge_level, weapon_item_or_nil, orgin_slot_or_nil)
		if not is_server then
			return false
		end

		local explosion_arming_distance = damage_config.explosion_arming_distance

		if explosion_arming_distance and hit_distance < explosion_arming_distance then
			return false
		end

		local hit_mass_depleted = HitMass.hit_mass_limit_reached(hit_mass_budget_attack, hit_mass_budget_impact)

		if not hit_mass_depleted then
			return false
		end

		local impact_config = damage_config.impact
		local hitmass_explosion = impact_config.hitmass_consumed_explosion

		if not hitmass_explosion then
			return false
		end

		local explosion_position, explosion_template = nil

		if attack_result == attack_results.died then
			local unit_data_extension = ScriptUnit.has_extension(hit_unit, "unit_data_system")
			local breed_or_nil = unit_data_extension and unit_data_extension:breed()
			local estimated_unit_center = (breed_or_nil and (breed_or_nil.player_locomotion_constrain_radius or breed_or_nil.broadphase_radius) or 1) * 0.5
			explosion_position = hit_position + attack_direction * estimated_unit_center
			explosion_template = hitmass_explosion.kill_explosion_template
		elseif attack_result ~= attack_results.dodged then
			explosion_position = hit_position
			explosion_template = hitmass_explosion.stop_explosion_template
		end

		if not explosion_template then
			return false
		end

		local attack_type = AttackSettings.attack_types.explosion

		Explosion.create_explosion(world, physics_world, explosion_position, hit_normal, attacker_unit, explosion_template, power_level, charge_level, attack_type, false, false, weapon_item_or_nil, orgin_slot_or_nil)

		return true
	end
}

return RangedAction
