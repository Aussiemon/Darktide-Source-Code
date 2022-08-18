local ImguiProfiler = class("ImguiProfiler")

ImguiProfiler.init = function (self)
	self._filter = ""
	self._filter_applied = false
	self._auto_update_filter = false
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

ImguiProfiler.update = function (self, dt, t)
	return
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

ImguiProfiler._post_draw = function (self)
	Imgui.set_window_size(700, 512, "once")

	local new_profiler_frames, confirmed = Imgui.input_int("Average over number of frames", LuaProfiler.PROFILER_FRAME_SCOPE)

	if confirmed then
		LuaProfiler.PROFILER_FRAME_SCOPE = new_profiler_frames
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

	Imgui.begin_child_window("Profiler Tree", 0, 0, true)

	INDEX = 1

	if self._filter_applied then
		self:_draw_filtered_scopes()
	else
		self:_draw_lookup_table(LuaProfiler.PROFILER_SCOPE_LOOKUP, false)
	end

	Imgui.end_child_window()
end

ImguiProfiler._draw_filtered_scopes = function (self)
	local fixed_frame_index = LuaProfiler.CURRENT_FIXED_FRAME_INDEX

	if FILTERED_SCOPES_INDEX >= 1 then
		local is_open = Imgui.tree_node("root", true)

		for i = 1, math.max(FILTERED_SCOPES_INDEX - 1, 1), 1 do
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

	if keep_in_scope and in_scope.frame_index and in_scope.frame_index < LuaProfiler.CURRENT_FIXED_FRAME_INDEX then
		return
	elseif not keep_in_scope and in_scope.frame_index and in_scope.frame_index < LuaProfiler.CURRENT_FRAME_INDEX then
		return
	end

	local is_root = false
	local is_leaf = in_scope.is_leaf ~= false
	local profiler_suffix = (in_scope.average_profiler_scope and string.format(((keep_in_scope and "fixed: ") or "") .. "%.3f", in_scope.average_profiler_scope)) or ""
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

	if is_open then
		local top_value = -1
		local top_scope = ""
		local SORTED_SCOPES = {}

		for _, scope in pairs(in_scope) do
			if type(scope) == "table" then
				if scope.parent == parent and (((scope.keep_in_scope or keep_in_scope) and scope.frame_index == LuaProfiler.CURRENT_FIXED_FRAME_INDEX) or scope.frame_index == LuaProfiler.CURRENT_FRAME_INDEX) then
					SORTED_SCOPES[#SORTED_SCOPES + 1] = scope
					local value = scope.average_profiler_scope or 0

					if top_value < value then
						top_value = value
						top_scope = scope
					end
				end

				local stack = scope.stack

				if stack then
					for i = 1, stack.stack_index, 1 do
						local entry = stack[i]
						SORTED_SCOPES[#SORTED_SCOPES + 1] = entry
						local value = entry.average_profiler_scope or 0

						if top_value < value then
							top_value = value
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

	if keep_in_scope and in_scope.frame_index and in_scope.frame_index < LuaProfiler.CURRENT_FIXED_FRAME_INDEX then
		return
	elseif not keep_in_scope and in_scope.frame_index and in_scope.frame_index < LuaProfiler.CURRENT_FRAME_INDEX then
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
			if scope.parent == parent and (((scope.keep_in_scope or keep_in_scope) and scope.frame_index == LuaProfiler.CURRENT_FIXED_FRAME_INDEX) or scope.frame_index == LuaProfiler.CURRENT_FRAME_INDEX) then
				SORTED_SCOPES[#SORTED_SCOPES + 1] = scope
			end

			local stack = scope.stack

			if stack then
				for i = 1, stack.stack_index, 1 do
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
