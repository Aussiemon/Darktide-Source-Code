local Promise = require("scripts/foundation/utilities/promise")
local SteamJoinPermission = {
	test_play_mutliplayer_permission = function (account_id, platform, platform_user_id, context)
		if platform == "steam" then
			local context_suffix = context and "_" .. context or ""
			local relationship = Friends.relationship(platform_user_id)

			if relationship == Friends.IGNORED_FRIEND then
				return Promise.rejected("STEAM_BLOCKED" .. context_suffix)
			end
		end

		return Promise.resolved("OK")
	end
}

return SteamJoinPermission
