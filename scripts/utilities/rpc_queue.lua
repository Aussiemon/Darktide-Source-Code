-- chunkname: @scripts/utilities/rpc_queue.lua

local RPCQueue = class("RPCQueue")
local REMAINING_BUFFER_SIZE_MINIMUM = 8000

RPCQueue.init = function (self, channel_id, settings)
	self._queue = {}
	self._num_rpcs_per_send = settings.num_rpcs_per_send or 1
	self._time_between_sends = settings.time_between_sends or 0

	local max_rpcs = settings.max_rpcs

	for i = 1, max_rpcs do
		self._queue[i] = {
			name = nil,
			args = {},
		}
	end

	self._channel_id = channel_id
	self._queue_index = 1
	self._send_timer = 0
	self._send_index = 1
end

RPCQueue.update = function (self, dt)
	if self._send_timer <= 0 then
		for i = 1, self._num_rpcs_per_send do
			if self:_can_send_next_rpc() then
				self:_send_next_rpc()
			end
		end

		self._send_timer = self._time_between_sends
	end

	self._send_timer = self._send_timer - dt
end

RPCQueue._can_send_next_rpc = function (self)
	local channel_id = self._channel_id
	local peer_id = Network.peer_id(channel_id)
	local remaining_buffer_size = Network.reliable_send_buffer_left(peer_id)

	if remaining_buffer_size < REMAINING_BUFFER_SIZE_MINIMUM then
		return false
	end

	local next_index = self._send_index
	local rpc = self._queue[next_index]
	local rpc_name = rpc.name

	if not rpc_name then
		return false
	end

	return true
end

RPCQueue._send_next_rpc = function (self)
	local channel_id = self._channel_id
	local index = self._send_index
	local rpc = self._queue[index]
	local rpc_name = rpc.name
	local args = rpc.args

	RPC[rpc_name](channel_id, unpack(args))

	rpc.name = nil

	table.clear(rpc.args)

	self._send_index = index + 1

	if self._send_index > #self._queue then
		self._send_index = 1
	end

	return index
end

RPCQueue.queue_rpc = function (self, rpc_name, ...)
	local index = self._queue_index
	local rpc = self._queue[index]

	rpc.name = rpc_name

	local num_args = select("#", ...)

	for i = 1, num_args do
		local arg = select(i, ...)

		rpc.args[i] = arg
	end

	self._queue_index = index + 1

	if self._queue_index > #self._queue then
		self._queue_index = 1
	end
end

RPCQueue.destroy = function (self)
	self._queue = nil
end

return RPCQueue
