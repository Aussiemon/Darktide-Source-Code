-- chunkname: @scripts/managers/loading/package_synchronization_manager.lua

local PackageSynchronizerHost = require("scripts/loading/package_synchronizer_host")
local PackageSynchronizerClient = require("scripts/loading/package_synchronizer_client")
local PackageSynchronizationManager = class("PackageSynchronizationManager")

PackageSynchronizationManager.init = function (self)
	self._peer_id = nil
	self._package_synchronizer_client = nil
	self._package_synchronizer_host = nil
end

PackageSynchronizationManager.destroy = function (self)
	self:cleanup()
end

PackageSynchronizationManager.update = function (self, dt)
	local package_synchronizer_host = self._package_synchronizer_host

	if package_synchronizer_host then
		package_synchronizer_host:update(dt)
	end

	local package_synchronizer_client = self._package_synchronizer_client

	if package_synchronizer_client then
		package_synchronizer_client:update(dt, package_synchronizer_host)
	end
end

PackageSynchronizationManager.create_synchronizer_host_and_client = function (self)
	self:cleanup()

	self._peer_id = Network.peer_id()

	local network_delegate = Managers.connection:network_event_delegate()
	local is_host = true
	local host_channel_id

	self._package_synchronizer_client = PackageSynchronizerClient:new(self._peer_id, is_host, network_delegate, host_channel_id)
	self._package_synchronizer_host = PackageSynchronizerHost:new(network_delegate, self._package_synchronizer_client)

	return self._package_synchronizer_host, self._package_synchronizer_client
end

PackageSynchronizationManager.is_ready = function (self)
	if not self._package_synchronizer_host and not self._package_synchronizer_client then
		return false
	end

	if self._package_synchronizer_host and not self._package_synchronizer_host:item_definitions_initialized() then
		return false
	end

	if self._package_synchronizer_client and not self._package_synchronizer_client:item_definitions_initialized() then
		return false
	end

	return true
end

PackageSynchronizationManager.synchronizer_host = function (self)
	return self._package_synchronizer_host
end

PackageSynchronizationManager.create_synchronizer_client = function (self, is_host, host_channel_id)
	self:cleanup()

	self._peer_id = Network.peer_id()

	local network_delegate = Managers.connection:network_event_delegate()

	self._package_synchronizer_client = PackageSynchronizerClient:new(self._peer_id, is_host, network_delegate, host_channel_id)

	return self._package_synchronizer_client
end

PackageSynchronizationManager.synchronizer_client = function (self)
	return self._package_synchronizer_client
end

PackageSynchronizationManager.cleanup = function (self)
	if self._package_synchronizer_host then
		self._package_synchronizer_host:delete()

		self._package_synchronizer_host = nil
	end

	if self._package_synchronizer_client then
		self._package_synchronizer_client:delete()

		self._package_synchronizer_client = nil
	end
end

return PackageSynchronizationManager
