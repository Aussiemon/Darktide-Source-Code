-- chunkname: @scripts/ui/view_elements/view_element_tutorial_popup/view_element_tutorial_popup_settings.lua

local tutorial_window_size = {
	900,
	576
}
local tutorial_grid_size = {
	tutorial_window_size[1] - 420,
	tutorial_window_size[2] - 225
}
local view_element_tutorial_popup = {
	tooltip_fade_speed = 7,
	tooltip_fade_delay = 0.3,
	tutorial_window_size = tutorial_window_size,
	tutorial_grid_size = tutorial_grid_size,
	tutorial_popup_pages = {
		{
			text = "loc_talent_menu_tutorial_body_1",
			header = "loc_talent_menu_tutorial_header_1",
			button_2 = "loc_next",
			image = "content/ui/materials/frames/talents/tutorial/talent_tree_tutorial_bg_01",
			button_1 = "loc_skip"
		},
		{
			text = "loc_talent_menu_tutorial_body_2",
			header = "loc_talent_menu_tutorial_header_2",
			button_2 = "loc_next",
			image = "content/ui/materials/frames/talents/tutorial/talent_tree_tutorial_bg_02",
			button_1 = "loc_previous"
		},
		{
			text = "loc_talent_menu_tutorial_body_4",
			header = "loc_talent_menu_tutorial_header_4",
			button_2 = "loc_talent_menu_tutorial_final_button_label",
			image = "content/ui/materials/frames/talents/tutorial/talent_tree_tutorial_bg_03",
			button_1 = "loc_previous"
		}
	}
}

return settings("ViewElementTutorialPopupSettings", view_element_tutorial_popup)
