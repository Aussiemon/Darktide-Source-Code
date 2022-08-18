local MissionBoardInteractableExtension = class("MissionBoardInteractableExtension")

MissionBoardInteractableExtension.setup_from_component = function (self, button_name, mission_board_name)
	self._button_name = button_name
	self._mission_board_name = mission_board_name
end

MissionBoardInteractableExtension.button_name = function (self)
	return self._button_name
end

MissionBoardInteractableExtension.mission_board_name = function (self)
	return self._mission_board_name
end

MissionBoardInteractableExtension.update = function (self, unit, dt, t)
	return
end

return MissionBoardInteractableExtension
