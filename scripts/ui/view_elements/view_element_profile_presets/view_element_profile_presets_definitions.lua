-- chunkname: @scripts/ui/view_elements/view_element_profile_presets/view_element_profile_presets_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local ItemUtils = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local Text = require("scripts/utilities/ui/text")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ViewElementTabMenuSettings = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	entry_pivot = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
	profile_preset_button_panel = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			524,
			56,
		},
		position = {
			-60,
			94,
			100,
		},
	},
	profile_preset_add_button = {
		horizontal_alignment = "right",
		parent = "profile_preset_button_panel",
		vertical_alignment = "center",
		size = {
			32,
			32,
		},
		position = {
			-11,
			0,
			1,
		},
	},
	profile_preset_button_pivot = {
		horizontal_alignment = "right",
		parent = "profile_preset_button_panel",
		vertical_alignment = "center",
		size = {
			44,
			58,
		},
		position = {
			-52,
			-2,
			1,
		},
	},
	profile_preset_tooltip = {
		horizontal_alignment = "right",
		parent = "profile_preset_button_panel",
		vertical_alignment = "top",
		size = {
			300,
			400,
		},
		position = {
			-5,
			62,
			1,
		},
	},
	profile_preset_tooltip_grid = {
		horizontal_alignment = "left",
		parent = "profile_preset_tooltip",
		vertical_alignment = "top",
		size = {
			225,
			1,
		},
		position = {
			37.5,
			0,
			1,
		},
	},
}
local widget_definitions = {
	profile_preset_button_panel = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/presets/main",
			value_id = "texture",
		},
	}, "profile_preset_button_panel"),
	profile_preset_tooltip = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size_addition = {
					-20,
					-20,
				},
			},
		},
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_grid_background_icon(255, true),
				size_addition = {
					-24,
					-24,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "background",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.terminal_grid_background(255, true),
				offset = {
					0,
					0,
					1,
				},
				size_addition = {
					0,
					0,
				},
			},
		},
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				scenegraph_id = "screen",
				vertical_alignment = "center",
				color = Color.black(100, true),
				size_addition = {
					0,
					0,
				},
				offset = {
					0,
					0,
					80,
				},
			},
		},
	}, "profile_preset_tooltip"),
	profile_preset_add_button = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			content = {
				on_pressed_sound = nil,
				on_released_sound = nil,
				on_hover_sound = UISoundEvents.default_mouse_hover,
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/presets/preset_new",
			style = {
				color = Color.terminal_frame(nil, true),
				default_color = Color.terminal_corner_hover(nil, true),
				hover_color = Color.terminal_icon(nil, true),
				disabled_color = Color.ui_grey_medium(255, true),
				offset = {
					0,
					0,
					1,
				},
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local color = style.color
				local default_color = hotspot.disabled and style.disabled_color or style.default_color
				local hover_color = style.hover_color
				local hover_progress = hotspot.anim_hover_progress
				local ignore_alpha = true

				ColorUtilities.color_lerp(default_color, hover_color, hover_progress, color, ignore_alpha)
			end,
			visibility_function = function (content, style)
				return not content.missing_content
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/generic/exclamation_mark",
			value_id = "exclamation_mark",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					7,
				},
				color = {
					255,
					246,
					69,
					69,
				},
				size = {
					16,
					28,
				},
			},
			visibility_function = function (content, style)
				return content.missing_content
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/hud/stamina_glow",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_icon(nil, true),
				offset = {
					0,
					0,
					0,
				},
				size_addition = {
					30,
					30,
				},
			},
			visibility_function = function (content, style)
				return content.pulse
			end,
			change_function = function (content, style, _, dt)
				local anim_pulse_fade_speed = 3
				local anim_pulse_fade_progress = content.anim_pulse_fade_progress or 0

				if content.pulse then
					anim_pulse_fade_progress = math.min(anim_pulse_fade_progress + dt * anim_pulse_fade_speed, 1)
				else
					anim_pulse_fade_progress = math.max(anim_pulse_fade_progress - dt * anim_pulse_fade_speed, 0)
				end

				content.anim_pulse_fade_progress = anim_pulse_fade_progress

				local hotspot = content.hotspot
				local hover_progress = hotspot.anim_hover_progress
				local pulse_speed = 4
				local alpha_progress = (1 - (0.5 + math.sin(Application.time_since_launch() * pulse_speed) * 0.5) * anim_pulse_fade_progress) * (1 - hover_progress)
				local color = style.color

				color[1] = 150 * math.min(alpha_progress)
			end,
		},
	}, "profile_preset_add_button"),
}
local profile_preset_button = UIWidget.create_definition({
	{
		pass_type = "rotated_texture",
		value = "content/ui/materials/icons/system/page_arrow",
		value_id = "arrow",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			angle = -math.pi / 2,
			offset = {
				0,
				39,
				7,
			},
			color = Color.terminal_corner(nil, true),
			size = {
				24,
				46,
			},
		},
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return hotspot.is_focused
		end,
	},
	{
		pass_type = "texture",
		style_id = "exclamation_mark",
		value = "content/ui/materials/icons/generic/exclamation_mark",
		value_id = "exclamation_mark",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			offset = {
				10,
				10,
				7,
			},
			color = {
				255,
				246,
				69,
				69,
			},
			size = {
				16,
				28,
			},
		},
		visibility_function = function (content, style)
			return content.missing_content
		end,
	},
	{
		pass_type = "texture",
		style_id = "modified_exclamation_mark",
		value = "content/ui/materials/icons/generic/exclamation_mark",
		value_id = "modified_exclamation_mark",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			offset = {
				10,
				10,
				7,
			},
			color = {
				255,
				246,
				202,
				69,
			},
			size = {
				16,
				28,
			},
		},
		visibility_function = function (content, style)
			return content.modified_content
		end,
		change_function = function (content, style)
			if content.missing_content then
				style.offset[1] = 0
			else
				style.offset[1] = 10
			end
		end,
	},
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		content = {
			on_pressed_sound = nil,
			on_released_sound = nil,
			on_hover_sound = UISoundEvents.default_mouse_hover,
		},
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/icons/presets/preset_01",
		value_id = "icon",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			offset = {
				0,
				4,
				3,
			},
			color = Color.terminal_icon(255, true),
			size = {
				32,
				32,
			},
		},
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/frames/presets/idle",
		value_id = "background_idle",
		style = {
			offset = {
				0,
				0,
				0,
			},
		},
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return not hotspot.is_selected
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/frames/presets/active",
		value_id = "background_active",
		style = {
			offset = {
				0,
				0,
				1,
			},
		},
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return hotspot.is_selected
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/frames/presets/highlight",
		value_id = "highlight",
		style = {
			offset = {
				0,
				0,
				2,
			},
			default_color = Color.terminal_corner(255, true),
			hover_color = Color.terminal_corner_hover(255, true),
		},
		change_function = function (content, style)
			local color = style.color
			local hotspot = content.hotspot
			local is_selected = hotspot.is_selected
			local default_color = style.default_color
			local hover_color = style.hover_color
			local hover_progress = hotspot.anim_hover_progress
			local input_progress = hotspot.anim_input_progress
			local focus_progress = hotspot.anim_focus_progress
			local select_progress = hotspot.anim_select_progress

			color[1] = 255 * math.max(hover_progress, focus_progress)

			local ignore_alpha = true

			ColorUtilities.color_lerp(default_color, hover_color, math.max(focus_progress, select_progress), color, ignore_alpha)
		end,
	},
}, "profile_preset_button_pivot")

local function icon_change_function(content, style)
	local hotspot = content.hotspot
	local is_selected = hotspot.is_selected
	local is_hover = hotspot.is_hover
	local color = style.color
	local default_color = style.default_color
	local hover_color = style.hover_color
	local hover_progress = hotspot.anim_hover_progress
	local input_progress = hotspot.anim_input_progress
	local focus_progress = hotspot.anim_focus_progress
	local select_progress = hotspot.anim_select_progress

	color[1] = 255 * math.min(hover_progress)

	local ignore_alpha = true

	ColorUtilities.color_lerp(default_color, hover_color, input_progress, color, ignore_alpha)
end

local profile_preset_grid_blueprints = {
	dynamic_spacing = {
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1],
				size[2],
			} or {
				225,
				20,
			}
		end,
	},
	texture = {
		size = {
			64,
			64,
		},
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1],
				size[2],
			} or {
				64,
				64,
			}
		end,
		pass_template = {
			{
				pass_type = "texture",
				style_id = "texture",
				value_id = "texture",
				style = {
					color = {
						255,
						255,
						255,
						255,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local texture = element.texture

			content.texture = texture

			local texture_color = element.color

			if texture_color then
				local color = style.texture.color

				color[1] = texture_color[1]
				color[2] = texture_color[2]
				color[3] = texture_color[3]
				color[4] = texture_color[4]
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end,
	},
	dynamic_button = {
		size = {
			225,
			100,
		},
		pass_template = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				content = {
					on_pressed_sound = nil,
					on_released_sound = nil,
					on_hover_sound = UISoundEvents.default_mouse_hover,
				},
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					size_addition = {
						0,
						0,
					},
					default_color = Color.terminal_frame(nil, true),
					hover_color = Color.terminal_frame_hover(nil, true),
					offset = {
						0,
						0,
						3,
					},
				},
				change_function = ButtonPassTemplates.default_button_hover_change_function,
				visibility_function = function (content, style)
					return not content.hotspot.disabled
				end,
			},
			{
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					size_addition = {
						0,
						0,
					},
					default_color = Color.terminal_corner(nil, true),
					hover_color = Color.terminal_corner_hover(nil, true),
					offset = {
						0,
						0,
						4,
					},
				},
				change_function = ButtonPassTemplates.default_button_hover_change_function,
				visibility_function = function (content, style)
					return not content.hotspot.disabled
				end,
			},
			{
				pass_type = "texture",
				style_id = "background_gradient",
				value = "content/ui/materials/gradients/gradient_vertical",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					size_addition = {
						0,
						0,
					},
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
				visibility_function = function (content, style)
					return not content.hotspot.disabled
				end,
			},
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = {
					font_size = 20,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					text_color = Color.terminal_text_header(255, true),
					offset = {
						0,
						0,
						3,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local text = element.text
			local new_indicator_width_offset = element.new_indicator_width_offset

			if new_indicator_width_offset then
				local offset = style.new_indicator.offset

				offset[1] = new_indicator_width_offset[1]
				offset[2] = new_indicator_width_offset[2]
				offset[3] = new_indicator_width_offset[3]
			end

			content.element = element
			content.text = text

			local hotspot = content.hotspot

			hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)

			local size = content.size
			local text_style = style.text
			local height = Text.text_height(ui_renderer, text, text_style, size)

			size[2] = height + 20
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end,
	},
	header = {
		size = {
			225,
			100,
		},
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = {
					font_size = 20,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					text_color = Color.terminal_text_header(255, true),
					offset = {
						0,
						0,
						3,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local text = element.text
			local new_indicator_width_offset = element.new_indicator_width_offset

			if new_indicator_width_offset then
				local offset = style.new_indicator.offset

				offset[1] = new_indicator_width_offset[1]
				offset[2] = new_indicator_width_offset[2]
				offset[3] = new_indicator_width_offset[3]
			end

			content.element = element
			content.text = text

			local size = content.size
			local text_style = style.text
			local height = Text.text_height(ui_renderer, text, text_style, size)

			size[2] = height + 0
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end,
	},
	icon = {
		size = {
			45,
			45,
		},
		pass_template = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				content = {
					on_released_sound = nil,
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.default_click,
				},
			},
			{
				pass_type = "rect",
				style = {
					color = {
						100,
						0,
						0,
						0,
					},
				},
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/frames/inner_shadow_thin",
				style = {
					scale_to_material = true,
					color = Color.terminal_corner_selected(nil, true),
					offset = {
						0,
						0,
						1,
					},
				},
				visibility_function = function (content, style)
					return content.equipped
				end,
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					offset = {
						0,
						0,
						6,
					},
					color = Color.terminal_frame(nil, true),
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					hover_color = Color.terminal_frame_hover(nil, true),
				},
				change_function = icon_change_function,
			},
			{
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					offset = {
						0,
						0,
						7,
					},
					color = Color.terminal_corner(nil, true),
					default_color = Color.terminal_corner(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true),
					hover_color = Color.terminal_corner_hover(nil, true),
				},
				change_function = icon_change_function,
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/frames/frame_tile_1px",
				style = {
					color = {
						255,
						0,
						0,
						0,
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
				value = "content/ui/materials/icons/presets/preset_01",
				value_id = "icon",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					offset = {
						0,
						0,
						2,
					},
					size = {
						32,
						32,
					},
					color = Color.terminal_icon(255, true),
				},
			},
		},
		init = function (parent, widget, element, callback_name)
			local style = widget.style
			local content = widget.content
			local hotspot = content.hotspot

			content.element = element
			hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)

			local icon_texture = element.icon

			if icon_texture then
				content.icon = icon_texture
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			return
		end,
	},
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	profile_preset_button = profile_preset_button,
	profile_preset_grid_blueprints = profile_preset_grid_blueprints,
}
