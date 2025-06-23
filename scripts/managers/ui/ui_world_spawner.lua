-- chunkname: @scripts/managers/ui/ui_world_spawner.lua

local ScriptWorld = require("scripts/foundation/utilities/script_world")
local ScriptViewport = require("scripts/foundation/utilities/script_viewport")
local UIUnitSpawner = require("scripts/managers/ui/ui_unit_spawner")
local ExtensionManager = require("scripts/foundation/managers/extension/extension_manager")
local WorldRenderUtils = require("scripts/utilities/world_render")
local VOSourcesCache = require("scripts/extension_systems/dialogue/vo_sources_cache")
local UIWorldSpawner = class("UIWorldSpawner")

UIWorldSpawner.init = function (self, world_name, world_layer, timer_name, optional_view_name, optional_flags)
	self._world_name = world_name

	local world = self:_create_world(world_name, world_layer, timer_name, optional_view_name, optional_flags)

	self._storyteller = World.storyteller(world)

	World.set_data(world, "__world_name", world_name)
	World.set_data(world, "__is_ui_world", true)

	self._unit_spawner = UIUnitSpawner:new(world)
	self._world = world
	self._story_speed = 1
end

UIWorldSpawner.play_story = function (self, story_name, start_time, play_backwards, on_complete_callback, on_complete_callback_time_fraction)
	if self:is_playing_story() then
		self:stop_active_story()
	end

	local level = self._level
	local storyteller = self._storyteller
	local story_id = storyteller:play_level_story(level, story_name)
	local length = storyteller:length(story_id)

	self._active_story_id = story_id
	self._on_story_complete_callback = on_complete_callback
	self._on_complete_callback_time_fraction = on_complete_callback_time_fraction

	if start_time then
		storyteller:set_time(story_id, math.clamp(start_time, 0, length))
	end

	if play_backwards then
		if not start_time then
			local time = storyteller:time(story_id)

			storyteller:set_time(story_id, math.clamp(time, 0, length))
		end

		storyteller:set_speed(story_id, -1 * self._story_speed)
	else
		storyteller:set_speed(story_id, self._story_speed)
	end

	self._play_story_backwards = play_backwards

	return story_id
end

UIWorldSpawner.set_story_speed = function (self, story_speed)
	self._story_speed = story_speed or 1

	if self._active_story_id then
		self._storyteller:set_speed(self._active_story_id, (self._play_story_backwards and -1 or 1) * self._story_speed)
	end
end

UIWorldSpawner.story_time = function (self, story_id)
	return self._storyteller:time(story_id)
end

UIWorldSpawner.story_length_by_name = function (self, story_name)
	return self._storyteller:length_from_name(story_name)
end

UIWorldSpawner.stop_story = function (self, story_id)
	self._storyteller:stop(story_id)

	self._active_story_id = nil
	self._on_story_complete_callback = nil

	return story_id
end

UIWorldSpawner.stop_active_story = function (self)
	if self:is_playing_story() then
		self._storyteller:stop(self._active_story_id)

		self._active_story_id = nil
		self._on_story_complete_callback = nil
	end
end

UIWorldSpawner.active_story_id = function (self)
	if self:is_playing_story() then
		return self._active_story_id
	end
end

UIWorldSpawner.is_playing_story = function (self)
	if self._active_story_id then
		local active = self._storyteller:is_playing(self._active_story_id)

		return active
	end

	return false
end

UIWorldSpawner.spawn_level = function (self, level_name, included_object_sets, position, rotation, ignore_level_background)
	self._level_name = level_name

	local world = self._world
	local spawn_units = true

	self:_setup_extension_manager()

	local level = ScriptWorld.spawn_level(world, level_name, position, rotation, spawn_units, ignore_level_background, included_object_sets)

	self._level = level

	local level_units = Level.units(level, true)
	local category_name = "level_spawned"

	self._extension_manager:add_and_register_units(world, level_units, nil, category_name)
	Level.trigger_level_spawned(level)

	if ignore_level_background then
		Level.trigger_event(level, "disable_background")
	end

	self._extension_manager:on_gameplay_post_init(level)
end

UIWorldSpawner.trigger_level_event = function (self, event_name)
	local level = self._level

	if level then
		Level.trigger_event(level, event_name)
	end
end

UIWorldSpawner.level = function (self)
	return self._level
end

UIWorldSpawner.world = function (self)
	return self._world
end

UIWorldSpawner.world_name = function (self)
	return self._world_name
end

UIWorldSpawner.unit_spawner = function (self)
	return self._unit_spawner
end

UIWorldSpawner.camera = function (self)
	return self._camera
end

UIWorldSpawner.camera_unit = function (self)
	local camera = self._camera
	local camera_unit = Camera.get_data(camera, "unit")

	return camera_unit
end

UIWorldSpawner._setup_extension_manager = function (self)
	local world = self._world
	local physics_world = World.physics_world(world)
	local wwise_world = Managers.world:wwise_world(world)
	local level_name = self._level_name
	local is_server
	local unit_templates = require("scripts/extension_systems/unit_templates")

	require("scripts/extension_systems/cinematic_scene/cinematic_scene_system")
	require("scripts/extension_systems/cutscene_character/cutscene_character_system")
	require("scripts/extension_systems/component/component_extension")
	require("scripts/extension_systems/component/component_system")
	require("scripts/extension_systems/dialogue/dialogue_context_system")
	require("scripts/extension_systems/dialogue/dialogue_system")
	require("scripts/extension_systems/light_controller/light_controller_system")

	local system_config = {
		{
			"component_system",
			"ComponentSystem",
			false,
			false,
			false,
			true,
			false,
			{
				"ComponentExtension"
			}
		},
		{
			"dialogue_system",
			"DialogueSystem",
			false,
			false,
			false,
			true,
			false,
			{
				"DialogueExtension"
			}
		},
		{
			"dialogue_context_system",
			"DialogueContextSystem",
			false,
			false,
			false,
			true,
			false
		},
		{
			"cutscene_character_system",
			"CutsceneCharacterSystem",
			false,
			false,
			false,
			false,
			false,
			{
				"CutsceneCharacterExtension"
			}
		},
		{
			"cinematic_scene_system",
			"CinematicSceneSystem",
			false,
			false,
			false,
			true,
			false,
			{
				"CinematicSceneExtension"
			}
		},
		{
			"light_controller_system",
			"LightControllerSystem",
			false,
			false,
			false,
			true,
			false,
			{
				"LightControllerExtension"
			}
		}
	}
	local vo_sources_cache = VOSourcesCache:new()
	local system_init_data = {
		dialogue_context_system = {},
		dialogue_system = {
			is_rule_db_enabled = false,
			vo_sources_cache = vo_sources_cache
		},
		cinematic_scene_system = {
			mission = {}
		},
		light_controller_system = {
			mission = {}
		},
		component_system = {}
	}
	local unit_categories = {
		"flow_spawned",
		"level_spawned",
		"cinematic"
	}
	local circumstance_name = "default"
	local use_time_slice = false

	self._extension_manager = ExtensionManager:new(world, physics_world, wwise_world, nil, nil, level_name, circumstance_name, nil, is_server, unit_templates, system_config, system_init_data, unit_categories, nil, nil, nil, {}, use_time_slice)

	Managers.ui:register_world_extension_manager_lookup(world, self._extension_manager)
end

UIWorldSpawner._create_world = function (self, world_name, layer, timer_name, optional_view_name, optional_flags)
	local flags = optional_flags or {
		Application.ENABLE_VOLUMETRICS,
		Application.ENABLE_RAY_TRACING
	}
	local ui_manager = Managers.ui
	local world = ui_manager:create_world(world_name, layer, timer_name, optional_view_name, flags)

	World.set_flow_callback_table(world, "FlowCallbacks", "UIFlowCallbacks")

	return world
end

local function quaternion_apply(data, name, quaternion)
	return data[name]:store(quaternion)
end

local function quaternion_get(data)
	return data.value:unbox()
end

local function quaternion_lerp(from, to, percent)
	return Quaternion.lerp(from:unbox(), to:unbox(), percent)
end

local function quaternion_animation_data(default)
	return {
		value = QuaternionBox(default),
		from = QuaternionBox(default),
		to = QuaternionBox(default),
		apply = quaternion_apply,
		lerp = quaternion_lerp,
		get = quaternion_get
	}
end

local function direct_apply(data, name, value)
	data[name] = value
end

local function direct_get(data)
	return data.value
end

local function numeric_animation_data(default)
	return {
		value = default,
		from = default,
		to = default,
		apply = direct_apply,
		lerp = math.lerp,
		get = direct_get
	}
end

UIWorldSpawner.create_viewport = function (self, camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment, shading_callback, render_targets)
	local world = self._world

	if self._viewport then
		local ignore_camera_destruction = self._ignore_camera_destruction

		ScriptWorld.destroy_viewport(world, self._viewport_name, ignore_camera_destruction)

		self._viewport = nil
		self._viewport_name = nil
	end

	shading_callback = shading_callback or callback(self, "_shading_callback")
	self._ignore_camera_destruction = camera_unit ~= nil

	local viewport = ScriptWorld.create_viewport(world, viewport_name, viewport_type, viewport_layer, camera_unit, nil, nil, nil, shading_environment, shading_callback, nil, render_targets)

	self._viewport = viewport
	self._viewport_name = viewport_name

	local camera = ScriptViewport.camera(viewport)

	camera_unit = camera_unit or Camera.get_data(camera, "unit")
	self._camera = camera
	self._camera_unit = camera_unit

	local camera_position = Unit.world_position(camera_unit, 1)
	local camera_rotation = Unit.world_rotation(camera_unit, 1)

	self._boxed_camera_start_position = Vector3Box(camera_position)
	self._boxed_camera_start_rotation = QuaternionBox(camera_rotation)

	local fov = math.deg(Camera.vertical_fov(camera))

	self._start_camera_fov = fov
	self._camera_animation_data = {
		fov = numeric_animation_data(fov),
		rotation = quaternion_animation_data(camera_rotation),
		position = {
			dx = numeric_animation_data(0),
			dy = numeric_animation_data(0),
			dz = numeric_animation_data(0)
		}
	}

	ScriptWorld.activate_viewport(world, viewport)

	return viewport
end

UIWorldSpawner.set_listener = function (self, viewport_name)
	local camera_manager = Managers.state.camera

	if camera_manager then
		local world = self._world

		camera_manager:use_ui_listener(true)

		local pose = self:listener_pose(viewport_name)
		local wwise_world = Managers.world:wwise_world(world)

		WwiseWorld.set_listener(wwise_world, 0, pose)
	end
end

UIWorldSpawner.release_listener = function (self)
	local camera_manager = Managers.state.camera

	if camera_manager then
		camera_manager:use_ui_listener(false)
	end
end

UIWorldSpawner.listener_pose = function (self, viewport_name)
	local world = self._world
	local viewport = ScriptWorld.viewport(world, viewport_name, true)
	local camera = ScriptViewport.camera(viewport)
	local pose = Camera.world_pose(camera)

	return pose
end

UIWorldSpawner.add_viewport_custom_output_targets = function (self, custom_render_targets)
	Viewport.add_custom_output_targets(self._viewport, custom_render_targets)
end

UIWorldSpawner.change_camera_unit = function (self, camera_unit, add_shadow_cull_camera, revert_camera_changes)
	local is_same_unit = camera_unit == self._camera_unit

	if not is_same_unit and revert_camera_changes then
		self:reset_camera_target()
		self:_update_camera(1e-06)
	end

	local viewport = self._viewport

	ScriptWorld.change_camera_unit(viewport, camera_unit, add_shadow_cull_camera)

	local camera = ScriptViewport.camera(viewport)

	self._camera = camera
	self._camera_unit = camera_unit

	if not is_same_unit then
		local camera_position = Unit.world_position(camera_unit, 1)
		local camera_rotation = Unit.world_rotation(camera_unit, 1)

		self._start_camera_fov = math.deg(Camera.vertical_fov(camera))

		Vector3Box.store(self._boxed_camera_start_position, camera_position)
		QuaternionBox.store(self._boxed_camera_start_rotation, camera_rotation)
	end

	self:reset_camera_target()
end

UIWorldSpawner.sync_camera_to_camera_unit = function (self, camera_unit)
	local camera_position = Unit.world_position(camera_unit, 1)
	local camera_rotation = Unit.world_rotation(camera_unit, 1)

	self:set_camera_position(camera_position)
	self:set_camera_rotation(camera_rotation)
end

UIWorldSpawner.set_camera_position = function (self, position)
	local camera_unit = self._camera_unit

	Unit.set_local_position(camera_unit, 1, position)
	Vector3Box.store(self._boxed_camera_start_position, position)
	self:reset_target_camera_offset()
end

UIWorldSpawner.set_camera_rotation = function (self, rotation)
	local camera_unit = self._camera_unit

	Unit.set_local_rotation(camera_unit, 1, rotation)
	QuaternionBox.store(self._boxed_camera_start_rotation, rotation)
	self:reset_target_camera_rotation()
end

UIWorldSpawner.set_viewport_position = function (self, x_scale, y_scale)
	self._viewport_x_scale = x_scale or self._viewport_x_scale or 0
	self._viewport_y_scale = y_scale or self._viewport_y_scale or 0

	self:_update_viewport_rect()
end

UIWorldSpawner.set_viewport_size = function (self, width_scale, height_scale)
	self._viewport_width_scale = width_scale or self._viewport_width_scale or 1
	self._viewport_height_scale = height_scale or self._viewport_height_scale or 1

	self:_update_viewport_rect()
end

UIWorldSpawner._update_viewport_rect = function (self)
	local x_scale = math.clamp(self._viewport_x_scale or 0, 0, 1)
	local y_scale = math.clamp(self._viewport_y_scale or 0, 0, 1)
	local width_scale = math.clamp(self._viewport_width_scale or 0, 0, 1)
	local height_scale = math.clamp(self._viewport_height_scale or 0, 0, 1)

	Viewport.set_rect(self._viewport, x_scale, y_scale, width_scale, height_scale)
end

UIWorldSpawner._set_fov = function (self, fov)
	self._start_camera_fov = fov

	Camera.set_vertical_fov(self._camera, fov * math.pi / 180)
	self:reset_target_camera_fov()
end

UIWorldSpawner.boxed_camera_start_position = function (self)
	return self._boxed_camera_start_position
end

UIWorldSpawner.boxed_camera_start_rotation = function (self)
	return self._boxed_camera_start_rotation
end

UIWorldSpawner._shading_callback = function (self, world, shading_env, viewport, default_shading_environment_name)
	local gamma = Application.user_setting("gamma") or 0

	ShadingEnvironment.set_scalar(shading_env, "exposure_compensation", ShadingEnvironment.scalar(shading_env, "exposure_compensation") + gamma)

	local blur_value = World.get_data(world, "fullscreen_blur") or 0

	if blur_value > 0 then
		ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_enabled", 1)
		ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_amount", math.clamp(blur_value, 0, 1))
	else
		World.set_data(world, "fullscreen_blur", nil)
		ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_enabled", 0)
	end

	local greyscale_value = World.get_data(world, "greyscale") or 0

	if greyscale_value > 0 then
		ShadingEnvironment.set_scalar(shading_env, "grey_scale_enabled", 1)
		ShadingEnvironment.set_scalar(shading_env, "grey_scale_amount", math.clamp(greyscale_value, 0, 1))
		ShadingEnvironment.set_vector3(shading_env, "grey_scale_weights", Vector3(0.33, 0.33, 0.33))
	else
		World.set_data(world, "greyscale", nil)
		ShadingEnvironment.set_scalar(shading_env, "grey_scale_enabled", 0)
	end
end

UIWorldSpawner.interpolate_to_camera = function (self, target_camera_unit, percent, animation_time, func_ptr)
	local boxed_camera_start_position = self:boxed_camera_start_position()
	local default_camera_world_position = Vector3.from_array(boxed_camera_start_position)
	local target_world_position = Unit.world_position(target_camera_unit, 1)

	self:set_target_camera_offset(percent * (target_world_position.x - default_camera_world_position.x), percent * (target_world_position.y - default_camera_world_position.y), percent * (target_world_position.z - default_camera_world_position.z), animation_time, func_ptr)

	local boxed_camera_start_rotation = self:boxed_camera_start_rotation()
	local default_camera_world_rotation = boxed_camera_start_rotation:unbox()
	local target_world_rotation = Unit.world_rotation(target_camera_unit, 1)
	local interpolated_world_rotation = Quaternion.lerp(default_camera_world_rotation, target_world_rotation, percent)

	self:set_target_camera_rotation(interpolated_world_rotation, animation_time, func_ptr)

	local start_camera_fov = self._start_camera_fov
	local target_camera = Unit.camera(target_camera_unit, "camera")

	if target_camera then
		local target_fov = Camera.vertical_fov(target_camera) * 180 / math.pi
		local current_fov = start_camera_fov + (target_fov - start_camera_fov) * percent

		self:set_target_camera_fov(current_fov, animation_time, func_ptr)
	else
		self:set_target_camera_fov(start_camera_fov, animation_time, func_ptr)
	end
end

UIWorldSpawner.set_target_camera_offset_for_axis = function (self, axis, value, animation_time, func)
	self:_set_animation_data(self._camera_animation_data.position[axis], value, 0, animation_time, func)
end

UIWorldSpawner.set_target_camera_rotation = function (self, target_world_rotation, animation_time, func_ptr)
	local initial_rotation = self._boxed_camera_start_rotation:unbox()

	self:_set_animation_data(self._camera_animation_data.rotation, target_world_rotation, initial_rotation, animation_time, func_ptr)
end

UIWorldSpawner.set_target_camera_offset = function (self, dx, dy, dz, animation_time, func_ptr)
	self:_set_animation_data(self._camera_animation_data.position.dx, dx, 0, animation_time, func_ptr)
	self:_set_animation_data(self._camera_animation_data.position.dy, dy, 0, animation_time, func_ptr)
	self:_set_animation_data(self._camera_animation_data.position.dz, dz, 0, animation_time, func_ptr)
end

UIWorldSpawner.set_target_camera_position = function (self, x, y, z, animation_time, func_ptr)
	local dx = x and x - self._boxed_camera_start_position.x or 0
	local dy = y and y - self._boxed_camera_start_position.y or 0
	local dz = z and z - self._boxed_camera_start_position.z or 0

	self:set_target_camera_offset(dx, dy, dz, animation_time, func_ptr)
end

UIWorldSpawner.set_target_camera_fov = function (self, target_fov, animation_time, func_ptr)
	self:_set_animation_data(self._camera_animation_data.fov, target_fov, self._start_camera_fov, animation_time, func_ptr)
end

UIWorldSpawner.reset_target_camera_fov = function (self, animation_time, func_ptr)
	self:set_target_camera_fov(self._start_camera_fov, animation_time, func_ptr)
end

UIWorldSpawner.reset_target_camera_offset = function (self, animation_time, func_ptr)
	self:set_target_camera_offset(0, 0, 0, animation_time, func_ptr)
end

UIWorldSpawner.reset_target_camera_rotation = function (self, animation_time, func_ptr)
	self:set_target_camera_rotation(self._boxed_camera_start_rotation:unbox(), animation_time, func_ptr)
end

UIWorldSpawner.reset_camera_target = function (self, animation_time, func_ptr)
	self:reset_target_camera_fov(animation_time, func_ptr)
	self:reset_target_camera_offset(animation_time, func_ptr)
	self:reset_target_camera_rotation(animation_time, func_ptr)
end

local function linear(x)
	return x
end

UIWorldSpawner._set_animation_data = function (self, data, target, default_value, animation_time, func_ptr)
	data.total_time = animation_time or 0
	data.time = 0
	data.func = func_ptr or linear

	data:apply("from", data:get() or default_value)
	data:apply("to", target or default_value)
end

UIWorldSpawner._update_animation_data = function (self, data, dt)
	local total_time = data.total_time

	if total_time then
		data.time = math.min(data.time + dt, total_time)

		local percent = total_time > 0 and data.func(data.time / total_time) or 1
		local value = data.lerp(data.from, data.to, percent)

		data:apply("value", value)
	end

	if total_time and data.time == total_time then
		data.total_time = false
		data.time = 0
		data.func = linear
	end
end

UIWorldSpawner._animate_axis = function (self, source, axis, value, animation_time, func_ptr, optional_start_time)
	local data = source[axis]

	data.from = animation_time and data.value or value
	data.to = value
	data.total_time = animation_time
	data.time = optional_start_time or 0
	data.func = func_ptr
	data.value = data.from
end

UIWorldSpawner.set_camera_blur = function (self, blur_amount, duration, anim_func)
	if not self._blur_animation_data and blur_amount == self._current_blur then
		return
	end

	local current_blur = self._current_blur or 0
	local blur_difference = blur_amount - current_blur

	self._blur_animation_data = {
		time = 0,
		start_value = current_blur,
		end_value = blur_amount,
		value_difference = blur_difference,
		anim_func = anim_func,
		duration = math.abs(blur_difference) * (duration or 1)
	}
end

UIWorldSpawner._set_world_blur_value = function (self, blur_amount)
	local world = self._world

	World.set_data(world, "fullscreen_blur", 0.75 * blur_amount)

	self._world_blurred = blur_amount ~= 0

	local world_name = self._world_name
	local viewport_name = self._viewport_name

	if self._world_blurred then
		WorldRenderUtils.enable_world_fullscreen_blur(world_name, viewport_name, blur_amount)
	else
		WorldRenderUtils.disable_world_fullscreen_blur(world_name, viewport_name)
	end
end

UIWorldSpawner._update_camera_animations = function (self, dt)
	self:_update_animation_data(self._camera_animation_data.rotation, dt)
	self:_update_animation_data(self._camera_animation_data.fov, dt)
	self:_update_animation_data(self._camera_animation_data.position.dx, dt)
	self:_update_animation_data(self._camera_animation_data.position.dy, dt)
	self:_update_animation_data(self._camera_animation_data.position.dz, dt)
end

UIWorldSpawner._update_camera_rotation = function (self)
	local camera_rotation = self._camera_animation_data.rotation:get()

	Unit.set_local_rotation(self._camera_unit, 1, camera_rotation)
end

UIWorldSpawner._update_camera_position = function (self)
	local boxed_camera_start_position = self._boxed_camera_start_position
	local camera_position_animation_data = self._camera_animation_data.position
	local camera_position_new = Vector3.zero()

	camera_position_new.x = boxed_camera_start_position[1] + camera_position_animation_data.dx:get()
	camera_position_new.y = boxed_camera_start_position[2] + camera_position_animation_data.dy:get()
	camera_position_new.z = boxed_camera_start_position[3] + camera_position_animation_data.dz:get()

	Unit.set_local_position(self._camera_unit, 1, camera_position_new)
end

UIWorldSpawner._update_fov = function (self)
	Camera.set_vertical_fov(self._camera, math.rad(self._camera_animation_data.fov:get()))
end

UIWorldSpawner._update_camera = function (self, dt)
	self:_update_camera_animations(dt)
	self:_update_camera_position()
	self:_update_camera_rotation()
	self:_update_fov()
end

UIWorldSpawner._update_world_blur = function (self, dt)
	local blur_animation_data = self._blur_animation_data

	if not blur_animation_data then
		return self._current_blur or 0
	end

	local time = blur_animation_data.time
	local duration = blur_animation_data.duration
	local anim_func = blur_animation_data.anim_func

	time = math.min(time + dt, duration)

	local progress = duration > 0 and time / duration or 0
	local anim_progress = anim_func and anim_func(progress) or progress
	local start_value = blur_animation_data.start_value
	local value_difference = blur_animation_data.value_difference
	local new_value = start_value + anim_progress * value_difference

	if progress == 1 then
		self._blur_animation_data = nil
	else
		blur_animation_data.time = time
	end

	return new_value
end

UIWorldSpawner.update = function (self, dt, t)
	local blur_value = self:_update_world_blur(dt)

	if blur_value ~= self._current_blur then
		self._current_blur = blur_value

		self:_set_world_blur_value(blur_value)
	end

	local extension_manager = self._extension_manager

	if extension_manager then
		extension_manager:pre_update(dt, t)
		extension_manager:update()
	end

	local animation_data = self._camera_animation_data

	if animation_data then
		self:_update_camera(dt)
	end

	local active_story_id = self._active_story_id

	if active_story_id and self._on_story_complete_callback then
		local storyteller = self._storyteller
		local active = self._storyteller:is_playing(active_story_id)

		if active then
			local current_time = self:story_time(active_story_id)
			local length = storyteller:length(active_story_id)
			local play_story_backwards = self._play_story_backwards
			local on_complete_time_fraction = self._on_complete_callback_time_fraction or 1

			if not play_story_backwards and current_time >= length * on_complete_time_fraction and self._on_story_complete_callback then
				self._on_story_complete_callback()

				self._on_story_complete_callback = nil
			end
		end
	end

	self._unit_spawner:remove_pending_units()
end

UIWorldSpawner.set_world_disabled = function (self, disabled)
	disabled = disabled or false
	self._world_disabled = disabled

	local world_name = self._world_name
	local world_manager = Managers.world
	local world_disabled_state = not world_manager:is_world_enabled(world_name)

	if world_disabled_state ~= disabled then
		world_manager:enable_world(world_name, not disabled)
	end
end

UIWorldSpawner.world_disabled = function (self)
	return self._world_disabled
end

UIWorldSpawner.destroy = function (self)
	local world = self._world

	if self._extension_manager then
		self._extension_manager:unregister_unit_category("level_spawned")
		self._extension_manager:unregister_unit_category("flow_spawned")
	end

	local unit_spawner = self._unit_spawner

	if unit_spawner then
		unit_spawner:remove_pending_units()
		unit_spawner:destroy()

		self._unit_spawner = nil
	end

	if self._viewport then
		local ignore_camera_destruction = self._ignore_camera_destruction

		ScriptWorld.destroy_viewport(world, self._viewport_name, ignore_camera_destruction)

		self._viewport = nil
		self._viewport_name = nil
	end

	if self._level then
		ScriptWorld.destroy_level(world, self._level_name)

		self._level = nil
		self._level_name = nil
	end

	if self._extension_manager then
		Managers.ui:unregister_world_extension_manager_lookup(world)
		self._extension_manager:destroy()

		self._extension_manager = nil
	end

	Managers.ui:destroy_world(world)

	self._world = nil
	self._world_name = nil
end

return UIWorldSpawner
