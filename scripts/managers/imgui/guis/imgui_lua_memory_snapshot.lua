-- chunkname: @scripts/managers/imgui/guis/imgui_lua_memory_snapshot.lua

local ImguiWidgetUtilities = require("scripts/managers/imgui/widgets/imgui_widget_utilities")
local MIN_WIDTH, MIN_HEIGHT = 300, 100
local MAX_AUTO_WINDOW_WIDTH = 700
local MAX_AUTO_WINDOW_HEIGHT = 700
local MAX_CHILDREN = 20
local MAX_FILTER_HITS = 2500
local ImguiLuaMemorySnapshot = class("ImguiLuaMemorySnapshot")

ImguiLuaMemorySnapshot.init = function (self, params, view_definition)
	self._take_snapshot_button = ImguiWidgetUtilities.create_unique_label("Take Snapshot")
	self._next_snapshot_id = 0
	self._snapshots = {}
	self._skip_determinism = true
end

ImguiLuaMemorySnapshot.on_activated = function (self)
	return
end

ImguiLuaMemorySnapshot.update = function (self, dt, t)
	self:_render()
end

local ROOT_IDS = {}

ImguiLuaMemorySnapshot._render = function (self)
	if Imgui.button(self._take_snapshot_button) then
		collectgarbage("collect")
		self:_add_snapshot(self:_traverse_memory(), "Memory Dump")
	end

	self._skip_determinism = Imgui.checkbox("Skip Determinism (Improves execution time)", self._skip_determinism)

	for i = #self._snapshots, 1, -1 do
		local snapshot_data = self._snapshots[i]

		if not snapshot_data.window_initialized then
			local parent_pos_x, parent_pos_y = Imgui.get_window_pos()
			local parent_size_x = Imgui.get_window_size()

			Imgui.set_next_window_pos(parent_pos_x + parent_size_x, parent_pos_y)
			Imgui.set_next_window_size(0, 0)
		elseif snapshot_data.window_width or snapshot_data.window_height then
			Imgui.set_next_window_size(snapshot_data.window_width, snapshot_data.window_height)

			snapshot_data.window_width = nil
			snapshot_data.window_height = nil
		end

		local _, do_close = Imgui.begin_window(string.format("%s (%s)", snapshot_data.name or "Memory Snapshot", snapshot_data.snapshot_id), "horizontal_scrollbar")

		if do_close then
			table.remove(self._snapshots, i)
		else
			local lua_memory = snapshot_data.lua_memory
			local filter_width = 300

			Imgui.push_item_width(filter_width)
			Imgui.text(string.format("\t\tFilter (Max hits %s): ", MAX_FILTER_HITS))
			Imgui.same_line()

			local filter_before = snapshot_data.filter

			snapshot_data.filter = Imgui.input_text("", snapshot_data.filter)

			if filter_before ~= snapshot_data.filter then
				table.clear(snapshot_data.filtered_ids)
				LuaMemory.ids_by_filter(lua_memory, snapshot_data.filter, MAX_FILTER_HITS, snapshot_data.filtered_ids)
			end

			Imgui.pop_item_width()
			Imgui.separator()

			if Imgui.button("Save to Disk##" .. i) then
				local success, result = self:_save_file(lua_memory)

				snapshot_data.save_success = success
				snapshot_data.save_status = result
			end

			if snapshot_data.save_status then
				Imgui.same_line()

				if snapshot_data.save_success then
					Imgui.text(string.format("Saved at: %s", snapshot_data.save_status))
					Imgui.same_line()

					if Imgui.button("Copy##" .. i) then
						Clipboard.put(snapshot_data.save_status)
					end
				else
					Imgui.text(string.format("Error: ", snapshot_data.save_status))
				end
			end

			Imgui.separator()

			snapshot_data.num_headers = 0

			local num_ids = LuaMemory.root_ids(lua_memory, ROOT_IDS)

			for id_i = 1, num_ids do
				self:_recursive_header(snapshot_data, ROOT_IDS[id_i])
			end

			local w, h = Imgui.get_item_rect_size()

			h = h * snapshot_data.num_headers
			w = math.max(w, MIN_WIDTH)
			h = math.max(h, MIN_HEIGHT)

			local win_w, win_h = Imgui.get_window_size()

			if snapshot_data.window_initialized then
				local wanted_width = math.max(win_w, math.min(w, MAX_AUTO_WINDOW_WIDTH))
				local wanted_height = math.max(win_h, math.min(h, MAX_AUTO_WINDOW_HEIGHT))

				if win_w < wanted_width or win_h < wanted_height then
					snapshot_data.window_width = wanted_width
					snapshot_data.window_height = wanted_height
				end
			end

			snapshot_data.window_initialized = true
		end

		Imgui.end_window()
	end
end

ImguiLuaMemorySnapshot._add_snapshot = function (self, lua_memory, optional_name)
	local snapshot_id = self._next_snapshot_id

	self._next_snapshot_id = snapshot_id + 1

	table.insert(self._snapshots, {
		filter = "",
		memory_layout_name_max_size = 0,
		window_height = 0,
		window_width = 0,
		name = optional_name,
		snapshot_id = snapshot_id,
		lua_memory = lua_memory,
		remember_open = {},
		max_children = {},
		filtered_ids = {},
		name_padding_cache = {},
		children_cache = {},
	})
end

ImguiLuaMemorySnapshot._traverse_memory = function (self, dump_result)
	local dump_path, name = nil, "Memory Dump"
	local ref_start_t = os.time()
	local lua_memory = LuaMemory.traverse(dump_path, self._skip_determinism)

	Log.info("LuaMemory", "Finding references took: %ss", os.time() - ref_start_t)

	return lua_memory, name
end

ImguiLuaMemorySnapshot._save_file = function (self, lua_memory)
	local file_path

	if file_path == "" then
		return nil
	end

	local success, result = LuaMemory.dump(lua_memory, file_path)

	return success, result
end

ImguiLuaMemorySnapshot._recursive_header = function (self, snapshot_data, id, override_draw, depth)
	local lua_memory = snapshot_data.lua_memory
	local draw, open, filtered = true, snapshot_data.remember_open[id], false

	if snapshot_data.filter ~= "" then
		draw = snapshot_data.filtered_ids[id]
		open = not not snapshot_data.filtered_ids[id]
		filtered = true
	end

	if override_draw ~= nil then
		draw = override_draw
	end

	if draw then
		local name = LuaMemory.name_by_id(lua_memory, id)

		snapshot_data.memory_layout_name_max_size = math.clamp(#name, snapshot_data.memory_layout_name_max_size, 125)

		local name_length = snapshot_data.memory_layout_name_max_size

		snapshot_data.num_headers = snapshot_data.num_headers + 1
		depth = depth or 1

		local right_padding = "\t\t"
		local size, one_layer_size = LuaMemory.size_by_id(lua_memory, id)
		local pad_cache = snapshot_data.name_padding_cache
		local header_name = string.format("%s%s (self: %sb)%s##%s", string.pad_right(name, name_length + 4, " ", pad_cache), string.pad_right(string.chunk_from_right(tostring(size), 3, "'") .. "b", 15, " ", pad_cache), string.chunk_from_right(tostring(one_layer_size), 3, "'"), right_padding, id)

		if Imgui.collapsing_header(header_name, open) then
			snapshot_data.remember_open[id] = not filtered and true or snapshot_data.remember_open[id]

			local max_children = snapshot_data.max_children[id] or MAX_CHILDREN
			local children_cache = snapshot_data.children_cache[depth]

			if not children_cache then
				children_cache = {}
				snapshot_data.children_cache[depth] = children_cache
			end

			local children, num_children = LuaMemory.children_by_id(lua_memory, id, children_cache)

			if num_children > 0 then
				Imgui.indent()

				local drawable_children = 0
				local override_draw_children = override_draw == nil and filtered and string.find(name, snapshot_data.filter) or override_draw

				for i = 1, num_children do
					local drawn, can_draw = self:_recursive_header(snapshot_data, children[i], override_draw_children, depth + 1)

					if drawn or not filtered or can_draw then
						drawable_children = drawable_children + 1

						if max_children <= drawable_children then
							override_draw_children = false
						end
					end
				end

				local num_hidden = drawable_children - max_children

				if num_hidden > 0 then
					local num_to_add = math.min(MAX_CHILDREN, num_hidden)

					if Imgui.button(string.format("Show %s (out of %s) more...", num_to_add, num_hidden)) then
						snapshot_data.max_children[id] = (snapshot_data.max_children[id] or MAX_CHILDREN) + num_to_add
					end
				end

				Imgui.unindent()
			end
		else
			snapshot_data.remember_open[id] = false
			snapshot_data.max_children[id] = nil
		end
	end

	return draw, snapshot_data.filtered_ids[id]
end

return ImguiLuaMemorySnapshot
