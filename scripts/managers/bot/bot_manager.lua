-- chunkname: @scripts/managers/bot/bot_manager.lua

local BotSynchronizerHost = require("scripts/bot/bot_synchronizer_host")
local BotSynchronizerClient = require("scripts/bot/bot_synchronizer_client")
local BotManagerTestify = GameParameters.testify and require("scripts/managers/bot/bot_manager_testify")
local BotManager = class("BotManager")

BotManager.init = function (self)
	self._bot_synchronizer_client = nil
	self._bot_synchronizer_host = nil
end

BotManager.destroy = function (self)
	self:_cleanup()
end

BotManager.update = function (self, dt)
	if self._bot_synchronizer_host then
		self._bot_synchronizer_host:update(dt)
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(BotManagerTestify, self)
	end
end

BotManager.post_update = function (self, dt, t)
	if self._bot_synchronizer_host then
		self._bot_synchronizer_host:handle_queued_bot_removals()
	end
end

BotManager.create_synchronizer_host = function (self)
	self:_cleanup()

	local network_delegate = Managers.connection:network_event_delegate()

	self._bot_synchronizer_host = BotSynchronizerHost:new(network_delegate)

	return self._bot_synchronizer_host
end

BotManager.synchronizer_host = function (self)
	return self._bot_synchronizer_host
end

BotManager.create_synchronizer_client = function (self, host_channel_id)
	self:_cleanup()

	local peer_id = Network.peer_id()
	local network_delegate = Managers.connection:network_event_delegate()

	self._bot_synchronizer_client = BotSynchronizerClient:new(peer_id, network_delegate, host_channel_id)

	return self._bot_synchronizer_client
end

BotManager.synchronizer_client = function (self)
	return self._bot_synchronizer_client
end

BotManager._cleanup = function (self)
	if self._bot_synchronizer_host then
		self._bot_synchronizer_host:delete()

		self._bot_synchronizer_host = nil
	end

	if self._bot_synchronizer_client then
		self._bot_synchronizer_client:delete()

		self._bot_synchronizer_client = nil
	end
end

return BotManager
