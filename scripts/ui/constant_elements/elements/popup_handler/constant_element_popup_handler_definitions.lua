-- chunkname: @scripts/ui/constant_elements/elements/popup_handler/constant_element_popup_handler_definitions.lua

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
			0
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
			0
		},
		position = {
			0,
			0,
			2
		}
	},
	offer_text = {
		vertical_alignment = "top",
		parent = "center_pivot",
		horizontal_alignment = "center",
		size = {
			text_max_width,
			0
		},
		position = {
			0,
			0,
			2
		}
	},
	offer_price_text = {
		vertical_alignment = "bottom",
		parent = "offer_text",
		horizontal_alignment = "center",
		size = {
			0,
			0
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

local wallet_text_font_style = table.clone(UIFontSettings.currency_title)

wallet_text_font_style.text_horizontal_alignment = "left"
wallet_text_font_style.text_vertical_alignment = "center"

local offer_title_style = table.clone(UIFontSettings.header_1)

offer_title_style.text_horizontal_alignment = "center"
offer_title_style.horizontal_alignment = "center"
offer_title_style.text_vertical_alignment = "top"
offer_title_style.vertical_alignment = "top"
offer_title_style.font_size = 40
offer_title_style.offset = {
	0,
	0,
	1
}

local offer_sub_title_style = table.clone(UIFontSettings.terminal_header_3)

offer_sub_title_style.text_horizontal_alignment = "center"
offer_sub_title_style.horizontal_alignment = "center"
offer_sub_title_style.text_vertical_alignment = "top"
offer_sub_title_style.vertical_alignment = "top"
offer_sub_title_style.offset = {
	0,
	10,
	1
}
offer_sub_title_style.font_size = 20

local popup_type_style = {
	warning = {
		icon = "content/ui/materials/symbols/warning",
		icon_size = {
			92,
			72
		},
		icon_color = {
			255,
			162,
			6,
			6
		},
		background_color = {
			50,
			100,
			0,
			0
		},
		terminal_background_color = {
			255,
			100,
			6,
			6
		},
		title_text_color = {
			255,
			162,
			6,
			6
		},
		description_text_color = {
			255,
			212,
			194,
			194
		}
	},
	default = {
		icon = "content/ui/materials/symbols/warning",
		icon_size = {
			0,
			0
		},
		icon_color = Color.blue(127.5, true),
		background_color = Color.terminal_grid_background(50, true),
		terminal_background_color = Color.terminal_grid_background(255, true),
		title_text_color = Color.terminal_text_header(255, true),
		description_text_color = Color.terminal_text_body(255, true)
	}
}
local widget_definitions = {
	popup_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			style_id = "terminal",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					start_layer
				},
				size = {
					nil,
					0
				},
				size_addition = {
					40,
					150
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
				},
				color = Color.terminal_grid_background(255, true)
			}
		},
		{
			value = "content/ui/materials/backgrounds/popups/screen_takeover_01",
			style_id = "texture",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.terminal_background(255, true),
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
				scale_to_material = true,
				size_addition = {
					50,
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
				scale_to_material = true,
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
				scale_to_material = true,
				size_addition = {
					50,
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
				scale_to_material = true,
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
			value = "content/ui/materials/dividers/horizontal_dynamic_lower",
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
					100,
					100
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
			value = "",
			style = description_text_style
		}
	}, "description_text")
}
local wallet_definitions = UIWidget.create_definition({
	{
		style_id = "texture",
		pass_type = "texture",
		value_id = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			size = {
				42,
				30
			},
			offset = {
				0,
				0,
				1
			}
		},
		visibility_function = function (content, style)
			return content.texture
		end
	},
	{
		value_id = "text",
		style_id = "text",
		pass_type = "text",
		value = "0",
		style = wallet_text_font_style
	}
}, "offer_price_text")
local offer_definitions = UIWidget.create_definition({
	{
		value_id = "text",
		pass_type = "text",
		style_id = "text",
		value = "",
		style = offer_title_style
	},
	{
		value_id = "sub_text",
		pass_type = "text",
		style_id = "sub_text",
		value = "",
		style = offer_sub_title_style
	}
}, "offer_text")
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

				if params.additional_widgets then
					for i = 1, #params.additional_widgets do
						local widget = params.additional_widgets[i]

						widget.alpha_multiplier = alpha_multiplier
					end
				end

				widgets.edge_top.style.texture.size[1] = widgets.popup_background.style.terminal.size[1]
				widgets.edge_bottom.style.texture.size[1] = widgets.popup_background.style.terminal.size[1]

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
				widgets.popup_background.style.terminal.color = popup_type_style[popup_type].terminal_background_color
				widgets.title_text.style.text.text_color = popup_type_style[popup_type].title_text_color
				widgets.description_text.style.text.text_color = popup_type_style[popup_type].description_text_color
				widgets.top_icon.content.texture = popup_type_style[popup_type].icon
				widgets.top_icon.style.texture.color = popup_type_style[popup_type].icon_color
				widgets.top_icon.style.texture.size = popup_type_style[popup_type].icon_size

				local content_widgets = parent._content_widgets

				for i = 1, #content_widgets do
					if content_widgets[i].style.text and not content_widgets[i].content.hotspot then
						content_widgets[i].style.text.text_color = popup_type_style[popup_type].description_text_color
					end

					content_widgets[i].alpha_multiplier = alpha_multiplier
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
				widgets.popup_background.style.terminal.size_addition[2] = window_height + anim_progress * 26
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

				local content_widgets = parent._content_widgets

				for i = 1, #content_widgets do
					content_widgets[i].alpha_multiplier = anim_progress
				end

				if params.additional_widgets then
					for i = 1, #params.additional_widgets do
						local widget = params.additional_widgets[i]

						widget.alpha_multiplier = anim_progress
					end
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

				local content_widgets = parent._content_widgets

				for i = 1, #content_widgets do
					content_widgets[i].alpha_multiplier = anim_progress
				end

				if params.additional_widgets then
					for i = 1, #params.additional_widgets do
						local widget = params.additional_widgets[i]

						widget.alpha_multiplier = anim_progress
					end
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
				widgets.popup_background.style.terminal.size_addition[2] = window_height + anim_progress * 26
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
	popup_type_style = popup_type_style,
	wallet_definitions = wallet_definitions,
	offer_definitions = offer_definitions
}
