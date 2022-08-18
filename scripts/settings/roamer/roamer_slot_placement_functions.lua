local NavQueries = require("scripts/utilities/nav_queries")
local roamer_slot_placement_functions = {}
local ABOVE = 2
local BELOW = 3
local TWO_PI = math.two_pi

roamer_slot_placement_functions.circle_placement = function (nav_world, spawn_position_boxed, roamer_placement_settings, traverse_logic, roamer_pacing)
	local roamer_slots = {}
	local num_slots = roamer_placement_settings.num_slots
	local radians_per_roamer_slot = TWO_PI / num_slots
	local current_radians = -(radians_per_roamer_slot / 2)
	local position_offset = roamer_placement_settings.position_offset
	local spawn_position = spawn_position_boxed:unbox()

	if num_slots == 1 then
		local random_radians = roamer_pacing:_random(0, TWO_PI)
		local random_direction = Vector3(math.sin(random_radians), math.cos(random_radians), 0)
		local position_on_navmesh = NavQueries.position_on_mesh(nav_world, spawn_position + random_direction * position_offset, ABOVE, BELOW, traverse_logic)

		if position_on_navmesh then
			local roamer_slot = {
				position = Vector3Box(position_on_navmesh),
				rotation = QuaternionBox(Quaternion.look(-random_direction))
			}
			roamer_slots[#roamer_slots + 1] = roamer_slot
		end

		return roamer_slots
	end

	for i = 1, num_slots do
		current_radians = current_radians + radians_per_roamer_slot
		local direction = Vector3(math.sin(current_radians), math.cos(current_radians), 0)
		local position = spawn_position + direction * position_offset
		local position_on_navmesh = NavQueries.position_on_mesh(nav_world, position, ABOVE, BELOW, traverse_logic)

		if position_on_navmesh then
			local roamer_slot = {
				position = Vector3Box(position_on_navmesh),
				rotation = QuaternionBox(Quaternion.look(-direction))
			}
			roamer_slots[#roamer_slots + 1] = roamer_slot
		end
	end

	return roamer_slots
end

roamer_slot_placement_functions.random_circle_placement = function (nav_world, spawn_position_boxed, roamer_placement_settings, traverse_logic, roamer_pacing)
	local roamer_slots = {}
	local num_slots = roamer_placement_settings.num_slots
	local radians_per_roamer_slot = TWO_PI / num_slots
	local current_radians = -(radians_per_roamer_slot / 2)
	local position_offset_range = roamer_placement_settings.position_offset_range
	local circle_radius = roamer_placement_settings.circle_radius
	local half_circle_radius = circle_radius * 0.5
	local spawn_position = spawn_position_boxed:unbox()
	local max_tries = 10

	for i = 1, num_slots do
		current_radians = current_radians + radians_per_roamer_slot
		local dir = Vector3(math.sin(current_radians), math.cos(current_radians), 0)
		local min_range = position_offset_range[1]
		local max_range = position_offset_range[2]

		for j = 1, max_tries do
			local position_offset = roamer_pacing:_random(min_range, max_range)
			local distance = math.min(position_offset + i % 2 * position_offset + roamer_pacing:_random(0, position_offset), half_circle_radius)
			local pos = spawn_position + dir * distance
			local position_on_navmesh = NavQueries.position_on_mesh(nav_world, pos, ABOVE, BELOW, traverse_logic)

			if position_on_navmesh then
				local random_radians = roamer_pacing:_random(0, TWO_PI)
				local random_direction = Vector3(math.sin(random_radians), math.cos(random_radians), 0)
				local roamer_slot = {
					position = Vector3Box(position_on_navmesh),
					rotation = QuaternionBox(Quaternion.look(random_direction))
				}
				roamer_slots[#roamer_slots + 1] = roamer_slot

				break
			end
		end
	end

	return roamer_slots
end

roamer_slot_placement_functions.flood_fill = function (nav_world, spawn_position_boxed, roamer_placement_settings, traverse_logic, roamer_pacing)
	local roamer_slots = {}
	local flood_fill_positions = {}
	local num_slots = roamer_placement_settings.num_slots
	local below = 2
	local above = 2
	local num_positions = GwNavQueries.flood_fill_from_position(nav_world, spawn_position_boxed:unbox(), above, below, num_slots, flood_fill_positions, traverse_logic)

	for i = 1, num_positions do
		local position = flood_fill_positions[i]
		local random_radians = roamer_pacing:_random(0, TWO_PI)
		local random_direction = Vector3(math.sin(random_radians), math.cos(random_radians), 0)
		local roamer_slot = {
			position = Vector3Box(position),
			rotation = QuaternionBox(Quaternion.look(random_direction))
		}
		roamer_slots[#roamer_slots + 1] = roamer_slot
	end

	return roamer_slots
end

return settings("RoamerSlotPlacementFunctions", roamer_slot_placement_functions)
