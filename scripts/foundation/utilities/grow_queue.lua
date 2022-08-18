local GrowQueue = class("GrowQueue")

GrowQueue.init = function (self)
	self.queue = {}
	self.first = 1
	self.last = 0
end

GrowQueue.push_back = function (self, item)
	self.last = self.last + 1
	self.queue[self.last] = item
end

GrowQueue.pop_first = function (self)
	if self.last < self.first then
		return
	end

	local item = self.queue[self.first]
	self.queue[self.first] = nil

	if self.first == self.last then
		self.first = 0
		self.last = 0
	end

	self.first = self.first + 1

	return item
end

GrowQueue.contains = function (self, item)
	local first = self.first
	local last = self.last
	local queue = self.queue

	for i = first, last do
		local queued_item = queue[i]

		if item == queued_item then
			return true
		end
	end

	return false
end

GrowQueue.size = function (self)
	return self.last - self.first + 1
end

GrowQueue.get_first = function (self)
	return self.queue[self.first]
end

GrowQueue.get_last = function (self)
	return self.queue[self._last]
end

GrowQueue.print_items = function (self, s)
	local s = (s or "") .. " queue: [" .. self.first .. "->" .. self.last .. "] --> "

	for i = self.first, self.last do
		s = s .. tostring(self.queue[i]) .. ","
	end

	print(s)
end

return GrowQueue
