-- chunkname: @scripts/foundation/utilities/string_builder.lua

local StringBuilder = class("StringBuilder")

StringBuilder.init = function (self)
	self:reset()
end

StringBuilder.reset = function (self)
	table.clear(self)

	self._length = 0
	self[1] = ""
end

StringBuilder.close = function (self)
	return
end

StringBuilder.flush = function (self)
	return
end

StringBuilder.write = function (self, ...)
	local num_args = select("#", ...)
	local length = self._length

	for i = 1, num_args do
		self[length + i] = tostring((select(i, ...)))
	end

	self._length = length + num_args
end

StringBuilder.format = function (self, ...)
	local new_length = self._length + 1

	self[new_length] = string.format(...)
	self._length = new_length
end

StringBuilder.tostring = function (self)
	if self._length > 1 then
		local str = table.concat(self, "", 1, self._length)

		table.clear(self)

		self._length = 1
		self[1] = str
	end

	return self[1]
end

return StringBuilder
