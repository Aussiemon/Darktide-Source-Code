local Bezier = require("scripts/utilities/spline/bezier")
local CorruptorArm = component("CorruptorArm")

CorruptorArm.init = function (self, unit)
	self._unit = unit

	self:_initialize_arm(unit)

	local corruptor_arm_extension = ScriptUnit.fetch_component_extension(unit, "corruptor_arm_system")

	if corruptor_arm_extension then
		local activation_delay = self:get_data(unit, "activation_delay")
		local arm_length = Bezier.length(20, Unit.world_position(unit, self._arm_start_node), Unit.world_position(unit, self._first_control_node), Unit.world_position(unit, self._second_control_node), Unit.world_position(unit, self._arm_end_node))

		corruptor_arm_extension:setup_from_component(activation_delay, arm_length, self)

		self._corruptor_arm_extension = corruptor_arm_extension
	end

	return true
end

CorruptorArm.destroy = function (self, unit)
	self:_destroy_children(unit)
end

CorruptorArm.enable = function (self, unit)
	return
end

CorruptorArm.disable = function (self, unit)
	return
end

local FONT = "core/editor_slave/gui/arial"
local FONT_MATERIAL = "core/editor_slave/gui/arial"
local FONT_SIZE = 0.1

CorruptorArm.editor_init = function (self, unit)
	self._in_level_editor = rawget(_G, "LevelEditor")

	self:_initialize_arm(unit)

	if self._in_level_editor then
		self._unit = unit
		local line_render = World.create_line_object(self._world, true)
		self._line_render = line_render
		self._drawer = DebugDrawer(line_render, "retained")

		self:_editor_debug_draw(unit)

		self._debug_text_ids = {}
		self._guis = {}
		local text_color = Color.red()
		local text_position = Unit.local_position(unit, 1)
		local translation_matrix = Matrix4x4.from_translation(text_position)

		for i = 1, 4 do
			self._guis[i] = World.create_world_gui(self._world, Matrix4x4.identity(), 1, 1)
			self._debug_text_ids[i] = Gui.text_3d(self._guis[i], "Node", FONT_MATERIAL, FONT_SIZE, FONT, translation_matrix, Vector3.zero(), 3, text_color)

			Gui.set_visible(self._guis[i], false)
		end
	end

	return true
end

CorruptorArm.editor_validate = function (self, unit)
	return true, ""
end

CorruptorArm.editor_destroy = function (self, unit)
	if self._in_level_editor then
		if self._line_render then
			LineObject.reset(self._line_render)
			LineObject.dispatch(self._world, self._line_render)

			self._line_render = nil
		end

		for i = 1, 4 do
			Gui.destroy_text_3d(self._guis[i], self._debug_text_ids[i])
			World.destroy_gui(self._world, self._guis[i])
		end

		self._debug_text_ids = nil
		self._guis = nil
	end

	self:_destroy_children(unit)

	self._world = nil
end

CorruptorArm._initialize_arm = function (self, unit)
	self._world = Unit.world(unit)
	self._transform = Matrix4x4Box(Unit.world_pose(unit, 1))
	self._mesh_amount = self:get_data(unit, "mesh_amount")
	self._attached_meshes = {}
	self._final_rotation = {}
	self._tiling_mesh_name = self:get_data(unit, "tiling_mesh_name")
	self._joint_amount = self:get_data(unit, "joint_amount")
	self._joint_base_name = self:get_data(unit, "joint_base_name")
	self._arm_start_name = self:get_data(unit, "arm_start")
	self._arm_end_name = self:get_data(unit, "arm_end")
	self._main_unit_root_name = self:get_data(unit, "main_unit_root_name")
	self._attach_unit_root_name = self:get_data(unit, "attach_unit_root_name")
	self._arm_start_node = Unit.node(unit, self._arm_start_name)
	self._arm_start_position = Vector3Box(Unit.local_position(unit, self._arm_start_node))
	self._arm_end_node = Unit.node(unit, self._arm_end_name)
	self._arm_end_position = Vector3Box(Unit.local_position(unit, self._arm_end_node))
	self._first_control_node = Unit.node(unit, self:get_data(unit, "first_control"))
	self._first_control_position = Vector3Box(Unit.local_position(unit, self._first_control_node))
	self._second_control_node = Unit.node(unit, self:get_data(unit, "second_control"))
	self._second_control_position = Vector3Box(Unit.local_position(unit, self._second_control_node))
	self._current_end = self:get_data(unit, "auto_current_end")
	self._current_spline_distance = self:get_data(unit, "current_spline_distance")

	self:_bezier_setup(unit)
end

CorruptorArm._bezier_setup = function (self, unit)
	self:_spline_position(unit, false, 0, unit, 0, 1)
	self:_place_meshes(unit)
end

CorruptorArm.last_joint_position = function (self)
	local last_joint = math.max(self._joint_amount - 1, 1)
	local last_mesh = self._attached_meshes[#self._attached_meshes]

	return Unit.world_position(last_mesh, last_joint)
end

CorruptorArm._spline_position = function (self, unit, multi_mesh, mesh_increment_add, attach_mesh, mesh_rotation, current_end_position)
	mesh_rotation = mesh_rotation or 0
	local mesh_amount = self._mesh_amount
	local total_joint_amount = self._joint_amount
	local joint_base_name = self._joint_base_name
	local first_control_pos = self._first_control_position:unbox()
	local second_control_pos = self._second_control_position:unbox()
	local arm_end_position = self._arm_end_position:unbox()
	local arm_start_position = self._arm_start_position:unbox()
	local transform = self._transform:unbox()
	local joint_increment = 1 / total_joint_amount
	local mesh_increment = 1 / mesh_amount

	for joint_amount = 0, total_joint_amount do
		local t = nil

		if multi_mesh then
			t = (joint_increment * joint_amount * mesh_increment + mesh_increment_add) * current_end_position + 0.01
		else
			t = joint_increment * joint_amount
			attach_mesh = unit
		end

		local current_joint = joint_base_name .. joint_amount
		local current_joint_node = Unit.node(attach_mesh, current_joint)
		local curve_position = Bezier.calc_point(t, arm_start_position, first_control_pos, second_control_pos, arm_end_position)
		local curve_tangent = Bezier.calc_tangent(t, arm_start_position, first_control_pos, second_control_pos, arm_end_position)

		local function _get_local_pose()
			local new_position = Matrix4x4.transform(Matrix4x4.identity(), curve_position)
			local new_rotation = Quaternion.multiply(Quaternion.look(curve_tangent, Matrix4x4.up(transform)), Quaternion.from_euler_angles_xyz(0, mesh_rotation, 90))

			return Matrix4x4.from_quaternion_position(new_rotation, new_position)
		end

		local pose = _get_local_pose()

		Unit.set_local_pose(attach_mesh, current_joint_node, pose)
	end
end

CorruptorArm._create_meshes = function (self, unit)
	local world = self._world
	local mesh_amount = self._mesh_amount
	local attached_meshes = self._attached_meshes
	local tiling_mesh_name = self._tiling_mesh_name
	local attach_unit_root_name = self._attach_unit_root_name

	if tiling_mesh_name == "" then
		return
	end

	for i = 1, mesh_amount do
		local attach_mesh = nil
		local socket_node = Unit.node(unit, self._main_unit_root_name)
		local socket_pos = Unit.world_position(unit, socket_node)
		local socket_rot = Unit.world_rotation(unit, socket_node)
		attach_mesh = World.spawn_unit_ex(world, tiling_mesh_name, nil, socket_pos, socket_rot)
		attached_meshes[#attached_meshes + 1] = attach_mesh

		World.link_unit(world, attach_mesh, Unit.node(attach_mesh, attach_unit_root_name), unit, socket_node, World.LINK_MODE_NONE)

		self._final_rotation[attach_mesh] = math.random() + math.random(0, 359)
	end
end

CorruptorArm._place_meshes = function (self, unit)
	local max_mesh_amount = self._mesh_amount
	local attached_meshes = self._attached_meshes
	local current_spline_distance = self._current_spline_distance
	local mesh_increment = 1 / max_mesh_amount

	if #attached_meshes == 0 then
		self:_create_meshes(unit)
	end

	for i, mesh in ipairs(attached_meshes) do
		local mesh_increment_add = mesh_increment * (i - 1)

		self:_spline_position(unit, true, mesh_increment_add, mesh, self._final_rotation[mesh], current_spline_distance)
	end
end

CorruptorArm._set_arm_visible = function (self, unit, visible)
	for i, mesh in ipairs(self._attached_meshes) do
		Unit.set_visibility(mesh, "main", visible)
	end
end

CorruptorArm._set_node_visible = function (self, unit, visible)
	Unit.set_visibility(unit, "main", visible)
end

CorruptorArm._destroy_children = function (self, unit)
	local attached_meshes = self._attached_meshes
	local unit_alive = Unit.alive

	for i, mesh in ipairs(attached_meshes) do
		World.destroy_unit(self._world, mesh)
	end

	table.clear(attached_meshes)
	table.clear(self._final_rotation)
end

CorruptorArm.editor_world_transform_modified = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self:_editor_debug_draw(unit)
end

CorruptorArm.editor_toggle_debug_draw = function (self, enable)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._should_debug_draw = enable

	self:_editor_debug_draw(self._unit)
end

CorruptorArm._editor_debug_draw = function (self, unit)
	self._drawer:reset()

	if self._should_debug_draw then
		local arm_start_position = Unit.world_position(unit, self._arm_start_node)
		local first_control_position = Unit.world_position(unit, self._first_control_node)
		local second_control_position = Unit.world_position(unit, self._second_control_node)
		local arm_end_position = Unit.world_position(unit, self._arm_end_node)

		Bezier.draw(20, self._drawer, 0.1, Color.red(), arm_start_position, first_control_position, second_control_position, arm_end_position)

		local node_pos = {
			arm_start_position,
			first_control_position,
			second_control_position,
			arm_end_position
		}
		local text = {
			"Start Node",
			"First Control",
			"Second Control",
			"End Node"
		}

		for i = 1, 4 do
			local text_position = node_pos[i]
			local translation_matrix = Matrix4x4.from_translation(text_position)
			local text_color = Color.red()

			Gui.destroy_text_3d(self._guis[i], self._debug_text_ids[i])

			self._debug_text_ids[i] = Gui.text_3d(self._guis[i], text[i], FONT_MATERIAL, FONT_SIZE, FONT, translation_matrix, Vector3.zero(), 3, text_color)
		end
	end

	if self._guis then
		for i = 1, 4 do
			Gui.set_visible(self._guis[i], not not self._should_debug_draw)
		end
	end

	self._drawer:update(self._world)
end

CorruptorArm.events.set_animation_pos = function (self, position)
	self._current_spline_distance = position

	self:_place_meshes(self._unit)
	self:_set_node_visible(self._unit, position >= 1)
	self:_set_arm_visible(self._unit, position > 0)
end

CorruptorArm.events.demolition_stage_start = function (self)
	self._corruptor_arm_extension:activate()
end

CorruptorArm.events.demolition_stage_finished = function (self)
	self._corruptor_arm_extension:deactivate()
end

CorruptorArm.component_data = {
	activation_delay = {
		ui_type = "number",
		value = 0,
		ui_name = "Activation Delay (sec.)",
		category = "Setup"
	},
	main_unit_root_name = {
		ui_type = "text_box",
		value = "rp_corruptor_arm_mid",
		ui_name = "Main Unit Root Name",
		category = "Curve"
	},
	attach_unit_root_name = {
		ui_type = "text_box",
		value = "rp_corruptor_arm_mid_attach",
		ui_name = "Attach Unit Base Name",
		category = "Curve"
	},
	joint_base_name = {
		ui_type = "text_box",
		value = "j_arm_0",
		ui_name = "Joint Base Name",
		category = "Curve"
	},
	mesh_amount = {
		ui_type = "slider",
		min = 1,
		step = 1,
		category = "Curve",
		value = 1,
		decimals = 0,
		ui_name = "Mesh Amount",
		max = 9
	},
	tiling_mesh_name = {
		ui_type = "resource",
		preview = true,
		category = "Curve",
		value = "content/environment/gameplay/corruptor/corruptor_arm_mid_attach",
		ui_name = "Tiling Mesh",
		filter = "unit"
	},
	joint_amount = {
		ui_type = "slider",
		min = 1,
		step = 1,
		category = "Curve",
		value = 6,
		decimals = 0,
		ui_name = "Joint Amount (per mesh)",
		max = 9
	},
	first_control = {
		ui_type = "text_box",
		value = "curve_start",
		ui_name = "First Ctrl",
		category = "Curve"
	},
	second_control = {
		ui_type = "text_box",
		value = "curve_end",
		ui_name = "Second Ctrl",
		category = "Curve"
	},
	arm_start = {
		ui_type = "text_box",
		value = "arm_start",
		ui_name = "Arm Start",
		category = "Curve"
	},
	arm_end = {
		ui_type = "text_box",
		value = "arm_end",
		ui_name = "Arm End",
		category = "Curve"
	},
	auto_current_end = {
		ui_type = "text_box",
		value = "auto_current_end",
		ui_name = "Auto Animator",
		category = "Curve"
	},
	current_spline_distance = {
		ui_type = "slider",
		min = 0,
		step = 0.001,
		category = "Curve",
		value = 0,
		decimals = 3,
		ui_name = "Current Spline Distance",
		max = 1
	},
	extensions = {
		"CorruptorArmExtension"
	}
}

return CorruptorArm
