-- chunkname: @scripts/ui/views/report_player_view/report_player_view_settings.lua

local elements_width = 800
local window_size = {
	elements_width + 60,
	730,
}
local content_size = {
	elements_width,
	window_size[2],
}
local report_player_view_settings = {
	window_size = window_size,
	content_size = content_size,
	report_button_size = {
		440,
		40,
	},
	dropdown_size = {
		800,
		50,
	},
	comment_input_text_size = {
		800,
		40,
	},
}

return settings("ReportPlayerViewSettings", report_player_view_settings)
