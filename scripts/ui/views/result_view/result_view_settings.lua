-- chunkname: @scripts/ui/views/result_view/result_view_settings.lua

local result_view_settings = {
	background_duration = 7,
	duration = 3,
	entry_duration = 1,
	exit_duration = 1,
	text_background_edge_width = 235,
	background_end_size = {
		2500,
		2500,
	},
	background_start_size = {
		2800,
		2800,
	},
}

return settings("ResultViewSettings", result_view_settings)
