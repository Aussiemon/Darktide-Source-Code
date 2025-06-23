-- chunkname: @scripts/managers/imgui/widgets/imgui_memory_snapshot_widget.lua

local LuaJIT = require("scripts/utilities/luajit")
local ImguiWidgetUtilities = require("scripts/managers/imgui/widgets/imgui_widget_utilities")
local LuaJITUtils = LuaJIT and LuaJIT.jutil()
local MIN_WIDTH, MIN_HEIGHT = 300, 100
local MAX_AUTO_WINDOW_WIDTH = 700
local MAX_AUTO_WINDOW_HEIGHT = 700
local Widget = {}
local snapshot_ignore = {}

snapshot_ignore[Widget] = true
snapshot_ignore[snapshot_ignore] = true

Widget.new = function (display_name, optional_width)
	local widget = {
		filter = "",
		window_width = 0,
		type = "debug_memory_snapshot",
		memory_layout_name_max_size = 0,
		window_height = 0,
		single_column = true,
		display_name = display_name,
		button_label = ImguiWidgetUtilities.create_unique_label("Take Snapshot"),
		remember_open = {}
	}

	snapshot_ignore[widget] = true

	return widget
end

Widget.pad_right = function (str, target_length, pad_str, cache)
	local str_size = #str
	local pad_size = #pad_str

	if cache then
		local slack = math.max(0, target_length - str_size)
		local cached = cache[slack]

		if cached then
			return str .. cached
		end

		cache[slack] = Widget.pad_right("", slack, pad_str)

		return str .. cache[slack]
	end

	local padding = ""

	for i = str_size + pad_size, target_length, pad_size do
		padding = padding .. pad_str
	end

	local rest = (target_length - str_size) % pad_size

	if rest ~= 0 then
		padding = padding .. string.sub(pad_str, 1, rest)
	end

	return str .. padding
end

local chunk_scratch = {}

Widget.chunk_from_right = function (str, step_n, sep)
	sep = sep or " "

	local str_len = #str
	local chunk_part_n = math.floor(str_len / step_n)
	local offset = 0
	local rest = str_len % step_n

	if rest > 0 then
		chunk_scratch[1] = string.sub(str, 1, rest)
		offset = 1
	end

	for i = 1, chunk_part_n do
		chunk_scratch[chunk_part_n - i + 1 + offset] = string.sub(str, -i * step_n, -(i - 1) * step_n - 1)
	end

	local res = table.concat(chunk_scratch, sep)

	table.clear(chunk_scratch)

	return res
end

Widget.select_map = function (t, selector)
	local new_t = {}

	for k, v in pairs(t) do
		new_t[k] = selector(k, v)
	end

	return new_t
end

Widget.max_func = function (t, func)
	local max_key, max_value = next(t)

	for key, value in pairs(t) do
		if func(value) > func(max_value) then
			max_key, max_value = key, value
		end
	end

	return max_key, max_value
end

local upvalue_name_cache = {}

Widget.find_references = function (ref, ref_blob, name_by_ref, references_at_depth, track_size, depth)
	local tbl_type = type(ref)

	if tbl_type == "table" then
		for k, v in pairs(ref) do
			Widget.add_to_blob(k, k, ref_blob, name_by_ref, references_at_depth, track_size, depth)
			Widget.add_to_blob(v, k, ref_blob, name_by_ref, references_at_depth, track_size, depth)
		end
	elseif tbl_type == "function" then
		local info = LuaJITUtils.funcinfo(ref)
		local uvs = info.upvalues
		local b = 0

		for i = 1, uvs do
			local k, v = debug.getupvalue(ref, i)

			if k == "" then
				upvalue_name_cache[i] = upvalue_name_cache[i] or "upvalue_" .. i
				k = upvalue_name_cache[i]
			end

			Widget.add_to_blob(v, k, ref_blob, name_by_ref, references_at_depth, track_size, depth)
		end

		return b
	end
end

Widget.add_to_blob = function (val, key, ref_blob, name_by_ref, references_at_depth, track_size, depth)
	if ref_blob[val] or snapshot_ignore[val] then
		return
	end

	local v_type = type(val)

	if v_type == "table" or v_type == "function" then
		name_by_ref[val] = key
		ref_blob[val] = depth

		if track_size then
			track_size[val] = true
		end

		local refs = references_at_depth[depth]

		if not refs then
			refs = {
				[0] = 1,
				val
			}
			references_at_depth[depth] = refs
		else
			local n = refs[0] + 1

			refs[0] = n
			refs[n] = val
		end
	end
end

Widget.grab_lua_memory_tree_snapshot = function (tbl, root_name)
	Deadlock.pause()

	tbl = tbl or _G

	local depth_by_reference = {
		[_G] = 1
	}
	local references_at_depth = {
		{
			[0] = 1,
			_G
		}
	}
	local size_by_ref = {
		[tbl] = LuaJIT.bytes(tbl, true)
	}
	local track_size = {
		[tbl] = true
	}
	local one_layer_size = {
		[tbl] = size_by_ref[tbl]
	}
	local name_by_ref = {
		[tbl] = root_name
	}

	do
		local i = 1

		repeat
			local refs = references_at_depth[i]

			for ref_i = 1, refs[0] do
				local ref = refs[ref_i]
				local track_size_tbl = track_size[ref] and track_size or nil

				Widget.find_references(ref, depth_by_reference, name_by_ref, references_at_depth, track_size_tbl, i + 1)
			end

			i = i + 1
		until not references_at_depth[i]
	end

	for ref, name in pairs(name_by_ref) do
		local n_type = type(name)

		if n_type ~= "string" then
			if n_type == "number" then
				name_by_ref[ref] = string.format("<Array Index %s>", name)
			elseif name_by_ref[name] and type(name_by_ref[name]) ~= "table" then
				name_by_ref[ref] = "<Indexed by: " .. tostring(name_by_ref[name]) .. ">"
			elseif n_type == "table" then
				name_by_ref[ref] = "<Table Index>"
			else
				name_by_ref[ref] = tostring(name)
			end
		end
	end

	local extra_lut = Widget.select_map(size_by_ref, function (k, v)
		return 0
	end)

	for k in pairs(snapshot_ignore) do
		extra_lut[k] = 0
	end

	for k in pairs(depth_by_reference) do
		if not track_size then
			extra_lut[k] = 0
		end
	end

	local target_depth = depth_by_reference[tbl]
	local handled = {}
	local children_by_ref = {}

	for depth = #references_at_depth, target_depth, -1 do
		local refs = references_at_depth[depth]

		for ref_i = 1, refs[0] do
			local ref = refs[ref_i]

			if track_size[ref] then
				if not size_by_ref[ref] then
					size_by_ref[ref] = LuaJIT.bytes(ref, true)
					one_layer_size[ref] = size_by_ref[ref]
				end

				children_by_ref[ref] = {}

				local children = ref

				if type(children) == "function" then
					local info = LuaJITUtils.funcinfo(children)
					local uvs = info.upvalues

					children = {}

					for i = 1, uvs do
						local _, v = debug.getupvalue(ref, i)

						children[i] = v
					end
				end

				for k, v in pairs(children) do
					if not snapshot_ignore[v] and not handled[v] then
						local child_depth = depth_by_reference[v]

						if child_depth and child_depth == depth + 1 then
							handled[v] = true

							table.insert(children_by_ref[ref], v)

							if not size_by_ref[v] then
								size_by_ref[v] = LuaJIT.bytes(v, true)
								one_layer_size[v] = size_by_ref[v]
							end

							size_by_ref[ref] = size_by_ref[ref] + size_by_ref[v]
						else
							local vt = type(v)

							if vt ~= "table" then
								size_by_ref[ref] = size_by_ref[ref] + LuaJIT.bytes(v, true)

								if vt == "function" then
									table.insert(children_by_ref[ref], v)
								else
									local child_size = vt == "string" and LuaJIT.bytes_ex(v, extra_lut) or LuaJIT.bytes(v, true)

									one_layer_size[ref] = one_layer_size[ref] + child_size
									size_by_ref[ref] = size_by_ref[ref] + child_size
								end
							end
						end
					end

					if not snapshot_ignore[k] and not handled[k] then
						local child_depth = depth_by_reference[k]

						if child_depth and child_depth == depth + 1 then
							handled[k] = true

							table.insert(children_by_ref[ref], k)

							if not size_by_ref[k] then
								size_by_ref[k] = LuaJIT.bytes(k, true)
								one_layer_size[k] = size_by_ref[k]
							end

							size_by_ref[ref] = size_by_ref[ref] + size_by_ref[k]
						else
							local kt = type(k)

							if kt ~= "table" then
								if kt == "function" then
									size_by_ref[ref] = size_by_ref[ref] + LuaJIT.bytes(k, true)

									table.insert(children_by_ref[ref], k)
								else
									local child_size = kt == "string" and LuaJIT.bytes_ex(k, extra_lut) or LuaJIT.bytes(k, true)

									one_layer_size[ref] = one_layer_size[ref] + child_size
									size_by_ref[ref] = size_by_ref[ref] + child_size
								end
							end
						end
					end
				end
			end
		end
	end

	local function sort_func(a, b)
		return (size_by_ref[a] or 0) > (size_by_ref[b] or 0)
	end

	for _, children in pairs(children_by_ref) do
		table.sort(children, sort_func)
	end

	for ign, name in pairs(snapshot_ignore) do
		-- Nothing
	end

	Deadlock.unpause()

	return children_by_ref, name_by_ref, size_by_ref, one_layer_size
end

local _pad_cache = {}

Widget.recursive_header = function (widget, tbl, children_by_ref, name_by_ref, size_by_ref, one_layer_size, name_length, depth)
	widget.num_headers = widget.num_headers + 1
	depth = depth or 1

	local left_padding = (depth - 1) * 10

	Imgui.dummy(left_padding, 0)
	Imgui.same_line()

	local right_padding = "\t\t"
	local header_name = string.format("%s%s (self: %sb)%s", Widget.pad_right(name_by_ref[tbl], name_length + 4, " ", _pad_cache), Widget.pad_right(Widget.chunk_from_right(tostring(size_by_ref[tbl]), 3, "'") .. "b", 15, " ", _pad_cache), Widget.chunk_from_right(tostring(one_layer_size[tbl]), 3, "'"), right_padding)

	if Imgui.collapsing_header(header_name, widget.remember_open[tbl]) then
		widget.remember_open[tbl] = true

		local children = children_by_ref[tbl]

		if not table.is_empty(children) then
			local _, longest_name_ref = Widget.max_func(children, function (ref)
				return #name_by_ref[ref]
			end)

			widget.memory_layout_name_max_size = math.clamp(#name_by_ref[longest_name_ref], widget.memory_layout_name_max_size, 125)

			for i = 1, #children do
				Widget.recursive_header(widget, children[i], children_by_ref, name_by_ref, size_by_ref, one_layer_size, widget.memory_layout_name_max_size, depth + 1)
			end

			Imgui.tree_pop()
		end
	else
		widget.remember_open[tbl] = false
	end
end

local function validate()
	local args = {
		Application.argv()
	}
	local memory_override_idx = table.find({
		Application.argv()
	}, "--lua-heap-mb-size")

	if not memory_override_idx or (tonumber(args[15]) or 0) < 2048 then
		return false, "[Not enough lua memory. Run the game with '--lua-heap-mb-size 2048' or more]"
	end

	if not LuaJIT then
		return false, "[LuaJIT is not available]"
	end

	return true
end

Widget.get_tbl = function (filter)
	local root = _G
	local indices = string.split(filter, ".")

	for i = 1, #indices do
		local index = indices[i]
		local success, filter_func = pcall(loadstring, "return root." .. index)

		if not success then
			return nil, filter_func
		elseif not filter_func then
			return nil, "invalid argument"
		end

		setfenv(filter_func, {
			root = root
		})

		success, root = pcall(filter_func)

		if type(root) == "function" then
			local info = LuaJITUtils.funcinfo(root)
			local new_root = {}
			local uvs = info.upvalues

			for uv_i = 1, uvs do
				local k, v = debug.getupvalue(root, uv_i)

				k = k == "" and "upvalue_" .. uv_i or k
				new_root[k] = v
			end

			root = new_root
		end

		if not success then
			return nil, root
		elseif not root then
			return nil, "filter " .. filter .. " not found"
		end
	end

	return root
end

Widget.render = function (widget)
	local root = _G

	Imgui.same_line()

	local valid, valid_error_msg = validate()

	if valid then
		if root then
			local button_label = widget.button_label

			if Imgui.button(button_label) then
				widget.snapshot_data = nil

				collectgarbage("collect")

				local name = root == _G and "_G" or widget.filter

				widget.snapshot_data = {
					root = root,
					Widget.grab_lua_memory_tree_snapshot(root, name)
				}
			end
		else
			Imgui.text_colored(filter_error_msg, 255, 0, 0, 255)
		end

		if widget.snapshot_data then
			local snapshot_root = widget.snapshot_data.root

			if not widget.window_initialized then
				local parent_pos_x, parent_pos_y = Imgui.get_window_pos()
				local parent_size_x = Imgui.get_window_size()

				Imgui.set_next_window_pos(parent_pos_x + parent_size_x, parent_pos_y)
				Imgui.set_next_window_size(0, 0)
			elseif widget.window_width or widget.window_height then
				Imgui.set_next_window_size(widget.window_width, widget.window_height)

				widget.window_width = nil
				widget.window_height = nil
			end

			local _, do_close = Imgui.begin_window("Memory Snapshot", "horizontal_scrollbar")

			if do_close then
				widget.snapshot_data = nil
				widget.window_initialized = nil
				widget.memory_layout_name_max_size = 0
			else
				widget.num_headers = 0

				local children, name_by_ref, size_by_ref, one_layer_size = unpack(widget.snapshot_data)

				widget.memory_layout_name_max_size = math.max(widget.memory_layout_name_max_size, #name_by_ref[snapshot_root])

				Widget.recursive_header(widget, snapshot_root, children, name_by_ref, size_by_ref, one_layer_size, widget.memory_layout_name_max_size)

				local w, h = Imgui.get_item_rect_size()

				h = h * widget.num_headers
				w = math.max(w, MIN_WIDTH)
				h = math.max(h, MIN_HEIGHT)

				local win_w, win_h = Imgui.get_window_size()

				if widget.window_initialized then
					local wanted_width = math.max(win_w, math.min(w, MAX_AUTO_WINDOW_WIDTH))
					local wanted_height = math.max(win_h, math.min(h, MAX_AUTO_WINDOW_HEIGHT))

					if win_w < wanted_width or win_h < wanted_height then
						widget.window_width = wanted_width
						widget.window_height = wanted_height
					end
				end

				widget.window_initialized = true
			end

			Imgui.end_window()
		end
	else
		Imgui.text_colored(valid_error_msg, 255, 0, 0, 255)
	end

	Imgui.dummy(0, 35)

	local is_focused = Imgui.is_item_focused()
	local is_active = false

	return is_focused, is_active
end

return Widget
