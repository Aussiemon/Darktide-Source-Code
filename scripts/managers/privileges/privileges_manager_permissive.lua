local Promise = require("scripts/foundation/utilities/promise")
local PERMISSIVE_RESPONSE = {
	has_privilege = true
}
local PrivilegesManagerPermissive = class("PrivilegesManagerPermissive")

PrivilegesManagerPermissive.init = function (self)
	return
end

PrivilegesManagerPermissive.multiplayer_privilege = function (self, resolve_privilege)
	local p = Promise:new()

	p:resolve(PERMISSIVE_RESPONSE)

	return p
end

PrivilegesManagerPermissive.communications_privilege = function (self, resolve_privilege)
	local p = Promise:new()

	p:resolve(PERMISSIVE_RESPONSE)

	return p
end

PrivilegesManagerPermissive.cross_play = function (self, resolve_privilege)
	local p = Promise:new()

	p:resolve(PERMISSIVE_RESPONSE)

	return p
end

PrivilegesManagerPermissive.update = function (self, dt, t)
	return
end

return PrivilegesManagerPermissive
