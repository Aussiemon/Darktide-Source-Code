local UIScenegraph = {}

UIScenegraph.init_scenegraph_cached = function (scenegraph)
	local hierarchical_scenegraph = scenegraph.hierarchical_scenegraph

	for i = 1, scenegraph.n_hierarchical_scenegraph do
		local scenegraph_object = hierarchical_scenegraph[i]

		EngineOptimized.scenegraph_cached_deinit(scenegraph_object.scene_graph_ref)

		scenegraph_object.scene_graph_ref = nil
		local children = scenegraph_object.children

		if children then
			local scene_graph_ref = EngineOptimized.scenegraph_cached_init(scenegraph_object.children)
			scenegraph_object.scene_graph_ref = scene_graph_ref
		end
	end
end

UIScenegraph.init_scenegraph = function (scenegraph, scale)
	scenegraph = table.clone(scenegraph)
	local hierarchical_scenegraph = {}
	local n_hierarchical_scenegraph = 0
	local is_static = false
	local num_scenegraph_objects = 0

	for name, scene_object_data in pairs(scenegraph) do
		is_static = is_static or scene_object_data.is_static or false
		scene_object_data.name = name
		num_scenegraph_objects = num_scenegraph_objects + 1

		if not scene_object_data.parent then
			n_hierarchical_scenegraph = n_hierarchical_scenegraph + 1
			hierarchical_scenegraph[n_hierarchical_scenegraph] = scene_object_data
			local position = scene_object_data.position or {
				0,
				0,
				0
			}
			scene_object_data.local_position = position
			scene_object_data.world_position = table.clone(position)
		end
	end

	local num_iterated_objects = n_hierarchical_scenegraph

	while num_iterated_objects < num_scenegraph_objects do
		for name, scene_object_data in pairs(scenegraph) do
			local parent = scene_object_data.parent

			if parent and not scene_object_data.world_position then
				fassert(scenegraph[parent], "No such parent %s in scene graph for object %s", parent, name)
				fassert(parent ~= name, "Object %q can't have itself as parent", name)

				local parent_data = scenegraph[parent]

				if parent_data.world_position then
					num_iterated_objects = num_iterated_objects + 1
					local position = scene_object_data.position or {
						0,
						0,
						0
					}
					scene_object_data.local_position = position

					fassert(parent_data.world_position, "[UIScenegraph] - No world position for parent: %s", parent)
					fassert(parent_data.world_position[3], "[UIScenegraph] - No layer for parent: %s", parent)

					local parent_world_position = Vector3.from_array(parent_data.world_position)
					local local_position = Vector3.from_array(position)
					scene_object_data.world_position = Vector3.to_array(local_position + parent_world_position, {})
					scene_object_data.size = scene_object_data.size or table.clone(parent_data.size)

					if (scene_object_data.size[1] or 0) < 0 then
						scene_object_data.size[1] = scene_object_data.size[1] + parent_data.size[1]
					else
						scene_object_data.size[1] = scene_object_data.size[1] or 0
					end

					if (scene_object_data.size[2] or 0) < 0 then
						scene_object_data.size[2] = scene_object_data.size[2] + parent_data.size[2]
					else
						scene_object_data.size[2] = scene_object_data.size[2] or 0
					end

					local children = parent_data.children or {}
					local num_children = parent_data.num_children or 0
					children[num_children + 1] = scene_object_data
					parent_data.children = children
					parent_data.num_children = num_children + 1
				end
			end
		end
	end

	scenegraph.n_hierarchical_scenegraph = n_hierarchical_scenegraph
	scenegraph.hierarchical_scenegraph = hierarchical_scenegraph
	scenegraph.is_static = is_static

	if scenegraph.is_static then
		local w = RESOLUTION_LOOKUP.width
		local h = RESOLUTION_LOOKUP.height
		scenegraph.w = w
		scenegraph.h = h
		scenegraph.dirty = false

		UIScenegraph.init_scenegraph_cached(scenegraph)
	end

	local strict_scenegraph_table = table.make_strict_nil_exceptions(scenegraph)

	UIScenegraph.update_scenegraph(strict_scenegraph_table, scale)

	return strict_scenegraph_table
end

local function _safe_rect()
	local safe_rect_default_value = 0

	return safe_rect_default_value * 0.01
end

local function _handle_alignment(position, data, width, height, parent_size_x, parent_size_y)
	local horizontal_alignment = data.horizontal_alignment

	if horizontal_alignment then
		if horizontal_alignment == "center" then
			Vector3.set_x(position, Vector3.x(position) + parent_size_x / 2 - width / 2)
		elseif horizontal_alignment == "right" then
			Vector3.set_x(position, Vector3.x(position) + parent_size_x - width)
		end
	end

	local vertical_alignment = data.vertical_alignment

	if vertical_alignment then
		if vertical_alignment == "center" then
			Vector3.set_y(position, Vector3.y(position) + parent_size_y / 2 - height / 2)
		elseif vertical_alignment == "bottom" then
			Vector3.set_y(position, Vector3.y(position) + parent_size_y - height)
		end
	end
end

local Vector3_from_array = Vector3.from_array
local Vector3_x = Vector3.x
local Vector3_y = Vector3.y
local Vector3_set_x = Vector3.set_x
local Vector3_set_y = Vector3.set_y
local scenegraph_cached_update_children = EngineOptimized.scenegraph_cached_update_children
local scenegraph_update_children = EngineOptimized.scenegraph_update_children

UIScenegraph.update_scenegraph = function (scenegraph, scale)
	Profiler.start("UIScenegraph.update_scenegraph")

	local default_scale = RESOLUTION_LOOKUP.scale
	local default_inverse_scale = 1 / default_scale
	scale = scale or default_scale
	local inverse_scale = 1 / scale
	local w = RESOLUTION_LOOKUP.width
	local h = RESOLUTION_LOOKUP.height
	local safe_rect = _safe_rect()
	local safe_rect_scale = 1 - safe_rect
	local safe_rect_offset_x = w * inverse_scale * safe_rect * 0.5
	local safe_rect_offset_y = h * inverse_scale * safe_rect * 0.5
	w = w * safe_rect_scale
	h = h * safe_rect_scale

	if scenegraph.is_static and (scenegraph.w ~= w or scenegraph.h ~= h or scenegraph.dirty) then
		scenegraph.w = w
		scenegraph.h = h
		scenegraph.dirty = false

		UIScenegraph.init_scenegraph_cached(scenegraph)
	end

	local hierarchical_scenegraph = scenegraph.hierarchical_scenegraph
	local w_inverse_scale = w * inverse_scale
	local h_inverse_scale = h * inverse_scale
	local n_hierarchical_scenegraph = scenegraph.n_hierarchical_scenegraph

	for i = 1, n_hierarchical_scenegraph do
		local scenegraph_object = hierarchical_scenegraph[i]
		local current_world_position = nil
		local size = scenegraph_object.size
		current_world_position = Vector3_from_array(scenegraph_object.local_position)
		local parent_size_x = w_inverse_scale
		local parent_size_y = h_inverse_scale
		local size_x = size and size[1]
		local size_y = size and size[2]
		local scenegraph_object_scale = scenegraph_object.scale
		local scenegraph_object_parent = scenegraph_object.parent

		if not scenegraph_object_parent and not scenegraph_object_scale or scenegraph_object_scale == "fit" or scenegraph_object_scale == "hud_fit" then
			size_x = w_inverse_scale
			size_y = h_inverse_scale
			local scale_offset_x = 0
			local scale_offset_y = 0

			Vector3_set_x(current_world_position, current_world_position[1] + safe_rect_offset_x + scale_offset_x)
			Vector3_set_y(current_world_position, current_world_position[2] + safe_rect_offset_y + scale_offset_y)
		elseif scenegraph_object_scale == "aspect_ratio" then
			local aspect_ratio = w / h
			local default_aspect_ratio = size_x / size_y
			size_x = w
			size_y = h

			if math.abs(aspect_ratio - default_aspect_ratio) > 0.005 then
				size_x = w
				size_y = size_x / default_aspect_ratio

				if h < size_y then
					size_x = h * default_aspect_ratio
					size_y = h
				end
			end

			Vector3_set_x(current_world_position, safe_rect_offset_x)
			Vector3_set_y(current_world_position, safe_rect_offset_y)

			size_x = size_x * inverse_scale
			size_y = size_y * inverse_scale

			_handle_alignment(current_world_position, scenegraph_object, size_x, size_y, parent_size_x, parent_size_y)
		elseif scenegraph_object_scale == "fit_width" then
			Vector3_set_x(current_world_position, safe_rect_offset_x)
			Vector3_set_y(current_world_position, safe_rect_offset_y)

			size_x = w_inverse_scale

			fassert(not scenegraph_object.horizontal_alignment, "UIScenegraph - Scenegraph scale (%s) do not support horizontal_alignment", scenegraph_object_scale)
			_handle_alignment(current_world_position, scenegraph_object, nil, size_y, nil, parent_size_y)
		elseif scenegraph_object_scale == "fit_height" then
			Vector3_set_y(current_world_position, safe_rect_offset_y)
			Vector3_set_x(current_world_position, safe_rect_offset_x)

			size_y = h_inverse_scale

			fassert(not scenegraph_object.vertical_alignment, "UIScenegraph - Scenegraph scale (%s) do not support vertical_alignment", scenegraph_object_scale)
			_handle_alignment(current_world_position, scenegraph_object, size_x, nil, parent_size_x, nil)
		end

		Vector3.to_array(current_world_position, scenegraph_object.world_position)

		local children = scenegraph_object.children

		if children then
			if scenegraph.is_static then
				Profiler.start("UIScenegraph.update_scenegraph_children_static")
				scenegraph_cached_update_children(scenegraph_object.scene_graph_ref, current_world_position, children, scenegraph_object.num_children, size_x, size_y)
				Profiler.stop("UIScenegraph.update_scenegraph_children_static")
			else
				Profiler.start("UIScenegraph.update_scenegraph_children_dynamic")
				scenegraph_update_children(current_world_position, children, scenegraph_object.num_children, size_x, size_y)
				Profiler.stop("UIScenegraph.update_scenegraph_children_dynamic")
			end
		end
	end

	Profiler.stop("UIScenegraph.update_scenegraph")
end

UIScenegraph.get_scenegraph_id_screen_scale = function (scenegraph, scenegraph_object_name, scale)
	local world_position = UIScenegraph.world_position(scenegraph, scenegraph_object_name, scale)
	local size_width, size_height = UIScenegraph.get_render_size(scenegraph, scenegraph_object_name, scale)
	local resolution_width = RESOLUTION_LOOKUP.width
	local resolution_height = RESOLUTION_LOOKUP.height
	local x_scale = world_position.x / resolution_width
	local y_scale = world_position.y / resolution_height
	local w_scale = size_width / resolution_width
	local h_scale = size_height / resolution_height

	return x_scale, y_scale, w_scale, h_scale
end

UIScenegraph.world_position = function (scenegraph, scenegraph_object_name, scale)
	fassert(rawget(scenegraph, scenegraph_object_name), "No such object name in scenegraph: %s", tostring(scenegraph_object_name))

	local world_position = scenegraph[scenegraph_object_name].world_position

	if scale then
		return Vector3(world_position[1] * scale, world_position[2] * scale, world_position[3])
	else
		return world_position
	end
end

UIScenegraph.local_position = function (scenegraph, scenegraph_object_name)
	return scenegraph[scenegraph_object_name].local_position
end

UIScenegraph.get_render_size = function (scenegraph, scenegraph_object_name, optional_scale)
	local scenegraph_object = scenegraph[scenegraph_object_name]
	local size = scenegraph_object.size
	local scenegraph_object_scale = scenegraph_object.scale
	local scenegraph_object_parent = scenegraph_object.parent
	local scale = optional_scale or RESOLUTION_LOOKUP.scale
	local inverse_scale = 1 / scale

	if scenegraph_object_scale or not scenegraph_object_parent then
		local w = RESOLUTION_LOOKUP.width
		local h = RESOLUTION_LOOKUP.height
		local safe_rect = _safe_rect()
		local safe_rect_scale = 1 - safe_rect
		w = w * safe_rect_scale
		h = h * safe_rect_scale

		if scenegraph_object_scale == "fit" or not scenegraph_object_parent and not scenegraph_object_scale then
			return w, h
		elseif scenegraph_object_scale == "hud_fit" then
			return w, h
		elseif scenegraph_object_scale == "fit_width" then
			return w, size[2] * scale
		elseif scenegraph_object_scale == "fit_height" then
			return size[1] * scale, h
		elseif scenegraph_object_scale == "aspect_ratio" then
			local size_x = size[1] * scale
			local size_y = size[2] * scale
			local aspect_ratio = w / h
			local default_aspect_ratio = size_x / size_y
			size_x = w
			size_y = h

			if math.abs(aspect_ratio - default_aspect_ratio) > 0.005 then
				size_x = w
				size_y = size_x / default_aspect_ratio

				if h < size_y then
					size_x = h * default_aspect_ratio
					size_y = h
				end
			end

			return size_x, size_y
		end
	elseif optional_scale then
		return size[1] * scale, size[2] * scale
	end
end

UIScenegraph.get_size = function (scenegraph, scenegraph_object_name, optional_scale)
	local scenegraph_object = scenegraph[scenegraph_object_name]
	local size = scenegraph_object.size
	local scenegraph_object_scale = scenegraph_object.scale
	local scenegraph_object_parent = scenegraph_object.parent

	if scenegraph_object_scale or not scenegraph_object_parent then
		local w = RESOLUTION_LOOKUP.width
		local h = RESOLUTION_LOOKUP.height
		local safe_rect = _safe_rect()
		local safe_rect_scale = 1 - safe_rect
		local scale = optional_scale or RESOLUTION_LOOKUP.scale
		local inverse_scale = 1 / scale
		w = w * safe_rect_scale
		h = h * safe_rect_scale

		if scenegraph_object_scale == "fit" or not scenegraph_object_parent and not scenegraph_object_scale then
			return w * inverse_scale, h * inverse_scale
		elseif scenegraph_object_scale == "hud_fit" then
			return w * inverse_scale, h * inverse_scale
		elseif scenegraph_object_scale == "fit_width" then
			return w * inverse_scale, size[2]
		elseif scenegraph_object_scale == "fit_height" then
			return size[1], h * inverse_scale
		elseif scenegraph_object_scale == "aspect_ratio" then
			local size_x = size[1]
			local size_y = size[2]
			local aspect_ratio = w / h
			local default_aspect_ratio = size_x / size_y
			size_x = w
			size_y = h

			if math.abs(aspect_ratio - default_aspect_ratio) > 0.005 then
				size_x = w
				size_y = size_x / default_aspect_ratio

				if h < size_y then
					size_x = h * default_aspect_ratio
					size_y = h
				end
			end

			size_x = size_x * inverse_scale
			size_y = size_y * inverse_scale

			return size_x, size_y
		end
	else
		return size[1], size[2]
	end
end

UIScenegraph.size_scaled = function (scenegraph, scenegraph_object_name, optional_scale)
	local scenegraph_object = scenegraph[scenegraph_object_name]
	local size = scenegraph_object.size
	local scale = optional_scale or RESOLUTION_LOOKUP.scale
	local inverse_scale = 1 / scale
	local safe_rect = _safe_rect()
	local safe_rect_scale = 1 - safe_rect
	local w = RESOLUTION_LOOKUP.width
	local h = RESOLUTION_LOOKUP.height
	w = w * safe_rect_scale
	h = h * safe_rect_scale
	local scenegraph_object_scale = scenegraph_object.scale
	local scenegraph_object_parent = scenegraph_object.parent

	if not scenegraph_object_parent and not scenegraph_object_scale or scenegraph_object_scale == "fit" then
		return Vector2(w * inverse_scale, h * inverse_scale)
	elseif scenegraph_object_scale == "hud_fit" then
		return Vector2(w * inverse_scale, h * inverse_scale)
	elseif scenegraph_object_scale == "fit_width" then
		return Vector2(w * inverse_scale, size[2])
	elseif scenegraph_object_scale == "fit_height" then
		return Vector2(size[1], h * inverse_scale)
	elseif scenegraph_object_scale == "aspect_ratio" then
		local size_x = size[1]
		local size_y = size[2]
		local aspect_ratio = w / h
		local default_aspect_ratio = size_x / size_y
		size_x = w
		size_y = h

		if math.abs(aspect_ratio - default_aspect_ratio) > 0.005 then
			size_x = w
			size_y = size_x / default_aspect_ratio

			if h < size_y then
				size_x = h * default_aspect_ratio
				size_y = h
			end
		end

		size_x = size_x * inverse_scale
		size_y = size_y * inverse_scale

		return Vector2(size_x, size_y)
	else
		return Vector2(size[1], size[2])
	end
end

UIScenegraph.set_local_position = function (scenegraph, scenegraph_object_name, new_position)
	local old_position = scenegraph[scenegraph_object_name].local_position
	old_position[1] = new_position[1]
	old_position[2] = new_position[2]
	old_position[3] = new_position[3]
end

return UIScenegraph
