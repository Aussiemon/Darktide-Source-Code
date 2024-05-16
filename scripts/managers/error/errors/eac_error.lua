-- chunkname: @scripts/managers/error/errors/eac_error.lua

local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local ErrorManager = require("scripts/managers/error/error_manager")
local EAC_KICK_REASONS_LOOKUP = {
	{
		error_code = "1",
		loc_message = "loc_eos_acccar_internalerror",
		error_level = ErrorManager.ERROR_LEVEL.fatal,
	},
	{
		error_code = "2",
		loc_message = "loc_eos_acccar_invalidmessage",
		error_level = ErrorManager.ERROR_LEVEL.error,
	},
	{
		error_code = "3",
		loc_message = "loc_eos_acccar_authenticationfailed",
		error_level = ErrorManager.ERROR_LEVEL.fatal,
	},
	{
		error_code = "4",
		loc_message = "loc_eos_acccar_nullclient",
		error_level = ErrorManager.ERROR_LEVEL.fatal,
	},
	{
		error_code = "5",
		loc_message = "loc_eos_acccar_heartbeattimeout",
		error_level = ErrorManager.ERROR_LEVEL.error,
	},
	{
		error_code = "6",
		loc_message = "loc_eos_acccar_clientviolation",
		error_level = ErrorManager.ERROR_LEVEL.fatal,
	},
	{
		error_code = "7",
		loc_message = "loc_eos_acccar_backendviolation",
		error_level = ErrorManager.ERROR_LEVEL.fatal,
	},
	{
		error_code = "8",
		loc_message = "loc_eos_acccar_temporarycooldown",
		error_level = ErrorManager.ERROR_LEVEL.error,
	},
	{
		error_code = "9",
		loc_message = "loc_eos_acccar_temporarybanned",
		error_level = ErrorManager.ERROR_LEVEL.fatal,
	},
	{
		error_code = "10",
		loc_message = "loc_popup_description_eac_kick",
		error_level = ErrorManager.ERROR_LEVEL.fatal,
	},
	{
		error_code = "99",
		loc_message = "loc_eos_acccar_unknown_error",
		error_level = ErrorManager.ERROR_LEVEL.fatal,
	},
}
local EACError = class("EACError")

EACError.init = function (self, error_reason, optional_error_code)
	local options
	local error_level = ErrorManager.ERROR_LEVEL.fatal

	if optional_error_code then
		local kick_reason_data = self:_kick_reason_data(optional_error_code)

		error_reason = kick_reason_data.loc_message
		error_level = kick_reason_data.error_level

		if error_level == ErrorManager.ERROR_LEVEL.fatal then
			options = self:_eac_policy_link_options()
		end

		if error_level == ErrorManager.ERROR_LEVEL.error then
			Managers.eac_client:reset()
		end
	end

	self._error_reason = error_reason
	self._optional_error_code = optional_error_code
	self._options = options
	self._error_level = error_level

	Log.info("EACError", "error_reason:%s, optional_error_code:%s", error_reason, optional_error_code)
end

EACError.level = function (self)
	return self._error_level
end

EACError.log_message = function (self)
	return string.format("Failed EAC: %s error_code %s ", self._error_reason, self._optional_error_code)
end

EACError.loc_title = function (self)
	return "loc_popup_header_eac_error"
end

EACError.loc_description = function (self)
	local description = self._error_reason
	local params = self._optional_error_code and {
		error = self._optional_error_code,
	}

	return description, params
end

EACError.options = function (self)
	return self._options
end

EACError._kick_reason_data = function (self, error_code)
	local kick_reasons = EAC_KICK_REASONS_LOOKUP
	local _, kick_reason = table.find_by_key(kick_reasons, "error_code", error_code)

	if not kick_reason then
		_, kick_reason = table.find_by_key(kick_reasons, "error_code", "99")
	end

	return kick_reason
end

EACError._eac_policy_link_options = function (self)
	local options = {
		{
			margin_bottom = 20,
			template_type = "url_button",
			text = "loc_popup_link_description_eac_error",
			callback = function ()
				Application.open_url_in_browser(Localize("loc_popup_link_eac_error"))
			end,
		},
	}

	return options
end

implements(EACError, ErrorInterface)

return EACError
