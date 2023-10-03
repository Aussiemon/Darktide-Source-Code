local FootIk = component("FootIk")

FootIk.init = function (self, unit)
	self.in_editor = false

	if DEDICATED_SERVER then
		return false
	end

	local use_foot_ik = Managers.state.game_mode:use_foot_ik()

	if not use_foot_ik then
		return false
	end

	self._unit = unit
	self._world = Unit.world(self._unit)
	self._physics_world = World.physics_world(self._world)

	self:_instantiate_ik_data()

	return true
end

FootIk.editor_init = function (self, unit)
	self._in_level_editor = rawget(_G, "LevelEditor") ~= nil

	if self._in_level_editor then
		self._should_debug_draw = true
		self.in_editor = true
		self.active_in_editor = self:get_data(unit, "active_in_editor")
		self._unit = unit
		self._world = Unit.world(unit)
		self._physics_world = World.physics_world(self._world)
		self._line_object = World.create_line_object(self._world)
		self._drawer = DebugDrawer(self._line_object, "retained")

		self:_instantiate_ik_data()

		return self.active_in_editor
	end
end

local TEMP_MISSING_NODE_NAMES = {}

FootIk.editor_validate = function (self, unit)
	local success = true
	local error_message = ""
	local num_missing_node_names = 0
	local node_names_to_validate = {
		self:get_data(unit, "hips_handle"),
		self:get_data(unit, "left_handle"),
		self:get_data(unit, "right_handle"),
		self:get_data(unit, "left_handle_ref"),
		self:get_data(unit, "hips_handle_ref"),
		self:get_data(unit, "right_handle_ref"),
		self:get_data(unit, "left_orient_ref"),
		self:get_data(unit, "right_orient_ref"),
		self:get_data(unit, "left_orient_handle"),
		self:get_data(unit, "right_orient_handle"),
		self:get_data(unit, "grounded_node"),
		"j_leftupleg",
		"j_rightupleg",
		"j_leftleg",
		"j_rightleg",
		"j_leftfoot",
		"j_rightfoot"
	}
	local contains_empty = false

	for i = 1, #node_names_to_validate do
		local node_name = node_names_to_validate[i]

		if node_name == "" then
			contains_empty = true
		elseif not Unit.has_node(unit, node_name) then
			num_missing_node_names = num_missing_node_names + 1
			TEMP_MISSING_NODE_NAMES[num_missing_node_names] = node_name
		end
	end

	if contains_empty then
		success = false
		error_message = "\nComponent contains empty node name"
	end

	if num_missing_node_names > 0 then
		success = false

		table.sort(TEMP_MISSING_NODE_NAMES)

		local missing_node_names_string = table.concat(TEMP_MISSING_NODE_NAMES, "\n\t")

		table.clear_array(TEMP_MISSING_NODE_NAMES, #TEMP_MISSING_NODE_NAMES)

		error_message = error_message .. string.format("\nThe following unit nodes are missing:\n\t%s", missing_node_names_string)
	end

	return success, error_message
end

FootIk._instantiate_ik_data = function (self)
	self._detect_surface_enabled = self:get_data(self._unit, "detect_surface_enabled")
	self._lean_in_acceleration_enabled = self:get_data(self._unit, "lean_in_acceleration_enabled")
	self._distance_warp_enabled = self:get_data(self._unit, "distance_warp_enabled")
	self._hips_handle = Unit.node(self._unit, self:get_data(self._unit, "hips_handle"))
	self._left_handle = Unit.node(self._unit, self:get_data(self._unit, "left_handle"))
	self._right_handle = Unit.node(self._unit, self:get_data(self._unit, "right_handle"))
	self._left_handle_ref = Unit.node(self._unit, self:get_data(self._unit, "left_handle_ref"))
	self._left_handle_ref_parent = Unit.scene_graph_parent(self._unit, self._left_handle_ref)
	self._hips_handle_ref = Unit.node(self._unit, self:get_data(self._unit, "hips_handle_ref"))
	self._hips_handle_ref_parent = Unit.scene_graph_parent(self._unit, self._hips_handle_ref)
	self._right_handle_ref = Unit.node(self._unit, self:get_data(self._unit, "right_handle_ref"))
	self._right_handle_ref_parent = Unit.scene_graph_parent(self._unit, self._right_handle_ref)
	self._left_orient_ref = Unit.node(self._unit, self:get_data(self._unit, "left_orient_ref"))
	self._left_orient_ref_parent = Unit.scene_graph_parent(self._unit, self._left_orient_ref)
	self._right_orient_ref = Unit.node(self._unit, self:get_data(self._unit, "right_orient_ref"))
	self._right_orient_ref_parent = Unit.scene_graph_parent(self._unit, self._right_orient_ref)
	self._left_orient_handle = Unit.node(self._unit, self:get_data(self._unit, "left_orient_handle"))
	self._right_orient_handle = Unit.node(self._unit, self:get_data(self._unit, "right_orient_handle"))
	self._left_upleg = Unit.node(self._unit, "j_leftupleg")
	self._right_upleg = Unit.node(self._unit, "j_rightupleg")
	self._left_leg_length = Vector3.length(Unit.local_position(self._unit, Unit.node(self._unit, "j_leftleg"))) + Vector3.length(Unit.local_position(self._unit, Unit.node(self._unit, "j_leftfoot")))
	self._right_leg_length = Vector3.length(Unit.local_position(self._unit, Unit.node(self._unit, "j_rightleg"))) + Vector3.length(Unit.local_position(self._unit, Unit.node(self._unit, "j_rightfoot")))
	self._grounded_node = Unit.node(self._unit, self:get_data(self._unit, "grounded_node"))

	self:_refresh_slider_values()

	self._distance_warp_sample = {}
	self._surface_sample = {}
	self._leaning_sample = {}
	self._past_surface_sample = {
		hips = {},
		left = {},
		right = {}
	}
	self._past_leaning_sample = {}
	local init_hips_pos = Unit.local_position(self._unit, self._hips_handle)
	local init_hips_rot = Unit.local_rotation(self._unit, self._hips_handle)
	local init_left_pos = Unit.local_position(self._unit, self._left_handle)
	local init_left_rot = Unit.local_rotation(self._unit, self._left_handle)
	local init_right_pos = Unit.local_position(self._unit, self._right_handle)
	local init_right_rot = Unit.local_rotation(self._unit, self._right_handle)
	self._past_leaning_sample.move = Vector3Box(init_hips_pos)
	self._past_leaning_sample.orient = QuaternionBox(init_hips_rot)
	self._past_surface_sample.hips.move = Vector3Box(init_hips_pos)
	self._past_surface_sample.hips.orient = QuaternionBox(init_hips_rot)
	self._past_surface_sample.left.move = Vector3Box(init_left_pos)
	self._past_surface_sample.left.orient = QuaternionBox(init_left_rot)
	self._past_surface_sample.right.move = Vector3Box(init_right_pos)
	self._past_surface_sample.right.orient = QuaternionBox(init_right_rot)
end

FootIk.enable = function (self, unit)
	return
end

FootIk.disable = function (self, unit)
	return
end

FootIk.destroy = function (self, unit)
	return
end

FootIk.sampling = function (self, surface_sample, past_surface_sample, leaning_sample, past_leaning_sample, distance_warp_sample)
	local unit_pose = Unit.world_pose(self._unit, 1)
	local left_ref_pos = Unit.world_position(self._unit, self._left_handle_ref)
	local right_ref_pos = Unit.world_position(self._unit, self._right_handle_ref)
	local left_ref_pose = Unit.world_pose(self._unit, self._left_handle_ref)
	local right_ref_pose = Unit.world_pose(self._unit, self._right_handle_ref)
	local feet_weight_sample = self:_get_feet_grounded_weights()

	if self._distance_warp_enabled then
		left_ref_pos, right_ref_pos, distance_warp_sample = self:_distance_warp_sampling(left_ref_pos, right_ref_pos, distance_warp_sample)
	end

	if self._detect_surface_enabled then
		self:_surface_sampling(unit_pose, left_ref_pose, right_ref_pose, feet_weight_sample, surface_sample, past_surface_sample)
	end

	if self._lean_in_acceleration_enabled then
		self:_lean_in_acceleration_sampling(leaning_sample, past_leaning_sample)
	end

	return surface_sample, leaning_sample, distance_warp_sample
end

FootIk._get_feet_grounded_weights = function (self)
	local grounded_pos = Unit.local_position(self._unit, self._grounded_node)

	return {
		left = grounded_pos.x,
		right = grounded_pos.y
	}
end

FootIk.feet_are_on_ground = function (self)
	local feet_weights = self:_get_feet_grounded_weights()
	local avg = (feet_weights.left + feet_weights.right) * 0.5

	return avg > 0.25
end

FootIk._distance_warp_sampling = function (self, left_ref_pos, right_ref_pos, distance_warp_sample)
	local left_ref_parent_inv_m = Unit.world_pose(self._unit, self._left_handle_ref_parent)
	local right_ref_parent_inv_m = Unit.world_pose(self._unit, self._right_handle_ref_parent)
	local left_ref_local_pos = Unit.local_position(self._unit, self._left_handle_ref)
	local right_ref_local_pos = Unit.local_position(self._unit, self._right_handle_ref)
	distance_warp_sample.left = Vector3(left_ref_local_pos.x, left_ref_local_pos.y * self._warp_distance_test, left_ref_local_pos.z)

	Vector3.set_y(left_ref_local_pos, left_ref_local_pos.y + distance_warp_sample.left.y)

	left_ref_pos = Matrix4x4.translation(Matrix4x4.multiply(Matrix4x4.from_translation(left_ref_local_pos), left_ref_parent_inv_m))
	distance_warp_sample.right = Vector3(right_ref_local_pos.x, right_ref_local_pos.y * self._warp_distance_test, right_ref_local_pos.z)

	Vector3.set_y(right_ref_local_pos, right_ref_local_pos.y + distance_warp_sample.right.y)

	right_ref_pos = Matrix4x4.translation(Matrix4x4.multiply(Matrix4x4.from_translation(right_ref_local_pos), right_ref_parent_inv_m))
	distance_warp_sample.hips = Vector3.zero()

	if self._warp_distance_test > 0 then
		distance_warp_sample.hips = Vector3.down() * self._warp_distance_test * self.warp_distance_hips * Vector3.distance(left_ref_pos, right_ref_pos)
	end

	return left_ref_pos, right_ref_pos, distance_warp_sample
end

local hit_types = table.enum("none", "down", "up")

FootIk._raycast_surface = function (self, from_pose, ray_distance, is_left)
	local from_pos = Matrix4x4.translation(from_pose) + Vector3.up() * ray_distance
	local to_pos = Matrix4x4.translation(from_pose) - Vector3.up() * ray_distance
	local from_rot = Quaternion.look(Vector3.down(), Matrix4x4.forward(from_pose))
	local sweep_results = PhysicsWorld.linear_obb_sweep(self._physics_world, from_pos, to_pos, Vector3(self._foot_width, self._foot_width, self._foot_length), from_rot, 5, "collision_filter", "filter_player_character_foot_ik", "report_initial_overlap")
	local hit = sweep_results ~= nil
	local hit_type = hit_types.none

	if hit then
		local hit_distance = from_pos.z - sweep_results[1].position.z
		local surface_normal = sweep_results[1].normal

		if ray_distance < hit_distance then
			hit_type = hit_types.down
			hit_distance = hit_distance - ray_distance
		else
			hit_type = hit_types.up
			hit_distance = ray_distance - hit_distance
		end

		return hit_type, hit_distance, surface_normal
	else
		return hit_type, 0, Vector3.up()
	end
end

FootIk._get_handle_movement_to_surface = function (self, hit_distance, weight, hit_type)
	if hit_type == hit_types.down then
		return Vector3.down() * hit_distance * weight
	elseif hit_type == hit_types.up then
		return Vector3.up() * hit_distance * weight
	else
		return Vector3.zero()
	end
end

FootIk._get_handle_orientation_to_surface = function (self, orient_ref, weight, orient_ref_parent, surface_normal)
	if surface_normal == Vector3.up() then
		return Matrix4x4.zero()
	end

	local orient_ref_m = Unit.world_pose(self._unit, orient_ref)

	Matrix4x4.set_up(orient_ref_m, surface_normal)
	Matrix4x4.set_forward(orient_ref_m, Vector3.cross(Matrix4x4.up(orient_ref_m), Matrix4x4.right(orient_ref_m)))

	local inv_parent_m = Matrix4x4.inverse(Unit.world_pose(self._unit, orient_ref_parent))

	return Quaternion.lerp(Unit.local_rotation(self._unit, orient_ref), Matrix4x4.rotation(Matrix4x4.multiply(orient_ref_m, inv_parent_m)), weight * self.feet_orient_factor)
end

FootIk._get_foot_surface_data = function (self, unit_pose, foot_pose, weight, orient_ref, orient_ref_p, inv_forward)
	local surface_data = {}
	local unit_pos = Matrix4x4.translation(unit_pose)
	local foot_pos = Matrix4x4.translation(foot_pose)
	local from_pos = Vector3(foot_pos.x, foot_pos.y, unit_pos.z)
	local foot_orient = Matrix4x4.rotation(foot_pose)
	local flat_foot_forward = Vector3.flat(Quaternion.forward(foot_orient))

	if inv_forward then
		flat_foot_forward = -flat_foot_forward
	end

	local flat_foot_orient = Quaternion.look(flat_foot_forward, Vector3.up())
	from_pos = from_pos + flat_foot_forward * 0.2
	local from_pose = Matrix4x4.from_quaternion_position(flat_foot_orient, from_pos)
	local hit_type, hit_distance, surface_normal = self:_raycast_surface(from_pose, self.raycast_distance)
	surface_data.move = self:_get_handle_movement_to_surface(hit_distance, weight, hit_type)
	surface_data.orient = self:_get_handle_orientation_to_surface(orient_ref, weight, orient_ref_p, surface_normal)
	surface_data.hit_type = hit_type
	surface_data.hit_distance = hit_distance

	return surface_data
end

FootIk._surface_sampling = function (self, unit_pose, left_ref_pose, right_ref_pose, feet_weights, surface_sample, past_surface_sample)
	surface_sample.left = self:_get_foot_surface_data(unit_pose, left_ref_pose, feet_weights.left, self._left_orient_ref, self._left_orient_ref_parent, false)
	surface_sample.right = self:_get_foot_surface_data(unit_pose, right_ref_pose, feet_weights.right, self._right_orient_ref, self._right_orient_ref_parent, true)
	surface_sample.hips = {
		move = Vector3.zero()
	}

	if surface_sample.left.hit_type == hit_types.down and surface_sample.right.hit_type == hit_types.down then
		if surface_sample.left.hit_distance * feet_weights.left > surface_sample.right.hit_distance * feet_weights.right then
			surface_sample.hips.move = Vector3(0, 0, surface_sample.left.move.z)
		else
			surface_sample.hips.move = Vector3(0, 0, surface_sample.right.move.z)
		end
	elseif surface_sample.left.hit_type == hit_types.down then
		surface_sample.hips.move = Vector3(0, 0, surface_sample.left.move.z)
	elseif surface_sample.right.hit_type == hit_types.down then
		surface_sample.hips.move = Vector3(0, 0, surface_sample.right.move.z)
	end

	surface_sample.hips.move = Vector3.lerp(Vector3Box.unbox(past_surface_sample.hips.move), surface_sample.hips.move, self.dt * self.hips_move_speed)
	surface_sample.left.move = Vector3.lerp(Vector3Box.unbox(past_surface_sample.left.move), surface_sample.left.move, self.dt * self.feet_move_speed)
	surface_sample.right.move = Vector3.lerp(Vector3Box.unbox(past_surface_sample.right.move), surface_sample.right.move, self.dt * self.feet_move_speed)
	surface_sample.left.orient = Quaternion.lerp(QuaternionBox.unbox(past_surface_sample.left.orient), surface_sample.left.orient, self.dt * self.feet_orient_speed)
	surface_sample.right.orient = Quaternion.lerp(QuaternionBox.unbox(past_surface_sample.right.orient), surface_sample.right.orient, self.dt * self.feet_orient_speed)
	past_surface_sample.hips.move = Vector3Box(surface_sample.hips.move)
	past_surface_sample.left.move = Vector3Box(surface_sample.left.move)
	past_surface_sample.right.move = Vector3Box(surface_sample.right.move)
	past_surface_sample.left.orient = QuaternionBox(surface_sample.left.orient)
	past_surface_sample.right.orient = QuaternionBox(surface_sample.right.orient)
end

FootIk._lean_in_acceleration_sampling = function (self, leaning_sample, past_leaning_sample)
	local velocity_current, velocity_wanted = nil

	if self.in_editor then
		velocity_current = Vector3.zero()

		Vector3.set_xyz(velocity_current, self.velocity_test_x, self.velocity_test_y, 1)

		velocity_wanted = Vector3.zero()
		velocity_wanted.z = 1
	else
		velocity_current = self._locomotion_component.velocity_current
		velocity_wanted = self._locomotion_steering_component.velocity_wanted
	end

	local orient_hips_w = Unit.world_pose(self._unit, self._hips_handle_ref)
	local up_vector = Vector3.zero()
	local current_speed = Vector3.length(velocity_current)
	local lean_speed_scale_t = (current_speed - self.leaning_scale_min_vel) / (self.leaning_scale_max_vel - self.leaning_scale_min_vel)
	local lean_speed_scale = math.clamp(lean_speed_scale_t, 0, 1)
	local lean_scale = math.lerp(self.leaning_scale_min, self.leaning_scale_max, lean_speed_scale)
	local leaning = self.leaning * lean_scale
	local leaning_balance = self.leaning_balance * lean_scale
	local leaning_descend = self.leaning_descend * lean_scale

	Vector3.set_xyz(up_vector, (velocity_wanted.x - velocity_current.x) * leaning, (velocity_wanted.y - velocity_current.y) * leaning, 1)
	Matrix4x4.set_up(orient_hips_w, up_vector)

	local inv_parent_m = Matrix4x4.inverse(Unit.world_pose(self._unit, self._hips_handle_ref_parent))
	local hips_leaning_m = Matrix4x4.multiply(orient_hips_w, inv_parent_m)
	leaning_sample.orient = Matrix4x4.rotation(hips_leaning_m)
	local local_diff = Quaternion.rotate(Matrix4x4.rotation(inv_parent_m), velocity_wanted - velocity_current)
	local acc_diff = Vector3.distance(velocity_wanted, velocity_current)
	local ref_v = Matrix4x4.translation(hips_leaning_m)
	leaning_sample.move = Vector3(ref_v.x - local_diff.x * leaning_balance, ref_v.y - local_diff.y * leaning_balance, ref_v.z - acc_diff * leaning_descend)

	if Vector3.length(velocity_wanted) < current_speed then
		leaning_sample.move = Vector3.lerp(Vector3Box.unbox(past_leaning_sample.move), leaning_sample.move, self.dt * self.stop_balance_speed)
		leaning_sample.orient = Quaternion.lerp(QuaternionBox.unbox(past_leaning_sample.orient), leaning_sample.orient, self.dt * self.stop_leaning_speed)
	else
		leaning_sample.move = Vector3.lerp(Vector3Box.unbox(past_leaning_sample.move), leaning_sample.move, self.dt * self.start_balance_speed)
		leaning_sample.orient = Quaternion.lerp(QuaternionBox.unbox(past_leaning_sample.orient), leaning_sample.orient, self.dt * self.start_leaning_speed)
	end

	past_leaning_sample.move = Vector3Box(leaning_sample.move)
	past_leaning_sample.orient = QuaternionBox(leaning_sample.orient)
end

FootIk.solve_handles = function (self, surface_sample, leaning_sample, distance_warp_sample)
	local hips_pos = Vector3.zero()
	local hips_rot = Quaternion.identity()
	local left_pos = Vector3.zero()
	local left_rot = Quaternion.identity()
	local right_pos = Vector3.zero()
	local right_rot = Quaternion.identity()

	if self._lean_in_acceleration_enabled then
		hips_pos = leaning_sample.move
		hips_rot = leaning_sample.orient
	end

	if self._detect_surface_enabled then
		hips_pos = hips_pos + surface_sample.hips.move
		left_pos = surface_sample.left.move
		left_rot = surface_sample.left.orient
		right_pos = surface_sample.right.move
		right_rot = surface_sample.right.orient
	end

	if self._distance_warp_enabled then
		hips_pos = hips_pos + distance_warp_sample.hips

		Vector3.set_y(left_pos, left_pos.y + distance_warp_sample.left.y)
		Vector3.set_y(right_pos, right_pos.y + distance_warp_sample.right.y)
	end

	Unit.set_local_position(self._unit, self._hips_handle, hips_pos)
	Unit.set_local_rotation(self._unit, self._hips_handle, hips_rot)
	Unit.set_local_position(self._unit, self._left_handle, left_pos)
	Unit.set_local_rotation(self._unit, self._left_orient_handle, left_rot)
	Unit.set_local_position(self._unit, self._right_handle, right_pos)
	Unit.set_local_rotation(self._unit, self._right_orient_handle, right_rot)
end

FootIk.update = function (self, unit, dt, t)
	local fps_threshold = 15

	if dt < 1 / fps_threshold then
		local unit_data_extension = ScriptUnit.extension(self._unit, "unit_data_system")
		self._locomotion_component = unit_data_extension:read_component("locomotion")
		self._locomotion_steering_component = unit_data_extension:read_component("locomotion_steering")
		self._hub_jog_character_state_component = unit_data_extension:read_component("hub_jog_character_state")
		self.dt = dt

		table.clear(self._surface_sample)
		table.clear(self._leaning_sample)
		table.clear(self._distance_warp_sample)
		self:sampling(self._surface_sample, self._past_surface_sample, self._leaning_sample, self._past_leaning_sample, self._distance_warp_sample)
		self:solve_handles(self._surface_sample, self._leaning_sample, self._distance_warp_sample)
	end

	return true
end

FootIk.editor_update = function (self, unit, dt, t)
	if not self.active_in_editor then
		return false
	end

	if self._should_debug_draw then
		self._drawer:reset()
	else
		self._drawer:reset()
		self._drawer:update(self._world)
	end

	local fps_threshold = 15

	if dt < 1 / fps_threshold then
		self.dt = dt

		table.clear(self._surface_sample)
		table.clear(self._leaning_sample)
		table.clear(self._distance_warp_sample)
		self:sampling(self._surface_sample, self._past_surface_sample, self._leaning_sample, self._past_leaning_sample, self._distance_warp_sample)
		self:solve_handles(self._surface_sample, self._leaning_sample, self._distance_warp_sample)
	end

	if self._should_debug_draw then
		self._drawer:update(self._world)
	end

	return true
end

FootIk._refresh_slider_values = function (self)
	self.warp_distance_hips = self:get_data(self._unit, "warp_distance_hips")
	self._warp_distance_test = self:get_data(self._unit, "warp_distance_test")
	self.hips_move_speed = self:get_data(self._unit, "hips_move_speed")
	self.feet_move_speed = self:get_data(self._unit, "feet_move_speed")
	self.feet_orient_speed = self:get_data(self._unit, "feet_orient_speed")
	self.feet_orient_factor = self:get_data(self._unit, "feet_orient_factor")
	self.raycast_distance = self:get_data(self._unit, "raycast_distance")
	self._foot_length = self:get_data(self._unit, "foot_length")
	self._foot_width = self:get_data(self._unit, "foot_width")
	self.start_leaning_speed = self:get_data(self._unit, "start_leaning_speed")
	self.stop_leaning_speed = self:get_data(self._unit, "stop_leaning_speed")
	self.start_balance_speed = self:get_data(self._unit, "start_balance_speed")
	self.stop_balance_speed = self:get_data(self._unit, "stop_balance_speed")
	self.leaning = self:get_data(self._unit, "leaning")
	self.leaning_descend = self:get_data(self._unit, "leaning_descend")
	self.leaning_balance = self:get_data(self._unit, "leaning_balance")
	self.leaning_scale_min_vel = self:get_data(self._unit, "leaning_scale_min_vel")
	self.leaning_scale_max_vel = self:get_data(self._unit, "leaning_scale_max_vel")
	self.leaning_scale_min = self:get_data(self._unit, "leaning_scale_min")
	self.leaning_scale_max = self:get_data(self._unit, "leaning_scale_max")
	self.velocity_test_x = self:get_data(self._unit, "velocity_test_x")
	self.velocity_test_y = self:get_data(self._unit, "velocity_test_y")
end

FootIk.editor_property_changed = function (self, unit)
	self:_refresh_slider_values()
end

FootIk.editor_toggle_debug_draw = function (self, enable)
	self._should_debug_draw = enable
end

FootIk._editor_debug_draw = function (self)
	if self._should_debug_draw then
		self._drawer:reset()
		self._drawer:update(self._world)
	else
		self._drawer:reset()
		self._drawer:update(self._world)
	end
end

FootIk.editor_destroy = function (self, unit)
	if self._drawer and self._should_debug_draw then
		self._drawer:reset()
		self._drawer:update(self._world)
	end
end

FootIk.component_data = {
	active_in_editor = {
		ui_type = "check_box",
		value = false,
		ui_name = "Active in Editor",
		category = "Settings"
	},
	detect_surface_enabled = {
		ui_type = "check_box",
		value = true,
		ui_name = "Surface Detection",
		category = "Settings"
	},
	lean_in_acceleration_enabled = {
		ui_type = "check_box",
		value = true,
		ui_name = "Lean into Acceleration",
		category = "Settings"
	},
	distance_warp_enabled = {
		ui_type = "check_box",
		value = true,
		ui_name = "Distance Warping",
		category = "Settings"
	},
	warp_distance_hips = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		category = "Distance Warpnig",
		value = 0.07,
		decimals = 2,
		ui_name = "Warp Distance Hips",
		max = 1
	},
	warp_distance_test = {
		ui_type = "slider",
		min = -1,
		step = 0.01,
		category = "Distance Warpnig",
		value = 0,
		decimals = 2,
		ui_name = "Warp Distance Test",
		max = 1
	},
	animation_speed_test = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		category = "Distance Warpnig",
		value = 1,
		decimals = 2,
		ui_name = "Animation Speed Test",
		max = 2
	},
	hips_move_speed = {
		ui_type = "slider",
		min = 0.1,
		step = 0.01,
		category = "Surface Detection",
		value = 10,
		decimals = 2,
		ui_name = "Hips Move Speed",
		max = 50
	},
	feet_move_speed = {
		ui_type = "slider",
		min = 0.1,
		step = 0.01,
		category = "Surface Detection",
		value = 20,
		decimals = 2,
		ui_name = "Feet Move Speed",
		max = 50
	},
	feet_orient_speed = {
		ui_type = "slider",
		min = 0.1,
		step = 0.01,
		category = "Surface Detection",
		value = 10,
		decimals = 2,
		ui_name = "Feet Orient Speed",
		max = 50
	},
	feet_orient_factor = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		category = "Surface Detection",
		value = 1,
		decimals = 2,
		ui_name = "Feet Orient Factor",
		max = 2
	},
	raycast_distance = {
		ui_type = "slider",
		min = 0.1,
		step = 0.01,
		category = "Surface Detection",
		value = 0.45,
		decimals = 2,
		ui_name = "Raycast Distance",
		max = 1
	},
	foot_length = {
		ui_type = "slider",
		min = 0.01,
		step = 0.01,
		category = "Surface Detection",
		value = 0.1,
		decimals = 2,
		ui_name = "Foot Length",
		max = 1
	},
	foot_width = {
		ui_type = "slider",
		min = 0.01,
		step = 0.01,
		category = "Surface Detection",
		value = 0.06,
		decimals = 2,
		ui_name = "Foot Width",
		max = 1
	},
	start_leaning_speed = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		category = "Leaning Into Velocity",
		value = 0.5,
		decimals = 2,
		ui_name = "Start Leaning Speed",
		max = 10
	},
	stop_leaning_speed = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		category = "Leaning Into Velocity",
		value = 0.5,
		decimals = 2,
		ui_name = "Stop Leaning Speed",
		max = 10
	},
	start_balance_speed = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		category = "Leaning Into Velocity",
		value = 0.5,
		decimals = 2,
		ui_name = "Start Balance Speed",
		max = 10
	},
	stop_balance_speed = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		category = "Leaning Into Velocity",
		value = 0.5,
		decimals = 2,
		ui_name = "Stop Balance Speed",
		max = 10
	},
	leaning = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		category = "Leaning Into Velocity",
		value = 5,
		decimals = 2,
		ui_name = "Hips Leaning",
		max = 10
	},
	leaning_descend = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		category = "Leaning Into Velocity",
		value = 0.5,
		decimals = 2,
		ui_name = "Lean Descend",
		max = 1
	},
	leaning_balance = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		category = "Leaning Into Velocity",
		value = 0.5,
		decimals = 2,
		ui_name = "Lean Balance",
		max = 1
	},
	leaning_scale_min_vel = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		category = "Leaning Into Velocity",
		value = 2,
		decimals = 2,
		ui_name = "Lean Scale Min Speed",
		max = 10
	},
	leaning_scale_max_vel = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		category = "Leaning Into Velocity",
		value = 5,
		decimals = 2,
		ui_name = "Lean Scale Max Speed",
		max = 10
	},
	leaning_scale_min = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		category = "Leaning Into Velocity",
		value = 0,
		decimals = 2,
		ui_name = "Lean Scale Min",
		max = 1
	},
	leaning_scale_max = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		category = "Leaning Into Velocity",
		value = 1,
		decimals = 2,
		ui_name = "Lean Scale Max",
		max = 1
	},
	velocity_test_x = {
		ui_type = "slider",
		min = -1,
		step = 0.01,
		category = "Leaning Into Velocity",
		value = 0,
		decimals = 2,
		ui_name = "Velocity Test X",
		max = 1
	},
	velocity_test_y = {
		ui_type = "slider",
		min = -1,
		step = 0.01,
		category = "Leaning Into Velocity",
		value = 0,
		decimals = 2,
		ui_name = "Velocity Test Y",
		max = 1
	},
	hips_handle = {
		ui_type = "text_box",
		value = "",
		ui_name = "Hips Handle",
		category = "Node Names"
	},
	left_handle = {
		ui_type = "text_box",
		value = "",
		ui_name = "Left Handle",
		category = "Node Names"
	},
	right_handle = {
		ui_type = "text_box",
		value = "",
		ui_name = "Right Handle",
		category = "Node Names"
	},
	left_orient_handle = {
		ui_type = "text_box",
		value = "",
		ui_name = "Left Orient Handle",
		category = "Node Names"
	},
	right_orient_handle = {
		ui_type = "text_box",
		value = "",
		ui_name = "Right Orient Handle",
		category = "Node Names"
	},
	hips_handle_ref = {
		ui_type = "text_box",
		value = "",
		ui_name = "Hips Handle Ref",
		category = "Node Names"
	},
	left_handle_ref = {
		ui_type = "text_box",
		value = "",
		ui_name = "Left Handle Ref",
		category = "Node Names"
	},
	right_handle_ref = {
		ui_type = "text_box",
		value = "",
		ui_name = "Right Handle Ref",
		category = "Node Names"
	},
	left_orient_ref = {
		ui_type = "text_box",
		value = "",
		ui_name = "Left Orient Ref",
		category = "Node Names"
	},
	right_orient_ref = {
		ui_type = "text_box",
		value = "",
		ui_name = "Right Orient Ref",
		category = "Node Names"
	},
	grounded_node = {
		ui_type = "text_box",
		value = "",
		ui_name = "Grounded Node",
		category = "Node Names"
	}
}

return FootIk
