local DangerSettings = require("scripts/settings/difficulty/danger_settings")
local InputDevice = require("scripts/managers/input/input_device")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local color_terminal_icon = {
	255,
	169,
	211,
	158
}
local color_terminal_text_header = Color.terminal_text_header(255, true)
local StepperPassTemplates = {}
local difficulty_picker_stepper_hotspot_content = {
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_select
}
local MIN_DANGER = 1
local MAX_DANGER = 5
local difficulty_picker_hotspot_ids = {
	"hotspot_1",
	"hotspot_2",
	"hotspot_3",
	"hotspot_4",
	"hotspot_5"
}

local function _make_difficulty_picker_rect_change_function(index)
	return function (content, style)
		local min_danger = content.min_danger or MIN_DANGER
		local max_danger = content.max_danger or MAX_DANGER

		if index < min_danger or max_danger < index then
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
				content.danger = min_danger <= content.danger and content.danger <= max_danger and content.danger or min_danger
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
				local gamepad_active = InputDevice.gamepad_active

				if content.was_gamepad_active ~= gamepad_active then
					content.was_gamepad_active = gamepad_active
					content.stepper_left = gamepad_active and "" or "<"
					content.stepper_right = gamepad_active and "" or ">"
				end
			end
		end
	},
	{
		style_id = "stepper_left",
		pass_type = "texture_uv",
		value = "content/ui/materials/buttons/arrow_01",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				32,
				32
			},
			color = color_terminal_text_header,
			offset = {
				-120,
				15,
				2
			},
			uvs = {
				{
					1,
					0
				},
				{
					0,
					1
				}
			}
		},
		visibility_function = function (parent, content)
			return Managers.ui:using_cursor_navigation()
		end
	},
	{
		style_id = "stepper_right",
		pass_type = "texture",
		value = "content/ui/materials/buttons/arrow_01",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				32,
				32
			},
			color = color_terminal_text_header,
			offset = {
				115,
				15,
				2
			}
		},
		visibility_function = function (parent, content)
			return Managers.ui:using_cursor_navigation()
		end
	},
	{
		value_id = "stepper_left_text",
		pass_type = "text",
		value = "",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			text_vertical_alignment = "center",
			font_size = 32,
			text_horizontal_alignment = "center",
			text_color = color_terminal_text_header,
			size = {
				75,
				75
			},
			offset = {
				-120,
				15,
				1
			}
		},
		visibility_function = function (parent, content)
			return not Managers.ui:using_cursor_navigation()
		end
	},
	{
		value_id = "stepper_right_text",
		pass_type = "text",
		value = "",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			text_vertical_alignment = "center",
			font_size = 32,
			text_horizontal_alignment = "center",
			text_color = color_terminal_text_header,
			size = {
				75,
				75
			},
			offset = {
				115,
				15,
				1
			}
		},
		visibility_function = function (parent, content)
			return not Managers.ui:using_cursor_navigation()
		end
	},
	{
		pass_type = "hotspot",
		content_id = "hotspot_left",
		content = difficulty_picker_stepper_hotspot_content,
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				75,
				75
			},
			offset = {
				-140,
				15,
				1
			}
		}
	},
	{
		pass_type = "hotspot",
		content_id = "hotspot_right",
		content = difficulty_picker_stepper_hotspot_content,
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				75,
				75
			},
			offset = {
				140,
				15,
				1
			}
		}
	},
	{
		value = "content/ui/materials/icons/generic/danger",
		style_id = "danger",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = color_terminal_icon,
			size = {
				46,
				46
			},
			offset = {
				-65,
				15,
				2
			}
		}
	},
	{
		pass_type = "hotspot",
		content_id = "hotspot_1",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				24,
				36
			},
			offset = {
				-22,
				15,
				2
			}
		}
	},
	{
		pass_type = "hotspot",
		content_id = "hotspot_2",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				24,
				36
			},
			offset = {
				2,
				15,
				2
			}
		}
	},
	{
		pass_type = "hotspot",
		content_id = "hotspot_3",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				24,
				36
			},
			offset = {
				26,
				15,
				2
			}
		}
	},
	{
		pass_type = "hotspot",
		content_id = "hotspot_4",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				24,
				36
			},
			offset = {
				50,
				15,
				2
			}
		}
	},
	{
		pass_type = "hotspot",
		content_id = "hotspot_5",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				24,
				36
			},
			offset = {
				74,
				15,
				2
			}
		}
	},
	{
		style_id = "difficulty_bar_1",
		pass_type = "rect",
		change_function = _make_difficulty_picker_rect_change_function(1),
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = color_terminal_icon,
			size = {
				18,
				36
			},
			offset = {
				-22,
				15,
				2
			}
		}
	},
	{
		style_id = "difficulty_bar_2",
		pass_type = "rect",
		change_function = _make_difficulty_picker_rect_change_function(2),
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = color_terminal_icon,
			size = {
				18,
				36
			},
			offset = {
				2,
				15,
				2
			}
		}
	},
	{
		style_id = "difficulty_bar_3",
		pass_type = "rect",
		change_function = _make_difficulty_picker_rect_change_function(3),
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = color_terminal_icon,
			size = {
				18,
				36
			},
			offset = {
				26,
				15,
				2
			}
		}
	},
	{
		style_id = "difficulty_bar_4",
		pass_type = "rect",
		change_function = _make_difficulty_picker_rect_change_function(4),
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = color_terminal_icon,
			size = {
				18,
				36
			},
			offset = {
				50,
				15,
				2
			}
		}
	},
	{
		style_id = "difficulty_bar_5",
		pass_type = "rect",
		change_function = _make_difficulty_picker_rect_change_function(5),
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = color_terminal_icon,
			size = {
				18,
				36
			},
			offset = {
				74,
				15,
				2
			}
		}
	},
	{
		value = "difficulty_text",
		value_id = "difficulty_text",
		pass_type = "text",
		style = {
			font_type = "proxima_nova_bold",
			font_size = 28,
			text_vertical_alignment = "center",
			text_horizontal_alignment = "center",
			text_color = color_terminal_text_header,
			offset = {
				0,
				-25,
				3
			}
		}
	}
}

return settings("StepperPassTemplates", StepperPassTemplates)
