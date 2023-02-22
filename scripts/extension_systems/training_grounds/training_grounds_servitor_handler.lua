local TrainingGroundsServitorHandler = class("TrainingGroundsServitorHandler")
local MOVEMENT_STATES = table.enum("still", "idle", "direct", "arc")

local function get_unit_rotation(target_unit)
	local target_is_player = Managers.player:player_by_unit(target_unit)

	if target_is_player then
		local first_person_extension = ScriptUnit.extension(target_unit, "first_person_system")
		local first_person_unit = first_person_extension:first_person_unit()
		local player_rotation = Unit.local_rotation(first_person_unit, 1)

		return Quaternion.from_yaw_pitch_roll(Quaternion.yaw(player_rotation), 0, 0)
	else
		return Unit.local_rotation(target_unit, 1)
	end
end

local function get_relative_position_rotation(target_unit, relative_position, rotate_position_relative_to_unit)
	local target_position = Unit.local_position(target_unit, 1)
	local target_unit_rotation = get_unit_rotation(target_unit)

	if rotate_position_relative_to_unit then
		relative_position = Quaternion.rotate(target_unit_rotation, relative_position)
	end

	local position = target_position + relative_position

	return position, target_unit_rotation
end

TrainingGroundsServitorHandler.init = function (self, scripted_scenario_system, world)
	self._unit = nil
	self._physics_world = World.physics_world(world)
	self._move_to_pos = Vector3Box()
	self._movement_state = MOVEMENT_STATES.still
	self._lookat_data = {
		use_velocity = true,
		lookat_pos = Vector3Box()
	}
	self._stop_at_arrival = true
	self._scripted_scenario_system = scripted_scenario_system
	self._velocity = Vector3Box()
	self._speed = 3
	self._idle_speed = 0.5
	self._idle_circle_radius = 3
	local idle_angular_speed = 2 * math.asin(self._idle_speed / (2 * self._idle_circle_radius))
	self._idle_next_point_rotation = QuaternionBox(Quaternion.axis_angle(Vector3.up(), idle_angular_speed))
	self._rotation_speed = math.pi
	self._float_z_offset_magnitude = 0.015
	self._float_z_speed = 1.5
	self._current_float_z_offset = 0
end

TrainingGroundsServitorHandler.update = function (self, dt, t)
	if not ALIVE[self._unit] then
		return
	end

	self:_handle_floating_z_offset(dt, t)

	local state = self._movement_state

	if state == MOVEMENT_STATES.idle then
		self:_calculate_idle(dt, t)
	elseif state == MOVEMENT_STATES.direct then
		self:_calculate_direct(dt)
	elseif state == MOVEMENT_STATES.arc then
		self:_calculate_arc(dt)
	end

	self:_move(dt)
	self:_handle_lookat(dt)
end

TrainingGroundsServitorHandler.spawn_servitor = function (self, position, rotation)
	local unit_name = "content/environment/artsets/imperial/training_grounds/placeholder/placeholder_servitor_2"
	local template_name = "training_grounds_servitor"
	local unit_spawner = Managers.state.unit_spawner
	self._unit = unit_spawner:spawn_network_unit(unit_name, template_name, position, rotation)
	self._interactee_extension = ScriptUnit.extension(self._unit, "interactee_system")

	return self._unit
end

TrainingGroundsServitorHandler.despawn_servitor = function (self)
	Managers.state.unit_spawner:mark_for_deletion(self._unit)
end

TrainingGroundsServitorHandler.unit = function (self)
	return self._unit
end

TrainingGroundsServitorHandler.update_lookat_position = function (self, optional_position)
	local lookat_data = self._lookat_data
	lookat_data.use_velocity = not optional_position

	if optional_position then
		lookat_data.lookat_pos:store(optional_position)
	end
end

TrainingGroundsServitorHandler._move = function (self, dt)
	local velocity = self._velocity:unbox()

	if Vector3.length_squared(velocity) < 0.001 then
		return
	end

	local servitor_pos = Unit.local_position(self._unit, 1)
	servitor_pos[3] = servitor_pos[3] - self._current_float_z_offset
	local wanted_pos = servitor_pos + velocity * dt
	local physics_world = self._physics_world
	local radius = 0.5
	local current_pos = servitor_pos
	local wanted_distance = Vector3.length(velocity * dt)
	local remaining_distance = wanted_distance
	local margin = wanted_distance * dt
	local iterations = 0

	while iterations < 10 do
		if remaining_distance <= 0 then
			break
		end

		local hits = PhysicsWorld.linear_sphere_sweep(physics_world, current_pos, wanted_pos, radius, 10, "types", "statics", "collision_filter", "filter_simple_geometry")
		local num_hits = hits and #hits or 0

		if num_hits <= 0 then
			break
		end

		local closest = math.huge
		local position = Vector3.zero()
		local normal = Vector3.zero()

		for i = 1, num_hits do
			local hit = hits[i]

			if hit.distance <= closest then
				closest = hit.distance
			end
		end

		local parsed_hits = 0

		for i = 1, num_hits do
			local hit = hits[i]

			if hit.distance <= closest then
				closest = hit.distance
				position = position + hit.position
				normal = normal + hit.normal
				parsed_hits = parsed_hits + 1
			end
		end

		position = position / parsed_hits
		normal = normal / parsed_hits
		local stop_pos = position + normal * radius
		local distance_to_stop = math.max(Vector3.length(stop_pos - current_pos) - margin, 0)
		distance_to_stop = math.min(distance_to_stop, remaining_distance)
		local move_direction = Vector3.normalize(wanted_pos - current_pos)
		current_pos = current_pos + move_direction * distance_to_stop
		remaining_distance = remaining_distance - distance_to_stop
		move_direction = Vector3.normalize(Vector3.cross(Vector3.cross(normal, Vector3.normalize(move_direction)), normal))

		if Vector3.length_squared(move_direction) < 0.001 then
			wanted_pos = current_pos

			break
		end

		wanted_pos = current_pos + move_direction * remaining_distance
		iterations = iterations + 1
	end

	wanted_pos[3] = wanted_pos[3] + self._current_float_z_offset

	Unit.set_local_position(self._unit, 1, wanted_pos)
end

TrainingGroundsServitorHandler.move_to_unit_relative_arc = function (self, relative_unit, relative_position, rotate_position_relative_to_unit, stop_at_arrival, lookat_unit)
	local start_position = Unit.local_position(self._unit, 1)
	local target_position, relative_unit_rotation = get_relative_position_rotation(relative_unit, relative_position, rotate_position_relative_to_unit)
	local start_relative_position = start_position - target_position
	self._move_arc_data = {
		start_relative_position = Vector3Box(start_relative_position),
		start_relative_unit_rotation = QuaternionBox(relative_unit_rotation),
		relative_unit = relative_unit,
		start_position = Vector3Box(start_position),
		relative_position = Vector3Box(relative_position),
		rotate_position_relative_to_unit = rotate_position_relative_to_unit,
		stop_at_arrival = stop_at_arrival,
		lookat_unit = lookat_unit
	}
	self._movement_state = MOVEMENT_STATES.arc
end

local max_arc_offset = 1.5

TrainingGroundsServitorHandler._calculate_arc = function (self, dt)
	local move_data = self._move_arc_data
	local relative_unit = move_data.relative_unit

	if not ALIVE[relative_unit] then
		self._movement_state = MOVEMENT_STATES.still

		return
	end

	local servitor_pos = Unit.local_position(self._unit, 1)
	local target_position, relative_unit_rotation = get_relative_position_rotation(relative_unit, move_data.relative_position:unbox(), move_data.rotate_position_relative_to_unit)
	local relative_position = servitor_pos - target_position
	local start_relative_position = move_data.start_relative_position:unbox()
	local rotation_diff = Quaternion.multiply(Quaternion.inverse(relative_unit_rotation), move_data.start_relative_unit_rotation:unbox())
	start_relative_position = Quaternion.rotate(rotation_diff, start_relative_position)
	local distance_from_target = Vector3.length(relative_position)
	local right_offset = Vector3.zero()
	local relative_unit_forward = Quaternion.forward(relative_unit_rotation)
	local projected_distance = Vector3.dot(relative_position, relative_unit_forward)

	if projected_distance < 0 then
		local turn_start_distance = 10
		local turn_end_distance = 1
		distance_from_target = math.abs(projected_distance)
		local curve_t = math.ilerp(turn_start_distance, turn_end_distance, distance_from_target) + math.ilerp(turn_end_distance, 0, distance_from_target) * 0.5
		local t_speed = self._speed / distance_from_target * dt
		curve_t = curve_t + t_speed
		local current_offset = (3 * curve_t * curve_t - 2 * curve_t * curve_t * curve_t) * max_arc_offset
		current_offset = math.clamp(current_offset, 0, max_arc_offset)
		local relative_right = Quaternion.right(relative_unit_rotation)
		right_offset = relative_right * current_offset * math.sign(Vector3.dot(relative_right, relative_position))
	end

	if move_data.lookat_unit then
		self:update_lookat_position(Unit.local_position(relative_unit, 1))
	end

	local wanted_pos = target_position + relative_unit_forward * math.sign(projected_distance) * math.max(distance_from_target - self._speed, 0) + right_offset
	wanted_pos[3] = wanted_pos[3] + self._current_float_z_offset
	local move = wanted_pos - servitor_pos
	local move_length = Vector3.length(move)
	local slow_down_distance = 2
	local min_speed_multiplier = 0.025
	local speed_multiplier = 1

	if move_length < slow_down_distance then
		speed_multiplier = math.max(move_length / slow_down_distance, min_speed_multiplier)
	else
		local distance_from_start = Vector3.length(servitor_pos - move_data.start_position:unbox())

		if distance_from_start < slow_down_distance then
			speed_multiplier = math.max(distance_from_start / slow_down_distance, min_speed_multiplier)
		end
	end

	local snap_distance = self._speed * dt * speed_multiplier

	if move_length < snap_distance then
		Unit.set_local_position(self._unit, 1, wanted_pos)

		if move_data.stop_at_arrival then
			self._movement_state = MOVEMENT_STATES.still
		end

		self._velocity:store(Vector3.zero())
	else
		local velocity = Vector3.normalize(move) * self._speed * speed_multiplier

		self._velocity:store(velocity)
	end
end

TrainingGroundsServitorHandler.move_to_unit_relative_direct = function (self, relative_unit, relative_position, relative_to_unit_rotation, stop_at_arrival)
	self._move_direct_data = {
		relative_unit = relative_unit,
		relative_position = Vector3Box(relative_position),
		relative_to_unit_rotation = relative_to_unit_rotation,
		stop_at_arrival = stop_at_arrival
	}
	self._movement_state = MOVEMENT_STATES.direct
end

TrainingGroundsServitorHandler._calculate_direct = function (self, dt)
	local move_data = self._move_direct_data
	local relative_unit = move_data.relative_unit

	if not ALIVE[relative_unit] then
		self._movement_state = MOVEMENT_STATES.still

		return
	end

	local relative_position = move_data.relative_position:unbox()
	local move_to_pos = get_relative_position_rotation(relative_unit, relative_position, move_data.rotate_position_relative_to_unit)
	move_to_pos[3] = move_to_pos[3] + self._current_float_z_offset

	self._move_to_pos:store(move_to_pos)

	local current_position = Unit.local_position(self._unit, 1)
	local move = move_to_pos - current_position

	if Vector3.length_squared(move) < self._speed * self._speed * dt * dt then
		Unit.set_local_position(self._unit, 1, move_to_pos)

		if move_data.stop_at_arrival then
			self._movement_state = MOVEMENT_STATES.still

			self._velocity:store(Vector3.zero())
		end
	else
		local velocity = Vector3.normalize(move) * self._speed

		self._velocity:store(velocity)
	end
end

TrainingGroundsServitorHandler.move_idle = function (self, relative_unit, reset_lookat)
	self._move_idle_data = {
		relative_unit = relative_unit
	}
	self._movement_state = MOVEMENT_STATES.idle

	if reset_lookat then
		self._lookat_data.use_velocity = true
	end
end

TrainingGroundsServitorHandler._calculate_idle = function (self, dt, t)
	local move_data = self._move_idle_data
	local relative_unit = move_data.relative_unit

	if not ALIVE[relative_unit] then
		self._movement_state = MOVEMENT_STATES.still

		return
	end

	local idle_circle_radius = self._idle_circle_radius
	local height_above_unit = 5
	local idle_circle_position, relative_unit_rotation = get_relative_position_rotation(relative_unit, Vector3(0, 3, height_above_unit), true)
	local delta = Vector3.flat(Unit.local_position(self._unit, 1) - idle_circle_position)
	local closest_point_delta = Vector3.normalize(delta) * idle_circle_radius
	local wanted_pos = idle_circle_position + Quaternion.rotate(self._idle_next_point_rotation:unbox(), closest_point_delta)
	wanted_pos[3] = wanted_pos[3] + self._current_float_z_offset
	local move = wanted_pos - Unit.local_position(self._unit, 1)
	local velocity = Vector3.normalize(move) * self._idle_speed

	self._velocity:store(velocity)
end

TrainingGroundsServitorHandler.destroy = function (self)
	return
end

TrainingGroundsServitorHandler._handle_lookat = function (self, dt)
	local lookat_data = self._lookat_data
	local velocity = self._velocity:unbox()
	local unit = self._unit
	local lookat_pos = nil

	if lookat_data.use_velocity then
		local velocity = self._velocity:unbox()
		local sqr_speed = Vector3.length_squared(velocity)

		if sqr_speed < 0.0001 then
			return
		end

		lookat_pos = Unit.local_position(unit, 1) + velocity
	else
		lookat_pos = lookat_data.lookat_pos:unbox()
	end

	local delta = Vector3.flat(lookat_pos - Unit.local_position(unit, 1))
	local target_rotation = Quaternion.look(delta, Vector3.cross(Vector3.cross(delta, Vector3.up()), delta))
	local current_rotation = Unit.local_rotation(unit, 1)
	local angle = Quaternion.angle(current_rotation, target_rotation)

	if angle > 0 then
		local lerp_t = math.ilerp(0, angle, self._rotation_speed * dt)
		local new_rotation = Quaternion.lerp(current_rotation, target_rotation, lerp_t)

		Unit.set_local_rotation(unit, 1, new_rotation)
	end
end

TrainingGroundsServitorHandler._handle_floating_z_offset = function (self, dt, t)
	local target_z_offset = math.sin(t * self._float_z_speed) * self._float_z_offset_magnitude
	local current_z_offset = self._current_float_z_offset
	local position = Unit.local_position(self._unit, 1)
	position[3] = position[3] + target_z_offset - current_z_offset

	Unit.set_local_position(self._unit, 1, position)

	self._current_float_z_offset = target_z_offset
end

TrainingGroundsServitorHandler.interactee_extension = function (self)
	return self._interactee_extension
end

TrainingGroundsServitorHandler.movement_state = function (self)
	return self._movement_state
end

return TrainingGroundsServitorHandler
