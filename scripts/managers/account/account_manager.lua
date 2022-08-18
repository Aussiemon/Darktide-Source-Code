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
	"wanted_transition"
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
