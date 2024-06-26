-- chunkname: @scripts/managers/save/script_save_token_ps5.lua

local TokenInterface = require("scripts/foundation/managers/token/token_interface")

local function _info(...)
	Log.info("ScriptSaveToken", ...)
end

local ScriptSaveToken = class("ScriptSaveToken")

ScriptSaveToken.init = function (self, system, token, is_loading)
	self._system = system
	self._token = token
	self._info = {}
	self._is_loading = is_loading
end

ScriptSaveToken._get_status_text = function (self, status_code)
	local status_text = "unset"

	if self._system.COMPLETED == status_code then
		status_text = "Completed"
	elseif self._system.ERROR == status_code then
		status_text = "Error"

		local error_text = "Unknown"
		local error_code = self._system.save_error_result(self._token)

		if self._system.BROKEN == error_code then
			error_text = "Broken"
		elseif self._system.NOT_FOUND == error_code then
			error_text = "Not Found"
		elseif self._system.OTHER == error_code then
			error_text = "Other"
		elseif self._system.OUT_OF_SPACE == error_code then
			error_text = "Out of space"
		end

		return status_text, error_text
	elseif self._system.STARTED == status_code then
		status_text = "Started"
	elseif self._system.UNKNOWN == status_code then
		status_text = "Unknown"
	end

	return status_text
end

ScriptSaveToken.update = function (self)
	local status, sce_error_code = self._system.status(self._token)

	if status ~= self._last_status then
		local status_text, error_text = self:_get_status_text(status)

		if error_text then
			_info("Status: '%s', Error: '%s'", status_text, error_text)
		else
			_info("Status: '%s'", status_text)
		end
	end

	self._last_status = status

	local info = self._info

	if status == SaveSystem.STARTED then
		return
	end

	if status == SaveSystem.UNKNOWN then
		info.done = true
		info.error = "SaveSystem Status: UNKNOWN. Either the specified ID was never created, or it was already freed."
	elseif status == SaveSystem.COMPLETED then
		info.done = true

		if self._is_loading then
			info.data = SaveSystem.load_result(self._token)[1].data
		end
	elseif status == SaveSystem.ERROR then
		info.done = true
		info.sce_error_code = sce_error_code

		local error_code, space_missing

		if self._is_loading then
			error_code = SaveSystem.load_error_result(self._token)
		else
			error_code, space_missing = SaveSystem.save_error_result(self._token)
			info.space_missing = space_missing
		end

		if error_code == SaveSystem.BROKEN then
			info.error = "BROKEN"
		elseif error_code == SaveSystem.NOT_FOUND then
			info.error = "NOT_FOUND"
		elseif error_code == SaveSystem.OUT_OF_SPACE then
			info.error = "OUT_OF_SPACE"
		elseif error_code == SaveSystem.OTHER then
			info.error = "OTHER"
		end
	end
end

ScriptSaveToken.info = function (self)
	return self._info
end

ScriptSaveToken.done = function (self)
	return self._info.done
end

ScriptSaveToken.close = function (self)
	self._system.free(self._token)
end

implements(ScriptSaveToken, TokenInterface)

return ScriptSaveToken
