-- chunkname: @scripts/managers/error/errors/loading_host_sync_error.lua

local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local ErrorManager = require("scripts/managers/error/error_manager")
local LoadingHostSyncError = class("LoadingHostSyncError")
local LOOKUP_ERROR_REASON = {
	sync_other = {
		error_code = 1,
		log_message = "Failed to sync with other peers",
	},
	sync_spawning = {
		error_code = 2,
		log_message = "Failed to sync with spawning peers",
	},
	sync_host = {
		error_code = 3,
		log_message = "Failed to sync with host",
	},
	unknown = {
		error_code = 99,
		log_message = "Unknown error",
	},
}

LoadingHostSyncError.init = function (self, optional_error_details)
	optional_error_details = optional_error_details or "unknown"

	local reason_data = LOOKUP_ERROR_REASON[optional_error_details] or LOOKUP_ERROR_REASON.unknown

	self._error_log_message = reason_data.log_message
	self._error_code = reason_data.error_code
end

LoadingHostSyncError.level = function (self)
	return ErrorManager.ERROR_LEVEL.warning_popup
end

LoadingHostSyncError.log_message = function (self)
	return self._error_log_message
end

LoadingHostSyncError.loc_title = function (self)
	return "loc_popup_header_loading_host_sync_error"
end

LoadingHostSyncError.loc_description = function (self)
	return "loc_popup_description_loading_host_sync_error", {
		error_code = self._error_code,
	}
end

LoadingHostSyncError.options = function (self)
	return
end

implements(LoadingHostSyncError, ErrorInterface)

return LoadingHostSyncError
