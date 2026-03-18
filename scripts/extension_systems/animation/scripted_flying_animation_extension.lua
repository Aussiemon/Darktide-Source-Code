-- chunkname: @scripts/extension_systems/animation/scripted_flying_animation_extension.lua

local ScriptedFlyingAnimationExtension = class("ScriptedFlyingAnimationExtension")

ScriptedFlyingAnimationExtension.init = function (self, extension_init_context, unit, extension_init_data)
	local breed = extension_init_data.breed

	self._breed = breed
	self._unit = unit
	self._is_server = extension_init_context.is_server

	local settings = breed.scripted_animation_settings

	self._anim_node = settings.animation_node and Unit.node(unit, settings.animation_node) or 1
	self._idle_offset = settings.idle_offset
	self._idle_rotation_offset = settings.idle_rotation_offset
	self._idle_rotation_force_axis = settings.idle_rotation_force_axis or nil
	self._rotation_offset = settings.rotation_offset or {
		0,
		0,
		0,
	}
	self._visual_rotation_node = Unit.node(self._unit, "anim_global")
	self._corner_lean = settings.corner_lean or 0
	self._max_speed_corner_lean = settings.max_speed_corner_lean or self._corner_lean
	self._max_rotation_speed = settings.max_rotation_speed or 0
	self._max_lean_at_speed = settings.max_lean_at_speed or 0
	self._rotation_stiffness = settings.rotation_stiffness or 0
	self._lean_rotation_acceleration = settings.lean_rotation_acceleration
	self._max_speed_lean_rotation_acceleration = settings.max_speed_lean_rotation_acceleration
	self._max_lean_rotation_speed = settings.max_lean_rotation_speed or 0
	self._reference_distance = settings.reference_forward_distance or 1
	self._override_max_speed = nil
	self._hover_lean_limit = settings.hover_lean_limit
	self._current_rotation_speed = 0
	self._current_lean = 0
	self._current_lean_rotation_speed = 0
	self._angular_velocity = Vector3Box(Vector3.zero())
	self._lean_angular_velocity = Vector3Box(Vector3.zero())
	self._current_rotation_without_lean = QuaternionBox(Unit.local_rotation(unit, self._anim_node))
	self._goal_random_rotation = QuaternionBox(Quaternion.identity())
	self._last_target_rotation = QuaternionBox(Quaternion.identity())
	self._last_to_goal = Vector3Box(Vector3(1, 0, 0))
	self._lean_rot = QuaternionBox(Quaternion.identity())
	self._poi_ignore_reasons = {}

	local spawn_rotation_offset = settings.spawn_rotation_offset

	if spawn_rotation_offset then
		local node_name = spawn_rotation_offset.node_name
		local offset = spawn_rotation_offset.offset
		local rotation_offset = Quaternion.axis_angle(Vector3.right(), math.degrees_to_radians(offset[1]))

		rotation_offset = Quaternion.multiply(Quaternion.axis_angle(Vector3.forward(), math.degrees_to_radians(offset[2])), rotation_offset)
		rotation_offset = Quaternion.multiply(Quaternion.axis_angle(Vector3.up(), math.degrees_to_radians(offset[3])), rotation_offset)

		Unit.set_local_rotation(unit, node_name and Unit.node(unit, node_name) or 1, rotation_offset)
	end
end

ScriptedFlyingAnimationExtension.extensions_ready = function (self, world, unit)
	self._navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	self._locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	self._last_target_rotation:store(Unit.local_rotation(unit, 1))
end

ScriptedFlyingAnimationExtension.update = function (self, unit, dt, t)
	if not self._is_server then
		return
	end

	local poi, new_poi = self:_point_of_interest(unit)
	local has_poi = poi ~= nil and table.is_empty(self._poi_ignore_reasons)

	new_poi = new_poi and (has_poi or has_poi ~= self._had_poi)
	self._had_poi = has_poi

	local is_goal
	local unit_pos = Unit.world_position(self._unit, self._anim_node)
	local has_path = self._navigation_extension:is_following_path()

	if has_path then
		local target_pos, second_last_index

		target_pos, is_goal, second_last_index = self._navigation_extension:position_ahead_on_path(self._reference_distance)

		local to_goal = target_pos - unit_pos
		local approaching_goal_progress

		if is_goal then
			local distance_left = self._navigation_extension:remaining_distance_from_progress_to_end_of_path()
			local distance_covered = self._navigation_extension:distance_to_progress_on_path()
			local total_distance = distance_left + distance_covered

			if total_distance < self._reference_distance then
				local break_point = total_distance * 0.5

				if break_point < distance_covered then
					approaching_goal_progress = (distance_covered - break_point) / (total_distance - break_point)
				end

				if not self._had_goal then
					local current_rot = Unit.local_rotation(unit, 1)
					local best_rotation, least_angle = nil, math.huge

					for i = -1, 2 do
						local rot = Quaternion.look(Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), i * math.pi * 0.5), Vector3.flat(to_goal)))
						local angle = Quaternion.angle(rot, current_rot)

						if angle < least_angle then
							best_rotation = rot
							least_angle = angle
						end
					end

					self._goal_random_rotation:store(best_rotation)
				end
			else
				approaching_goal_progress = 1 - distance_left / self._reference_distance

				if not self._had_goal then
					local second_last_pos = self._navigation_extension:path_node_position(second_last_index)
					local last_dir = target_pos - second_last_pos

					last_dir[3] = 0

					self._goal_random_rotation:store(Quaternion.look(last_dir, Vector3.up()))
				end
			end

			target_pos = self:_point_of_interest(unit) or target_pos
		end

		local to_target = target_pos - unit_pos

		to_target[3] = 0

		self._last_target_rotation:store(is_goal and self._goal_random_rotation:unbox() or Quaternion.look(to_target, Vector3.up()))

		self._last_approaching_goal_progress = approaching_goal_progress

		self._last_to_goal:store(to_goal)
	else
		is_goal = false

		local target_rot = self._last_target_rotation:unbox()

		target_rot = Quaternion.flat_no_roll(target_rot)

		self._last_target_rotation:store(target_rot)
	end

	local target_rotation = self._last_target_rotation:unbox()

	if has_poi then
		local to_poi = poi - unit_pos
		local to_poi_flat = Vector3.flat(to_poi)

		if Vector3.length_squared(to_poi_flat) > 1e-06 then
			local to_poi_rot = Quaternion.look(to_poi, Vector3.up())
			local to_poi_flat_rot = Quaternion.look(to_poi_flat, Vector3.up())
			local angle = Quaternion.angle(to_poi_rot, to_poi_flat_rot)
			local limit = self._hover_lean_limit

			if limit < angle then
				target_rotation = Quaternion.lerp(to_poi_flat_rot, to_poi_rot, limit / angle)
			else
				target_rotation = to_poi_rot
			end
		end
	end

	local to_goal = self._last_to_goal:unbox()
	local approaching_goal_progress = self._last_approaching_goal_progress or nil

	self:_apply_rotation(target_rotation, to_goal, dt, approaching_goal_progress, has_poi, new_poi, has_path)

	self._had_goal = is_goal
end

ScriptedFlyingAnimationExtension._apply_lean = function (self, rotation, to_goal, dt, optional_approaching_goal_progress, has_poi, has_path)
	local max_speed = self._navigation_extension:max_speed()
	local speed_multiplier = 1
	local wanted_lean

	if max_speed == 0 then
		wanted_lean = self._max_speed_corner_lean
	else
		local current_velocity = self._locomotion_extension:current_velocity()

		wanted_lean = math.lerp(self._corner_lean, self._max_speed_corner_lean, math.clamp01(Vector3.length(current_velocity) / math.min(self._max_lean_at_speed, max_speed)))
	end

	if not has_path then
		wanted_lean = 0
	elseif optional_approaching_goal_progress then
		local pull_back = 0.8
		local break_p = math.clamp01(math.ease_in_out_sine(optional_approaching_goal_progress / pull_back))

		wanted_lean = math.lerp(wanted_lean, -self._corner_lean, break_p)
		speed_multiplier = math.lerp(2, 0.75, break_p)

		if pull_back < optional_approaching_goal_progress then
			local plane_out_p = math.ease_in_out_sine(math.clamp01((optional_approaching_goal_progress - pull_back) / (1 - pull_back)))

			wanted_lean = math.lerp(wanted_lean, 0, plane_out_p)
		end
	end

	local forward = Vector3.normalize(to_goal, Vector3.up())
	local perp_vec = Vector3.normalize(Vector3.cross(forward, Vector3.up()))
	local wanted_lean_rot = Quaternion.axis_angle(perp_vec, wanted_lean)
	local stiffness

	if max_speed == 0 then
		stiffness = self._lean_rotation_acceleration
	else
		local current_velocity = self._locomotion_extension:current_velocity()

		stiffness = math.lerp(self._lean_rotation_acceleration, self._max_speed_lean_rotation_acceleration, math.clamp01(Vector3.length(current_velocity) / max_speed))
	end

	stiffness = stiffness * speed_multiplier

	local damping = 2 * math.sqrt(stiffness)
	local current_lean_rot = self._lean_rot:unbox()
	local delta = Quaternion.multiply(wanted_lean_rot, Quaternion.inverse(current_lean_rot))
	local x, y, z, w = Quaternion.to_elements(delta)

	if w < 0 then
		delta = Quaternion.from_elements(-x, -y, -z, -w)
		x, y, z, w = Quaternion.to_elements(delta)
	end

	local xyz = Vector3(x, y, z)
	local half_angle = math.acos(math.clamp(w, -1, 1))
	local sin_half = math.sin(half_angle)
	local angular_displacement

	if sin_half > 1e-06 then
		angular_displacement = xyz / sin_half * (2 * half_angle)
	else
		angular_displacement = xyz * 2
	end

	local angular_velocity = self._lean_angular_velocity:unbox()

	angular_velocity = angular_velocity + (angular_displacement * stiffness - angular_velocity * damping) * dt

	local speed = Vector3.length(angular_velocity)

	if speed > self._max_lean_rotation_speed then
		angular_velocity = angular_velocity * (self._max_lean_rotation_speed / speed)
		speed = self._max_lean_rotation_speed
	end

	self._lean_angular_velocity:store(angular_velocity)

	local step_angle = speed * dt
	local new_lean_rot

	if step_angle > 1e-06 then
		local step_quat = Quaternion.axis_angle(Vector3.normalize(angular_velocity), step_angle)

		new_lean_rot = Quaternion.multiply(step_quat, current_lean_rot)
	else
		new_lean_rot = current_lean_rot
	end

	self._lean_rot:store(new_lean_rot)

	return Quaternion.multiply(new_lean_rot, rotation)
end

ScriptedFlyingAnimationExtension._apply_rotation = function (self, target_rotation, to_goal, dt, optional_approaching_goal_progress, has_poi, new_poi, has_path)
	if self._anim_node ~= 1 then
		local right, forward, up = Quaternion.right(target_rotation), Quaternion.forward(target_rotation), Quaternion.up(target_rotation)
		local rotation_offset = self._rotation_offset

		target_rotation = Quaternion.multiply(Quaternion.axis_angle(right, math.degrees_to_radians(rotation_offset[1])), target_rotation)
		target_rotation = Quaternion.multiply(Quaternion.axis_angle(forward, math.degrees_to_radians(rotation_offset[2])), target_rotation)
		target_rotation = Quaternion.multiply(Quaternion.axis_angle(up, math.degrees_to_radians(rotation_offset[3])), target_rotation)
	end

	local current_rotation = self._current_rotation_without_lean:unbox()
	local delta = Quaternion.multiply(target_rotation, Quaternion.inverse(current_rotation))
	local x, y, z, w = Quaternion.to_elements(delta)

	if w < 0 then
		delta = Quaternion.from_elements(-x, -y, -z, -w)
		x, y, z, w = Quaternion.to_elements(delta)
	end

	local xyz = Vector3(x, y, z)
	local half_angle = math.acos(math.clamp(w, -1, 1))
	local sin_half = math.sin(half_angle)
	local angular_displacement

	if sin_half > 1e-06 then
		angular_displacement = xyz / sin_half * (2 * half_angle)
	else
		angular_displacement = xyz * 2
	end

	local stiffness = self._rotation_stiffness
	local damping = 2 * math.sqrt(stiffness)
	local angular_velocity = self._angular_velocity:unbox()

	angular_velocity = angular_velocity + (angular_displacement * stiffness - angular_velocity * damping) * dt

	local speed = Vector3.length(angular_velocity)

	if speed > self._max_rotation_speed then
		angular_velocity = angular_velocity * (self._max_rotation_speed / speed)
	end

	self._angular_velocity:store(angular_velocity)

	local step_angle = Vector3.length(angular_velocity) * dt
	local wanted_rotation

	if step_angle > 1e-06 then
		local step_quat = Quaternion.axis_angle(Vector3.normalize(angular_velocity), step_angle)

		wanted_rotation = Quaternion.multiply(step_quat, current_rotation)
	else
		wanted_rotation = current_rotation
	end

	self._current_rotation_without_lean:store(wanted_rotation)

	wanted_rotation = self:_apply_lean(wanted_rotation, to_goal, dt, optional_approaching_goal_progress, has_poi, has_path)

	local parent_node = Unit.scene_graph_parent(self._unit, self._anim_node)
	local wanted_local = parent_node and Quaternion.multiply(wanted_rotation, Quaternion.inverse(Unit.world_rotation(self._unit, parent_node))) or wanted_rotation

	Unit.set_local_rotation(self._unit, self._anim_node, wanted_local)
end

ScriptedFlyingAnimationExtension._point_of_interest = function (self, unit)
	local blackboard = BLACKBOARDS[unit]
	local perception_component = blackboard.perception
	local target_unit = perception_component.target_unit

	if HEALTH_ALIVE[target_unit] then
		local new_point_of_interest = self._last_poi ~= target_unit

		self._last_poi = target_unit

		return Unit.local_position(target_unit, 1), new_point_of_interest
	end

	return nil
end

ScriptedFlyingAnimationExtension.set_ignore_poi_reason = function (self, reason, ignore)
	ignore = ignore or nil
	self._poi_ignore_reasons[reason] = ignore
end

return ScriptedFlyingAnimationExtension
