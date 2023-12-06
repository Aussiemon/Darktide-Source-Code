local InputUtils = require("scripts/managers/input/input_utils")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ColorUtilities = require("scripts/utilities/ui/colors")
local ListHeaderPassTemplates = require("scripts/ui/pass_templates/list_header_templates")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ButtonPassTemplates = {}
local color_lerp = ColorUtilities.color_lerp
local color_copy = ColorUtilities.color_copy
local math_max = math.max
local math_lerp = math.lerp
local terminal_button_text_style = table.clone(UIFontSettings.button_primary)
terminal_button_text_style.offset = {
	0,
	0,
	6
}
terminal_button_text_style.text_horizontal_alignment = "center"
terminal_button_text_style.text_vertical_alignment = "center"
terminal_button_text_style.text_color = {
	255,
	216,
	229,
	207
}
terminal_button_text_style.default_color = {
	255,
	216,
	229,
	207
}
local terminal_button_small_text_style = table.clone(terminal_button_text_style)
terminal_button_small_text_style.font_size = terminal_button_text_style.font_size - 2
local terminal_button_hold_small_text_style = table.clone(terminal_button_text_style)
terminal_button_hold_small_text_style.font_size = terminal_button_text_style.font_size - 2
terminal_button_hold_small_text_style.text_color = {
	255,
	216,
	229,
	207
}
terminal_button_hold_small_text_style.default_color = {
	255,
	216,
	229,
	207
}
terminal_button_hold_small_text_style.hover_color = {
	0,
	216,
	229,
	207
}
terminal_button_hold_small_text_style.text_vertical_alignment = "bottom"
terminal_button_hold_small_text_style.vertical_alignment = "bottom"
terminal_button_hold_small_text_style.offset = {
	0,
	-10,
	6
}

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
	local color = nil

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

ButtonPassTemplates.terminal_button_change_function = terminal_button_change_function

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

ButtonPassTemplates.terminal_button_hover_change_function = terminal_button_hover_change_function

local function default_button_hover_change_function(content, style)
	local hotspot = content.hotspot
	local default_color = hotspot.disabled and style.disabled_color or style.default_color
	local hover_color = style.hover_color
	local color = style.text_color or style.color
	local progress = math.max(math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress), hotspot.anim_input_progress), hotspot.anim_select_progress)

	color_lerp(default_color, hover_color, progress, color)
end

ButtonPassTemplates.default_button_hover_change_function = default_button_hover_change_function

local function default_button_text_change_function(content, style)
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
	local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

	if color and default_color and hover_color then
		color_lerp(default_color, hover_color, progress, color)
	end
end

ButtonPassTemplates.terminal_list_button_background_change_function = function (content, style)
	local math_lerp = math_lerp
	local math_max = math_max
	local hotspot = content.hotspot
	local select_progress = hotspot.anim_select_progress or 0
	local hover_progress = math_max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
	local color = style.color
	local max_alpha = style.max_alpha
	local min_alpha = style.min_alpha
	local alpha = math_lerp(min_alpha, max_alpha, hover_progress)
	color[1] = alpha * select_progress
end

ButtonPassTemplates.terminal_list_button_frame_hover_change_function = function (content, style)
	local color_lerp = color_lerp
	local color_copy = color_copy
	local math_lerp = math_lerp
	local hotspot = content.hotspot
	local is_selected = hotspot.is_selected
	local hover_progress = math_max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
	local color = style.color

	if is_selected then
		color_copy(style.selected_color, color)
	else
		local default_color = style.default_color
		local hover_color = style.hover_color

		color_lerp(default_color, hover_color, hover_progress, color)
	end

	local min_alpha = style.min_alpha or color[1]
	local max_alpha = style.max_alpha or color[1]

	if min_alpha ~= max_alpha then
		color[1] = math_lerp(min_alpha, max_alpha, hover_progress)
	end

	local selected_layer = style.selected_layer

	if selected_layer then
		if is_selected then
			style.offset[3] = selected_layer
		else
			style.offset[3] = style.hover_layer
		end
	end
end

ButtonPassTemplates.terminal_list_button_text_change_function = function (content, style)
	local color_lerp = color_lerp
	local math_max = math_max
	local hotspot = content.hotspot
	local select_progress = hotspot.anim_select_progress
	local hover_progress = math_max(hotspot.anim_hover_progress - select_progress, 0)
	local color = style.text_color or style.color
	local default_color = style.default_color
	local hover_color = style.hover_color
	local focused_color = style.selected_color
	local progress, target_color = nil

	if hover_progress < select_progress then
		progress = select_progress
		target_color = focused_color
	else
		progress = hover_progress
		target_color = hover_color
	end

	color_lerp(default_color, target_color, progress, color)
end

local default_button_content = {
	on_hover_sound = UISoundEvents.default_mouse_hover
}
local simple_button_font_setting_name = "button_medium"
local simple_button_font_settings = UIFontSettings[simple_button_font_setting_name]
local simple_button_font_color = simple_button_font_settings.text_color
ButtonPassTemplates.simple_button = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		content = default_button_content
	},
	{
		pass_type = "rect",
		style = {
			color = {
				200,
				160,
				160,
				160
			}
		}
	},
	{
		pass_type = "rect",
		style = {
			color = {
				200,
				40,
				40,
				40
			},
			offset = {
				0,
				0,
				1
			}
		},
		change_function = function (content, style)
			style.color[1] = math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress) * 255
		end
	},
	{
		style_id = "text",
		pass_type = "text",
		value_id = "text",
		value = "Button",
		style = {
			text_vertical_alignment = "center",
			text_horizontal_alignment = "center",
			offset = {
				0,
				0,
				2
			},
			font_type = simple_button_font_settings.font_type,
			font_size = simple_button_font_settings.font_size,
			text_color = simple_button_font_color,
			default_text_color = simple_button_font_color
		},
		change_function = function (content, style)
			local default_text_color = style.default_text_color
			local text_color = style.text_color
			local progress = 1 - content.hotspot.anim_input_progress * 0.3
			text_color[2] = default_text_color[2] * progress
			text_color[3] = default_text_color[3] * progress
			text_color[4] = default_text_color[4] * progress
		end
	}
}
local default_button_text_style = table.clone(UIFontSettings.button_primary)
default_button_text_style.offset = {
	0,
	0,
	4
}
local ready_button_text_style = table.clone(UIFontSettings.button_primary)
ready_button_text_style.offset = {
	0,
	-8,
	4
}
ready_button_text_style.horizontal_alignment = "center"
ready_button_text_style.vertical_alignment = "center"
ready_button_text_style.font_size = 36
local aquila_button_text_style = table.clone(UIFontSettings.button_primary)
aquila_button_text_style.offset = {
	0,
	0,
	4
}
aquila_button_text_style.horizontal_alignment = "center"
aquila_button_text_style.vertical_alignment = "center"
aquila_button_text_style.font_size = 24
local url_text_style = table.clone(UIFontSettings.body)
url_text_style.text_horizontal_alignment = "center"
url_text_style.text_vertical_alignment = "center"
url_text_style.default_color = Color.ui_terminal(255, true)
url_text_style.font_type = "proxima_nova_bold"
url_text_style.hover_color = Color.white(255, true)
ButtonPassTemplates.url_button = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		content = default_button_content
	},
	{
		style_id = "text",
		pass_type = "text",
		value_id = "text",
		style = url_text_style,
		change_function = default_button_text_change_function
	},
	{
		value = "content/ui/materials/frames/hover",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			scale_to_material = true,
			hdr = false,
			color = Color.ui_terminal(255, true),
			size_addition = {
				20,
				20
			}
		},
		change_function = function (content, style)
			local anim_progress = math.max(math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress), content.hotspot.anim_focus_progress)
			style.color[1] = anim_progress * 255
			local size_addition = style.size_addition
			local size_padding = 20 - math.easeInCubic(anim_progress) * 10
			size_addition[1] = size_padding
			size_addition[2] = size_padding
		end
	},
	size_function = function (parent, config, ui_renderer)
		local text_width, text_height = UIRenderer.text_size(ui_renderer, Localize(config.text), url_text_style.font_type, url_text_style.font_size)

		return {
			text_width,
			text_height
		}
	end,
	init = function (parent, widget, ui_renderer, options)
		widget.content.text = string.format("{#under(true)}%s{#under(false)}", options.text)
	end
}
ButtonPassTemplates.default_button = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		content = default_button_content
	},
	{
		value = "content/ui/materials/backgrounds/terminal_basic",
		style_id = "background",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			size_addition = {
				-20,
				8
			},
			color = Color.terminal_grid_background(255, true),
			offset = {
				0,
				0,
				0
			}
		}
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			size_addition = {
				-60,
				-30
			},
			default_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				2
			}
		},
		change_function = function (content, style)
			terminal_button_change_function(content, style)
			terminal_button_hover_change_function(content, style)
		end,
		visibility_function = function (content, style)
			return not content.hotspot.disabled
		end
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			size_addition = {
				-60,
				-30
			},
			default_color = Color.terminal_frame(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				3
			}
		},
		change_function = default_button_hover_change_function,
		visibility_function = function (content, style)
			return not content.hotspot.disabled
		end
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			size_addition = {
				-60,
				-30
			},
			default_color = Color.terminal_corner(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				4
			}
		},
		change_function = default_button_hover_change_function,
		visibility_function = function (content, style)
			return not content.hotspot.disabled
		end
	},
	{
		pass_type = "rect",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size_addition = {
				-24,
				-14
			},
			color = {
				150,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				5
			}
		},
		visibility_function = function (content, style)
			return content.hotspot.disabled
		end
	},
	{
		style_id = "text",
		pass_type = "text",
		value_id = "text",
		style = terminal_button_text_style,
		change_function = default_button_text_change_function
	},
	{
		value = "content/ui/materials/buttons/primary",
		pass_type = "texture",
		style = {
			scale_to_material = true,
			offset = {
				0,
				0,
				7
			}
		}
	},
	size = {
		347,
		76
	}
}
local ready_button_small_button_size_addition = {
	-170,
	-54
}
ButtonPassTemplates.ready_button = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		content = default_button_content
	},
	{
		value = "content/ui/materials/buttons/ready_active",
		pass_type = "texture",
		style = {
			offset = {
				0,
				0,
				4
			}
		},
		visibility_function = function (content, style)
			return content.active
		end
	},
	{
		value = "content/ui/materials/buttons/ready_idle",
		pass_type = "texture",
		style = {
			offset = {
				0,
				0,
				4
			}
		},
		visibility_function = function (content, style)
			return not content.active
		end
	},
	{
		value = "content/ui/materials/backgrounds/terminal_basic",
		style_id = "background",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			size_addition = ready_button_small_button_size_addition,
			color = Color.terminal_grid_background(255, true),
			offset = {
				0,
				-8,
				0
			}
		}
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			size_addition = {
				-44 + ready_button_small_button_size_addition[1],
				-44 + ready_button_small_button_size_addition[2]
			},
			color = Color.terminal_background_gradient(nil, true),
			offset = {
				0,
				-8,
				2
			}
		},
		change_function = terminal_button_hover_change_function,
		visibility_function = function (content, style)
			return not content.hotspot.disabled
		end
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			size_addition = {
				-44 + ready_button_small_button_size_addition[1],
				-44 + ready_button_small_button_size_addition[2]
			},
			default_color = Color.terminal_frame(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				-8,
				3
			}
		},
		change_function = default_button_hover_change_function,
		visibility_function = function (content, style)
			return not content.hotspot.disabled
		end
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			size_addition = {
				-44 + ready_button_small_button_size_addition[1],
				-44 + ready_button_small_button_size_addition[2]
			},
			default_color = Color.terminal_corner(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				-8,
				4
			}
		},
		change_function = default_button_hover_change_function,
		visibility_function = function (content, style)
			return not content.hotspot.disabled
		end
	},
	{
		pass_type = "rect",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size_addition = {
				-40 + ready_button_small_button_size_addition[1],
				-30 + ready_button_small_button_size_addition[2]
			},
			color = {
				150,
				0,
				0,
				0
			},
			offset = {
				0,
				-8,
				3
			}
		},
		visibility_function = function (content, style)
			return content.hotspot.disabled
		end
	},
	{
		style_id = "text",
		pass_type = "text",
		value_id = "text",
		style = ready_button_text_style,
		change_function = default_button_text_change_function
	},
	size = {
		490,
		150
	}
}
local aquila_small_button_size_addition = {
	-90,
	-40
}
ButtonPassTemplates.aquila_button = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		content = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_click
		}
	},
	{
		value = "content/ui/materials/backgrounds/terminal_basic",
		style_id = "background",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			color = Color.terminal_grid_background_gradient(255, true),
			offset = {
				0,
				0,
				0
			}
		}
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			size_addition = {
				aquila_small_button_size_addition[1],
				aquila_small_button_size_addition[2]
			},
			color = Color.terminal_background_gradient(nil, true)
		},
		offset = {
			0,
			0,
			1
		},
		change_function = terminal_button_hover_change_function,
		visibility_function = function (content, style)
			return not content.hotspot.disabled
		end
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			size_addition = {
				aquila_small_button_size_addition[1],
				aquila_small_button_size_addition[2]
			},
			default_color = Color.terminal_frame(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				2
			}
		},
		change_function = default_button_hover_change_function,
		visibility_function = function (content, style)
			return not content.hotspot.disabled
		end
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			size_addition = {
				aquila_small_button_size_addition[1],
				aquila_small_button_size_addition[2]
			},
			default_color = Color.terminal_corner(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				3
			}
		},
		change_function = default_button_hover_change_function,
		visibility_function = function (content, style)
			return not content.hotspot.disabled
		end
	},
	{
		pass_type = "rect",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size_addition = {
				aquila_small_button_size_addition[1],
				aquila_small_button_size_addition[2]
			},
			color = {
				150,
				0,
				0,
				0
			},
			offset = {
				0,
				-8,
				3
			}
		},
		visibility_function = function (content, style)
			return content.hotspot.disabled
		end
	},
	{
		style_id = "text",
		pass_type = "text",
		value_id = "text",
		style = aquila_button_text_style,
		change_function = default_button_text_change_function
	},
	{
		value = "content/ui/materials/frames/premium_store/currency_button",
		pass_type = "texture",
		style = {
			offset = {
				0,
				0,
				4
			}
		}
	},
	size = {
		390,
		74
	}
}
local default_button_small_text_style = table.clone(UIFontSettings.button_primary)
default_button_small_text_style.offset = {
	0,
	0,
	5
}
default_button_small_text_style.text_horizontal_alignment = "center"
default_button_small_text_style.text_vertical_alignment = "center"
default_button_small_text_style.character_spacing = 0.1
default_button_small_text_style.font_size = 20
ButtonPassTemplates.default_button_small = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		content = default_button_content
	},
	{
		value = "content/ui/materials/backgrounds/terminal_basic",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			size_addition = {
				2,
				16
			},
			color = Color.terminal_grid_background(255, true),
			offset = {
				0,
				0,
				0
			}
		}
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			{
				0,
				0,
				1
			},
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size_addition = {
				-30,
				-20
			},
			default_color = Color.terminal_background(nil, true),
			selected_color = Color.terminal_background_selected(nil, true)
		},
		change_function = terminal_button_change_function
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size_addition = {
				-30,
				-20
			},
			color = Color.terminal_background_gradient(nil, true)
		},
		offset = {
			0,
			0,
			2
		},
		change_function = terminal_button_hover_change_function
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/inner_shadow_medium",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size_addition = {
				-30,
				-20
			},
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				3
			}
		},
		change_function = terminal_button_change_function
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			size_addition = {
				-30,
				-20
			},
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				3
			}
		},
		change_function = terminal_button_change_function
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			size_addition = {
				-30,
				-20
			},
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			offset = {
				0,
				0,
				4
			}
		},
		change_function = terminal_button_change_function
	},
	{
		style_id = "text",
		pass_type = "text",
		value_id = "text",
		style = default_button_small_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

			color_lerp(default_color, hover_color, progress, text_color)
		end
	},
	{
		value = "content/ui/materials/buttons/secondary",
		pass_type = "texture",
		style = {
			offset = {
				0,
				0,
				5
			}
		}
	},
	size = {
		347,
		50
	}
}
ButtonPassTemplates.default_button_large = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot"
	},
	{
		value = "content/ui/materials/buttons/floating_big_idle",
		style_id = "idle",
		pass_type = "texture",
		style = {
			size = {},
			color = Color.ui_terminal(255, true),
			offset = {
				0,
				0,
				0
			}
		}
	},
	{
		pass_type = "texture",
		style_id = "highlight",
		value = "content/ui/materials/buttons/floating_big_highlight",
		style = {
			hdr = true,
			default_color = Color.ui_terminal(255, true),
			disabled_color = Color.ui_grey_light(255, true),
			input_color = Color.ui_terminal(255, true),
			offset = {
				0,
				0,
				3
			}
		},
		change_function = function (content, style)
			local color = style.color
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local input_color = style.input_color
			local hover_progress = hotspot.anim_hover_progress
			local input_progress = hotspot.anim_input_progress
			local select_progress = hotspot.anim_select_progress
			color[1] = 255 * math.max(hover_progress, select_progress)
			local ignore_alpha = true

			color_lerp(default_color, input_color, input_progress, color, ignore_alpha)
		end
	},
	{
		pass_type = "text",
		style_id = "text",
		value_id = "text",
		style = table.clone(UIFontSettings.button_primary),
		change_function = function (content, style)
			local default_color = content.hotspot.disabled and style.disabled_color or style.default_color
			local hotspot = content.hotspot
			local hover_progress = hotspot.anim_hover_progress
			local select_progress = hotspot.anim_select_progress
			local progress = math.max(hover_progress, select_progress)

			color_lerp(default_color, style.hover_color, progress, style.text_color)

			style.material = progress == 1 and "content/ui/materials/base/ui_slug_hdr" or nil
		end
	}
}
ButtonPassTemplates.secondary_button_default_height = 64
ButtonPassTemplates.secondary_button = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot"
	},
	{
		pass_type = "texture",
		style_id = "highlight",
		value = "content/ui/materials/frames/hover",
		style = {
			hdr = true,
			scale_to_material = true,
			color = Color.ui_terminal(255, true),
			offset = {
				0,
				0,
				3
			}
		},
		change_function = function (content, style)
			local color = style.color
			local hotspot = content.hotspot
			color[1] = 255 * math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress)
		end
	},
	{
		pass_type = "text",
		style_id = "text",
		value_id = "text",
		style = table.clone(UIFontSettings.button_primary),
		change_function = function (content, style)
			local text_color = style.text_color
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local highlight_color = style.hover_color
			local hover_progress = math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress)
			local ignore_alpha = true

			color_lerp(default_color, highlight_color, hover_progress, text_color, ignore_alpha)
		end
	}
}
ButtonPassTemplates.terminal_button = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		content = default_button_content
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			default_color = Color.terminal_background(nil, true),
			selected_color = Color.terminal_background_selected(nil, true)
		},
		change_function = terminal_button_change_function
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
				1
			}
		},
		change_function = function (content, style)
			terminal_button_change_function(content, style)
			terminal_button_hover_change_function(content, style)
		end
	},
	{
		value = "content/ui/materials/frames/dropshadow_medium",
		style_id = "outer_shadow",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			scale_to_material = true,
			color = Color.black(200, true),
			size_addition = {
				20,
				20
			},
			offset = {
				0,
				0,
				3
			}
		}
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			disabled_color = Color.ui_grey_medium(255, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				3
			}
		},
		change_function = terminal_button_change_function
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			disabled_color = Color.ui_grey_light(255, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				4
			}
		},
		change_function = terminal_button_change_function
	},
	{
		style_id = "text",
		pass_type = "text",
		value_id = "text",
		style = terminal_button_text_style,
		change_function = default_button_text_change_function
	}
}
ButtonPassTemplates.terminal_button_icon = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		content = default_button_content
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			default_color = Color.terminal_background(nil, true),
			selected_color = Color.terminal_background_selected(nil, true)
		},
		change_function = terminal_button_change_function
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
				1
			}
		},
		change_function = function (content, style)
			terminal_button_change_function(content, style)
			terminal_button_hover_change_function(content, style)
		end
	},
	{
		value = "content/ui/materials/frames/dropshadow_medium",
		style_id = "outer_shadow",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			scale_to_material = true,
			color = Color.black(200, true),
			size_addition = {
				20,
				20
			},
			offset = {
				0,
				0,
				3
			}
		}
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			disabled_color = Color.ui_grey_medium(255, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				3
			}
		},
		change_function = terminal_button_change_function
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			disabled_color = Color.ui_grey_light(255, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				4
			}
		},
		change_function = terminal_button_change_function
	},
	{
		pass_type = "texture",
		value_id = "icon",
		style_id = "icon",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_text_header(255, true),
			disabled_color = Color.gray(255, true),
			color = Color.terminal_text_header(255, true),
			hover_color = Color.terminal_text_header_selected(255, true),
			size = {
				40,
				40
			},
			offset = {
				0,
				0,
				6
			}
		},
		change_function = ButtonPassTemplates.list_button_label_change_function
	}
}
ButtonPassTemplates.terminal_button.size = {
	340,
	60
}
ButtonPassTemplates.terminal_button_small = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = default_button_content
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			default_color = Color.terminal_background(nil, true),
			selected_color = Color.terminal_background_selected(nil, true)
		},
		change_function = terminal_button_change_function
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = Color.terminal_background_gradient(nil, true),
			offset = {
				0,
				0,
				1
			}
		},
		change_function = terminal_button_hover_change_function
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				2
			}
		},
		change_function = terminal_button_change_function
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			offset = {
				0,
				0,
				3
			}
		},
		change_function = terminal_button_change_function
	},
	{
		value = "content/ui/materials/frames/dropshadow_medium",
		style_id = "outer_shadow",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			scale_to_material = true,
			color = Color.black(200, true),
			size_addition = {
				20,
				20
			},
			offset = {
				0,
				0,
				3
			}
		}
	},
	{
		style_id = "text",
		pass_type = "text",
		value_id = "text",
		style = terminal_button_small_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

			color_lerp(default_color, hover_color, progress, text_color)
		end
	},
	size = {
		280,
		40
	}
}
ButtonPassTemplates.terminal_button_hold_small = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_complete_sound = UISoundEvents.default_click
		},
		style = {
			vertical_alignment = "top",
			horizontal_alignment = "center"
		}
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			default_color = Color.terminal_background(nil, true),
			selected_color = Color.terminal_background_selected(nil, true)
		},
		change_function = terminal_button_change_function
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
				1
			}
		},
		change_function = function (content, style)
			terminal_button_change_function(content, style)
			terminal_button_hover_change_function(content, style)
		end
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			vertical_alignment = "top",
			scale_to_material = true,
			horizontal_alignment = "center",
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				4
			}
		},
		change_function = terminal_button_change_function
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			vertical_alignment = "top",
			scale_to_material = true,
			horizontal_alignment = "center",
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			offset = {
				0,
				0,
				5
			}
		},
		change_function = terminal_button_change_function
	},
	{
		style_id = "hold",
		pass_type = "rect",
		style = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			color = {
				150,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				3
			},
			size = {
				0
			}
		},
		change_function = function (content, style)
			local progress = content.hold_progress or 0
			local total_width = content.size[1]
			style.size[1] = total_width * progress
		end
	},
	{
		value = "content/ui/materials/frames/dropshadow_medium",
		style_id = "outer_shadow",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			scale_to_material = true,
			color = Color.black(200, true),
			size_addition = {
				20,
				20
			},
			offset = {
				0,
				0,
				3
			}
		}
	},
	{
		style_id = "text",
		pass_type = "text",
		value_id = "text",
		style = terminal_button_small_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local gamepad_active = hotspot.gamepad_active
			local button_text = content.original_text or ""
			local gamepad_action = content.input_action

			if gamepad_active and gamepad_action and not hotspot.disabled and not content.ignore_gamepad_on_text then
				local service_type = "View"
				local alias_key = Managers.ui:get_input_alias_key(gamepad_action, service_type)
				local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)
				content.text = string.format("{#color(226,199,126)}%s %s{#reset()} %s", Localize("loc_input_hold"), input_text, button_text)
			else
				content.text = string.format("{#color(226,199,126)}%s{#reset()} %s", Localize("loc_input_hold"), button_text)
			end

			local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

			color_lerp(default_color, hover_color, progress, text_color)
		end
	},
	size = {
		280,
		40
	},
	init = function (parent, widget, ui_renderer, options)
		widget.content.timer = options.timer or 1
		widget.content.current_timer = 0
		widget.content.hold_progress = 0
		widget.content.complete_function = options.complete_function
		widget.content.hotspot.pressed_callback = nil
		widget.content.input_action = options.input_action or "confirm_hold"
		widget.content.original_text = options.text
		widget.content.ignore_gamepad_on_text = options.ignore_gamepad_on_text
		widget.content.hotspot.on_complete_sound = options.on_complete_sound
		widget.content.hotspot.hold_release = options.hold_release
		widget.content.hotspot.hold_sound = options.hold_sound
		local width = widget.content.size[1]
		local height = widget.content.size[2]
		widget.style.background.size = {
			width,
			height
		}
		widget.style.background_gradient.size = {
			width,
			height
		}
		widget.style.frame.size = {
			width,
			height
		}
		widget.style.corner.size = {
			width,
			height
		}
		widget.style.hold.size = {
			width,
			height
		}
		widget.style.hotspot.size = {
			width,
			height
		}
		widget.content.size[2] = height
		widget.style.text.offset[2] = -(widget.content.size[2] - height) * 0.5
	end,
	update = function (parent, widget, renderer, dt)
		local content = widget.content
		local hotspot = content.hotspot
		local hold_active = hotspot.on_pressed
		local input_service = renderer.input_service
		local input_action = content.input_action and input_service:get(content.input_action)
		local left_hold = input_service and (input_action or input_service:get("left_hold"))

		if not left_hold and content.hold_active then
			content.hold_active = nil
		elseif not content.hold_active then
			content.hold_active = hold_active
		end

		if content.hold_active then
			local total_time = content.timer
			local current_time = content.current_timer + dt
			local progress = math.min(current_time / total_time, 1)

			if progress < 1 then
				if hotspot.hold_sound and content.hold_progress == 0 then
					Managers.ui:play_2d_sound(hotspot.hold_sound)
				end

				content.current_timer = current_time
				content.hold_progress = progress

				return
			else
				content.current_timer = 0
				content.hold_progress = 0
				content.hold_active = false

				if hotspot.on_complete_sound then
					Managers.ui:play_2d_sound(hotspot.on_complete_sound)
				end

				if content.complete_function then
					content.complete_function()
				end

				return
			end
		elseif not content.hold_active and content.current_timer > 0 then
			content.current_timer = 0
			content.hold_progress = 0

			if hotspot.hold_release then
				Managers.ui:play_2d_sound(hotspot.hold_release)
			end
		end
	end
}
ButtonPassTemplates.list_button_default_height = 64
local list_button_highlight_size_addition = 10
local list_button_icon_size = {
	50,
	50
}
local list_button_hotspot_default_style = {
	anim_hover_speed = 8,
	anim_input_speed = 8,
	anim_select_speed = 8,
	anim_focus_speed = 8,
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_click
}

ButtonPassTemplates.list_button_highlight_change_function = function (content, style)
	local hotspot = content.hotspot
	local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
	style.color[1] = 255 * math.easeOutCubic(progress)
	local size_addition = list_button_highlight_size_addition * math.easeInCubic(1 - progress)
	local style_size_addition = style.size_addition
	style_size_addition[1] = size_addition * 2
	style_size_addition[2] = size_addition * 2
	local offset = style.offset
	offset[1] = -size_addition
	offset[2] = -size_addition
	style.hdr = progress == 1
end

ButtonPassTemplates.list_button_focused_visibility_function = function (content, style)
	local hotspot = content.hotspot

	return hotspot.is_hover or hotspot.is_selected or hotspot.is_focused
end

ButtonPassTemplates.list_button_label_change_function = function (content, style)
	local hotspot = content.hotspot
	local default_color = hotspot.disabled and style.disabled_color or style.default_color
	local hover_color = style.hover_color
	local color = style.text_color or style.color
	local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)

	color_lerp(default_color, hover_color, progress, color)
end

local list_button_text_style = table.clone(UIFontSettings.list_button)
list_button_text_style.offset[3] = 7
ButtonPassTemplates.list_button_with_background = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = {},
		style = list_button_hotspot_default_style
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			default_color = Color.terminal_background(nil, true),
			selected_color = Color.terminal_background_selected(nil, true)
		},
		change_function = terminal_button_change_function
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
			disabled_color = UIFontSettings.list_button.disabled_color,
			offset = {
				0,
				0,
				1
			}
		},
		change_function = function (content, style)
			terminal_button_change_function(content, style)
			terminal_button_hover_change_function(content, style)
		end
	},
	{
		value = "content/ui/materials/frames/dropshadow_medium",
		style_id = "outer_shadow",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			scale_to_material = true,
			color = Color.black(200, true),
			size_addition = {
				20,
				20
			},
			offset = {
				0,
				0,
				3
			}
		}
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			scale_to_material = true,
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				12
			}
		},
		change_function = terminal_button_change_function
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			scale_to_material = true,
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = Color.terminal_corner(nil, true),
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				13
			}
		},
		change_function = terminal_button_change_function
	},
	{
		pass_type = "texture",
		style_id = "arrow_highlight",
		value = "content/ui/materials/buttons/arrow_01",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			size = {
				12,
				18
			},
			default_color = Color.terminal_icon(255, true),
			offset = {
				-30,
				0,
				5
			},
			default_offset = {
				-40,
				0,
				5
			},
			size_addition = {
				0,
				0
			},
			disabled_color = UIFontSettings.list_button.disabled_color,
			hover_color = UIFontSettings.list_button.hover_color
		},
		change_function = function (content, style)
			local hotspot = content.hotspot
			local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
			local size_addition = 2 * math.easeInCubic(progress)
			local style_size_addition = style.size_addition
			style_size_addition[1] = size_addition * 2
			style_size_addition[2] = size_addition * 2
			local offset = style.offset
			local default_offset = style.default_offset

			ButtonPassTemplates.list_button_label_change_function(content, style)
		end
	},
	{
		pass_type = "text",
		style_id = "text",
		value_id = "text",
		style = list_button_text_style,
		change_function = ButtonPassTemplates.list_button_label_change_function
	}
}
local list_icon_button_text_style = table.clone(UIFontSettings.list_button)
list_icon_button_text_style.offset[1] = 70
list_icon_button_text_style.offset[3] = 7
ButtonPassTemplates.terminal_list_button_with_background_and_icon = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = {},
		style = list_button_hotspot_default_style
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			default_color = Color.terminal_background(nil, true),
			selected_color = Color.terminal_background_selected(nil, true)
		},
		change_function = terminal_button_change_function
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
				1
			}
		},
		change_function = function (content, style)
			terminal_button_change_function(content, style)
			terminal_button_hover_change_function(content, style)
		end
	},
	{
		value = "content/ui/materials/frames/dropshadow_medium",
		style_id = "outer_shadow",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			scale_to_material = true,
			color = Color.black(200, true),
			size_addition = {
				20,
				20
			},
			offset = {
				0,
				0,
				3
			}
		}
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			disabled_color = Color.ui_grey_medium(255, true),
			offset = {
				0,
				0,
				2
			}
		},
		change_function = terminal_button_change_function
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			disabled_color = Color.ui_grey_light(255, true),
			offset = {
				0,
				0,
				3
			}
		},
		change_function = terminal_button_change_function
	},
	{
		pass_type = "texture",
		style_id = "arrow_highlight",
		value = "content/ui/materials/buttons/arrow_01",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			size = {
				12,
				18
			},
			default_color = Color.terminal_icon(255, true),
			offset = {
				-30,
				0,
				5
			},
			default_offset = {
				-40,
				0,
				5
			},
			size_addition = {
				0,
				0
			},
			disabled_color = UIFontSettings.list_button.disabled_color,
			hover_color = UIFontSettings.list_button.hover_color
		},
		change_function = function (content, style)
			local hotspot = content.hotspot
			local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
			local size_addition = 2 * math.easeInCubic(progress)
			local style_size_addition = style.size_addition
			style_size_addition[1] = size_addition * 2
			style_size_addition[2] = size_addition * 2
			local offset = style.offset
			local default_offset = style.default_offset

			ButtonPassTemplates.list_button_label_change_function(content, style)
		end
	},
	{
		pass_type = "text",
		style_id = "text",
		value_id = "text",
		style = list_icon_button_text_style,
		change_function = ButtonPassTemplates.list_button_label_change_function
	},
	{
		pass_type = "texture",
		value_id = "icon",
		style_id = "icon",
		style = {
			vertical_alignment = "center",
			default_color = Color.terminal_text_header(255, true),
			disabled_color = Color.gray(255, true),
			color = Color.terminal_text_header(255, true),
			hover_color = Color.terminal_text_header_selected(255, true),
			size = {
				50,
				50
			},
			offset = {
				9,
				0,
				6
			}
		},
		change_function = ButtonPassTemplates.list_button_label_change_function
	}
}
local list_button_with_icon_text_style = table.clone(UIFontSettings.list_button)
list_button_with_icon_text_style.offset[1] = 64
local list_button_with_icon_icon_style = {
	vertical_alignment = "center",
	color = list_button_with_icon_text_style.text_color,
	default_color = list_button_with_icon_text_style.default_text_color,
	disabled_color = list_button_with_icon_text_style.disabled_color,
	hover_color = list_button_with_icon_text_style.hover_color,
	size = list_button_icon_size,
	offset = {
		9,
		0,
		3
	}
}
ButtonPassTemplates.list_button_with_background_and_icon = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = {
			use_is_focused = true
		},
		style = list_button_hotspot_default_style
	},
	{
		pass_type = "texture",
		style_id = "background_selected",
		value = "content/ui/materials/buttons/background_selected",
		style = {
			color = Color.ui_terminal(0, true),
			offset = {
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			style.color[1] = 255 * content.hotspot.anim_select_progress
		end,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/buttons/background_selected",
		style = {
			color = Color.ui_terminal(0, true),
			offset = {
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			local hotspot = content.hotspot
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)
			style.color[1] = 120 + progress * 135
		end
	},
	{
		pass_type = "texture",
		style_id = "arrow_highlight",
		value = "content/ui/materials/buttons/arrow_01",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			hdr = true,
			size = {
				12,
				18
			},
			color = Color.ui_terminal(255, true),
			offset = {
				-30,
				0,
				3
			},
			default_offset = {
				-40,
				0,
				3
			},
			size_addition = {
				0,
				0
			}
		},
		change_function = function (content, style)
			local hotspot = content.hotspot
			local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
			local size_addition = 2 * math.easeInCubic(progress)
			local style_size_addition = style.size_addition
			style_size_addition[1] = size_addition * 2
			style_size_addition[2] = size_addition * 2
			local offset = style.offset
			local default_offset = style.default_offset
			offset[1] = default_offset[1] + size_addition * 6
			style.hdr = progress == 1
		end
	},
	{
		pass_type = "texture",
		style_id = "highlight",
		value = "content/ui/materials/frames/hover",
		style = {
			hdr = true,
			scale_to_material = true,
			color = Color.ui_terminal(255, true),
			offset = {
				0,
				0,
				3
			},
			size_addition = {
				0,
				0
			}
		},
		change_function = ButtonPassTemplates.list_button_highlight_change_function,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		pass_type = "texture",
		value_id = "icon",
		style_id = "icon",
		style = table.clone(list_button_with_icon_icon_style),
		change_function = ButtonPassTemplates.list_button_label_change_function
	},
	{
		pass_type = "text",
		style_id = "text",
		value_id = "text",
		style = table.clone(UIFontSettings.list_button),
		change_function = ButtonPassTemplates.list_button_label_change_function
	}
}
ButtonPassTemplates.terminal_list_divider_height = 2
ButtonPassTemplates.terminal_list_divider = {
	{
		value_id = "divider",
		style_id = "divider",
		pass_type = "texture",
		value = "content/ui/materials/dividers/divider_line_01",
		style = {
			vertical_alignment = "bottom",
			color = Color.terminal_frame(128, true),
			offset = {
				0,
				0,
				2
			},
			size = {
				[2] = ButtonPassTemplates.terminal_list_divider_height
			}
		}
	}
}
ButtonPassTemplates.terminal_list_button_vertical_spacing = -2
ButtonPassTemplates.terminal_list_button = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = {
			use_is_focused = true,
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_click,
			on_select_sound = UISoundEvents.default_click
		}
	},
	{
		style_id = "background",
		pass_type = "texture",
		value = "content/ui/materials/backgrounds/default_square",
		value_id = "background",
		style = {
			scale_to_material = true,
			max_alpha = 64,
			min_alpha = 24,
			color = Color.terminal_background_selected(nil, true),
			size_addition = {
				0,
				-2 * ButtonPassTemplates.terminal_list_divider_height
			},
			offset = {
				0,
				ButtonPassTemplates.terminal_list_divider_height,
				0
			}
		},
		change_function = ButtonPassTemplates.terminal_list_button_background_change_function,
		visibility_function = function (content, style)
			return content.hotspot.is_selected
		end
	},
	{
		style_id = "background_gradient",
		pass_type = "texture",
		value = "content/ui/materials/masks/gradient_horizontal_sides_02",
		value_id = "background_gradient",
		style = {
			scale_to_material = true,
			max_alpha = 255,
			min_alpha = 150,
			color = Color.terminal_background_gradient(nil, true),
			default_color = Color.terminal_background_gradient(nil, true),
			hover_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_background_selected(nil, true),
			size_addition = {
				0,
				-2 * ButtonPassTemplates.terminal_list_divider_height
			},
			offset = {
				0,
				ButtonPassTemplates.terminal_list_divider_height,
				1
			}
		},
		change_function = ButtonPassTemplates.terminal_list_button_frame_hover_change_function,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		style_id = "frame",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_tile_2px",
		value_id = "frame",
		style = {
			hover_layer = 7,
			selected_layer = 8,
			scale_to_material = true,
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				6
			}
		},
		change_function = ButtonPassTemplates.terminal_list_button_frame_hover_change_function,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		style_id = "corner",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_corner_2px",
		value_id = "corner",
		style = {
			hover_layer = 10,
			selected_layer = 11,
			scale_to_material = true,
			color = Color.terminal_corner(nil, true),
			default_color = Color.terminal_corner(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			offset = {
				0,
				0,
				9
			}
		},
		change_function = ButtonPassTemplates.terminal_list_button_frame_hover_change_function,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		value_id = "divider_top",
		style_id = "divider_top",
		pass_type = "texture",
		value = "content/ui/materials/dividers/divider_line_01",
		style = {
			vertical_alignment = "top",
			color = Color.terminal_frame(128, true),
			offset = {
				0,
				0,
				1
			},
			size = {
				[2] = ButtonPassTemplates.terminal_list_divider_height
			}
		},
		visibility_function = function (content, style)
			return content.show_top_divider
		end
	},
	{
		value_id = "divider",
		style_id = "divider",
		pass_type = "texture",
		value = "content/ui/materials/dividers/divider_line_01",
		style = {
			vertical_alignment = "bottom",
			color = Color.terminal_frame(128, true),
			offset = {
				0,
				0,
				2
			},
			size = {
				[2] = ButtonPassTemplates.terminal_list_divider_height
			}
		}
	},
	{
		style_id = "bullet",
		pass_type = "texture",
		value = "content/ui/materials/icons/system/page_indicator_02_idle",
		value_id = "bullet",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			size = {
				32,
				32
			},
			offset = {
				15,
				0,
				3
			},
			color = Color.terminal_text_body(255, true),
			default_color = Color.terminal_text_body(255, true),
			hover_color = Color.terminal_text_header(255, true),
			selected_color = Color.terminal_text_header_selected(255, true)
		},
		change_function = ButtonPassTemplates.terminal_list_button_text_change_function
	},
	{
		style_id = "bullet_active",
		pass_type = "texture",
		value = "content/ui/materials/icons/system/page_indicator_02_active",
		value_id = "bullet_active",
		style = {
			vertical_alignment = "center",
			max_alpha = 255,
			horizontal_alignment = "left",
			min_alpha = 0,
			size = {
				32,
				32
			},
			offset = {
				15,
				0,
				4
			},
			color = Color.terminal_text_body(255, true),
			default_color = Color.terminal_text_body(255, true),
			hover_color = Color.terminal_text_header(255, true),
			selected_color = Color.terminal_text_header_selected(255, true)
		},
		change_function = ButtonPassTemplates.terminal_list_button_frame_hover_change_function,
		visibility_function = function (content, style)
			local hotspot = content.hotspot
			local is_hovered = hotspot.is_hover or hotspot.is_focused
			local was_hovered = hotspot.anim_hover_progress > 0 or hotspot.anim_focus_progress > 0

			return is_hovered or was_hovered
		end
	},
	{
		style_id = "text",
		pass_type = "text",
		value = "",
		value_id = "text",
		style = table.clone(UIFontSettings.list_button),
		change_function = ButtonPassTemplates.terminal_list_button_text_change_function
	}
}
ButtonPassTemplates.list_button = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = {
			use_is_focused = true
		},
		style = list_button_hotspot_default_style
	},
	{
		pass_type = "texture",
		style_id = "background_selected",
		value = "content/ui/materials/buttons/background_selected",
		style = {
			color = Color.terminal_corner_hover(0, true),
			offset = {
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			local hotspot = content.hotspot
			local hover_progress = content.show_background_with_hover and math_max(hotspot.anim_hover_progress, hotspot.anim_focus_progress) or 0
			style.color[1] = 255 * math_max(content.hotspot.anim_select_progress, hover_progress)
		end,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		pass_type = "texture",
		style_id = "highlight",
		value = "content/ui/materials/frames/hover",
		style = {
			hdr = true,
			scale_to_material = true,
			color = Color.terminal_corner_hover(255, true),
			offset = {
				0,
				0,
				3
			},
			size_addition = {
				0,
				0
			}
		},
		change_function = ButtonPassTemplates.list_button_highlight_change_function,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		pass_type = "text",
		style_id = "text",
		value_id = "text",
		style = table.clone(UIFontSettings.list_button),
		change_function = ButtonPassTemplates.list_button_label_change_function
	}
}
local list_button_large_text_style = table.clone(UIFontSettings.list_button)
list_button_large_text_style.font_size = 36
list_button_large_text_style.offset = {
	50,
	-2,
	2
}
ButtonPassTemplates.list_button_large_default_height = 128
ButtonPassTemplates.list_button_large = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = {
			use_is_focused = true
		},
		style = list_button_hotspot_default_style
	},
	{
		pass_type = "texture",
		style_id = "background_selected",
		value = "content/ui/materials/buttons/background_selected",
		style = {
			color = Color.ui_terminal(0, true),
			offset = {
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			style.color[1] = 255 * content.hotspot.anim_select_progress
		end,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		pass_type = "texture",
		style_id = "highlight",
		value = "content/ui/materials/frames/hover",
		style = {
			hdr = true,
			scale_to_material = true,
			color = Color.ui_terminal(255, true),
			offset = {
				0,
				0,
				3
			},
			size_addition = {
				0,
				0
			}
		},
		change_function = ButtonPassTemplates.list_button_highlight_change_function,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		pass_type = "text",
		style_id = "text",
		value_id = "text",
		style = table.clone(list_button_large_text_style),
		change_function = ButtonPassTemplates.list_button_label_change_function
	}
}
local list_button_caption_text_style = table.clone(list_button_large_text_style)
list_button_caption_text_style.offset[2] = -15
local list_button_sub_caption_text_style = table.clone(UIFontSettings.list_button)
list_button_sub_caption_text_style.offset[2] = 25
ButtonPassTemplates.list_button_large_with_info = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = {
			use_is_focused = true
		},
		style = list_button_hotspot_default_style
	},
	{
		pass_type = "texture",
		style_id = "background_selected",
		value = "content/ui/materials/buttons/background_selected",
		style = {
			color = Color.ui_terminal(0, true),
			offset = {
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			style.color[1] = 255 * content.hotspot.anim_select_progress
		end,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		pass_type = "texture",
		style_id = "highlight",
		value = "content/ui/materials/frames/hover",
		style = {
			hdr = true,
			scale_to_material = true,
			color = Color.ui_terminal(255, true),
			offset = {
				0,
				0,
				3
			},
			size_addition = {
				0,
				0
			}
		},
		change_function = ButtonPassTemplates.list_button_highlight_change_function,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		pass_type = "text",
		style_id = "text",
		value_id = "text",
		style = table.clone(list_button_caption_text_style),
		change_function = ButtonPassTemplates.list_button_label_change_function
	},
	{
		pass_type = "text",
		style_id = "sub_caption",
		value_id = "sub_caption",
		style = table.clone(list_button_sub_caption_text_style),
		change_function = ButtonPassTemplates.list_button_label_change_function
	}
}
ButtonPassTemplates.list_button_with_icon = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = {
			use_is_focused = true
		},
		style = list_button_hotspot_default_style
	},
	{
		pass_type = "texture",
		style_id = "background_selected",
		value = "content/ui/materials/buttons/background_selected",
		style = {
			color = Color.terminal_corner_hover(0, true),
			offset = {
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			style.color[1] = 255 * content.hotspot.anim_select_progress
		end,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		pass_type = "texture",
		style_id = "highlight",
		value = "content/ui/materials/frames/hover",
		style = {
			hdr = true,
			scale_to_material = true,
			color = Color.terminal_corner_hover(255, true),
			offset = {
				0,
				0,
				3
			},
			size_addition = {
				0,
				0
			}
		},
		change_function = ButtonPassTemplates.list_button_highlight_change_function,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		pass_type = "texture",
		value_id = "icon",
		style_id = "icon",
		style = table.clone(list_button_with_icon_icon_style),
		change_function = ButtonPassTemplates.list_button_label_change_function,
		visibility_function = function (content, style)
			return not not content.icon
		end
	},
	{
		pass_type = "text",
		style_id = "text",
		value_id = "text",
		style = table.clone(list_button_with_icon_text_style),
		change_function = ButtonPassTemplates.list_button_label_change_function
	}
}
local list_button_with_two_rows_text_style = table.clone(list_button_with_icon_text_style)
list_button_with_two_rows_text_style.offset[2] = -12
ButtonPassTemplates.list_button_two_rows_with_icon = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = {
			use_is_focused = true
		},
		style = list_button_hotspot_default_style
	},
	{
		pass_type = "texture",
		style_id = "background_selected",
		value = "content/ui/materials/buttons/background_selected",
		style = {
			color = Color.ui_terminal(0, true),
			offset = {
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			local hotspot = content.hotspot
			local hover_progress = content.show_background_with_hover and hotspot.anim_hover_progress or 0
			style.color[1] = 255 * math_max(content.hotspot.anim_select_progress, hover_progress)
		end,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		pass_type = "texture",
		style_id = "highlight",
		value = "content/ui/materials/frames/hover",
		style = {
			hdr = true,
			scale_to_material = true,
			color = Color.ui_terminal(255, true),
			offset = {
				0,
				0,
				3
			},
			size_addition = {
				0,
				0
			}
		},
		change_function = ButtonPassTemplates.list_button_highlight_change_function,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		pass_type = "texture",
		value_id = "icon",
		style_id = "icon",
		style = table.clone(list_button_with_icon_icon_style),
		change_function = ButtonPassTemplates.list_button_label_change_function
	},
	{
		pass_type = "text",
		style_id = "text",
		value_id = "text",
		style = table.clone(list_button_with_two_rows_text_style),
		change_function = ButtonPassTemplates.list_button_label_change_function
	},
	{
		pass_type = "text",
		style_id = "second_row",
		value_id = "second_row",
		style = table.clone(UIFontSettings.list_button_second_row),
		change_function = ButtonPassTemplates.list_button_label_change_function
	}
}
local continue_button_text_style = table.clone(UIFontSettings.header_3)
continue_button_text_style.offset = {
	-25,
	0,
	2
}
continue_button_text_style.text_horizontal_alignment = "right"
continue_button_text_style.text_vertical_alignment = "center"
continue_button_text_style.hover_color = Color.ui_grey_light(255, true)
continue_button_text_style.default_text_color = {
	255,
	255,
	255,
	255
}
continue_button_text_style.text_color = {
	255,
	255,
	255,
	255
}
ButtonPassTemplates.continue_button = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		content = default_button_content
	},
	{
		value = "content/ui/materials/buttons/arrow_01",
		style_id = "arrow",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			size = {
				11.5,
				17
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				2
			}
		}
	},
	{
		value = "content/ui/materials/buttons/arrow_01",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			size = {
				11.5,
				17
			},
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				1,
				1,
				1
			}
		}
	},
	{
		pass_type = "text",
		value_id = "text",
		style = continue_button_text_style,
		change_function = function (content, style)
			local default_text_color = style.default_text_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local hotspot = content.hotspot
			local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress)
			local arrow_style = style.parent.arrow
			local arrow_color = arrow_style.color

			for i = 2, 4 do
				text_color[i] = (hover_color[i] - default_text_color[i]) * progress + default_text_color[i]
				arrow_color[i] = text_color[i]
			end
		end
	}
}
local menu_panel_button_style = table.clone(UIFontSettings.header_3)
menu_panel_button_style.text_horizontal_alignment = "center"
menu_panel_button_style.text_vertical_alignment = "center"
menu_panel_button_style.offset = {
	0,
	0,
	3
}
local menu_panel_button_hotspot_content = {
	on_hover_sound = UISoundEvents.tab_button_hovered
}
ButtonPassTemplates.menu_panel_button = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = menu_panel_button_hotspot_content,
		style = {
			anim_select_speed = 4
		}
	},
	{
		value_id = "divider_bottom",
		style_id = "divider_bottom",
		pass_type = "texture",
		value = "content/ui/materials/dividers/skull_rendered_center_03",
		style = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			scale_to_material = true,
			size = {
				nil,
				26
			},
			offset = {
				0,
				20,
				2
			}
		},
		visibility_function = function (content, style)
			return content.hotspot.is_selected
		end
	},
	{
		style_id = "glow",
		pass_type = "texture",
		value = "content/ui/materials/effects/wide_upward_glow",
		value_id = "glow",
		style = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			color = Color.ui_terminal(255, true),
			size = {
				nil,
				0
			},
			size_addition = {
				-5,
				0
			},
			offset = {
				0,
				-3,
				1
			}
		},
		change_function = function (content, style)
			style.color[1] = 255 * math.easeOutCubic(content.hotspot.anim_select_progress)
			style.size_addition[2] = 80 * content.hotspot.anim_select_progress
		end,
		visibility_function = function (content, style)
			return content.hotspot.is_selected
		end
	},
	{
		pass_type = "text",
		style_id = "text",
		value_id = "text",
		style = menu_panel_button_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = hotspot.disabled and style.disabled_color or style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress, hotspot.anim_hover_progress, hotspot.anim_input_progress)

			color_lerp(default_text_color, hover_color, progress, text_color)
		end
	},
	{
		style_id = "alert_dot",
		pass_type = "texture",
		value = "content/ui/materials/symbols/new_item_indicator",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			size = {
				80,
				80
			},
			offset = {
				25,
				-15,
				2
			},
			color = Color.ui_terminal(255, true)
		},
		visibility_function = function (content)
			return content.show_alert
		end
	}
}
local tab_menu_button_hotspot_content = {
	on_hover_sound = UISoundEvents.tab_secondary_button_hovered,
	on_pressed_sound = UISoundEvents.tab_secondary_button_pressed
}
ButtonPassTemplates.tab_menu_button = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = tab_menu_button_hotspot_content
	},
	{
		style_id = "glow",
		pass_type = "texture",
		value = "content/ui/materials/effects/wide_upward_glow",
		value_id = "glow",
		style = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			color = Color.ui_terminal(255, true),
			size = {
				nil,
				0
			},
			size_addition = {
				0,
				0
			},
			offset = {
				0,
				-3,
				2
			}
		},
		change_function = function (content, style)
			local hotspot = content.hotspot
			local progress = math_max(hotspot.anim_focus_progress, hotspot.anim_select_progress)
			style.color[1] = 255 * math.easeOutCubic(progress)
			style.size_addition[2] = 80 * progress
		end,
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return hotspot.anim_focus_progress > 0 or hotspot.anim_select_progress > 0
		end
	},
	{
		style_id = "text",
		pass_type = "text",
		value_id = "text",
		style = table.clone(UIFontSettings.tab_menu_button),
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return hotspot.anim_hover_progress < 1 and hotspot.anim_focus_progress < 1 and hotspot.anim_select_progress < 1 and hotspot.anim_input_progress < 1
		end
	},
	{
		style_id = "text_hover",
		pass_type = "text",
		value_id = "text",
		style = table.clone(UIFontSettings.tab_menu_button_hover),
		change_function = function (content, style)
			local hotspot = content.hotspot
			local text_color = style.text_color
			local math_max = math_max
			local progress = math_max(math_max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math_max(hotspot.anim_hover_progress, hotspot.anim_input_progress))
			text_color[1] = 255 * math.easeInCubic(progress)
		end,
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return hotspot.anim_hover_progress > 0 or hotspot.anim_focus_progress > 0 or hotspot.anim_select_progress > 0 or hotspot.anim_input_progress > 0
		end
	}
}
ButtonPassTemplates.terminal_tab_menu_button = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = tab_menu_button_hotspot_content
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			size_addition = {
				0,
				0
			},
			color = Color.terminal_background_gradient(nil, true),
			offset = {
				0,
				0,
				1
			}
		},
		change_function = terminal_button_hover_change_function,
		visibility_function = function (content, style)
			return ButtonPassTemplates.list_button_focused_visibility_function(content, style) and content.hotspot.is_hover
		end
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			default_color = Color.terminal_frame(nil, true),
			hover_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				2
			}
		},
		change_function = terminal_button_change_function,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			default_color = Color.terminal_corner(nil, true),
			hover_color = Color.terminal_corner_selected(nil, true),
			offset = {
				0,
				0,
				3
			}
		},
		change_function = terminal_button_change_function,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		style_id = "text",
		pass_type = "text",
		value_id = "text",
		style = terminal_button_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

			color_lerp(default_color, hover_color, progress, text_color)
		end
	}
}
ButtonPassTemplates.terminal_tab_menu_with_divider_button = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = tab_menu_button_hotspot_content
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			size_addition = {
				0,
				0
			},
			color = Color.terminal_background_gradient(nil, true),
			offset = {
				0,
				0,
				1
			}
		},
		change_function = terminal_button_hover_change_function,
		visibility_function = function (content, style)
			return ButtonPassTemplates.list_button_focused_visibility_function(content, style) and content.hotspot.is_hover
		end
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			default_color = Color.terminal_frame(nil, true),
			hover_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				2
			}
		},
		change_function = terminal_button_change_function,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			default_color = Color.terminal_corner(nil, true),
			hover_color = Color.terminal_corner_selected(nil, true),
			offset = {
				0,
				0,
				3
			}
		},
		change_function = terminal_button_change_function,
		visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
	},
	{
		style_id = "text",
		pass_type = "text",
		value_id = "text",
		style = terminal_button_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

			color_lerp(default_color, hover_color, progress, text_color)
		end
	},
	{
		value = "content/ui/materials/dividers/faded_line_01",
		pass_type = "rotated_texture",
		style_id = "divider",
		style = {
			horizontal_alignment = "right",
			color = Color.terminal_frame(255, true),
			size = {
				2
			},
			offset = {
				11,
				0,
				1
			}
		}
	}
}
ButtonPassTemplates.tab_menu_button_icon = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = tab_menu_button_hotspot_content
	},
	{
		style_id = "glow",
		pass_type = "texture",
		value = "content/ui/materials/effects/wide_upward_glow",
		value_id = "glow",
		style = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			color = Color.ui_terminal(255, true),
			size = {
				nil,
				0
			},
			size_addition = {
				0,
				0
			},
			offset = {
				0,
				8,
				2
			}
		},
		change_function = function (content, style)
			local hotspot = content.hotspot
			local progress = math_max(hotspot.anim_focus_progress, hotspot.anim_select_progress)
			style.color[1] = 255 * math.easeOutCubic(progress)
			style.size_addition[2] = 80 * progress
		end,
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return hotspot.anim_focus_progress > 0 or hotspot.anim_select_progress > 0
		end
	},
	{
		style_id = "icon",
		pass_type = "texture",
		value_id = "icon",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			default_color = Color.ui_brown_light(255, true),
			hover_color = Color.ui_brown_super_light(255, true),
			disabled_color = Color.ui_grey_medium(255, true),
			color = {
				255,
				255,
				255,
				255
			},
			size = {
				50,
				50
			}
		},
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local hover_color = style.hover_color
			local color = style.color
			local math_max = math_max
			local progress = math_max(math_max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math_max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

			color_lerp(default_color, hover_color, progress, color)
		end
	}
}
ButtonPassTemplates.page_indicator = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = tab_menu_button_hotspot_content
	},
	{
		value_id = "icon",
		pass_type = "texture",
		style_id = "icon",
		value = "content/ui/materials/icons/system/page_indicator_active",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			default_color = Color.ui_grey_medium(255, true),
			hover_color = Color.ui_brown_super_light(255, true),
			disabled_color = Color.ui_grey_medium(255, true),
			color = {
				255,
				255,
				255,
				255
			},
			size = {
				20,
				20
			}
		},
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local hover_color = style.hover_color
			local color = style.color
			local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

			color_lerp(default_color, hover_color, progress, color)
		end
	}
}
ButtonPassTemplates.page_indicator_terminal = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = tab_menu_button_hotspot_content
	},
	{
		value = "content/ui/materials/icons/system/page_indicator_02_idle",
		style_id = "idle",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				32,
				32
			},
			color = Color.terminal_text_body(255, true)
		}
	},
	{
		style_id = "active",
		pass_type = "texture",
		value = "content/ui/materials/icons/system/page_indicator_02_active",
		style = {
			vertical_alignment = "center",
			hdr = true,
			horizontal_alignment = "center",
			size = {
				32,
				32
			},
			color = Color.terminal_text_header(255, true)
		},
		visibility_function = function (content, style)
			return content.hotspot.is_focused
		end
	}
}
local input_legend_button_style = table.clone(UIFontSettings.input_legend_button)
ButtonPassTemplates.input_legend_button = {
	{
		style_id = "text",
		pass_type = "text",
		value_id = "text",
		style = input_legend_button_style,
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
		content = default_button_content
	}
}
ButtonPassTemplates.title_back_button = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = default_button_content
	},
	{
		value = "content/ui/materials/icons/system/return",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			hdr = false,
			horizontal_alignment = "center",
			size_addition = {
				-32,
				-32
			},
			offset = {
				0,
				0,
				1
			},
			color = Color.ui_brown_light(255, true)
		}
	},
	{
		value = "content/ui/materials/buttons/rhombus",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			hdr = false,
			horizontal_alignment = "center",
			offset = {
				0,
				0,
				0
			},
			color = Color.ui_brown_medium(255, true)
		}
	},
	{
		value = "content/ui/materials/buttons/rhombus_highlight",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			hdr = true,
			horizontal_alignment = "center",
			offset = {
				0,
				0,
				2
			},
			color = Color.ui_highlight_color(255, true)
		},
		change_function = function (content, style)
			style.color[1] = content.hotspot.anim_hover_progress * 255
		end
	}
}

ButtonPassTemplates.settings_button = function (width, height, settings_area_width, use_is_focused)
	local header_width = width - settings_area_width
	local font_style = table.clone(UIFontSettings.button_primary)
	font_style.offset = {
		header_width,
		0,
		3
	}
	font_style.size = {
		settings_area_width,
		height
	}
	local passes = ListHeaderPassTemplates.list_header(header_width, height, use_is_focused)
	local button_passes = {
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/hover",
			style = {
				hdr = true,
				scale_to_material = true,
				color = Color.terminal_corner(255, true),
				offset = {
					header_width,
					0,
					3
				},
				size = {
					settings_area_width,
					height
				}
			},
			change_function = function (content, style)
				local color = style.color
				local hotspot = content.hotspot
				color[1] = 255 * math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress)
			end
		},
		{
			value = "content/ui/materials/buttons/background_selected",
			pass_type = "texture",
			style = {
				offset = {
					header_width,
					0,
					3
				},
				size = {
					settings_area_width,
					height
				},
				color = Color.terminal_corner(255, true)
			}
		},
		{
			pass_type = "rect",
			style = {
				size = {
					settings_area_width,
					height
				},
				offset = {
					header_width,
					0,
					2
				},
				color = Color.terminal_corner(25.5, true)
			}
		},
		{
			pass_type = "text",
			style_id = "text",
			value_id = "button_text",
			style = font_style,
			change_function = function (content, style)
				local text_color = style.text_color
				local hotspot = content.hotspot
				local default_color = (hotspot.disabled or content.disabled) and style.disabled_color or style.default_color
				local highlight_color = style.hover_color
				local hover_progress = math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress)
				local ignore_alpha = true

				color_lerp(default_color, highlight_color, hover_progress, text_color, ignore_alpha)
			end
		}
	}

	table.append(passes, button_passes)

	return passes
end

ButtonPassTemplates.item_category_tab_menu_button = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = tab_menu_button_hotspot_content,
		style = {
			on_hover_sound = UISoundEvents.tab_secondary_button_hovered,
			on_pressed_sound = UISoundEvents.tab_secondary_button_pressed
		}
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			default_color = Color.terminal_background(nil, true),
			selected_color = Color.terminal_background_selected(nil, true)
		},
		change_function = terminal_button_change_function
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
			offset = {
				0,
				0,
				1
			}
		},
		change_function = function (content, style)
			terminal_button_change_function(content, style)
			terminal_button_hover_change_function(content, style)
		end
	},
	{
		value = "content/ui/materials/frames/dropshadow_medium",
		style_id = "outer_shadow",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			scale_to_material = true,
			color = Color.black(200, true),
			size_addition = {
				20,
				20
			},
			offset = {
				0,
				0,
				3
			}
		}
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			offset = {
				0,
				0,
				12
			}
		},
		change_function = terminal_button_change_function
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = Color.terminal_corner(nil, true),
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			offset = {
				0,
				0,
				13
			}
		},
		change_function = terminal_button_change_function
	},
	{
		value_id = "icon",
		pass_type = "texture",
		style_id = "icon",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = Color.terminal_icon(nil, true),
			size = {
				126,
				32
			},
			offset = {
				0,
				0,
				4
			}
		}
	}
}
ButtonPassTemplates.item_category_sort_button = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = {
			on_pressed_sound = UISoundEvents.tab_secondary_button_pressed,
			on_hover_sound = UISoundEvents.default_mouse_hover
		},
		style = list_button_hotspot_default_style
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			default_color = Color.terminal_background(nil, true),
			selected_color = Color.terminal_background_selected(nil, true)
		},
		change_function = terminal_button_change_function
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
				1
			}
		},
		change_function = function (content, style)
			terminal_button_change_function(content, style)
			terminal_button_hover_change_function(content, style)
		end
	},
	{
		value = "content/ui/materials/frames/dropshadow_medium",
		style_id = "outer_shadow",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			scale_to_material = true,
			color = Color.black(200, true),
			size_addition = {
				20,
				20
			},
			offset = {
				0,
				0,
				3
			}
		}
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			disabled_color = Color.ui_grey_medium(255, true),
			offset = {
				0,
				0,
				2
			}
		},
		change_function = terminal_button_change_function
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			disabled_color = Color.ui_grey_light(255, true),
			offset = {
				0,
				0,
				3
			}
		},
		change_function = terminal_button_change_function
	},
	{
		pass_type = "texture",
		value_id = "icon",
		style_id = "icon",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_text_header(255, true),
			disabled_color = Color.gray(255, true),
			color = Color.terminal_text_header(255, true),
			hover_color = Color.terminal_text_header_selected(255, true),
			original_size_addition = {
				-20,
				-20
			},
			size_addition = {
				0,
				0
			},
			offset = {
				0,
				0,
				6
			}
		},
		change_function = function (content, style)
			local hotspot = content.hotspot
			local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
			local size_addition = 2 * math.easeInCubic(progress)
			local style_size_addition = style.size_addition
			local original_size_addition = style.original_size_addition
			style_size_addition[1] = original_size_addition[1] + size_addition * 2
			style_size_addition[2] = original_size_addition[1] + size_addition * 2

			ButtonPassTemplates.list_button_label_change_function(content, style)
		end
	}
}

return settings("ButtonPassTemplates", ButtonPassTemplates)
