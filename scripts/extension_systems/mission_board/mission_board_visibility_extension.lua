local MissionBoardVisibilityExtension = class("MissionBoardVisibilityExtension")
local VISIBIILITY_GROUP_NAME = "mission_board_active"

MissionBoardVisibilityExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	fassert(Unit.has_visibility_group(unit, VISIBIILITY_GROUP_NAME), "%s doesn't have a the visibility group \"%s\"", tostring(unit), VISIBIILITY_GROUP_NAME)
end

return MissionBoardVisibilityExtension
