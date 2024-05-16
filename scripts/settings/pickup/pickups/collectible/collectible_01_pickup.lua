-- chunkname: @scripts/settings/pickup/pickups/collectible/collectible_01_pickup.lua

local pickup_data = {
	description = "loc_pickup_collectible",
	game_object_type = "pickup",
	group = "collectibles",
	interaction_type = "penance_collectible",
	name = "collectible_01_pickup",
	smart_tag_target_type = "pickup",
	spawn_weighting = 1,
	unit_name = "content/pickups/collectibles/collectible_pickup_01",
	unit_template_name = "pickup",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local collectibles_manager = Managers.state.collectibles

		collectibles_manager:register_collectible(pickup_unit, interactor_unit, "collectible")
	end,
}

return pickup_data
