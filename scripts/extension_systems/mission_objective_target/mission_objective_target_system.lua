require("scripts/extension_systems/mission_objective_target/mission_objective_target_extension")

local MissionObjectiveTargetSystem = class("MissionObjectiveTargetSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_mission_objective_target_set_objective_name",
	"rpc_mission_objective_target_setup"
}

MissionObjectiveTargetSystem.init = function (self, extension_system_creation_context, ...)
	MissionObjectiveTargetSystem.super.init(self, extension_system_creation_context, ...)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

MissionObjectiveTargetSystem.destroy = function (self, ...)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	MissionObjectiveTargetSystem.super.destroy(self, ...)
end

MissionObjectiveTargetSystem.hot_join_sync = function (self, sender, channel)
	local unit_spawner_manager = Managers.state.unit_spawner
	local unit_to_extension_map = self._unit_to_extension_map

	for target_unit, extension in pairs(unit_to_extension_map) do
		local target_unit_is_level_unit = false
		local target_unit_id = unit_spawner_manager:game_object_id(target_unit)

		if not target_unit_id then
			target_unit_id = unit_spawner_manager:level_index(target_unit)

			if target_unit_id then
				target_unit_is_level_unit = true
			end
		end

		if target_unit_id then
			local objective_name = extension:objective_name()

			if objective_name then
				local objective_name_id = NetworkLookup.mission_objective_names[objective_name]
				local ui_target_type = extension:ui_target_type()
				local ui_target_type_id = NetworkLookup.mission_objective_target_ui_types[ui_target_type]
				local objective_stage = extension:objective_stage()
				local add_marker_on_registration = extension:should_add_marker_on_registration()
				local add_marker_on_objective_start = extension:should_add_marker_on_objective_start()
				local enabled_only_during_mission = extension:enabled_only_during_mission()

				RPC.rpc_mission_objective_target_setup(channel, target_unit_id, target_unit_is_level_unit, objective_name_id, ui_target_type_id, objective_stage, add_marker_on_registration, add_marker_on_objective_start, enabled_only_during_mission)
			end
		end
	end
end

MissionObjectiveTargetSystem.rpc_mission_objective_target_set_objective_name = function (self, channel, target_unit_id, target_unit_is_level_unit, objective_name_id)
	local unit_spawner_manager = Managers.state.unit_spawner
	local target_unit = unit_spawner_manager:unit(target_unit_id, target_unit_is_level_unit)
	local objective_name = NetworkLookup.mission_objective_names[objective_name_id]
	local extension = self._unit_to_extension_map[target_unit]

	extension:set_objective_name(objective_name)
end

MissionObjectiveTargetSystem.rpc_mission_objective_target_setup = function (self, channel, target_unit_id, target_unit_is_level_unit, objective_name_id, ui_target_type_id, objective_stage, add_marker_on_registration, add_marker_on_objective_start, enabled_only_during_mission)
	local unit_spawner_manager = Managers.state.unit_spawner
	local target_unit = unit_spawner_manager:unit(target_unit_id, target_unit_is_level_unit)
	local objective_name = NetworkLookup.mission_objective_names[objective_name_id]
	local ui_target_type = NetworkLookup.mission_objective_target_ui_types[ui_target_type_id]
	local extension = self._unit_to_extension_map[target_unit]

	extension:setup_from_external(objective_name, ui_target_type, objective_stage, add_marker_on_registration, add_marker_on_objective_start, enabled_only_during_mission)
end

return MissionObjectiveTargetSystem
