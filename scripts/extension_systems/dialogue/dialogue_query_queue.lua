-- chunkname: @scripts/extension_systems/dialogue/dialogue_query_queue.lua

local DialogueQueryQueue = class("DialogueQueryQueue")

DialogueQueryQueue.init = function (self)
	self._input_query_queue = {}
	self._input_query_queue_n = 0
end

DialogueQueryQueue.get_query = function (self, t)
	local found_time = math.huge
	local answer_query

	for query_time, query in pairs(self._input_query_queue) do
		if query_time < t and query_time < found_time then
			found_time = query_time
			answer_query = query
		end
	end

	if answer_query then
		self._input_query_queue[found_time] = nil

		return answer_query
	end

	return nil
end

DialogueQueryQueue.queue_query = function (self, target_time, query)
	self._input_query_queue[target_time] = query
end

return DialogueQueryQueue
