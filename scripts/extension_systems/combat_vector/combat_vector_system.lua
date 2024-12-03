-- chunkname: @scripts/extension_systems/combat_vector/combat_vector_system.lua

require("scripts/extension_systems/combat_vector/combat_vector_user_extension")

local AttackIntensity = require("scripts/utilities/attack_intensity")
local CombatVectorSettings = require("scripts/settings/combat_vector/combat_vector_settings")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local Navigation = require("scripts/extension_systems/navigation/utilities/navigation")
local NavQueries = require("scripts/utilities/nav_queries")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local SpawnPointQueries = require("scripts/managers/main_path/utilities/spawn_point_queries")
local CombatVectorSystem = class("CombatVectorSystem", "ExtensionSystemBase")
local _calculate_flank_positions, _calculate_flank_vectors, _calculate_from_position, _calculate_main_aggro_unit, _calculate_nav_mesh_locations, _calculate_segment, _calculate_to_position, _clear_data, _generate_combat_vector, _get_segment_range_identifier
local LEFT_SEGMENT_INDEX = 1
local MID_SEGMENT_INDEX = 2
local RIGHT_SEGMENT_INDEX = 3
local VECTOR_TYPES = {
	"main",
	"left_flank",
	"right_flank",
}

CombatVectorSystem.init = function (self, ...)
	CombatVectorSystem.super.init(self, ...)

	local is_server = self._is_server

	if is_server then
		local nav_world = self._nav_world
		local astar = GwNavAStar.create(nav_world)

		self._astar_data = {
			astar_finished = true,
			astar_timer = 0,
			astar = astar,
		}
		self._current_from_position = Vector3Box()
		self._current_to_position = Vector3Box()
		self._combat_vector = Vector3Box()
		self._last_known_positions = {}

		local location_types = CombatVectorSettings.location_types
		local max_segments = CombatVectorSettings.max_segments
		local segments, nav_mesh_locations, claimed_location_counters = {}, {}, {}

		for i = 1, #VECTOR_TYPES do
			local vector_type = VECTOR_TYPES[i]
			local vector_segments = Script.new_array(max_segments)

			vector_segments[1] = Vector3Box()

			for j = 2, max_segments do
				vector_segments[j] = {
					Vector3Box(),
					Vector3Box(),
					Vector3Box(),
				}
			end

			segments[vector_type] = vector_segments

			local location_counters = {}
			local locations = {}

			for j = 1, #location_types do
				local location_type = location_types[j]

				locations[location_type] = {
					close = {},
					far = {},
				}
				location_counters[location_type] = 0
			end

			claimed_location_counters[vector_type] = location_counters
			nav_mesh_locations[vector_type] = locations
		end

		self._segments = segments
		self._nav_mesh_locations = nav_mesh_locations
		self._claimed_location_counters = claimed_location_counters

		local segment_count = {}

		for i = 1, #VECTOR_TYPES do
			local vector_type = VECTOR_TYPES[i]

			segment_count[vector_type] = 0
		end

		self._segment_count = segment_count
		self._aggro_unit_scores = {}
		self._locked_in_melee_cooldown = 0
		self._locked_in_melee_unit = nil
		self._flank_positions = {}

		local left_flank_astar = GwNavAStar.create(nav_world)
		local right_flank_astar = GwNavAStar.create(nav_world)

		self._flank_astar_data = {
			left_flank = {
				finished = true,
				astar = left_flank_astar,
			},
			right_flank = {
				finished = true,
				astar = right_flank_astar,
			},
		}
		self._next_update_at = 0
		self._current_update_unit = nil
		self._current_update_extension = nil
		self._unit_extension_data = {}
	end
end

local NAV_TAG_LAYER_COSTS = {
	cover_ledges = 10,
	cover_vaults = 10,
	doors = 10,
	jumps = 10,
	ledges = 10,
	ledges_with_fence = 10,
	monster_walls = 0,
	teleporters = 100,
}
local FORBIDDEN_NAV_TAG_VOLUME_TYPES = {
	"content/volume_types/nav_tag_volumes/minion_no_destination",
}

CombatVectorSystem.on_gameplay_post_init = function (self, level)
	if not self._is_server then
		return
	end

	local traverse_logic, nav_tag_cost_table = Navigation.create_traverse_logic(self._nav_world, NAV_TAG_LAYER_COSTS, nil, false)

	self._traverse_logic, self._nav_tag_cost_table = traverse_logic, nav_tag_cost_table

	local nav_mesh_manager = Managers.state.nav_mesh

	for i = 1, #FORBIDDEN_NAV_TAG_VOLUME_TYPES do
		local volume_type = FORBIDDEN_NAV_TAG_VOLUME_TYPES[i]
		local layer_ids = nav_mesh_manager:nav_tag_volume_layer_ids_by_volume_type(volume_type)

		for j = 1, #layer_ids do
			GwNavTagLayerCostTable.forbid_layer(nav_tag_cost_table, layer_ids[j])
		end
	end
end

CombatVectorSystem.destroy = function (self, ...)
	if self._nav_tag_cost_table then
		GwNavTagLayerCostTable.destroy(self._nav_tag_cost_table)
	end

	if self._traverse_logic then
		GwNavTraverseLogic.destroy(self._traverse_logic)
	end

	local astar_data = self._astar_data

	if astar_data and astar_data.astar then
		GwNavAStar.destroy(astar_data.astar)
	end

	local flank_astar_data = self._flank_astar_data

	if flank_astar_data then
		for _, data in pairs(flank_astar_data) do
			GwNavAStar.destroy(data.astar)
		end
	end

	CombatVectorSystem.super.destroy(self, ...)
end

CombatVectorSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = CombatVectorSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)

	if extension_name == "CombatVectorUserExtension" then
		self._unit_extension_data[unit] = extension

		local current_update_unit = self._current_update_unit
		local unit_extension_data = self._unit_extension_data

		if current_update_unit == unit then
			self._current_update_unit, self._current_update_extension = next(unit_extension_data, current_update_unit)
		end
	end

	return extension
end

CombatVectorSystem.on_remove_extension = function (self, unit, extension_name)
	if extension_name == "CombatVectorUserExtension" then
		local current_update_unit = self._current_update_unit
		local unit_extension_data = self._unit_extension_data

		if current_update_unit == unit then
			self._current_update_unit, self._current_update_extension = next(unit_extension_data, current_update_unit)
		end

		unit_extension_data[unit] = nil
	end

	CombatVectorSystem.super.on_remove_extension(self, unit, extension_name)
end

CombatVectorSystem.update = function (self, context, dt, t)
	if not self._is_server or not Managers.state.main_path:is_main_path_ready() then
		return
	end

	local changed = self:_update_combat_vector(dt, t)
	local nav_mesh_locations = self._nav_mesh_locations
	local claimed_location_counters = self._claimed_location_counters
	local flank_positions = self._flank_positions
	local combat_vector_position = self._current_to_position
	local unit_extension_data = self._unit_extension_data
	local current_update_unit = self._current_update_unit
	local current_update_extension = self._current_update_extension

	if current_update_unit then
		current_update_extension:update(current_update_unit, context, dt, t, nav_mesh_locations, claimed_location_counters, changed, flank_positions, combat_vector_position)
	end

	current_update_unit, current_update_extension = next(unit_extension_data, current_update_unit)
	self._current_update_unit = current_update_unit
	self._current_update_extension = current_update_extension
end

CombatVectorSystem._reset = function (self)
	local nav_mesh_locations = self._nav_mesh_locations

	for _, locations in pairs(nav_mesh_locations) do
		for _, range_locations in pairs(locations) do
			table.clear(range_locations)
		end
	end

	local claimed_location_counters = self._claimed_location_counters

	for range, counter in pairs(claimed_location_counters) do
		claimed_location_counters[range] = 0
	end
end

CombatVectorSystem._update_combat_vector = function (self, dt, t)
	local nav_world = self._nav_world
	local aggro_unit_scores, current_aggro_unit = self._aggro_unit_scores, self._main_aggro_unit

	self._main_aggro_unit = _calculate_main_aggro_unit(nav_world, dt, aggro_unit_scores, current_aggro_unit, CombatVectorSettings.aggro_decay_speed)

	local traverse_logic = self._traverse_logic
	local astar_data = self._astar_data
	local astar = astar_data.astar
	local changed = false

	if astar then
		local done = GwNavAStar.processing_finished(astar)

		if done and not astar_data.astar_finished then
			local path_found = GwNavAStar.path_found(astar)

			if path_found then
				local node_count = GwNavAStar.node_count(astar)
				local vector_type = CombatVectorSettings.main_vector_type
				local nav_mesh_locations = self._nav_mesh_locations[vector_type]
				local num_nav_mesh_location_types = #CombatVectorSettings.location_types
				local segments = self._segments[vector_type]

				_clear_data(nav_mesh_locations, self._claimed_location_counters[vector_type])

				local num_locations_per_segment_meter = CombatVectorSettings.num_locations_per_segment_meter
				local width = CombatVectorSettings.width
				local segment_count = _generate_combat_vector(nav_world, traverse_logic, astar, segments, node_count, nav_mesh_locations, num_nav_mesh_location_types, num_locations_per_segment_meter, width)

				self._segment_count.main = segment_count
				changed = true
			end

			astar_data.astar_finished = true
		end
	end

	self:_check_for_locked_in_melee_unit(t)

	if t > astar_data.astar_timer and astar_data.astar_finished then
		local new_astar = astar_data.astar or GwNavAStar.create(nav_world)
		local total_challenge_rating = Managers.state.pacing:total_challenge_rating()
		local from_position

		if total_challenge_rating <= 0 then
			local main_path_manager = Managers.state.main_path
			local target_side_id = CombatVectorSettings.target_side_id
			local _, _, ahead_position = main_path_manager:ahead_unit(target_side_id)

			from_position = ahead_position
		else
			from_position = _calculate_from_position(nav_world, traverse_logic, self._locked_in_melee_unit or self._main_aggro_unit, self._last_known_positions)
		end

		local astar_frequency = CombatVectorSettings.astar_frequency

		if not from_position then
			astar_data.astar_timer = t + astar_frequency

			return changed
		end

		local to_position, num_aggroed = _calculate_to_position(from_position, nav_world, traverse_logic)

		if to_position then
			local from_position_distance_sq = Vector3.distance_squared(from_position, self._current_from_position:unbox())
			local to_position_distance_sq = Vector3.distance_squared(to_position, self._current_to_position:unbox())
			local from_update_distance_sq = CombatVectorSettings.from_update_distance_sq
			local to_update_distance_sq = CombatVectorSettings.to_update_distance_sq

			if t > self._next_update_at and (from_update_distance_sq <= from_position_distance_sq or to_update_distance_sq <= to_position_distance_sq) then
				GwNavAStar.start(new_astar, nav_world, from_position, to_position, traverse_logic)

				astar_data.astar = new_astar
				astar_data.astar_finished = false

				self._current_from_position:store(from_position)

				local update_frequency = CombatVectorSettings.combat_vector_update_frequency

				self._next_update_at = t + update_frequency
			end
		end

		self._num_aggroed_combat_vector_minions = num_aggroed
		astar_data.astar_timer = t + astar_frequency
	end

	local current_segment_count = self._segment_count.main

	if changed and current_segment_count > 1 then
		local vector_type = CombatVectorSettings.main_vector_type
		local segments = self._segments[vector_type]
		local first_segment_position = segments[1]:unbox()
		local last_segment_position = segments[current_segment_count][2]:unbox()
		local combat_vector = Vector3.flat(last_segment_position - first_segment_position)

		self._combat_vector:store(combat_vector)
		self._current_to_position:store(last_segment_position)
		_calculate_flank_positions(self._current_from_position:unbox(), combat_vector, self._flank_positions, nav_world, traverse_logic)
	end

	local nav_mesh_locations = self._nav_mesh_locations
	local claimed_location_counters = self._claimed_location_counters
	local flank_vectors_calculated = _calculate_flank_vectors(t, changed, self._current_from_position:unbox(), self._flank_positions, self._flank_astar_data, self._segments, nav_mesh_locations, claimed_location_counters, self._segment_count, nav_world, traverse_logic)

	return flank_vectors_calculated
end

CombatVectorSystem.get_combat_direction = function (self)
	local combat_vector_normalized = Vector3.normalize(self._combat_vector:unbox())

	return combat_vector_normalized
end

CombatVectorSystem.get_from_position = function (self)
	return self._current_from_position:unbox()
end

CombatVectorSystem.get_to_position = function (self, vector_type)
	local vector_types = CombatVectorSettings.vector_types

	if vector_type and (vector_type == vector_types.left_flank or vector_type == vector_types.right_flank) then
		local flank_position = self._flank_positions[vector_type]

		if flank_position then
			return flank_position:unbox()
		else
			return self._current_to_position:unbox()
		end
	else
		return self._current_to_position:unbox()
	end
end

CombatVectorSystem.add_main_aggro_target_score = function (self, type, aggro_unit, victim_unit)
	local aggro_unit_scores = self._aggro_unit_scores
	local event_types = CombatVectorSettings.main_aggro_target_event_types
	local score = 0
	local victim_breed = ScriptUnit.extension(victim_unit, "unit_data_system"):breed()

	if type == event_types.killed_unit then
		score = victim_breed.challenge_rating / 4
	elseif type == event_types.suppression then
		score = victim_breed.challenge_rating / 2
	end

	local current_score = aggro_unit_scores[aggro_unit]
	local max_score = CombatVectorSettings.max_main_aggro_score

	if not current_score then
		aggro_unit_scores[aggro_unit] = math.min(score, max_score)
	else
		aggro_unit_scores[aggro_unit] = math.min(current_score + score, max_score)
	end
end

CombatVectorSystem._check_for_locked_in_melee_unit = function (self, t)
	if not HEALTH_ALIVE[self._locked_in_melee_unit] then
		self._locked_in_melee_unit = nil
		self._locked_in_melee_cooldown = 0
	end

	local locked_in_melee_cooldown = self._locked_in_melee_cooldown

	if t < locked_in_melee_cooldown then
		return
	end

	local side_system = Managers.state.extension:system("side_system")
	local target_side_id = CombatVectorSettings.target_side_id
	local side = side_system:get_side(target_side_id)
	local valid_player_units = side.valid_player_units

	for i = 1, #valid_player_units do
		local player_unit = valid_player_units[i]
		local locked_in_melee = AttackIntensity.player_is_locked_in_melee(player_unit)

		if locked_in_melee then
			local to_position = self._current_to_position:unbox()
			local unit_position = POSITION_LOOKUP[player_unit]
			local distance = Vector3.distance(to_position, unit_position)

			if distance < CombatVectorSettings.locked_in_melee_range then
				self._locked_in_melee_cooldown = t + CombatVectorSettings.locked_in_melee_cooldown
				self._locked_in_melee_unit = player_unit

				return
			end
		end
	end

	self._locked_in_melee_unit = nil
end

CombatVectorSystem.get_main_aggro_unit = function (self)
	return self._main_aggro_unit
end

CombatVectorSystem.get_main_aggro_scores = function (self)
	return self._aggro_unit_scores
end

CombatVectorSystem.get_flank_positions = function (self)
	return self._flank_positions
end

CombatVectorSystem.get_flank_direction = function (self, vector_type)
	local flank_position = self._flank_positions[vector_type]

	if flank_position then
		local from_position = self._current_from_position:unbox()
		local direction = Vector3.normalize(flank_position:unbox() - from_position)

		return direction
	end
end

CombatVectorSystem.allow_nav_tag_layer = function (self, layer_name, layer_allowed)
	local layer_id = Managers.state.nav_mesh:nav_tag_layer_id(layer_name)
	local nav_tag_cost_table = self._nav_tag_cost_table

	if layer_allowed then
		GwNavTagLayerCostTable.allow_layer(nav_tag_cost_table, layer_id)
	else
		GwNavTagLayerCostTable.forbid_layer(nav_tag_cost_table, layer_id)
	end
end

CombatVectorSystem.is_traverse_logic_initialized = function (self)
	return self._traverse_logic ~= nil
end

CombatVectorSystem.set_last_known_position = function (self, unit, position)
	if not self._last_known_positions[unit] then
		self._last_known_positions[unit] = Vector3Box(position)
	else
		self._last_known_positions[unit]:store(position)
	end
end

CombatVectorSystem.num_aggroed_combat_vector_minions = function (self)
	return self._num_aggroed_combat_vector_minions
end

local ABOVE, BELOW, LATERAL, DISTANCE_FROM_OBSTACLE = 4, 4, 4, 0.1

function _generate_combat_vector(nav_world, traverse_logic, astar, segments, node_count, nav_mesh_locations, num_nav_mesh_location_types, num_locations_per_segment_meter, width)
	local GwNavAStar_node_at_index, Vector3_length, Vector3_normalize = GwNavAStar.node_at_index, Vector3.length, Vector3.normalize
	local segment_count = 1
	local node_index = 1
	local max_segments = CombatVectorSettings.max_segments
	local prev_node
	local min_segment_length = CombatVectorSettings.min_segment_length

	while segment_count < max_segments and node_index <= node_count do
		local node = GwNavAStar_node_at_index(astar, node_index)

		if node_index > 1 then
			local to_prev_node = prev_node - node
			local to_prev_node_length = Vector3_length(to_prev_node)
			local num_segments_between_nodes = math.floor(to_prev_node_length / min_segment_length)
			local prev_node_direction = Vector3_normalize(to_prev_node)

			for i = num_segments_between_nodes, 1, -1 do
				if segment_count == max_segments then
					break
				end

				local percentage = i / num_segments_between_nodes
				local length = to_prev_node_length * percentage
				local segment_position = node + prev_node_direction * length

				segment_count = segment_count + 1

				_calculate_segment(nav_world, traverse_logic, segments, segment_position, prev_node_direction, segment_count, width)
			end
		else
			segments[node_index]:store(node)
		end

		node_index = node_index + 1
		prev_node = node
	end

	local nav_mesh_location_start_index = CombatVectorSettings.nav_mesh_location_start_index

	if nav_mesh_location_start_index < segment_count then
		_calculate_nav_mesh_locations(nav_world, traverse_logic, segments, segment_count, nav_mesh_locations, num_nav_mesh_location_types, num_locations_per_segment_meter)
	end

	return segment_count
end

local LOCATION_ABOVE, LOCATION_BELOW = 1, 1

function _calculate_nav_mesh_locations(nav_world, traverse_logic, segments, segment_count, nav_mesh_locations, num_nav_mesh_location_types, num_locations_per_segment_meter)
	local Vector3_distance, two_pi = Vector3.distance, math.two_pi
	local min_nav_mesh_location_radius = CombatVectorSettings.min_nav_mesh_location_radius
	local nav_mesh_location_start_index = CombatVectorSettings.nav_mesh_location_start_index
	local num_segments_with_locations = segment_count - nav_mesh_location_start_index + 1
	local one_third_num_segments_with_locations = math.ceil(num_segments_with_locations / 3)

	for i = nav_mesh_location_start_index, segment_count do
		local segment = segments[i]
		local pos_on_nav_mesh_left = segment[LEFT_SEGMENT_INDEX]:unbox()
		local pos_on_nav_mesh_mid = segment[MID_SEGMENT_INDEX]:unbox()
		local pos_on_nav_mesh_right = segment[RIGHT_SEGMENT_INDEX]:unbox()
		local segment_width = Vector3_distance(pos_on_nav_mesh_left, pos_on_nav_mesh_right)
		local lane_width = segment_width / num_nav_mesh_location_types

		if min_nav_mesh_location_radius <= lane_width then
			local half_lane_width = lane_width * 0.5
			local quarter_lane_width = half_lane_width * 0.5
			local location_segment_index = i - nav_mesh_location_start_index + 1
			local range_identifier = _get_segment_range_identifier(location_segment_index, one_third_num_segments_with_locations)
			local num_positions = math.ceil(segment_width * num_locations_per_segment_meter / num_nav_mesh_location_types)
			local radians_per_nav_mesh_location = two_pi / num_positions
			local left_to_mid_direction = Vector3.normalize(pos_on_nav_mesh_mid - pos_on_nav_mesh_left)
			local right_to_mid_direction = Vector3.normalize(pos_on_nav_mesh_mid - pos_on_nav_mesh_right)
			local left_to_mid_offset = half_lane_width * left_to_mid_direction
			local right_to_mid_offset = half_lane_width * right_to_mid_direction

			for location_type, locations in pairs(nav_mesh_locations) do
				local range_nav_mesh_locations = locations[range_identifier]
				local current_radians = -(radians_per_nav_mesh_location / 2)
				local location_origin

				if location_type == "right" then
					location_origin = pos_on_nav_mesh_right + right_to_mid_offset
				elseif location_type == "left" then
					location_origin = pos_on_nav_mesh_left + left_to_mid_offset
				else
					location_origin = pos_on_nav_mesh_mid
				end

				for j = 1, num_positions do
					current_radians = current_radians + radians_per_nav_mesh_location

					local dir = Vector3(math.sin(current_radians), math.cos(current_radians), 0)
					local distance = math.random_range(quarter_lane_width, half_lane_width)
					local pos = location_origin + dir * distance
					local pos_on_nav_mesh = NavQueries.position_on_mesh(nav_world, pos, LOCATION_ABOVE, LOCATION_BELOW, traverse_logic)

					if pos_on_nav_mesh then
						range_nav_mesh_locations[#range_nav_mesh_locations + 1] = {
							claimed = false,
							position = Vector3Box(pos_on_nav_mesh),
							location_type = location_type,
						}
					end
				end
			end
		end
	end
end

function _get_segment_range_identifier(location_segment_index, one_third_num_segments_with_locations)
	local range_identifier
	local range_types = CombatVectorSettings.range_types

	if one_third_num_segments_with_locations <= location_segment_index then
		range_identifier = range_types.far
	else
		range_identifier = range_types.close
	end

	return range_identifier
end

function _calculate_segment(nav_world, traverse_logic, segments, segment_position, direction, index, width)
	local right = Vector3.cross(direction, Vector3.up())
	local left = -right
	local close_width = width / 4
	local ray_destination_1 = segment_position + right * close_width
	local ray_destination_2 = segment_position + left * close_width
	local _, hit_position1 = GwNavQueries.raycast(nav_world, segment_position, ray_destination_1, traverse_logic)
	local _, hit_position2 = GwNavQueries.raycast(nav_world, segment_position, ray_destination_2, traverse_logic)
	local mid_position = (hit_position1 + hit_position2) / 2

	segments[index][LEFT_SEGMENT_INDEX]:store(hit_position1)
	segments[index][MID_SEGMENT_INDEX]:store(mid_position)
	segments[index][RIGHT_SEGMENT_INDEX]:store(hit_position2)
end

function _calculate_from_position(nav_world, traverse_logic, main_aggro_unit, last_known_positions)
	if not ALIVE[main_aggro_unit] then
		return
	end

	local from_unit = main_aggro_unit
	local from_position = last_known_positions[from_unit] and last_known_positions[from_unit]:unbox() or POSITION_LOOKUP[from_unit]
	local from_position_on_nav_mesh = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, from_position, ABOVE, BELOW, LATERAL, DISTANCE_FROM_OBSTACLE)

	return from_position_on_nav_mesh
end

function _calculate_to_position(from_position, nav_world, traverse_logic)
	local side_system = Managers.state.extension:system("side_system")
	local target_side_id = CombatVectorSettings.target_side_id
	local target_side = side_system:get_side(target_side_id)
	local alive_minions = target_side:alive_units_by_tag("enemy", "minion")
	local Vector3_distance_squared = Vector3.distance_squared
	local min_distance_sq = CombatVectorSettings.min_distance_sq
	local max_distance_sq = CombatVectorSettings.max_distance_sq
	local average_position = Vector3(0, 0, 0)
	local num_alive_minions = alive_minions.size
	local num_aggroed = 0
	local total_minions = 0

	for i = 1, num_alive_minions do
		local unit = alive_minions[i]
		local blackboard = BLACKBOARDS[unit]
		local perception_component = blackboard.perception

		if perception_component.aggro_state == "aggroed" then
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local breed = unit_data_extension:breed()
			local tags = breed.tags

			if breed.combat_range_data and not tags.melee then
				local behavior_component = blackboard.behavior
				local combat_range = behavior_component.combat_range
				local is_in_melee = combat_range == "melee" and perception_component.target_distance <= CombatVectorSettings.melee_minion_range

				if not is_in_melee then
					local unit_position = POSITION_LOOKUP[unit]
					local distance_sq = Vector3_distance_squared(from_position, unit_position)

					if min_distance_sq < distance_sq and distance_sq < max_distance_sq then
						average_position = average_position + unit_position
						num_aggroed = num_aggroed + 1
					end

					total_minions = total_minions + 1
				end
			end
		end
	end

	local to_position

	if num_aggroed > 0 then
		average_position = average_position / num_aggroed
		to_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, average_position, ABOVE, BELOW, LATERAL, DISTANCE_FROM_OBSTACLE)
	end

	if not to_position then
		local _, wanted_distance = MainPathQueries.closest_position(from_position)
		local main_path_distance = CombatVectorSettings.main_path_distance
		local wanted_position = MainPathQueries.position_from_distance(wanted_distance + main_path_distance)

		if wanted_position then
			local altitude = GwNavQueries.triangle_from_position(nav_world, wanted_position, 1, 1)

			if altitude then
				to_position = Vector3(wanted_position[1], wanted_position[2], altitude)
			end
		end
	end

	return to_position, total_minions
end

function _calculate_main_aggro_unit(nav_world, dt, aggro_unit_scores, current_main_aggro_unit, decay_speed)
	local highest_score = 0
	local best_aggro_unit
	local ALIVE = ALIVE

	for aggro_unit, score in pairs(aggro_unit_scores) do
		score = math.max(score - dt * decay_speed, 0)
		aggro_unit_scores[aggro_unit] = score

		if not ALIVE[aggro_unit] or score == 0 then
			aggro_unit_scores[aggro_unit] = nil
		elseif highest_score < score then
			highest_score = score
			best_aggro_unit = aggro_unit
		end
	end

	if not best_aggro_unit then
		local target_side_id = CombatVectorSettings.target_side_id
		local main_path_manager = Managers.state.main_path

		best_aggro_unit = main_path_manager:ahead_unit(target_side_id)

		local unit_data_extension = ScriptUnit.has_extension(best_aggro_unit, "unit_data_system")
		local character_state_component = unit_data_extension and unit_data_extension:read_component("character_state")

		if character_state_component and PlayerUnitStatus.is_disabled(character_state_component) then
			local nav_spawn_points = main_path_manager:nav_spawn_points()
			local side_system = Managers.state.extension:system("side_system")
			local side = side_system:get_side(target_side_id)
			local valid_player_units = side.valid_player_units
			local num_valid_player_units = #valid_player_units
			local best_travel_distance = 0

			for i = 1, num_valid_player_units do
				repeat
					local player_unit = valid_player_units[i]

					if player_unit == best_aggro_unit then
						break
					end

					local player_character_state_component = ScriptUnit.extension(player_unit, "unit_data_system"):read_component("character_state")

					if PlayerUnitStatus.is_disabled(player_character_state_component) then
						break
					end

					local player_position = POSITION_LOOKUP[player_unit]
					local group_index = SpawnPointQueries.group_from_position(nav_world, nav_spawn_points, player_position)

					if not group_index then
						local latest_position_on_nav_mesh = ScriptUnit.extension(player_unit, "navigation_system"):latest_position_on_nav_mesh()

						if latest_position_on_nav_mesh then
							group_index = SpawnPointQueries.group_from_position(nav_world, nav_spawn_points, latest_position_on_nav_mesh)
						end
					end

					local start_index = main_path_manager:node_index_by_nav_group_index(group_index or 1)
					local end_index = start_index + 1
					local _, travel_distance = MainPathQueries.closest_position_between_nodes(player_position, start_index, end_index)

					if best_travel_distance < travel_distance then
						best_aggro_unit = player_unit
						best_travel_distance = travel_distance
					end
				until true
			end
		end
	elseif best_aggro_unit ~= current_main_aggro_unit then
		aggro_unit_scores[best_aggro_unit] = highest_score + CombatVectorSettings.main_aggro_target_stickyness
	end

	return best_aggro_unit or current_main_aggro_unit
end

local FLANK_POS_ABOVE, FLANK_POS_BELOW = 5, 5
local MAX_FLANK_FIND_POSITION_TRIES = 10
local FLANK_OFFSET = 5
local MIN_FLANK_LENGTH = 10

function _calculate_flank_positions(from_position, combat_vector, flank_positions, nav_world, traverse_logic)
	local combat_vector_length = Vector3.length(combat_vector)
	local right = Vector3.normalize(Vector3.cross(combat_vector, Vector3.up()))

	for i = 1, MAX_FLANK_FIND_POSITION_TRIES do
		local offset = FLANK_OFFSET * (i - 1)
		local length = math.max(combat_vector_length - offset, MIN_FLANK_LENGTH)
		local right_flank_pos = from_position + right * length
		local right_pos_on_nav_mesh = NavQueries.position_on_mesh(nav_world, right_flank_pos, FLANK_POS_ABOVE, FLANK_POS_BELOW, traverse_logic)

		if right_pos_on_nav_mesh then
			flank_positions.right_flank = Vector3Box(right_pos_on_nav_mesh)

			break
		elseif i == MAX_FLANK_FIND_POSITION_TRIES then
			flank_positions.right_flank = nil
		end
	end

	local left = -right

	for i = 1, MAX_FLANK_FIND_POSITION_TRIES do
		local offset = FLANK_OFFSET * (i - 1)
		local length = math.max(combat_vector_length - offset, MIN_FLANK_LENGTH)
		local left_flank_pos = from_position + left * length
		local left_pos_on_nav_mesh = NavQueries.position_on_mesh(nav_world, left_flank_pos, FLANK_POS_ABOVE, FLANK_POS_BELOW, traverse_logic)

		if left_pos_on_nav_mesh then
			flank_positions.left_flank = Vector3Box(left_pos_on_nav_mesh)

			break
		elseif i == MAX_FLANK_FIND_POSITION_TRIES then
			flank_positions.left_flank = nil
		end
	end
end

function _calculate_flank_vectors(t, changed, from_position, flank_positions, flank_astar_data, segments, flank_nav_mesh_locations, claimed_location_counters, segment_counts, nav_world, traverse_logic)
	local flank_vector_types = CombatVectorSettings.flank_vector_types
	local num_nav_mesh_location_types = #CombatVectorSettings.location_types
	local flank_vectors_calculated = false

	for i = 1, #flank_vector_types do
		local vector_type = flank_vector_types[i]
		local astar_data = flank_astar_data[vector_type]
		local flank_segments = segments[vector_type]
		local nav_mesh_locations = flank_nav_mesh_locations[vector_type]
		local claimed_counters = claimed_location_counters[vector_type]
		local astar = astar_data.astar
		local done = GwNavAStar.processing_finished(astar)

		if done and not astar_data.finished then
			local path_found = GwNavAStar.path_found(astar)

			if path_found then
				local node_count = GwNavAStar.node_count(astar)

				_clear_data(nav_mesh_locations, claimed_counters)

				local num_locations_per_segment_meter = CombatVectorSettings.num_flank_locations_per_segment_meter
				local width = CombatVectorSettings.flank_width
				local segment_count = _generate_combat_vector(nav_world, traverse_logic, astar, flank_segments, node_count, nav_mesh_locations, num_nav_mesh_location_types, num_locations_per_segment_meter, width)

				segment_counts[vector_type] = segment_count
			end

			astar_data.finished = true
			flank_vectors_calculated = true
		end

		if changed and astar_data.finished then
			local new_astar = astar_data.astar or GwNavAStar.create(nav_world)
			local to_position_boxed = flank_positions[vector_type]
			local to_position = to_position_boxed and to_position_boxed:unbox()

			if from_position and to_position then
				GwNavAStar.start(new_astar, nav_world, from_position, to_position, traverse_logic)

				astar_data.astar = new_astar
				astar_data.finished = false
			else
				flank_positions[vector_type] = nil
				segment_counts[vector_type] = 0

				_clear_data(nav_mesh_locations, claimed_counters)
			end
		end
	end

	return flank_vectors_calculated
end

function _clear_data(nav_mesh_locations, claimed_location_counters, segments)
	for _, locations in pairs(nav_mesh_locations) do
		for _, range_locations in pairs(locations) do
			table.clear(range_locations)
		end
	end
end

return CombatVectorSystem
