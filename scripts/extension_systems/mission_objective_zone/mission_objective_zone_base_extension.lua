local MissionObjectiveZoneBaseExtension = class("MissionObjectiveZoneBaseExtension")
MissionObjectiveZoneBaseExtension.UPDATE_DISABLED_BY_DEFAULT = true
local UNIT_MARKER_STATES = table.enum("add", "remove")

MissionObjectiveZoneBaseExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._is_server = extension_init_context.is_server
	self._owner_system = extension_init_context.owner_system
	self._unit = unit
	self._activated = false
	self._mission_objective_target_extension = nil
	self._zone_type = ""
	local mission_objective_zone_system = Managers.state.extension:system("mission_objective_zone_system")
	self._mission_objective_zone_system = mission_objective_zone_system
	self._mission_objective_system = Managers.state.extension:system("mission_objective_system")
end

MissionObjectiveZoneBaseExtension.setup_from_component = function (self)
	return
end

MissionObjectiveZoneBaseExtension.extensions_ready = function (self, world, unit)
	self._mission_objective_target_extension = ScriptUnit.extension(self._unit, "mission_objective_target_system")
end

MissionObjectiveZoneBaseExtension.point_in_zone = function (self, position)
	return Unit.is_point_inside_volume(self._unit, "g_mission_objective_zone_volume", position)
end

MissionObjectiveZoneBaseExtension.zone_finished = function (self)
	if self._is_server then
		local unit = self._unit
		local level_object_id = Managers.state.unit_spawner:level_index(unit)
		local mission_objective_zone_system = Managers.state.extension:system("mission_objective_zone_system")

		mission_objective_zone_system:register_finished_zone()

		local game_session_manager = Managers.state.game_session

		game_session_manager:send_rpc_clients("rpc_mission_objective_zone_finished", level_object_id)
	end

	self:_deactivate_zone()
end

MissionObjectiveZoneBaseExtension.activate_zone = function (self)
	self._activated = true

	self:_set_unit_marker_state(UNIT_MARKER_STATES.add)
	self:_enable_update()
end

MissionObjectiveZoneBaseExtension._deactivate_zone = function (self)
	self._activated = false

	self:_set_unit_marker_state(UNIT_MARKER_STATES.remove)
	self:_disable_update()
end

MissionObjectiveZoneBaseExtension.activated = function (self)
	return self._activated
end

MissionObjectiveZoneBaseExtension.zone_type = function (self)
	return self._zone_type
end

MissionObjectiveZoneBaseExtension.set_seed = function (self, seed)
	self._seed = seed
end

MissionObjectiveZoneBaseExtension._set_unit_marker_state = function (self, marker_state)
	if self._is_server then
		if marker_state == UNIT_MARKER_STATES.add then
			self._mission_objective_target_extension:add_unit_marker()
		elseif marker_state == UNIT_MARKER_STATES.remove then
			self._mission_objective_target_extension:remove_unit_marker()
		end
	end
end

MissionObjectiveZoneBaseExtension.current_progression = function (self)
	return
end

MissionObjectiveZoneBaseExtension._enable_update = function (self)
	self._owner_system:enable_update_function(self.__class_name, "update", self._unit, self)
end

MissionObjectiveZoneBaseExtension._disable_update = function (self)
	self._owner_system:disable_update_function(self.__class_name, "update", self._unit, self)
end

MissionObjectiveZoneBaseExtension.unit = function (self)
	return self._unit
end

return MissionObjectiveZoneBaseExtension
