-- chunkname: @scripts/managers/privileges/privileges_manager_xbox_live.lua

local Promise = require("scripts/foundation/utilities/promise")
local PrivilegesManagerXboxLive = class("PrivilegesManagerXboxLive")

PrivilegesManagerXboxLive.init = function (self)
	return
end

PrivilegesManagerXboxLive.update = function (self, dt, t)
	return
end

PrivilegesManagerXboxLive.destroy = function (self)
	return
end

local function _get_xbox_privilege(privilege_name)
	local p = Promise:new()
	local has_privilege, deny_reason = Managers.account:get_privilege(privilege_name)

	p:resolve({
		has_privilege = has_privilege or false,
		deny_reason = deny_reason,
	})

	return p
end

PrivilegesManagerXboxLive.multiplayer_privilege = function (self, resolve_privilege)
	return _get_xbox_privilege(XUserPrivilege.Multiplayer)
end

PrivilegesManagerXboxLive.communications_privilege = function (self, resolve_privilege)
	return _get_xbox_privilege(XUserPrivilege.Communications)
end

PrivilegesManagerXboxLive.cross_play = function (self, resolve_privilege)
	return _get_xbox_privilege(XUserPrivilege.CrossPlay)
end

return PrivilegesManagerXboxLive
