-- chunkname: @scripts/ui/view_elements/view_element_wintrack_mastery/view_element_wintrack_mastery_definitions.lua

local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ViewElementWintrackSettings = require("scripts/ui/view_elements/view_element_wintrack/view_element_wintrack_settings")
local rating_text_style = table.clone(UIFontSettings.body_small)

rating_text_style.text_horizontal_alignment = "right"
rating_text_style.text_vertical_alignment = "center"
rating_text_style.text_color = Color.white(255, true)
rating_text_style.font_size = 30
rating_text_style.offset = {
	-10,
	0,
	300,
}
rating_text_style.material = "content/ui/materials/font_gradients/slug_font_gradient_item_level"

local rating_header_text_style = table.clone(UIFontSettings.body_small)

rating_header_text_style.text_horizontal_alignment = "right"
rating_header_text_style.text_vertical_alignment = "center"
rating_header_text_style.text_color = Color.terminal_text_body(255, true)
rating_header_text_style.font_size = 17
rating_header_text_style.size = {
	nil,
	18,
}
rating_header_text_style.offset = {
	-112,
	3,
	300,
}

local mark_display_name_text_style = table.clone(UIFontSettings.header_3)

mark_display_name_text_style.text_vertical_alignment = "top"
mark_display_name_text_style.vertical_alignment = "top"
mark_display_name_text_style.horizontal_alignment = "center"
mark_display_name_text_style.text_horizontal_alignment = "center"
mark_display_name_text_style.size_addition = {
	-40,
}
mark_display_name_text_style.offset = {
	20,
	0,
	6,
}
mark_display_name_text_style.font_size = 24
mark_display_name_text_style.text_color = Color.terminal_text_header(255, true)

local bar_size = {
	1300,
	17,
}
local reward_field_size = {
	bar_size[1] + 300,
	198,
}
local item_size = ViewElementWintrackSettings.item_size
local reward_size = {
	155,
	186,
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	pivot = {
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
	reward_field = {
		horizontal_alignment = "center",
		parent = "pivot",
		vertical_alignment = "bottom",
		size = reward_field_size,
		position = {
			0,
			-95,
			2,
		},
	},
	experience_bar_frame = {
		horizontal_alignment = "center",
		parent = "reward_field",
		vertical_alignment = "bottom",
		size = {
			1420,
			34,
		},
		position = {
			0,
			-10,
			3,
		},
	},
	reward_progress_bar = {
		horizontal_alignment = "center",
		parent = "reward_field",
		vertical_alignment = "bottom",
		size = bar_size,
		position = {
			0,
			-22,
			6,
		},
	},
	experience_progress_bar = {
		horizontal_alignment = "center",
		parent = "reward_field",
		vertical_alignment = "bottom",
		size = bar_size,
		position = {
			0,
			-22,
			5,
		},
	},
	reward_mask = {
		horizontal_alignment = "center",
		parent = "reward_progress_bar",
		vertical_alignment = "bottom",
		size = {
			bar_size[1] - 200,
			reward_size[2] + 150,
		},
		position = {
			0,
			100,
			1,
		},
	},
	reward_interaction = {
		horizontal_alignment = "center",
		parent = "reward_progress_bar",
		vertical_alignment = "bottom",
		size = {
			bar_size[1] - 200,
			reward_size[2] + 150,
		},
		position = {
			0,
			100,
			1,
		},
	},
	reward = {
		horizontal_alignment = "left",
		parent = "reward_progress_bar",
		vertical_alignment = "bottom",
		size = reward_size,
		position = {
			0,
			5,
			10,
		},
	},
	reward_item = {
		horizontal_alignment = "center",
		parent = "reward",
		vertical_alignment = "center",
		size = item_size,
		position = {
			0,
			-10,
			3,
		},
	},
	claim_button = {
		horizontal_alignment = "left",
		parent = "reward_field",
		vertical_alignment = "bottom",
		size = {
			232,
			52,
		},
		position = {
			9,
			-6,
			33,
		},
	},
	page_thumb_indicator = {
		horizontal_alignment = "center",
		parent = "reward_progress_bar",
		vertical_alignment = "bottom",
		size = {
			0,
			0,
		},
		position = {
			0,
			30,
			15,
		},
	},
	navigation_arrow_left = {
		horizontal_alignment = "left",
		parent = "page_thumb_indicator",
		vertical_alignment = "center",
		size = {
			35,
			35,
		},
		position = {
			-80,
			0,
			30,
		},
	},
	navigation_arrow_right = {
		horizontal_alignment = "right",
		parent = "page_thumb_indicator",
		vertical_alignment = "center",
		size = {
			35,
			35,
		},
		position = {
			80,
			0,
			30,
		},
	},
	item_stats_pivot = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			0,
			170,
			1,
		},
	},
	reward_input_description = {
		horizontal_alignment = "center",
		parent = "item_stats_pivot",
		vertical_alignment = "bottom",
		size = {
			800,
			40,
		},
		position = {
			0,
			75,
			1,
		},
	},
	tooltip = {
		horizontal_alignment = "center",
		parent = "pivot",
		vertical_alignment = "bottom",
		size = {
			700,
			200,
		},
		position = {
			0,
			-360,
			50,
		},
	},
}
local widget_definitions = {
	reward_input_description = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = {
				drop_shadow = true,
				font_size = 28,
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					0,
					0,
					1,
				},
			},
		},
	}, "reward_input_description"),
	navigation_arrow_left = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
		},
		{
			pass_type = "texture_uv",
			style_id = "arrow",
			value = "content/ui/materials/buttons/premium_store_button_next_page",
			value_id = "arrow",
			style = {
				uvs = {
					{
						1,
						0,
					},
					{
						0,
						1,
					},
				},
			},
			visibility_function = function (content, style)
				local hotspot = content.hotspot

				return not hotspot.is_selected and not hotspot.is_hover and not hotspot.is_focused
			end,
		},
		{
			pass_type = "texture_uv",
			style_id = "arrow_active",
			value = "content/ui/materials/buttons/premium_store_button_next_page_hover",
			value_id = "arrow_active",
			style = {
				uvs = {
					{
						1,
						0,
					},
					{
						0,
						1,
					},
				},
			},
			visibility_function = function (content, style)
				local hotspot = content.hotspot

				return hotspot.is_selected or hotspot.is_hover or hotspot.is_focused
			end,
		},
	}, "navigation_arrow_left"),
	navigation_arrow_right = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
		},
		{
			pass_type = "texture",
			style_id = "arrow",
			value = "content/ui/materials/buttons/premium_store_button_next_page",
			value_id = "arrow",
			visibility_function = function (content, style)
				local hotspot = content.hotspot

				return not hotspot.is_selected and not hotspot.is_hover and not hotspot.is_focused
			end,
		},
		{
			pass_type = "texture",
			style_id = "arrow_active",
			value = "content/ui/materials/buttons/premium_store_button_next_page_hover",
			value_id = "arrow_active",
			visibility_function = function (content, style)
				local hotspot = content.hotspot

				return hotspot.is_selected or hotspot.is_hover or hotspot.is_focused
			end,
		},
	}, "navigation_arrow_right"),
	reward_field = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "bg",
			value = "content/ui/materials/frames/achievements/wintrack_frame_background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					1286,
					146,
				},
				offset = {
					0,
					-35,
					0,
				},
				material_values = {
					texture_map = "content/ui/textures/frames/mastery_tree/wintrack_frame_background",
				},
			},
		},
	}, "reward_field"),
	experience_bar_frame = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/mastery_tree/wintrack_frame_progress_bar_holder",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					1,
				},
				color = Color.white(255, true),
			},
		},
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					nil,
					15,
				},
				color = Color.black(255, true),
				offset = {
					0,
					-3,
					-3,
				},
			},
		},
	}, "experience_bar_frame"),
	experience_progress_bar = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "bar",
			value = "content/ui/materials/bars/exp_fill",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				color = Color.terminal_text_body_sub_header(255, true),
				size = {
					0,
				},
				size_addition = {
					0,
					-4,
				},
				offset = {
					0,
					0,
					0,
				},
				material_values = {
					progress = 1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "outer_glow",
			value = "content/ui/materials/frames/dropshadow_heavy",
			style = {
				horizontal_alignment = "left",
				scale_to_material = true,
				vertical_alignment = "center",
				size = {
					0,
				},
				offset = {
					-10,
					1,
					0,
				},
				color = Color.terminal_text_body_sub_header(0, true),
				size_addition = {
					20,
					14,
				},
			},
		},
	}, "experience_progress_bar"),
	reward_progress_bar = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "bar",
			value = "content/ui/materials/bars/exp_fill",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				color = Color.terminal_corner_selected(255, true),
				size = {
					0,
				},
				size_addition = {
					0,
					-4,
				},
				offset = {
					0,
					0,
					0,
				},
				material_values = {
					progress = 1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "outer_glow",
			value = "content/ui/materials/frames/dropshadow_heavy",
			style = {
				horizontal_alignment = "left",
				scale_to_material = true,
				vertical_alignment = "center",
				size = {
					0,
				},
				offset = {
					-10,
					1,
					0,
				},
				color = Color.terminal_text_key_value(0, true),
				size_addition = {
					20,
					14,
				},
			},
		},
	}, "reward_progress_bar"),
	tooltip = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.black(150, true),
				size_addition = {
					20,
					20,
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
					0,
				},
				size_addition = {
					40,
					40,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "description",
			value = "",
			value_id = "description",
			style = {
				horizontal_alignment = "left",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "top",
				vertical_alignment = "top",
				text_color = Color.white(255, true),
				size_addition = {
					-40,
					0,
				},
				offset = {
					20,
					0,
					2,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "title",
			value = "",
			value_id = "title",
			style = mark_display_name_text_style,
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value = nil,
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				unlock_color = Color.terminal_text_key_value(255, true),
				locked_color = Color.white(100, true),
				default_color = Color.white(255, true),
				color = Color.white(255, true),
				offset = {
					0,
					20,
					5,
				},
			},
			visibility_function = function (content, style)
				return not not content.icon
			end,
		},
	}, "tooltip", {
		visible = false,
	}),
}
local page_thumb_size = ViewElementWintrackSettings.page_thumb_size
local page_thumb_widget_definition = UIWidget.create_definition({
	{
		pass_type = "rect",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_frame(nil, true),
			size = page_thumb_size,
			offset = {
				0,
				0,
				0,
			},
		},
	},
	{
		pass_type = "rect",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.terminal_icon(255, true),
			size = page_thumb_size,
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
		value = "content/ui/materials/frames/frame_glow_01",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			color = Color.terminal_icon(150, true),
			size = page_thumb_size,
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
			return content.active
		end,
	},
}, "page_thumb_indicator")
local reward_base_pass_template = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style_id = "hotspot",
		content = {},
		style = {
			anim_select_speed = 4,
		},
	},
	{
		pass_type = "texture",
		style_id = "claim_icon_glow",
		value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_background_glow",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size_addition = {
				140,
				140,
			},
			color = Color.ui_terminal(255, true),
			offset = {
				0,
				-10,
				0,
			},
		},
		visibility_function = function (content, style)
			return content.can_claim and not content.claimed
		end,
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/buttons/mastery_tree/wintrack_reward_holder",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			offset = {
				0,
				-2,
				1,
			},
			material_values = {
				background_intensity = 0,
			},
		},
		change_function = function (content, style)
			if content.claimed then
				style.material_values.background_intensity = -0.12
			else
				style.material_values.background_intensity = 0
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
				-22,
				30,
				24,
			},
		},
		visibility_function = function (content, style)
			return content.claimed
		end,
		change_function = ButtonPassTemplates.terminal_button_change_function,
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
				-26,
				29,
				25,
			},
		},
		visibility_function = function (content, style)
			return content.claimed
		end,
		change_function = ButtonPassTemplates.terminal_button_change_function,
	},
	{
		pass_type = "texture",
		style_id = "completed_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			size = {
				110,
				110,
			},
			offset = {
				0,
				-48,
				2,
			},
			color = Color.terminal_frame_selected(200, true),
		},
		visibility_function = function (content, style)
			return content.claimed
		end,
	},
	{
		pass_type = "texture",
		style_id = "reward_count_bg",
		value = "content/ui/materials/gradients/gradient_horizontal",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = {
				255,
				0,
				0,
				0,
			},
			size = {
				60,
				30,
			},
			offset = {
				26,
				32,
				20,
			},
		},
		visibility_function = function (content, style)
			return content.reward_count ~= ""
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/base/ui_default_base",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				155,
				186,
			},
			default_color = Color.terminal_frame(180, true),
			selected_color = Color.terminal_frame_selected(180, true),
			disabled_color = Color.ui_grey_medium(180, true),
			hover_color = Color.terminal_corner_hover(180, true),
			color = Color.terminal_completed(180, true),
			offset = {
				0,
				0,
				1,
			},
			material_values = {
				texture_map = "content/ui/textures/buttons/mastery_tree/wintrack_reward_holder_mask_inner",
			},
		},
		visibility_function = function (content, style)
			return content.hotspot.is_hover or content.hotspot.is_selected
		end,
		change_function = ButtonPassTemplates.terminal_button_change_function,
	},
	{
		pass_type = "text",
		style_id = "reward_count",
		value = "",
		value_id = "reward_count",
		style = {
			drop_shadow = true,
			font_size = 20,
			font_type = "proxima_nova_bold",
			text_horizontal_alignment = "right",
			text_vertical_alignment = "center",
			text_color = Color.terminal_text_key_value(nil, true),
			offset = {
				-30,
				31,
				25,
			},
		},
	},
	{
		pass_type = "text",
		style_id = "required_points",
		value = "00000",
		value_id = "required_points",
		style = {
			font_size = 16,
			font_type = "proxima_nova_bold",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "bottom",
			text_color = Color.terminal_text_header(255, true),
			offset = {
				0,
				-24,
				25,
			},
		},
	},
}
local claim_button_pass_template = table.clone(ButtonPassTemplates.terminal_button)

claim_button_pass_template[#claim_button_pass_template + 1] = {
	pass_type = "texture",
	style_id = "button_attention",
	value = "content/ui/materials/effects/button_attention",
	style = {
		horizontal_alignment = "center",
		play_pulse = false,
		scale_to_material = true,
		vertical_alignment = "center",
		color = Color.terminal_frame_hover(0, true),
		offset = {
			0,
			0,
			2,
		},
		material_values = {
			intensity = 0,
		},
	},
	visibility_function = function (content, style)
		return style.play_pulse
	end,
}
claim_button_pass_template[#claim_button_pass_template + 1] = {
	pass_type = "texture",
	style_id = "inner_frame_glow",
	value = "content/ui/materials/frames/inner_shadow_sharp",
	style = {
		horizontal_alignment = "center",
		play_pulse = false,
		scale_to_material = true,
		vertical_alignment = "center",
		color = Color.terminal_corner_hover(255, true),
		offset = {
			0,
			0,
			2,
		},
	},
	visibility_function = function (content, style)
		return style.play_pulse
	end,
	change_function = function (content, style)
		local alpha = 0

		if style.play_pulse then
			local speed = 0.8
			local pulse_progress = Application.time_since_launch() * speed % 1
			local pulse_anim_progress = (pulse_progress * 2 - 1)^2
			local alpha_multiplier = 0.6 + pulse_anim_progress * 0.4

			alpha = 255 * alpha_multiplier
		end

		style.color[1] = alpha
	end,
}

local front_widget_definitions = {
	reward_field_2 = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "corner_left",
			value = "content/ui/materials/frames/mastery_tree/wintrack_frame_corner_left",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					276,
					228,
				},
				offset = {
					-21,
					9,
					30,
				},
			},
			visibility_function = function (content, style)
				return not content.read_only
			end,
		},
		{
			pass_type = "texture",
			style_id = "corner_left",
			value = "content/ui/materials/effects/mastery_tree/wintrack_frame_corner_left_candles",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					276,
					228,
				},
				offset = {
					0,
					16,
					31,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "corner_right",
			value = "content/ui/materials/frames/mastery_tree/wintrack_frame_corner_right",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				size = {
					260,
					228,
				},
				offset = {
					0,
					17,
					30,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "corner_left_read_only",
			value = "content/ui/materials/frames/mastery_tree/wintrack_frame_corner_left",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					276,
					228,
				},
				offset = {
					0,
					17,
					30,
				},
			},
			visibility_function = function (content, style)
				return content.read_only
			end,
		},
	}, "reward_field"),
	claim_button = UIWidget.create_definition(claim_button_pass_template, "claim_button", {
		gamepad_action = "hotkey_menu_special_2",
		original_text = Utf8.upper(Localize("loc_penance_menu_claim_button")),
		hotspot = {
			on_pressed_sound = UISoundEvents.default_click,
		},
	}, nil, {
		text = {
			font_size = 22,
			line_spacing = 0.8,
			offset = {
				10,
				0,
				6,
			},
			size_addition = {
				-20,
				0,
			},
		},
	}),
}
local animations = {
	on_points_added = {
		{
			end_time = 0.3,
			name = "in",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.ease_in_exp(progress)

				widgets.experience_progress_bar.style.outer_glow.color[1] = anim_progress * 200

				if not params.anim_only_experience_bar then
					widgets.reward_progress_bar.style.outer_glow.color[1] = anim_progress * 200
				end
			end,
		},
		{
			end_time = 1.9,
			name = "out",
			start_time = 1.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.ease_in_exp(1 - progress)

				widgets.experience_progress_bar.style.outer_glow.color[1] = anim_progress * 200

				if not params.anim_only_experience_bar then
					widgets.reward_progress_bar.style.outer_glow.color[1] = anim_progress * 200
				end
			end,
		},
	},
	activate_claim_button = {
		{
			end_time = 0.2,
			name = "fade_in",
			start_time = 0,
			init = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				widgets.claim_button.style.inner_frame_glow.play_pulse = true
				widgets.claim_button.style.button_attention.play_pulse = true
			end,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				widgets.claim_button.style.button_attention.color[1] = 255 * progress
			end,
		},
		{
			end_time = 1,
			name = "intensity",
			start_time = 0,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				widgets.claim_button.style.button_attention.material_values.intensity = 1 - math.ease_sine(progress)
			end,
		},
		{
			end_time = 2,
			name = "fade_out",
			start_time = 0.8,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				widgets.claim_button.style.button_attention.color[1] = 255 - 255 * math.easeOutCubic(progress)
			end,
		},
	},
	deactivate_claim_button = {
		{
			end_time = 0.1,
			name = "disable_pulse",
			start_time = 0,
			init = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				widgets.claim_button.style.inner_frame_glow.play_pulse = false
				widgets.claim_button.style.button_attention.play_pulse = true
			end,
		},
	},
}

return {
	animations = animations,
	reward_base_pass_template = reward_base_pass_template,
	page_thumb_widget_definition = page_thumb_widget_definition,
	widget_definitions = widget_definitions,
	front_widget_definitions = front_widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
