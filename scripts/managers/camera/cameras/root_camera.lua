-- chunkname: @scripts/managers/camera/cameras/root_camera.lua

local BaseCamera = require("scripts/managers/camera/cameras/base_camera")
local RootCamera = class("RootCamera", "BaseCamera")

RootCamera.init = function (self, root_node)
	BaseCamera.init(self, root_node)

	self._aim_pitch = 0
	self._aim_yaw = 0
	self._aim_roll = 0
	self._environment_params = {}
end

RootCamera.set_root_unit = function (self, unit, object, preserve_yaw)
	object = object or self._object_name and Unit.node(unit, self._object_name) or 1

	BaseCamera.set_root_unit(self, unit, object)

	if not preserve_yaw then
		local rotation = Unit.world_rotation(unit, 1)
		local forward = Quaternion.forward(rotation)
		local forward_flat = Vector3(forward.x, forward.y, 0)
		local forward_flat_normalized = Vector3.normalize(forward_flat)
		local init_yaw = math.atan2(forward_flat_normalized.x, forward_flat_normalized.y)

		self._aim_yaw = -init_yaw
	end
end

RootCamera.parse_parameters = function (self, camera_settings, parent_node)
	if camera_settings.name then
		self._name = camera_settings.name
	end

	local degrees_to_radians = math.pi / 180

	self._vertical_fov = camera_settings.vertical_fov and camera_settings.vertical_fov * degrees_to_radians
	self._should_apply_fov_multiplier = camera_settings.should_apply_fov_multiplier or false
	self._custom_vertical_fov = camera_settings.custom_vertical_fov and camera_settings.custom_vertical_fov * degrees_to_radians
	self._default_fov = camera_settings.default_fov and camera_settings.default_fov * degrees_to_radians or self._vertical_fov
	self._near_range = camera_settings.near_range
	self._far_range = camera_settings.far_range
	self._safe_position_offset = camera_settings.safe_position_offset
	self._tree_transitions = camera_settings.tree_transitions
	self._node_transitions = camera_settings.node_transitions
	self._fade_to_black = camera_settings.fade_to_black or 0

	if camera_settings.root_object_name then
		self._object_name = camera_settings.root_object_name
	end

	self._use_collision = not camera_settings.disable_collision
end

RootCamera.update = function (self, dt, data)
	if not self:active() then
		return
	end

	local position, rotation
	local root_unit = self._root_unit
	local root_object = self._root_object

	if root_unit and ALIVE[root_unit] then
		position = Unit.world_position(root_unit, root_object)
		rotation = Unit.world_rotation(root_unit, root_object)

		self._root_position:store(position)
		self._root_rotation:store(rotation)
	else
		position = self._root_position:unbox()
		rotation = self._root_rotation:unbox()
	end

	BaseCamera.update(self, dt, position, rotation, data)
end

RootCamera.aim_yaw = function (self)
	return self._aim_yaw
end

RootCamera.aim_pitch = function (self)
	return self._aim_pitch
end

RootCamera.aim_roll = function (self)
	return self._aim_roll
end

RootCamera.set_aim_pitch = function (self, pitch)
	self._aim_pitch = pitch
end

RootCamera.set_aim_yaw = function (self, yaw)
	self._aim_yaw = yaw
end

RootCamera.set_aim_roll = function (self, roll)
	self._aim_roll = roll
end

RootCamera.set_root_vertical_fov = function (self, vertical_fov)
	self._vertical_fov = vertical_fov
end

RootCamera.use_collision = function (self)
	return self._use_collision
end

RootCamera.custom_vertical_fov = function (self)
	return self._custom_vertical_fov
end

return RootCamera
