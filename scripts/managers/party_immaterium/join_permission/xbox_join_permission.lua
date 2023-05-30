local Promise = require("scripts/foundation/utilities/promise")
local XboxLiveUtilities = require("scripts/foundation/utilities/xbox_live")
local XboxJoinPermission = {}
local empty_array = {}
local deny_reasons = nil

if XblPermissionDenyReason then
	deny_reasons = {
		[XblPermissionDenyReason.BlockListRestrictsTarget] = "XBOX_BLOCKED",
		[XblPermissionDenyReason.MuteListRestrictsTarget] = "XBOX_UNKNOWN",
		[XblPermissionDenyReason.PrivacySettingRestrictsTarget] = "XBOX_PRIVACY_SETTING_RESTRICTS_TARGET",
		[XblPermissionDenyReason.PrivilegeRestrictsTarget] = "XBOX_UNKNOWN",
		[XblPermissionDenyReason.Unknown] = "XBOX_UNKNOWN",
		[XblPermissionDenyReason.CrossNetworkUserMustBeFriend] = "XBOX_UNKNOWN",
		[XblPermissionDenyReason.MissingPrivilege] = "XBOX_UNKNOWN",
		[XblPermissionDenyReason.NotAllowed] = "XBOX_UNKNOWN"
	}
end

local PERMISSION_ARRAY = nil

if XblPermission then
	PERMISSION_ARRAY = {
		default = {
			XblPermission.PlayMultiplayer
		},
		INVITE = {
			XblPermission.PlayMultiplayer,
			XblPermission.CommunicateUsingText
		},
		JOIN_REQUEST = {
			XblPermission.PlayMultiplayer
		}
	}
end

XboxJoinPermission.test_play_mutliplayer_permission = function (account_id, platform, platform_user_id, context)
	if platform == "xbox" then
		local context_suffix = context and "_" .. context or ""
		local permission_array = PERMISSION_ARRAY[context] or PERMISSION_ARRAY.default
		local promise_check = XboxLiveUtilities.batch_check_permission(permission_array, {
			platform_user_id
		}, empty_array):catch(function (error)
			Log.error("XboxJoinPermission", "XboxLiveUtilities.batch_check_permission failed with hresult %s", tostring(error[1]))

			return Promise.resolved({
				{
					is_allowed = true
				}
			})
		end)

		return promise_check:next(function (result_array)
			Log.info("XboxJoinPermission", "XboxLiveUtilities.batch_check_permission result=%s", table.tostring(result_array, 5))

			for _, result in ipairs(result_array) do
				if not result.is_allowed then
					return Promise.rejected("declined")
				end
			end

			return Promise.resolved("OK")
		end)
	else
		return Promise.resolved("OK")
	end
end

XboxJoinPermission.check_join_request_communication_allowed = function (joiner_account_id, joiner_presence)
	if joiner_presence:platform() == "xbox" then
		local has_privilege, _ = Managers.account:get_privilege(XUserPrivilege.Communications)

		if not has_privilege then
			local is_allowed = false

			return Promise.resolved(is_allowed)
		end

		local joiner_xuid = joiner_presence:platform_user_id()
		local promise = Promise.new()

		Managers.account:verify_user_restriction(joiner_xuid, XblPermission.CommunicateUsingText, function (success, has_restriction)
			if success then
				local is_allowed = not has_restriction

				promise:resolve(is_allowed)
			else
				promise:reject({
					"Failed verifying user restriction"
				})
			end
		end)

		return promise
	else
		return Managers.data_service.social:fetch_friends():next(function (friends)
			local is_friend = false

			for i = 1, #friends do
				local player_info = friends[i]

				if player_info:account_id() == joiner_account_id or player_info:platform() == joiner_presence:platform() and player_info:platform_user_id() == joiner_presence:platform_user_id() then
					is_friend = true

					break
				end
			end

			local relation = is_friend and XblAnonymousUserType.CrossNetworkFriend or XblAnonymousUserType.CrossNetworkUser
			local is_allowed = not Managers.account:has_crossplay_restriction(relation, XblPermission.CommunicateUsingText)

			return is_allowed
		end)
	end
end

return XboxJoinPermission
