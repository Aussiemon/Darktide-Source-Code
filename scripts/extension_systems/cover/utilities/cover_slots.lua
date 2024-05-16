-- chunkname: @scripts/extension_systems/cover/utilities/cover_slots.lua

local NavQueries = require("scripts/utilities/nav_queries")
local CoverSettings = require("scripts/settings/cover/cover_settings")
local CoverSlots = {}

CoverSlots.fetch_node_positions = function (unit)
	local node_positions = {}
	local node_index = 1

	while true do
		local node_name = "cp_0" .. node_index

		if Unit.has_node(unit, node_name) then
			local node = Unit.node(unit, node_name)
			local position = Unit.world_position(unit, node)

			node_positions[#node_positions + 1] = Vector3Box(position)
		else
			break
		end

		node_index = node_index + 1
	end

	return node_positions
end

CoverSlots.create = function (physics_world, nav_world, unit, cover_type, node_positions)
	local slot_width = CoverSettings.slot_width
	local half_slot_width = slot_width * 0.5
	local slot_navmesh_offset = CoverSettings.slot_navmesh_offset
	local slot_user_offset = CoverSettings.slot_user_offset
	local num_node_positions = #node_positions
	local cover_types = CoverSettings.types
	local cover_slots = {}
	local Script_temp_byte_count = Script.temp_byte_count
	local Script_set_temp_byte_count = Script.set_temp_byte_count

	for i = 1, num_node_positions do
		repeat
			local node_position = node_positions[i]:unbox()
			local next_node_index = i % num_node_positions + 1
			local next_node_position = node_positions[next_node_index]:unbox()
			local distance_to_node = Vector3.distance(node_position, next_node_position)
			local distance_to_node_rounded = math.round_with_precision(distance_to_node, 2)
			local temp_byte_count = Script_temp_byte_count()

			if slot_width <= distance_to_node_rounded then
				local num_fitting_slots = math.floor(distance_to_node_rounded / slot_width)

				if num_fitting_slots == 0 then
					break
				end

				local node_to_next_node_direction = Vector3.normalize(next_node_position - node_position)
				local left = -Vector3.cross(node_to_next_node_direction, Vector3.up())
				local navmesh_offset = left * slot_navmesh_offset
				local user_offset = left * slot_user_offset

				if num_fitting_slots == 1 then
					local mid_position = node_position + node_to_next_node_direction * (distance_to_node * 0.5)
					local navmesh_position = mid_position + navmesh_offset
					local position = mid_position + user_offset

					CoverSlots._add_slot(physics_world, unit, navmesh_position, position, left, cover_type, nav_world, cover_slots)
				elseif cover_type == cover_types.low then
					local slot_width_offset = distance_to_node / num_fitting_slots
					local start_position = node_position - node_to_next_node_direction * (slot_width_offset * 0.5)

					for j = 1, num_fitting_slots do
						local edge_position = start_position + node_to_next_node_direction * (j * slot_width_offset)
						local navmesh_position = edge_position + navmesh_offset
						local position = edge_position + user_offset

						CoverSlots._add_slot(physics_world, unit, navmesh_position, position, left, cover_type, nav_world, cover_slots)
					end
				elseif cover_type == cover_types.high then
					local start_position = node_position + node_to_next_node_direction * half_slot_width
					local position_1 = start_position + user_offset
					local navmesh_position_1 = start_position + navmesh_offset

					CoverSlots._add_slot(physics_world, unit, navmesh_position_1, position_1, left, cover_type, nav_world, cover_slots)

					local end_position = next_node_position - node_to_next_node_direction * half_slot_width
					local position_2 = end_position + user_offset
					local navmesh_position_2 = end_position + navmesh_offset

					CoverSlots._add_slot(physics_world, unit, navmesh_position_2, position_2, left, cover_type, nav_world, cover_slots)
				end
			end

			Script_set_temp_byte_count(temp_byte_count)
		until true
	end

	return cover_slots
end

local COVER_SLOT_ID = 0
local MIN_SLOT_TO_NAVMESH_DISTANCE = 1.5

CoverSlots._add_slot = function (physics_world, unit, navmesh_position, slot_position, left, cover_type, nav_world, cover_slots)
	local above, below, horizontal = 0.75, 0.75, CoverSettings.slot_navmesh_outside_search_distance
	local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, navmesh_position, above, below, horizontal)

	if position_on_navmesh then
		local boxed_navmesh_position = Vector3Box(position_on_navmesh)

		if Vector3.distance(position_on_navmesh, slot_position) > MIN_SLOT_TO_NAVMESH_DISTANCE then
			return
		end

		slot_position.z = boxed_navmesh_position.z

		local boxed_slot_position = Vector3Box(slot_position)

		COVER_SLOT_ID = COVER_SLOT_ID + 1

		local cover_slot = {
			navmesh_position = boxed_navmesh_position,
			position = boxed_slot_position,
			type = cover_type,
			normal = Vector3Box(left),
			direction = Vector3Box(-left),
			id = COVER_SLOT_ID,
		}
		local valid_cover_slot = CoverSlots._generate_slot_peek_types(physics_world, cover_slot, cover_type, position_on_navmesh)

		if valid_cover_slot then
			cover_slots[#cover_slots + 1] = cover_slot
		end
	end
end

CoverSlots._generate_slot_peek_types = function (physics_world, cover_slot, cover_type, position_on_navmesh)
	local position = cover_slot.position:unbox()
	local normal = cover_slot.normal:unbox()
	local right = Vector3.cross(-normal, Vector3.up())
	local z_offset = Vector3.up() * CoverSettings.peek_z_offsets[cover_type]
	local navmesh_los_check = CoverSlots._navmesh_los_check(physics_world, position, position_on_navmesh, z_offset)

	if not navmesh_los_check then
		return false
	end

	local offset_z_position = position + z_offset
	local los_from_position_right = offset_z_position + right
	local los_to_position_right = los_from_position_right - normal
	local has_los_to_right = CoverSlots._double_raycast_los_check(physics_world, offset_z_position, los_from_position_right, los_to_position_right)
	local los_from_position_left = offset_z_position - right
	local los_to_position_left = los_from_position_left - normal
	local has_los_to_left = CoverSlots._double_raycast_los_check(physics_world, offset_z_position, los_from_position_left, los_to_position_left)
	local peek_types = CoverSettings.peek_types

	if has_los_to_right and has_los_to_left then
		cover_slot.peek_type = peek_types.both
	elseif has_los_to_right then
		cover_slot.peek_type = peek_types.right
	elseif has_los_to_left then
		cover_slot.peek_type = peek_types.left
	elseif cover_type == "low" then
		cover_slot.peek_type = peek_types.blocked
	else
		return false
	end

	return true
end

CoverSlots._navmesh_los_check = function (physics_world, position, position_on_navmesh, z_offset)
	local slot_offset_check_position = position + z_offset * 0.5
	local navmesh_offset_z_position = position_on_navmesh + z_offset * 0.5
	local to_los_position = navmesh_offset_z_position - slot_offset_check_position
	local distance = Vector3.length(to_los_position) + CoverSettings.slot_width * 0.25
	local direction = Vector3.normalize(to_los_position)
	local filter = "filter_minion_line_of_sight_check"
	local hit = PhysicsWorld.raycast(physics_world, slot_offset_check_position, direction, distance, "closest", "collision_filter", filter)

	if hit then
		return false
	end

	return true
end

CoverSlots._double_raycast_los_check = function (physics_world, offset_z_position, los_from_position, los_to_position)
	local to_los_position = los_from_position - offset_z_position
	local distance = Vector3.length(to_los_position)
	local direction = Vector3.normalize(to_los_position)
	local filter = "filter_minion_line_of_sight_check"
	local hit = PhysicsWorld.raycast(physics_world, offset_z_position, direction, distance, "closest", "collision_filter", filter)

	if hit then
		return false
	end

	to_los_position = los_to_position - los_from_position
	distance = Vector3.length(to_los_position)
	direction = Vector3.normalize(to_los_position)
	hit = PhysicsWorld.raycast(physics_world, los_from_position, direction, distance, "closest", "collision_filter", filter)

	return not hit
end

return CoverSlots
