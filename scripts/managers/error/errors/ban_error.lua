-- chunkname: @scripts/managers/error/errors/ban_error.lua

local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local ErrorManager = require("scripts/managers/error/error_manager")
local Text = require("scripts/utilities/ui/text")
local BanError = class("BanError")

BanError.init = function (self, original_error)
	local banned_data = original_error.banned

	if banned_data.frozen then
		self._description = "loc_error_banned_frozen"
	elseif banned_data.reason then
		if banned_data.reason == "BHV" then
			self._description = "loc_error_banned_bhv"
		elseif banned_data.reason == "CRG" then
			self._description = "loc_error_banned_crg"
		else
			self._description = "loc_error_banned_gen"
		end
	end

	if banned_data.expiry then
		local time = Managers.time:time("main")
		local server_time = Managers.backend:get_server_time(time)
		local expiry_time = banned_data.expiry
		local diff = (expiry_time - server_time) / 1000

		if diff > 0 then
			self._description_params = {
				description = Localize(self._description),
				time_remaining = Text.format_time_span_long_form_localized(diff),
			}
			self._description = "loc_error_banned_with_expire_time"
		end
	end

	self._log_message = table.tostring(original_error, 3)
end

BanError.level = function (self)
	return ErrorManager.ERROR_LEVEL.error
end

BanError.log_message = function (self)
	return self._log_message
end

BanError.loc_title = function (self)
	return "loc_error_banned_auth_failure"
end

BanError.loc_description = function (self)
	return self._description, self._description_params
end

BanError.options = function (self)
	return
end

implements(BanError, ErrorInterface)

return BanError
