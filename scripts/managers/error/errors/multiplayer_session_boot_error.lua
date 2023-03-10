local ErrorCodes = require("scripts/managers/error/error_codes")
local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local ErrorManager = require("scripts/managers/error/error_manager")
local MultiplayerSessionBootError = class("MultiplayerSessionBootError")

MultiplayerSessionBootError.init = function (self, error_source, error_reason, optional_error_details)
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
		Crashify.print_exception("MultiplayerSessionBootError", error_reason)
	end
end

MultiplayerSessionBootError.level = function (self)
	if self._error_reason == "mission_not_found" then
		return ErrorManager.ERROR_LEVEL.warning_popup
	end

	return ErrorManager.ERROR_LEVEL.warning
end

MultiplayerSessionBootError.log_message = function (self)
	return self._log_message
end

MultiplayerSessionBootError.loc_title = function (self)
	if self._error_reason == "mission_not_found" then
		return "loc_popup_header_missing_mission"
	end

	return "loc_failed_joining_server"
end

MultiplayerSessionBootError.loc_description = function (self)
	if self._error_reason == "mission_not_found" then
		return "loc_popup_description_missing_mission"
	end

	local error_code_string = ErrorCodes.get_error_code_string_from_reason(self._error_reason)
	local string_format = "%s %s"

	return "loc_error_reason", {
		error_reason = error_code_string
	}, string_format
end

MultiplayerSessionBootError.options = function (self)
	return
end

implements(MultiplayerSessionBootError, ErrorInterface)

return MultiplayerSessionBootError
