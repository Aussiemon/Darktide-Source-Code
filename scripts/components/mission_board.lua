local MissionBoard = component("MissionBoard")

MissionBoard.init = function (self, unit)
	local mission_board_extension = ScriptUnit.fetch_component_extension(unit, "mission_board_system")

	if mission_board_extension then
		local camera_goto_height = self:get_data(unit, "camera_goto_height")
		local camera_goto_radius = self:get_data(unit, "camera_goto_radius")
		local camera_goto_right = self:get_data(unit, "camera_goto_right")
		local camera_rotation_acceleration = self:get_data(unit, "camera_rotation_acceleration")
		local camera_rotation_deceleration = self:get_data(unit, "camera_rotation_deceleration")
		local camera_rotation_wanted_speed = self:get_data(unit, "camera_rotation_wanted_speed")

		mission_board_extension:setup_from_component(camera_goto_height, camera_goto_radius, camera_goto_right, camera_rotation_acceleration, camera_rotation_deceleration, camera_rotation_wanted_speed)
	end
end

MissionBoard.editor_init = function (self, unit)
	return
end

MissionBoard.enable = function (self, unit)
	return
end

MissionBoard.disable = function (self, unit)
	return
end

MissionBoard.destroy = function (self, unit)
	return
end

MissionBoard.component_data = {
	camera_goto_height = {
		ui_type = "number",
		min = 0,
		step = 1,
		decimals = 0,
		value = 1,
		ui_name = "Camera goto Height",
		max = 10
	},
	camera_goto_radius = {
		ui_type = "number",
		min = 0,
		step = 1,
		decimals = 0,
		value = 1,
		ui_name = "Camera goto Radius",
		max = 25
	},
	camera_goto_right = {
		ui_type = "number",
		min = 0,
		step = 1,
		decimals = 0,
		value = 1,
		ui_name = "Camera pan Right",
		max = 10
	},
	camera_rotation_acceleration = {
		ui_type = "number",
		min = 0,
		step = 0.01,
		value = 0.05,
		ui_name = "Camera rotation Acceleration",
		max = 0.1
	},
	camera_rotation_deceleration = {
		ui_type = "number",
		min = 0,
		step = 0.01,
		value = 0.05,
		ui_name = "Camera rotation Deceleration",
		max = 0.1
	},
	camera_rotation_wanted_speed = {
		ui_type = "number",
		min = 0,
		step = 0.01,
		value = 0.03,
		ui_name = "Camera rotation Wanted Speed",
		max = 0.1
	},
	extensions = {
		"MissionBoardExtension"
	}
}

return MissionBoard
