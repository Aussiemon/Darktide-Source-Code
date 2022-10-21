local BeastOfNurgle = component("BeastOfNurgle")
local Bezier = require("scripts/utilities/spline/bezier")
local SPLINE_JOINT_NAMES = {
	"j_tail_spline_01",
	"j_tail_spline_02",
	"j_tail_spline_03",
	"j_tail_spline_04",
	"j_tail_spline_05",
	"j_tail_spline_06",
	"j_tail_spline_07",
	"j_tail_spline_08"
}
local ANIM_JOINT_NAMES = {
	"j_tail_anim_01",
	"j_tail_anim_02",
	"j_tail_anim_03",
	"j_tail_anim_04",
	"j_tail_anim_05",
	"j_tail_anim_06",
	"j_tail_anim_07",
	"j_tail_anim_08"
}
local BIND_JOINT_NAMES = {
	"j_tail_bind_01",
	"j_tail_bind_02",
	"j_tail_bind_03",
	"j_tail_bind_04",
	"j_tail_bind_05",
	"j_tail_bind_06",
	"j_tail_bind_07",
	"j_tail_bind_08"
}

BeastOfNurgle.init = function (self, unit, is_server)
	self._in_level_editor = false
	self._should_debug_draw = false
	self._world = Unit.world(unit)
	self._physics_world = World.physics_world(self._world)

	self:_init_spline(unit)

	self._is_server = is_server

	return true
end

BeastOfNurgle.editor_init = function (self, unit)
	self._in_level_editor = rawget(_G, "LevelEditor") ~= nil

	if self._in_level_editor then
		self._should_debug_draw = false
		self._world = Unit.world(unit)
		self._physics_world = World.physics_world(self._world)

		self:_init_spline(unit)

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
	self:_reparent_spline_joints(unit)
end

BeastOfNurgle.editor_destroy = function (self, unit)
	if self._in_level_editor then
		self:_reparent_spline_joints(unit)
		LineObject.reset(self._line_object)
		LineObject.dispatch(self._world, self._line_object)
		World.destroy_line_object(self._world, self._line_object)

		self._line_object = nil
		self._world = nil
	end
end

BeastOfNurgle.update = function (self, unit, dt, t)
	self:_update_spline(unit, dt)
	self:_update_joints(unit, dt)

	return true
end

BeastOfNurgle.editor_update = function (self, unit, dt, t)
	if self._in_level_editor then
		self:_update_spline(unit, dt)
		self:_update_joints(unit, dt)
		self:_editor_debug_draw(unit)

		return true
	end
end

BeastOfNurgle.get_spline_position_rotation = function (self, spline_index)
	local tm = self._spline_transforms[spline_index]
	local tm_unboxed = tm:unbox()
	local pos = Matrix4x4.translation(tm_unboxed)
	local rot = Matrix4x4.rotation(tm_unboxed)

	return pos, rot
end

BeastOfNurgle.get_last_spline_position_rotation = function (self)
	local tm = self._spline_transforms[#self._spline_transforms]
	local tm_unboxed = tm:unbox()
	local pos = Matrix4x4.translation(tm_unboxed)
	local rot = Matrix4x4.rotation(tm_unboxed)

	return pos, rot
end

BeastOfNurgle.editor_world_transform_modified = function (self, unit)
	return
end

BeastOfNurgle.editor_toggle_debug_draw = function (self, enable)
	self._should_debug_draw = enable
end

local COLLISION_FILTER = "filter_minion_mover"

BeastOfNurgle._ray_cast = function (self, from, to)
	local to_target = to - from
	local hit, hit_position, _, hit_normal, _ = PhysicsWorld.raycast(self._physics_world, from, Vector3.normalize(to_target), Vector3.length(to_target), "closest", "collision_filter", COLLISION_FILTER)

	return hit, hit_position, hit_normal
end

BeastOfNurgle._init_spline = function (self, unit)
	self._target_joint = Unit.node(unit, "j_gut")
	self._target_bind_joint = Unit.node(unit, "j_gut_bind")
	self._bezier_mesuring_segments = 20
	self._spline_joints = {}

	for i, name in pairs(SPLINE_JOINT_NAMES) do
		self._spline_joints[i] = Unit.node(unit, name)
	end

	self._anim_joints = {}

	for i, name in pairs(ANIM_JOINT_NAMES) do
		self._anim_joints[i] = Unit.node(unit, name)
	end

	self._bind_joints = {}

	for i, name in pairs(BIND_JOINT_NAMES) do
		self._bind_joints[i] = Unit.node(unit, name)
	end

	self._blend_joint = Unit.node(unit, self:get_data(unit, "spline_blend_node"))
	self._length = self:get_data(unit, "spline_length")
	self._tail_offset = self:get_data(unit, "tail_offset")
	self._spline_segments = self:get_data(unit, "spline_segments")
	self._control_weight = self:get_data(unit, "control_weight")
	self._bezier = Bezier
	self._segment_length = self._length / self._spline_segments
	self._spline_transforms = {}

	self:_set_default_spline(unit)

	if not self._in_level_editor then
		self:_unparent_spline_joints(unit)
	end
end

BeastOfNurgle._set_default_spline = function (self, unit)
	table.clear(self._spline_transforms)

	self._target_transform = Unit.world_pose(unit, self._target_joint)
	local forward = Matrix4x4.forward(self._target_transform)
	local tail_translation = Matrix4x4.translation(self._target_transform) - forward * self._tail_offset
	local rotation = Matrix4x4.rotation(self._target_transform)
	self._tail_transform = Matrix4x4.from_quaternion_position(rotation, tail_translation)
	self._spline_transforms[1] = Matrix4x4Box(self._target_transform)
	self._spline_transforms[2] = Matrix4x4Box(self._tail_transform)
	local offset, point, m = nil

	for i = 3, self._spline_segments + 1 do
		offset = self._segment_length * (i - 2)
		point = tail_translation + forward * -offset
		m = Matrix4x4.from_quaternion_position(rotation, point)
		self._spline_transforms[i] = Matrix4x4Box(m)
	end

	self._last_frame_translation = Vector3Box(tail_translation)
	self._target_up = Vector3Box(Matrix4x4.up(self._target_transform))
end

BeastOfNurgle._update_spline = function (self, unit, dt)
	self._target_transform = Unit.world_pose(unit, self._target_joint)
	local target_translation = Matrix4x4.translation(self._target_transform)
	local target_forward = Matrix4x4.forward(self._target_transform)
	local target_up = Matrix4x4.up(self._target_transform)
	local gut_hit, _, gut_normal = self:_ray_cast(target_translation + target_up, target_translation - target_up)
	local new_target_up = nil

	if gut_hit then
		new_target_up = Vector3.lerp(self._target_up:unbox(), gut_normal, dt * 15)
	else
		new_target_up = Vector3.lerp(self._target_up:unbox(), target_up, dt * 15)
	end

	if Vector3.is_valid(new_target_up) then
		self._target_up:store(new_target_up)
	else
		new_target_up = self._target_up:unbox()
	end

	local target_bind_transform = Unit.world_pose(unit, self._target_bind_joint)

	Matrix4x4.set_up(target_bind_transform, new_target_up)
	Unit.set_local_pose(unit, self._target_bind_joint, Matrix4x4.multiply(target_bind_transform, Matrix4x4.inverse(self._target_transform)))

	local tail_translation = Matrix4x4.translation(self._target_transform) - target_forward * self._tail_offset
	local last_frame_translation = self._last_frame_translation:unbox()
	local spline_tm3 = self._spline_transforms[3]:unbox()
	local spline_translation3 = Matrix4x4.translation(spline_tm3)
	local tail_to_spline_dist = Vector3.length(tail_translation - spline_translation3)
	local last_tail_to_spline_dist = Vector3.length(last_frame_translation - spline_translation3)
	local moving_away = last_tail_to_spline_dist < tail_to_spline_dist
	local moving_back = tail_to_spline_dist < last_tail_to_spline_dist
	local last_tail_transform = self._spline_transforms[2]:unbox()
	local length = self:_get_bezier_arc_length(last_tail_transform, spline_tm3, 1, 1)
	local middle_tm = self:_get_bezier_transform(last_tail_transform, spline_tm3, 0.5, 1, 1)
	local tangent_start = Vector3.lerp(spline_translation3, Matrix4x4.translation(middle_tm), length / self._segment_length - 1)
	local tangent = Vector3.normalize(target_translation - tangent_start)
	local tail_rotation = Quaternion.multiply(Quaternion.look(new_target_up, tangent), Quaternion.from_euler_angles_xyz(-90, 0, 180))
	self._tail_transform = Matrix4x4.from_quaternion_position(tail_rotation, tail_translation)
	self._spline_transforms[1] = Matrix4x4Box(self._target_transform)
	self._spline_transforms[2] = Matrix4x4Box(self._tail_transform)
	self._spline_transforms[3] = Matrix4x4Box(spline_tm3)
	local push_backwards = nil

	if moving_away then
		local new_bezier_segments = math.floor(length / (self._segment_length * 2))

		if new_bezier_segments > 0 then
			for i = 1, new_bezier_segments do
				table.insert(self._spline_transforms, 3, Matrix4x4Box(middle_tm))
				table.remove(self._spline_transforms, #self._spline_transforms)
			end
		end

		push_backwards = 0
	elseif moving_back then
		push_backwards = (last_tail_to_spline_dist - tail_to_spline_dist) * 1.5
	end

	if moving_away or moving_back then
		local spline_tm, move_direction = nil
		local last_tm = self._tail_transform

		for i = 3, #self._spline_transforms do
			spline_tm = self._spline_transforms[i]:unbox()
			move_direction = -Matrix4x4.forward(last_tm)

			Matrix4x4.set_translation(spline_tm, Matrix4x4.translation(spline_tm) + move_direction * push_backwards)

			self._spline_transforms[i] = Matrix4x4Box(spline_tm)
			last_tm = spline_tm
		end
	end

	self._last_frame_translation = Vector3Box(tail_translation)
end

BeastOfNurgle._reparent_spline_joints = function (self, unit)
	for _, spline_j in pairs(self._spline_joints) do
		Unit.scene_graph_link(unit, spline_j, 1)
	end
end

BeastOfNurgle._unparent_spline_joints = function (self, unit)
	for _, spline_j in pairs(self._spline_joints) do
		Unit.scene_graph_link(unit, spline_j, nil)
	end
end

BeastOfNurgle._update_joints = function (self, unit, dt)
	local current_spline_i = 1
	local tm1 = self._target_transform
	local tm2 = self._tail_transform
	local current_bezier_length = self:_get_bezier_arc_length(tm1, tm2, 1, 1)
	local spline_length = current_bezier_length
	local joint_separation = self._length / #self._spline_joints
	local spline_blend = nil

	if self._in_level_editor then
		spline_blend = self:get_data(unit, "spline_blend")
	else
		spline_blend = Unit.local_position(unit, self._blend_joint)[1]
	end

	local spline_joint_transforms = {}

	if spline_blend > 0.001 then
		for i, j in pairs(self._spline_joints) do
			local anim_position = Unit.local_position(unit, self._anim_joints[i])
			local joint_length = joint_separation * i - anim_position[2]
			local beyond_spline_length = nil

			while spline_length < joint_length do
				current_spline_i = current_spline_i + 1

				if current_spline_i < #self._spline_transforms then
					tm1 = self._spline_transforms[current_spline_i]:unbox()
					tm2 = self._spline_transforms[current_spline_i + 1]:unbox()
					current_bezier_length = self:_get_bezier_arc_length(tm1, tm2, 1, 0.5)
					spline_length = spline_length + current_bezier_length
					beyond_spline_length = false
				else
					tm1 = self._spline_transforms[#self._spline_transforms]:unbox()
					spline_length = joint_length
					beyond_spline_length = true
				end
			end

			if beyond_spline_length then
				spline_joint_transforms[i] = Matrix4x4.copy(tm1)

				Matrix4x4.set_translation(spline_joint_transforms[i], Matrix4x4.translation(tm1) - Matrix4x4.forward(tm1) * (joint_length - spline_length))
			else
				local t = (joint_length - (spline_length - current_bezier_length)) / current_bezier_length

				if current_spline_i == 1 then
					spline_joint_transforms[i] = self:_get_bezier_transform(tm1, tm2, t, 1, 0.5)
				else
					spline_joint_transforms[i] = self:_get_bezier_transform(tm1, tm2, t, 1, 1)
				end
			end
		end
	else
		local unsplined_p_offset = -Matrix4x4.forward(self._target_transform) * joint_separation
		local unsplined_q = Matrix4x4.rotation(self._target_transform)
		local unsplined_p = nil
		local last_unsplined_p = Matrix4x4.translation(self._target_transform)

		for i, j in pairs(self._spline_joints) do
			unsplined_p = last_unsplined_p + unsplined_p_offset
			last_unsplined_p = unsplined_p
			spline_joint_transforms[i] = Matrix4x4.from_quaternion_position(unsplined_q, unsplined_p)
		end
	end

	if spline_blend < 0.999 then
		local unsplined_p_offset = -Matrix4x4.forward(self._target_transform) * joint_separation
		local unsplined_q = Matrix4x4.rotation(self._target_transform)
		local unsplined_p, unsplined_tm = nil
		local last_unsplined_p = Matrix4x4.translation(self._target_transform)

		for i, j in pairs(self._spline_joints) do
			unsplined_p = last_unsplined_p + unsplined_p_offset
			last_unsplined_p = unsplined_p
			unsplined_tm = Matrix4x4.from_quaternion_position(unsplined_q, unsplined_p)
			spline_joint_transforms[i] = Matrix4x4.lerp(unsplined_tm, spline_joint_transforms[i], spline_blend)
		end
	end

	if self._in_level_editor then
		local inv_root_tm = Matrix4x4.inverse(Unit.world_pose(unit, 1))

		for i, j in pairs(self._spline_joints) do
			local spline_tm = Unit.world_pose(unit, j)
			local t = math.min(math.max(25 * dt - 15 * dt * i / #self._spline_joints, 0), 1)
			local new_pose = Matrix4x4.lerp(spline_tm, spline_joint_transforms[i], t)

			Unit.set_local_pose(unit, j, Matrix4x4.multiply(new_pose, inv_root_tm))
		end
	else
		for i, j in pairs(self._spline_joints) do
			local spline_tm = Unit.world_pose(unit, j)
			local t = math.min(math.max(25 * dt - 15 * dt * i / #self._spline_joints, 0), 1)
			local new_pose = Matrix4x4.lerp(spline_tm, spline_joint_transforms[i], t)

			Unit.set_local_pose(unit, j, new_pose)
		end
	end

	for i = 1, #self._bind_joints do
		local anim_position = Unit.local_position(unit, self._anim_joints[i])

		Vector3.set_y(anim_position, anim_position[2] * (1 - spline_blend))

		local anim_rotation = Unit.local_rotation(unit, self._anim_joints[i])
		local anim_scale = Unit.local_scale(unit, self._anim_joints[i])
		local bind_tm = Matrix4x4.from_quaternion_position_scale(anim_rotation, anim_position, anim_scale)

		Unit.set_local_pose(unit, self._bind_joints[i], bind_tm)
	end
end

BeastOfNurgle._get_bezier_arc_length = function (self, tm1, tm2, w1, w2)
	local p1 = Matrix4x4.translation(tm1)
	local p2 = Matrix4x4.translation(tm2)
	local distanced_weight = self._control_weight * Vector3.distance(p1, p2) / self._segment_length
	local c1 = p1 - self:_get_curve_control(tm1, distanced_weight * w1)
	local c2 = p2 + self:_get_curve_control(tm2, distanced_weight * w2)

	return self._bezier.length(self._bezier_mesuring_segments, p1, c1, c2, p2)
end

BeastOfNurgle._get_bezier_transform = function (self, tm1, tm2, t, w1, w2)
	local p1 = Matrix4x4.translation(tm1)
	local p2 = Matrix4x4.translation(tm2)
	local distanced_weight = self._control_weight * Vector3.distance(p1, p2) / self._segment_length
	local c1 = p1 - self:_get_curve_control(tm1, distanced_weight * w1)
	local c2 = p2 + self:_get_curve_control(tm2, distanced_weight * w2)
	local result_translation = self._bezier.calc_point(t, p1, c1, c2, p2)
	local tangent = self._bezier.calc_tangent(t, p1, c1, c2, p2)
	local up = Vector3.lerp(Matrix4x4.up(tm1), Matrix4x4.up(tm2), t)
	local result_rotation = Quaternion.look(-tangent, up)

	return Matrix4x4.from_quaternion_position(result_rotation, result_translation)
end

BeastOfNurgle._get_curve_control = function (self, tm, control_weight)
	local w = control_weight or self._control_weight
	local rotation = Matrix4x4.rotation(tm)
	local unit_forward = Quaternion.forward(rotation)

	return unit_forward * self._segment_length * w
end

BeastOfNurgle._editor_debug_draw = function (self, unit)
	if self._should_debug_draw then
		self._drawer:reset()
		self._drawer:sphere(Matrix4x4.translation(self._spline_transforms[1]:unbox()), 0.1, Color.red())

		local last_tm = self._spline_transforms[1]:unbox()

		for i = 2, #self._spline_transforms do
			local spline_tm = self._spline_transforms[i]:unbox()

			if i == 2 then
				self:_draw_tm(last_tm, spline_tm, 0.5, 2, Color.red())
			else
				self:_draw_tm(last_tm, spline_tm, 1, 1, Color.red())
			end

			last_tm = spline_tm
		end

		local blue = Color.blue()

		for i, j in pairs(self._spline_joints) do
			self._drawer:sphere(Unit.world_position(unit, j), 0.15 - 0.1 * i / #self._spline_joints, blue)
		end

		local white = Color.white()

		for i, j in pairs(self._bind_joints) do
			self._drawer:sphere(Unit.world_position(unit, j), 0.2 - 0.1 * i / #self._bind_joints, white)
		end

		self._drawer:update(self._world)
	else
		self._drawer:reset()
		self._drawer:update(self._world)
	end
end

BeastOfNurgle._draw_tm = function (self, tm1, tm2, w1, w2, color)
	local distanced_weight = self._control_weight * Vector3.distance(Matrix4x4.translation(tm1), Matrix4x4.translation(tm2)) / self._segment_length
	local p1 = Matrix4x4.translation(tm1)
	local p2 = Matrix4x4.translation(tm2)
	local c1 = p1 - self:_get_curve_control(tm1, distanced_weight * w1)
	local c2 = p2 + self:_get_curve_control(tm2, distanced_weight * w2)

	Bezier.draw(10, self._drawer, 0.1, color, p1, c1, c2, p2)
	self._drawer:sphere(p2, 0.1, color)
end

BeastOfNurgle.component_data = {
	control_weight = {
		ui_type = "slider",
		min = 0,
		step = 0.1,
		decimals = 3,
		value = 0.4,
		ui_name = "Spline Tangent Weight",
		max = 1
	},
	spline_segments = {
		ui_type = "slider",
		min = 0,
		step = 1,
		decimals = 0,
		value = 6,
		ui_name = "Spline Segments",
		max = 10
	},
	tail_offset = {
		ui_type = "slider",
		min = 0,
		step = 0.1,
		decimals = 3,
		value = 1.2,
		ui_name = "Tail Offset",
		max = 10
	},
	spline_blend = {
		ui_type = "slider",
		min = 0,
		step = 0.1,
		decimals = 3,
		value = 1,
		ui_name = "Spline Blend",
		max = 1
	},
	spline_length = {
		ui_type = "slider",
		min = 0,
		step = 0.1,
		decimals = 3,
		value = 7,
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
