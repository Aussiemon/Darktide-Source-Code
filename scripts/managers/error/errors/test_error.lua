-- chunkname: @scripts/managers/error/errors/test_error.lua

local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local ErrorManager = require("scripts/managers/error/error_manager")
local TestError = class("TestError")

TestError.init = function (self, error_level_name)
	self._error_level_name = error_level_name
end

TestError.level = function (self)
	return ErrorManager.ERROR_LEVEL[self._error_level_name]
end

TestError.log_message = function (self)
	return "Some log message..."
end

TestError.loc_title = function (self)
	return "loc_popup_header_error"
end

TestError.loc_description = function (self)
	return "loc_error_reason", {
		error_reason = string.format("I'm an error, level %q", self._error_level_name)
	}
end

TestError.options = function (self)
	return
end

implements(TestError, ErrorInterface)

return TestError
