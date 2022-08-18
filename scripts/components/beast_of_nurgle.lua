local BeastOfNurgle = component("BeastOfNurgle")
local Bezier = require("scripts/utilities/spline/bezier")
local Component = require("scripts/utilities/component")

BeastOfNurgle.init = function (self, unit, is_server)
	self._base_unit = unit
	self._world = Application.main_world()
	self._spline_class = Bezier

	self:_instantiate_spline_data()
	self:_unparent_spline_joints()

	self._is_server = is_server

	return true
end

BeastOfNurgle.editor_init = function (self, unit)
	self._in_level_editor = rawget(_G, "LevelEditor") ~= nil

	if self._in_level_editor then
		self._should_debug_draw = false
		self._base_unit = unit
		self._world = Application.main_world()
		self._spline_class = Bezier

		self:_instantiate_spline_data()
		self:_unparent_spline_joints()

		self._line_object = World.create_line_object(self._world)
		self._drawer = DebugDrawer(self._line_object, "retained")

		return true
	end
end

BeastOfNurgle.enable = function (self, unit)
	return
end

BeastOfNurgle.disable = function (self, unit)
	return
end

BeastOfNurgle.destroy = function (self, unit)
	for _, spline_j in pairs(self._spline_joints) do
		Unit.scene_graph_link(self._base_unit, spline_j, 1)
	end
end

BeastOfNurgle.editor_destroy = function (self, unit)
	self:_unparent_spline_joints()

	if self._in_level_editor then
		LineObject.reset(self._line_object)
		LineObject.dispatch(self._world, self._line_object)
		World.destroy_line_object(self._world, self._line_object)

		self._line_object = nil
		self._world = nil
	end
end

BeastOfNurgle.update = function (self, unit, dt, t)
	self:_update_spline_data()
	self:_update_joints()

	return true
end

BeastOfNurgle._set_default_spline_data = function (self)
	local inv_unit_transform = Matrix4x4.inverse(self._unit_transform)
	local translation = Matrix4x4.translation(self._unit_transform)
	local rotation = Matrix4x4.rotation(self._unit_transform)
	self._heading = Quaternion.forward(rotation)
	local offset, point, m, relative_m = nil

	for i = 1, #self._spline_joints + 1 do
		offset = self._segment_length * (i - 1)
		point = translation + self._heading * -offset
		m = Matrix4x4.copy(self._unit_transform)

		Matrix4x4.set_translation(m, point)

		self._spline_transforms[i] = Matrix4x4Box(m)
		relative_m = Matrix4x4.multiply(m, inv_unit_transform)
		self._init_transforms[i] = Matrix4x4Box(relative_m)
	end
end

BeastOfNurgle._instantiate_spline_data = function (self)
	self._length = self:get_data(self._base_unit, "length")
	self._control_weight = self:get_data(self._base_unit, "control_weight")
	self._move_unit = self:get_data(self._base_unit, "control_weight")
	local anim_joint_names = self:get_data(self._base_unit, "anim_joints")
	self._anim_joints = {}

	for i, joint_name in pairs(anim_joint_names) do
		if Unit.has_node(self._base_unit, joint_name) then
			self._anim_joints[i] = Unit.node(self._base_unit, joint_name)
		else
			Log.info("BeastOfNurgle", "Not able to find node %q in unit: %q", joint_name, self._base_unit)

			return
		end
	end

	local spline_joint_names = self:get_data(self._base_unit, "spline_joints")
	self._spline_joints = {}

	for i, joint_name in pairs(spline_joint_names) do
		if Unit.has_node(self._base_unit, joint_name) then
			self._spline_joints[i] = Unit.node(self._base_unit, joint_name)
		else
			Log.info("BeastOfNurgle", "Not able to find node %q in unit: %q", joint_name, self._base_unit)

			return
		end
	end

	local spline_blend_node_name = self:get_data(self._base_unit, "spline_blend_node")

	if Unit.has_node(self._base_unit, spline_blend_node_name) then
		self._spline_blend_node = Unit.node(self._base_unit, spline_blend_node_name)
		self._spline_blend = Unit.local_position(self._base_unit, self._spline_blend_node)[1]
	else
		Log.info("BeastOfNurgle", "Not able to find node %q in unit: %q", spline_blend_node_name, self._base_unit)

		return
	end

	self._segment_length = self._length / #self._spline_joints
	self._spline_transforms = {}
	self._init_transforms = {}
	self._unit_transform = Unit.world_pose(self._base_unit, 1)

	self:_set_default_spline_data()

	self._last_frame_position = Vector3Box(Matrix4x4.translation(self._unit_transform))
	self.new_points_on_frame = false
	self._last_spline_blend = self._spline_blend
end

BeastOfNurgle._unparent_spline_joints = function (self)
	for _, spline_j in pairs(self._spline_joints) do
		Unit.scene_graph_link(self._base_unit, spline_j, nil)
	end
end

BeastOfNurgle._update_spline_data = function (self)
	self._unit_transform = Unit.world_pose(self._base_unit, 1)
	local closest_spline_transform = Matrix4x4Box.unbox(self._spline_transforms[1])
	local closest_position = Matrix4x4.translation(closest_spline_transform)
	local current_position = Matrix4x4.translation(self._unit_transform)
	self._distance_from_segment = Vector3.distance(current_position, closest_position)
	local last_pos = Vector3Box.unbox(self._last_frame_position)
	local new_segments = math.floor(self._distance_from_segment / self._segment_length)

	if new_segments > 0 then
		self.new_points_on_frame = true
		self._heading = Vector3.normalize(current_position - closest_position)
		local new_tangent = Vector3.normalize(current_position - last_pos)

		for i = 1, new_segments do
			local p = Matrix4x4.translation(closest_spline_transform) + self._heading * self._segment_length * i
			local q = Quaternion.look(new_tangent, Matrix4x4.up(self._unit_transform))
			local m = Matrix4x4.from_quaternion_position(q, p)

			table.insert(self._spline_transforms, 1, Matrix4x4Box(m))
			table.remove(self._spline_transforms, #self._spline_transforms)
		end
	end

	self._last_spline_blend = self._spline_blend
	self._spline_blend = Unit.local_position(self._base_unit, self._spline_blend_node)[1]

	if self._last_spline_blend < 0.001 and self._spline_blend >= 0.001 then
		self:_set_default_spline_data()
	end

	self._last_frame_position = Vector3Box(current_position)
end

BeastOfNurgle._update_joints = function (self)
	local t = self._distance_from_segment / self._segment_length

	if self.new_points_on_frame then
		t = 0
		self.new_points_on_frame = false
	end

	local parting_transform, heading_transform, spline_transform, init_spline_transform, local_init_spline_transform, spline_transform, weighted_spline_transform = nil

	for i, spline_j in pairs(self._spline_joints) do
		if self._spline_blend == 0 then
			init_spline_transform = Matrix4x4Box.unbox(self._init_transforms[i])
			local_init_spline_transform = Matrix4x4.multiply(init_spline_transform, self._unit_transform)
			weighted_spline_transform = local_init_spline_transform
		else
			parting_transform = Matrix4x4Box.unbox(self._spline_transforms[i + 1])
			heading_transform = Matrix4x4Box.unbox(self._spline_transforms[i])
			spline_transform = self:_get_cubic_curve_transform(parting_transform, heading_transform, t)

			if self._spline_blend == 1 then
				weighted_spline_transform = spline_transform
			else
				init_spline_transform = Matrix4x4Box.unbox(self._init_transforms[i])
				local_init_spline_transform = Matrix4x4.multiply(init_spline_transform, self._unit_transform)
				weighted_spline_transform = Matrix4x4.lerp(local_init_spline_transform, spline_transform, self._spline_blend)
			end
		end

		Unit.set_local_pose(self._base_unit, spline_j, weighted_spline_transform)
	end
end

BeastOfNurgle._get_cubic_curve_transform = function (self, tm1, tm2, t)
	local pos1 = Matrix4x4.translation(tm1)
	local ctrl1 = pos1 + self:_get_curve_control(tm1)
	local pos2 = Matrix4x4.translation(tm2)
	local ctrl2 = pos2 - self:_get_curve_control(tm2)
	local result_translation = self._spline_class.calc_point(t, pos1, ctrl1, ctrl2, pos2)
	local tangent = self._spline_class.calc_tangent(t, pos1, ctrl1, ctrl2, pos2)
	local result_rotation = Quaternion.look(tangent, Matrix4x4.up(self._unit_transform))

	return Matrix4x4.from_quaternion_position(result_rotation, result_translation)
end

BeastOfNurgle._get_curve_control = function (self, tm)
	local rotation = Matrix4x4.rotation(tm)
	local unit_forward = Quaternion.forward(rotation)

	return unit_forward * self._segment_length * self._control_weight
end

BeastOfNurgle.editor_world_transform_modified = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self:_update_spline_data()
	self:_update_joints()
	self:_editor_debug_draw()
end

BeastOfNurgle.editor_toggle_debug_draw = function (self, enable)
	self._should_debug_draw = enable

	self:_editor_debug_draw()
end

BeastOfNurgle._editor_debug_draw = function (self)
	if self._should_debug_draw then
		self._drawer:reset()

		local red = Color.red()
		local green = Color.green()

		for i, tm in pairs(self._spline_transforms) do
			local spline_tm = Matrix4x4Box.unbox(tm)
			local position = Matrix4x4.translation(spline_tm)
			local control = self:_get_curve_control(spline_tm)

			self._drawer:sphere(position, 0.1, red)
			self._drawer:sphere(position + control, 0.05, green)
			self._drawer:line(position, position + control, green)
			self._drawer:sphere(position - control, 0.05, green)
			self._drawer:line(position, position - control, green)
		end

		self._drawer:update(self._world)
	else
		self._drawer:reset()
		self._drawer:update(self._world)
	end
end

BeastOfNurgle.component_data = {
	control_weight = {
		ui_type = "slider",
		min = 0,
		step = 0.1,
		decimals = 3,
		value = 0.25,
		ui_name = "Spline Tangent Weight",
		max = 1
	},
	length = {
		ui_type = "slider",
		min = 0,
		step = 0.1,
		decimals = 3,
		value = 6,
		ui_name = "Spline Length",
		max = 15
	},
	spline_blend_node = {
		ui_type = "text_box",
		value = "ap_spline_blend",
		ui_name = "Spline Blend Node",
		category = "Node Names"
	},
	spline_joints = {
		ui_type = "text_box_array",
		size = 2,
		ui_name = "Spline Joints",
		category = "Node Names"
	},
	anim_joints = {
		ui_type = "text_box_array",
		size = 2,
		ui_name = "Animated Joints",
		category = "Node Names"
	}
}

return BeastOfNurgle
