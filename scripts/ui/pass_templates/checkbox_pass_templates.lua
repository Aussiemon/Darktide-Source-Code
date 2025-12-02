-- chunkname: @scripts/ui/pass_templates/checkbox_pass_templates.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIResolution = require("scripts/managers/ui/ui_resolution")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ListHeaderPassTemplates = require("scripts/ui/pass_templates/list_header_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local InputUtils = require("scripts/managers/input/input_utils")
local CheckboxPassTemplates = {}
local color_lerp = ColorUtilities.color_lerp
local color_copy = ColorUtilities.color_copy
local highlight_size_addition = ListHeaderPassTemplates.highlight_size_addition
local highlight_color_change_function = ListHeaderPassTemplates.list_highlight_color_change_function
local list_item_highight_focused_visibility_function = ListHeaderPassTemplates.list_item_highight_focused_visibility_function

local function list_item_highlight_change_function(content, style)
	local hotspot = content.hotspot
	local use_is_focused = hotspot.use_is_focused
	local focus_progress = use_is_focused and hotspot.anim_focus_progress or not use_is_focused and hotspot.anim_select_progress
	local progress = math.max(hotspot.anim_hover_progress, focus_progress)

	style.color[1] = 255 * math.easeOutCubic(progress)

	local size_addition = highlight_size_addition * math.easeInCubic(1 - progress)
	local style_size_addition = style.size_addition

	style_size_addition[1] = size_addition * 2
	style_size_addition[2] = size_addition * 2

	local offset = style.offset

	offset[1] = size_addition
	offset[2] = -size_addition
	style.hdr = progress == 1
end

local function terminal_button_change_function(content, style)
	local hotspot = content.hotspot
	local is_selected = hotspot.is_selected
	local is_focused = hotspot.is_focused
	local is_hover = hotspot.is_hover
	local disabled = hotspot.disabled
	local default_color = style.default_color
	local hover_color = style.hover_color
	local selected_color = style.selected_color
	local disabled_color = style.disabled_color
	local color

	if disabled and disabled_color then
		color = disabled_color
	elseif (is_selected or is_focused) and selected_color then
		color = selected_color
	elseif is_hover and hover_color then
		color = hover_color
	elseif default_color then
		color = default_color
	end

	if color then
		color_copy(color, style.color)
	end
end

CheckboxPassTemplates.terminal_button_change_function = terminal_button_change_function

local function terminal_button_hover_change_function(content, style)
	local hotspot = content.hotspot
	local anim_hover_progress = hotspot.anim_hover_progress or 0
	local anim_select_progress = hotspot.anim_select_progress or 0
	local anim_focus_progress = hotspot.anim_focus_progres or 0
	local default_alpha = 155
	local hover_alpha = anim_hover_progress * 100
	local select_alpha = math.max(anim_select_progress, anim_focus_progress) * 50

	style.color[1] = math.clamp(default_alpha + select_alpha + hover_alpha, 0, 255)
end

CheckboxPassTemplates.terminal_button_hover_change_function = terminal_button_hover_change_function

CheckboxPassTemplates.settings_checkbox = function (width, height, settings_area_width, num_options, use_is_focused, is_sub_setting)
	local header_width = width - settings_area_width
	local passes = ListHeaderPassTemplates.list_header(header_width, height, use_is_focused, is_sub_setting)

	passes[#passes + 1] = {
		pass_type = "texture",
		value = "content/ui/materials/frames/hover",
		style = {
			hdr = true,
			horizontal_alignment = "right",
			size = {
				settings_area_width,
				height,
			},
			color = Color.terminal_corner_hover(255, true),
			size_addition = {
				0,
				0,
			},
			offset = {
				0,
				0,
				11,
			},
		},
		change_function = list_item_highlight_change_function,
		visibility_function = list_item_highight_focused_visibility_function,
	}

	local option_width = settings_area_width / num_options
	local option_size = {
		option_width,
		height,
	}

	for i = 1, num_options do
		local horizontal_offset = -((num_options - i) * option_width)
		local option_font_style = table.clone(UIFontSettings.list_button)

		option_font_style.horizontal_alignment = "right"
		option_font_style.text_horizontal_alignment = "center"
		option_font_style.size = option_size
		option_font_style.offset[1] = horizontal_offset

		local hotspot_id = "option_hotspot_" .. i

		passes[#passes + 1] = {
			pass_type = "hotspot",
			content_id = hotspot_id,
			style_id = hotspot_id,
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "top",
				size = option_size,
				offset = {
					horizontal_offset,
					0,
					10,
				},
			},
		}
		passes[#passes + 1] = {
			pass_type = "texture",
			value = "content/ui/materials/buttons/background_selected",
			style = {
				horizontal_alignment = "right",
				size = option_size,
				offset = {
					horizontal_offset,
					0,
					1,
				},
				color = Color.terminal_corner_hover(255, true),
			},
			change_function = function (content, style)
				local default_alpha = 255
				local disabled_alpha = default_alpha * 0.8
				local current_alpha = content.disabled and disabled_alpha or default_alpha

				style.color[1] = current_alpha * content[hotspot_id].anim_select_progress
			end,
			visibility_function = function (content, style)
				return content[hotspot_id].is_selected
			end,
		}
		passes[#passes + 1] = {
			pass_type = "rect",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "top",
				size = option_size,
				offset = {
					horizontal_offset,
					0,
					9,
				},
				color = Color.terminal_corner(25.5, true),
			},
			change_function = function (content, style)
				style.color[1] = 25.5 * content[hotspot_id].anim_select_progress
			end,
			visibility_function = function (content, style)
				return content[hotspot_id].is_selected and not content.disabled
			end,
		}
		passes[#passes + 1] = {
			pass_type = "text",
			style = option_font_style,
			style_id = "option_" .. i,
			value_id = "option_" .. i,
			value = "option_" .. i,
			change_function = highlight_color_change_function,
		}
	end

	return passes
end

local terminal_button_text_style = table.clone(UIFontSettings.button_primary)

terminal_button_text_style.offset = {
	70,
	0,
	6,
}
terminal_button_text_style.size_addition = {
	-70,
	0,
}
terminal_button_text_style.text_horizontal_alignment = "left"
terminal_button_text_style.text_vertical_alignment = "center"
terminal_button_text_style.text_color = {
	255,
	216,
	229,
	207,
}
terminal_button_text_style.default_color = {
	255,
	216,
	229,
	207,
}
CheckboxPassTemplates.terminal_checkbox_button = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		content = {
			on_released_sound = nil,
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_click,
		},
		change_function = function (content, style, _, dt)
			local checked = content.parent.checked
			local anim_hover_speed = style and style.anim_hover_speed

			if anim_hover_speed then
				local anim_checked_progress = content.anim_checked_progress or 0

				if checked then
					anim_checked_progress = math.min(anim_checked_progress + dt * anim_hover_speed, 1)
				else
					anim_checked_progress = math.max(anim_checked_progress - dt * anim_hover_speed, 0)
				end

				content.anim_checked_progress = anim_checked_progress
			end
		end,
	},
	{
		pass_type = "rect",
		style_id = "checkbox_background",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			color = {
				180,
				28,
				31,
				28,
			},
			size = {
				50,
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
		style_id = "checkbox_shadow",
		value = "content/ui/materials/frames/dropshadow_medium",
		style = {
			horizontal_alignment = "right",
			scale_to_material = true,
			vertical_alignment = "center",
			color = Color.black(150, true),
			size_addition = {
				-30,
				20,
			},
			offset = {
				10,
				0,
				3,
			},
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
		change_function = terminal_button_change_function,
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			disabled_color = Color.ui_grey_medium(255, true),
			size_addition = {
				-50,
				0,
			},
			offset = {
				0,
				0,
				1,
			},
		},
		change_function = function (content, style)
			terminal_button_change_function(content, style)
			terminal_button_hover_change_function(content, style)
		end,
	},
	{
		pass_type = "text",
		style_id = "checkbox_text_default",
		value_id = "checkbox",
		style = {
			drop_shadow = false,
			font_size = 28,
			font_type = "proxima_nova_bold",
			horizontal_alignment = "left",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			vertical_alignment = "center",
			size = {
				50,
			},
			text_color = {
				255,
				10,
				10,
				10,
			},
			offset = {
				0,
				0,
				5,
			},
		},
		change_function = function (content, style)
			content.checkbox = ""
		end,
		visibility_function = function (content, style)
			return not content.checked
		end,
	},
	{
		pass_type = "text",
		style_id = "checkbox_text_checked",
		value_id = "checkbox",
		style = {
			drop_shadow = true,
			font_size = 28,
			font_type = "proxima_nova_bold",
			horizontal_alignment = "left",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			vertical_alignment = "center",
			size = {
				50,
			},
			text_color = Color.terminal_corner_selected(nil, true),
			offset = {
				0,
				0,
				5,
			},
		},
		change_function = function (content, style)
			content.checkbox = ""
		end,
		visibility_function = function (content, style)
			return content.checked
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
			color = Color.black(200, true),
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
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			disabled_color = Color.ui_grey_medium(255, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				5,
			},
		},
		change_function = terminal_button_change_function,
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			disabled_color = Color.ui_grey_light(255, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				6,
			},
		},
		change_function = terminal_button_change_function,
	},
	{
		pass_type = "text",
		style_id = "text",
		value_id = "text",
		style = terminal_button_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local is_disabled = hotspot.disabled
			local gamepad_active = hotspot.gamepad_active
			local button_text = content.original_text or ""
			local gamepad_action = content.gamepad_action

			if gamepad_active and gamepad_action and not is_disabled then
				local service_type = "View"
				local alias_key = Managers.ui:get_input_alias_key(gamepad_action, service_type)
				local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)

				content.text = string.format(Localize("loc_input_legend_text_template"), input_text, button_text)
			else
				content.text = button_text
			end

			local default_color = is_disabled and style.disabled_color or style.default_color
			local hover_color = style.hover_color
			local color = style.text_color
			local progress = math.max(math.max(hotspot.anim_checked_progress or 0, math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress)), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

			if color and default_color and hover_color then
				color_lerp(default_color, hover_color, progress, color)
			end
		end,
	},
}

return CheckboxPassTemplates
