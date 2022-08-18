local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local WwiseStateGroupBase = class("WwiseStateGroupBase")

WwiseStateGroupBase.init = function (self, wwise_world, wwise_state_group_name)
	self._wwise_world = wwise_world
	self._wwise_state_group_name = wwise_state_group_name
	self._current_wwise_state = WwiseGameSyncSettings.default_group_state
	self._game_state_machine = nil
	self._player_unit = nil
end

WwiseStateGroupBase.destroy = function (self)
	return
end

WwiseStateGroupBase.update = function (self, dt, t)
	return
end

WwiseStateGroupBase._set_wwise_state = function (self, state)
	self._current_wwise_state = state
end

WwiseStateGroupBase.wwise_state = function (self)
	return self._current_wwise_state
end

WwiseStateGroupBase.set_game_state_machine = function (self, game_state_machine)
	self._game_state_machine = game_state_machine
end

WwiseStateGroupBase.get_game_state_machine = function (self)
	return self._game_state_machine
end

WwiseStateGroupBase.on_gameplay_post_init = function (self, level)
	return
end

WwiseStateGroupBase.on_gameplay_shutdown = function (self)
	return
end

WwiseStateGroupBase.set_followed_player_unit = function (self, player_unit)
	self._player_unit = player_unit
end

return WwiseStateGroupBase
