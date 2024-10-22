-- chunkname: @scripts/managers/party_immaterium/join_permission/playstation_join_permission.lua

local Promise = require("scripts/foundation/utilities/promise")
local PlaystationJoinPermission = {}

PlaystationJoinPermission.test_play_mutliplayer_permission = function (account_id, platform, platform_user_id, context)
	return Promise.resolved("OK")
end

return PlaystationJoinPermission
