local Promise = require("scripts/foundation/utilities/promise")
local XboxLiveUtilities = require("scripts/foundation/utilities/xbox_live")
local XboxJoinPermission = {}
local empty_array = {}
local deny_reasons = nil

if XblPermissionDenyReason then
	deny_reasons = {
		[XblPermissionDenyReason.BlockListRestrictsTarget] = "XBOX_BLOCKED",
		[XblPermissionDenyReason.MuteListRestrictsTarget] = "XBOX_UNKNOWN",
		[XblPermissionDenyReason.PrivacySettingsRestrictsTarget] = "XBOX_PRIVACY_SETTINGS_RESTRICTS_TARGET",
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

return XboxJoinPermission
