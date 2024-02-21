local DialogueQueryQueue = class("DialogueQueryQueue")
local ESTIMATED_MAX_SIZE = 16

DialogueQueryQueue.init = function (self)
	self._input_query_queue = Script.new_map(ESTIMATED_MAX_SIZE)
end

DialogueQueryQueue.get_query = function (self, t)
	local found_time = math.huge
	local found_query = nil

	for query, query_time in pairs(self._input_query_queue) do
		if query_time < t and query_time < found_time then
			found_time = query_time
			found_query = query
		end
	end

	if found_query then
		self._input_query_queue[found_query] = nil

		return found_query
	end

	return nil
end

DialogueQueryQueue.queue_query = function (self, target_time, query)
	self._input_query_queue[query] = target_time
end

return DialogueQueryQueue
