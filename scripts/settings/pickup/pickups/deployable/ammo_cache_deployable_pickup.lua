local pickup_data = {
	interaction_type = "ammunition",
	name = "ammo_cache_deployable",
	look_at_tag = "ammo",
	ammo_crate = true,
	spawn_weighting = 0,
	spawn_flow_event = "lua_deploy",
	pickup_sound = "wwise/events/player/play_pick_up_ammo_01",
	auto_tag_on_spawn = true,
	unit_name = "content/pickups/pocketables/ammo_crate/deployable_ammo_crate",
	unit_template_name = "pickup",
	description = "loc_pickup_deployable_ammo_crate_01",
	smart_tag_target_type = "pickup",
	group = "ammo",
	game_object_type = "pickup",
	num_charges = 4,
	interaction_icon = "content/ui/materials/hud/interactions/icons/pocketable_ammo",
	ammo_amount_func = function (max_ammunition_reserve, max_ammo_clip, pickup_data)
		return max_ammunition_reserve + max_ammo_clip
	end
}

return pickup_data
