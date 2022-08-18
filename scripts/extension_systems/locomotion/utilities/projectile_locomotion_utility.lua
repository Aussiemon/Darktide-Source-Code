local ProjectileLocomotionUtility = {
	set_kinematic = function (unit, actor_id, kinematic)
		if actor_id then
			local dynamic_actor = Unit.actor(unit, actor_id)

			fassert(dynamic_actor, "[ProjectileLocomotionUtility] Actor not available.")
			Actor.set_kinematic(dynamic_actor, kinematic)
		end
	end
}

local function _has_actor(unit, actor_name)
	local actor_id = Unit.find_actor(unit, actor_name)
	local actor = Unit.actor(unit, actor_id)

	return actor
end

ProjectileLocomotionUtility.activate_physics = function (unit)
	if not _has_actor(unit, "dynamic") then
		Unit.create_actor(unit, "dynamic")
	end
end

ProjectileLocomotionUtility.deactivate_physics = function (unit, dynamic_id)
	if _has_actor(unit, "dynamic") then
		Unit.destroy_actor(unit, dynamic_id)
	end
end

local DEFAULT_SUPPRESION_COLLISION_FILTER = "filter_player_character_shooting_dynamics"
local DEFAULT_SUPPRESION_COLLISION_TYPE = "dynamics"
local DEFAULT_SUPPRESION_CHECK_RADIUS = 0.075

ProjectileLocomotionUtility.check_suppresion = function (physics_world, integration_data, previus_position, new_position, is_server, dt, t)
	if not is_server then
		return
	end

	local damage_extension = integration_data.damage_extension

	if not damage_extension or not damage_extension:use_suppresion() then
		return
	end

	local suppresion_settings = integration_data.suppresion_settings
	local suppresion_radius = suppresion_settings and suppresion_settings.suppresion_radius or DEFAULT_SUPPRESION_CHECK_RADIUS
	local suppersion_collision_types = suppresion_settings and suppresion_settings.suppersion_collision_types or DEFAULT_SUPPRESION_COLLISION_TYPE
	local suppersion_collision_filter = suppresion_settings and suppresion_settings.suppersion_collision_filter or DEFAULT_SUPPRESION_COLLISION_FILTER
	local hits = PhysicsWorld.linear_sphere_sweep(physics_world, previus_position, new_position, suppresion_radius, 1, "types", suppersion_collision_types, "collision_filter", suppersion_collision_filter)

	if hits and #hits > 0 then
		for i = 1, #hits do
			local hit = hits[i]
			local hit_actor = hit.actor
			local hit_unit = Actor.unit(hit_actor)
			local hit_position = hit.position

			damage_extension:on_suppresion(hit_unit, hit_position)
		end
	end
end

ProjectileLocomotionUtility.check_collision = function (hit_unit, hit_position, integration_data)
	local owner_unit = integration_data.owner_unit

	if hit_unit == owner_unit then
		return false
	end

	if hit_unit == integration_data.last_hit_unit then
		return false
	end

	return true
end

return ProjectileLocomotionUtility
