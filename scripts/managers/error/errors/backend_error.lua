-- chunkname: @scripts/managers/error/errors/backend_error.lua

local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local ErrorManager = require("scripts/managers/error/error_manager")
local BackendError = class("BackendError")

BackendError.init = function (self, original_error)
	if type(original_error) == "string" then
		self._log_message = original_error
	elseif type(original_error) == "table" then
		self.__traceback = original_error.__traceback

		local max_depth = 3

		self._log_message = table.tostring(original_error, max_depth, true)
	end
end

BackendError.level = function (self)
	return ErrorManager.ERROR_LEVEL.error
end

BackendError.log_message = function (self)
	return self._log_message
end

BackendError.loc_title = function (self)
	return "loc_popup_header_error"
end

BackendError.loc_description = function (self)
	return "loc_popup_description_backend_error"
end

BackendError.options = function (self)
	return
end

implements(BackendError, ErrorInterface)

return BackendError
