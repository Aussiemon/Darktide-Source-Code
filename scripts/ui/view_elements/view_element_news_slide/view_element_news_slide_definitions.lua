-- chunkname: @scripts/ui/view_elements/view_element_news_slide/view_element_news_slide_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local InputUtils = require("scripts/managers/input/input_utils")
local Settings = require("scripts/ui/view_elements/view_element_news_slide/view_element_news_slide_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local width, height = Settings.size[1], Settings.size[2]
local bar_height = Settings.bar_size[2]
local buffer = Settings.buffer
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	news_area = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			width,
			height,
		},
		position = {
			-90,
			70,
			0,
		},
	},
	progress_bar = {
		horizontal_alignment = "center",
		parent = "news_area",
		vertical_alignment = "bottom",
		size = Settings.bar_size,
		position = {
			0,
			bar_height + 6 + buffer,
			0,
		},
	},
	input_prompt_left = {
		horizontal_alignment = "left",
		parent = "news_area",
		vertical_alignment = "bottom",
		offset = {
			0,
			height + buffer,
			10,
		},
	},
	input_prompt_right = {
		horizontal_alignment = "right",
		parent = "news_area",
		vertical_alignment = "bottom",
		offset = {
			15,
			height + buffer,
			10,
		},
	},
	open_news_button_pivot = {
		horizontal_alignment = "center",
		parent = "news_area",
		vertical_alignment = "bottom",
		size = {
			Settings.bar_size[1],
			Settings.bar_size[2] * 4 + buffer * 2,
		},
		offset = {
			0,
			Settings.bar_size[2] * 9,
			4,
		},
	},
}

local function _input_prompt_change_function(content, style)
	local is_enabled = content.is_enabled
	local input_action = content.input_action

	if not input_action or not is_enabled then
		content.text = ""

		return
	end

	local service_type = "View"
	local alias_key = Managers.ui:get_input_alias_key(input_action, service_type)
	local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)

	content.text = string.format(Localize("loc_input_legend_text_template"), input_text, "")
end

local function _body_background_visibility_function(content, style)
	return content.body_number and content.body_number ~= "" or content.body_text and content.body_text ~= ""
end

local widget_definitions = {
	news_button = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			content = {
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_click,
			},
		},
		{
			pass_type = "rect",
			style_id = "screen_background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = {
					100,
					0,
					0,
					0,
				},
				offset = {
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					24,
					24,
				},
				offset = {
					0,
					0,
					1,
				},
				color = Color.terminal_grid_background(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				default_color = Color.black(255, true),
				hover_color = Color.black(155, true),
				selected_color = Color.black(155, true),
				disabled_color = Color.black(255, true),
				offset = {
					0,
					0,
					2,
				},
			},
			change_function = ButtonPassTemplates.terminal_button_change_function,
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				default_color = Color.terminal_frame(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				disabled_color = Color.ui_grey_medium(255, true),
				hover_color = Color.terminal_frame_hover(nil, true),
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
			style_id = "corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				default_color = Color.terminal_corner(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true),
				disabled_color = Color.ui_grey_light(255, true),
				hover_color = Color.terminal_corner_hover(nil, true),
				offset = {
					0,
					0,
					10,
				},
			},
			change_function = ButtonPassTemplates.terminal_button_change_function,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/achievements/card_upper",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					nil,
					22,
				},
				size_addition = {
					12,
					0,
				},
				offset = {
					0,
					-10,
					8,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/achievements/card_lower",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					nil,
					24,
				},
				size_addition = {
					12,
					0,
				},
				offset = {
					0,
					11,
					9,
				},
			},
		},
		{
			pass_type = "texture_uv",
			style_id = "online_image",
			value = "content/ui/materials/backgrounds/news_feed/article_image_blank",
			value_id = "texture",
			style = {
				hdr = false,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = Settings.image_size,
				offset = {
					0,
					0,
					5,
				},
				uvs = {
					{
						0,
						0,
					},
					{
						1,
						Settings.image_size[2] / Settings.image_size[1],
					},
				},
				material_values = {
					left_offset = 0.5,
					right_offset = 0.5,
				},
			},
			visibility_function = function (content, style)
				return not not style.material_values.texture
			end,
		},
		{
			pass_type = "rect",
			style_id = "title_background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					nil,
					48,
				},
				color = {
					150,
					0,
					0,
					0,
				},
				offset = {
					0,
					0,
					7,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "title",
			value = "",
			value_id = "title",
			change_function = ButtonPassTemplates.terminal_button_change_function,
			style = table.add_missing({
				font_size = 20,
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "bottom",
				vertical_alignment = "center",
				size = {
					width - 2 * buffer,
					height - 2 * buffer,
				},
				offset = {
					0,
					3,
					7,
				},
			}, UIFontSettings.list_button),
		},
		{
			pass_type = "rect",
			style_id = "body_background",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "top",
				size = {
					width - 1 * buffer,
					height + 5 * buffer,
				},
				color = {
					150,
					0,
					0,
					0,
				},
				offset = {
					0,
					0,
					6,
				},
			},
			visibility_function = _body_background_visibility_function,
		},
		{
			pass_type = "texture",
			style_id = "body_gradient",
			value = "content/ui/materials/gradients/gradient_horizontal",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "top",
				size = {
					width - 1 * buffer,
					height + 10 * buffer,
				},
				color = {
					150,
					0,
					0,
					0,
				},
				offset = {
					-width - 1 * buffer,
					0,
					6,
				},
			},
			visibility_function = _body_background_visibility_function,
		},
		{
			pass_type = "text",
			style_id = "body_number",
			value = "",
			value_id = "body_number",
			change_function = ButtonPassTemplates.terminal_button_change_function,
			style = table.add_missing({
				font_size = 28,
				horizontal_alignment = "center",
				text_horizontal_alignment = "right",
				text_vertical_alignment = "top",
				vertical_alignment = "center",
				size = {
					width - 1 * buffer,
					height - 1 * buffer,
				},
				offset = {
					-1 * buffer,
					0,
					7,
				},
			}, UIFontSettings.list_button),
		},
		{
			pass_type = "text",
			style_id = "body_text",
			value = "",
			value_id = "body_text",
			style = table.add_missing({
				font_size = 18,
				horizontal_alignment = "center",
				text_horizontal_alignment = "right",
				text_vertical_alignment = "top",
				vertical_alignment = "center",
				size = {
					width - 2 * buffer,
					height - 2 * buffer,
				},
				offset = {
					0,
					0,
					7,
				},
				text_color = Color.terminal_text_body_sub_header(255, true),
			}, UIFontSettings.list_button),
			change_function = function (content, style, optional_hotspot_id)
				style.text_color = content.body_number and content.body_number ~= "" and Color.terminal_text_body_sub_header(255, true) or Color.terminal_text_header(255, true)
			end,
		},
	}, "news_area"),
	input_prompt_left = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = table.add_missing({
				font_size = 18,
				text_horizontal_alignment = "left",
				text_vertical_alignment = "top",
				size = {
					width - 2 * buffer,
					height - 2 * buffer,
				},
				offset = {
					0,
					0,
					12,
				},
				text_color = Color.terminal_text_body_sub_header(255, true),
			}, UIFontSettings.list_button),
			change_function = _input_prompt_change_function,
		},
	}, "input_prompt_left"),
	input_prompt_right = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = table.add_missing({
				font_size = 18,
				text_horizontal_alignment = "right",
				text_vertical_alignment = "top",
				size = {
					width - 2 * buffer,
					height - 2 * buffer,
				},
				offset = {
					0,
					0,
					12,
				},
				text_color = Color.terminal_text_body_sub_header(255, true),
			}, UIFontSettings.list_button),
			change_function = _input_prompt_change_function,
		},
	}, "input_prompt_right"),
	open_news_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "open_news_button_pivot", {
		hotspot = {
			on_pressed_sound = UISoundEvents.default_click,
		},
	}, nil, {
		text = {
			font_size = 20,
		},
	}),
}
local blueprints = {}

blueprints.loading_bar = UIWidget.create_definition({
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style_id = "hotspot",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			size = {
				0,
				bar_height,
			},
		},
	},
	{
		pass_type = "rect",
		style_id = "background",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			size = {
				0,
				bar_height,
			},
			offset = {
				0,
				0,
				0,
			},
		},
	},
	{
		pass_type = "rect",
		style_id = "foreground",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			color = Color.terminal_icon(nil, true),
			size = {
				0,
				bar_height,
			},
			offset = {
				0,
				0,
				1,
			},
		},
		visibility_function = function (content, style)
			return content.active
		end,
	},
	{
		pass_type = "texture",
		style_id = "glow",
		value = "content/ui/materials/frames/frame_glow_01",
		style = {
			horizontal_alignment = "left",
			scale_to_material = true,
			vertical_alignment = "center",
			color = Color.terminal_icon(150, true),
			size = {
				0,
				bar_height,
			},
			offset = {
				0,
				0,
				1,
			},
			size_addition = {
				24,
				24,
			},
		},
		visibility_function = function (content, style)
			return content.active and style.size[1] > 4
		end,
	},
}, "progress_bar", nil, {
	0,
	bar_height,
})

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	blueprints = blueprints,
}
