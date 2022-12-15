local pickup_data = {
	description = "loc_pickup_small_metal",
	name = "reward_01_pickup",
	smart_tag_target_type = "pickup",
	spawn_weighting = 1,
	game_object_type = "pickup",
	interaction_type = "forge_material",
	pickup_sound = "wwise/events/player/play_pick_up_valuable",
	group = "rewards",
	unit_name = "content/pickups/rewards/reward_pickup_01",
	unit_template_name = "pickup",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local pickup_system = Managers.state.extension:system("pickup_system")

		pickup_system:register_material_collected(pickup_unit, interactor_unit, "reward_01_pickup", "small")
	end
}

return pickup_data
