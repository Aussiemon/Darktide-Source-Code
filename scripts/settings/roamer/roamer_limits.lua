-- chunkname: @scripts/settings/roamer/roamer_limits.lua

local roamer_limits = {}

local function _create_roamer_limits_entry(path)
	local roamer_limit = require(path)
	local name = roamer_limit.name
	local limits = roamer_limit.limits

	roamer_limits[name] = limits
end

_create_roamer_limits_entry("scripts/settings/roamer/default_roamer_limits")
_create_roamer_limits_entry("scripts/settings/roamer/havoc_roamer_limits")

return settings("RoamerLimits", roamer_limits)
