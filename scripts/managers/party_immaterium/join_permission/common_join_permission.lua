-- chunkname: @scripts/managers/party_immaterium/join_permission/common_join_permission.lua

local Promise = require("scripts/foundation/utilities/promise")
local PrivilegesManager = require("scripts/managers/privileges/privileges_manager")
local CommonJoinPermission = {}

CommonJoinPermission.test_play_mutliplayer_permission = function (account_id, platform, platform_user_id, context)
	local context_suffix = context and "_" .. context or ""
	local privileges_manager = PrivilegesManager:new()
	local blocked_check = Managers.data_service.social:is_account_blocked(account_id):catch(function (error)
		Log.error("CommonJoinPermission", "could not check if player was blocked, error=%s", table.tostring(error, 4))

		return Promise.resolved()
	end):next(function (is_blocked)
		if is_blocked then
			return Promise.rejected("BLOCKED" .. context_suffix)
		else
			return Promise.resolved()
		end
	end)
	local cross_play_check

	if platform ~= Managers.presence:presence_entry_myself():platform() then
		cross_play_check = privileges_manager:cross_play():next(function (result)
			if result.has_privilege == true then
				return Promise.resolved()
			else
				Log.info("CommonJoinPermission", "Crossplay privilege denied, reason: %s", result.deny_reason)

				return Promise.rejected("CROSS_PLAY_DISABLED" .. context_suffix)
			end
		end)
	else
		cross_play_check = Promise.resolved()
	end

	return Promise.all(blocked_check, cross_play_check):next(function (results)
		return Promise.resolved("OK")
	end):catch(function (errors)
		for i = 1, #errors do
			if errors[i] then
				return Promise.rejected(errors[i])
			end
		end
	end)
end

return CommonJoinPermission
