local ScriptCamera = require("scripts/foundation/utilities/script_camera")
local ScriptViewport = require("scripts/foundation/utilities/script_viewport")
local ScriptWorld = {
	name = function (world)
		return World.get_data(world, "name")
	end,
	activate = function (world)
		World.set_data(world, "active", true)
	end,
	deactivate = function (world)
		World.set_data(world, "active", false)
	end,
	pause = function (world)
		World.set_data(world, "paused", true)
	end,
	unpause = function (world)
		World.set_data(world, "paused", false)
	end,
	bottom_viewport = function (world)
		local render_queue = World.get_data(world, "render_queue")

		if render_queue then
			return render_queue[1]
		else
			return nil
		end
	end
}

ScriptWorld.create_viewport = function (world, name, template, layer, camera_unit, position, rotation, add_shadow_cull_camera, shading_environment_name, shading_callback, mood_setting, render_targets)
	local viewports = World.get_data(world, "viewports")
	local viewport = Application.create_viewport(world, template, render_targets)

	Viewport.set_data(viewport, "layer", layer or 1)
	Viewport.set_data(viewport, "active", true)
	Viewport.set_data(viewport, "name", name)

	viewports[name] = viewport

	ScriptWorld.create_shading_environment(world, viewport, shading_environment_name, shading_callback, mood_setting or "default")

	if camera_unit then
		local camera = Unit.camera(camera_unit, "camera")

		if position then
			ScriptCamera.set_local_position(camera, position)
		end

		if rotation then
			ScriptCamera.set_local_rotation(camera, rotation)
		end
	elseif position and rotation then
		camera_unit = World.spawn_unit_ex(world, "core/units/camera", nil, position, rotation)
	elseif position then
		camera_unit = World.spawn_unit_ex(world, "core/units/camera", nil, position)
	else
		camera_unit = World.spawn_unit_ex(world, "core/units/camera")
	end

	ScriptWorld.change_camera_unit(viewport, camera_unit, add_shadow_cull_camera)
	ScriptWorld._update_render_queue(world)

	return viewport
end

ScriptWorld.change_camera_unit = function (viewport, camera_unit, add_shadow_cull_camera)
	local camera = Unit.camera(camera_unit, "camera")

	Camera.set_data(camera, "unit", camera_unit)
	Viewport.set_data(viewport, "camera", camera)

	if add_shadow_cull_camera then
		local shadow_cull_camera = Unit.camera(camera_unit, "shadow_cull_camera")

		Camera.set_data(shadow_cull_camera, "unit", camera_unit)
		Viewport.set_data(viewport, "shadow_cull_camera", shadow_cull_camera)
	end
end

ScriptWorld.has_viewport = function (world, name)
	local viewports = World.get_data(world, "viewports")

	return viewports[name] and true or false
end

ScriptWorld.viewport = function (world, name, return_free_flight_viewport)
	local viewport = nil

	if return_free_flight_viewport then
		viewport = World.get_data(world, "free_flight_viewports")[name] or World.get_data(world, "viewports")[name]
	else
		viewport = World.get_data(world, "viewports")[name]
	end

	return viewport
end

ScriptWorld.destroy_viewport = function (world, name)
	local viewports = World.get_data(world, "viewports")
	local viewport = viewports[name]
	viewports[name] = nil

	ScriptWorld.destroy_shading_environment(world, viewport)

	local camera = Viewport.get_data(viewport, "camera")
	local camera_unit = Camera.get_data(camera, "unit")

	World.destroy_unit(world, camera_unit)
	Application.destroy_viewport(world, viewport)
	ScriptWorld._update_render_queue(world)
end

ScriptWorld.create_global_free_flight_viewport = function (world, template)
	local viewports = World.get_data(world, "viewports")

	if table.is_empty(viewports) then
		return nil
	end

	local bottom_viewport = ScriptWorld.bottom_viewport(world)
	local bottom_layer = Viewport.get_data(bottom_viewport, "layer")
	local free_flight_viewport = Application.create_viewport(world, template)

	Viewport.set_data(free_flight_viewport, "layer", bottom_layer)
	Viewport.set_data(free_flight_viewport, "name", "global_free_flight")
	Viewport.set_data(free_flight_viewport, "is_first_render", true)
	World.set_data(world, "global_free_flight_viewport", free_flight_viewport)

	local camera_unit = World.spawn_unit_ex(world, "core/units/camera")
	local camera = Unit.camera(camera_unit, "camera")

	Camera.set_data(camera, "unit", camera_unit)

	local bottom_layer_camera = ScriptViewport.camera(bottom_viewport)
	local pose = Camera.local_pose(bottom_layer_camera)

	ScriptCamera.set_local_pose(camera, pose)

	local vertical_fov = Camera.vertical_fov(bottom_layer_camera)

	Camera.set_vertical_fov(camera, vertical_fov)
	Viewport.set_data(free_flight_viewport, "camera", camera)

	return free_flight_viewport
end

ScriptWorld.global_free_flight_viewport = function (world)
	return World.get_data(world, "global_free_flight_viewport")
end

ScriptWorld.destroy_global_free_flight_viewport = function (world)
	local viewport = World.get_data(world, "global_free_flight_viewport")
	local camera = Viewport.get_data(viewport, "camera")
	local camera_unit = Camera.get_data(camera, "unit")

	World.destroy_unit(world, camera_unit)
	Application.destroy_viewport(world, viewport)
	World.set_data(world, "global_free_flight_viewport", nil)
end

ScriptWorld.create_free_flight_viewport = function (world, overridden_viewport_name, template, shading_environment_name, shading_callback, mood_setting)
	local overridden_viewport = ScriptWorld.viewport(world, overridden_viewport_name)
	local free_flight_viewport = Application.create_viewport(world, template)

	Viewport.set_data(free_flight_viewport, "layer", Viewport.get_data(overridden_viewport, "layer"))

	local free_flight_viewports = World.get_data(world, "free_flight_viewports")
	free_flight_viewports[overridden_viewport_name] = free_flight_viewport

	ScriptWorld.create_shading_environment(world, free_flight_viewport, shading_environment_name, shading_callback, mood_setting or "default")

	local camera_unit = World.spawn_unit_ex(world, "core/units/camera")
	local camera = Unit.camera(camera_unit, "camera")

	Camera.set_data(camera, "unit", camera_unit)

	local overridden_viewport_camera = ScriptViewport.camera(overridden_viewport)
	local pose = Camera.local_pose(overridden_viewport_camera)

	ScriptCamera.set_local_pose(camera, pose)
	Viewport.set_data(free_flight_viewport, "camera", camera)
	Viewport.set_data(free_flight_viewport, "overridden_viewport", overridden_viewport)
	ScriptWorld._update_render_queue(world)

	return free_flight_viewport
end

ScriptWorld.free_flight_viewport = function (world, name)
	local viewports = World.get_data(world, "free_flight_viewports")

	return viewports[name]
end

ScriptWorld.destroy_free_flight_viewport = function (world, name)
	local viewports = World.get_data(world, "free_flight_viewports")
	local viewport = viewports[name]
	viewports[name] = nil

	ScriptWorld.destroy_shading_environment(world, viewport)

	local camera = Viewport.get_data(viewport, "camera")
	local camera_unit = Camera.get_data(camera, "unit")

	World.destroy_unit(world, camera_unit)
	Application.destroy_viewport(world, viewport)
	ScriptWorld._update_render_queue(world)
end

ScriptWorld.activate_viewport = function (world, viewport)
	Viewport.set_data(viewport, "active", true)
	ScriptWorld._update_render_queue(world)
end

ScriptWorld.deactivate_viewport = function (world, viewport)
	Viewport.set_data(viewport, "active", false)
	ScriptWorld._update_render_queue(world)
end

ScriptWorld.update = function (world, dt, anim_callback, scene_callback)
	if World.get_data(world, "active") then
		if World.get_data(world, "paused") then
			dt = 0
		end

		if anim_callback then
			World.update_animations_with_callback(world, dt, anim_callback)
		else
			World.update_animations(world, dt)
		end

		if scene_callback then
			World.update_scene_with_callback(world, dt, scene_callback)
		else
			World.update_scene(world, dt)
		end
	else
		World.update_timer(world, dt)
	end
end

local function _check_shadow_baking(world, shading_environment)
	local shadow_baked = World.get_data(world, "shadow_baked")
	local chunk_lod_manager = Managers.state and Managers.state.chunk_lod

	if chunk_lod_manager and not shadow_baked then
		chunk_lod_manager:disable()
		Renderer.bake_static_shadows()
		chunk_lod_manager:enable()
		World.set_data(world, "shadow_baked", true)
	end
end

ScriptWorld.render = function (world)
	local render_queue = World.get_data(world, "render_queue")

	if not render_queue or #render_queue == 0 then
		return
	end

	local global_free_flight_viewport = World.get_data(world, "global_free_flight_viewport")

	if global_free_flight_viewport then
		local bottom_viewport = ScriptWorld.bottom_viewport(world)
		local shading_settings = Viewport.get_data(bottom_viewport, "shading_settings")
		local shading_environment = Viewport.get_data(bottom_viewport, "shading_environment")

		ShadingEnvironment.blend(shading_environment, shading_settings)

		local has_shading_callback = Viewport.has_data(bottom_viewport, "shading_callback")

		if has_shading_callback and not Viewport.get_data(bottom_viewport, "avoid_shading_callback") then
			local shading_callback = Viewport.get_data(bottom_viewport, "shading_callback")
			local default_shading_environment_resource = Viewport.get_data(bottom_viewport, "default_resource")

			shading_callback(world, shading_environment, bottom_viewport, default_shading_environment_resource)
		end

		ShadingEnvironment.apply(shading_environment)
		_check_shadow_baking(world, shading_environment)

		local camera = ScriptViewport.camera(global_free_flight_viewport)

		if World.update_lod_levels then
			World.update_lod_levels(world, camera)
		end

		Application.render_world(world, camera, global_free_flight_viewport, shading_environment)
	else
		local should_blend = not World.get_data(world, "avoid_blend")
		local render_queue_size = #render_queue

		for i = 1, render_queue_size do
			local viewport = render_queue[i]
			local shading_environment = Viewport.get_data(viewport, "shading_environment")

			if should_blend then
				local shading_settings = Viewport.get_data(viewport, "shading_settings")
				local override_shading_settings = Viewport.get_data(viewport, "override_shading_settings")

				ShadingEnvironment.blend(shading_environment, shading_settings, override_shading_settings)
			end

			local has_shading_callback = Viewport.has_data(viewport, "shading_callback")

			if has_shading_callback and not Viewport.get_data(viewport, "avoid_shading_callback") then
				local shading_callback = Viewport.get_data(viewport, "shading_callback")
				local default_shading_environment_resource = Viewport.get_data(viewport, "default_resource")

				shading_callback(world, shading_environment, viewport, default_shading_environment_resource)
			end

			if should_blend then
				ShadingEnvironment.apply(shading_environment)
				_check_shadow_baking(world, shading_environment)
			end

			local camera = ScriptViewport.camera(viewport)

			if World.update_lod_levels then
				World.update_lod_levels(world, camera)
			end

			Application.render_world(world, camera, viewport, shading_environment)
		end
	end
end

ScriptWorld._update_render_queue = function (world)
	local render_queue = {}
	local viewports = World.get_data(world, "viewports")
	local free_flight_viewports = World.get_data(world, "free_flight_viewports")

	for name, viewport in pairs(viewports) do
		if ScriptViewport.active(viewport) then
			render_queue[#render_queue + 1] = free_flight_viewports[name] or viewport
		end
	end

	local function comparator(v1, v2)
		return Viewport.get_data(v1, "layer") < Viewport.get_data(v2, "layer")
	end

	table.sort(render_queue, comparator)
	World.set_data(world, "render_queue", render_queue)
end

ScriptWorld.create_shading_environment = function (world, viewport, shading_environment_name, shading_callback, mood_setting)
	local shading_environment = World.create_shading_environment(world, shading_environment_name)
	local shading_environment_resource = World.create_shading_environment_resource(world, shading_environment_name)

	Viewport.set_data(viewport, "default_shading_environment_name", shading_environment_name)
	Viewport.set_data(viewport, "shading_environment", shading_environment)
	Viewport.set_data(viewport, "shading_callback", shading_callback)
	Viewport.set_data(viewport, "default_resource", shading_environment_resource)
	Viewport.set_data(viewport, "shading_settings", {
		shading_environment_resource,
		1,
		ShadingEnvironmentBlendMask.ALL
	})

	return shading_environment
end

ScriptWorld.destroy_shading_environment = function (world, viewport)
	local shading_environment = Viewport.get_data(viewport, "shading_environment")
	local shading_environment_resource = Viewport.get_data(viewport, "default_resource")

	Viewport.set_data(viewport, "default_shading_environment_name", nil)
	Viewport.set_data(viewport, "shading_environment", nil)
	Viewport.set_data(viewport, "shading_callback", nil)
	Viewport.set_data(viewport, "default_resource", nil)
	Viewport.set_data(viewport, "shading_settings", nil)
	World.destroy_shading_environment_resource(world, shading_environment_resource)
	World.destroy_shading_environment(world, shading_environment)
end

ScriptWorld.spawn_level = function (world, name, object_sets, position, rotation, spawn_units, ignore_background)
	local levels = World.get_data(world, "levels")
	local spawned_level_count = World.get_data(world, "spawned_level_count")
	local level = nil

	if spawn_units then
		level = World.spawn_level(world, name, position or Vector3.zero(), rotation or Quaternion.identity(), Vector3(1, 1, 1), object_sets)
	else
		level = World.spawn_level_time_sliced(world, name, position or Vector3.zero(), rotation or Quaternion.identity(), Vector3(1, 1, 1), object_sets)
	end

	spawned_level_count = spawned_level_count + 1
	levels[name] = {
		level = level,
		id = spawned_level_count
	}

	Log.info("ScriptWorld", "Registering level named: %q with id: %d", name, spawned_level_count)

	spawned_level_count = spawned_level_count + ScriptWorld._register_nested_levels(levels, level, spawned_level_count)

	World.set_data(world, "spawned_level_count", spawned_level_count)

	if not ignore_background then
		Level.spawn_background(level)
	end

	return level
end

ScriptWorld._register_nested_levels = function (levels, parent, last_count)
	local num_sub_levels = Level.num_nested_levels(parent)
	local sub_level_names = {}
	local sub_levels = Level.nested_levels(parent)

	for i = 1, num_sub_levels do
		sub_level_names[i] = Level.name(sub_levels[i])

		Log.info("ScriptWorld", "Registering sub level named: %q with id: %d", sub_level_names[i], last_count + i)

		levels[sub_level_names[i]] = {
			level = sub_levels[i],
			id = last_count + i
		}
	end

	return num_sub_levels
end

ScriptWorld._unregister_nested_levels = function (levels, parent_level)
	local num_sub_levels = Level.num_nested_levels(parent_level)
	local sub_levels = Level.nested_levels(parent_level)

	for i = 1, num_sub_levels do
		local sub_level_name = Level.name(sub_levels[i])
		levels[sub_level_name] = nil

		Log.info("ScriptWorld", "Unregistering sub level named: %q", sub_level_name)
	end
end

ScriptWorld.level_id = function (world, level)
	local levels = World.get_data(world, "levels")

	for name, data in pairs(levels) do
		if data.level == level then
			return data.id
		end
	end
end

ScriptWorld.level_from_id = function (world, level_id)
	local levels = World.get_data(world, "levels")

	for name, data in pairs(levels) do
		if data.id == level_id then
			return data.level
		end
	end
end

ScriptWorld.level_id_from_name = function (world, name)
	local levels = World.get_data(world, "levels")

	return levels[name].id
end

ScriptWorld.level = function (world, name)
	local levels = World.get_data(world, "levels")

	return levels[name].level
end

ScriptWorld.register_sub_levels_spawned_callback = function (world, level, cb)
	local levels = World.get_data(world, "levels")

	for name, data in pairs(levels) do
		if data.level == level then
			data.sub_levels_spawned_cb = cb
		end
	end
end

ScriptWorld.trigger_sub_levels_spawned = function (world, level)
	local levels = World.get_data(world, "levels")

	for name, data in pairs(levels) do
		if data.level == level and data.sub_levels_spawned_cb then
			data.sub_levels_spawned_cb()
		end
	end
end

ScriptWorld.destroy_level = function (world, name)
	local levels = World.get_data(world, "levels")

	ScriptWorld._unregister_nested_levels(levels, levels[name].level)
	World.destroy_level(world, levels[name].level)

	levels[name] = nil
end

ScriptWorld.optimize_level_units = function (world)
	local levels = World.get_data(world, "levels")
	local Level_units = Level.units
	local ScriptUnit_optimize = ScriptUnit.optimize

	for _, level_data in pairs(levels) do
		local level = level_data.level
		local level_units = Level_units(level)

		for i = 1, #level_units do
			ScriptUnit_optimize(level_units[i])
		end
	end
end

return ScriptWorld
