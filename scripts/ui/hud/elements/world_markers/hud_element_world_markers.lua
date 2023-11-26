-- chunkname: @scripts/ui/hud/elements/world_markers/hud_element_world_markers.lua

local Definitions = require("scripts/ui/hud/elements/world_markers/hud_element_world_markers_definitions")
local HudElementWorldMarkersSettings = require("scripts/ui/hud/elements/world_markers/hud_element_world_markers_settings")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UIWidget = require("scripts/managers/ui/ui_widget")
local DEBUG_MARKER = "objective"
local temp_array_markers_to_remove = {}
local temp_marker_raycast_queue = {}

local function raycast_sort_func(a, b)
	local a_frame_count = a.raycast_frame_count or 0
	local b_frame_count = b.raycast_frame_count or 0

	if a_frame_count == b_frame_count then
		local a_distance = a.widget.content.distance or 0
		local b_distance = b.widget.content.distance or 0

		return a_distance < b_distance
	end

	return b_frame_count < a_frame_count
end

local HudElementWorldMarkers = class("HudElementWorldMarkers", "HudElementBase")

HudElementWorldMarkers.init = function (self, parent, draw_layer, start_scale)
	HudElementWorldMarkers.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._id_counter = 0
	self._markers = {}
	self._markers_by_id = {}
	self._markers_by_type = {}
	self._raycast_frame_counter = 0
	self._marker_templates = {}

	local marker_templates = HudElementWorldMarkersSettings.marker_templates

	for i = 1, #marker_templates do
		local template_path = marker_templates[i]
		local template = require(template_path)
		local name = template.name

		self._marker_templates[name] = template
	end

	local event_manager = Managers.event

	event_manager:register(self, "add_world_marker_unit", "event_add_world_marker_unit")
	event_manager:register(self, "add_world_marker_position", "event_add_world_marker_position")
	event_manager:register(self, "remove_world_marker", "event_remove_world_marker")
	event_manager:register(self, "request_world_markers_list", "event_request_world_markers_list")

	self._safe_raycast_cb = callback(self, "_async_raycast_result_cb")
	self._raycast_object = Managers.state.game_mode:create_safe_raycast_object("closest", "types", "both", "collision_filter", "filter_interactable_line_of_sight_marker_check")
end

HudElementWorldMarkers.destroy = function (self, ui_renderer)
	HudElementWorldMarkers.super.destroy(self, ui_renderer)

	local event_manager = Managers.event

	event_manager:unregister(self, "add_world_marker_unit")
	event_manager:unregister(self, "add_world_marker_position")
	event_manager:unregister(self, "remove_world_marker")
	event_manager:unregister(self, "request_world_markers_list")
end

HudElementWorldMarkers._template_by_type = function (self, marker_type, clone)
	return clone and table.clone(self._marker_templates[marker_type]) or self._marker_templates[marker_type]
end

HudElementWorldMarkers.event_request_world_markers_list = function (self, response_callback)
	if response_callback then
		response_callback(self._markers)
	end
end

HudElementWorldMarkers.event_remove_world_marker = function (self, id)
	local marker_to_remove
	local markers = self._markers

	for i = 1, #markers do
		local marker = markers[i]

		if marker.id == id then
			marker_to_remove = marker

			break
		end
	end

	if marker_to_remove then
		self:_unregister_marker(marker_to_remove)
	end
end

HudElementWorldMarkers.event_add_world_marker_unit = function (self, marker_type, unit, callback, data)
	local marker = {
		scale = 1,
		type = marker_type,
		unit = unit,
		position = Vector3Box()
	}
	local id = self:_register_marker(marker)
	local widget_name = "marker_widget_id_" .. id
	local template = self:_template_by_type(marker_type)
	local widget = self:_create_widget_by_type(widget_name, template)

	marker.widget = widget
	marker.data = data
	marker.template = template

	local on_enter = template.on_enter

	if on_enter then
		on_enter(widget, marker, template)
	end

	if callback then
		callback(id)
	end
end

HudElementWorldMarkers.event_add_world_marker_position = function (self, marker_type, world_position, callback, data)
	local marker = {
		scale = 1,
		type = marker_type,
		world_position = Vector3Box(world_position),
		position = Vector3Box()
	}
	local id = self:_register_marker(marker)
	local widget_name = "marker_widget_id_" .. id
	local template = self:_template_by_type(marker_type)
	local widget = self:_create_widget_by_type(widget_name, template)

	marker.widget = widget
	marker.data = data or {}
	marker.template = template

	local on_enter = template.on_enter

	if on_enter then
		on_enter(widget, marker, template)
	end

	if callback then
		callback(id)
	end
end

HudElementWorldMarkers._register_marker = function (self, marker)
	local markers = self._markers
	local markers_by_id = self._markers_by_id
	local markers_by_type = self._markers_by_type

	self._id_counter = self._id_counter + 1

	local id = self._id_counter

	marker.id = id
	markers_by_id[id] = marker
	markers[#markers + 1] = marker

	local marker_type = marker.type
	local type_markers = markers_by_type[marker_type] or {}

	markers_by_type[marker_type] = type_markers
	type_markers[#type_markers + 1] = marker

	return id
end

HudElementWorldMarkers._unregister_marker = function (self, marker)
	local markers = self._markers
	local markers_by_id = self._markers_by_id
	local markers_by_type = self._markers_by_type
	local id = marker.id

	markers_by_id[id] = nil

	for i = 1, #markers do
		if markers[i].id == id then
			markers[i].deleted = true

			table.remove(markers, i)

			break
		end
	end

	local marker_type = marker.type
	local type_markers = markers_by_type[marker_type]

	for i = 1, #type_markers do
		if type_markers[i].id == id then
			table.remove(type_markers, i)

			break
		end
	end
end

HudElementWorldMarkers._create_widget_by_type = function (self, name, template)
	local scenegraph_id = "pivot"
	local definition = template.create_widget_defintion(template, scenegraph_id)

	return self:_create_widget(name, definition)
end

HudElementWorldMarkers.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementWorldMarkers.super.update(self, dt, t, ui_renderer, render_settings, input_service)
	self:_calculate_markers(dt, t, input_service, ui_renderer, render_settings)
end

HudElementWorldMarkers._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	HudElementWorldMarkers.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
	self:_draw_markers(dt, t, input_service, ui_renderer, render_settings)
end

HudElementWorldMarkers._calculate_markers = function (self, dt, t, input_service, ui_renderer, render_settings)
	local raycasts_allowed = self._raycast_frame_counter == 0

	self._raycast_frame_counter = (self._raycast_frame_counter + 1) % HudElementWorldMarkersSettings.raycasts_frame_delay

	local camera = self._camera

	if camera then
		local scale = ui_renderer.scale
		local inverse_scale = ui_renderer.inverse_scale
		local camera_position = Camera.local_position(camera)
		local camera_rotation = Camera.local_rotation(camera)
		local camera_forward = Quaternion.forward(camera_rotation)
		local camera_direction = Quaternion.forward(camera_rotation)
		local camera_position_center = camera_position + camera_forward
		local camera_pose = Camera.local_pose(camera)
		local camera_position_right = Matrix4x4.right(camera_pose)
		local camera_position_left = -camera_position_right
		local camera_position_up = Matrix4x4.up(camera_pose)
		local camera_position_down = -camera_position_up
		local root_size = UIScenegraph.size_scaled(self._ui_scenegraph, "screen")
		local markers_by_id = self._markers_by_id
		local markers_by_type = self._markers_by_type
		local ALIVE = ALIVE

		for marker_type, markers in pairs(markers_by_type) do
			for i = 1, #markers do
				local marker = markers[i]
				local id = marker.id
				local template = marker.template
				local update = markers_by_id[id] ~= nil
				local remove = marker.remove
				local widget = marker.widget
				local content = widget.content
				local screen_clamp = template.screen_clamp and not marker.block_screen_clamp
				local screen_margins = template.screen_margins
				local max_distance = template.max_distance

				if marker.block_max_distance then
					max_distance = math.huge
				end

				local life_time = template.life_time
				local check_line_of_sight = template.check_line_of_sight
				local marker_position

				if update then
					local world_position = marker.world_position

					if world_position then
						marker_position = world_position:unbox()
					else
						local unit = marker.unit

						if ALIVE[unit] then
							local unit_node = template.unit_node
							local node = unit_node and Unit.has_node(unit, unit_node) and Unit.node(unit, unit_node) or 1

							marker_position = Unit.world_position(unit, node)
						else
							remove = true
						end
					end

					if life_time then
						local duration = marker.duration or 0

						duration = math.min(duration + dt, life_time)

						if life_time <= duration then
							remove = true
						else
							marker.duration = duration
						end
					end
				end

				if remove then
					update = false
					temp_array_markers_to_remove[#temp_array_markers_to_remove + 1] = marker
				end

				if update then
					local position_offset = template.position_offset

					if position_offset then
						marker_position.x = marker_position.x + position_offset[1]
						marker_position.y = marker_position.y + position_offset[2]
						marker_position.z = marker_position.z + position_offset[3]
					end

					Vector3Box.store(marker.position, marker_position)

					local distance = Vector3.distance(marker_position, camera_position)

					content.distance = distance
					marker.distance = distance

					local out_of_reach = max_distance and max_distance < distance
					local draw = not out_of_reach

					if not out_of_reach then
						local marker_direction = Vector3.normalize(marker_position - camera_position)

						marker_direction = Vector3.normalize(marker_direction)

						local forward_dot_dir = Vector3.dot(camera_direction, marker_direction)
						local is_inside_frustum = Camera.inside_frustum(camera, marker_position) > 0
						local camera_left = Vector3.cross(camera_direction, Vector3.up())
						local left_dot_dir = Vector3.dot(camera_left, marker_direction)
						local angle = math.atan2(left_dot_dir, forward_dot_dir)
						local is_behind = forward_dot_dir < 0 and true or false
						local is_under = marker_position.z < camera_position.z
						local x, y, _ = self:_convert_world_to_screen_position(camera, marker_position)
						local pixel_offset = template.pixel_offset

						if pixel_offset then
							x = x + pixel_offset[1]
							y = y + pixel_offset[2]
						end

						local screen_x, screen_y = self:_get_screen_offset(scale)

						x = x - screen_x
						y = y - screen_y

						local is_clamped, is_clamped_left, is_clamped_right, is_clamped_up, is_clamped_down = false, false, false, false, false

						if screen_clamp then
							local clamped_x, clamped_y

							clamped_x, clamped_y, is_clamped_left, is_clamped_right, is_clamped_up, is_clamped_down = self:_clamp_to_screen(x, y, screen_margins, is_behind, is_under, marker_position, camera_position_center, camera_position_left, camera_position_right, camera_position_up, camera_position_down)
							is_clamped = is_clamped_left or is_clamped_right or is_clamped_up or is_clamped_down
							x = clamped_x
							y = clamped_y
						end

						if not is_clamped then
							if is_behind then
								draw = false
							elseif not is_inside_frustum then
								local vertical_pixel_overlap, horizontal_pixel_overlap

								if x < 0 then
									horizontal_pixel_overlap = math.abs(x)
								elseif x > root_size[1] then
									horizontal_pixel_overlap = x - root_size[1]
								end

								if y < 0 then
									vertical_pixel_overlap = math.abs(y)
								elseif y > root_size[2] then
									vertical_pixel_overlap = y - root_size[2]
								end

								if vertical_pixel_overlap or horizontal_pixel_overlap then
									draw = false

									local check_widget_visible = template.check_widget_visible

									if check_widget_visible then
										draw = check_widget_visible(widget, vertical_pixel_overlap, horizontal_pixel_overlap)
									end
								else
									draw = false
								end
							end
						elseif is_clamped_left or is_clamped_right then
							if is_clamped_left then
								angle = 0
							elseif is_clamped_right then
								angle = math.pi
							end
						elseif is_clamped_up then
							angle = math.pi * 0.5
						elseif is_clamped_down then
							angle = -math.pi * 0.5
						end

						content.is_inside_frustum = is_inside_frustum
						content.is_clamped = is_clamped
						content.is_under = is_under
						content.distance = distance
						content.angle = angle
						marker.is_inside_frustum = is_inside_frustum
						marker.is_clamped = is_clamped
						marker.is_under = is_under
						marker.distance = distance
						marker.angle = angle

						local offset = widget.offset

						offset[1] = x * inverse_scale
						offset[2] = y * inverse_scale

						if draw and check_line_of_sight then
							marker.raycast_frame_count = (marker.raycast_frame_count or 0) + 1

							if raycasts_allowed then
								temp_marker_raycast_queue[#temp_marker_raycast_queue + 1] = marker
							end
						end
					end

					marker.draw = draw
				end

				marker.update = update
			end
		end

		if raycasts_allowed then
			self:_raycast_markers(temp_marker_raycast_queue)
		end

		for marker_type, markers in pairs(markers_by_type) do
			for i = 1, #markers do
				local marker = markers[i]

				if marker.update then
					local template = marker.template
					local update_function = template.update_function

					if update_function then
						update_function(self, ui_renderer, marker.widget, marker, template, dt, t)
					end
				end
			end
		end
	else
		self._camera = self._parent:player_camera()
	end

	local markers_to_remove = #temp_array_markers_to_remove

	if markers_to_remove > 0 then
		for i = 1, markers_to_remove do
			local marker = temp_array_markers_to_remove[i]

			self:_unregister_marker(marker)
		end

		table.clear(temp_array_markers_to_remove)
	end
end

HudElementWorldMarkers._draw_markers = function (self, dt, t, input_service, ui_renderer, render_settings)
	local camera = self._camera

	if camera then
		local markers_by_type = self._markers_by_type

		for marker_type, markers in pairs(markers_by_type) do
			for i = 1, #markers do
				local marker = markers[i]
				local draw = marker.draw

				if draw then
					local widget = marker.widget
					local content = widget.content
					local distance = content.distance
					local template = marker.template
					local scale_settings = template.scale_settings
					local fade_settings = template.fade_settings

					if scale_settings then
						marker.scale = self:_get_scale(scale_settings, distance)

						local new_scale = marker.ignore_scale and 1 or marker.scale

						self:_apply_scale(widget, new_scale)
					end

					local alpha_multiplier = 1

					if fade_settings and not marker.block_fade_settings then
						alpha_multiplier = self:_get_fade(fade_settings, distance)
					end

					if draw then
						local previous_alpha_multiplier = widget.alpha_multiplier

						widget.alpha_multiplier = (previous_alpha_multiplier or 1) * alpha_multiplier

						UIWidget.draw(widget, ui_renderer)

						widget.alpha_multiplier = previous_alpha_multiplier
					end
				end
			end
		end
	end
end

HudElementWorldMarkers._get_fade = function (self, fade_settings, distance)
	local easing_function = fade_settings.easing_function
	local return_value

	if distance > fade_settings.distance_max then
		return_value = fade_settings.fade_from
	elseif distance < fade_settings.distance_min then
		return_value = fade_settings.fade_to
	else
		local distance_fade_fraction = 1 - (distance - fade_settings.distance_min) / (fade_settings.distance_max - fade_settings.distance_min)
		local eased_distance_fade_fraction = easing_function(distance_fade_fraction)
		local adjusted_fade = fade_settings.fade_from + eased_distance_fade_fraction * (fade_settings.fade_to - fade_settings.fade_from)

		return_value = adjusted_fade
	end

	if fade_settings.invert then
		return 1 - return_value
	else
		return return_value
	end
end

HudElementWorldMarkers._get_scale = function (self, scale_settings, distance)
	local easing_function = scale_settings.easing_function

	if distance > scale_settings.distance_max then
		return scale_settings.scale_from
	elseif distance < scale_settings.distance_min then
		return scale_settings.scale_to
	else
		local distance_fade_fraction = 1 - (distance - scale_settings.distance_min) / (scale_settings.distance_max - scale_settings.distance_min)
		local eased_distance_scale_fraction = easing_function and easing_function(distance_fade_fraction) or distance_fade_fraction
		local adjusted_fade = scale_settings.scale_from + eased_distance_scale_fraction * (scale_settings.scale_to - scale_settings.scale_from)

		return adjusted_fade
	end
end

HudElementWorldMarkers._apply_scale = function (self, widget, scale)
	local style = widget.style
	local lerp_multiplier = 0.2

	for _, pass_style in pairs(style) do
		local default_size = pass_style.default_size

		if default_size then
			local current_size = pass_style.area_size or pass_style.texture_size or pass_style.size

			current_size[1] = math.lerp(current_size[1], default_size[1] * scale, lerp_multiplier)
			current_size[2] = math.lerp(current_size[2], default_size[2] * scale, lerp_multiplier)
		end

		local default_offset = pass_style.default_offset

		if default_offset then
			local offset = pass_style.offset

			offset[1] = math.lerp(offset[1], default_offset[1] * scale, lerp_multiplier)
			offset[2] = math.lerp(offset[2], default_offset[2] * scale, lerp_multiplier)
		end

		local default_pivot = pass_style.default_pivot

		if default_pivot then
			local pivot = pass_style.pivot

			pivot[1] = math.lerp(pivot[1], default_pivot[1] * scale, lerp_multiplier)
			pivot[2] = math.lerp(pivot[2], default_pivot[2] * scale, lerp_multiplier)
		end
	end
end

HudElementWorldMarkers._get_screen_offset = function (self, scale)
	local position = UIScenegraph.world_position(self._ui_scenegraph, "screen", scale)

	return Vector3.to_elements(position)
end

HudElementWorldMarkers._convert_world_to_screen_position = function (self, camera, world_position)
	if camera then
		local world_to_screen, distance = Camera.world_to_screen(camera, world_position)

		return world_to_screen.x, world_to_screen.y, distance
	end
end

HudElementWorldMarkers._clamp_to_screen = function (self, x, y, screen_margins, is_behind, is_under, world_position, camera_position_center, camera_position_left, camera_position_right, camera_position_up, camera_position_down)
	local root_size = UIScenegraph.size_scaled(self._ui_scenegraph, "screen")
	local default_scale = RESOLUTION_LOOKUP.scale
	local is_clamped_left, is_clamped_right, is_clamped_up, is_clamped_down = false, false, false, false
	local root_width = root_size[1] * default_scale
	local root_height = root_size[2] * default_scale
	local margin_up = screen_margins and screen_margins.up or 0
	local margin_down = screen_margins and screen_margins.down or 0
	local margin_left = screen_margins and screen_margins.left or 0
	local margin_right = screen_margins and screen_margins.right or 0
	local clamped_x = math.max(margin_left, math.min(x, root_width - margin_right))
	local clamped_y = math.max(margin_down, math.min(y, root_height - margin_up))
	local is_clamped = clamped_x ~= x or clamped_y ~= y or is_behind

	if is_behind then
		local camera_distance_left = Vector3.distance(Vector3.flat(world_position), Vector3.flat(camera_position_center + camera_position_left))
		local camera_distance_right = Vector3.distance(Vector3.flat(world_position), Vector3.flat(camera_position_center + camera_position_right))
		local camera_distances_difference_horizontal = camera_distance_left - camera_distance_right

		if camera_distances_difference_horizontal > 0 then
			clamped_x = root_width - margin_right
			is_clamped_left = true
		else
			clamped_x = margin_left
			is_clamped_right = true
		end

		if is_under then
			clamped_y = clamped_y * -1
			is_clamped_up = true
		end

		if margin_left <= clamped_x or clamped_x <= root_height - margin_right then
			if clamped_y > root_height / 2 or not is_under then
				clamped_y = margin_down
				is_clamped_down = true
			else
				clamped_y = root_height - margin_up
				is_clamped_up = true
			end
		end
	elseif is_clamped then
		if clamped_x < x then
			is_clamped_left = true
		elseif x < clamped_x then
			is_clamped_right = true
		end

		if clamped_y < y then
			is_clamped_down = true
		elseif y < clamped_y then
			is_clamped_up = true
		end
	end

	return clamped_x, clamped_y, is_clamped_left, is_clamped_right, is_clamped_up, is_clamped_down
end

HudElementWorldMarkers._physics_world = function (self)
	local world_manager = Managers.world
	local world_name = "level_world"

	if world_manager:has_world(world_name) then
		local world = world_manager:world(world_name)
		local physics_world = World.physics_world(world)

		return physics_world
	end
end

HudElementWorldMarkers.physics_cb_line_of_sight_hit = function (self, marker, id, hit, hit_position)
	marker.raycast_result = hit
	marker.raycast_frame_count = 0
end

HudElementWorldMarkers._raycast_markers = function (self, marker_raycast_queue)
	local physics_world = self:_physics_world()

	if not physics_world then
		return
	end

	local num_raycast_queue = #marker_raycast_queue

	if num_raycast_queue <= 0 then
		return
	end

	if num_raycast_queue > 1 then
		table.sort(marker_raycast_queue, raycast_sort_func)
	end

	local raycast_object = self._raycast_object
	local camera_position = Camera.local_position(self._camera)
	local raycasts_per_frame = HudElementWorldMarkersSettings.raycasts_per_frame
	local num_raycast_to_check = math.min(num_raycast_queue, raycasts_per_frame)

	for i = 1, num_raycast_to_check do
		local marker = marker_raycast_queue[i]
		local widget = marker.widget
		local content = widget.content
		local marker_position = Vector3Box.unbox(marker.position)
		local ray_dir = Vector3.normalize(marker_position - camera_position)
		local ray_length = content.distance

		Managers.state.game_mode:add_safe_raycast(raycast_object, camera_position, ray_dir, ray_length, self._safe_raycast_cb, marker)

		if not marker.raycast_initialized then
			marker.raycast_initialized = true
		end
	end

	table.clear(marker_raycast_queue)
end

HudElementWorldMarkers._async_raycast_result_cb = function (self, id, hit, hit_position, data)
	if self.destroyed then
		return
	end

	local marker = data[1]

	marker.raycast_result = hit
	marker.raycast_frame_count = 0
end

return HudElementWorldMarkers
