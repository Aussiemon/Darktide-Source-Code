-- chunkname: @scripts/managers/privileges/privileges_manager_psn.lua

local Promise = require("scripts/foundation/utilities/promise")
local PrivilegesManagerPSN = class("PrivilegesManagerPSN")

PrivilegesManagerPSN.init = function (self)
	return
end

PrivilegesManagerPSN.update = function (self, dt, t)
	return
end

PrivilegesManagerPSN.destroy = function (self)
	return
end

PrivilegesManagerPSN.multiplayer_privilege = function (self, resolve_privilege)
	local p = Promise:new()

	p:resolve({
		has_privilege = true,
	})

	return p
end

PrivilegesManagerPSN.communications_privilege = function (self, resolve_privilege)
	local restriction = Managers.account:user_has_restriction()
	local p = Promise:new()

	p:resolve({
		has_privilege = not restriction,
	})

	return p
end

PrivilegesManagerPSN.cross_play = function (self, resolve_privilege)
	local restriction = Managers.account:has_crossplay_restriction()
	local p = Promise:new()

	p:resolve({
		has_privilege = not restriction,
	})

	return p
end

return PrivilegesManagerPSN
