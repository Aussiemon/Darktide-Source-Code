-- chunkname: @scripts/extension_systems/locomotion/utilities/true_flight_functions/true_flight_drone.lua

local TrueFlightDefaults = require("scripts/extension_systems/locomotion/utilities/true_flight_functions/true_flight_defaults")
local TrueFlightDrone = {}

TrueFlightDrone.drone_projectile_locomotion = function (physics_world, integration_data, dt, t)
	local velocity = integration_data.velocity
	local position = integration_data.position
	local new_position = position + velocity * dt
	local new_rotation = Quaternion.look(velocity)
	local rotation_speed = 15
	local rotation_length = 30
	local sin_test = math.sin(t * rotation_speed + integration_data.time_since_start^2)
	local cos_test = math.sin(t * rotation_speed * 0.55)
	local test_vector = Vector3(sin_test, rotation_length, cos_test)
	local test_look = Quaternion.look(test_vector)
	local new_velocity = Quaternion.rotate(test_look, velocity)

	integration_data.velocity = new_velocity

	return new_position, new_rotation
end

TrueFlightDrone.drone_update_towards_position = function (target_position, physics_world, integration_data, dt, t, optional_validate_impact_func, optional_on_impact_func)
	local true_flight_template = integration_data.true_flight_template
	local trigger_time = true_flight_template.trigger_time
	local on_target_time = integration_data.on_target_time
	local have_triggered = trigger_time < on_target_time
	local position = integration_data.position
	local towards_target = target_position - position
	local distance_squared = Vector3.length_squared(towards_target)
	local should_integrate = distance_squared >= 0.25

	integration_data.integrate = should_integrate

	if have_triggered then
		return TrueFlightDefaults.default_update_towards_position(target_position, physics_world, integration_data, dt, t, optional_validate_impact_func, optional_on_impact_func)
	else
		return TrueFlightDrone.drone_projectile_locomotion(physics_world, integration_data, dt, t)
	end
end

return TrueFlightDrone
