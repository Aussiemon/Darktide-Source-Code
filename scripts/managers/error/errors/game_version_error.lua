-- chunkname: @scripts/managers/error/errors/game_version_error.lua

local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local ErrorManager = require("scripts/managers/error/error_manager")
local GameVersionError = class("GameVersionError")

GameVersionError.init = function (self, original_error)
	if type(original_error) == "string" then
		self._log_message = original_error
	elseif type(original_error) == "table" then
		self._log_message = table.tostring(original_error, 3)
	end
end

GameVersionError.level = function (self)
	return ErrorManager.ERROR_LEVEL.fatal
end

GameVersionError.log_message = function (self)
	return self._log_message
end

GameVersionError.loc_title = function (self)
	return "loc_popup_header_wrong_game_version"
end

GameVersionError.loc_description = function (self)
	if PLATFORM == "win32" then
		return "loc_popup_description_wrong_game_version_win"
	else
		return "loc_popup_description_wrong_game_version_console"
	end
end

GameVersionError.options = function (self)
	return
end

implements(GameVersionError, ErrorInterface)

return GameVersionError
