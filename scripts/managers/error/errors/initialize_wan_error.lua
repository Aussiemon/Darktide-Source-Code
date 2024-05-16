-- chunkname: @scripts/managers/error/errors/initialize_wan_error.lua

local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local ErrorManager = require("scripts/managers/error/error_manager")
local InitializeWanError = class("InitializeWanError")

InitializeWanError.init = function (self, original_error)
	if type(original_error) == "string" then
		self._log_message = original_error
	elseif type(original_error) == "table" then
		self._log_message = table.tostring(original_error, 3)
	end
end

InitializeWanError.level = function (self)
	return ErrorManager.ERROR_LEVEL.error
end

InitializeWanError.log_message = function (self)
	return self._log_message
end

InitializeWanError.loc_title = function (self)
	return "loc_popup_header_initialize_wan_error"
end

InitializeWanError.loc_description = function (self)
	return "loc_popup_description_initialize_wan_error"
end

InitializeWanError.options = function (self)
	return
end

implements(InitializeWanError, ErrorInterface)

return InitializeWanError
