-- chunkname: @scripts/extension_systems/locomotion/utilities/projectile_integration_data.lua

local ProjectileIntegrationData = {}
local integration_data_interface = {
	"previous_position",
	"position",
	"velocity",
	"acceleration",
	"rotation",
	"has_hit",
	"max_hit_count",
	"hit_count",
	"integrate",
	"radius",
	"collision_types",
	"collision_filter",
	"owner_unit",
	"projectile_unit",
	"rotate_towards_direction",
	"damage_extension",
	"fx_extension",
	"suppression_settings",
	"last_hit_unit",
	"last_hit_position",
	"hit_zone_priority",
	"last_hit_detection_position",
	"integrator_parameters",
	"angular_velocity",
	"gravity",
	"coefficient_of_restitution",
	"air_drag",
	"inertia",
	"use_generous_bouncing",
	"have_bounced",
	"bounced_this_frame",
	"true_flight_template",
	"initial_position",
	"target_position",
	"target_unit",
	"target_hit_zone",
	"raycast_timer",
	"height_offset",
	"time_since_start",
	"on_target_time",
	"time_without_bounce",
	"time_without_target",
	"missile_triggered",
	"missile_striking",
	"missile_lingering",
	"min_slow_down",
	"number_of_bounces",
	"store_data",
	"previous_position_box",
	"position_box",
	"velocity_box",
	"acceleration_box",
	"rotation_box",
	"angular_velocity_box",
	"initial_position_box",
	"target_position_box",
	"last_hit_position_box",
	"last_hit_detection_position_box"
}
local num_integration_data_fields = #integration_data_interface

ProjectileIntegrationData.allocate_integration_data = function (store_data)
	local integration_data = Script.new_map(num_integration_data_fields)

	integration_data.previous_position = nil
	integration_data.position = nil
	integration_data.velocity = nil
	integration_data.acceleration = nil
	integration_data.rotation = nil
	integration_data.angular_velocity = nil
	integration_data.gravity = 0
	integration_data.coefficient_of_restitution = 0
	integration_data.air_drag = 0
	integration_data.has_hit = false
	integration_data.max_hit_count = 0
	integration_data.hit_count = 0
	integration_data.integrate = false
	integration_data.inertia = 1
	integration_data.radius = 1
	integration_data.collision_types = nil
	integration_data.collision_filter = nil
	integration_data.use_generous_bouncing = nil
	integration_data.have_bounced = nil
	integration_data.bounced_this_frame = false
	integration_data.rotate_towards_direction = nil
	integration_data.hit_zone_priority = nil
	integration_data.number_of_bounces = 0
	integration_data.last_hit_detection_position = nil
	integration_data.integrator_parameters = nil
	integration_data.true_flight_template = nil
	integration_data.target_position = nil
	integration_data.initial_position = nil
	integration_data.owner_unit = nil
	integration_data.projectile_unit = nil
	integration_data.target_unit = nil
	integration_data.target_hit_zone = nil
	integration_data.height_offset = 0
	integration_data.time_since_start = 0
	integration_data.on_target_time = 0
	integration_data.time_without_target = 0
	integration_data.time_without_bounce = 0
	integration_data.raycast_timer = 0
	integration_data.damage_extension = nil
	integration_data.suppression_settings = nil
	integration_data.store_data = store_data

	if store_data then
		integration_data.previous_position_box = Vector3Box()
		integration_data.position_box = Vector3Box()
		integration_data.velocity_box = Vector3Box()
		integration_data.acceleration_box = Vector3Box(Vector3.zero())
		integration_data.rotation_box = QuaternionBox()
		integration_data.angular_velocity_box = Vector3Box()
		integration_data.initial_position_box = Vector3Box()
		integration_data.last_hit_detection_position_box = Vector3Box()
		integration_data.store_data = true
	end

	return integration_data
end

ProjectileIntegrationData.fill_integration_data = function (integration_data, owner_unit, projectile_unit, locomotion_template, radius, mass, position, rotation, direction, speed, angular_velocity, target_unit, target_position)
	local integrator_parameters = locomotion_template.integrator_parameters
	local true_flight_template = integrator_parameters.true_flight_template
	local air_density = integrator_parameters.air_density
	local drag_coefficient = integrator_parameters.drag_coefficient
	local gravity = integrator_parameters.gravity
	local coefficient_of_restitution = integrator_parameters.coefficient_of_restitution
	local max_hit_count = integrator_parameters.max_hit_count
	local collision_types = integrator_parameters.collision_types
	local collision_filter = integrator_parameters.collision_filter
	local use_generous_bouncing = integrator_parameters.use_generous_bouncing
	local rotate_towards_direction = integrator_parameters.rotate_towards_direction
	local hit_zone_priority = integrator_parameters.hit_zone_priority
	local air_drag = drag_coefficient and 0.5 * drag_coefficient * (math.pi * radius * radius) * air_density / mass or 0
	local velocity = speed * direction

	integration_data.previous_position = position
	integration_data.position = position
	integration_data.velocity = velocity
	integration_data.acceleration = Vector3.zero()
	integration_data.rotation = rotation
	integration_data.gravity = gravity
	integration_data.coefficient_of_restitution = coefficient_of_restitution
	integration_data.air_drag = air_drag
	integration_data.has_hit = false
	integration_data.max_hit_count = max_hit_count
	integration_data.hit_count = 0
	integration_data.integrate = true
	integration_data.angular_velocity = angular_velocity
	integration_data.inertia = 0.4 * mass * radius * radius
	integration_data.radius = radius
	integration_data.collision_types = collision_types
	integration_data.collision_filter = collision_filter
	integration_data.owner_unit = owner_unit
	integration_data.projectile_unit = projectile_unit
	integration_data.use_generous_bouncing = use_generous_bouncing
	integration_data.have_bounced = nil
	integration_data.rotate_towards_direction = rotate_towards_direction
	integration_data.hit_zone_priority = hit_zone_priority
	integration_data.last_hit_detection_position = position
	integration_data.integrator_parameters = integrator_parameters
	integration_data.initial_position = position
	integration_data.true_flight_template = true_flight_template
	integration_data.target_unit = target_unit
	integration_data.target_position = target_position
	integration_data.target_hit_zone = nil
	integration_data.height_offset = 0
	integration_data.time_since_start = 0
	integration_data.on_target_time = 0
	integration_data.raycast_timer = 0
	integration_data.damage_extension = ScriptUnit.has_extension(projectile_unit, "projectile_damage_system")
	integration_data.fx_extension = ScriptUnit.has_extension(projectile_unit, "fx_system")
	integration_data.suppression_settings = locomotion_template.suppression_settings
	integration_data.last_hit_unit = nil
	integration_data.last_hit_position = nil

	if integration_data.store_data then
		ProjectileIntegrationData.store(integration_data)
	end
end

ProjectileIntegrationData.store = function (integration_data)
	integration_data.previous_position_box:store(integration_data.previous_position)
	integration_data.position_box:store(integration_data.position)
	integration_data.velocity_box:store(integration_data.velocity)
	integration_data.acceleration_box:store(integration_data.acceleration)
	integration_data.rotation_box:store(integration_data.rotation)
	integration_data.angular_velocity_box:store(integration_data.angular_velocity)
	integration_data.initial_position_box:store(integration_data.initial_position)

	local target_position = integration_data.target_position

	if target_position then
		if not integration_data.target_position_box then
			integration_data.target_position_box = Vector3Box(target_position)
		else
			integration_data.target_position_box:store(target_position)
		end
	end

	local last_hit_position = integration_data.last_hit_position

	if last_hit_position then
		if not integration_data.last_hit_position_box then
			integration_data.last_hit_position_box = Vector3Box(last_hit_position)
		else
			integration_data.last_hit_position_box:store(last_hit_position)
		end
	end

	integration_data.last_hit_detection_position_box:store(integration_data.last_hit_detection_position)
end

ProjectileIntegrationData.unbox = function (integration_data)
	integration_data.previous_position = integration_data.previous_position_box:unbox()
	integration_data.position = integration_data.position_box:unbox()
	integration_data.velocity = integration_data.velocity_box:unbox()
	integration_data.acceleration = integration_data.acceleration_box:unbox()
	integration_data.rotation = integration_data.rotation_box:unbox()
	integration_data.angular_velocity = integration_data.angular_velocity_box:unbox()
	integration_data.initial_position = integration_data.initial_position_box:unbox()
	integration_data.target_position = integration_data.target_position_box and integration_data.target_position_box:unbox()
	integration_data.last_hit_position = integration_data.last_hit_position_box and integration_data.last_hit_position_box:unbox()
	integration_data.last_hit_detection_position = integration_data.last_hit_detection_position_box and integration_data.last_hit_detection_position_box:unbox()
end

ProjectileIntegrationData.mass_radius = function (locomotion_template, optional_locomotion_extension)
	local mass, radius

	if optional_locomotion_extension and locomotion_template.integrator_parameters.use_actor_mass_radius then
		mass = optional_locomotion_extension:mass()
		radius = optional_locomotion_extension:radius()
	else
		mass = locomotion_template.integrator_parameters.mass
		radius = locomotion_template.integrator_parameters.radius
	end

	return mass, radius
end

return ProjectileIntegrationData
