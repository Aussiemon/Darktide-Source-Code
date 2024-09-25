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
	tutorial_popup_pages = {
		{
			button_1 = "loc_skip",
			button_2 = "loc_next",
			header = "loc_talent_menu_tutorial_header_1",
			image = "content/ui/materials/frames/talents/tutorial/talent_tree_tutorial_bg_01",
			text = "loc_talent_menu_tutorial_body_1",
		},
		{
			button_1 = "loc_previous",
			button_2 = "loc_next",
			header = "loc_talent_menu_tutorial_header_2",
			image = "content/ui/materials/frames/talents/tutorial/talent_tree_tutorial_bg_02",
			text = "loc_talent_menu_tutorial_body_2",
		},
		{
			button_1 = "loc_previous",
			button_2 = "loc_talent_menu_tutorial_final_button_label",
			header = "loc_talent_menu_tutorial_header_4",
			image = "content/ui/materials/frames/talents/tutorial/talent_tree_tutorial_bg_03",
			text = "loc_talent_menu_tutorial_body_4",
		},
	},
}

return settings("ViewElementTutorialPopupSettings", view_element_tutorial_popup)
