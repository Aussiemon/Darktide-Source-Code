-- chunkname: @scripts/extension_systems/event_synchronizer/mission_objective_zone_synchronizer_extension.lua

local MissionObjectiveZoneUtilites = require("scripts/extension_systems/mission_objective/utilities/mission_objective_zone")
local MissionObjectiveZoneSynchronizerExtension = class("MissionObjectiveZoneSynchronizerExtension", "EventSynchronizerBaseExtension")
local ZONE_TYPES = MissionObjectiveZoneUtilites.ZONE_TYPES

MissionObjectiveZoneSynchronizerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	MissionObjectiveZoneSynchronizerExtension.super.init(self, extension_init_context, unit, extension_init_data, ...)

	self._is_server = extension_init_context.is_server
	self._num_zones_in_mission_objective = 0
	self._objective_name = "default"
	self._automatic_start = false
	self._mission_objective_zone_system = nil
	self._zone_type = ZONE_TYPES.none
	self._servor_skull_activator_extension = nil

	Unit.flow_event(unit, "lua_unit_visibility_disable")
end

MissionObjectiveZoneSynchronizerExtension.setup_from_component = function (self, num_zones_in_mission_objective, objective_name, automatic_start)
	self._num_zones_in_mission_objective = num_zones_in_mission_objective
	self._objective_name = objective_name
	self._automatic_start = automatic_start

	self._mission_objective_system:register_objective_synchronizer(objective_name, self._unit)
end

MissionObjectiveZoneSynchronizerExtension.on_gameplay_post_init = function (self, level)
	self._mission_objective_zone_system = Managers.state.extension:system("mission_objective_zone_system")
end

MissionObjectiveZoneSynchronizerExtension.register_connected_units = function (self)
	local mission_objective_zone_system = self._mission_objective_zone_system
	local selected_units = mission_objective_zone_system:retrieve_selected_units_for_event(self._objective_name)

	return selected_units
end

MissionObjectiveZoneSynchronizerExtension.register_zone_type = function (self, zone_type)
	self._zone_type = zone_type
end

MissionObjectiveZoneSynchronizerExtension.register_servor_skull_activator_extension = function (self, servor_skull_activator_extension)
	self._servor_skull_activator_extension = servor_skull_activator_extension
end

MissionObjectiveZoneSynchronizerExtension.start_event = function (self)
	local mission_objective_zone_system = self._mission_objective_zone_system

	mission_objective_zone_system:reset_progression()

	if self._is_server then
		if self._servor_skull_activator_extension then
			self._servor_skull_activator_extension:on_start_event()
		end
	else
		mission_objective_zone_system:register_objective_name(self._objective_name)
	end
end

MissionObjectiveZoneSynchronizerExtension.num_zones_in_mission_objective = function (self)
	return self._num_zones_in_mission_objective
end

MissionObjectiveZoneSynchronizerExtension._num_scannables_in_zone = function (self)
	local mission_objective_zone_system = self._mission_objective_zone_system
	local current_active_zone_extension = mission_objective_zone_system:current_active_zone()
	local start_num_active_units = current_active_zone_extension:num_scannables_in_zone()

	return start_num_active_units
end

MissionObjectiveZoneSynchronizerExtension.has_connected_spline_path = function (self, objective_name)
	local mission_objective_zone_system = self._mission_objective_zone_system
	local has_connected_spline_path = mission_objective_zone_system:has_connected_spline_path(objective_name)

	return has_connected_spline_path
end

MissionObjectiveZoneSynchronizerExtension.has_current_active_zone = function (self)
	local mission_objective_zone_system = self._mission_objective_zone_system
	local current_active_zone = mission_objective_zone_system:current_active_zone()

	return current_active_zone ~= nil
end

MissionObjectiveZoneSynchronizerExtension.zone_type = function (self)
	return self._zone_type
end

MissionObjectiveZoneSynchronizerExtension.auto_start = function (self)
	return self._automatic_start
end

MissionObjectiveZoneSynchronizerExtension.zone_progression = function (self)
	local mission_objective_zone_system = self._mission_objective_zone_system

	return mission_objective_zone_system:progression()
end

MissionObjectiveZoneSynchronizerExtension.start_num_active_units = function (self)
	local start_num_active_units = 0

	if self._zone_type == ZONE_TYPES.scan then
		start_num_active_units = self:_num_scannables_in_zone()
	elseif self._zone_type == ZONE_TYPES.capture then
		start_num_active_units = self:num_zones_in_mission_objective()
	end

	return start_num_active_units
end

MissionObjectiveZoneSynchronizerExtension.progression = function (self)
	local mission_objective_zone_system = self._mission_objective_zone_system
	local progression

	if self._zone_type == ZONE_TYPES.scan then
		progression = mission_objective_zone_system:scannable_progression()
	else
		progression = mission_objective_zone_system:progression()
	end

	return progression
end

MissionObjectiveZoneSynchronizerExtension.second_progression = function (self)
	local mission_objective_zone_system = self._mission_objective_zone_system
	local second_progression = mission_objective_zone_system:second_progression()

	return second_progression
end

MissionObjectiveZoneSynchronizerExtension.at_start_of_spline = function (self)
	local unit = self._unit

	Unit.flow_event(unit, "lua_at_start_of_spline")
end

MissionObjectiveZoneSynchronizerExtension.at_end_of_spline = function (self)
	local unit = self._unit

	Unit.flow_event(unit, "lua_at_end_of_spline")
end

return MissionObjectiveZoneSynchronizerExtension
