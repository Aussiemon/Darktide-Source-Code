local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local ErrorManager = require("scripts/managers/error/error_manager")
local EACError = class("EACError")

EACError.init = function (self, error_reason, optional_info)
	self._error_reason = error_reason
	self._optional_error_code = optional_info.error_code
	self._options = optional_info.options
end

EACError.level = function (self)
	return ErrorManager.ERROR_LEVEL.fatal
end

EACError.log_message = function (self)
	return string.format("Failed EAC: %s", self._error_reason)
end

EACError.loc_title = function (self)
	return "loc_popup_header_eac_error"
end

EACError.loc_description = function (self)
	local description = self._error_reason

	if self._optional_error_code then
		local params = {
			error = self._optional_error_code
		}
	end

	return description, params
end

EACError.options = function (self)
	return self._options
end

implements(EACError, ErrorInterface)

return EACError
