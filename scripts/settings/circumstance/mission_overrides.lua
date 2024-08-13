-- chunkname: @scripts/settings/circumstance/mission_overrides.lua

local HazardPropOverrides = require("scripts/settings/circumstance/mission_overrides/hazard_prop_overrides")
local HealthStationOverrides = require("scripts/settings/circumstance/mission_overrides/health_station_overrides")
local PickupOverrides = require("scripts/settings/circumstance/mission_overrides/pickup_overrides")
local MissionOverrides = {}

local function add_overrides(destination, source)
	for name, entry in pairs(source) do
		destination[name] = entry
	end
end

add_overrides(MissionOverrides, HazardPropOverrides)
add_overrides(MissionOverrides, HealthStationOverrides)
add_overrides(MissionOverrides, PickupOverrides)

MissionOverrides.merge = function (...)
	local t = {}
	local arg_count = select("#", ...)

	for i = 1, arg_count do
		local mission_override_name = select(i, ...)
		local mission_override = MissionOverrides[mission_override_name]
		local _, overwritten = table.merge_recursive_advanced(t, mission_override, true)
	end
end

return settings("MissionOverrides", MissionOverrides)
