-- chunkname: @scripts/utilities/action/flamer_action.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local RangedAction = require("scripts/utilities/action/ranged_action")
local Suppression = require("scripts/utilities/attack/suppression")
local proc_events = BuffSettings.proc_events
local ATTACK_RESULT_DIED = AttackSettings.attack_results.died
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local FlamerAction = {}

FlamerAction.damage_target = function (player_unit, target_unit, target_index, hit_mass_lerp_t, damage_type, is_critical_strike, flamer_gas_template, weapon, player_buff_extension)
	local damage_config = flamer_gas_template.damage
	local damage_profile = damage_config.impact.damage_profile
	local min_power_level_multiplier = damage_config.impact.min_power_level_multiplier
	local player_pos = POSITION_LOOKUP[player_unit]
	local target_pos = POSITION_LOOKUP[target_unit]
	local actor
	local hit_position = target_pos
	local hit_distance = Vector3.distance(target_pos, player_pos)
	local direction = Vector3.normalize(target_pos - player_pos)
	local hit_normal, hit_zone_name
	local penetrated = false
	local instakill = false
	local damage_profile_lerp_values = DamageProfile.lerp_values(damage_profile, player_unit, target_index)
	local charge_level = 1
	local weapon_item = weapon.item
	local power_level = DEFAULT_POWER_LEVEL

	if hit_mass_lerp_t then
		local power_level_easing_func = damage_config.power_level_easing_func

		if power_level_easing_func then
			hit_mass_lerp_t = power_level_easing_func(hit_mass_lerp_t)
		end

		local power_level_multiplier = math.lerp(min_power_level_multiplier, 1, hit_mass_lerp_t)

		power_level = power_level * power_level_multiplier
	end

	local damage_dealt, attack_result, _, _ = RangedAction.execute_attack(target_index, player_unit, target_unit, actor, hit_position, hit_distance, direction, hit_normal, hit_zone_name, damage_profile, damage_profile_lerp_values, power_level, charge_level, penetrated, instakill, damage_type, is_critical_strike, weapon_item)

	if damage_dealt then
		local param_table = player_buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.attacked_unit = target_unit

			player_buff_extension:add_proc_event(proc_events.on_direct_flamer_hit, param_table)
		end
	end

	local target_died = attack_result == ATTACK_RESULT_DIED

	return target_died
end

local _broadphase_results = {}
local _suppressed_units = {}

FlamerAction.suppress_targets = function (t, player_unit, player_rotation_1p, flamer_gas_template, size_of_flame_template)
	table.clear(_broadphase_results)
	table.clear(_suppressed_units)

	local damage_config = flamer_gas_template.damage
	local damage_profile = damage_config.impact.damage_profile
	local suppression_radius = flamer_gas_template.suppression_radius
	local suppression_radius_squared = suppression_radius * suppression_radius
	local suppression_cone_radius = size_of_flame_template.suppression_cone_radius
	local suppression_cone_dot = flamer_gas_template.suppression_cone_dot
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local player_position = POSITION_LOOKUP[player_unit]
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local num_hits = broadphase.query(broadphase, player_position, suppression_cone_radius, _broadphase_results, enemy_side_names)
	local forward = Vector3.normalize(Vector3.flat(Quaternion.forward(player_rotation_1p)))

	for ii = 1, num_hits do
		local enemy_unit = _broadphase_results[ii]
		local enemy_unit_position = POSITION_LOOKUP[enemy_unit]
		local flat_direction = Vector3.flat(enemy_unit_position - player_position)
		local direction = Vector3.normalize(flat_direction)
		local dot = Vector3.dot(forward, direction)

		if suppression_cone_dot < dot then
			_suppressed_units[enemy_unit] = true
		else
			local distance_squared = Vector3.length_squared(flat_direction)

			if distance_squared < suppression_radius_squared then
				_suppressed_units[enemy_unit] = true
			end
		end
	end

	for hit_unit, _ in pairs(_suppressed_units) do
		Suppression.apply_suppression(hit_unit, player_unit, damage_profile, POSITION_LOOKUP[player_unit])
	end
end

FlamerAction.is_unit_blocking_flame = function (unit, player_pos, hit_zone_name_or_nil)
	local shield_extension = ScriptUnit.has_extension(unit, "shield_system")

	if shield_extension then
		return shield_extension:can_block_from_position(player_pos, hit_zone_name_or_nil)
	end
end

return FlamerAction
