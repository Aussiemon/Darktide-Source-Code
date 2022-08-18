local PointOfInterestUtilities = {
	can_raycast = function (physics_world, unit, target, ray_position, ray_direction, ray_length, ray_collision_filter)
		if Vector3.length(ray_direction) == 0 then
			return true
		end

		local collision_filter = ray_collision_filter or "filter_look_at_object_ray"
		local hits = PhysicsWorld.raycast(physics_world, ray_position, ray_direction, ray_length, "all", "types", "both", "collision_filter", collision_filter)
		local INDEX_ACTOR = 4

		if hits then
			local num_hits = #hits

			for i = 1, num_hits do
				local hit_data = hits[i]
				local hit_unit = Actor.unit(hit_data[INDEX_ACTOR])

				if hit_unit ~= unit and hit_unit ~= target then
					return false
				end
			end
		end

		return true
	end,
	is_in_range = function (observer_position, target_position, observer_forward, view_distance_sq, view_half_angle)
		local observer_to_target_vector = target_position - observer_position
		local observer_target_direction = Vector3.normalize(observer_to_target_vector)
		local distance_squared = math.max(0.1, Vector3.length_squared(observer_to_target_vector))

		if view_distance_sq < distance_squared then
			return false, observer_to_target_vector, observer_target_direction, nil, nil
		end

		local distance_det = view_distance_sq / (2 * distance_squared)
		local angle = Vector3.angle(observer_forward, observer_target_direction)
		local max_angle = view_half_angle * distance_det

		if angle >= max_angle then
			return false, observer_to_target_vector, observer_target_direction, angle, max_angle
		end

		return true, observer_to_target_vector, observer_target_direction, angle, max_angle
	end
}

return PointOfInterestUtilities
