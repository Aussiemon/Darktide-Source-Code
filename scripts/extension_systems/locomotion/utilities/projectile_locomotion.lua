local HitZone = require("scripts/utilities/attack/hit_zone")
local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local ProjectileLocomotionUtility = require("scripts/extension_systems/locomotion/utilities/projectile_locomotion_utility")
local projectile_impact_results = ProjectileLocomotionSettings.impact_results
local MIN_TRAVEL_DISTANCE_TO_INTEGRATE = ProjectileLocomotionSettings.MIN_TRAVEL_DISTANCE_TO_INTEGRATE
local ProjectileLocomotion = {}
local DO_NOTHING_IMPACT_RESULTS = {
	stick = true,
	continue_straight = true
}

ProjectileLocomotion.integrate_position = function (physics_world, integration_data, dt, t, time_step_multiplier, dont_draw)
	local velocity = integration_data.velocity
	local position = integration_data.position
	local acceleration = integration_data.acceleration
	local gravity = -integration_data.gravity
	local air_drag = integration_data.air_drag
	local collision_types = integration_data.collision_types
	local collision_filter = integration_data.collision_filter
	time_step_multiplier = time_step_multiplier or 1
	local new_position = position
	local new_velocity = velocity
	local new_acceleration = acceleration

	for i = 1, time_step_multiplier do
		local old_acceleration = new_acceleration
		new_position = new_position + dt * new_velocity
		new_position = new_position + dt * dt * 0.5 * new_acceleration
		local air_drag_acceleration = -air_drag * Vector3.length(new_velocity) * new_velocity
		new_acceleration = air_drag_acceleration
		new_acceleration.z = new_acceleration.z + gravity
		new_velocity = new_velocity + dt * 0.5 * (old_acceleration + new_acceleration)
	end

	dt = dt * time_step_multiplier
	local position_after_impact, velocity_after_impact = ProjectileLocomotionUtility.impact_detection_and_resolution(integration_data, new_position, new_velocity, physics_world, collision_filter, dt, dont_draw, false)
	integration_data.previous_position = position
	integration_data.position = position_after_impact
	integration_data.velocity = velocity_after_impact
	integration_data.acceleration = new_acceleration
	integration_data.time_since_start = integration_data.time_since_start + dt

	return new_position
end

ProjectileLocomotion.integrate_rotation = function (physics_world, integration_data, dt, t)
	local angular_velocity = integration_data.angular_velocity
	local have_bounced = integration_data.have_bounced
	local rotate_towards_direction = integration_data.rotate_towards_direction

	if not have_bounced and rotate_towards_direction then
		local previous_rotation = integration_data.rotation
		local previous_up = Quaternion.up(previous_rotation)
		local direction = integration_data.velocity
		local angle = -angular_velocity.x * dt
		local up_rotator = Quaternion.axis_angle(direction, angle)
		local new_up = Quaternion.rotate(up_rotator, previous_up)
		local rotation = Quaternion.look(direction, new_up)
		integration_data.rotation = rotation
	else
		local new_rotation = Quaternion.from_elements(angular_velocity.x, angular_velocity.y, angular_velocity.z, 0)
		new_rotation = Quaternion.multiply_scalar(new_rotation, 0.5)
		local rotation = integration_data.rotation
		local spin = Quaternion.multiply(rotation, new_rotation)
		spin = Quaternion.multiply_scalar(spin, dt)
		rotation = Quaternion.add_elements(rotation, spin)
		rotation = Quaternion.normalize(rotation)
		integration_data.rotation = rotation

		return rotation
	end
end

ProjectileLocomotion.integrate = function (physics_world, integration_data, dt, t, is_server, time_step_multiplier, dont_draw)
	if integration_data.integrate then
		local previus_position = integration_data.position
		local new_position = ProjectileLocomotion.integrate_position(physics_world, integration_data, dt, t, time_step_multiplier, dont_draw)
		local _ = ProjectileLocomotion.integrate_rotation(physics_world, integration_data, dt, t)

		ProjectileLocomotionUtility.check_suppression(physics_world, integration_data, previus_position, new_position, is_server, dt, t)
	end
end

return ProjectileLocomotion
