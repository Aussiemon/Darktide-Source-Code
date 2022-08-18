local pickup_data = {
	description = "Health booster",
	name = "health_booster",
	smart_tag_target_type = "pickup",
	spawn_weighting = 0,
	game_object_type = "pickup",
	health_min_percentage = 0.2,
	interaction_type = "health",
	unit_name = "content/pickups/consumables/refill_01/consumable_refill_01",
	look_at_tag = "health",
	unit_template_name = "pickup",
	health_max_percentage = 0.3,
	group = "health",
	health_amount_func = function (max_health, pickup_data)
		local rnd = math.random()
		local range = pickup_data.health_max_percentage - pickup_data.health_min_percentage
		local rnd_percentage = math.round_with_precision(pickup_data.health_min_percentage + range * rnd, 2)
		local health_amount = rnd_percentage * max_health

		return health_amount
	end
}

return pickup_data
