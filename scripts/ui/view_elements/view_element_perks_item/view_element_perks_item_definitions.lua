-- chunkname: @scripts/ui/view_elements/view_element_perks_item/view_element_perks_item_definitions.lua

local InputDevice = require("scripts/managers/input/input_device")
local InputUtils = require("scripts/managers/input/input_utils")
local ItemUtils = require("scripts/utilities/items")
local TextUtilities = require("scripts/utilities/ui/text")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local default_button_content = {
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_click,
}
local title_height = 0
local edge_padding = 40
local grid_width = 430
local grid_height = 800
local bottom_chin = 0
local grid_size = {
	grid_width - edge_padding,
	grid_height,
}
local grid_spacing = {
	10,
	10,
}
local mask_width = grid_width
local mask_size = {
	mask_width,
	grid_height,
}
local service_type = "View"
local gamepad_action_navigate_primary_left = "navigate_primary_left_pressed"
local alias_key_navigate_primary_left = Managers.ui:get_input_alias_key(gamepad_action_navigate_primary_left, service_type)
local input_text_navigate_primary_left = InputUtils.input_text_for_current_input_device(service_type, alias_key_navigate_primary_left)
local gamepad_action_navigate_primary_right = "navigate_primary_right_pressed"
local alias_key_navigate_primary_right = Managers.ui:get_input_alias_key(gamepad_action_navigate_primary_right, service_type)
local input_text_navigate_primary_right = InputUtils.input_text_for_current_input_device(service_type, alias_key_navigate_primary_right)
local menu_settings = {
	scrollbar_width = 7,
	top_padding = 140,
	use_is_focused_for_navigation = false,
	use_select_on_focused = true,
	use_terminal_background = true,
	widget_icon_load_margin = 0,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding,
	scrollbar_position = {
		0,
		0,
	},
	bottom_chin = bottom_chin,
}
local background_size = {
	grid_size[1] + edge_padding,
	grid_size[2],
}
local use_horizontal_scrollbar = menu_settings.use_horizontal_scrollbar
local scrollbar_width = menu_settings.scrollbar_width
local scrollbar_vertical_margin = menu_settings.scrollbar_vertical_margin or 0
local scrollbar_height = use_horizontal_scrollbar and scrollbar_width or background_size[2] - scrollbar_vertical_margin - 20
local scrollbar_size = {
	scrollbar_width,
	scrollbar_height,
}
local scrollbar_position = {
	menu_settings.scrollbar_position and menu_settings.scrollbar_position[1] or 0,
	menu_settings.scrollbar_position and menu_settings.scrollbar_position[2] or 0,
	13,
}
local scenegraph_definition = {
	grid_mask = {
		horizontal_alignment = "center",
		parent = "grid_background",
		vertical_alignment = "center",
		size = mask_size,
		position = {
			0,
			0,
			10,
		},
	},
	grid_scrollbar = {
		parent = "grid_background",
		size = scrollbar_size,
		position = scrollbar_position,
		horizontal_alignment = menu_settings.scrollbar_horizontal_alignment or "right",
		vertical_alignment = menu_settings.scrollbar_vertical_alignment or "top",
	},
	tab_pivot = {
		horizontal_alignment = "center",
		parent = "grid_divider_top",
		vertical_alignment = "top",
		size = {
			grid_width,
			50,
		},
		position = {
			0,
			130,
			1,
		},
	},
}
local item_perk_style = table.clone(UIFontSettings.header_3)

item_perk_style.offset = {
	98,
	0,
	3,
}
item_perk_style.size = {
	324,
}
item_perk_style.font_size = 18
item_perk_style.text_horizontal_alignment = "left"
item_perk_style.text_vertical_alignment = "top"
item_perk_style.text_color = Color.terminal_text_header(255, true)

local item_perk_description_style = table.clone(UIFontSettings.body)

item_perk_description_style.offset = {
	98,
	20,
	3,
}
item_perk_description_style.size = {
	324,
	500,
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
	3,
}
header_style.text_horizontal_alignment = "center"
header_style.text_vertical_alignment = "top"
header_style.text_color = Color.terminal_text_body(255, true)

local left_trigger_style = table.clone(UIFontSettings.header_3)

left_trigger_style.font_size = 30
left_trigger_style.offset = {
	20,
	82,
	3,
}
left_trigger_style.text_horizontal_alignment = "left"
left_trigger_style.text_vertical_alignment = "top"
left_trigger_style.text_color = {
	255,
	226,
	199,
	126,
}

local right_trigger_style = table.clone(UIFontSettings.header_3)

right_trigger_style.font_size = 30
right_trigger_style.offset = {
	-20,
	82,
	3,
}
right_trigger_style.text_horizontal_alignment = "right"
right_trigger_style.text_vertical_alignment = "top"
right_trigger_style.text_color = {
	255,
	226,
	199,
	126,
}

local item_lock_symbol_text_style = table.clone(UIFontSettings.header_3)

item_lock_symbol_text_style.text_color = Color.terminal_text_body_sub_header(255, true)
item_lock_symbol_text_style.default_color = Color.terminal_text_body_sub_header(255, true)
item_lock_symbol_text_style.hover_color = Color.terminal_icon_selected(255, true)
item_lock_symbol_text_style.selected_color = Color.terminal_corner_selected(255, true)
item_lock_symbol_text_style.font_size = 24
item_lock_symbol_text_style.drop_shadow = false
item_lock_symbol_text_style.text_horizontal_alignment = "center"
item_lock_symbol_text_style.text_vertical_alignment = "center"
item_lock_symbol_text_style.vertical_alignment = "center"
item_lock_symbol_text_style.horizontal_alignment = "center"
item_lock_symbol_text_style.size = {
	20,
	20,
}
item_lock_symbol_text_style.offset = {
	-10,
	-55,
	1,
}

local widget_definitions = {
	header = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "header",
			value_id = "header",
			value = Localize("loc_weapon_inventory_perks_title_text"),
			style = table.merge_recursive(table.clone(header_style), {
				offset = {
					0,
					40,
					0,
				},
			}),
		},
	}, "grid_divider_top"),
	grid_divider_top = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "texture",
			value = "content/ui/materials/frames/item_info_upper",
			value_id = "texture",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				offset = {
					0,
					0,
					0,
				},
			},
		},
	}, "grid_divider_top"),
	grid_divider_bottom = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "texture",
			value = "content/ui/materials/frames/item_info_lower",
			value_id = "texture",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
			},
		},
	}, "grid_divider_bottom"),
	overlay = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "overlay",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					0,
				},
				size_addition = {
					-4,
					0,
				},
				color = {
					0,
					0,
					0,
					0,
				},
			},
		},
	}, "screen"),
	left_trigger = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "left_trigger",
			value_id = "left_trigger",
			value = input_text_navigate_primary_left,
			style = left_trigger_style,
			visibility_function = function ()
				return InputDevice.gamepad_active
			end,
		},
	}, "grid_divider_top"),
	right_trigger = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "right_trigger",
			value_id = "right_trigger",
			value = input_text_navigate_primary_right,
			style = right_trigger_style,
			visibility_function = function ()
				return InputDevice.gamepad_active
			end,
		},
	}, "grid_divider_top"),
}
local EMPTY_TABLE = {}

local function create_tab_widgets(tab_settings)
	local tab_definitions = {}
	local max_blessings = tab_settings.max_blessings or EMPTY_TABLE
	local num_blessings = tab_settings.num_blessings or EMPTY_TABLE
	local tab_size = tab_settings.size or {
		60,
		40,
	}
	local spacing = tab_settings.spacing or 20
	local offset_x = ((tab_settings.num_tabs - 1) * tab_size[1] + (tab_settings.num_tabs - 1) * spacing) * 0.5 * -1

	for i = 1, tab_settings.num_tabs do
		local current_max_blessings = max_blessings[i] or "?"
		local current_num_blessings = num_blessings[i] or "?"
		local locked_style = table.clone_instance(item_lock_symbol_text_style)

		locked_style.offset[1] = offset_x

		local widget_definition = UIWidget.create_definition({
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				content = default_button_content,
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					offset = {
						offset_x,
						-50,
						0,
					},
					size = tab_size,
				},
				change_function = function (content, style, animations, dt)
					local lerp_direction = content.is_hover and 1 or -1

					content.parent.progress = math.clamp((content.parent.progress or 0) + dt * lerp_direction * 4, 0, 1)
				end,
			},
			{
				pass_type = "rect",
				style_id = "background",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					visible = true,
					size = tab_size,
					offset = {
						offset_x,
						-50,
						1,
					},
					color = Color.terminal_frame(50, true),
				},
			},
			{
				pass_type = "texture",
				style_id = "background_gradient",
				value = "content/ui/materials/gradients/gradient_vertical",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					visible = true,
					size = tab_size,
					offset = {
						offset_x,
						-50,
						1,
					},
					color = Color.terminal_frame(192, true),
				},
			},
			{
				pass_type = "texture",
				value = ItemUtils.perk_textures(nil, i),
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					size = {
						20,
						20,
					},
					offset = {
						offset_x,
						-50,
						1,
					},
					color = Color.terminal_icon(255, true),
				},
				visibility_function = function (content, style)
					return not content.locked
				end,
			},
			{
				pass_type = "texture",
				style_id = "hover_frame",
				value = "content/ui/materials/gradients/gradient_vertical",
				style = {
					hdr = false,
					horizontal_alignment = "center",
					vertical_alignment = "top",
					offset = {
						offset_x,
						-50,
						0,
					},
					size = tab_size,
					color = Color.ui_terminal(0, true),
					size_addition = {
						0,
						0,
					},
				},
				change_function = function (content, style)
					local progress = content.selected and 1 or content.progress
					local t = math.easeOutCubic(progress)

					style.color[1] = t * 128
				end,
			},
			{
				pass_type = "texture",
				style_id = "hover_frame_border",
				value = "content/ui/materials/frames/frame_tile_1px",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "top",
					offset = {
						offset_x,
						-50,
						1,
					},
					size = tab_size,
					color = Color.terminal_grid_background(128, true),
					base_color = Color.terminal_grid_background(128, true),
					selected_color = Color.ui_terminal(128, true),
				},
				change_function = function (content, style)
					local progress = content.selected and 1 or content.progress
					local t = math.easeOutCubic(progress)

					style.color[2] = math.lerp(style.base_color[2], style.selected_color[2], t)
					style.color[3] = math.lerp(style.base_color[3], style.selected_color[3], t)
					style.color[4] = math.lerp(style.base_color[4], style.selected_color[4], t)
				end,
			},
			{
				pass_type = "texture",
				style_id = "hover_frame_corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "top",
					offset = {
						offset_x,
						-50,
						2,
					},
					size = tab_size,
					color = Color.terminal_grid_background(255, true),
					base_color = Color.terminal_grid_background(255, true),
					selected_color = Color.ui_terminal(255, true),
				},
				change_function = function (content, style)
					local progress = content.selected and 1 or content.progress
					local t = math.easeOutCubic(progress)

					style.color[2] = math.lerp(style.base_color[2], style.selected_color[2], t)
					style.color[3] = math.lerp(style.base_color[3], style.selected_color[3], t)
					style.color[4] = math.lerp(style.base_color[4], style.selected_color[4], t)
				end,
			},
			{
				pass_type = "triangle",
				style_id = "triangle",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					offset = {
						background_size[1] * 0.5 + offset_x,
						-5,
						100,
					},
					color = Color.ui_terminal(255, true),
					triangle_corners = {
						{
							-20,
							0,
						},
						{
							20,
							0,
						},
						{
							0,
							15,
						},
					},
				},
				visibility_function = function (content, style)
					return content.selected
				end,
			},
			{
				pass_type = "text",
				value = "",
				style = locked_style,
				visibility_function = function (content, style)
					return content.locked
				end,
			},
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
	create_tab_widgets = create_tab_widgets,
}
