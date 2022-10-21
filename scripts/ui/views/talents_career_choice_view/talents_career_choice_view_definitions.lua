local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local ViewStyles = require("scripts/ui/views/talents_career_choice_view/talents_career_choice_view_styles")
local ColorUtilities = require("scripts/utilities/ui/colors")
local WIDGET_NAME_PREFIX = "career_"
local top_panel_size = UIWorkspaceSettings.top_panel.size
local bottom_panel_size = UIWorkspaceSettings.bottom_panel.size
local confirm_choice_button_size = ViewStyles.confirm_button_size
local banner_size = ViewStyles.career_banner.size
local screen_height = UIWorkspaceSettings.screen.size[2]
local visible_area_width = banner_size[1] * 3
local visible_area_height = screen_height - top_panel_size[2] - bottom_panel_size[2]
local divider_size = ViewStyles.vertical_divider.size
local list_size = ViewStyles.career_banner.talents_list.size
local list_position = ViewStyles.career_banner.talents_list.offset
local mask_margins = ViewStyles.mask_margins
local mask_size = {
	list_size[1] + mask_margins[1] * 2,
	list_size[2]
}
local scrollbar_size = {
	10,
	list_size[2] - mask_margins[2] * 2
}
local scenegraph = {
	screen = UIWorkspaceSettings.screen,
	visible_area = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			visible_area_width,
			visible_area_height
		},
		position = {
			0,
			top_panel_size[2],
			1
		}
	},
	header = {
		vertical_alignment = "top",
		parent = "visible_area",
		horizontal_alignment = "center",
		size = {
			800,
			60
		},
		position = {
			0,
			48,
			15
		}
	},
	confirm_choice_button = {
		vertical_alignment = "bottom",
		parent = "visible_area",
		horizontal_alignment = "center",
		size = confirm_choice_button_size,
		position = {
			0,
			-40,
			15
		}
	}
}
local lipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eget eleifend lectus. Praesent ac pellentesque arcu. Etiam commodo"
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				color = {
					255,
					0,
					0,
					0
				}
			}
		}
	}, "screen"),
	confirm_choice_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "confirm_choice_button", {
		loc_key = "loc_talents_choose_specialization_confirm_choice_button"
	})
}

local function banner_pass_visibility_function(content, style)
	local color = style.text_color or style.color

	return color[1] > 0
end

local blueprints = {
	career_banner = {
		passes = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				style_id = "background",
				value_id = "background",
				pass_type = "texture"
			},
			{
				style_id = "background_blurred",
				value_id = "background_blurred",
				pass_type = "texture",
				visibility_function = banner_pass_visibility_function
			},
			{
				value = "content/ui/materials/mission_board/frames/headline_background_vertical",
				style_id = "fade_top",
				pass_type = "texture_uv"
			},
			{
				value = "content/ui/materials/mission_board/frames/headline_background_vertical",
				style_id = "fade_bottom",
				pass_type = "texture"
			},
			{
				style_id = "title",
				value_id = "title",
				pass_type = "text",
				visibility_function = banner_pass_visibility_function
			},
			{
				style_id = "short_description",
				value_id = "short_description",
				pass_type = "text",
				visibility_function = banner_pass_visibility_function
			},
			{
				style_id = "description",
				value_id = "description",
				pass_type = "text",
				visibility_function = banner_pass_visibility_function
			},
			{
				style_id = "show_details_button_hint",
				value_id = "show_details_button_hint",
				pass_type = "text",
				visibility_function = banner_pass_visibility_function
			},
			{
				style_id = "hide_details_button_hint",
				value_id = "hide_details_button_hint",
				pass_type = "text",
				visibility_function = banner_pass_visibility_function
			},
			{
				style_id = "description_button_hint",
				value_id = "description_button_hint",
				pass_type = "text",
				visibility_function = banner_pass_visibility_function
			},
			{
				style_id = "information_button_hint",
				value_id = "information_button_hint",
				pass_type = "text",
				visibility_function = banner_pass_visibility_function
			}
		}
	},
	list_entry_with_icon = {
		passes = {
			{
				style_id = "icon",
				value_id = "icon",
				pass_type = "texture"
			},
			{
				value = "content/ui/materials/icons/talents/menu/frame_active",
				style_id = "icon_frame",
				pass_type = "texture"
			},
			{
				style_id = "label",
				value_id = "label",
				pass_type = "text"
			},
			{
				style_id = "description",
				value_id = "description",
				pass_type = "text"
			}
		},
		style = ViewStyles.list_entry_with_icon,
		min_height = ViewStyles.list_entry_with_icon.icon_frame.size[2]
	},
	list_entry_no_icon = {
		min_height = 0,
		passes = {
			{
				style_id = "label",
				value_id = "label",
				pass_type = "text"
			},
			{
				style_id = "description",
				value_id = "description",
				pass_type = "text"
			}
		},
		style = ViewStyles.list_entry_no_icon
	}
}

for i = 1, 3 do
	local banner_position = {
		banner_size[1] * (i - 1),
		ViewStyles.banner_offset_y,
		3
	}
	local scenegraph_name = "career_" .. i
	local list_name = scenegraph_name .. "_list"
	scenegraph[scenegraph_name] = {
		vertical_alignment = "top",
		parent = "visible_area",
		horizontal_alignment = "left",
		size = banner_size,
		position = banner_position
	}
	scenegraph[list_name] = {
		vertical_alignment = "bottom",
		horizontal_alignment = "center",
		parent = scenegraph_name,
		size = list_size,
		position = list_position
	}
	scenegraph[list_name .. "_content"] = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		parent = list_name,
		size = list_size,
		position = {
			0,
			0,
			1
		}
	}
	scenegraph[list_name .. "_mask"] = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		parent = list_name,
		size = mask_size,
		position = {
			-mask_margins[1],
			0,
			2
		}
	}
	scenegraph[scenegraph_name .. "_scrollbar"] = {
		vertical_alignment = "top",
		horizontal_alignment = "right",
		parent = list_name,
		size = scrollbar_size,
		position = {
			36,
			mask_margins[2],
			5
		}
	}
	local career_widget_name = WIDGET_NAME_PREFIX .. i
	local widget_definition = UIWidget.create_definition(blueprints.career_banner.passes, scenegraph_name, {
		banner_id = i
	}, nil, ViewStyles.career_banner)
	widget_definitions[career_widget_name] = widget_definition
	widget_definitions[career_widget_name .. "_scrollbar"] = UIWidget.create_definition(ScrollbarPassTemplates.default_scrollbar, scenegraph_name .. "_scrollbar")
	widget_definitions[career_widget_name .. "_mask"] = UIWidget.create_definition({
		{
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur_02",
			style_id = "mask",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	}, list_name .. "_mask")
end

for i = 1, 4 do
	local divider_position = {
		(i - 1) * banner_size[1] - divider_size[1] / 2,
		ViewStyles.banner_offset_y,
		15
	}
	local divider_name = "divider_" .. i
	scenegraph[divider_name] = {
		vertical_alignment = "top",
		parent = "visible_area",
		horizontal_alignment = "left",
		size = divider_size,
		position = divider_position
	}
	widget_definitions[divider_name] = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/vertical_dynamic"
		}
	}, divider_name, nil, nil, ViewStyles.vertical_divider)
end

local lerp = math.lerp
local color_lerp = ColorUtilities.color_lerp

local function lerp_style(widget_styles, source_styles, target_styles, progress)
	for style_name, pass_style in pairs(widget_styles) do
		local from_style = source_styles[style_name]
		local to_style = target_styles[style_name]

		if to_style then
			for property_name, style_property in pairs(pass_style) do
				local from_property = from_style[property_name]
				local to_property = to_style[property_name]
				local property_type = type(style_property)

				if to_property then
					fassert(property_type == type(from_property) and property_type == type(to_property), "Property type differs for style %s.%s", style_name, property_name)

					if property_name == "size" or property_name == "offset" then
						local to_x = to_property[1]
						local to_y = to_property[2]

						if to_x then
							local from_x = from_property[1] or style_property[1]
							style_property[1] = lerp(from_x, to_x, progress)
						end

						if to_y then
							local from_y = from_property[2] or style_property[2]
							style_property[2] = lerp(from_y, to_y, progress)
						end
					elseif property_name == "color" or property_name == "text_color" then
						color_lerp(from_property, to_property, progress, style_property)
					end
				end
			end
		end
	end
end

local animations = {
	switch_state = {
		{
			name = "update_banner",
			end_time = 0.2,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				params.talents_start_alpha = widgets.mask.alpha_multiplier or 0
				params.talents_target_alpha = params.banner_target_style.show_talents and 1 or 0
				widgets.banner_widget.style.title.material = nil

				if params.sound then
					Managers.ui:play_2d_sound(params.sound)
				end
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local banner_widget = widgets.banner_widget
				local banner_style = banner_widget.style
				local banner_source_style = params.banner_source_style
				local banner_target_style = params.banner_target_style
				progress = math.ease_quad(progress)

				lerp_style(banner_style, banner_source_style, banner_target_style, progress)

				banner_style.background.material_values.saturation = math.lerp(banner_source_style.background.material_values.saturation, banner_target_style.background.material_values.saturation, progress)
				local mask = widgets.mask
				mask.style.mask.size = banner_style.talents_list.size
				local talents_alpha = math.lerp(params.talents_start_alpha, params.talents_target_alpha, progress)
				mask.alpha_multiplier = talents_alpha
				widgets.scrollbar.alpha_multiplier = talents_alpha
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				widgets.banner_widget.style.title.material = params.banner_target_style.title.material
			end
		}
	}
}
local talents_career_choice_view_definitions = {
	widget_name_prefix = WIDGET_NAME_PREFIX,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph,
	animations = animations,
	blueprints = blueprints
}

return settings("TalentsCareerChoiceViewDefinitions", talents_career_choice_view_definitions)
