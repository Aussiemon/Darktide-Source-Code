-- chunkname: @scripts/game_states/boot/boot_state_set_globals.lua

require("scripts/game_states/boot/state_boot_sub_state_base")

local BootStateSetGlobals = class("BootStateSetGlobals", "StateBootSubStateBase")

local function get_auth_platform(auth_method)
	if auth_method == Backend.AUTH_METHOD_STEAM and HAS_STEAM then
		return "steam"
	elseif auth_method == Backend.AUTH_METHOD_XBOXLIVE and IS_WINDOWS then
		return "xbox"
	elseif auth_method == Backend.AUTH_METHOD_XBOXLIVE and Application.xbox_live and Application.xbox_live() == true then
		return "xbox"
	elseif auth_method == Backend.AUTH_METHOD_PSN then
		return "psn"
	end

	Log.warning("BootStateSetGlobals", "Could not resolve a platform for auth_method: " .. tostring(auth_method))

	return "unknown"
end

BootStateSetGlobals._state_update = function (self, dt)
	rawset(_G, "APPLICATION_SETTINGS", Application.settings())
	rawset(_G, "BUILD", Application.build())
	rawset(_G, "BUILD_IDENTIFIER", Application.build_identifier())
	rawset(_G, "IS_TEAMCITY_BUILD", APPLICATION_SETTINGS.teamcity_build_id and APPLICATION_SETTINGS.teamcity_build_id ~= "")
	rawset(_G, "HAS_STEAM", not not rawget(_G, "Steam"))
	rawset(_G, "IS_MODDED", not not rawget(_G, "Mods"))
	rawset(_G, "PLATFORM", Application.platform())
	rawset(_G, "AUTH_METHOD", Backend.get_auth_method())
	rawset(_G, "IS_XBS", PLATFORM == "xbs")
	rawset(_G, "IS_PLAYSTATION", PLATFORM == "ps5")
	rawset(_G, "IS_WINDOWS", PLATFORM == "win32")
	rawset(_G, "IS_GDK", IS_WINDOWS and AUTH_METHOD == Backend.AUTH_METHOD_XBOXLIVE)
	rawset(_G, "AUTH_PLATFORM", get_auth_platform(AUTH_METHOD))
	rawset(_G, "EDITOR", not not EDITOR)
	rawset(_G, "LEVEL_EDITOR_TEST", not not LEVEL_EDITOR_TEST)
	rawset(_G, "IS_FILESERVER_CLIENT", Application.file_client() ~= nil)
	rawset(_G, "DEDICATED_SERVER", Application.is_dedicated_server())
	rawset(_G, "VIRTUAL_MACHINE", Application.is_virtual_machine())

	return true
end

return BootStateSetGlobals
