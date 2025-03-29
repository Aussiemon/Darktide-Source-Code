-- chunkname: @scripts/settings/pickup/pickups/deployable/medical_crate_deployable_pickup.lua

local pickup_data = {
	auto_tag_on_spawn = true,
	description = "loc_pickup_deployable_medical_crate_01",
	group = "deployable",
	interaction_type = "health",
	name = "medical_crate_deployable",
	num_charges = 4,
	smart_tag_target_type = "pickup",
	spawn_flow_event = "lua_deploy",
	unit_name = "content/pickups/pocketables/medical_crate/deployable_medical_crate",
	health_amount_func = function (max_health, pickup_data)
		return max_health * 0.3
	end,
}

return pickup_data
