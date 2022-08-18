local StatStorage = require("scripts/managers/stats/storage/stat_storage")
local StatTree = class("StatTree", "StatStorage")

StatTree.init = function (self, id, parameters, optional_default_value)
	StatTree.super.init(self, id, parameters)

	self._default_value = optional_default_value or 0
end

StatTree.set_value = function (self, stat_table, value, ...)
	local param_count = select("#", ...)
	local root = stat_table[self:get_id()] or {}
	local node = root

	for i = 1, param_count do
		local param_name = select(i, ...)

		if i == param_count then
			node[param_name] = value
		else
			node[param_name] = node[param_name] or {}
			node = node[param_name]
		end
	end

	stat_table[self:get_id()] = root
end

StatTree.get_value = function (self, stat_table, ...)
	local param_count = select("#", ...)
	local node = stat_table[self:get_id()]

	for i = 1, param_count do
		if not node then
			return self._default_value
		end

		node = node[select(i, ...)]
	end

	return node or self._default_value
end

implements(StatTree, StatStorage.INTERFACE)

return StatTree
