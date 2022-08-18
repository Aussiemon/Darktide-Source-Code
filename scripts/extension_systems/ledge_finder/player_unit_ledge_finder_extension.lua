local MaterialQuery = require("scripts/utilities/material_query")
local PlayerUnitLedgeFinderExtension = class("PlayerUnitLedgeFinderExtension")
local RING_BUFFER_SIZE = 32
local MAX_NUM_LEDGE_TRACKING = 5
local _ring_buffer_index = nil

PlayerUnitLedgeFinderExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	local ledge_finder_tweak_data = extension_init_data.ledge_finder_tweak_data
	self._ledge_finder_tweak_data = ledge_finder_tweak_data
	local physics_world = extension_init_context.physics_world
	self._physics_world = physics_world
	local unit_data = ScriptUnit.extension(unit, "unit_data_system")
	self._unit_data_extension = unit_data
	self._locomotion_component = unit_data:read_component("locomotion")
	self._first_person_component = unit_data:read_component("first_person")
	local fixed_frame = extension_init_context.fixed_frame
	self._fixed_frame = fixed_frame
	local ledge_collision_filter = "filter_player_mover"
	self._ledge_collision_filter = ledge_collision_filter
	self._raycast_object = PhysicsWorld.make_raycast(physics_world, "closest", "types", "statics", "collision_filter", ledge_collision_filter)
	local ledge_ring_buffer = Script.new_array(RING_BUFFER_SIZE)
	self._ledge_ring_buffer = ledge_ring_buffer

	for i = 1, RING_BUFFER_SIZE, 1 do
		local ledge_data = Script.new_array(MAX_NUM_LEDGE_TRACKING)

		for j = 1, MAX_NUM_LEDGE_TRACKING, 1 do
			ledge_data[j] = self:_new_ledge_data()
		end

		local ledges = {
			num_ledges = 0,
			ledge_data = ledge_data
		}
		ledge_ring_buffer[i] = ledges
	end
end

PlayerUnitLedgeFinderExtension._new_ledge_data = function (self)
	local ledge_data = {
		left = Vector3Box(),
		right = Vector3Box(),
		forward = Vector3Box(),
		distance_sq_from_player_unit = math.huge,
		distance_flat_sq_from_player_unit = math.huge,
		height_distance_from_player_unit = math.huge
	}

	return ledge_data
end

PlayerUnitLedgeFinderExtension.extensions_ready = function (self, world, unit)
	self._locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
end

PlayerUnitLedgeFinderExtension.ledges = function (self)
	local ledges = self._ledge_ring_buffer[_ring_buffer_index(self._fixed_frame)]

	return ledges.num_ledges, ledges.ledge_data
end

PlayerUnitLedgeFinderExtension.fixed_update = function (self, unit, dt, t, fixed_frame)
	self._fixed_frame = fixed_frame

	if self._unit_data_extension.is_resimulating then
		return
	end

	local ledges = self._ledge_ring_buffer[_ring_buffer_index(fixed_frame)]
	ledges.num_ledges = 0

	self:_try_find_ledges(ledges)
end

local temp_potential_left_ledge_points = {}
local temp_potential_right_ledge_points = {}
local temp_ledge_point_unit_map = {}
local PLAYER_RADIUS = 0.1

PlayerUnitLedgeFinderExtension._try_find_ledges = function (self, ledges)
	local position = self._locomotion_component.position
	local rotation = self._first_person_component.rotation
	local left_pos, right_pos = nil
	local right = Quaternion.right(rotation)
	local radius = self._locomotion_extension:mover_radius()
	left_pos = position - right * PLAYER_RADIUS
	right_pos = position + right * PLAYER_RADIUS
	local ray_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))

	table.clear(temp_potential_left_ledge_points)
	table.clear(temp_ledge_point_unit_map)

	if self:_find_potential_ledge_points(left_pos, ray_direction, temp_potential_left_ledge_points, temp_ledge_point_unit_map) then
		table.clear(temp_potential_right_ledge_points)

		if self:_find_potential_ledge_points(right_pos, ray_direction, temp_potential_right_ledge_points, temp_ledge_point_unit_map) then
			self:_pair_potential_ledge_points(ledges, temp_potential_left_ledge_points, temp_potential_right_ledge_points, temp_ledge_point_unit_map)
			self:_finalize_ledges(ledges, position)
		end
	end
end

local HEIGHT_LIMIT = 3
local NUM_RAYS = 10
local NUM_ENTRIES_PER_RAY = 3
local HIT = 1
local POSITION = 2
local DISTANCE = 3
local RAY_RESULTS_LIMIT = NUM_RAYS * NUM_ENTRIES_PER_RAY
local RAY_RESULTS = Script.new_array(RAY_RESULTS_LIMIT)
local RAY_LENGTH = 2
local HEIGHT_STEP = HEIGHT_LIMIT / NUM_RAYS
local ENOUGH_SPACE_TO_STAND = 0.5
local ENOUGH_SPACE_TO_FIT_PLAYER = 1.21

PlayerUnitLedgeFinderExtension._find_potential_ledge_points = function (self, origin, ray_direction, potential_ledge_points, ledge_point_unit_map)
	local up_vector = Vector3.up()
	local point_found = nil
	local raycast_object = self._raycast_object

	for ray_index = 1, NUM_RAYS, 1 do
		local ray_pos = origin + up_vector * HEIGHT_STEP * ray_index
		local hit, position, distance = Raycast.cast(raycast_object, ray_pos, ray_direction, RAY_LENGTH)
		local ray_result_index = (ray_index - 1) * NUM_ENTRIES_PER_RAY
		RAY_RESULTS[ray_result_index + HIT] = hit
		RAY_RESULTS[ray_result_index + POSITION] = position
		RAY_RESULTS[ray_result_index + DISTANCE] = distance
	end

	local down_vector = Vector3.down()
	local ledge_finder_tweak_data = self._ledge_finder_tweak_data
	local player_height = ledge_finder_tweak_data.player_height
	local player_width = ledge_finder_tweak_data.player_width

	for eval_ray_index = 1, NUM_RAYS, 1 do
		local eval_strided_array_i = (eval_ray_index - 1) * NUM_ENTRIES_PER_RAY
		local eval_hit = RAY_RESULTS[eval_strided_array_i + HIT]
		local eval_position = RAY_RESULTS[eval_strided_array_i + POSITION]
		local eval_distance = RAY_RESULTS[eval_strided_array_i + DISTANCE]
		local potential_ledge_point = false

		if eval_hit then
			for comp_ray_index = eval_ray_index + 1, NUM_RAYS, 1 do
				local comp_strided_array_i = (comp_ray_index - 1) * NUM_ENTRIES_PER_RAY
				local comp_hit = RAY_RESULTS[comp_strided_array_i + HIT]
				local comp_distance = RAY_RESULTS[comp_strided_array_i + DISTANCE]
				local enough_space_to_fit_width_above = not comp_hit or player_width < comp_distance - eval_distance

				if not enough_space_to_fit_width_above then
					potential_ledge_point = false

					break
				end

				local num_comparisons = comp_ray_index - eval_ray_index
				local enough_space_to_fit_height_above = player_height < HEIGHT_STEP * num_comparisons

				if enough_space_to_fit_height_above then
					potential_ledge_point = true

					break
				end
			end
		end

		if potential_ledge_point then
			local real_ledge_length = HEIGHT_STEP + HEIGHT_STEP * 0.1
			local real_ledge_ray_pos = eval_position + up_vector * HEIGHT_STEP
			real_ledge_ray_pos = real_ledge_ray_pos + ray_direction * 0.01
			local hit, real_pos, hit_distance, _, hit_actor = Raycast.cast(raycast_object, real_ledge_ray_pos, down_vector, real_ledge_length)

			if hit then
				potential_ledge_points[#potential_ledge_points + 1] = real_pos
				point_found = true
				local unit = Actor.unit(hit_actor)
				ledge_point_unit_map[real_pos] = unit
			end
		end
	end

	return point_found
end

local PERPENDICULAR_RAD = math.pi * 0.5
local HALF_WIGGLE_ROOM_RAD = math.pi * 0.08
local RAD_UPPER = PERPENDICULAR_RAD + HALF_WIGGLE_ROOM_RAD
local RAD_LOWER = PERPENDICULAR_RAD - HALF_WIGGLE_ROOM_RAD

PlayerUnitLedgeFinderExtension._pair_potential_ledge_points = function (self, ledges, potential_left_ledge_points, potential_right_ledge_points, ledge_point_unit_map)
	local up = Vector3.up()
	local down = -up
	local ledge_data = ledges.ledge_data
	local num_left_ledge_points = #potential_left_ledge_points

	for i = 1, num_left_ledge_points, 1 do
		local eval_point = potential_left_ledge_points[i]
		local best_find_j, best_find_point = nil
		local best_find_rad = math.huge
		local num_potential_right_ledge_points = #potential_right_ledge_points

		for j = 1, num_potential_right_ledge_points, 1 do
			local comp_point = potential_right_ledge_points[j]
			local dir = Vector3.normalize(eval_point - comp_point)
			local dot = math.clamp(Vector3.dot(dir, up), -1, 1)
			local angle_rad = math.acos(dot)
			local within_allowed_angle = angle_rad <= RAD_UPPER and RAD_LOWER <= angle_rad

			if within_allowed_angle and angle_rad < best_find_rad then
				best_find_j = j
				best_find_point = comp_point
				best_find_rad = angle_rad
			end
		end

		if best_find_j then
			local ledge_index = ledges.num_ledges + 1
			ledges.num_ledges = ledge_index
			local data = ledge_data[ledge_index]

			data.left:store(eval_point)
			data.right:store(best_find_point)

			local right_unit = ledge_point_unit_map[best_find_point]
			local left_unit = ledge_point_unit_map[eval_point]
			local material_unit = right_unit or left_unit

			if material_unit then
				local impact_position = (material_unit == right_unit and best_find_point) or eval_point
				data.material_or_nil = MaterialQuery.query_unit_material(material_unit, impact_position, down)
			else
				data.material_or_nil = nil
			end

			table.remove(potential_right_ledge_points, best_find_j)
		end
	end
end

PlayerUnitLedgeFinderExtension._finalize_ledges = function (self, ledges, player_position)
	local num_ledges = ledges.num_ledges
	local ledge_data = ledges.ledge_data
	local player_position_flat = Vector3.flat(player_position)
	local up = Vector3.up()

	for i = 1, num_ledges, 1 do
		local data = ledge_data[i]
		local left = data.left:unbox()
		local right = data.right:unbox()
		local ledge_dir = Vector3.normalize(left - right)
		local forward = Vector3.cross(ledge_dir, up)

		data.forward:store(forward)

		local mid_point = Vector3.lerp(left, right, 0.5)
		local distance_sq = Vector3.distance_squared(player_position, mid_point)
		data.distance_sq_from_player_unit = distance_sq
		local mid_point_flat = Vector3.flat(mid_point)
		local distance_flat_sq = Vector3.distance_squared(player_position_flat, mid_point_flat)
		data.distance_flat_sq_from_player_unit = distance_flat_sq
		local height_distance = math.abs(mid_point.z - player_position.z)
		data.height_distance_from_player_unit = height_distance
	end
end

function _ring_buffer_index(fixed_frame)
	return fixed_frame % RING_BUFFER_SIZE + 1
end

return PlayerUnitLedgeFinderExtension
