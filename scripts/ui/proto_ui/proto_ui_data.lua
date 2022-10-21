local ProtoUI = require("scripts/ui/proto_ui/proto_ui")

ProtoUI._INTERNAL_reset_data_tree = function ()
	ProtoUI.data_node = {
		__parent__ = false
	}
	ProtoUI.DATA_ROOT = ProtoUI.data_node
end

if not ProtoUI.DATA_ROOT then
	ProtoUI._INTERNAL_reset_data_tree()
end

local function ID(x)
	return x
end

local function TNEW()
	return {}
end

ProtoUI.make_data = function (idx, default, factory)
	local val = ProtoUI.data_node[idx]

	if val then
		return val
	end

	val = factory or default and ID or TNEW(default)
	ProtoUI.data_node[idx] = val

	return val, true
end

ProtoUI.get_data = function (idx)
	return ProtoUI.data_node[idx]
end

ProtoUI.set_data = function (idx, value)
	ProtoUI.data_node[idx] = value
end

local function INTERNAL_use_data_continuation(tab, key, new_value, ...)
	tab[key] = new_value

	return new_value, ...
end

ProtoUI.use_data = function (idx, func, ...)
	local node = ProtoUI.data_node

	return INTERNAL_use_data_continuation(node, idx, func(node[idx], ...))
end

local offset_stack = {}
local offset_stack_n = 0
local size_lookup = {}

ProtoUI.begin_group = function (idx, pos, size)
	local val = ProtoUI.data_node[idx]

	if not val then
		val = {
			__parent__ = ProtoUI.data_node
		}
		ProtoUI.data_node[idx] = val
	end

	ProtoUI.data_node = val

	if pos then
		offset_stack_n = offset_stack_n + 1
		offset_stack[offset_stack_n] = ProtoUI.offset
		ProtoUI.offset = ProtoUI.transform_position(pos, ProtoUI.scale, ProtoUI.offset)
	end

	if size then
		size_lookup[val] = size
	end

	return val
end

ProtoUI.end_group = function (idx)
	local val = ProtoUI.data_node
	ProtoUI.data_node = val.__parent__
	local prev_offset = offset_stack[offset_stack_n]

	if prev_offset then
		ProtoUI.offset = prev_offset
		offset_stack[offset_stack_n] = nil
		offset_stack_n = offset_stack_n - 1
	end

	size_lookup[val] = nil
end

ProtoUI.group_size = function ()
	return size_lookup[ProtoUI.data_node]
end
