-- chunkname: @scripts/ui/view_elements/view_element_tutorial_popup/view_element_tutorial_popup_templates.lua

local Settings = require("scripts/ui/view_elements/view_element_tutorial_popup/view_element_tutorial_popup_settings")
local tutorial_window_size = Settings.tutorial_window_size
local tutorial_grid_size = Settings.tutorial_grid_size
local templates = {
	default = {
		layout_function = function (page_content, page_index, num_pages)
			local layout = {}

			layout[#layout + 1] = {
				widget_type = "counter",
				current_page = page_index,
				total_pages = num_pages,
			}
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					tutorial_grid_size[1],
					30,
				},
			}
			layout[#layout + 1] = {
				widget_type = "main_header",
				text = Localize(page_content.header),
			}
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					tutorial_grid_size[1],
					10,
				},
			}
			layout[#layout + 1] = {
				widget_type = "text",
				text = page_content.text,
			}

			return layout
		end,
		image_size = {
			tutorial_window_size[1] - (tutorial_grid_size[1] + 60),
			tutorial_window_size[2],
		},
	},
	three_texts_right = {
		layout_function = function (page_content, page_index, num_pages)
			local layout = {}

			layout[#layout + 1] = {
				text_horizontal_alignment = "center",
				widget_type = "counter",
				current_page = page_index,
				total_pages = num_pages,
			}
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					tutorial_window_size[1],
					30,
				},
			}
			layout[#layout + 1] = {
				widget_type = "header",
				text = Localize(page_content.title_1),
				x_offset = tutorial_window_size[1] * 0.5 - 20,
				width = tutorial_window_size[1] * 0.5,
			}
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					tutorial_window_size[1],
					10,
				},
			}
			layout[#layout + 1] = {
				widget_type = "text",
				text = Localize(page_content.text_1),
				x_offset = tutorial_window_size[1] * 0.5 - 20,
				width = tutorial_window_size[1] * 0.5,
			}
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					tutorial_window_size[1],
					60,
				},
			}
			layout[#layout + 1] = {
				widget_type = "header",
				text = Localize(page_content.title_2),
				x_offset = tutorial_window_size[1] * 0.5 - 20,
				width = tutorial_window_size[1] * 0.5,
			}
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					tutorial_window_size[1],
					10,
				},
			}
			layout[#layout + 1] = {
				widget_type = "text",
				text = Localize(page_content.text_2),
				x_offset = tutorial_window_size[1] * 0.5 - 20,
				width = tutorial_window_size[1] * 0.5,
			}
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					tutorial_window_size[1],
					60,
				},
			}
			layout[#layout + 1] = {
				widget_type = "header",
				text = Localize(page_content.title_3),
				x_offset = tutorial_window_size[1] * 0.5 - 20,
				width = tutorial_window_size[1] * 0.5,
			}
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					tutorial_window_size[1],
					10,
				},
			}
			layout[#layout + 1] = {
				widget_type = "text",
				text = Localize(page_content.text_3),
				x_offset = tutorial_window_size[1] * 0.5 - 20,
				width = tutorial_window_size[1] * 0.5,
			}

			return layout
		end,
		image_size = {
			tutorial_window_size[1] - (tutorial_grid_size[1] + 60),
			tutorial_window_size[2],
		},
	},
	single_text_bottom = {
		layout_function = function (page_content, page_index, num_pages)
			local layout = {}

			layout[#layout + 1] = {
				text_horizontal_alignment = "center",
				widget_type = "counter",
				current_page = page_index,
				total_pages = num_pages,
			}
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					tutorial_grid_size[1],
					10,
				},
			}
			layout[#layout + 1] = {
				text_horizontal_alignment = "center",
				widget_type = "main_header",
				x_offset = 20,
				text = Localize(page_content.header),
				width = tutorial_window_size[1] - 40,
			}
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					tutorial_grid_size[1],
					340,
				},
			}
			layout[#layout + 1] = {
				text_horizontal_alignment = "center",
				widget_type = "text",
				x_offset = 120,
				text = Localize(page_content.text),
				width = tutorial_window_size[1] - 240,
			}

			return layout
		end,
		image_size = {
			tutorial_window_size[1],
			tutorial_window_size[2],
		},
	},
}

return templates
