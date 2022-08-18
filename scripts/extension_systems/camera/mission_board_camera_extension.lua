local MissionBoardCameraExtension = class("MissionBoardCameraExtension")

MissionBoardCameraExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._tree = "mission_board"
	self._node = "mission_board"
end

MissionBoardCameraExtension.change_node = function (self, new_node)
	self._node = new_node
end

MissionBoardCameraExtension.camera_tree_node = function (self)
	return self._tree, self._node
end

return MissionBoardCameraExtension
