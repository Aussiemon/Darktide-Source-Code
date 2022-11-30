local BotGameplay = class("BotGameplay")

BotGameplay.init = function (self, player, game_state_context)
	self._player = player
	self._is_server = game_state_context.is_server
	self._has_spawned = false
end

BotGameplay.destroy = function (self)
	if self._is_server and ALIVE[self._player.player_unit] then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn

		player_unit_spawn_manager:despawn(self._player)
	end
end

BotGameplay.on_reload = function (self, refreshed_resources)
	return
end

BotGameplay.update = function (self, main_dt, main_t)
	local player = self._player
	local package_synchronizer_host = Managers.package_synchronization:synchronizer_host()
	local local_player_id = player:local_player_id()

	if self._is_server and not self._has_spawned and package_synchronizer_host:bot_synced_by_all(local_player_id) then
		local player_spawner_system = Managers.state.extension:system("player_spawner_system")
		local position, rotation, parent, side = player_spawner_system:next_free_spawn_point("bots")
		local force_spawn = true
		local is_respawn = false
		local player_unit_spawn_manager = Managers.state.player_unit_spawn

		player_unit_spawn_manager:spawn_player(player, position, rotation, parent, force_spawn, side, nil, "walking", is_respawn)

		self._has_spawned = true
	end
end

return BotGameplay
