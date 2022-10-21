local PrivilegesManagerConstants = require("scripts/managers/privileges/privileges_manager_constants")
XboxPrivileges = class("XboxPrivileges")
local DEFAULT_PRIVILEGES = DEFAULT_PRIVILEGES or {}
local ATTEMPT_RESOLUTION_PRIVILEGES = ATTEMPT_RESOLUTION_PRIVILEGES or {}
local XBOX_PRIVILEGE_LUT = XBOX_PRIVILEGE_LUT or {}

local function debug_log(...)
	return
end

XboxPrivileges.init = function (self)
	self:reset()
end

XboxPrivileges.reset = function (self)
	self._initialized = false
	self._has_error = nil
	self._privileges_data = {}
	self._async_privileges = {}

	self:_setup_lookup_tables()
end

XboxPrivileges.fetch_all_privileges = function (self, user_id, fetch_done_cb)
	self:reset()

	for _, privilege in pairs(DEFAULT_PRIVILEGES) do
		local attempt_resolution = false

		if ATTEMPT_RESOLUTION_PRIVILEGES[privilege] then
			debug_log(XBOX_PRIVILEGE_LUT[privilege] .. " using attempt_resolution=true")

			local async_task, h_result = XUser.resolve_privilege_async(user_id, XUserPrivilegeOptions.None, privilege)

			if async_task then
				local success_cb = callback(self, "_cb_user_privilege_done", user_id, privilege)
				local fail_cb = callback(self, "_cb_user_privilege_failed", user_id, privilege)

				Managers.xasync:wrap(async_task, XUser.release_async_block):next(success_cb, fail_cb)

				self._async_privileges[privilege] = true
			else
				self._has_error = h_result
			end
		else
			local has_privilege, deny_reason, resolution_required = XUser.check_privilege(user_id, XUserPrivilegeOptions.None, privilege)
			self._privileges_data[privilege] = {
				has_privilege = has_privilege,
				deny_reason = HRESULT.S_OK < deny_reason and PrivilegesManagerConstants.DenyReason[deny_reason] or "OK",
				resolution_required = resolution_required
			}

			debug_log("[XboxPrivileges] User %q %s the privilege to %q - Reason: %s", tostring(user_id), has_privilege and "has" or "do NOT have", XBOX_PRIVILEGE_LUT[privilege] or "unknown", HRESULT.S_OK < deny_reason and PrivilegesManagerConstants.DenyReason[deny_reason] or "UNKNOWN")
		end
	end

	if table.is_empty(self._async_privileges) then
		fetch_done_cb()
	else
		self._fetch_done_cb = fetch_done_cb
	end
end

XboxPrivileges.update_privileges = function (self, user_id)
	for _, privilege in pairs(DEFAULT_PRIVILEGES) do
		local has_privilege, deny_reason, resolution_required = XUser.check_privilege(user_id, XUserPrivilegeOptions.None, privilege)
		self._privileges_data[privilege] = {
			has_privilege = has_privilege,
			deny_reason = HRESULT.S_OK < deny_reason and PrivilegesManagerConstants.DenyReason[deny_reason] or "OK",
			resolution_required = resolution_required
		}
	end
end

XboxPrivileges._cb_user_privilege_done = function (self, user_id, privilege, async_task)
	local has_privilege = XUser.get_resolve_privilege_result(async_task)

	debug_log("[XboxPrivileges] User %q %s the privilege to %q", tostring(user_id), has_privilege and "has" or "do NOT have", XBOX_PRIVILEGE_LUT[privilege] or "unknown")

	self._privileges_data[privilege] = {
		deny_reason = "OK",
		has_privilege = has_privilege
	}
	self._async_privileges[privilege] = nil

	if table.is_empty(self._async_privileges) and self._fetch_done_cb then
		self._fetch_done_cb()

		self._fetch_done_cb = nil
	end
end

XboxPrivileges._cb_user_privilege_failed = function (self, user_id, privilege, result)
	local h_result = result[1]

	debug_log("[XboxPrivileges] User %q failed getting privilege %q - Reason: %s", tostring(user_id), XBOX_PRIVILEGE_LUT[privilege] or "unknown", HRESULT.S_OK < h_result and PrivilegesManagerConstants.DenyReason[h_result] or "UNKNOWN")

	self._async_privileges[privilege] = nil
	self._has_error = true

	if table.is_empty(self._async_privileges) and self._fetch_done_cb then
		self._fetch_done_cb()

		self._fetch_done_cb = nil
	end
end

local EMPTY_TABLE = {}

XboxPrivileges.has_privilege = function (self, privilege)
	local privilege_data = self._privileges_data[privilege] or EMPTY_TABLE

	return privilege_data.has_privilege, privilege_data.deny_reason, privilege_data.resolution_required
end

XboxPrivileges.has_error = function (self)
	return self._has_error
end

XboxPrivileges._setup_lookup_tables = function (self)
	table.clear(XBOX_PRIVILEGE_LUT)
	table.clear(DEFAULT_PRIVILEGES)
	table.clear(ATTEMPT_RESOLUTION_PRIVILEGES)

	XBOX_PRIVILEGE_LUT[XUserPrivilege.AddFriends] = "ADD_FRIEND"
	XBOX_PRIVILEGE_LUT[XUserPrivilege.Broadcast] = "BROADCAST"
	XBOX_PRIVILEGE_LUT[XUserPrivilege.CloudJoinSession] = "CLOUD_JOIN_SESSION"
	XBOX_PRIVILEGE_LUT[XUserPrivilege.CloudManageSession] = "CLOUD_MANAGE_SESSION"
	XBOX_PRIVILEGE_LUT[XUserPrivilege.CloudSavedGames] = "CLOUD_SAVED_GAMES"
	XBOX_PRIVILEGE_LUT[XUserPrivilege.Clubs] = "CLUBS"
	XBOX_PRIVILEGE_LUT[XUserPrivilege.Communications] = "COMMUNICATIONS"
	XBOX_PRIVILEGE_LUT[XUserPrivilege.CrossPlay] = "CROSSPLAY"
	XBOX_PRIVILEGE_LUT[XUserPrivilege.GameDvr] = "GAMEDVR"
	XBOX_PRIVILEGE_LUT[XUserPrivilege.ManageProfilePrivacy] = "MANAGE_PROFILE_PRIVACY"
	XBOX_PRIVILEGE_LUT[XUserPrivilege.Multiplayer] = "MULTIPLAYER"
	XBOX_PRIVILEGE_LUT[XUserPrivilege.MultiplayerParties] = "MULTIPLAYER_PARTIES"
	XBOX_PRIVILEGE_LUT[XUserPrivilege.Sessions] = "SESSIONS"
	XBOX_PRIVILEGE_LUT[XUserPrivilege.SocialNetworkSharing] = "SOCIAL_NETWORK_SHARING"
	XBOX_PRIVILEGE_LUT[XUserPrivilege.UserGeneratedContent] = "USER_GENERATED_CONTENT"
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = XUserPrivilege.AddFriends
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = XUserPrivilege.Broadcast
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = XUserPrivilege.CloudJoinSession
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = XUserPrivilege.CloudManageSession
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = XUserPrivilege.CloudSavedGames
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = XUserPrivilege.Clubs
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = XUserPrivilege.Communications
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = XUserPrivilege.CrossPlay
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = XUserPrivilege.GameDvr
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = XUserPrivilege.ManageProfilePrivacy
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = XUserPrivilege.Multiplayer
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = XUserPrivilege.MultiplayerParties
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = XUserPrivilege.Sessions
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = XUserPrivilege.SocialNetworkSharing
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = XUserPrivilege.UserGeneratedContent
	ATTEMPT_RESOLUTION_PRIVILEGES[XUserPrivilege.Multiplayer] = true
end

return XboxPrivileges
