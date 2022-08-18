local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")

local function create_definitions(settings)
	local scrollbar_pass_templates = settings.scrollbar_pass_templates or ScrollbarPassTemplates.default_scrollbar
	local scrollbar_width = settings.scrollbar_width
	local scrollbar_vertical_margin = settings.scrollbar_vertical_margin or 0
	local grid_size = settings.grid_size
	local mask_size = settings.mask_size
	local title_height = settings.title_height
	local edge_padding = settings.edge_padding or 0
	local background_size = {
		grid_size[1] + edge_padding,
		grid_size[2]
	}
	local scrollbar_height = background_size[2] - scrollbar_vertical_margin - 20
	local scenegraph_definition = {
		screen = UIWorkspaceSettings.screen,
		pivot = {
			vertical_alignment = "top",
			parent = "screen",
			horizontal_alignment = "left",
			size = {
				0,
				0
			},
			position = {
				0,
				0,
				1
			}
		},
		grid_divider_top = {
			vertical_alignment = "top",
			parent = "pivot",
			horizontal_alignment = "left",
			size = {
				background_size[1],
				36
			},
			position = {
				0,
				0,
				12
			}
		},
		grid_title_background = {
			vertical_alignment = "top",
			parent = "grid_divider_top",
			horizontal_alignment = "center",
			size = {
				background_size[1],
				title_height
			},
			position = {
				0,
				15,
				-10
			}
		},
		grid_divider_title = {
			vertical_alignment = "bottom",
			parent = "grid_title_background",
			horizontal_alignment = "center",
			size = {
				background_size[1],
				44
			},
			position = {
				0,
				22,
				12
			}
		},
		grid_background = {
			vertical_alignment = "top",
			parent = "grid_title_background",
			horizontal_alignment = "center",
			size = background_size,
			position = {
				0,
				title_height,
				1
			}
		},
		grid_divider_bottom = {
			vertical_alignment = "bottom",
			parent = "grid_background",
			horizontal_alignment = "center",
			size = {
				background_size[1],
				36
			},
			position = {
				0,
				16,
				12
			}
		},
		grid_content_pivot = {
			vertical_alignment = "top",
			parent = "grid_background",
			horizontal_alignment = "left",
			size = {
				0,
				0
			},
			position = {
				edge_padding * 0.5,
				0,
				1
			}
		},
		grid_scrollbar = {
			vertical_alignment = "center",
			parent = "grid_background",
			horizontal_alignment = "right",
			size = {
				scrollbar_width,
				scrollbar_height
			},
			position = {
				0,
				0,
				13
			}
		},
		grid_mask = {
			vertical_alignment = "center",
			parent = "grid_background",
			horizontal_alignment = "center",
			size = mask_size,
			position = {
				0,
				0,
				10
			}
		},
		grid_interaction = {
			vertical_alignment = "top",
			parent = "grid_background",
			horizontal_alignment = "left",
			size = mask_size,
			position = {
				0,
				0,
				0
			}
		},
		title_text = {
			vertical_alignment = "center",
			parent = "grid_title_background",
			horizontal_alignment = "center",
			size = {
				960,
				50
			},
			position = {
				0,
				0,
				2
			}
		},
		sort_button = {
			vertical_alignment = "bottom",
			parent = "grid_divider_bottom",
			horizontal_alignment = "left",
			size = {
				background_size[1] / 2,
				20
			},
			position = {
				10,
				20,
				1
			}
		},
		timer_text = {
			vertical_alignment = "bottom",
			parent = "grid_divider_bottom",
			horizontal_alignment = "right",
			size = {
				background_size[1] / 2,
				20
			},
			position = {
				-10,
				20,
				1
			}
		}
	}
	local title_text_font_style = table.clone(UIFontSettings.grid_title)
	local sort_button_style = table.clone(UIFontSettings.body_small)
	sort_button_style.text_horizontal_alignment = "left"
	sort_button_style.text_vertical_alignment = "center"
	sort_button_style.text_color = Color.ui_grey_light(255, true)
	sort_button_style.default_text_color = Color.ui_grey_light(255, true)
	sort_button_style.hover_color = {
		255,
		255,
		255,
		255
	}
	local timer_text_style = table.clone(sort_button_style)
	timer_text_style.text_horizontal_alignment = "right"
	local widget_definitions = {
		title_text = UIWidget.create_definition({
			{
				value = "",
				value_id = "text",
				pass_type = "text",
				style = title_text_font_style
			}
		}, "title_text"),
		grid_divider_top = UIWidget.create_definition({
			{
				pass_type = "texture",
				value = "content/ui/materials/dividers/horizontal_frame_big_upper"
			}
		}, "grid_divider_top"),
		grid_divider_bottom = UIWidget.create_definition({
			{
				pass_type = "texture",
				value = "content/ui/materials/dividers/horizontal_frame_big_lower"
			}
		}, "grid_divider_bottom"),
		grid_divider_title = UIWidget.create_definition({
			{
				pass_type = "texture",
				value = "content/ui/materials/dividers/horizontal_frame_big_middle"
			}
		}, "grid_divider_title"),
		grid_title_background = UIWidget.create_definition({
			{
				value = "content/ui/materials/backgrounds/headline_terminal",
				pass_type = "texture",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					size_addition = {
						-4,
						0
					},
					color = Color.ui_terminal(70, true),
					offset = {
						0,
						0,
						1
					}
				}
			},
			{
				pass_type = "rect",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					size_addition = {
						-4,
						0
					},
					color = {
						100,
						0,
						0,
						0
					}
				}
			}
		}, "grid_title_background"),
		grid_background = UIWidget.create_definition({
			{
				pass_type = "rect",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					size_addition = {
						-4,
						0
					},
					color = {
						100,
						0,
						0,
						0
					}
				}
			}
		}, "grid_background"),
		grid_scrollbar = UIWidget.create_definition(scrollbar_pass_templates, "grid_scrollbar"),
		grid_interaction = UIWidget.create_definition({
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			}
		}, "grid_interaction"),
		sort_button = UIWidget.create_definition({
			{
				style_id = "text",
				pass_type = "text",
				value_id = "text",
				style = sort_button_style,
				change_function = function (content, style)
					local hotspot = content.hotspot
					local default_text_color = style.default_text_color
					local hover_color = style.hover_color
					local text_color = style.text_color
					local progress = math.max(hotspot.anim_hover_progress or 0, hotspot.anim_input_progress or 0)

					for i = 2, 4, 1 do
						text_color[i] = (hover_color[i] - default_text_color[i]) * progress + default_text_color[i]
					end
				end
			},
			{
				pass_type = "hotspot",
				content_id = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.default_select
				}
			}
		}, "sort_button"),
		timer_text = UIWidget.create_definition({
			{
				value = "text",
				value_id = "text",
				pass_type = "text",
				style = timer_text_style
			}
		}, "timer_text")
	}

	return {
		widget_definitions = widget_definitions,
		scenegraph_definition = scenegraph_definition
	}
end

return create_definitions
