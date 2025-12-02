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
local color_copy = ColorUtilities.color_copy

local function _get_input_text(action)
	local service_type = "View"
	local alias_key = Managers.ui:get_input_alias_key(action, service_type)

	return InputUtils.input_text_for_current_input_device(service_type, alias_key)
end

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
		local danger_color = DangerSettings[current_danger] and DangerSettings[current_danger].color or DangerSettings[1].color

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
					local danger_settings = DangerSettings[danger]

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
					content.stepper_left_text = gamepad_active and _get_input_text("navigate_primary_left_pressed") or "<"
					content.stepper_right_text = gamepad_active and _get_input_text("navigate_primary_right_pressed") or ">"
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
		value = "<",
		value_id = "stepper_left_text",
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
		value = ">",
		value_id = "stepper_right_text",
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
					content.stepper_left = gamepad_active and _get_input_text("navigate_primary_left_pressed") or "<"
					content.stepper_right = gamepad_active and _get_input_text("navigate_primary_right_pressed") or ">"
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
			on_released_sound = nil,
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
		value = "<",
		value_id = "stepper_left_text",
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
		value = ">",
		value_id = "stepper_right_text",
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

	local gamepad_active = InputDevice.gamepad_active

	if content.was_gamepad_active ~= gamepad_active then
		content.was_gamepad_active = gamepad_active
		content.stepper_left_text = gamepad_active and _get_input_text("navigate_primary_left_pressed") or "<"
		content.stepper_right_text = gamepad_active and _get_input_text("navigate_primary_right_pressed") or ">"
	end
end

local Styles = {}

Styles.difficulty_stepper = {}
Styles.difficulty_stepper.frame_top = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "top",
	color = Color.white(nil, true),
	size = {
		374.40000000000003,
		62.400000000000006,
	},
	offset = {
		0,
		-20,
		3,
	},
	size_addition = {
		0,
		0,
	},
}
Styles.difficulty_stepper.frame_bottom = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "bottom",
	color = Color.white(nil, true),
	size = {
		374.40000000000003,
		62.400000000000006,
	},
	offset = {
		0,
		20,
		3,
	},
	uvs = {
		{
			0,
			1,
		},
		{
			1,
			0,
		},
	},
	size_addition = {
		0,
		0,
	},
}
Styles.difficulty_stepper.difficulty_text = {
	font_size = 34,
	font_type = "kode_mono_medium",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "center",
	vertical_alignment = "center",
	offset = {
		0,
		0,
		2,
	},
	size_addition = {
		0,
		0,
	},
	text_color = Color.golden_rod(nil, true),
}
Styles.difficulty_stepper.left_button = {
	horizontal_alignment = "left",
	scale_to_material = true,
	vertical_alignment = "center",
	size = {
		84,
		74,
	},
	offset = {
		-42,
		0,
		6,
	},
	color = Color.golden_rod(nil, true),
}
Styles.difficulty_stepper.left_button_glow = table.clone(Styles.difficulty_stepper.left_button)
Styles.difficulty_stepper.left_button_glow.offset[3] = 5
Styles.difficulty_stepper.right_button = {
	horizontal_alignment = "right",
	scale_to_material = true,
	vertical_alignment = "center",
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
	size = {
		90,
		74,
	},
	offset = {
		45,
		0,
		6,
	},
	color = Color.golden_rod(nil, true),
}
Styles.difficulty_stepper.right_button_glow = table.clone(Styles.difficulty_stepper.right_button)
Styles.difficulty_stepper.right_button_glow.offset[3] = 5
Styles.difficulty_stepper.left_hotspot = {
	horizontal_alignment = "left",
	vertical_alignment = "center",
	size = {
		74,
		60,
	},
	offset = {
		-37,
		0,
		5,
	},
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_click,
}
Styles.difficulty_stepper.right_hotspot = table.clone(Styles.difficulty_stepper.left_hotspot)
Styles.difficulty_stepper.right_hotspot.offset[1] = 37
Styles.difficulty_stepper.right_hotspot.horizontal_alignment = "right"
Styles.difficulty_stepper.left_input_text = {
	horizontal_alignment = "left",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "center",
	vertical_alignment = "center",
	size = {
		64,
		54,
	},
	offset = {
		-32,
		0,
		5,
	},
}
Styles.difficulty_stepper.right_input_text = table.clone(Styles.difficulty_stepper.left_input_text)
Styles.difficulty_stepper.right_input_text.offset[1] = 32
Styles.difficulty_stepper.right_input_text.horizontal_alignment = "right"
Styles.difficulty_stepper.right_input_text.text_color = {
	255,
	255,
	255,
	255,
}
Styles.difficulty_stepper.difficulty_indicator = {}
Styles.difficulty_stepper.difficulty_indicator.frame = {
	size = {
		28,
		28,
	},
	offset = {
		0,
		0,
		20,
	},
	default_size = {
		28,
		28,
	},
	active_size = {
		84,
		84,
	},
	active_color = Color.white(255, true),
	inactive_color = Color.gray(255, true),
}
Styles.difficulty_stepper.difficulty_indicator.background = {
	size = {
		26,
		26,
	},
	offset = {
		0,
		0,
		19,
	},
	default_size = {
		26,
		26,
	},
	active_size = {
		78,
		78,
	},
	color = Color.black(255, true),
}
Styles.difficulty_stepper.difficulty_indicator.hotspot = table.clone(Styles.difficulty_stepper.difficulty_indicator.frame)
Styles.difficulty_stepper.difficulty_indicator.frame_fill = table.clone(Styles.difficulty_stepper.difficulty_indicator.frame)
Styles.difficulty_stepper.difficulty_indicator.frame_fill.offset[3] = 22
Styles.difficulty_stepper.difficulty_indicator.icon = {
	size = {
		22,
		22,
	},
	default_size = {
		22,
		22,
	},
	active_size = {
		48,
		48,
	},
	offset = {
		0,
		0,
		21,
	},
}
Styles.difficulty_stepper.difficulty_indicator.indicator_locked = {
	size = {
		22,
		22,
	},
	offset = {
		0,
		0,
		23,
	},
	default_size = {
		22,
		22,
	},
	active_size = {
		58,
		58,
	},
	color = Color.white(255, true),
}

local function _stepper_static_elements_update(content, style, animations, dt)
	local color = style.color or style.text_color
	local from_color = style.color or style.text_color
	local to_color = content.target_color

	if to_color then
		ColorUtilities.color_lerp(from_color, to_color, 0.1, color, false)
	end
end

local function _left_stepper_button_change_function(hotspot_data, content, style, dt)
	local color = style.color
	local from_color = style.color
	local to_color = content.target_color

	if from_color and to_color then
		ColorUtilities.color_lerp(from_color, to_color, 0.1, color, true)
	end

	style.size[1] = 90 + 14 * hotspot_data.anim_hover_progress
	style.size[2] = 80 + 14 * hotspot_data.anim_hover_progress
end

local function _right_stepper_button_change_function(hotspot_data, content, style, dt)
	local color = style.color
	local from_color = style.color
	local to_color = content.target_color

	if from_color and to_color then
		ColorUtilities.color_lerp(from_color, to_color, 0.1, color, true)
	end

	style.size[1] = 90 + 14 * hotspot_data.anim_hover_progress
	style.size[2] = 80 + 14 * hotspot_data.anim_hover_progress
end

local function _arrows_visibilit_function(content, style)
	return not InputDevice.gamepad_active
end

local function _gamepad_input_visibilit_function(content, style)
	return InputDevice.gamepad_active
end

StepperPassTemplates.mission_board_stepper = {
	{
		pass_type = "logic",
		value = function (pass, ui_renderer, logic_style, content, position, size)
			local gamepad_active = InputDevice.gamepad_active

			if content.is_using_gamepad ~= gamepad_active then
				content.is_using_gamepad = gamepad_active

				if content.override_left_gamepad_input then
					content.left_gamepad_input = content.override_left_gamepad_input
				else
					content.left_gamepad_input = "navigate_primary_left_pressed"
				end

				if content.override_right_gamepad_input then
					content.right_gamepad_input = content.override_right_gamepad_input
				else
					content.right_gamepad_input = "navigate_primary_right_pressed"
				end

				content.gamepad_left_input_text = content.is_using_gamepad and _get_input_text(content.left_gamepad_input) or ""
				content.gamepad_right_input_text = content.is_using_gamepad and _get_input_text(content.right_gamepad_input) or ""
			end

			local input_service = ui_renderer.input_service
			local left_hotspot_data = content.left_hotspot
			local right_hotspot_data = content.right_hotspot

			if content.left_pressed_callback and (left_hotspot_data.on_released or content.left_gamepad_input and input_service:get(content.left_gamepad_input)) then
				content.left_pressed_callback()
			elseif left_hotspot_data.on_released or content.left_gamepad_input and input_service:get(content.left_gamepad_input) then
				content.danger = content.danger > 1 and content.danger - 1 or content.danger
			end

			if content.right_pressed_callback and (right_hotspot_data.on_released or content.right_gamepad_input and input_service:get(content.right_gamepad_input)) then
				content.right_pressed_callback()
			elseif right_hotspot_data.on_released or content.right_gamepad_input and input_service:get(content.right_gamepad_input) then
				content.danger = content.danger < 5 and content.danger + 1 or content.danger
			end
		end,
	},
	{
		pass_type = "texture",
		style_id = "stepper_frame_top",
		value = "content/ui/materials/frames/difficulty_stepper_frame",
		style = Styles.difficulty_stepper.frame_top,
		change_function = _stepper_static_elements_update,
	},
	{
		pass_type = "texture_uv",
		style_id = "stepper_frame_bottom",
		value = "content/ui/materials/frames/difficulty_stepper_frame",
		style = Styles.difficulty_stepper.frame_bottom,
		change_function = _stepper_static_elements_update,
	},
	{
		pass_type = "text",
		style_id = "difficulty_text",
		value = "DIFFICULTY",
		value_id = "difficulty_text",
		style = Styles.difficulty_stepper.difficulty_text,
		change_function = _stepper_static_elements_update,
	},
	{
		content_id = "left_hotspot",
		pass_type = "hotspot",
		style_id = "left_hotspot",
		style = Styles.difficulty_stepper.left_hotspot,
		visibility_function = _arrows_visibilit_function,
	},
	{
		pass_type = "texture",
		style_id = "left_button",
		value = "content/ui/materials/buttons/double_arrow",
		style = Styles.difficulty_stepper.left_button,
		visibility_function = _arrows_visibilit_function,
		change_function = function (content, style, animations, dt)
			local hotspot_data = content.left_hotspot

			_left_stepper_button_change_function(hotspot_data, content, style, dt)

			style.offset[1] = -(51 + 7 * hotspot_data.anim_hover_progress)
			style.color[1] = 255 * (1 - hotspot_data.anim_input_progress)
		end,
	},
	{
		pass_type = "text",
		style_id = "gamepad_left_input_text",
		value = "n/a",
		value_id = "gamepad_left_input_text",
		style = Styles.difficulty_stepper.left_input_text,
		change_function = _stepper_static_elements_update,
		visibility_function = _gamepad_input_visibilit_function,
	},
	{
		pass_type = "texture",
		style_id = "left_button_glow",
		value = "content/ui/materials/buttons/double_arrow_glow",
		style = Styles.difficulty_stepper.left_button_glow,
		visibility_function = _arrows_visibilit_function,
		change_function = function (content, style, animations, dt)
			local hotspot_data = content.left_hotspot

			_left_stepper_button_change_function(hotspot_data, content, style, dt)

			style.offset[1] = -(51 + 7 * hotspot_data.anim_hover_progress)
			style.color[1] = 255 * hotspot_data.anim_input_progress
		end,
	},
	{
		content_id = "right_hotspot",
		pass_type = "hotspot",
		style_id = "right_hotspot",
		style = Styles.difficulty_stepper.right_hotspot,
		visibility_function = _arrows_visibilit_function,
	},
	{
		pass_type = "text",
		style_id = "gamepad_right_input_text",
		value = "n/a",
		value_id = "gamepad_right_input_text",
		style = Styles.difficulty_stepper.right_input_text,
		visibility_function = _gamepad_input_visibilit_function,
		change_function = _stepper_static_elements_update,
	},
	{
		pass_type = "texture_uv",
		style_id = "right_button",
		value = "content/ui/materials/buttons/double_arrow",
		style = Styles.difficulty_stepper.right_button,
		visibility_function = _arrows_visibilit_function,
		change_function = function (content, style, animations, dt)
			local hotspot_data = content.right_hotspot

			_right_stepper_button_change_function(hotspot_data, content, style, dt)

			local base_alpha = content.next_page_unlocked and 255 or 90

			style.color[1] = base_alpha * (1 - hotspot_data.anim_input_progress)
			style.offset[1] = 51 + 7 * hotspot_data.anim_hover_progress
		end,
	},
	{
		pass_type = "texture_uv",
		style_id = "right_button_glow",
		value = "content/ui/materials/buttons/double_arrow_glow",
		style = Styles.difficulty_stepper.right_button_glow,
		visibility_function = _arrows_visibilit_function,
		change_function = function (content, style, animations, dt)
			local hotspot_data = content.right_hotspot

			_right_stepper_button_change_function(hotspot_data, content, style, dt)

			style.color[1] = 255 * hotspot_data.anim_input_progress
			style.offset[1] = 51 + 7 * hotspot_data.anim_hover_progress
		end,
	},
	{
		content_id = "tooltip_hotspot",
		pass_type = "hotspot",
		style_id = "tooltip_hotspot",
		style = {
			anim_hover_speed = 5,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				260,
				70,
			},
			offset = {
				0,
				15,
				4,
			},
		},
	},
}

local function _stepper_indicator_change_function(content, style, dt, ignore_color)
	local is_active = content.active
	local progress = content.active_progress or 0

	if is_active then
		progress = math.min(progress + dt * 5, 1)
	else
		progress = math.max(progress - dt * 5, 0)
	end

	style.size[1] = style.default_size[1] + (style.active_size[1] - style.default_size[1]) * progress
	style.size[2] = style.default_size[2] + (style.active_size[2] - style.default_size[2]) * progress

	local hotspot = content.hotspot or content.parent.hotspot

	if hotspot then
		local anim_hover_progress = hotspot.anim_hover_progress or 0

		style.size[1] = style.size[1] + 10 * anim_hover_progress
		style.size[2] = style.size[2] + 10 * anim_hover_progress
	end

	style.offset[1] = -style.size[1] * 0.5
	style.offset[2] = -style.size[2] * 0.5

	if not ignore_color then
		local color = style.color
		local from_color = style.color
		local to_color = content.target_color

		if from_color then
			ColorUtilities.color_lerp(from_color, to_color, 0.1, color, false)
		else
			style.color = style.inactive_color
		end
	end

	content.active_progress = progress
end

StepperPassTemplates.difficulty_stepper_indicator = {}
StepperPassTemplates.difficulty_stepper_indicator.passes = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style_id = "hotspot",
		style = Styles.difficulty_stepper.difficulty_indicator.hotspot,
		change_function = function (content, style, animations, dt)
			_stepper_indicator_change_function(content, style, dt, true)
		end,
	},
	{
		pass_type = "texture",
		style_id = "indicator_frame",
		value = "content/ui/materials/icons/difficulty/difficulty_indicator_empty",
		style = Styles.difficulty_stepper.difficulty_indicator.frame,
		change_function = function (content, style, animations, dt)
			_stepper_indicator_change_function(content, style, dt)
		end,
		visibility_function = function (content, style)
			return content.active
		end,
	},
	{
		pass_type = "texture",
		style_id = "indicator_frame",
		value = "content/ui/materials/icons/difficulty/selection_frame_dimond_small",
		style = Styles.difficulty_stepper.difficulty_indicator.frame,
		change_function = function (content, style, animations, dt)
			_stepper_indicator_change_function(content, style, dt)
		end,
		visibility_function = function (content, style)
			return not content.active
		end,
	},
	{
		pass_type = "texture",
		style_id = "indicator_background",
		value = "content/ui/materials/icons/difficulty/difficulty_indicator_full",
		style = Styles.difficulty_stepper.difficulty_indicator.background,
		change_function = function (content, style, animations, dt)
			_stepper_indicator_change_function(content, style, dt, true)
		end,
	},
	{
		pass_type = "texture",
		style_id = "icon",
		value = "content/ui/materials/icons/difficulty/difficulty_skull_uprising",
		value_id = "icon",
		style = Styles.difficulty_stepper.difficulty_indicator.icon,
		visibility_function = function (content, style)
			return content.active
		end,
		change_function = function (content, style, animations, dt)
			_stepper_indicator_change_function(content, style, dt)
		end,
	},
	{
		pass_type = "texture",
		style_id = "indicator_full",
		value = "content/ui/materials/icons/difficulty/difficulty_indicator_full",
		style = Styles.difficulty_stepper.difficulty_indicator.frame_fill,
		change_function = function (content, style, animations, dt)
			_stepper_indicator_change_function(content, style, dt)
		end,
		visibility_function = function (content, style)
			return not content.active and content.is_unlocked
		end,
	},
}

return settings("StepperPassTemplates", StepperPassTemplates)
