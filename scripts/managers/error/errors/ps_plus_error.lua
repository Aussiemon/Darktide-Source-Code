-- chunkname: @scripts/managers/error/errors/ps_plus_error.lua

local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local ErrorManager = require("scripts/managers/error/error_manager")
local PsPlusError = class("PsPlusError")

PsPlusError.init = function (self, original_error)
	if type(original_error) == "string" then
		self._log_message = original_error
	elseif type(original_error) == "table" then
		self._log_message = table.tostring(original_error, 3)
	end
end

PsPlusError.level = function (self)
	return ErrorManager.ERROR_LEVEL.error
end

PsPlusError.log_message = function (self)
	return self._log_message
end

PsPlusError.loc_title = function (self)
	return "loc_popup_header_error"
end

PsPlusError.loc_description = function (self)
	return "loc_psn_premium_fail_desc"
end

PsPlusError.options = function (self)
	return
end

implements(PsPlusError, ErrorInterface)

return PsPlusError
