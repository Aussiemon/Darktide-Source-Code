-- chunkname: @scripts/ui/views/loading_view/loading_view_settings.lua

local loading_view_settings = {
	entry_duration = 1,
	hint_text_update_duration = 0.3,
	background_end_size = {
		2500,
		2500,
	},
	background_start_size = {
		2800,
		2800,
	},
}

return settings("LoadingViewSettings", loading_view_settings)
