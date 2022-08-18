local MissionObjectiveSystemTestify = {
	fetch_active_units_from_objective_system = function (objective_name, objective_system)
		local objective = objective_system:get_active_objective(objective_name)

		if objective then
			return objective:objective_units()
		end

		return nil
	end,
	fetch_synchronizer_unit_from_objective_system = function (objective_name, objective_system)
		local objective = objective_system:get_active_objective(objective_name)

		if objective then
			return objective:synchronizer_unit()
		end

		return nil
	end
}

return MissionObjectiveSystemTestify
