-- chunkname: @scripts/managers/server_metrics/server_metrics_names.lua

local gauge_metrics = table.enum("utilized", "connected_players", "target_frame_time", "spawned_minions")
local counter_metrics = table.enum("missed_frame_time", "lagging_frames")

return {
	gauge = gauge_metrics,
	counter = counter_metrics
}
