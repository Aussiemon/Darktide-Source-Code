-- chunkname: @scripts/settings/region/region_restrictions_xbox_live.lua

local RegionConstants = require("scripts/settings/region/region_constants")
local restrictions = RegionConstants.restrictions
local RegionRestrictionsXboxLive = {
	at = {
		[restrictions.ragdoll_interaction] = true,
		[restrictions.visible_minion_wounds] = false,
		[restrictions.gibbing] = false,
		[restrictions.blood_decals] = false,
	},
	["040"] = {
		[restrictions.ragdoll_interaction] = true,
		[restrictions.visible_minion_wounds] = false,
		[restrictions.gibbing] = false,
		[restrictions.blood_decals] = false,
	},
	de = {
		[restrictions.ragdoll_interaction] = true,
		[restrictions.visible_minion_wounds] = false,
		[restrictions.gibbing] = false,
		[restrictions.blood_decals] = false,
	},
	["276"] = {
		[restrictions.ragdoll_interaction] = true,
		[restrictions.visible_minion_wounds] = false,
		[restrictions.gibbing] = false,
		[restrictions.blood_decals] = false,
	},
	unknown = {
		[restrictions.ragdoll_interaction] = true,
		[restrictions.visible_minion_wounds] = true,
		[restrictions.gibbing] = true,
		[restrictions.blood_decals] = true,
	},
}

return settings("RegionRestrictionsXboxLive", RegionRestrictionsXboxLive)
