-- chunkname: @scripts/ui/view_elements/view_element_news_slide/view_element_news_slide_settings.lua

local ElementSettings = {}

ElementSettings.buffer = 6
ElementSettings.size = {
	420,
	210
}
ElementSettings.image_size = {
	410,
	210
}
ElementSettings.bar_size = {
	320,
	8
}
ElementSettings.selected_factor = 6
ElementSettings.transition_time = 0.4
ElementSettings.total_time = 16

return settings("ViewElementNewsSlideSettings", ElementSettings)
