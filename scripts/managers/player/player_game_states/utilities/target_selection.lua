-- chunkname: @scripts/managers/player/player_game_states/utilities/target_selection.lua

local RAYCAST_RANGE = 50
local MINIMUM_DISTANCE = 0.05
local INDEX_POSITION = 1
local INDEX_DISTANCE = 2
local INDEX_ACTOR = 4
local TargetSelection = {}

TargetSelection.select_target = function (physics_world, self_unit, ray_origin, ray_rotation, collision_filter)
	local selected_unit, selected_unit_distance
	local darkness_system = Managers.state.extension:system("darkness_system")
	local forward = Quaternion.forward(ray_rotation)
	local right = Quaternion.right(ray_rotation)
	local up = Quaternion.up(ray_rotation)
	local hits, hits_n = PhysicsWorld.raycast(physics_world, ray_origin, forward, RAYCAST_RANGE, "all", "collision_filter", collision_filter)
	local best_ping_utility = -math.huge
	local debug_camera_pose = Matrix4x4.from_quaternion_position(ray_rotation, ray_origin)
	local abs = math.abs
	local max = math.max
	local dot = Vector3.dot

	for i = 1, hits_n do
		local hit = hits[i]
		local actor = hit[INDEX_ACTOR]
		local hit_position = hit[INDEX_POSITION]
		local distance = hit[INDEX_DISTANCE]

		if actor then
			local hit_unit = Actor.unit(actor)

			if hit_unit ~= self_unit then
				local is_pickup = ScriptUnit.has_extension(hit_unit, "interactee_system")
				local health_ext = ScriptUnit.has_extension(hit_unit, "health_system")
				local is_alive = health_ext and health_ext:is_alive()

				if is_pickup or is_alive then
					local half_width, half_height, hit_unit_center_pos

					if is_alive then
						local pose, half_extents = Unit.box(hit_unit, true)
						local object_right = Matrix4x4.right(pose)
						local object_forward = Matrix4x4.forward(pose)
						local world_extents_right = object_right * half_extents.x
						local world_extents_forward = object_forward * half_extents.y

						half_width = 0.25 * max(abs(dot(right, world_extents_right + world_extents_forward)), abs(dot(right, world_extents_right - world_extents_forward)))
						half_height = 0.5 * half_extents.z
						hit_unit_center_pos = Matrix4x4.translation(pose)
						distance = Vector3.length(hit_unit_center_pos - ray_origin) - half_width
					elseif is_pickup then
						local pose, half_extents = Unit.box(hit_unit, true)
						local object_right = Matrix4x4.right(pose)
						local object_forward = Matrix4x4.forward(pose)
						local world_extents_right = object_right * half_extents.x
						local world_extents_forward = object_forward * half_extents.y

						half_width = max(abs(dot(right, world_extents_right + world_extents_forward)), abs(dot(right, world_extents_right - world_extents_forward)))
						half_height = half_extents.z
						hit_unit_center_pos = Matrix4x4.translation(pose)
					end

					if distance > MINIMUM_DISTANCE then
						local hit_offset = hit_position - hit_unit_center_pos
						local x_diff = math.abs(Vector3.dot(hit_offset, right))
						local y_diff = math.abs(Vector3.dot(hit_offset, up))
						local epsilon = 0.01
						local direct_hit = x_diff <= half_width + epsilon and y_diff <= half_height + epsilon

						if direct_hit then
							selected_unit = hit_unit
							selected_unit_distance = distance

							break
						else
							local angle_width = math.atan(half_width / distance)
							local angle_height = math.atan(half_height / distance)
							local angle_x_diff = math.atan(x_diff / distance)
							local angle_y_diff = math.atan(y_diff / distance)
							local x_offset = math.max((angle_x_diff - angle_width) / angle_width, epsilon) / math.log(angle_width)
							local y_offset = math.max((angle_y_diff - angle_height) / angle_width, epsilon) / math.log(angle_width)
							local utility = 1 / (x_offset * y_offset)

							if best_ping_utility < utility and not darkness_system:is_in_darkness(hit_position) then
								selected_unit = hit_unit
								selected_unit_distance = distance
								best_ping_utility = utility
							end
						end
					end
				else
					break
				end
			end
		end
	end

	return selected_unit, selected_unit_distance
end

return TargetSelection
