-- chunkname: @scripts/settings/region/region_restrictions_xbox_live.lua

local RegionConstants = require("scripts/settings/region/region_constants")
local restrictions = RegionConstants.restrictions
local RegionRestrictionsXboxLive = {
	at = {
		[restrictions.ragdoll_interaction] = true,
		[restrictions.visible_minion_wounds] = true,
		[restrictions.gibbing] = true,
		[restrictions.blood_decals] = true,
	},
	["040"] = {
		[restrictions.ragdoll_interaction] = true,
		[restrictions.visible_minion_wounds] = true,
		[restrictions.gibbing] = true,
		[restrictions.blood_decals] = true,
	},
	de = {
		[restrictions.ragdoll_interaction] = true,
		[restrictions.visible_minion_wounds] = true,
		[restrictions.gibbing] = true,
		[restrictions.blood_decals] = true,
	},
	["276"] = {
		[restrictions.ragdoll_interaction] = true,
		[restrictions.visible_minion_wounds] = true,
		[restrictions.gibbing] = true,
		[restrictions.blood_decals] = true,
	},
	jp = {
		[restrictions.ragdoll_interaction] = true,
		[restrictions.visible_minion_wounds] = true,
		[restrictions.gibbing] = true,
		[restrictions.blood_decals] = true,
	},
	["392"] = {
		[restrictions.ragdoll_interaction] = true,
		[restrictions.visible_minion_wounds] = true,
		[restrictions.gibbing] = true,
		[restrictions.blood_decals] = true,
	},
	unknown = {
		[restrictions.ragdoll_interaction] = true,
		[restrictions.visible_minion_wounds] = true,
		[restrictions.gibbing] = true,
		[restrictions.blood_decals] = true,
	},
}

return settings("RegionRestrictionsXboxLive", RegionRestrictionsXboxLive)
