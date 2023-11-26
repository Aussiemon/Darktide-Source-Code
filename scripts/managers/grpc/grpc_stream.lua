-- chunkname: @scripts/managers/grpc/grpc_stream.lua

local Promise = require("scripts/foundation/utilities/promise")
local GRPCStream = class("GRPCStream")

local function _info(...)
	Log.info("GRPCStream", ...)
end

local function _error(...)
	Log.error("GRPCStream", ...)
end

local empty_list = {}

GRPCStream.init = function (self, grpc_manager, operation_id, stream_getter, stream_sender)
	self._grpc_manager = grpc_manager
	self._operation_id = operation_id
	self._stream_getter = stream_getter
	self._stream_sender = stream_sender
	self._alive = true
	self._error = nil
end

GRPCStream.destroy = function (self)
	self._grpc_manager = nil

	self:abort()
end

GRPCStream.get_stream_messages = function (self)
	if self:alive() then
		return self._stream_getter(self._operation_id)
	else
		return empty_list
	end
end

GRPCStream.send_stream_message = function (self, message)
	if self._stream_sender then
		return self._stream_sender(self._operation_id, message)
	else
		return false
	end
end

GRPCStream.alive = function (self)
	return self._alive
end

GRPCStream._end = function (self, error)
	self._alive = false
	self._error = error
end

GRPCStream.completed = function (self)
	return not self:alive() and not self._error
end

GRPCStream.error = function (self)
	return self._error
end

GRPCStream.abort = function (self)
	self._grpc_manager:abort_operation(self._operation_id)
end

return GRPCStream
