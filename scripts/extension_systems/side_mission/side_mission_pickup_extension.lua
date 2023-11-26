-- chunkname: @scripts/extension_systems/side_mission/side_mission_pickup_extension.lua

local SideMissionPickupExtension = class("SideMissionPickupExtension")

SideMissionPickupExtension.init = function (self, extension_init_context, unit, extension_init_data)
	self:_register_to_mission_objective(unit)
end

SideMissionPickupExtension._register_to_mission_objective = function (self, unit)
	local side_mission = Managers.state.mission:side_mission()

	if side_mission then
		local objective_name = side_mission.name
		local objective_stage = 1
		local ui_target_type = "default"
		local add_marker_on_registration = false
		local add_marker_on_objective_start = false
		local enabled_only_during_mission = false
		local sync_to_clients = false
		local mission_objective_target_extension = ScriptUnit.extension(unit, "mission_objective_target_system")

		mission_objective_target_extension:setup_from_external(objective_name, ui_target_type, objective_stage, add_marker_on_registration, add_marker_on_objective_start, enabled_only_during_mission, sync_to_clients)
	end
end

return SideMissionPickupExtension
