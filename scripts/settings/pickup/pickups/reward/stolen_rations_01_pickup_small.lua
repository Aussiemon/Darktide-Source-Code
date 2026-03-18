-- chunkname: @scripts/settings/pickup/pickups/reward/stolen_rations_01_pickup_small.lua

local pickup_data = {
	description = "loc_stolen_rations_pickup_small",
	group = "rewards",
	interaction_type = "stolen_rations",
	name = "stolen_rations_01_pickup_small",
	smart_tag_target_type = "pickup",
	unit_names = {
		"content/pickups/collectibles/collectible_stolen_rations_01",
		"content/pickups/collectibles/collectible_stolen_rations_05",
	},
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data, t)
		local caused_by_player = Managers.state.player_unit_spawn:owner(interactor_unit)

		if caused_by_player.is_server then
			Managers.stats:record_private("hook_stolen_rations_destroyed", caused_by_player, 1)
		end
	end,
	randomized_rotation = {
		false,
		false,
		true,
	},
}

return pickup_data
