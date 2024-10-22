-- chunkname: @scripts/managers/account/account_manager.lua

local interface = {
	"delete",
	"destroy",
	"do_re_signin",
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
	"platform_user_id",
	"user_display_name",
	"wanted_transition",
	"get_friends",
	"friends_list_has_changes",
	"refresh_communication_restrictions",
	"is_muted",
	"is_blocked",
	"fetch_crossplay_restrictions",
	"set_crossplay_restriction",
	"has_crossplay_restriction",
	"verify_user_restriction",
	"user_has_restriction",
	"user_restriction_verified",
	"verify_connection",
	"communication_restriction_iteration",
	"region_has_restriction",
	"return_to_title_screen",
}
local AccountManager = {}

AccountManager.new = function (self)
	local instance

	if IS_XBS then
		instance = require("scripts/managers/account/account_manager_xbox_live"):new()

		Log.info("AccountManager", "Using Xbox Live account manager")
	elseif IS_GDK then
		instance = require("scripts/managers/account/account_manager_win_gdk"):new()

		Log.info("AccountManager", "Using Win GDK account manager")
	elseif IS_PLAYSTATION then
		instance = require("scripts/managers/account/account_manager_psn"):new()

		Log.info("AccountManager", "Using PSN account manager")
	elseif HAS_STEAM then
		instance = require("scripts/managers/account/account_manager_steam"):new()

		Log.info("AccountManager", "Using steam account manager")
	else
		instance = require("scripts/managers/account/account_manager_base"):new()

		Log.info("AccountManager", "Using base account manager")
	end

	if rawget(_G, "implements") then
		implements(instance, interface)
	end

	return instance
end

return AccountManager
