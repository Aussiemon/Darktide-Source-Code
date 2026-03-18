-- chunkname: @scripts/extension_systems/navigation/flying_nav_queries.lua

FlyingNavQueries = FlyingNavQueries or {}

local function _flying_navigation_system()
	return Managers.state.extension:system("flying_navigation_system")
end

FlyingNavQueries.ray_can_go = function (from_position, to_position, radius)
	return _flying_navigation_system():ray_can_go(from_position, to_position, radius)
end

return FlyingNavQueries
