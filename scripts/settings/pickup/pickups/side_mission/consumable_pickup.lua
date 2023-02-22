local pickup_data = {
	description = "loc_pickup_side_mission_consumable_01",
	name = "consumable",
	smart_tag_target_type = "pickup",
	spawn_weighting = 1,
	game_object_type = "pickup",
	is_side_mission_pickup = true,
	look_at_tag = "none",
	unit_name = "content/pickups/consumables/side_mission/relic_01",
	interaction_type = "side_mission",
	unit_template_name = "pickup",
	pickup_sound = "wwise/events/player/play_pick_up_forge_material_small",
	group = "side_mission_collect",
	on_pickup_func = function (unit)
		local mission_objective_target_extension = ScriptUnit.extension(unit, "mission_objective_target_system")
		local objective_name = mission_objective_target_extension:objective_name()
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")

		if mission_objective_system:is_current_active_objective(objective_name) then
			local synchronizer_unit = mission_objective_system:get_objective_synchronizer_unit(objective_name)
			local synchronizer_extension = ScriptUnit.extension(synchronizer_unit, "event_synchronizer_system")

			synchronizer_extension:add_progression(1)
		end
	end
}

return pickup_data
