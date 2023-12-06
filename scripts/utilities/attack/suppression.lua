local Breed = require("scripts/utilities/breed")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local MinionPerception = require("scripts/utilities/minion_perception")
local Suppression = {}
local _apply_suppression_falloff, _apply_suppression_minion, _apply_suppression_player, _get_breed = nil
local breed_types = BreedSettings.types
local DEFAULT_SUPPRESSION_VALUE = 1
local DEFAULT_SUPPRESSION_ATTACK_DELAY = 0.35
local MINION_BREED_TYPE = breed_types.minion
local PLAYER_BREED_TYPE = breed_types.player

Suppression.apply_suppression = function (hit_unit, attacking_unit, damage_profile, hit_position, optional_same_side_supression_enabled, num_suppressions)
	local breed = _get_breed(hit_unit)

	if not breed then
		return
	end

	if not optional_same_side_supression_enabled then
		local side_system = Managers.state.extension:system("side_system")
		local is_ally = side_system:is_ally(attacking_unit, hit_unit)

		if is_ally then
			return
		end
	end

	local lerp_values = DamageProfile.lerp_values(damage_profile, attacking_unit)
	local suppression_value = DamageProfile.suppression_value(damage_profile, lerp_values, num_suppressions) or DEFAULT_SUPPRESSION_VALUE
	local suppression_attack_delay = DamageProfile.suppression_attack_delay(damage_profile, lerp_values) or DEFAULT_SUPPRESSION_ATTACK_DELAY
	local attacking_unit_buff_extension = ScriptUnit.has_extension(attacking_unit, "buff_system")

	if attacking_unit_buff_extension then
		local stat_buffs = attacking_unit_buff_extension:stat_buffs()
		suppression_value = suppression_value * stat_buffs.suppression_dealt
	end

	if Breed.is_player(breed) then
		local stagger_category = damage_profile.stagger_category

		_apply_suppression_player(hit_unit, suppression_value, stagger_category, hit_position)
	else
		local suppression_type = damage_profile.suppression_type or "default"

		_apply_suppression_minion(hit_unit, suppression_value, suppression_type, suppression_attack_delay, attacking_unit, hit_position)
	end
end

Suppression.apply_suppression_decay_delay = function (suppressed_unit, decay_delay)
	local suppression_extension = ScriptUnit.has_extension(suppressed_unit, "suppression_system")

	if not suppression_extension then
		return
	end

	suppression_extension:apply_suppression_decay_delay(decay_delay)
end

Suppression.apply_area_explosion_suppression = function (attacking_unit, suppression_settings, from_position, optional_relation, optional_include_self, optional_lerp_values)
	local attacking_unit_breed = _get_breed(attacking_unit)

	if not attacking_unit_breed then
		return
	end

	if Breed.is_player(attacking_unit_breed) then
		Suppression.apply_area_minion_suppression(attacking_unit, suppression_settings, from_position, optional_relation, optional_include_self, optional_lerp_values)
	else
		local stagger_category = "explosion"

		Suppression.apply_area_player_suppression(attacking_unit, suppression_settings, from_position, stagger_category, optional_relation, optional_include_self, optional_lerp_values)
	end
end

local BROADPHASE_RESULTS = {}
local NO_LERP_VALUES = {}
local DEFAULT_RELATION = "enemy"
local DEFAULT_COVER_DISABLE_RANGE = {
	3,
	8
}

Suppression.apply_area_minion_suppression = function (attacking_unit, suppression_settings, from_position, optional_relation, optional_include_self, optional_lerp_values)
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[attacking_unit]

	if not side then
		return
	end

	local relation = optional_relation or DEFAULT_RELATION
	local target_side_names = side:relation_side_names(relation)
	local lerp_values = optional_lerp_values or NO_LERP_VALUES
	local broadphase_radius = suppression_settings.distance

	if type(broadphase_radius) == "table" then
		local lerp_value = DamageProfile.lerp_value_from_path(lerp_values, "distance")
		broadphase_radius = DamageProfile.lerp_damage_profile_entry(broadphase_radius, lerp_value)
	end

	local suppression_value = suppression_settings.suppression_value or DEFAULT_SUPPRESSION_VALUE

	if type(suppression_value) == "table" then
		local lerp_value = DamageProfile.lerp_value_from_path(lerp_values, "suppression_value")
		suppression_value = DamageProfile.lerp_damage_profile_entry(suppression_value, lerp_value)
	end

	local suppression_attack_delay = suppression_settings.suppression_attack_delay or DEFAULT_SUPPRESSION_ATTACK_DELAY

	if type(suppression_attack_delay) == "table" then
		local lerp_value = DamageProfile.lerp_value_from_path(lerp_values, "suppression_attack_delay")
		suppression_attack_delay = DamageProfile.lerp_damage_profile_entry(suppression_attack_delay, lerp_value)
	end

	local apply_suppression_falloff = suppression_settings.suppression_falloff
	local instant_aggro = suppression_settings.instant_aggro
	local num_results = broadphase:query(from_position, broadphase_radius, BROADPHASE_RESULTS, target_side_names, MINION_BREED_TYPE)

	for i = 1, num_results do
		local hit_unit = BROADPHASE_RESULTS[i]

		if hit_unit ~= attacking_unit or optional_include_self then
			local suppression_amount = suppression_value
			local to_position = POSITION_LOOKUP[hit_unit]
			local distance_from_source = Vector3.distance(from_position, to_position)

			if apply_suppression_falloff then
				suppression_amount = _apply_suppression_falloff(suppression_value, broadphase_radius, from_position, to_position, distance_from_source)
			end

			local suppression_type = "default"

			_apply_suppression_minion(hit_unit, suppression_amount, suppression_type, suppression_attack_delay, attacking_unit, from_position, instant_aggro)

			local cover_extension = ScriptUnit.has_extension(hit_unit, "cover_system")
			local disable_cover_radius = suppression_settings.disable_cover_radius or broadphase_radius * 0.5

			if cover_extension and distance_from_source < disable_cover_radius then
				local disable_cover_range = suppression_settings.disable_cover_time_range or DEFAULT_COVER_DISABLE_RANGE

				cover_extension:release_cover_slot(math.random_range(disable_cover_range[1], disable_cover_range[2]))
			end
		end
	end
end

Suppression.apply_area_player_suppression = function (attacking_unit, suppression_settings, from_position, stagger_category, optional_relation, optional_include_self, optional_lerp_values)
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[attacking_unit]
	local relation = optional_relation or DEFAULT_RELATION
	local target_side_names = side:relation_side_names(relation)
	local lerp_values = optional_lerp_values or NO_LERP_VALUES
	local broadphase_radius = suppression_settings.distance

	if type(broadphase_radius) == "table" then
		local lerp_value = DamageProfile.lerp_value_from_path(lerp_values, "distance")
		broadphase_radius = DamageProfile.lerp_damage_profile_entry(broadphase_radius, lerp_value)
	end

	local suppression_value = suppression_settings.suppression_value or DEFAULT_SUPPRESSION_VALUE

	if type(suppression_value) == "table" then
		local lerp_value = DamageProfile.lerp_value_from_path(lerp_values, "suppression_value")
		suppression_value = DamageProfile.lerp_damage_profile_entry(suppression_value, lerp_value)
	end

	local afro_radius = 2
	local apply_suppression_falloff = suppression_settings.suppression_falloff
	local num_results = broadphase:query(from_position, broadphase_radius, BROADPHASE_RESULTS, target_side_names, PLAYER_BREED_TYPE)

	for i = 1, num_results do
		local hit_unit = BROADPHASE_RESULTS[i]

		if hit_unit ~= attacking_unit or optional_include_self then
			local hit_unit_position = POSITION_LOOKUP[hit_unit]
			local suppression_amount = suppression_value

			if apply_suppression_falloff then
				local distance_from_source = Vector3.distance(from_position, hit_unit_position)
				suppression_amount = _apply_suppression_falloff(suppression_value, broadphase_radius, from_position, hit_unit_position, distance_from_source)
			end

			local afro_hit_position = math.closest_point_on_sphere(hit_unit_position, afro_radius, from_position)

			_apply_suppression_player(hit_unit, suppression_amount, stagger_category, afro_hit_position)
		end
	end
end

Suppression.add_immediate_suppression = function (t, suppression_movement_template, suppression_component, suppression_index)
	local immediate_sway = suppression_movement_template.immediate_sway
	local immediate_spread = suppression_movement_template.immediate_spread

	if immediate_sway then
		local sway_index = math.min(suppression_index, #immediate_sway)
		local sway_settings = immediate_sway[sway_index]
		suppression_component.sway_pitch = sway_settings.pitch
		suppression_component.sway_yaw = sway_settings.yaw
	end

	if immediate_spread then
		local spread_index = math.min(suppression_index, #immediate_spread)
		local spread_settings = immediate_spread[spread_index]
		suppression_component.spread_pitch = spread_settings.pitch
		suppression_component.spread_yaw = spread_settings.yaw
	end

	suppression_component.time = t
	suppression_component.decay_time = suppression_movement_template.decay_time
end

Suppression.apply_suppression_offsets_to_sway = function (suppression_component, pitch, yaw)
	local suppression_pitch = suppression_component.sway_pitch
	local suppression_yaw = suppression_component.sway_yaw
	local decay_time = suppression_component.decay_time
	local suppression_t = suppression_component.time
	local t = Managers.time:time("gameplay")

	if t < suppression_t + decay_time then
		local decay_amount = (suppression_t + decay_time - t) / decay_time
		suppression_pitch = suppression_pitch * decay_amount
		suppression_yaw = suppression_yaw * decay_amount
		pitch = pitch + suppression_pitch
		yaw = yaw + suppression_yaw
	end

	return pitch, yaw
end

Suppression.apply_suppression_offsets_to_spread = function (suppression_component, pitch, yaw)
	local suppression_pitch = suppression_component.spread_pitch
	local suppression_yaw = suppression_component.spread_yaw
	local decay_time = suppression_component.decay_time
	local suppression_t = suppression_component.time
	local t = Managers.time:time("gameplay")

	if t < suppression_t + decay_time then
		local decay_amount = (suppression_t + decay_time - t) / decay_time
		suppression_pitch = suppression_pitch * decay_amount
		suppression_yaw = suppression_yaw * decay_amount
		pitch = pitch + suppression_pitch
		yaw = yaw + suppression_yaw
	end

	return pitch, yaw
end

Suppression.is_suppressed = function (unit)
	local suppression_extension = ScriptUnit.has_extension(unit, "suppression_system")

	if suppression_extension and suppression_extension.is_suppressed then
		return suppression_extension:is_suppressed()
	end

	return false
end

Suppression.clear_suppression = function (unit)
	local suppression_extension = ScriptUnit.has_extension(unit, "suppression_system")

	if suppression_extension and suppression_extension.clear_suppression then
		suppression_extension:clear_suppression()
	end
end

function _get_breed(unit)
	if not HEALTH_ALIVE[unit] then
		return
	end

	local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

	return unit_data_extension and unit_data_extension:breed()
end

function _apply_suppression_player(unit, suppression_value, stagger_category, hit_position)
	local is_valid_category = stagger_category == "ranged" or stagger_category == "explosion"

	if is_valid_category then
		local suppression_extension = ScriptUnit.extension(unit, "suppression_system")

		suppression_extension:add_suppression(suppression_value, hit_position)
	end
end

function _apply_suppression_minion(suppressed_unit, suppression_value, suppression_type, suppression_attack_delay, attacking_unit, from_position, optional_instant_aggro)
	local suppression_extension = ScriptUnit.has_extension(suppressed_unit, "suppression_system")

	if suppression_extension then
		local direction = Vector3.normalize(from_position - POSITION_LOOKUP[suppressed_unit])

		suppression_extension:add_suppress_value(suppression_value, suppression_type, suppression_attack_delay, direction, attacking_unit)

		local attacking_unit_data_extension = ScriptUnit.has_extension(attacking_unit, "unit_data_system")
		local attacker_breed_or_nil = attacking_unit_data_extension and attacking_unit_data_extension:breed()

		if attacker_breed_or_nil then
			local attacker_is_player = Breed.is_player(attacker_breed_or_nil)

			if attacker_is_player then
				local combat_vector_system = Managers.state.extension:system("combat_vector_system")

				combat_vector_system:add_main_aggro_target_score("suppression", attacking_unit, suppressed_unit)
			end
		end
	end

	local side_system = Managers.state.extension:system("side_system")
	local is_enemy = side_system:is_enemy(attacking_unit, suppressed_unit)

	if is_enemy then
		local perception_extension = ScriptUnit.extension(suppressed_unit, "perception_system")

		if optional_instant_aggro then
			MinionPerception.attempt_aggro(perception_extension, attacking_unit)
		else
			MinionPerception.attempt_alert(perception_extension, attacking_unit)
		end

		local target_position = Unit.world_position(attacking_unit, Unit.node(attacking_unit, "enemy_aim_target_03"))

		perception_extension:set_last_los_position(attacking_unit, target_position)
	end
end

function _apply_suppression_falloff(suppression_value, distance, from_position, to_position, distance_from_source)
	local distance_sq = distance * distance
	local distance_from_source_sq = distance_from_source * distance_from_source
	local inverse_radius = math.clamp(1 - distance_from_source_sq / distance_sq, 0, 1)
	local inverse_radius_sq = inverse_radius * inverse_radius
	local suppression_amount = inverse_radius_sq * suppression_value

	return suppression_amount
end

return Suppression
