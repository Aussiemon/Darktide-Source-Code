-- chunkname: @scripts/settings/pickup/pickups/reward/live_event_leftover_01_pick_up_large.lua

local pickup_data = {
	description = "loc_leftover_pickup_large",
	group = "rewards",
	interaction_type = "leftover_pickup",
	name = "live_event_leftover_01_pickup_large",
	pickup_sound = "wwise/events/player/play_pick_up_event_artifact_large",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/collectibles/collectible_leftover/pickup_collectible_leftover_01_large",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data, t)
		local caused_by_player = Managers.state.player_unit_spawn:owner(interactor_unit)

		if caused_by_player.is_server then
			Managers.event:trigger("mutator_pickup_collected", caused_by_player, NetworkLookup.material_size_lookup.large, 5)
		end
	end,
	randomized_rotation = {
		false,
		false,
		true,
	},
}

return pickup_data
