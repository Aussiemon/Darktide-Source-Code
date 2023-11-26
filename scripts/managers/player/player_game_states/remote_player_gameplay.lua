-- chunkname: @scripts/managers/player/player_game_states/remote_player_gameplay.lua

local RemotePlayerGameplay = class("RemotePlayerGameplay")

RemotePlayerGameplay.init = function (self, player, game_state_context)
	self._player = player
	self._is_server = game_state_context.is_server
end

RemotePlayerGameplay.destroy = function (self)
	return
end

RemotePlayerGameplay.on_reload = function (self, refreshed_resources)
	return
end

RemotePlayerGameplay.update = function (self, main_dt, main_t)
	if self._is_server then
		local input_handler = self._player.input_handler

		if input_handler then
			local time_manager = Managers.time
			local game_dt, game_t = time_manager:delta_time("gameplay"), time_manager:time("gameplay")

			input_handler:update(game_dt, game_t)
		end
	end
end

RemotePlayerGameplay.fixed_update = function (self, game_dt, game_t, fixed_frame)
	if self._is_server then
		local input_handler = self._player.input_handler

		if input_handler then
			input_handler:fixed_update(game_dt, game_t, fixed_frame)
		end
	end
end

RemotePlayerGameplay.post_update = function (self, main_dt, main_t)
	return
end

RemotePlayerGameplay.render = function (self)
	return
end

return RemotePlayerGameplay
