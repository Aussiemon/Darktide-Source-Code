local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ColorUtilities = require("scripts/utilities/ui/colors")
local ListHeaderPassTemplates = require("scripts/ui/pass_templates/list_header_templates")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ButtonPassTemplates = {}
local terminal_orange_light = Color.ui_orange_light(255, true)
local terminal_orange_medium = Color.ui_orange_medium(255, true)
local terminal_orange_dark = Color.ui_orange_dark(255, true)
local ui_brown_light = Color.ui_brown_light(255, true)
local ui_brown_medium = Color.ui_brown_medium(255, true)
local ui_brown_dark = Color.ui_brown_dark(255, true)
local color_lerp = ColorUtilities.color_lerp
local color_copy = ColorUtilities.color_copy
local math_max = math.max
local terminal_button_text_style = table.clone(UIFontSettings.button_primary)
terminal_button_text_style.offset = {
	0,
	0,
	6
}
terminal_button_text_style.text_horizontal_alignment = "center"
terminal_button_text_style.text_vertical_alignment = "center"
terminal_button_text_style.character_spacing = 0.1
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
	local color = style.color
	local default_color = style.default_color
	local selected_color = style.selected_color

	color_copy(is_selected and selected_color or default_color, color)
end

local function terminal_button_hover_change_function(content, style)
	local hotspot = content.hotspot
	style.color[1] = 100 + math.max(hotspot.anim_hover_progress, content.hotspot.anim_select_progress) * 155
end

local function default_button_hover_change_function(content, style)
	local hotspot = content.hotspot
	local default_color = hotspot.disabled and style.disabled_color or style.default_color
	local hover_color = style.hover_color
	local color = style.text_color or style.color
	local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

	color_lerp(default_color, hover_color, progress, color)
end

local default_button_content = {
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_select
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
		change_function = default_button_hover_change_function
	},
	{
		value = "content/ui/materials/frames/hover",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
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
			color = Color.terminal_background_gradient(nil, true),
			offset = {
				0,
				0,
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
		change_function = default_button_hover_change_function
	},
	{
		value = "content/ui/materials/buttons/primary",
		pass_type = "texture",
		style = {
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
				-40 + ready_button_small_button_size_addition[1],
				-30 + ready_button_small_button_size_addition[2]
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
				-50 + ready_button_small_button_size_addition[1],
				-50 + ready_button_small_button_size_addition[2]
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
				-50 + ready_button_small_button_size_addition[1],
				-50 + ready_button_small_button_size_addition[2]
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
	size = {
		340,
		60
	}
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
		content = default_button_content,
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
			vertical_alignment = "top",
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
			vertical_alignment = "top",
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
			vertical_alignment = "top",
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
			local progress = content.hold_progress
			local total_width = content.size[1]
			style.size[1] = total_width * progress
		end
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
	{
		style_id = "hold_text",
		pass_type = "text",
		value_id = "hold_text",
		style = terminal_button_hold_small_text_style,
		value = Localize("loc_button_hold_description"),
		change_function = function (content, style)
			local progress = content.hold_progress
			local default_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color

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
		widget.content.size[2] = height + 40
		widget.style.text.offset[2] = -(widget.content.size[2] - height) * 0.5
	end,
	update = function (parent, widget, renderer, dt)
		local hold_active = widget.content.hotspot.on_pressed
		local input_service = renderer.input_service
		local input_action = widget.content.input_action and input_service:get(widget.content.input_action)
		local left_hold = input_service and (input_action or input_service:get("left_hold"))

		if not left_hold and widget.content.hold_active then
			widget.content.hold_active = nil
		elseif not widget.content.hold_active then
			widget.content.hold_active = hold_active
		end

		if widget.content.hold_active then
			local total_time = widget.content.timer
			local current_time = widget.content.current_timer + dt
			local progress = math.min(current_time / total_time, 1)

			if progress < 1 then
				widget.content.current_timer = current_time
				widget.content.hold_progress = progress

				return
			else
				widget.content.current_timer = 0
				widget.content.hold_progress = 0
				widget.content.hold_active = false

				if widget.content.complete_function then
					widget.content.complete_function()
				end

				return
			end
		elseif not widget.content.hold_active and widget.content.current_timer > 0 then
			widget.content.current_timer = 0
			widget.content.hold_progress = 0
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
			color = Color.ui_terminal(0, true),
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
	on_hover_sound = UISoundEvents.tab_button_hovered,
	on_pressed_sound = UISoundEvents.tab_button_pressed
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
				24,
				24
			},
			offset = {
				12,
				-10,
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
				color = Color.ui_terminal(255, true),
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
				color = Color.ui_terminal(255, true)
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
		style_id = "icon",
		pass_type = "texture",
		value_id = "icon",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_text_body(255, true),
			hover_color = Color.terminal_corner_selected(255, true),
			disabled_color = Color.ui_grey_medium(255, true),
			color = {
				255,
				255,
				255,
				255
			},
			size = {
				126,
				32
			},
			offset = {
				0,
				0,
				4
			}
		},
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local hover_color = style.hover_color
			local color = style.color
			local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress, hotspot.anim_hover_progress, hotspot.anim_input_progress)

			ColorUtilities.color_lerp(default_color, hover_color, progress, color)
		end
	}
}

return settings("ButtonPassTemplates", ButtonPassTemplates)
