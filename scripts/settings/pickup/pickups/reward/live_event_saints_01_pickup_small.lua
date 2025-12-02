-- chunkname: @scripts/settings/pickup/pickups/reward/live_event_saints_01_pickup_small.lua

local pickup_data = {
	description = "loc_saints_relic_pickup_small",
	group = "rewards",
	interaction_type = "saints_pickup",
	name = "live_event_saints_01_pickup_small",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/collectibles/collectibles_saints/pickup_collectible_saints_small_01",
	unit_names = {
		"content/pickups/collectibles/collectibles_saints/pickup_collectible_saints_small_01",
	},
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data, t)
		local caused_by_player = Managers.state.player_unit_spawn:owner(interactor_unit)

		if caused_by_player.is_server then
			Managers.event:trigger("mutator_pickup_collected", caused_by_player, NetworkLookup.material_size_lookup.small, 1)
		end
	end,
	randomized_rotation = {
		false,
		false,
		true,
	},
}

return pickup_data
