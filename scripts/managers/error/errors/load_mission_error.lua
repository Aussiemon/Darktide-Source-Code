local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local ErrorManager = require("scripts/managers/error/error_manager")
local LoadMissionError = class("LoadMissionError")

LoadMissionError.init = function (self, mission_name)
	self._mission_name = mission_name
end

LoadMissionError.level = function (self)
	return ErrorManager.ERROR_LEVEL.error
end

LoadMissionError.log_message = function (self)
	return string.format("Failed to load mission %s", self._mission_name)
end

LoadMissionError.loc_title = function (self)
	return "loc_popup_header_error"
end

LoadMissionError.loc_description = function (self)
	return "loc_popup_description_load_mission_error"
end

LoadMissionError.options = function (self)
	return
end

implements(LoadMissionError, ErrorInterface)

return LoadMissionError
