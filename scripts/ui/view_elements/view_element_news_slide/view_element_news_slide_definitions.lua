-- chunkname: @scripts/ui/view_elements/view_element_news_slide/view_element_news_slide_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local Settings = require("scripts/ui/view_elements/view_element_news_slide/view_element_news_slide_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local width, height = Settings.size[1], Settings.size[2]
local bar_height = Settings.bar_size[2]
local buffer = Settings.buffer
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	news_area = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			width,
			height
		},
		position = {
			-90,
			70,
			0
		}
	},
	progress_bar = {
		vertical_alignment = "bottom",
		parent = "news_area",
		horizontal_alignment = "center",
		size = Settings.bar_size,
		position = {
			0,
			bar_height + 6 + buffer,
			0
		}
	}
}
local widget_definitions = {
	news_button = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot",
			content = {
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_click
			}
		},
		{
			style_id = "screen_background",
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			style_id = "background",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				size_addition = {
					24,
					24
				},
				offset = {
					0,
					0,
					1
				},
				color = Color.terminal_grid_background(255, true)
			}
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				default_color = Color.black(255, true),
				hover_color = Color.black(155, true),
				selected_color = Color.black(155, true),
				disabled_color = Color.black(255, true),
				offset = {
					0,
					0,
					2
				}
			},
			change_function = ButtonPassTemplates.terminal_button_change_function
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				default_color = Color.terminal_frame(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				disabled_color = Color.ui_grey_medium(255, true),
				hover_color = Color.terminal_frame_hover(nil, true),
				offset = {
					0,
					0,
					20
				}
			},
			change_function = ButtonPassTemplates.terminal_button_change_function
		},
		{
			pass_type = "texture",
			style_id = "corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				default_color = Color.terminal_corner(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true),
				disabled_color = Color.ui_grey_light(255, true),
				hover_color = Color.terminal_corner_hover(nil, true),
				offset = {
					0,
					0,
					21
				}
			},
			change_function = ButtonPassTemplates.terminal_button_change_function
		},
		{
			value = "content/ui/materials/frames/achievements/card_upper",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					nil,
					22
				},
				size_addition = {
					12,
					0
				},
				offset = {
					0,
					-10,
					22
				}
			}
		},
		{
			value = "content/ui/materials/frames/achievements/card_lower",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					nil,
					24
				},
				size_addition = {
					12,
					0
				},
				offset = {
					0,
					11,
					23
				}
			}
		},
		{
			value_id = "texture",
			style_id = "online_image",
			pass_type = "texture_uv",
			value = "content/ui/materials/backgrounds/news_feed/article_image_blank",
			style = {
				vertical_alignment = "center",
				hdr = false,
				horizontal_alignment = "center",
				size = Settings.image_size,
				offset = {
					0,
					0,
					10
				},
				uvs = {
					{
						0,
						0
					},
					{
						1,
						Settings.image_size[2] / Settings.image_size[1]
					}
				},
				material_values = {
					right_offset = 0.5,
					left_offset = 0.5
				}
			},
			visibility_function = function (content, style)
				return not not style.material_values.texture
			end
		},
		{
			style_id = "title_background",
			pass_type = "rect",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					nil,
					48
				},
				color = {
					150,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					11
				}
			}
		},
		{
			value_id = "title",
			pass_type = "text",
			style_id = "title",
			value = "",
			change_function = ButtonPassTemplates.terminal_button_change_function,
			style = table.add_missing({
				vertical_alignment = "center",
				horizontal_alignment = "center",
				text_vertical_alignment = "bottom",
				font_size = 20,
				text_horizontal_alignment = "center",
				size = {
					width - 2 * buffer,
					height - 2 * buffer
				},
				offset = {
					0,
					3,
					12
				}
			}, UIFontSettings.list_button)
		},
		{
			style_id = "body_background",
			pass_type = "rect",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				size = {
					nil,
					0
				},
				color = {
					150,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					11
				}
			}
		},
		{
			value = "content/ui/materials/gradients/gradient_horizontal",
			style_id = "body_gradient",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				size = {
					nil,
					0
				},
				color = {
					150,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					11
				}
			}
		},
		{
			value_id = "body_number",
			pass_type = "text",
			style_id = "body_number",
			value = "",
			change_function = ButtonPassTemplates.terminal_button_change_function,
			style = table.add_missing({
				vertical_alignment = "center",
				horizontal_alignment = "center",
				text_vertical_alignment = "top",
				font_size = 18,
				text_horizontal_alignment = "right",
				size = {
					width - 2 * buffer,
					height - 2 * buffer
				},
				offset = {
					0,
					0,
					12
				}
			}, UIFontSettings.list_button)
		},
		{
			value_id = "body_text",
			style_id = "body_text",
			pass_type = "text",
			value = "",
			style = table.add_missing({
				vertical_alignment = "center",
				text_vertical_alignment = "top",
				horizontal_alignment = "center",
				font_size = 18,
				text_horizontal_alignment = "right",
				size = {
					width - 2 * buffer,
					height - 2 * buffer
				},
				offset = {
					0,
					0,
					12
				},
				text_color = Color.terminal_text_body_sub_header(255, true)
			}, UIFontSettings.list_button)
		}
	}, "news_area")
}
local blueprints = {}

blueprints.loading_bar = UIWidget.create_definition({
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			size = {
				0,
				bar_height
			}
		}
	},
	{
		style_id = "background",
		pass_type = "rect",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			color = Color.terminal_frame(nil, true),
			size = {
				0,
				bar_height
			},
			offset = {
				0,
				0,
				0
			}
		}
	},
	{
		style_id = "foreground",
		pass_type = "rect",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			color = Color.terminal_icon(nil, true),
			size = {
				0,
				bar_height
			},
			offset = {
				0,
				0,
				1
			}
		},
		visibility_function = function (content, style)
			return content.active
		end
	},
	{
		style_id = "glow",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_glow_01",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "left",
			color = Color.terminal_icon(150, true),
			size = {
				0,
				bar_height
			},
			offset = {
				0,
				0,
				1
			},
			size_addition = {
				24,
				24
			}
		},
		visibility_function = function (content, style)
			return content.active and style.size[1] > 4
		end
	}
}, "progress_bar", nil, {
	0,
	bar_height
})

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	blueprints = blueprints
}
