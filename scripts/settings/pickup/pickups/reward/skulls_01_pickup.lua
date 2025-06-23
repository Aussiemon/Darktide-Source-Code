-- chunkname: @scripts/settings/pickup/pickups/reward/skulls_01_pickup.lua

local pickup_data = {
	description = "loc_tainted_skull_pickup",
	smart_tag_target_type = "pickup",
	pickup_sound = "wwise/events/player/play_pick_up_skull",
	interaction_type = "tainted_skull",
	group = "rewards",
	name = "skulls_01_pickup",
	unit_name = "content/pickups/collectibles/collectible_tainted_skull_01",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		return
	end,
	randomized_rotation = {
		false,
		false,
		true
	}
}

return pickup_data
