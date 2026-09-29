-- chunkname: @scripts/ui/views/news_view/news_view_settings.lua

local window_size = {
	1400,
	700
}
local image_size = {
	window_size[1] * 0.5,
	window_size[2]
}
local grid_size = {
	window_size[1] - image_size[1],
	window_size[2] - 225
}
local news_view_settings = {
	window_size = window_size,
	grid_size = grid_size,
	image_size = image_size,
	slide_thumb_size = {
		20,
		4
	}
}

return settings("NewsViewSettings", news_view_settings)
