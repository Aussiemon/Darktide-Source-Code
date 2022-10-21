local ImguiProfiler = class("ImguiProfiler")

ImguiProfiler.init = function (self)
	self:_reset()
end

ImguiProfiler._reset = function (self)
	self._filter = ""
	self._filter_applied = false
	self._auto_update_filter = false
	self._current_histogram_index = nil
	self._paused_frame_index = nil
	self._paused_fixed_frame_index = nil
	self._first_draw = true
	DO_RELOAD = false
end

ImguiProfiler.is_persistent = function (self)
	return false
end

ImguiProfiler.on_activated = function (self)
	LuaProfiler.CALCULATE_AVERAGE = true
end

ImguiProfiler.on_deactivated = function (self)
	LuaProfiler.CALCULATE_AVERAGE = false
end

DO_RELOAD = true

ImguiProfiler.update = function (self, dt, t)
	if DO_RELOAD then
		self:_reset()
	end
end

ImguiProfiler._draw = function (self)
	return
end

ImguiProfiler.post_update = function (self, dt, t)
	self:_post_draw()
end

local INDEX = 1
local FILTERED_SCOPES = {}
local FILTERED_SCOPES_INDEX = 1
local CURRENT_FRAME_INDEX, CURRENT_FIXED_FRAME_INDEX = nil

ImguiProfiler._post_draw = function (self)
	if self._first_draw then
		Imgui.set_window_size(660, 900)

		self._first_draw = nil
	end

	local new_profiler_frames, confirmed = Imgui.input_int("Average over number of frames", LuaProfiler.PROFILER_FRAME_SCOPE)

	if confirmed then
		LuaProfiler.PROFILER_FRAME_SCOPE = new_profiler_frames
	end

	CURRENT_FRAME_INDEX = LuaProfiler.CURRENT_FRAME_INDEX
	CURRENT_FIXED_FRAME_INDEX = LuaProfiler.CURRENT_FIXED_FRAME_INDEX

	if self._current_histogram_index then
		CURRENT_FRAME_INDEX = self._paused_frame_index
		CURRENT_FIXED_FRAME_INDEX = self._paused_fixed_frame_index
	end

	local update_filter = false
	local new_filter_text, confirmed = Imgui.input_text("Filter", self._filter)

	if confirmed then
		self._filter = new_filter_text
		self._filter_applied = self._filter ~= ""
		update_filter = true
	end

	self._auto_update_filter = Imgui.checkbox("Auto Update Filter (affects performance)", self._auto_update_filter)

	if update_filter or self._auto_update_filter then
		FILTERED_SCOPES_INDEX = 1
		local SCOPES = LuaProfiler.PROFILER_SCOPE_LOOKUP

		if self._filter ~= "" then
			self:_apply_filter(SCOPES)
		end
	end

	Imgui.begin_child_window("Profiler Tree", 0, 525, true)

	INDEX = 1
	self._selected_scope = nil

	if self._filter_applied then
		self:_draw_filtered_scopes()
	else
		self:_draw_lookup_table(LuaProfiler.PROFILER_SCOPE_LOOKUP, false)
	end

	Imgui.end_child_window()
	Imgui.begin_child_window("Histogram", 0, 220, true)
	self:_draw_histogram()
	Imgui.end_child_window()
	Imgui.begin_child_window("Pause", 0, 40, true)

	local width, height = Imgui.get_window_size()
	local text = "Pause"

	if LuaProfiler.PAUSED then
		text = "Unpause - (paused on frame: " .. (self._current_histogram_index and self._current_histogram_index - 1 or LuaProfiler.HISTOGRAM_SIZE - 2) .. ")"
	end

	if Imgui.button(text, width, 20) then
		LuaProfiler.PAUSED = not LuaProfiler.PAUSED
		self._current_histogram_index = nil
	end

	Imgui.end_child_window()
end

local EMPTY_TABLE = {}

ImguiProfiler._draw_histogram = function (self)
	if not self._selected_scope then
		local label = string.upper("Select scope to generate histogram")
		local width, height = Imgui.get_window_size()

		Imgui.plot_histogram("", EMPTY_TABLE, nil, label, nil, nil, Vector2(width, 180))

		return
	end

	local histogram = self._selected_scope.histogram
	local histogram_clone = table.clone(histogram)

	table.sort(histogram_clone)

	local percentile = 0.95
	local histogram_size = #histogram_clone
	local offset = math.ceil((1 - percentile) * histogram_size)
	local max_scale = histogram_clone[histogram_size - offset] or nil
	local min_scale = histogram_clone[offset] or nil
	local histogram_clone = table.clone(histogram)

	for i = 1, LuaProfiler.HISTOGRAM_SIZE do
		histogram_clone[i] = histogram_clone[i] or 0
	end

	local label = string.format("%sth-percentile: %.3f ms", percentile * 100, max_scale or 0)
	local width, height = Imgui.get_window_size()

	Imgui.plot_histogram("", histogram_clone, nil, label, min_scale and min_scale * 0.85, max_scale and max_scale * 1.25, Vector2(width, 200))

	if Imgui.is_window_hovered() and Imgui.is_mouse_clicked(0) then
		local histogram_width = width - 14
		local window_x, _ = Imgui.get_window_pos()
		local histogram_start_x = window_x + 12
		local cursor_x, cursor_y = Imgui.get_mouse_pos()
		local histogram_index = math.floor((cursor_x - histogram_start_x) / histogram_width * 99)

		if not histogram[histogram_index + 1] then
			return
		end

		self._current_histogram_index = histogram_index + 1
		LuaProfiler.PAUSED = true
		self._paused_frame_index = self._selected_scope.histogram_frame_indices[self._current_histogram_index] or CURRENT_FRAME_INDEX
		self._paused_fixed_frame_index = self._selected_scope.histogram_fixed_frame_indices[self._current_histogram_index] or CURRENT_FIXED_FRAME_INDEX
	end

	if LuaProfiler.PAUSED and self._current_histogram_index then
		local width, height = Imgui.get_window_size()
		local x, y = Imgui.get_cursor_screen_pos()
		local offset_x = 4
		local offset_y = 7
		local rect_x = x + offset_x
		local rect_y = y - offset_y
		local histogram_height = height - 24
		local base_diff = 1436
		local width_diff = width - 484
		local lerp_diff = math.clamp(width_diff / base_diff, 0, 1)
		local step_size = math.lerp(4.76, 19.12, lerp_diff)
		local histogram_index = self._current_histogram_index - 1
		local histogram_value = histogram_clone[histogram_index]

		Imgui.add_rect_filled(math.round(rect_x + step_size * histogram_index), rect_y, math.round(rect_x + step_size * (histogram_index + 1)), rect_y - histogram_height, Color(128, 255, 0, 0))
	end
end

ImguiProfiler._draw_filtered_scopes = function (self)
	local fixed_frame_index = CURRENT_FIXED_FRAME_INDEX

	if FILTERED_SCOPES_INDEX >= 1 then
		local is_open = Imgui.tree_node("root", true)

		for i = 1, math.max(FILTERED_SCOPES_INDEX - 1, 1) do
			local filtered_scope = FILTERED_SCOPES[i]

			self:_draw_lookup_table(filtered_scope, false)
		end

		Imgui.tree_pop()
	else
		Imgui.text_colored(string.format("No scope includes the text %q", self._filter), 255, 128, 128, 255)
	end
end

ImguiProfiler._draw_lookup_table = function (self, in_scope, is_top_scope, keep_in_scope)
	if not in_scope then
		return
	end

	local parent = in_scope.name
	local keep_in_scope = in_scope.keep_in_scope or keep_in_scope
	local in_scope_frame_index = in_scope.frame_index
	local histogram_index = self._current_histogram_index

	if LuaProfiler.PAUSED and in_scope.name then
		local scope_histogram_frame_indices = in_scope.histogram_frame_indices

		if scope_histogram_frame_indices then
			histogram_index = table.find(scope_histogram_frame_indices, CURRENT_FRAME_INDEX)

			if histogram_index then
				in_scope_frame_index = CURRENT_FRAME_INDEX
			else
				return
			end
		end
	end

	if keep_in_scope and in_scope_frame_index < CURRENT_FIXED_FRAME_INDEX then
		return
	elseif not keep_in_scope and in_scope_frame_index and in_scope_frame_index < CURRENT_FRAME_INDEX then
		return
	end

	local is_root = false
	local is_leaf = in_scope.is_leaf ~= false
	local average_profiler_scope = in_scope.name and in_scope.average_profiler_scope

	if LuaProfiler.PAUSED then
		average_profiler_scope = in_scope.histogram and in_scope.histogram[histogram_index]
	end

	local profiler_suffix = average_profiler_scope and string.format((keep_in_scope and "fixed: " or "") .. "%.3f", average_profiler_scope) or ""
	local header = nil

	if is_leaf then
		header = string.format("%s", in_scope.name, INDEX)

		if is_top_scope then
			Imgui.text_colored(header, 0, 255, 0, 255)
		else
			Imgui.text(header)
		end

		Imgui.same_line()

		if is_top_scope then
			Imgui.text_colored(profiler_suffix, 0, 255, 0, 255)
		elseif keep_in_scope then
			Imgui.text_colored(profiler_suffix, 192, 192, 0, 255)
		else
			Imgui.text_colored(profiler_suffix, 192, 128, 128, 255)
		end

		Imgui.same_line()

		if Imgui.checkbox("##" .. header, LuaProfiler.SELECTED_SCOPE == header) then
			LuaProfiler.SELECTED_SCOPE = header
			self._selected_scope = in_scope
		end

		return
	elseif in_scope.name then
		header = string.format("%s ##%s", in_scope.name, INDEX)
	else
		header = "root"
		is_root = true
	end

	INDEX = INDEX + 1
	local is_open = Imgui.tree_node(header, is_root)

	Imgui.same_line()

	if is_top_scope then
		Imgui.text_colored(profiler_suffix, 0, 255, 0, 255)
	elseif keep_in_scope then
		Imgui.text_colored(profiler_suffix, 192, 192, 0, 255)
	else
		Imgui.text_colored(profiler_suffix, 192, 128, 128, 255)
	end

	if not is_root then
		Imgui.same_line()

		if Imgui.checkbox("##" .. header, LuaProfiler.SELECTED_SCOPE == header) then
			LuaProfiler.SELECTED_SCOPE = header
			self._selected_scope = in_scope
		end
	end

	if is_open then
		local top_value = -1
		local top_scope = ""
		local SORTED_SCOPES = {}

		for _, scope in pairs(in_scope) do
			if type(scope) == "table" then
				local fixed_update = scope.keep_in_scope or keep_in_scope
				local scope_frame_index = fixed_update and scope.fixed_frame_index or scope.frame_index
				local histogram_index = self._current_histogram_index

				if LuaProfiler.PAUSED then
					local scope_histogram_frame_indices = fixed_update and scope.histogram_fixed_frame_indices or scope.histogram_frame_indices

					if scope_histogram_frame_indices then
						histogram_index = table.find(scope_histogram_frame_indices, CURRENT_FRAME_INDEX) or histogram_index

						if histogram_index then
							scope_frame_index = CURRENT_FRAME_INDEX
						end
					end
				end

				if scope.parent == parent and ((scope.keep_in_scope or keep_in_scope) and scope_frame_index == CURRENT_FIXED_FRAME_INDEX or scope_frame_index == CURRENT_FRAME_INDEX) then
					SORTED_SCOPES[#SORTED_SCOPES + 1] = scope
					local average_profiler_scope = scope.average_profiler_scope or 0

					if LuaProfiler.PAUSED and histogram_index then
						average_profiler_scope = scope.histogram[histogram_index] or 0
					end

					if top_value < average_profiler_scope then
						top_value = average_profiler_scope
						top_scope = scope
					end
				end

				local stack = scope.stack

				if stack then
					for i = 1, stack.stack_index do
						local entry = stack[i]
						local average_profiler_scope = nil

						if LuaProfiler.PAUSED then
							local scope_histogram_frame_indices = fixed_update and entry.histogram_fixed_frame_indices or entry.histogram_frame_indices

							if scope_histogram_frame_indices then
								local entry_histogram_index = table.find(scope_histogram_frame_indices, CURRENT_FRAME_INDEX)

								if entry_histogram_index then
									average_profiler_scope = entry.histogram and entry.histogram[entry_histogram_index]

									if average_profiler_scope then
										SORTED_SCOPES[#SORTED_SCOPES + 1] = entry
									end
								end
							end
						else
							average_profiler_scope = entry.average_profiler_scope
							SORTED_SCOPES[#SORTED_SCOPES + 1] = entry
						end

						if average_profiler_scope and top_value < average_profiler_scope then
							top_value = average_profiler_scope
							top_scope = entry
						end
					end
				end
			end
		end

		local function sort_func(a, b)
			local a_name = a.name
			local b_name = b.name

			return a_name < b_name
		end

		table.sort(SORTED_SCOPES, sort_func)

		for _, scope in ipairs(SORTED_SCOPES) do
			self:_draw_lookup_table(scope, scope == top_scope, keep_in_scope)
		end

		Imgui.tree_pop()
	end
end

ImguiProfiler._apply_filter = function (self, in_scope, keep_in_scope)
	local parent = in_scope.name
	local keep_in_scope = in_scope.keep_in_scope or keep_in_scope

	if keep_in_scope and in_scope.frame_index and in_scope.frame_index < CURRENT_FIXED_FRAME_INDEX then
		return
	elseif not keep_in_scope and in_scope.frame_index and in_scope.frame_index < CURRENT_FRAME_INDEX then
		return
	end

	INDEX = INDEX + 1

	if parent and string.find(string.lower(parent), string.lower(self._filter)) ~= nil then
		FILTERED_SCOPES[FILTERED_SCOPES_INDEX] = in_scope
		FILTERED_SCOPES_INDEX = FILTERED_SCOPES_INDEX + 1

		return
	end

	local SORTED_SCOPES = {}

	for _, scope in pairs(in_scope) do
		if type(scope) == "table" then
			if scope.parent == parent and ((scope.keep_in_scope or keep_in_scope) and scope.frame_index == CURRENT_FIXED_FRAME_INDEX or scope.frame_index == CURRENT_FRAME_INDEX) then
				SORTED_SCOPES[#SORTED_SCOPES + 1] = scope
			end

			local stack = scope.stack

			if stack then
				for i = 1, stack.stack_index do
					local entry = stack[i]
					SORTED_SCOPES[#SORTED_SCOPES + 1] = entry
				end
			end
		end
	end

	local function sort_func(a, b)
		local a_name = a.name
		local b_name = b.name

		return a_name < b_name
	end

	table.sort(SORTED_SCOPES, sort_func)

	for _, scope in ipairs(SORTED_SCOPES) do
		self:_apply_filter(scope, keep_in_scope)
	end
end

return ImguiProfiler
