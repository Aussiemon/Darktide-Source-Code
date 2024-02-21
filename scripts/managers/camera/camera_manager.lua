require("scripts/managers/camera/cameras/aim_camera")
require("scripts/managers/camera/cameras/aim_down_sight_camera")
require("scripts/managers/camera/cameras/base_camera")
require("scripts/managers/camera/cameras/blend_camera")
require("scripts/managers/camera/cameras/cinematic_link_camera")
require("scripts/managers/camera/cameras/critically_dampened_string_transform_camera")
require("scripts/managers/camera/cameras/dampened_string_transform_camera")
require("scripts/managers/camera/cameras/first_person_animation_camera")
require("scripts/managers/camera/cameras/lerp_rotation_camera")
require("scripts/managers/camera/cameras/object_link_camera")
require("scripts/managers/camera/cameras/offset_camera")
require("scripts/managers/camera/cameras/root_camera")
require("scripts/managers/camera/cameras/rotation_camera")
require("scripts/managers/camera/cameras/scalable_fov_camera")
require("scripts/managers/camera/cameras/scalable_transform_camera")
require("scripts/managers/camera/cameras/scalable_z_axis_camera")
require("scripts/managers/camera/cameras/scanning_camera")
require("scripts/managers/camera/cameras/sway_camera")
require("scripts/managers/camera/cameras/testify_camera")
require("scripts/managers/camera/cameras/transform_camera")
require("scripts/managers/camera/transitions/camera_transition_exposure_snap")
require("scripts/managers/camera/transitions/camera_transition_fov_linear")
require("scripts/managers/camera/transitions/camera_transition_generic")
require("scripts/managers/camera/transitions/camera_transition_position_linear")
require("scripts/managers/camera/transitions/camera_transition_rotation_lerp")

local CameraEffectSettings = require("scripts/settings/camera/camera_effect_settings")
local CameraSettings = require("scripts/settings/camera/camera_settings")
local CameraShakeEvent = require("scripts/managers/camera/camera_shake_event")
local EnvironmentBlend = require("scripts/managers/camera/environment_blend")
local ScriptCamera = require("scripts/foundation/utilities/script_camera")
local ScriptViewport = require("scripts/foundation/utilities/script_viewport")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local WorldInteractionSettings = require("scripts/managers/world_interaction/world_interaction_settings")
local debug = false
local CameraManager = class("CameraManager")
CameraManager.NODE_PROPERTY_MAP = {
	"position",
	"rotation",
	"vertical_fov",
	"custom_vertical_fov",
	"near_range",
	"far_range",
	"shading_environment",
	"fade_to_black",
	"exposure_snap"
}

CameraManager.init = function (self, world)
	self._world = world
	self._physics_world = World.physics_world(self._world)
	self._scatter_system = World.scatter_system(self._world)
	self._rtxgi_volume = World.spawn_unit_ex(self._world, "content/characters/player/ddgi_volume/player_ddgi_volume")
	self._node_trees = {}
	self._current_trees = {}
	self._camera_nodes = {}
	self._scatter_system_observers = {}
	self._variables = {}
	self._mood_blend_list = {}
	self._last_rotation = QuaternionBox()
	self._angular_velocity = Vector3Box()
	self._listener_elevation_offset = 0
	self._listener_elevation_scale = 1
	self._listener_elevation_min = -math.huge
	self._listener_elevation_max = math.huge
	self._sequence_event_settings = {
		time_to_recover = 0,
		end_time = 0,
		start_time = 0
	}
	self._shake_event_settings = {}
	self._active_events = {}
	self._level_particle_effect_ids = {}
	self._level_screen_effect_ids = {}
	self._property_temp_table = {}
	self._environment_blenders = {}
	self._shading_environment_extensions = {}
	self._viewport_camera_data = {}
	self._shading_callback = callback(self, "shading_callback")
	self._camera_shake_enabled = true
	local vertical_fov = Application.user_setting("render_settings", "vertical_fov") or GameParameters.vertical_fov
	self._fov_multiplier = vertical_fov / GameParameters.vertical_fov
end

CameraManager.add_environment = function (self, shading_environment_extension)
	self._shading_environment_extensions[shading_environment_extension] = true

	for _, blender in pairs(self._environment_blenders) do
		blender:register_environment(shading_environment_extension)
	end
end

CameraManager.remove_environment = function (self, shading_environment_extension)
	self._shading_environment_extensions[shading_environment_extension] = nil

	for _, blender in pairs(self._environment_blenders) do
		blender:unregister_environment(shading_environment_extension)
	end
end

CameraManager._add_environment_blender = function (self, viewport_name)
	local new_blender = EnvironmentBlend:new(self._world)
	self._environment_blenders[viewport_name] = new_blender
	local shading_environment_extensions = self._shading_environment_extensions

	for environment_extension, _ in pairs(shading_environment_extensions) do
		new_blender:register_environment(environment_extension)
	end
end

CameraManager.destroy = function (self)
	return
end

CameraManager.set_elevation_offset = function (self, offset, scale, min, max)
	self._listener_elevation_offset = offset
	self._listener_elevation_scale = scale
	self._listener_elevation_min = min or -math.huge
	self._listener_elevation_max = max or math.huge
end

CameraManager.add_viewport = function (self, viewport_name, position, rotation)
	self._scatter_system_observers[viewport_name] = ScatterSystem.make_observer(self._scatter_system, position, rotation)
	self._node_trees[viewport_name] = {}
	self._variables[viewport_name] = {}
	self._camera_nodes[viewport_name] = {}
	self._shadow_lights_viewport = viewport_name

	self:_add_environment_blender(viewport_name)
end

CameraManager.create_viewport = function (self, viewport_name, camera_unit, position, rotation, shading_environment_name)
	local world = self._world
	local add_shadow_cull_camera = true
	local shading_callback = self._shading_callback
	local viewport = ScriptWorld.create_viewport(world, viewport_name, "default", 1, camera_unit, position, rotation, add_shadow_cull_camera, shading_environment_name, shading_callback)

	self:add_viewport(viewport_name, position, rotation)

	return viewport
end

CameraManager.destroy_viewport = function (self, viewport_name)
	local world = self._world

	ScriptWorld.destroy_viewport(world, viewport_name)
	ScatterSystem.destroy_observer(self._scatter_system, self._scatter_system_observers[viewport_name])

	self._scatter_system_observers[viewport_name] = nil
	self._node_trees[viewport_name] = nil
	self._variables[viewport_name] = nil
	self._camera_nodes[viewport_name] = nil
end

CameraManager.load_node_tree = function (self, viewport_name, tree_id, tree_name)
	local tree_settings = CameraSettings[tree_name]
	local node_table = {}
	local root_node = self:_setup_child_nodes(node_table, viewport_name, tree_id, nil, tree_settings)
	local tree_table = {
		root_node = root_node,
		nodes = node_table
	}
	self._node_trees[viewport_name][tree_id] = tree_table
end

CameraManager.delete_units = function (self)
	local world = self._world

	World.destroy_unit(world, self._rtxgi_volume)
end

CameraManager.node_tree_loaded = function (self, viewport_name, tree_id)
	if self._node_trees[viewport_name] and self._node_trees[viewport_name][tree_id] then
		return true
	end

	return false
end

CameraManager.set_node_tree_root_unit = function (self, viewport_name, tree_id, unit, object, preserve_aim_yaw)
	self._node_trees[viewport_name][tree_id].root_node:set_root_unit(unit, object, preserve_aim_yaw)
end

CameraManager.current_node_tree_root_unit = function (self, viewport_name)
	local tree_id = self._current_trees[viewport_name]

	return self._node_trees[viewport_name][tree_id].root_node:root_unit()
end

CameraManager.set_node_tree_root_position = function (self, viewport_name, tree_id, position)
	self._node_trees[viewport_name][tree_id].root_node:set_root_position(position)
end

CameraManager.set_node_tree_root_rotation = function (self, viewport_name, tree_id, rotation)
	self._node_trees[viewport_name][tree_id].root_node:set_root_rotation(rotation)
end

CameraManager.set_node_tree_root_vertical_fov = function (self, viewport_name, tree_id, vertical_fov)
	self._node_trees[viewport_name][tree_id].root_node:set_root_vertical_fov(vertical_fov)
end

CameraManager.set_node_tree_root_near_range = function (self, viewport_name, tree_id, near_range)
	self._node_trees[viewport_name][tree_id].root_node:set_root_near_range(near_range)
end

CameraManager.set_node_tree_root_far_range = function (self, viewport_name, tree_id, far_range)
	self._node_trees[viewport_name][tree_id].root_node:set_root_far_range(far_range)
end

CameraManager.set_node_tree_root_dof_enabled = function (self, viewport_name, tree_id, dof_enabled)
	self._node_trees[viewport_name][tree_id].root_node:set_root_dof_enabled(dof_enabled)
end

CameraManager.set_node_tree_root_focal_distance = function (self, viewport_name, tree_id, focal_distance)
	self._node_trees[viewport_name][tree_id].root_node:set_root_focal_distance(focal_distance)
end

CameraManager.set_node_tree_root_focal_region = function (self, viewport_name, tree_id, focal_region)
	self._node_trees[viewport_name][tree_id].root_node:set_root_focal_region(focal_region)
end

CameraManager.set_node_tree_root_focal_padding = function (self, viewport_name, tree_id, focal_padding)
	self._node_trees[viewport_name][tree_id].root_node:set_root_focal_padding(focal_padding)
end

CameraManager.set_node_tree_root_focal_scale = function (self, viewport_name, tree_id, focal_scale)
	self._node_trees[viewport_name][tree_id].root_node:set_root_focal_scale(focal_scale)
end

CameraManager.current_camera_node = function (self, viewport_name)
	return self._camera_nodes[viewport_name][#self._camera_nodes[viewport_name]].node:name()
end

CameraManager.tree_node = function (self, viewport_name, tree_id, node_name)
	local tree = self._node_trees[viewport_name][tree_id]

	return tree.nodes[node_name]
end

local merged_blend_list = {}

CameraManager.shading_callback = function (self, world, shading_env, viewport, default_shading_environment_resource)
	if self._world == world then
		local viewport_name = Viewport.get_data(viewport, "name")
		local camera_data = self._viewport_camera_data[viewport] or self._viewport_camera_data[Viewport.get_data(viewport, "overridden_viewport")]

		if not camera_data then
			return
		end

		local environment_blender = self._environment_blenders[viewport_name]
		local camera_pose = self:listener_pose(viewport_name)
		local camera_position = Matrix4x4.translation(camera_pose)
		local environment_blend_list = environment_blender:blend_list(camera_position, default_shading_environment_resource)
		local mood_blend_list = self._mood_blend_list

		table.clear(merged_blend_list)

		for i = 1, #environment_blend_list do
			merged_blend_list[i] = environment_blend_list[i]
		end

		for i = 1, #mood_blend_list do
			merged_blend_list[#merged_blend_list + 1] = mood_blend_list[i]
		end

		ShadingEnvironment.ordered_blend(shading_env, merged_blend_list)

		local camera_shading_env_settings = camera_data.shading_environment

		if camera_shading_env_settings.dof_enabled then
			local dof_enabled = camera_shading_env_settings.dof_enabled

			ShadingEnvironment.set_scalar(shading_env, "dof_enabled", dof_enabled)

			if dof_enabled > 0 then
				local focal_distance = camera_shading_env_settings.focal_distance
				local focal_region = camera_shading_env_settings.focal_region
				local focal_padding = camera_shading_env_settings.focal_padding
				local focal_scale = camera_shading_env_settings.focal_scale

				ShadingEnvironment.set_scalar(shading_env, "dof_focal_distance", focal_distance)
				ShadingEnvironment.set_scalar(shading_env, "dof_focal_region", focal_region)
				ShadingEnvironment.set_scalar(shading_env, "dof_focal_region_start", focal_padding)
				ShadingEnvironment.set_scalar(shading_env, "dof_focal_region_end", focal_padding)
				ShadingEnvironment.set_scalar(shading_env, "dof_focal_near_scale", focal_scale)
				ShadingEnvironment.set_scalar(shading_env, "dof_focal_far_scale", focal_scale)
			end
		end

		if camera_data.exposure_snap then
			ShadingEnvironment.set_scalar(shading_env, "exposure_snap", 1)
		end

		for interaction_type, interaction_settings in pairs(WorldInteractionSettings) do
			ShadingEnvironment.set_scalar(shading_env, interaction_settings.shading_env_variable, math.clamp(interaction_settings.window_size, 1, 100))
		end

		local gamma = Application.user_setting("gamma") or 0

		ShadingEnvironment.set_scalar(shading_env, "exposure_compensation", ShadingEnvironment.scalar(shading_env, "exposure_compensation") + gamma)

		local ui_bloom_value = World.get_data(world, "ui_bloom_enabled") or 0

		if ui_bloom_value > 0 then
			ShadingEnvironment.set_scalar(shading_env, "ui_bloom_enabled", 1)
			ShadingEnvironment.set_scalar(shading_env, "ui_enable_hdr_layer", 1)
			ShadingEnvironment.set_vector3(shading_env, "ui_bloom_threshold_offset_falloff", Vector3(World.get_data(world, "ui_bloom_threshold_offset_falloff_1") or 0, World.get_data(world, "ui_bloom_threshold_offset_falloff_2") or 0, World.get_data(world, "ui_bloom_threshold_offset_falloff_3") or 0))
			ShadingEnvironment.set_vector3(shading_env, "ui_bloom_tint", Vector3(World.get_data(world, "ui_bloom_tint_1") or 0, World.get_data(world, "ui_bloom_tint_2") or 0, World.get_data(world, "ui_bloom_tint_3") or 0))
		else
			World.set_data(world, "fullscreen_blur", nil)
			ShadingEnvironment.set_scalar(shading_env, "ui_bloom_enabled", 0)
			ShadingEnvironment.set_scalar(shading_env, "ui_enable_hdr_layer", 0)
		end

		local blur_value = World.get_data(world, "fullscreen_blur") or 0

		if blur_value > 0 then
			ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_enabled", 1)
			ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_amount", math.clamp(blur_value, 0, 1))
		else
			World.set_data(world, "fullscreen_blur", nil)
			ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_enabled", 0)
		end
	end
end

CameraManager._update_level_particle_effects = function (self, viewport_name)
	for id, _ in pairs(self._level_particle_effect_ids) do
		World.move_particles(self._world, id, self:camera_position(viewport_name))
	end
end

CameraManager.set_camera_node = function (self, viewport_name, tree_id, node_name)
	local old_tree_id = self._current_trees[viewport_name]
	self._current_trees[viewport_name] = tree_id
	local camera_nodes = self._camera_nodes[viewport_name]
	local current_node = camera_nodes[#camera_nodes]
	local tree = self._node_trees[viewport_name][tree_id]
	local next_node = {
		node = tree.nodes[node_name]
	}

	if current_node then
		local transition_template = nil

		if old_tree_id ~= tree_id then
			local tree_transitions = current_node.node:tree_transitions()
			transition_template = tree_transitions[tree_id] or tree_transitions.default

			if next_node then
				local node_transitions = current_node.node:node_transitions()

				if node_transitions[next_node.node:name()] then
					transition_template = node_transitions[next_node.node:name()]
				end
			end
		else
			local node_transitions = current_node.node:node_transitions()
			transition_template = node_transitions[next_node.node:name()] or node_transitions.default
		end

		if transition_template then
			self:_add_transition(viewport_name, current_node, next_node, transition_template)

			if transition_template.inherit_aim_rotation and old_tree_id ~= tree_id then
				local old_root = self._node_trees[viewport_name][old_tree_id].root_node
				local old_pitch = old_root:aim_pitch()
				local old_yaw = old_root:aim_yaw()

				tree.root_node:set_aim_pitch(old_pitch)
				tree.root_node:set_aim_yaw(old_yaw)
			end
		else
			next_node.transition = {}

			self:_remove_camera_node(camera_nodes, #camera_nodes)
		end
	else
		next_node.transition = {}
	end

	next_node.node:set_active(true)

	camera_nodes[#camera_nodes + 1] = next_node
end

CameraManager.is_in_view = function (self, viewport_name, position)
	local viewport = ScriptWorld.viewport(self._world, viewport_name)
	local camera = ScriptViewport.camera(viewport)

	return Camera.inside_frustum(camera, position) > 0
end

CameraManager.world_to_screen_position = function (self, viewport_name, world_position)
	local camera = self:camera(viewport_name)
	local world_to_screen, distance = Camera.world_to_screen(camera, world_position)

	return world_to_screen.x, world_to_screen.y, distance
end

CameraManager._remove_camera_node = function (self, camera_nodes, index)
	for i = 1, index do
		local node_table = table.remove(camera_nodes, 1)

		node_table.node:set_active(false)
	end
end

CameraManager.has_camera = function (self, viewport_name)
	local world = self._world

	if ScriptWorld.has_viewport(world, viewport_name) then
		local viewport = ScriptWorld.viewport(world, viewport_name)

		return ScriptViewport.camera(viewport)
	end

	return nil
end

CameraManager.camera = function (self, viewport_name)
	local viewport = ScriptWorld.viewport(self._world, viewport_name)

	return ScriptViewport.camera(viewport)
end

CameraManager.camera_position = function (self, viewport_name)
	local viewport = ScriptWorld.viewport(self._world, viewport_name)
	local camera = ScriptViewport.camera(viewport)

	return Camera.world_position(camera)
end

CameraManager.camera_rotation = function (self, viewport_name)
	local viewport = ScriptWorld.viewport(self._world, viewport_name)
	local camera = ScriptViewport.camera(viewport)

	return Camera.world_rotation(camera)
end

CameraManager.camera_pose = function (self, viewport_name)
	local viewport = ScriptWorld.viewport(self._world, viewport_name)
	local camera = ScriptViewport.camera(viewport)

	return Camera.world_pose(camera)
end

CameraManager.fov = function (self, viewport_name)
	local viewport = ScriptWorld.viewport(self._world, viewport_name)
	local camera = ScriptViewport.camera(viewport)

	return Camera.vertical_fov(camera)
end

CameraManager.angular_velocity = function (self, viewport_name)
	return self._angular_velocity:unbox()
end

CameraManager.has_viewport = function (self, viewport_name)
	return ScriptWorld.has_viewport(self._world, viewport_name)
end

CameraManager._setup_child_nodes = function (self, node_table, viewport_name, tree_id, parent_node, settings, root_node)
	local node_settings = settings._node
	local node = self:_setup_node(node_settings, parent_node, root_node)
	root_node = root_node or node
	node_table[node:name()] = node

	for key, child_settings in pairs(settings) do
		if key ~= "_node" then
			self:_setup_child_nodes(node_table, viewport_name, tree_id, node, child_settings, root_node)
		end
	end

	return node
end

CameraManager._setup_node = function (self, node_settings, parent_node, root_node)
	local node_name = node_settings.name
	local class_name = node_settings.class
	local node_class = CLASSES[class_name]
	local node = node_class:new(root_node)

	node:parse_parameters(node_settings, parent_node)

	if parent_node then
		parent_node:add_child_node(node)
	end

	return node
end

CameraManager.update = function (self, dt, t, viewport_name, yaw, pitch, roll)
	local node_trees = self._node_trees[viewport_name]

	for tree_id, tree in pairs(node_trees) do
		tree.root_node:set_aim_yaw(yaw)
		tree.root_node:set_aim_pitch(pitch)
		tree.root_node:set_aim_roll(roll)
	end
end

CameraManager.set_fov_multiplier = function (self, multiplier)
	self._fov_multiplier = multiplier
end

CameraManager.set_variable = function (self, viewport_name, field, value)
	self._variables[viewport_name][field] = value
end

CameraManager.set_mood_blend_list = function (self, mood_blend_list)
	self._mood_blend_list = mood_blend_list
end

CameraManager.variable = function (self, viewport_name, field)
	return self._variables[viewport_name][field]
end

CameraManager.post_update = function (self, dt, t, viewport_name)
	local node_trees = self._node_trees[viewport_name]
	local data = self._variables[viewport_name]

	for tree_id, tree in pairs(node_trees) do
		self:_update_nodes(dt, viewport_name, tree_id, data)
	end

	self:_update_camera(dt, t, viewport_name)
	self:_update_angular_velocity(dt, viewport_name)
	self:_update_sound_listener(viewport_name)
	self:_update_level_particle_effects(viewport_name)
end

CameraManager.force_update_nodes = function (self, dt, viewport_name)
	local node_trees = self._node_trees[viewport_name]
	local data = self._variables[viewport_name]

	for tree_id, tree in pairs(node_trees) do
		self:_update_nodes(dt, viewport_name, tree_id, data)
	end
end

CameraManager._smooth_camera_collision = function (self, camera_position, safe_position, smooth_radius, near_radius)
	local SWEEP_EPSILON = 0.01
	local MAX_ITERATIONS = 20
	local physics_world = self._physics_world
	local cast_from = safe_position
	local cast_to = camera_position
	local dir = Vector3.normalize(cast_to - cast_from)
	local len = Vector3.length(cast_to - cast_from)
	local cast_distance = len
	local cast_radius = smooth_radius

	if len < cast_radius then
		return cast_to
	end

	local drawer = nil

	if debug and Managers.state.debug then
		drawer = Managers.state.debug:drawer({
			name = "Intersection"
		})

		drawer:reset()
	end

	local _, num_hits = PhysicsWorld.immediate_overlap(physics_world, "shape", "sphere", "position", cast_from, "size", smooth_radius, "types", "statics", "collision_filter", "filter_camera_sweep")

	if num_hits > 0 then
		if debug then
			Application.warning("[CameraManager] Safe spot is intersecting with geometry")
		end

		return cast_from
	end

	local iterations = 0

	while true do
		if cast_distance < SWEEP_EPSILON then
			return cast_from
		end

		local hits = PhysicsWorld.linear_sphere_sweep(physics_world, cast_from, cast_to, cast_radius, 1, "types", "statics", "collision_filter", "filter_camera_sweep")
		local hit = nil

		if hits and #hits > 0 then
			if debug then
				local last_pos = cast_from

				for _, k in ipairs(hits) do
					drawer:vector(last_pos, k.position - last_pos, Color(0, 255, 0))
					drawer:sphere(k.position, 0.1, Color(0, 255, 0))

					last_pos = k.position
				end
			end

			hit = hits[1]
			local x = Vector3.dot(dir, hit.position - cast_from)
			local y = Vector3.length(hit.position - cast_from - x * dir)

			if y < SWEEP_EPSILON then
				local pos = hit.position

				return pos
			end

			local cd = nil

			if y < near_radius then
				cd = x - cast_radius
			else
				cd = x + (y - near_radius) / (smooth_radius - near_radius) * (len - x) - cast_radius
			end

			if cast_distance > cd then
				cast_distance = cd
				cast_to = cast_from + dir * cast_distance
			end

			if cast_radius - y < 0.05 then
				cast_radius = math.max(cast_radius - 0.05, near_radius)
			else
				cast_radius = math.max(y, near_radius)
			end
		else
			if debug then
				drawer:sphere(cast_to, 0.2, Color(0, 0, 255))
			end

			return cast_to
		end

		iterations = iterations + 1

		if MAX_ITERATIONS < iterations then
			return cast_to
		end
	end
end

CameraManager._update_nodes = function (self, dt, viewport_name, tree_id, data)
	local tree = self._node_trees[viewport_name][tree_id]

	tree.root_node:update(dt, data)
end

CameraManager._current_node = function (self, camera_nodes)
	return camera_nodes[#camera_nodes].node
end

CameraManager._current_transition = function (self, camera_nodes)
	return camera_nodes[#camera_nodes].transition
end

CameraManager.camera_effect_sequence_event = function (self, event, start_time)
	if not self._camera_shake_enabled then
		return
	end

	local sequence_event_settings = self._sequence_event_settings
	local previous_values = nil

	if sequence_event_settings.event then
		previous_values = sequence_event_settings.current_values
	end

	sequence_event_settings.start_time = start_time
	sequence_event_settings.event = CameraEffectSettings.sequence[event]
	sequence_event_settings.transition_function = CameraEffectSettings.transition_functions.lerp
	local duration = 0

	for modifier_type, modifiers in pairs(sequence_event_settings.event.values) do
		for index, settings in ipairs(modifiers) do
			if duration < settings.time_stamp then
				duration = settings.time_stamp
			end
		end
	end

	sequence_event_settings.end_time = start_time + duration

	if previous_values then
		local recuperate_percentage = sequence_event_settings.event.time_to_recuperate_to
		local time_to_recover = recuperate_percentage / 100 * duration
		sequence_event_settings.time_to_recover = time_to_recover
		sequence_event_settings.recovery_values = self:_calculate_sequence_event_values_normal(sequence_event_settings.event.values, time_to_recover)
		sequence_event_settings.previous_values = previous_values
	end
end

CameraManager.camera_effect_shake_event = function (self, event_name, source_unit_data)
	if not self._camera_shake_enabled then
		return
	end

	self._active_events[#self._active_events + 1] = CameraShakeEvent:new(event_name, source_unit_data)
end

CameraManager.set_offset = function (self, x, y, z)
	self._camera_offset = self._camera_offset and self._camera_offset:store(Vector3(x, y, z)) or Vector3Box(x, y, z)
end

CameraManager._apply_offset = function (self, current_data, t)
	local new_data = current_data
	local offset = self._camera_offset and self._camera_offset:unbox() or Vector3(0, 0, 0)
	local offset_x = offset.x
	local offset_y = offset.y
	local offset_z = offset.z
	local x = offset_x * Quaternion.right(current_data.rotation)
	local y = offset_y * Quaternion.forward(current_data.rotation)
	local z = Vector3(0, 0, offset_z)
	local new_pos = current_data.position + x + y + z
	new_data.position = new_pos

	return new_data
end

CameraManager._update_camera = function (self, dt, t, viewport_name)
	local viewport = ScriptWorld.viewport(self._world, viewport_name)
	local camera = ScriptViewport.camera(viewport)
	local shadow_cull_camera = ScriptViewport.shadow_cull_camera(viewport)
	local camera_nodes = self._camera_nodes[viewport_name]
	local camera_data = self:_update_transition(viewport_name, camera_nodes, dt)

	if self._sequence_event_settings.event then
		self:_apply_sequence_event(camera_data, t)
	end

	if #self._active_events > 0 then
		self:_update_active_events(dt, viewport_name, camera_data)
	end

	self:_apply_offset(camera_data, t)
	self:_update_camera_properties(camera, shadow_cull_camera, camera_nodes, camera_data, viewport_name)
	ScriptCamera.force_update(self._world, camera)
end

CameraManager._update_active_events = function (self, dt, viewport_name, camera_data)
	local camera_position = self:camera_position(viewport_name)

	for i = #self._active_events, 1, -1 do
		local script = self._active_events[i]

		if not script:done() then
			script:update(dt, camera_data, camera_position)
		else
			table.remove(self._active_events, i)
		end
	end
end

CameraManager._apply_sequence_event = function (self, camera_data, t)
	local sequence_event_settings = self._sequence_event_settings
	local new_values = nil
	local time_to_recover = sequence_event_settings.time_to_recover
	local start_time = sequence_event_settings.start_time

	if t < time_to_recover + start_time then
		new_values = self:_calculate_sequence_event_values_recovery(t)
	else
		local total_progress = t - sequence_event_settings.start_time
		local event_values = sequence_event_settings.event.values
		new_values = self:_calculate_sequence_event_values_normal(event_values, total_progress)
	end

	camera_data.position = self:_calculate_sequence_event_position(camera_data, new_values)
	sequence_event_settings.current_values = new_values

	if self._sequence_event_settings.end_time <= t then
		sequence_event_settings.start_time = 0
		sequence_event_settings.end_time = 0
		sequence_event_settings.event = nil
		sequence_event_settings.current_values = nil
		sequence_event_settings.time_to_recover = 0
		sequence_event_settings.recovery_values = nil
		sequence_event_settings.transition_function = nil
	end
end

CameraManager._calculate_sequence_event_values_recovery = function (self, t)
	local new_values = {
		yaw = 0,
		z = 0,
		roll = 0,
		y = 0,
		pitch = 0,
		x = 0
	}
	local sequence_event_settings = self._sequence_event_settings
	local time_to_recover = sequence_event_settings.time_to_recover

	if time_to_recover <= 0 then
		table.dump(sequence_event_settings)
	end

	local starting_values = sequence_event_settings.previous_values
	local recovery_values = sequence_event_settings.recovery_values
	local start_time = sequence_event_settings.start_time
	local progress = (t - start_time) / time_to_recover

	for modifier, value in pairs(starting_values) do
		new_values[modifier] = math.lerp(value, recovery_values[modifier], progress)
	end

	return new_values
end

CameraManager._calculate_sequence_event_values_normal = function (self, event_values, total_progress)
	local new_values = {
		yaw = 0,
		z = 0,
		roll = 0,
		y = 0,
		pitch = 0,
		x = 0
	}

	for modifier_type, modifiers in pairs(event_values) do
		for index, settings in ipairs(modifiers) do
			if total_progress < settings.time_stamp then
				local next_settings = settings
				local current_settings = modifiers[index - 1] or CameraEffectSettings.empty_modifier_settings
				local progress = total_progress - current_settings.time_stamp
				local time_stamp_difference = next_settings.time_stamp - current_settings.time_stamp

				if time_stamp_difference == 0 then
					table.dump(current_settings, "current settings")
					table.dump(next_settings, "next_settings")
				end

				local lerp_progress = progress / time_stamp_difference
				new_values[modifier_type] = self._sequence_event_settings.transition_function(current_settings.value, next_settings.value, lerp_progress)

				break
			end
		end
	end

	return new_values
end

CameraManager._calculate_sequence_event_position = function (self, camera_data, new_values)
	local current_pos = camera_data.position
	local current_rot = camera_data.rotation
	local x = new_values.x * Quaternion.right(current_rot)
	local y = new_values.y * Quaternion.forward(current_rot)
	local z = Vector3(0, 0, new_values.z)

	return current_pos + x + y + z
end

CameraManager._calculate_sequence_event_rotation = function (self, camera_data, new_values)
	local current_rot = camera_data.rotation
	local deg_to_rad = math.pi / 180
	local yaw_offset = new_values.yaw * deg_to_rad
	local pitch_offset = new_values.pitch * deg_to_rad
	local roll_offset = new_values.roll * deg_to_rad
	local total_offset = Quaternion.from_yaw_pitch_roll(yaw_offset, pitch_offset, roll_offset)

	return Quaternion.multiply(current_rot, total_offset)
end

CameraManager.apply_level_particle_effects = function (self, effects, viewport_name)
	for _, effect in ipairs(effects) do
		local world = self._world
		local effect_id = World.create_particles(world, effect, self:position(viewport_name))
		self._level_particle_effect_ids[effect_id] = true
	end
end

CameraManager.apply_level_screen_effects = function (self, effects, viewport_name)
	for _, effect in ipairs(effects) do
		local world = self._world
		local effect_id = World.create_particles(world, effect, Vector3(0, 0, 0))
		self._level_screen_effect_ids[effect_id] = true
	end
end

CameraManager._update_camera_properties = function (self, camera, shadow_cull_camera, camera_nodes, camera_data, viewport_name)
	local current_node = self:_current_node(camera_nodes)
	local current_transition = self:_current_transition(camera_nodes)
	camera_data.root_unit = current_node:root_unit()

	if camera_data.position then
		local root_unit, root_object = current_node:root_unit()
		local pos = camera_data.position
		local use_collision = false
		local safe_pos_offset = nil

		if current_node:use_collision() then
			use_collision = true
			safe_pos_offset = current_node:safe_position_offset():unbox()
		elseif current_transition and current_transition.position and current_transition.position:use_collision() then
			use_collision = current_transition.position:use_collision()
			safe_pos_offset = current_transition.position:safe_position_offset():unbox()
		end

		if use_collision then
			local safe_pos = nil
			safe_pos = root_unit and ALIVE[root_unit] and Unit.world_position(root_unit, root_object or 1) + safe_pos_offset or camera_data.position + safe_pos_offset
			pos = self:_smooth_camera_collision(camera_data.position, safe_pos, 0.35, 0.25)
		end

		camera_data.boxed_position = Vector3Box(camera_data.position)

		ScriptCamera.set_local_position(camera, pos)
		Unit.set_local_position(self._rtxgi_volume, 1, pos)
		ScatterSystem.move_observer(self._scatter_system, self._scatter_system_observers[viewport_name], pos, camera_data.rotation)

		local physics_world = self._physics_world

		if physics_world and PhysicsWorld.set_observer then
			PhysicsWorld.set_observer(physics_world, Matrix4x4.from_quaternion_position(camera_data.rotation, pos))
		end
	end

	if camera_data.rotation then
		ScriptCamera.set_local_rotation(camera, camera_data.rotation)
	end

	if camera_data.vertical_fov then
		local vertical_fov = camera_data.vertical_fov

		if current_node:should_apply_fov_multiplier() then
			Camera.set_vertical_fov(camera, vertical_fov * self._fov_multiplier)
			Camera.set_vertical_fov(shadow_cull_camera, current_node:default_fov())
		else
			Camera.set_vertical_fov(camera, vertical_fov)
			Camera.set_vertical_fov(shadow_cull_camera, current_node:default_fov())
		end
	end

	if camera_data.custom_vertical_fov then
		local custom_vertical_fov = camera_data.custom_vertical_fov

		Camera.set_custom_vertical_fov(camera, custom_vertical_fov)
	end

	if camera_data.near_range then
		Camera.set_near_range(camera, camera_data.near_range)
		Camera.set_near_range(shadow_cull_camera, camera_data.near_range)
	end

	if camera_data.far_range then
		local far_range = Camera.get_data(camera, "far_range") or camera_data.far_range

		Camera.set_far_range(camera, far_range)
		Camera.set_far_range(shadow_cull_camera, far_range)
	end

	if camera_data.fade_to_black then
		self._variables[viewport_name].fade_to_black = camera_data.fade_to_black
	end

	local viewport = ScriptWorld.viewport(self._world, viewport_name)
	self._viewport_camera_data[viewport] = camera_data
end

CameraManager._update_angular_velocity = function (self, dt, viewport_name)
	local camera_rot = self:camera_rotation(viewport_name)
	local last_rot = self._last_rotation:unbox()

	if Quaternion.is_valid(camera_rot) and Quaternion.is_valid(last_rot) then
		local rotation_delta = Quaternion.multiply(Quaternion.inverse(camera_rot), last_rot)
		local angular_velocity_vector, angular_delta = Quaternion.decompose(rotation_delta)
		self._angular_velocity = Vector3Box(angular_velocity_vector * angular_delta / dt)
	end

	QuaternionBox.store(self._last_rotation, camera_rot)
end

CameraManager._update_sound_listener = function (self, viewport_name)
	local world = self._world
	local pose = self:listener_pose(viewport_name)
	local wwise_world = Managers.world:wwise_world(world)

	WwiseWorld.set_listener(wwise_world, 0, pose)

	local position = Matrix4x4.translation(pose)
	local scale = self._listener_elevation_scale
	local offset = self._listener_elevation_offset
	local min = self._listener_elevation_min
	local max = self._listener_elevation_max
	local elevation = math.clamp((position.z - offset) * scale, min, max)

	WwiseWorld.set_global_parameter(wwise_world, "lua_elevation", elevation)
end

CameraManager.listener_pose = function (self, viewport_name)
	local world = self._world
	local viewport = ScriptWorld.global_free_flight_viewport(world) or ScriptWorld.viewport(world, viewport_name, true)
	local camera = ScriptViewport.camera(viewport)
	local pose = Camera.world_pose(camera)

	return pose
end

CameraManager._add_transition = function (self, viewport_name, from_node, to_node, transition_template)
	local transition = {}

	for _, property in ipairs(self.NODE_PROPERTY_MAP) do
		local settings = transition_template[property]

		if settings then
			local duration = settings.duration
			local speed = settings.speed
			local transition_class = CLASSES[settings.class]
			local instance = transition_class:new(from_node.node, to_node.node, duration, speed, settings)
			transition[property] = instance
		end
	end

	to_node.transition = transition
end

CameraManager._update_transition = function (self, viewport_name, nodes, dt)
	local values = self._property_temp_table

	table.clear(values)

	local value = nil
	local node_property_map = self.NODE_PROPERTY_MAP

	for _prop_index, property in ipairs(node_property_map) do
		for _node_index, node_table in ipairs(nodes) do
			local transition = node_table.transition
			local transition_class = transition[property]

			if transition_class then
				local done = nil
				local update_time = _node_index == #nodes
				value, done = transition_class:update(dt, value, update_time)

				if done then
					transition_class:on_complete()

					transition[property] = nil
				end
			else
				value = node_table.node[property](node_table.node)
			end
		end

		values[property] = value
		value = nil
	end

	local remove_from_index = nil

	for index, node_table in ipairs(nodes) do
		if not next(node_table.transition) then
			remove_from_index = index - 1
		end
	end

	if remove_from_index and remove_from_index > 0 then
		self:_remove_camera_node(nodes, remove_from_index)
	end

	return values
end

return CameraManager
