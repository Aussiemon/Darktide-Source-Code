local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local ErrorManager = require("scripts/managers/error/error_manager")
local MultiplayerSessionDisconnectError = class("MultiplayerSessionDisconnectError")

MultiplayerSessionDisconnectError.init = function (self, error_source, error_reason, optional_error_details)
	self._error_reason = error_reason
	local error_details = "n/a"

	if optional_error_details then
		if type(optional_error_details) == "table" then
			error_details = table.tostring(optional_error_details, 3)
		else
			error_details = optional_error_details
		end
	end

	self._log_message = string.format("source: %s, reason: %s, error_details: %s", error_source, error_reason, error_details)
end

MultiplayerSessionDisconnectError.level = function (self)
	return ErrorManager.ERROR_LEVEL.warning
end

MultiplayerSessionDisconnectError.log_message = function (self)
	return self._log_message
end

MultiplayerSessionDisconnectError.loc_title = function (self)
	return "loc_disconnected_from_server"
end

MultiplayerSessionDisconnectError.loc_description = function (self)
	return "loc_error_reason", {
		error_reason = self._error_reason
	}
end

MultiplayerSessionDisconnectError.options = function (self)
	return
end

implements(MultiplayerSessionDisconnectError, ErrorInterface)

return MultiplayerSessionDisconnectError
