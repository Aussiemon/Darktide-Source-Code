-- chunkname: @scripts/managers/error/errors/multiplayer_session_disconnect_error.lua

local ErrorCodes = require("scripts/managers/error/error_codes")
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

	if ErrorCodes.should_report_to_crashify(error_reason) then
		Crashify.print_exception("MultiplayerSessionDisconnectError", error_reason)
	end
end

MultiplayerSessionDisconnectError.level = function (self)
	local error_level = ErrorCodes.get_error_code_level_from_reason(self._error_reason)

	return ErrorManager.ERROR_LEVEL[error_level]
end

MultiplayerSessionDisconnectError.log_message = function (self)
	return self._log_message
end

MultiplayerSessionDisconnectError.loc_title = function (self)
	local override, title = ErrorCodes.get_error_code_title_from_reason(self._error_reason, false)

	if override then
		return title
	end

	return "loc_disconnected_from_server"
end

MultiplayerSessionDisconnectError.loc_description = function (self)
	local error_reason = self._error_reason
	local override, title, format = ErrorCodes.get_error_code_description_from_reason(error_reason, false)

	if override then
		return title, format
	end

	local error_code_string = ErrorCodes.get_error_code_string_from_reason(error_reason)
	local string_format = "%s %s"

	return "loc_error_reason", {
		error_reason = error_code_string,
	}, string_format
end

MultiplayerSessionDisconnectError.options = function (self)
	return
end

implements(MultiplayerSessionDisconnectError, ErrorInterface)

return MultiplayerSessionDisconnectError
