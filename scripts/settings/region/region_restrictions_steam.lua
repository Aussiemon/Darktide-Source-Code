-- chunkname: @scripts/settings/region/region_restrictions_steam.lua

local RegionConstants = require("scripts/settings/region/region_constants")
local restrictions = RegionConstants.restrictions
local RegionRestrictionsSteam = {
	AT = {
		[restrictions.ragdoll_interaction] = true,
		[restrictions.visible_minion_wounds] = true,
		[restrictions.gibbing] = true,
		[restrictions.blood_decals] = true,
	},
	DE = {
		[restrictions.ragdoll_interaction] = true,
		[restrictions.visible_minion_wounds] = true,
		[restrictions.gibbing] = true,
		[restrictions.blood_decals] = true,
	},
	JP = {
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

return settings("RegionRestrictionsSteam", RegionRestrictionsSteam)
