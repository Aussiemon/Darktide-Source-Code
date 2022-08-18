local MinionState = {
	is_sleeping_deamonhost = function (unit)
		if not unit then
			return false
		end

		local unit_data = ScriptUnit.has_extension(unit, "unit_data_system")
		local target_breed = unit_data and unit_data:breed()

		if not target_breed then
			return false
		end

		local breed_name = target_breed.name

		if breed_name ~= "chaos_daemonhost" then
			return false
		end

		local behavior_extension = ScriptUnit.has_extension(unit, "behavior_system")
		local brain = behavior_extension and behavior_extension:brain()
		local current_action = brain and brain:running_action()

		if current_action ~= "sleeping" and current_action ~= "passive" then
			return false
		end

		return true
	end,
	is_staggered = function (unit)
		local target_blackboard = BLACKBOARDS[unit]

		if target_blackboard then
			local stagger_component = target_blackboard.stagger
			local num_triggered_staggers = stagger_component.num_triggered_staggers

			return num_triggered_staggers > 0
		end

		return nil
	end
}

return MinionState
