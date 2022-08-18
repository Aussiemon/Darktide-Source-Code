local pickup_data = {
	description = "loc_pickup_consumable_small_clip_01",
	name = "small_clip",
	look_at_tag = "ammo",
	smart_tag_target_type = "pickup",
	spawn_weighting = 0.5,
	game_object_type = "pickup",
	ammunition_min_percentage = 0.1,
	interaction_type = "ammunition",
	unit_name = "content/pickups/consumables/small_clip_01/consumable_small_clip_01",
	ammunition_max_percentage = 0.2,
	unit_template_name = "pickup",
	pickup_sound = "wwise/events/player/play_pick_up_ammo_01",
	group = "ammo",
	ammo_amount_func = function (max_ammunition_reserve, max_ammo_clip, pickup_data, seed)
		local _, rnd = math.next_random(seed)
		local range = pickup_data.ammunition_max_percentage - pickup_data.ammunition_min_percentage
		local modifier = pickup_data.modifier or 1
		local percentage = (pickup_data.ammunition_min_percentage + range * rnd) * modifier
		local amount = math.ceil(percentage * max_ammunition_reserve)

		return amount
	end
}

return pickup_data
