-- chunkname: @scripts/managers/account/account_manager_steam.lua

local AccountManagerBase = require("scripts/managers/account/account_manager_base")
local RegionRestrictionsSteam = require("scripts/settings/region/region_restrictions_steam")
local AccountManagerSteam = class("AccountManagerSteam", "AccountManagerBase")

AccountManagerSteam.signin_profile = function (self, signin_callback)
	self:_setup_region()

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

AccountManagerSteam._setup_region = function (self)
	local country_code = Steam.user_country_code()

	country_code = country_code or "unknown"
	self._region_restrictions = RegionRestrictionsSteam[country_code] or {}
end

AccountManagerSteam.region_has_restriction = function (self, restriction)
	return not not self._region_restrictions[restriction]
end

return AccountManagerSteam
