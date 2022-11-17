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
local difficulty_picker_hotspot_ids = {
	"hotspot_1",
	"hotspot_2",
	"hotspot_3",
	"hotspot_4",
	"hotspot_5"
}

local function _make_difficulty_picker_rect_change_function(index)
	return function (content, style)
		if index <= content._hover_index_1 then
			style.color[1] = 255
		elseif index <= content._hover_index_2 then
			style.color[1] = 127
		else
			style.color[1] = 64
		end
	end
end

StepperPassTemplates.difficulty_stepper = {
	{
		pass_type = "logic",
		value = function (pass, ui_renderer, logic_style, content, position, size)
			if not content.disabled then
				local danger = content.danger
				local input_service = ui_renderer.input_service

				if (content.hotspot_left.on_released or input_service:get("navigate_primary_left_pressed")) and danger > 1 then
					danger = danger - 1
				elseif (content.hotspot_right.on_released or input_service:get("navigate_primary_right_pressed")) and danger < 5 then
					danger = danger + 1
				end

				local hover_index = content.danger

				for i = 1, 5 do
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
		value = "<",
		value_id = "stepper_left",
		pass_type = "text",
		style = {
			font_size = 32,
			text_vertical_alignment = "center",
			horizontal_alignment = "center",
			text_horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "proxima_nova_bold",
			text_color = color_terminal_text_header,
			size = {
				75,
				75
			},
			offset = {
				-120,
				30,
				1
			}
		}
	},
	{
		value = ">",
		value_id = "stepper_right",
		pass_type = "text",
		style = {
			font_size = 32,
			text_vertical_alignment = "center",
			horizontal_alignment = "center",
			text_horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "proxima_nova_bold",
			text_color = color_terminal_text_header,
			size = {
				75,
				75
			},
			offset = {
				120,
				30,
				1
			}
		}
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
				30,
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
				30,
				1
			}
		}
	},
	{
		value = "content/ui/materials/icons/generic/danger",
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
				30,
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
				30,
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
				30,
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
				30,
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
				30,
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
				30,
				2
			}
		}
	},
	{
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
				30,
				2
			}
		}
	},
	{
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
				30,
				2
			}
		}
	},
	{
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
				30,
				2
			}
		}
	},
	{
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
				30,
				2
			}
		}
	},
	{
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
				30,
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
				-20,
				3
			}
		}
	}
}

return settings("StepperPassTemplates", StepperPassTemplates)
