local interface = {
	"delete",
	"destroy",
	"do_re_signin",
	"gamertag",
	"get_privilege",
	"init",
	"is_guest",
	"leaving_game",
	"new",
	"reset",
	"show_profile_picker",
	"signin_profile",
	"signin_state",
	"update",
	"user_detached",
	"user_id",
	"wanted_transition",
	"get_friends",
	"friends_list_has_changes",
	"xuid",
	"refresh_communication_restrictions",
	"is_muted",
	"is_blocked",
	"fetch_crossplay_restrictions",
	"has_crossplay_restriction",
	"verify_gdk_store_account",
	"verify_user_restriction",
	"user_has_restriction",
	"user_restriction_verified",
	"verify_connection",
	"user_restriction_updated"
}
local NullAccountManager = class("NullAccountManager")

NullAccountManager.init = function (self)
	return
end

NullAccountManager.reset = function (self)
	return
end

NullAccountManager.wanted_transition = function (self)
	return
end

NullAccountManager.do_re_signin = function (self)
	return false
end

NullAccountManager.signin_profile = function (self)
	return
end

NullAccountManager.user_detached = function (self)
	return false
end

NullAccountManager.leaving_game = function (self)
	return false
end

NullAccountManager.user_id = function (self)
	return nil
end

NullAccountManager.is_guest = function (self)
	return false
end

NullAccountManager.gamertag = function (self)
	return ""
end

NullAccountManager.signin_state = function (self)
	return ""
end

NullAccountManager.update = function (self, dt, t)
	return
end

NullAccountManager.destroy = function (self)
	return
end

NullAccountManager.get_privilege = function (self)
	return
end

NullAccountManager.show_profile_picker = function (self)
	return
end

NullAccountManager.get_friends = function (self)
	return
end

NullAccountManager.friends_list_has_changes = function (self)
	return
end

NullAccountManager.xuid = function (self)
	return
end

NullAccountManager.refresh_communication_restrictions = function (self)
	return
end

NullAccountManager.is_muted = function (self)
	return false
end

NullAccountManager.is_blocked = function (self)
	return false
end

NullAccountManager.fetch_crossplay_restrictions = function (self)
	return
end

NullAccountManager.has_crossplay_restriction = function (self)
	return false
end

NullAccountManager.verify_gdk_store_account = function (self)
	return true
end

NullAccountManager.verify_user_restriction = function (self)
	return
end

NullAccountManager.user_has_restriction = function (self)
	return false
end

NullAccountManager.user_restriction_verified = function (self)
	return true
end

NullAccountManager.verify_connection = function (self)
	return true
end

NullAccountManager.user_restriction_updated = function (self)
	return
end

local AccountManager = {
	new = function (self)
		local instance = nil

		if IS_XBS then
			instance = require("scripts/managers/account/account_manager_xbox_live"):new()

			Log.info("AccountManager", "Using Xbox Live account manager")
		elseif IS_GDK then
			instance = require("scripts/managers/account/account_manager_win_gdk"):new()

			Log.info("AccountManager", "Using Win GDK account manager")
		else
			instance = NullAccountManager:new()

			Log.info("AccountManager", "Using base account manager")
		end

		if rawget(_G, "implements") then
			implements(instance, interface)
		end

		return instance
	end
}

return AccountManager
