-- chunkname: @scripts/components/nav_box_obstacle.lua

local NavBoxObstacle = component("NavBoxObstacle")

NavBoxObstacle.init = function (self, unit, is_server)
	self._is_server = is_server

	local extension = ScriptUnit.fetch_component_extension(unit, "nav_box_obstacle_system")

	if extension then
		local is_static = self:get_data(unit, "is_static")
		local fake_with_cost = self:get_data(unit, "fake_with_cost")
		local box_center = self:get_data(unit, "box_center")
		local box_extants = self:get_data(unit, "box_extants")

		extension:setup_from_component(unit, box_center, box_extants, is_static, fake_with_cost)

		self._extension = extension
	end
end

NavBoxObstacle.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

NavBoxObstacle.editor_init = function (self, unit)
	self._should_debug_draw = false

	return true
end

NavBoxObstacle.editor_destroy = function (self, unit)
	if self._drawer then
		self._drawer:delete()
	end

	self._should_debug_draw = false
end

NavBoxObstacle.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	if self._drawer then
		self:_editor_debug_draw(unit)
		self._drawer:update()
	end

	return true
end

NavBoxObstacle.editor_toggle_debug_draw = function (self, enable)
	self._should_debug_draw = enable
end

NavBoxObstacle.enable = function (self, unit)
	return
end

NavBoxObstacle.disable = function (self, unit)
	return
end

NavBoxObstacle.destroy = function (self, unit)
	return
end

NavBoxObstacle._editor_debug_draw = function (self, unit)
	if not self._should_debug_draw then
		return
	end

	local debug_color = Color.blue

	if self:get_data(unit, "is_static") then
		debug_color = Color.magenta
	end

	if self:get_data(unit, "fake_with_cost") then
		debug_color = Color.green
	end

	local box_center = self:get_data(unit, "box_center"):unbox()
	local box_extants = self:get_data(unit, "box_extants"):unbox()
	local world_pose = Unit.world_pose(unit, 1)
	local box_center_world = Matrix4x4.transform(world_pose, box_center)
	local box_pose_world = Matrix4x4.from_quaternion_position_scale(Matrix4x4.rotation(world_pose), box_center_world, Matrix4x4.scale(world_pose))

	self._drawer:box(box_pose_world, box_extants, debug_color())
end

NavBoxObstacle.component_data = {
	box_center = {
		ui_name = "Box Center",
		ui_type = "vector",
		value = Vector3Box(0, 0, 0),
	},
	box_extants = {
		ui_name = "Box Extants",
		ui_type = "vector",
		value = Vector3Box(1, 1, 1),
	},
	is_static = {
		ui_name = "Is Static",
		ui_type = "check_box",
		value = false,
	},
	fake_with_cost = {
		ui_name = "Should Fake With Cost",
		ui_type = "check_box",
		value = false,
	},
	extensions = {
		"NavBoxObstacleExtension",
	},
}

return NavBoxObstacle
