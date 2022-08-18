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

local permission_array = nil

if XblPermission then
	permission_array = {
		XblPermission.PlayMultiplayer
	}
end

XboxJoinPermission.test_play_mutliplayer_permission = function (account_id, platform, platform_user_id, context_suffix)
	if platform == "xbox" then
		local promise_check = XboxLiveUtilities.batch_check_permission(permission_array, {
			platform_user_id
		}, empty_array):catch(function (error)
			Log.error("XboxJoinPermission", "XboxLiveUtilities.batch_check_permission failed with hresult " .. tostring(error[1]))

			return Promise.resolved({
				{
					is_allowed = true
				}
			})
		end)

		return promise_check:next(function (result_array)
			Log.info("XboxJoinPermission", "XboxLiveUtilities.batch_check_permission result=" .. table.tostring(result_array, 5))

			local result = result_array[1]

			if not result.is_allowed then
				local reason = result.reasons[1].reason_string or deny_reasons[result.reasons[1].reason]

				if not reason then
					reason = "XBOX_JOIN_UNKNOWN_ERROR"
				else
					reason = reason .. context_suffix
				end

				return Promise.rejected(reason)
			else
				return Promise.resolved("OK")
			end
		end)
	else
		return Promise.resolved("OK")
	end
end

return XboxJoinPermission
