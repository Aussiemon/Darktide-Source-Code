-- chunkname: @scripts/managers/account/account_manager_steam.lua

local AccountManagerBase = require("scripts/managers/account/account_manager_base")
local AccountManagerSteam = class("AccountManagerSteam", "AccountManagerBase")

AccountManagerSteam.signin_profile = function (self, signin_callback)
	if signin_callback then
		signin_callback()
	end
end

AccountManagerSteam.user_display_name = function (self)
	return Steam.user_name()
end

AccountManagerSteam.platform_user_id = function (self)
	return Steam.user_id()
end

return AccountManagerSteam
