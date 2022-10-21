local pickup_data = {
	description = "loc_pickup_deployable_medical_crate_01",
	name = "medical_crate_deployable",
	spawn_flow_event = "lua_deploy",
	spawn_weighting = 0,
	game_object_type = "pickup",
	interaction_type = "health",
	num_charges = 4,
	look_at_tag = "healthstation",
	unit_name = "content/pickups/pocketables/medical_crate/deployable_medical_crate",
	unit_template_name = "pickup",
	group = "deployable",
	smart_tag_target_type = "pickup",
	auto_tag_on_spawn = true,
	health_amount_func = function (max_health, pickup_data)
		return max_health * 0.3
	end
}

return pickup_data
