-- chunkname: @scripts/ui/views/character_appearance_view/character_appearance_view_content_blueprints.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local CharacterAppearanceViewFontStyle = require("scripts/ui/views/character_appearance_view/character_appearance_view_font_style")
local CharacterAppearanceViewSettings = require("scripts/ui/views/character_appearance_view/character_appearance_view_settings")
local ColorUtilities = require("scripts/utilities/ui/colors")
local TextInputPassTemplates = require("scripts/ui/pass_templates/text_input_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIResolution = require("scripts/managers/ui/ui_resolution")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local MasterItems = require("scripts/backend/master_items")
local grid_size = CharacterAppearanceViewSettings.grid_size
local grid_width = grid_size[1]

local function on_icon_load(widget, grid_index, rows, columns, render_target)
	local material_values = widget.style.texture.material_values

	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.texture_icon = render_target
end

local function load_appearance_icon(parent, widget, element)
	local profile = table.clone_instance(parent._character_create:profile())

	parent._character_create.set_item_per_slot_preview(parent._character_create, element.slot_name, widget.content.option_value, profile)

	local function cb(grid_index, rows, columns, render_target)
		on_icon_load(widget, grid_index, rows, columns, render_target)
	end

	profile.character_id = math:uuid()

	local render_context = {
		size = {
			128,
			192,
		},
	}
	local icon_load_id = Managers.ui:load_profile_portrait(profile, cb, render_context)

	widget.content.icon_load_id = icon_load_id
	widget.content.icon_profile = profile
end

local function unload_appearance_icon(parent, widget, element)
	local content = widget.content

	if content.icon_load_id then
		Managers.ui:unload_profile_portrait(widget.content.icon_load_id)

		local material_values = widget.style.texture.material_values

		material_values.use_placeholder_texture = 1
		material_values.texture_icon = nil
		material_values.rows = nil
		material_values.columns = nil
		material_values.grid_index = nil
		widget.content.icon_load_id = nil
		widget.content.icon_profile = nil
	end
end

local function item_change_function(content, style)
	local hotspot = content.hotspot
	local is_selected = hotspot.is_selected
	local is_hover = hotspot.is_hover or hotspot.is_focused
	local default_color = style.default_color
	local selected_color = style.selected_color
	local hover_color = style.hover_color
	local color

	if is_selected then
		color = selected_color
	elseif is_hover then
		color = hover_color
	else
		color = default_color
	end

	style.color = color
end

local blueprints = {
	spacing_vertical = {
		size = {
			grid_width,
			20,
		},
	},
	name_input = {
		size = {
			400,
			60,
		},
		pass_template = TextInputPassTemplates.terminal_input_field,
		init = function (parent, widget, element)
			local content = widget.content

			content.element = element

			local initial_name = element and element.initial_name

			content.input_text = initial_name
			content.max_length = element.max_length or 18
			content.error_message = element.error_message
			content.virtual_keyboard_title = Localize("loc_character_create_set_name_virtual_keyboard_title")

			local hotspot = content.hotspot

			hotspot.use_is_focused = true
			content.on_update_function = element.on_update_function
		end,
		update = function (parent, widget)
			local content = widget.content

			if content.on_update_function then
				content.on_update_function(parent, widget)
			end

			if content.selected_text and not content.is_writing then
				content.selected_text = nil
				content._selection_start = nil
				content._selection_end = nil
			end
		end,
	},
	button = {
		size = {
			450,
			60,
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

			content.element = element
		end,
	},
	divider = {
		size = {
			450,
			12,
		},
		pass_template = ButtonPassTemplates.terminal_list_divider,
	},
	category_button = {
		size = {
			450,
			60,
		},
		pass_template = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				style_id = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.default_click,
					on_select_sound = UISoundEvents.default_click,
				},
			},
			{
				pass_type = "texture",
				style_id = "background",
				value = "content/ui/materials/backgrounds/default_square",
				value_id = "background",
				style = {
					max_alpha = 64,
					min_alpha = 24,
					scale_to_material = true,
					color = Color.terminal_background_selected(nil, true),
					size_addition = {
						0,
						-2 * ButtonPassTemplates.terminal_list_divider_height,
					},
					offset = {
						0,
						ButtonPassTemplates.terminal_list_divider_height,
						0,
					},
				},
				change_function = ButtonPassTemplates.terminal_list_button_background_change_function,
				visibility_function = function (content, style)
					return content.hotspot.is_selected
				end,
			},
			{
				pass_type = "texture",
				style_id = "background_gradient",
				value = "content/ui/materials/masks/gradient_horizontal_sides_dynamic_02",
				style = {
					max_alpha = 255,
					min_alpha = 150,
					scale_to_material = true,
					color = Color.terminal_background_gradient(nil, true),
					default_color = Color.terminal_background_gradient(nil, true),
					hover_color = Color.terminal_background_gradient(nil, true),
					selected_color = Color.terminal_background_selected(nil, true),
					size_addition = {
						0,
						-2 * ButtonPassTemplates.terminal_list_divider_height,
					},
					offset = {
						0,
						ButtonPassTemplates.terminal_list_divider_height,
						1,
					},
				},
				change_function = ButtonPassTemplates.terminal_list_button_frame_hover_change_function,
				visibility_function = ButtonPassTemplates.list_button_focused_visibility_function,
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					hover_layer = 7,
					scale_to_material = true,
					selected_layer = 8,
					color = Color.terminal_frame(nil, true),
					default_color = Color.terminal_frame(nil, true),
					hover_color = Color.terminal_frame_hover(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					offset = {
						0,
						0,
						6,
					},
				},
				change_function = ButtonPassTemplates.terminal_list_button_frame_hover_change_function,
				visibility_function = ButtonPassTemplates.list_button_focused_visibility_function,
			},
			{
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					hover_layer = 10,
					scale_to_material = true,
					selected_layer = 11,
					color = Color.terminal_corner(nil, true),
					default_color = Color.terminal_corner(nil, true),
					hover_color = Color.terminal_corner_hover(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true),
					offset = {
						0,
						0,
						9,
					},
				},
				change_function = ButtonPassTemplates.terminal_list_button_frame_hover_change_function,
				visibility_function = ButtonPassTemplates.list_button_focused_visibility_function,
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/dividers/divider_line_01",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "bottom",
					color = Color.terminal_frame(255, true),
					size = {
						nil,
						2,
					},
					offset = {
						0,
						0,
						1,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "icon",
				value = "",
				value_id = "icon",
				style = {
					vertical_alignment = "center",
					size = {
						40,
						40,
					},
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_text_body(255, true),
					selected_color = Color.terminal_text_header_selected(255, true),
					hover_color = Color.terminal_text_header(255, true),
					offset = {
						15,
						0,
						3,
					},
				},
				visibility_function = function (content, style)
					return content.icon
				end,
				change_function = ButtonPassTemplates.terminal_list_button_text_change_function,
			},
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = CharacterAppearanceViewFontStyle.category_button_font_style,
				change_function = ButtonPassTemplates.terminal_list_button_text_change_function,
			},
			{
				pass_type = "rect",
				style = {
					color = Color.ui_hud_red_light(255, true),
					offset = {
						0,
						2,
						3,
					},
					size = {
						5,
					},
				},
				visibility_function = function (content, style)
					return content.show_warning
				end,
			},
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

			content.element = element
		end,
	},
	slot_item_button = {
		size = {
			460,
			80,
		},
		pass_template = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.character_appearance_change,
				},
			},
			{
				pass_type = "texture",
				style_id = "highlight",
				value = "content/ui/materials/frames/hover",
				style = {
					hdr = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = Color.ui_terminal(255, true),
					offset = {
						0,
						0,
						2,
					},
					size_addition = {
						0,
						0,
					},
				},
				change_function = function (content, style, _, dt)
					local hotspot = content.hotspot
					local progress = math.max(hotspot.anim_select_progress, hotspot.anim_hover_progress)

					style.color[1] = 255 * math.easeOutCubic(progress)

					local size_addition = 10 * math.easeInCubic(1 - progress)
					local style_size_additon = style.size_addition

					style_size_additon[1] = size_addition * 2
					style.size_addition[2] = size_addition * 2

					local offset = style.offset

					offset[1] = -size_addition
					offset[2] = -size_addition
					style.hdr = progress == 1
				end,
			},
			{
				pass_type = "texture",
				style_id = "button_gradient",
				value = "content/ui/materials/gradients/gradient_diagonal_down_right",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					default_color = Color.black(nil, true),
					hover_color = Color.terminal_background_gradient(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					offset = {
						0,
						0,
						1,
					},
				},
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_change_function(content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style)
				end,
				visibility_function = function (content, style)
					return content.hotspot.is_hover or content.hotspot.is_focused
				end,
			},
			{
				pass_type = "texture",
				style_id = "background_selected",
				value = "content/ui/materials/buttons/background_selected",
				style = {
					color = Color.ui_terminal(255, true),
					offset = {
						0,
						0,
						0,
					},
				},
				visibility_function = function (content, style)
					return content.hotspot.is_selected
				end,
			},
			{
				pass_type = "text",
				value = "n/a",
				value_id = "text",
				style = CharacterAppearanceViewFontStyle.slot_button_name_font_style,
				change_function = function (content, style)
					local default_text_color = style.default_text_color
					local hover_text_color = style.hover_text_color
					local text_color = style.text_color
					local hotspot = content.hotspot
					local progress = math.max(hotspot.anim_select_progress, hotspot.anim_hover_progress)

					for i = 2, 4 do
						text_color[i] = (hover_text_color[i] - default_text_color[i]) * progress + default_text_color[i]
					end
				end,
			},
			{
				pass_type = "text",
				value = "",
				value_id = "description",
				style = CharacterAppearanceViewFontStyle.slot_button_description_font_style,
				change_function = function (content, style)
					local default_text_color = style.default_text_color
					local hover_text_color = style.hover_text_color
					local text_color = style.text_color
					local hotspot = content.hotspot
					local progress = math.max(hotspot.anim_select_progress, hotspot.anim_hover_progress)

					for i = 2, 4 do
						text_color[i] = (hover_text_color[i] - default_text_color[i]) * progress + default_text_color[i]
					end
				end,
			},
		},
		init = function (parent, widget, element, option, grid_index, callback_name)
			local content = widget.content

			content.hotspot.use_is_focused = true
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, option, grid_index)
			content.text = option.value.display_name and option.value.display_name
			content.description = option.value.description and option.value.description
			content.element = element
		end,
	},
	slot_icon = {
		size = CharacterAppearanceViewSettings.slot_icon_size,
		pass_template = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.character_appearance_change,
				},
			},
			{
				pass_type = "texture",
				style_id = "texture",
				value = "content/ui/materials/base/ui_portrait_base",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					offset = {
						0,
						0,
						2,
					},
					size = CharacterAppearanceViewSettings.slot_icon_size,
					material_values = {
						columns = 1,
						grid_index = 1,
						rows = 1,
						use_placeholder_texture = 1,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					horizontal_alignment = "center",
					hover_layer = 7,
					max_alpha = 255,
					scale_to_material = true,
					selected_layer = 8,
					vertical_alignment = "center",
					color = Color.terminal_frame(nil, true),
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					hover_color = Color.terminal_frame_hover(nil, true),
					offset = {
						0,
						0,
						6,
					},
				},
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
			{
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					horizontal_alignment = "center",
					hover_layer = 10,
					max_alpha = 255,
					scale_to_material = true,
					selected_layer = 11,
					vertical_alignment = "center",
					color = Color.terminal_corner(nil, true),
					default_color = Color.terminal_corner(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true),
					hover_color = Color.terminal_corner_hover(nil, true),
					offset = {
						0,
						0,
						9,
					},
				},
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
			{
				pass_type = "texture",
				style_id = "button_gradient",
				value = "content/ui/materials/gradients/gradient_diagonal_down_right",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					default_color = Color.black(nil, true),
					hover_color = Color.terminal_background_gradient(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					offset = {
						0,
						0,
						10,
					},
				},
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_change_function(content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style)
				end,
				visibility_function = function (content, style)
					return content.hotspot.is_hover or content.hotspot.is_focused
				end,
			},
			{
				pass_type = "texture",
				style_id = "equipped_icon",
				value = "content/ui/materials/icons/items/equipped_label",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "top",
					size = {
						32,
						32,
					},
					offset = {
						0,
						0,
						8,
					},
				},
				visibility_function = function (content, style)
					return content.hotspot.is_selected
				end,
			},
			{
				pass_type = "texture",
				style_id = "choice_icon",
				value = "content/ui/materials/base/ui_default_base",
				value_id = "choice_icon",
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "bottom",
					offset = {
						5,
						-5,
						3,
					},
					color = Color.ui_terminal(255, true),
					size = {
						16,
						16,
					},
				},
				visibility_function = function (content)
					return content.use_choice_icon
				end,
			},
		},
		init = function (parent, widget, element, option, grid_index, callback_name)
			local content = widget.content

			content.hotspot.use_is_focused = true
			content.option_value = option.value
			content.element = element
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, option, grid_index)
		end,
		load_icon = function (parent, widget, element)
			if element.icon_type ~= "companion" then
				load_appearance_icon(parent, widget, element)
			end
		end,
		unload_icon = function (parent, widget, element)
			if element.icon_type ~= "companion" then
				unload_appearance_icon(parent, widget, element)
			end
		end,
		update_icon = function (parent, widget, element)
			if element.icon_type ~= "companion" then
				local profile = table.clone_instance(parent._character_create:profile())

				parent._character_create.set_item_per_slot_preview(parent._character_create, element.slot_name, widget.content.option_value, profile)

				profile.character_id = widget.content.icon_profile and widget.content.icon_profile.character_id or math:uuid()

				Managers.event:trigger("event_player_profile_updated", nil, nil, profile)
			end
		end,
	},
	icon = {
		size = {
			90,
			90,
		},
		pass_template = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.character_appearance_change,
				},
			},
			{
				pass_type = "rect",
				style_id = "rect",
				style = {
					color = Color.terminal_grid_background_icon(30, true),
					offset = {
						0,
						0,
						1,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "icon_background",
				value = "content/ui/materials/base/ui_default_base",
				value_id = "icon",
				style = {
					offset = {
						0,
						0,
						2,
					},
					color = Color.terminal_frame(nil, true),
					default_color = Color.terminal_frame(nil, true),
					hover_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
				},
				change_function = item_change_function,
				visibility_function = function (content, style)
					return style.material_values.texture_map
				end,
			},
			{
				pass_type = "texture",
				style_id = "button_gradient",
				value = "content/ui/materials/gradients/gradient_diagonal_down_right",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					default_color = Color.black(nil, true),
					hover_color = Color.terminal_background_gradient(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					offset = {
						0,
						0,
						4,
					},
				},
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_change_function(content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style)
				end,
				visibility_function = function (content, style)
					return content.hotspot.is_hover or content.hotspot.is_focused
				end,
			},
			{
				pass_type = "texture",
				style_id = "icon",
				value = "content/ui/materials/base/ui_default_base",
				value_id = "icon",
				style = {
					offset = {
						0,
						0,
						3,
					},
					color = Color.terminal_text_body(nil, true),
					default_color = Color.terminal_text_body(nil, true),
					selected_color = Color.terminal_icon_selected(nil, true),
				},
				change_function = item_change_function,
				visibility_function = function (content, style)
					return style.material_values.texture_map
				end,
			},
			{
				pass_type = "text",
				style_id = "label",
				value = "missing icon",
				value_id = "label",
				style = {
					offset = {
						0,
						0,
						2,
					},
				},
				visibility_function = function (content, style)
					return not content.icon_texture
				end,
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					horizontal_alignment = "center",
					hover_layer = 7,
					max_alpha = 255,
					scale_to_material = true,
					selected_layer = 8,
					vertical_alignment = "center",
					color = Color.terminal_frame(nil, true),
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					hover_color = Color.terminal_frame_hover(nil, true),
					offset = {
						0,
						0,
						6,
					},
				},
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
			{
				max_alpha = 255,
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					horizontal_alignment = "center",
					hover_layer = 10,
					scale_to_material = true,
					selected_layer = 11,
					vertical_alignment = "center",
					color = Color.terminal_corner(nil, true),
					default_color = Color.terminal_corner(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true),
					hover_color = Color.terminal_corner_hover(nil, true),
					offset = {
						0,
						0,
						9,
					},
				},
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
			{
				pass_type = "texture",
				style_id = "equipped_icon",
				value = "content/ui/materials/icons/items/equipped_label",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "top",
					size = {
						32,
						32,
					},
					offset = {
						0,
						0,
						8,
					},
				},
				visibility_function = function (content, style)
					return content.hotspot.is_selected
				end,
			},
			{
				pass_type = "texture",
				style_id = "choice_icon",
				value = "content/ui/materials/base/ui_default_base",
				value_id = "choice_icon",
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "bottom",
					offset = {
						5,
						-5,
						3,
					},
					color = Color.ui_terminal(255, true),
					size = {
						16,
						16,
					},
				},
				visibility_function = function (content)
					return content.use_choice_icon
				end,
			},
		},
		init = function (parent, widget, element, option, grid_index, callback_name)
			local content = widget.content
			local style = widget.style

			content.hotspot.use_is_focused = true
			content.icon_background = element.icon_background
			content.icon_texture = option.icon_texture
			style.icon.material_values = {
				texture_map = content.icon_texture,
			}
			style.icon_background.material_values = {
				texture_map = content.icon_background,
			}
			content.element = element
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, option, grid_index)
		end,
	},
	icon_small_texture = {
		size = {
			40,
			40,
		},
		pass_template = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.character_appearance_change,
				},
			},
			{
				pass_type = "texture",
				style_id = "texture",
				value = "",
				value_id = "texture",
				style = {
					color = Color.terminal_corner(255, true),
					offset = {
						0,
						0,
						1,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					horizontal_alignment = "center",
					hover_layer = 7,
					max_alpha = 255,
					scale_to_material = true,
					selected_layer = 8,
					vertical_alignment = "center",
					color = Color.terminal_frame(nil, true),
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					hover_color = Color.terminal_frame_hover(nil, true),
					offset = {
						0,
						0,
						6,
					},
				},
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
			{
				max_alpha = 255,
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					horizontal_alignment = "center",
					hover_layer = 10,
					scale_to_material = true,
					selected_layer = 11,
					vertical_alignment = "center",
					color = Color.terminal_corner(nil, true),
					default_color = Color.terminal_corner(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true),
					hover_color = Color.terminal_corner_hover(nil, true),
					offset = {
						0,
						0,
						9,
					},
				},
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
			{
				pass_type = "texture",
				style_id = "equipped_icon",
				value = "content/ui/materials/icons/items/equipped_label",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "top",
					size = {
						32,
						32,
					},
					offset = {
						0,
						0,
						8,
					},
				},
				visibility_function = function (content, style)
					return content.hotspot.is_selected
				end,
			},
			{
				pass_type = "texture",
				style_id = "button_gradient",
				value = "content/ui/materials/gradients/gradient_diagonal_down_right",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					default_color = Color.black(nil, true),
					hover_color = Color.terminal_background_gradient(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					offset = {
						0,
						0,
						4,
					},
				},
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_change_function(content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style)
				end,
				visibility_function = function (content, style)
					return content.hotspot.is_hover or content.hotspot.is_focused
				end,
			},
			{
				pass_type = "texture",
				style_id = "choice_icon",
				value = "content/ui/materials/base/ui_default_base",
				value_id = "choice_icon",
				style = {
					horizontal_alignment = "bottom",
					vertical_alignment = "left",
					offset = {
						5,
						-5,
						3,
					},
					color = Color.ui_terminal(255, true),
					size = {
						16,
						16,
					},
				},
				visibility_function = function (content)
					return content.use_choice_icon
				end,
			},
		},
		init = function (parent, widget, element, option, grid_index, callback_name)
			local content = widget.content
			local style = widget.style

			content.hotspot.use_is_focused = true
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, option, grid_index)
			content.element = element
			content.texture = element.texture
			style.texture.color = option.color
		end,
	},
	icon_small_texture_hsv = {
		size = {
			40,
			40,
		},
		pass_template = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.character_appearance_change,
				},
			},
			{
				pass_type = "texture",
				style_id = "texture",
				value = "",
				value_id = "texture",
				style = {
					material_values = {
						hsv_skin = {
							0,
							0,
							0,
						},
					},
					color = Color.terminal_corner(255, true),
					offset = {
						0,
						0,
						1,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					horizontal_alignment = "center",
					hover_layer = 7,
					max_alpha = 255,
					scale_to_material = true,
					selected_layer = 8,
					vertical_alignment = "center",
					color = Color.terminal_frame(nil, true),
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					hover_color = Color.terminal_frame_hover(nil, true),
					offset = {
						0,
						0,
						6,
					},
				},
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
			{
				max_alpha = 255,
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					horizontal_alignment = "center",
					hover_layer = 10,
					scale_to_material = true,
					selected_layer = 11,
					vertical_alignment = "center",
					color = Color.terminal_corner(nil, true),
					default_color = Color.terminal_corner(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true),
					hover_color = Color.terminal_corner_hover(nil, true),
					offset = {
						0,
						0,
						9,
					},
				},
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
			{
				pass_type = "texture",
				style_id = "equipped_icon",
				value = "content/ui/materials/icons/items/equipped_label",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "top",
					size = {
						32,
						32,
					},
					offset = {
						0,
						0,
						8,
					},
				},
				visibility_function = function (content, style)
					return content.hotspot.is_selected
				end,
			},
			{
				pass_type = "texture",
				style_id = "button_gradient",
				value = "content/ui/materials/gradients/gradient_diagonal_down_right",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					default_color = Color.black(nil, true),
					hover_color = Color.terminal_background_gradient(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					offset = {
						0,
						0,
						4,
					},
				},
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_change_function(content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style)
				end,
				visibility_function = function (content, style)
					return content.hotspot.is_hover or content.hotspot.is_focused
				end,
			},
			{
				pass_type = "texture",
				style_id = "choice_icon",
				value = "content/ui/materials/base/ui_default_base",
				value_id = "choice_icon",
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "bottom",
					offset = {
						5,
						-5,
						3,
					},
					color = Color.ui_terminal(255, true),
					size = {
						16,
						16,
					},
				},
				visibility_function = function (content)
					return content.use_choice_icon
				end,
			},
		},
		init = function (parent, widget, element, option, grid_index, callback_name)
			local content = widget.content
			local style = widget.style

			content.element = element
			content.hotspot.use_is_focused = true
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, option, grid_index)
			content.texture = element.texture
			style.texture.material_values.hsv_skin = option.color
		end,
	},
	vertical_slider = {
		size = {
			140,
			580,
		},
		pass_template = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
			},
			{
				content_id = "hotspot_handle",
				pass_type = "hotspot",
			},
			{
				pass_type = "text",
				value_id = "value_text_top",
				style = CharacterAppearanceViewFontStyle.slider_top_font_style,
				value = Localize("loc_character_create_height_max"),
			},
			{
				pass_type = "text",
				value_id = "value_text_bottom",
				style = CharacterAppearanceViewFontStyle.slider_bottom_font_style,
				value = Localize("loc_character_create_height_min"),
			},
			{
				pass_type = "texture",
				style_id = "background_selected",
				value = "content/ui/materials/buttons/background_selected",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = Color.ui_terminal(255, true),
					offset = {
						0,
						0,
						0,
					},
					size = {
						20,
						460,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "frame_highlight",
				value = "content/ui/materials/buttons/background_selected_edge",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					offset = {
						0,
						0,
						2,
					},
					size = {
						6,
						460,
					},
					disabled_color = Color.terminal_text_body_dark(255, true),
					default_color = Color.terminal_corner(255, true),
					hover_color = Color.terminal_corner_hover(255, true),
				},
				change_function = function (content, style)
					local default_color = style.default_color
					local hover_color = style.hover_color
					local color = style.color
					local hotspot = content.hotspot
					local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

					ColorUtilities.color_lerp(default_color, hover_color, progress, color)

					style.hdr = progress == 1
				end,
			},
			{
				pass_type = "texture",
				style_id = "frame_highlight_edge_top",
				value = "content/ui/materials/buttons/background_selected_edge",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = Color.terminal_corner(255, true),
					offset = {
						0,
						-230,
						2,
					},
					size = {
						20,
						3,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "frame_highlight_edge_bottom",
				value = "content/ui/materials/buttons/background_selected_edge",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = Color.terminal_corner(255, true),
					offset = {
						0,
						230,
						2,
					},
					size = {
						20,
						3,
					},
				},
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/buttons/slider_handle_line",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					offset = {
						0,
						0,
						7,
					},
					size = {
						38,
						38,
					},
					disabled_color = Color.terminal_text_body_dark(255, true),
					default_color = Color.terminal_corner(255, true),
					hover_color = Color.terminal_corner_hover(255, true),
				},
				change_function = function (content, style)
					local size = 460
					local position_diff = size / 2
					local value = content.slider_value

					style.offset[2] = value * size - position_diff

					local default_color = style.default_color
					local hover_color = style.hover_color
					local color = style.color
					local hotspot = content.hotspot
					local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

					ColorUtilities.color_lerp(default_color, hover_color, progress, color)

					style.hdr = progress == 1
				end,
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/buttons/slider_handle_fill",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					offset = {
						0,
						0,
						6,
					},
					size = {
						38,
						38,
					},
					color = Color.black(255, true),
				},
				change_function = function (content, style)
					local size = 460
					local position_diff = size / 2
					local value = content.slider_value
					local hotspot = content.hotspot
					local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

					style.offset[2] = value * size - position_diff
					style.hdr = progress == 1
				end,
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/buttons/slider_handle_highlight",
				style = {
					hdr = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					offset = {
						0,
						0,
						9,
					},
					size = {
						38,
						38,
					},
					color = Color.terminal_corner_hover(255, true),
				},
				change_function = function (content, style)
					local size = 460
					local position_diff = size / 2
					local value = content.slider_value
					local hotspot = content.hotspot

					style.offset[2] = value * size - position_diff

					local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

					style.color[1] = 255 * math.easeOutCubic(progress)

					local new_size = math.lerp(78, 58, math.easeInCubic(progress))
					local size = style.size

					size[1] = new_size
					size[2] = new_size
				end,
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

					local is_selected = content.hotspot.is_focused or content.hotspot.is_hover

					if not is_selected then
						content.drag_active = false
					end

					if up_axis and is_selected then
						content.drag_active = true
					elseif down_axis and is_selected then
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
						local cursor = (IS_XBS or IS_PLAYSTATION) and base_cursor or UIResolution.inverse_scale_vector(base_cursor, renderer.inverse_scale)
						local input_coordinate = cursor[2] - (position[2] + 60)
						local slide_size = 460

						input_coordinate = math.clamp(input_coordinate, 0, slide_size)
						slider_value = input_coordinate / slide_size
					end

					if slider_value ~= content.slider_value then
						content.slider_value = slider_value

						local inverted_value = 1 - slider_value

						if content.option and content.option.on_value_updated then
							content.option.on_value_updated(inverted_value)
						end
					end
				end,
			},
		},
		init = function (parent, widget, element, option, grid_index, callback_name)
			local content = widget.content

			content.hotspot.use_is_focused = true

			local height_range = parent._character_create:get_height_values_range()
			local min_height = height_range.min
			local max_height = height_range.max
			local value = parent._character_create:height()

			content.element = element
			content.option = option
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
		end,
	},
	personality_button = {
		size = {
			450,
			60,
		},
		pass_template = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.character_appearence_option_pressed,
				},
			},
			{
				pass_type = "texture",
				style_id = "background",
				value = "content/ui/materials/backgrounds/default_square",
				value_id = "background",
				style = {
					max_alpha = 64,
					min_alpha = 24,
					scale_to_material = true,
					color = Color.terminal_background_selected(nil, true),
					size_addition = {
						0,
						-2 * ButtonPassTemplates.terminal_list_divider_height,
					},
					offset = {
						0,
						ButtonPassTemplates.terminal_list_divider_height,
						0,
					},
				},
				change_function = ButtonPassTemplates.terminal_list_button_background_change_function,
				visibility_function = function (content, style)
					return content.hotspot.is_selected
				end,
			},
			{
				pass_type = "texture",
				style_id = "background_gradient",
				value = "content/ui/materials/masks/gradient_horizontal_sides_02",
				value_id = "background_gradient",
				style = {
					max_alpha = 255,
					min_alpha = 150,
					scale_to_material = true,
					color = Color.terminal_background_gradient(nil, true),
					default_color = Color.terminal_background_gradient(nil, true),
					hover_color = Color.terminal_background_gradient(nil, true),
					selected_color = Color.terminal_background_selected(nil, true),
					size_addition = {
						0,
						-2 * ButtonPassTemplates.terminal_list_divider_height,
					},
					offset = {
						0,
						ButtonPassTemplates.terminal_list_divider_height,
						1,
					},
				},
				change_function = ButtonPassTemplates.terminal_list_button_frame_hover_change_function,
				visibility_function = ButtonPassTemplates.list_button_focused_visibility_function,
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				value_id = "frame",
				style = {
					hover_layer = 7,
					scale_to_material = true,
					selected_layer = 8,
					color = Color.terminal_frame(nil, true),
					default_color = Color.terminal_frame(nil, true),
					hover_color = Color.terminal_frame_hover(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					offset = {
						0,
						0,
						6,
					},
				},
				change_function = ButtonPassTemplates.terminal_button_change_function,
				visibility_function = ButtonPassTemplates.list_button_focused_visibility_function,
			},
			{
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				value_id = "corner",
				style = {
					hover_layer = 10,
					scale_to_material = true,
					selected_layer = 11,
					color = Color.terminal_corner(nil, true),
					default_color = Color.terminal_corner(nil, true),
					hover_color = Color.terminal_corner_hover(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true),
					offset = {
						0,
						0,
						9,
					},
				},
				change_function = ButtonPassTemplates.terminal_button_change_function,
				visibility_function = ButtonPassTemplates.list_button_focused_visibility_function,
			},
			{
				pass_type = "texture",
				style_id = "divider_top",
				value = "content/ui/materials/dividers/divider_line_01",
				value_id = "divider_top",
				style = {
					vertical_alignment = "top",
					color = Color.terminal_frame(128, true),
					offset = {
						0,
						0,
						1,
					},
					size = {
						[2] = ButtonPassTemplates.terminal_list_divider_height,
					},
				},
				visibility_function = function (content, style)
					return content.show_top_divider
				end,
			},
			{
				pass_type = "texture",
				style_id = "divider",
				value = "content/ui/materials/dividers/divider_line_01",
				value_id = "divider",
				style = {
					vertical_alignment = "bottom",
					color = Color.terminal_frame(128, true),
					offset = {
						0,
						0,
						2,
					},
					size = {
						[2] = ButtonPassTemplates.terminal_list_divider_height,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "bullet",
				value = "content/ui/materials/icons/system/page_indicator_02_idle",
				value_id = "bullet",
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "center",
					size = {
						32,
						32,
					},
					offset = {
						15,
						0,
						3,
					},
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_text_body(255, true),
					hover_color = Color.terminal_text_header(255, true),
					selected_color = Color.terminal_text_header_selected(255, true),
				},
				change_function = ButtonPassTemplates.terminal_list_button_text_change_function,
			},
			{
				pass_type = "texture",
				style_id = "bullet_active",
				value = "content/ui/materials/icons/system/page_indicator_02_active",
				value_id = "bullet_active",
				style = {
					horizontal_alignment = "left",
					max_alpha = 255,
					min_alpha = 0,
					vertical_alignment = "center",
					size = {
						32,
						32,
					},
					offset = {
						15,
						0,
						4,
					},
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_text_body(255, true),
					hover_color = Color.terminal_text_header(255, true),
					selected_color = Color.terminal_text_header_selected(255, true),
				},
				change_function = ButtonPassTemplates.terminal_list_button_frame_hover_change_function,
				visibility_function = function (content, style)
					local hotspot = content.hotspot
					local is_hovered = hotspot.is_hover or hotspot.is_focused
					local was_hovered = hotspot.anim_hover_progress > 0 or hotspot.anim_select_progress > 0

					return is_hovered or was_hovered
				end,
			},
			{
				pass_type = "text",
				style_id = "text",
				value = "",
				value_id = "text",
				style = table.clone(UIFontSettings.list_button),
				change_function = ButtonPassTemplates.terminal_list_button_text_change_function,
			},
			{
				pass_type = "rect",
				style = {
					color = Color.ui_hud_red_light(255, true),
					offset = {
						0,
						0,
						1,
					},
					size = {
						5,
					},
				},
				visibility_function = function (content, style)
					return content.show_warning
				end,
			},
			{
				pass_type = "texture",
				style_id = "choice_icon",
				value = "content/ui/materials/base/ui_default_base",
				value_id = "choice_icon",
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "bottom",
					offset = {
						5,
						-5,
						3,
					},
					color = Color.ui_terminal(255, true),
					size = {
						16,
						16,
					},
				},
				visibility_function = function (content)
					return content.use_choice_icon
				end,
			},
			{
				content_id = "voice_hotspot",
				pass_type = "hotspot",
				content = {
					hover_type = "circle",
				},
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "center",
					size = {
						40,
						40,
					},
					offset = {
						-20,
						0,
						1,
					},
				},
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/icons/generic/voice",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "center",
					offset = {
						-20,
						0,
						3,
					},
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_text_body(255, true),
					selected_color = Color.terminal_frame_selected(255, true),
					hover_color = Color.terminal_text_header_selected(255, true),
					size = {
						40,
						40,
					},
				},
				visibility_function = function (content, style)
					return not content.sound_id
				end,
				change_function = function (content, style)
					local hotspot = content.hotspot
					local default_color = content.hotspot.is_selected and style.selected_color or style.default_color
					local hover_color = style.hover_color
					local color = style.color
					local progress = math.max(math.max(hotspot.anim_select_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

					ColorUtilities.color_lerp(default_color, hover_color, progress, color)
				end,
			},
			{
				pass_type = "texture",
				style_id = "pulse_1",
				value = "content/ui/materials/bars/plain_vertical_rounded",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "center",
					offset = {
						-12,
						0,
						3,
					},
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_text_body(255, true),
					selected_color = Color.terminal_frame_selected(255, true),
					hover_color = Color.terminal_text_header_selected(255, true),
					size = {
						6,
						40,
					},
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local default_color = content.hotspot.is_selected and style.selected_color or style.default_color
					local hover_color = style.hover_color
					local color = style.color
					local progress = math.max(math.max(hotspot.anim_select_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

					ColorUtilities.color_lerp(default_color, hover_color, progress, color)
				end,
				visibility_function = function (content, style)
					return content.sound_id
				end,
			},
			{
				pass_type = "texture",
				style_id = "pulse_2",
				value = "content/ui/materials/bars/plain_vertical_rounded",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "center",
					offset = {
						-22,
						0,
						3,
					},
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_text_body(255, true),
					selected_color = Color.terminal_frame_selected(255, true),
					hover_color = Color.terminal_text_header_selected(255, true),
					size = {
						6,
						40,
					},
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local default_color = content.hotspot.is_selected and style.selected_color or style.default_color
					local hover_color = style.hover_color
					local color = style.color
					local progress = math.max(math.max(hotspot.anim_select_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

					ColorUtilities.color_lerp(default_color, hover_color, progress, color)
				end,
				visibility_function = function (content, style)
					return content.sound_id
				end,
			},
			{
				pass_type = "texture",
				style_id = "pulse_3",
				value = "content/ui/materials/bars/plain_vertical_rounded",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "center",
					offset = {
						-32,
						0,
						3,
					},
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_text_body(255, true),
					selected_color = Color.terminal_frame_selected(255, true),
					hover_color = Color.terminal_text_header_selected(255, true),
					size = {
						6,
						40,
					},
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local default_color = content.hotspot.is_selected and style.selected_color or style.default_color
					local hover_color = style.hover_color
					local color = style.color
					local progress = math.max(math.max(hotspot.anim_select_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

					ColorUtilities.color_lerp(default_color, hover_color, progress, color)
				end,
				visibility_function = function (content, style)
					return content.sound_id
				end,
			},
			{
				pass_type = "texture",
				style_id = "pulse_4",
				value = "content/ui/materials/bars/plain_vertical_rounded",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "center",
					offset = {
						-42,
						0,
						3,
					},
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_text_body(255, true),
					selected_color = Color.terminal_frame_selected(255, true),
					hover_color = Color.terminal_text_header_selected(255, true),
					size = {
						6,
						40,
					},
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local default_color = content.hotspot.is_selected and style.selected_color or style.default_color
					local hover_color = style.hover_color
					local color = style.color
					local progress = math.max(math.max(hotspot.anim_select_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

					ColorUtilities.color_lerp(default_color, hover_color, progress, color)
				end,
				visibility_function = function (content, style)
					return content.sound_id
				end,
			},
			{
				pass_type = "texture",
				style_id = "pulse_5",
				value = "content/ui/materials/bars/plain_vertical_rounded",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "center",
					offset = {
						-52,
						0,
						3,
					},
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_text_body(255, true),
					selected_color = Color.terminal_frame_selected(255, true),
					hover_color = Color.terminal_text_header_selected(255, true),
					size = {
						6,
						40,
					},
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local default_color = content.hotspot.is_selected and style.selected_color or style.default_color
					local hover_color = style.hover_color
					local color = style.color
					local progress = math.max(math.max(hotspot.anim_select_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

					ColorUtilities.color_lerp(default_color, hover_color, progress, color)
				end,
				visibility_function = function (content, style)
					return content.sound_id
				end,
			},
			{
				pass_type = "texture",
				style_id = "pulse_6",
				value = "content/ui/materials/bars/plain_vertical_rounded",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "center",
					offset = {
						-62,
						0,
						3,
					},
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_text_body(255, true),
					selected_color = Color.terminal_frame_selected(255, true),
					hover_color = Color.terminal_text_header_selected(255, true),
					size = {
						6,
						40,
					},
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local default_color = content.hotspot.is_selected and style.selected_color or style.default_color
					local hover_color = style.hover_color
					local color = style.color
					local progress = math.max(math.max(hotspot.anim_select_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

					ColorUtilities.color_lerp(default_color, hover_color, progress, color)
				end,
				visibility_function = function (content, style)
					return content.sound_id
				end,
			},
		},
		init = function (parent, widget, element, option, grid_index, callback_name)
			local content = widget.content

			content.hotspot.use_is_focused = true
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, option, grid_index)
			content.text = option.text
			content.value_text = Managers.localization:localize("loc_character_create_value_selected")
			content.draw_arrow = element.entries ~= nil
			content.element = element
		end,
		update = function (parent, widget, dt)
			if widget.content.sound_id then
				if not widget.content.pulse_progress then
					for i = 1, 6 do
						local pass = widget.style["pulse_" .. i]

						pass.min_value = math.random(5, 15)
						pass.max_value = math.random(20, 50)
						pass.speed = math.random(5, 20)
					end

					widget.content.pulse_progress = 0
				else
					widget.content.pulse_progress = widget.content.pulse_progress + dt
				end

				for i = 1, 6 do
					local pass = widget.style["pulse_" .. i]
					local min = pass.min_value
					local max = pass.max_value
					local speed = pass.speed
					local wave_value = math.sin(widget.content.pulse_progress * speed)
					local current_value = min + wave_value * wave_value * (max - min)

					pass.size[2] = current_value
				end

				local world = Managers.ui:world()
				local wwise_world = Managers.world:wwise_world(world)

				if not WwiseWorld.is_playing(wwise_world, widget.content.sound_id) then
					widget.content.sound_id = nil
				end
			elseif not widget.content.sound_id and widget.content.pulse_progress then
				widget.content.pulse_progress = nil
			end
		end,
	},
}

return blueprints
