-- chunkname: @scripts/ui/view_elements/view_element_discard_items/view_element_discard_items_settings.lua

local elements_width = 440
local window_size = {
	elements_width + 60,
	650,
}
local content_size = {
	elements_width,
	window_size[2],
}
local discard_items_settings = {
	window_size = window_size,
	content_size = content_size,
	checkbox_size = {
		440,
		50,
	},
	confirm_button_size = {
		210,
		40,
	},
}

return settings("ViewElementDiscardItems", discard_items_settings)
