-- chunkname: @scripts/managers/error/errors/ban_error.lua

local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local ErrorManager = require("scripts/managers/error/error_manager")
local Text = require("scripts/utilities/ui/text")
local BanSettings = require("scripts/managers/error/errors/ban_settings")
local WebBrowser = require("scripts/utilities/web_browser/web_browser")
local BanError = class("BanError")
local DESCRIPTION_FONT_SIZE = 18

BanError.init = function (self, original_error)
	local banned_data = original_error.banned
	local log_message = table.tostring(original_error, 3)

	self._description = BanSettings.fallback_description
	self._description_params = nil

	if banned_data.frozen then
		self._description = BanSettings.frozen_description
	elseif banned_data.reason then
		local reason = banned_data.reason
		local ban_category = BanSettings.category_by_reason[reason]

		if ban_category then
			self._description = "loc_error_ban_category"
			self._description_params = {
				ban_category = Localize(ban_category.category),
				font_size = DESCRIPTION_FONT_SIZE,
			}

			if ban_category.description then
				self:_wrap_description("loc_error_ban_description", {
					ban_description = Localize(ban_category.description),
					font_size = DESCRIPTION_FONT_SIZE,
				})
			end

			if ban_category.violation then
				self:_wrap_description("loc_error_ban_violation", {
					ban_violation = Localize(ban_category.violation),
					font_size = DESCRIPTION_FONT_SIZE,
				})
			end
		else
			log_message = string.format("No ban setting found for ban reason %q\n%s", tostring(reason), log_message)
		end
	end

	if banned_data.issued then
		local issued_date = os.date("!%Y-%m-%d %H:%M:%S", banned_data.issued / 1000)

		self:_wrap_description("loc_error_ban_issued_date", {
			date = issued_date,
		})
	end

	if banned_data.expiry then
		local time = Managers.time:time("main")
		local server_time = Managers.backend:get_server_time(time)
		local expiry_time = tonumber(banned_data.expiry)

		if server_time < expiry_time then
			local expiration_date = os.date("!%Y-%m-%d %H:%M:%S", expiry_time / 1000)

			self:_wrap_description("loc_error_ban_expire_date", {
				date = expiration_date,
			})
		end
	end

	self._log_message = log_message
end

BanError.level = function (self)
	return ErrorManager.ERROR_LEVEL.error
end

BanError.log_message = function (self)
	return self._log_message
end

BanError.loc_title = function (self)
	return "loc_error_banned_gen"
end

BanError.loc_description = function (self)
	return self._description, self._description_params
end

BanError.options = function (self)
	return {
		{
			margin_bottom = 20,
			template_type = "url_button",
			text = "loc_appeal_ban_button_text",
			callback = function ()
				WebBrowser.open(BanSettings.appeal_url)
			end,
		},
	}
end

BanError._wrap_description = function (self, loc_key, params)
	local description_params = self._description_params

	params.description = Localize(self._description, description_params ~= nil, description_params)
	self._description = loc_key
	self._description_params = params
end

implements(BanError, ErrorInterface)

return BanError
