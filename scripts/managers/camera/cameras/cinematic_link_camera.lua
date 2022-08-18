local RootCamera = require("scripts/managers/camera/cameras/root_camera")
local CinematicLinkCamera = class("CinematicLinkCamera", "RootCamera")
CinematicLinkCamera.CAMERA_NODE_ID = 1
CinematicLinkCamera.CROPPED_ASPECT_RATIO = 2.35

CinematicLinkCamera.init = function (self, root_node)
	RootCamera.init(self, root_node)
end

local DOF_PARAMETERS = {
	{
		use_ceil = true,
		environment_parameter = "dof_enabled",
		unit_node_name = "Enabled"
	},
	{
		use_ceil = false,
		environment_parameter = "focal_distance",
		unit_node_name = "Distance"
	},
	{
		use_ceil = false,
		environment_parameter = "focal_region",
		unit_node_name = "Region"
	},
	{
		use_ceil = false,
		environment_parameter = "focal_padding",
		unit_node_name = "Padding"
	},
	{
		use_ceil = false,
		environment_parameter = "focal_scale",
		unit_node_name = "Scale"
	}
}

CinematicLinkCamera.update = function (self, dt, data)
	local root_unit = self._root_unit

	if ALIVE[root_unit] then
		local cinematic_manager = Managers.state.cinematic

		fassert(cinematic_manager, "CinematicManager not available with CinematicLinkCamera.")

		local alignment_inverse_pose_boxed = cinematic_manager:alignment_inverse_pose()
		local alignment_inverse_pose = nil

		if alignment_inverse_pose_boxed then
			alignment_inverse_pose = alignment_inverse_pose_boxed:unbox()
		else
			alignment_inverse_pose = Matrix4x4.identity()
		end

		for i = 1, #DOF_PARAMETERS, 1 do
			local dof_parameter = DOF_PARAMETERS[i]
			local unit_node_name = dof_parameter.unit_node_name
			local node_id = Unit.node(root_unit, unit_node_name)
			local node_position = Unit.local_position(root_unit, node_id)
			node_position = Matrix4x4.transform(alignment_inverse_pose, node_position)
			local environment_parameter = dof_parameter.environment_parameter

			if dof_parameter.use_ceil then
				self._environment_params[environment_parameter] = math.ceil(node_position.y)
			else
				self._environment_params[environment_parameter] = node_position.y
			end
		end
	end

	RootCamera.update(self, dt, data)
end

CinematicLinkCamera.set_root_unit = function (self, unit, object, preserve_yaw)
	RootCamera.set_root_unit(self, unit, object, preserve_yaw)

	self._root_camera = Unit.camera(self._root_unit, self.CAMERA_NODE_ID)
end

CinematicLinkCamera.near_range = function (self)
	if ALIVE[self._root_unit] then
		return Camera.near_range(self._root_camera)
	end

	return CinematicLinkCamera.super.near_range(self)
end

CinematicLinkCamera.far_range = function (self)
	if ALIVE[self._root_unit] then
		return Camera.far_range(self._root_camera)
	end

	return CinematicLinkCamera.super.far_range(self)
end

CinematicLinkCamera.vertical_fov = function (self)
	if ALIVE[self._root_unit] then
		local w = RESOLUTION_LOOKUP.width
		local h = RESOLUTION_LOOKUP.height
		local v_fov = Camera.vertical_fov(self._root_camera)
		local native_aspect_ratio = w / h
		local y = self.CROPPED_ASPECT_RATIO * math.tan(v_fov * 0.5)
		local new_fov = 2 * math.atan(y / native_aspect_ratio)

		return new_fov
	end

	return CinematicLinkCamera.super.vertical_fov(self)
end

return CinematicLinkCamera
