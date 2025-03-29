-- chunkname: @scripts/ui/view_content_blueprints/item_stats_blueprints.lua

local Action = require("scripts/utilities/action/action")
local DefaultViewInputSettings = require("scripts/settings/input/default_view_input_settings")
local InputDevice = require("scripts/managers/input/input_device")
local Items = require("scripts/utilities/items")
local ProfileUtils = require("scripts/utilities/profile_utils")
local Text = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local WeaponStats = require("scripts/utilities/weapon_stats")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WeaponUIStatsTemplates = require("scripts/settings/equipment/weapon_ui_stats_templates")

local function _generated_icon_visibility(content, style)
	local use_placeholder_texture = content.use_placeholder_texture

	if use_placeholder_texture and use_placeholder_texture == 0 then
		return true
	end

	return false
end

local function _loading_icon_visibility(content, style)
	local use_placeholder_texture = content.use_placeholder_texture

	if not use_placeholder_texture or use_placeholder_texture == 1 then
		return true
	end

	return false
end

local function _loading_icon_change(content, style, _, dt)
	local add = -0.5 * dt

	style.rotation_progress = ((style.rotation_progress or 0) + add) % 1
	style.angle = style.rotation_progress * math.pi * 2
end

local bar_width = 150
local bar_height = 6

local function _scale_stat_value_by_type(value, display_type)
	if display_type == "multiplier" then
		value = (value - 1) * 100
	elseif display_type == "inverse_multiplier" then
		value = (1 - 1 / value) * 100
	elseif display_type == "percentage" then
		value = value * 100
	end

	return value
end

local function _stat_value_to_text(stat, is_int)
	local type_data = stat.type_data
	local value = _scale_stat_value_by_type(stat.value, type_data.display_type)

	if value >= math.huge then
		return Localize("loc_weapon_stats_display_unlimited")
	elseif type_data.signed and value >= 0 then
		if is_int then
			return string.format("+%.0f%s", value, type_data.display_units or "")
		else
			return string.format("+%.2f%s", value, type_data.display_units or "")
		end
	elseif is_int then
		return string.format("%.0f%s", value, type_data.display_units or "")
	else
		return string.format("%.2f%s", value, type_data.display_units or "")
	end
end

local bar_offset = 150 - bar_width
local default_button_content = {
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_select,
}

local function _style_text_height(text, style, ui_renderer)
	local text_font_data = UIFonts.data_by_type(style.font_type)
	local text_font = text_font_data.path
	local text_size = style.size
	local use_max_extents = true
	local text_options = UIFonts.get_font_options_by_style(style)
	local _, text_height = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, text_size, text_options, use_max_extents)

	return text_height
end

local function _style_text_width(text, style, ui_renderer)
	local text_font_data = UIFonts.data_by_type(style.font_type)
	local text_font = text_font_data.path
	local text_size = style.size
	local use_max_extents = true
	local text_options = UIFonts.get_font_options_by_style(style)
	local text_width, _ = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, text_size, text_options, use_max_extents)

	return text_width
end

local function generate_blueprints_function(grid_size, optional_item)
	local grid_width = grid_size[1]
	local equipped_display_name_style = table.clone(UIFontSettings.header_3)

	equipped_display_name_style.font_size = 24
	equipped_display_name_style.offset = {
		0,
		5,
		3,
	}
	equipped_display_name_style.text_horizontal_alignment = "center"
	equipped_display_name_style.text_vertical_alignment = "top"
	equipped_display_name_style.text_color = Color.terminal_text_header(255, true)

	local weapon_display_name_style = table.clone(UIFontSettings.header_3)

	weapon_display_name_style.font_size = 24
	weapon_display_name_style.offset = {
		20,
		35,
		4,
	}
	weapon_display_name_style.size = {
		grid_width - 40,
		500,
	}
	weapon_display_name_style.text_horizontal_alignment = "left"
	weapon_display_name_style.text_vertical_alignment = "top"
	weapon_display_name_style.text_color = Color.terminal_text_header_selected(255, true)

	local weapon_sub_display_name_style = table.clone(UIFontSettings.header_3)

	weapon_sub_display_name_style.offset = {
		20,
		37,
		4,
	}
	weapon_sub_display_name_style.font_size = 20
	weapon_sub_display_name_style.size = {
		grid_width - 40,
		500,
	}
	weapon_sub_display_name_style.text_horizontal_alignment = "left"
	weapon_sub_display_name_style.text_vertical_alignment = "top"
	weapon_sub_display_name_style.text_color = Color.text_default(255, true)

	local item_display_name_style = table.clone(weapon_display_name_style)

	item_display_name_style.offset = {
		20,
		15,
		4,
	}

	local item_sub_display_name_style = table.clone(weapon_sub_display_name_style)

	item_sub_display_name_style.offset = {
		20,
		17,
		4,
	}

	local weapon_rarity_name_style = table.clone(weapon_sub_display_name_style)
	local weapon_keyword_style = table.clone(UIFontSettings.header_3)

	weapon_keyword_style.offset = {
		0,
		-20,
		11,
	}
	weapon_keyword_style.size = {
		grid_width,
		40,
	}
	weapon_keyword_style.font_size = 18
	weapon_keyword_style.text_horizontal_alignment = "center"
	weapon_keyword_style.text_vertical_alignment = "center"
	weapon_keyword_style.text_color = Color.terminal_text_body(255, true)

	local weapon_skin_requirement_header_style = table.clone(UIFontSettings.header_3)

	weapon_skin_requirement_header_style.offset = {
		10,
		0,
		3,
	}
	weapon_skin_requirement_header_style.size = {
		grid_width - 20,
		30,
	}
	weapon_skin_requirement_header_style.font_size = 22
	weapon_skin_requirement_header_style.text_horizontal_alignment = "left"
	weapon_skin_requirement_header_style.text_vertical_alignment = "top"
	weapon_skin_requirement_header_style.text_color = Color.terminal_corner_selected(255, true)

	local weapon_skin_requirement_style = table.clone(UIFontSettings.body)

	weapon_skin_requirement_style.offset = {
		10,
		0,
		3,
	}
	weapon_skin_requirement_style.size = {
		grid_width - 20,
		500,
	}
	weapon_skin_requirement_style.font_size = 20
	weapon_skin_requirement_style.text_horizontal_alignment = "left"
	weapon_skin_requirement_style.text_vertical_alignment = "top"
	weapon_skin_requirement_style.text_color = Color.terminal_text_body(255, true)

	local weapon_stat_text_style = table.clone(UIFontSettings.body)

	weapon_stat_text_style.offset = {
		0,
		0,
		4,
	}
	weapon_stat_text_style.size = {
		160,
		180,
	}
	weapon_stat_text_style.font_size = 18
	weapon_stat_text_style.text_horizontal_alignment = "left"
	weapon_stat_text_style.text_vertical_alignment = "top"
	weapon_stat_text_style.text_color = Color.terminal_text_body(255, true)

	local weapon_value_style = table.clone(UIFontSettings.body)

	weapon_value_style.offset = {
		0,
		0,
		4,
	}
	weapon_value_style.size = {
		200,
		180,
	}
	weapon_value_style.font_size = 28
	weapon_value_style.text_horizontal_alignment = "left"
	weapon_value_style.text_vertical_alignment = "top"
	weapon_value_style.text_color = Color.white(255, true)
	weapon_value_style.material = "content/ui/materials/font_gradients/slug_font_gradient_item_level"

	local gear_stat_text_style = table.clone(UIFontSettings.body)

	gear_stat_text_style.offset = {
		0,
		-42,
		5,
	}
	gear_stat_text_style.font_size = 16
	gear_stat_text_style.size = {
		100,
	}
	gear_stat_text_style.horizontal_alignment = "right"
	gear_stat_text_style.text_horizontal_alignment = "left"
	gear_stat_text_style.text_vertical_alignment = "bottom"
	gear_stat_text_style.text_color = Color.terminal_text_body(255, true)

	local gear_value_style = table.clone(UIFontSettings.body)

	gear_value_style.offset = {
		0,
		-10,
		5,
	}
	gear_value_style.font_size = 28
	gear_value_style.size = {
		100,
	}
	gear_value_style.horizontal_alignment = "right"
	gear_value_style.text_horizontal_alignment = "left"
	gear_value_style.text_vertical_alignment = "bottom"
	gear_value_style.text_color = Color.white(255, true)
	gear_value_style.material = "content/ui/materials/font_gradients/slug_font_gradient_item_level"

	local stamina_value_style = table.clone(UIFontSettings.body)

	stamina_value_style.offset = {
		0,
		0,
		4,
	}
	stamina_value_style.size = {
		150,
	}
	stamina_value_style.font_size = 20
	stamina_value_style.text_horizontal_alignment = "left"
	stamina_value_style.text_vertical_alignment = "top"
	stamina_value_style.text_color = Color.terminal_text_body(255, true)

	local stat_percentage_style = table.clone(UIFontSettings.body)

	stat_percentage_style.offset = {
		0,
		0,
		4,
	}
	stat_percentage_style.size = {
		150,
	}
	stat_percentage_style.font_size = 20
	stat_percentage_style.text_horizontal_alignment = "left"
	stat_percentage_style.text_vertical_alignment = "top"
	stat_percentage_style.text_color = Color.terminal_text_body(255, true)

	local modification_lock_style = table.clone(UIFontSettings.body)

	modification_lock_style.offset = {
		grid_width - 20 - 10,
		0,
		9,
	}
	modification_lock_style.size = {
		20,
		20,
	}
	modification_lock_style.font_size = 20
	modification_lock_style.text_horizontal_alignment = "center"
	modification_lock_style.text_vertical_alignment = "center"
	modification_lock_style.vertical_alignment = "center"
	modification_lock_style.text_color = Color.terminal_corner(255, true)
	modification_lock_style.visible = false

	local modification_modified_style = table.clone(modification_lock_style)

	modification_modified_style.text_color = Color.terminal_icon(255, true)

	local weapon_perk_style = table.clone(UIFontSettings.body)

	weapon_perk_style.offset = {
		55,
		6,
		8,
	}
	weapon_perk_style.size = {
		grid_width - 106 - 40,
		200,
	}
	weapon_perk_style.font_size = 18
	weapon_perk_style.text_horizontal_alignment = "left"
	weapon_perk_style.text_vertical_alignment = "top"
	weapon_perk_style.text_color = Color.terminal_text_body(255, true)

	local gadget_trait_style = table.clone(UIFontSettings.body)

	gadget_trait_style.offset = {
		98,
		0,
		3,
	}
	gadget_trait_style.size = {
		grid_width - 106,
	}
	gadget_trait_style.font_size = 18
	gadget_trait_style.text_horizontal_alignment = "left"
	gadget_trait_style.text_vertical_alignment = "center"
	gadget_trait_style.text_color = Color.terminal_text_header(255, true)

	local weapon_traits_style = table.clone(UIFontSettings.header_3)

	weapon_traits_style.offset = {
		98,
		0,
		8,
	}
	weapon_traits_style.size = {
		grid_width - 106,
	}
	weapon_traits_style.font_size = 18
	weapon_traits_style.text_horizontal_alignment = "left"
	weapon_traits_style.text_vertical_alignment = "top"
	weapon_traits_style.text_color = Color.terminal_text_header(255, true)

	local weapon_traits_description_style = table.clone(UIFontSettings.body)

	weapon_traits_description_style.offset = {
		98,
		20,
		8,
	}
	weapon_traits_description_style.size = {
		grid_width - 126 - 40,
		500,
	}
	weapon_traits_description_style.font_size = 18
	weapon_traits_description_style.text_horizontal_alignment = "left"
	weapon_traits_description_style.text_vertical_alignment = "top"
	weapon_traits_description_style.text_color = Color.terminal_text_body(255, true)

	local description_style = table.clone(UIFontSettings.body)

	description_style.offset = {
		20,
		0,
		3,
	}
	description_style.size = {
		grid_width - 40,
		500,
	}
	description_style.font_size = 18
	description_style.line_spacing = 1.4
	description_style.text_horizontal_alignment = "center"
	description_style.text_vertical_alignment = "top"
	description_style.text_color = Color.terminal_text_body_sub_header(255, true)

	local obtained_label_style = table.clone(UIFontSettings.body)

	obtained_label_style.offset = {
		20,
		4,
		4,
	}
	obtained_label_style.size = {
		grid_width - 40,
		500,
	}
	obtained_label_style.font_size = 18
	obtained_label_style.text_horizontal_alignment = "left"
	obtained_label_style.text_vertical_alignment = "top"
	obtained_label_style.text_color = Color.terminal_text_header(255, true)

	local obtained_header_style = table.clone(UIFontSettings.header_3)

	obtained_header_style.offset = {
		20,
		0,
		4,
	}
	obtained_header_style.size = {
		grid_width - 40,
		500,
	}
	obtained_header_style.font_size = 20
	obtained_header_style.text_horizontal_alignment = "left"
	obtained_header_style.text_vertical_alignment = "top"
	obtained_header_style.text_color = Color.terminal_text_body_sub_header(255, true)

	local achievement_description_style = table.clone(UIFontSettings.body)

	achievement_description_style.offset = {
		20,
		0,
		3,
	}
	achievement_description_style.size = {
		grid_width - 40,
		500,
	}
	achievement_description_style.font_size = 18
	achievement_description_style.line_spacing = 1.4
	achievement_description_style.text_horizontal_alignment = "left"
	achievement_description_style.text_vertical_alignment = "top"
	achievement_description_style.text_color = Color.terminal_text_body(255, true)

	local weapon_attack_info_style = table.clone(UIFontSettings.body)

	weapon_attack_info_style.offset = {
		52,
		0,
		4,
	}
	weapon_attack_info_style.size = {
		grid_width - 62,
	}
	weapon_attack_info_style.font_size = 20
	weapon_attack_info_style.text_horizontal_alignment = "left"
	weapon_attack_info_style.text_vertical_alignment = "center"
	weapon_attack_info_style.text_color = Color.terminal_text_body(255, true)

	local weapon_attack_header_style = table.clone(UIFontSettings.body)

	weapon_attack_header_style.offset = {
		10,
		0,
		4,
	}
	weapon_attack_header_style.size = {
		grid_width - 20,
	}
	weapon_attack_header_style.font_size = 18
	weapon_attack_header_style.text_horizontal_alignment = "left"
	weapon_attack_header_style.text_vertical_alignment = "center"
	weapon_attack_header_style.text_color = Color.terminal_text_header(255, true)

	local weapon_action_value_style = table.clone(UIFontSettings.body)

	weapon_action_value_style.offset = {
		0,
		0,
		4,
	}
	weapon_action_value_style.size = {
		200,
		240,
	}
	weapon_action_value_style.font_size = 22
	weapon_action_value_style.text_horizontal_alignment = "right"
	weapon_action_value_style.text_vertical_alignment = "bottom"
	weapon_action_value_style.text_color = Color.white(255, true)
	weapon_action_value_style.material = "content/ui/materials/font_gradients/slug_font_gradient_item_level"

	local rating_info_style = table.clone(UIFontSettings.header_3)

	rating_info_style.offset = {
		-25,
		10,
		5,
	}
	rating_info_style.size = {
		grid_width,
		40,
	}
	rating_info_style.font_size = 18
	rating_info_style.text_horizontal_alignment = "right"
	rating_info_style.text_vertical_alignment = "top"
	rating_info_style.text_color = Color.terminal_text_body(255, true)

	local rating_header_style = table.clone(UIFontSettings.header_3)

	rating_header_style.offset = {
		20,
		10,
		5,
	}
	rating_header_style.size = {
		grid_width,
		40,
	}
	rating_header_style.font_size = 18
	rating_header_style.text_horizontal_alignment = "left"
	rating_header_style.text_vertical_alignment = "top"
	rating_header_style.text_color = Color.terminal_text_body_sub_header(255, true)

	local special_description_style = table.clone(UIFontSettings.body)

	special_description_style.offset = {
		10,
		10,
		3,
	}
	special_description_style.size = {
		grid_width - 20,
		500,
	}
	special_description_style.font_size = 16
	special_description_style.text_horizontal_alignment = "left"
	special_description_style.text_vertical_alignment = "top"
	special_description_style.text_color = Color.terminal_text_body_dark(255, true)

	local weapon_display_name_header_style = table.clone(UIFontSettings.header_2)

	weapon_display_name_header_style.size = {
		grid_width - 20,
		50,
	}
	weapon_display_name_header_style.offset = {
		10,
		0,
		3,
	}
	weapon_display_name_header_style.font_size = 35
	weapon_display_name_header_style.text_horizontal_alignment = "left"
	weapon_display_name_header_style.text_vertical_alignment = "center"
	weapon_display_name_header_style.text_color = Color.white(255, true)
	weapon_display_name_header_style.material = "content/ui/materials/font_gradients/slug_font_gradient_item_level"

	local weapon_attack_type_desc_style = table.clone(UIFontSettings.body)

	weapon_attack_type_desc_style.offset = {
		10,
		10,
		3,
	}
	weapon_attack_type_desc_style.size = {
		grid_width - 80,
		500,
	}
	weapon_attack_type_desc_style.font_size = 16
	weapon_attack_type_desc_style.text_horizontal_alignment = "center"
	weapon_attack_type_desc_style.text_vertical_alignment = "top"
	weapon_attack_type_desc_style.text_color = Color.terminal_text_body_dark(0, true)

	local weapon_attack_type_display_name_header_style = table.clone(UIFontSettings.header_2)

	weapon_attack_type_display_name_header_style.size = {
		grid_width - 20,
		50,
	}
	weapon_attack_type_display_name_header_style.offset = {
		10,
		0,
		3,
	}
	weapon_attack_type_display_name_header_style.font_size = 40
	weapon_attack_type_display_name_header_style.text_horizontal_alignment = "left"
	weapon_attack_type_display_name_header_style.text_vertical_alignment = "center"
	weapon_attack_type_display_name_header_style.text_color = Color.white(255, true)

	local weapon_rarity_header_style = table.clone(UIFontSettings.header_2)

	weapon_rarity_header_style.size = {
		grid_width - 20,
	}
	weapon_rarity_header_style.offset = {
		10,
		40,
		3,
	}
	weapon_rarity_header_style.font_size = 30
	weapon_rarity_header_style.text_horizontal_alignment = "left"
	weapon_rarity_header_style.text_vertical_alignment = "center"
	weapon_rarity_header_style.text_color = Color.terminal_text_header(255, true)

	local rating_icon_style = table.clone(UIFontSettings.body)

	rating_icon_style.offset = {
		0,
		0,
		3,
	}
	rating_icon_style.font_size = 80
	rating_icon_style.text_horizontal_alignment = "left"
	rating_icon_style.text_vertical_alignment = "top"
	rating_icon_style.text_color = Color.white(255, true)
	rating_icon_style.material = "content/ui/materials/font_gradients/slug_font_gradient_item_level"

	local rating_value_style = table.clone(UIFontSettings.body)

	rating_value_style.offset = {
		0,
		0,
		3,
	}
	rating_value_style.font_size = 60
	rating_value_style.text_horizontal_alignment = "left"
	rating_value_style.text_vertical_alignment = "top"
	rating_value_style.text_color = Color.white(255, true)

	local weapon_keyword_expanded_header_style = table.clone(UIFontSettings.header_3)

	weapon_keyword_expanded_header_style.offset = {
		0,
		0,
		3,
	}
	weapon_keyword_expanded_header_style.font_size = 25
	weapon_keyword_expanded_header_style.text_horizontal_alignment = "left"
	weapon_keyword_expanded_header_style.text_vertical_alignment = "top"
	weapon_keyword_expanded_header_style.text_color = Color.white(255, true)
	weapon_keyword_expanded_header_style.material = "content/ui/materials/font_gradients/slug_font_gradient_item_level"

	local weapon_keyword_desc_style = table.clone(UIFontSettings.body)

	weapon_keyword_desc_style.size = {
		grid_width * 0.5 - 10,
		400,
	}
	weapon_keyword_desc_style.offset = {
		0,
		0,
		3,
	}
	weapon_keyword_desc_style.font_size = 16
	weapon_keyword_desc_style.text_horizontal_alignment = "left"
	weapon_keyword_desc_style.text_vertical_alignment = "top"
	weapon_keyword_desc_style.text_color = Color.terminal_text_header(255, true)

	local weapon_description_desc_style = table.clone(UIFontSettings.body)

	weapon_description_desc_style.size = {
		grid_width - 10,
		400,
	}
	weapon_description_desc_style.offset = {
		0,
		80,
		3,
	}
	weapon_description_desc_style.font_size = 18
	weapon_description_desc_style.text_horizontal_alignment = "left"
	weapon_description_desc_style.text_vertical_alignment = "top"
	weapon_description_desc_style.text_color = Color.terminal_text_header(255, true)

	local damage_grid_x_header_style = table.clone(UIFontSettings.body)

	damage_grid_x_header_style.offset = {
		0,
		0,
		3,
	}
	damage_grid_x_header_style.size = {
		150,
	}
	damage_grid_x_header_style.font_size = 18
	damage_grid_x_header_style.horizontal_alignment = "right"
	damage_grid_x_header_style.vertical_alignment = "bottom"
	damage_grid_x_header_style.text_horizontal_alignment = "center"
	damage_grid_x_header_style.text_vertical_alignment = "top"
	damage_grid_x_header_style.text_color = Color.terminal_text_body_dark(255, true)
	damage_grid_x_header_style.base_text_color = Color.terminal_text_body_dark(255, true)
	damage_grid_x_header_style.selected_text_color = Color.terminal_corner_selected(255, true)

	local damage_grid_y_header_style = table.clone(UIFontSettings.body)

	damage_grid_y_header_style.offset = {
		0,
		0,
		3,
	}
	damage_grid_y_header_style.size = {
		500,
	}
	damage_grid_y_header_style.font_size = 18
	damage_grid_y_header_style.horizontal_alignment = "right"
	damage_grid_y_header_style.vertical_alignment = "top"
	damage_grid_y_header_style.text_horizontal_alignment = "right"
	damage_grid_y_header_style.text_vertical_alignment = "top"
	damage_grid_y_header_style.text_color = Color.terminal_text_body_dark(255, true)
	damage_grid_y_header_style.base_text_color = Color.terminal_text_body_dark(255, true)
	damage_grid_y_header_style.selected_text_color = Color.terminal_corner_selected(255, true)

	local damage_stat_style = table.clone(UIFontSettings.header_2)

	damage_stat_style.offset = {
		0,
		5,
		3,
	}
	damage_stat_style.size = {
		150,
	}
	damage_stat_style.font_size = 20
	damage_stat_style.horizontal_alignment = "right"
	damage_stat_style.vertical_alignment = "top"
	damage_stat_style.text_horizontal_alignment = "center"
	damage_stat_style.text_vertical_alignment = "top"
	damage_stat_style.text_color = Color.white(255, true)

	local damage_legend_style = table.clone(UIFontSettings.header_2)

	damage_legend_style.offset = {
		0,
		0,
		3,
	}
	damage_legend_style.size = {
		600,
	}
	damage_legend_style.font_size = 18
	damage_legend_style.horizontal_alignment = "right"
	damage_legend_style.vertical_alignment = "top"
	damage_legend_style.text_horizontal_alignment = "right"
	damage_legend_style.text_vertical_alignment = "top"
	damage_legend_style.text_color = Color.white(255, true)

	local function _generate_background_pass()
		return {
			pass_type = "rect",
			style_id = "background",
			style = {
				visible = false,
				offset = {
					0,
					0,
					0,
				},
				color = Color.terminal_frame(50, true),
			},
		}
	end

	local function _generate_damage_grid_pass_templates(pass_grid_size, item)
		local pass_templates = {}

		if not item then
			return pass_templates
		end

		local weapon_template = WeaponTemplate.weapon_template_from_item(item)

		if not weapon_template then
			return pass_templates
		end

		local weapon_stats = WeaponStats:new(item)
		local advanced_weapon_stats = weapon_stats._weapon_statistics
		local x_axis_headers = advanced_weapon_stats.hit_types
		local y_axis_headers = {}
		local attack_index = 1
		local chain_index = 1
		local damage_stats = advanced_weapon_stats.damage

		if not damage_stats then
			return
		end

		local chain_data = damage_stats[attack_index]
		local attack_data = chain_data[chain_index] or chain_data
		local attack_type_data = attack_data.type_data
		local attack_damage = attack_data.attack
		local impact_damage = attack_data.impact
		local attack_data_def = attack_type_data.attack

		for ii = 1, #attack_data_def, 3 do
			y_axis_headers[#y_axis_headers + 1] = {
				name = attack_data_def[ii],
				display_name = UISettings.weapon_stats_armor_types[attack_data_def[ii]],
			}
		end

		local num_x_axis_headers = #x_axis_headers
		local num_y_axis_headers = #y_axis_headers

		for jj = 1, num_y_axis_headers do
			for ii = #x_axis_headers, 1, -1 do
				local index = (jj - 1) * num_x_axis_headers + (num_x_axis_headers - (ii - 1))
				local damage = math.floor(attack_damage[index] + 0.5)
				local impact = math.floor(impact_damage[index] + 0.5)

				pass_templates[#pass_templates + 1] = {
					pass_type = "texture",
					value = "content/ui/materials/frames/frame_tile_1px",
					style_id = "hover_frame_border_" .. ii .. "_" .. jj,
					style = {
						horizontal_alignment = "right",
						scale_to_material = true,
						vertical_alignment = "top",
						offset = {
							-20 - pass_grid_size[1] * (ii - 1),
							25 + pass_grid_size[2] * (jj - 1),
							1,
						},
						size = pass_grid_size,
						color = Color.terminal_text_body(255, true),
						base_color = Color.terminal_text_body(60, true),
						selected_color = Color.terminal_corner_selected(128, 0),
					},
				}
				pass_templates[#pass_templates + 1] = {
					pass_type = "texture",
					value = "content/ui/materials/frames/frame_corner_2px",
					style_id = "hover_frame_corner_" .. ii .. "_" .. jj,
					style = {
						horizontal_alignment = "right",
						scale_to_material = true,
						vertical_alignment = "top",
						offset = {
							-20 - pass_grid_size[1] * (ii - 1),
							25 + pass_grid_size[2] * (jj - 1),
							2,
						},
						size = pass_grid_size,
						color = Color.terminal_text_body(255, true),
						base_color = Color.terminal_text_body(60, true),
						selected_color = Color.terminal_corner_selected(128, 0),
					},
				}
				pass_templates[#pass_templates + 1] = {
					pass_type = "texture",
					value = "content/ui/materials/gradients/gradient_vertical",
					style_id = "hover_bg_" .. ii .. "_" .. jj,
					style = {
						horizontal_alignment = "right",
						scale_to_material = true,
						vertical_alignment = "top",
						offset = {
							-20 - pass_grid_size[1] * (ii - 1),
							25 + pass_grid_size[2] * (jj - 1),
							2,
						},
						size = pass_grid_size,
						color = Color.terminal_corner_selected(0, 0),
					},
				}
				pass_templates[#pass_templates + 1] = {
					pass_type = "hotspot",
					content_id = "hotspot_" .. (ii - 1) * num_y_axis_headers + jj,
					content = table.merge(table.clone(default_button_content), {
						x = ii,
						y = jj,
					}),
					style = {
						horizontal_alignment = "right",
						vertical_alignment = "top",
						offset = {
							-20 - pass_grid_size[1] * (ii - 1),
							25 + pass_grid_size[2] * (jj - 1),
							2,
						},
						size = pass_grid_size,
						color = {
							255,
							math.random(255),
							math.random(255),
							math.random(255),
						},
					},
				}
				pass_templates[#pass_templates + 1] = {
					pass_type = "text",
					style_id = "damage_stat_" .. ii .. "_" .. jj,
					value_id = "damage_stat_" .. ii .. "_" .. jj,
					value = "{#color(171,91,81)}" .. damage .. "  {#color(95,152,180)}" .. impact,
					style = table.merge_recursive(table.clone(damage_stat_style), {
						offset = {
							-15 - pass_grid_size[1] * (ii - 1),
							damage_stat_style.font_size * 0.5 + pass_grid_size[2] * 0.5 + pass_grid_size[2] * (jj - 1),
							2,
						},
					}),
				}
			end
		end

		for ii = 1, num_x_axis_headers do
			local header = x_axis_headers[num_x_axis_headers - (ii - 1)]

			pass_templates[#pass_templates + 1] = {
				pass_type = "text",
				style_id = "x_axis_header_" .. ii,
				value_id = "x_axis_header_" .. ii,
				value = Localize(header.display_name),
				style = table.merge_recursive(table.clone(damage_grid_x_header_style), {
					offset = {
						-15 - pass_grid_size[1] * (ii - 1),
						-5,
						3,
					},
				}),
			}
		end

		for ii = num_y_axis_headers, 1, -1 do
			local header = y_axis_headers[ii]

			pass_templates[#pass_templates + 1] = {
				pass_type = "text",
				style_id = "y_axis_header_" .. ii,
				value_id = "y_axis_header_" .. ii,
				value = Localize(header.display_name),
				style = table.merge_recursive(table.clone(damage_grid_y_header_style), {
					offset = {
						-pass_grid_size[1] * num_x_axis_headers - 30,
						45 + pass_grid_size[2] * (ii - 1),
						3,
					},
				}),
			}
		end

		pass_templates[#pass_templates + 1] = {
			pass_type = "text",
			style_id = "legend",
			value_id = "legend",
			value = "{#color(171,91,81)} " .. Localize("loc_stats_display_damage_stat") .. "  {#color(95,152,180)} " .. Localize("loc_stagger"),
			style = table.merge_recursive(table.clone(damage_legend_style), {
				offset = {
					-20,
					pass_grid_size[2] * num_y_axis_headers + 35,
					2,
				},
			}),
		}
		pass_templates[#pass_templates + 1] = {
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/line_thin_detailed_01",
			style = {
				horizontal_alignment = "right",
				scale_to_material = true,
				vertical_alignment = "top",
				offset = {
					-15,
					20,
					2,
				},
				size = {
					pass_grid_size[1] * num_x_axis_headers + 10,
					pass_grid_size[2] * num_y_axis_headers + 10,
				},
				color = Color.terminal_text_body(60, true),
			},
		}

		return pass_templates
	end

	local function _update_damage_data(damage_stats, widget, attack_index, chain_index)
		local content = widget.content

		if attack_index == content.current_attack_index and chain_index == content.current_chain_index then
			return
		end

		local weapon_stats = content.weapon_stats
		local advanced_weapon_stats = weapon_stats._weapon_statistics
		local num_columns = #advanced_weapon_stats.hit_types
		local no_data = false
		local attack_data = damage_stats[attack_index]

		if not attack_data or table.is_empty(attack_data) then
			attack_data = damage_stats[1][1]
			no_data = true
			content.current_attack_index = attack_index
			content.current_chain_index = chain_index
			widget.visible = false

			return
		end

		attack_data = attack_data[chain_index] or chain_index == 1 and attack_data

		if not attack_data or table.is_empty(attack_data) then
			attack_data = damage_stats[1][1]
			no_data = true
			content.current_attack_index = attack_index
			content.current_chain_index = chain_index
			widget.visible = false

			return
		end

		widget.visible = true

		local attack_type_data = attack_data.type_data
		local attack_damage = attack_data.attack
		local impact_damage = attack_data.impact
		local num_rows = #attack_type_data.attack / 3

		for j = 1, num_rows do
			for i = num_columns, 1, -1 do
				if no_data then
					content["damage_stat_" .. i .. "_" .. j] = "{#color(171,91,81)}-  {#color(95,152,180)}-"
				else
					local index = (j - 1) * num_columns + (num_columns - (i - 1))
					local damage = math.floor(attack_damage[index] + 0.5)
					local impact = math.floor(impact_damage[index] + 0.5)

					content["damage_stat_" .. i .. "_" .. j] = "{#color(171,91,81)} " .. damage .. "  {#color(95,152,180)} " .. impact
				end
			end
		end

		content.current_attack_index = attack_index
		content.current_chain_index = chain_index
	end

	local function _generate_attack_pattern_passes(item)
		local pass_templates = {}

		if not item then
			return pass_templates
		end

		local weapon_template = WeaponTemplate.weapon_template_from_item(item)

		if not weapon_template then
			return pass_templates
		end

		pass_templates = {
			{
				pass_type = "text",
				value_id = "header",
				style = table.merge_recursive(table.clone(weapon_display_name_header_style), {
					text_horizontal_alignment = "center",
					text_vertical_alignment = "top",
					offset = {
						0,
						0,
						1,
					},
				}),
				value = Localize("loc_weapon_stats_attack_pattern"),
			},
			{
				pass_type = "texture",
				style_id = "rating_divider",
				value = "content/ui/materials/dividers/divider_line_01",
				value_id = "rating_divider",
				style = {
					horizontal_alignemt = "center",
					vertical_alignment = "top",
					size = {
						grid_width - 50,
						2,
					},
					offset = {
						25,
						50,
						3,
					},
					color = Color.terminal_frame(128, true),
				},
			},
			{
				pass_type = "text",
				style_id = "header_1",
				value = "N/A",
				value_id = "header_1",
				style = table.merge_recursive(table.clone(weapon_display_name_header_style), {
					font_size = 20,
					text_horizontal_alignment = "center",
					text_vertical_alignment = "top",
					text_color = {
						0,
						255,
						255,
						255,
					},
					offset = {
						0,
						80,
						0,
					},
				}),
			},
			{
				pass_type = "text",
				style_id = "header_2",
				value = "N/A",
				value_id = "header_2",
				style = table.merge_recursive(table.clone(weapon_display_name_header_style), {
					font_size = 20,
					text_horizontal_alignment = "center",
					text_vertical_alignment = "top",
					text_color = {
						0,
						255,
						255,
						255,
					},
					offset = {
						0,
						80,
						0,
					},
				}),
			},
			{
				pass_type = "text",
				style_id = "header_3",
				value = "N/A",
				value_id = "header_3",
				style = table.merge_recursive(table.clone(weapon_display_name_header_style), {
					font_size = 20,
					text_horizontal_alignment = "center",
					text_vertical_alignment = "top",
					text_color = {
						0,
						255,
						255,
						255,
					},
					offset = {
						0,
						80,
						0,
					},
				}),
			},
			{
				pass_type = "text",
				style_id = "header_4",
				value = "N/A",
				value_id = "header_4",
				style = table.merge_recursive(table.clone(weapon_display_name_header_style), {
					font_size = 20,
					text_horizontal_alignment = "center",
					text_vertical_alignment = "top",
					text_color = {
						0,
						255,
						255,
						255,
					},
					offset = {
						0,
						80,
						0,
					},
				}),
			},
			{
				pass_type = "texture",
				style_id = "divider_1",
				value = "content/ui/materials/dividers/divider_line_01",
				value_id = "divider_1",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					size = {
						100,
						2,
					},
					offset = {
						0,
						105,
						3,
					},
					color = Color.terminal_frame(0, true),
				},
			},
			{
				pass_type = "texture",
				style_id = "divider_2",
				value = "content/ui/materials/dividers/divider_line_01",
				value_id = "divider_2",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					size = {
						100,
						2,
					},
					offset = {
						0,
						105,
						3,
					},
					color = Color.terminal_frame(0, true),
				},
			},
			{
				pass_type = "texture",
				style_id = "divider_3",
				value = "content/ui/materials/dividers/divider_line_01",
				value_id = "divider_3",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					size = {
						100,
						2,
					},
					offset = {
						0,
						105,
						3,
					},
					color = Color.terminal_frame(0, true),
				},
			},
			{
				pass_type = "texture",
				style_id = "divider_4",
				value = "content/ui/materials/dividers/divider_line_01",
				value_id = "divider_4",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					size = {
						100,
						2,
					},
					offset = {
						0,
						105,
						3,
					},
					color = Color.terminal_frame(0, true),
				},
			},
			{
				pass_type = "rect",
				style_id = "top_line",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					size = {
						2,
						25,
					},
					offset = {
						-16,
						160,
						0,
					},
					color = Color.terminal_frame(255, true),
				},
			},
			{
				pass_type = "rect",
				style_id = "horizontal_line",
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "top",
					size = {
						100,
						2,
					},
					offset = {
						0,
						185,
						0,
					},
					color = Color.terminal_frame(255, true),
				},
			},
			{
				pass_type = "rect",
				style_id = "bottom_line",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					size = {
						2,
						25,
					},
					offset = {
						-16,
						185,
						0,
					},
					color = Color.terminal_frame(255, true),
				},
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
						-16,
						111,
						1,
					},
					size = {
						50,
						50,
					},
					color = Color.terminal_corner_selected(128, 0),
				},
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
						-16,
						111,
						2,
					},
					size = {
						50,
						50,
					},
					color = Color.terminal_corner_selected(128, 0),
				},
			},
			{
				pass_type = "texture",
				style_id = "hover_bg",
				value = "content/ui/materials/gradients/gradient_vertical",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "top",
					offset = {
						-16,
						111,
						2,
					},
					size = {
						50,
						50,
					},
					color = Color.terminal_corner_selected(60, 0),
				},
			},
		}

		local displayed_attacks = weapon_template.displayed_attacks

		if displayed_attacks then
			local is_ranged_weapon = Items.is_weapon_template_ranged(item)
			local weapon_action_title_display_names = is_ranged_weapon and UISettings.weapon_action_title_display_names or UISettings.weapon_action_title_display_names_melee
			local weapon_action_display_order_array = UISettings.weapon_action_display_order_array
			local num_elements = 0

			for index, key in ipairs(weapon_action_display_order_array) do
				local data = displayed_attacks[key]

				if data then
					num_elements = num_elements + 1
				end
			end

			local width = num_elements < 4 and grid_width - 100 or grid_width
			local step = width / num_elements
			local offset_index = 1

			for index, key in ipairs(weapon_action_display_order_array) do
				local data = displayed_attacks[key]

				if data then
					local base_offset = -step * (num_elements - 1) * 0.5 + (offset_index - 1) * step
					local attack_chain = data.attack_chain

					if attack_chain then
						local num_attack_chains = #attack_chain

						for ii = 1, num_attack_chains do
							local pattern_width = 50 * num_attack_chains
							local icon_step = pattern_width / num_attack_chains
							local offset_x = base_offset + -icon_step * (num_attack_chains - 1) * 0.5 + (ii - 1) * icon_step
							local attack_type = attack_chain[ii]
							local icon = UISettings.weapon_action_type_icons[attack_type] or "content/ui/materials/icons/traits/empty"

							pass_templates[#pass_templates + 1] = {
								pass_type = "texture",
								value_id = "icon_" .. index .. "_" .. ii,
								style_id = "icon_" .. index .. "_" .. ii,
								value = icon,
								style = {
									horizontal_alignment = "center",
									vertical_alignment = "top",
									size = {
										32,
										32,
									},
									offset = {
										-16 + offset_x,
										120,
										1,
									},
									color = Color.terminal_text_body(255, true),
									selected_color = Color.white(255, true),
									base_color = Color.terminal_text_body(255, true),
								},
								change_function = function (content, style, animations, dt)
									local hotspot = content["icon_hotspot_" .. index .. "_" .. ii]

									style.color = (hotspot.is_hover or hotspot.is_selected) and style.selected_color or style.base_color
								end,
							}
							pass_templates[#pass_templates + 1] = {
								pass_type = "hotspot",
								style_id = "icon_hotspot_" .. index .. "_" .. ii,
								content_id = "icon_hotspot_" .. index .. "_" .. ii,
								content = default_button_content,
								style = {
									horizontal_alignment = "center",
									vertical_alignment = "top",
									offset = {
										-16 + offset_x,
										120,
										1,
									},
									size = {
										32,
										32,
									},
								},
							}
						end
					else
						local attack_type = data.type
						local icon = UISettings.weapon_action_type_icons[attack_type] or "content/ui/materials/icons/traits/empty"

						pass_templates[#pass_templates + 1] = {
							pass_type = "texture",
							value_id = "icon_" .. index .. "_1",
							style_id = "icon_" .. index .. "_1",
							value = icon,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									32,
									32,
								},
								offset = {
									-16 + base_offset,
									120,
									1,
								},
								color = Color.terminal_text_body(255, true),
								selected_color = Color.white(255, true),
								base_color = Color.terminal_text_body(255, true),
							},
							change_function = function (content, style, animations, dt)
								local hotspot = content["icon_hotspot_" .. index .. "_1"]

								style.color = (hotspot.is_hover or hotspot.is_selected) and style.selected_color or style.base_color
							end,
						}
						pass_templates[#pass_templates + 1] = {
							pass_type = "hotspot",
							style_id = "icon_hotspot_" .. index .. "_1",
							content_id = "icon_hotspot_" .. index .. "_1",
							content = default_button_content,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									-16 + base_offset,
									120,
									1,
								},
								size = {
									32,
									32,
								},
							},
						}
					end

					offset_index = offset_index + 1
				end
			end
		end

		return pass_templates
	end

	local function _update_pattern_type(widget, parent, ui_renderer)
		local content = widget.content
		local style = widget.style
		local attack_index, chain_index = 1, 1

		if parent.current_attack_index then
			attack_index, chain_index = parent:current_attack_index()
		end

		if content.current_attack_index == attack_index and content.current_chain_index == chain_index then
			return
		end

		local spacing = 5
		local item = content.item
		local weapon_template = WeaponTemplate.weapon_template_from_item(item)
		local displayed_attacks = weapon_template.displayed_attacks
		local min_desc_size = 20
		local desc_size = 0

		if displayed_attacks then
			local statistics_template = weapon_template.displayed_weapon_stats and WeaponUIStatsTemplates[weapon_template.displayed_weapon_stats] or weapon_template.displayed_weapon_stats_table
			local damage_actions = statistics_template.damage
			local action_table = damage_actions[attack_index]
			local action_name = action_table and action_table[chain_index] and action_table[chain_index].action_name
			local action = action_name and weapon_template.actions[action_name]
			local explosion_template = action and Action.explosion_template(action)

			content.extra_information = explosion_template and Localize("loc_weapon_stats_display_explosions_vary") or ""

			local is_ranged_weapon = Items.is_weapon_template_ranged(item)
			local weapon_action_title_display_names = is_ranged_weapon and UISettings.weapon_action_title_display_names or UISettings.weapon_action_title_display_names_melee
			local weapon_action_display_order_array = UISettings.weapon_action_display_order_array
			local key = weapon_action_display_order_array[attack_index]
			local data = displayed_attacks[key]

			if data then
				local attack_type = data.attack_chain and data.attack_chain[chain_index] or data.type

				if attack_type then
					local attack_type_icon = UISettings.weapon_action_type_icons[attack_type]
					local display_name = UISettings.attack_type_lookup[attack_type]

					display_name = display_name or data.display_name
					display_name = Localize(display_name)

					local desc_id = UISettings.attack_type_desc_lookup[attack_type] or data.desc
					local desc = desc_id and Localize(desc_id) or ""

					if desc ~= "" then
						local desc_style = style.extra_information
						local text_options = UIFonts.get_font_options_by_style(desc_style)
						local text_size = {
							desc_style.size[1],
							2000,
						}
						local _, text_height = UIRenderer.text_size(ui_renderer, desc, desc_style.font_type, desc_style.font_size, text_size, text_options)

						desc_size = math.max(min_desc_size, text_height) - min_desc_size
					end

					content.attack_type_icon = attack_type_icon
					content.attack_type_name = display_name
					content.attack_type_desc = desc

					local attack_type_icon_style = style.attack_type_icon
					local attack_type_name_style = style.attack_type_name
					local attack_type_desc_style = style.attack_type_desc
					local text_width = _style_text_width(display_name, attack_type_name_style, ui_renderer)

					attack_type_name_style.text_color[1] = 255
					attack_type_desc_style.text_color[1] = 255
					attack_type_icon_style.offset[1] = -text_width * 0.5 - attack_type_icon_style.size[1] - spacing
				end
			end
		end

		content.current_attack_index = attack_index
		content.current_chain_index = chain_index

		local original_offset = 115
		local original_bottom_size = 160
		local original_top_size = 150

		style.tile_top.size[2] = original_top_size + desc_size
		style.corner_top.size[2] = original_top_size + desc_size
		style.tile_bottom.offset[2] = original_offset + desc_size
		style.corner_bottom.offset[2] = original_offset + desc_size
		style.detailed_bottom.size[2] = original_bottom_size + desc_size
	end

	local function _update_connection_line(old_attack_index, old_chain_index, new_attack_index, new_chain_index, content, style)
		content["icon_hotspot_" .. old_attack_index .. "_" .. old_chain_index].is_selected = false

		local hotspot_offset = style["icon_hotspot_" .. new_attack_index .. "_" .. new_chain_index].offset[1]

		style.top_line.offset[1] = hotspot_offset
		style.hover_frame_border.offset[1] = hotspot_offset
		style.hover_frame_corner.offset[1] = hotspot_offset
		style.hover_bg.offset[1] = hotspot_offset

		if hotspot_offset < -16 then
			style.horizontal_line.offset[1] = grid_width * 0.5 + hotspot_offset - 1
			style.horizontal_line.size[1] = math.abs(hotspot_offset) - 16
		else
			style.horizontal_line.offset[1] = grid_width * 0.5 - 16
			style.horizontal_line.size[1] = math.abs(hotspot_offset + 16) + 1
		end
	end

	local function _generate_weapon_attack_action_passes(action_pass_optional_item)
		local pass_templates = {
			_generate_background_pass(),
		}

		if not action_pass_optional_item then
			return pass_templates
		end

		local weapon_template = WeaponTemplate.weapon_template_from_item(action_pass_optional_item)

		if not weapon_template then
			return pass_templates
		end

		local weapon_card_data = weapon_template.weapon_card_data

		if not weapon_card_data then
			return pass_templates
		end

		local weapon_stats = WeaponStats:new(action_pass_optional_item)
		local main_card_data = weapon_card_data.main
		local num_entries = #main_card_data
		local width = num_entries < 4 and grid_width - 100 or grid_width
		local step = width / num_entries

		for ii = 1, num_entries do
			local data_entry = main_card_data[ii]
			local header_key = data_entry.header
			local icon_key = data_entry.icon
			local sub_icon_key = data_entry.sub_icon
			local value_func_key = data_entry.value_func
			local header = header_key and Localize(UISettings.weapon_card_headers[header_key]) or "n/a"
			local icon = icon_key and UISettings.weapon_card_icons[icon_key]
			local sub_icon = sub_icon_key and UISettings.weapon_card_icons[sub_icon_key]
			local value_func = value_func_key and UISettings.weapon_card_value_funcs[value_func_key]
			local value = value_func and value_func(weapon_stats) or data_entry.value or "n/a"
			local has_icon = icon ~= nil
			local has_sub_icon = sub_icon ~= nil

			pass_templates[#pass_templates + 1] = {
				pass_type = "texture",
				value = icon,
				style_id = "attack_icon_" .. ii,
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					offset = {
						-step * (num_entries - 1) * 0.5 + (ii - 1) * step,
						23 + (has_sub_icon and -4.5 or 0),
						50,
					},
					size = {
						20,
						20,
					},
					color = Color.terminal_icon(255, true),
					visible = has_icon,
				},
			}
			pass_templates[#pass_templates + 1] = {
				pass_type = "texture",
				value = sub_icon,
				value_id = "fire_mode_icon_" .. ii,
				style_id = "fire_mode_icon_" .. ii,
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					size = {
						20,
						8,
					},
					offset = {
						-step * (num_entries - 1) * 0.5 + (ii - 1) * step,
						40.5,
						50,
					},
					color = Color.terminal_icon(255, true),
					visible = has_sub_icon,
				},
			}
			pass_templates[#pass_templates + 1] = {
				pass_type = "text",
				value = header,
				value_id = "attack_header_" .. ii,
				style_id = "attack_header_" .. ii,
				style = table.merge_recursive(table.clone(weapon_stat_text_style), {
					horizontal_alignment = "center",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "top",
					vertical_alignment = "top",
					offset = {
						-step * (num_entries - 1) * 0.5 + (ii - 1) * step,
						0,
						50,
					},
					text_color = Color.terminal_text_body_sub_header(255, true),
				}),
			}
			pass_templates[#pass_templates + 1] = {
				pass_type = "text",
				value = value,
				value_id = "attack_value_" .. ii,
				style_id = "attack_value_" .. ii,
				style = table.merge_recursive(table.clone(weapon_action_value_style), {
					horizontal_alignment = "center",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "top",
					vertical_alignment = "top",
					offset = {
						-step * (num_entries - 1) * 0.5 + (ii - 1) * step,
						20,
						50,
					},
					text_color = Color.white(255, true),
				}),
			}
		end

		return pass_templates
	end

	local function _generate_weapon_stats_passes(action_pass_optional_item)
		local pass_templates = {
			_generate_background_pass(),
		}

		for ii = 1, 5 do
			local base_offset_x = 20 * ((ii - 1) % 3) + 150 * ((ii - 1) % 3)
			local base_offset_y = 65 * ((ii - 1) % 2)
			local bar_offset_y = 24

			pass_templates[#pass_templates + 1] = {
				pass_type = "text",
				value = "n/a",
				style_id = string.format("text_%i", ii),
				value_id = string.format("text_%i", ii),
				style = table.merge_recursive(table.clone(weapon_stat_text_style), {
					horizontal_alignment = "left",
					offset = {
						20 + base_offset_x,
						10 + base_offset_y,
						3,
					},
					text_color = Color.terminal_text_body(255, true),
					preview_color = Color.ui_blue_light(255, true),
				}),
			}
			pass_templates[#pass_templates + 1] = {
				pass_type = "text",
				value = "100%",
				style_id = string.format("percentage_%i", ii),
				value_id = string.format("percentage_%i", ii),
				style = table.merge_recursive(table.clone(stat_percentage_style), {
					font_size = 22,
					text_horizontal_alignment = "left",
					offset = {
						20 + base_offset_x,
						10 + base_offset_y + 27 + 5,
						3,
					},
					text_color = Color.terminal_text_header(255, true),
				}),
			}
			pass_templates[#pass_templates + 1] = {
				pass_type = "rect",
				style_id = string.format("background_%i", ii),
				style = {
					horizontal_alignment = "left",
					offset = {
						22 + base_offset_x + bar_offset,
						10 + base_offset_y + bar_offset_y,
						3,
					},
					size = {
						bar_width,
						bar_height,
					},
					color = Color.black(200, true),
				},
			}
			pass_templates[#pass_templates + 1] = {
				pass_type = "rect",
				style_id = string.format("frame_%i", ii),
				style = {
					horizontal_alignment = "left",
					offset = {
						20 + base_offset_x + bar_offset,
						10 + base_offset_y + bar_offset_y - 2,
						2,
					},
					size = {
						bar_width + 4,
						bar_height + bar_height * 0.5,
					},
					color = Color.terminal_frame(200, true),
				},
			}
			pass_templates[#pass_templates + 1] = {
				pass_type = "rect",
				style_id = string.format("divider_1_%i", ii),
				style = {
					horizontal_alignment = "left",
					offset = {
						0,
						10 + base_offset_y + bar_offset_y,
						6,
					},
					size = {
						2,
						bar_height,
					},
					color = Color.terminal_frame(200, true),
				},
			}
			pass_templates[#pass_templates + 1] = {
				pass_type = "rect",
				style_id = string.format("divider_2_%i", ii),
				style = {
					horizontal_alignment = "left",
					offset = {
						0,
						10 + base_offset_y + bar_offset_y,
						6,
					},
					size = {
						2,
						bar_height,
					},
					color = Color.terminal_frame(200, true),
				},
			}
			pass_templates[#pass_templates + 1] = {
				pass_type = "texture",
				value = "content/ui/materials/backgrounds/default_square",
				style_id = string.format("bar_bg_%i", ii),
				style = {
					horizontal_alignment = "left",
					offset = {
						22 + base_offset_x + bar_offset,
						10 + base_offset_y + bar_offset_y,
						4,
					},
					size = {
						bar_width,
						bar_height,
					},
					color = Color.terminal_stat_bar_background(255, true),
				},
			}
			pass_templates[#pass_templates + 1] = {
				pass_type = "texture",
				value = "content/ui/materials/backgrounds/default_square",
				style_id = string.format("bar_%i", ii),
				style = {
					horizontal_alignment = "left",
					offset = {
						22 + base_offset_x + bar_offset,
						10 + base_offset_y + bar_offset_y,
						5,
					},
					size = {
						bar_width,
						bar_height,
					},
					default_color = Color.terminal_stat_bar_foreground(255, true),
					preview_color = Color.ui_blue_light(255, true),
					color = Color.terminal_stat_bar_foreground(255, true),
				},
			}
			pass_templates[#pass_templates + 1] = {
				pass_type = "hotspot",
				content_id = string.format("hotspot_%i", ii),
				content = default_button_content,
				style = {
					offset = {
						20 + base_offset_x,
						60 * ((ii - 1) % 2),
						0,
					},
					size = {
						150,
						70,
					},
				},
			}
			pass_templates[#pass_templates + 1] = {
				pass_type = "texture",
				value = "content/ui/materials/gradients/gradient_vertical",
				style_id = string.format("hover_frame_%i", ii),
				style = {
					hdr = false,
					horizontal_alignment = "left",
					vertical_alignment = "top",
					offset = {
						15 + base_offset_x,
						base_offset_y + 8,
						0,
					},
					size = {
						160,
						65,
					},
					color = Color.terminal_corner_selected(0, true),
					size_addition = {
						0,
						0,
					},
				},
			}
			pass_templates[#pass_templates + 1] = {
				pass_type = "texture",
				value = "content/ui/materials/frames/frame_tile_1px",
				style_id = string.format("hover_frame_border_%i", ii),
				style = {
					horizontal_alignment = "left",
					scale_to_material = true,
					vertical_alignment = "top",
					offset = {
						15 + base_offset_x,
						base_offset_y + 8,
						1,
					},
					size = {
						160,
						65,
					},
					color = Color.terminal_corner_selected(0, true),
				},
			}
			pass_templates[#pass_templates + 1] = {
				pass_type = "texture",
				value = "content/ui/materials/frames/frame_corner_2px",
				style_id = string.format("hover_frame_corner_%i", ii),
				style = {
					horizontal_alignment = "left",
					scale_to_material = true,
					vertical_alignment = "top",
					offset = {
						15 + base_offset_x,
						base_offset_y + 8,
						2,
					},
					size = {
						160,
						65,
					},
					color = Color.terminal_corner_selected(0, true),
				},
			}
		end

		pass_templates[#pass_templates + 1] = {
			pass_type = "text",
			style_id = "text_extra_value",
			value = "",
			value_id = "text_extra_value",
			style = table.merge_recursive(table.clone(stamina_value_style), {
				horizontal_alignment = "left",
				offset = {
					360,
					80,
					3,
				},
			}),
		}
		pass_templates[#pass_templates + 1] = {
			content_id = "hotspot_6",
			pass_type = "hotspot",
			content = default_button_content,
			style = {
				offset = {
					360,
					60,
					0,
				},
				size = {
					150,
					70,
				},
			},
		}
		pass_templates[#pass_templates + 1] = {
			pass_type = "texture",
			style_id = "hover_frame_6",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				hdr = false,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				offset = {
					355,
					58,
					0,
				},
				size = {
					160,
					65,
				},
				color = Color.terminal_corner_selected(0, true),
				size_addition = {
					0,
					0,
				},
			},
		}
		pass_templates[#pass_templates + 1] = {
			pass_type = "texture",
			style_id = "hover_frame_border_6",
			value = "content/ui/materials/frames/frame_tile_1px",
			style = {
				horizontal_alignment = "left",
				scale_to_material = true,
				vertical_alignment = "top",
				offset = {
					355,
					58,
					1,
				},
				size = {
					160,
					65,
				},
				color = Color.terminal_corner_selected(0, true),
			},
		}
		pass_templates[#pass_templates + 1] = {
			pass_type = "texture",
			style_id = "hover_frame_corner_6",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				horizontal_alignment = "left",
				scale_to_material = true,
				vertical_alignment = "top",
				offset = {
					355,
					58,
					2,
				},
				size = {
					160,
					65,
				},
				color = Color.terminal_corner_selected(0, true),
			},
		}
		pass_templates[#pass_templates + 1] = {
			pass_type = "texture",
			style_id = "glow",
			value = "content/ui/materials/frames/frame_glow_01",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				offset = {
					0,
					10,
					52,
				},
				size_addition = {
					20,
					30,
				},
				color = Color.terminal_corner_selected(nil, true),
			},
			change_function = function (content, style)
				style.color[1] = 200 + 55 * math.cos(3 * Application.time_since_launch())
			end,
			visibility_function = function (content, style)
				return not not content.show_glow
			end,
		}
		pass_templates[#pass_templates + 1] = {
			pass_type = "texture",
			style_id = "glow_background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				offset = {
					0,
					10,
					52,
				},
				size_addition = {
					5,
					5,
				},
				color = Color.terminal_corner_selected(nil, true),
			},
			change_function = function (content, style)
				style.color[1] = 50 + 5 * math.cos(3 * Application.time_since_launch())
			end,
			visibility_function = function (content, style)
				return not not content.show_glow
			end,
		}

		return pass_templates
	end

	local function _apply_stat_bar_values(widget, item)
		local content = widget.content
		local style = widget.style
		local weapon_stats = WeaponStats:new(item)
		local comparing_stats = weapon_stats:get_comparing_stats()
		local advanced_weapon_stats = weapon_stats._weapon_statistics
		local bar_breakdown = table.clone(advanced_weapon_stats.bar_breakdown)
		local start_preview_expertise = content.start_expertise_value
		local current_preview_expertise = content.preview_expertise_value and math.max(content.preview_expertise_value - start_preview_expertise, 0) or 0
		local max_preview_expertise = Items.max_expertise_level() - start_preview_expertise
		local disable_preview = content.disable_preview
		local is_preview = current_preview_expertise > 0 and not disable_preview

		content.show_glow = is_preview

		local added_stats = Items.preview_stats_change(item, is_preview and current_preview_expertise or 0, comparing_stats)
		local max_stats = Items.preview_stats_change(item, max_preview_expertise, comparing_stats)
		local num_stats = #comparing_stats

		for ii = 1, num_stats do
			local stat_data = comparing_stats[ii]
			local stat = added_stats[stat_data.display_name]
			local max_stat = max_stats[stat_data.display_name]
			local text_id = "text_" .. ii
			local bar_id = "bar_" .. ii
			local bar_bg_id = "bar_bg_" .. ii
			local divider_1_id = "divider_1_" .. ii
			local divider_2_id = "divider_2_" .. ii
			local percentage_id = "percentage_" .. ii
			local display_name = Localize(stat_data.display_name)

			widget.content.text = display_name

			local value_bar_width = math.round(bar_width * stat.fraction)
			local bar_style = style[bar_id]

			bar_style.size[1] = value_bar_width
			bar_style.color = is_preview and bar_style.preview_color or bar_style.default_color
			content[text_id] = display_name

			local stat_value_string = stat.value
			local text_style = style[text_id]

			if is_preview then
				stat_value_string = Text.apply_color_to_text(stat_value_string, text_style.preview_color)
			end

			content[percentage_id] = string.format("[%s/%d]%%", stat_value_string, max_stat.value)

			local bar_bg_style = style[bar_bg_id]
			local max_value_bar_width = math.round(bar_width * max_stat.fraction)

			bar_bg_style.size[1] = max_value_bar_width

			local divider_1_style = style[divider_1_id]

			divider_1_style.offset[1] = bar_bg_style.offset[1] + value_bar_width - 2

			local divider_2_style = style[divider_2_id]

			divider_2_style.offset[1] = bar_bg_style.offset[1] + max_value_bar_width
			content["bar_breakdown_" .. ii] = bar_breakdown[ii]
		end
	end

	local function _apply_package_item_icon_cb_func(widget, item, optional_texture_id)
		local icon_style = widget.style.icon
		local material_values = icon_style.material_values

		if item.icon_material and item.icon_material ~= "" then
			widget.content.old_icon_material = widget.content.icon
			widget.content.icon = item.icon_material
			material_values.texture_map = nil
		else
			material_values[optional_texture_id or "texture_icon"] = item.icon
		end

		material_values.use_placeholder_texture = 0
		material_values.use_render_target = 0
		widget.content.use_placeholder_texture = material_values.use_placeholder_texture
	end

	local function _remove_package_item_icon_cb_func(widget, ui_renderer, optional_texture_id)
		if widget.content.visible then
			UIWidget.set_visible(widget, ui_renderer, false)
			UIWidget.set_visible(widget, ui_renderer, true)
		end

		local material_values = widget.style.icon.material_values

		material_values[optional_texture_id or "texture_icon"] = nil
		material_values.use_placeholder_texture = 1

		if widget.content.old_icon_material then
			widget.content.icon = widget.content.old_icon_material
			widget.content.old_icon_material = nil
		end

		widget.content.use_placeholder_texture = material_values.use_placeholder_texture
	end

	local function _apply_live_item_icon_cb_func(widget, grid_index, rows, columns, render_target)
		local material_values = widget.style.icon.material_values

		material_values.use_placeholder_texture = 0
		material_values.rows = rows
		material_values.columns = columns
		material_values.grid_index = grid_index - 1
		material_values.texture_icon = render_target
		widget.content.use_placeholder_texture = material_values.use_placeholder_texture
	end

	local function _remove_live_item_icon_cb_func(widget, ui_renderer)
		if widget.content.visible then
			UIWidget.set_visible(widget, ui_renderer, false)
			UIWidget.set_visible(widget, ui_renderer, true)
		end

		local material_values = widget.style.icon.material_values

		material_values.use_placeholder_texture = 1
		material_values.texture_icon = nil
		widget.content.use_placeholder_texture = material_values.use_placeholder_texture
	end

	local weapon_header_icon_width = grid_width * 0.5
	local weapon_header_icon_height = 95
	local blueprints = {
		equipped = {
			size = {
				grid_width,
				50,
			},
			pass_template = {
				_generate_background_pass(),
				{
					pass_type = "text",
					style_id = "display_name",
					value_id = "display_name",
					style = equipped_display_name_style,
					value = Localize("loc_item_information_equipped_label"),
				},
			},
		},
		weapon_header = {
			size = {
				grid_width,
				135,
			},
			pass_template = {
				_generate_background_pass(),
				{
					pass_type = "texture",
					style_id = "gradient_background",
					value = "content/ui/materials/gradients/gradient_vertical",
					value_id = "gradient_background",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "bottom",
						offset = {
							0,
							0,
							1,
						},
						color = Color.white(255, true),
					},
				},
				{
					pass_type = "texture",
					style_id = "icon",
					value = "content/ui/materials/icons/weapons/hud/combat_blade_01",
					value_id = "icon",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "top",
						size = {
							weapon_header_icon_width,
							weapon_header_icon_height,
						},
						offset = {
							weapon_header_icon_width * 0.5,
							30,
							3,
						},
						color = Color.terminal_icon(nil, true),
						material_values = {},
					},
				},
				{
					pass_type = "text",
					style_id = "sub_display_name",
					value = "n/a",
					value_id = "sub_display_name",
					style = weapon_sub_display_name_style,
				},
				{
					pass_type = "text",
					style_id = "rarity_name",
					value = "n/a",
					value_id = "rarity_name",
					style = weapon_rarity_name_style,
				},
				{
					pass_type = "texture",
					style_id = "weapon_special_icon",
					value = "content/ui/materials/backgrounds/default_square",
					value_id = "weapon_special_icon",
					style = {
						horizontal_alignment = "left",
						vertical_alignment = "top",
						offset = {
							20,
							44,
							50,
						},
						size = {
							24,
							24,
						},
						color = Color.terminal_icon(255, true),
					},
				},
				{
					pass_type = "text",
					style_id = "weapon_special_text",
					value = "n/a",
					value_id = "weapon_special_text",
					style = table.merge_recursive(table.clone(UIFontSettings.body), {
						font_size = 16,
						horizontal_alignment = "left",
						text_horizontal_alignment = "left",
						text_vertical_alignment = "top",
						vertical_alignment = "top",
						offset = {
							50,
							44,
							50,
						},
						size = {
							200,
							20,
						},
						text_color = Color.terminal_icon(255, true),
					}),
				},
			},
			init = function (parent, widget, element, callback_name, _, ui_renderer)
				local content = widget.content
				local style = widget.style

				content.element = element

				local item = element.item
				local sub_display_name = Items.weapon_card_sub_display_name(item)
				local rarity_name = Items.sub_display_name(item, nil, true)

				content.sub_display_name = sub_display_name
				content.rarity_name = rarity_name
				content.icon = item.hud_icon or "content/ui/materials/icons/weapons/hud/combat_blade_01"

				local rarity_name_style = style.rarity_name
				local sub_display_name_text_height = _style_text_height(sub_display_name, weapon_display_name_style, ui_renderer)

				rarity_name_style.offset[2] = rarity_name_style.offset[2] + sub_display_name_text_height

				local weapon_template = WeaponTemplate.weapon_template_from_item(item)
				local displayed_attacks = weapon_template.displayed_attacks
				local weapon_special = displayed_attacks.special

				if weapon_special then
					content.weapon_special_icon = UISettings.weapon_action_type_icons[weapon_special.type]
					content.weapon_special_text = Localize(weapon_special.display_name)
					style.weapon_special_icon.visible = true
					style.weapon_special_text.visible = true

					local rarity_name_text_height = _style_text_height(rarity_name, weapon_rarity_name_style, ui_renderer)

					style.weapon_special_icon.offset[2] = style.weapon_special_icon.offset[2] + sub_display_name_text_height + rarity_name_text_height
					style.weapon_special_text.offset[2] = style.weapon_special_text.offset[2] + sub_display_name_text_height + rarity_name_text_height
				else
					style.weapon_special_icon.visible = false
					style.weapon_special_text.visible = false
				end

				local rarity_color, rarity_color_dark = Items.rarity_color(item)

				style.gradient_background.color = table.clone(rarity_color_dark)
				style.gradient_background.material_values = {
					invert = 1,
				}
				style.background.visible = not not element.add_background
				style.rarity_name.text_color = table.clone(rarity_color)
			end,
		},
		item_header = {
			size = {
				grid_width,
				100,
			},
			size_function = function (parent, element, ui_renderer)
				local item = element.item
				local text = Items.display_name(item) .. "\n" .. Items.sub_display_name(item, nil, true)
				local text_height = _style_text_height(text, item_display_name_style, ui_renderer)
				local entry_height = math.max(0, text_height + 25)

				return {
					grid_width,
					entry_height,
				}
			end,
			pass_template = {
				{
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							0,
						},
						color = Color.black(255, true),
					},
				},
				_generate_background_pass(),
				{
					pass_type = "texture",
					style_id = "gradient_background",
					value = "content/ui/materials/gradients/gradient_vertical",
					value_id = "gradient_background",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "bottom",
						offset = {
							0,
							0,
							1,
						},
						color = Color.terminal_grid_background(255, true),
					},
				},
				{
					pass_type = "rect",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "center",
						offset = {
							0,
							0,
							2,
						},
						color = Color.black(140, true),
					},
				},
				{
					pass_type = "text",
					style_id = "display_name",
					value = "n/a",
					value_id = "display_name",
					style = item_display_name_style,
				},
				{
					pass_type = "text",
					style_id = "sub_display_name",
					value = "n/a",
					value_id = "sub_display_name",
					style = item_sub_display_name_style,
				},
			},
			init = function (parent, widget, element, callback_name, _, ui_renderer)
				local content = widget.content
				local style = widget.style

				content.element = element

				local item = element.item
				local display_name = Items.display_name(item)
				local sub_display_name = Items.sub_display_name(item, nil, true)

				content.display_name = display_name
				content.sub_display_name = sub_display_name

				local display_name_style = style.display_name
				local sub_display_name_style = style.sub_display_name

				if item.rarity then
					local rarity_color, rarity_color_dark = Items.rarity_color(item)

					style.gradient_background.color = table.clone(rarity_color_dark)
				end

				local display_name_text_height = _style_text_height(display_name, item_display_name_style, ui_renderer)

				sub_display_name_style.offset[2] = sub_display_name_style.offset[2] + display_name_text_height
			end,
		},
		character_title_header = {
			size = {
				grid_width,
				100,
			},
			size_function = function (parent, element, ui_renderer)
				local item = element.item
				local profile = element.profile
				local display_name = ProfileUtils.title_item_name_no_color(item, profile)
				local text = display_name .. "\n" .. Items.sub_display_name(item)
				local text_height = _style_text_height(text, item_display_name_style, ui_renderer)
				local entry_height = math.max(0, text_height + 25)

				return {
					grid_width,
					entry_height,
				}
			end,
			pass_template = {
				{
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							0,
						},
						color = Color.black(255, true),
					},
				},
				{
					pass_type = "texture",
					style_id = "gradient_background",
					value = "content/ui/materials/gradients/gradient_vertical",
					value_id = "gradient_background",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "bottom",
						offset = {
							0,
							0,
							1,
						},
						color = Color.terminal_grid_background(255, true),
					},
				},
				{
					pass_type = "text",
					style_id = "display_name",
					value = "n/a",
					value_id = "display_name",
					style = item_display_name_style,
				},
				{
					pass_type = "text",
					style_id = "sub_display_name",
					value = "n/a",
					value_id = "sub_display_name",
					style = item_sub_display_name_style,
				},
			},
			init = function (parent, widget, element, callback_name, _, ui_renderer)
				local content = widget.content
				local style = widget.style

				content.element = element

				local item = element.item
				local profile = element.profile
				local display_name = ProfileUtils.title_item_name_no_color(item, profile)
				local sub_display_name = Items.type_display_name(item)

				content.display_name = display_name
				content.sub_display_name = sub_display_name

				local display_name_style = style.display_name
				local sub_display_name_style = style.sub_display_name

				if item.rarity then
					local rarity_color, rarity_color_dark = Items.rarity_color(item)

					style.gradient_background.color = table.clone(rarity_color_dark)
					style.display_name.text_color = table.clone(rarity_color)
				end

				local display_name_text_height = _style_text_height(display_name, item_display_name_style, ui_renderer)

				sub_display_name_style.offset[2] = sub_display_name_style.offset[2] + display_name_text_height
			end,
		},
		weapon_skin_icon = {
			size = {
				grid_width,
				200,
			},
			pass_template = {
				{
					pass_type = "texture",
					style_id = "icon",
					value = "content/ui/materials/icons/items/containers/item_container_tooltip_no_rarity",
					value_id = "icon",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "bottom",
						size = {
							grid_width,
							190,
						},
						offset = {
							0,
							0,
							3,
						},
						color = Color.white(255, true),
						material_values = {},
					},
					visibility_function = _generated_icon_visibility,
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
							10,
							3,
						},
					},
					visibility_function = _loading_icon_visibility,
					change_function = _loading_icon_change,
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content

				content.element = element
			end,
			load_icon = function (parent, widget, element)
				local content = widget.content

				if not content.icon_load_id then
					local visual_item = element.visual_item
					local cb = callback(_apply_live_item_icon_cb_func, widget)
					local context = {
						size = {
							grid_width * 2,
							380,
						},
					}

					content.icon_load_id = Managers.ui:load_item_icon(visual_item, cb, context)
				end
			end,
			unload_icon = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_live_item_icon_cb_func(widget, ui_renderer)
					Managers.ui:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end,
			destroy = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_live_item_icon_cb_func(widget, ui_renderer)
					Managers.ui:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end,
		},
		cosmetic_gear_icon = {
			size = {
				grid_width,
				350,
			},
			pass_template = {
				{
					pass_type = "texture",
					style_id = "icon",
					value = "content/ui/materials/icons/items/containers/item_container_tooltip_no_rarity",
					value_id = "icon",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "bottom",
						size = {
							grid_width,
							350,
						},
						offset = {
							0,
							0,
							3,
						},
						color = Color.white(255, true),
						material_values = {},
					},
					visibility_function = _generated_icon_visibility,
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
					visibility_function = _loading_icon_visibility,
					change_function = _loading_icon_change,
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				local style = widget.style

				content.element = element

				local item = element.item

				content.display_name = Items.display_name(item)
				content.sub_display_name = Items.sub_display_name(item)
			end,
			load_icon = function (parent, widget, element)
				local content = widget.content

				if not content.icon_load_id then
					local item = element.item
					local slots = item.slots
					local slot_name = slots[1]
					local item_state_machine = item.state_machine
					local item_animation_event = item.animation_event
					local profile = element.profile
					local render_context = {
						camera_focus_slot_name = slot_name,
						state_machine = item_state_machine,
						animation_event = item_animation_event,
						size = {
							grid_width,
							350,
						},
					}
					local cb = callback(_apply_live_item_icon_cb_func, widget)

					content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context, profile)
				end
			end,
			unload_icon = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_live_item_icon_cb_func(widget, ui_renderer)
					Managers.ui:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end,
			destroy = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_live_item_icon_cb_func(widget, ui_renderer)
					Managers.ui:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end,
		},
		gadget_header = {
			size = {
				grid_width,
				300,
			},
			pass_template = {
				{
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							0,
						},
						color = Color.black(255, true),
					},
				},
				{
					pass_type = "texture",
					style_id = "icon",
					value = "content/ui/materials/icons/items/containers/item_container_tooltip_no_rarity",
					value_id = "icon",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "center",
						size = {
							grid_width,
							200,
						},
						offset = {
							0,
							0,
							3,
						},
						color = Color.white(255, true),
						material_values = {},
					},
					visibility_function = _generated_icon_visibility,
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
							10,
							3,
						},
					},
					visibility_function = _loading_icon_visibility,
					change_function = _loading_icon_change,
				},
				{
					pass_type = "texture",
					style_id = "background",
					value = "content/ui/materials/gradients/gradient_vertical",
					value_id = "background",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "bottom",
						offset = {
							0,
							0,
							1,
						},
						color = Color.white(255, true),
					},
				},
				{
					pass_type = "rect",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "center",
						offset = {
							0,
							0,
							2,
						},
						color = Color.black(140, true),
					},
				},
				{
					pass_type = "text",
					style_id = "display_name",
					value = "n/a",
					value_id = "display_name",
					style = item_display_name_style,
				},
				{
					pass_type = "text",
					style_id = "sub_display_name",
					value = "n/a",
					value_id = "sub_display_name",
					style = item_sub_display_name_style,
				},
				{
					pass_type = "text",
					style_id = "rating_text",
					value_id = "rating_title",
					value = Localize("loc_item_information_rating"),
					style = gear_stat_text_style,
				},
				{
					pass_type = "text",
					style_id = "rating_value",
					value = "n/a",
					value_id = "rating_value",
					style = gear_value_style,
				},
			},
			init = function (parent, widget, element, callback_name, _, ui_renderer)
				local content = widget.content
				local style = widget.style

				content.element = element

				local item = element.item
				local display_name = Items.display_name(item)
				local sub_display_name = Items.sub_display_name(item)
				local sub_display_name_style = style.sub_display_name

				content.display_name = display_name
				content.sub_display_name = sub_display_name

				local display_name_text_height = _style_text_height(display_name, item_display_name_style, ui_renderer)

				sub_display_name_style.offset[2] = sub_display_name_style.offset[2] + display_name_text_height

				local item_level, has_level = Items.expertise_level(item)
				local rating_value = item.override_item_rating_string or has_level and item_level or ""

				content.rating_value = rating_value

				local item_rarity = item.rarity

				if item_rarity then
					local rarity_color, rarity_color_dark = Items.rarity_color(item)

					style.background.color = table.clone(rarity_color)
					style.display_name.text_color = table.clone(rarity_color)
					style.sub_display_name.text_color = table.clone(rarity_color)
				end
			end,
			load_icon = function (parent, widget, element)
				local content = widget.content

				if not content.icon_load_id then
					local item = element.item
					local cb = callback(_apply_live_item_icon_cb_func, widget)
					local context = {
						size = {
							grid_width * 2,
							400,
						},
					}

					content.icon_load_id = Managers.ui:load_item_icon(item, cb, context)
				end
			end,
			unload_icon = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_live_item_icon_cb_func(widget, ui_renderer)
					Managers.ui:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end,
			destroy = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_live_item_icon_cb_func(widget, ui_renderer)
					Managers.ui:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end,
		},
		divider_line = {
			size = {
				grid_width,
				1,
			},
			pass_template = {
				{
					pass_type = "rect",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "top",
						size = {
							grid_width,
							1,
						},
						offset = {
							0,
							0,
							10,
						},
						color = Color.terminal_grid_background(255, true),
					},
				},
			},
		},
		portrait_frame = {
			size = {
				grid_width,
				220,
			},
			pass_template = {
				{
					pass_type = "texture",
					style_id = "icon",
					value = "content/ui/materials/base/ui_portrait_frame_base",
					value_id = "icon",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "center",
						size = {
							140,
							160,
						},
						offset = {
							0,
							0,
							2,
						},
						color = Color.white(255, true),
						material_values = {
							use_placeholder_texture = 1,
						},
					},
					visibility_function = _generated_icon_visibility,
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
					visibility_function = _loading_icon_visibility,
					change_function = _loading_icon_change,
				},
			},
			init = function (parent, widget, element, callback_name, _, ui_renderer)
				local content = widget.content

				content.element = element
			end,
			load_icon = function (parent, widget, element)
				local content = widget.content

				if not content.icon_load_id then
					local item = element.item
					local slots = item.slots
					local slot_name = slots[1]
					local cb = callback(_apply_package_item_icon_cb_func, widget, item, "portrait_frame_texture")
					local render_context = {
						camera_focus_slot_name = slot_name,
					}

					content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context)
				end
			end,
			unload_icon = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_package_item_icon_cb_func(widget, ui_renderer, "portrait_frame_texture")
					Managers.ui:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end,
			destroy = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_package_item_icon_cb_func(widget, ui_renderer, "portrait_frame_texture")
					Managers.ui:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end,
		},
		insignia = {
			size = {
				grid_width,
				220,
			},
			pass_template = {
				{
					pass_type = "texture",
					style_id = "icon",
					value = "content/ui/materials/base/ui_default_base",
					value_id = "icon",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "center",
						size = {
							60,
							160,
						},
						offset = {
							0,
							0,
							2,
						},
						color = Color.white(255, true),
						material_values = {
							use_placeholder_texture = 1,
						},
					},
					visibility_function = _generated_icon_visibility,
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
					visibility_function = _loading_icon_visibility,
					change_function = _loading_icon_change,
				},
			},
			init = function (parent, widget, element, callback_name, _, ui_renderer)
				local content = widget.content

				content.element = element
			end,
			load_icon = function (parent, widget, element)
				local content = widget.content

				if not content.icon_load_id then
					local item = element.item
					local slots = item.slots
					local slot_name = slots[1]
					local cb = callback(_apply_package_item_icon_cb_func, widget, item, "texture_map")
					local render_context = {
						camera_focus_slot_name = slot_name,
					}

					content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context)
				end
			end,
			unload_icon = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_package_item_icon_cb_func(widget, ui_renderer, "texture_map")
					Managers.ui:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end,
			destroy = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_package_item_icon_cb_func(widget, ui_renderer, "texture_map")
					Managers.ui:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end,
		},
		emote = {
			size = {
				grid_width,
				220,
			},
			pass_template = {
				{
					pass_type = "texture",
					style_id = "icon",
					value = "content/ui/materials/base/ui_default_base",
					value_id = "icon",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "center",
						size = {
							128,
							128,
						},
						offset = {
							0,
							0,
							2,
						},
						color = Color.white(255, true),
						material_values = {
							use_placeholder_texture = 1,
						},
					},
					visibility_function = _generated_icon_visibility,
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
					visibility_function = _loading_icon_visibility,
					change_function = _loading_icon_change,
				},
			},
			init = function (parent, widget, element, callback_name, _, ui_renderer)
				local content = widget.content

				content.element = element
			end,
			load_icon = function (parent, widget, element)
				local content = widget.content

				if not content.icon_load_id then
					local item = element.item
					local slots = item.slots
					local slot_name = slots[1]
					local cb = callback(_apply_package_item_icon_cb_func, widget, item, "texture_map")
					local render_context = {
						camera_focus_slot_name = slot_name,
					}
					local profile = element.profile

					content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context, profile)
				end
			end,
			unload_icon = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_package_item_icon_cb_func(widget, ui_renderer, "texture_map")
					Managers.ui:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end,
			destroy = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_package_item_icon_cb_func(widget, ui_renderer, "texture_map")
					Managers.ui:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end,
		},
		weapon_keywords = {
			size = {
				grid_width,
				0,
			},
			pass_template = {
				{
					pass_type = "text",
					style_id = "text",
					value = "n/a",
					value_id = "text",
					style = weapon_keyword_style,
				},
				{
					pass_type = "texture",
					style_id = "frame",
					value = "content/ui/materials/frames/line_thin_sharp_edges",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "center",
						offset = {
							0,
							0,
							10,
						},
						size = {
							grid_width,
							30,
						},
						color = Color.terminal_grid_background(255, true),
					},
				},
				{
					pass_type = "texture",
					style_id = "inner_frame",
					value = "content/ui/materials/frames/line_thin_sharp_edges_fill",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "center",
						offset = {
							0,
							0,
							9,
						},
						size = {
							grid_width,
							30,
						},
						color = {
							255,
							25,
							31,
							24,
						},
					},
				},
				{
					pass_type = "rect",
					style = {
						horizontal_alignment = "center",
						size = {
							grid_width,
							1,
						},
						offset = {
							0,
							0,
							1,
						},
						color = Color.terminal_grid_background(255, true),
					},
				},
			},
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
				local content = widget.content
				local style = widget.style

				content.element = element

				local item = element.item

				content.text = Items.keywords_text(item)

				local text_width = _style_text_width(content.text, style.text, ui_renderer)
				local frame_style = style.frame

				frame_style.size[1] = text_width + 50

				local inner_frame_style = style.inner_frame

				inner_frame_style.size[1] = text_width + 50
			end,
		},
		weapon_stats = {
			size = {
				grid_width,
				134,
			},
			pass_template = _generate_weapon_stats_passes(optional_item),
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				local style = widget.style

				content.element = element
				style.background.visible = not not element.add_background

				local item = element.item
				local weapon_stats = WeaponStats:new(item)
				local current_expertise = Items.expertise_level(item, true)

				content.start_expertise_value = tonumber(current_expertise)

				_apply_stat_bar_values(widget, item)

				content.bar_breakdown_6 = {
					description = "loc_weapon_stats_display_base_rating_desc",
					display_name = "loc_weapon_stats_display_base_rating",
					name = "base_rating",
				}
				content.gamepad_bar_matrix = {
					{
						1,
						2,
						6,
					},
					{
						4,
						5,
						3,
					},
				}
				content.gamepad_selected_index = {}
				parent._weapon_advanced_stats = weapon_stats._weapon_statistics

				local show_base_stats = content.element.show_base_rating

				if show_base_stats then
					local base_stats_rating = Items.calculate_stats_rating(item)

					content.text_extra_value = " " .. base_stats_rating
					style.text_extra_value.text_color = Color.white(255, true)
					style.text_extra_value.font_size = 30
					style.text_extra_value.offset[2] = style.text_extra_value.offset[2] - 10
				end
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				local content = widget.content
				local style = widget.style
				local total_stats = content.element.show_base_rating and 6 or 5
				local item = content.element.item

				if content.preview_expertise_value ~= content.new_preview_expertise_value then
					content.preview_expertise_value = content.new_preview_expertise_value

					_apply_stat_bar_values(widget, item)
				end

				if not content.element.interactive then
					return
				end

				local parent_active = true

				if type(parent.is_active) == "function" then
					parent_active = parent:is_active()
				end

				local stat_data

				if InputDevice.gamepad_active then
					local gamepad_selected_index_x = content.gamepad_selected_index[1]
					local gamepad_selected_index_y = content.gamepad_selected_index[2]
					local index_x = gamepad_selected_index_x or 1
					local index_y = gamepad_selected_index_y or 1
					local gamepad_bar_matrix = content.gamepad_bar_matrix

					if input_service:get("navigate_up_continuous") then
						index_y = math.max(index_y - 1, 1)
					elseif input_service:get("navigate_down_continuous") then
						index_y = math.min(index_y + 1, #gamepad_bar_matrix)
					elseif input_service:get("navigate_left_continuous") then
						index_x = math.max(index_x - 1, 1)
					elseif input_service:get("navigate_right_continuous") then
						index_x = math.min(index_x + 1, #gamepad_bar_matrix[index_y])
					end

					content.gamepad_selected_index[1] = index_x
					content.gamepad_selected_index[2] = index_y

					local selected_index = gamepad_bar_matrix[index_y][index_x]

					for ii = 1, total_stats do
						local is_hover = parent_active and ii == selected_index

						style["hover_frame_" .. ii].color[1] = is_hover and 128 or 0
						style["hover_frame_border_" .. ii].color[1] = is_hover and 128 or 0
						style["hover_frame_corner_" .. ii].color[1] = is_hover and 128 or 0
						stat_data = is_hover and content["bar_breakdown_" .. ii] or stat_data
					end
				else
					for ii = 1, total_stats do
						local hotspot = content["hotspot_" .. ii]
						local is_hover = parent_active and hotspot.is_hover

						style["hover_frame_" .. ii].color[1] = is_hover and 128 or 0
						style["hover_frame_border_" .. ii].color[1] = is_hover and 128 or 0
						style["hover_frame_corner_" .. ii].color[1] = is_hover and 128 or 0
						stat_data = is_hover and content["bar_breakdown_" .. ii] or stat_data
					end
				end

				if parent.update_bar_breakdown_data then
					parent:update_bar_breakdown_data(stat_data)
				end
			end,
		},
		rating_info = {
			size = {
				grid_width,
				0,
			},
			pass_template = {
				{
					pass_type = "text",
					style_id = "header",
					value = "",
					value_id = "header",
					style = rating_header_style,
				},
			},
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
				local content = widget.content
				local style = widget.style
				local rating_value = element.rating
				local header = element.header

				content.header = header or ""
			end,
		},
		trait_dynamic_spacing = {
			size = {
				0,
				0,
			},
			pass_template = {
				_generate_background_pass(),
			},
			size_function = function (parent, config)
				return config.size
			end,
		},
		weapon_attack_data = {
			size = {
				0,
				0,
			},
			pass_template = _generate_weapon_attack_action_passes(optional_item),
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
				local content = widget.content
				local style = widget.style

				content.item = element.item
				style.background.visible = not not element.add_background

				local index = 1
				local attack_icon_style = style["attack_icon_" .. index]
				local fire_mode_icon_style = style["fire_mode_icon_" .. index]
				local attack_value_style = style["attack_value_" .. index]
				local spacing = 15

				while attack_icon_style and attack_value_style do
					local text = content["attack_value_" .. index]
					local text_width = _style_text_width(text, attack_value_style, ui_renderer)
					local icon_width = attack_icon_style.size[1]
					local size = (text_width * 0.5 + icon_width * 0.5 + spacing) * 0.5

					if text_width > 0 then
						attack_icon_style.offset[1] = attack_icon_style.offset[1] - size
						fire_mode_icon_style.offset[1] = attack_icon_style.offset[1]

						if attack_icon_style.visible then
							attack_value_style.offset[1] = attack_value_style.offset[1] - size + icon_width + spacing
						end
					end

					index = index + 1
					fire_mode_icon_style = style["fire_mode_icon_" .. index]
					attack_icon_style = style["attack_icon_" .. index]
					attack_value_style = style["attack_value_" .. index]
				end
			end,
			size_function = function (parent, config)
				return config.size
			end,
		},
		weapon_perk = {
			size_function = function (parent, element, ui_renderer)
				local perk_item = element.perk_item
				local perk_value = element.perk_value
				local perk_rarity = element.perk_rarity
				local description = Items.trait_description(perk_item, perk_rarity, perk_value)
				local text_height = _style_text_height(description, weapon_perk_style, ui_renderer)
				local entry_height = math.max(weapon_perk_style.font_size + 8, text_height + 14)

				return {
					grid_width,
					entry_height,
				}
			end,
			pass_template = {
				_generate_background_pass(),
				{
					pass_type = "texture",
					value = "content/ui/materials/icons/perks/perk_level_01",
					value_id = "rank",
					style = {
						vertical_alignment = "center",
						size = {
							20,
							20,
						},
						offset = {
							20,
							0,
							8,
						},
						color = Color.terminal_icon(255, true),
					},
				},
				{
					pass_type = "text",
					style_id = "description",
					value = "n/a",
					value_id = "text",
					style = weapon_perk_style,
				},
				{
					pass_type = "texture",
					style_id = "glow",
					value = "content/ui/materials/frames/frame_glow_01",
					style = {
						horizontal_alignment = "center",
						scale_to_material = true,
						vertical_alignment = "center",
						offset = {
							0,
							0,
							7,
						},
						size_addition = {
							24,
							25,
						},
						color = Color.terminal_corner_selected(nil, true),
					},
					change_function = function (content, style)
						style.color[1] = 200 + 55 * math.cos(3 * Application.time_since_launch())
					end,
				},
				{
					pass_type = "texture",
					style_id = "glow_background",
					value = "content/ui/materials/backgrounds/default_square",
					style = {
						horizontal_alignment = "center",
						scale_to_material = true,
						vertical_alignment = "center",
						offset = {
							0,
							0,
							6,
						},
						size_addition = {
							2,
							2,
						},
						color = Color.terminal_corner_selected(nil, true),
					},
					change_function = function (content, style)
						style.color[1] = 50 + 5 * math.cos(3 * Application.time_since_launch())
					end,
				},
				{
					pass_type = "text",
					value = "",
					value_id = "rating",
					style = table.merge_recursive(table.clone(weapon_traits_style), {
						text_horizontal_alignment = "right",
						text_vertical_alignment = "center",
						text_color = {
							255,
							255,
							255,
							255,
						},
					}),
				},
			},
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer, double_click_callback_name, template)
				local content = widget.content
				local style = widget.style

				content.element = element
				style.background.visible = not not element.add_background
				style.glow.visible = not not element.show_glow
				style.glow_background.visible = not not element.show_glow

				template.update_item(widget)

				widget.update_item = template.update_item
			end,
			update_item = function (widget, preview_perk)
				local content = widget.content
				local style = widget.style
				local element = content.element
				local perk_item = preview_perk and preview_perk.preview_perk_item or element.perk_item
				local perk_value = preview_perk and preview_perk.preview_perk_value or element.perk_value
				local perk_rarity = preview_perk and preview_perk.preview_perk_rarity or element.perk_rarity
				local description = Items.trait_description(perk_item, perk_rarity, perk_value)

				content.text = description
				content.rank = Items.perk_textures(perk_item, perk_rarity)

				if element.show_rating then
					content.rating = " " .. Items.perk_rating(perk_item, perk_rarity)

					local description_size = element.description_size or {}

					style.description.size[1] = description_size[1] or style.description.size[1]
					style.description.size[2] = description_size[2] or style.description.size[2]
				end
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				return
			end,
		},
		weapon_trait = {
			size = {
				grid_width,
				114,
			},
			size_function = function (parent, element, ui_renderer)
				local trait_item = element.trait_item
				local trait_value = element.trait_value
				local trait_rarity = element.trait_rarity
				local description = Items.trait_description(trait_item, trait_rarity, trait_value)
				local description_height = _style_text_height(description, weapon_traits_description_style, ui_renderer)
				local entry_height = math.max(68, description_height + 25)

				return {
					grid_width,
					entry_height,
				}
			end,
			pass_template = {
				_generate_background_pass(),
				{
					pass_type = "texture",
					style_id = "icon",
					value = "content/ui/materials/icons/traits/traits_container",
					style = {
						material_values = {},
						size = {
							64,
							64,
						},
						offset = {
							20,
							0,
							8,
						},
						color = Color.terminal_icon(255, true),
					},
				},
				{
					pass_type = "text",
					value = "n/a",
					value_id = "display_name",
					style = weapon_traits_style,
				},
				{
					pass_type = "text",
					value = "",
					value_id = "rating",
					style = table.merge_recursive(table.clone(weapon_traits_style), {
						text_horizontal_alignment = "right",
						text_vertical_alignment = "center",
						text_color = {
							255,
							255,
							255,
							255,
						},
					}),
				},
				{
					pass_type = "text",
					style_id = "description",
					value = "n/a",
					value_id = "description",
					style = weapon_traits_description_style,
				},
				{
					pass_type = "texture",
					style_id = "glow",
					value = "content/ui/materials/frames/frame_glow_01",
					style = {
						horizontal_alignment = "center",
						scale_to_material = true,
						vertical_alignment = "center",
						offset = {
							0,
							0,
							7,
						},
						size_addition = {
							20,
							30,
						},
						color = Color.terminal_corner_selected(nil, true),
					},
					change_function = function (content, style)
						style.color[1] = 200 + 55 * math.cos(3 * Application.time_since_launch())
					end,
				},
				{
					pass_type = "texture",
					style_id = "glow_background",
					value = "content/ui/materials/backgrounds/default_square",
					style = {
						horizontal_alignment = "center",
						scale_to_material = true,
						vertical_alignment = "center",
						size_addition = {
							2,
							2,
						},
						offset = {
							0,
							0,
							6,
						},
						color = Color.terminal_corner_selected(nil, true),
					},
					change_function = function (content, style)
						style.color[1] = 50 + 5 * math.cos(3 * Application.time_since_launch())
					end,
				},
			},
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer, double_click_callback_name, template)
				local content = widget.content
				local style = widget.style

				content.element = element
				style.background.visible = not not element.add_background
				style.glow.visible = not not element.show_glow
				style.glow_background.visible = not not element.show_glow

				template.update_item(widget)

				widget.update_item = template.update_item
			end,
			update_item = function (widget, preview_trait)
				local content = widget.content
				local style = widget.style
				local element = content.element
				local trait_item = preview_trait and preview_trait.preview_trait_item or element.trait_item
				local trait_value = preview_trait and preview_trait.preview_trait_value or element.trait_value
				local trait_rarity = preview_trait and preview_trait.preview_trait_rarity or element.trait_rarity
				local display_name = trait_item.display_name

				content.display_name = Localize(display_name)

				local texture_icon, texture_frame = Items.trait_textures(trait_item, trait_rarity)
				local icon_material_values = style.icon.material_values

				if texture_icon then
					icon_material_values.icon = texture_icon
				end

				if texture_frame then
					icon_material_values.frame = texture_frame
				end

				local description = Items.trait_description(trait_item, trait_rarity, trait_value)

				content.description = description

				if element.show_rating then
					local rating_value = Items.trait_rating(trait_item, trait_rarity, trait_value)

					content.rating = " " .. rating_value

					local description_size = element.description_size or {}

					style.description.size[1] = description_size[1] or style.description.size[1]
					style.description.size[2] = description_size[2] or style.description.size[2]
				end

				style.icon.material_values.overlay = 0

				if element.trait_category then
					local seen_traits = Managers.data_service.crafting:cached_trait_sticker_book(element.trait_category)

					for seen_trait_name, status in pairs(seen_traits) do
						if seen_trait_name == trait_item.name and status ~= nil then
							local trait_status = status[trait_rarity]

							if trait_status == "unseen" then
								style.icon.material_values.overlay = 1

								break
							end
						end
					end
				end
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				return
			end,
		},
		gadget_trait = {
			size = {
				grid_width,
				54,
			},
			pass_template = {
				_generate_background_pass(),
				{
					pass_type = "texture",
					value = "content/ui/materials/icons/perks/perk_level_05",
					value_id = "rank",
					style = {
						vertical_alignment = "center",
						size = {
							20,
							20,
						},
						offset = {
							42,
							0,
							8,
						},
						color = Color.terminal_icon(255, true),
					},
				},
				{
					pass_type = "text",
					value = "n/a",
					value_id = "text",
					style = gadget_trait_style,
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				local style = widget.style

				content.element = element
				style.background.visible = not not element.add_background

				local trait_item = element.trait_item
				local trait_value = element.trait_value or 0
				local trait_rarity = element.trait_rarity
				local description = Items.trait_description(trait_item, trait_rarity, trait_value)

				content.text = description
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				return
			end,
		},
		description = {
			size = {
				grid_width,
				114,
			},
			size_function = function (parent, element, ui_renderer)
				local item = element.item
				local description = item.description
				local description_localized = description and Localize(description) or ""
				local description_height = _style_text_height(description_localized, description_style, ui_renderer)
				local entry_height = math.max(0, description_height + 8)

				return {
					grid_width,
					entry_height,
				}
			end,
			pass_template = {
				{
					pass_type = "text",
					value = "n/a",
					value_id = "description",
					style = description_style,
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content

				content.element = element

				local item = element.item
				local description = item.description
				local description_localized = description and Localize(description) or ""

				content.description = description_localized
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				return
			end,
		},
		obtained_header = {
			size = {
				grid_width,
				114,
			},
			size_function = function (parent, element, ui_renderer)
				local text = Localize("loc_item_source_obtained_title")
				local text_height = _style_text_height(text, obtained_header_style, ui_renderer)
				local entry_height = math.max(0, text_height)

				return {
					grid_width,
					entry_height,
				}
			end,
			pass_template = {
				{
					pass_type = "text",
					value = "n/a",
					value_id = "text",
					style = obtained_header_style,
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content

				content.element = element
				content.text = Localize("loc_item_source_obtained_title")
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				return
			end,
		},
		obtained_label = {
			size = {
				grid_width,
				114,
			},
			size_function = function (parent, element, ui_renderer)
				local label = element.label or ""
				local label_height = _style_text_height(label, obtained_label_style, ui_renderer)
				local entry_height = math.max(0, label_height + 8)

				return {
					grid_width,
					entry_height,
				}
			end,
			pass_template = {
				{
					pass_type = "text",
					value = "n/a",
					value_id = "label",
					style = obtained_label_style,
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content

				content.element = element

				local label = element.label or ""

				content.label = label
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				return
			end,
		},
		achievement_description = {
			size = {
				grid_width,
				114,
			},
			size_function = function (parent, element, ui_renderer)
				local description = element.description or ""
				local description_height = _style_text_height(description, achievement_description_style, ui_renderer)
				local entry_height = math.max(0, description_height + 8)

				return {
					grid_width,
					entry_height,
				}
			end,
			pass_template = {
				_generate_background_pass(),
				{
					pass_type = "text",
					value = "n/a",
					value_id = "description",
					style = achievement_description_style,
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content

				content.element = element

				local description = element.description or ""

				content.description = description
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				return
			end,
		},
		weapon_skin_requirements = {
			size = {
				grid_width,
				114,
			},
			size_function = function (parent, element, ui_renderer)
				local item = element.item
				local text = Items.weapon_skin_requirement_text(item)
				local text_height = _style_text_height(text, weapon_skin_requirement_style, ui_renderer)
				local entry_height = math.max(0, text_height + 10)

				return {
					grid_width,
					entry_height,
				}
			end,
			pass_template = {
				{
					pass_type = "text",
					value = "n/a",
					value_id = "description",
					style = weapon_skin_requirement_style,
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content

				content.element = element

				local item = element.item
				local text = Items.weapon_skin_requirement_text(item)

				content.description = text
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				return
			end,
		},
		gear_requirements = {
			size = {
				grid_width,
				114,
			},
			size_function = function (parent, element, ui_renderer)
				local item = element.item
				local text = Items.class_requirement_text(item)
				local text_height = _style_text_height(text, weapon_skin_requirement_style, ui_renderer)
				local entry_height = math.max(0, text_height + 10)

				return {
					grid_width,
					entry_height,
				}
			end,
			pass_template = {
				{
					pass_type = "text",
					value = "n/a",
					value_id = "description",
					style = weapon_skin_requirement_style,
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content

				content.element = element

				local item = element.item
				local text = Items.class_requirement_text(item)

				content.description = text
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				return
			end,
		},
		gear_requirement_header = {
			size = {
				grid_width,
				36,
			},
			size_function = function (parent, element, ui_renderer)
				local item = element.item
				local text = Localize("loc_item_equippable_on_header")
				local text_height = _style_text_height(text, weapon_skin_requirement_header_style, ui_renderer)
				local entry_height = math.max(0, text_height + 10)

				weapon_skin_requirement_header_style.size[2] = entry_height

				return {
					grid_width,
					entry_height,
				}
			end,
			pass_template = {
				{
					pass_type = "text",
					value = "n/a",
					value_id = "text",
					style = weapon_skin_requirement_header_style,
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content

				content.element = element

				local item = element.item

				content.text = Localize("loc_item_equippable_on_header")
			end,
		},
		weapon_skin_requirement_header = {
			size = {
				grid_width,
				36,
			},
			size_function = function (parent, element, ui_renderer)
				local item = element.item
				local text = Localize("loc_item_equippable_on_header")
				local text_height = _style_text_height(text, weapon_skin_requirement_header_style, ui_renderer)
				local entry_height = math.max(0, text_height + 10)

				weapon_skin_requirement_header_style.size[2] = entry_height

				return {
					grid_width,
					entry_height,
				}
			end,
			pass_template = {
				{
					pass_type = "text",
					value = "n/a",
					value_id = "text",
					style = weapon_skin_requirement_header_style,
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content

				content.element = element

				local item = element.item

				content.text = Localize("loc_item_equippable_on_header")
			end,
		},
		special_description = {
			size = {
				grid_width,
				114,
			},
			size_function = function (parent, element, ui_renderer)
				local data = element.data
				local special_description = data.desc and Localize(data.desc) or ""
				local special_description_height = _style_text_height(special_description, special_description_style, ui_renderer)
				local entry_height = math.max(0, special_description_height)

				return {
					grid_width,
					entry_height,
				}
			end,
			pass_template = {
				{
					pass_type = "text",
					value = "N/A",
					value_id = "special_description",
					style = special_description_style,
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content

				content.element = element

				local data = element.data

				content.special_description = data.desc and Localize(data.desc) or ""
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				return
			end,
		},
		header = {
			size = {
				grid_width,
				40,
			},
			pass_template = {
				{
					pass_type = "text",
					value = "n/a",
					value_id = "header",
					style = weapon_display_name_header_style,
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content

				content.element = element

				local header = element.header or "missing_header"

				content.header = header
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				return
			end,
		},
		weapon_attack_info = {
			size = {
				grid_width,
				32,
			},
			pass_template = {
				{
					pass_type = "texture",
					value = "content/ui/materials/icons/traits/empty",
					value_id = "icon",
					style = {
						vertical_alignment = "center",
						size = {
							32,
							32,
						},
						offset = {
							10,
							0,
							0,
						},
						color = Color.ui_brown_light(255, true),
					},
				},
				{
					pass_type = "text",
					value = "n/a",
					value_id = "text",
					style = weapon_attack_info_style,
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content

				content.element = element

				local data = element.data
				local display_name = data.display_name

				content.text = Localize(display_name)

				local attack_type = data.type
				local icon = UISettings.weapon_action_type_icons[attack_type]

				if icon then
					content.icon = icon
				end
			end,
		},
		weapon_attack_info_ranged = {
			size = {
				grid_width,
				42,
			},
			pass_template = {
				{
					pass_type = "texture",
					value = "content/ui/materials/icons/traits/empty",
					value_id = "icon",
					style = {
						vertical_alignment = "center",
						size = {
							32,
							32,
						},
						offset = {
							10,
							0,
							0,
						},
						color = Color.ui_brown_light(255, true),
					},
				},
				{
					pass_type = "texture",
					value = "content/ui/materials/base/ui_default_base",
					value_id = "icon2",
					style = {
						vertical_alignment = "center",
						size = {
							32,
							10,
						},
						offset = {
							10,
							20,
							0,
						},
						color = Color.ui_brown_light(255, true),
					},
					visibility_function = function (content, style)
						return content.icon2
					end,
				},
				{
					pass_type = "text",
					value = "n/a",
					value_id = "text",
					style = table.merge_recursive(table.clone(weapon_attack_info_style), {
						offset = {
							nil,
							4,
						},
					}),
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content

				content.element = element

				local data = element.data
				local attack_type = data.type
				local icon = UISettings.weapon_action_type_icons[attack_type] or "content/ui/materials/base/ui_default_base"

				if icon then
					content.icon = icon
				end

				local attack_fire_mode = data.fire_mode
				local icon2 = UISettings.weapon_fire_type_icons[attack_fire_mode]
				local fire_mode_prefix_key = UISettings.weapon_fire_type_display_text[attack_fire_mode]

				content.icon2 = icon2

				local display_name = data.display_name
				local text = Localize(display_name)

				if fire_mode_prefix_key then
					text = text .. " • " .. Localize(fire_mode_prefix_key)
				end

				content.text = text
			end,
		},
		weapon_attack_header = {
			size = {
				grid_width,
				30,
			},
			pass_template = {
				{
					pass_type = "text",
					style_id = "text",
					value = "n/a",
					value_id = "text",
					style = weapon_attack_header_style,
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				local style = widget.style

				content.element = element

				local display_name = element.display_name

				if Managers.localization:exists(display_name) then
					content.text = Localize(display_name)
				else
					content.text = ""
				end

				local text_color = element.text_color

				style.text.text_color = text_color or style.text.text_color
			end,
		},
		divider = {
			size = {
				grid_width,
				12,
			},
			pass_template = {
				{
					pass_type = "texture",
					style_id = "rating_divider",
					value = "content/ui/materials/dividers/divider_line_01",
					value_id = "rating_divider",
					style = {
						horizontal_alignemt = "center",
						vertical_alignment = "center",
						size = {
							nil,
							2,
						},
						offset = {
							0,
							0,
							3,
						},
						color = Color.terminal_frame(128, true),
					},
				},
			},
		},
		extended_weapon_keywords = {
			size = {
				grid_width,
				0,
			},
			size_function = function (parent, element, ui_renderer)
				local item = element.item
				local weapon_template = WeaponTemplate.weapon_template_from_item(item)
				local entry_height = 0
				local displayed_keywords = weapon_template.displayed_keywords

				for i = 1, #displayed_keywords do
					local display_name = displayed_keywords[i].display_name
					local description = displayed_keywords[i].description

					if description then
						description = Localize(description)
					else
						description = Localize(display_name .. "_mouseover")
					end

					local keyword_height = _style_text_height(description, weapon_keyword_desc_style, ui_renderer)

					entry_height = entry_height < keyword_height and keyword_height or entry_height
				end

				return {
					grid_width,
					entry_height + 45,
				}
			end,
			pass_template = {
				{
					pass_type = "text",
					style_id = "header_1",
					value = "N/A",
					value_id = "header_1",
					style = table.merge_recursive(table.clone(weapon_keyword_expanded_header_style), {
						offset = {
							10,
							10,
							0,
						},
						text_color = Color.white(0, true),
					}),
				},
				{
					pass_type = "text",
					style_id = "desc_1",
					value = "N/A",
					value_id = "desc_1",
					style = table.merge_recursive(table.clone(weapon_keyword_desc_style), {
						offset = {
							10,
							45,
							0,
						},
						text_color = Color.terminal_text_body_dark(0, true),
					}),
				},
				{
					pass_type = "text",
					style_id = "header_2",
					value = "N/A",
					value_id = "header_2",
					style = table.merge_recursive(table.clone(weapon_keyword_expanded_header_style), {
						offset = {
							300,
							10,
							0,
						},
						text_color = Color.white(0, true),
					}),
				},
				{
					pass_type = "text",
					style_id = "desc_2",
					value = "N/A",
					value_id = "desc_2",
					style = table.merge_recursive(table.clone(weapon_keyword_desc_style), {
						offset = {
							300,
							45,
							0,
						},
						text_color = Color.terminal_text_body_dark(0, true),
					}),
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				local style = widget.style
				local item = element.item
				local weapon_template = WeaponTemplate.weapon_template_from_item(item)
				local displayed_keywords = weapon_template.displayed_keywords

				for i = 1, #displayed_keywords do
					local display_name = displayed_keywords[i].display_name

					content["header_" .. i] = Localize(display_name)
					style["header_" .. i].text_color[1] = 255

					local description = displayed_keywords[i].description

					if description then
						content["desc_" .. i] = Localize(description)
					else
						local desc_id = display_name .. "_mouseover"

						content["desc_" .. i] = Managers.localization:exists(desc_id) and Localize(desc_id) or ""
					end

					style["desc_" .. i].text_color[1] = 255
				end

				content.element = element
			end,
		},
		bar_breakdown_info = {
			size = {
				grid_width - 10,
				70,
			},
			pass_template = {
				{
					pass_type = "text",
					style_id = "information",
					value_id = "information",
					value = Localize("loc_tutorial_weapons_text_03"),
					style = table.merge_recursive(table.clone(rating_value_style), {
						font_size = 18,
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
						offset = {
							20,
							-5,
							1,
						},
						text_color = Color.ui_chalk_grey(255, true),
					}),
				},
			},
		},
		extended_weapon_stats_header = {
			size = {
				grid_width,
				80,
			},
			size_function = function (parent, element, ui_renderer)
				local item = element.item
				local item_description = item.description
				local entry_height = 0
				local desciption_height = _style_text_height(Localize(item_description), weapon_description_desc_style, ui_renderer)

				entry_height = desciption_height or entry_height

				return {
					grid_width,
					entry_height + 80,
				}
			end,
			pass_template = {
				{
					pass_type = "text",
					style_id = "display_name",
					value = "N/A",
					value_id = "display_name",
					style = table.merge_recursive(table.clone(weapon_display_name_header_style), {
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
						size = {
							1920,
							100,
						},
					}),
				},
				{
					pass_type = "text",
					style_id = "sub_display_name",
					value = "N/A",
					value_id = "sub_display_name",
					style = table.merge_recursive(table.clone(weapon_rarity_header_style), {
						font_size = 25,
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
					}),
				},
				{
					pass_type = "text",
					style_id = "rarity_name",
					value = "N/A",
					value_id = "rarity_name",
					style = table.merge_recursive(table.clone(weapon_rarity_header_style), {
						font_size = 25,
						text_horizontal_alignment = "right",
						text_vertical_alignment = "top",
						offset = {
							0,
							0,
							3,
						},
					}),
				},
				{
					pass_type = "text",
					style_id = "text_description",
					value = "N/A",
					value_id = "text_description",
					style = table.merge_recursive(table.clone(weapon_description_desc_style), {
						offset = {
							10,
							75,
							6,
						},
						text_color = Color.terminal_text_body_dark(0, true),
					}),
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				local style = widget.style
				local item = element.item
				local rarity_color, rarity_color_dark = Items.rarity_color(item)

				content.element = element
				content.display_name = Items.weapon_card_display_name(item)
				content.sub_display_name = Items.weapon_card_sub_display_name(item)
				content.rarity_name = Items.rarity_display_name(item)
				style.rarity_name.text_color = table.clone(rarity_color)

				local item_description = item.description

				if item_description then
					content.text_description = Localize(item_description)
					style.text_description.text_color[1] = 255
				end
			end,
		},
		extended_weapon_stats = {
			size = {
				grid_width,
				195,
			},
			pass_template = {
				{
					pass_type = "text",
					style_id = "text_rating_icon",
					value = "",
					value_id = "text_rating_icon",
					style = table.merge_recursive(table.clone(rating_icon_style), {
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
						offset = {
							10,
							10,
							6,
						},
						text_color = Color.white(255, true),
					}),
					visibility_function = function (content, style)
						return content.text_rating_value ~= ""
					end,
				},
				{
					pass_type = "text",
					style_id = "text_rating",
					value = "N/A",
					value_id = "text_rating_value",
					style = table.merge_recursive(table.clone(rating_value_style), {
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
						offset = {
							90,
							35,
							6,
						},
						text_color = Color.white(255, true),
					}),
				},
				{
					pass_type = "text",
					style_id = "text_rating_header",
					value_id = "text_rating_header_value",
					value = Localize("loc_item_information_item_level"),
					style = table.merge_recursive(table.clone(rating_icon_style), {
						font_size = 20,
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
						offset = {
							90,
							17,
							6,
						},
						text_color = Color.white(255, true),
					}),
					visibility_function = function (content, style)
						return content.text_rating_value ~= ""
					end,
				},
				{
					pass_type = "text",
					style_id = "text_action_header_1",
					value = "N/A",
					value_id = "text_action_header_1_value",
					style = table.merge_recursive(table.clone(rating_icon_style), {
						font_size = 20,
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
						offset = {
							240,
							32,
							6,
						},
						text_color = Color.white(0, true),
					}),
				},
				{
					pass_type = "text",
					style_id = "text_action_1",
					value = "N/A",
					value_id = "text_action_1_value",
					style = table.merge_recursive(table.clone(rating_value_style), {
						font_size = 40,
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
						offset = {
							240,
							52,
							6,
						},
						text_color = Color.white(0, true),
					}),
				},
				{
					pass_type = "text",
					style_id = "text_action_header_2",
					value = "N/A",
					value_id = "text_action_header_2_value",
					style = table.merge_recursive(table.clone(rating_icon_style), {
						font_size = 20,
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
						offset = {
							390,
							32,
							6,
						},
						text_color = Color.white(0, true),
					}),
				},
				{
					pass_type = "text",
					style_id = "text_action_2",
					value = "N/A",
					value_id = "text_action_2_value",
					style = table.merge_recursive(table.clone(rating_value_style), {
						font_size = 40,
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
						offset = {
							390,
							52,
							6,
						},
						text_color = Color.white(0, true),
					}),
				},
				{
					pass_type = "texture",
					style_id = "rating_divider",
					value = "content/ui/materials/dividers/divider_line_01",
					value_id = "rating_divider",
					style = {
						size = {
							nil,
							2,
						},
						offset = {
							0,
							110,
							3,
						},
						color = Color.terminal_frame(128, true),
					},
				},
				{
					pass_type = "text",
					style_id = "text_stat_header_1",
					value = "N/A",
					value_id = "text_stat_header_1_value",
					style = table.merge_recursive(table.clone(rating_icon_style), {
						font_size = 15,
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
						offset = {
							10,
							125,
							6,
						},
						text_color = Color.white(0, true),
					}),
				},
				{
					pass_type = "text",
					style_id = "text_stat_1",
					value = "N/A",
					value_id = "text_stat_1_value",
					style = table.merge_recursive(table.clone(rating_value_style), {
						font_size = 25,
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
						offset = {
							10,
							145,
							6,
						},
						text_color = Color.white(0, true),
					}),
				},
				{
					pass_type = "text",
					style_id = "text_stat_header_2",
					value = "N/A",
					value_id = "text_stat_header_2_value",
					style = table.merge_recursive(table.clone(rating_icon_style), {
						font_size = 15,
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
						offset = {
							160,
							125,
							6,
						},
						text_color = Color.white(0, true),
					}),
				},
				{
					pass_type = "text",
					style_id = "text_stat_2",
					value = "N/A",
					value_id = "text_stat_2_value",
					style = table.merge_recursive(table.clone(rating_value_style), {
						font_size = 25,
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
						offset = {
							160,
							145,
							6,
						},
						text_color = Color.white(0, true),
					}),
				},
				{
					pass_type = "text",
					style_id = "text_stat_header_3",
					value = "N/A",
					value_id = "text_stat_header_3_value",
					style = table.merge_recursive(table.clone(rating_icon_style), {
						font_size = 15,
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
						offset = {
							310,
							125,
							6,
						},
						text_color = Color.white(0, true),
					}),
				},
				{
					pass_type = "text",
					style_id = "text_stat_3",
					value = "N/A",
					value_id = "text_stat_3_value",
					style = table.merge_recursive(table.clone(rating_value_style), {
						font_size = 25,
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
						offset = {
							310,
							145,
							6,
						},
						text_color = Color.white(0, true),
					}),
				},
				{
					pass_type = "text",
					style_id = "text_stat_header_4",
					value = "N/A",
					value_id = "text_stat_header_4_value",
					style = table.merge_recursive(table.clone(rating_icon_style), {
						font_size = 15,
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
						offset = {
							460,
							125,
							6,
						},
						text_color = Color.white(0, true),
					}),
				},
				{
					pass_type = "text",
					style_id = "text_stat_4",
					value = "N/A",
					value_id = "text_stat_4_value",
					style = table.merge_recursive(table.clone(rating_value_style), {
						font_size = 25,
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
						offset = {
							460,
							145,
							6,
						},
						text_color = Color.white(0, true),
					}),
				},
				{
					pass_type = "texture",
					style_id = "stats_divider",
					value = "content/ui/materials/dividers/divider_line_01",
					value_id = "stats_divider",
					style = {
						size = {
							nil,
							2,
						},
						offset = {
							0,
							190,
							3,
						},
						color = Color.terminal_frame(128, true),
					},
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				local style = widget.style
				local item = element.item
				local is_ranged_weapon = Items.is_weapon_template_ranged(item)
				local weapon_template = WeaponTemplate.weapon_template_from_item(item)
				local rating_value, has_rating = Items.expertise_level(item, true)
				local weapon_stats = WeaponStats:new(item)
				local advanced_weapon_stats = weapon_stats._weapon_statistics
				local power_stats = advanced_weapon_stats.power_stats
				local stats = advanced_weapon_stats.stats

				if Items.is_weapon(item.item_type) then
					content.text_rating_header_value = Localize("loc_item_information_power")
				end

				content.element = element
				content.text_rating_value = has_rating and rating_value or ""

				if power_stats then
					for i = 1, #power_stats do
						local power_stat = power_stats[i]
						local attack = power_stat.attack or 0
						local type_data = power_stat.type_data
						local display_name = type_data.display_name or "N/A"

						content["text_action_header_" .. i .. "_value"] = Localize(display_name)
						content["text_action_" .. i .. "_value"] = math.floor(attack + 0.5)
						style["text_action_header_" .. i].text_color[1] = 255
						style["text_action_" .. i].text_color[1] = 255
					end
				end

				if stats then
					local is_staff_weapon = table.contains(weapon_template.keywords, "force_staff")
					local main_stats = weapon_stats:get_main_stats()

					if is_staff_weapon then
						content.text_stat_header_1_value = Localize("loc_weapon_stat_title_ammo")
						content.text_stat_1_value = Localize("loc_weapon_stats_display_unlimited")
						style.text_stat_header_1.text_color[1] = 255
						style.text_stat_1.text_color[1] = 255

						local rate_of_fire = main_stats.rate_of_fire

						content.text_stat_header_2_value = Localize("loc_weapon_stats_display_rate_of_fire")
						content.text_stat_2_value = string.format("%.2f/s", 1 / rate_of_fire)
						style.text_stat_header_2.text_color[1] = 255
						style.text_stat_2.text_color[1] = 255

						local charge_duration = main_stats.charge_duration or 0

						content.text_stat_header_3_value = Localize("loc_weapon_stats_display_charge_speed")
						content.text_stat_3_value = string.format("%.2fs", charge_duration)
						style.text_stat_header_3.text_color[1] = 255
						style.text_stat_3.text_color[1] = 255
						content.text_stat_header_4_value = Localize("loc_stats_display_stamina_title")
						content.text_stat_4_value = _stat_value_to_text(stats.stamina)
						style.text_stat_header_4.text_color[1] = 255
						style.text_stat_4.text_color[1] = 255
					elseif is_ranged_weapon then
						local ammo_clip = _stat_value_to_text(stats.ammo_clip, true)
						local ammo_reserve = _stat_value_to_text(stats.ammo_reserve, true)

						content.text_stat_header_1_value = Localize("loc_weapon_stat_title_ammo")
						content.text_stat_1_value = ammo_clip .. "/" .. ammo_reserve
						style.text_stat_header_1.text_color[1] = 255
						style.text_stat_1.text_color[1] = 255

						local rate_of_fire = main_stats.rate_of_fire

						content.text_stat_header_2_value = Localize("loc_weapon_stats_display_rate_of_fire")
						content.text_stat_2_value = string.format("%.2f/s", 1 / rate_of_fire)
						style.text_stat_header_2.text_color[1] = 255
						style.text_stat_2.text_color[1] = 255

						local reload_time = main_stats.reload_time

						content.text_stat_header_3_value = Localize("loc_basic_reload_input")
						content.text_stat_3_value = string.format("%.2fs", reload_time)
						style.text_stat_header_3.text_color[1] = 255
						style.text_stat_3.text_color[1] = 255

						local stamina = stats.stamina

						content.text_stat_header_4_value = Localize("loc_stats_display_stamina_title")
						content.text_stat_4_value = _stat_value_to_text(stamina)
						style.text_stat_header_4.text_color[1] = 255
						style.text_stat_4.text_color[1] = 255
					else
						content.text_stat_header_1_value = Localize("loc_weapon_stats_display_sprint_speed")

						local sprint_speed = stats.sprint_speed

						content.text_stat_1_value = _stat_value_to_text(sprint_speed)
						style.text_stat_header_1.text_color[1] = 255
						style.text_stat_1.text_color[1] = 255
						content.text_stat_header_2_value = Localize("loc_weapon_stats_display_dodge_distance")

						local dodge_distance = stats.dodge_distance

						content.text_stat_2_value = _stat_value_to_text(dodge_distance)
						style.text_stat_header_2.text_color[1] = 255
						style.text_stat_2.text_color[1] = 255
						content.text_stat_header_3_value = Localize("loc_weapon_stats_display_effective_dodges")

						local effective_dodges = stats.effective_dodges

						content.text_stat_3_value = _stat_value_to_text(effective_dodges)
						style.text_stat_header_3.text_color[1] = 255
						style.text_stat_3.text_color[1] = 255

						local stamina = stats.stamina

						content.text_stat_header_4_value = Localize("loc_stats_display_stamina_title")
						content.text_stat_4_value = _stat_value_to_text(stamina)
						style.text_stat_header_4.text_color[1] = 255
						style.text_stat_4.text_color[1] = 255
					end
				end
			end,
		},
		weapon_stat = {
			size = {
				grid_width,
				30,
			},
			pass_template = {
				{
					pass_type = "texture",
					value = "content/ui/materials/icons/objectives/secondary",
					style = {
						horizontal_alignment = "left",
						vertical_alignment = "top",
						size = {
							15,
							15,
						},
						offset = {
							20,
							3,
							0,
						},
						color = Color.terminal_icon(255, true),
					},
				},
				{
					pass_type = "text",
					style_id = "text",
					value = "N/A",
					value_id = "text",
					style = table.merge_recursive(table.clone(weapon_perk_style), {
						horizontal_alignment = "left",
						text_vertical_alignment = "top",
						offset = {
							40,
							0,
							3,
						},
					}),
				},
			},
			init = function (parent, widget, element)
				local content = widget.content
				local style = widget.style
				local stat = element.stat
				local type_data = stat.type_data
				local display_name = type_data.display_name or ""
				local display_type = type_data.display_type or "default"
				local signed = type_data.signed
				local display_units = type_data.display_units or ""
				local stat_value = stat.value

				if display_type == "multiplier" then
					stat_value = (stat_value - 1) * 100
				elseif display_type == "inverse_multiplier" then
					stat_value = (1 - 1 / stat_value) * 100
				elseif display_type == "inverse_percentage" then
					stat_value = (1 / stat_value - 1) * 100
				elseif display_type == "percentage" then
					stat_value = stat_value * 100
				end

				local value = signed and stat_value or stat_value * math.sign(stat_value)

				if value >= math.huge then
					value = Localize("loc_weapon_stats_display_unlimited")
				elseif signed and value >= 0 then
					value = string.format("+%.2f", value) .. display_units
				else
					value = string.format("%.2f", value) .. display_units
				end

				value = Text.apply_color_to_text(value, Color.terminal_icon(255, true))
				content.text = string.format(" %s: %s", Localize(display_name), value)
			end,
		},
		attack_pattern_header = {
			size = {
				grid_width,
				210,
			},
			pass_template = _generate_attack_pattern_passes(optional_item),
			init = function (parent, widget, element)
				local content = widget.content
				local style = widget.style
				local item = element.item

				content.item = item

				local weapon_template = WeaponTemplate.weapon_template_from_item(item)
				local displayed_attacks = weapon_template.displayed_attacks

				if displayed_attacks then
					local is_ranged_weapon = Items.is_weapon_template_ranged(item)
					local weapon_action_title_display_names = is_ranged_weapon and UISettings.weapon_action_title_display_names or UISettings.weapon_action_title_display_names_melee
					local weapon_action_display_order_array = UISettings.weapon_action_display_order_array
					local num_elements = 0

					for index, key in ipairs(weapon_action_display_order_array) do
						local data = displayed_attacks[key]

						if data then
							num_elements = num_elements + 1
						end
					end

					local width = num_elements < 4 and grid_width - 100 or grid_width
					local step = width / num_elements
					local offset_index = 1

					for index, key in ipairs(weapon_action_display_order_array) do
						local data = displayed_attacks[key]

						if data then
							local id = "header_" .. index
							local display_name = weapon_action_title_display_names[key]

							if Managers.localization:exists(display_name) then
								content[id] = Localize(display_name)
							else
								content[id] = ""
							end

							local header_style = style[id]

							header_style.text_color[1] = 255
							header_style.offset[1] = -step * (num_elements - 1) * 0.5 + (offset_index - 1) * step

							local divider_id = "divider_" .. index
							local divider_style = style[divider_id]

							divider_style.color[1] = 128
							divider_style.offset[1] = -step * (num_elements - 1) * 0.5 + (offset_index - 1) * step - 10
							divider_style.size[1] = 200
							offset_index = offset_index + 1
						end
					end

					local attack_index, chain_index = 1, 1

					if parent.current_attack_index then
						attack_index, chain_index = parent:current_attack_index()
					end

					content.gamepad_selected_attack = 1

					local content_hotspot = content["icon_hotspot_" .. attack_index .. "_" .. chain_index]

					if content_hotspot then
						content_hotspot.is_selected = true

						_update_connection_line(attack_index, chain_index, attack_index, chain_index, content, style)
					end
				end
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				local content = widget.content
				local style = widget.style
				local item = content.item
				local weapon_template = WeaponTemplate.weapon_template_from_item(item)
				local is_ranged_weapon = Items.is_weapon_template_ranged(item)
				local displayed_attacks = weapon_template.displayed_attacks
				local gamepad_active = InputDevice.gamepad_active
				local gamepad_selected_attack = content.gamepad_selected_attack
				local parent_active = true

				if type(parent.is_active) == "function" then
					parent_active = parent:is_active()
				end

				if parent_active and displayed_attacks then
					local weapon_action_title_display_names = is_ranged_weapon and UISettings.weapon_action_title_display_names or UISettings.weapon_action_title_display_names_melee
					local weapon_action_display_order_array = UISettings.weapon_action_display_order_array
					local num_elements = #weapon_action_display_order_array
					local attack_index, chain_index = 1, 1

					if parent.current_attack_index then
						attack_index, chain_index = parent:current_attack_index()
					end

					local horizontal_index = 1

					if gamepad_active then
						if input_service:get("navigate_primary_left_pressed") or input_service:get("navigate_left_continuous") then
							gamepad_selected_attack = gamepad_selected_attack - 1
						elseif input_service:get("navigate_primary_right_pressed") or input_service:get("navigate_right_continuous") then
							gamepad_selected_attack = gamepad_selected_attack + 1
						end
					else
						gamepad_selected_attack = 1
					end

					for index, key in ipairs(weapon_action_display_order_array) do
						local data = displayed_attacks[key]

						if data then
							if data.attack_chain then
								for i = 1, #data.attack_chain do
									local hotspot = content["icon_hotspot_" .. index .. "_" .. i]
									local hotspot_selected = hotspot and (gamepad_active and horizontal_index == gamepad_selected_attack or hotspot.on_pressed)

									if hotspot_selected and parent.set_current_attack_index then
										parent:set_current_attack_index(index, i)

										hotspot.is_selected = true

										_update_connection_line(attack_index, chain_index, index, i, content, style)
									end

									horizontal_index = horizontal_index + 1
								end
							else
								local hotspot = content["icon_hotspot_" .. index .. "_1"]
								local hotspot_selected = hotspot and (gamepad_active and horizontal_index == gamepad_selected_attack or hotspot.on_pressed)

								if hotspot_selected and parent.set_current_attack_index then
									parent:set_current_attack_index(index, 1)

									hotspot.is_selected = true

									_update_connection_line(attack_index, chain_index, index, 1, content, style)
								end

								horizontal_index = horizontal_index + 1
							end
						end
					end

					content.gamepad_selected_attack = math.clamp(gamepad_selected_attack, 1, horizontal_index - 1)
				end
			end,
		},
		pattern_type_breakdown = {
			size = {
				grid_width,
				180,
			},
			pass_template = {
				{
					pass_type = "texture",
					style_id = "tile_top",
					value = "content/ui/materials/frames/frame_tile_1px",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "top",
						size = {
							grid_width - 45,
							150,
						},
						offset = {
							0,
							0,
							0,
						},
						color = Color.terminal_text_body_dark(255, true),
					},
				},
				{
					pass_type = "texture",
					style_id = "corner_top",
					value = "content/ui/materials/frames/frame_corner_2px",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "top",
						size = {
							grid_width - 45,
							150,
						},
						offset = {
							0,
							0,
							1,
						},
						color = Color.terminal_text_body_dark(255, true),
					},
				},
				{
					pass_type = "texture",
					style_id = "tile_bottom",
					value = "content/ui/materials/frames/frame_tile_1px",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "top",
						size = {
							grid_width - 45,
							35,
						},
						offset = {
							0,
							115,
							2,
						},
						color = Color.terminal_text_body_dark(255, true),
					},
				},
				{
					pass_type = "texture",
					style_id = "corner_bottom",
					value = "content/ui/materials/frames/frame_corner_2px",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "top",
						size = {
							grid_width - 45,
							35,
						},
						offset = {
							0,
							115,
							3,
						},
						color = Color.terminal_text_body_dark(255, true),
					},
				},
				{
					pass_type = "texture",
					style_id = "detailed_bottom",
					value = "content/ui/materials/frames/line_thin_detailed_01",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "top",
						size = {
							grid_width - 35,
							160,
						},
						offset = {
							0,
							-5,
							0,
						},
						color = Color.terminal_text_body_dark(255, true),
					},
				},
				{
					pass_type = "texture",
					style_id = "attack_type_icon",
					value_id = "attack_type_icon",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "top",
						size = {
							32,
							32,
						},
						offset = {
							-16,
							16,
							0,
						},
						color = Color.white(255, true),
					},
					visibility_function = function (content, style)
						return content.attack_type_icon
					end,
				},
				{
					pass_type = "text",
					style_id = "attack_type_name",
					value_id = "attack_type_name",
					style = table.merge_recursive(table.clone(weapon_attack_type_display_name_header_style), {
						font_size = 20,
						text_horizontal_alignment = "center",
						text_vertical_alignment = "top",
						offset = {
							0,
							20,
							0,
						},
						text_color = Color.white(0, true),
					}),
				},
				{
					pass_type = "text",
					style_id = "attack_type_desc",
					value_id = "attack_type_desc",
					style = table.merge_recursive(table.clone(weapon_attack_type_desc_style), {
						font_size = 20,
						text_horizontal_alignment = "center",
						text_vertical_alignment = "top",
						offset = {
							40,
							60,
							0,
						},
					}),
				},
				{
					pass_type = "text",
					style_id = "extra_information",
					value = "",
					value_id = "extra_information",
					style = table.merge_recursive(table.clone(weapon_attack_type_desc_style), {
						font_size = 20,
						text_horizontal_alignment = "center",
						text_vertical_alignment = "top",
						offset = {
							40,
							120,
							0,
						},
						text_color = Color.terminal_text_body_dark(255, true),
					}),
				},
			},
			init = function (parent, widget, element)
				local content = widget.content

				content.item = element.item
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				_update_pattern_type(widget, parent, ui_renderer)
			end,
		},
		damage_grid = {
			size = {
				grid_width,
				430,
			},
			pass_template = _generate_damage_grid_pass_templates({
				140,
				60,
			}, optional_item),
			init = function (parent, widget, element)
				local content = widget.content
				local style = widget.style
				local item = element.item

				content.item = item

				local weapon_stats = WeaponStats:new(item)

				content.weapon_stats = weapon_stats
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				local content = widget.content
				local style = widget.style
				local index = 1
				local x_hover, y_hover
				local hotspot_content = content["hotspot_" .. index]

				while hotspot_content do
					local x = hotspot_content.x
					local y = hotspot_content.y
					local is_hover = hotspot_content.is_hover

					x_hover = is_hover and x or x_hover
					y_hover = is_hover and y or y_hover

					local border_style = style["hover_frame_border_" .. x .. "_" .. y]
					local corner_style = style["hover_frame_corner_" .. x .. "_" .. y]
					local bg_style = style["hover_bg_" .. x .. "_" .. y]
					local x_header = style["x_axis_header_" .. x]
					local y_header = style["y_axis_header_" .. y]

					border_style.color = is_hover and border_style.selected_color or border_style.base_color
					corner_style.color = is_hover and corner_style.selected_color or corner_style.base_color
					bg_style.color[1] = is_hover and 128 or 0
					x_header.text_color = (is_hover or x == x_hover) and x_header.selected_text_color or x_header.base_text_color
					y_header.text_color = (is_hover or y == y_hover) and y_header.selected_text_color or y_header.base_text_color
					index = index + 1
					hotspot_content = content["hotspot_" .. index]
				end

				local weapon_stats = content.weapon_stats
				local advanced_weapon_stats = weapon_stats._weapon_statistics
				local damage_stats = advanced_weapon_stats.damage

				if damage_stats then
					local attack_index, chain_index = 1, 1

					if parent.current_attack_index then
						attack_index, chain_index = parent:current_attack_index()
					end

					_update_damage_data(damage_stats, widget, attack_index, chain_index)
				end
			end,
		},
		weapon_attack_chain = {
			size = {
				grid_width,
				50,
			},
			pass_template = {
				{
					pass_type = "rect",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "center",
						offset = {
							0,
							0,
							0,
						},
						color = Color.ui_brown_light(20, true),
						size_addition = {
							-20,
							-10,
						},
					},
				},
				{
					content_id = "hotspot_icon_1",
					pass_type = "hotspot",
					style_id = "hotspot_icon_1",
					content = default_button_content,
					style = {
						vertical_alignment = "center",
						offset = {
							0,
							0,
							0,
						},
						size = {
							32,
							32,
						},
					},
				},
				{
					pass_type = "texture",
					style_id = "icon_1",
					value = "content/ui/materials/icons/traits/empty",
					value_id = "icon_1",
					style = {
						horizontal_alignment = "left",
						vertical_alignment = "center",
						size = {
							32,
							32,
						},
						offset = {
							0,
							0,
							1,
						},
						color = Color.ui_brown_light(255, true),
					},
					visibility_function = function (content, style)
						return content.icon_1
					end,
				},
				{
					content_id = "hotspot_icon_2",
					pass_type = "hotspot",
					style_id = "hotspot_icon_2",
					content = default_button_content,
					style = {
						vertical_alignment = "center",
						offset = {
							0,
							0,
							0,
						},
						size = {
							32,
							32,
						},
					},
				},
				{
					pass_type = "texture",
					style_id = "icon_2",
					value = "content/ui/materials/icons/traits/empty",
					value_id = "icon_2",
					style = {
						horizontal_alignment = "left",
						vertical_alignment = "center",
						size = {
							32,
							32,
						},
						offset = {
							0,
							0,
							1,
						},
						color = Color.ui_brown_light(255, true),
					},
					visibility_function = function (content, style)
						return content.icon_2
					end,
				},
				{
					content_id = "hotspot_icon_3",
					pass_type = "hotspot",
					style_id = "hotspot_icon_3",
					content = default_button_content,
					style = {
						vertical_alignment = "center",
						offset = {
							0,
							0,
							0,
						},
						size = {
							32,
							32,
						},
					},
				},
				{
					pass_type = "texture",
					style_id = "icon_3",
					value = "content/ui/materials/icons/traits/empty",
					value_id = "icon_3",
					style = {
						horizontal_alignment = "left",
						vertical_alignment = "center",
						size = {
							32,
							32,
						},
						offset = {
							0,
							0,
							1,
						},
						color = Color.ui_brown_light(255, true),
					},
					visibility_function = function (content, style)
						return content.icon_3
					end,
				},
				{
					content_id = "hotspot_icon_4",
					pass_type = "hotspot",
					style_id = "hotspot_icon_4",
					content = default_button_content,
					style = {
						vertical_alignment = "center",
						offset = {
							0,
							0,
							0,
						},
						size = {
							32,
							32,
						},
					},
				},
				{
					pass_type = "texture",
					style_id = "icon_4",
					value = "content/ui/materials/icons/traits/empty",
					value_id = "icon_4",
					style = {
						horizontal_alignment = "left",
						vertical_alignment = "center",
						size = {
							32,
							32,
						},
						offset = {
							0,
							0,
							1,
						},
						color = Color.ui_brown_light(255, true),
					},
					visibility_function = function (content, style)
						return content.icon_4
					end,
				},
				{
					content_id = "hotspot_icon_5",
					pass_type = "hotspot",
					style_id = "hotspot_icon_5",
					content = default_button_content,
					style = {
						vertical_alignment = "center",
						offset = {
							0,
							0,
							0,
						},
						size = {
							32,
							32,
						},
					},
				},
				{
					pass_type = "texture",
					style_id = "icon_5",
					value = "content/ui/materials/icons/traits/empty",
					value_id = "icon_5",
					style = {
						horizontal_alignment = "left",
						vertical_alignment = "center",
						size = {
							32,
							32,
						},
						offset = {
							0,
							0,
							1,
						},
						color = Color.ui_brown_light(255, true),
					},
					visibility_function = function (content, style)
						return content.icon_5
					end,
				},
				{
					pass_type = "texture",
					style_id = "spacing_icon_1",
					value = "content/ui/materials/icons/generic/light_arrow",
					value_id = "spacing_icon_1",
					style = {
						horizontal_alignment = "left",
						vertical_alignment = "center",
						size = {
							8,
							14,
						},
						offset = {
							0,
							0,
							1,
						},
						color = Color.white(80, true),
					},
					visibility_function = function (content, style)
						return content.icon_2
					end,
				},
				{
					pass_type = "texture",
					style_id = "spacing_icon_2",
					value = "content/ui/materials/icons/generic/light_arrow",
					value_id = "spacing_icon_2",
					style = {
						horizontal_alignment = "left",
						vertical_alignment = "center",
						size = {
							8,
							14,
						},
						offset = {
							0,
							0,
							1,
						},
						color = Color.white(80, true),
					},
					visibility_function = function (content, style)
						return content.icon_3
					end,
				},
				{
					pass_type = "texture",
					style_id = "spacing_icon_3",
					value = "content/ui/materials/icons/generic/light_arrow",
					value_id = "spacing_icon_3",
					style = {
						horizontal_alignment = "left",
						vertical_alignment = "center",
						size = {
							8,
							14,
						},
						offset = {
							0,
							0,
							1,
						},
						color = Color.white(80, true),
					},
					visibility_function = function (content, style)
						return content.icon_4
					end,
				},
				{
					pass_type = "texture",
					style_id = "spacing_icon_4",
					value = "content/ui/materials/icons/generic/light_arrow",
					value_id = "spacing_icon_4",
					style = {
						horizontal_alignment = "left",
						vertical_alignment = "center",
						size = {
							8,
							14,
						},
						offset = {
							0,
							0,
							1,
						},
						color = Color.white(80, true),
					},
					visibility_function = function (content, style)
						return content.icon_5
					end,
				},
				{
					pass_type = "rect",
					style_id = "hover_bg",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "top",
						size = {
							grid_width - 45 + 60,
							100,
						},
						offset = {
							0,
							-100,
							5,
						},
						color = Color.black(0, true),
					},
				},
				{
					pass_type = "texture",
					style_id = "hover_frame",
					value = "content/ui/materials/frames/frame_tile_1px",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "top",
						size = {
							grid_width - 45 + 60,
							100,
						},
						offset = {
							0,
							-100,
							5,
						},
						color = Color.terminal_text_body_dark(0, true),
					},
				},
				{
					pass_type = "texture",
					style_id = "hover_frame_corner",
					value = "content/ui/materials/frames/frame_corner_2px",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "top",
						size = {
							grid_width - 45 + 60,
							100,
						},
						offset = {
							0,
							-100,
							6,
						},
						color = Color.terminal_text_body_dark(0, true),
					},
				},
				{
					pass_type = "texture",
					style_id = "hover_inner_line",
					value = "content/ui/materials/frames/line_thin_detailed_01",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "top",
						size = {
							grid_width - 35 + 60,
							110,
						},
						offset = {
							0,
							-105,
							5,
						},
						color = Color.terminal_text_body_dark(0, true),
					},
				},
				{
					pass_type = "texture",
					style_id = "hover_icon",
					value_id = "hover_icon",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "top",
						size = {
							32,
							32,
						},
						offset = {
							-16,
							-84,
							5,
						},
						color = Color.white(0, true),
					},
					visibility_function = function (content, style)
						return content.hover_icon
					end,
				},
				{
					pass_type = "text",
					style_id = "hover_icon_name",
					value_id = "hover_icon_name",
					style = table.merge_recursive(table.clone(weapon_attack_type_display_name_header_style), {
						font_size = 20,
						text_horizontal_alignment = "center",
						text_vertical_alignment = "top",
						offset = {
							0,
							-40,
							5,
						},
						text_color = Color.white(0, true),
					}),
				},
				{
					pass_type = "text",
					style_id = "hover_icon_desc",
					value_id = "hover_icon_desc",
					style = table.merge_recursive(table.clone(weapon_attack_type_desc_style), {
						font_size = 20,
						text_horizontal_alignment = "center",
						text_vertical_alignment = "bottom",
						vertical_alignment = "bottom",
						offset = {
							40,
							-60,
							5,
						},
					}),
				},
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				local style = widget.style

				content.element = element

				local attack_chain = element.attack_chain
				local num_attacks = #attack_chain
				local width_offset = 0
				local spacing = 50
				local icon_width = 32
				local spacing_icon_width = 8
				local start_width_offset = grid_width * 0.5 - ((num_attacks - 1) * spacing + num_attacks * icon_width) * 0.5

				for i = 1, 5 do
					local attack_type = attack_chain[i]
					local attack_icon = attack_type and UISettings.weapon_action_type_icons[attack_type]
					local hotspot_pass_id = "hotspot_icon_" .. i
					local pass_id = "icon_" .. i

					content[pass_id] = attack_icon

					local display_name = Localize(UISettings.attack_type_lookup[attack_type] or "Missing Attack Type")

					content["icon_name_" .. i] = display_name

					local desc_id = UISettings.attack_type_desc_lookup[attack_type]
					local desc = desc_id and Localize(desc_id) or ""

					content["desc_" .. i] = desc
					style.hover_bg.base_offset = table.clone(style.hover_bg.offset)
					style.hover_frame.base_offset = table.clone(style.hover_frame.offset)
					style.hover_frame_corner.base_offset = table.clone(style.hover_frame_corner.offset)
					style.hover_inner_line.base_offset = table.clone(style.hover_inner_line.offset)
					style.hover_icon.base_offset = table.clone(style.hover_icon.offset)
					style.hover_icon_name.base_offset = table.clone(style.hover_icon_name.offset)
					style.hover_bg.base_size = table.clone(style.hover_bg.size)
					style.hover_frame.base_size = table.clone(style.hover_frame.size)
					style.hover_frame_corner.base_size = table.clone(style.hover_frame_corner.size)
					style.hover_inner_line.base_size = table.clone(style.hover_inner_line.size)
					style.hover_icon_name.base_size = table.clone(style.hover_icon_name.size)

					if attack_icon then
						local pass_style = style[pass_id]
						local hotstpot_pass_style = style[hotspot_pass_id]

						pass_style.offset[1] = start_width_offset + width_offset
						hotstpot_pass_style.offset[1] = start_width_offset + width_offset
						width_offset = width_offset + icon_width + spacing

						if i < 5 then
							local spacing_pass_id = "spacing_icon_" .. i

							style[spacing_pass_id].offset[1] = pass_style.offset[1] + (icon_width * 2 + spacing) * 0.5 - spacing_icon_width * 0.5
						end
					end
				end
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				local content = widget.content
				local style = widget.style
				local hotspot_prefix = "hotspot_icon_"
				local icon_prefix = "icon_"
				local index = 1
				local is_hover = false
				local hotspot_content = content[hotspot_prefix .. index]

				while hotspot_content do
					local icon_style = style[icon_prefix .. index]

					if hotspot_content.is_hover then
						icon_style.color = Color.white(255, true)

						local icon_name = content["icon_name_" .. index]
						local icon = content["icon_" .. index]
						local description = content["desc_" .. index]
						local text_height = _style_text_height(description, style.hover_icon_desc, ui_renderer) + 20

						style.hover_bg.color[1] = 210
						style.hover_frame.color[1] = 255
						style.hover_frame_corner.color[1] = 255
						style.hover_inner_line.color[1] = 255
						style.hover_icon.color[1] = 255
						style.hover_icon_name.text_color[1] = 255
						style.hover_icon_desc.text_color[1] = 255
						content.hover_icon_name = icon_name
						content.hover_icon = icon
						content.hover_icon_desc = description
						style.hover_bg.offset[2] = style.hover_bg.base_offset[2] - text_height
						style.hover_frame.offset[2] = style.hover_frame.base_offset[2] - text_height
						style.hover_frame_corner.offset[2] = style.hover_frame_corner.base_offset[2] - text_height
						style.hover_inner_line.offset[2] = style.hover_inner_line.base_offset[2] - text_height
						style.hover_icon_name.offset[2] = style.hover_icon_name.base_offset[2] - text_height
						style.hover_icon.offset[2] = style.hover_icon.base_offset[2] - text_height
						style.hover_bg.size[2] = style.hover_bg.base_size[2] + text_height
						style.hover_frame.size[2] = style.hover_frame.base_size[2] + text_height
						style.hover_frame_corner.size[2] = style.hover_frame_corner.base_size[2] + text_height
						style.hover_inner_line.size[2] = style.hover_inner_line.base_size[2] + text_height
						style.hover_icon_name.size[2] = style.hover_icon_name.base_size[2] + text_height
						is_hover = true
					else
						icon_style.color = Color.ui_brown_light(255, true)
					end

					index = index + 1
					hotspot_content = content[hotspot_prefix .. index]
				end

				if not is_hover then
					style.hover_bg.color[1] = 0
					style.hover_frame.color[1] = 0
					style.hover_frame_corner.color[1] = 0
					style.hover_inner_line.color[1] = 0
					style.hover_icon.color[1] = 0
					style.hover_icon_name.text_color[1] = 0
					style.hover_icon_desc.text_color[1] = 0
				end
			end,
		},
		dynamic_spacing = {
			size = {
				0,
				0,
			},
			pass_template = {
				_generate_background_pass(),
			},
			init = function (parent, widget, element)
				local style = widget.style

				style.background.visible = not not element.add_background
			end,
			size_function = function (parent, config)
				return config.size
			end,
		},
		spacing_vertical = {
			size = {
				grid_width,
				20,
			},
		},
		spacing_vertical_small = {
			size = {
				grid_width,
				10,
			},
		},
	}

	return blueprints
end

return generate_blueprints_function
