local pickup_data = {
	description = "loc_pickup_side_mission_pocketable_02",
	name = "tome",
	smart_tag_target_type = "pickup",
	spawn_weighting = 1,
	game_object_type = "pickup",
	is_side_mission_pickup = true,
	unit_name = "content/pickups/pocketables/side_mission/tome/tome_pickup_01",
	look_at_tag = "none",
	unit_template_name = "pickup",
	interaction_type = "pocketable",
	pickup_sound = "wwise/events/player/play_pick_up_tome",
	group = "side_mission_collect",
	inventory_item = "content/items/pocketable/tome_pocketable",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local mission_objective_target_extension = ScriptUnit.extension(pickup_unit, "mission_objective_target_system")
		local objective_name = mission_objective_target_extension:objective_name()
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")

		if mission_objective_system:is_current_active_objective(objective_name) then
			local synchronizer_unit = mission_objective_system:get_objective_synchronizer_unit(objective_name)
			local synchronizer_extension = ScriptUnit.extension(synchronizer_unit, "event_synchronizer_system")
			local increment_value = 1

			synchronizer_extension:update_progression(increment_value, pickup_data)
		end
	end,
	on_drop_func = function (unit)
		local mission_objective_target_extension = ScriptUnit.extension(unit, "mission_objective_target_system")
		local objective_name = mission_objective_target_extension:objective_name()
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")

		if mission_objective_system:is_current_active_objective(objective_name) then
			local synchronizer_unit = mission_objective_system:get_objective_synchronizer_unit(objective_name)
			local synchronizer_extension = ScriptUnit.extension(synchronizer_unit, "event_synchronizer_system")
			local increment_value = -1

			synchronizer_extension:update_progression(increment_value)
		end
	end
}

return pickup_data
