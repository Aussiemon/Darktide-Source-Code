local TextUtilities = require("scripts/utilities/ui/text")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local InputDevice = require("scripts/managers/input/input_device")
local ItemUtils = require("scripts/utilities/items")
local default_button_content = {
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_click
}
local title_height = 0
local edge_padding = 40
local grid_width = 430
local grid_height = 800
local bottom_chin = 0
local grid_size = {
	grid_width - edge_padding,
	grid_height
}
local grid_spacing = {
	10,
	10
}
local mask_width = grid_width
local mask_size = {
	mask_width,
	grid_height
}
local menu_settings = {
	scrollbar_width = 7,
	widget_icon_load_margin = 0,
	use_select_on_focused = true,
	use_is_focused_for_navigation = false,
	use_terminal_background = true,
	top_padding = 140,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding,
	scrollbar_position = {
		0,
		0
	},
	bottom_chin = bottom_chin
}
local background_size = {
	grid_size[1] + edge_padding,
	grid_size[2]
}
local use_horizontal_scrollbar = menu_settings.use_horizontal_scrollbar
local scrollbar_width = menu_settings.scrollbar_width
local scrollbar_vertical_margin = menu_settings.scrollbar_vertical_margin or 0
local scrollbar_height = use_horizontal_scrollbar and scrollbar_width or background_size[2] - scrollbar_vertical_margin - 20
local scrollbar_size = {
	scrollbar_width,
	scrollbar_height
}
local scrollbar_position = {
	menu_settings.scrollbar_position and menu_settings.scrollbar_position[1] or 0,
	menu_settings.scrollbar_position and menu_settings.scrollbar_position[2] or 0,
	13
}
local scenegraph_definition = {
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
	grid_scrollbar = {
		parent = "grid_background",
		size = scrollbar_size,
		position = scrollbar_position,
		horizontal_alignment = menu_settings.scrollbar_horizontal_alignment or "right",
		vertical_alignment = menu_settings.scrollbar_vertical_alignment or "top"
	},
	tab_pivot = {
		vertical_alignment = "top",
		parent = "grid_divider_top",
		horizontal_alignment = "center",
		size = {
			grid_width,
			50
		},
		position = {
			0,
			130,
			1
		}
	}
}
local item_perk_style = table.clone(UIFontSettings.header_3)
item_perk_style.offset = {
	98,
	0,
	3
}
item_perk_style.size = {
	324
}
item_perk_style.font_size = 18
item_perk_style.text_horizontal_alignment = "left"
item_perk_style.text_vertical_alignment = "top"
item_perk_style.text_color = Color.terminal_text_header(255, true)
local item_perk_description_style = table.clone(UIFontSettings.body)
item_perk_description_style.offset = {
	98,
	20,
	3
}
item_perk_description_style.size = {
	324,
	500
}
item_perk_description_style.font_size = 18
item_perk_description_style.text_horizontal_alignment = "left"
item_perk_description_style.text_vertical_alignment = "top"
item_perk_description_style.text_color = Color.terminal_text_body(255, true)
local header_style = table.clone(UIFontSettings.header_3)
header_style.font_size = 24
header_style.offset = {
	0,
	5,
	3
}
header_style.text_horizontal_alignment = "center"
header_style.text_vertical_alignment = "top"
header_style.text_color = Color.terminal_text_body(255, true)
local left_trigger_style = table.clone(UIFontSettings.header_3)
left_trigger_style.font_size = 30
left_trigger_style.offset = {
	20,
	82,
	3
}
left_trigger_style.text_horizontal_alignment = "left"
left_trigger_style.text_vertical_alignment = "top"
left_trigger_style.text_color = {
	255,
	226,
	199,
	126
}
local right_trigger_style = table.clone(UIFontSettings.header_3)
right_trigger_style.font_size = 30
right_trigger_style.offset = {
	-20,
	82,
	3
}
right_trigger_style.text_horizontal_alignment = "right"
right_trigger_style.text_vertical_alignment = "top"
right_trigger_style.text_color = {
	255,
	226,
	199,
	126
}
local widget_definitions = {
	header = UIWidget.create_definition({
		{
			value_id = "header",
			style_id = "header",
			pass_type = "text",
			value = Localize("loc_weapon_inventory_perks_title_text"),
			style = table.merge_recursive(table.clone(header_style), {
				offset = {
					0,
					40,
					0
				}
			})
		}
	}, "grid_divider_top"),
	grid_divider_top = UIWidget.create_definition({
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/frames/item_info_upper",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					0
				}
			}
		}
	}, "grid_divider_top"),
	grid_divider_bottom = UIWidget.create_definition({
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/frames/item_info_lower",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center"
			}
		}
	}, "grid_divider_bottom"),
	overlay = UIWidget.create_definition({
		{
			style_id = "overlay",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					0
				},
				size_addition = {
					-4,
					0
				},
				color = {
					0,
					0,
					0,
					0
				}
			}
		}
	}, "screen"),
	left_trigger = UIWidget.create_definition({
		{
			value_id = "left_trigger",
			style_id = "left_trigger",
			pass_type = "text",
			value = "",
			style = left_trigger_style,
			visibility_function = function ()
				return InputDevice.gamepad_active
			end
		}
	}, "grid_divider_top"),
	right_trigger = UIWidget.create_definition({
		{
			value_id = "right_trigger",
			style_id = "right_trigger",
			pass_type = "text",
			value = "",
			style = right_trigger_style,
			visibility_function = function ()
				return InputDevice.gamepad_active
			end
		}
	}, "grid_divider_top")
}
local EMPTY_TABLE = {}

local function create_tab_widgets(tab_settings)
	local tab_definitions = {}
	local max_blessings = tab_settings.max_blessings or EMPTY_TABLE
	local num_blessings = tab_settings.num_blessings or EMPTY_TABLE
	local tab_size = tab_settings.size or {
		60,
		40
	}
	local spacing = tab_settings.spacing or 20
	local offset_x = ((tab_settings.num_tabs - 1) * tab_size[1] + (tab_settings.num_tabs - 1) * spacing) * 0.5 * -1

	for i = 1, tab_settings.num_tabs do
		local current_max_blessings = max_blessings[i] or "?"
		local current_num_blessings = num_blessings[i] or "?"
		local widget_definition = UIWidget.create_definition({
			{
				pass_type = "hotspot",
				content_id = "hotspot",
				content = default_button_content,
				style = {
					vertical_alignment = "top",
					horizontal_alignment = "center",
					offset = {
						offset_x,
						-50,
						0
					},
					size = tab_size
				},
				change_function = function (content, style, animations, dt)
					local lerp_direction = content.is_hover and 1 or -1
					content.parent.progress = math.clamp((content.parent.progress or 0) + dt * lerp_direction * 4, 0, 1)
				end
			},
			{
				style_id = "background",
				pass_type = "rect",
				style = {
					vertical_alignment = "top",
					visible = true,
					horizontal_alignment = "center",
					size = tab_size,
					offset = {
						offset_x,
						-50,
						1
					},
					color = Color.terminal_frame(50, true)
				}
			},
			{
				value = "content/ui/materials/gradients/gradient_vertical",
				style_id = "background_gradient",
				pass_type = "texture",
				style = {
					vertical_alignment = "top",
					visible = true,
					horizontal_alignment = "center",
					size = tab_size,
					offset = {
						offset_x,
						-50,
						1
					},
					color = Color.terminal_frame(192, true)
				}
			},
			{
				pass_type = "texture",
				value = ItemUtils.perk_textures(nil, i),
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					size = {
						20,
						20
					},
					offset = {
						offset_x,
						-50,
						1
					},
					color = Color.terminal_icon(255, true)
				}
			},
			{
				pass_type = "texture",
				style_id = "hover_frame",
				value = "content/ui/materials/gradients/gradient_vertical",
				style = {
					vertical_alignment = "top",
					horizontal_alignment = "center",
					hdr = false,
					offset = {
						offset_x,
						-50,
						0
					},
					size = tab_size,
					color = Color.ui_terminal(0, true),
					size_addition = {
						0,
						0
					}
				},
				change_function = function (content, style)
					local progress = content.selected and 1 or content.progress
					local t = math.easeOutCubic(progress)
					style.color[1] = t * 128
				end
			},
			{
				pass_type = "texture",
				style_id = "hover_frame_border",
				value = "content/ui/materials/frames/frame_tile_1px",
				style = {
					vertical_alignment = "top",
					horizontal_alignment = "center",
					scale_to_material = true,
					offset = {
						offset_x,
						-50,
						1
					},
					size = tab_size,
					color = Color.terminal_grid_background(128, true),
					base_color = Color.terminal_grid_background(128, true),
					selected_color = Color.ui_terminal(128, true)
				},
				change_function = function (content, style)
					local progress = content.selected and 1 or content.progress
					local t = math.easeOutCubic(progress)
					style.color[2] = math.lerp(style.base_color[2], style.selected_color[2], t)
					style.color[3] = math.lerp(style.base_color[3], style.selected_color[3], t)
					style.color[4] = math.lerp(style.base_color[4], style.selected_color[4], t)
				end
			},
			{
				pass_type = "texture",
				style_id = "hover_frame_corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					vertical_alignment = "top",
					horizontal_alignment = "center",
					scale_to_material = true,
					offset = {
						offset_x,
						-50,
						2
					},
					size = tab_size,
					color = Color.terminal_grid_background(255, true),
					base_color = Color.terminal_grid_background(255, true),
					selected_color = Color.ui_terminal(255, true)
				},
				change_function = function (content, style)
					local progress = content.selected and 1 or content.progress
					local t = math.easeOutCubic(progress)
					style.color[2] = math.lerp(style.base_color[2], style.selected_color[2], t)
					style.color[3] = math.lerp(style.base_color[3], style.selected_color[3], t)
					style.color[4] = math.lerp(style.base_color[4], style.selected_color[4], t)
				end
			},
			{
				style_id = "triangle",
				pass_type = "triangle",
				style = {
					vertical_alignment = "top",
					horizontal_alignment = "center",
					offset = {
						background_size[1] * 0.5 + offset_x,
						-5,
						100
					},
					color = Color.ui_terminal(255, true),
					triangle_corners = {
						{
							-20,
							0
						},
						{
							20,
							0
						},
						{
							0,
							15
						}
					}
				},
				visibility_function = function (content, style)
					return content.selected
				end
			}
		}, "tab_pivot")
		offset_x = offset_x + tab_size[1] + spacing
		tab_definitions[#tab_definitions + 1] = widget_definition
	end

	return tab_definitions
end

return {
	menu_settings = menu_settings,
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	create_tab_widgets = create_tab_widgets
}
