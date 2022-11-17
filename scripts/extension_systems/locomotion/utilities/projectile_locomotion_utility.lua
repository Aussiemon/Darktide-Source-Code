local ProjectileLocomotionUtility = {
	set_kinematic = function (unit, actor_id, kinematic)
		if actor_id then
			local dynamic_actor = Unit.actor(unit, actor_id)

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

local DEFAULT_SUPPRESSION_COLLISION_FILTER = "filter_player_character_shooting_raycast_dynamics"
local DEFAULT_SUPPRESSION_COLLISION_TYPE = "dynamics"
local DEFAULT_SUPPRESSION_CHECK_RADIUS = 0.075

ProjectileLocomotionUtility.check_suppression = function (physics_world, integration_data, previus_position, new_position, is_server, dt, t)
	if not is_server then
		return
	end

	local damage_extension = integration_data.damage_extension

	if not damage_extension or not damage_extension:use_suppression() then
		return
	end

	local suppression_settings = integration_data.suppression_settings
	local suppression_radius = suppression_settings and suppression_settings.suppression_radius or DEFAULT_SUPPRESSION_CHECK_RADIUS
	local suppersion_collision_types = suppression_settings and suppression_settings.suppersion_collision_types or DEFAULT_SUPPRESSION_COLLISION_TYPE
	local suppersion_collision_filter = suppression_settings and suppression_settings.suppersion_collision_filter or DEFAULT_SUPPRESSION_COLLISION_FILTER
	local hits = PhysicsWorld.linear_sphere_sweep(physics_world, previus_position, new_position, suppression_radius, 1, "types", suppersion_collision_types, "collision_filter", suppersion_collision_filter)

	if hits then
		for ii = 1, #hits do
			local hit = hits[ii]
			local hit_actor = hit.actor
			local hit_unit = Actor.unit(hit_actor)
			local hit_position = hit.position

			damage_extension:on_suppression(hit_unit, hit_position)
		end
	end
end

ProjectileLocomotionUtility.check_collision = function (hit_unit, hit_position, integration_data, bounce_unit)
	local owner_unit = integration_data.owner_unit

	if hit_unit == owner_unit then
		return false
	end

	if hit_unit == bounce_unit then
		return false
	end

	return true
end

return ProjectileLocomotionUtility
