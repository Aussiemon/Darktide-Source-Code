-- chunkname: @scripts/components/mission_objective_zone_capture.lua

local MissionObjectiveZoneCapture = component("MissionObjectiveZoneCapture")

MissionObjectiveZoneCapture.init = function (self, unit)
	local mission_objective_zone_extension = ScriptUnit.fetch_component_extension(unit, "mission_objective_zone_system")

	if mission_objective_zone_extension then
		local return_to_skull = self:get_data(unit, "return_to_skull")
		local num_player_in_zone = self:get_data(unit, "num_player_in_zone")
		local require_half_playes = self:get_data(unit, "require_half_playes")
		local time_in_zone = self:get_data(unit, "time_in_zone")
		local show_border = self:get_data(unit, "show_border")
		local border_offset = self:get_data(unit, "border_offset")
		local border_height_scale = self:get_data(unit, "border_max_height_percentage")

		mission_objective_zone_extension:setup_from_component(return_to_skull, num_player_in_zone, require_half_playes, time_in_zone, show_border, border_offset, border_height_scale)
	end
end

MissionObjectiveZoneCapture.editor_validate = function (self, unit)
	return true, ""
end

MissionObjectiveZoneCapture.editor_update = function (self, unit, dt)
	return
end

MissionObjectiveZoneCapture.enable = function (self, unit)
	return
end

MissionObjectiveZoneCapture.disable = function (self, unit)
	return
end

MissionObjectiveZoneCapture.destroy = function (self, unit)
	return
end

MissionObjectiveZoneCapture.component_data = {
	return_to_skull = {
		ui_name = "Return to servo skull",
		ui_type = "check_box",
		value = false,
	},
	num_player_in_zone = {
		ui_name = "Players in zone",
		ui_type = "number",
		value = 1,
	},
	require_half_playes = {
		ui_name = "Require half players",
		ui_type = "check_box",
		value = false,
	},
	time_in_zone = {
		ui_name = "Time in zone",
		ui_type = "number",
		value = 60,
	},
	show_border = {
		ui_name = "Show Border",
		ui_type = "check_box",
		value = false,
	},
	border_max_height_percentage = {
		decimals = 2,
		max = 1,
		min = 0,
		step = 0.01,
		ui_name = "Border Max Height %",
		ui_type = "slider",
		value = 1,
	},
	border_offset = {
		decimals = 2,
		max = 2,
		min = 0,
		step = 0.01,
		ui_name = "Border Offset",
		ui_type = "slider",
		value = 0.5,
	},
	extensions = {
		"NetworkedTimerExtension",
		"MissionObjectiveZoneCaptureExtension",
	},
}

return MissionObjectiveZoneCapture
