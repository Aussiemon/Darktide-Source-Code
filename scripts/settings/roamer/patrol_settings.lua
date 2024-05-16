-- chunkname: @scripts/settings/roamer/patrol_settings.lua

local patrol_settings = {}

patrol_settings.max_num_failed_astar_queries = 10
patrol_settings.min_patrol_distance = 7.5
patrol_settings.num_patrols_per_zone = 4
patrol_settings.min_members_in_patrol = 1

return settings("PatrolSettings", patrol_settings)
