local Missions = require("scripts/settings/mission/mission_templates")
local LoadingManager = class("LoadingManager")

LoadingManager.init = function (self)
	self._loading_client = nil
	self._loading_host = nil
	self._shelved_loading_clients = {}
end

LoadingManager.destroy = function (self)
	self:cleanup()
	self:_cleanup_shelved_loading_clients()
end

LoadingManager._cleanup_shelved_loading_clients = function (self)
	local loading_clients = self._shelved_loading_clients

	for i = 1, #loading_clients do
		local loading_client = loading_clients[i]

		loading_client:delete()
		Log.info("LoadingManager", "Deleting shelved loading client")
	end

	table.clear(loading_clients)
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
		self:_shelve_loading_client()

		self._loading_client = nil
	end

	if self._loading_host then
		self._loading_host:delete()

		self._loading_host = nil
	end
end

LoadingManager._shelve_loading_client = function (self)
	local loading_client = self._loading_client
	local loading_clients = self._shelved_loading_clients
	loading_clients[#loading_clients + 1] = loading_client
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

LoadingManager.load_mission = function (self, mission_name, level_name, circumstance_name)
	if mission_name then
		level_name = level_name or Missions[mission_name].level
	end

	if self._loading_host then
		self:_cleanup_shelved_loading_clients()
		self._loading_host:load_mission(mission_name, level_name, circumstance_name)
	end

	if self._loading_client then
		self:_cleanup_shelved_loading_clients()
		self._loading_client:load_mission(mission_name, level_name, circumstance_name)
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

return LoadingManager
