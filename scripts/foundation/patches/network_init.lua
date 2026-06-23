-- chunkname: @scripts/foundation/patches/network_init.lua

return function ()
	Network._is_active = false

	Network.is_active = function ()
		return Network._is_active
	end

	local init_steam_server = Network.init_steam_server

	if init_steam_server then
		Network.init_steam_server = function (...)
			local server = init_steam_server(...)

			if server then
				Network._is_active = true
			end

			return server
		end
	end

	local shutdown_steam_server = Network.shutdown_steam_server

	if shutdown_steam_server then
		Network.shutdown_steam_server = function (...)
			shutdown_steam_server(...)

			Network._is_active = false
		end
	end

	local init_steam_client = Network.init_steam_client

	if init_steam_client then
		Network.init_steam_client = function (...)
			local client = init_steam_client(...)

			if client then
				Network._is_active = true
			end

			return client
		end
	end

	local shutdown_steam_client = Network.shutdown_steam_client

	if shutdown_steam_client then
		Network.shutdown_steam_client = function (...)
			shutdown_steam_client(...)

			Network._is_active = false
		end
	end

	local init_lan_client = Network.init_lan_client

	if init_lan_client then
		Network.init_lan_client = function (...)
			local client = init_lan_client(...)

			if client then
				Network._is_active = true
			end

			return client
		end
	end

	local shutdown_lan_client = Network.shutdown_lan_client

	if shutdown_lan_client then
		Network.shutdown_lan_client = function (...)
			shutdown_lan_client(...)

			Network._is_active = false
		end
	end

	local init_wan_server = Network.init_wan_server

	if init_wan_server then
		Network.init_wan_server = function (...)
			local server = init_wan_server(...)

			if server then
				Network._is_active = true
			end

			return server
		end
	end

	local init_wan_client = Network.init_wan_client

	if init_wan_client then
		Network.init_wan_client = function (...)
			local client = init_wan_client(...)

			if client then
				Network._is_active = true
			end

			return client
		end
	end
end
