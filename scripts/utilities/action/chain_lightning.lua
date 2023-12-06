local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local ChainLightning = {}
local math_abs = math.abs
local Unit_node = Unit.node
local Unit_world_position = Unit.world_position
local Vector3_angle = Vector3.angle
local Vector3_direction_length = Vector3.direction_length
local Vector3_flat = Vector3.flat
local Vector3_length_squared = Vector3.length_squared
local Vector3_normalize = Vector3.normalize
local ATTACK_TYPES = AttackSettings.attack_types
local BUFF_KEYWORDS = BuffSettings.keywords
local BROADPHASE_RESULTS = {}
local EPSILON_SQUARED = 0.010000000000000002
local CLOSE_EPSILON_SQUARED = 6.25
local LINE_OF_SIGHT_FILTER = "filter_chain_lightning_line_of_sight"
local LINE_OF_SIGHT_NODE = "enemy_aim_target_02"
local DEFAULT_MAX_TARGETS = 1
ChainLightning.breadth_first_validation_functions = {
	node_available_within_depth_and_target_alive = function (t, node, max_jumps)
		if not HEALTH_ALIVE[node:value("unit")] then
			return false
		end

		node:recalculate_max_num_children(t, node:value("start_t") or 0)

		if node:is_full() then
			return false
		end

		local depth = node:depth()
		local outside_depth = max_jumps < depth
		outside_depth = outside_depth or depth <= 0

		if outside_depth then
			return false
		end

		return true
	end,
	node_available_within_depth = function (t, node, max_jumps)
		node:recalculate_max_num_children(t, node:value("start_t") or 0)

		if node:is_full() then
			return false
		end

		local depth = node:depth()
		local outside_depth = max_jumps < depth
		outside_depth = outside_depth or depth <= 0

		if outside_depth then
			return false
		end

		return true
	end
}
ChainLightning.depth_first_validation_functions = {
	node_target_alive_and_not_self = function (t, node, player_unit)
		local target_unit = node:value("unit")

		if target_unit == player_unit then
			return false
		end

		if not HEALTH_ALIVE[target_unit] then
			return false
		end

		local depth = node:depth()

		if depth <= 0 then
			return false
		end

		return true
	end,
	node_target_not_alive = function (t, node, player_unit)
		if HEALTH_ALIVE[node:value("unit")] then
			return false
		end

		local depth = node:depth()

		if depth <= 0 then
			return false
		end

		return true
	end,
	node_target_not_electrocuted_or_not_alive = function (t, node, player_unit)
		local target_unit = node:value("unit")

		if HEALTH_ALIVE[target_unit] then
			return false
		end

		local depth = node:depth()

		if depth <= 0 then
			return false
		end

		local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")
		local is_electrocuted = buff_extension and buff_extension:has_keyword(BUFF_KEYWORDS.electrocuted)

		if is_electrocuted then
			return false
		end

		return true
	end
}
ChainLightning.jump_validation_functions = {
	target_alive_and_electrocuted = function (target_unit)
		local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")
		local valid_target = buff_extension and buff_extension:has_keyword(BUFF_KEYWORDS.electrocuted)

		return valid_target
	end
}
local _is_in_cover, _has_line_of_sight, _check_line_of_sight = nil

ChainLightning.jump = function (t, physics_world, source_node, hit_units, broadphase, enemy_side_names, initial_travel_direction, radius, max_angle, close_max_angle, vertical_max_angle, max_z_diff, on_add_func, add_func_context, jump_validation_func)
	local source_unit = source_node:value("unit")
	local query_position = POSITION_LOOKUP[source_unit]
	local depth = source_node:depth()
	local travel_direction = nil

	if depth > 1 then
		local current_node = source_node

		repeat
			local parent_node = current_node:parent()

			if not parent_node then
				break
			end

			local parent_unit = parent_node:value("unit")
			local parent_position = POSITION_LOOKUP[parent_unit]
			local x = parent_position.x - query_position.x
			local y = parent_position.y - query_position.y
			local too_close = x * x + y * y < EPSILON_SQUARED

			if not too_close then
				travel_direction = Vector3_normalize(Vector3_flat(parent_position - query_position))
			else
				current_node = parent_node
			end
		until travel_direction ~= nil or parent_node:depth() <= 1
	end

	travel_direction = travel_direction or initial_travel_direction

	table.clear(BROADPHASE_RESULTS)

	local num_results = broadphase:query(query_position, radius, BROADPHASE_RESULTS, enemy_side_names)

	for i = 1, num_results do
		local target_unit = BROADPHASE_RESULTS[i]

		if not hit_units[target_unit] and HEALTH_ALIVE[target_unit] then
			local valid_target, debug_reason = ChainLightning.is_valid_target(physics_world, source_unit, target_unit, query_position, travel_direction, max_angle, close_max_angle, vertical_max_angle, max_z_diff, jump_validation_func)

			if valid_target then
				source_node:add_child(on_add_func, add_func_context, "unit", target_unit, "start_t", t)

				if source_node:is_full() then
					return
				end
			end
		end
	end
end

ChainLightning.is_valid_target = function (physics_world, source_unit, target_unit, query_position, travel_direction, max_angle, close_max_angle, max_vertical_angle, max_z_diff, jump_validation_func, min_distance)
	if not HEALTH_ALIVE[target_unit] then
		return false, "health"
	end

	if source_unit == target_unit then
		return false, "same_unit"
	end

	local valid_target = not jump_validation_func or jump_validation_func(target_unit)

	if not valid_target then
		return false, "validation"
	end

	local target_position = POSITION_LOOKUP[target_unit]
	local z_diff = math_abs(target_position.z - query_position.z)

	if max_z_diff and max_z_diff < z_diff then
		return false, "z_diff"
	end

	local x = query_position.x - target_position.x
	local y = query_position.y - target_position.y

	if x * x + y * y < EPSILON_SQUARED then
		return false, "too_close"
	end

	local to_target_vector = query_position - target_position

	if min_distance and Vector3.length_squared(to_target_vector) < min_distance * min_distance then
		return false, "min_distance"
	end

	local direction = Vector3_normalize(to_target_vector)
	local flat_direction = Vector3_normalize(Vector3_flat(to_target_vector))
	local flat_angle = Vector3_angle(travel_direction, flat_direction)
	local vertical_angle = Vector3_angle(direction, flat_direction)
	local distance_squared = Vector3_length_squared(to_target_vector)
	local lerp_t = math.clamp01(distance_squared / CLOSE_EPSILON_SQUARED)
	local angle_limit = close_max_angle == max_angle and max_angle or math.lerp(close_max_angle, max_angle, lerp_t)

	if angle_limit < flat_angle then
		return false, "max_angle"
	end

	if max_vertical_angle and max_vertical_angle < vertical_angle then
		return false, "max_angle"
	end

	if not _is_in_cover(target_unit) and not _has_line_of_sight(physics_world, source_unit, target_unit) then
		return false, "line_of_sight"
	end

	return true
end

ChainLightning.max_targets = function (time_in_action, chain_settings, depth, use_random)
	if not chain_settings then
		return DEFAULT_MAX_TARGETS
	end

	local max_target_settings = nil
	local max_targets_at_time = chain_settings.max_targets_at_time
	local max_targets_at_depth = chain_settings.max_targets_at_depth

	if max_targets_at_time then
		for ii = #max_targets_at_time, 1, -1 do
			local entry = max_targets_at_time[ii]

			if entry.t <= time_in_action then
				max_target_settings = entry

				break
			end
		end
	elseif max_targets_at_depth then
		max_target_settings = max_targets_at_depth[depth + 1]
	else
		max_target_settings = chain_settings.max_targets
	end

	if not max_target_settings then
		return DEFAULT_MAX_TARGETS
	end

	local num_targets = max_target_settings.num_targets
	local min = max_target_settings.num_targets_min
	local max = max_target_settings.num_targets_max
	local max_targets = use_random and min and max and math.random(min, max) or num_targets

	if not max_targets then
		return DEFAULT_MAX_TARGETS
	end

	return max_targets
end

local DEFAULT_MAX_ANGLE = math.pi * 0.1
local DEFAULT_VERTICAL_MAX_ANGLE = math.pi * 0.33
local DEFAULT_MAX_Z_DIFF = 5
local DEFAULT_MAX_JUMPS = 3
local DEFAULT_RADIUS = 4
local DEFAULT_JUMP_TIME = 0.15

ChainLightning.targeting_parameters = function (time_in_action, chain_settings, stat_buffs)
	local is_staff = chain_settings and chain_settings.staff
	local stat_buff_max_angle = not is_staff and stat_buffs and stat_buffs.chain_lightning_max_angle or 0
	local stat_buff_max_z_diff = not is_staff and stat_buffs and stat_buffs.chain_lightning_max_z_diff or 0
	local stat_buff_max_radius = not is_staff and stat_buffs and stat_buffs.chain_lightning_max_radius or 0
	local stat_buff_jump_time = not is_staff and stat_buffs and stat_buffs.chain_lightning_jump_time_multiplier or 1
	local stat_buff_max_jumps = not is_staff and stat_buffs and stat_buffs.chain_lightning_max_jumps or stat_buffs and is_staff and stat_buffs.chain_lightning_staff_max_jumps or 0
	local max_jumps = nil
	local max_jumps_at_time = chain_settings and chain_settings.max_jumps_at_time

	if max_jumps_at_time then
		for ii = #max_jumps_at_time, 1, -1 do
			local entry = max_jumps_at_time[ii]

			if entry.t <= time_in_action then
				max_jumps = entry.num_jumps

				break
			end
		end
	end

	max_jumps = (max_jumps or chain_settings and chain_settings.max_jumps or DEFAULT_MAX_JUMPS) + stat_buff_max_jumps
	local max_angle = chain_settings and chain_settings.max_angle or DEFAULT_MAX_ANGLE
	local close_max_angle = chain_settings and chain_settings.close_max_angle or max_angle
	max_angle = max_angle + stat_buff_max_angle
	close_max_angle = close_max_angle + stat_buff_max_angle
	local vertical_max_angle = DEFAULT_VERTICAL_MAX_ANGLE
	local max_z_diff = (chain_settings and chain_settings.max_z_diff or DEFAULT_MAX_Z_DIFF) + stat_buff_max_z_diff
	local radius = (chain_settings and chain_settings.radius or DEFAULT_RADIUS) + stat_buff_max_radius
	local jump_time = chain_settings and chain_settings.jump_time or DEFAULT_JUMP_TIME * stat_buff_jump_time
	local max_targets = chain_settings and chain_settings.max_targets

	return max_angle, close_max_angle, vertical_max_angle, max_z_diff, max_jumps, radius, jump_time, max_targets
end

ChainLightning.execute_attack = function (target_unit, attacking_unit, power_level, charge_level, target_index, target_number, attack_direction_or_nil, damage_profile, damage_type, is_critical_strike)
	local hit_zone_name = "center_mass"
	local hit_zone_actors = HitZone.get_actor_names(target_unit, hit_zone_name)
	local num_hit_actor_names = #hit_zone_actors
	local hit_actor_name = hit_zone_actors[math.random(1, num_hit_actor_names)]
	local hit_actor = Unit.actor(target_unit, hit_actor_name)
	local node_index = hit_actor and Actor.node(hit_actor)
	local hit_world_position = node_index and Unit.world_position(target_unit, node_index)
	local damage_dealt, attack_result, damage_efficiency, stagger_result, hit_weakspot = Attack.execute(target_unit, damage_profile, "power_level", power_level, "charge_level", charge_level, "damage_type", damage_type, "attacking_unit", HEALTH_ALIVE[attacking_unit] and attacking_unit, "attack_direction", attack_direction_or_nil, "hit_actor", hit_actor, "hit_zone_name", hit_zone_name, "hit_world_position", hit_world_position, "target_index", target_index, "target_number", target_number, "attack_type", ATTACK_TYPES.ranged, "is_critical_strike", is_critical_strike)

	return damage_dealt, attack_result, damage_efficiency, stagger_result, hit_weakspot
end

function _is_in_cover(target_unit)
	local unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")

	if not unit_data_extension then
		return false
	end

	local breed = unit_data_extension:breed()
	local cover_config = breed and breed.cover_config

	if not cover_config then
		return false
	end

	local blackboard = BLACKBOARDS[target_unit]

	if not blackboard then
		return false
	end

	local is_in_cover = blackboard.cover.is_in_cover

	return is_in_cover
end

function _has_line_of_sight(physics_world, source_unit, target_unit)
	local source_node_index = Unit_node(source_unit, LINE_OF_SIGHT_NODE)
	local target_node_index = Unit_node(target_unit, LINE_OF_SIGHT_NODE)
	local source_los_pos = Unit_world_position(source_unit, source_node_index)
	local target_los_pos = Unit_world_position(target_unit, target_node_index)
	local direction, distance = Vector3_direction_length(target_los_pos - source_los_pos)

	if _check_line_of_sight(physics_world, source_los_pos, direction, distance) then
		return true
	end

	if _check_line_of_sight(physics_world, source_los_pos, direction, distance, "up") then
		return true
	end

	if _check_line_of_sight(physics_world, source_los_pos, direction, distance, "right") then
		return true
	end

	if _check_line_of_sight(physics_world, source_los_pos, direction, distance, "left") then
		return true
	end

	return false
end

function _check_line_of_sight(physics_world, source_los_pos, direction, distance, optional_offset)
	local from = source_los_pos

	if optional_offset == "up" then
		from = from + Vector3.up()
	else
		local right = Vector3.cross(direction, Vector3.up())

		if optional_offset == "right" then
			from = from + right * 0.5
		elseif optional_offset == "left" then
			from = from - right * 0.5
		end
	end

	local hit = PhysicsWorld.raycast(physics_world, from, direction, distance, "any", "collision_filter", LINE_OF_SIGHT_FILTER)

	return not hit
end

return ChainLightning
