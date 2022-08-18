local MissionBoardExtension = class("MissionBoardExtension")
local VIEW_NAME = "mission_board_view"

MissionBoardExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._input_index = 0
	self._camera_goto_height = 0
	self._camera_goto_radius = 0
	self._camera_goto_right = 0
	self._camera_rotation_acceleration = 0
	self._camera_rotation_deceleration = 0
	self._camera_rotation_wanted_speed = 0
	self._camera_movement = 0
end

MissionBoardExtension.setup_from_component = function (self, camera_goto_height, camera_goto_radius, camera_goto_right, camera_rotation_acceleration, camera_rotation_deceleration, camera_rotation_wanted_speed)
	self._camera_goto_height = camera_goto_height
	self._camera_goto_radius = camera_goto_radius
	self._camera_goto_right = camera_goto_right
	self._camera_rotation_acceleration = camera_rotation_acceleration
	self._camera_rotation_deceleration = camera_rotation_deceleration
	self._camera_rotation_wanted_speed = camera_rotation_wanted_speed
end

MissionBoardExtension.destroy = function (self, unit)
	local ui_manager = Managers.ui

	if ui_manager and ui_manager:view_active(VIEW_NAME) then
		ui_manager:close_view(VIEW_NAME)
	end
end

MissionBoardExtension.pre_update = function (self, main_t, main_dt, input, sensitivity_modifier)
	local acceleration = self._camera_rotation_acceleration
	local deceleration = self._camera_rotation_deceleration
	local wanted_speed = self._camera_rotation_wanted_speed
	local input_index = self._input_index
	self._input_index = 0
	local movement = self._camera_movement
	local move_right = input_index == -1
	local move_left = input_index == 1

	if move_right then
		movement = math.max(movement - acceleration * main_dt, -wanted_speed)
	elseif move_left then
		movement = math.min(movement + acceleration * main_dt, wanted_speed)
	elseif movement ~= 0 then
		movement = (movement > 0 and math.max(movement - deceleration * main_dt, 0)) or math.min(movement + deceleration * main_dt, 0)
	end

	self._camera_movement = movement
end

MissionBoardExtension.zoom = function (self, zoom, node_name)
	local camera_node_name = (zoom and "mission_board_zoom") or "mission_board"

	if zoom then
		local node_index = Unit.node(self._unit, node_name)
		local original_position = Vector3(0, 0, 0)
		local node_position = Unit.local_position(self._unit, node_index)
		local normalized_direction = Vector3.normalize(original_position - node_position)
		local rotation = Quaternion.look(normalized_direction)
		self._camera_zoom_rotation = QuaternionBox(rotation)
	end

	local camera_extension = ScriptUnit.extension(self._unit, "camera_system")

	camera_extension:change_node(camera_node_name)

	self._is_zooming = zoom
end

MissionBoardExtension.node_index = function (self, node_name)
	if not Unit.has_node(self._unit, node_name) then
		return
	end

	return Unit.node(self._unit, node_name)
end

MissionBoardExtension.node_position = function (self, node_name)
	local node_index = Unit.node(self._unit, node_name)
	local node_position = Unit.world_position(self._unit, node_index)

	return node_position
end

MissionBoardExtension.is_zooming = function (self)
	return self._is_zooming
end

MissionBoardExtension.camera_zoom_rotation = function (self)
	return self._camera_zoom_rotation
end

MissionBoardExtension.move_right = function (self, moving)
	self._input_index = -1
end

MissionBoardExtension.move_left = function (self)
	self._input_index = 1
end

MissionBoardExtension.movement = function (self)
	return self._camera_movement
end

MissionBoardExtension.camera_goto_height = function (self)
	return self._camera_goto_height
end

MissionBoardExtension.camera_goto_radius = function (self)
	return self._camera_goto_radius
end

MissionBoardExtension.camera_goto_right = function (self)
	return self._camera_goto_right
end

MissionBoardExtension.camera_rotation_acceleration = function (self)
	return self._camera_rotation_acceleration
end

MissionBoardExtension.camera_rotation_deceleration = function (self)
	return self._camera_rotation_deceleration
end

MissionBoardExtension.camera_rotation_wanted_speed = function (self)
	return self._camera_rotation_wanted_speed
end

return MissionBoardExtension
