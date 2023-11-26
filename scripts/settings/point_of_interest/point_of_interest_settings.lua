-- chunkname: @scripts/settings/point_of_interest/point_of_interest_settings.lua

local point_of_interest_settings = {}

point_of_interest_settings.default_view_distance = 10
point_of_interest_settings.broadphase_cell_size = 30
point_of_interest_settings.seen_recently_threshold = 15
point_of_interest_settings.max_view_distance = 50
point_of_interest_settings.event_trigger_interval = 1

return settings("PointOfInterestSettings", point_of_interest_settings)
