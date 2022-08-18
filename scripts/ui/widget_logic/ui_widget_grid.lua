local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UIAnimation = require("scripts/managers/ui/ui_animation")
local DIRECTION = {
	RIGHT = "right",
	UP = "up",
	LEFT = "left",
	DOWN = "down"
}
local UIWidgetGrid = class("UIWidgetGrid")

UIWidgetGrid.init = function (self, widgets, alignment_list, scenegraph, area_scenegraph_id, direction, spacing, fill_section_spacing, use_is_focused_for_navigation)
	self._direction = direction
	self._scenegraph = scenegraph
	self._spacing = spacing or {
		0,
		0
	}
	self._area_scenegraph_id = area_scenegraph_id
	alignment_list = alignment_list or widgets
	local axis = ((direction == DIRECTION.LEFT or direction == DIRECTION.RIGHT) and 1) or 2
	local negative_direction = direction == DIRECTION.LEFT or direction == DIRECTION.UP
	self._using_negative_direction = negative_direction
	self._fill_section_spacing = fill_section_spacing
	self._use_is_focused_for_navigation = use_is_focused_for_navigation
	self._axis = axis
	self._scroll_direction_multiplier = (negative_direction and 1) or -1
	local area_size = self:_get_area_size()
	self._start_offset = (negative_direction and area_size[axis]) or 0
	self._widgets = widgets
	self._alignment_list = alignment_list
	self._total_grid_length, self._smallest_widget_length = self:_align_grid_widgets(alignment_list)
	self._ui_animations = {}
end

UIWidgetGrid._get_area_size = function (self)
	if self._area_size then
		return self._area_size
	else
		local scenegraph = self._scenegraph
		local area_scenegraph_id = self._area_scenegraph_id
		local scenegraph_size = UIScenegraph.size_scaled(scenegraph, area_scenegraph_id)
		local size = Vector3.to_array(scenegraph_size)
		self._area_size = size

		return size
	end
end

UIWidgetGrid.get_spacing = function (self)
	return self._spacing
end

UIWidgetGrid.assign_scrollbar = function (self, scrollbar_widget, pivot_scenegraph_id, interaction_scenegraph_id)
	self._scrollbar_widget = scrollbar_widget
	self._pivot_scenegraph_id = pivot_scenegraph_id
	self._interaction_scenegraph_id = interaction_scenegraph_id
	scrollbar_widget.style.mouse_scroll.scenegraph_id = interaction_scenegraph_id

	self:_update_scrollbar_sizes()
end

UIWidgetGrid.can_scroll = function (self)
	local scrollbar_widget = self._scrollbar_widget

	if scrollbar_widget then
		local axis = self._axis
		local area_size = self:_get_area_size()
		local area_length = area_size[axis]

		return area_length < self:length()
	end

	return false
end

UIWidgetGrid.set_scrollbar_progress = function (self, progress, animate_scroll)
	if self._scrollbar_active then
		local scrollbar_widget = self._scrollbar_widget
		local scrollbar_content = scrollbar_widget.content
		scrollbar_content.scroll_value = nil
		scrollbar_content.scroll_add = 0
		scrollbar_content.focused = self._selected_grid_index ~= nil
		self._scroll_progress = nil

		if animate_scroll then
			local func = UIAnimation.function_by_time
			local target = scrollbar_content
			local target_index = "value"
			local from = target[target_index] or 0
			local to = progress
			local duration = 0.3
			local easing = math.easeOutCubic
			self._ui_animations.scrollbar = UIAnimation.init(func, target, target_index, from, to, duration, easing)
		else
			scrollbar_content.value = progress or 0
			self._ui_animations.scrollbar = nil
		end
	end
end

UIWidgetGrid.scrollbar_progress = function (self)
	if self._scrollbar_active then
		local scrollbar_widget = self._scrollbar_widget

		return scrollbar_widget.content.value or 0
	else
		return 0
	end
end

UIWidgetGrid.set_render_scale = function (self, scale)
	self._render_scale = scale
end

UIWidgetGrid._update_animations = function (self, dt, t)
	local ui_animations = self._ui_animations

	for key, ui_animation in pairs(ui_animations) do
		UIAnimation.update(ui_animation, dt)

		if UIAnimation.completed(ui_animation) then
			ui_animations[key] = nil
		end
	end
end

UIWidgetGrid.update = function (self, dt, t, input_service)
	self:_update_animations(dt, t)
	self:_update_grid_position(dt, t)

	if input_service then
		local current_index = self._selected_grid_index

		if current_index then
			self:handle_grid_selection(input_service)
		end
	end
end

UIWidgetGrid.on_resolution_modified = function (self, scale)
	self._render_scale = scale
	self._area_size = nil

	self:_update_scrollbar_sizes()
end

UIWidgetGrid._update_scrollbar_sizes = function (self)
	local scrollbar_widget = self._scrollbar_widget

	if scrollbar_widget then
		local scroll_length = self:scroll_length()
		scrollbar_widget.content.scroll_length = scroll_length
		local area_size = self._area_size
		local axis = self._axis
		local area_length = area_size[axis]
		scrollbar_widget.content.area_length = area_length
		local spacing = self._spacing
		local scroll_step_length = self._scroll_step_length or self._smallest_widget_length
		local scroll_amount = (scroll_step_length + spacing[axis]) / scroll_length
		scrollbar_widget.content.scroll_amount = scroll_amount
	end

	local scrollbar_active = self:can_scroll()

	if scrollbar_active ~= self._scrollbar_active then
		self._scrollbar_active = scrollbar_active
	end
end

UIWidgetGrid.set_scroll_step_length = function (self, step_length)
	self._scroll_step_length = step_length

	self:_update_scrollbar_sizes()
end

UIWidgetGrid._update_grid_position = function (self, dt, t)
	local pivot_scenegraph_id = self._pivot_scenegraph_id

	if not pivot_scenegraph_id then
		return
	end

	local scenegraph = self._scenegraph
	local grid_scenegraph = scenegraph[pivot_scenegraph_id]
	local scroll_progress = self:scrollbar_progress()

	if scroll_progress ~= self._scroll_progress then
		local axis = self._axis
		local scroll_length = self:scroll_length()
		local scroll_direction_multiplier = self._scroll_direction_multiplier
		grid_scenegraph.position[axis] = scroll_length * scroll_progress * scroll_direction_multiplier

		UIScenegraph.update_scenegraph(scenegraph, self._render_scale)

		self._scroll_progress = scroll_progress
	end
end

UIWidgetGrid.scroll_progress_by_length = function (self, length)
	local scroll_length = self:scroll_length()
	local length_fraction = math.clamp(length / scroll_length, 0, 1)

	return length_fraction
end

UIWidgetGrid.clear_scroll_progress = function (self)
	self._scroll_progress = nil
end

UIWidgetGrid.length_scrolled = function (self)
	local scroll_length = self:scroll_length() or 0
	local scroll_progress = self._scroll_progress or 0
	local length = scroll_progress * scroll_length

	return length
end

UIWidgetGrid.scroll_length = function (self)
	local axis = self._axis
	local stale_axis = axis % 2 + 1
	local area_size = self:_get_area_size()
	local total_grid_length = self._total_grid_length
	local value = math.max(total_grid_length - area_size[axis], 0)

	return value
end

UIWidgetGrid.area_length = function (self)
	local axis = self._axis
	local area_size = self:_get_area_size()

	return area_size[axis]
end

UIWidgetGrid.length = function (self)
	return self._total_grid_length
end

UIWidgetGrid._find_closest_neighbour_vertical = function (self, index, input_direction)
	local widgets = self._widgets
	local direction = self._direction
	local growing_vertically = direction == DIRECTION.UP or direction == DIRECTION.DOWN
	local negative_direction = input_direction == DIRECTION.LEFT or input_direction == DIRECTION.UP
	local current_widget = widgets[index]
	local current_offset = current_widget.offset
	local current_content = current_widget.content
	local current_size = current_widget.size or current_content.size
	local current_row = current_content.row
	local current_column = current_content.column
	local current_coordinate_x = current_offset[1] + current_offset[1] + current_size[1] * 0.5
	local current_coordinate_y = current_offset[2] + current_offset[1] + current_size[2] * 0.5
	local best_index, closest_index, closest_index_distance = nil
	local shortest_distance = math.huge
	local closest_widget = nil
	local num_widgets = #widgets

	local function is_widget_closest(start_index, widget, widget_index)
		local offset = widget.offset
		local content = widget.content
		local size = widget.size or content.size
		local row = content.row
		local coordinate_x = offset[1] + offset[1] + size[1] * 0.5
		local distance = math.abs(coordinate_x - current_coordinate_x)

		if growing_vertically and row ~= current_row and distance <= shortest_distance then
			local same_distance = distance == shortest_distance
			shortest_distance = distance

			if same_distance then
				if not closest_index_distance or math.abs(start_index - widget_index) <= closest_index_distance then
					return not closest_index_distance or widget_index < closest_index
				end
			else
				return true
			end
		end
	end

	if input_direction == DIRECTION.DOWN then
		for i = math.min(index + 1, num_widgets), num_widgets, 1 do
			local widget = widgets[i]
			local content = widget.content

			if closest_widget and closest_widget.content.row < content.row then
				break
			end

			if content.hotspot then
				local row = content.row

				if is_widget_closest(index, widget, i) then
					closest_index_distance = math.abs(index - i)
					closest_index = i
					closest_widget = widget
				end
			end
		end
	elseif input_direction == DIRECTION.UP then
		for i = index, 1, -1 do
			local widget = widgets[i]
			local content = widget.content

			if closest_widget and content.row < closest_widget.content.row then
				break
			end

			if content.hotspot then
				local row = content.row

				if is_widget_closest(index, widget, i) then
					closest_index_distance = math.abs(index - i)
					closest_index = i
					closest_widget = widget
				end
			end
		end
	end

	return closest_index
end

UIWidgetGrid._find_closest_neighbour_horizontal = function (self, index, input_direction)
	local widgets = self._widgets
	local direction = self._direction
	local growing_vertically = direction == DIRECTION.UP or direction == DIRECTION.DOWN
	local current_widget = widgets[index]
	local current_offset = current_widget.offset
	local current_content = current_widget.content
	local current_size = current_widget.size or current_content.size
	local current_row = current_content.row
	local current_column = current_content.column
	local current_coordinate_x = current_offset[1] + current_size[1] * 0.5
	local current_coordinate_y = current_offset[2] + current_size[2] * 0.5
	local best_index, closest_index, closest_index_distance = nil
	local shortest_distance = math.huge
	local num_widgets = #widgets

	local function is_widget_closest(start_index, widget, widget_index)
		local offset = widget.offset
		local content = widget.content
		local size = widget.size or content.size
		local row = content.row
		local column = content.column

		if growing_vertically and row ~= current_row and (not closest_index_distance or math.abs(start_index - widget_index) <= closest_index_distance) then
			return not closest_index_distance or widget_index < closest_index
		end
	end

	if input_direction == DIRECTION.LEFT then
		for i = math.max(index - 1, 1), 1, -1 do
			local widget = widgets[i]
			local content = widget.content

			if content.hotspot then
				local row = content.row

				if row ~= current_row then
					break
				end

				if not closest_index_distance or math.abs(index - i) < closest_index_distance then
					closest_index_distance = math.abs(index - i)
					closest_index = i
				end
			end
		end
	elseif input_direction == DIRECTION.RIGHT then
		for i = math.min(index + 1, num_widgets), num_widgets, 1 do
			local widget = widgets[i]
			local content = widget.content

			if content.hotspot then
				local row = content.row

				if row ~= current_row then
					break
				end

				if not closest_index_distance or math.abs(index - i) < closest_index_distance then
					closest_index_distance = math.abs(index - i)
					closest_index = i
				end
			end
		end
	end

	return closest_index
end

UIWidgetGrid.force_update_list_size = function (self)
	local alignment_list = self._alignment_list
	self._total_grid_length, self._smallest_widget_length = self:_align_grid_widgets(alignment_list)

	self:_update_scrollbar_sizes()
end

UIWidgetGrid.remove_widget = function (self, widget)
	local widgets = self._widgets
	local alignment_list = self._alignment_list

	for i = 1, #widgets, 1 do
		if widgets[i] == widget then
			table.remove(widgets, i)

			break
		end
	end

	for i = 1, #alignment_list, 1 do
		if alignment_list[i] == widget then
			table.remove(alignment_list, i)

			break
		end
	end

	self._total_grid_length, self._smallest_widget_length = self:_align_grid_widgets(alignment_list)

	self:_update_scrollbar_sizes()
end

UIWidgetGrid._align_grid_widgets = function (self, widgets)
	local axis = self._axis
	local stale_axis = axis % 2 + 1
	local direction = self._direction
	local area_size = self:_get_area_size()
	local start_offset = self._start_offset
	local spacing = self._spacing
	local scenegraph = self._scenegraph
	local position = {
		0,
		0,
		[axis] = start_offset
	}
	local row = 1
	local column = 1
	local total_length = 0
	local first_interactable_widget, last_interactable_widget = nil
	local grid_section_largest_direction_axis = 0
	local grid_smallest_direction_axis = math.huge
	local grid_section_entry_positions = {}
	local grid_section_entry_sizes = {}
	local growing_vertically = direction == DIRECTION.UP or direction == DIRECTION.DOWN
	local negative_direction = direction == DIRECTION.LEFT or direction == DIRECTION.UP
	local use_limit_new_section_spacing = self._fill_section_spacing
	local num_widgets = #widgets

	for i, widget in ipairs(widgets) do
		local first_widget = i == 1
		local last_widget = i == num_widgets
		local content = widget.content
		local size = widget.size or content.size

		if not size then
			local scenegraph_id = widget.scenegraph_id
			local widget_scenegraph = scenegraph[scenegraph_id]
			size = widget_scenegraph.size
		end

		local change_grid_section = area_size[stale_axis] < position[stale_axis] + size[stale_axis] or false

		if change_grid_section then
			if growing_vertically then
				column = 1
				row = row + 1
			else
				row = 1
				column = column + 1
			end

			local limit_new_section_spacing = use_limit_new_section_spacing

			if limit_new_section_spacing then
				for i = 1, #grid_section_entry_sizes, 1 do
					local previous_selection_entry_size = grid_section_entry_sizes[i]
					local previous_selection_entry_position = grid_section_entry_positions[i]

					if math.box_overlap_box(position, size, previous_selection_entry_position, previous_selection_entry_size) then
						limit_new_section_spacing = false
					end
				end
			end

			if limit_new_section_spacing then
				local previous_selection_entry_size = grid_section_entry_sizes[1]
				local direction_axis = (previous_selection_entry_size and previous_selection_entry_size[axis]) or 0

				if negative_direction then
					position[axis] = position[axis] - (direction_axis + spacing[axis])
				else
					position[axis] = position[axis] + direction_axis + spacing[axis]
				end
			elseif negative_direction then
				position[axis] = position[axis] - (grid_section_largest_direction_axis + spacing[axis])
			else
				position[axis] = position[axis] + grid_section_largest_direction_axis + spacing[axis]
			end

			position[stale_axis] = 0
			grid_section_largest_direction_axis = 0

			if use_limit_new_section_spacing then
				table.clear(grid_section_entry_sizes)
				table.clear(grid_section_entry_positions)
			end
		end

		if use_limit_new_section_spacing then
			grid_section_entry_sizes[#grid_section_entry_sizes + 1] = table.clone(size)
			grid_section_entry_positions[#grid_section_entry_positions + 1] = table.clone(position)
		end

		local offset = widget.offset

		if offset then
			offset[1] = position[1]
			offset[2] = position[2]

			if negative_direction then
				offset[axis] = offset[axis] - size[axis]
			end

			local default_offset = widget.default_offset

			if default_offset then
				default_offset[1] = offset[1]
				default_offset[2] = offset[2]
			else
				default_offset = table.clone(offset)
				widget.default_offset = default_offset
			end

			content.row = row
			content.column = column

			if content.hotspot then
				first_interactable_widget = first_interactable_widget or widget
				last_interactable_widget = widget
			end
		end

		position[stale_axis] = position[stale_axis] + size[stale_axis] + spacing[stale_axis]

		if grid_section_largest_direction_axis < size[axis] then
			grid_section_largest_direction_axis = size[axis]
		end

		if size[axis] < grid_smallest_direction_axis then
			grid_smallest_direction_axis = size[axis]
		end

		if last_widget then
			if negative_direction then
				total_length = math.abs(position[axis]) + start_offset
			else
				total_length = math.abs(position[axis]) + grid_section_largest_direction_axis
			end
		end

		if growing_vertically then
			column = column + 1
		else
			row = row + 1
		end
	end

	self._first_interactable_widget_index = self:index_by_widget(first_interactable_widget)
	self._last_interactable_widget_index = self:index_by_widget(last_interactable_widget)

	return total_length, grid_smallest_direction_axis
end

UIWidgetGrid.handle_grid_selection = function (self, input_service)
	local current_index = self._selected_grid_index
	local widgets = self._widgets
	local selected_widget = widgets[current_index]
	local using_negative_direction = self._using_negative_direction
	local new_selection_index = nil

	if input_service:get("navigate_up_continuous") then
		local direction = (using_negative_direction and DIRECTION.DOWN) or DIRECTION.UP
		new_selection_index = self:_find_closest_neighbour_vertical(current_index, direction)
	elseif input_service:get("navigate_down_continuous") then
		local direction = (using_negative_direction and DIRECTION.UP) or DIRECTION.DOWN
		new_selection_index = self:_find_closest_neighbour_vertical(current_index, direction)
	elseif input_service:get("navigate_left_continuous") then
		new_selection_index = self:_find_closest_neighbour_horizontal(current_index, DIRECTION.LEFT)
	elseif input_service:get("navigate_right_continuous") then
		new_selection_index = self:_find_closest_neighbour_horizontal(current_index, DIRECTION.RIGHT)
	end

	if new_selection_index then
		local scroll_progress = nil

		if new_selection_index == self._first_interactable_widget_index then
			scroll_progress = 0
		elseif new_selection_index == self._last_interactable_widget_index then
			scroll_progress = 1
		else
			scroll_progress = self:get_scrollbar_percentage_by_index(new_selection_index)
		end

		self:select_grid_index(new_selection_index, scroll_progress, false, self._use_is_focused_for_navigation)
	end
end

UIWidgetGrid.widget_neighbour_by_index = function (self, widget, index)
	local content = widget.content
	local neighbours = content.neighbours

	return neighbours[index]
end

UIWidgetGrid.widgets = function (self)
	return self._widgets
end

UIWidgetGrid.index_by_widget = function (self, widget)
	local widgets = self._widgets

	for i, value in ipairs(widgets) do
		if value == widget then
			return i
		end
	end
end

UIWidgetGrid.last_interactable_grid_index = function (self)
	return self._last_interactable_widget_index
end

UIWidgetGrid.select_first_index = function (self, use_is_focused)
	local new_selection_index = self._first_interactable_widget_index

	self:select_grid_index(new_selection_index, 0, true, use_is_focused)
end

UIWidgetGrid.select_last_index = function (self, use_is_focused)
	local new_selection_index = self._last_interactable_widget_index

	self:select_grid_index(new_selection_index, 1, true, use_is_focused)
end

UIWidgetGrid.select_widget = function (self, widget, scrollbar_animation_progress, scroll_to_widget)
	local widget_index = self:index_by_widget(widget)

	if scroll_to_widget then
		scrollbar_animation_progress = self:get_scrollbar_percentage_by_index(widget_index)
	end

	self:select_grid_index(widget_index, scrollbar_animation_progress)
end

UIWidgetGrid.selected_grid_index = function (self)
	return self._selected_grid_index
end

UIWidgetGrid.focus_grid_index = function (self, index, scrollbar_animation_progress, instant_scroll)
	self:select_grid_index(index, scrollbar_animation_progress, instant_scroll, true)
end

UIWidgetGrid.select_grid_index = function (self, index, scrollbar_animation_progress, instant_scroll, use_is_focused)
	local widgets = self._widgets

	if widgets then
		for i, widget in ipairs(widgets) do
			local content = widget.content
			local hotspot = content.hotspot or content.button_hotspot

			if hotspot then
				local is_selected = i == index

				if use_is_focused then
					hotspot.is_focused = is_selected
				else
					hotspot.is_selected = is_selected
				end

				if is_selected then
					local selected_callback = hotspot.selected_callback

					if selected_callback then
						selected_callback()
					end
				end
			end
		end
	end

	if self._selected_grid_index ~= index then
		self._previous_grid_index = self._selected_grid_index
		self._selected_grid_index = index
		self._ui_animations.scrollbar = nil
	end

	if self._scrollbar_active and scrollbar_animation_progress then
		self:set_scrollbar_progress(scrollbar_animation_progress, not instant_scroll)
	end
end

UIWidgetGrid.get_scrollbar_percentage_by_index = function (self, index, start_from_bottom)
	if self._scrollbar_active then
		local scroll_progress = nil

		if start_from_bottom then
			scroll_progress = 1
		else
			scroll_progress = self:scrollbar_progress()
		end

		local scroll_length = self:scroll_length()
		local scrolled_length = scroll_length * scroll_progress
		local axis = self._axis
		local stale_axis = axis % 2 + 1
		local draw_length = self._area_size[axis]
		local draw_start_height = scrolled_length
		local draw_end_height = draw_start_height + draw_length
		local widgets = self._widgets

		if widgets then
			local widget = widgets[index]
			local content = widget.content
			local offset = widget.offset
			local size = content.size
			local height = size[axis]
			local start_position_top = math.abs(offset[axis])
			local start_position_bottom = start_position_top + height
			local percentage_difference = 0

			if draw_end_height < start_position_bottom then
				local height_missing = start_position_bottom - draw_end_height
				percentage_difference = math.clamp(height_missing / scroll_length, 0, 1)
			elseif start_position_top < draw_start_height then
				local height_missing = draw_start_height - start_position_top
				percentage_difference = -math.clamp(height_missing / scroll_length, 0, 1)
			end

			if percentage_difference then
				local new_scroll_progress = math.clamp(scroll_progress + percentage_difference, 0, 1)

				return new_scroll_progress
			end
		end

		return 0
	end
end

UIWidgetGrid.is_widget_visible = function (self, widget, extra_margin)
	if self._scrollbar_active then
		local scroll_progress = self:scrollbar_progress()
		local scroll_length = self:scroll_length()
		local scrolled_length = scroll_length * scroll_progress
		local axis = self._axis
		local draw_length = self._area_size[axis]
		local draw_start_length = scrolled_length
		local draw_end_length = draw_start_length + draw_length
		local content = widget.content
		local offset = widget.offset
		local size = content.size
		local size_length = size[axis]
		local margin = extra_margin or 0
		local start_position_start = math.abs(offset[axis]) - margin
		local start_position_end = start_position_start + size_length + margin * 2

		if draw_end_length < start_position_start then
			return false
		elseif start_position_end < draw_start_length then
			return false
		end
	end

	return true
end

UIWidgetGrid.destroy = function (self)
	return
end

return UIWidgetGrid
