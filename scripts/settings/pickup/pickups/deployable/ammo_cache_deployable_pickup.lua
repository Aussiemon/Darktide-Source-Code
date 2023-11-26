-- chunkname: @scripts/settings/pickup/pickups/deployable/ammo_cache_deployable_pickup.lua

local pickup_data = {
	description = "loc_pickup_deployable_ammo_crate_01",
	name = "ammo_cache_deployable",
	look_at_tag = "ammo",
	smart_tag_target_type = "pickup",
	pickup_sound = "wwise/events/player/play_pick_up_ammo_01",
	game_object_type = "pickup",
	interaction_type = "ammunition",
	num_charges = 4,
	group = "ammo",
	unit_name = "content/pickups/pocketables/ammo_crate/deployable_ammo_crate",
	ammo_crate = true,
	unit_template_name = "pickup",
	spawn_weighting = 0,
	spawn_flow_event = "lua_deploy",
	auto_tag_on_spawn = true,
	ammo_amount_func = function (max_ammunition_reserve, max_ammo_clip, pickup_data)
		return max_ammunition_reserve + max_ammo_clip
	end
}

return pickup_data
