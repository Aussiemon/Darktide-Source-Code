-- chunkname: @scripts/boot_init.lua

if jit then
	jit.off()
end

if not LEVEL_EDITOR_TEST then
	LEVEL_EDITOR_TEST = false
end

if not EDITOR then
	EDITOR = false
end

local function import(lib)
	for k, v in pairs(lib) do
		_G[k] = v
	end
end

if s3d and not LIBRARIES_IMPORTED then
	import(s3d)

	LIBRARIES_IMPORTED = true
end

if cjson.stingray_init then
	cjson = cjson.stingray_init()
end

if not ENGINE_FUNCTIONS_OVERRIDDEN then
	APPLICATION_SETTINGS = Application.settings()
	BUILD = Application.build()
	BUILD_IDENTIFIER = Application.build_identifier()
	PLATFORM = Application.platform()
	IS_XBS = PLATFORM == "xbs"
	IS_PLAYSTATION = PLATFORM == "ps5"
	IS_WINDOWS = PLATFORM == "win32"
	IS_GDK = Backend.get_auth_method() == Backend.AUTH_METHOD_XBOXLIVE and IS_WINDOWS

	if PLATFORM == "win32_server" then
		PLATFORM = "win32"
	end

	if PLATFORM == "linux_server" then
		PLATFORM = "linux"
	end

	Application.settings = function ()
		error("Trying to use Application.settings, use global variable APPLICATION_SETTINGS instead.")
	end

	Application.build = function ()
		error("Trying to use Application.build, use global variable BUILD instead.")
	end

	Application.build_identifier = function ()
		error("Trying to use Application.build_identifier(), use global variable BUILD_IDENTIFIER instead.")

		return BUILD_IDENTIFIER
	end

	Application.platform = function ()
		error("Trying to use Application.platform(), use global variable PLATFORM instead.")
	end

	lua_math = {}

	for f_name, f in pairs(math) do
		lua_math[f_name] = f
	end

	local function err()
		error("Use 'math' instead of 'Math'")
	end

	for f_name, f in pairs(Math) do
		math[f_name] = f
		Math[f_name] = err
	end

	ENGINE_FUNCTIONS_OVERRIDDEN = true
end

HAS_STEAM = rawget(_G, "Steam") and true or false
DEDICATED_SERVER = Application.is_dedicated_server()
CLASSES = CLASSES or {}
SETTINGS = SETTINGS or {}

local valid

valid, LOCAL_CONTENT_REVISION = pcall(require, "scripts/optional/content_revision")

if not valid then
	LOCAL_CONTENT_REVISION = "Unknown"
end

if not NETWORK_INIT_WRAPPED then
	NETWORK_INIT_WRAPPED = true
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
