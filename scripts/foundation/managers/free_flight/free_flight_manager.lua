-- chunkname: @scripts/foundation/managers/free_flight/free_flight_manager.lua

local InputDevice = require("scripts/managers/input/input_device")
local FreeFlightDefaultInput = require("scripts/foundation/managers/free_flight/free_flight_default_input")
local FreeFlightFollowPath = require("scripts/foundation/managers/free_flight/utilities/free_flight_follow_path")
local FreeFlightManagerTestify = GameParameters.testify and require("scripts/foundation/managers/free_flight/free_flight_manager_testify")
local ScriptCamera = require("scripts/foundation/utilities/script_camera")
local ScriptViewport = require("scripts/foundation/utilities/script_viewport")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local FreeFlightManager = class("FreeFlightManager")

FreeFlightManager.DEBUG_TAG = "Free Flight"
FreeFlightManager.STD_TRANSLATION_SPEED = 3
FreeFlightManager.STD_ACCELERATION = 10
FreeFlightManager.STD_ROTATION_SPEED = 0.003
FreeFlightManager.STD_SPEED_CHANGE = 0.5
FreeFlightManager.STD_MINIMUM_SPEED = 0.001
FreeFlightManager.STD_MAXIMUM_SPEED = 50
FreeFlightManager.STD_ORTHOGRAPHIC_SIZE = 100
FreeFlightManager.STD_ORTHOGRAPHIC_SPEED = 250
FreeFlightManager.STD_FOCAL_DISTANCE = 10
FreeFlightManager.STD_FOCAL_REGION = 8
FreeFlightManager.STD_FOCAL_REGION_START = 4
FreeFlightManager.STD_FOCAL_REGION_END = 4
FreeFlightManager.STD_FOCAL_NEAR_SCALE = 1
FreeFlightManager.STD_FOCAL_FAR_SCALE = 1
FreeFlightManager.STD_DOF_CHANGE = 0.2
FreeFlightManager.STD_DOF_PADDING_CHANGE = 0.1
FreeFlightManager.STD_DOF_SCALE_CHANGE = 0.02
FreeFlightManager.STD_FOV_CHANGE = math.pi / 72
FreeFlightManager.STD_FOV_CHANGE_PER_S = math.pi / 18

FreeFlightManager.init = function (self)
	self._has_terrain = not not rawget(_G, "TerrainDecoration")
	self._default_input = FreeFlightDefaultInput:new()

	self:set_input_source(self._default_input)

	self._free_flight_cameras = {}

	self:_create_global_camera()

	self._look_input_enabled = true
	self._follow_path = FreeFlightFollowPath:new()
end

FreeFlightManager._create_global_camera = function (self)
	self._free_flight_cameras.global = {}

	self:_setup_standard_camera(self._free_flight_cameras.global)
end

FreeFlightManager._setup_standard_camera = function (self, camera)
	camera.active = false
	camera.mode = "paused"
	camera.translation_speed = self.STD_TRANSLATION_SPEED
	camera.rotation_speed = self.STD_ROTATION_SPEED
	camera.projection_type = Camera.PERSPECTIVE
	camera.orthographic_data = {
		size = self.STD_ORTHOGRAPHIC_SIZE,
	}
	camera.dof_enabled = 0

	self:_reset_dof(camera)
end

FreeFlightManager.set_project_specific_teleporter = function (self, object)
	self._free_flight_teleporter = object
end

FreeFlightManager.on_gameplay_shutdown = function (self)
	self:_clean_up()
end

FreeFlightManager._clean_up = function (self)
	local global_camera = self._free_flight_cameras.global

	if global_camera.active then
		self:_exit_global_free_flight(global_camera)
	end
end

FreeFlightManager.destroy = function (self)
	self:_clean_up()

	self._has_terrain = nil
	self._input = nil
	self._free_flight_cameras = nil
end

FreeFlightManager.set_input_source = function (self, source)
	self._input = source
end

FreeFlightManager._get_input = function (self)
	local imgui_manager, ui_manager = Managers.imgui, Managers.ui
	local input_is_being_used_by_other_manager = imgui_manager and imgui_manager:using_input() or ui_manager and ui_manager:using_input()
	local input = input_is_being_used_by_other_manager and self._input:null_service() or self._input

	return input
end

FreeFlightManager.update = function (self, dt, t)
	local input = self:_get_input()

	self:_check_toggle(input)

	for camera_id, camera_data in pairs(self._free_flight_cameras) do
		if camera_data.active then
			self:_check_camera(input, dt, camera_id, camera_data)
		end
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(FreeFlightManagerTestify, self)
	end
end

FreeFlightManager._camera = function (self, camera_id)
	local data = self._free_flight_cameras[camera_id]
	local name = data.viewport_world_name

	if not name then
		self:_debug_print("Free flight camera id %i not active. Try pressing f9 first.", camera_id)

		return false
	end

	local world = Managers.world:world(data.viewport_world_name)
	local viewport = ScriptWorld.global_free_flight_viewport(world)
	local camera = ScriptViewport.camera(viewport)

	return camera
end

FreeFlightManager._debug_print = function (self, str, ...)
	Log.debug(self.DEBUG_TAG, str, ...)
end

FreeFlightManager.teleport_camera = function (self, camera_id, pos, rot)
	local camera = self:_camera(camera_id)

	if not camera then
		return
	end

	if rot then
		local pose = Matrix4x4.from_quaternion_position(rot, pos)

		ScriptCamera.set_local_pose(camera, pose)
	else
		ScriptCamera.set_local_position(camera, pos)
	end
end

FreeFlightManager.camera_position_rotation = function (self, camera_id)
	local camera = self:_camera(camera_id)

	if not camera then
		return
	end

	local position = ScriptCamera.position(camera)
	local rotation = ScriptCamera.rotation(camera)

	return position, rotation
end

FreeFlightManager.camera_pose = function (self, data)
	local world = Managers.world:world(data.viewport_world_name)
	local viewport = ScriptWorld.global_free_flight_viewport(world)
	local cam = data.frustum_freeze_camera or ScriptViewport.camera(viewport)
	local cm = Camera.local_pose(cam)

	return cm
end

FreeFlightManager._check_toggle = function (self, input)
	local global_toggle = input:get("global_toggle")
	local global_camera = self._free_flight_cameras.global

	if global_camera.active and global_toggle then
		self:_debug_print("Toggle Free Flight")
		self:_exit_global_free_flight(global_camera)
	elseif global_toggle then
		self:_debug_print("Toggle Free Flight")
		self:_enter_global_free_flight(global_camera)
	end
end

FreeFlightManager.is_in_free_flight = function (self)
	local global_camera = self._free_flight_cameras.global

	return global_camera.active
end

FreeFlightManager._check_camera = function (self, input, dt, camera_id, camera_data)
	local frustum_modifier = input:get("frustum_toggle")

	if not Managers.world:has_world(camera_data.viewport_world_name) then
		self:_clear_free_flight_camera(camera_data)
	elseif frustum_modifier and BUILD ~= "release" then
		local world = Managers.world:world(camera_data.viewport_world_name)

		self:_toggle_frustum_freeze(dt, camera_data, world, ScriptWorld.global_free_flight_viewport(world))
	else
		self:_update_camera(input, dt, camera_data)
	end
end

FreeFlightManager._exit_frustum_freeze = function (self, data, world, viewport)
	World.set_frustum_inspector_camera(world, nil)

	local camera = data.frustum_freeze_camera
	local cam = ScriptViewport.camera(viewport)
	local cam_unit = Camera.get_data(cam, "unit")
	local pose = Camera.local_pose(camera)

	Camera.set_local_pose(cam, cam_unit, pose)

	data.frustum_freeze_camera = nil
end

FreeFlightManager._enter_frustum_freeze = function (self, data, world, viewport)
	local camera
	local cam = ScriptViewport.camera(viewport)
	local cam_fov = Camera.vertical_fov(cam)
	local camera_unit = World.spawn_unit_ex(world, "core/units/camera")

	camera = Unit.camera(camera_unit, "camera")

	Camera.set_data(camera, "unit", camera_unit)

	local pose = Camera.local_pose(cam)

	Camera.set_local_pose(camera, camera_unit, pose)
	Camera.set_vertical_fov(camera, cam_fov)

	data.frustum_freeze_camera = camera

	World.set_frustum_inspector_camera(world, camera)
end

FreeFlightManager._toggle_frustum_freeze = function (self, dt, data, world, viewport)
	if data.frustum_freeze_camera then
		self:_exit_frustum_freeze(data, world, viewport)
	else
		self:_enter_frustum_freeze(data, world, viewport)
	end
end

FreeFlightManager.toggle_follow_path = function (self)
	if self._follow_path:active() then
		self._follow_path:stop()
	else
		self._follow_path:start()
	end
end

FreeFlightManager.set_follow_path_speed = function (self, speed)
	self._follow_path:set_speed(speed)
end

FreeFlightManager._update_camera = function (self, input, dt, camera_data)
	local world = Managers.world:world(camera_data.viewport_world_name)
	local viewport = ScriptWorld.global_free_flight_viewport(world)
	local cam = camera_data.frustum_freeze_camera or ScriptViewport.camera(viewport)
	local toggle_look_input = input:get("toggle_look_input")
	local projection_mode_swap = input:get("top_down_toggle")
	local speed_change = input:get("speed_change")
	local look = input:get("look")
	local move_right = input:get("move_right")
	local move_left = input:get("move_left")
	local move_forward = input:get("move_forward")
	local move_back = input:get("move_backward")
	local move_up = input:get("move_up")
	local move_down = input:get("move_down")
	local roll_left = input:get("roll_left")
	local roll_right = input:get("roll_right")
	local move_controller = input:get("move_controller")
	local using_gamepad = Managers.input:is_using_gamepad()

	if not using_gamepad then
		move_controller = Vector3.zero()
	end

	if toggle_look_input then
		self._look_input_enabled = not self._look_input_enabled
	end

	if projection_mode_swap and camera_data.projection_type == Camera.PERSPECTIVE then
		camera_data.projection_type = Camera.ORTHOGRAPHIC
	elseif projection_mode_swap and camera_data.projection_type == Camera.ORTHOGRAPHIC then
		camera_data.projection_type = Camera.PERSPECTIVE
	end

	Camera.set_projection_type(cam, camera_data.projection_type)

	local translation_change_speed = camera_data.translation_speed * self.STD_SPEED_CHANGE

	camera_data.translation_speed = camera_data.translation_speed + speed_change * translation_change_speed
	camera_data.translation_speed = math.clamp(camera_data.translation_speed, self.STD_MINIMUM_SPEED, self.STD_MAXIMUM_SPEED)

	local cm = Camera.local_pose(cam)
	local trans = Matrix4x4.translation(cm)

	if self._follow_path:active() then
		self._follow_path:update(dt, cm)
	elseif self._look_input_enabled then
		if camera_data.projection_type == Camera.ORTHOGRAPHIC then
			local ortho_data = camera_data.orthographic_data

			ortho_data.yaw = (ortho_data.yaw or 0) - Vector3.x(look) * camera_data.rotation_speed

			local q1 = Quaternion(Vector3(0, 0, 1), ortho_data.yaw)
			local q2 = Quaternion(Vector3.right(), -math.half_pi)
			local q = Quaternion.multiply(q1, q2)
			local x_trans = (move_right - move_left + move_controller.x) * dt * self.STD_ORTHOGRAPHIC_SPEED
			local y_trans = (move_forward - move_back + move_controller.y) * dt * self.STD_ORTHOGRAPHIC_SPEED
			local pos = trans + Quaternion.up(q) * y_trans + Quaternion.right(q) * x_trans

			cm = Matrix4x4.from_quaternion_position(q, pos)

			local size = ortho_data.size

			size = size - speed_change * (size * dt)
			ortho_data.size = size

			Camera.set_orthographic_view(cam, -size, size, -size, size)
		else
			Matrix4x4.set_translation(cm, Vector3(0, 0, 0))

			local q1 = Quaternion(Vector3(0, 0, 1), -Vector3.x(look) * (camera_data.rotation_speed * (using_gamepad and 2 or 1)))
			local q2 = Quaternion(Matrix4x4.x(cm), -Vector3.y(look) * (camera_data.rotation_speed * (using_gamepad and 2 or 1)))
			local roll = -roll_left + roll_right
			local q3 = Quaternion(Matrix4x4.y(cm), roll * (camera_data.rotation_speed * (using_gamepad and 2 or 1)))
			local q = Quaternion.multiply(q1, q2)

			q = Quaternion.multiply(q, q3)
			cm = Matrix4x4.multiply(cm, Matrix4x4.from_quaternion(q))

			local x_trans = move_right - move_left + move_controller.x
			local y_trans = move_forward - move_back + move_controller.y
			local z_trans = move_up - move_down
			local offset = Matrix4x4.transform(cm, Vector3(x_trans, y_trans, z_trans) * camera_data.translation_speed * dt)

			trans = Vector3.add(trans, offset)

			Matrix4x4.set_translation(cm, trans)
		end
	else
		Debug:colored_text(Color.red(), "FREE FLIGHT CAMERA LOCKED,     Keybind: TAB")
	end

	local rot = Matrix4x4.rotation(cm)
	local wwise_world = Managers.world:wwise_world(world)

	WwiseWorld.set_listener(wwise_world, 0, cm)

	if self._has_terrain then
		TerrainDecoration.move_observer(world, camera_data.terrain_decoration_observer, trans)
	end

	ScatterSystem.move_observer(World.scatter_system(world), camera_data.scatter_system_observer, trans, rot)

	if input:get("teleport_player_to_camera") then
		local position = Matrix4x4.translation(cm)
		local rotation = Matrix4x4.rotation(cm)
		local teleporter = self._free_flight_teleporter

		if teleporter then
			teleporter:teleport_player_to_camera_position(position, rotation)
		else
			Log.info("FreeFlightManager", "There is no free_flight_teleporter extension hooked to this manager")
		end
	end

	if input:get("toggle_input_in_free_flight") then
		local new_value = not DevParameters.allow_character_input_in_free_flight

		ParameterResolver.set_dev_parameter("allow_character_input_in_free_flight", new_value)
	end

	if DevParameters.allow_character_input_in_free_flight then
		Debug:colored_text(Color.orange_red(), "FREE FLIGHT INPUT ENABLED,     Keybind: L-CTRL + SPACE")
	end

	ScriptCamera.set_local_pose(cam, cm)
	self:_handle_fov(dt, input, cam)
	self:_handle_dof(dt, input, camera_data, world)
end

FreeFlightManager._handle_fov = function (self, dt, input, camera)
	local fov = Camera.vertical_fov(camera)
	local increase_fov_hold = input:get("increase_fov_hold")
	local decrease_fov_hold = input:get("decrease_fov_hold")

	if input:get("increase_fov") and not increase_fov_hold then
		fov = fov + self.STD_FOV_CHANGE
	end

	if input:get("decrease_fov") and not decrease_fov_hold then
		fov = fov - self.STD_FOV_CHANGE
	end

	if increase_fov_hold then
		fov = fov + self.STD_FOV_CHANGE_PER_S * dt
	end

	if decrease_fov_hold then
		fov = fov - self.STD_FOV_CHANGE_PER_S * dt
	end

	Camera.set_vertical_fov(camera, fov)
end

FreeFlightManager._reset_dof = function (self, data)
	data.dof_focal_distance = self.STD_FOCAL_DISTANCE
	data.dof_focal_region = self.STD_FOCAL_REGION
	data.dof_focal_region_start = self.STD_FOCAL_REGION_START
	data.dof_focal_region_end = self.STD_FOCAL_REGION_END
	data.dof_focal_near_scale = self.STD_FOCAL_NEAR_SCALE
	data.dof_focal_far_scale = self.STD_FOCAL_FAR_SCALE

	self:_debug_print("Dof Focal Distance: %f", data.dof_focal_distance)
	self:_debug_print("Dof Focal Region: %f", data.dof_focal_region)
	self:_debug_print("Dof Focal Padding: %f", data.dof_focal_region_start)
	self:_debug_print("Dof Focal Scale: %f", data.dof_focal_near_scale)
end

FreeFlightManager._handle_dof = function (self, dt, input, data, world)
	local bottom_viewport = ScriptWorld.bottom_viewport(world)

	if not bottom_viewport then
		return
	end

	local shading_env = Viewport.get_data(bottom_viewport, "shading_environment")

	if input:get("toggle_dof") and not input:get("reset_dof") then
		data.dof_enabled = 1 - data.dof_enabled
	end

	if input:get("inc_dof_distance") then
		data.dof_focal_distance = data.dof_focal_distance + self.STD_DOF_CHANGE

		self:_debug_print("Dof Focal Distance: %f", data.dof_focal_distance)
	end

	if input:get("dec_dof_distance") then
		data.dof_focal_distance = data.dof_focal_distance - self.STD_DOF_CHANGE

		if data.dof_focal_distance < 0 then
			data.dof_focal_distance = 0
		end

		self:_debug_print("Dof Focal Distance: %f", data.dof_focal_distance)
	end

	if input:get("inc_dof_region") then
		data.dof_focal_region = data.dof_focal_region + self.STD_DOF_CHANGE

		self:_debug_print("Dof Focal Region: %f", data.dof_focal_region)
	end

	if input:get("dec_dof_region") then
		data.dof_focal_region = data.dof_focal_region - self.STD_DOF_CHANGE

		if data.dof_focal_region < 0 then
			data.dof_focal_region = 0
		end

		self:_debug_print("Dof Focal Region: %f", data.dof_focal_region)
	end

	if input:get("inc_dof_padding") then
		data.dof_focal_region_start = data.dof_focal_region_start + self.STD_DOF_PADDING_CHANGE
		data.dof_focal_region_end = data.dof_focal_region_end + self.STD_DOF_PADDING_CHANGE

		self:_debug_print("Dof Focal Padding: %f", data.dof_focal_region_start)
	end

	if input:get("dec_dof_padding") then
		data.dof_focal_region_start = data.dof_focal_region_start - self.STD_DOF_PADDING_CHANGE
		data.dof_focal_region_end = data.dof_focal_region_end - self.STD_DOF_PADDING_CHANGE

		if data.dof_focal_region_start < 0 then
			data.dof_focal_region_start = 0
		end

		if data.dof_focal_region_end < 0 then
			data.dof_focal_region_end = 0
		end

		self:_debug_print("Dof Focal Padding: %f", data.dof_focal_region_start)
	end

	if input:get("inc_dof_scale") then
		data.dof_focal_near_scale = data.dof_focal_near_scale + self.STD_DOF_SCALE_CHANGE
		data.dof_focal_far_scale = data.dof_focal_far_scale + self.STD_DOF_SCALE_CHANGE

		if data.dof_focal_near_scale > 1 then
			data.dof_focal_near_scale = 1
		end

		if data.dof_focal_far_scale > 1 then
			data.dof_focal_far_scale = 1
		end

		self:_debug_print("Dof Focal Scale: %f", data.dof_focal_near_scale)
	end

	if input:get("dec_dof_scale") then
		data.dof_focal_near_scale = data.dof_focal_near_scale - self.STD_DOF_SCALE_CHANGE
		data.dof_focal_far_scale = data.dof_focal_far_scale - self.STD_DOF_SCALE_CHANGE

		if data.dof_focal_near_scale < 0 then
			data.dof_focal_near_scale = 0
		end

		if data.dof_focal_far_scale < 0 then
			data.dof_focal_far_scale = 0
		end

		self:_debug_print("Dof Focal Scale: %f", data.dof_focal_near_scale)
	end

	if input:get("reset_dof") then
		self:_reset_dof(data)
	end

	ShadingEnvironment.set_scalar(shading_env, "dof_enabled", data.dof_enabled)
	ShadingEnvironment.set_scalar(shading_env, "dof_focal_distance", data.dof_focal_distance)
	ShadingEnvironment.set_scalar(shading_env, "dof_focal_region", data.dof_focal_region)
	ShadingEnvironment.set_scalar(shading_env, "dof_focal_region_start", data.dof_focal_region_start)
	ShadingEnvironment.set_scalar(shading_env, "dof_focal_region_end", data.dof_focal_region_end)
	ShadingEnvironment.set_scalar(shading_env, "dof_focal_near_scale", data.dof_focal_near_scale)
	ShadingEnvironment.set_scalar(shading_env, "dof_focal_far_scale", data.dof_focal_far_scale)

	if ShadingEnvironment.scalar(shading_env, "dof_enabled") then
		ShadingEnvironment.apply(shading_env)
	end
end

FreeFlightManager._enter_global_free_flight = function (self, camera_data)
	local world = Application.main_world()

	if not world then
		return
	end

	local viewport = ScriptWorld.create_global_free_flight_viewport(world, "default")

	if not viewport then
		return
	end

	camera_data.active = true
	camera_data.viewport_world_name = ScriptWorld.name(world)

	local cam = ScriptViewport.camera(viewport)
	local tm = Camera.local_pose(cam)
	local position = Matrix4x4.translation(tm)
	local rotation = Matrix4x4.rotation(tm)

	if self._follow_path then
		self._follow_path:stop()
	end

	if self._has_terrain then
		camera_data.terrain_decoration_observer = TerrainDecoration.create_observer(world, position)
	end

	camera_data.scatter_system_observer = ScatterSystem.make_observer(World.scatter_system(world), position, rotation)
end

FreeFlightManager._exit_global_free_flight = function (self, camera_data)
	local world = Managers.world:world(camera_data.viewport_world_name)

	if camera_data.frustum_freeze_camera then
		self:_exit_frustum_freeze(camera_data, world, ScriptWorld.global_free_flight_viewport(world))
	end

	local world_name = camera_data.viewport_world_name

	if self._has_terrain then
		TerrainDecoration.destroy_observer(world, camera_data.terrain_decoration_observer)
	end

	ScatterSystem.destroy_observer(World.scatter_system(world), camera_data.scatter_system_observer)

	camera_data.active = false
	camera_data.viewport_world_name = nil

	ScriptWorld.destroy_global_free_flight_viewport(Managers.world:world(world_name))
end

FreeFlightManager._clear_free_flight_camera = function (self, camera_data)
	camera_data.active = false
	camera_data.viewport_world_name = nil
end

return FreeFlightManager
