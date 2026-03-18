-- chunkname: @scripts/ui/view_elements/view_element_tutorial_popup/view_element_tutorial_popup_settings.lua

local tutorial_window_size = {
	900,
	576,
}
local tutorial_grid_size = {
	tutorial_window_size[1] - 420,
	tutorial_window_size[2] - 225,
}
local view_element_tutorial_popup = {
	tooltip_fade_delay = 0.3,
	tooltip_fade_speed = 7,
	tutorial_window_size = tutorial_window_size,
	tutorial_grid_size = tutorial_grid_size,
}

return settings("ViewElementTutorialPopupSettings", view_element_tutorial_popup)
