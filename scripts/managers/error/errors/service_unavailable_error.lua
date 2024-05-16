-- chunkname: @scripts/managers/error/errors/service_unavailable_error.lua

local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local ErrorManager = require("scripts/managers/error/error_manager")
local ServiceUnavailableError = class("ServiceUnavailableError")

ServiceUnavailableError.init = function (self, original_error)
	if type(original_error) == "string" then
		self._log_message = original_error
	elseif type(original_error) == "table" then
		self._log_message = table.tostring(original_error, 3)
	end
end

ServiceUnavailableError.level = function (self)
	return ErrorManager.ERROR_LEVEL.error
end

ServiceUnavailableError.log_message = function (self)
	return self._log_message
end

ServiceUnavailableError.loc_title = function (self)
	return "loc_popup_header_service_unavailable_error"
end

ServiceUnavailableError.loc_description = function (self)
	if IS_XBS or IS_GDK then
		return "loc_popup_description_service_unavailable_console"
	else
		return "loc_popup_description_service_unavailable_win"
	end
end

ServiceUnavailableError.options = function (self)
	return
end

implements(ServiceUnavailableError, ErrorInterface)

return ServiceUnavailableError
