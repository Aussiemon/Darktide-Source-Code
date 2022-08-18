local MissionObjectiveList = class("MissionObjectiveList")

MissionObjectiveList.init = function (self, context, system_init_data, ...)
	self._active_objectives = {}
	self._completed_objectives = {}
	self._level_end_objectives = {}
	self._objective_registered_synchronizer = {}
	self._objective_registered_units = {}
end

MissionObjectiveList.active_objectives = function (self)
	return self._active_objectives
end

MissionObjectiveList.get_active_objective = function (self, objective_name)
	return self._active_objectives[objective_name]
end

MissionObjectiveList.add_active_objective = function (self, objective_name, objective)
	self._active_objectives[objective_name] = objective
end

MissionObjectiveList.set_objective_to_completed = function (self, objective_name)
	self._completed_objectives[objective_name] = self._active_objectives[objective_name]
	self._active_objectives[objective_name] = nil
end

MissionObjectiveList.completed_objectives = function (self)
	return self._completed_objectives
end

MissionObjectiveList.get_complete_objective = function (self, objective_name)
	return self._completed_objectives[objective_name]
end

MissionObjectiveList.add_level_end_objectives = function (self, objective_name, objective)
	self._level_end_objectives[objective_name] = objective
end

MissionObjectiveList.level_end_objectives = function (self)
	return self._level_end_objectives
end

MissionObjectiveList.register_unit = function (self, objective_name, objective_stage, objective_unit)
	local objective_units = self._objective_registered_units[objective_name]

	if not objective_units then
		objective_units = {}
		self._objective_registered_units[objective_name] = objective_units
	end

	local stage_units = objective_units[objective_stage]

	if not stage_units then
		stage_units = {}
		objective_units[objective_stage] = stage_units
	end

	table.insert(stage_units, objective_unit)

	local active_objective = self._active_objectives[objective_name]

	if active_objective and active_objective:stage() == objective_stage then
		active_objective:register_unit(objective_unit)
	end
end

MissionObjectiveList.unregister_unit = function (self, objective_name, objective_stage, objective_unit)
	local active_objective = self._active_objectives[objective_name]

	if active_objective and active_objective:stage() == objective_stage then
		active_objective:unregister_unit(objective_unit)
	end

	local objective_units = self._objective_registered_units[objective_name]

	if not objective_units then
		return
	end

	local stage_units = objective_units[objective_stage]

	if stage_units then
		local index = table.find(stage_units, objective_unit)

		table.remove(stage_units, index)
	end
end

MissionObjectiveList.objective_registered_units = function (self, objective_name)
	return self._objective_registered_units[objective_name]
end

MissionObjectiveList.register_synchronizer_unit = function (self, objective_name, objective_unit)
	self._objective_registered_synchronizer[objective_name] = objective_unit
end

MissionObjectiveList.objective_registered_synchronizer = function (self, objective_name)
	return self._objective_registered_synchronizer[objective_name]
end

return MissionObjectiveList
