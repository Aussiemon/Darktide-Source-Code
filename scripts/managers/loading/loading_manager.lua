-- chunkname: @scripts/managers/loading/loading_manager.lua

local Missions = require("scripts/settings/mission/mission_templates")
local LoadingManager = class("LoadingManager")

LoadingManager.init = function (self)
	self._loading_client = nil
	self._loading_host = nil
	self._shelved_clients_loaders = {}

	Managers.event:register(self, "on_suspend", "_on_suspend")
end

LoadingManager.destroy = function (self)
	Managers.event:unregister(self, "on_suspend")
	self:cleanup()
	self:_cleanup_shelved_loaders()
end

LoadingManager._cleanup_shelved_loaders = function (self)
	local shelved_clients_loaders = self._shelved_clients_loaders

	if shelved_clients_loaders then
		for i = 1, #shelved_clients_loaders do
			local clients_loaders = shelved_clients_loaders[i]

			for _, loader in ipairs(clients_loaders) do
				if not loader:dont_destroy() then
					loader:cleanup()
					loader:delete()
				end
			end

			Log.info("LoadingManager", "Deleting shelved loading client")
		end

		table.clear(shelved_clients_loaders)
	end
end

LoadingManager.update = function (self, dt)
	if self._loading_client then
		self._loading_client:update(dt)
	end

	if self._loading_host then
		self._loading_host:update(dt)
	end
end

LoadingManager.cleanup = function (self)
	if self._loading_client then
		self:_shelve_loaders()
		self._loading_client:delete()

		self._loading_client = nil
	end

	if self._loading_host then
		self._loading_host:delete()

		self._loading_host = nil
	end
end

LoadingManager._shelve_loaders = function (self)
	local loading_client = self._loading_client
	local loaders = self._shelved_clients_loaders

	loaders[#loaders + 1] = loading_client:take_ownership_of_loaders()
end

LoadingManager.is_alive = function (self)
	return self._loading_client ~= nil or self._loading_host ~= nil
end

LoadingManager.is_client = function (self)
	return self._loading_client ~= nil
end

LoadingManager.is_host = function (self)
	return self._loading_host ~= nil
end

LoadingManager.set_client = function (self, loading_client)
	self:cleanup()

	self._loading_client = loading_client
end

LoadingManager.set_host = function (self, loading_host)
	self:cleanup()

	self._loading_host = loading_host
end

LoadingManager.failed = function (self)
	return self._loading_client:state() == "failed"
end

LoadingManager.add_client = function (self, channel_id)
	self._loading_host:add(channel_id)
end

LoadingManager.remove_client = function (self, channel_id)
	self._loading_host:remove(channel_id)
end

LoadingManager.failed_clients = function (self, failed_clients)
	self._loading_host:failed(failed_clients)
end

LoadingManager.load_mission = function (self, loading_context)
	if self._loading_host then
		self:_cleanup_shelved_loaders()
		self._loading_host:load_mission(loading_context)
	end

	if self._loading_client then
		self:_cleanup_shelved_loaders()
		self._loading_client:load_mission(loading_context)
	end
end

LoadingManager.stop_load_mission = function (self)
	if self._loading_host then
		self._loading_host:stop_load_mission()
	end

	if self._loading_client then
		self._loading_client:stop_load_mission()
	end
end

LoadingManager.no_level_needed = function (self)
	if self._loading_client then
		self._loading_client:no_level_needed()
	end
end

LoadingManager.load_finished = function (self)
	if self._loading_host then
		return self._loading_host:first_group_ready()
	elseif self._loading_client then
		return self._loading_client:load_finished()
	end
end

LoadingManager.end_load = function (self)
	self._loading_host:end_load()
end

LoadingManager.take_ownership_of_level = function (self)
	if self._loading_host then
		return self._loading_host:take_ownership_of_level()
	end

	if self._loading_client then
		return self._loading_client:take_ownership_of_level()
	end
end

LoadingManager.mission = function (self)
	if self._loading_host then
		return self._loading_host:mission()
	end

	if self._loading_client then
		return self._loading_client:mission()
	end
end

LoadingManager.spawn_group_id = function (self)
	if self._loading_client then
		return self._loading_client:spawn_group()
	end

	return nil
end

LoadingManager._on_suspend = function (self)
	self:cleanup()
end

return LoadingManager
