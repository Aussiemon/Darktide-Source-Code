local PlayerUnitSpawnManagerTestify = {
	wait_for_players_spawned = function (num_players, player_unit_spawn_manager)
		local players_with_unit = player_unit_spawn_manager._players_with_unit
		local num_player_spawned = table.size(players_with_unit)

		if num_player_spawned < num_players then
			return Testify.RETRY
		end
	end
}

return PlayerUnitSpawnManagerTestify
