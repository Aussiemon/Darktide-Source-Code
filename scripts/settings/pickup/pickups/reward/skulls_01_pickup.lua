-- chunkname: @scripts/settings/pickup/pickups/reward/skulls_01_pickup.lua

local pickup_data = {
	description = "loc_tainted_skull_pickup",
	group = "rewards",
	interaction_type = "tainted_skull",
	name = "skulls_01_pickup",
	pickup_sound = "wwise/events/player/play_pick_up_skull",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/collectibles/collectible_tainted_skull_01",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
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
