-- chunkname: @scripts/extension_systems/mission_objective_target/mission_objective_target_extension.lua

local MissionObjectiveTargetExtension = class("MissionObjectiveTargetExtension")

MissionObjectiveTargetExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._is_server = extension_init_context.is_server
	self._unit = unit
	self._objective_name = "default"
	self._ui_target_type = "default"
	self._objective_stage = 1
	self._add_marker_on_registration = false
	self._add_marker_on_objective_start = true
	self._enabled_only_during_mission = false
	self._registered_objective = nil
	self._mission_objective_system = Managers.state.extension:system("mission_objective_system")
end

MissionObjectiveTargetExtension.setup_from_component = function (self, objective_name, ui_target_type, objective_stage, register_self, add_marker_on_registration, add_marker_on_objective_start, enabled_only_during_mission)
	self._objective_name = objective_name
	self._ui_target_type = ui_target_type
	self._objective_stage = objective_stage
	self._add_marker_on_registration = add_marker_on_registration
	self._add_marker_on_objective_start = add_marker_on_objective_start
	self._enabled_only_during_mission = enabled_only_during_mission

	if register_self then
		self:_setup()
	end
end

MissionObjectiveTargetExtension.setup_from_external = function (self, objective_name, ui_target_type, objective_stage, add_marker_on_registration, add_marker_on_objective_start, enabled_only_during_mission, sync_to_clients, peer_id)
	self._objective_name = objective_name or self._objective_name
	self._ui_target_type = ui_target_type or self._ui_target_type
	self._objective_stage = objective_stage or self._objective_stage

	if add_marker_on_registration ~= nil then
		self._add_marker_on_registration = add_marker_on_registration
	end

	if add_marker_on_objective_start ~= nil then
		self._add_marker_on_objective_start = add_marker_on_objective_start
	end

	if enabled_only_during_mission ~= nil then
		self._enabled_only_during_mission = enabled_only_during_mission
	end

	self:_setup()

	if self._is_server and sync_to_clients then
		local unit = self._unit
		local unit_spawner_manager = Managers.state.unit_spawner
		local unit_is_level_unit, unit_id = unit_spawner_manager:game_object_id_or_level_index(unit)
		local objective_name_id = NetworkLookup.mission_objective_names[objective_name]
		local ui_target_type_id = NetworkLookup.mission_objective_target_ui_types[ui_target_type]

		Managers.state.game_session:send_rpc_clients("rpc_mission_objective_target_setup", unit_id, unit_is_level_unit, objective_name_id, ui_target_type_id, objective_stage, add_marker_on_registration, add_marker_on_objective_start, enabled_only_during_mission)
	end
end

MissionObjectiveTargetExtension._setup = function (self)
	local objective_name = self._objective_name
	local objective_stage = self._objective_stage

	if objective_name ~= "default" and not self._registered_objective then
		local unit = self._unit

		self._registered_objective = objective_name

		self._mission_objective_system:register_objective_unit(objective_name, unit, objective_stage)

		if self._is_server and self._add_marker_on_registration then
			self:add_unit_marker()
		end

		if self._enabled_only_during_mission then
			self:disable_unit()
		end
	end
end

MissionObjectiveTargetExtension.add_unit_marker = function (self)
	local objective_name = self._objective_name
	local unit = self._unit

	self._mission_objective_system:add_marker(objective_name, unit)
end

MissionObjectiveTargetExtension.remove_unit_marker = function (self)
	local objective_name = self._objective_name
	local unit = self._unit

	self._mission_objective_system:remove_marker(objective_name, unit)
end

MissionObjectiveTargetExtension.enable_unit = function (self)
	local objective_name = self._objective_name
	local unit = self._unit
	local stage = self._objective_stage

	self._mission_objective_system:enable_unit(objective_name, unit, stage)
end

MissionObjectiveTargetExtension.disable_unit = function (self)
	local objective_name = self._objective_name
	local unit = self._unit
	local stage = self._objective_stage

	self._mission_objective_system:disable_unit(objective_name, unit, stage)
end

MissionObjectiveTargetExtension.set_objective_name = function (self, objective_name, sync)
	self._objective_name = objective_name

	if self._is_server and sync then
		local unit = self._unit
		local unit_spawner_manager = Managers.state.unit_spawner
		local unit_is_level_unit, unit_id = unit_spawner_manager:game_object_id_or_level_index(unit)
		local objective_name_id = NetworkLookup.mission_objective_names[objective_name]

		Managers.state.game_session:send_rpc_clients("rpc_mission_objective_target_set_objective_name", unit_id, unit_is_level_unit, objective_name_id)
	end
end

MissionObjectiveTargetExtension.objective_name = function (self)
	return self._objective_name
end

MissionObjectiveTargetExtension.set_ui_target_type = function (self, ui_target_type)
	self._ui_target_type = ui_target_type
end

MissionObjectiveTargetExtension.ui_target_type = function (self)
	return self._ui_target_type
end

MissionObjectiveTargetExtension.objective_stage = function (self)
	return self._objective_stage
end

MissionObjectiveTargetExtension.should_add_marker_on_registration = function (self)
	return self._add_marker_on_registration
end

MissionObjectiveTargetExtension.set_add_marker_on_objective_start = function (self, state)
	self._add_marker_on_objective_start = state
end

MissionObjectiveTargetExtension.should_add_marker_on_objective_start = function (self)
	return self._add_marker_on_objective_start
end

MissionObjectiveTargetExtension.enabled_only_during_mission = function (self)
	return self._enabled_only_during_mission
end

return MissionObjectiveTargetExtension
