-- chunkname: @scripts/settings/region/region_restrictions_xbox_live.lua

local RegionConstants = require("scripts/settings/region/region_constants")
local restrictions = RegionConstants.restrictions
local RegionRestrictionsXboxLive = {
	at = {
		[restrictions.ragdoll_interaction] = true,
	},
	["040"] = {
		[restrictions.ragdoll_interaction] = true,
	},
	de = {
		[restrictions.ragdoll_interaction] = true,
	},
	["276"] = {
		[restrictions.ragdoll_interaction] = true,
	},
	unknown = {
		[restrictions.ragdoll_interaction] = true,
	},
}

return settings("RegionRestrictionsXboxLive", RegionRestrictionsXboxLive)
