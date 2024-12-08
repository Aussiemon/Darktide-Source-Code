-- chunkname: @scripts/settings/region/region_restrictions_steam.lua

local RegionConstants = require("scripts/settings/region/region_constants")
local restrictions = RegionConstants.restrictions
local RegionRestrictionsSteam = {
	AT = {
		[restrictions.ragdoll_interaction] = true,
		[restrictions.visible_minion_wounds] = false,
		[restrictions.gibbing] = false,
		[restrictions.blood_decals] = false,
	},
	DE = {
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

return settings("RegionRestrictionsSteam", RegionRestrictionsSteam)
