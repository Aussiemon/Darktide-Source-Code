local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local SteamOfflineError = class("SteamOfflineError")

SteamOfflineError.init = function (self, is_booting)
	self._is_booting = is_booting
end

SteamOfflineError.level = function (self)
	if self._is_booting then
		return Managers.error.ERROR_LEVEL.fatal
	else
		return Managers.error.ERROR_LEVEL.error
	end
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
	if not self._is_booting then
		return {
			{
				text = "loc_popup_button_quit_game",
				callback = function ()
					Application.quit()
				end
			}
		}
	end
end

implements(SteamOfflineError, ErrorInterface)

return SteamOfflineError
