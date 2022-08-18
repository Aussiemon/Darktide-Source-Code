-- Decompilation Error: _glue_flows(node)

local MasterItems = require("scripts/backend/master_items")
local RPCS = {
	"rpc_master_items_version_reply"
}
local LocalMasterItemsCheckState = class("LocalMasterItemsCheckState")

LocalMasterItemsCheckState.init = function (self, state_machine, shared_state)
	assert(type(shared_state.event_delegate) == "table", "Event delegate required")
	assert(type(shared_state.channel_id) == "number", "Numeric channel id required")
	assert(type(shared_state.timeout) == "number", "Numeric timeout required")

	self._shared_state = shared_state
	self._time = 0
	self._items_ready = false
	self._items_promise = nil
	self._items_update_failed = false

	RPC.rpc_request_master_items_version(shared_state.channel_id)
	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))
end

LocalMasterItemsCheckState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))

	if self._items_promise then
		self._items_promise:cancel()

		self._items_promise = nil
	end
end

LocalMasterItemsCheckState.update = function (self, dt)
	local shared_state = self._shared_state
	self._time = self._time + dt

	if shared_state.timeout < self._time then
		Log.info("LocalMasterItemsCheckState", "Timeout waiting for rpc_master_items_version_reply")

		return "timeout", {
			game_reason = "timeout"
		}
	end

	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnected" then
		Log.info("LocalMasterItemsCheckState", "Connection channel disconnected")

		return "disconnected", {
			engine_reason = reason
		}
	end

	if self._items_update_failed then
		return "update failed", {
			game_reason = "master_item_update_failed"
		}
	end

	if self._items_ready then
		return "items ready"
	end
end

LocalMasterItemsCheckState.rpc_master_items_version_reply = function (self, channel_id, host_items_version, host_items_url)
	local local_items_version = tostring(MasterItems.get_cached_version())

	if local_items_version == host_items_version then
		Log.info("LocalMasterItemsCheckState", "Host items version %s matches local version", host_items_version)

		self._items_ready = true
	else
		Log.info("LocalMasterItemsCheckState", "Items version diff, host: %s, local: %s", host_items_version, local_items_version)
		self:_update_master_items(host_items_version, host_items_url)
	end
end

LocalMasterItemsCheckState._update_master_items = function (self, version, url)
	Log.info("LocalMasterItemsCheckState", "Updating master items to host version %s, %s", version, url)

	self._items_promise = MasterItems.get_by_url(version, url)

	self._items_promise:next(function ()
		self._items_promise = nil
		self._items_ready = true

		Log.info("LocalMasterItemsCheckState", "Master items updated")
	end):catch(function (err)
		self._items_promise = nil
		self._items_update_failed = true

		Log.info("LocalMasterItemsCheckState", "Failed updating master items: %s", table.tostring(err))
	end)
end

return LocalMasterItemsCheckState
