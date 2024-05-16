-- chunkname: @scripts/managers/server_metrics/server_metrics_names.lua

local gauge_metrics = table.enum("utilized", "connected_players", "target_frame_time", "spawned_minions", "progression")
local counter_metrics = table.enum("missed_frame_time", "lagging_frames", "lagging_frames_bucket1", "lagging_frames_bucket2", "lagging_frames_bucket3", "lagging_frames_bucket4", "lagging_frames_bucket5", "lagging_frames_bucket6", "lagging_frames_bucket7")

return {
	gauge = gauge_metrics,
	counter = counter_metrics,
}
