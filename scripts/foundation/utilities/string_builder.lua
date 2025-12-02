-- chunkname: @scripts/foundation/utilities/string_builder.lua

local StringBuilder = class("StringBuilder")

StringBuilder.init = function (self)
	self._length = 0
	self[1] = ""
end

StringBuilder.close = function (self)
	return
end

StringBuilder.flush = function (self)
	if self._length > 1 then
		local str = table.concat(self, "", 1, self._length)

		table.clear(self)

		self._length = 1
		self[1] = str
	end
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
	self[self._length + 1] = string.format(...)
	self._length = self._length + 1
end

StringBuilder.tostring = function (self)
	self:flush()

	return self[1]
end

return StringBuilder
