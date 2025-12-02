-- chunkname: @scripts/components/mission_objective_zone_capture.lua

local MissionObjectiveZoneCapture = component("MissionObjectiveZoneCapture")

MissionObjectiveZoneCapture.init = function (self, unit)
	local mission_objective_zone_extension = ScriptUnit.fetch_component_extension(unit, "mission_objective_zone_system")

	if mission_objective_zone_extension then
		local num_player_in_zone = self:get_data(unit, "num_player_in_zone")
		local time_in_zone = self:get_data(unit, "time_in_zone")

		mission_objective_zone_extension:setup_from_component(num_player_in_zone, time_in_zone)
	end
end

MissionObjectiveZoneCapture.editor_init = function (self, unit)
	return
end

MissionObjectiveZoneCapture.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
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
	num_player_in_zone = {
		ui_name = "Players in zone",
		ui_type = "number",
		value = 1,
	},
	time_in_zone = {
		ui_name = "Time in zone",
		ui_type = "number",
		value = 60,
	},
	extensions = {
		"MissionObjectiveZoneCaptureExtension",
	},
}

return MissionObjectiveZoneCapture
