-- chunkname: @scripts/components/mission_objective_target.lua

local MissionObjectiveTarget = component("MissionObjectiveTarget")
local TARGET_EVENT_TYPE = table.enum("none", "interactable", "destructible", "scanning")

MissionObjectiveTarget.init = function (self, unit)
	self._event_type = TARGET_EVENT_TYPE.none

	local mission_objective_target_extension = ScriptUnit.fetch_component_extension(unit, "mission_objective_target_system")

	if mission_objective_target_extension then
		local objective_name = self:_retrieve_objective_name(unit)
		local ui_target_type = self:get_data(unit, "ui_target_type")
		local objective_stage = self:get_data(unit, "objective_stage")
		local register_self = self:get_data(unit, "register_self")
		local add_marker_on_registration = self:get_data(unit, "add_marker_on_registration")
		local add_marker_on_objective_start = self:get_data(unit, "add_marker_on_objective_start")
		local unit_enabled = self:get_data(unit, "unit_enabled")
		local enabled_only_during_mission = unit_enabled == "only_mission"

		mission_objective_target_extension:setup_from_component(objective_name, ui_target_type, objective_stage, register_self, add_marker_on_registration, add_marker_on_objective_start, enabled_only_during_mission)

		self._mission_objective_target_extension = mission_objective_target_extension

		local start_visible = self:get_data(unit, "start_visible")

		if Unit.has_visibility_group(unit, "main") and not start_visible then
			Unit.set_visibility(unit, "main", false)
		end
	end
end

MissionObjectiveTarget._retrieve_objective_name = function (self, unit)
	local objective_name = self:get_data(unit, "objective_name")
	local is_side_mission = self:get_data(unit, "is_side_mission")

	if is_side_mission then
		local side_objective_type = self:get_data(unit, "side_objective_type")
		local side_mission = Managers.state.mission:side_mission()

		if side_mission and side_objective_type == side_mission.side_objective_type then
			objective_name = side_mission.name
		end
	end

	return objective_name
end

MissionObjectiveTarget.events.interactable_enable = function (self)
	local mission_objective_target_extension = self._mission_objective_target_extension

	if mission_objective_target_extension then
		if mission_objective_target_extension:should_add_marker_on_objective_start() then
			mission_objective_target_extension:add_unit_marker()
		end

		self._event_type = TARGET_EVENT_TYPE.interactable
	end
end

MissionObjectiveTarget.events.interactable_disable = function (self)
	local mission_objective_target_extension = self._mission_objective_target_extension

	if mission_objective_target_extension and self._event_type == TARGET_EVENT_TYPE.interactable then
		mission_objective_target_extension:remove_unit_marker()
	end
end

MissionObjectiveTarget.events.interaction_success = function (self)
	local mission_objective_target_extension = self._mission_objective_target_extension

	if mission_objective_target_extension and self._event_type == TARGET_EVENT_TYPE.interactable then
		mission_objective_target_extension:remove_unit_marker()
	end
end

MissionObjectiveTarget.events.destructible_enable = function (self)
	local mission_objective_target_extension = self._mission_objective_target_extension

	if mission_objective_target_extension then
		if mission_objective_target_extension:should_add_marker_on_objective_start() then
			mission_objective_target_extension:add_unit_marker()
		end

		self._event_type = TARGET_EVENT_TYPE.destructible
	end
end

MissionObjectiveTarget.events.destructible_destroyed = function (self)
	local mission_objective_target_extension = self._mission_objective_target_extension

	if mission_objective_target_extension and self._event_type == TARGET_EVENT_TYPE.destructible then
		mission_objective_target_extension:remove_unit_marker()
	end
end

MissionObjectiveTarget.editor_init = function (self, unit)
	return
end

MissionObjectiveTarget.editor_validate = function (self, unit)
	return true, ""
end

MissionObjectiveTarget.editor_update = function (self, unit, dt)
	return
end

MissionObjectiveTarget.enable = function (self, unit)
	return
end

MissionObjectiveTarget.disable = function (self, unit)
	return
end

MissionObjectiveTarget.destroy = function (self, unit)
	return
end

MissionObjectiveTarget.objective_marker_enable = function (self)
	local mission_objective_target_extension = self._mission_objective_target_extension

	mission_objective_target_extension:add_unit_marker()
end

MissionObjectiveTarget.objective_marker_disable = function (self)
	local mission_objective_target_extension = self._mission_objective_target_extension

	mission_objective_target_extension:remove_unit_marker()
end

MissionObjectiveTarget.component_data = {
	ui_target_type = {
		value = "default",
		ui_type = "combo_box",
		category = "UI",
		ui_name = "UI Icon Type",
		options_keys = {
			"default",
			"demolition",
			"decode",
			"escort",
			"kill",
			"resupply",
			"scanning"
		},
		options_values = {
			"default",
			"demolition",
			"decode",
			"escort",
			"kill",
			"resupply",
			"scanning"
		}
	},
	objective_name = {
		ui_type = "text_box",
		value = "default",
		ui_name = "Objective Name"
	},
	register_self = {
		ui_type = "check_box",
		value = true,
		ui_name = "Register Self"
	},
	add_marker_on_registration = {
		ui_type = "check_box",
		value = false,
		ui_name = "Add Marker on Registration"
	},
	add_marker_on_objective_start = {
		ui_type = "check_box",
		value = true,
		ui_name = "Add Marker on Objective Start"
	},
	objective_stage = {
		value = 1,
		min = 1,
		ui_type = "number",
		decimals = 0,
		ui_name = "Objective Stage"
	},
	unit_enabled = {
		value = "enabled",
		ui_type = "combo_box",
		ui_name = "Enabled Options",
		options_keys = {
			"Unit Enabled",
			"Unit Enabled only during Mission Event"
		},
		options_values = {
			"enabled",
			"only_mission"
		}
	},
	start_visible = {
		ui_type = "check_box",
		value = true,
		ui_name = "Starts visible"
	},
	is_side_mission = {
		ui_type = "check_box",
		value = false,
		ui_name = "Is Side Mission",
		category = "Side Mission"
	},
	side_objective_type = {
		value = "none",
		ui_type = "combo_box",
		category = "Side Mission",
		ui_name = "Side Objective Type",
		options_keys = {
			"none",
			"luggable",
			"collect"
		},
		options_values = {
			"none",
			"luggable",
			"collect"
		}
	},
	inputs = {
		objective_marker_enable = {
			accessibility = "public",
			type = "event"
		},
		objective_marker_disable = {
			accessibility = "public",
			type = "event"
		}
	},
	extensions = {
		"MissionObjectiveTargetExtension"
	}
}

return MissionObjectiveTarget
