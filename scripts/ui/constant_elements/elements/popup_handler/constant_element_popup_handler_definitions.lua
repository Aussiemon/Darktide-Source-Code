local ConstantElementWarningPopupsSettings = require("scripts/ui/constant_elements/elements/popup_handler/constant_element_popup_handler_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local start_layer = 1
local text_max_width = ConstantElementWarningPopupsSettings.text_max_width
local button_height = ConstantElementWarningPopupsSettings.button_height
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	center_pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			start_layer + 1
		}
	},
	top_icon = {
		vertical_alignment = "top",
		parent = "center_pivot",
		horizontal_alignment = "center",
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
	title_text = {
		vertical_alignment = "top",
		parent = "center_pivot",
		horizontal_alignment = "center",
		size = {
			text_max_width,
			50
		},
		position = {
			0,
			0,
			1
		}
	},
	description_text = {
		vertical_alignment = "top",
		parent = "center_pivot",
		horizontal_alignment = "center",
		size = {
			text_max_width,
			50
		},
		position = {
			0,
			0,
			2
		}
	},
	button_pivot = {
		vertical_alignment = "top",
		parent = "center_pivot",
		horizontal_alignment = "center",
		size = {
			0,
			button_height
		},
		position = {
			0,
			0,
			3
		}
	}
}
local title_text_style = table.clone(UIFontSettings.header_2)
title_text_style.text_horizontal_alignment = "center"
title_text_style.text_vertical_alignment = "top"
local description_text_style = table.clone(UIFontSettings.body)
description_text_style.text_horizontal_alignment = "center"
description_text_style.text_vertical_alignment = "top"
local popup_type_style = {
	warning = {
		icon = "content/ui/materials/symbols/warning",
		icon_size = {
			92,
			72
		},
		icon_color = Color.ui_brown_light(255, true),
		background_color = Color.red(76.5, true)
	},
	default = {
		icon = "content/ui/materials/symbols/warning",
		icon_size = {
			0,
			0
		},
		icon_color = Color.ui_brown_light(255, true),
		background_color = Color.ui_brown_light(76.5, true)
	}
}
local widget_definitions = {
	popup_background = UIWidget.create_definition({
		{
			style_id = "rect",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				offset = {
					0,
					0,
					start_layer
				},
				size_addition = {
					0,
					0
				},
				size = {
					nil,
					0
				},
				color = {
					166,
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/popups/screen_takeover_01",
			style_id = "texture",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size_addition = {
					0,
					0
				},
				offset = {
					0,
					0,
					start_layer + 1
				},
				size = {
					1822,
					430
				},
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				}
			}
		}
	}, "screen"),
	edge_top = UIWidget.create_definition({
		{
			value = "content/ui/materials/dividers/horizontal_dynamic_upper",
			style_id = "texture",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size_addition = {
					0,
					0
				},
				offset = {
					0,
					0,
					start_layer + 2
				},
				size = {
					252,
					10
				}
			}
		},
		{
			value = "content/ui/materials/dividers/skull_rendered_center_01",
			style_id = "texture_center",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size_addition = {
					0,
					0
				},
				offset = {
					0,
					0,
					start_layer + 3
				},
				size = {
					140,
					18
				}
			}
		}
	}, "screen"),
	edge_bottom = UIWidget.create_definition({
		{
			value = "content/ui/materials/dividers/horizontal_dynamic_lower",
			style_id = "texture",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size_addition = {
					0,
					0
				},
				offset = {
					0,
					0,
					start_layer + 2
				},
				size = {
					252,
					10
				}
			}
		},
		{
			value = "content/ui/materials/dividers/skull_rendered_center_02",
			style_id = "texture_center",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size_addition = {
					0,
					0
				},
				offset = {
					0,
					10,
					start_layer + 3
				},
				size = {
					306,
					48
				}
			}
		}
	}, "screen"),
	top_icon = UIWidget.create_definition({
		{
			style_id = "texture",
			value_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/symbols/warning",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size_addition = {
					0,
					0
				},
				offset = {
					0,
					0,
					start_layer + 2
				},
				size = {
					0,
					0
				}
			}
		}
	}, "top_icon"),
	title_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "title_text",
			style = title_text_style
		}
	}, "title_text"),
	description_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "Press the new button for this action.",
			style = description_text_style
		}
	}, "description_text")
}
local anim_start_delay = 0
local animations = {
	on_enter = {
		{
			name = "init",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local alpha_multiplier = 0
				parent._animated_alpha_multiplier = alpha_multiplier
				widgets.title_text.alpha_multiplier = alpha_multiplier
				widgets.description_text.alpha_multiplier = alpha_multiplier
				widgets.top_icon.alpha_multiplier = alpha_multiplier
				widgets.edge_top.style.texture.size[1] = widgets.popup_background.style.rect.size[1]
				widgets.edge_bottom.style.texture.size[1] = widgets.popup_background.style.rect.size[1]
				local popup_type = "default"

				if parent._popup_type then
					for name, _ in pairs(popup_type_style) do
						if parent._popup_type == name then
							popup_type = name

							break
						end
					end
				end

				widgets.popup_background.style.texture.color = popup_type_style[popup_type].background_color
				widgets.top_icon.content.texture = popup_type_style[popup_type].icon
				widgets.top_icon.style.texture.color = popup_type_style[popup_type].icon_color
				widgets.top_icon.style.texture.size = popup_type_style[popup_type].icon_size
				local button_widgets = parent._button_widgets

				for i = 1, #button_widgets do
					button_widgets[i].alpha_multiplier = alpha_multiplier
				end
			end
		},
		{
			name = "open",
			start_time = anim_start_delay + 0,
			end_time = anim_start_delay + 0.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				parent._animated_alpha_multiplier = anim_progress
				local popup_height = params.popup_height
				local window_height = popup_height * anim_progress
				local background_height = widgets.popup_background.style.texture.size[2]
				local background_limit = math.min(popup_height, background_height)
				local normalized_end_height = background_limit / background_height
				local uv_v_mid_value = normalized_end_height * 0.5
				widgets.popup_background.style.texture.size_addition[2] = -background_height + background_limit * anim_progress
				widgets.popup_background.style.texture.uvs[1][2] = uv_v_mid_value - uv_v_mid_value * anim_progress
				widgets.popup_background.style.texture.uvs[2][2] = uv_v_mid_value + uv_v_mid_value * anim_progress
				widgets.popup_background.style.rect.size_addition[2] = window_height
				widgets.edge_bottom.offset[2] = window_height * 0.5
				widgets.edge_top.offset[2] = -window_height * 0.5
			end
		},
		{
			name = "fade_in",
			start_time = anim_start_delay + 0.2,
			end_time = anim_start_delay + 0.4,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				widgets.title_text.alpha_multiplier = anim_progress
				widgets.description_text.alpha_multiplier = anim_progress
				widgets.top_icon.alpha_multiplier = anim_progress
				local button_widgets = parent._button_widgets

				for i = 1, #button_widgets do
					button_widgets[i].alpha_multiplier = anim_progress
				end
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_time = anim_start_delay + 0,
			end_time = anim_start_delay + 0.4,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeInCubic(1 - progress)
				widgets.title_text.alpha_multiplier = anim_progress
				widgets.description_text.alpha_multiplier = anim_progress
				widgets.top_icon.alpha_multiplier = anim_progress
				local button_widgets = parent._button_widgets

				for i = 1, #button_widgets do
					button_widgets[i].alpha_multiplier = anim_progress
				end
			end
		},
		{
			name = "close",
			start_time = anim_start_delay + 0.2,
			end_time = anim_start_delay + 0.4,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeInCubic(1 - progress)
				parent._animated_alpha_multiplier = anim_progress
				local popup_height = params.popup_height
				local window_height = popup_height * anim_progress
				local background_height = widgets.popup_background.style.texture.size[2]
				local background_limit = math.min(popup_height, background_height)
				local normalized_end_height = background_limit / background_height
				local uv_v_mid_value = normalized_end_height * 0.5
				widgets.popup_background.style.texture.size_addition[2] = -background_height + background_limit * anim_progress
				widgets.popup_background.style.texture.uvs[1][2] = uv_v_mid_value - uv_v_mid_value * anim_progress
				widgets.popup_background.style.texture.uvs[2][2] = uv_v_mid_value + uv_v_mid_value * anim_progress
				widgets.popup_background.style.rect.size_addition[2] = window_height
				widgets.edge_bottom.offset[2] = window_height * 0.5
				widgets.edge_top.offset[2] = -window_height * 0.5
			end
		}
	}
}

return {
	button_definition = UIWidget.create_definition(ButtonPassTemplates.default_button, "button_pivot", nil, {
		button_height,
		button_height
	}),
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	popup_type_style = popup_type_style
}
