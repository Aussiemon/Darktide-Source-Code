local Promise = require("scripts/foundation/utilities/promise")
local SteamJoinPermission = {
	test_play_mutliplayer_permission = function (account_id, platform, platform_user_id, context_suffix)
		if platform == "steam" and Friends.relationship(platform_user_id) == Friends.IGNORED_FRIEND then
			return Promise.resolved("STEAM_BLOCKED" .. context_suffix)
		end

		return Promise.resolved("OK")
	end
}

return SteamJoinPermission
