local MissionObjectiveTestify = {
	wait_for_progression_update_from_objective_system = function (objective_data, objective_system, current_objective_name)
		local objective_name = objective_data.objective_name

		if objective_name ~= current_objective_name then
			return Testify.RETRY
		end

		local last_progression = objective_data.last_progression
		local objective = objective_system:get_active_objective(objective_name)
		local progression = nil

		if objective then
			progression = objective:progression()
		end

		if progression == 1 or progression ~= last_progression then
			return progression
		end

		return Testify.RETRY
	end
}

return MissionObjectiveTestify
