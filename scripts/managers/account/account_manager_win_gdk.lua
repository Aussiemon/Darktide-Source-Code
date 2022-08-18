local XboxPrivileges = require("scripts/managers/account/xbox_privileges")
local render_settings = require("scripts/settings/options/render_settings")
local AccountManagerWinGDK = class("AccountManagerWinGDK")
local SIGNIN_STATES = {
	fetching_privileges = "loc_signin_fetch_privileges",
	fetching_sandbox_id = "loc_signin_fetch_sandbox_id",
	idle = "",
	signin_profile = "loc_signin_acquiring_user_profile"
}

AccountManagerWinGDK.init = function (self)
	self._xbox_privileges = XboxPrivileges:new()
end

AccountManagerWinGDK.signin_profile = function (self, signin_callback)
	local success_cb = callback(self, "_cb_user_signed_in")
	local fail_cb = callback(self, "_show_fatal_error", "loc_popup_header_error", "loc_user_signin_failed_desc")
	local async_task = nil
	local users = XUser.users()

	if #users > 1 then
		async_task = XUser.add_user_async(XUserAddOptions.None)
	else
		async_task = XUser.add_user_async(XUserAddOptions.AddDefaultUserAllowingUI)
	end

	Managers.xasync:wrap(async_task, XUser.release_async_block):next(success_cb, fail_cb)

	self._signin_state = SIGNIN_STATES.signin_profile
	self._signin_callback = signin_callback
end

AccountManagerWinGDK.signin_state = function (self)
	return self._signin_state
end

AccountManagerWinGDK.user_id = function (self)
	return self._user_id
end

AccountManagerWinGDK.is_guest = function (self)
	return self._is_guest
end

AccountManagerWinGDK.gamertag = function (self)
	return self._gamertag
end

AccountManagerWinGDK.reset = function (self)
	self._signin_callback = nil
	self._popup_id = nil
	self._leave_game = nil
	self._wanted_state = nil
	self._wanted_state_params = nil
	self._signin_state = SIGNIN_STATES.idle
	self._is_guest = nil
	self._xuid = nil
	self._user_id = nil
	self._gamertag = nil
end

AccountManagerWinGDK.get_privilege = function (self, privilege)
	return self._xbox_privileges:has_privilege(privilege)
end

AccountManagerWinGDK.sandbox_id = function (self)
	return self._sandbox_id
end

AccountManagerWinGDK.wanted_transition = function (self)
	return
end

AccountManagerWinGDK.do_re_signin = function (self)
	return false
end

AccountManagerWinGDK.user_detached = function (self)
	return false
end

AccountManagerWinGDK.leaving_game = function (self)
	return false
end

AccountManagerWinGDK.update = function (self, dt, t)
	return
end

AccountManagerWinGDK.destroy = function (self)
	return
end

AccountManagerWinGDK.show_profile_picker = function (self)
	return
end

AccountManagerWinGDK._cb_user_signed_in = function (self, async_block)
	local user_id = XUser.get_user_result(async_block)
	local user_info = XUser.user_info(user_id)
	self._is_guest = user_info.guest
	self._xuid = user_info.xuid
	self._user_id = user_id
	self._gamertag = XUser.get_gamertag(user_id)

	self._xbox_privileges:fetch_all_privileges(self._user_id, callback(self, "_cb_privileges_updated"))

	self._signin_state = SIGNIN_STATES.fetching_privileges
end

AccountManagerWinGDK._cb_privileges_updated = function (self)
	if self._xbox_privileges:has_error() then
		self:_show_fatal_error("loc_popup_header_error", "loc_privilege_fetch_fail_desc")

		return
	end

	if not self._xbox_privileges:has_privilege(XUserPrivilege.Multiplayer) then
		self:_show_fatal_error("loc_popup_header_error", "loc_multiplayer_privilege_fail_desc")

		return
	end

	local success_cb = callback(self, "_cb_sanbox_id_fetched")
	local fail_cb = callback(self, "_show_fatal_error", "loc_popup_header_error", "loc_user_signin_failed_desc")
	local async_task, error_code = XboxLive.get_sandbox_id_async()

	if async_task then
		Managers.xasync:wrap(async_task, XboxLive.release_async_block):next(success_cb, fail_cb)

		self._signin_state = SIGNIN_STATES.fetching_sandbox_id
	else
		fail_cb()
	end
end

AccountManagerWinGDK._cb_sanbox_id_fetched = function (self, async_block)
	local sandbox_id, error_code = XboxLive.get_sandbox_id_async_result(async_block)

	if not sandbox_id then
		self:_show_fatal_error("loc_popup_header_error", "loc_user_signin_failed_desc")

		return
	end

	self._sandbox_id = sandbox_id

	self:_finalize_signin()
end

AccountManagerWinGDK._finalize_signin = function (self)
	self._signin_callback()

	self._signin_callback = nil
	self._signin_state = SIGNIN_STATES.idle
end

AccountManagerWinGDK._show_fatal_error = function (self, title_text, description_text)
	local context = {
		title_text = title_text,
		description_text = description_text,
		options = {
			{
				text = "loc_popup_button_close",
				close_on_pressed = true,
				callback = callback(self, "_return_to_title_screen")
			}
		}
	}

	Managers.event:trigger("event_show_ui_popup", context, function (id)
		self._popup_id = id
	end)
end

AccountManagerWinGDK._return_to_title_screen = function (self)
	self._popup_id = nil
	self._leave_game = true
	self._wanted_state = CLASSES.StateError
	self._wanted_state_params = {}

	Managers.backend:logout()
end

return AccountManagerWinGDK
