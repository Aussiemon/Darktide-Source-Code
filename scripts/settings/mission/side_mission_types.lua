-- chunkname: @scripts/settings/mission/side_mission_types.lua

local side_mission_types = table.enum("none", "luggable", "collect")

return settings("SideMissionTypes", side_mission_types)
