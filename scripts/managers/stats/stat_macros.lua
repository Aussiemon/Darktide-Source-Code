-- chunkname: @scripts/managers/stats/stat_macros.lua

local StatMacros = {}

StatMacros.forward = function (self, stat_data, ...)
	return self.id, ...
end

StatMacros.increment = function (self, stat_data)
	local id = self.id

	stat_data[id] = (stat_data[id] or self.default) + 1

	return id, stat_data[id]
end

StatMacros.decrement = function (self, stat_data)
	local id = self.id

	stat_data[id] = (stat_data[id] or self.default) - 1

	return id, stat_data[id]
end

StatMacros.increment_by = function (self, stat_data, value)
	local id = self.id

	stat_data[id] = (stat_data[id] or self.default) + value

	return id, stat_data[id]
end

StatMacros.decrement_by = function (self, stat_data, value)
	local id = self.id

	stat_data[id] = (stat_data[id] or self.default) - value

	return id, stat_data[id]
end

StatMacros.set_to_max = function (self, stat_data, value)
	local id = self.id
	local current_value = stat_data[id] or self.default

	if current_value < value then
		stat_data[id] = value

		return id, value
	end
end

StatMacros.set_to_min = function (self, stat_data, value)
	local id = self.id
	local current_value = stat_data[id] or self.default

	if value < current_value then
		stat_data[id] = value

		return id, value
	end
end

StatMacros.set_flag = function (self, stat_data)
	local id = self.id

	if stat_data[id] == 1 then
		return
	end

	stat_data[id] = 1

	return id, 1
end

StatMacros.clear_flag = function (self, stat_data)
	local id = self.id

	if stat_data[id] == 0 then
		return
	end

	stat_data[id] = 0

	return id, 0
end

return StatMacros
