require("scripts/extension_systems/mission_board/mission_board_extension")
require("scripts/extension_systems/mission_board/mission_board_visibility_extension")

local MissionBoardSystem = class("MissionBoardSystem", "ExtensionSystemBase")
local MISSION_BOARD_VIEW = "mission_board_view"

MissionBoardSystem.init = function (self, context, system_init_data, ...)
	MissionBoardSystem.super.init(self, context, system_init_data, ...)

	self._mission_board_counter = 0
	self._mission_board_extension = nil
	self._mission_board_unit = nil
	self._visibility_group_units = {}
end

MissionBoardSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = MissionBoardSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)

	if extension_name == "MissionBoardExtension" then
		self._mission_board_counter = self._mission_board_counter + 1

		if self._mission_board_counter > 1 then
			local unit_to_extension_map = self._unit_to_extension_map
			local mission_board_extension_unit = nil

			for extension_unit, _ in pairs(unit_to_extension_map) do
				mission_board_extension_unit = extension_unit
			end
		end

		self._mission_board_extension = extension
		self._mission_board_unit = unit
	elseif extension_name == "MissionBoardVisibilityExtension" then
		self._visibility_group_units[#self._visibility_group_units + 1] = unit
	end

	return extension
end

MissionBoardSystem.is_open = function (self)
	local ui_manager = Managers.ui

	return ui_manager and ui_manager:view_active(MISSION_BOARD_VIEW)
end

MissionBoardSystem.mission_board_unit = function (self)
	return self._mission_board_unit
end

MissionBoardSystem.mission_board_extension = function (self)
	return self._mission_board_extension
end

MissionBoardSystem.set_group_visibility = function (self, is_visible)
	local units = self._visibility_group_units

	for i = 1, #units do
		Unit.set_visibility(units[i], "mission_board_active", is_visible)
	end
end

return MissionBoardSystem
