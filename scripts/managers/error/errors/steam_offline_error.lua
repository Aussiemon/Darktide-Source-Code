local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local SteamOfflineError = class("SteamOfflineError")

SteamOfflineError.init = function (self)
	return
end

SteamOfflineError.level = function (self)
	return Managers.error.ERROR_LEVEL.fatal
end

SteamOfflineError.log_message = function (self)
	return "No connection to the Steam Network"
end

SteamOfflineError.loc_title = function (self)
	return "loc_popup_header_error"
end

SteamOfflineError.loc_description = function (self)
	return "loc_popup_description_steam_offline_error"
end

SteamOfflineError.options = function (self)
	return
end

implements(SteamOfflineError, ErrorInterface)

return SteamOfflineError
