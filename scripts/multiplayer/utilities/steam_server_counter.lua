-- chunkname: @scripts/multiplayer/utilities/steam_server_counter.lua

local SteamServerCounter = class("SteamServerCounter")

local function _info(...)
	Log.info("SteamServerCounter", ...)
end

local STATES = table.enum("idle", "searching", "fetching_data", "reserving", "joining", "result")

SteamServerCounter.init = function (self, steam_client, options)
	self:_validate_options(options)

	self._steam_client = steam_client
	self._network_hash = options.network_hash
	self._use_eac = options.use_eac
	self._mission_id = options.mission_id
	self._host_type = options.host_type
	self._state = STATES.idle
	self._server_browser = SteamClient.create_server_browser(steam_client)

	local server_filters = {
		dedicated = "true",
		secure = "notused",
		notfull = "notused",
		gamedir = GameParameters.gamedir
	}

	SteamServerBrowser.add_filter(self._server_browser, server_filters)

	self._num_servers = 0
	self._num_verified_servers = 0
	self._server_info = nil

	local search_type = "internet"

	self:start_searching(search_type)
end

SteamServerCounter.destroy = function (self)
	SteamClient.destroy_server_browser(self._steam_client, self._server_browser)
end

SteamServerCounter.update = function (self, dt)
	local state = self._state

	if state == STATES.searching then
		local browser = self._server_browser

		if not SteamServerBrowser.is_refreshing(browser) then
			self._num_servers = SteamServerBrowser.num_servers(browser)
			self._lobby_join_index = 0

			self:_process_next()
		end
	elseif state == STATES.fetching_data then
		local is_fetching, has_failed = SteamServerBrowser.is_fetching_data(self._server_browser, self._lobby_join_index)

		if not is_fetching then
			local server_name = self._server_info.name

			if has_failed then
				_info("lobby data failed for %s", server_name)
				self:_process_next()
			else
				local network_hash = SteamServerBrowser.data(self._server_browser, self._lobby_join_index, "network_hash")
				local mission_id = SteamServerBrowser.data(self._server_browser, self._lobby_join_index, "mission_id")
				local host_type = SteamServerBrowser.data(self._server_browser, self._lobby_join_index, "host_type")

				if network_hash ~= self._network_hash then
					_info("network hash mismatch %s ~= %s for %s", network_hash, self._network_hash, server_name)
					self:_process_next()
				elseif host_type ~= self._host_type then
					_info("host_type mismatch %s ~= %s for %s", host_type, self._host_type, server_name)
					self:_process_next()
				elseif self._mission_id and self._mission_id ~= mission_id then
					_info("mission ID mismatch %s ~= %s for %s", mission_id, self._mission_id, server_name)
					self:_process_next()
				else
					local server_info = self._server_info
					local num_verified_servers = self._num_verified_servers + 1

					self._num_verified_servers = num_verified_servers

					self:_process_next()
				end
			end
		end
	end
end

SteamServerCounter.start_searching = function (self, search_type)
	_info("Searching for %s servers...", search_type)

	local browser = self._server_browser

	SteamServerBrowser.refresh(browser, search_type)

	self._state = STATES.searching
end

SteamServerCounter.result = function (self)
	if self._state ~= STATES.result then
		return false, nil
	end

	local num_verified_servers = self._num_verified_servers

	return true, num_verified_servers
end

SteamServerCounter._validate_options = function (self, options)
	return
end

SteamServerCounter._process_next = function (self)
	while true do
		self._lobby_join_index = self._lobby_join_index + 1

		if self._lobby_join_index > self._num_servers then
			_info("no more results, search finished.")

			self._state = STATES.result

			break
		else
			local info = SteamServerBrowser.server(self._server_browser, self._lobby_join_index)

			self._server_info = info

			SteamServerBrowser.request_data(self._server_browser, self._lobby_join_index)

			self._state = STATES.fetching_data

			_info("Server %s (%s) playing map %s at %s:%d", info.name, info.game_description, info.map, info.ip_address, info.query_port)
			_info("fetching data")

			break
		end
	end
end

return SteamServerCounter
