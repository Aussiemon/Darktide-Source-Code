-- chunkname: @scripts/settings/pickup/pickups/reward/stolen_rations_01_pickup_medium.lua

local pickup_data = {
	description = "loc_stolen_rations_pickup_medium",
	group = "rewards",
	interaction_type = "stolen_rations",
	name = "stolen_rations_01_pickup_medium",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/collectibles/collectible_stolen_rations_02",
	unit_names = {
		"content/pickups/collectibles/collectible_stolen_rations_02",
		"content/pickups/collectibles/collectible_stolen_rations_03",
		"content/pickups/collectibles/collectible_stolen_rations_04",
	},
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data, t)
		local interactee_extension = ScriptUnit.extension(pickup_unit, "interactee_system")
		local input_type = interactee_extension:get_interaction_input_type()
		local caused_by_player = Managers.state.player_unit_spawn:owner(interactor_unit)

		if caused_by_player.is_server then
			Managers.stats:record_private(input_type == "primary" and "hook_stolen_rations_recovered" or "hook_stolen_rations_destroyed", caused_by_player, 3)
			Managers.state.game_session:send_rpc_clients("rpc_player_collected_event_materials", caused_by_player:peer_id(), NetworkLookup.material_type_lookup.event_material, NetworkLookup.material_size_lookup.medium, input_type == "primary" and 1 or 2)
		end
	end,
	randomized_rotation = {
		false,
		false,
		true,
	},
}

return pickup_data
