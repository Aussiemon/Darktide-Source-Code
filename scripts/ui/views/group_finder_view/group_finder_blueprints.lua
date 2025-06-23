-- chunkname: @scripts/ui/views/group_finder_view/group_finder_blueprints.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local Danger = require("scripts/utilities/danger")
local DangerSettings = require("scripts/settings/difficulty/danger_settings")
local TextUtilities = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local tag_text_style = {
	horizontal_alignment = "center",
	font_size = 28,
	text_vertical_alignment = "center",
	text_horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "proxima_nova_bold",
	text_color = Color.terminal_text_header(255, true),
	offset = {
		0,
		0,
		3
	},
	size_addition = {
		-60,
		0
	}
}
local tag_slot_header_text_style = {
	horizontal_alignment = "center",
	font_size = 28,
	text_vertical_alignment = "center",
	text_horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "proxima_nova_bold",
	text_color = Color.terminal_text_header(255, true),
	offset = {
		0,
		-15,
		3
	},
	size_addition = {
		-60,
		0
	}
}
local tag_slot_sub_header_text_style = {
	horizontal_alignment = "center",
	font_size = 24,
	text_vertical_alignment = "center",
	text_horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "proxima_nova_bold",
	text_color = Color.terminal_text_body_sub_header(255, true),
	offset = {
		0,
		15,
		3
	},
	size_addition = {
		-60,
		0
	}
}
local terminal_button_text_style = table.clone(UIFontSettings.button_primary)

terminal_button_text_style.offset = {
	70,
	0,
	6
}
terminal_button_text_style.size_addition = {
	-90,
	0
}
terminal_button_text_style.text_horizontal_alignment = "left"
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

local function generate_blueprints_func(grid_size)
	local tag_default = {
		size = {
			grid_size[1],
			60
		},
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return {
				size and size[1] or grid_size[1],
				size and size[2] or 60
			}
		end,
		pass_template = {
			{
				pass_type = "hotspot",
				content_id = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.default_click
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
				end
			},
			{
				style_id = "checkbox_background",
				pass_type = "rect",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "left",
					color = {
						180,
						28,
						31,
						28
					},
					size = {
						50
					},
					offset = {
						0,
						0,
						2
					}
				},
				visibility_function = function (content, style)
					return not content.element.is_preview
				end
			},
			{
				style_id = "checkbox_shadow",
				pass_type = "texture",
				value = "content/ui/materials/frames/dropshadow_medium",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					scale_to_material = true,
					color = Color.black(150, true),
					size_addition = {
						-30,
						20
					},
					offset = {
						10,
						0,
						3
					}
				},
				visibility_function = function (content, style)
					return not content.element.is_preview
				end
			},
			{
				pass_type = "texture",
				style_id = "background",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					default_color = Color.terminal_background(nil, true),
					selected_color = Color.terminal_background_selected(nil, true)
				},
				change_function = ButtonPassTemplates.terminal_button_change_function
			},
			{
				pass_type = "texture",
				style_id = "background_gradient",
				value = "content/ui/materials/gradients/gradient_vertical",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					disabled_color = Color.ui_grey_medium(255, true),
					size_addition = {
						-50,
						0
					},
					offset = {
						0,
						0,
						1
					}
				},
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_change_function(content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style)
				end
			},
			{
				value_id = "checkbox",
				style_id = "checkbox_text_default",
				pass_type = "text",
				value = "",
				style = {
					font_size = 28,
					text_vertical_alignment = "center",
					horizontal_alignment = "left",
					text_horizontal_alignment = "center",
					vertical_alignment = "center",
					drop_shadow = false,
					font_type = "proxima_nova_bold",
					size = {
						50
					},
					text_color = {
						255,
						10,
						10,
						10
					},
					offset = {
						0,
						0,
						5
					}
				},
				visibility_function = function (content, style)
					return not content.checked and not content.element.is_preview and not content.hotspot.disabled
				end
			},
			{
				value_id = "checkbox",
				style_id = "checkbox_text_checked",
				pass_type = "text",
				value = "",
				style = {
					font_size = 28,
					text_vertical_alignment = "center",
					horizontal_alignment = "left",
					text_horizontal_alignment = "center",
					vertical_alignment = "center",
					drop_shadow = true,
					font_type = "proxima_nova_bold",
					size = {
						50
					},
					text_color = Color.terminal_corner_selected(nil, true),
					offset = {
						0,
						0,
						5
					}
				},
				visibility_function = function (content, style)
					return content.checked and not content.element.is_preview and not content.hotspot.disabled
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
				style_id = "outer_highlight",
				value = "content/ui/materials/frames/dropshadow_heavy",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					scale_to_material = true,
					color = Color.terminal_text_body(200, true),
					size_addition = {
						20,
						20
					},
					offset = {
						0,
						0,
						4
					}
				},
				change_function = function (content, style, _, dt)
					local any_visible_tag_selected_last_frame = content.any_visible_tag_selected_last_frame
					local anim_speed = 2

					if anim_speed then
						local anim_highlight_progress = content.anim_highlight_progress or 0

						if not any_visible_tag_selected_last_frame then
							anim_highlight_progress = math.min(anim_highlight_progress + dt * anim_speed, 1)
						else
							anim_highlight_progress = math.max(anim_highlight_progress - dt * anim_speed, 0)
						end

						content.anim_highlight_progress = anim_highlight_progress

						local pulse_speed = 3
						local pulse_progress = 1 - (0.5 + math.sin(Application.time_since_launch() * pulse_speed) * 0.5)

						style.color[1] = (50 + 100 * pulse_progress) * anim_highlight_progress
					end
				end,
				visibility_function = function (content, style)
					return not content.element.is_preview and not content.hotspot.disabled
				end
			},
			{
				value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
				pass_type = "texture",
				style = {
					offset = {
						0,
						0,
						7
					},
					color = {
						105,
						45,
						45,
						45
					}
				},
				visibility_function = function (content, style)
					return content.element.block_reason ~= nil
				end
			},
			{
				style_id = "required_level_background",
				pass_type = "rect",
				style = {
					offset = {
						0,
						0,
						6
					},
					color = {
						150,
						35,
						0,
						0
					}
				},
				visibility_function = function (content, style)
					return content.element.block_reason ~= nil
				end
			},
			{
				value_id = "required_level_text",
				style_id = "required_level_text",
				pass_type = "text",
				value = "",
				style = {
					text_vertical_alignment = "center",
					font_size = 22,
					horizontal_alignment = "center",
					text_horizontal_alignment = "right",
					vertical_alignment = "center",
					drop_shadow = true,
					font_type = "proxima_nova_bold",
					size_addition = {
						-40,
						-20
					},
					text_color = {
						255,
						159,
						67,
						67
					},
					offset = {
						0,
						0,
						8
					}
				},
				visibility_function = function (content, style)
					return content.element.block_reason ~= nil
				end
			},
			{
				value = "",
				pass_type = "text",
				style = {
					font_size = 28,
					text_vertical_alignment = "center",
					horizontal_alignment = "left",
					text_horizontal_alignment = "center",
					vertical_alignment = "center",
					drop_shadow = true,
					font_type = "proxima_nova_bold",
					size = {
						50
					},
					text_color = {
						255,
						159,
						67,
						67
					},
					offset = {
						0,
						0,
						8
					}
				},
				visibility_function = function (content, style)
					return content.element.block_reason ~= nil
				end
			},
			{
				value = "",
				pass_type = "text",
				style = {
					font_size = 28,
					text_vertical_alignment = "center",
					horizontal_alignment = "left",
					text_horizontal_alignment = "center",
					vertical_alignment = "center",
					drop_shadow = true,
					font_type = "proxima_nova_bold",
					size = {
						50
					},
					text_color = Color.ui_grey_medium(255, true),
					offset = {
						0,
						0,
						8
					}
				},
				visibility_function = function (content, style)
					return content.hotspot.disabled and content.element.block_reason == nil
				end
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					offset = {
						0,
						0,
						9
					},
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					disabled_color = Color.ui_grey_medium(255, true),
					hover_color = Color.terminal_frame_hover(nil, true)
				},
				change_function = ButtonPassTemplates.terminal_button_change_function
			},
			{
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					offset = {
						0,
						0,
						10
					},
					default_color = Color.terminal_corner(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true),
					disabled_color = Color.ui_grey_light(255, true),
					hover_color = Color.terminal_corner_hover(nil, true)
				},
				change_function = ButtonPassTemplates.terminal_button_change_function
			},
			{
				style_id = "text",
				pass_type = "text",
				value_id = "text",
				style = terminal_button_text_style,
				change_function = function (content, style)
					local hotspot = content.hotspot
					local is_disabled = hotspot.disabled
					local default_color = is_disabled and style.disabled_color or style.default_color
					local hover_color = style.hover_color
					local color = style.text_color
					local progress = math.max(math.max(hotspot.anim_checked_progress or 0, math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress)), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

					if color and default_color and hover_color then
						ColorUtilities.color_lerp(default_color, hover_color, progress, color)
					end
				end
			}
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content

			content.element = element
			content.text = element.text or "n/a"
			content.hotspot.pressed_callback = element.pressed_callback

			if element.is_preview then
				style.background_gradient.size_addition[1] = 0
				style.text.offset[1] = 20
			end

			if element.block_reason then
				content.required_level_text = element.block_reason
			end
		end
	}
	local tag_checkbox = table.clone_instance(tag_default)

	tag_checkbox.size[2] = 30

	return {
		tag_default = tag_default,
		tag_checkbox = tag_checkbox,
		tag_radio_button = {
			size = {
				grid_size[1],
				60
			},
			size_function = function (parent, element, ui_renderer)
				local size = element.size

				return {
					size and size[1] or grid_size[1],
					size and size[2] or 60
				}
			end,
			pass_template = {
				{
					pass_type = "hotspot",
					content_id = "hotspot",
					content = {
						on_hover_sound = UISoundEvents.default_mouse_hover,
						on_pressed_sound = UISoundEvents.default_click
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
					end
				},
				{
					style_id = "checkbox_background",
					pass_type = "rect",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						color = {
							180,
							28,
							31,
							28
						},
						size = {
							50
						},
						offset = {
							0,
							0,
							2
						}
					},
					visibility_function = function (content, style)
						return not content.element.is_preview
					end
				},
				{
					style_id = "checkbox_shadow",
					pass_type = "texture",
					value = "content/ui/materials/frames/dropshadow_medium",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						scale_to_material = true,
						color = Color.black(150, true),
						size_addition = {
							-30,
							20
						},
						offset = {
							10,
							0,
							3
						}
					},
					visibility_function = function (content, style)
						return not content.element.is_preview
					end
				},
				{
					pass_type = "texture",
					style_id = "background",
					value = "content/ui/materials/backgrounds/default_square",
					style = {
						default_color = Color.terminal_background(nil, true),
						selected_color = Color.terminal_background_selected(nil, true)
					},
					change_function = ButtonPassTemplates.terminal_button_change_function
				},
				{
					pass_type = "texture",
					style_id = "background_gradient",
					value = "content/ui/materials/gradients/gradient_vertical",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						default_color = Color.terminal_frame(nil, true),
						selected_color = Color.terminal_frame_selected(nil, true),
						disabled_color = Color.ui_grey_medium(255, true),
						size_addition = {
							-50,
							0
						},
						offset = {
							0,
							0,
							1
						}
					},
					change_function = function (content, style)
						ButtonPassTemplates.terminal_button_change_function(content, style)
						ButtonPassTemplates.terminal_button_hover_change_function(content, style)
					end
				},
				{
					value_id = "checkbox",
					style_id = "checkbox_text_default",
					pass_type = "text",
					value = "•",
					style = {
						font_size = 72,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = false,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = {
							255,
							10,
							10,
							10
						},
						offset = {
							0,
							-5,
							5
						}
					},
					visibility_function = function (content, style)
						return not content.checked and not content.element.is_preview and not content.hotspot.disabled
					end
				},
				{
					value_id = "checkbox",
					style_id = "checkbox_text_checked",
					pass_type = "text",
					value = "•",
					style = {
						font_size = 72,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = false,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = Color.terminal_corner_selected(nil, true),
						offset = {
							0,
							-5,
							5
						}
					},
					visibility_function = function (content, style)
						return content.checked and not content.element.is_preview and not content.hotspot.disabled
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
					style_id = "outer_highlight",
					value = "content/ui/materials/frames/dropshadow_heavy",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						scale_to_material = true,
						color = Color.terminal_text_body(200, true),
						size_addition = {
							20,
							20
						},
						offset = {
							0,
							0,
							4
						}
					},
					change_function = function (content, style, _, dt)
						local any_visible_tag_selected_last_frame = content.any_visible_tag_selected_last_frame
						local anim_speed = 2

						if anim_speed then
							local anim_highlight_progress = content.anim_highlight_progress or 0

							if not any_visible_tag_selected_last_frame then
								anim_highlight_progress = math.min(anim_highlight_progress + dt * anim_speed, 1)
							else
								anim_highlight_progress = math.max(anim_highlight_progress - dt * anim_speed, 0)
							end

							content.anim_highlight_progress = anim_highlight_progress

							local pulse_speed = 3
							local pulse_progress = 1 - (0.5 + math.sin(Application.time_since_launch() * pulse_speed) * 0.5)

							style.color[1] = (50 + 100 * pulse_progress) * anim_highlight_progress
						end
					end,
					visibility_function = function (content, style)
						return not content.element.is_preview and not content.hotspot.disabled
					end
				},
				{
					value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
					pass_type = "texture",
					style = {
						offset = {
							0,
							0,
							7
						},
						color = {
							105,
							45,
							45,
							45
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					style_id = "required_level_background",
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							6
						},
						color = {
							150,
							35,
							0,
							0
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					value_id = "required_level_text",
					style_id = "required_level_text",
					pass_type = "text",
					value = "",
					style = {
						text_vertical_alignment = "center",
						font_size = 22,
						horizontal_alignment = "center",
						text_horizontal_alignment = "right",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size_addition = {
							-40,
							-20
						},
						text_color = {
							255,
							159,
							67,
							67
						},
						offset = {
							0,
							0,
							8
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					value = "",
					pass_type = "text",
					style = {
						font_size = 28,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = {
							255,
							159,
							67,
							67
						},
						offset = {
							0,
							0,
							8
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					value = "",
					pass_type = "text",
					style = {
						font_size = 28,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = Color.ui_grey_medium(255, true),
						offset = {
							0,
							0,
							8
						}
					},
					visibility_function = function (content, style)
						return content.hotspot.disabled and content.element.block_reason == nil
					end
				},
				{
					style_id = "required_level_background",
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							6
						},
						color = {
							150,
							35,
							0,
							0
						}
					},
					visibility_function = function (content, style)
						return content.no_active_havoc_order
					end
				},
				{
					value_id = "no_active_havoc_order_text",
					style_id = "no_active_havoc_order_text",
					pass_type = "text",
					value = "",
					style = {
						text_vertical_alignment = "center",
						font_size = 22,
						horizontal_alignment = "center",
						text_horizontal_alignment = "right",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size_addition = {
							-40,
							-20
						},
						text_color = {
							255,
							159,
							67,
							67
						},
						offset = {
							0,
							0,
							8
						}
					},
					visibility_function = function (content, style)
						return content.no_active_havoc_order
					end
				},
				{
					value = "",
					pass_type = "text",
					style = {
						font_size = 28,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = {
							255,
							159,
							67,
							67
						},
						offset = {
							0,
							0,
							8
						}
					},
					visibility_function = function (content, style)
						return content.no_active_havoc_order
					end
				},
				{
					value = "",
					pass_type = "text",
					style = {
						font_size = 28,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = Color.ui_grey_medium(255, true),
						offset = {
							0,
							0,
							8
						}
					},
					visibility_function = function (content, style)
						return content.hotspot.disabled and content.no_active_havoc_order
					end
				},
				{
					pass_type = "texture",
					style_id = "frame",
					value = "content/ui/materials/frames/frame_tile_2px",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							9
						},
						default_color = Color.terminal_frame(nil, true),
						selected_color = Color.terminal_frame_selected(nil, true),
						disabled_color = Color.ui_grey_medium(255, true),
						hover_color = Color.terminal_frame_hover(nil, true)
					},
					change_function = ButtonPassTemplates.terminal_button_change_function
				},
				{
					pass_type = "texture",
					style_id = "corner",
					value = "content/ui/materials/frames/frame_corner_2px",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							10
						},
						default_color = Color.terminal_corner(nil, true),
						selected_color = Color.terminal_corner_selected(nil, true),
						disabled_color = Color.ui_grey_light(255, true),
						hover_color = Color.terminal_corner_hover(nil, true)
					},
					change_function = ButtonPassTemplates.terminal_button_change_function
				},
				{
					style_id = "text",
					pass_type = "text",
					value_id = "text",
					style = terminal_button_text_style,
					change_function = function (content, style)
						local hotspot = content.hotspot
						local is_disabled = hotspot.disabled
						local default_color = is_disabled and style.disabled_color or style.default_color
						local hover_color = style.hover_color
						local color = style.text_color
						local progress = math.max(math.max(hotspot.anim_checked_progress or 0, math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress)), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

						if color and default_color and hover_color then
							ColorUtilities.color_lerp(default_color, hover_color, progress, color)
						end
					end
				}
			},
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
				local style = widget.style
				local content = widget.content

				content.element = element
				content.text = element.text or "n/a"

				if element.is_preview then
					style.background_gradient.size_addition[1] = 0
					style.text.offset[1] = 20
				end

				if element.block_reason ~= nil then
					content.required_level_text = element.block_reason
				end

				if not element.active_havoc_order and element.tag and element.tag.name == "my_havoc_order" then
					content.no_active_havoc_order_text = Localize("loc_group_finder_tag_no_active_personal_havoc_order")
					content.no_active_havoc_order = true
					content.hotspot.disabled = true
				else
					content.hotspot.pressed_callback = element.pressed_callback
				end
			end
		},
		tag_game_mode = {
			size = {
				grid_size[1],
				60
			},
			size_function = function (parent, element, ui_renderer)
				local size = element.size

				return {
					size and size[1] or grid_size[1],
					size and size[2] or 60
				}
			end,
			pass_template = {
				{
					pass_type = "hotspot",
					content_id = "hotspot",
					content = {
						on_hover_sound = UISoundEvents.default_mouse_hover,
						on_pressed_sound = UISoundEvents.default_click
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
					end
				},
				{
					style_id = "heckbox_background",
					pass_type = "rect",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						color = {
							180,
							28,
							31,
							28
						},
						size = {
							50
						},
						offset = {
							0,
							0,
							2
						}
					},
					visibility_function = function (content, style)
						return not content.element.is_preview
					end
				},
				{
					style_id = "checkbox_shadow",
					pass_type = "texture",
					value = "content/ui/materials/frames/dropshadow_medium",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						scale_to_material = true,
						color = Color.black(150, true),
						size_addition = {
							-30,
							20
						},
						offset = {
							10,
							0,
							3
						}
					},
					visibility_function = function (content, style)
						return not content.element.is_preview
					end
				},
				{
					pass_type = "texture",
					style_id = "background",
					value = "content/ui/materials/backgrounds/default_square",
					style = {
						default_color = Color.terminal_background(nil, true),
						selected_color = Color.terminal_background_selected(nil, true)
					},
					change_function = ButtonPassTemplates.terminal_button_change_function
				},
				{
					pass_type = "texture",
					style_id = "background_gradient",
					value = "content/ui/materials/gradients/gradient_vertical",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						default_color = Color.terminal_frame(nil, true),
						selected_color = Color.terminal_frame_selected(nil, true),
						disabled_color = Color.ui_grey_medium(255, true),
						size_addition = {
							-50,
							0
						},
						offset = {
							0,
							0,
							1
						}
					},
					change_function = function (content, style)
						ButtonPassTemplates.terminal_button_change_function(content, style)
						ButtonPassTemplates.terminal_button_hover_change_function(content, style)
					end
				},
				{
					value_id = "checkbox",
					style_id = "checkbox_text_default",
					pass_type = "text",
					value = "•",
					style = {
						font_size = 72,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = false,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = {
							255,
							10,
							10,
							10
						},
						offset = {
							0,
							-5,
							5
						}
					},
					visibility_function = function (content, style)
						return not content.checked and not content.element.is_preview
					end
				},
				{
					value_id = "checkbox",
					style_id = "checkbox_text_checked",
					pass_type = "text",
					value = "•",
					style = {
						font_size = 72,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = false,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = Color.terminal_corner_selected(nil, true),
						offset = {
							0,
							-5,
							5
						}
					},
					visibility_function = function (content, style)
						return content.checked and not content.element.is_preview
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
					style_id = "outer_highlight",
					value = "content/ui/materials/frames/dropshadow_heavy",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						scale_to_material = true,
						color = Color.terminal_text_body(200, true),
						size_addition = {
							20,
							20
						},
						offset = {
							0,
							0,
							4
						}
					},
					change_function = function (content, style, _, dt)
						local any_visible_tag_selected_last_frame = content.any_visible_tag_selected_last_frame
						local anim_speed = 2

						if anim_speed then
							local anim_highlight_progress = content.anim_highlight_progress or 0

							if not any_visible_tag_selected_last_frame then
								anim_highlight_progress = math.min(anim_highlight_progress + dt * anim_speed, 1)
							else
								anim_highlight_progress = math.max(anim_highlight_progress - dt * anim_speed, 0)
							end

							content.anim_highlight_progress = anim_highlight_progress

							local pulse_speed = 3
							local pulse_progress = 1 - (0.5 + math.sin(Application.time_since_launch() * pulse_speed) * 0.5)

							style.color[1] = (50 + 100 * pulse_progress) * anim_highlight_progress
						end
					end,
					visibility_function = function (content, style)
						return not content.element.is_preview and not content.hotspot.disabled
					end
				},
				{
					value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
					pass_type = "texture",
					style = {
						offset = {
							0,
							0,
							7
						},
						color = {
							105,
							45,
							45,
							45
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					style_id = "required_level_background",
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							6
						},
						color = {
							150,
							35,
							0,
							0
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					value_id = "required_level_text",
					style_id = "required_level_text",
					pass_type = "text",
					value = "",
					style = {
						text_vertical_alignment = "center",
						font_size = 22,
						horizontal_alignment = "center",
						text_horizontal_alignment = "right",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size_addition = {
							-40,
							-20
						},
						text_color = {
							255,
							159,
							67,
							67
						},
						offset = {
							0,
							0,
							8
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					value = "",
					pass_type = "text",
					style = {
						font_size = 28,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = {
							255,
							159,
							67,
							67
						},
						offset = {
							0,
							0,
							8
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					value = "",
					pass_type = "text",
					style = {
						font_size = 28,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = Color.ui_grey_medium(255, true),
						offset = {
							0,
							0,
							8
						}
					},
					visibility_function = function (content, style)
						return content.hotspot.disabled and content.element.block_reason == nil
					end
				},
				{
					pass_type = "texture",
					style_id = "frame",
					value = "content/ui/materials/frames/frame_tile_2px",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							9
						},
						default_color = Color.terminal_frame(nil, true),
						selected_color = Color.terminal_frame_selected(nil, true),
						disabled_color = Color.ui_grey_medium(255, true),
						hover_color = Color.terminal_frame_hover(nil, true)
					},
					change_function = ButtonPassTemplates.terminal_button_change_function
				},
				{
					pass_type = "texture",
					style_id = "corner",
					value = "content/ui/materials/frames/frame_corner_2px",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							10
						},
						default_color = Color.terminal_corner(nil, true),
						selected_color = Color.terminal_corner_selected(nil, true),
						disabled_color = Color.ui_grey_light(255, true),
						hover_color = Color.terminal_corner_hover(nil, true)
					},
					change_function = ButtonPassTemplates.terminal_button_change_function
				},
				{
					style_id = "text",
					pass_type = "text",
					value_id = "text",
					style = terminal_button_text_style,
					change_function = function (content, style)
						local hotspot = content.hotspot
						local is_disabled = hotspot.disabled
						local default_color = is_disabled and style.disabled_color or style.default_color
						local hover_color = style.hover_color
						local color = style.text_color
						local progress = math.max(math.max(hotspot.anim_checked_progress or 0, math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress)), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

						if color and default_color and hover_color then
							ColorUtilities.color_lerp(default_color, hover_color, progress, color)
						end
					end
				},
				{
					value = "content/ui/materials/base/ui_default_base",
					style_id = "background_texture",
					pass_type = "texture_uv",
					style = {
						scale_to_material = true,
						horizontal_alignment = "right",
						vertical_alignment = "center",
						material_values = {
							texture_map = "content/ui/textures/missions/lm_scavenge_big"
						},
						offset = {
							0,
							0,
							2
						},
						size_addition = {
							-50,
							0
						},
						color = {
							200,
							200,
							200,
							200
						},
						selected_color = {
							200,
							200,
							200,
							200
						},
						uvs = {
							{
								0,
								1
							},
							{
								1,
								1
							}
						}
					}
				}
			},
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
				local style = widget.style
				local content = widget.content

				content.element = element
				content.text = element.text or "n/a"
				content.hotspot.pressed_callback = element.pressed_callback

				if element.block_reason then
					content.required_level_text = element.block_reason
				end

				if element.is_preview then
					style.background_gradient.size_addition[1] = 0
					style.text.offset[1] = 20
				end

				local tag = element.tag
				local background_texture = tag and tag.background_texture

				if background_texture then
					local background_texture_style = style.background_texture

					background_texture_style.material_values.texture_map = background_texture

					local element_width = 100
					local element_height = 100
					local image_width = 575
					local image_height = 120
					local uvs = background_texture_style.uvs

					uvs[1][2] = (image_width - element_width) * 0.5 / image_width
					uvs[2][2] = 1 - (image_height - element_height) * 0.5 / image_height
				end
			end
		},
		tag_game_mode_with_unlocks = {
			size = {
				grid_size[1],
				60
			},
			size_function = function (parent, element, ui_renderer)
				local size = element.size

				return {
					size and size[1] or grid_size[1],
					size and size[2] or 60
				}
			end,
			pass_template = {
				{
					pass_type = "hotspot",
					content_id = "hotspot",
					content = {
						on_hover_sound = UISoundEvents.default_mouse_hover,
						on_pressed_sound = UISoundEvents.default_click
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
					end
				},
				{
					style_id = "heckbox_background",
					pass_type = "rect",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						color = {
							180,
							28,
							31,
							28
						},
						size = {
							50
						},
						offset = {
							0,
							0,
							2
						}
					},
					visibility_function = function (content, style)
						return not content.element.is_preview
					end
				},
				{
					style_id = "checkbox_shadow",
					pass_type = "texture",
					value = "content/ui/materials/frames/dropshadow_medium",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						scale_to_material = true,
						color = Color.black(150, true),
						size_addition = {
							-30,
							20
						},
						offset = {
							10,
							0,
							3
						}
					},
					visibility_function = function (content, style)
						return not content.element.is_preview
					end
				},
				{
					pass_type = "texture",
					style_id = "background",
					value = "content/ui/materials/backgrounds/default_square",
					style = {
						default_color = Color.terminal_background(nil, true),
						selected_color = Color.terminal_background_selected(nil, true)
					},
					change_function = ButtonPassTemplates.terminal_button_change_function
				},
				{
					pass_type = "texture",
					style_id = "background_gradient",
					value = "content/ui/materials/gradients/gradient_vertical",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						default_color = Color.terminal_frame(nil, true),
						selected_color = Color.terminal_frame_selected(nil, true),
						disabled_color = Color.ui_grey_medium(255, true),
						size_addition = {
							-50,
							0
						},
						offset = {
							0,
							0,
							1
						}
					},
					change_function = function (content, style)
						ButtonPassTemplates.terminal_button_change_function(content, style)
						ButtonPassTemplates.terminal_button_hover_change_function(content, style)
					end
				},
				{
					value_id = "checkbox",
					style_id = "checkbox_text_default",
					pass_type = "text",
					value = "•",
					style = {
						font_size = 72,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = false,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = {
							255,
							10,
							10,
							10
						},
						offset = {
							0,
							-5,
							5
						}
					},
					visibility_function = function (content, style)
						return not content.checked and not content.element.is_preview
					end
				},
				{
					value_id = "checkbox",
					style_id = "checkbox_text_checked",
					pass_type = "text",
					value = "•",
					style = {
						font_size = 72,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = false,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = Color.terminal_corner_selected(nil, true),
						offset = {
							0,
							-5,
							5
						}
					},
					visibility_function = function (content, style)
						return content.checked and not content.element.is_preview
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
					style_id = "outer_highlight",
					value = "content/ui/materials/frames/dropshadow_heavy",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						scale_to_material = true,
						color = Color.terminal_text_body(200, true),
						size_addition = {
							20,
							20
						},
						offset = {
							0,
							0,
							4
						}
					},
					change_function = function (content, style, _, dt)
						local any_visible_tag_selected_last_frame = content.any_visible_tag_selected_last_frame
						local anim_speed = 2

						if anim_speed then
							local anim_highlight_progress = content.anim_highlight_progress or 0

							if not any_visible_tag_selected_last_frame then
								anim_highlight_progress = math.min(anim_highlight_progress + dt * anim_speed, 1)
							else
								anim_highlight_progress = math.max(anim_highlight_progress - dt * anim_speed, 0)
							end

							content.anim_highlight_progress = anim_highlight_progress

							local pulse_speed = 3
							local pulse_progress = 1 - (0.5 + math.sin(Application.time_since_launch() * pulse_speed) * 0.5)

							style.color[1] = (50 + 100 * pulse_progress) * anim_highlight_progress
						end
					end,
					visibility_function = function (content, style)
						return not content.element.is_preview and not content.hotspot.disabled
					end
				},
				{
					value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
					pass_type = "texture",
					style = {
						offset = {
							0,
							0,
							7
						},
						color = {
							105,
							45,
							45,
							45
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					style_id = "required_level_background",
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							6
						},
						color = {
							150,
							35,
							0,
							0
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					value_id = "required_level_text",
					style_id = "required_level_text",
					pass_type = "text",
					value = "",
					style = {
						text_vertical_alignment = "center",
						font_size = 22,
						horizontal_alignment = "center",
						text_horizontal_alignment = "right",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size_addition = {
							-40,
							-20
						},
						text_color = {
							255,
							159,
							67,
							67
						},
						offset = {
							0,
							0,
							8
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					value = "",
					pass_type = "text",
					style = {
						font_size = 28,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = {
							255,
							159,
							67,
							67
						},
						offset = {
							0,
							0,
							8
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					value = "",
					pass_type = "text",
					style = {
						font_size = 28,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = Color.ui_grey_medium(255, true),
						offset = {
							0,
							0,
							8
						}
					},
					visibility_function = function (content, style)
						return content.hotspot.disabled and content.element.block_reason == nil
					end
				},
				{
					pass_type = "texture",
					style_id = "frame",
					value = "content/ui/materials/frames/frame_tile_2px",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							9
						},
						default_color = Color.terminal_frame(nil, true),
						selected_color = Color.terminal_frame_selected(nil, true),
						disabled_color = Color.ui_grey_medium(255, true),
						hover_color = Color.terminal_frame_hover(nil, true)
					},
					change_function = ButtonPassTemplates.terminal_button_change_function
				},
				{
					pass_type = "texture",
					style_id = "corner",
					value = "content/ui/materials/frames/frame_corner_2px",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							10
						},
						default_color = Color.terminal_corner(nil, true),
						selected_color = Color.terminal_corner_selected(nil, true),
						disabled_color = Color.ui_grey_light(255, true),
						hover_color = Color.terminal_corner_hover(nil, true)
					},
					change_function = ButtonPassTemplates.terminal_button_change_function
				},
				{
					style_id = "text",
					pass_type = "text",
					value_id = "text",
					style = terminal_button_text_style,
					change_function = function (content, style)
						local hotspot = content.hotspot
						local is_disabled = hotspot.disabled
						local default_color = is_disabled and style.disabled_color or style.default_color
						local hover_color = style.hover_color
						local color = style.text_color
						local progress = math.max(math.max(hotspot.anim_checked_progress or 0, math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress)), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

						if color and default_color and hover_color then
							ColorUtilities.color_lerp(default_color, hover_color, progress, color)
						end
					end
				},
				{
					value = "content/ui/materials/base/ui_default_base",
					style_id = "background_texture",
					pass_type = "texture_uv",
					style = {
						scale_to_material = true,
						horizontal_alignment = "right",
						vertical_alignment = "center",
						material_values = {
							texture_map = "content/ui/textures/missions/lm_scavenge_big"
						},
						offset = {
							0,
							0,
							2
						},
						size_addition = {
							-50,
							0
						},
						color = {
							200,
							200,
							200,
							200
						},
						selected_color = {
							200,
							200,
							200,
							200
						},
						uvs = {
							{
								0,
								1
							},
							{
								1,
								1
							}
						}
					}
				}
			},
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
				local style = widget.style
				local content = widget.content

				element.auto_next = true
				content.element = element
				content.text = element.text or "n/a"
				content.hotspot.pressed_callback = element.pressed_callback

				if element.block_reason then
					content.required_level_text = element.block_reason
				end

				if element.is_preview then
					style.background_gradient.size_addition[1] = 0
					style.text.offset[1] = 20
				end

				local tag = element.tag
				local background_texture = tag and tag.background_texture

				if background_texture then
					local background_texture_style = style.background_texture

					background_texture_style.material_values.texture_map = background_texture

					local element_width = 100
					local element_height = 100
					local image_width = 575
					local image_height = 120
					local uvs = background_texture_style.uvs

					uvs[1][2] = (image_width - element_width) * 0.5 / image_width
					uvs[2][2] = 1 - (image_height - element_height) * 0.5 / image_height
				end
			end
		},
		tag_slot_button = {
			size = {
				grid_size[1],
				80
			},
			size_function = function (parent, element, ui_renderer)
				local size = element.size

				return {
					size and size[1] or grid_size[1],
					size and size[2] or 80
				}
			end,
			pass_template = {
				{
					pass_type = "hotspot",
					content_id = "hotspot",
					content = {}
				},
				{
					style_id = "rect",
					pass_type = "rect",
					style = {
						color = Color.black(200, true)
					}
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
							-10,
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
							-9,
							1,
							1
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
						offset = {
							0,
							0,
							7
						},
						default_color = Color.terminal_frame(nil, true),
						selected_color = Color.terminal_frame_selected(nil, true),
						disabled_color = Color.ui_grey_medium(255, true),
						hover_color = Color.terminal_frame_hover(nil, true)
					},
					change_function = ButtonPassTemplates.terminal_button_change_function
				},
				{
					pass_type = "texture",
					style_id = "corner",
					value = "content/ui/materials/frames/frame_corner_2px",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							8
						},
						default_color = Color.terminal_corner(nil, true),
						selected_color = Color.terminal_corner_selected(nil, true),
						disabled_color = Color.ui_grey_light(255, true),
						hover_color = Color.terminal_corner_hover(nil, true)
					},
					change_function = ButtonPassTemplates.terminal_button_change_function
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
							4
						}
					}
				},
				{
					pass_type = "texture",
					style_id = "outer_highlight",
					value = "content/ui/materials/frames/dropshadow_heavy",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						scale_to_material = true,
						color = Color.terminal_text_body(200, true),
						size_addition = {
							20,
							20
						},
						offset = {
							0,
							0,
							4
						}
					},
					change_function = function (content, style, _, dt)
						local any_visible_tag_selected_last_frame = content.any_visible_tag_selected_last_frame
						local anim_speed = 2

						if anim_speed then
							local anim_highlight_progress = content.anim_highlight_progress or 0

							if not any_visible_tag_selected_last_frame then
								anim_highlight_progress = math.min(anim_highlight_progress + dt * anim_speed, 1)
							else
								anim_highlight_progress = math.max(anim_highlight_progress - dt * anim_speed, 0)
							end

							content.anim_highlight_progress = anim_highlight_progress

							local pulse_speed = 3
							local pulse_progress = 1 - (0.5 + math.sin(Application.time_since_launch() * pulse_speed) * 0.5)

							style.color[1] = (50 + 100 * pulse_progress) * anim_highlight_progress
						end
					end,
					visibility_function = function (content, style)
						return not content.element.is_preview and not content.hotspot.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "background_gradient",
					value = "content/ui/materials/gradients/gradient_vertical",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						default_color = Color.terminal_frame(nil, true),
						selected_color = Color.terminal_frame_selected(nil, true),
						disabled_color = Color.ui_grey_medium(255, true),
						offset = {
							0,
							0,
							1
						}
					},
					change_function = function (content, style)
						ButtonPassTemplates.terminal_button_change_function(content, style)
						ButtonPassTemplates.terminal_button_hover_change_function(content, style)
					end
				},
				{
					style_id = "text",
					value_id = "text",
					pass_type = "text",
					value = "n/a",
					style = tag_slot_header_text_style
				},
				{
					style_id = "sub_header_filled",
					value_id = "sub_header_filled",
					pass_type = "text",
					style = tag_slot_sub_header_text_style,
					value = Localize("loc_group_finder_slot_tag_button_default_value"),
					visibility_function = function (content)
						return content.slot_filled
					end
				},
				{
					style_id = "sub_header",
					value_id = "sub_header",
					pass_type = "text",
					style = tag_slot_sub_header_text_style,
					value = Localize("loc_group_finder_slot_tag_button_default_value"),
					visibility_function = function (content)
						return not content.slot_filled
					end
				},
				{
					value_id = "difficulty_icon",
					style_id = "difficulty_icon",
					pass_type = "texture",
					value = "content/ui/materials/icons/difficulty/difficulty_skull_uprising",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						visible = false,
						color = Color.terminal_text_header(255, true),
						offset = {
							-27,
							0,
							4
						},
						size = {
							48,
							48
						}
					}
				},
				{
					value = "content/ui/materials/gradients/gradient_texture_diagonal",
					style_id = "background_texture",
					pass_type = "texture",
					style = {
						scale_to_material = true,
						material_values = {
							texture_map = "content/ui/textures/missions/lm_scavenge_big"
						},
						offset = {
							0,
							0,
							2
						},
						default_color = Color.white(nil, true),
						selected_color = Color.white(nil, true),
						change_function = ButtonPassTemplates.terminal_button_change_function
					}
				}
			},
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
				local style = widget.style
				local content = widget.content

				element.auto_next = true
				element.auto_clear_on_back = true
				content.element = element
				content.text = element.text or "n/a"
				content.hotspot.pressed_callback = element.pressed_callback

				local tag = element.tag
				local background_texture = tag and tag.background_texture

				if background_texture then
					local background_texture_style = style.background_texture

					background_texture_style.material_values.texture_map = background_texture
				end

				local get_selected_unlocks_tags = element.get_selected_unlocks_tags

				if get_selected_unlocks_tags then
					local selected_tags = get_selected_unlocks_tags()

					if selected_tags and #selected_tags > 0 then
						local sub_header_text, sub_header_color = nil, Color.terminal_text_key_value(200, true)

						if #selected_tags > 1 then
							sub_header_text = Localize("loc_group_finder_slot_tag_multiple_selected_tags_text", true, {
								num_tags = tostring(#selected_tags)
							})
						else
							local first_selected_tag = selected_tags[1]

							sub_header_text = first_selected_tag and first_selected_tag.text or "-"

							local difficulty_name = first_selected_tag.difficulty
							local difficulty_index = Danger.index_by_name(difficulty_name)
							local danger_settings = DangerSettings[difficulty_index]

							if danger_settings then
								style.difficulty_icon.visible = true
								content.difficulty_icon = danger_settings.icon
							end
						end

						content.slot_filled = true
						content.sub_header_filled = TextUtilities.apply_color_to_text(sub_header_text, sub_header_color)
					end
				end
			end
		},
		tag_category_button = {
			size = {
				grid_size[1],
				60
			},
			size_function = function (parent, element, ui_renderer)
				local size = element.size

				return {
					size and size[1] or grid_size[1],
					size and size[2] or 60
				}
			end,
			pass_template = {
				{
					pass_type = "hotspot",
					content_id = "hotspot",
					content = {}
				},
				{
					style_id = "rect",
					pass_type = "rect",
					style = {
						color = Color.black(200, true)
					}
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
							-10,
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
							-9,
							1,
							1
						}
					}
				},
				{
					value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
					pass_type = "texture",
					style = {
						offset = {
							0,
							0,
							7
						},
						color = {
							105,
							45,
							45,
							45
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					style_id = "required_level_background",
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							6
						},
						color = {
							150,
							35,
							0,
							0
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					value_id = "required_level_text",
					style_id = "required_level_text",
					pass_type = "text",
					value = "",
					style = {
						text_vertical_alignment = "center",
						font_size = 22,
						horizontal_alignment = "center",
						text_horizontal_alignment = "right",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size_addition = {
							-40,
							-20
						},
						text_color = {
							255,
							159,
							67,
							67
						},
						offset = {
							0,
							0,
							8
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					value = "",
					pass_type = "text",
					style = {
						font_size = 28,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = {
							255,
							159,
							67,
							67
						},
						offset = {
							0,
							0,
							8
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					value = "",
					pass_type = "text",
					style = {
						font_size = 28,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = Color.ui_grey_medium(255, true),
						offset = {
							0,
							0,
							8
						}
					},
					visibility_function = function (content, style)
						return content.hotspot.disabled and content.element.block_reason == nil
					end
				},
				{
					pass_type = "texture",
					style_id = "frame",
					value = "content/ui/materials/frames/frame_tile_2px",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							9
						},
						default_color = Color.terminal_frame(nil, true),
						selected_color = Color.terminal_frame_selected(nil, true),
						disabled_color = Color.ui_grey_medium(255, true),
						hover_color = Color.terminal_frame_hover(nil, true)
					},
					change_function = ButtonPassTemplates.terminal_button_change_function
				},
				{
					pass_type = "texture",
					style_id = "corner",
					value = "content/ui/materials/frames/frame_corner_2px",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							10
						},
						default_color = Color.terminal_corner(nil, true),
						selected_color = Color.terminal_corner_selected(nil, true),
						disabled_color = Color.ui_grey_light(255, true),
						hover_color = Color.terminal_corner_hover(nil, true)
					},
					change_function = ButtonPassTemplates.terminal_button_change_function
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
							4
						}
					}
				},
				{
					pass_type = "texture",
					style_id = "outer_highlight",
					value = "content/ui/materials/frames/dropshadow_heavy",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						scale_to_material = true,
						color = Color.terminal_text_body(200, true),
						size_addition = {
							20,
							20
						},
						offset = {
							0,
							0,
							4
						}
					},
					change_function = function (content, style, _, dt)
						local any_visible_tag_selected_last_frame = content.any_visible_tag_selected_last_frame
						local anim_speed = 2

						if anim_speed then
							local anim_highlight_progress = content.anim_highlight_progress or 0

							if not any_visible_tag_selected_last_frame then
								anim_highlight_progress = math.min(anim_highlight_progress + dt * anim_speed, 1)
							else
								anim_highlight_progress = math.max(anim_highlight_progress - dt * anim_speed, 0)
							end

							content.anim_highlight_progress = anim_highlight_progress

							local pulse_speed = 3
							local pulse_progress = 1 - (0.5 + math.sin(Application.time_since_launch() * pulse_speed) * 0.5)

							style.color[1] = (50 + 100 * pulse_progress) * anim_highlight_progress
						end
					end,
					visibility_function = function (content, style)
						return not content.element.is_preview and not content.hotspot.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "background_gradient",
					value = "content/ui/materials/gradients/gradient_vertical",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						default_color = Color.terminal_frame(nil, true),
						selected_color = Color.terminal_frame_selected(nil, true),
						disabled_color = Color.ui_grey_medium(255, true),
						offset = {
							0,
							0,
							1
						}
					},
					change_function = function (content, style)
						ButtonPassTemplates.terminal_button_change_function(content, style)
						ButtonPassTemplates.terminal_button_hover_change_function(content, style)
					end
				},
				{
					style_id = "text",
					value_id = "text",
					pass_type = "text",
					value = "n/a",
					style = tag_text_style
				}
			},
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
				local style = widget.style
				local content = widget.content

				element.auto_next = true
				element.auto_clear_on_back = true
				content.element = element
				content.text = element.text or "n/a"
				content.hotspot.pressed_callback = element.pressed_callback

				if element.block_reason then
					content.required_level_text = element.block_reason
				end
			end
		},
		tag_difficulty = {
			size = {
				grid_size[1],
				60
			},
			size_function = function (parent, element, ui_renderer)
				local size = element.size

				return {
					size and size[1] or grid_size[1],
					size and size[2] or 60
				}
			end,
			pass_template = {
				{
					pass_type = "hotspot",
					content_id = "hotspot",
					content = {
						on_hover_sound = UISoundEvents.default_mouse_hover,
						on_pressed_sound = UISoundEvents.default_click
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
					end
				},
				{
					style_id = "checkbox_background",
					pass_type = "rect",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						color = {
							180,
							28,
							31,
							28
						},
						size = {
							50
						},
						offset = {
							0,
							0,
							2
						}
					},
					visibility_function = function (content, style)
						return not content.element.is_preview
					end
				},
				{
					style_id = "checkbox_shadow",
					pass_type = "texture",
					value = "content/ui/materials/frames/dropshadow_medium",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						scale_to_material = true,
						color = Color.black(150, true),
						size_addition = {
							-30,
							20
						},
						offset = {
							10,
							0,
							3
						}
					},
					visibility_function = function (content, style)
						return not content.element.is_preview
					end
				},
				{
					pass_type = "texture",
					style_id = "background",
					value = "content/ui/materials/backgrounds/default_square",
					style = {
						default_color = Color.terminal_background(nil, true),
						selected_color = Color.terminal_background_selected(nil, true)
					},
					change_function = ButtonPassTemplates.terminal_button_change_function
				},
				{
					pass_type = "texture",
					style_id = "background_gradient",
					value = "content/ui/materials/gradients/gradient_vertical",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						default_color = Color.terminal_frame(nil, true),
						selected_color = Color.terminal_frame_selected(nil, true),
						disabled_color = Color.ui_grey_medium(255, true),
						size_addition = {
							-50,
							0
						},
						offset = {
							0,
							0,
							1
						}
					},
					change_function = function (content, style)
						ButtonPassTemplates.terminal_button_change_function(content, style)
						ButtonPassTemplates.terminal_button_hover_change_function(content, style)
					end
				},
				{
					value_id = "checkbox",
					style_id = "checkbox_text_default",
					pass_type = "text",
					value = "•",
					style = {
						font_size = 72,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = false,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = {
							255,
							10,
							10,
							10
						},
						offset = {
							0,
							-5,
							5
						}
					},
					visibility_function = function (content, style)
						return not content.checked and not content.element.is_preview
					end
				},
				{
					value_id = "checkbox",
					style_id = "checkbox_text_checked",
					pass_type = "text",
					value = "•",
					style = {
						font_size = 72,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = false,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = Color.terminal_corner_selected(nil, true),
						offset = {
							0,
							-5,
							5
						}
					},
					visibility_function = function (content, style)
						return content.checked and not content.element.is_preview
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
					style_id = "outer_highlight",
					value = "content/ui/materials/frames/dropshadow_heavy",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						scale_to_material = true,
						color = Color.terminal_text_body(200, true),
						size_addition = {
							20,
							20
						},
						offset = {
							0,
							0,
							4
						}
					},
					change_function = function (content, style, _, dt)
						local any_visible_tag_selected_last_frame = content.any_visible_tag_selected_last_frame
						local anim_speed = 2

						if anim_speed then
							local anim_highlight_progress = content.anim_highlight_progress or 0

							if not any_visible_tag_selected_last_frame then
								anim_highlight_progress = math.min(anim_highlight_progress + dt * anim_speed, 1)
							else
								anim_highlight_progress = math.max(anim_highlight_progress - dt * anim_speed, 0)
							end

							content.anim_highlight_progress = anim_highlight_progress

							local pulse_speed = 3
							local pulse_progress = 1 - (0.5 + math.sin(Application.time_since_launch() * pulse_speed) * 0.5)

							style.color[1] = (50 + 100 * pulse_progress) * anim_highlight_progress
						end
					end,
					visibility_function = function (content, style)
						return not content.element.is_preview and not content.hotspot.disabled
					end
				},
				{
					value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
					pass_type = "texture",
					style = {
						offset = {
							0,
							0,
							7
						},
						color = {
							105,
							45,
							45,
							45
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					style_id = "required_level_background",
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							6
						},
						color = {
							150,
							35,
							0,
							0
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					value_id = "required_level_text",
					style_id = "required_level_text",
					pass_type = "text",
					value = "",
					style = {
						text_vertical_alignment = "center",
						font_size = 22,
						horizontal_alignment = "center",
						text_horizontal_alignment = "right",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size_addition = {
							-40,
							-20
						},
						text_color = {
							255,
							159,
							67,
							67
						},
						offset = {
							0,
							0,
							8
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					value = "",
					pass_type = "text",
					style = {
						font_size = 28,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = {
							255,
							159,
							67,
							67
						},
						offset = {
							0,
							0,
							8
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					value = "",
					pass_type = "text",
					style = {
						font_size = 28,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size = {
							50
						},
						text_color = Color.ui_grey_medium(255, true),
						offset = {
							0,
							0,
							8
						}
					},
					visibility_function = function (content, style)
						return content.hotspot.disabled and content.element.block_reason == nil
					end
				},
				{
					pass_type = "texture",
					style_id = "frame",
					value = "content/ui/materials/frames/frame_tile_2px",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							9
						},
						default_color = Color.terminal_frame(nil, true),
						selected_color = Color.terminal_frame_selected(nil, true),
						disabled_color = Color.ui_grey_medium(255, true),
						hover_color = Color.terminal_frame_hover(nil, true)
					},
					change_function = ButtonPassTemplates.terminal_button_change_function
				},
				{
					pass_type = "texture",
					style_id = "corner",
					value = "content/ui/materials/frames/frame_corner_2px",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							10
						},
						default_color = Color.terminal_corner(nil, true),
						selected_color = Color.terminal_corner_selected(nil, true),
						disabled_color = Color.ui_grey_light(255, true),
						hover_color = Color.terminal_corner_hover(nil, true)
					},
					change_function = ButtonPassTemplates.terminal_button_change_function
				},
				{
					style_id = "text",
					pass_type = "text",
					value_id = "text",
					style = terminal_button_text_style,
					change_function = function (content, style)
						local hotspot = content.hotspot
						local is_disabled = hotspot.disabled
						local default_color = is_disabled and style.disabled_color or style.default_color
						local hover_color = style.hover_color
						local color = style.text_color
						local progress = math.max(math.max(hotspot.anim_checked_progress or 0, math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress)), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

						if color and default_color and hover_color then
							ColorUtilities.color_lerp(default_color, hover_color, progress, color)
						end
					end
				},
				{
					value_id = "difficulty_icon",
					style_id = "difficulty_icon",
					pass_type = "texture",
					value = "content/ui/materials/icons/difficulty/difficulty_skull_uprising",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						color = Color.terminal_text_header(255, true),
						offset = {
							-27,
							0,
							4
						},
						size = {
							48,
							48
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason == nil
					end
				}
			},
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
				local style = widget.style
				local content = widget.content

				content.element = element
				content.text = element.text or "n/a"
				content.hotspot.pressed_callback = element.pressed_callback

				if element.block_reason then
					content.required_level_text = element.block_reason
				end

				if element.is_preview then
					style.background_gradient.size_addition[1] = 0
					style.text.offset[1] = 20
				end

				local tag = element.tag
				local difficulty_name = tag.difficulty
				local difficulty_index = Danger.index_by_name(difficulty_name)
				local danger_settings = DangerSettings[difficulty_index]

				if danger_settings then
					content.difficulty_icon = danger_settings.icon
				end
			end
		},
		tag_preview = {
			size = {
				grid_size[1],
				45
			},
			size_function = function (parent, element, ui_renderer)
				local size = element.size

				return {
					size and size[1] or grid_size[1],
					size and size[2] or 45
				}
			end,
			pass_template = {
				{
					value = "content/ui/materials/backgrounds/default_square",
					style_id = "background",
					pass_type = "texture",
					style = {
						color = Color.terminal_background(nil, true)
					}
				},
				{
					value = "content/ui/materials/gradients/gradient_vertical",
					style_id = "background_gradient",
					pass_type = "texture",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						color = Color.terminal_frame(nil, true),
						offset = {
							0,
							0,
							1
						}
					}
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
					value = "content/ui/materials/frames/frame_tile_2px",
					style_id = "frame",
					pass_type = "texture",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							9
						},
						color = Color.terminal_frame(nil, true)
					}
				},
				{
					value = "content/ui/materials/frames/frame_corner_2px",
					style_id = "corner",
					pass_type = "texture",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							10
						},
						color = Color.terminal_corner(nil, true)
					}
				},
				{
					value_id = "text",
					pass_type = "text",
					style_id = "text",
					style = {
						text_vertical_alignment = "center",
						horizontal_alignment = "center",
						font_size = 20,
						text_horizontal_alignment = "center",
						line_spacing = 1,
						font_type = "proxima_nova_bold",
						offset = {
							0,
							0,
							6
						},
						size_addition = {
							-20,
							0
						},
						text_color = {
							255,
							216,
							229,
							207
						}
					}
				}
			},
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
				local content = widget.content

				content.element = element
				content.text = element.text or "n/a"
			end
		},
		dynamic_spacing = {
			size_function = function (parent, element, ui_renderer)
				local size = element.size

				return size and {
					size[1],
					size[2]
				} or {
					225,
					20
				}
			end
		},
		group = {
			size = {
				grid_size[1] * 0.5 - 5,
				120
			},
			size_function = function (parent, element, ui_renderer)
				local size = element.size

				return size and {
					size[1],
					size[2]
				} or {
					grid_size[1] * 0.5 - 5,
					120
				}
			end,
			pass_template = {
				{
					pass_type = "hotspot",
					content_id = "hotspot",
					content = {}
				},
				{
					style_id = "rect",
					pass_type = "rect",
					style = {
						color = Color.black(200, true)
					}
				},
				{
					style_id = "background_texture",
					pass_type = "texture",
					value = "content/ui/materials/base/ui_default_base",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						material_values = {
							texture_map = "content/ui/textures/backgrounds/group_finder/group_finder_generic_bg"
						},
						offset = {
							0,
							0,
							2
						},
						color = {
							150,
							200,
							200,
							200
						}
					},
					visibility_function = function (content, style)
						return style.material_values.texture_map ~= nil
					end
				},
				{
					pass_type = "texture",
					style_id = "frame",
					value = "content/ui/materials/frames/frame_tile_2px",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							9
						},
						default_color = Color.terminal_frame(nil, true),
						selected_color = Color.terminal_frame_selected(nil, true),
						disabled_color = Color.terminal_frame(255, true),
						hover_color = Color.terminal_frame_hover(nil, true)
					},
					change_function = ButtonPassTemplates.terminal_button_change_function
				},
				{
					pass_type = "texture",
					style_id = "corner",
					value = "content/ui/materials/frames/frame_corner_2px",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							10
						},
						default_color = Color.terminal_corner(nil, true),
						selected_color = Color.terminal_corner_selected(nil, true),
						disabled_color = Color.terminal_corner(255, true),
						hover_color = Color.terminal_corner_hover(nil, true)
					},
					change_function = ButtonPassTemplates.terminal_button_change_function
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
					style_id = "background_gradient",
					value = "content/ui/materials/gradients/gradient_vertical",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						default_color = Color.terminal_frame(nil, true),
						selected_color = Color.terminal_frame_selected(nil, true),
						disabled_color = Color.terminal_frame(255, true),
						offset = {
							0,
							0,
							1
						}
					},
					change_function = function (content, style)
						ButtonPassTemplates.terminal_button_change_function(content, style)
						ButtonPassTemplates.terminal_button_hover_change_function(content, style)
					end
				},
				{
					style_id = "description",
					value_id = "description",
					pass_type = "text",
					value = "",
					style = {
						horizontal_alignment = "center",
						font_size = 20,
						text_vertical_alignment = "top",
						text_horizontal_alignment = "left",
						vertical_alignment = "center",
						font_type = "proxima_nova_bold",
						text_color = Color.terminal_text_header(255, true),
						offset = {
							0,
							10,
							3
						},
						size_addition = {
							-20,
							0
						}
					}
				},
				{
					value_id = "difficulty_icon",
					style_id = "difficulty_icon",
					pass_type = "texture",
					value = "content/ui/materials/icons/difficulty/difficulty_skull_uprising",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						visible = false,
						color = Color.terminal_text_header(255, true),
						offset = {
							-10,
							-10,
							5
						},
						size = {
							32,
							32
						}
					}
				},
				{
					value = "content/ui/materials/gradients/gradient_horizontal",
					pass_type = "texture",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						size = {
							200,
							45
						},
						color = Color.black(255, true),
						offset = {
							0,
							0,
							3
						}
					},
					visibility_function = function (content, style)
						return style.difficulty_icon and style.difficulty_icon.visible
					end
				},
				{
					style_id = "havoc_rank_text",
					value_id = "havoc_rank_text",
					pass_type = "text",
					value = "",
					style = {
						font_type = "proxima_nova_bold",
						font_size = 32,
						text_vertical_alignment = "bottom",
						text_horizontal_alignment = "left",
						text_color = Color.terminal_text_header(255, true),
						offset = {
							425,
							-3,
							4
						},
						size_addition = {
							0,
							0
						}
					}
				},
				{
					style_id = "havoc_icon_text",
					value_id = "havoc_icon_text",
					pass_type = "text",
					value = "",
					style = {
						font_type = "proxima_nova_bold",
						font_size = 40,
						text_vertical_alignment = "bottom",
						text_horizontal_alignment = "left",
						text_color = Color.terminal_text_header(255, true),
						offset = {
							385,
							-3,
							4
						},
						size_addition = {
							0,
							0
						}
					}
				},
				{
					value = "content/ui/materials/gradients/gradient_horizontal",
					pass_type = "texture",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						size = {
							200,
							45
						},
						color = Color.black(255, true),
						offset = {
							0,
							0,
							3
						}
					},
					visibility_function = function (content, style)
						return content.havoc_rank_text ~= ""
					end
				},
				{
					value_id = "circumstance_icon_1",
					pass_type = "texture",
					value = "content/ui/materials/icons/circumstances/assault_01",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						size = {
							32,
							32
						},
						color = Color.terminal_text_key_value(255, true),
						offset = {
							-105,
							-8,
							5
						}
					},
					visibility_function = function (content, style)
						return content.circumstance_icons and content.circumstance_icons[1] ~= nil
					end
				},
				{
					value_id = "circumstance_icon_1",
					pass_type = "texture",
					value = "content/ui/materials/icons/circumstances/assault_01",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						size = {
							32,
							32
						},
						color = Color.black(255, true),
						offset = {
							-103,
							-6,
							4
						}
					},
					visibility_function = function (content, style)
						return content.circumstance_icons and content.circumstance_icons[1] ~= nil
					end
				},
				{
					value_id = "circumstance_icon_2",
					pass_type = "texture",
					value = "content/ui/materials/icons/circumstances/assault_01",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						size = {
							32,
							32
						},
						color = Color.terminal_text_key_value(255, true),
						offset = {
							-145,
							-8,
							5
						}
					},
					visibility_function = function (content, style)
						return content.circumstance_icons and content.circumstance_icons[2] ~= nil
					end
				},
				{
					value_id = "circumstance_icon_2",
					pass_type = "texture",
					value = "content/ui/materials/icons/circumstances/assault_01",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						size = {
							32,
							32
						},
						color = Color.black(255, true),
						offset = {
							-143,
							-6,
							4
						}
					},
					visibility_function = function (content, style)
						return content.circumstance_icons and content.circumstance_icons[2] ~= nil
					end
				},
				{
					value_id = "circumstance_icon_3",
					pass_type = "texture",
					value = "content/ui/materials/icons/circumstances/assault_01",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						size = {
							32,
							32
						},
						color = Color.terminal_text_key_value(255, true),
						offset = {
							-185,
							-8,
							5
						}
					},
					visibility_function = function (content, style)
						return content.circumstance_icons and content.circumstance_icons[3] ~= nil
					end
				},
				{
					value_id = "circumstance_icon_3",
					pass_type = "texture",
					value = "content/ui/materials/icons/circumstances/assault_01",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						size = {
							32,
							32
						},
						color = Color.black(255, true),
						offset = {
							-183,
							-6,
							4
						}
					},
					visibility_function = function (content, style)
						return content.circumstance_icons and content.circumstance_icons[3] ~= nil
					end
				},
				{
					value_id = "circumstance_icon_4",
					pass_type = "texture",
					value = "content/ui/materials/icons/circumstances/assault_01",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						size = {
							32,
							32
						},
						color = Color.terminal_text_key_value(255, true),
						offset = {
							-225,
							-8,
							5
						}
					},
					visibility_function = function (content, style)
						return content.circumstance_icons and content.circumstance_icons[4] ~= nil
					end
				},
				{
					value_id = "circumstance_icon_4",
					pass_type = "texture",
					value = "content/ui/materials/icons/circumstances/assault_01",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						size = {
							32,
							32
						},
						color = Color.black(255, true),
						offset = {
							-223,
							-6,
							4
						}
					},
					visibility_function = function (content, style)
						return content.circumstance_icons and content.circumstance_icons[4] ~= nil
					end
				},
				{
					style_id = "team_counter",
					value_id = "team_counter",
					pass_type = "text",
					value = "-",
					style = {
						font_type = "proxima_nova_bold",
						font_size = 16,
						text_vertical_alignment = "bottom",
						text_horizontal_alignment = "left",
						text_color = Color.terminal_text_body_sub_header(255, true),
						offset = {
							10,
							-48,
							4
						},
						size_addition = {
							0,
							0
						}
					}
				},
				{
					style_id = "team_member_icon_4",
					value_id = "team_member_icon_4",
					pass_type = "text",
					value = "",
					style = {
						font_size = 32,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "bottom",
						font_type = "proxima_nova_bold",
						text_color = {
							255,
							255,
							255,
							255
						},
						color = {
							255,
							255,
							255,
							255
						},
						size = {
							40,
							40
						},
						offset = {
							121,
							-5,
							3
						}
					}
				},
				{
					style_id = "team_member_icon_3",
					value_id = "team_member_icon_3",
					pass_type = "text",
					value = "",
					style = {
						font_size = 32,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "bottom",
						font_type = "proxima_nova_bold",
						text_color = {
							255,
							255,
							255,
							255
						},
						color = {
							255,
							255,
							255,
							255
						},
						size = {
							40,
							40
						},
						offset = {
							84,
							-5,
							3
						}
					}
				},
				{
					style_id = "team_member_icon_2",
					value_id = "team_member_icon_2",
					pass_type = "text",
					value = "",
					style = {
						font_size = 32,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "bottom",
						font_type = "proxima_nova_bold",
						text_color = {
							255,
							255,
							255,
							255
						},
						color = {
							255,
							255,
							255,
							255
						},
						size = {
							40,
							40
						},
						offset = {
							47,
							-5,
							3
						}
					}
				},
				{
					style_id = "team_member_icon_1",
					value_id = "team_member_icon_1",
					pass_type = "text",
					value = "",
					style = {
						font_size = 32,
						text_vertical_alignment = "center",
						horizontal_alignment = "left",
						text_horizontal_alignment = "center",
						vertical_alignment = "bottom",
						font_type = "proxima_nova_bold",
						text_color = {
							255,
							255,
							255,
							255
						},
						color = {
							255,
							255,
							255,
							255
						},
						size = {
							40,
							40
						},
						offset = {
							10,
							-5,
							3
						}
					}
				},
				{
					value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
					pass_type = "texture",
					style = {
						offset = {
							0,
							0,
							7
						},
						color = {
							105,
							45,
							45,
							45
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					style_id = "required_level_background",
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							6
						},
						color = {
							150,
							35,
							0,
							0
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					value = "content/ui/materials/gradients/gradient_horizontal",
					pass_type = "texture_uv",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "left",
						size = {
							nil,
							45
						},
						color = Color.black(255, true),
						offset = {
							0,
							0,
							8
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
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					value_id = "required_level_text",
					style_id = "required_level_text",
					pass_type = "text",
					value = "",
					style = {
						text_vertical_alignment = "bottom",
						font_size = 22,
						horizontal_alignment = "center",
						text_horizontal_alignment = "left",
						vertical_alignment = "center",
						drop_shadow = true,
						font_type = "proxima_nova_bold",
						size_addition = {
							-40,
							-20
						},
						text_color = {
							255,
							159,
							67,
							67
						},
						offset = {
							0,
							0,
							9
						}
					},
					visibility_function = function (content, style)
						return content.element.block_reason ~= nil
					end
				},
				{
					style_id = "overlay",
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							5
						},
						color = Color.black(220, true)
					},
					visibility_function = function (content, style)
						return content.use_overlay
					end
				},
				{
					value = "content/ui/materials/dividers/faded_line_01",
					pass_type = "texture",
					style = {
						vertical_alignment = "center",
						size = {
							nil,
							40
						},
						color = Color.terminal_grid_background(70, true),
						offset = {
							0,
							0,
							6
						}
					},
					visibility_function = function (content, style)
						return content.use_overlay
					end
				},
				{
					style_id = "overlay_text",
					value_id = "overlay_text",
					pass_type = "text",
					value = "",
					style = {
						horizontal_alignment = "center",
						font_size = 26,
						text_vertical_alignment = "center",
						text_horizontal_alignment = "center",
						vertical_alignment = "center",
						font_type = "machine_medium",
						text_color = Color.terminal_text_header(255, true),
						offset = {
							0,
							0,
							7
						},
						size_addition = {
							0,
							0
						}
					},
					visibility_function = function (content, style)
						return content.use_overlay
					end
				}
			},
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
				local style = widget.style
				local content = widget.content

				content.element = element
				content.group_id = element.group_id
				content.description = element.description or ""
				content.hotspot.pressed_callback = element.pressed_callback
				content.hotspot.disabled = element.disabled

				if element.block_reason then
					content.required_level_text = element.block_reason
				end

				local tags = element.tags

				if tags then
					local background_texture = "content/ui/textures/backgrounds/group_finder/group_finder_generic_bg"
					local difficulty_name

					for i = 1, #tags do
						local tag = tags[i]

						background_texture = tag.background_texture or background_texture
						difficulty_name = tag.difficulty or difficulty_name
					end

					if background_texture then
						local background_texture_style = style.background_texture

						background_texture_style.material_values.texture_map = background_texture
					end

					local difficulty_index = Danger.index_by_name(difficulty_name)
					local danger_settings = DangerSettings[difficulty_index]

					if danger_settings then
						style.difficulty_icon.visible = true
						content.difficulty_icon = danger_settings.icon
					end

					local metadata = element.metadata

					if metadata and next(metadata) then
						if metadata.havoc_order_rank then
							content.havoc_icon_text = "" .. "{#reset()}"
							content.havoc_rank_text = metadata.havoc_order_rank .. "{#reset()}"
						end

						if metadata.havoc_circumstances then
							content.circumstance_icons = {}

							for i, circumstance in ipairs(metadata.havoc_circumstances) do
								local circumstance_template = CircumstanceTemplates[circumstance]
								local icon = circumstance_template.ui.icon

								if i <= 4 then
									content["circumstance_icon_" .. i] = icon

									table.insert(content.circumstance_icons, icon)
								end
							end
						end
					end
				end

				local rect_color = element.color

				if rect_color then
					local color = style.rect.color

					color[1] = rect_color[1]
					color[2] = rect_color[2]
					color[3] = rect_color[3]
					color[4] = rect_color[4]
				end
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				local style = widget.style
				local content = widget.content
				local element = content.element

				if not element then
					return
				end

				local group = element.group

				if not group then
					return
				end

				local members = group.members
				local team_counter = 0
				local total_team_size = 4

				for i = 1, total_team_size do
					local member = members and members[i]
					local member_presence_info = member and member.presence_info
					local player_color = style["team_member_icon_" .. i].text_color

					if member_presence_info and member_presence_info.synced then
						local archetype = member_presence_info.archetype
						local archetype_font_icon = archetype and UISettings.archetype_font_icon_simple[archetype]

						team_counter = team_counter + 1
						content["team_member_icon_" .. i] = archetype_font_icon or ""
						player_color[2] = 255
						player_color[3] = 255
						player_color[4] = 255
					else
						content["team_member_icon_" .. i] = ""
						player_color[2] = 80
						player_color[3] = 80
						player_color[4] = 80
					end
				end

				content.team_counter = Localize("loc_group_finder_group_player_title") .. ": " .. team_counter .. "/" .. total_team_size

				local use_overlay = false
				local status = element.group_request_status_callback and element.group_request_status_callback()

				if not status then
					use_overlay = false
				elseif status == "sent" then
					content.overlay_text = Localize("loc_group_finder_group_status_request_sent")
					use_overlay = true
				elseif status == "pending" then
					content.overlay_text = Localize("loc_group_finder_group_status_request_pending")
					use_overlay = true
				elseif status == "approved" then
					content.overlay_text = Localize("loc_group_finder_group_status_request_approved")
					use_overlay = true
				elseif status == "declined" then
					content.overlay_text = Localize("loc_group_finder_group_status_request_declined")
					use_overlay = true

					local overlay_text_color = style.overlay_text.text_color

					overlay_text_color[2] = 144
					overlay_text_color[3] = 19
					overlay_text_color[4] = 23
				end

				content.use_overlay = use_overlay
			end
		},
		texture = {
			size = {
				64,
				64
			},
			size_function = function (parent, element, ui_renderer)
				local size = element.size

				return size and {
					size[1],
					size[2]
				} or {
					64,
					64
				}
			end,
			pass_template = {
				{
					style_id = "texture",
					value_id = "texture",
					pass_type = "texture",
					style = {
						color = {
							255,
							255,
							255,
							255
						}
					}
				}
			},
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
				local style = widget.style
				local content = widget.content
				local texture = element.texture

				if texture then
					content.texture = texture
				end

				local texture_size = element.texture_size

				if texture_size then
					style.texture.size = texture_size
				end

				local horizontal_alignment = element.horizontal_alignment

				if horizontal_alignment then
					style.texture.horizontal_alignment = horizontal_alignment
				end

				local vertical_alignment = element.vertical_alignment

				if vertical_alignment then
					style.texture.vertical_alignment = vertical_alignment
				end

				local texture_color = element.color

				if texture_color then
					local color = style.texture.color

					color[1] = texture_color[1]
					color[2] = texture_color[2]
					color[3] = texture_color[3]
					color[4] = texture_color[4]
				end
			end
		},
		header = {
			size_function = function (parent, element, ui_renderer)
				local size = element.size

				return size and {
					size[1],
					size[2]
				} or {
					grid_size[1],
					100
				}
			end,
			size = {
				grid_size[1],
				100
			},
			pass_template = {
				{
					style_id = "text",
					value_id = "text",
					pass_type = "text",
					value = "n/a",
					style = {
						font_type = "proxima_nova_bold",
						font_size = 28,
						text_vertical_alignment = "center",
						text_horizontal_alignment = "center",
						text_color = Color.terminal_text_header(255, true),
						offset = {
							0,
							0,
							3
						}
					}
				}
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
				local text_options = UIFonts.get_font_options_by_style(text_style)
				local height = UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)

				size[2] = height + 0
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				local content = widget.content
				local element = content.element
			end
		},
		body = {
			size_function = function (parent, element, ui_renderer)
				local size = element.size

				return size and {
					size[1],
					size[2]
				} or {
					grid_size[1],
					100
				}
			end,
			size = {
				grid_size[1],
				100
			},
			pass_template = {
				{
					style_id = "text",
					value_id = "text",
					pass_type = "text",
					value = "n/a",
					style = {
						font_type = "proxima_nova_bold",
						font_size = 20,
						text_vertical_alignment = "center",
						text_horizontal_alignment = "left",
						text_color = Color.text_default(255, true),
						offset = {
							0,
							0,
							3
						}
					}
				}
			},
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
				local style = widget.style
				local content = widget.content
				local text = element.text
				local optional_text_color = element.text_color

				if optional_text_color then
					ColorUtilities.color_copy(optional_text_color, style.text.text_color)
				end

				content.element = element
				content.text = text

				local size = content.size
				local text_style = style.text
				local text_options = UIFonts.get_font_options_by_style(text_style)
				local height = UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)

				size[2] = height + 0
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				local content = widget.content
				local element = content.element
			end
		},
		body_centered = {
			size_function = function (parent, element, ui_renderer)
				local size = element.size

				return size and {
					size[1],
					size[2]
				} or {
					grid_size[1],
					100
				}
			end,
			size = {
				grid_size[1],
				100
			},
			pass_template = {
				{
					style_id = "text",
					value_id = "text",
					pass_type = "text",
					value = "n/a",
					style = {
						font_type = "proxima_nova_bold",
						font_size = 20,
						text_vertical_alignment = "center",
						text_horizontal_alignment = "center",
						text_color = Color.text_default(255, true),
						offset = {
							0,
							0,
							3
						}
					}
				}
			},
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
				local style = widget.style
				local content = widget.content
				local text = element.text
				local optional_text_color = element.text_color

				if optional_text_color then
					ColorUtilities.color_copy(optional_text_color, style.text.text_color)
				end

				content.element = element
				content.text = text

				local size = content.size
				local text_style = style.text
				local text_options = UIFonts.get_font_options_by_style(text_style)
				local height = UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)

				size[2] = height + 0
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				local content = widget.content
				local element = content.element
			end
		}
	}
end

return generate_blueprints_func
