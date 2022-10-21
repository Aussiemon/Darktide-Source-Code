local MinigameBase = class("MinigameBase")

MinigameBase.init = function (self, unit, is_server, seed, context)
	self._minigame_unit = unit
	self._is_server = is_server
	self._seed = seed
	self._player_session_id = nil
end

MinigameBase.destroy = function (self)
	return
end

MinigameBase.hot_join_sync = function (self, sender, channel)
	return
end

MinigameBase.start = function (self, player_or_nil)
	self._player_session_id = player_or_nil and player_or_nil:session_id()
end

MinigameBase.stop = function (self)
	self._player_session_id = nil
end

MinigameBase.is_completed = function (self)
	return false
end

MinigameBase.setup_game = function (self)
	return
end

MinigameBase.on_action_pressed = function (self, t)
	return
end

return MinigameBase
