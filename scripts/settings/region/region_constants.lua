-- chunkname: @scripts/settings/region/region_constants.lua

local RegionConstants = {}

RegionConstants.restrictions = table.enum("ragdoll_interaction")

return settings("RegionConstants", RegionConstants)
