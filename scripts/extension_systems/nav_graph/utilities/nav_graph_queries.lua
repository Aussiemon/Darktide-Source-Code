local SmartObject = require("scripts/extension_systems/nav_graph/utilities/smart_object")
local SmartObjectSettings = require("scripts/settings/navigation/smart_object_settings")
local NavGraphQueries = {}
local Script_temp_byte_count = Script.temp_byte_count
local Script_set_temp_byte_count = Script.set_temp_byte_count

local function _calculate_node_position_on_navmesh(nav_world, unit, node_index)
	local NAVMESH_ABOVE = 0.5
	local NAVMESH_BELOW = 0.5
	local NAVMESH_HORIZONTAL = 0.5
	local NAVMESH_DISTANCE_FROM_BORDER = 0.1
	local node_position = Unit.world_position(unit, node_index)
	local altitude = GwNavQueries.triangle_from_position(nav_world, node_position, NAVMESH_ABOVE, NAVMESH_BELOW)

	if altitude then
		node_position.z = altitude

		return node_position
	else
		local found_position = GwNavQueries.inside_position_from_outside_position(nav_world, node_position, NAVMESH_ABOVE, NAVMESH_BELOW, NAVMESH_HORIZONTAL, NAVMESH_DISTANCE_FROM_BORDER)

		if not found_position then
			return node_position
		end

		return found_position
	end
end

local function _create_smart_object_from_node_pair(nav_world, calculation_params, out_smart_objects, out_debug_draw_list)
	local node_pair = calculation_params.node_pair
	local unit = calculation_params.unit
	local entrance_position = _calculate_node_position_on_navmesh(nav_world, unit, node_pair[1])
	local exit_position = _calculate_node_position_on_navmesh(nav_world, unit, node_pair[2])
	local new_smart_object = SmartObject:new()

	new_smart_object:set_entrance_exit_positions(entrance_position, exit_position)
	new_smart_object:set_is_bidirectional(not calculation_params.is_one_way)
	new_smart_object:set_layer_type(calculation_params.layer_type)

	out_smart_objects[#out_smart_objects + 1] = new_smart_object

	return true
end

local function _create_smart_object_from_offset_node(calculation_params, out_smart_objects, out_debug_draw_list)
	local offset_node = calculation_params.offset_node
	local entrance_offset = calculation_params.entrance_offset
	local exit_offset = calculation_params.exit_offset
	local unit = calculation_params.unit
	local offset_node_position = Unit.world_position(unit, offset_node)
	local offset_node_rotation = Unit.world_rotation(unit, offset_node)
	local right = Quaternion.right(offset_node_rotation)
	local forward = Quaternion.forward(offset_node_rotation)
	local up = Quaternion.up(offset_node_rotation)
	local entrance_position = offset_node_position + right * entrance_offset.x + forward * entrance_offset.y + up * entrance_offset.z
	local exit_position = offset_node_position + right * exit_offset.x + forward * exit_offset.y + up * exit_offset.z
	local new_smart_object = SmartObject:new()

	new_smart_object:set_entrance_exit_positions(entrance_position, exit_position)
	new_smart_object:set_is_bidirectional(not calculation_params.is_one_way)
	new_smart_object:set_layer_type(calculation_params.layer_type)

	out_smart_objects[#out_smart_objects + 1] = new_smart_object

	return true
end

local function _extract_hit(hits)
	if hits then
		for i = 1, #hits do
			local hit = hits[i]

			if hit then
				local position, distance, normal, actor = nil

				if hit.position then
					actor = hit.actor
					normal = hit.normal
					distance = hit.distance
					position = hit.position
				else
					position, distance, normal, actor = unpack(hit)
				end

				local unit = Actor.unit(actor)

				if not unit or not Unit.get_data(unit, "disable_ledge_collision") then
					return true, position, distance, normal, actor
				end
			end
		end
	end

	return false
end

local function _calculate_ledge_type(physics_world, ledge_position, ledge_normal)
	local edge_detect_position1 = ledge_position + ledge_normal * 0.18 + Vector3.up()
	local edge_detect_distance = 1.3
	local hit1 = _extract_hit(PhysicsWorld.raycast(physics_world, edge_detect_position1, Vector3.down(), edge_detect_distance, "all", "collision_filter", "filter_ledge_test_simple"))
	local edge_detect_position2 = ledge_position - ledge_normal * 0.18 + Vector3.up()
	local hit2 = _extract_hit(PhysicsWorld.raycast(physics_world, edge_detect_position2, Vector3.down(), edge_detect_distance, "all", "collision_filter", "filter_ledge_test_simple"))
	local hit_sum = (hit1 and 1 or 0) + (hit2 and 1 or 0)
	local is_on_edge = hit_sum == 1
	local is_on_narrow_fence = hit_sum == 0

	if is_on_narrow_fence then
		local edge_detect_position_fence_start = ledge_position + Vector3.up()
		local edge_detect_position_fence_end = edge_detect_position_fence_start + Vector3.down() * 1.3
		local radius = 0.3
		local max_hits = 1
		local hit_fence = _extract_hit(PhysicsWorld.linear_sphere_sweep(physics_world, edge_detect_position_fence_start, edge_detect_position_fence_end, radius, max_hits, "collision_filter", "filter_ledge_test_simple", "report_initial_overlap"))

		if not hit_fence then
			is_on_narrow_fence = false
			is_on_edge = true
		end
	end

	local ledge_type = "thick_fence"

	if is_on_edge then
		ledge_type = "edge"
	elseif is_on_narrow_fence then
		ledge_type = "narrow_fence"
	end

	return ledge_type
end

local function _is_ledge_unobstructed(physics_world, ledge_position, ledge_normal, out_debug_draw_list)
	local check_position = ledge_position + ledge_normal + Vector3.up()
	local distance = 2
	local hit = _extract_hit(PhysicsWorld.raycast(physics_world, check_position, -ledge_normal, distance, "all", "collision_filter", "filter_ledge_test"))

	if hit then
		return false
	else
		return true
	end
end

local function _calculate_ground_positions(physics_world, ledge_normal, check_position1, check_position2)
	local distance = 13
	local hit1, position1, distance1 = _extract_hit(PhysicsWorld.raycast(physics_world, check_position1, Vector3.down(), distance, "all", "collision_filter", "filter_ledge_test_simple"))
	local hit2, position2, distance2 = _extract_hit(PhysicsWorld.raycast(physics_world, check_position2, Vector3.down(), distance, "all", "collision_filter", "filter_ledge_test_simple"))

	if hit1 and hit2 then
		return true, position1, distance1, position2, distance2
	end

	return false
end

local function _calculate_ledge_on_navmesh(nav_world, ledge_detect_position1, ledge_detect_position2, position1, position2, out_debug_draw_list)
	local NAVMESH_ABOVE = 0.4
	local NAVMESH_BELOW = 0.4
	local altitude1 = GwNavQueries.triangle_from_position(nav_world, position1, NAVMESH_ABOVE, NAVMESH_BELOW)

	if altitude1 then
		position1.z = altitude1
	end

	local altitude2 = GwNavQueries.triangle_from_position(nav_world, position2, NAVMESH_ABOVE, NAVMESH_BELOW)

	if altitude2 then
		position2.z = altitude2
	end

	if altitude1 and altitude2 then
		return true
	end

	return false
end

local function _calculate_thick_fence_edges(physics_world, ledge_position, ledge_normal, out_debug_draw_list)
	local wall_detect_position1 = ledge_position + ledge_normal + Vector3.down() * 0.2
	local hit_horizontal1, position1_horizontal, distance1_horizontal = _extract_hit(PhysicsWorld.raycast(physics_world, wall_detect_position1, -ledge_normal, 1, "all", "collision_filter", "filter_ledge_test"))
	local wall_detect_position2 = ledge_position - ledge_normal + Vector3.down() * 0.2
	local hit_horizontal2, position2_horizontal, distance2_horizontal = _extract_hit(PhysicsWorld.raycast(physics_world, wall_detect_position2, ledge_normal, 1, "all", "collision_filter", "filter_ledge_test"))

	if not hit_horizontal1 or not hit_horizontal2 or distance1_horizontal == 0 or distance2_horizontal == 0 then
		return false
	end

	local ledge_detect_position1 = position1_horizontal - ledge_normal * 0.01 + Vector3.up()
	hit_horizontal1, position1_horizontal = _extract_hit(PhysicsWorld.raycast(physics_world, ledge_detect_position1, Vector3.down(), 2, "all", "collision_filter", "filter_ledge_test"))
	local ledge_detect_position2 = position2_horizontal + ledge_normal * 0.01 + Vector3.up()
	hit_horizontal2, position2_horizontal = _extract_hit(PhysicsWorld.raycast(physics_world, ledge_detect_position2, Vector3.down(), 2, "all", "collision_filter", "filter_ledge_test"))

	if hit_horizontal1 and hit_horizontal2 then
		return true, position1_horizontal, position2_horizontal
	end

	return false
end

local function _calculate_ledge(physics_world, nav_world, calculation_params, ledge_type, out_smart_objects, out_debug_draw_list)
	local ledge_position = calculation_params.ledge_position
	local ledge_normal = calculation_params.ledge_normal
	local jump_up_max_height = calculation_params.jump_up_max_height
	local force_one_way_ledge = calculation_params.is_one_way
	local ledge_position1 = ledge_position
	local ledge_position2 = ledge_position

	if ledge_type == "thick_fence" then
		local success_thick_ledge = nil
		success_thick_ledge, ledge_position1, ledge_position2 = _calculate_thick_fence_edges(physics_world, ledge_position, ledge_normal, out_debug_draw_list)

		if not success_thick_ledge then
			return false
		end
	end

	local ledge_detect_position1 = ledge_position1 + ledge_normal + Vector3.up()
	local ledge_detect_position2 = ledge_position2 - ledge_normal + Vector3.up()
	local ground_success, position1, distance1, position2, distance2 = _calculate_ground_positions(physics_world, ledge_normal, ledge_detect_position1, ledge_detect_position2)

	if not ground_success then
		return false
	end

	if ledge_type == "narrow_fence" then
		local ground_is_below_fence = ledge_position.z < position1.z or ledge_position.z < position2.z

		if ground_is_below_fence then
			return false
		end
	elseif ledge_type == "thick_fence" then
		local ground_too_close = distance1 <= 1.5 or distance2 <= 1.5

		if ground_too_close then
			return false
		end
	elseif ledge_type == "edge" then
		local too_close_to_ground = math.abs(position1.z - position2.z) < 0.5

		if too_close_to_ground then
			return false
		end
	end

	local up_offset = 1
	local too_high_to_climb = jump_up_max_height < distance1 - up_offset
	too_high_to_climb = too_high_to_climb and jump_up_max_height < distance2 - up_offset

	if too_high_to_climb then
		return false
	end

	local position2_is_higher = position1.z < position2.z

	if position2_is_higher then
		position2 = position1
		position1 = position2
		ledge_detect_position2 = ledge_detect_position1
		ledge_detect_position1 = ledge_detect_position2
	end

	if not _calculate_ledge_on_navmesh(nav_world, ledge_detect_position1, ledge_detect_position2, position1, position2, out_debug_draw_list) then
		return false
	end

	local is_bidirectional = not force_one_way_ledge
	is_bidirectional = is_bidirectional and jump_up_max_height >= position1.z - position2.z
	local layer_type = calculation_params.layer_type

	if layer_type == "auto_detect" then
		layer_type = "ledges"
	end

	if layer_type == "ledges" and (ledge_type == "thick_fence" or ledge_type == "narrow_fence") then
		layer_type = "ledges_with_fence"
	end

	local new_smart_object = SmartObject:new()

	new_smart_object:set_layer_type(layer_type)
	new_smart_object:set_entrance_exit_positions(position1, position2)
	new_smart_object:set_is_bidirectional(is_bidirectional)
	new_smart_object:set_ledge(ledge_type, ledge_position, ledge_position1, ledge_position2)

	out_smart_objects[#out_smart_objects + 1] = new_smart_object

	return true
end

local function _create_climb_smart_object(nav_world, physics_world, calculation_params, out_smart_objects, out_debug_draw_list)
	local ledge_position = calculation_params.ledge_position
	local ledge_normal = calculation_params.ledge_normal

	if _is_ledge_unobstructed(physics_world, ledge_position, ledge_normal, out_debug_draw_list) then
		local ledge_type = _calculate_ledge_type(physics_world, ledge_position, ledge_normal)

		return _calculate_ledge(physics_world, nav_world, calculation_params, ledge_type, out_smart_objects, out_debug_draw_list)
	end

	return false
end

local function _calculate_jump_entrance(nav_world, physics_world, calculation_params)
	local NAVMESH_ABOVE = 0.3
	local NAVMESH_BELOW = 0.3
	local ledge_position = calculation_params.ledge_position
	local ledge_normal = calculation_params.ledge_normal
	local jump_start_position_check = ledge_position + ledge_normal + Vector3.up()
	local hit, jump_start_position = _extract_hit(PhysicsWorld.raycast(physics_world, jump_start_position_check, Vector3.down(), 1.3, "all", "collision_filter", "filter_ledge_test_simple"))

	if not hit then
		return nil
	end

	local is_position_on_navmesh = GwNavQueries.triangle_from_position(nav_world, jump_start_position, NAVMESH_ABOVE, NAVMESH_BELOW)

	if not is_position_on_navmesh then
		return nil
	end

	return jump_start_position, jump_start_position_check
end

local function _calculate_jump_exit(nav_world, physics_world, calculation_params, jump_start_position_check, out_debug_draw_list)
	local NAVMESH_ABOVE = 0.3
	local NAVMESH_BELOW = 0.3
	local ledge_normal = calculation_params.ledge_normal
	local jump_across_min_length = calculation_params.jump_across_min_length
	local jump_across_max_length = calculation_params.jump_across_max_length
	local end_index = (jump_across_max_length - jump_across_min_length) / 0.5

	for i = 0, end_index do
		local exit_check_distance = jump_across_min_length + 0.5 * i
		local hit_horizontal, horizontal_hit_pos = _extract_hit(PhysicsWorld.raycast(physics_world, jump_start_position_check, -ledge_normal, exit_check_distance, "all", "collision_filter", "filter_ledge_test"))

		if hit_horizontal then
			return nil
		end

		local jump_exit_check = jump_start_position_check - ledge_normal * exit_check_distance + Vector3.up()
		local hit, position, distance = _extract_hit(PhysicsWorld.raycast(physics_world, jump_exit_check, Vector3.down(), 3.1, "all", "collision_filter", "filter_ledge_test_simple"))

		if hit then
			if distance < 1 then
				local ledge_position = calculation_params.ledge_position

				return nil
			end

			local is_position_on_navmesh = GwNavQueries.triangle_from_position(nav_world, position, NAVMESH_ABOVE, NAVMESH_BELOW)

			if is_position_on_navmesh then
				return position
			end
		end
	end
end

local function _is_jump_midpoint_unobstructed(physics_world, jump_start_position, jump_end_position, out_debug_draw_list)
	local midpoint = Vector3.lerp(jump_start_position, jump_end_position, 0.5)
	local hit_up, position_up, distance_up = _extract_hit(PhysicsWorld.raycast(physics_world, midpoint + Vector3.down() * 0.1, Vector3.up(), 3, "all", "collision_filter", "filter_ledge_test"))

	if hit_up then
		return false
	end

	local hit_down, position_down, distance_down = _extract_hit(PhysicsWorld.raycast(physics_world, midpoint + Vector3.up() * 0.1, Vector3.down(), 1, "all", "collision_filter", "filter_ledge_test"))

	if hit_down then
		if distance_down > 0.3 then
			-- Nothing
		end

		return false
	end

	return true
end

local function _calculate_vault_ground_positions(physics_world, ledge_normal, ledge_position, check_position1, check_position2)
	local horizontal_distance = 1.3
	local hit1, position1 = _extract_hit(PhysicsWorld.raycast(physics_world, check_position1, Vector3.down(), horizontal_distance, "all", "collision_filter", "filter_ledge_test"))
	local hit2, position2 = _extract_hit(PhysicsWorld.raycast(physics_world, check_position2, Vector3.down(), horizontal_distance, "all", "collision_filter", "filter_ledge_test"))

	if not hit1 or not hit2 then
		return false
	end

	local half_up = Vector3.up() * 0.5
	local vertical_distance = 4
	local hit3 = _extract_hit(PhysicsWorld.raycast(physics_world, ledge_position + ledge_normal - half_up, ledge_normal, vertical_distance, "all", "collision_filter", "filter_ledge_test"))
	local hit4 = _extract_hit(PhysicsWorld.raycast(physics_world, ledge_position - ledge_normal - half_up, -ledge_normal, vertical_distance, "all", "collision_filter", "filter_ledge_test"))

	if hit3 or hit4 then
		return false
	end

	return true, position1, position2
end

local function _calculate_vault_on_navmesh(nav_world, ledge_detect_position1, ledge_detect_position2, position1, position2, out_debug_draw_list)
	local NAVMESH_ABOVE = 0.4
	local NAVMESH_BELOW = 0.4
	local altitude1 = GwNavQueries.triangle_from_position(nav_world, position1, NAVMESH_ABOVE, NAVMESH_BELOW)

	if altitude1 then
		position1.z = altitude1
	end

	local altitude2 = GwNavQueries.triangle_from_position(nav_world, position2, NAVMESH_ABOVE, NAVMESH_BELOW)

	if altitude2 then
		position2.z = altitude2
	end

	if altitude1 and altitude2 then
		return true
	end

	return false
end

local function _create_vault_smart_object(nav_world, physics_world, calculation_params, out_smart_objects, out_debug_draw_list)
	local ledge_position = calculation_params.ledge_position
	local ledge_normal = calculation_params.ledge_normal

	if not _is_ledge_unobstructed(physics_world, ledge_position, ledge_normal, out_debug_draw_list) then
		return false
	end

	local ledge_detect_position1 = ledge_position + ledge_normal * 5
	local ledge_detect_position2 = ledge_position - ledge_normal * 5
	local ground_success, entrance_position, exit_position = _calculate_vault_ground_positions(physics_world, ledge_normal, ledge_position, ledge_detect_position1, ledge_detect_position2)

	if not ground_success then
		return false
	end

	if not _calculate_vault_on_navmesh(nav_world, ledge_detect_position1, ledge_detect_position2, entrance_position, exit_position, out_debug_draw_list) then
		return false
	end

	local is_bidirectional = true
	local flat_jump_distance = Vector3.length(Vector3.flat(entrance_position - exit_position))
	local unit = calculation_params.unit
	local new_smart_object = SmartObject:new(unit)

	new_smart_object:set_layer_type("cover_vaults")
	new_smart_object:set_entrance_exit_positions(entrance_position, exit_position)
	new_smart_object:set_is_bidirectional(is_bidirectional)
	new_smart_object:set_jump_distance(flat_jump_distance)

	out_smart_objects[#out_smart_objects + 1] = new_smart_object

	return true
end

local function _create_jump_smart_object(nav_world, physics_world, calculation_params, out_smart_objects, out_debug_draw_list)
	local jump_start_position, jump_start_position_check = _calculate_jump_entrance(nav_world, physics_world, calculation_params)

	if jump_start_position == nil then
		return false
	end

	local jump_end_position = _calculate_jump_exit(nav_world, physics_world, calculation_params, jump_start_position_check, out_debug_draw_list)

	if jump_end_position == nil then
		return false
	end

	if GwNavQueries.raycango(nav_world, jump_start_position, jump_end_position) then
		return false
	end

	if not _is_jump_midpoint_unobstructed(physics_world, jump_start_position, jump_end_position, out_debug_draw_list) then
		return false
	end

	local layer_type = calculation_params.layer_type

	if layer_type == "auto_detect" then
		layer_type = "jumps"
	end

	local is_bidirectional = not calculation_params.is_one_way
	local jump_flat_distance = Vector3.length(Vector3.flat(jump_start_position - jump_end_position))
	local new_smart_object = SmartObject:new()

	new_smart_object:set_layer_type(layer_type)
	new_smart_object:set_entrance_exit_positions(jump_start_position, jump_end_position)
	new_smart_object:set_is_bidirectional(is_bidirectional)
	new_smart_object:set_jump_distance(jump_flat_distance)

	out_smart_objects[#out_smart_objects + 1] = new_smart_object

	return true
end

local LEDGE_MARGIN = 0.39
local WANTED_DISTANCE_BETWEEN_LEDGES = 1

local function _calculate_ledge_splits(position_a, position_b)
	local ledge_vector = position_a - position_b
	local ledge_vector_flat = Vector3.flat(ledge_vector)
	local ledge_length = Vector3.length(ledge_vector_flat)
	local ledge_length_with_margin = ledge_length - LEDGE_MARGIN * 2

	if ledge_length_with_margin > 0 then
		local num_splits = math.ceil(ledge_length_with_margin / WANTED_DISTANCE_BETWEEN_LEDGES)
		local split_distance_actual = ledge_length_with_margin / num_splits
		local ledge_direction_flat = Vector3.normalize(ledge_vector_flat)
		local ledge_normal = Vector3.cross(ledge_direction_flat, Vector3.up())
		local ledge_t_start = LEDGE_MARGIN / ledge_length
		local ledge_t_stride = split_distance_actual / ledge_length

		return num_splits, ledge_t_start, ledge_t_stride, ledge_normal
	end

	return 0, nil, nil, nil
end

local function _calculate_smart_objects_from_node_pair(nav_world, physics_world, calculation_params, out_smart_objects, out_debug_draw_list)
	if calculation_params.layer_type ~= "auto_detect" and calculation_params.layer_type ~= "cover_ledges" then
		Log.warning("NavGraphQueries", "[_calculate_smart_objects_from_node_pair] Layer type %q not supported for method %q.", calculation_params.layer_type, calculation_params.method)
	end

	local node_pair = calculation_params.node_pair
	local unit = calculation_params.unit
	local position_a = Unit.world_position(unit, node_pair[1])
	local position_b = Unit.world_position(unit, node_pair[2])
	local num_splits, ledge_t_start, ledge_t_stride, ledge_normal = _calculate_ledge_splits(position_a, position_b)

	if num_splits > 0 then
		calculation_params.ledge_normal = ledge_normal

		for i = 0, num_splits do
			local temp_byte_count = Script_temp_byte_count()
			local ledge_t = ledge_t_start + i * ledge_t_stride
			calculation_params.ledge_position = Vector3.lerp(position_a, position_b, ledge_t)

			_create_climb_smart_object(nav_world, physics_world, calculation_params, out_smart_objects, out_debug_draw_list)
			_create_jump_smart_object(nav_world, physics_world, calculation_params, out_smart_objects, out_debug_draw_list)
			Script_set_temp_byte_count(temp_byte_count)
		end
	end
end

local function _check_and_remove_nearby_ledge(out_smart_objects, exit_positions, calculation_params)
	local last_smart_object = out_smart_objects[#out_smart_objects]
	local entrance_position, exit_position = last_smart_object:get_entrance_exit_positions()
	local is_too_close_to_other_ledge = false
	local Vector3_distance = Vector3.distance
	local Vector3Box_unbox = Vector3Box.unbox

	for i = 1, #exit_positions do
		local distance = Vector3_distance(entrance_position, Vector3Box_unbox(exit_positions[i]))
		local max_distance_to_other_exit = calculation_params.cover_max_distance_to_other_exit

		if distance <= max_distance_to_other_exit then
			is_too_close_to_other_ledge = true

			break
		end
	end

	if is_too_close_to_other_ledge then
		table.remove(out_smart_objects, #out_smart_objects)
	else
		exit_positions[#exit_positions + 1] = Vector3Box(exit_position)
	end
end

local function _calculate_smart_objects_from_node_list(nav_world, physics_world, calculation_params, out_smart_objects, out_debug_draw_list)
	if calculation_params.layer_type ~= "auto_detect" and calculation_params.layer_type ~= "cover_ledges" then
		Log.warning("NavGraphQueries", "[_calculate_smart_objects_from_node_list] Layer type %q not supported for method %q.", calculation_params.layer_type, calculation_params.method)
	end

	local previous_control_point_node = nil
	local exit_positions = {}
	local Unit_world_position = Unit.world_position
	local up_vector = Vector3.up()
	local node_list = calculation_params.node_list

	for i = 1, #node_list do
		local control_point_node = node_list[i]
		local temp_byte_count = Script_temp_byte_count()

		if previous_control_point_node ~= nil then
			local unit = calculation_params.unit
			local control_point_position_a = Unit_world_position(unit, control_point_node)
			local control_point_position_b = Unit_world_position(unit, previous_control_point_node)
			local control_point_up_offset = calculation_params.cover_z_offset
			local position_a = control_point_position_a + up_vector * control_point_up_offset
			local position_b = control_point_position_b + up_vector * control_point_up_offset
			local num_splits, ledge_t_start, ledge_t_stride, ledge_normal = _calculate_ledge_splits(position_a, position_b)

			if num_splits > 0 then
				calculation_params.ledge_normal = ledge_normal

				for i = 0, num_splits do
					local ledge_t = ledge_t_start + i * ledge_t_stride
					local ledge_position = Vector3.lerp(position_a, position_b, ledge_t)
					calculation_params.ledge_position = ledge_position
					local success = _create_climb_smart_object(nav_world, physics_world, calculation_params, out_smart_objects, out_debug_draw_list)

					if success then
						_check_and_remove_nearby_ledge(out_smart_objects, exit_positions, calculation_params)
					end

					success = _create_vault_smart_object(nav_world, physics_world, calculation_params, out_smart_objects, out_debug_draw_list)

					if success then
						_check_and_remove_nearby_ledge(out_smart_objects, exit_positions, calculation_params)
					end
				end
			end
		end

		previous_control_point_node = control_point_node

		Script_set_temp_byte_count(temp_byte_count)
	end
end

local COVER_Z_OFFSETS = {
	high = 1.82,
	low = 1.22
}

local function _set_cover_calculation_parameters(unit, calculation_params)
	calculation_params.cover_z_offset = 0
	calculation_params.cover_max_distance_to_other_exit = 0

	if EDITOR or rawget(_G, "LevelEditor") then
		local component_manager = LevelEditor.component_manager
		local cover_components = component_manager:get_components_by_name(unit, "Cover")

		if #cover_components > 0 then
			local cover_type = cover_components[1]:get_data(unit, "cover_type")
			calculation_params.cover_z_offset = COVER_Z_OFFSETS[cover_type]
			calculation_params.cover_max_distance_to_other_exit = 0.4

			if calculation_params.layer_type == "auto_detect" then
				calculation_params.layer_type = "cover_ledges"
			end
		end
	else
		local cover_extension = ScriptUnit.has_extension(unit, "cover_system")

		if cover_extension then
			local cover_type = cover_extension:cover_type()
			calculation_params.cover_z_offset = COVER_Z_OFFSETS[cover_type]
			calculation_params.cover_max_distance_to_other_exit = 0.4

			if calculation_params.layer_type == "auto_detect" then
				calculation_params.layer_type = "cover_ledges"
			end
		end
	end
end

local function _set_doors_calculation_parameters(unit, calculation_params)
	if EDITOR or rawget(_G, "LevelEditor") then
		local component_manager = LevelEditor.component_manager
		local has_door_component = component_manager:has_component_by_name(unit, "Door")

		if has_door_component and calculation_params.layer_type == "auto_detect" then
			calculation_params.layer_type = "doors"
		end
	elseif ScriptUnit.has_extension(unit, "door_system") and calculation_params.layer_type == "auto_detect" then
		calculation_params.layer_type = "doors"
	end
end

local CALCULATION_PARAMS = {}

local function _get_smart_object_calculation_parameters(unit, component)
	table.clear(CALCULATION_PARAMS)

	local is_one_way = component:get_data(unit, "is_one_way")
	local layer_type = component:get_data(unit, "layer_type")
	CALCULATION_PARAMS.layer_type = layer_type
	local error = false
	local smart_object_calculation_method = component:get_data(unit, "smart_object_calculation_method")

	if smart_object_calculation_method == "use_node_pair" or smart_object_calculation_method == "calculate_from_node_pair" then
		local node_a_name = component:get_data(unit, "node_a_name")
		local node_b_name = component:get_data(unit, "node_b_name")

		if not Unit.has_node(unit, node_a_name) then
			Log.error("[NavGraphQueries]", "[_get_smart_object_calculation_parameters][Unit: %s] node(%s) not found.", Unit.id_string(unit), node_a_name)

			error = true
		end

		if not Unit.has_node(unit, node_b_name) then
			Log.error("[NavGraphQueries]", "[_get_smart_object_calculation_parameters][Unit: %s] node(%s) not found.", Unit.id_string(unit), node_b_name)

			error = true
		end

		if not error then
			CALCULATION_PARAMS.node_pair = {
				Unit.node(unit, node_a_name),
				Unit.node(unit, node_b_name)
			}
		end
	elseif smart_object_calculation_method == "use_offset_node" then
		local offset_node_name = component:get_data(unit, "offset_node_name")
		local entrance_offset_boxed = component:get_data(unit, "entrance_offset")
		local exit_offset_boxed = component:get_data(unit, "exit_offset")
		local entrance_offset = entrance_offset_boxed:unbox()
		local exit_offset = exit_offset_boxed:unbox()

		if not Unit.has_node(unit, offset_node_name) then
			Log.error("[NavGraphQueries]", "[_get_smart_object_calculation_parameters][Unit: %s] node(%s) not found.", Unit.id_string(unit), offset_node_name)

			error = true
		end

		if not error then
			CALCULATION_PARAMS.offset_node = Unit.node(unit, offset_node_name)
		end

		CALCULATION_PARAMS.entrance_offset = entrance_offset
		CALCULATION_PARAMS.exit_offset = exit_offset
	elseif smart_object_calculation_method == "calculate_from_node_list" then
		local node_list = component:get_data(unit, "node_list")
		local node_indices = {}
		local unit_has_node = Unit.has_node
		local unit_node = Unit.node

		for i = 1, #node_list do
			local control_point_name = node_list[i]
			local temp_byte_count = Script_temp_byte_count()

			if not unit_has_node(unit, control_point_name) then
				Log.error("NavGraphQueries", "[_get_smart_object_calculation_parameters][Unit: %s] node(%s) not found.", Unit.id_string(unit), control_point_name)

				error = true

				break
			end

			node_indices[#node_indices + 1] = unit_node(unit, control_point_name)

			Script_set_temp_byte_count(temp_byte_count)
		end

		CALCULATION_PARAMS.node_list = node_indices
	end

	_set_cover_calculation_parameters(unit, CALCULATION_PARAMS)
	_set_doors_calculation_parameters(unit, CALCULATION_PARAMS)

	CALCULATION_PARAMS.unit = unit
	CALCULATION_PARAMS.method = smart_object_calculation_method
	CALCULATION_PARAMS.is_one_way = is_one_way
	CALCULATION_PARAMS.ledge_position = Vector3.zero()
	CALCULATION_PARAMS.ledge_normal = Vector3.zero()
	CALCULATION_PARAMS.jump_up_max_height = SmartObjectSettings.jump_up_max_height
	CALCULATION_PARAMS.jump_across_min_length = SmartObjectSettings.jump_across_min_length
	CALCULATION_PARAMS.jump_across_max_length = SmartObjectSettings.jump_across_max_length

	return CALCULATION_PARAMS, error
end

local SMART_OBJECTS = {}
local DEBUG_DRAW_LIST = {}

NavGraphQueries.generate_smart_objects = function (unit, nav_world, physics_world, component)
	local calculation_params, error = _get_smart_object_calculation_parameters(unit, component)

	table.clear(SMART_OBJECTS)
	table.clear(DEBUG_DRAW_LIST)

	if error then
		Log.error("[NavGraphQueries]", "[generate_smart_objects][Unit: %s] Error parsing parameters. Cannot generate Smart Objects.", Unit.id_string(unit))
	else
		local method = calculation_params.method

		if method == "use_node_pair" then
			_create_smart_object_from_node_pair(nav_world, calculation_params, SMART_OBJECTS, DEBUG_DRAW_LIST)
		elseif method == "use_offset_node" then
			_create_smart_object_from_offset_node(calculation_params, SMART_OBJECTS, DEBUG_DRAW_LIST)
		elseif method == "calculate_from_node_pair" then
			_calculate_smart_objects_from_node_pair(nav_world, physics_world, calculation_params, SMART_OBJECTS, DEBUG_DRAW_LIST)
		elseif method == "calculate_from_node_list" then
			_calculate_smart_objects_from_node_list(nav_world, physics_world, calculation_params, SMART_OBJECTS, DEBUG_DRAW_LIST)
		end
	end

	return SMART_OBJECTS, DEBUG_DRAW_LIST
end

return NavGraphQueries
