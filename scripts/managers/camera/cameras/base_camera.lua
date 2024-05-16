-- chunkname: @scripts/managers/camera/cameras/base_camera.lua

local BaseCamera = class("BaseCamera")

BaseCamera.init = function (self, root_node)
	self._root_node = root_node
	self._children = {}
	self._name = ""
	self._root_unit = nil
	self._root_object = nil
	self._root_position = Vector3Box()
	self._root_rotation = QuaternionBox()
	self._position = Vector3Box()
	self._rotation = QuaternionBox()
	self._vertical_fov = nil
	self._custom_vertical_fov = nil
	self._near_range = nil
	self._far_range = nil
	self._active = 0
	self._active_children = 0
	self._external_fov_multiplier = 1
	self._default_fov_multiplier_lerp_time = 0.15
	self._fov_multiplier = 1
	self._wanted_fov_multiplier = 1
	self._fov_multiplier_lerp_time = 0
end

BaseCamera.parse_parameters = function (self, camera_settings, parent_node)
	if camera_settings.name then
		self._name = camera_settings.name
	end

	local degrees_to_radians = math.pi / 180

	self._fade_to_black = camera_settings.fade_to_black
	self._vertical_fov = camera_settings.vertical_fov and camera_settings.vertical_fov * degrees_to_radians
	self._should_apply_fov_multiplier = camera_settings.should_apply_fov_multiplier or parent_node:should_apply_fov_multiplier()
	self._custom_vertical_fov = camera_settings.custom_vertical_fov and camera_settings.custom_vertical_fov * degrees_to_radians
	self._default_fov = camera_settings.default_fov and camera_settings.default_fov * degrees_to_radians or parent_node:default_fov()
	self._near_range = camera_settings.near_range or parent_node:near_range()
	self._far_range = camera_settings.far_range or parent_node:far_range()
	self._safe_position_offset = camera_settings.safe_position_offset or parent_node:safe_position_offset()
	self._tree_transitions = camera_settings.tree_transitions or parent_node:tree_transitions()
	self._node_transitions = camera_settings.node_transitions or parent_node:node_transitions()

	if camera_settings.dof_enabled then
		self._environment_params = self._environment_params or {}
		self._environment_params.dof_enabled = camera_settings.dof_enabled
		self._environment_params.focal_distance = camera_settings.focal_distance
		self._environment_params.focal_region = camera_settings.focal_region
		self._environment_params.focal_padding = camera_settings.focal_padding
		self._environment_params.focal_scale = camera_settings.focal_scale
	end
end

BaseCamera.should_apply_fov_multiplier = function (self)
	return self._should_apply_fov_multiplier
end

BaseCamera.default_fov = function (self)
	return self._default_fov
end

BaseCamera.node_transitions = function (self)
	return self._node_transitions
end

BaseCamera.tree_transitions = function (self)
	return self._tree_transitions
end

BaseCamera.safe_position_offset = function (self)
	return self._safe_position_offset
end

BaseCamera.name = function (self)
	return self._name
end

BaseCamera.pose = function (self)
	local pose = Matrix4x4.identity()

	Matrix4x4.set_translation(pose, self:position())
	Matrix4x4.set_rotation(pose, self:rotation())

	return pose
end

BaseCamera.exposure_snap = function (self)
	return false
end

BaseCamera.position = function (self)
	return self._position:unbox()
end

BaseCamera.rotation = function (self)
	return self._rotation:unbox()
end

BaseCamera.vertical_fov = function (self)
	local fov = self._vertical_fov

	if fov then
		return fov * self._external_fov_multiplier * self._fov_multiplier
	else
		return self._parent_node:vertical_fov()
	end
end

BaseCamera.custom_vertical_fov = function (self)
	return self._custom_vertical_fov or self._parent_node:custom_vertical_fov()
end

BaseCamera.fade_to_black = function (self)
	return self._fade_to_black or self._parent_node:fade_to_black()
end

BaseCamera.shading_environment = function (self)
	return self._environment_params or self._parent_node and self._parent_node:shading_environment()
end

BaseCamera.near_range = function (self)
	return self._near_range
end

BaseCamera.far_range = function (self)
	return self._far_range
end

BaseCamera.dof_enabled = function (self)
	return self._environment_params.dof_enabled
end

BaseCamera.focal_distance = function (self)
	return self._environment_params.focal_distance
end

BaseCamera.focal_region = function (self)
	return self._environment_params.focal_region
end

BaseCamera.focal_padding = function (self)
	return self._environment_params.focal_padding
end

BaseCamera.focal_scale = function (self)
	return self._environment_params.focal_scale
end

BaseCamera.parent_node = function (self)
	return self._parent_node
end

BaseCamera.root_node = function (self)
	return self._root_node
end

BaseCamera.use_collision = function (self)
	return self._root_node:use_collision()
end

BaseCamera.set_parent_node = function (self, parent)
	self._parent_node = parent
end

BaseCamera.add_child_node = function (self, node)
	self._children[#self._children + 1] = node

	node:set_parent_node(self)
end

BaseCamera.set_active = function (self, active)
	local old_active = self:active()

	if active then
		self._active = self._active + 1
	else
		self._active = self._active - 1
	end

	local new_active = self:active()

	if self._parent_node and old_active ~= new_active then
		self._parent_node:set_active_child(new_active)
	end
end

BaseCamera.active = function (self)
	return self._active > 0 or self._active_children > 0
end

BaseCamera.set_active_child = function (self, active)
	local old_active = self:active()

	if active then
		self._active_children = self._active_children + 1
	else
		self._active_children = self._active_children - 1
	end

	local new_active = self:active()

	if self._parent_node and old_active ~= new_active then
		self._parent_node:set_active_child(new_active)
	end
end

BaseCamera.set_root_unit = function (self, unit, object)
	self._root_unit = unit
	self._root_object = object

	for _, child in ipairs(self._children) do
		child:set_root_unit(unit, object)
	end
end

BaseCamera.root_unit = function (self)
	return self._root_unit, self._root_object
end

BaseCamera.set_root_position = function (self, position)
	self._root_position:store(position)

	for _, child in ipairs(self._children) do
		child:set_root_position(position)
	end
end

BaseCamera.set_root_rotation = function (self, rotation)
	self._root_rotation:store(rotation)

	for _, child in ipairs(self._children) do
		child:set_root_rotation(rotation)
	end
end

BaseCamera.set_root_near_range = function (self, near_range)
	self._near_range = near_range

	for _, child in ipairs(self._children) do
		child:set_root_near_range(near_range)
	end
end

BaseCamera.set_root_far_range = function (self, far_range)
	self._far_range = far_range

	for _, child in ipairs(self._children) do
		child:set_root_far_range(far_range)
	end
end

BaseCamera.set_root_dof_enabled = function (self, dof_enabled)
	self._environment_params.dof_enabled = dof_enabled

	for _, child in ipairs(self._children) do
		child:set_root_dof_enabled(dof_enabled)
	end
end

BaseCamera.set_root_focal_distance = function (self, focal_distance)
	self._environment_params.focal_distance = focal_distance

	for _, child in ipairs(self._children) do
		child:set_root_focal_distance(focal_distance)
	end
end

BaseCamera.set_root_focal_region = function (self, focal_region)
	self._environment_params.focal_region = focal_region

	for _, child in ipairs(self._children) do
		child:set_root_focal_region(focal_region)
	end
end

BaseCamera.set_root_focal_padding = function (self, focal_padding)
	self._environment_params.focal_padding = focal_padding

	for _, child in ipairs(self._children) do
		child:set_root_focal_padding(focal_padding)
	end
end

BaseCamera.set_root_focal_scale = function (self, focal_scale)
	self._environment_params.focal_scale = focal_scale

	for _, child in ipairs(self._children) do
		child:set_root_focal_scale(focal_scale)
	end
end

BaseCamera.update = function (self, dt, position, rotation, data)
	self._position:store(position)
	self._rotation:store(rotation)

	for _, child in ipairs(self._children) do
		if child:active() then
			child:update(dt, position, rotation, data)
		end
	end

	if data.external_fov_multiplier then
		self._external_fov_multiplier = data.external_fov_multiplier
	else
		self._external_fov_multiplier = 1
	end

	self:_update_fov_multiplier(dt, data)
end

BaseCamera._update_fov_multiplier = function (self, dt, data)
	local new_fov_multiplier = data.fov_multiplier
	local wanted_fov_multiplier = self._wanted_fov_multiplier
	local fov_multiplier_lerp_time = self._fov_multiplier_lerp_time

	if new_fov_multiplier and new_fov_multiplier ~= wanted_fov_multiplier then
		self._wanted_fov_multiplier = new_fov_multiplier
		fov_multiplier_lerp_time = 0
	end

	if fov_multiplier_lerp_time then
		local fov_multiplier = self._fov_multiplier
		local lerp_time = data.fov_multiplier_lerp_time or self._default_fov_multiplier_lerp_time
		local lerp_value = fov_multiplier_lerp_time / lerp_time

		fov_multiplier = math.lerp(fov_multiplier, wanted_fov_multiplier, lerp_value)
		self._fov_multiplier = fov_multiplier
		fov_multiplier_lerp_time = math.min(fov_multiplier_lerp_time + dt, lerp_time)

		if lerp_time <= fov_multiplier_lerp_time then
			self._fov_multiplier_lerp_time = nil
		else
			self._fov_multiplier_lerp_time = fov_multiplier_lerp_time
		end
	end
end

BaseCamera.destroy = function (self)
	for _, child in ipairs(self._children) do
		child:destroy()
	end

	self._children = {}
	self._parent_node = nil
end

return BaseCamera
