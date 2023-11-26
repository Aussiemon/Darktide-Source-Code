-- chunkname: @scripts/utilities/attack/bot_aoe_threat.lua

local NavQueries = require("scripts/utilities/nav_queries")
local BotAoeThreat = {}
local EPSILON, THREAT_NAV_MESH_ABOVE, THREAT_NAV_MESH_BELOW = 0.01, 2, 2

BotAoeThreat.detect_sphere = function (nav_world, traverse_logic, bot_position, bot_height, bot_radius, sphere_x, sphere_y, sphere_z, rotation, sphere_radius, duration)
	local bot_x, bot_y, bot_z = bot_position.x, bot_position.y, bot_position.z
	local offset_x, offset_y = bot_x - sphere_x, bot_y - sphere_y
	local flat_dist_from_center = math.sqrt(offset_x * offset_x + offset_y * offset_y)

	if flat_dist_from_center > sphere_radius + bot_radius then
		return nil
	end

	if bot_z < sphere_z + sphere_radius and bot_z > sphere_z - bot_height - sphere_radius then
		local escape_dist = sphere_radius - flat_dist_from_center
		local escape_dir

		if flat_dist_from_center < EPSILON then
			escape_dir = Vector3(0, 1, 0)
		else
			escape_dir = Vector3(offset_x / flat_dist_from_center, offset_y / flat_dist_from_center, 0)
		end

		local to = bot_position + escape_dir * escape_dist
		local success = NavQueries.ray_can_go(nav_world, bot_position, to, traverse_logic, THREAT_NAV_MESH_ABOVE, THREAT_NAV_MESH_BELOW)

		if success then
			return escape_dir
		end
	end
end

BotAoeThreat.detect_cylinder = function (nav_world, traverse_logic, bot_position, bot_height, bot_radius, x, y, z, rotation, size, duration)
	local radius = math.max(size.x, size.y)
	local half_height = size.z
	local bot_x, bot_y, bot_z = bot_position.x, bot_position.y, bot_position.z
	local offset_x, offset_y = bot_x - x, bot_y - y
	local flat_dist_from_center = math.sqrt(offset_x * offset_x + offset_y * offset_y)

	if flat_dist_from_center <= radius + bot_radius and bot_z > z - bot_height - half_height and bot_z < z + half_height then
		local escape_dist = radius - flat_dist_from_center
		local escape_dir

		if flat_dist_from_center < EPSILON then
			escape_dir = Vector3(0, 1, 0)
		else
			escape_dir = Vector3(offset_x / flat_dist_from_center, offset_y / flat_dist_from_center, 0)
		end

		local to = bot_position + escape_dir * escape_dist
		local success = NavQueries.ray_can_go(nav_world, bot_position, to, traverse_logic, THREAT_NAV_MESH_ABOVE, THREAT_NAV_MESH_BELOW)

		if success then
			return escape_dir
		end
	end
end

BotAoeThreat.detect_oobb = function (nav_world, traverse_logic, bot_position, bot_height, bot_radius, x, y, z, rotation, extents, duration)
	local half_bot_height = bot_height * 0.5
	local offset = bot_position - Vector3(x, y, z - half_bot_height)
	local right_vector = Quaternion.right(rotation)
	local x_offset = Vector3.dot(right_vector, offset)
	local y_offset = Vector3.dot(Quaternion.forward(rotation), offset)
	local z_offset = Vector3.dot(Quaternion.up(rotation), offset)
	local extents_x, extents_y, extents_z = extents.x + bot_radius, extents.y + bot_radius, extents.z + half_bot_height

	if extents_x < x_offset or x_offset < -extents_x or extents_y < y_offset or y_offset < -extents_y or extents_z < z_offset or z_offset < -extents_z then
		return
	end

	local sign = x_offset == 0 and 1 - math.random(0, 1) * 2 or math.sign(x_offset)
	local to_direction

	for i = 1, 2 do
		local to = bot_position - x_offset * right_vector + sign * ((bot_radius + extents_x) * right_vector)
		local raycango = NavQueries.ray_can_go(nav_world, bot_position, to, traverse_logic, THREAT_NAV_MESH_ABOVE, THREAT_NAV_MESH_BELOW)

		if raycango then
			local in_liquid = false

			if not in_liquid or in_liquid and to_direction == nil then
				to_direction = Vector3.normalize(to - bot_position)
			end

			if not in_liquid then
				break
			end
		end

		sign = -sign
	end

	return to_direction
end

return BotAoeThreat
