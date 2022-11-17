local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local ErrorManager = require("scripts/managers/error/error_manager")
local SignInError = class("SignInError")

SignInError.init = function (self, original_error)
	if type(original_error) == "string" then
		self._log_message = original_error
	elseif type(original_error) == "table" then
		self._log_message = table.tostring(original_error, 3)
	end
end

SignInError.level = function (self)
	return ErrorManager.ERROR_LEVEL.error
end

SignInError.log_message = function (self)
	return self._log_message
end

SignInError.loc_title = function (self)
	return "loc_popup_header_signin_error"
end

SignInError.loc_description = function (self)
	local is_xbox_live = IS_XBS or IS_GDK

	if is_xbox_live then
		return "loc_popup_description_signin_error_console"
	else
		return "loc_popup_description_signin_error_win"
	end
end

SignInError.options = function (self)
	return
end

implements(SignInError, ErrorInterface)

return SignInError
