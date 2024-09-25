-- chunkname: @scripts/ui/view_elements/view_element_tutorial_overlay/view_element_tutorial_overlay_settings.lua

local view_element_tutorial_overlay_settings = {
	default_color_intensity_value = 0.25,
	mask_padding_pixel_size = 40,
	window_margins_height = 30,
	window_margins_width = 75,
	window_max_width = 225,
}

return settings("ViewElementTutorialOverlaySettings", view_element_tutorial_overlay_settings)
