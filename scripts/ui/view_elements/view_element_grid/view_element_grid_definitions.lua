local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")

local function create_definitions(settings)
	local use_horizontal_scrollbar = settings.use_horizontal_scrollbar
	local scrollbar_pass_templates = settings.scrollbar_pass_templates or ScrollbarPassTemplates.terminal_scrollbar
	local scrollbar_width = settings.scrollbar_width
	local scrollbar_vertical_margin = settings.scrollbar_vertical_margin or 0
	local grid_size = settings.grid_size
	local mask_size = settings.mask_size
	local title_height = settings.title_height
	local edge_padding = settings.edge_padding or 0
	local using_custom_gamepad_navigation = settings.using_custom_gamepad_navigation
	local background_size = {
		grid_size[1] + edge_padding,
		grid_size[2]
	}
	local scrollbar_height = use_horizontal_scrollbar and scrollbar_width or background_size[2] - scrollbar_vertical_margin - 20

	if use_horizontal_scrollbar then
		scrollbar_width = background_size[1] - scrollbar_vertical_margin - 20
	end

	local scrollbar_size = {
		scrollbar_width,
		scrollbar_height
	}
	local scrollbar_position = {
		settings.scrollbar_position and settings.scrollbar_position[1] or 0,
		settings.scrollbar_position and settings.scrollbar_position[2] or 0,
		13
	}
	local background_icon_width = math.min(grid_size[1], 480)
	local background_icon_height = math.min(grid_size[2], 480)
	local background_icon_aspect_ratio = background_icon_width / background_icon_height

	if background_icon_height < background_icon_width then
		background_icon_width = background_icon_width * background_icon_aspect_ratio
	elseif background_icon_width < background_icon_height then
		background_icon_height = background_icon_height * background_icon_aspect_ratio
	end

	local background_icon_size = {
		background_icon_width,
		background_icon_height
	}
	local use_terminal_background = settings.use_terminal_background
	local use_solid_terminal_background = settings.use_solid_terminal_background
	local terminal_background_icon = settings.terminal_background_icon
	local hide_dividers = settings.hide_dividers
	local hide_background = settings.hide_background
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
				10
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
				13,
				-3
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
				3
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
				0
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
				3
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
				3
			}
		},
		grid_scrollbar = {
			parent = "grid_background",
			size = scrollbar_size,
			position = scrollbar_position,
			horizontal_alignment = settings.scrollbar_horizontal_alignment or "right",
			vertical_alignment = settings.scrollbar_vertical_alignment or "center"
		},
		grid_mask = {
			vertical_alignment = "center",
			parent = "grid_background",
			horizontal_alignment = "center",
			size = mask_size,
			position = {
				0,
				0,
				2
			}
		},
		grid_interaction = {
			vertical_alignment = "top",
			parent = "grid_mask",
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
				3
			}
		},
		sort_button = {
			vertical_alignment = "bottom",
			parent = "grid_divider_bottom",
			horizontal_alignment = "left",
			size = {
				background_size[1],
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
	sort_button_style.text_color = Color.terminal_text_body(255, true)
	sort_button_style.default_text_color = Color.terminal_text_body(255, true)
	sort_button_style.hover_color = Color.terminal_text_header_selected(255, true)
	local empty_message_style = table.clone(UIFontSettings.grid_title)
	empty_message_style.text_horizontal_alignment = "center"
	empty_message_style.text_vertical_alignment = "center"
	local timer_text_style = table.clone(sort_button_style)
	timer_text_style.text_horizontal_alignment = "right"
	timer_text_style.font_size = 24
	timer_text_style.text_color = Color.terminal_text_body_sub_header(255, true)
	timer_text_style.default_text_color = Color.terminal_text_body_sub_header(255, true)
	local widget_definitions = {
		title_text = UIWidget.create_definition({
			{
				value_id = "text",
				style_id = "text",
				pass_type = "text",
				value = "",
				style = title_text_font_style
			}
		}, "title_text"),
		grid_divider_title = UIWidget.create_definition({
			{
				value_id = "texture",
				style_id = "texture",
				pass_type = "texture",
				value = "content/ui/materials/dividers/horizontal_frame_big_middle",
				style = {
					vertical_alignment = "bottom",
					scale_to_material = true,
					horizontal_alignment = "center"
				}
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
					color = Color.terminal_grid_background(100, true),
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
					color = Color.terminal_background(nil, true)
				}
			}
		}, "grid_title_background"),
		grid_background = UIWidget.create_definition(use_terminal_background and {
			{
				value = "content/ui/materials/backgrounds/terminal_basic",
				pass_type = "texture",
				style = {
					vertical_alignment = "center",
					scale_to_material = true,
					horizontal_alignment = "center",
					size_addition = {
						18,
						24
					},
					color = Color.terminal_grid_background(hide_background and 0 or nil, true)
				}
			},
			terminal_background_icon and {
				pass_type = "texture",
				value = terminal_background_icon,
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					color = Color.terminal_grid_background_icon(nil, true),
					size = background_icon_size
				}
			}
		} or use_solid_terminal_background and {
			{
				pass_type = "texture",
				style_id = "outer_shadow",
				value = "content/ui/materials/frames/dropshadow_heavy",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					scale_to_material = true,
					color = Color.ui_terminal(nil, true),
					size_addition = {
						23,
						24
					},
					offset = {
						0,
						0,
						-1
					}
				},
				change_function = function (content, style, _, dt)
					local anim_speed = 5
					local anim_hover_progress = style.anim_hover_progress or 0

					if content.hovered then
						anim_hover_progress = math.min(anim_hover_progress + dt * anim_speed, 1)
					else
						anim_hover_progress = math.max(anim_hover_progress - dt * anim_speed, 0)
					end

					style.anim_hover_progress = anim_hover_progress
					style.color[1] = 255 * anim_hover_progress
				end
			},
			{
				pass_type = "texture",
				style_id = "background_gradient",
				value = "content/ui/materials/gradients/gradient_vertical",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					default_color = Color.terminal_background_gradient(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					disabled_color = Color.ui_grey_medium(255, true),
					offset = {
						0,
						0,
						2
					}
				},
				change_function = function (content, style, _, dt)
					local anim_speed = 5
					local anim_hover_progress = style.anim_hover_progress or 0
					local hovered = content.hovered

					if content.hovered then
						anim_hover_progress = math.min(anim_hover_progress + dt * anim_speed, 1)
					else
						anim_hover_progress = math.max(anim_hover_progress - dt * anim_speed, 0)
					end

					style.anim_hover_progress = anim_hover_progress
					local default_alpha = 155
					local hover_alpha = anim_hover_progress * 100
					local style_color = style.text_color or style.color
					style_color[1] = math.clamp(default_alpha + hover_alpha, 0, 255)
					local default_color = style.default_color
					local hover_color = style.hover_color
					local color = nil

					if hovered and hover_color then
						color = hover_color
					else
						color = default_color
					end

					local ignore_alpha = true

					ColorUtilities.color_copy(color, style_color, ignore_alpha)
				end
			},
			{
				value = "content/ui/materials/backgrounds/default_square",
				pass_type = "texture",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					size_addition = {
						0,
						0
					},
					color = {
						hide_background and 0 or 255,
						0,
						0,
						0
					}
				}
			},
			{
				value = "content/ui/materials/backgrounds/terminal_basic",
				pass_type = "texture",
				style = {
					vertical_alignment = "center",
					scale_to_material = true,
					horizontal_alignment = "center",
					size_addition = {
						28,
						24
					},
					color = Color.terminal_grid_background(hide_background and 0 or nil, true),
					offset = {
						0,
						0,
						1
					}
				}
			},
			terminal_background_icon and {
				pass_type = "texture",
				value = terminal_background_icon,
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					color = Color.terminal_grid_background_icon(nil, true),
					size = background_icon_size
				}
			}
		} or {
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
						hide_background and 0 or 100,
						0,
						0,
						0
					}
				}
			}
		}, "grid_background"),
		grid_loading = UIWidget.create_definition({
			{
				pass_type = "rect",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					size_addition = {
						-8,
						0
					},
					color = {
						100,
						0,
						0,
						0
					},
					offset = {
						0,
						0,
						2
					}
				},
				visibility_function = function (content, style)
					return content.is_loading
				end
			},
			{
				pass_type = "rotated_texture",
				value = "content/ui/materials/loading/loading_small",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					angle = 0,
					size = {
						60,
						60
					},
					color = Color.terminal_corner_hover(255, true),
					offset = {
						0,
						0,
						3
					}
				},
				change_function = function (content, style, _, dt)
					local add = -0.5 * dt
					style.rotation_progress = ((style.rotation_progress or 0) + add) % 1
					style.angle = style.rotation_progress * math.pi * 2
				end,
				visibility_function = function (content, style)
					return content.is_loading
				end
			}
		}, "grid_background"),
		grid_empty = UIWidget.create_definition({
			{
				style_id = "text",
				pass_type = "text",
				value_id = "text",
				style = empty_message_style,
				value = Localize("loc_item_grid_empty")
			}
		}, "grid_background", {
			visible = false
		}),
		grid_scrollbar = UIWidget.create_definition(scrollbar_pass_templates, "grid_scrollbar", {
			axis = use_horizontal_scrollbar and 1 or 2,
			using_custom_gamepad_navigation = using_custom_gamepad_navigation
		}),
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

					for i = 2, 4 do
						text_color[i] = (hover_color[i] - default_text_color[i]) * progress + default_text_color[i]
					end
				end
			},
			{
				pass_type = "hotspot",
				content_id = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.default_click
				}
			}
		}, "sort_button"),
		timer_text = UIWidget.create_definition({
			{
				value_id = "text",
				style_id = "text",
				pass_type = "text",
				value = "text",
				style = timer_text_style
			}
		}, "timer_text")
	}

	if not hide_dividers then
		widget_definitions.grid_divider_top = UIWidget.create_definition({
			{
				value_id = "texture",
				style_id = "texture",
				pass_type = "texture",
				value = "content/ui/materials/dividers/horizontal_frame_big_upper",
				style = {
					vertical_alignment = "top",
					scale_to_material = true,
					horizontal_alignment = "center"
				}
			}
		}, "grid_divider_top")
		widget_definitions.grid_divider_bottom = UIWidget.create_definition({
			{
				value_id = "texture",
				style_id = "texture",
				pass_type = "texture",
				value = "content/ui/materials/dividers/horizontal_frame_big_lower",
				style = {
					vertical_alignment = "center",
					scale_to_material = true,
					horizontal_alignment = "center"
				}
			}
		}, "grid_divider_bottom")
	end

	return {
		widget_definitions = widget_definitions,
		scenegraph_definition = scenegraph_definition
	}
end

return create_definitions
