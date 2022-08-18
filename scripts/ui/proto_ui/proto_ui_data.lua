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
		offset_stack[val] = ProtoUI.offset
		ProtoUI.offset = ProtoUI.transform_position(pos, ProtoUI.scale, ProtoUI.offset)
	end

	if size then
		size_lookup[val] = size
	end

	return val
end

ProtoUI.end_group = function (idx)
	assert(ProtoUI.data_node.__parent__, "end_group: No group was currently open")

	local val = ProtoUI.data_node
	ProtoUI.data_node = val.__parent__
	local prev_offset = offset_stack[val]

	if prev_offset then
		ProtoUI.offset = prev_offset
		offset_stack[val] = nil
	end

	size_lookup[val] = nil
end
