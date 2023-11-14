local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local CharacterAppearanceViewFontStyle = require("scripts/ui/views/character_appearance_view/character_appearance_view_font_style")
local CharacterAppearanceViewSettings = require("scripts/ui/views/character_appearance_view/character_appearance_view_settings")
local ColorUtilities = require("scripts/utilities/ui/colors")
local TextInputPassTemplates = require("scripts/ui/pass_templates/text_input_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIResolution = require("scripts/managers/ui/ui_resolution")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local grid_size = CharacterAppearanceViewSettings.grid_size
local grid_width = grid_size[1]

local function terminal_button_change_function(content, style)
	local is_selected = content.element_selected
	local color = style.color
	local default_color = style.default_color
	local selected_color = style.selected_color
	style.color[1] = is_selected and selected_color[1] or default_color[1]
	style.color[2] = is_selected and selected_color[2] or default_color[2]
	style.color[3] = is_selected and selected_color[3] or default_color[3]
	style.color[4] = is_selected and selected_color[4] or default_color[4]
end

local function item_change_function(content, style)
	local hotspot = content.hotspot
	local is_selected = content.element_selected
	local is_hover = hotspot.is_hover or hotspot.is_focused
	local default_color = style.default_color
	local selected_color = style.selected_color
	local hover_color = style.hover_color
	local color = nil

	if is_selected then
		color = selected_color
	elseif is_hover then
		color = hover_color
	else
		color = default_color
	end

	style.color = color
end

local function list_button_focused_visibility_function(content, style)
	local hotspot = content.hotspot

	return hotspot.is_hover
end

local function list_button_all_visibility_function(content, style)
	local hotspot = content.hotspot

	return hotspot.is_hover or hotspot.is_selected or hotspot.is_focused or content.element_selected
end

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
		pass_template = TextInputPassTemplates.terminal_input_field,
		init = function (parent, widget, initial_name)
			local content = widget.content
			content.input_text = initial_name
			content.max_length = 18
			content.virtual_keyboard_title = Localize("loc_character_create_set_name_virtual_keyboard_title")
			local hotspot = content.hotspot
			hotspot.use_is_focused = true
		end,
		update = function (parent, widget)
			local content = widget.content
			local name = type(widget.content.input_text) == "string" and widget.content.input_text ~= "" and widget.content.input_text or widget.content.selected_text or ""

			if parent._character_create:name() ~= name then
				parent:_update_character_custom_name()
			end

			if content.selected_text and not content.is_writing then
				content.selected_text = nil
				content._selection_start = nil
				content._selection_end = nil
			end
		end
	},
	button = {
		size = {
			450,
			60
		},
		pass_template = ButtonPassTemplates.terminal_list_button,
		init = function (parent, widget, element, option, grid_index, callback_name)
			local content = widget.content
			content.hotspot.use_is_focused = true
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, option, grid_index)
			content.text = option.text
			content.value_text = Managers.localization:localize("loc_character_create_value_selected")
			content.draw_arrow = element.entries ~= nil
			local active_page_number = parent._active_page_number
			local active_page = parent._pages[active_page_number]

			if active_page.name == "home_planet" then
				content.hotspot.on_select_sound = nil
			end
		end
	},
	divider = {
		size = {
			450,
			12
		},
		pass_template = ButtonPassTemplates.terminal_list_divider
	},
	category_button = {
		size = {
			450,
			60
		},
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot",
				content = {
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
				pass_type = "texture",
				style_id = "background_gradient",
				value = "content/ui/materials/masks/gradient_horizontal_sides_dynamic_02",
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
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
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
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
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
				value = "content/ui/materials/dividers/divider_line_01",
				pass_type = "texture",
				style = {
					vertical_alignment = "top",
					horizontal_alignment = "center",
					color = Color.terminal_frame(255, true),
					size = {
						nil,
						2
					},
					offset = {
						0,
						0,
						0
					}
				}
			},
			{
				value = "content/ui/materials/dividers/divider_line_01",
				pass_type = "texture",
				style = {
					vertical_alignment = "bottom",
					horizontal_alignment = "center",
					color = Color.terminal_frame(255, true),
					size = {
						nil,
						2
					},
					offset = {
						0,
						0,
						1
					}
				}
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
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_text_body(255, true),
					selected_color = Color.terminal_text_header_selected(255, true),
					hover_color = Color.terminal_text_header(255, true),
					offset = {
						15,
						0,
						3
					}
				},
				visibility_function = function (content, style)
					return content.icon
				end,
				change_function = ButtonPassTemplates.terminal_list_button_text_change_function
			},
			{
				value_id = "text",
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				style = CharacterAppearanceViewFontStyle.category_button_font_style,
				change_function = ButtonPassTemplates.terminal_list_button_text_change_function
			},
			{
				pass_type = "rect",
				style = {
					color = Color.ui_hud_red_light(255, true),
					offset = {
						0,
						2,
						3
					},
					size = {
						5
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
	},
	slot_item_button = {
		size = {
			460,
			80
		},
		pass_template = {
			{
				pass_type = "hotspot",
				content_id = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.character_appearance_change
				}
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
				pass_type = "texture",
				style_id = "button_gradient",
				value = "content/ui/materials/gradients/gradient_diagonal_down_right",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					default_color = Color.black(nil, true),
					hover_color = Color.terminal_background_gradient(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					offset = {
						0,
						0,
						1
					}
				},
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_change_function(content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style)
				end,
				visibility_function = function (content, style)
					return content.hotspot.is_hover or content.hotspot.is_focused
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
				style = CharacterAppearanceViewFontStyle.slot_button_name_font_style,
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
				value_id = "description",
				pass_type = "text",
				value = "",
				style = CharacterAppearanceViewFontStyle.slot_button_description_font_style,
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
			content.text = option.value.display_name and option.value.display_name
			content.description = option.value.description and option.value.description
		end
	},
	slot_icon = {
		size = CharacterAppearanceViewSettings.slot_icon_size,
		pass_template = {
			{
				pass_type = "hotspot",
				content_id = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.character_appearance_change
				}
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
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					hover_layer = 7,
					horizontal_alignment = "center",
					selected_layer = 8,
					scale_to_material = true,
					vertical_alignment = "center",
					max_alpha = 255,
					color = Color.terminal_frame(nil, true),
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					hover_color = Color.terminal_frame_hover(nil, true),
					offset = {
						0,
						0,
						6
					}
				},
				change_function = ButtonPassTemplates.terminal_button_change_function
			},
			{
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					hover_layer = 10,
					horizontal_alignment = "center",
					selected_layer = 11,
					scale_to_material = true,
					vertical_alignment = "center",
					max_alpha = 255,
					color = Color.terminal_corner(nil, true),
					default_color = Color.terminal_corner(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true),
					hover_color = Color.terminal_corner_hover(nil, true),
					offset = {
						0,
						0,
						9
					}
				},
				change_function = ButtonPassTemplates.terminal_button_change_function
			},
			{
				pass_type = "texture",
				style_id = "button_gradient",
				value = "content/ui/materials/gradients/gradient_diagonal_down_right",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					default_color = Color.black(nil, true),
					hover_color = Color.terminal_background_gradient(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					offset = {
						0,
						0,
						10
					}
				},
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_change_function(content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style)
				end,
				visibility_function = function (content, style)
					return content.hotspot.is_hover or content.hotspot.is_focused
				end
			},
			{
				style_id = "equipped_icon",
				pass_type = "texture",
				value = "content/ui/materials/icons/items/equipped_label",
				style = {
					vertical_alignment = "top",
					horizontal_alignment = "right",
					size = {
						32,
						32
					},
					offset = {
						0,
						0,
						8
					}
				},
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
	},
	icon = {
		size = {
			90,
			90
		},
		pass_template = {
			{
				pass_type = "hotspot",
				content_id = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.character_appearance_change
				}
			},
			{
				style_id = "rect",
				pass_type = "rect",
				style = {
					color = Color.terminal_grid_background_icon(30, true),
					offset = {
						0,
						0,
						1
					}
				}
			},
			{
				value_id = "icon",
				pass_type = "texture",
				value = "content/ui/materials/base/ui_default_base",
				style_id = "icon_background",
				style = {
					offset = {
						0,
						0,
						2
					},
					color = Color.terminal_frame(nil, true),
					default_color = Color.terminal_frame(nil, true),
					hover_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true)
				},
				change_function = item_change_function,
				visibility_function = function (content, style)
					return style.material_values.texture_map
				end
			},
			{
				pass_type = "texture",
				style_id = "button_gradient",
				value = "content/ui/materials/gradients/gradient_diagonal_down_right",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					default_color = Color.black(nil, true),
					hover_color = Color.terminal_background_gradient(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					offset = {
						0,
						0,
						4
					}
				},
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_change_function(content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style)
				end,
				visibility_function = function (content, style)
					return content.hotspot.is_hover or content.hotspot.is_focused
				end
			},
			{
				value_id = "icon",
				pass_type = "texture",
				value = "content/ui/materials/base/ui_default_base",
				style_id = "icon",
				style = {
					offset = {
						0,
						0,
						3
					},
					color = Color.terminal_text_body(nil, true),
					default_color = Color.terminal_text_body(nil, true),
					selected_color = Color.terminal_icon_selected(nil, true)
				},
				change_function = item_change_function,
				visibility_function = function (content, style)
					return style.material_values.texture_map
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
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					hover_layer = 7,
					horizontal_alignment = "center",
					selected_layer = 8,
					scale_to_material = true,
					vertical_alignment = "center",
					max_alpha = 255,
					color = Color.terminal_frame(nil, true),
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					hover_color = Color.terminal_frame_hover(nil, true),
					offset = {
						0,
						0,
						6
					}
				},
				change_function = ButtonPassTemplates.terminal_button_change_function
			},
			{
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				max_alpha = 255,
				style = {
					hover_layer = 10,
					horizontal_alignment = "center",
					selected_layer = 11,
					scale_to_material = true,
					vertical_alignment = "center",
					color = Color.terminal_corner(nil, true),
					default_color = Color.terminal_corner(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true),
					hover_color = Color.terminal_corner_hover(nil, true),
					offset = {
						0,
						0,
						9
					}
				},
				change_function = ButtonPassTemplates.terminal_button_change_function
			},
			{
				style_id = "equipped_icon",
				pass_type = "texture",
				value = "content/ui/materials/icons/items/equipped_label",
				style = {
					vertical_alignment = "top",
					horizontal_alignment = "right",
					size = {
						32,
						32
					},
					offset = {
						0,
						0,
						8
					}
				},
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
				texture_map = content.icon_texture
			}
			style.icon_background.material_values = {
				texture_map = content.icon_background
			}
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, option, grid_index)
		end
	},
	icon_small_texture = {
		size = {
			40,
			40
		},
		pass_template = {
			{
				pass_type = "hotspot",
				content_id = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.character_appearance_change
				}
			},
			{
				value_id = "texture",
				style_id = "texture",
				pass_type = "texture",
				value = "",
				style = {
					color = Color.terminal_corner(255, true),
					offset = {
						0,
						0,
						1
					}
				}
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					hover_layer = 7,
					horizontal_alignment = "center",
					selected_layer = 8,
					scale_to_material = true,
					vertical_alignment = "center",
					max_alpha = 255,
					color = Color.terminal_frame(nil, true),
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					hover_color = Color.terminal_frame_hover(nil, true),
					offset = {
						0,
						0,
						6
					}
				},
				change_function = ButtonPassTemplates.terminal_button_change_function
			},
			{
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				max_alpha = 255,
				style = {
					hover_layer = 10,
					horizontal_alignment = "center",
					selected_layer = 11,
					scale_to_material = true,
					vertical_alignment = "center",
					color = Color.terminal_corner(nil, true),
					default_color = Color.terminal_corner(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true),
					hover_color = Color.terminal_corner_hover(nil, true),
					offset = {
						0,
						0,
						9
					}
				},
				change_function = ButtonPassTemplates.terminal_button_change_function
			},
			{
				style_id = "equipped_icon",
				pass_type = "texture",
				value = "content/ui/materials/icons/items/equipped_label",
				style = {
					vertical_alignment = "top",
					horizontal_alignment = "right",
					size = {
						32,
						32
					},
					offset = {
						0,
						0,
						8
					}
				},
				visibility_function = function (content, style)
					return content.element_selected
				end
			},
			{
				pass_type = "texture",
				style_id = "button_gradient",
				value = "content/ui/materials/gradients/gradient_diagonal_down_right",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					default_color = Color.black(nil, true),
					hover_color = Color.terminal_background_gradient(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					offset = {
						0,
						0,
						4
					}
				},
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_change_function(content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style)
				end,
				visibility_function = function (content, style)
					return content.hotspot.is_hover or content.hotspot.is_focused
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
	},
	icon_small_texture_hsv = {
		size = {
			40,
			40
		},
		pass_template = {
			{
				pass_type = "hotspot",
				content_id = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.character_appearance_change
				}
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
					color = Color.terminal_corner(255, true),
					offset = {
						0,
						0,
						1
					}
				}
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					hover_layer = 7,
					horizontal_alignment = "center",
					selected_layer = 8,
					scale_to_material = true,
					vertical_alignment = "center",
					max_alpha = 255,
					color = Color.terminal_frame(nil, true),
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					hover_color = Color.terminal_frame_hover(nil, true),
					offset = {
						0,
						0,
						6
					}
				},
				change_function = ButtonPassTemplates.terminal_button_change_function
			},
			{
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				max_alpha = 255,
				style = {
					hover_layer = 10,
					horizontal_alignment = "center",
					selected_layer = 11,
					scale_to_material = true,
					vertical_alignment = "center",
					color = Color.terminal_corner(nil, true),
					default_color = Color.terminal_corner(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true),
					hover_color = Color.terminal_corner_hover(nil, true),
					offset = {
						0,
						0,
						9
					}
				},
				change_function = ButtonPassTemplates.terminal_button_change_function
			},
			{
				style_id = "equipped_icon",
				pass_type = "texture",
				value = "content/ui/materials/icons/items/equipped_label",
				style = {
					vertical_alignment = "top",
					horizontal_alignment = "right",
					size = {
						32,
						32
					},
					offset = {
						0,
						0,
						8
					}
				},
				visibility_function = function (content, style)
					return content.element_selected
				end
			},
			{
				pass_type = "texture",
				style_id = "button_gradient",
				value = "content/ui/materials/gradients/gradient_diagonal_down_right",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					default_color = Color.black(nil, true),
					hover_color = Color.terminal_background_gradient(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					offset = {
						0,
						0,
						4
					}
				},
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_change_function(content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style)
				end,
				visibility_function = function (content, style)
					return content.hotspot.is_hover or content.hotspot.is_focused
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
	},
	vertical_slider = {
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
				pass_type = "text",
				value_id = "value_text_top",
				style = CharacterAppearanceViewFontStyle.slider_top_font_style,
				value = Localize("loc_character_create_height_max")
			},
			{
				pass_type = "text",
				value_id = "value_text_bottom",
				style = CharacterAppearanceViewFontStyle.slider_bottom_font_style,
				value = Localize("loc_character_create_height_min")
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
						local cursor = IS_XBS and base_cursor or UIResolution.inverse_scale_vector(base_cursor, renderer.inverse_scale)
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
	},
	personality_button = {
		size = {
			450,
			60
		},
		pass_template = {
			{
				pass_type = "hotspot",
				content_id = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.character_appearence_option_pressed
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
				change_function = ButtonPassTemplates.terminal_button_change_function,
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
				change_function = ButtonPassTemplates.terminal_button_change_function,
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
			},
			{
				pass_type = "rect",
				style = {
					color = Color.ui_hud_red_light(255, true),
					offset = {
						0,
						0,
						1
					},
					size = {
						5
					}
				},
				visibility_function = function (content, style)
					return content.show_warning
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
						3
					},
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_text_body(255, true),
					selected_color = Color.terminal_frame_selected(255, true),
					hover_color = Color.terminal_text_header_selected(255, true),
					size = {
						40,
						40
					}
				},
				visibility_function = function (content, style)
					return not content.audio_playing
				end,
				change_function = function (content, style)
					local hotspot = content.hotspot
					local default_color = content.element_selected and style.selected_color or style.default_color
					local hover_color = style.hover_color
					local color = style.color
					local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

					ColorUtilities.color_lerp(default_color, hover_color, progress, color)
				end
			},
			{
				pass_type = "texture",
				style_id = "pulse_1",
				value = "content/ui/materials/bars/plain_vertical_rounded",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					offset = {
						-12,
						0,
						3
					},
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_text_body(255, true),
					selected_color = Color.terminal_frame_selected(255, true),
					hover_color = Color.terminal_text_header_selected(255, true),
					size = {
						6,
						40
					}
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local default_color = content.element_selected and style.selected_color or style.default_color
					local hover_color = style.hover_color
					local color = style.color
					local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

					ColorUtilities.color_lerp(default_color, hover_color, progress, color)
				end,
				visibility_function = function (content, style)
					return content.audio_playing
				end
			},
			{
				pass_type = "texture",
				style_id = "pulse_2",
				value = "content/ui/materials/bars/plain_vertical_rounded",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					offset = {
						-22,
						0,
						3
					},
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_text_body(255, true),
					selected_color = Color.terminal_frame_selected(255, true),
					hover_color = Color.terminal_text_header_selected(255, true),
					size = {
						6,
						40
					}
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local default_color = content.element_selected and style.selected_color or style.default_color
					local hover_color = style.hover_color
					local color = style.color
					local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

					ColorUtilities.color_lerp(default_color, hover_color, progress, color)
				end,
				visibility_function = function (content, style)
					return content.audio_playing
				end
			},
			{
				pass_type = "texture",
				style_id = "pulse_3",
				value = "content/ui/materials/bars/plain_vertical_rounded",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					offset = {
						-32,
						0,
						3
					},
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_text_body(255, true),
					selected_color = Color.terminal_frame_selected(255, true),
					hover_color = Color.terminal_text_header_selected(255, true),
					size = {
						6,
						40
					}
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local default_color = content.element_selected and style.selected_color or style.default_color
					local hover_color = style.hover_color
					local color = style.color
					local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

					ColorUtilities.color_lerp(default_color, hover_color, progress, color)
				end,
				visibility_function = function (content, style)
					return content.audio_playing
				end
			},
			{
				pass_type = "texture",
				style_id = "pulse_4",
				value = "content/ui/materials/bars/plain_vertical_rounded",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					offset = {
						-42,
						0,
						3
					},
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_text_body(255, true),
					selected_color = Color.terminal_frame_selected(255, true),
					hover_color = Color.terminal_text_header_selected(255, true),
					size = {
						6,
						40
					}
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local default_color = content.element_selected and style.selected_color or style.default_color
					local hover_color = style.hover_color
					local color = style.color
					local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

					ColorUtilities.color_lerp(default_color, hover_color, progress, color)
				end,
				visibility_function = function (content, style)
					return content.audio_playing
				end
			},
			{
				pass_type = "texture",
				style_id = "pulse_5",
				value = "content/ui/materials/bars/plain_vertical_rounded",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					offset = {
						-52,
						0,
						3
					},
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_text_body(255, true),
					selected_color = Color.terminal_frame_selected(255, true),
					hover_color = Color.terminal_text_header_selected(255, true),
					size = {
						6,
						40
					}
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local default_color = content.element_selected and style.selected_color or style.default_color
					local hover_color = style.hover_color
					local color = style.color
					local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

					ColorUtilities.color_lerp(default_color, hover_color, progress, color)
				end,
				visibility_function = function (content, style)
					return content.audio_playing
				end
			},
			{
				pass_type = "texture",
				style_id = "pulse_6",
				value = "content/ui/materials/bars/plain_vertical_rounded",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					offset = {
						-62,
						0,
						3
					},
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_text_body(255, true),
					selected_color = Color.terminal_frame_selected(255, true),
					hover_color = Color.terminal_text_header_selected(255, true),
					size = {
						6,
						40
					}
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local default_color = content.element_selected and style.selected_color or style.default_color
					local hover_color = style.hover_color
					local color = style.color
					local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

					ColorUtilities.color_lerp(default_color, hover_color, progress, color)
				end,
				visibility_function = function (content, style)
					return content.audio_playing
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
	},
	backstory_choice = {
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
				content_id = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.character_appearence_option_pressed
				}
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
	},
	reward_cosmetic = {
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
	},
	reward_text = {
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
}
local pulse_animations = {
	init = function (widget)
		for i = 1, 6 do
			local pass = widget.style["pulse_" .. i]
			pass.min_value = math.random(5, 15)
			pass.max_value = math.random(20, 50)
			pass.speed = math.random(5, 20)
		end
	end,
	update = function (dt, current_progress, widget)
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
}

return {
	blueprints = blueprints,
	pulse_animations = pulse_animations
}
