-- chunkname: @scripts/settings/region/region_constants.lua

local RegionConstants = {}

RegionConstants.restrictions = table.enum("ragdoll_interaction", "visible_minion_wounds", "gibbing", "blood_decals")

return settings("RegionConstants", RegionConstants)
