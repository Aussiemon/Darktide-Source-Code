-- chunkname: @scripts/managers/game_mode/game_mode_extensions/game_mode_extension_base.lua

local GameModeExtensionBase = class("GameModeExtensionBase")

GameModeExtensionBase.init = function (self, is_server)
	self._is_server = is_server
end

GameModeExtensionBase.server_update = function (self, dt, t)
	return
end

GameModeExtensionBase.on_gameplay_init = function (self)
	return
end

GameModeExtensionBase.destroy = function (self)
	return
end

GameModeExtensionBase.hot_join_sync = function (self, sender, channel)
	return
end

return GameModeExtensionBase
