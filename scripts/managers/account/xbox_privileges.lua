local PrivilegesManagerConstants = require("scripts/managers/privileges/privileges_manager_constants")
local FGRLLimits = require("scripts/foundation/utilities/fgrl_limits")
XboxPrivileges = class("XboxPrivileges")
local DEFAULT_PRIVILEGES = DEFAULT_PRIVILEGES or {}
local ATTEMPT_RESOLUTION_PRIVILEGES = ATTEMPT_RESOLUTION_PRIVILEGES or {}
local XBOX_PRIVILEGE_LUT = XBOX_PRIVILEGE_LUT or {}
local XBOX_PERMISSION_LUT = XBOX_PERMISSION_LUT or {}
local ANONYMOUSE_USER_TYPES_LUT = ANONYMOUSE_USER_TYPES_LUT or {}
local DEFAULT_PERMISSIONS = DEFAULT_PERMISSIONS or {}
local DEFAULT_ANONYMOUS_USER_TYPES = DEFAULT_ANONYMOUS_USER_TYPES or {}
local XBOX_PERMISSION_DENY_REASON_LUT = XBOX_PERMISSION_DENY_REASON_LUT or {}
local BATCH_WAIT_TIMES = {
	CHAT_HUB = 10,
	CHAT_PARTY = 0,
	CHAT_MISSION = 0
}
local BATCH_SEND_DELAY = 3

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
	self._crossplay_restrictions = {}
	self._user_restrictions = {}
	self._batched_user_restrictions = {}
	self._batch_wait_timer = {}
	self._batch_send_timer = {}
end

XboxPrivileges.verify_user_restriction_batched = function (self, xuid, restriction, batch_type)
	if Managers.account:user_detached() then
		return
	end

	local user_data = self._user_restrictions[xuid]

	if user_data and user_data[restriction] ~= nil then
		return
	end

	local batch = self._batched_user_restrictions[batch_type]

	if not batch then
		batch = {
			restrictions = {},
			xuids = {}
		}
		self._batched_user_restrictions[batch_type] = batch
	end

	batch.restrictions[restriction] = true
	batch.xuids[xuid] = true
end

XboxPrivileges._update_batched_user_restrictions = function (self, dt, t)
	local batches = self._batched_user_restrictions

	if table.is_empty(batches) then
		return
	end

	for batch_type, data in pairs(batches) do
		local wait_timer = self._batch_wait_timer[batch_type] or 0
		local send_timer = self._batch_send_timer[batch_type] or nil

		if wait_timer <= t and not send_timer then
			self._batch_wait_timer[batch_type] = t + BATCH_WAIT_TIMES[batch_type]
			self._batch_send_timer[batch_type] = t + BATCH_SEND_DELAY
		elseif send_timer and send_timer <= t then
			self:_send_batched_user_restrictions(batch_type, t)
		end
	end
end

XboxPrivileges._send_batched_user_restrictions = function (self, batch_type, t)
	local batch = self._batched_user_restrictions[batch_type]
	local xuids = table.keys(batch.xuids)
	local restrictions = table.keys(batch.restrictions)
	self._batched_user_restrictions[batch_type] = nil
	self._batch_send_timer[batch_type] = nil

	if Managers.account:user_detached() then
		return
	end

	Log.info("XboxPrivileges", "Sending batch %q, checking %s xuid's for restrictions %s", batch_type, #xuids, table.tostring(restrictions))

	local async_task, error_code, error_message = XboxLivePrivacy.batch_check_permission(Managers.account:user_id(), restrictions, xuids, {})

	if error_code then
		Log.warning("XboxPrivileges", "batch_check_permission failed with error code: %s", error_code)

		return
	elseif error_message then
		Log.warning("XboxPrivileges", "batch_check_permission failed with error message: %s", error_message)

		return
	end

	if async_task then
		Managers.xasync:wrap(async_task, XboxLivePrivacy.release_block):next(function (async_block)
			local results, error_code = XboxLivePrivacy.batch_check_permission_result(async_block)

			if error_code then
				Log.warning("XboxPrivileges", "batch_check_permission_result failed with error code: %s", error_code)

				return
			end

			local user_restrictions = self._user_restrictions

			for i = 1, #results do
				local result = results[i]
				local xuid = result.target_xuid
				local permission = result.permission_requested
				local is_allowed = result.is_allowed
				user_restrictions[xuid] = self._user_restrictions[xuid] or {}
				user_restrictions[xuid][permission] = not result.is_allowed

				if not is_allowed then
					local reasons = result.reasons

					if reasons then
						for _, reason_data in ipairs(reasons) do
							local reason = reason_data.reason
							local restricted_privilege = reason_data.restricted_privilege

							Log.info("XboxPrivileges", "You are not allowed to %q with %q because of %q", XBOX_PERMISSION_LUT[permission], xuid, XBOX_PERMISSION_DENY_REASON_LUT[reason] or "Unknown")
							Log.info("XboxPrivileges", "This affects the %q privilege", XBOX_PRIVILEGE_LUT[restricted_privilege] or "Unknown")
						end
					end
				end
			end

			Managers.chat:player_mute_status_changed()
		end):catch(function (err)
			Log.warning("XboxPrivileges", "batch_check_permission async task failed with error: %s", table.tostring(err, 3))
		end)
	end
end

XboxPrivileges.update = function (self, dt, t)
	self:_update_batched_user_restrictions(dt, t)
end

XboxPrivileges.fetch_all_privileges = function (self, user_id, fetch_done_cb)
	self:reset()

	for _, privilege in pairs(DEFAULT_PRIVILEGES) do
		local has_privilege, deny_reason, resolution_required = XUser.check_privilege(user_id, XUserPrivilegeOptions.None, privilege)
		local attempt_resolution = ATTEMPT_RESOLUTION_PRIVILEGES[privilege] and not has_privilege

		if attempt_resolution then
			debug_log(XBOX_PRIVILEGE_LUT[privilege] .. " using attempt_resolution=true")

			local async_task, h_result, error_message = XUser.resolve_privilege_async(user_id, XUserPrivilegeOptions.None, privilege)

			if async_task then
				local success_cb = callback(self, "_cb_user_privilege_done", user_id, privilege)
				local fail_cb = callback(self, "_cb_user_privilege_failed", user_id, privilege)

				Managers.xasync:wrap(async_task, XUser.release_async_block):next(success_cb, fail_cb)

				self._async_privileges[privilege] = true
			else
				self._has_error = h_result or error_message
			end
		else
			self._privileges_data[privilege] = {
				has_privilege = has_privilege,
				deny_reason = HRESULT.S_OK < deny_reason and PrivilegesManagerConstants.DenyReason[deny_reason] or "OK",
				resolution_required = resolution_required
			}
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

	table.clear(self._user_restrictions)
	self:fetch_crossplay_restrictions()
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
	self._privileges_data[privilege] = {
		has_privilege = false,
		deny_reason = HRESULT.S_OK < h_result and PrivilegesManagerConstants.DenyReason[h_result] or "UNKNOWN"
	}

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

XboxPrivileges.fetch_crossplay_restrictions = function (self)
	if Managers.account:user_detached() then
		return
	end

	local async_task, error_code, error_message = XboxLivePrivacy.batch_check_permission(Managers.account:user_id(), DEFAULT_PERMISSIONS, {}, DEFAULT_ANONYMOUS_USER_TYPES)

	if async_task then
		Managers.xasync:wrap(async_task, XboxLivePrivacy.release_block):next(function (async_task)
			local result, has_error = XboxLivePrivacy.batch_check_permission_result(async_task)

			if has_error then
				return
			end

			table.clear(self._crossplay_restrictions)
			print("*** Restricted Permissions ***")
			print("")

			for _, result_data in pairs(result) do
				if not result_data.is_allowed then
					local target_user_type = result_data.target_user_type
					local permission_type = result_data.permission_requested
					local reasons = result_data.reasons

					if reasons then
						for _, reason_data in ipairs(reasons) do
							local reason = reason_data.reason
							local restricted_privilege = reason_data.restricted_privilege

							print(string.format("You are not allowed to %q with %q because of %q", XBOX_PERMISSION_LUT[permission_type], ANONYMOUSE_USER_TYPES_LUT[target_user_type], XBOX_PERMISSION_DENY_REASON_LUT[reason] or "Unknown"))
							print(string.format("This affects the %q privilege", XBOX_PRIVILEGE_LUT[restricted_privilege] or "Unknown"))
						end
					end

					self._crossplay_restrictions[target_user_type] = self._crossplay_restrictions[target_user_type] or {}
					self._crossplay_restrictions[target_user_type][permission_type] = true
				end
			end

			print("")
			print("*** Restricted Permissions END ***")
		end):next(function ()
			Managers.chat:player_mute_status_changed()
		end)
	end
end

XboxPrivileges.has_crossplay_restriction = function (self, relation, restriction)
	if not restriction or not restriction then
		return false
	end

	local relation_restrictions = self._crossplay_restrictions[relation]

	return relation_restrictions and relation_restrictions[restriction]
end

XboxPrivileges.verify_user_restriction = function (self, xuid, restriction, optional_callback)
	if not XBOX_PERMISSION_LUT[restriction] then
		if optional_callback then
			optional_callback(false, nil)
		end

		return
	end

	if Managers.account:user_detached() then
		if optional_callback then
			optional_callback(false, nil)
		end

		return
	end

	local user_data = self._user_restrictions[xuid]

	if user_data and user_data[restriction] ~= nil then
		if optional_callback then
			optional_callback(true, user_data[restriction])
		end

		return
	end

	local async_block, error_code, error_message = XboxLivePrivacy.check_user_permission(Managers.account:user_id(), xuid, restriction)

	if error_code then
		Log.warning("XboxPrivileges:verify_user_restriction", "Check user restriction failed with error code: %s", error_code)

		if optional_callback then
			optional_callback(false, nil)
		end

		return
	elseif error_message then
		Log.warning("XboxPrivileges:verify_user_restriction", "Check user restriction failed with error message: %s", error_message)

		if optional_callback then
			optional_callback(false, nil)
		end

		return
	end

	Managers.xasync:wrap(async_block, XboxLivePrivacy.release_block):next(function (async_block)
		local result, error_code = XboxLivePrivacy.check_user_permission_result(async_block)

		if error_code then
			Application.warning(string.format("[XboxPrivileges:verify_user_restriction] Failed getting the restriction results with error code: %s", error_code))

			if optional_callback then
				optional_callback(false, nil)
			end

			return
		end

		self._user_restrictions[xuid] = self._user_restrictions[xuid] or {}
		self._user_restrictions[xuid][restriction] = not result.is_allowed

		if not result.is_allowed then
			local reasons_data = result.reasons
			local data = reasons_data[1]
			local reason = data.reason

			Log.info("XboxPrivileges", string.format("You are not allowed to %q with xuid %q because of %q", XBOX_PERMISSION_LUT[restriction], xuid, XBOX_PERMISSION_DENY_REASON_LUT[reason] or "Unknown"))
		end

		Managers.chat:player_mute_status_changed()

		if optional_callback then
			optional_callback(true, not result.is_allowed)
		end
	end)
end

XboxPrivileges.user_restriction_verified = function (self, xuid, restriction)
	if not XBOX_PERMISSION_LUT[restriction] then
		return
	end

	local restriction_data = self._user_restrictions[xuid]

	if not restriction_data then
		return false
	end

	return restriction_data[restriction] ~= nil
end

XboxPrivileges.user_has_restriction = function (self, xuid, restriction)
	local user_restrictions = self._user_restrictions[xuid]

	if not user_restrictions then
		return false
	end

	local has_restriction = user_restrictions[restriction]

	return has_restriction
end

XboxPrivileges.push_telemetry = function (self)
	local telemetry_data = {}

	for code, data in pairs(self._privileges_data) do
		local privilege_name = XBOX_PRIVILEGE_LUT[code]
		local has_privilege = data.has_privilege

		if privilege_name then
			telemetry_data[privilege_name] = not not has_privilege
		end
	end

	Managers.telemetry_events:xbox_privileges(telemetry_data)
end

local function setup_lookup_tables()
	table.clear(XBOX_PRIVILEGE_LUT)
	table.clear(DEFAULT_PRIVILEGES)
	table.clear(ATTEMPT_RESOLUTION_PRIVILEGES)
	table.clear(XBOX_PERMISSION_LUT)
	table.clear(ANONYMOUSE_USER_TYPES_LUT)
	table.clear(DEFAULT_PERMISSIONS)
	table.clear(DEFAULT_ANONYMOUS_USER_TYPES)
	table.clear(XBOX_PERMISSION_DENY_REASON_LUT)

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
	ATTEMPT_RESOLUTION_PRIVILEGES[XUserPrivilege.CrossPlay] = true
	ATTEMPT_RESOLUTION_PRIVILEGES[XUserPrivilege.Communications] = true
	DEFAULT_PERMISSIONS[#DEFAULT_PERMISSIONS + 1] = XblPermission.CommunicateUsingText
	DEFAULT_PERMISSIONS[#DEFAULT_PERMISSIONS + 1] = XblPermission.CommunicateUsingVoice
	DEFAULT_PERMISSIONS[#DEFAULT_PERMISSIONS + 1] = XblPermission.PlayMultiplayer
	DEFAULT_PERMISSIONS[#DEFAULT_PERMISSIONS + 1] = XblPermission.CommunicateUsingVideo
	DEFAULT_PERMISSIONS[#DEFAULT_PERMISSIONS + 1] = XblPermission.BroadcastWithTwitch
	DEFAULT_PERMISSIONS[#DEFAULT_PERMISSIONS + 1] = XblPermission.ShareItem
	DEFAULT_PERMISSIONS[#DEFAULT_PERMISSIONS + 1] = XblPermission.ShareTargetContentToExternalNetworks
	DEFAULT_PERMISSIONS[#DEFAULT_PERMISSIONS + 1] = XblPermission.ViewTargetExerciseInfo
	DEFAULT_PERMISSIONS[#DEFAULT_PERMISSIONS + 1] = XblPermission.ViewTargetGameHistory
	DEFAULT_PERMISSIONS[#DEFAULT_PERMISSIONS + 1] = XblPermission.ViewTargetMusicHistory
	DEFAULT_PERMISSIONS[#DEFAULT_PERMISSIONS + 1] = XblPermission.ViewTargetMusicStatus
	DEFAULT_PERMISSIONS[#DEFAULT_PERMISSIONS + 1] = XblPermission.ViewTargetPresence
	DEFAULT_PERMISSIONS[#DEFAULT_PERMISSIONS + 1] = XblPermission.ViewTargetProfile
	DEFAULT_PERMISSIONS[#DEFAULT_PERMISSIONS + 1] = XblPermission.ViewTargetUserCreatedContent
	DEFAULT_PERMISSIONS[#DEFAULT_PERMISSIONS + 1] = XblPermission.ViewTargetVideoHistory
	DEFAULT_PERMISSIONS[#DEFAULT_PERMISSIONS + 1] = XblPermission.ViewTargetVideoStatus
	DEFAULT_ANONYMOUS_USER_TYPES[#DEFAULT_ANONYMOUS_USER_TYPES + 1] = XblAnonymousUserType.CrossNetworkUser
	DEFAULT_ANONYMOUS_USER_TYPES[#DEFAULT_ANONYMOUS_USER_TYPES + 1] = XblAnonymousUserType.CrossNetworkFriend
	XBOX_PERMISSION_LUT[XblPermission.CommunicateUsingText] = "CommunicateUsingText"
	XBOX_PERMISSION_LUT[XblPermission.CommunicateUsingVoice] = "CommunicateUsingVoice"
	XBOX_PERMISSION_LUT[XblPermission.PlayMultiplayer] = "PlayMultiplayer"
	XBOX_PERMISSION_LUT[XblPermission.CommunicateUsingVideo] = "CommunicateUsingVideo"
	XBOX_PERMISSION_LUT[XblPermission.BroadcastWithTwitch] = "BroadcastWithTwitch"
	XBOX_PERMISSION_LUT[XblPermission.ShareItem] = "ShareItem"
	XBOX_PERMISSION_LUT[XblPermission.ShareTargetContentToExternalNetworks] = "ShareTargetContentToExternalNetworks"
	XBOX_PERMISSION_LUT[XblPermission.ViewTargetExerciseInfo] = "ViewTargetExerciseInfo"
	XBOX_PERMISSION_LUT[XblPermission.ViewTargetGameHistory] = "ViewTargetGameHistory"
	XBOX_PERMISSION_LUT[XblPermission.ViewTargetMusicHistory] = "ViewTargetMusicHistory"
	XBOX_PERMISSION_LUT[XblPermission.ViewTargetMusicStatus] = "ViewTargetMusicStatus"
	XBOX_PERMISSION_LUT[XblPermission.ViewTargetPresence] = "ViewTargetPresence"
	XBOX_PERMISSION_LUT[XblPermission.ViewTargetProfile] = "ViewTargetProfile"
	XBOX_PERMISSION_LUT[XblPermission.ViewTargetUserCreatedContent] = "ViewTargetUserCreatedContent"
	XBOX_PERMISSION_LUT[XblPermission.ViewTargetVideoHistory] = "ViewTargetVideoHistory"
	XBOX_PERMISSION_LUT[XblPermission.ViewTargetVideoStatus] = "ViewTargetVideoStatus"
	ANONYMOUSE_USER_TYPES_LUT[XblAnonymousUserType.CrossNetworkUser] = "CrossNetworkUser"
	ANONYMOUSE_USER_TYPES_LUT[XblAnonymousUserType.CrossNetworkFriend] = "CrossNetworkFriend"
	XBOX_PERMISSION_DENY_REASON_LUT[XblPermissionDenyReason.BlockListRestrictsTarget] = "BlockListRestrictsTarget"
	XBOX_PERMISSION_DENY_REASON_LUT[XblPermissionDenyReason.CrossNetworkUserMustBeFriend] = "CrossNetworkUserMustBeFriend"
	XBOX_PERMISSION_DENY_REASON_LUT[XblPermissionDenyReason.MissingPrivilege] = "MissingPrivilege"
	XBOX_PERMISSION_DENY_REASON_LUT[XblPermissionDenyReason.MuteListRestrictsTarget] = "MuteListRestrictsTarget"
	XBOX_PERMISSION_DENY_REASON_LUT[XblPermissionDenyReason.NotAllowed] = "NotAllowed"
	XBOX_PERMISSION_DENY_REASON_LUT[XblPermissionDenyReason.PrivacySettingRestrictsTarget] = "PrivacySettingRestrictsTarget"
	XBOX_PERMISSION_DENY_REASON_LUT[XblPermissionDenyReason.PrivilegeRestrictsTarget] = "PrivilegeRestrictsTarget"
	XBOX_PERMISSION_DENY_REASON_LUT[XblPermissionDenyReason.Unknown] = "Unknown"
end

setup_lookup_tables()

return XboxPrivileges
