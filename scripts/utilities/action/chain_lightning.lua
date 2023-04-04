local ChainLightning = {}
local math_abs = math.abs
local Unit_node = Unit.node
local Unit_world_position = Unit.world_position
local Vector3_angle = Vector3.angle
local Vector3_direction_length = Vector3.direction_length
local Vector3_flat = Vector3.flat
local Vector3_length_squared = Vector3.length_squared
local Vector3_normalize = Vector3.normalize
local BROADPHASE_RESULTS = {}
local EPSILON_SQUARED = 0.010000000000000002
local CLOSE_EPSILON_SQUARED = 6.25
local LINE_OF_SIGHT_FILTER = "filter_chain_lightning_line_of_sight"
local LINE_OF_SIGHT_NODE = "enemy_aim_target_02"
local DEFAULT_MAX_TARGETS = 1
local _is_in_cover, _has_line_of_sight, _check_line_of_sight = nil

ChainLightning.calculate_max_targets = function (max_targets_settings, depth, use_random)
	local max_targets = max_targets_settings

	if not max_targets_settings then
		return DEFAULT_MAX_TARGETS
	end

	if type(max_targets) == "table" then
		max_targets = max_targets[depth] or 0
	end

	if type(max_targets) == "table" then
		local min = max_targets[1]
		local max = max_targets[2]
		max_targets = use_random and math.random(min, max) or max
	end

	return max_targets
end

ChainLightning.jump = function (self, t, source_target, hit_units, broadphase, enemy_side_names, initial_travel_direction, radius, max_angle, close_max_angle, max_z_diff, on_add_func, jump_validation_func)
	local source_unit = source_target:value("unit")
	local query_position = POSITION_LOOKUP[source_unit]
	local depth = source_target:depth()
	local travel_direction = nil

	if depth == 1 then
		travel_direction = initial_travel_direction
	else
		local parent_target = source_target:parent()
		local previous_unit = parent_target:value("unit")
		local previous_position = POSITION_LOOKUP[previous_unit]
		travel_direction = Vector3_normalize(Vector3_flat(previous_position - query_position))
	end

	table.clear(BROADPHASE_RESULTS)

	local num_results = broadphase:query(query_position, radius, BROADPHASE_RESULTS, enemy_side_names)

	if num_results > 0 then
		for ii = 1, num_results do
			local target_unit = BROADPHASE_RESULTS[ii]

			if target_unit and not hit_units[target_unit] and HEALTH_ALIVE[target_unit] then
				local valid_target, debug_reason = ChainLightning.is_valid_target(self._physics_world, source_unit, target_unit, query_position, travel_direction, max_angle, close_max_angle, max_z_diff, jump_validation_func)

				if valid_target then
					local child_node = source_target:add_child("unit", target_unit)

					on_add_func(self, t, source_target, child_node)

					hit_units[target_unit] = true

					if source_target:is_full() then
						return
					end
				end
			end
		end
	end
end

ChainLightning.is_valid_target = function (physics_world, source_unit, target_unit, query_position, travel_direction, max_angle, close_max_angle, max_z_diff, jump_validation_func)
	local valid_target = HEALTH_ALIVE[target_unit] and (not jump_validation_func or jump_validation_func(target_unit))

	if valid_target then
		local target_position = POSITION_LOOKUP[target_unit]
		local x = query_position.x - target_position.x
		local y = query_position.y - target_position.y
		local too_close = x * x + y * y < EPSILON_SQUARED

		if not too_close then
			local to_target_vector = query_position - target_position
			local direction = Vector3_normalize(Vector3_flat(to_target_vector))
			local angle = Vector3_angle(travel_direction, direction)
			local z_diff = math_abs(target_position.z - query_position.z)

			if angle <= max_angle and z_diff <= max_z_diff then
				valid_target = _is_in_cover(target_unit)

				if not valid_target and _has_line_of_sight(physics_world, source_unit, target_unit) then
					valid_target = true
				end

				return valid_target
			end
		end
	end

	return false
end

local DEFAULT_MAX_ANGLE = math.pi * 0.1
local DEFAULT_MAX_Z_DIFF = 2
local DEFAULT_MAX_JUMPS = 3
local DEFAULT_RADIUS = 4
local DEFAULT_JUMP_TIME = 0.15

ChainLightning.targeting_parameters = function (chain_settings, stat_buffs)
	local stat_buff_max_angle = stat_buffs and stat_buffs.chain_lightning_max_angle or 0
	local stat_buff_max_z_diff = stat_buffs and stat_buffs.chain_lightning_max_z_diff or 0
	local stat_buff_max_jumps = stat_buffs and stat_buffs.chain_lightning_max_jumps or 0
	local stat_buff_max_radius = stat_buffs and stat_buffs.chain_lightning_max_radius or 0
	local max_angle = chain_settings and chain_settings.max_angle or DEFAULT_MAX_ANGLE
	local close_max_angle = chain_settings and chain_settings.close_max_angle or max_angle
	max_angle = max_angle + stat_buff_max_angle
	close_max_angle = close_max_angle + stat_buff_max_angle
	local max_z_diff = (chain_settings and chain_settings.max_z_diff or DEFAULT_MAX_Z_DIFF) + stat_buff_max_z_diff
	local max_jumps = (chain_settings and chain_settings.max_jumps or DEFAULT_MAX_JUMPS) + stat_buff_max_jumps
	local radius = (chain_settings and chain_settings.radius or DEFAULT_RADIUS) + stat_buff_max_radius
	local jump_time = chain_settings and chain_settings.jump_time or DEFAULT_JUMP_TIME

	return max_angle, close_max_angle, max_z_diff, max_jumps, radius, jump_time
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
