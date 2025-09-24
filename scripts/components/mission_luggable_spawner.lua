-- chunkname: @scripts/components/mission_luggable_spawner.lua

local MissionLuggableSpawner = component("MissionLuggableSpawner")

MissionLuggableSpawner.init = function (self, unit, is_server)
	self._unit = unit
	self._is_server = is_server
end

MissionLuggableSpawner.editor_init = function (self, unit)
	return
end

MissionLuggableSpawner.editor_validate = function (self, unit)
	return true, ""
end

MissionLuggableSpawner.enable = function (self, unit)
	return
end

MissionLuggableSpawner.disable = function (self, unit)
	return
end

MissionLuggableSpawner.destroy = function (self, unit)
	return
end

MissionLuggableSpawner.spawn_mission_luggable = function (self)
	if self._is_server then
		local unit = self._unit
		local mission_target_extension = ScriptUnit.extension(unit, "mission_objective_target_system")
		local objective_name = mission_target_extension:objective_name()
		local group_id = mission_target_extension:objective_group_id()
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")
		local synchronizer_unit = mission_objective_system:objective_synchronizer_unit(objective_name, group_id)
		local synchronizer_extension = ScriptUnit.extension(synchronizer_unit, "event_synchronizer_system")

		synchronizer_extension:spawn_luggable(unit)
	end
end

MissionLuggableSpawner.activate_objective_target_on_luggable = function (self)
	if self._is_server then
		local unit = self._unit
		local mission_target_extension = ScriptUnit.extension(unit, "mission_objective_target_system")
		local objective_name = mission_target_extension:objective_name()
		local group_id = mission_target_extension:objective_group_id()
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")
		local synchronizer_unit = mission_objective_system:objective_synchronizer_unit(objective_name, group_id)
		local synchronizer_extension = ScriptUnit.extension(synchronizer_unit, "event_synchronizer_system")

		synchronizer_extension:add_marker_on_luggable(unit)
	end
end

MissionLuggableSpawner.component_data = {
	inputs = {
		spawn_mission_luggable = {
			accessibility = "public",
			type = "event",
		},
		activate_objective_target_on_luggable = {
			accessibility = "public",
			type = "event",
		},
	},
}

return MissionLuggableSpawner
