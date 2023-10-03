local GRPCBatchedPresenceStream = class("GRPCBatchedPresenceStream")

local function _info(...)
	Log.info("GRPCBatchedPresenceStream", ...)
end

local function _error(...)
	Log.error("GRPCBatchedPresenceStream", ...)
end

GRPCBatchedPresenceStream.init = function (self, grpc_manager, operation_id, request_presence, abort_presence, get_presence)
	self._grpc_manager = grpc_manager
	self._operation_id = operation_id
	self._request_presence = request_presence
	self._abort_presence = abort_presence
	self._get_presence = get_presence
	self._alive = true
	self._error = nil
end

GRPCBatchedPresenceStream.destroy = function (self)
	self._grpc_manager = nil

	self:abort()
end

GRPCBatchedPresenceStream.get_presence = function (self, request_id)
	if self:alive() then
		return self._get_presence(self._operation_id, request_id)
	else
		return nil
	end
end

GRPCBatchedPresenceStream.request_presence = function (self, platform, platform_user_id)
	if self:alive() then
		return self._request_presence(self._operation_id, platform, platform_user_id)
	else
		return nil
	end
end

GRPCBatchedPresenceStream.abort_presence = function (self, request_id)
	if self:alive() then
		self._abort_presence(self._operation_id, request_id)
	end
end

GRPCBatchedPresenceStream.alive = function (self)
	return self._alive
end

GRPCBatchedPresenceStream._end = function (self, error)
	self._alive = false
	self._error = error
end

GRPCBatchedPresenceStream.completed = function (self)
	return not self:alive() and not self._error
end

GRPCBatchedPresenceStream.error = function (self)
	return self._error
end

GRPCBatchedPresenceStream.abort = function (self)
	self._grpc_manager:abort_operation(self._operation_id)
end

return GRPCBatchedPresenceStream
