local pickup_data = {
	interaction_type = "ammunition",
	name = "ammo_cache_deployable",
	look_at_tag = "ammo",
	ammo_crate = true,
	spawn_weighting = 0,
	pickup_sound = "wwise/events/player/play_pick_up_ammo_01",
	game_object_type = "pickup",
	auto_tag_on_spawn = true,
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/pocketables/ammo_crate/deployable_ammo_crate",
	group = "ammo",
	unit_template_name = "pickup",
	description = "loc_pickup_deployable_ammo_crate_01",
	spawn_flow_event = "lua_deploy",
	ammunition_min_percentage = 0.1,
	num_charges = 4,
	ammunition_max_percentage = 0.2,
	ammo_amount_func = function (max_ammunition_reserve, max_ammo_clip, pickup_data, seed)
		return max_ammunition_reserve + max_ammo_clip
	end
}

return pickup_data
