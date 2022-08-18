local ProjectileIntegrationData = {}

ProjectileIntegrationData.allocate_integration_data = function ()
	local integration_data = {
		previous_position = Vector3Box(),
		position = Vector3Box(),
		velocity = Vector3Box(),
		acceleration = Vector3Box(),
		rotation = QuaternionBox(Quaternion.identity()),
		angular_momentum = Vector3Box(),
		gravity = 0,
		coefficient_of_restitution = 0,
		air_drag = 0,
		has_hit = false,
		max_hit_count = 0,
		hit_count = 0,
		integrate = false,
		inertia = 1,
		radius = 1,
		collision_types = nil,
		collision_filter = nil,
		use_generous_bouncing = nil,
		have_bounced = nil,
		rotate_towards_direction = nil,
		true_flight_template = nil,
		target_position = nil,
		initial_position = Vector3Box(),
		owner_unit = nil,
		projectile_unit = nil,
		target_unit = nil,
		target_hit_zone = nil,
		height_offset = 0,
		time_since_start = 0,
		on_target_time = 0,
		raycast_timer = 0,
		damage_extension = nil,
		suppresion_settings = nil
	}

	return integration_data
end

ProjectileIntegrationData.fill_integration_data = function (integration_data, owner_unit, projectile_unit, locomotion_template, radius, mass, position, rotation, direction, speed, momentum, target_unit, target_position)
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
	local inertia = 0.4 * mass * radius * radius
	local angular_momentum = momentum * radius

	fassert(mass > 0, "[ProjectileIntegrationData.fill_integration_data] mass needs to be larger than 0!")

	local air_drag = drag_coefficient and 0.5 * drag_coefficient * math.pi * radius * radius * air_density / mass or 0
	local velocity = speed * direction
	integration_data.previous_position = Vector3Box(position)
	integration_data.position = Vector3Box(position)
	integration_data.velocity = Vector3Box(velocity)
	integration_data.acceleration = Vector3Box(0, 0, 0)
	integration_data.rotation = QuaternionBox(rotation)
	integration_data.gravity = gravity
	integration_data.coefficient_of_restitution = coefficient_of_restitution
	integration_data.air_drag = air_drag
	integration_data.has_hit = false
	integration_data.max_hit_count = max_hit_count
	integration_data.hit_count = 0
	integration_data.integrate = true
	integration_data.angular_momentum = Vector3Box(angular_momentum)
	integration_data.inertia = inertia
	integration_data.radius = radius
	integration_data.collision_types = collision_types
	integration_data.collision_filter = collision_filter
	integration_data.owner_unit = owner_unit
	integration_data.projectile_unit = projectile_unit
	integration_data.use_generous_bouncing = use_generous_bouncing
	integration_data.have_bounced = nil
	integration_data.rotate_towards_direction = rotate_towards_direction
	integration_data.initial_position = Vector3Box(position)
	integration_data.true_flight_template = true_flight_template
	integration_data.target_unit = target_unit
	integration_data.target_position = target_position and Vector3Box(target_position)
	integration_data.target_hit_zone = nil
	integration_data.height_offset = 0
	integration_data.time_since_start = 0
	integration_data.on_target_time = 0
	integration_data.raycast_timer = 0
	integration_data.damage_extension = ScriptUnit.has_extension(projectile_unit, "projectile_damage_system")
	integration_data.fx_extension = ScriptUnit.has_extension(projectile_unit, "fx_system")
	integration_data.suppresion_settings = locomotion_template.suppresion_settings
end

ProjectileIntegrationData.mass_radius = function (locomotion_template, optional_locomotion_extension)
	local mass, radius = nil

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
