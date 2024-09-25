-- chunkname: @scripts/ui/pass_templates/item_pass_templates.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local ItemUtils = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ItemPassTemplates = {}
local character_title_item_size = UISettings.character_title_item_size
local character_title_button_size = UISettings.character_title_button_size

ItemPassTemplates.character_title_item_size = character_title_item_size
ItemPassTemplates.character_title_button_size = character_title_button_size

local weapon_item_size = UISettings.weapon_item_size
local weapon_icon_size = UISettings.weapon_icon_size
local icon_size = UISettings.icon_size
local gadget_size = UISettings.gadget_size
local gadget_item_size = UISettings.gadget_item_size
local gadget_icon_size = UISettings.gadget_icon_size
local item_icon_size = UISettings.item_icon_size

ItemPassTemplates.store_item_goods_size = {
	weapon_item_size[1],
	weapon_item_size[2] + 40,
}
ItemPassTemplates.store_item_size = {
	weapon_item_size[1],
	weapon_item_size[2] + 40,
}
ItemPassTemplates.store_item_credits_goods_size = {
	weapon_item_size[1] * 0.5 - 7,
	weapon_item_size[2] * 0.5,
}
ItemPassTemplates.icon_size = {
	item_icon_size[1],
	item_icon_size[2],
}
ItemPassTemplates.weapon_item_size = weapon_item_size
ItemPassTemplates.weapon_icon_size = weapon_icon_size
ItemPassTemplates.ui_item_size = UISettings.ui_item_size
ItemPassTemplates.ui_icon_size = {
	60,
	70,
}
ItemPassTemplates.gear_icon_size = UISettings.cosmetics_item_size
ItemPassTemplates.gear_bundle_size = UISettings.cosmetics_bundle_item_size
ItemPassTemplates.gadget_size = gadget_item_size
ItemPassTemplates.gadget_icon_size = gadget_icon_size

local function item_change_function(content, style)
	local hotspot = content.hotspot
	local is_selected = hotspot.is_selected
	local is_focused = hotspot.is_focused
	local is_hover = hotspot.is_hover
	local default_color = style.default_color
	local selected_color = style.selected_color
	local hover_color = style.hover_color
	local color

	if is_selected or is_focused then
		color = selected_color
	elseif is_hover then
		color = hover_color
	else
		color = default_color
	end

	local progress = math.max(math.max(hotspot.anim_hover_progress or 0, hotspot.anim_select_progress or 0), hotspot.anim_focus_progress or 0)

	ColorUtilities.color_lerp(style.color, color, progress, style.color)
end

local item_display_name_text_style = table.clone(UIFontSettings.header_3)

item_display_name_text_style.text_horizontal_alignment = "left"
item_display_name_text_style.text_vertical_alignment = "top"
item_display_name_text_style.horizontal_alignment = "right"
item_display_name_text_style.vertical_alignment = "top"
item_display_name_text_style.offset = {
	-20,
	10,
	5,
}
item_display_name_text_style.font_size = 24
item_display_name_text_style.size = {
	weapon_item_size[1] - 40,
	40,
}
item_display_name_text_style.text_color = Color.terminal_text_header(255, true)
item_display_name_text_style.default_color = Color.terminal_text_header(255, true)
item_display_name_text_style.hover_color = Color.terminal_text_header_selected(255, true)

local credits_item_display_name_text_style = table.clone(item_display_name_text_style)

credits_item_display_name_text_style.horizontal_alignment = "left"
credits_item_display_name_text_style.vertical_alignment = "center"
credits_item_display_name_text_style.text_vertical_alignment = "center"
credits_item_display_name_text_style.offset = {
	10,
	0,
	6,
}
credits_item_display_name_text_style.font_size = 16
credits_item_display_name_text_style.size = {
	ItemPassTemplates.store_item_credits_goods_size[1] * 0.66,
}

local item_sub_display_name_text_style = table.clone(UIFontSettings.body_small)

item_sub_display_name_text_style.text_horizontal_alignment = "left"
item_sub_display_name_text_style.text_vertical_alignment = "top"
item_sub_display_name_text_style.horizontal_alignment = "right"
item_sub_display_name_text_style.vertical_alignment = "top"
item_sub_display_name_text_style.font_size = 18
item_sub_display_name_text_style.offset = {
	-20,
	39,
	5,
}
item_sub_display_name_text_style.size = {
	weapon_item_size[1] - 40,
	40,
}
item_sub_display_name_text_style.text_color = Color.terminal_text_body_sub_header(255, true)
item_sub_display_name_text_style.default_color = Color.terminal_text_body_sub_header(255, true)
item_sub_display_name_text_style.hover_color = Color.terminal_text_body(255, true)

local item_rarity_text_style = table.clone(item_sub_display_name_text_style)

item_rarity_text_style.offset = {
	-20,
	62,
	5,
}

local item_level_text_style = table.clone(UIFontSettings.body_small)

item_level_text_style.text_horizontal_alignment = "right"
item_level_text_style.text_vertical_alignment = "bottom"
item_level_text_style.horizontal_alignment = "right"
item_level_text_style.vertical_alignment = "top"
item_level_text_style.font_size = 26
item_level_text_style.offset = {
	-20,
	-10,
	5,
}
item_level_text_style.size = {
	weapon_item_size[1],
	weapon_item_size[2],
}
item_level_text_style.text_color = Color.white(255, true)
item_level_text_style.default_color = Color.white(255, true)
item_level_text_style.hover_color = Color.white(255, true)
item_level_text_style.material = "content/ui/materials/font_gradients/slug_font_gradient_item_level"

local gadget_item_level_text_style = table.clone(UIFontSettings.body_small)

gadget_item_level_text_style.text_horizontal_alignment = "center"
gadget_item_level_text_style.text_vertical_alignment = "top"
gadget_item_level_text_style.horizontal_alignment = "center"
gadget_item_level_text_style.vertical_alignment = "top"
gadget_item_level_text_style.font_size = 26
gadget_item_level_text_style.offset = {
	0,
	10,
	7,
}
gadget_item_level_text_style.text_color = Color.white(255, true)
gadget_item_level_text_style.default_color = Color.white(255, true)
gadget_item_level_text_style.hover_color = Color.white(255, true)
gadget_item_level_text_style.material = "content/ui/materials/font_gradients/slug_font_gradient_item_level"

local required_level_text_style = table.clone(UIFontSettings.body_small)

required_level_text_style.text_horizontal_alignment = "center"
required_level_text_style.text_vertical_alignment = "center"
required_level_text_style.horizontal_alignment = "center"
required_level_text_style.vertical_alignment = "top"
required_level_text_style.font_size = 22
required_level_text_style.offset = {
	0,
	ItemPassTemplates.weapon_item_size[2] * 0.5 - 19,
	8,
}
required_level_text_style.size = {
	nil,
	38,
}
required_level_text_style.text_color = {
	255,
	159,
	67,
	67,
}

local required_level_general_good_text_style = table.clone(credits_item_display_name_text_style)

required_level_general_good_text_style.text_color = {
	255,
	159,
	67,
	67,
}
required_level_general_good_text_style.size = {
	150,
}
required_level_general_good_text_style.offset[3] = 10

local character_title_item_text_style = table.clone(UIFontSettings.body)

character_title_item_text_style.text_horizontal_alignment = "center"
character_title_item_text_style.text_vertical_alignment = "center"
character_title_item_text_style.horizontal_alignment = "center"
character_title_item_text_style.vertical_alignment = "center"
character_title_item_text_style.font_size = 18
character_title_item_text_style.offset = {
	0,
	0,
	8,
}
character_title_item_text_style.text_color = Color.terminal_text_header(255, true)
character_title_item_text_style.default_color = Color.terminal_text_header(255, true)
character_title_item_text_style.hover_color = Color.terminal_text_header_selected(255, true)

local gear_character_title_item_text_style = table.clone(UIFontSettings.header_3)

gear_character_title_item_text_style.text_horizontal_alignment = "center"
gear_character_title_item_text_style.text_vertical_alignment = "bottom"
gear_character_title_item_text_style.horizontal_alignment = "center"
gear_character_title_item_text_style.vertical_alignment = "top"
gear_character_title_item_text_style.size = {
	500,
	ItemPassTemplates.gear_icon_size[2],
}
gear_character_title_item_text_style.font_size = 18
gear_character_title_item_text_style.offset = {
	0,
	-(ItemPassTemplates.gear_icon_size[2] + 13),
	8,
}
gear_character_title_item_text_style.text_color = Color.terminal_text_header(255, true)
gear_character_title_item_text_style.default_color = Color.terminal_text_header(255, true)
gear_character_title_item_text_style.hover_color = Color.terminal_text_header_selected(255, true)

local gear_item_slot_title_text_style = table.clone(UIFontSettings.header_3)

gear_item_slot_title_text_style.text_horizontal_alignment = "center"
gear_item_slot_title_text_style.text_vertical_alignment = "bottom"
gear_item_slot_title_text_style.horizontal_alignment = "center"
gear_item_slot_title_text_style.vertical_alignment = "top"
gear_item_slot_title_text_style.size = {
	500,
	ItemPassTemplates.gear_icon_size[2],
}
gear_item_slot_title_text_style.font_size = 18
gear_item_slot_title_text_style.offset = {
	0,
	-(ItemPassTemplates.gear_icon_size[2] + 16),
	8,
}
gear_item_slot_title_text_style.text_color = Color.terminal_text_header(255, true)
gear_item_slot_title_text_style.default_color = Color.terminal_text_header(255, true)
gear_item_slot_title_text_style.hover_color = Color.terminal_text_header_selected(255, true)

local ui_item_emote_slot_title_text_style = table.clone(gear_item_slot_title_text_style)

ui_item_emote_slot_title_text_style.offset = {
	0,
	-(ItemPassTemplates.gear_icon_size[2] + 5),
	8,
}
ui_item_emote_slot_title_text_style.font_size = 14

local ui_item_slot_title_text_style = table.clone(UIFontSettings.header_3)

ui_item_slot_title_text_style.text_horizontal_alignment = "center"
ui_item_slot_title_text_style.text_vertical_alignment = "bottom"
ui_item_slot_title_text_style.horizontal_alignment = "center"
ui_item_slot_title_text_style.vertical_alignment = "top"
ui_item_slot_title_text_style.vertical_alignment = "top"
ui_item_slot_title_text_style.font_size = 18
ui_item_slot_title_text_style.offset = {
	0,
	-(ItemPassTemplates.ui_item_size[2] + 10),
	5,
}
ui_item_slot_title_text_style.text_color = Color.ui_brown_light(255, true)
ui_item_slot_title_text_style.default_color = Color.ui_brown_light(255, true)
ui_item_slot_title_text_style.hover_color = Color.ui_brown_super_light(255, true)

local item_owned_text_style = table.clone(UIFontSettings.header_2)

item_owned_text_style.text_horizontal_alignment = "right"
item_owned_text_style.text_vertical_alignment = "bottom"
item_owned_text_style.horizontal_alignment = "right"
item_owned_text_style.vertical_alignment = "bottom"
item_owned_text_style.offset = {
	0,
	4,
	15,
}
item_owned_text_style.text_color = Color.terminal_text_body(255, true)

local item_price_style = table.clone(UIFontSettings.body)

item_price_style.text_horizontal_alignment = "right"
item_price_style.text_vertical_alignment = "bottom"
item_price_style.horizontal_alignment = "right"
item_price_style.vertical_alignment = "center"
item_price_style.offset = {
	-35,
	-8,
	12,
}
item_price_style.font_size = 20
item_price_style.text_color = Color.white(255, true)
item_price_style.default_color = Color.white(255, true)
item_price_style.hover_color = Color.white(255, true)

local gear_item_price_style = table.clone(item_price_style)

gear_item_price_style.offset = {
	-29,
	-3,
	12,
}

local gear_item_owned_count_style = table.clone(item_price_style)

gear_item_owned_count_style.offset = {
	-8,
	-35,
	15,
}
gear_item_owned_count_style.text_color = Color.terminal_text_body(255, true)

local item_sold_style = table.clone(UIFontSettings.body)

item_sold_style.text_horizontal_alignment = "right"
item_sold_style.text_vertical_alignment = "bottom"
item_sold_style.horizontal_alignment = "right"
item_sold_style.vertical_alignment = "center"
item_sold_style.offset = {
	-15,
	-7,
	15,
}
item_sold_style.text_color = Color.terminal_text_header(255, true)
item_sold_style.font_size = 20

local symbol_text_style = table.clone(UIFontSettings.header_3)

symbol_text_style.text_color = Color.terminal_text_body_sub_header(255, true)
symbol_text_style.default_color = Color.terminal_text_body_sub_header(255, true)
symbol_text_style.hover_color = Color.terminal_icon_selected(255, true)
symbol_text_style.selected_color = Color.terminal_corner_selected(255, true)
symbol_text_style.font_size = 24
symbol_text_style.drop_shadow = false

local item_lock_symbol_text_style = table.clone(symbol_text_style)

item_lock_symbol_text_style.text_horizontal_alignment = "right"
item_lock_symbol_text_style.text_vertical_alignment = "bottom"
item_lock_symbol_text_style.offset = {
	-10,
	-5,
	7,
}

local item_properties_symbol_text_style = table.clone(symbol_text_style)

item_properties_symbol_text_style.text_horizontal_alignment = "left"
item_properties_symbol_text_style.text_vertical_alignment = "top"
item_properties_symbol_text_style.drop_shadow = true
item_properties_symbol_text_style.offset = {
	4,
	2,
	7,
}

local function _symbol_text_change_function(content, style)
	local hotspot = content.hotspot
	local is_selected = hotspot.is_selected
	local is_focused = hotspot.is_focused
	local is_hover = hotspot.is_hover
	local default_text_color = style.default_color
	local hover_color = style.hover_color
	local text_color = style.text_color
	local selected_color = style.selected_color
	local color

	if is_selected or is_focused then
		color = selected_color
	elseif is_hover then
		color = hover_color
	else
		color = default_text_color
	end

	local progress = math.max(math.max(hotspot.anim_hover_progress or 0, hotspot.anim_select_progress or 0), hotspot.anim_focus_progress or 0)

	ColorUtilities.color_lerp(text_color, color, progress, text_color)
end

ItemPassTemplates.gear_item = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_click,
		},
	},
	{
		pass_type = "texture",
		style_id = "outer_shadow",
		value = "content/ui/materials/frames/dropshadow_medium",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			color = Color.black(200, true),
			size_addition = {
				20,
				20,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			color = Color.terminal_background_dark(nil, true),
			selected_color = Color.terminal_background_selected(nil, true),
		},
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = {
				100,
				33,
				35,
				37,
			},
			color = {
				100,
				33,
				35,
				37,
			},
			offset = {
				0,
				0,
				1,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				12,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_corner(nil, true),
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				13,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "button_gradient",
		value = "content/ui/materials/gradients/gradient_diagonal_down_right",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				1,
			},
		},
		change_function = function (content, style)
			ButtonPassTemplates.terminal_button_change_function(content, style)
			ButtonPassTemplates.terminal_button_hover_change_function(content, style)
		end,
	},
	{
		pass_type = "texture",
		style_id = "inner_highlight",
		value = "content/ui/materials/frames/inner_shadow_medium",
		style = {
			scale_to_material = true,
			color = Color.terminal_frame(255, true),
			offset = {
				0,
				0,
				3,
			},
		},
		change_function = function (content, style)
			local hotspot = content.hotspot

			style.color[1] = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress) * 255
		end,
	},
	{
		pass_type = "texture",
		style_id = "icon",
		value = "content/ui/materials/icons/items/containers/item_container_landscape",
		value_id = "icon",
		style = {
			material_values = {
				use_placeholder_texture = 1,
			},
			offset = {
				0,
				0,
				2,
			},
			color = Color.white(255, true),
		},
		visibility_function = function (content, style)
			local use_placeholder_texture = content.use_placeholder_texture

			if use_placeholder_texture and use_placeholder_texture == 0 then
				return true
			end

			return false
		end,
	},
	{
		pass_type = "text",
		style_id = "owned",
		value = "",
		value_id = "owned",
		style = item_owned_text_style,
		visibility_function = function (content, style)
			return content.owned
		end,
	},
	{
		pass_type = "text",
		style_id = "owned_count_text",
		value = "",
		value_id = "owned_count_text",
		style = gear_item_owned_count_style,
		visibility_function = function (content, style)
			return content.owned_count_text
		end,
	},
	{
		pass_type = "rotated_texture",
		style_id = "loading",
		value = "content/ui/materials/loading/loading_small",
		style = {
			angle = 0,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				80,
				80,
			},
			color = {
				60,
				160,
				160,
				160,
			},
			offset = {
				0,
				0,
				2,
			},
		},
		visibility_function = function (content, style)
			local use_placeholder_texture = content.use_placeholder_texture

			if not use_placeholder_texture or use_placeholder_texture == 1 then
				return true
			end

			return false
		end,
		change_function = function (content, style, _, dt)
			local add = -0.5 * dt

			style.rotation_progress = ((style.rotation_progress or 0) + add) % 1
			style.angle = style.rotation_progress * math.pi * 2
		end,
	},
	{
		pass_type = "texture",
		style_id = "equipped_icon",
		value = "content/ui/materials/icons/items/equipped_label",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "top",
			size = {
				32,
				32,
			},
			offset = {
				0,
				0,
				16,
			},
		},
		visibility_function = function (content, style)
			return content.equipped
		end,
	},
	{
		pass_type = "rect",
		style = {
			vertical_alignment = "bottom",
			offset = {
				0,
				0,
				3,
			},
			color = {
				150,
				0,
				0,
				0,
			},
			size = {
				nil,
				30,
			},
		},
		visibility_function = function (content, style)
			local is_locked = content.locked
			local is_sold = content.has_price_tag and not content.sold

			return is_locked or is_sold
		end,
	},
	{
		pass_type = "text",
		style_id = "price_text",
		value = "n/a",
		value_id = "price_text",
		style = gear_item_price_style,
		visibility_function = function (content, style)
			return content.has_price_tag and not content.sold
		end,
	},
	{
		pass_type = "texture",
		style_id = "wallet_icon",
		value = "content/ui/materials/base/ui_default_base",
		value_id = "wallet_icon",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "bottom",
			size = {
				28,
				20,
			},
			offset = {
				-2,
				-5,
				12,
			},
			color = {
				255,
				255,
				255,
				255,
			},
		},
		visibility_function = function (content, style)
			return content.has_price_tag and not content.sold
		end,
	},
	{
		pass_type = "text",
		value = "",
		style = item_lock_symbol_text_style,
		visibility_function = function (content, style)
			return content.locked
		end,
		change_function = _symbol_text_change_function,
	},
	{
		pass_type = "text",
		value = "",
		value_id = "properties",
		style = item_properties_symbol_text_style,
		change_function = _symbol_text_change_function,
	},
	{
		pass_type = "texture",
		style_id = "favorite_icon",
		value = "content/ui/materials/symbols/character_level",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "bottom",
			size = {
				40,
				40,
			},
			offset = {
				0,
				0,
				16,
			},
			color = Color.ui_veteran(255, true),
		},
		visibility_function = function (content, style)
			return content.favorite
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/symbols/new_item_indicator",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "top",
			size = {
				100,
				100,
			},
			offset = {
				30,
				-30,
				5,
			},
			color = Color.terminal_corner_selected(255, true),
		},
		visibility_function = function (content, style)
			return content.element.new_item_marker
		end,
		change_function = function (content, style)
			local speed = 5
			local anim_progress = 1 - (0.5 + math.sin(Application.time_since_launch() * speed) * 0.5)
			local hotspot = content.hotspot

			style.color[1] = 150 + anim_progress * 80

			local hotspot = content.hotspot

			if hotspot.is_selected or hotspot.on_hover_exit then
				content.element.new_item_marker = nil

				local element = content.element
				local item = element and (element.real_item or element.item)

				if content.element.remove_new_marker_callback and item then
					content.element.remove_new_marker_callback(item)
				end
			end
		end,
	},
}
ItemPassTemplates.gear_item_slot = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
		},
	},
	{
		pass_type = "texture",
		style_id = "slot",
		value = "content/ui/materials/frames/cosmetic_slot_small",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = {
				255,
				255,
				255,
				255,
			},
			size = {
				250,
				230,
			},
			offset = {
				0,
				-21,
				0,
			},
		},
	},
	{
		pass_type = "text",
		style_id = "slot_title",
		value = "n/a",
		value_id = "slot_title",
		style = gear_item_slot_title_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			color = Color.terminal_background_dark(nil, true),
			selected_color = Color.terminal_background_selected(nil, true),
			offset = {
				0,
				0,
				1,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = {
				100,
				33,
				35,
				37,
			},
			color = {
				100,
				33,
				35,
				37,
			},
			offset = {
				0,
				0,
				2,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "button_gradient",
		value = "content/ui/materials/gradients/gradient_diagonal_down_right",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				1,
			},
		},
		change_function = function (content, style)
			ButtonPassTemplates.terminal_button_change_function(content, style)
			ButtonPassTemplates.terminal_button_hover_change_function(content, style)
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/icons/generic/aquila",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			offset = {
				0,
				0,
				3,
			},
			size = {
				93.60000000000001,
				36,
			},
		},
		visibility_function = function (content, style)
			return not content.item
		end,
	},
	{
		pass_type = "texture",
		style_id = "icon",
		value = "content/ui/materials/icons/items/containers/item_container_landscape",
		value_id = "icon",
		style = {
			material_values = {
				use_placeholder_texture = 1,
			},
			offset = {
				0,
				0,
				3,
			},
			color = Color.white(255, true),
		},
		visibility_function = function (content, style)
			local use_placeholder_texture = content.use_placeholder_texture

			if use_placeholder_texture and use_placeholder_texture == 0 then
				return true
			end

			return false
		end,
	},
	{
		pass_type = "rotated_texture",
		style_id = "loading",
		value = "content/ui/materials/loading/loading_small",
		style = {
			angle = 0,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				80,
				80,
			},
			color = {
				60,
				160,
				160,
				160,
			},
			offset = {
				0,
				0,
				2,
			},
		},
		visibility_function = function (content, style)
			local use_placeholder_texture = content.use_placeholder_texture

			if not use_placeholder_texture or use_placeholder_texture == 1 then
				return true
			end

			return false
		end,
		change_function = function (content, style, _, dt)
			local add = -0.5 * dt

			style.rotation_progress = ((style.rotation_progress or 0) + add) % 1
			style.angle = style.rotation_progress * math.pi * 2
		end,
	},
	{
		pass_type = "texture",
		style_id = "inner_highlight",
		value = "content/ui/materials/frames/inner_shadow_medium",
		style = {
			scale_to_material = true,
			color = Color.terminal_frame(255, true),
			offset = {
				0,
				0,
				4,
			},
		},
		change_function = function (content, style)
			local hotspot = content.hotspot

			style.color[1] = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress) * 255
		end,
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				6,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_corner(nil, true),
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				7,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "new_indicator",
		value = "content/ui/materials/symbols/new_item_indicator",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			size = {
				90,
				90,
			},
			offset = {
				0,
				60,
				4,
			},
			color = Color.terminal_corner_selected(255, true),
		},
		visibility_function = function (content, style)
			return content.has_new_items
		end,
	},
}
ItemPassTemplates.character_title_item = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
		},
	},
	{
		pass_type = "text",
		style_id = "display_name",
		value = "n/a",
		value_id = "display_name",
		style = character_title_item_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
		visibility_function = function (content, style)
			return not content.show_icon
		end,
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			color = Color.terminal_background_dark(nil, true),
			selected_color = Color.terminal_background_selected(nil, true),
			offset = {
				0,
				0,
				1,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = {
				100,
				33,
				35,
				37,
			},
			color = {
				100,
				33,
				35,
				37,
			},
			offset = {
				0,
				0,
				2,
			},
		},
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
		style = {
			vertical_alignment = "top",
			offset = {
				0,
				0,
				2,
			},
			color = {
				105,
				45,
				45,
				45,
			},
		},
		visibility_function = function (content, style)
			return content.locked
		end,
	},
	{
		pass_type = "text",
		value = "",
		style = item_lock_symbol_text_style,
		visibility_function = function (content, style)
			return content.locked
		end,
		change_function = _symbol_text_change_function,
	},
	{
		pass_type = "texture",
		style_id = "button_gradient",
		value = "content/ui/materials/gradients/gradient_diagonal_down_right",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				1,
			},
		},
		change_function = function (content, style)
			ButtonPassTemplates.terminal_button_change_function(content, style)
			ButtonPassTemplates.terminal_button_hover_change_function(content, style)
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/icons/generic/aquila",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			offset = {
				0,
				0,
				3,
			},
			size = {
				93.60000000000001,
				36,
			},
		},
		visibility_function = function (content, style)
			return not content.item
		end,
	},
	{
		pass_type = "texture",
		style_id = "icon",
		value = "content/ui/materials/icons/items/containers/item_container_square",
		value_id = "icon",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			material_values = {},
			offset = {
				0,
				0,
				2,
			},
		},
		visibility_function = function (content, style)
			local parent_style = style.parent

			return content.show_icon and parent_style.icon.material_values.use_placeholder_texture == 0
		end,
	},
	{
		pass_type = "texture",
		style_id = "inner_highlight",
		value = "content/ui/materials/frames/inner_shadow_medium",
		style = {
			scale_to_material = true,
			color = Color.terminal_frame(255, true),
			offset = {
				0,
				0,
				4,
			},
		},
		change_function = function (content, style)
			local hotspot = content.hotspot

			style.color[1] = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress) * 255
		end,
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				6,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_corner(nil, true),
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				7,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "equipped_icon",
		value = "content/ui/materials/icons/items/equipped_label",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "top",
			size = {
				32,
				32,
			},
			offset = {
				0,
				0,
				8,
			},
		},
		visibility_function = function (content, style)
			return content.equipped
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/symbols/new_item_indicator",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "top",
			size = {
				100,
				100,
			},
			offset = {
				30,
				-30,
				5,
			},
			color = Color.terminal_corner_selected(255, true),
		},
		visibility_function = function (content, style)
			return content.element.new_item_marker
		end,
		change_function = function (content, style)
			local speed = 5
			local anim_progress = 1 - (0.5 + math.sin(Application.time_since_launch() * speed) * 0.5)
			local hotspot = content.hotspot

			style.color[1] = 150 + anim_progress * 80

			if hotspot.is_selected or hotspot.on_hover_exit then
				content.element.new_item_marker = nil

				local element = content.element
				local item = element and (element.real_item or element.item)

				if content.element.remove_new_marker_callback and item then
					content.element.remove_new_marker_callback(item)
				end
			end
		end,
	},
}
ItemPassTemplates.character_title_item_slot = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
		},
	},
	{
		pass_type = "texture",
		style_id = "slot",
		value = "content/ui/materials/frames/cosmetic_slot_title_small",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = {
				255,
				255,
				255,
				255,
			},
			size = {
				388,
				142,
			},
			offset = {
				0,
				-21,
				0,
			},
		},
	},
	{
		pass_type = "text",
		style_id = "slot_title",
		value = "n/a",
		value_id = "slot_title",
		style = gear_character_title_item_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
	},
	{
		pass_type = "text",
		style_id = "display_name",
		value = "n/a",
		value_id = "display_name",
		style = character_title_item_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			color = Color.terminal_background_dark(nil, true),
			selected_color = Color.terminal_background_selected(nil, true),
			offset = {
				0,
				0,
				1,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = {
				100,
				33,
				35,
				37,
			},
			color = {
				100,
				33,
				35,
				37,
			},
			offset = {
				0,
				0,
				2,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "button_gradient",
		value = "content/ui/materials/gradients/gradient_diagonal_down_right",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				1,
			},
		},
		change_function = function (content, style)
			ButtonPassTemplates.terminal_button_change_function(content, style)
			ButtonPassTemplates.terminal_button_hover_change_function(content, style)
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/icons/generic/aquila",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			offset = {
				0,
				0,
				3,
			},
			size = {
				93.60000000000001,
				36,
			},
		},
		visibility_function = function (content, style)
			return not content.item
		end,
	},
	{
		pass_type = "texture",
		style_id = "inner_highlight",
		value = "content/ui/materials/frames/inner_shadow_medium",
		style = {
			scale_to_material = true,
			color = Color.terminal_frame(255, true),
			offset = {
				0,
				0,
				4,
			},
		},
		change_function = function (content, style)
			local hotspot = content.hotspot

			style.color[1] = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress) * 255
		end,
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				6,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_corner(nil, true),
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				7,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "new_indicator",
		value = "content/ui/materials/symbols/new_item_indicator",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			size = {
				90,
				90,
			},
			offset = {
				0,
				60,
				4,
			},
			color = Color.terminal_corner_selected(255, true),
		},
		visibility_function = function (content, style)
			return content.has_new_items
		end,
	},
}
ItemPassTemplates.ui_item = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_click,
		},
	},
	{
		pass_type = "texture",
		style_id = "outer_shadow",
		value = "content/ui/materials/frames/dropshadow_medium",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			color = Color.black(200, true),
			size_addition = {
				20,
				20,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = {
				100,
				33,
				35,
				37,
			},
			color = {
				100,
				33,
				35,
				37,
			},
			offset = {
				0,
				0,
				2,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			color = Color.terminal_background_dark(nil, true),
			selected_color = Color.terminal_background_selected(nil, true),
			offset = {
				0,
				0,
				0,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "button_gradient",
		value = "content/ui/materials/gradients/gradient_diagonal_down_right",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				1,
			},
		},
		change_function = function (content, style)
			ButtonPassTemplates.terminal_button_change_function(content, style)
			ButtonPassTemplates.terminal_button_hover_change_function(content, style)
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/icons/generic/aquila",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			offset = {
				0,
				0,
				3,
			},
			size = {
				93.60000000000001,
				36,
			},
		},
		visibility_function = function (content, style)
			return not content.item
		end,
	},
	{
		pass_type = "texture",
		style_id = "icon",
		value = "content/ui/materials/icons/items/containers/item_container_square",
		value_id = "icon",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			material_values = {},
			offset = {
				0,
				0,
				2,
			},
		},
		visibility_function = function (content, style)
			local parent_style = style.parent

			return parent_style.icon.material_values.use_placeholder_texture == 0
		end,
	},
	{
		pass_type = "rotated_texture",
		style_id = "loading",
		value = "content/ui/materials/loading/loading_small",
		style = {
			angle = 0,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				80,
				80,
			},
			color = {
				60,
				160,
				160,
				160,
			},
			offset = {
				0,
				0,
				2,
			},
		},
		visibility_function = function (content, style)
			local use_placeholder_texture = content.use_placeholder_texture

			if not use_placeholder_texture or use_placeholder_texture == 1 then
				return true
			end

			return false
		end,
		change_function = function (content, style, _, dt)
			local add = -0.5 * dt

			style.rotation_progress = ((style.rotation_progress or 0) + add) % 1
			style.angle = style.rotation_progress * math.pi * 2
		end,
	},
	{
		pass_type = "texture",
		style_id = "inner_highlight",
		value = "content/ui/materials/frames/inner_shadow_medium",
		style = {
			scale_to_material = true,
			color = Color.terminal_frame(255, true),
			offset = {
				0,
				0,
				4,
			},
		},
		change_function = function (content, style)
			local hotspot = content.hotspot

			style.color[1] = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress) * 255
		end,
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				6,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_corner(nil, true),
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				7,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "equipped_icon",
		value = "content/ui/materials/icons/items/equipped_label",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "top",
			size = {
				32,
				32,
			},
			offset = {
				0,
				0,
				8,
			},
		},
		visibility_function = function (content, style)
			return content.equipped
		end,
	},
	{
		pass_type = "rect",
		style = {
			offset = {
				0,
				0,
				3,
			},
			color = {
				150,
				0,
				0,
				0,
			},
		},
		visibility_function = function (content, style)
			return content.locked
		end,
	},
	{
		pass_type = "text",
		value = "",
		style = item_lock_symbol_text_style,
		visibility_function = function (content, style)
			return content.locked
		end,
		change_function = _symbol_text_change_function,
	},
	{
		pass_type = "text",
		value = "",
		value_id = "properties",
		style = item_properties_symbol_text_style,
		change_function = _symbol_text_change_function,
	},
	{
		pass_type = "texture",
		style_id = "favorite_icon",
		value = "content/ui/materials/symbols/character_level",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "bottom",
			size = {
				40,
				40,
			},
			offset = {
				0,
				0,
				16,
			},
			color = Color.ui_veteran(255, true),
		},
		visibility_function = function (content, style)
			return content.favorite
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/symbols/new_item_indicator",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "top",
			size = {
				100,
				100,
			},
			offset = {
				30,
				-30,
				5,
			},
			color = Color.terminal_corner_selected(255, true),
		},
		visibility_function = function (content, style)
			return content.element.new_item_marker
		end,
		change_function = function (content, style)
			local speed = 5
			local anim_progress = 1 - (0.5 + math.sin(Application.time_since_launch() * speed) * 0.5)
			local hotspot = content.hotspot

			style.color[1] = 150 + anim_progress * 80

			local hotspot = content.hotspot

			if hotspot.is_selected or hotspot.on_hover_exit then
				content.element.new_item_marker = nil

				local element = content.element
				local item = element and (element.real_item or element.item)

				if content.element.remove_new_marker_callback and item then
					content.element.remove_new_marker_callback(item)
				end
			end
		end,
	},
}
ItemPassTemplates.ui_item_slot = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_click,
		},
	},
	{
		pass_type = "texture",
		style_id = "slot",
		value = "content/ui/materials/frames/cosmetic_slot_small",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = {
				255,
				255,
				255,
				255,
			},
			size = {
				250,
				230,
			},
			offset = {
				0,
				-21,
				0,
			},
		},
	},
	{
		pass_type = "text",
		style_id = "slot_title",
		value = "n/a",
		value_id = "slot_title",
		style = gear_item_slot_title_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			color = Color.terminal_background_dark(nil, true),
			selected_color = Color.terminal_background_selected(nil, true),
			offset = {
				0,
				0,
				1,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = {
				100,
				33,
				35,
				37,
			},
			color = {
				100,
				33,
				35,
				37,
			},
			offset = {
				0,
				0,
				2,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "button_gradient",
		value = "content/ui/materials/gradients/gradient_diagonal_down_right",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				1,
			},
		},
		change_function = function (content, style)
			ButtonPassTemplates.terminal_button_change_function(content, style)
			ButtonPassTemplates.terminal_button_hover_change_function(content, style)
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/icons/generic/aquila",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			offset = {
				0,
				0,
				3,
			},
			size = {
				93.60000000000001,
				36,
			},
		},
		visibility_function = function (content, style)
			return not content.item
		end,
	},
	{
		pass_type = "texture",
		style_id = "icon",
		value = "content/ui/materials/icons/items/containers/item_container_square",
		value_id = "icon",
		style = {
			scale_to_material = true,
			material_values = {},
			offset = {
				0,
				0,
				3,
			},
		},
		visibility_function = function (content, style)
			local parent_style = style.parent

			return parent_style.icon.material_values.use_placeholder_texture == 0
		end,
	},
	{
		pass_type = "rotated_texture",
		style_id = "loading",
		value = "content/ui/materials/loading/loading_small",
		style = {
			angle = 0,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				80,
				80,
			},
			color = {
				60,
				160,
				160,
				160,
			},
			offset = {
				0,
				0,
				3,
			},
		},
		visibility_function = function (content, style)
			local use_placeholder_texture = content.use_placeholder_texture

			if (not use_placeholder_texture or use_placeholder_texture == 1) and content.item then
				return true
			end

			return false
		end,
		change_function = function (content, style, _, dt)
			local add = -0.5 * dt

			style.rotation_progress = ((style.rotation_progress or 0) + add) % 1
			style.angle = style.rotation_progress * math.pi * 2
		end,
	},
	{
		pass_type = "texture",
		style_id = "inner_highlight",
		value = "content/ui/materials/frames/inner_shadow_medium",
		style = {
			scale_to_material = true,
			color = Color.terminal_frame(255, true),
			offset = {
				0,
				0,
				4,
			},
		},
		change_function = function (content, style)
			local hotspot = content.hotspot

			style.color[1] = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress) * 255
		end,
	},
	{
		pass_type = "texture",
		style_id = "new_indicator",
		value = "content/ui/materials/symbols/new_item_indicator",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			size = {
				90,
				90,
			},
			offset = {
				0,
				60,
				4,
			},
			color = Color.terminal_corner_selected(255, true),
		},
		visibility_function = function (content, style)
			return content.has_new_items
		end,
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				6,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_corner(nil, true),
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				7,
			},
		},
		change_function = item_change_function,
	},
}
ItemPassTemplates.ui_item_emote_slot = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_click,
		},
	},
	{
		pass_type = "texture",
		style_id = "slot",
		value = "content/ui/materials/frames/cosmetic_slot_small",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = {
				255,
				255,
				255,
				255,
			},
			size = {
				125,
				115,
			},
			offset = {
				0,
				-10.5,
				0,
			},
		},
	},
	{
		pass_type = "text",
		style_id = "slot_title",
		value = "n/a",
		value_id = "slot_title",
		style = ui_item_emote_slot_title_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			color = Color.terminal_background_dark(nil, true),
			selected_color = Color.terminal_background_selected(nil, true),
			offset = {
				0,
				0,
				1,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = {
				100,
				33,
				35,
				37,
			},
			color = {
				100,
				33,
				35,
				37,
			},
			offset = {
				0,
				0,
				2,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "button_gradient",
		value = "content/ui/materials/gradients/gradient_diagonal_down_right",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				1,
			},
		},
		change_function = function (content, style)
			ButtonPassTemplates.terminal_button_change_function(content, style)
			ButtonPassTemplates.terminal_button_hover_change_function(content, style)
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/icons/generic/aquila",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			offset = {
				0,
				0,
				3,
			},
			size = {
				52,
				20,
			},
		},
		visibility_function = function (content, style)
			return not content.item
		end,
	},
	{
		pass_type = "texture",
		style_id = "icon",
		value = "content/ui/materials/icons/items/containers/item_container_square",
		value_id = "icon",
		style = {
			scale_to_material = true,
			material_values = {},
			offset = {
				0,
				0,
				3,
			},
		},
		visibility_function = function (content, style)
			local parent_style = style.parent

			return parent_style.icon.material_values.use_placeholder_texture == 0
		end,
	},
	{
		pass_type = "rotated_texture",
		style_id = "loading",
		value = "content/ui/materials/loading/loading_small",
		style = {
			angle = 0,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				40,
				40,
			},
			color = {
				60,
				160,
				160,
				160,
			},
			offset = {
				0,
				0,
				3,
			},
		},
		visibility_function = function (content, style)
			local use_placeholder_texture = content.use_placeholder_texture

			if (not use_placeholder_texture or use_placeholder_texture == 1) and content.item then
				return true
			end

			return false
		end,
		change_function = function (content, style, _, dt)
			local add = -0.5 * dt

			style.rotation_progress = ((style.rotation_progress or 0) + add) % 1
			style.angle = style.rotation_progress * math.pi * 2
		end,
	},
	{
		pass_type = "texture",
		style_id = "inner_highlight",
		value = "content/ui/materials/frames/inner_shadow_medium",
		style = {
			scale_to_material = true,
			color = Color.terminal_frame(255, true),
			offset = {
				0,
				0,
				4,
			},
		},
		change_function = function (content, style)
			local hotspot = content.hotspot

			style.color[1] = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress) * 255
		end,
	},
	{
		pass_type = "texture",
		style_id = "new_indicator",
		value = "content/ui/materials/symbols/new_item_indicator",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			size = {
				90,
				90,
			},
			offset = {
				0,
				60,
				4,
			},
			color = Color.terminal_corner_selected(255, true),
		},
		visibility_function = function (content, style)
			return content.has_new_items
		end,
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				6,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_corner(nil, true),
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				7,
			},
		},
		change_function = item_change_function,
	},
}
ItemPassTemplates.ui_item_pose_slot = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_click,
		},
	},
	{
		pass_type = "texture",
		style_id = "slot",
		value = "content/ui/materials/frames/cosmetic_slot_small",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = {
				255,
				255,
				255,
				255,
			},
			size = {
				125,
				115,
			},
			offset = {
				0,
				-10.5,
				0,
			},
		},
	},
	{
		pass_type = "text",
		style_id = "slot_title",
		value = "n/a",
		value_id = "slot_title",
		style = ui_item_emote_slot_title_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			color = Color.terminal_background_dark(nil, true),
			selected_color = Color.terminal_background_selected(nil, true),
			offset = {
				0,
				0,
				1,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = {
				100,
				33,
				35,
				37,
			},
			color = {
				100,
				33,
				35,
				37,
			},
			offset = {
				0,
				0,
				2,
			},
		},
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/icons/generic/aquila",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			offset = {
				0,
				0,
				3,
			},
			size = {
				52,
				20,
			},
		},
		visibility_function = function (content, style)
			return not content.item
		end,
	},
	{
		pass_type = "texture",
		style_id = "icon",
		value = "content/ui/materials/icons/items/containers/item_container_landscape",
		value_id = "icon",
		style = {
			scale_to_material = true,
			material_values = {},
			offset = {
				0,
				0,
				3,
			},
		},
		visibility_function = function (content, style)
			local parent_style = style.parent

			return parent_style.icon.material_values.use_placeholder_texture == 0
		end,
	},
	{
		pass_type = "rotated_texture",
		style_id = "loading",
		value = "content/ui/materials/loading/loading_small",
		style = {
			angle = 0,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				40,
				40,
			},
			color = {
				60,
				160,
				160,
				160,
			},
			offset = {
				0,
				0,
				3,
			},
		},
		visibility_function = function (content, style)
			local use_placeholder_texture = content.use_placeholder_texture

			if (not use_placeholder_texture or use_placeholder_texture == 1) and content.item then
				return true
			end

			return false
		end,
		change_function = function (content, style, _, dt)
			local add = -0.5 * dt

			style.rotation_progress = ((style.rotation_progress or 0) + add) % 1
			style.angle = style.rotation_progress * math.pi * 2
		end,
	},
	{
		pass_type = "texture",
		style_id = "inner_highlight",
		value = "content/ui/materials/frames/inner_shadow_medium",
		style = {
			scale_to_material = true,
			color = Color.terminal_frame(255, true),
			offset = {
				0,
				0,
				4,
			},
		},
		change_function = function (content, style)
			local hotspot = content.hotspot

			style.color[1] = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress) * 255
		end,
	},
	{
		pass_type = "texture",
		style_id = "new_indicator",
		value = "content/ui/materials/symbols/new_item_indicator",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			size = {
				90,
				90,
			},
			offset = {
				0,
				60,
				4,
			},
			color = Color.terminal_corner_selected(255, true),
		},
		visibility_function = function (content, style)
			return content.has_new_items
		end,
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				6,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_corner(nil, true),
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				7,
			},
		},
		change_function = item_change_function,
	},
}
ItemPassTemplates.item_slot = {
	{
		pass_type = "texture",
		style_id = "outer_shadow",
		value = "content/ui/materials/frames/dropshadow_medium",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			color = Color.black(200, true),
			size_addition = {
				20,
				20,
			},
		},
	},
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_click,
		},
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			color = Color.terminal_background_dark(nil, true),
			selected_color = Color.terminal_background_selected(nil, true),
		},
	},
	{
		pass_type = "texture_uv",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_diagonal_down_right",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			color = Color.terminal_background_gradient(nil, true),
			size = {},
			offset = {
				0,
				0,
				2,
			},
			uvs = {
				{
					1,
					0,
				},
				{
					0,
					1,
				},
			},
		},
		change_function = function (content, style)
			style.color[1] = 150
		end,
	},
	{
		pass_type = "texture",
		style_id = "button_gradient",
		value = "content/ui/materials/gradients/gradient_diagonal_down_right",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				1,
			},
		},
		change_function = function (content, style)
			ButtonPassTemplates.terminal_button_change_function(content, style)
			ButtonPassTemplates.terminal_button_hover_change_function(content, style)
		end,
	},
	{
		pass_type = "texture",
		style_id = "inner_highlight",
		value = "content/ui/materials/frames/inner_shadow_medium",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "top",
			color = Color.terminal_background_gradient_selected(255, true),
			size = {
				[2] = weapon_item_size[2],
			},
			offset = {
				0,
				0,
				4,
			},
		},
		change_function = function (content, style)
			local hotspot = content.hotspot

			style.color[1] = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress) * 255
		end,
	},
	{
		pass_type = "texture_uv",
		style_id = "icon",
		value = "content/ui/materials/icons/items/containers/item_container_landscape",
		value_id = "icon",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "top",
			material_values = {},
			size = {
				weapon_icon_size[1],
				weapon_item_size[2],
			},
			offset = {
				0,
				0,
				4,
			},
			uvs = {
				{
					0,
					(weapon_icon_size[2] - weapon_item_size[2]) * 0.5 / weapon_icon_size[2],
				},
				{
					1,
					1 - (weapon_icon_size[2] - weapon_item_size[2]) * 0.5 / weapon_icon_size[2],
				},
			},
		},
		visibility_function = function (content, style)
			local use_placeholder_texture = content.use_placeholder_texture

			if use_placeholder_texture and use_placeholder_texture == 0 and content.item and not content.item.is_fallback_item then
				return true
			end

			return false
		end,
	},
	{
		pass_type = "rotated_texture",
		style_id = "loading",
		value = "content/ui/materials/loading/loading_small",
		style = {
			angle = 0,
			horizontal_alignment = "right",
			vertical_alignment = "center",
			size = {
				80,
				80,
			},
			color = {
				60,
				160,
				160,
				160,
			},
			offset = {
				-90,
				0,
				4,
			},
		},
		visibility_function = function (content, style)
			local use_placeholder_texture = content.use_placeholder_texture

			if (not use_placeholder_texture or use_placeholder_texture == 1) and content.item then
				return true
			end

			return false
		end,
		change_function = function (content, style, _, dt)
			local add = -0.5 * dt

			style.rotation_progress = ((style.rotation_progress or 0) + add) % 1
			style.angle = style.rotation_progress * math.pi * 2
		end,
	},
	{
		pass_type = "text",
		style_id = "display_name",
		value = "n/a",
		value_id = "display_name",
		style = item_display_name_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
	},
	{
		pass_type = "text",
		style_id = "sub_display_name",
		value = "n/a",
		value_id = "sub_display_name",
		style = item_sub_display_name_text_style,
	},
	{
		pass_type = "text",
		style_id = "rarity_name",
		value = "n/a",
		value_id = "rarity_name",
		style = item_rarity_text_style,
	},
	{
		pass_type = "text",
		style_id = "item_level",
		value = "",
		value_id = "item_level",
		style = item_level_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
	},
	{
		pass_type = "texture",
		style_id = "rarity_tag",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			size = {
				6,
			},
			offset = {
				0,
				0,
				9,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				12,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_corner(nil, true),
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				13,
			},
		},
		change_function = item_change_function,
	},
}
ItemPassTemplates.item = {
	{
		pass_type = "texture",
		style_id = "outer_shadow",
		value = "content/ui/materials/frames/dropshadow_medium",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			color = Color.black(200, true),
			size_addition = {
				20,
				20,
			},
		},
	},
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style_id = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_click,
		},
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			color = Color.terminal_background_dark(nil, true),
			selected_color = Color.terminal_background_selected(nil, true),
		},
	},
	{
		pass_type = "texture_uv",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_diagonal_down_right",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			color = Color.terminal_background_gradient(nil, true),
			size = {},
			offset = {
				0,
				0,
				2,
			},
			uvs = {
				{
					1,
					0,
				},
				{
					0,
					1,
				},
			},
		},
		change_function = function (content, style)
			style.color[1] = 150
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
		style = {
			vertical_alignment = "top",
			offset = {
				0,
				0,
				2,
			},
			color = {
				105,
				45,
				45,
				45,
			},
		},
		visibility_function = function (content, style)
			return not content.level_requirement_met
		end,
	},
	{
		pass_type = "texture",
		style_id = "button_gradient",
		value = "content/ui/materials/gradients/gradient_diagonal_down_right",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				1,
			},
		},
		change_function = function (content, style)
			ButtonPassTemplates.terminal_button_change_function(content, style)
			ButtonPassTemplates.terminal_button_hover_change_function(content, style)
		end,
	},
	{
		pass_type = "texture",
		style_id = "inner_shadow",
		value = "content/ui/materials/frames/inner_shadow_medium",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "top",
			color = Color.black(100, true),
			size = {
				[2] = weapon_item_size[2],
			},
			offset = {
				0,
				0,
				3,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "inner_highlight",
		value = "content/ui/materials/frames/inner_shadow_medium",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "top",
			color = Color.terminal_background_gradient_selected(255, true),
			size = {
				[2] = weapon_item_size[2],
			},
			offset = {
				0,
				0,
				4,
			},
		},
		change_function = function (content, style)
			local hotspot = content.hotspot

			style.color[1] = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress) * 255
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/symbols/new_item_indicator",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "top",
			size = {
				100,
				100,
			},
			offset = {
				30,
				-30,
				4,
			},
			color = Color.terminal_corner_selected(255, true),
		},
		visibility_function = function (content, style)
			if content.store_item then
				return false
			end

			return content.element.new_item_marker
		end,
		change_function = function (content, style)
			if content.store_item then
				return false
			end

			local speed = 5
			local anim_progress = 1 - (0.5 + math.sin(Application.time_since_launch() * speed) * 0.5)
			local hotspot = content.hotspot

			style.color[1] = 150 + anim_progress * 80

			local hotspot = content.hotspot

			if hotspot.is_selected or hotspot.on_hover_exit then
				content.element.new_item_marker = nil

				local element = content.element
				local item = element and (element.real_item or element.item)

				if content.element.remove_new_marker_callback and item then
					content.element.remove_new_marker_callback(item)
				end
			end
		end,
	},
	{
		pass_type = "texture_uv",
		style_id = "icon",
		value = "content/ui/materials/icons/items/containers/item_container_landscape",
		value_id = "icon",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "top",
			material_values = {},
			size = {
				weapon_icon_size[1],
				weapon_item_size[2],
			},
			offset = {
				0,
				0,
				4,
			},
			uvs = {
				{
					0,
					(weapon_icon_size[2] - weapon_item_size[2]) * 0.5 / weapon_icon_size[2],
				},
				{
					1,
					1 - (weapon_icon_size[2] - weapon_item_size[2]) * 0.5 / weapon_icon_size[2],
				},
			},
		},
		visibility_function = function (content, style)
			local use_placeholder_texture = content.use_placeholder_texture

			if use_placeholder_texture and use_placeholder_texture == 0 then
				return true
			end

			return false
		end,
	},
	{
		pass_type = "rotated_texture",
		style_id = "loading",
		value = "content/ui/materials/loading/loading_small",
		style = {
			angle = 0,
			horizontal_alignment = "right",
			vertical_alignment = "top",
			size = {
				80,
				80,
			},
			color = {
				60,
				160,
				160,
				160,
			},
			offset = {
				-85,
				20,
				4,
			},
		},
		visibility_function = function (content, style)
			local use_placeholder_texture = content.use_placeholder_texture

			if not use_placeholder_texture or use_placeholder_texture == 1 then
				return true
			end

			return false
		end,
		change_function = function (content, style, _, dt)
			local add = -0.5 * dt

			style.rotation_progress = ((style.rotation_progress or 0) + add) % 1
			style.angle = style.rotation_progress * math.pi * 2
		end,
	},
	{
		pass_type = "text",
		style_id = "display_name",
		value = "n/a",
		value_id = "display_name",
		style = item_display_name_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
	},
	{
		pass_type = "text",
		style_id = "sub_display_name",
		value = "n/a",
		value_id = "sub_display_name",
		style = item_sub_display_name_text_style,
	},
	{
		pass_type = "text",
		style_id = "rarity_name",
		value = "n/a",
		value_id = "rarity_name",
		style = item_rarity_text_style,
	},
	{
		pass_type = "text",
		style_id = "item_level",
		value = "n/a",
		value_id = "item_level",
		style = item_level_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
	},
	{
		pass_type = "rect",
		style = {
			vertical_alignment = "top",
			offset = {
				0,
				0,
				6,
			},
			color = {
				150,
				0,
				0,
				0,
			},
		},
		visibility_function = function (content, style)
			return not content.level_requirement_met
		end,
	},
	{
		pass_type = "rect",
		style_id = "required_level_background",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "top",
			size = {
				nil,
				38,
			},
			offset = {
				0,
				ItemPassTemplates.weapon_item_size[2] * 0.5 - 19,
				7,
			},
			color = {
				150,
				35,
				0,
				0,
			},
		},
		visibility_function = function (content, style)
			return not content.level_requirement_met
		end,
	},
	{
		pass_type = "text",
		style_id = "required_level",
		value = "loc_requires_level",
		value_id = "required_level",
		style = required_level_text_style,
		visibility_function = function (content, style)
			return not content.level_requirement_met
		end,
	},
	{
		pass_type = "texture",
		style_id = "rarity_tag",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			size = {
				6,
			},
			offset = {
				0,
				0,
				9,
			},
			color = Color.terminal_corner_hover(255, true),
		},
	},
	{
		pass_type = "rect",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			size = {
				nil,
				40,
			},
			size_addition = {
				-6,
				0,
			},
			offset = {
				6,
				0,
				10,
			},
			color = Color.terminal_background_dark(150, true),
		},
		visibility_function = function (content, style)
			return content.has_price_tag
		end,
	},
	{
		pass_type = "texture",
		style_id = "salvage_icon",
		value = "content/ui/materials/icons/items/salvage_middle",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			size = {
				54,
				54,
			},
			offset = {
				weapon_icon_size[1] * 0.5 - 27,
				0,
				14,
			},
		},
		visibility_function = function (content, style)
			return style.parent.salvage_circle.material_values.progress > 0
		end,
	},
	{
		pass_type = "texture",
		style_id = "salvage_circle",
		value = "content/ui/materials/icons/items/salvage_circle",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			material_values = {
				progress = 0,
			},
			size = {
				100,
				100,
			},
			offset = {
				weapon_icon_size[1] * 0.5 - 50,
				0,
				15,
			},
		},
		visibility_function = function (content, style)
			return style.material_values.progress > 0
		end,
	},
	{
		pass_type = "texture",
		style_id = "deleted_icon",
		value = "content/ui/materials/icons/items/equipped_label",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				64,
				64,
			},
			offset = {
				0,
				0,
				16,
			},
		},
		visibility_function = function (content, style)
			return content.multi_selected
		end,
	},
	{
		pass_type = "rect",
		style_id = "deleted_icon_background",
		value = "content/ui/materials/icons/items/equipped_label",
		style = {
			color = Color.black(127.5, true),
			offset = {
				0,
				0,
				15,
			},
		},
		visibility_function = function (content, style)
			return content.multi_selected
		end,
	},
	{
		pass_type = "texture",
		style_id = "equipped_icon",
		value = "content/ui/materials/icons/items/equipped_label",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "top",
			size = {
				32,
				32,
			},
			offset = {
				0,
				0,
				16,
			},
		},
		visibility_function = function (content, style)
			return content.equipped
		end,
	},
	{
		pass_type = "text",
		style_id = "favorite_icon",
		value = string.format("%s %s", "", Localize("loc_inventory_menu_favorite_item")),
		style = {
			font_size = 18,
			horizontal_alignment = "left",
			text_vertical_alignment = "bottom",
			vertical_alignment = "bottom",
			offset = {
				15,
				-5,
				16,
			},
			text_color = Color.terminal_text_header(255, true),
		},
		visibility_function = function (content, style)
			return content.favorite
		end,
	},
	{
		pass_type = "texture",
		style_id = "wallet_icon",
		value = "content/ui/materials/base/ui_default_base",
		value_id = "wallet_icon",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "bottom",
			size = {
				28,
				20,
			},
			offset = {
				-8,
				-10,
				12,
			},
			color = {
				255,
				255,
				255,
				255,
			},
		},
		visibility_function = function (content, style)
			return content.has_price_tag and not content.sold
		end,
	},
	{
		pass_type = "text",
		style_id = "price_text",
		value = "n/a",
		value_id = "price_text",
		style = item_price_style,
		visibility_function = function (content, style)
			return content.has_price_tag and not content.sold
		end,
	},
	{
		pass_type = "text",
		style_id = "owned_text",
		value_id = "owned_text",
		value = string.format("%s %s", Localize("loc_item_owned"), ""),
		style = item_sold_style,
		visibility_function = function (content, style)
			return content.sold or content.owned
		end,
	},
	{
		pass_type = "rect",
		style = {
			color = {
				190,
				20,
				20,
				20,
			},
			offset = {
				0,
				0,
				12,
			},
		},
		visibility_function = function (content, style)
			return content.sold or content.owned
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/dividers/faded_line_01",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			size = {
				nil,
				2,
			},
			size_addition = {
				-40,
				0,
			},
			offset = {
				0,
				-39,
				13,
			},
			color = Color.terminal_frame(nil, true),
		},
		visibility_function = function (content, style)
			return content.has_price_tag
		end,
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				15,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_corner(nil, true),
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				16,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "rect",
		style_id = "warning_message_background",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "top",
			size = {
				nil,
				38,
			},
			offset = {
				0,
				ItemPassTemplates.weapon_item_size[2] * 0.5 - 19,
				7,
			},
			color = {
				150,
				35,
				0,
				0,
			},
		},
		visibility_function = function (content, style)
			return content.warning_message and content.warning_message ~= ""
		end,
	},
	{
		pass_type = "text",
		style_id = "warning_message",
		value = "",
		value_id = "warning_message",
		style = required_level_text_style,
	},
}
ItemPassTemplates.general_goods_item = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_click,
		},
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			color = Color.terminal_background_dark(nil, true),
			selected_color = Color.terminal_background_selected(nil, true),
		},
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_horizontal",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			color = Color.terminal_background_gradient(nil, true),
			size = {
				weapon_item_size[1] * 0.5,
			},
			offset = {
				0,
				0,
				1,
			},
		},
		change_function = function (content, style)
			local hotspot = content.hotspot

			style.color[1] = 50
		end,
	},
	{
		pass_type = "texture",
		style_id = "inner_highlight",
		value = "content/ui/materials/frames/inner_shadow_medium",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "top",
			color = Color.terminal_background_gradient_selected(255, true),
			size = {
				[2] = weapon_item_size[2],
			},
			offset = {
				0,
				0,
				3,
			},
		},
		change_function = function (content, style)
			local hotspot = content.hotspot

			style.color[1] = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress) * 255
		end,
	},
	{
		pass_type = "texture_uv",
		style_id = "background_icon",
		value_id = "background_icon",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			material_values = {},
			color = Color.terminal_grid_background_icon(80, true),
			offset = {
				0,
				0,
				4,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "icon",
		value = "content/ui/materials/icons/contracts/contracts_store/uknown_melee_weapon",
		value_id = "icon",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "top",
			color = Color.terminal_text_body(255, true),
			offset = {
				-18,
				8,
				5,
			},
			size = {
				128,
				96,
			},
		},
	},
	{
		pass_type = "text",
		style_id = "display_name",
		value = "n/a",
		value_id = "display_name",
		style = item_display_name_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
	},
	{
		pass_type = "text",
		style_id = "sub_display_name",
		value = "n/a",
		value_id = "sub_display_name",
		style = item_sub_display_name_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
	},
	{
		pass_type = "rect",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			size = {
				nil,
				40,
			},
			size_addition = {
				-6,
				0,
			},
			offset = {
				6,
				0,
				10,
			},
			color = Color.terminal_background_dark(150, true),
		},
		visibility_function = function (content, style)
			return content.has_price_tag
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/dividers/faded_line_01",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			size = {
				nil,
				2,
			},
			size_addition = {
				-40,
				0,
			},
			offset = {
				0,
				-39,
				12,
			},
			color = Color.terminal_frame(nil, true),
		},
		visibility_function = function (content, style)
			return content.has_price_tag
		end,
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				12,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_corner(nil, true),
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				13,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "wallet_icon",
		value = "content/ui/materials/base/ui_default_base",
		value_id = "wallet_icon",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "bottom",
			size = {
				28,
				20,
			},
			offset = {
				-8,
				-10,
				12,
			},
			color = {
				255,
				255,
				255,
				255,
			},
		},
		visibility_function = function (content, style)
			return content.has_price_tag
		end,
	},
	{
		pass_type = "text",
		style_id = "price_text",
		value = "n/a",
		value_id = "price_text",
		style = item_price_style,
		visibility_function = function (content, style)
			return content.has_price_tag
		end,
	},
}
ItemPassTemplates.credits_goods_item = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_click,
		},
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			default_color = Color.terminal_background(nil, true),
			selected_color = Color.terminal_background_selected(nil, true),
		},
		change_function = ButtonPassTemplates.terminal_button_change_function,
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				2,
			},
		},
		change_function = function (content, style)
			ButtonPassTemplates.terminal_button_change_function(content, style)
			ButtonPassTemplates.terminal_button_hover_change_function(content, style)
		end,
	},
	{
		pass_type = "texture",
		style_id = "outer_shadow",
		value = "content/ui/materials/frames/dropshadow_medium",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			color = Color.black(100, true),
			size_addition = {
				20,
				20,
			},
			offset = {
				0,
				0,
				3,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "icon",
		value = "content/ui/materials/icons/contracts/contracts_store/uknown_melee_weapon",
		value_id = "icon",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "top",
			color = Color.terminal_text_body(255, true),
			default_color = Color.terminal_text_body(nil, true),
			selected_color = Color.terminal_icon(nil, true),
			offset = {
				0,
				4,
				5,
			},
			size = {
				128,
				48,
			},
		},
		change_function = ButtonPassTemplates.terminal_button_change_function,
	},
	{
		pass_type = "text",
		style_id = "display_name",
		value = "n/a",
		value_id = "display_name",
		style = table.merge(table.clone(credits_item_display_name_text_style), {
			text_vertical_alignment = "top",
			vertical_alignment = "top",
			offset = {
				10,
				8,
				6,
			},
		}),
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
		visibility_function = function (content, style)
			return content.level_requirement_met
		end,
	},
	{
		pass_type = "text",
		style_id = "sub_display_name",
		value = "n/a",
		value_id = "sub_display_name",
		style = table.merge(table.clone(credits_item_display_name_text_style), {
			text_vertical_alignment = "bottom",
			vertical_alignment = "top",
			offset = {
				10,
				-8,
				6,
			},
			text_color = Color.terminal_text_body(255, true),
			default_color = Color.terminal_text_body(255, true),
			hover_color = Color.terminal_text_header(255, true),
		}),
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
		visibility_function = function (content, style)
			return content.level_requirement_met
		end,
	},
	{
		pass_type = "rect",
		style = {
			vertical_alignment = "top",
			offset = {
				0,
				0,
				6,
			},
			color = {
				150,
				0,
				0,
				0,
			},
		},
		visibility_function = function (content, style)
			return not content.level_requirement_met
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
		style = {
			vertical_alignment = "top",
			offset = {
				0,
				0,
				2,
			},
			color = {
				105,
				45,
				45,
				45,
			},
		},
		visibility_function = function (content, style)
			return not content.level_requirement_met
		end,
	},
	{
		pass_type = "text",
		style_id = "required_level",
		value = "loc_requires_level",
		value_id = "required_level",
		style = required_level_general_good_text_style,
		visibility_function = function (content, style)
			return not content.level_requirement_met
		end,
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				12,
			},
		},
		change_function = function (content, style)
			item_change_function(content, style)
		end,
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				12,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_corner(nil, true),
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				13,
			},
		},
		change_function = item_change_function,
	},
}
ItemPassTemplates.item_icon = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_click,
		},
	},
	{
		pass_type = "texture",
		style_id = "outer_shadow",
		value = "content/ui/materials/frames/dropshadow_medium",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			color = Color.black(200, true),
			size_addition = {
				20,
				20,
			},
		},
	},
	{
		pass_type = "texture_uv",
		style_id = "icon",
		value = "content/ui/materials/icons/items/containers/item_container_landscape",
		value_id = "icon",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "top",
			material_values = {},
			offset = {
				0,
				0,
				4,
			},
			uvs = {
				{
					(weapon_icon_size[1] - item_icon_size[1]) * 0.5 / weapon_icon_size[1],
					(weapon_icon_size[2] - item_icon_size[2]) * 0.5 / weapon_icon_size[2],
				},
				{
					1 - (weapon_icon_size[1] - item_icon_size[1]) * 0.5 / weapon_icon_size[1],
					1 - (weapon_icon_size[2] - item_icon_size[2]) * 0.5 / weapon_icon_size[2],
				},
			},
		},
		visibility_function = function (content, style)
			local use_placeholder_texture = content.use_placeholder_texture

			if use_placeholder_texture and use_placeholder_texture == 0 then
				return true
			end

			return false
		end,
	},
	{
		pass_type = "rotated_texture",
		style_id = "loading",
		value = "content/ui/materials/loading/loading_small",
		style = {
			angle = 0,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				80,
				80,
			},
			color = {
				60,
				160,
				160,
				160,
			},
			offset = {
				0,
				0,
				4,
			},
		},
		visibility_function = function (content, style)
			local use_placeholder_texture = content.use_placeholder_texture

			if not use_placeholder_texture or use_placeholder_texture == 1 then
				return true
			end

			return false
		end,
		change_function = function (content, style, _, dt)
			local add = -0.5 * dt

			style.rotation_progress = ((style.rotation_progress or 0) + add) % 1
			style.angle = style.rotation_progress * math.pi * 2
		end,
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			color = Color.terminal_background_dark(nil, true),
			selected_color = Color.terminal_background_selected(nil, true),
			offset = {
				0,
				0,
				0,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = {
				100,
				33,
				35,
				37,
			},
			color = {
				100,
				33,
				35,
				37,
			},
			offset = {
				0,
				0,
				1,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "button_gradient",
		value = "content/ui/materials/gradients/gradient_diagonal_down_right",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				1,
			},
		},
		change_function = function (content, style)
			ButtonPassTemplates.terminal_button_change_function(content, style)
			ButtonPassTemplates.terminal_button_hover_change_function(content, style)
		end,
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				6,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_corner(nil, true),
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				7,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "equipped_icon",
		value = "content/ui/materials/icons/items/equipped_label",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "top",
			size = {
				32,
				32,
			},
			offset = {
				0,
				0,
				8,
			},
		},
		visibility_function = function (content, style)
			return content.equipped
		end,
	},
	{
		pass_type = "text",
		style_id = "owned",
		value = "",
		value_id = "owned",
		style = item_owned_text_style,
		visibility_function = function (content, style)
			return content.owned
		end,
	},
	{
		pass_type = "rect",
		style = {
			vertical_alignment = "bottom",
			offset = {
				0,
				0,
				3,
			},
			color = {
				150,
				0,
				0,
				0,
			},
			size = {
				nil,
				40,
			},
		},
		visibility_function = function (content, style)
			return content.has_price_tag
		end,
	},
	{
		pass_type = "text",
		style_id = "price_text",
		value = "n/a",
		value_id = "price_text",
		style = gear_item_price_style,
		visibility_function = function (content, style)
			return content.has_price_tag and not content.sold
		end,
	},
	{
		pass_type = "texture",
		style_id = "wallet_icon",
		value = "content/ui/materials/base/ui_default_base",
		value_id = "wallet_icon",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "bottom",
			size = {
				28,
				20,
			},
			offset = {
				-2,
				-5,
				12,
			},
			color = {
				255,
				255,
				255,
				255,
			},
		},
		visibility_function = function (content, style)
			return content.has_price_tag and not content.sold
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/symbols/new_item_indicator",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "top",
			size = {
				100,
				100,
			},
			offset = {
				30,
				-30,
				5,
			},
			color = Color.terminal_corner_selected(255, true),
		},
		visibility_function = function (content, style)
			return content.element.new_item_marker
		end,
		change_function = function (content, style)
			local speed = 5
			local anim_progress = 1 - (0.5 + math.sin(Application.time_since_launch() * speed) * 0.5)
			local hotspot = content.hotspot

			style.color[1] = 150 + anim_progress * 80

			local hotspot = content.hotspot

			if hotspot.is_selected or hotspot.on_hover_exit then
				content.element.new_item_marker = nil

				local element = content.element
				local item = element and (element.real_item or element.item)

				if content.element.remove_new_marker_callback and item then
					content.element.remove_new_marker_callback(item)
				end
			end
		end,
	},
	{
		pass_type = "texture",
		style_id = "favorite_icon",
		value = "content/ui/materials/symbols/character_level",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "bottom",
			size = {
				40,
				40,
			},
			offset = {
				0,
				0,
				9,
			},
			color = Color.ui_veteran(255, true),
		},
		visibility_function = function (content, style)
			return content.favorite
		end,
	},
}

local emote_item_slot_title_style = table.clone(UIFontSettings.body)

emote_item_slot_title_style.text_horizontal_alignment = "left"
emote_item_slot_title_style.text_vertical_alignment = "center"
emote_item_slot_title_style.horizontal_alignment = "left"
emote_item_slot_title_style.vertical_alignment = "center"
emote_item_slot_title_style.offset = {
	70,
	0,
	5,
}
emote_item_slot_title_style.text_color = Color.ui_brown_super_light(255, true)
emote_item_slot_title_style.default_color = Color.ui_brown_super_light(255, true)
emote_item_slot_title_style.hover_color = Color.ui_brown_super_light(255, true)

local emote_item_slot_name_style = table.clone(UIFontSettings.body)

emote_item_slot_name_style.text_horizontal_alignment = "right"
emote_item_slot_name_style.text_vertical_alignment = "center"
emote_item_slot_name_style.horizontal_alignment = "right"
emote_item_slot_name_style.vertical_alignment = "center"
emote_item_slot_name_style.offset = {
	-90,
	0,
	5,
}
emote_item_slot_name_style.text_color = Color.ui_brown_light(255, true)
emote_item_slot_name_style.default_color = Color.ui_brown_light(255, true)
emote_item_slot_name_style.hover_color = Color.ui_brown_super_light(255, true)
ItemPassTemplates.emote_item_slot = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_click,
		},
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/frames/hover",
		style = {
			hdr = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.ui_terminal(255, true),
			size_addition = {
				20,
				20,
			},
			offset = {
				0,
				0,
				0,
			},
		},
		change_function = function (content, style)
			local anim_progress = math.max(math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress), content.hotspot.anim_focus_progress)

			style.color[1] = anim_progress * 255

			local size_addition = style.size_addition
			local size_padding = 10 - math.easeInCubic(anim_progress) * 10

			size_addition[1] = size_padding
			size_addition[2] = size_padding
		end,
	},
	{
		pass_type = "text",
		style_id = "title_text",
		value = "n/a",
		value_id = "title_text",
		style = emote_item_slot_title_style,
	},
	{
		pass_type = "text",
		style_id = "name_text",
		value = "n/a",
		value_id = "name_text",
		style = emote_item_slot_name_style,
	},
	{
		pass_type = "rotated_texture",
		style_id = "slot_icon",
		value = "content/ui/materials/icons/items/emotes/emote_wheel_icon",
		value_id = "slot_icon",
		style = {
			angle = 0,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			color = Color.white(255, true),
			size = {
				42,
				42,
			},
			offset = {
				10,
				0,
				1,
			},
		},
		visibility_function = function (content, style)
			return true
		end,
	},
	{
		pass_type = "texture",
		style_id = "icon",
		value = "content/ui/materials/icons/cosmetics/categories/upper_body",
		value_id = "icon",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			color = Color.white(255, true),
			size = {
				50,
				50,
			},
			offset = {
				-30,
				0,
				1,
			},
		},
		visibility_function = function (content, style)
			return true
		end,
	},
	{
		pass_type = "texture",
		style_id = "arrow",
		value = "content/ui/materials/buttons/arrow_01",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			color = Color.white(255, true),
			size = {
				12,
				18,
			},
			offset = {
				-10,
				0,
				1,
			},
		},
		visibility_function = function (content, style)
			return true
		end,
	},
}

local animation_item_slot_title_style = table.clone(UIFontSettings.body)

animation_item_slot_title_style.text_horizontal_alignment = "left"
animation_item_slot_title_style.text_vertical_alignment = "center"
animation_item_slot_title_style.horizontal_alignment = "left"
animation_item_slot_title_style.vertical_alignment = "center"
animation_item_slot_title_style.offset = {
	70,
	0,
	5,
}
animation_item_slot_title_style.text_color = Color.ui_brown_super_light(255, true)
animation_item_slot_title_style.default_color = Color.ui_brown_super_light(255, true)
animation_item_slot_title_style.hover_color = Color.ui_brown_super_light(255, true)

local animation_item_slot_name_style = table.clone(UIFontSettings.body)

animation_item_slot_name_style.text_horizontal_alignment = "right"
animation_item_slot_name_style.text_vertical_alignment = "center"
animation_item_slot_name_style.horizontal_alignment = "right"
animation_item_slot_name_style.vertical_alignment = "center"
animation_item_slot_name_style.offset = {
	-40,
	0,
	5,
}
animation_item_slot_name_style.text_color = Color.ui_brown_light(255, true)
animation_item_slot_name_style.default_color = Color.ui_brown_light(255, true)
animation_item_slot_name_style.hover_color = Color.ui_brown_super_light(255, true)
ItemPassTemplates.animation_item_slot = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_click,
		},
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/frames/hover",
		style = {
			hdr = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.ui_terminal(255, true),
			size_addition = {
				20,
				20,
			},
			offset = {
				0,
				0,
				0,
			},
		},
		change_function = function (content, style)
			local anim_progress = math.max(math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress), content.hotspot.anim_focus_progress)

			style.color[1] = anim_progress * 255

			local size_addition = style.size_addition
			local size_padding = 10 - math.easeInCubic(anim_progress) * 10

			size_addition[1] = size_padding
			size_addition[2] = size_padding
		end,
	},
	{
		pass_type = "text",
		style_id = "title_text",
		value = "n/a",
		value_id = "title_text",
		style = animation_item_slot_title_style,
	},
	{
		pass_type = "text",
		style_id = "name_text",
		value = "n/a",
		value_id = "name_text",
		style = animation_item_slot_name_style,
	},
	{
		pass_type = "texture",
		style_id = "slot_icon",
		value = "content/ui/materials/icons/cosmetics/categories/upper_body",
		value_id = "slot_icon",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			color = Color.white(255, true),
			size = {
				50,
				50,
			},
			offset = {
				10,
				0,
				1,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "arrow",
		value = "content/ui/materials/buttons/arrow_01",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			color = Color.white(255, true),
			size = {
				12,
				18,
			},
			offset = {
				-10,
				0,
				1,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "new_indicator",
		value = "content/ui/materials/symbols/new_item_indicator",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			size = {
				90,
				90,
			},
			offset = {
				0,
				60,
				4,
			},
			color = Color.terminal_corner_selected(255, true),
		},
		visibility_function = function (content, style)
			return content.has_new_items
		end,
	},
}

local gadget_size = ItemPassTemplates.gadget_size
local gadget_display_name_text_style = table.clone(UIFontSettings.header_3)

gadget_display_name_text_style.text_horizontal_alignment = "center"
gadget_display_name_text_style.text_vertical_alignment = "top"
gadget_display_name_text_style.horizontal_alignment = "center"
gadget_display_name_text_style.vertical_alignment = "bottom"
gadget_display_name_text_style.offset = {
	0,
	0,
	7,
}
gadget_display_name_text_style.size = {
	gadget_size[1] - 20,
	gadget_size[2] - gadget_icon_size[2] - 30,
}
gadget_display_name_text_style.text_color = Color.terminal_text_header(255, true)
gadget_display_name_text_style.default_color = Color.terminal_text_header(255, true)
gadget_display_name_text_style.hover_color = Color.terminal_text_header_selected(255, true)
gadget_display_name_text_style.font_size = 20

local gadget_empty_text_style = table.clone(gadget_display_name_text_style)

gadget_empty_text_style.text_color = Color.terminal_text_body_sub_header(255, true)
gadget_empty_text_style.default_color = Color.terminal_text_body_sub_header(255, true)
gadget_empty_text_style.hover_color = Color.terminal_text_body(255, true)

local gadget_lock_symbol_text_style = table.clone(gadget_display_name_text_style)

gadget_lock_symbol_text_style.text_color = Color.terminal_frame(255, true)
gadget_lock_symbol_text_style.default_color = Color.terminal_frame(255, true)
gadget_lock_symbol_text_style.hover_color = Color.terminal_text_body_sub_header(255, true)
gadget_lock_symbol_text_style.font_size = 120
gadget_lock_symbol_text_style.drop_shadow = false
gadget_lock_symbol_text_style.text_horizontal_alignment = "center"
gadget_lock_symbol_text_style.text_vertical_alignment = "center"
gadget_lock_symbol_text_style.horizontal_alignment = "center"
gadget_lock_symbol_text_style.vertical_alignment = "center"
gadget_lock_symbol_text_style.offset = {
	0,
	-40,
	7,
}
ItemPassTemplates.gadget_item_slot = {
	{
		pass_type = "texture",
		style_id = "outer_shadow",
		value = "content/ui/materials/frames/dropshadow_medium",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			color = Color.black(200, true),
			size_addition = {
				20,
				20,
			},
		},
	},
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_click,
		},
		visibility_function = function (content, style)
			return content.parent.unlocked
		end,
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = {
				100,
				33,
				35,
				37,
			},
			color = {
				100,
				33,
				35,
				37,
			},
			offset = {
				0,
				0,
				4,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			color = {
				100,
				0,
				0,
				0,
			},
			offset = {
				0,
				0,
				5,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "button_gradient",
		value = "content/ui/materials/gradients/gradient_diagonal_down_right",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				4,
			},
		},
		change_function = function (content, style)
			ButtonPassTemplates.terminal_button_change_function(content, style)
			ButtonPassTemplates.terminal_button_hover_change_function(content, style)
		end,
	},
	{
		pass_type = "texture_uv",
		style_id = "icon",
		value = "content/ui/materials/icons/items/containers/item_container_landscape",
		value_id = "icon",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "top",
			material_values = {},
			size = {
				gadget_icon_size[1],
				gadget_icon_size[2],
			},
			offset = {
				0,
				35,
				6,
			},
			uvs = {
				{
					(gadget_icon_size[1] - gadget_icon_size[1]) * 0.5 / gadget_icon_size[1],
					0,
				},
				{
					1 - (gadget_icon_size[1] - gadget_icon_size[1]) * 0.5 / gadget_icon_size[1],
					1,
				},
			},
		},
		visibility_function = function (content, style)
			local use_placeholder_texture = content.use_placeholder_texture

			if use_placeholder_texture and use_placeholder_texture == 0 then
				return content.item and content.unlocked
			end

			return false
		end,
	},
	{
		pass_type = "rotated_texture",
		style_id = "loading",
		value = "content/ui/materials/loading/loading_small",
		style = {
			angle = 0,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				80,
				80,
			},
			color = {
				60,
				160,
				160,
				160,
			},
			offset = {
				0,
				-20,
				6,
			},
		},
		visibility_function = function (content, style)
			local use_placeholder_texture = content.use_placeholder_texture

			if (not use_placeholder_texture or use_placeholder_texture == 1) and content.item and content.unlocked then
				return true
			end

			return false
		end,
		change_function = function (content, style, _, dt)
			local add = -0.5 * dt

			style.rotation_progress = ((style.rotation_progress or 0) + add) % 1
			style.angle = style.rotation_progress * math.pi * 2
		end,
	},
	{
		pass_type = "text",
		style_id = "item_level",
		value = "",
		value_id = "item_level",
		style = gadget_item_level_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress or 0, hotspot.anim_select_progress or 0), hotspot.anim_focus_progress or 0)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
	},
	{
		pass_type = "texture",
		style_id = "inner_frame",
		value = "content/ui/materials/frames/line_thin_detailed_03",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				6,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				6,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_corner(nil, true),
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				7,
			},
		},
		change_function = item_change_function,
	},
	{
		pass_type = "texture",
		style_id = "inner_highlight",
		value = "content/ui/materials/frames/inner_shadow_medium",
		style = {
			scale_to_material = true,
			color = Color.terminal_frame_selected(255, true),
			offset = {
				0,
				0,
				13,
			},
		},
		change_function = function (content, style)
			local hotspot = content.hotspot

			style.color[1] = math.max(hotspot.anim_focus_progress or 0, hotspot.anim_select_progress or 0) * 255
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/icons/generic/aquila",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			offset = {
				0,
				-30,
				7,
			},
			size = {
				93.60000000000001,
				36,
			},
		},
		visibility_function = function (content, style)
			return not content.item and content.unlocked
		end,
	},
	{
		pass_type = "text",
		style_id = "display_name",
		value = "",
		value_id = "display_name",
		style = gadget_display_name_text_style,
		visibility_function = function (content, style)
			return content.item and content.unlocked
		end,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress or 0, hotspot.anim_select_progress or 0), hotspot.anim_focus_progress or 0)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
	},
	{
		pass_type = "text",
		value = Localize("loc_item_slot_empty"),
		style = gadget_empty_text_style,
		visibility_function = function (content, style)
			return not content.item and content.unlocked
		end,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress or 0, hotspot.anim_select_progress or 0), hotspot.anim_focus_progress or 0)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
	},
	{
		pass_type = "text",
		value_id = "unlock_text",
		value = Localize("loc_item_slot_empty"),
		style = gadget_empty_text_style,
		visibility_function = function (content, style)
			return not content.unlocked
		end,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress or 0, hotspot.anim_select_progress or 0), hotspot.anim_focus_progress or 0)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
	},
	{
		pass_type = "text",
		value = "",
		style = gadget_lock_symbol_text_style,
		visibility_function = function (content, style)
			return not content.unlocked
		end,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress or 0, hotspot.anim_select_progress or 0), hotspot.anim_focus_progress or 0)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end,
	},
}

local item_name_title_style = table.clone(UIFontSettings.header_1)

item_name_title_style.text_horizontal_alignment = "right"
item_name_title_style.text_vertical_alignment = "top"
item_name_title_style.horizontal_alignment = "right"
item_name_title_style.offset = {
	-70,
	0,
	2,
}
item_name_title_style.text_color = Color.white(255, true)
item_name_title_style.font_size = 38

local item_name_description_style = table.clone(UIFontSettings.body)

item_name_description_style.text_horizontal_alignment = "right"
item_name_description_style.text_vertical_alignment = "top"
item_name_description_style.horizontal_alignment = "right"
item_name_description_style.offset = {
	-70,
	0,
	2,
}
ItemPassTemplates.item_name = {
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/item_name",
		value_id = "background",
		style = {
			scale_to_material = true,
			vertical_alignment = "center",
			size_addition = {
				0,
				80,
			},
			material_values = {},
		},
	},
	{
		pass_type = "text",
		style_id = "title",
		value = "",
		value_id = "title",
		style = item_name_title_style,
	},
	{
		pass_type = "text",
		style_id = "description",
		value = "",
		value_id = "description",
		style = item_name_description_style,
	},
}

return settings("ItemPassTemplates", ItemPassTemplates)
