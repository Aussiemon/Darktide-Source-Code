local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local ErrorManager = require("scripts/managers/error/error_manager")
local LoggedInFromAnotherLocationError = class("LoggedInFromAnotherLocationError")

LoggedInFromAnotherLocationError.init = function (self)
	return
end

LoggedInFromAnotherLocationError.level = function (self)
	return ErrorManager.ERROR_LEVEL.fatal
end

LoggedInFromAnotherLocationError.log_message = function (self)
	return "Logged in from another location, need to close application."
end

LoggedInFromAnotherLocationError.loc_title = function (self)
	return "loc_popup_header_logged_in_another_location_error"
end

LoggedInFromAnotherLocationError.loc_description = function (self)
	return "loc_popup_description_logged_in_another_location_error"
end

LoggedInFromAnotherLocationError.options = function (self)
	return
end

implements(LoggedInFromAnotherLocationError, ErrorInterface)

return LoggedInFromAnotherLocationError
