-- chunkname: @scripts/managers/privileges/privileges_manager.lua

local Interface = {
	"multiplayer_privilege",
	"communications_privilege",
	"cross_play",
	"update"
}
local PrivilegesManager = {}

PrivilegesManager.new = function (self)
	local instance

	if IS_XBS or IS_GDK then
		instance = require("scripts/managers/privileges/privileges_manager_xbox_live"):new()

		Log.info("PrivilegesManager", "Using Xbox Live privileges manager")
	elseif IS_PLAYSTATION then
		instance = require("scripts/managers/privileges/privileges_manager_psn"):new()

		Log.info("PrivilegesManager", "Using PSN privileges manager")
	else
		instance = require("scripts/managers/privileges/privileges_manager_permissive"):new()

		Log.info("PrivilegesManager", "Using permissive privileges manager")
	end

	if rawget(_G, "implements") then
		implements(instance, Interface)
	end

	return instance
end

return PrivilegesManager
