-- chunkname: @scripts/extension_systems/weapon/actions/utilities/aim_placement.lua

local AimPlacement = {}

local function _valid_unit_from_actor(actor)
	if not actor then
		return nil
	end

	local unit_hit = Actor.unit(actor)

	if not unit_hit then
		return nil
	end

	local unit_spawner_manager = Managers.state.unit_spawner
	local game_object_id = unit_spawner_manager:game_object_id(unit_hit)
	local level_index = unit_spawner_manager:level_index(unit_hit)

	if not game_object_id and not level_index then
		return nil
	end

	return unit_hit
end

AimPlacement.from_unit = function (physics_world, unit)
	local unit_pos = Unit.world_position(unit, 1)
	local unit_rot = Unit.world_rotation(unit, 1)
	local raycast_pos = unit_pos + Vector3.up() * 0.5
	local hit, position, _, _, actor = PhysicsWorld.raycast(physics_world, raycast_pos, Vector3.down(), 1, "closest", "types", "both", "collision_filter", "filter_player_place_deployable")
	local can_place = not not hit
	local unit_hit = _valid_unit_from_actor(actor)

	return can_place, position, unit_rot, unit_hit
end

local OPTIONAL_AIM_UPWARDS_DEPLOYMENT_DISTANCE_MODIFIER = 5

AimPlacement.from_configuration = function (physics_world, place_configuration, first_person_component)
	local look_position = first_person_component.position
	local look_rotation = first_person_component.rotation
	local look_direction = Quaternion.forward(look_rotation)
	local place_distance = place_configuration.distance
	local hit, position, _, normal, actor = PhysicsWorld.raycast(physics_world, look_position, look_direction, place_distance, "closest", "types", "both", "collision_filter", "filter_player_place_deployable")

	if not hit then
		local downwards_length_modifier = 1

		if place_configuration.allow_aim_upwards_deployment then
			downwards_length_modifier = OPTIONAL_AIM_UPWARDS_DEPLOYMENT_DISTANCE_MODIFIER
		end

		local downward_raycast_position = look_position + look_direction * place_distance

		hit, position, _, normal, actor = PhysicsWorld.raycast(physics_world, downward_raycast_position, Vector3.down(), place_distance * downwards_length_modifier, "closest", "types", "both", "collision_filter", "filter_player_place_deployable")
	end

	local can_place = false

	if position then
		if Vector3.dot(normal, Vector3.up()) > 0.7 then
			can_place = true
		end
	else
		position = Vector3.zero()
	end

	local unit_hit = _valid_unit_from_actor(actor)
	local look_direction_flat = Vector3.flat(look_direction)
	local rotation = Quaternion.look(look_direction_flat)

	return can_place, position, rotation, unit_hit
end

return AimPlacement
