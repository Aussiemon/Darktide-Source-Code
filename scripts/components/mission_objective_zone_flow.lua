-- chunkname: @scripts/components/mission_objective_zone_flow.lua

local MissionObjectiveZoneFlow = component("MissionObjectiveZoneFlow")

MissionObjectiveZoneFlow.init = function (self, unit)
	local mission_objective_zone_extension = ScriptUnit.fetch_component_extension(unit, "mission_objective_zone_system")

	self._mission_objective_zone_extension = mission_objective_zone_extension

	if mission_objective_zone_extension then
		local return_to_skull = self:get_data(unit, "return_to_skull")
		local max_progress = self:get_data(unit, "max_progress")
		local progress_ui_type = self:get_data(unit, "progress_ui_type")

		mission_objective_zone_extension:setup_from_component(max_progress, progress_ui_type)
	end
end

MissionObjectiveZoneFlow.editor_init = function (self, unit)
	return
end

MissionObjectiveZoneFlow.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

MissionObjectiveZoneFlow.editor_update = function (self, unit, dt)
	return
end

MissionObjectiveZoneFlow.enable = function (self, unit)
	return
end

MissionObjectiveZoneFlow.disable = function (self, unit)
	return
end

MissionObjectiveZoneFlow.destroy = function (self, unit)
	return
end

MissionObjectiveZoneFlow.increment_progression = function (self)
	if self._mission_objective_zone_extension then
		self._mission_objective_zone_extension:increment_progression()
	end
end

MissionObjectiveZoneFlow.component_data = {
	return_to_skull = {
		ui_name = "Return to servo skull",
		ui_type = "check_box",
		value = false,
	},
	max_progress = {
		ui_name = "Max Progress",
		ui_type = "number",
		value = 1,
	},
	progress_ui_type = {
		category = "UI",
		ui_name = "UI Progress Type",
		ui_type = "combo_box",
		value = "none",
		options_keys = {
			"bar",
			"counter",
			"none",
		},
		options_values = {
			"bar",
			"counter",
			"none",
		},
	},
	inputs = {
		increment_progression = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {
		"MissionObjectiveZoneFlowExtension",
	},
}

return MissionObjectiveZoneFlow
