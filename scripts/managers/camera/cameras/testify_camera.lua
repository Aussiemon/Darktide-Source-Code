-- chunkname: @scripts/managers/camera/cameras/testify_camera.lua

local RootCamera = require("scripts/managers/camera/cameras/root_camera")
local TestifyCamera = class("TestifyCamera", "RootCamera")

TestifyCamera.CAMERA_NODE_ID = 1

TestifyCamera.init = function (self, root_node)
	RootCamera.init(self, root_node)
end

TestifyCamera.set_root_unit = function (self, unit, object, preserve_yaw)
	RootCamera.set_root_unit(self, unit, object, preserve_yaw)

	self._root_camera = Unit.camera(self._root_unit, self.CAMERA_NODE_ID)
end

TestifyCamera.near_range = function (self)
	return Camera.near_range(self._root_camera)
end

TestifyCamera.far_range = function (self)
	return Camera.far_range(self._root_camera)
end

return TestifyCamera
