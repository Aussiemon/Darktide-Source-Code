-- chunkname: @scripts/ui/pass_templates/stepper_pass_templates.lua

local ColorUtilities = require("scripts/utilities/ui/colors")
local DangerSettings = require("scripts/settings/difficulty/danger_settings")
local InputDevice = require("scripts/managers/input/input_device")
local InputUtils = require("scripts/managers/input/input_utils")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local color_terminal_icon = Color.terminal_text_header(255, true)
local color_terminal_text_header = Color.terminal_text_header(255, true)
local StepperPassTemplates = {}
local color_lerp = ColorUtilities.color_lerp
local color_copy = ColorUtilities.color_copy
local service_type = "View"
local gamepad_action_navigate_primary_left = "navigate_primary_left_pressed"
local alias_key_navigate_primary_left = Managers.ui:get_input_alias_key(gamepad_action_navigate_primary_left, service_type)
local input_text_navigate_primary_left = InputUtils.input_text_for_current_input_device(service_type, alias_key_navigate_primary_left)
local gamepad_action_navigate_primary_right = "navigate_primary_right_pressed"
local alias_key_navigate_primary_right = Managers.ui:get_input_alias_key(gamepad_action_navigate_primary_right, service_type)
local input_text_navigate_primary_right = InputUtils.input_text_for_current_input_device(service_type, alias_key_navigate_primary_right)

local function terminal_button_change_function(content, style, hotspot_id)
	local hotspot = hotspot_id and content[hotspot_id] or content.hotspot
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

StepperPassTemplates.terminal_button_change_function = terminal_button_change_function

local function terminal_button_hover_change_function(content, style, hotspot_id)
	local hotspot = hotspot_id and content[hotspot_id] or content.hotspot
	local anim_hover_progress = hotspot.anim_hover_progress or 0
	local anim_select_progress = hotspot.anim_select_progress or 0
	local anim_focus_progress = hotspot.anim_focus_progres or 0
	local default_alpha = 155
	local hover_alpha = anim_hover_progress * 100
	local select_alpha = math.max(anim_select_progress, anim_focus_progress) * 50

	style.color[1] = math.clamp(default_alpha + select_alpha + hover_alpha, 0, 255)
end

StepperPassTemplates.terminal_button_hover_change_function = terminal_button_hover_change_function

local difficulty_picker_stepper_hotspot_content = {
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_select,
}
local MIN_DANGER = 1
local MAX_DANGER = 5
local difficulty_picker_hotspot_ids = {
	"hotspot_1",
	"hotspot_2",
	"hotspot_3",
	"hotspot_4",
	"hotspot_5",
}

local function _make_difficulty_picker_rect_change_function(index)
	return function (content, style)
		local min_danger = content.min_danger or MIN_DANGER
		local max_danger = content.max_danger or MAX_DANGER
		local current_danger = content.hover_danger or content.danger
		local danger_color = DangerSettings.by_index[current_danger] and DangerSettings.by_index[current_danger].color or DangerSettings.by_index[1].color

		ColorUtilities.color_copy(danger_color, style.color, true)

		if min_danger > index or max_danger < index then
			style.color[1] = 127
			style.size[1] = 10
			style.size[2] = 10
		elseif index <= content._hover_index_1 then
			style.color[1] = 255
			style.size[1] = 18
			style.size[2] = 36
		elseif index <= content._hover_index_2 then
			style.color[1] = 127
			style.size[1] = 18
			style.size[2] = 36
		else
			style.color[1] = 64
			style.size[1] = 18
			style.size[2] = 36
		end
	end
end

StepperPassTemplates.difficulty_stepper = {
	{
		pass_type = "logic",
		value = function (pass, ui_renderer, logic_style, content, position, size)
			if not content.disabled then
				local min_danger = math.clamp(content.min_danger or MIN_DANGER, MIN_DANGER, MAX_DANGER)
				local max_danger = math.clamp(content.max_danger or MAX_DANGER, MIN_DANGER, MAX_DANGER)

				min_danger = min_danger <= max_danger and min_danger or max_danger
				content.min_danger = min_danger
				content.max_danger = max_danger
				content.danger = min_danger <= content.danger and max_danger >= content.danger and content.danger or min_danger

				local danger = content.danger
				local input_service = ui_renderer.input_service

				if (content.hotspot_left.on_released or input_service:get("navigate_primary_left_pressed")) and min_danger < danger then
					danger = danger - 1
				elseif (content.hotspot_right.on_released or input_service:get("navigate_primary_right_pressed")) and danger < max_danger then
					danger = danger + 1
				end

				local hover_index = content.danger

				for i = min_danger, max_danger do
					local hotspot_content = content[difficulty_picker_hotspot_ids[i]]

					if hotspot_content.on_pressed then
						danger = i

						break
					elseif hotspot_content.is_hover then
						hover_index = i
					end
				end

				if content.last_danger ~= danger then
					local danger_settings = DangerSettings.by_index[danger]

					content.difficulty_text = Localize(danger_settings.display_name)
					content.last_danger = danger
					content.danger = danger

					local cb = content.on_changed_callback

					if cb then
						cb()
					end
				end

				content._hover_index_1 = math.min(hover_index, danger)
				content._hover_index_2 = math.max(hover_index, danger)
				content.hover_danger = hover_index

				local gamepad_active = InputDevice.gamepad_active

				if content.was_gamepad_active ~= gamepad_active then
					content.was_gamepad_active = gamepad_active
					content.stepper_left = gamepad_active and input_text_navigate_primary_left or "<"
					content.stepper_right = gamepad_active and input_text_navigate_primary_right or ">"
				end
			end
		end,
	},
	{
		pass_type = "texture_uv",
		style_id = "stepper_left",
		value = "content/ui/materials/buttons/arrow_01",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				32,
				32,
			},
			color = color_terminal_text_header,
			offset = {
				-120,
				15,
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
		visibility_function = function (parent, content)
			return Managers.ui:using_cursor_navigation()
		end,
	},
	{
		pass_type = "texture",
		style_id = "stepper_right",
		value = "content/ui/materials/buttons/arrow_01",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				32,
				32,
			},
			color = color_terminal_text_header,
			offset = {
				115,
				15,
				2,
			},
		},
		visibility_function = function (parent, content)
			return Managers.ui:using_cursor_navigation()
		end,
	},
	{
		pass_type = "text",
		value_id = "stepper_left_text",
		value = input_text_navigate_primary_left,
		style = {
			font_size = 32,
			horizontal_alignment = "center",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			vertical_alignment = "center",
			text_color = color_terminal_text_header,
			size = {
				75,
				75,
			},
			offset = {
				-120,
				15,
				1,
			},
		},
		visibility_function = function (parent, content)
			return not Managers.ui:using_cursor_navigation()
		end,
	},
	{
		pass_type = "text",
		value_id = "stepper_right_text",
		value = input_text_navigate_primary_right,
		style = {
			font_size = 32,
			horizontal_alignment = "center",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			vertical_alignment = "center",
			text_color = color_terminal_text_header,
			size = {
				75,
				75,
			},
			offset = {
				115,
				15,
				1,
			},
		},
		visibility_function = function (parent, content)
			return not Managers.ui:using_cursor_navigation()
		end,
	},
	{
		content_id = "hotspot_left",
		pass_type = "hotspot",
		content = difficulty_picker_stepper_hotspot_content,
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				75,
				75,
			},
			offset = {
				-140,
				15,
				1,
			},
		},
	},
	{
		content_id = "hotspot_right",
		pass_type = "hotspot",
		content = difficulty_picker_stepper_hotspot_content,
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				75,
				75,
			},
			offset = {
				140,
				15,
				1,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "danger",
		value = "content/ui/materials/icons/generic/danger",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = color_terminal_icon,
			size = {
				46,
				46,
			},
			offset = {
				-65,
				15,
				2,
			},
		},
	},
	{
		content_id = "hotspot_1",
		pass_type = "hotspot",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				24,
				36,
			},
			offset = {
				-22,
				15,
				2,
			},
		},
	},
	{
		content_id = "hotspot_2",
		pass_type = "hotspot",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				24,
				36,
			},
			offset = {
				2,
				15,
				2,
			},
		},
	},
	{
		content_id = "hotspot_3",
		pass_type = "hotspot",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				24,
				36,
			},
			offset = {
				26,
				15,
				2,
			},
		},
	},
	{
		content_id = "hotspot_4",
		pass_type = "hotspot",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				24,
				36,
			},
			offset = {
				50,
				15,
				2,
			},
		},
	},
	{
		content_id = "hotspot_5",
		pass_type = "hotspot",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				24,
				36,
			},
			offset = {
				74,
				15,
				2,
			},
		},
	},
	{
		pass_type = "rect",
		style_id = "difficulty_bar_1",
		change_function = _make_difficulty_picker_rect_change_function(1),
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = color_terminal_icon,
			size = {
				18,
				36,
			},
			offset = {
				-22,
				15,
				2,
			},
		},
	},
	{
		pass_type = "rect",
		style_id = "difficulty_bar_2",
		change_function = _make_difficulty_picker_rect_change_function(2),
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = color_terminal_icon,
			size = {
				18,
				36,
			},
			offset = {
				2,
				15,
				2,
			},
		},
	},
	{
		pass_type = "rect",
		style_id = "difficulty_bar_3",
		change_function = _make_difficulty_picker_rect_change_function(3),
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = color_terminal_icon,
			size = {
				18,
				36,
			},
			offset = {
				26,
				15,
				2,
			},
		},
	},
	{
		pass_type = "rect",
		style_id = "difficulty_bar_4",
		change_function = _make_difficulty_picker_rect_change_function(4),
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = color_terminal_icon,
			size = {
				18,
				36,
			},
			offset = {
				50,
				15,
				2,
			},
		},
	},
	{
		pass_type = "rect",
		style_id = "difficulty_bar_5",
		change_function = _make_difficulty_picker_rect_change_function(5),
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = color_terminal_icon,
			size = {
				18,
				36,
			},
			offset = {
				74,
				15,
				2,
			},
		},
	},
	{
		pass_type = "text",
		value = "difficulty_text",
		value_id = "difficulty_text",
		style = {
			font_size = 28,
			font_type = "proxima_nova_bold",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			text_color = color_terminal_text_header,
			offset = {
				0,
				-25,
				3,
			},
		},
	},
}

local MIN_HAVOC_RANK = 1
local MAX_HAVOC_RANK = 40

StepperPassTemplates.havoc_stepper = {
	{
		pass_type = "logic",
		value = function (pass, ui_renderer, logic_style, content, position, size)
			if not content.disabled then
				local min_level = math.clamp(content.min_level or MIN_HAVOC_RANK, MIN_HAVOC_RANK, MAX_HAVOC_RANK)
				local max_level = math.clamp(content.max_level or MAX_HAVOC_RANK, MAX_HAVOC_RANK, MAX_HAVOC_RANK)

				min_level = min_level <= max_level and min_level or max_level
				content.min_level = min_level
				content.max_level = max_level
				content.level = min_level <= content.level and max_level >= content.level and content.level or min_level

				local level = content.level
				local input_service = ui_renderer.input_service

				if (content.hotspot_left.on_released or input_service:get("navigate_primary_left_pressed")) and min_level < level then
					level = level - 1
				elseif (content.hotspot_right.on_released or input_service:get("navigate_primary_right_pressed")) and level < max_level then
					level = level + 1
				end

				local hover_index = content.level

				if content.last_level ~= level then
					content.difficulty_text = tostring(level)
					content.last_level = level
					content.level = level

					local cb = content.on_changed_callback

					if cb then
						cb()
					end
				end

				content._hover_index_1 = math.min(hover_index, level)
				content._hover_index_2 = math.max(hover_index, level)

				local gamepad_active = InputDevice.gamepad_active

				if content.was_gamepad_active ~= gamepad_active then
					content.was_gamepad_active = gamepad_active
					content.stepper_left = gamepad_active and input_text_navigate_primary_left or "<"
					content.stepper_right = gamepad_active and input_text_navigate_primary_right or ">"
				end
			end
		end,
	},
	{
		pass_type = "text",
		value = "<",
		value_id = "stepper_left",
		style = {
			font_size = 32,
			font_type = "proxima_nova_bold",
			horizontal_alignment = "center",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			vertical_alignment = "center",
			text_color = color_terminal_text_header,
			size = {
				75,
				75,
			},
			offset = {
				-120,
				30,
				1,
			},
		},
	},
	{
		pass_type = "text",
		value = ">",
		value_id = "stepper_right",
		style = {
			font_size = 32,
			font_type = "proxima_nova_bold",
			horizontal_alignment = "center",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			vertical_alignment = "center",
			text_color = color_terminal_text_header,
			size = {
				75,
				75,
			},
			offset = {
				120,
				30,
				1,
			},
		},
	},
	{
		content_id = "hotspot_left",
		pass_type = "hotspot",
		content = difficulty_picker_stepper_hotspot_content,
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				75,
				75,
			},
			offset = {
				-140,
				30,
				1,
			},
		},
	},
	{
		content_id = "hotspot_right",
		pass_type = "hotspot",
		content = difficulty_picker_stepper_hotspot_content,
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				75,
				75,
			},
			offset = {
				140,
				30,
				1,
			},
		},
	},
	{
		pass_type = "text",
		value = "difficulty_text",
		value_id = "difficulty_text",
		style = {
			font_size = 45,
			font_type = "proxima_nova_bold",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			text_color = color_terminal_text_header,
			offset = {
				0,
				20,
				3,
			},
		},
	},
}

local terminal_button_text_style = table.clone(UIFontSettings.button_primary)

terminal_button_text_style.offset = {
	0,
	0,
	6,
}
terminal_button_text_style.size_addition = {
	-100,
	0,
}
terminal_button_text_style.horizontal_alignment = "center"
terminal_button_text_style.text_horizontal_alignment = "center"
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
StepperPassTemplates.terminal_stepper = {
	{
		content_id = "hotspot_left",
		pass_type = "hotspot",
		content = difficulty_picker_stepper_hotspot_content,
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			size = {
				50,
			},
			offset = {
				0,
				0,
				1,
			},
		},
	},
	{
		content_id = "hotspot_right",
		pass_type = "hotspot",
		content = difficulty_picker_stepper_hotspot_content,
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			size = {
				50,
			},
			offset = {
				0,
				0,
				1,
			},
		},
	},
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		content = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_select,
		},
	},
	{
		pass_type = "texture_uv",
		style_id = "stepper_left",
		value = "content/ui/materials/buttons/arrow_01",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			size = {
				16,
				16,
			},
			color = color_terminal_text_header,
			offset = {
				17,
				0,
				4,
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
		visibility_function = function (content, style)
			return Managers.ui:using_cursor_navigation()
		end,
	},
	{
		pass_type = "texture",
		style_id = "stepper_right",
		value = "content/ui/materials/buttons/arrow_01",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			size = {
				16,
				16,
			},
			color = color_terminal_text_header,
			offset = {
				-17,
				0,
				4,
			},
		},
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return Managers.ui:using_cursor_navigation()
		end,
	},
	{
		pass_type = "text",
		value_id = "stepper_left_text",
		value = input_text_navigate_primary_left,
		style = {
			font_size = 32,
			horizontal_alignment = "center",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			vertical_alignment = "center",
			text_color = color_terminal_text_header,
			size = {
				75,
				75,
			},
			offset = {
				-195,
				2,
				5,
			},
		},
		visibility_function = function (content, style)
			return not Managers.ui:using_cursor_navigation() and content.hotspot and content.hotspot.is_selected
		end,
	},
	{
		pass_type = "text",
		value_id = "stepper_right_text",
		value = input_text_navigate_primary_right,
		style = {
			font_size = 32,
			horizontal_alignment = "center",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			vertical_alignment = "center",
			text_color = color_terminal_text_header,
			size = {
				75,
				75,
			},
			offset = {
				195,
				2,
				5,
			},
		},
		visibility_function = function (content, style)
			return not Managers.ui:using_cursor_navigation() and content.hotspot and content.hotspot.is_selected
		end,
	},
	{
		pass_type = "rect",
		style_id = "stepper_left_background",
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
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return Managers.ui:using_cursor_navigation()
		end,
	},
	{
		pass_type = "texture",
		style_id = "stepper_left_background_shadow",
		value = "content/ui/materials/frames/dropshadow_medium",
		style = {
			horizontal_alignment = "left",
			scale_to_material = true,
			vertical_alignment = "center",
			color = Color.black(200, true),
			size = {
				50,
			},
			size_addition = {
				20,
				20,
			},
			offset = {
				-10,
				0,
				3,
			},
		},
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return Managers.ui:using_cursor_navigation()
		end,
	},
	{
		pass_type = "texture",
		style_id = "stepper_left_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			disabled_color = Color.ui_grey_medium(255, true),
			size = {
				50,
			},
			offset = {
				0,
				0,
				3,
			},
		},
		change_function = function (content, style)
			terminal_button_change_function(content, style, "hotspot_left")
			terminal_button_hover_change_function(content, style, "hotspot_left")
		end,
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return Managers.ui:using_cursor_navigation()
		end,
	},
	{
		pass_type = "rect",
		style_id = "stepper_right_background",
		style = {
			horizontal_alignment = "right",
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
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return Managers.ui:using_cursor_navigation()
		end,
	},
	{
		pass_type = "texture",
		style_id = "stepper_right_background_shadow",
		value = "content/ui/materials/frames/dropshadow_medium",
		style = {
			horizontal_alignment = "right",
			scale_to_material = true,
			vertical_alignment = "center",
			color = Color.black(200, true),
			size = {
				50,
			},
			size_addition = {
				20,
				20,
			},
			offset = {
				10,
				0,
				3,
			},
		},
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return Managers.ui:using_cursor_navigation()
		end,
	},
	{
		pass_type = "texture",
		style_id = "stepper_right_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			disabled_color = Color.ui_grey_medium(255, true),
			size = {
				50,
			},
			offset = {
				0,
				0,
				3,
			},
		},
		change_function = function (content, style)
			terminal_button_change_function(content, style, "hotspot_right")
			terminal_button_hover_change_function(content, style, "hotspot_right")
		end,
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return Managers.ui:using_cursor_navigation()
		end,
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_background(100, true),
			hover_color = Color.terminal_background(130, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			disabled_color = Color.ui_grey_medium(255, true),
			offset = {
				0,
				0,
				1,
			},
		},
		change_function = function (content, style)
			terminal_button_change_function(content, style)
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

			content.text = button_text
		end,
	},
}

StepperPassTemplates.terminal_stepper.update = function (widget, renderer, dt, t, input_service)
	local content = widget.content
	local pressed_delay = content.pressed_delay or 0.1
	local pressed_delay_time = content.pressed_delay_time

	if pressed_delay_time then
		content.pressed_delay_time = pressed_delay_time - dt

		if content.pressed_delay_time <= 0 then
			content.pressed_delay_time = nil
		end
	else
		local left_pressed_callback = content.left_pressed_callback
		local right_pressed_callback = content.right_pressed_callback

		if left_pressed_callback and right_pressed_callback then
			local hotspot_left = content.hotspot_left
			local hotspot_right = content.hotspot_right
			local hotspot = content.hotspot

			if InputDevice.gamepad_active then
				if hotspot.is_selected then
					local input_service = input_service or renderer.input_service

					if input_service:get("navigate_primary_left_held") then
						left_pressed_callback()

						content.pressed_delay_time = pressed_delay
					elseif input_service:get("navigate_primary_right_held") then
						right_pressed_callback()

						content.pressed_delay_time = pressed_delay
					end
				end
			elseif hotspot_left.is_held then
				left_pressed_callback()

				content.pressed_delay_time = pressed_delay
			elseif hotspot_right.is_held then
				right_pressed_callback()

				content.pressed_delay_time = pressed_delay
			end
		end
	end
end

return settings("StepperPassTemplates", StepperPassTemplates)
