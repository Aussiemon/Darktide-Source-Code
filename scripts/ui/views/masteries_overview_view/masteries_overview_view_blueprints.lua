-- chunkname: @scripts/ui/views/masteries_overview_view/masteries_overview_view_blueprints.lua

local blueprints = {}
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local MasteriesOverviewViewDefinitions = require("scripts/ui/views/masteries_overview_view/masteries_overview_view_definitions")
local weapon_item_size = UISettings.weapon_item_size
local weapon_pattern_size = {
	weapon_item_size[1] * 0.5 - 7,
	weapon_item_size[2],
}
local pattern_display_name_text_style = table.clone(UIFontSettings.header_3)

pattern_display_name_text_style.size = {
	weapon_item_size[1] - 40,
	40,
}
pattern_display_name_text_style.text_color = Color.terminal_text_header(255, true)
pattern_display_name_text_style.default_color = Color.terminal_text_header(255, true)
pattern_display_name_text_style.hover_color = Color.terminal_text_header_selected(255, true)
pattern_display_name_text_style.completed_color = Color.terminal_completed(255, true)
pattern_display_name_text_style.completed_selected_color = Color.terminal_completed(255, true)
pattern_display_name_text_style.completed_hover_color = Color.terminal_completed(255, true)
pattern_display_name_text_style.vertical_alignment = "top"
pattern_display_name_text_style.horizontal_alignment = "left"
pattern_display_name_text_style.text_vertical_alignment = "center"
pattern_display_name_text_style.text_horizontal_alignment = "center"
pattern_display_name_text_style.offset = {
	10,
	0,
	10,
}
pattern_display_name_text_style.size = {
	weapon_pattern_size[1] - 20,
	40,
}
pattern_display_name_text_style.font_size = 16

local required_level_text_style = table.clone(pattern_display_name_text_style)

required_level_text_style.vertical_alignment = "bottom"

local expertise_level_text_style = table.clone(required_level_text_style)

expertise_level_text_style.text_vertical_alignment = "center"
expertise_level_text_style.text_horizontal_alignment = "left"
expertise_level_text_style.font_size = 20
expertise_level_text_style.offset = {
	10,
	5,
	10,
}

local mastery_level_text_style = table.clone(expertise_level_text_style)

mastery_level_text_style.text_horizontal_alignment = "right"

local mark_text_style = table.clone(required_level_text_style)

mark_text_style.size = nil
mark_text_style.vertical_alignment = "bottom"
mark_text_style.horizontal_alignment = "center"
mark_text_style.text_vertical_alignment = "bottom"
mark_text_style.text_horizontal_alignment = "center"
mark_text_style.offset = {
	0,
	-10,
	6,
}

local mark_display_name_text_style = table.clone(UIFontSettings.header_3)

mark_display_name_text_style.horizontal_alignment = "center"
mark_display_name_text_style.text_horizontal_alignment = "center"
mark_display_name_text_style.text_vertical_alignment = "top"
mark_display_name_text_style.size = {
	nil,
	40,
}
mark_display_name_text_style.size_addition = {
	-20,
}
mark_display_name_text_style.offset = {
	10,
	0,
	6,
}
mark_display_name_text_style.font_size = 18

local unlocked_level_text_style = table.clone(mark_display_name_text_style)

unlocked_level_text_style.vertical_alignment = "bottom"

local function item_text_change_function(content, style)
	local hotspot = content.hotspot
	local is_selected = hotspot.is_selected
	local is_focused = hotspot.is_focused
	local is_hover = hotspot.is_hover
	local default_color = style.default_color
	local selected_color = style.selected_color
	local hover_color = style.hover_color
	local color

	if is_selected or is_focused then
		color = selected_color
	elseif is_hover then
		color = hover_color
	else
		color = default_color
	end

	local progress = math.max(math.max(hotspot.anim_hover_progress or 0, hotspot.anim_select_progress or 0), hotspot.anim_focus_progress or 0)

	ColorUtilities.color_lerp(default_color, color, progress, style.text_color)
end

local function item_change_function(content, style)
	local hotspot = content.hotspot
	local is_selected = hotspot.is_selected
	local is_focused = hotspot.is_focused
	local is_hover = hotspot.is_hover
	local default_color = style.default_color
	local selected_color = style.selected_color
	local hover_color = style.hover_color
	local color

	if is_selected or is_focused then
		color = selected_color
	elseif is_hover then
		color = hover_color
	else
		color = default_color
	end

	local progress = math.max(math.max(hotspot.anim_hover_progress or 0, hotspot.anim_select_progress or 0), hotspot.anim_focus_progress or 0)

	ColorUtilities.color_lerp(default_color, color, progress, style.color)
end

blueprints.weapon_pattern = {
	size = weapon_pattern_size,
	pass_template = {
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			style = {
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_click,
			},
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				default_color = Color.terminal_background(nil, true),
				selected_color = Color.terminal_background_selected(nil, true),
			},
			change_function = ButtonPassTemplates.terminal_button_change_function,
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
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
		},
		{
			pass_type = "texture",
			style_id = "outer_shadow",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.black(100, true),
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
			style_id = "icon",
			value = "content/ui/materials/icons/contracts/contracts_store/uknown_melee_weapon",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_text_body(255, true),
				default_color = Color.terminal_text_body(nil, true),
				selected_color = Color.terminal_icon(nil, true),
				completed_color = Color.terminal_completed(255, true),
				offset = {
					0,
					0,
					5,
				},
				size = {
					128,
					48,
				},
			},
			change_function = function (content, style)
				if content.completed then
					style.color = table.clone(style.completed_color)
				else
					style.color = table.clone(style.default_color)

					ButtonPassTemplates.terminal_button_change_function(content, style)
				end
			end,
		},
		{
			pass_type = "text",
			style_id = "display_name",
			value = "",
			value_id = "display_name",
			style = pattern_display_name_text_style,
			change_function = function (content, style)
				local hotspot = content.hotspot
				local default_text_color = style.default_color
				local hover_color = style.hover_color
				local text_color = style.text_color

				if content.completed then
					style.text_color = table.clone(style.completed_color)
				else
					style.text_color = table.clone(style.default_color)

					local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

					ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
				end
			end,
			visibility_function = function (content, style)
				return content.level_requirement_met
			end,
		},
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "top",
				offset = {
					0,
					0,
					6,
				},
				color = {
					150,
					0,
					0,
					0,
				},
			},
			visibility_function = function (content, style)
				return not content.level_requirement_met
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
			style = {
				vertical_alignment = "top",
				offset = {
					0,
					0,
					2,
				},
				color = {
					105,
					45,
					45,
					45,
				},
			},
			visibility_function = function (content, style)
				return not content.level_requirement_met
			end,
		},
		{
			pass_type = "text",
			style_id = "required_level",
			value = "loc_requires_level",
			value_id = "required_level",
			style = required_level_text_style,
			visibility_function = function (content, style)
				return not content.level_requirement_met
			end,
		},
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "bottom",
				offset = {
					0,
					0,
					6,
				},
				color = {
					150,
					0,
					0,
					0,
				},
				size = {
					nil,
					32,
				},
			},
			visibility_function = function (content, style)
				return content.level_requirement_met
			end,
		},
		{
			pass_type = "text",
			style_id = "expertise_level",
			value = "",
			value_id = "expertise_level",
			style = expertise_level_text_style,
			change_function = function (content, style)
				if content.completed then
					style.text_color = table.clone(style.completed_color)
				else
					style.text_color = table.clone(style.default_color)
				end
			end,
			visibility_function = function (content, style)
				return content.level_requirement_met
			end,
		},
		{
			pass_type = "text",
			style_id = "mastery_level",
			value = "",
			value_id = "mastery_level",
			style = mastery_level_text_style,
			change_function = function (content, style)
				if content.completed then
					style.text_color = table.clone(style.completed_color)
				else
					style.text_color = table.clone(style.default_color)
				end
			end,
			visibility_function = function (content, style)
				return content.level_requirement_met
			end,
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_frame(nil, true),
				default_color = Color.terminal_frame(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				hover_color = Color.terminal_frame_hover(nil, true),
				offset = {
					0,
					0,
					12,
				},
			},
			change_function = function (content, style)
				item_change_function(content, style)
			end,
		},
		{
			pass_type = "texture",
			style_id = "corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_corner(nil, true),
				default_color = Color.terminal_corner(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true),
				hover_color = Color.terminal_corner_hover(nil, true),
				offset = {
					0,
					0,
					13,
				},
			},
			change_function = item_change_function,
		},
		{
			pass_type = "texture",
			style_id = "alert_dot",
			value = "content/ui/materials/symbols/new_item_indicator",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "top",
				size = {
					80,
					80,
				},
				offset = {
					20,
					0,
					2,
				},
				color = Color.ui_terminal(255, true),
			},
			visibility_function = function (content)
				return content.show_alert and content.level_requirement_met
			end,
			change_function = function (content, style)
				if content.completed then
					style.offset[2] = 0
				else
					style.offset[2] = -20
				end
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/generic/top_right_triangle",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "top",
				size = {
					40,
					40,
				},
				color = Color.terminal_frame_selected(255, true),
				default_color = Color.terminal_frame(180, true),
				selected_color = Color.terminal_frame_selected(180, true),
				disabled_color = Color.ui_grey_medium(180, true),
				hover_color = Color.terminal_frame_hover(180, true),
				offset = {
					0,
					0,
					8,
				},
			},
			visibility_function = function (content, style)
				return content.completed
			end,
			change_function = function (content, style)
				item_change_function(content, style)
			end,
		},
		{
			pass_type = "text",
			style_id = "complete_sign",
			value = "",
			style = {
				font_size = 22,
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "right",
				text_vertical_alignment = "top",
				text_color = Color.white(255, true),
				default_color = Color.ui_terminal(nil, true),
				selected_color = Color.white(nil, true),
				disabled_color = Color.ui_grey_light(255, true),
				hover_color = Color.ui_terminal(nil, true),
				offset = {
					-4,
					-1,
					9,
				},
			},
			visibility_function = function (content, style)
				return content.completed
			end,
			change_function = function (content, style)
				item_text_change_function(content, style)
			end,
		},
	},
	init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer, double_click_callback)
		local content = widget.content
		local style = widget.style

		content.hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)
		content.element = element

		local display_name = element.display_name
		local icon = element.icon

		if display_name then
			content.display_name = display_name
		end

		if icon then
			content.icon = icon
		end

		local view_instance = parent._parent or parent
		local character_level = view_instance and view_instance.character_level and view_instance:character_level()
		local level_requirement_met = true

		if element.weapon_level_requirement then
			level_requirement_met = character_level >= element.weapon_level_requirement
		end

		content.level_requirement_met = level_requirement_met

		if level_requirement_met == false then
			content.required_level = Localize("loc_requires_level", true, {
				level = element.weapon_level_requirement,
			})
		end

		if element.mastery_level then
			content.mastery_level = string.format(" %d", element.mastery_level)
		end

		if element.expertise_level then
			content.expertise_level = string.format(" %d", element.expertise_level)
		end

		if element.show_alert then
			content.show_alert = element.show_alert
		end

		content.completed = element.mastery_level == element.mastery_max_level
	end,
}
blueprints.spacing_vertical = {
	size = {
		MasteriesOverviewViewDefinitions.patterns_grid_settings.grid_size[1],
		20,
	},
}
blueprints.mark = {
	size = {
		240,
		200,
	},
	pass_template = {
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			style = {
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_click,
			},
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/contracts/contracts_store/uknown_melee_weapon",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_text_body(255, true),
				default_color = Color.terminal_text_body(nil, true),
				selected_color = Color.terminal_icon(nil, true),
				disabled_color = Color.ui_grey_light(255, true),
				offset = {
					0,
					0,
					5,
				},
				size = {
					nil,
					80,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "display_name",
			value = "",
			value_id = "display_name",
			style = unlocked_level_text_style,
			visibility_function = function (content, style)
				return content.unlocked
			end,
		},
		{
			pass_type = "text",
			style_id = "unlock_level",
			value = "",
			value_id = "unlock_level",
			style = unlocked_level_text_style,
			visibility_function = function (content, style)
				return not content.unlocked
			end,
		},
	},
	init = function (parent, widget, element)
		local content = widget.content
		local style = widget.style

		content.element = element
		content.display_name = element.display_name
		content.unlock_level = Localize("loc_mastery_unlocked_level", true, {
			level = element.unlock_level or 0,
		})

		local unlocked = element.unlocked

		content.unlocked = unlocked

		if element.icon then
			content.icon = element.icon
		end

		local icon_style = widget.style.icon

		icon_style.color = unlocked and icon_style.default_color or icon_style.disabled_color
	end,
}
blueprints.trait = {
	size = {
		114,
		114,
	},
	pass_template = {
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			style = {
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_click,
			},
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/traits/traits_container",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_text_body(255, true),
				material_values = {},
			},
		},
	},
	init = function (parent, widget, element)
		local content = widget.content
		local style = widget.style

		content.element = element

		local texture_icon = element.texture_icon
		local texture_frame = element.texture_frame
		local unlocked = element.unlocked
		local icon_material_values = style.icon.material_values

		if texture_icon then
			icon_material_values.icon = texture_icon
		end

		if texture_frame then
			icon_material_values.frame = texture_frame
		end

		if unlocked then
			style.icon.color = Color.white(255, true)
		end
	end,
}
blueprints.weapon_mark = {
	size = weapon_pattern_size,
	pass_template = {
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			style = {
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.weapons_switch_mark,
			},
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				default_color = Color.terminal_background(nil, true),
				selected_color = Color.terminal_background_selected(nil, true),
			},
			change_function = ButtonPassTemplates.terminal_button_change_function,
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
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
		},
		{
			pass_type = "texture",
			style_id = "outer_shadow",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.black(100, true),
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
			style_id = "icon",
			value = "content/ui/materials/icons/contracts/contracts_store/uknown_melee_weapon",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_text_body(255, true),
				default_color = Color.terminal_text_body(nil, true),
				selected_color = Color.terminal_icon(nil, true),
				offset = {
					0,
					-10,
					5,
				},
				size = {
					128,
					48,
				},
			},
			change_function = ButtonPassTemplates.terminal_button_change_function,
		},
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "top",
				offset = {
					0,
					0,
					6,
				},
				color = {
					150,
					0,
					0,
					0,
				},
			},
			visibility_function = function (content, style)
				return not content.is_unlocked
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
			style = {
				vertical_alignment = "top",
				offset = {
					0,
					0,
					2,
				},
				color = {
					105,
					45,
					45,
					45,
				},
			},
			visibility_function = function (content, style)
				return not content.is_unlocked
			end,
		},
		{
			pass_type = "text",
			style_id = "mark_name",
			value = "",
			value_id = "mark_name",
			style = mark_text_style,
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_frame(nil, true),
				default_color = Color.terminal_frame(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				hover_color = Color.terminal_frame_hover(nil, true),
				offset = {
					0,
					0,
					12,
				},
			},
			change_function = function (content, style)
				item_change_function(content, style)
			end,
		},
		{
			pass_type = "texture",
			style_id = "corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_corner(nil, true),
				default_color = Color.terminal_corner(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true),
				hover_color = Color.terminal_corner_hover(nil, true),
				offset = {
					0,
					0,
					13,
				},
			},
			change_function = item_change_function,
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
					16,
				},
			},
			visibility_function = function (content, style)
				return content.equipped
			end,
		},
	},
	init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer, double_click_callback)
		local content = widget.content
		local style = widget.style

		content.hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)
		content.element = element
		content.is_unlocked = element.is_unlocked

		local icon = element.icon

		if icon then
			content.icon = icon
		end

		content.mark_name = element.mark_name
		content.equipped = element.equipped
	end,
}

return blueprints
