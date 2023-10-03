local AimPlaceUtil = {
	aim_placement = function (physics_world, place_configuration, first_person_component)
		local look_position = first_person_component.position
		local look_rotation = first_person_component.rotation
		local look_direction = Quaternion.forward(look_rotation)
		local place_distance = place_configuration.distance
		local hit, position, _, normal, actor = PhysicsWorld.raycast(physics_world, look_position, look_direction, place_distance, "closest", "types", "both", "collision_filter", "filter_player_place_deployable")

		if not hit then
			local downward_raycast_position = look_position + look_direction * place_distance
			hit, position, _, normal, actor = PhysicsWorld.raycast(physics_world, downward_raycast_position, Vector3.down(), place_distance, "closest", "types", "both", "collision_filter", "filter_player_place_deployable")
		end

		local can_place = false

		if position then
			if Vector3.dot(normal, Vector3.up()) > 0.7 then
				can_place = true
			end
		else
			position = Vector3.zero()
		end

		local unit_hit = nil

		if actor then
			unit_hit = Actor.unit(actor)
		end

		if unit_hit then
			local unit_spawner_manager = Managers.state.unit_spawner
			local game_object_id = unit_spawner_manager:game_object_id(unit_hit)
			local level_index = unit_spawner_manager:level_index(unit_hit)

			if not game_object_id and not level_index then
				unit_hit = nil
			end
		end

		local look_direction_flat = Vector3.flat(look_direction)
		local rotation = Quaternion.look(look_direction_flat)

		return can_place, position, rotation, unit_hit
	end
}

return AimPlaceUtil
