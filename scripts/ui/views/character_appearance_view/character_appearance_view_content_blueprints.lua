local CharacterAppearanceViewSettings = require("scripts/ui/views/character_appearance_view/character_appearance_view_settings")
local UIResolution = require("scripts/managers/ui/ui_resolution")
local ColorUtilities = require("scripts/utilities/ui/colors")
local CharacterAppearanceViewFontStyle = require("scripts/ui/views/character_appearance_view/character_appearance_view_font_style")
local TextInputPassTemplates = require("scripts/ui/pass_templates/text_input_pass_templates")
local grid_size = CharacterAppearanceViewSettings.grid_size
local grid_width = grid_size[1]
local blueprints = {
	spacing_vertical = {
		size = {
			grid_width,
			20
		}
	},
	name_input = {
		size = {
			400,
			60
		},
		pass_template = TextInputPassTemplates.simple_input_field,
		init = function (parent, widget, initial_name)
			local content = widget.content
			content.input_text = initial_name
			content.max_length = 18
			content.virtual_keyboard_title = Localize("loc_character_create_set_name_virtual_keyboard_title")
			local hotspot = content.hotspot
			hotspot.use_is_focused = true
		end,
		update = function (parent, widget)
			if parent._character_create:name() ~= widget.content.input_text then
				parent:_update_character_name()
			end
		end
	}
}
blueprints.button = {
	size = {
		460,
		60
	},
	pass_template = {
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/hover",
			style = {
				vertical_alignment = "center",
				hdr = true,
				horizontal_alignment = "center",
				color = Color.ui_terminal(255, true),
				offset = {
					0,
					0,
					2
				},
				size_addition = {
					0,
					0
				}
			},
			change_function = function (content, style, _, dt)
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)
				style.color[1] = 255 * math.easeOutCubic(progress)
				local size_addition = 10 * math.easeInCubic(1 - progress)
				local style_size_additon = style.size_addition
				style_size_additon[1] = size_addition * 2
				style.size_addition[2] = size_addition * 2
				local offset = style.offset
				offset[1] = -size_addition
				offset[2] = -size_addition
				style.hdr = progress == 1
			end
		},
		{
			style_id = "background_selected",
			pass_type = "texture",
			value = "content/ui/materials/buttons/background_selected",
			style = {
				color = Color.ui_terminal(255, true),
				offset = {
					0,
					0,
					0
				}
			},
			visibility_function = function (content, style)
				return content.element_selected
			end
		},
		{
			value_id = "text",
			pass_type = "text",
			value = "n/a",
			style = CharacterAppearanceViewFontStyle.button_font_style,
			change_function = function (content, style)
				local default_text_color = style.default_text_color
				local hover_text_color = style.hover_text_color
				local text_color = style.text_color
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

				for i = 2, 4 do
					text_color[i] = (hover_text_color[i] - default_text_color[i]) * progress + default_text_color[i]
				end
			end
		}
	},
	init = function (parent, widget, element, option, grid_index, callback_name)
		local content = widget.content
		content.hotspot.use_is_focused = true
		content.hotspot.pressed_callback = callback(parent, callback_name, widget, option, grid_index)
		content.text = option.text
		content.value_text = Managers.localization:localize("loc_character_create_value_selected")
		content.draw_arrow = element.entries ~= nil
	end
}
blueprints.category_button = {
	size = {
		460,
		65
	},
	pass_template = {
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/hover",
			style = {
				vertical_alignment = "center",
				hdr = true,
				horizontal_alignment = "center",
				color = Color.ui_terminal(255, true),
				offset = {
					0,
					0,
					2
				},
				size_addition = {
					0,
					0
				}
			},
			change_function = function (content, style, _, dt)
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)
				style.color[1] = 255 * math.easeOutCubic(progress)
				local size_addition = 10 * math.easeInCubic(1 - progress)
				local style_size_additon = style.size_addition
				style_size_additon[1] = size_addition * 2
				style.size_addition[2] = size_addition * 2
				local offset = style.offset
				offset[1] = -size_addition
				offset[2] = -size_addition
				style.hdr = progress == 1
			end
		},
		{
			style_id = "background_selected",
			pass_type = "texture",
			value = "content/ui/materials/buttons/background_selected",
			style = {
				color = Color.ui_terminal(255, true),
				offset = {
					0,
					0,
					0
				}
			},
			visibility_function = function (content, style)
				return content.element_selected
			end
		},
		{
			style_id = "arrow_selected",
			pass_type = "texture",
			value = "content/ui/materials/buttons/arrow_01",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				color = Color.ui_terminal(255, true),
				offset = {
					-20,
					0,
					0
				},
				size = {
					16,
					20
				}
			},
			visibility_function = function (content, style)
				return content.element_selected
			end
		},
		{
			value_id = "icon",
			pass_type = "texture",
			value = "",
			style_id = "icon",
			style = {
				vertical_alignment = "center",
				size = {
					40,
					40
				},
				default_color = Color.ui_brown_light(255, true),
				color = Color.ui_brown_light(255, true),
				hover_color = Color.ui_brown_super_light(255, true),
				offset = {
					15,
					0,
					0
				}
			},
			visibility_function = function (content, style)
				return content.icon
			end,
			change_function = function (content, style)
				local default_color = style.default_color
				local hover_color = style.hover_color
				local color = style.color
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

				for i = 2, 4 do
					color[i] = (hover_color[i] - default_color[i]) * progress + default_color[i]
				end
			end
		},
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			value = "n/a",
			style = CharacterAppearanceViewFontStyle.category_button_font_style,
			change_function = function (content, style)
				local default_text_color = style.default_text_color
				local hover_text_color = style.hover_text_color
				local text_color = style.text_color
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

				for i = 2, 4 do
					text_color[i] = (hover_text_color[i] - default_text_color[i]) * progress + default_text_color[i]
				end
			end
		},
		{
			pass_type = "rect",
			style = {
				color = Color.ui_hud_red_light(255, true),
				offset = {
					-5,
					0,
					1
				},
				size = {
					5,
					65
				}
			},
			visibility_function = function (content, style)
				return content.show_warning
			end
		}
	},
	init = function (parent, widget, element, option, grid_index, callback_name)
		local content = widget.content
		local style = widget.style
		content.hotspot.use_is_focused = true
		content.hotspot.pressed_callback = callback(parent, callback_name, widget, option, grid_index)
		content.text = option.text
		content.value_text = Managers.localization:localize("loc_character_create_value_selected")
		content.draw_arrow = option.options ~= nil

		if option.icon then
			content.icon = option.icon
			style.text.offset[1] = 70
		end
	end
}
blueprints.slot_icon = {
	size = CharacterAppearanceViewSettings.slot_icon_size,
	pass_template = {
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			value = "content/ui/materials/base/ui_portrait_base",
			style_id = "texture",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					2
				},
				size = CharacterAppearanceViewSettings.slot_icon_size,
				material_values = {
					use_placeholder_texture = 1,
					rows = 1,
					columns = 1,
					grid_index = 1
				},
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/hover",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				hdr = true,
				color = Color.ui_terminal(255, true),
				offset = {
					0,
					0,
					1
				},
				size = {
					CharacterAppearanceViewSettings.slot_icon_size[1] + 15,
					CharacterAppearanceViewSettings.slot_icon_size[2] + 15
				}
			},
			change_function = function (content, style, _, dt)
				local hotspot = content.hotspot
				local anim_progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)
				style.color[1] = anim_progress * 255
				style.hdr = anim_progress == 1
			end
		},
		{
			value = "content/ui/materials/frames/line_light",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					3
				},
				color = Color.black(255, true),
				size = {
					CharacterAppearanceViewSettings.slot_icon_size[1] + 2,
					CharacterAppearanceViewSettings.slot_icon_size[2] + 2
				}
			},
			visibility_function = function (content, style)
				return not content.element_selected
			end
		},
		{
			value = "content/ui/materials/frames/line_light",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					3
				},
				color = Color.ui_terminal(255, true),
				size = {
					CharacterAppearanceViewSettings.slot_icon_size[1] + 2,
					CharacterAppearanceViewSettings.slot_icon_size[2] + 2
				}
			},
			visibility_function = function (content, style)
				return content.element_selected
			end
		},
		{
			value_id = "marker",
			style_id = "marker",
			pass_type = "text",
			value = "",
			style = CharacterAppearanceViewFontStyle.marker_icon_font_style,
			visibility_function = function (content, style)
				return content.element_selected
			end
		},
		{
			style_id = "choice_icon",
			value_id = "choice_icon",
			pass_type = "texture",
			value = "content/ui/materials/base/ui_default_base",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				offset = {
					5,
					-5,
					3
				},
				color = Color.ui_terminal(255, true),
				size = {
					16,
					16
				}
			},
			visibility_function = function (content)
				return content.use_choice_icon
			end
		}
	},
	init = function (parent, widget, element, option, grid_index, callback_name)
		local content = widget.content
		content.hotspot.use_is_focused = true
		content.hotspot.pressed_callback = callback(parent, callback_name, widget, option, grid_index)
	end
}
blueprints.icon = {
	size = {
		90,
		90
	},
	pass_template = {
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			style_id = "rect",
			pass_type = "rect",
			style = {
				color = {
					230,
					18,
					19,
					21
				},
				offset = {
					0,
					0,
					1
				}
			}
		},
		{
			style_id = "icon",
			value_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/icons/appearances/container",
			style = {
				offset = {
					0,
					0,
					2
				}
			},
			visibility_function = function (content, style)
				return content.icon_texture
			end
		},
		{
			value_id = "label",
			style_id = "label",
			pass_type = "text",
			value = "missing icon",
			style = {
				offset = {
					0,
					0,
					2
				}
			},
			visibility_function = function (content, style)
				return not content.icon_texture
			end
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/hover",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				hdr = true,
				color = Color.ui_terminal(255, true),
				offset = {
					0,
					0,
					2
				},
				size = {
					105,
					105
				}
			},
			change_function = function (content, style, _, dt)
				local hotspot = content.hotspot
				local anim_progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)
				style.color[1] = anim_progress * 255
				style.hdr = anim_progress == 1
			end
		},
		{
			value = "content/ui/materials/frames/line_light",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					3
				},
				color = Color.black(255, true),
				size = {
					92,
					92
				}
			},
			visibility_function = function (content, style)
				return not content.element_selected
			end
		},
		{
			value = "content/ui/materials/frames/line_light",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					3
				},
				color = Color.ui_terminal(255, true),
				size = {
					92,
					92
				}
			},
			visibility_function = function (content, style)
				return content.element_selected
			end
		},
		{
			value_id = "marker",
			style_id = "marker",
			pass_type = "text",
			value = "",
			style = CharacterAppearanceViewFontStyle.marker_icon_font_style,
			visibility_function = function (content, style)
				return content.element_selected
			end
		},
		{
			style_id = "choice_icon",
			value_id = "choice_icon",
			pass_type = "texture",
			value = "content/ui/materials/base/ui_default_base",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				offset = {
					5,
					-5,
					3
				},
				color = Color.ui_terminal(255, true),
				size = {
					16,
					16
				}
			},
			visibility_function = function (content)
				return content.use_choice_icon
			end
		}
	},
	init = function (parent, widget, element, option, grid_index, callback_name)
		local content = widget.content
		local style = widget.style
		content.hotspot.use_is_focused = true
		style.icon.material_values = {
			number = content.icon_texture,
			background = content.icon_background
		}
		content.hotspot.pressed_callback = callback(parent, callback_name, widget, option, grid_index)
	end
}
blueprints.icon_small_texture = {
	size = {
		40,
		40
	},
	pass_template = {
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "",
			style = {
				color = Color.white(255, true),
				offset = {
					0,
					0,
					1
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/hover",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				hdr = true,
				color = Color.ui_terminal(255, true),
				offset = {
					0,
					0,
					2
				},
				size = {
					55,
					55
				}
			},
			change_function = function (content, style, _, dt)
				local hotspot = content.hotspot
				local anim_progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)
				style.color[1] = anim_progress * 255
				style.hdr = anim_progress == 1
			end
		},
		{
			value = "content/ui/materials/frames/line_light",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					3
				},
				color = Color.ui_terminal(255, true),
				size = {
					40,
					40
				}
			},
			visibility_function = function (content, style)
				return content.element_selected
			end
		},
		{
			value_id = "marker",
			style_id = "marker",
			pass_type = "text",
			value = "",
			style = CharacterAppearanceViewFontStyle.marker_font_style,
			visibility_function = function (content, style)
				return content.element_selected
			end
		},
		{
			style_id = "choice_icon",
			value_id = "choice_icon",
			pass_type = "texture",
			value = "content/ui/materials/base/ui_default_base",
			style = {
				vertical_alignment = "left",
				horizontal_alignment = "bottom",
				offset = {
					5,
					-5,
					3
				},
				color = Color.ui_terminal(255, true),
				size = {
					16,
					16
				}
			},
			visibility_function = function (content)
				return content.use_choice_icon
			end
		}
	},
	init = function (parent, widget, element, option, grid_index, callback_name)
		local content = widget.content
		local style = widget.style
		content.hotspot.use_is_focused = true
		content.hotspot.pressed_callback = callback(parent, callback_name, widget, option, grid_index)
		content.texture = element.texture
		style.texture.color = option.color
	end
}
blueprints.icon_small_texture_hsv = {
	size = {
		40,
		40
	},
	pass_template = {
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "",
			style = {
				material_values = {
					hsv_skin = {
						0,
						0,
						0
					}
				},
				color = Color.white(255, true),
				offset = {
					0,
					0,
					1
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/hover",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				hdr = true,
				color = Color.ui_terminal(255, true),
				offset = {
					0,
					0,
					2
				},
				size = {
					55,
					55
				}
			},
			change_function = function (content, style, _, dt)
				local hotspot = content.hotspot
				local anim_progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)
				style.color[1] = anim_progress * 255
				style.hdr = anim_progress == 1
			end
		},
		{
			value = "content/ui/materials/frames/line_light",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					3
				},
				color = Color.ui_terminal(255, true),
				size = {
					40,
					40
				}
			},
			visibility_function = function (content, style)
				return content.element_selected
			end
		},
		{
			value_id = "marker",
			style_id = "marker",
			pass_type = "text",
			value = "",
			style = CharacterAppearanceViewFontStyle.marker_font_style,
			visibility_function = function (content, style)
				return content.element_selected
			end
		},
		{
			style_id = "choice_icon",
			value_id = "choice_icon",
			pass_type = "texture",
			value = "content/ui/materials/base/ui_default_base",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				offset = {
					5,
					-5,
					3
				},
				color = Color.ui_terminal(255, true),
				size = {
					16,
					16
				}
			},
			visibility_function = function (content)
				return content.use_choice_icon
			end
		}
	},
	init = function (parent, widget, element, option, grid_index, callback_name)
		local content = widget.content
		local style = widget.style
		content.hotspot.use_is_focused = true
		content.hotspot.pressed_callback = callback(parent, callback_name, widget, option, grid_index)
		content.texture = element.texture
		style.texture.material_values.hsv_skin = option.color
	end
}
blueprints.vertical_slider = {
	size = {
		140,
		420
	},
	pass_template = {
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			pass_type = "hotspot",
			content_id = "hotspot_handle"
		},
		{
			value = "Tall",
			pass_type = "text",
			value_id = "value_text_top",
			style = CharacterAppearanceViewFontStyle.slider_top_font_style
		},
		{
			value = "Short",
			pass_type = "text",
			value_id = "value_text_bottom",
			style = CharacterAppearanceViewFontStyle.slider_bottom_font_style
		},
		{
			value = "content/ui/materials/buttons/background_selected",
			style_id = "background_selected",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.ui_terminal(255, true),
				offset = {
					0,
					0,
					0
				},
				size = {
					20,
					300
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "frame_highlight",
			value = "content/ui/materials/buttons/background_selected_edge",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					2
				},
				size = {
					6,
					300
				},
				disabled_color = Color.ui_grey_light(255, true),
				default_color = Color.ui_brown_light(255, true),
				hover_color = Color.ui_terminal(255, true)
			},
			change_function = function (content, style)
				local default_color = style.default_color
				local hover_color = style.hover_color
				local color = style.color
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

				ColorUtilities.color_lerp(default_color, hover_color, progress, color)

				style.hdr = progress == 1
			end
		},
		{
			value = "content/ui/materials/buttons/background_selected_edge",
			style_id = "frame_highlight_edge_top",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.ui_terminal(255, true),
				offset = {
					0,
					-150,
					2
				},
				size = {
					20,
					3
				}
			}
		},
		{
			value = "content/ui/materials/buttons/background_selected_edge",
			style_id = "frame_highlight_edge_bottom",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.ui_terminal(255, true),
				offset = {
					0,
					150,
					2
				},
				size = {
					20,
					3
				}
			}
		},
		{
			value = "content/ui/materials/buttons/slider_handle_line",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					7
				},
				size = {
					38,
					38
				},
				disabled_color = Color.ui_grey_light(255, true),
				default_color = Color.ui_brown_light(255, true),
				hover_color = Color.ui_terminal(255, true)
			},
			change_function = function (content, style)
				local position_diff = 150
				local value = content.slider_value
				style.offset[2] = value * 300 - position_diff
				local default_color = style.default_color
				local hover_color = style.hover_color
				local color = style.color
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

				ColorUtilities.color_lerp(default_color, hover_color, progress, color)

				style.hdr = progress == 1
			end
		},
		{
			value = "content/ui/materials/buttons/slider_handle_fill",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					6
				},
				size = {
					38,
					38
				},
				color = Color.black(255, true)
			},
			change_function = function (content, style)
				local position_diff = 150
				local value = content.slider_value
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)
				style.offset[2] = value * 300 - position_diff
				style.hdr = progress == 1
			end
		},
		{
			value = "content/ui/materials/buttons/slider_handle_highlight",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				hdr = true,
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					9
				},
				size = {
					38,
					38
				},
				color = Color.ui_terminal(255, true)
			},
			change_function = function (content, style)
				local position_diff = 150
				local value = content.slider_value
				local hotspot = content.hotspot
				style.offset[2] = value * 300 - position_diff
				local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)
				style.color[1] = 255 * math.easeOutCubic(progress)
				local new_size = math.lerp(78, 58, math.easeInCubic(progress))
				local size = style.size
				size[1] = new_size
				size[2] = new_size
			end
		},
		{
			pass_type = "logic",
			value = function (pass, renderer, style, content, position, size)
				local hotspot = content.hotspot_handle
				local on_pressed = hotspot.on_pressed
				local input_service = renderer.input_service
				local left_hold = input_service and input_service:get("left_hold")
				local up_axis = input_service and input_service:get("navigate_up_continuous")
				local down_axis = input_service and input_service:get("navigate_down_continuous")

				if on_pressed then
					content.drag_active = true
				end

				if not left_hold then
					content.drag_active = nil
				end

				if not content.element_selected then
					content.drag_active = false
				end

				if up_axis and content.element_selected then
					content.drag_active = true
				elseif down_axis and content.element_selected then
					content.drag_active = true
				elseif not content.drag_active then
					return
				end

				local base_cursor = input_service:get("cursor")
				local slider_value = content.slider_value
				local scroll_amount = 0.01

				if up_axis then
					slider_value = math.clamp(slider_value - scroll_amount, 0, 1)
				elseif down_axis then
					slider_value = math.clamp(slider_value + scroll_amount, 0, 1)
				else
					local cursor = UIResolution.inverse_scale_vector(base_cursor, renderer.inverse_scale)
					local input_coordinate = cursor[2] - (position[2] + 60)
					input_coordinate = math.clamp(input_coordinate, 0, 300)
					slider_value = input_coordinate / 300
				end

				if slider_value ~= content.slider_value then
					content.slider_value = slider_value
					local inverted_value = 1 - slider_value

					content.entry.on_value_updated(inverted_value)
				end
			end
		}
	},
	init = function (parent, widget, element, option, grid_index, callback_name)
		local content = widget.content
		content.hotspot.use_is_focused = true
		local height_range = parent._character_create:get_height_values_range()
		local min_height = height_range.min
		local max_height = height_range.max
		local value = parent._character_create:height()
		content.slider_value = 1 - math.ilerp(min_height, max_height, value)
		content.hotspot.pressed_callback = callback(parent, callback_name, widget, option, grid_index)
	end,
	reset = function (parent, widget)
		local content = widget.content
		local height_range = parent._character_create:get_height_values_range()
		local min_height = height_range.min
		local max_height = height_range.max
		local value = parent._character_create:height()
		content.slider_value = 1 - math.ilerp(min_height, max_height, value)
	end
}
blueprints.personality_button = {
	size = {
		460,
		65
	},
	pass_template = {
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			pass_type = "hotspot",
			content_id = "voice_hotspot",
			content = {
				hover_type = "circle"
			},
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					40,
					40
				},
				offset = {
					-20,
					0,
					1
				}
			}
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/generic/voice",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					-20,
					0,
					1
				},
				hover_color = Color.white(255, true),
				default_color = Color.ui_terminal(255, true),
				size = {
					40,
					40
				}
			},
			visibility_function = function (content, style)
				return not content.audio_playing
			end,
			change_function = function (content, style, _, dt)
				local default_color = style.default_color
				local hover_color = style.hover_color
				local color = style.color
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

				for i = 2, 4 do
					color[i] = (hover_color[i] - color[i]) * progress + default_color[i]
				end
			end
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/bars/plain_vertical_rounded",
			style_id = "pulse_1",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					-12,
					0,
					1
				},
				hover_color = Color.white(255, true),
				default_color = Color.ui_terminal(255, true),
				size = {
					6,
					40
				}
			},
			visibility_function = function (content, style)
				return content.audio_playing
			end,
			change_function = function (content, style, _, dt)
				local default_color = style.default_color
				local hover_color = style.hover_color
				local color = style.color
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

				for i = 2, 4 do
					color[i] = (hover_color[i] - color[i]) * progress + default_color[i]
				end
			end
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/bars/plain_vertical_rounded",
			style_id = "pulse_2",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					-22,
					0,
					1
				},
				hover_color = Color.white(255, true),
				default_color = Color.ui_terminal(255, true),
				size = {
					6,
					40
				}
			},
			visibility_function = function (content, style)
				return content.audio_playing
			end,
			change_function = function (content, style, _, dt)
				local default_color = style.default_color
				local hover_color = style.hover_color
				local color = style.color
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

				for i = 2, 4 do
					color[i] = (hover_color[i] - color[i]) * progress + default_color[i]
				end
			end
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/bars/plain_vertical_rounded",
			style_id = "pulse_3",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					-32,
					0,
					1
				},
				hover_color = Color.white(255, true),
				default_color = Color.ui_terminal(255, true),
				size = {
					6,
					40
				}
			},
			visibility_function = function (content, style)
				return content.audio_playing
			end,
			change_function = function (content, style, _, dt)
				local default_color = style.default_color
				local hover_color = style.hover_color
				local color = style.color
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

				for i = 2, 4 do
					color[i] = (hover_color[i] - color[i]) * progress + default_color[i]
				end
			end
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/bars/plain_vertical_rounded",
			style_id = "pulse_4",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					-42,
					0,
					1
				},
				hover_color = Color.white(255, true),
				default_color = Color.ui_terminal(255, true),
				size = {
					6,
					40
				}
			},
			visibility_function = function (content, style)
				return content.audio_playing
			end,
			change_function = function (content, style, _, dt)
				local default_color = style.default_color
				local hover_color = style.hover_color
				local color = style.color
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

				for i = 2, 4 do
					color[i] = (hover_color[i] - color[i]) * progress + default_color[i]
				end
			end
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/bars/plain_vertical_rounded",
			style_id = "pulse_5",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					-52,
					0,
					1
				},
				hover_color = Color.white(255, true),
				default_color = Color.ui_terminal(255, true),
				size = {
					6,
					40
				}
			},
			visibility_function = function (content, style)
				return content.audio_playing
			end,
			change_function = function (content, style, _, dt)
				local default_color = style.default_color
				local hover_color = style.hover_color
				local color = style.color
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

				for i = 2, 4 do
					color[i] = (hover_color[i] - color[i]) * progress + default_color[i]
				end
			end
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/bars/plain_vertical_rounded",
			style_id = "pulse_6",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					-62,
					0,
					1
				},
				hover_color = Color.white(255, true),
				default_color = Color.ui_terminal(255, true),
				size = {
					6,
					40
				}
			},
			visibility_function = function (content, style)
				return content.audio_playing
			end,
			change_function = function (content, style, _, dt)
				local default_color = style.default_color
				local hover_color = style.hover_color
				local color = style.color
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

				for i = 2, 4 do
					color[i] = (hover_color[i] - color[i]) * progress + default_color[i]
				end
			end
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/hover",
			style = {
				vertical_alignment = "center",
				hdr = true,
				horizontal_alignment = "center",
				color = Color.ui_terminal(255, true),
				offset = {
					0,
					0,
					2
				},
				size_addition = {
					0,
					0
				}
			},
			change_function = function (content, style, _, dt)
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)
				style.color[1] = 255 * math.easeOutCubic(progress)
				local size_addition = 10 * math.easeInCubic(1 - progress)
				local style_size_additon = style.size_addition
				style_size_additon[1] = size_addition * 2
				style.size_addition[2] = size_addition * 2
				local offset = style.offset
				offset[1] = -size_addition
				offset[2] = -size_addition
				style.hdr = progress == 1
			end
		},
		{
			style_id = "background_selected",
			pass_type = "texture",
			value = "content/ui/materials/buttons/background_selected",
			style = {
				color = Color.ui_terminal(255, true),
				offset = {
					0,
					0,
					0
				}
			},
			visibility_function = function (content, style)
				return content.element_selected
			end
		},
		{
			value_id = "text",
			pass_type = "text",
			value = "n/a",
			style = CharacterAppearanceViewFontStyle.button_font_style,
			change_function = function (content, style)
				local default_text_color = style.default_text_color
				local hover_text_color = style.hover_text_color
				local text_color = style.text_color
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

				for i = 2, 4 do
					text_color[i] = (hover_text_color[i] - default_text_color[i]) * progress + default_text_color[i]
				end
			end
		}
	},
	init = function (parent, widget, element, option, grid_index, callback_name)
		local content = widget.content
		content.hotspot.use_is_focused = true
		content.hotspot.pressed_callback = callback(parent, callback_name, widget, option, grid_index)
		content.voice_hotspot.pressed_callback = callback(option, "on_voice_pressed_function", widget)
		content.text = option.text
		content.value_text = Managers.localization:localize("loc_character_create_value_selected")
		content.draw_arrow = element.entries ~= nil
	end
}
blueprints.backstory_choice = {
	grid = "backstory_choices_grid",
	scenegraph = "backstory_choices_pivot",
	grid_direction = "right",
	size = {
		280,
		480
	},
	pass_template = {
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			style_id = "title",
			value_id = "title",
			pass_type = "text",
			value = "",
			style = CharacterAppearanceViewFontStyle.header_choice_text_style
		},
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				color = {
					255,
					255,
					255,
					255
				},
				size = {
					280,
					400
				},
				offset = {
					0,
					60,
					1
				}
			}
		},
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			value = "",
			style = CharacterAppearanceViewFontStyle.effect_text_style
		}
	}
}
blueprints.reward_cosmetic = {
	size = {
		430,
		60
	},
	pass_template = {
		{
			style_id = "icon",
			value_id = "icon",
			pass_type = "texture",
			value = "",
			style = {
				color = Color.ui_terminal(255, true),
				offset = {
					10,
					10,
					1
				},
				size = {
					40,
					40
				}
			}
		},
		{
			style_id = "frame",
			value_id = "frame",
			pass_type = "texture",
			value = "content/ui/materials/base/ui_default_base",
			style = {
				color = Color.white(255, true),
				offset = {
					0,
					0,
					0
				},
				size = {
					60,
					60
				},
				material_values = {
					texture_map = "content/ui/textures/icons/achievement_rewards/frames/rarity_01"
				}
			}
		},
		{
			style_id = "title",
			value_id = "title",
			pass_type = "text",
			value = "",
			style = CharacterAppearanceViewFontStyle.reward_description_style
		}
	},
	init = function (parent, widget, entry)
		widget.content.icon = entry.icon
		widget.content.title = Localize(entry.text)
	end
}
blueprints.reward_text = {
	size = {
		430,
		60
	},
	pass_template = {
		{
			style_id = "title",
			value_id = "title",
			pass_type = "text",
			value = "",
			style = CharacterAppearanceViewFontStyle.reward_description_no_icon_style
		}
	},
	init = function (parent, widget, entry)
		widget.content.title = Localize(entry.text)
	end
}
local pulse_animations = {
	init = function (widget)
		for i = 1, 6 do
			local pass = widget.style["pulse_" .. i]
			pass.min_value = math.random(5, 15)
			pass.max_value = math.random(20, 50)
			pass.speed = math.random(5, 20)
		end
	end
}

pulse_animations.update = function (dt, current_progress, widget)
	local progress = current_progress + dt

	for i = 1, 6 do
		local pass = widget.style["pulse_" .. i]
		local min = pass.min_value
		local max = pass.max_value
		local speed = pass.speed
		local wave_value = math.sin(progress * speed)
		local current_value = min + wave_value * wave_value * (max - min)
		pass.size[2] = current_value
	end

	return progress
end

return {
	blueprints = blueprints,
	pulse_animations = pulse_animations
}
