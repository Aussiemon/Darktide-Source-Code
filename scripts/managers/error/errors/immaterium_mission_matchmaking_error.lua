local ErrorCodes = require("scripts/managers/error/error_codes")
local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local ErrorManager = require("scripts/managers/error/error_manager")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ImmateriumMissionMatchmakingError = class("ImmateriumMissionMatchmakingError")

ImmateriumMissionMatchmakingError.init = function (self, error_reason)
	self._error_reason = error_reason

	if ErrorCodes.should_report_to_crashify(error_reason) then
		Crashify.print_exception("ImmateriumMissionMatchmakingError", error_reason)
	end
end

ImmateriumMissionMatchmakingError.level = function (self)
	return ErrorManager.ERROR_LEVEL.warning
end

ImmateriumMissionMatchmakingError.log_message = function (self)
	return string.format("error_reason: %s", self._error_reason)
end

ImmateriumMissionMatchmakingError.loc_title = function (self)
	return nil
end

ImmateriumMissionMatchmakingError.loc_description = function (self)
	if self._error_reason == "FAILED_CROSS_PLAY_DISABLED_GLOBALLY" then
		return "loc_cross_play_disabled_globally"
	elseif self._error_reason == "CROSS_PLAY_DISABLED_BY_PARTICIPANT" then
		return "loc_cross_play_disabled_by_a_player"
	else
		local error_code_string = ErrorCodes.get_error_code_string_from_reason(self._error_reason)

		return "loc_matchmaking_failed", {
			error_code = error_code_string
		}
	end
end

ImmateriumMissionMatchmakingError.options = function (self)
	return
end

ImmateriumMissionMatchmakingError.sound_event = function (self)
	return UISoundEvents.notification_matchmaking_failed
end

implements(ImmateriumMissionMatchmakingError, ErrorInterface)

return ImmateriumMissionMatchmakingError
