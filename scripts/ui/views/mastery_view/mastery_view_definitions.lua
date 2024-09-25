-- chunkname: @scripts/ui/views/mastery_view/mastery_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			3,
		},
	},
	background_plaque = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			1766,
			706,
		},
		position = {
			0,
			88,
			1,
		},
	},
	milestones_grid_pivot = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "bottom",
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
	traits_grid_pivot = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			564,
			224,
			1,
		},
	},
	button = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = ButtonPassTemplates.default_button.size,
		position = {
			-300,
			-100,
			1,
		},
	},
	mastery_unlock_bar = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			364,
			364,
		},
		position = {
			161,
			196,
			1,
		},
	},
	mastery_unlock_node = {
		horizontal_alignment = "center",
		parent = "mastery_unlock_bar",
		vertical_alignment = "center",
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
	mastery_points = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			255,
			120,
		},
		position = {
			210,
			590,
			2,
		},
	},
	tooltip = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			460,
			200,
		},
		position = {
			0,
			0,
			100,
		},
	},
	mastery_level = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			232,
			76,
		},
		position = {
			190,
			-85,
			100,
		},
	},
	loading = {
		horizontal_alignment = "center",
		scale = "fit",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			200,
		},
	},
}
local area_size = {
	460,
	400,
}
local icon_size = {
	150,
	50,
}
local bar_width = area_size[1] * 0.7
local continue_button_pass_template = table.clone(ButtonPassTemplates.terminal_button)

continue_button_pass_template[#continue_button_pass_template + 1] = {
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
continue_button_pass_template[#continue_button_pass_template + 1] = {
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

local weapon_trait_title_style = table.clone(UIFontSettings.header_3)

weapon_trait_title_style.offset = {
	98,
	10,
	10,
}
weapon_trait_title_style.size = {
	324,
}
weapon_trait_title_style.font_size = 18
weapon_trait_title_style.text_horizontal_alignment = "left"
weapon_trait_title_style.text_vertical_alignment = "top"
weapon_trait_title_style.text_color = {
	255,
	216,
	229,
	207,
}
weapon_trait_title_style.default_color = {
	255,
	216,
	229,
	207,
}
weapon_trait_title_style.hover_color = Color.white(255, true)
weapon_trait_title_style.disabled_color = {
	255,
	60,
	60,
	60,
}

local weapon_trait_header_style = table.clone(UIFontSettings.header_3)

weapon_trait_header_style.offset = {
	10,
	0,
	10,
}
weapon_trait_header_style.size = {
	430,
}
weapon_trait_header_style.font_size = 18
weapon_trait_header_style.text_horizontal_alignment = "left"
weapon_trait_header_style.text_vertical_alignment = "top"
weapon_trait_header_style.text_color = Color.white(255, true)

local weapon_trait_description_style = table.clone(UIFontSettings.body)

weapon_trait_description_style.offset = {
	98,
	30,
	11,
}
weapon_trait_description_style.size = {
	324,
	500,
}
weapon_trait_description_style.font_size = 18
weapon_trait_description_style.text_horizontal_alignment = "left"
weapon_trait_description_style.text_vertical_alignment = "top"
weapon_trait_description_style.text_color = Color.terminal_text_body(255, true)
weapon_trait_description_style.default_color = Color.terminal_text_body(255, true)
weapon_trait_description_style.hover_color = Color.terminal_text_header(255, true)
weapon_trait_description_style.disabled_color = {
	255,
	60,
	60,
	60,
}

local mastery_cost_style = table.clone(UIFontSettings.body)

mastery_cost_style.text_horizontal_alignment = "center"
mastery_cost_style.text_vertical_alignment = "bottom"
mastery_cost_style.offset = {
	0,
	40,
	11,
}

local required_level_text_style = table.clone(UIFontSettings.body_small)

required_level_text_style.text_horizontal_alignment = "center"
required_level_text_style.text_vertical_alignment = "center"
required_level_text_style.horizontal_alignment = "center"
required_level_text_style.vertical_alignment = "top"
required_level_text_style.font_size = 22
required_level_text_style.offset = {
	0,
	0,
	12,
}
required_level_text_style.size = {
	nil,
	50,
}
required_level_text_style.text_color = {
	255,
	159,
	67,
	67,
}

local function generate_mastery_unlock_bar_passes()
	local passes = {}
	local circle_size = {
		100,
		100,
	}
	local outer_circle_size = {
		350,
		350,
	}
	local position_by_rarity = {
		{
			0,
			-(outer_circle_size[2] * 0.5),
			2,
		},
		{
			outer_circle_size[1] * 0.5,
			0,
			2,
		},
		{
			0,
			outer_circle_size[2] * 0.5,
			2,
		},
		{
			-(outer_circle_size[1] * 0.5),
			0,
			2,
		},
	}

	passes[#passes + 1] = {
		pass_type = "texture_uv",
		style_id = "progress_bar",
		value = "content/ui/materials/bars/mastery_tree/pattern_bar_radial",
		value_id = "progress_bar",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			material_values = {
				progress = 0,
			},
			offset = {
				0,
				0,
				1,
			},
		},
	}
	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "tier_rarity",
		value = "content/ui/materials/frames/mastery_tree/pattern_tier_container",
		value_id = "tier_rarity",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				100,
				100,
			},
			material_values = {
				node_bg = "",
				tier_selected = "",
			},
			offset = {
				0,
				-35,
				2,
			},
		},
		change_function = function (content, style)
			local unlocked_rarity = content.max_unlocked_rarity

			style.material_values.node_bg = unlocked_rarity and "content/ui/textures/frames/mastery_tree/pattern_tier_" .. content.max_unlocked_rarity or ""
			style.material_values.tier_selected = unlocked_rarity and "content/ui/textures/frames/mastery_tree/pattern_tier_" .. content.max_unlocked_rarity .. "_reached" or ""
		end,
	}

	return passes
end

local widget_definitions = {
	corners = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/mastery_tree/corner_bottom_left",
			style = {
				vertical_alignment = "bottom",
				size = {
					128,
					174,
				},
				offset = {
					0,
					0,
					62,
				},
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/mastery_tree/corner_bottom_right",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				size = {
					128,
					174,
				},
				offset = {
					0,
					0,
					62,
				},
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/mastery_tree/corner_top_left",
			style = {
				vertical_alignment = "top",
				size = {
					242,
					750,
				},
				offset = {
					0,
					0,
					62,
				},
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/effects/mastery_tree/corner_top_left_candles",
			style = {
				vertical_alignment = "top",
				size = {
					242,
					750,
				},
				offset = {
					0,
					0,
					62,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/mastery_tree/corner_top_right",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "top",
				size = {
					420,
					750,
				},
				offset = {
					0,
					0,
					62,
				},
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/effects/mastery_tree/corner_top_right_candles",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "top",
				size = {
					420,
					750,
				},
				offset = {
					0,
					0,
					62,
				},
			},
		},
	}, "screen"),
	background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/mastery_tree/bg",
		},
	}, "screen"),
	screen_effects = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/masks/gradient_vignette",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {},
				color = {
					120,
					0,
					0,
					0,
				},
				offset = {
					0,
					0,
					2,
				},
			},
		},
	}, "screen"),
	background_plaque = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/mastery_tree/pattern_plaque_bg",
		},
		{
			pass_type = "texture",
			style_id = "bg_candles",
			value = "content/ui/materials/effects/mastery_tree/pattern_plaque_bg_candles",
			value_id = "bg_candles",
			style = {
				size = {
					1550,
					750,
				},
				offset = {
					153,
					-352,
					62,
				},
			},
		},
	}, "background_plaque"),
	mastery_unlock_bar = UIWidget.create_definition(generate_mastery_unlock_bar_passes(), "mastery_unlock_bar"),
	header = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "pattern_name",
			value = "",
			value_id = "pattern_name",
			style = table.merge_recursive(table.clone(UIFontSettings.header_2), {
				horizontal_alignment = "left",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				offset = {
					100,
					16,
					65,
				},
				size = {
					634,
					50,
				},
			}),
		},
		{
			pass_type = "texture",
			style_id = "pattern_nameplate",
			value = "content/ui/materials/frames/mastery_tree/pattern_nameplate",
			style = {
				horizontal_alignment = "left",
				material_values = {
					texture_map = "content/ui/textures/frames/mastery_tree/pattern_nameplate_melee",
				},
				size = {
					914,
					138,
				},
				offset = {
					0,
					0,
					64,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "pattern_icon",
			value = "content/ui/materials/base/ui_default_base",
			value_id = "pattern_icon",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				size = {
					178,
					67,
				},
				offset = {
					25,
					12,
					65,
				},
				material_values = {},
				color = {
					0,
					0,
					0,
					0,
				},
			},
			visibility_function = function (content, style)
				return not not style.material_values.texture_map
			end,
		},
	}, "screen"),
	mastery_points = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "mastery_points_text",
			value_id = "mastery_points_text",
			value = Utf8.upper(Localize("loc_mastery_reward_mastery_points")),
			style = {
				font_size = 18,
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "top",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					5,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "mastery_points_value",
			value = "",
			value_id = "mastery_points_value",
			style = {
				font_size = 50,
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					10,
					0,
				},
			},
		},
	}, "mastery_points"),
	mastery_level = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "mastery_level",
			value = "",
			value_id = "mastery_level",
			style = table.merge_recursive(table.merge_recursive(table.clone(UIFontSettings.header_2), {
				font_size = 50,
			}), {
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				offset = {
					0,
					0,
					1,
				},
			}),
		},
	}, "mastery_level", {
		visible = false,
	}),
}
local tooltip_widget_definition = UIWidget.create_definition({
	{
		pass_type = "texture",
		value = "content/ui/materials/base/ui_default_base",
		style = {
			color = Color.black(180, true),
		},
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
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			offset = {
				0,
				0,
				1,
			},
			color = Color.terminal_background(nil, true),
		},
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_vertical",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			offset = {
				0,
				0,
				2,
			},
			color = Color.terminal_background_gradient(nil, true),
		},
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
		style = {
			vertical_alignment = "top",
			offset = {
				0,
				0,
				3,
			},
			color = {
				105,
				45,
				45,
				45,
			},
		},
		visibility_function = function (content, style)
			return content.warning_message and content.warning_message ~= ""
		end,
	},
	{
		pass_type = "texture",
		style_id = "button_frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "right",
			scale_to_material = true,
			vertical_alignment = "center",
			offset = {
				0,
				0,
				3,
			},
			color = Color.terminal_frame(nil, true),
		},
	},
	{
		pass_type = "texture",
		style_id = "button_corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			horizontal_alignment = "right",
			scale_to_material = true,
			vertical_alignment = "center",
			offset = {
				0,
				0,
				4,
			},
			color = Color.terminal_corner(nil, true),
		},
	},
	{
		pass_type = "texture",
		style_id = "rarity_icon",
		value = "content/ui/materials/icons/traits/traits_container",
		style = {
			material_values = {},
			size = {
				64,
				64,
			},
			offset = {
				20,
				10,
				10,
			},
			color = Color.terminal_icon(255, true),
		},
		visibility_function = function (content, style)
			return content.has_rarity
		end,
	},
	{
		pass_type = "texture",
		style_id = "next_rarity_icon",
		value = "content/ui/materials/icons/traits/traits_container",
		style = {
			material_values = {},
			size = {
				64,
				64,
			},
			offset = {
				20,
				10,
				10,
			},
			color = Color.terminal_icon(255, true),
		},
		visibility_function = function (content, style)
			return not content.reached_max_rarity
		end,
	},
	{
		pass_type = "text",
		style_id = "rarity_header",
		value_id = "rarity_header",
		style = weapon_trait_header_style,
		value = Localize("loc_mastery_current_trait"),
		visibility_function = function (content, style)
			return content.has_rarity
		end,
	},
	{
		pass_type = "text",
		style_id = "rarity_title",
		value = "n/a",
		value_id = "rarity_title",
		style = weapon_trait_title_style,
		visibility_function = function (content, style)
			return content.has_rarity
		end,
	},
	{
		pass_type = "text",
		style_id = "rarity_description",
		value = "n/a",
		value_id = "rarity_description",
		style = weapon_trait_description_style,
		visibility_function = function (content, style)
			return content.has_rarity
		end,
	},
	{
		pass_type = "rect",
		style_id = "divider",
		style = {
			color = Color.white(255, true),
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
		visibility_function = function (content, style)
			return content.has_rarity and not content.reached_max_rarity
		end,
	},
	{
		pass_type = "text",
		style_id = "next_rarity_header",
		value_id = "next_rarity_header",
		style = weapon_trait_header_style,
		value = Localize("loc_mastery_next_trait"),
		visibility_function = function (content, style)
			return not content.reached_max_rarity
		end,
	},
	{
		pass_type = "texture",
		style_id = "warning_message_background",
		value = "content/ui/materials/backgrounds/default_square",
		value_id = "warning_message_background",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "top",
			size = {
				nil,
				50,
			},
			offset = {
				0,
				0,
				11,
			},
			color = {
				255,
				35,
				0,
				0,
			},
		},
		visibility_function = function (content, style)
			return content.warning_message and content.warning_message ~= ""
		end,
	},
	{
		pass_type = "text",
		style_id = "warning_message",
		value = "",
		value_id = "warning_message",
		style = required_level_text_style,
	},
	{
		pass_type = "text",
		style_id = "next_rarity_title",
		value = "n/a",
		value_id = "next_rarity_title",
		style = weapon_trait_title_style,
		visibility_function = function (content, style)
			return not content.reached_max_rarity
		end,
	},
	{
		pass_type = "text",
		style_id = "next_rarity_description",
		value = "n/a",
		value_id = "next_rarity_description",
		style = weapon_trait_description_style,
		visibility_function = function (content, style)
			return not content.reached_max_rarity
		end,
	},
	{
		pass_type = "text",
		style_id = "mastery_cost",
		value = "",
		value_id = "mastery_cost",
		style = {
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			offset = {
				0,
				-10,
				11,
			},
			size = {
				nil,
				50,
			},
			text_color = Color.white(255, true),
		},
		visibility_function = function (content, style)
			return not content.reached_max_rarity
		end,
	},
	{
		pass_type = "texture",
		style_id = "requirement_background",
		value = "content/ui/materials/backgrounds/default_square",
		value_id = "requirement_background",
		style = {
			vertical_alignment = "top",
			size = {
				nil,
				50,
			},
			offset = {
				0,
				0,
				10,
			},
			color = {
				150,
				0,
				0,
				0,
			},
		},
		visibility_function = function (content, style)
			return not content.reached_max_rarity
		end,
	},
}, "tooltip")
local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_settings_menu_close_menu",
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
	},
	{
		alignment = "right_alignment",
		display_name = "",
		input_action = "cycle_list_primary",
		on_pressed_callback = "cb_on_switch_focus",
		visibility_function = function (parent, id)
			local display_name = parent._wintracks_focused and "loc_mastery_blessings_select" or "loc_mastery_reward_track_select"

			parent._input_legend_element:set_display_name(id, display_name)

			return not parent._using_cursor_navigation and parent._wintrack_element
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_action_interaction_help",
		input_action = "hotkey_help",
		on_pressed_callback = "cb_on_help_pressed",
		visibility_function = function (parent)
			return parent._tutorial_overlay and not parent._tutorial_overlay:is_active()
		end,
	},
}
local node_widgets_definitions = UIWidget.create_definition({
	{
		horizontal_alignment = "center",
		pass_type = "texture",
		style_id = "mastery_unlock_node",
		value = "content/ui/materials/buttons/mastery_tree/pattern_bar_node_container",
		value_id = "mastery_unlock_node",
		vertical_alignment = "center",
		style = {
			size = {
				26,
				26,
			},
			material_values = {
				tier_icon_intensity = 1,
			},
		},
	},
}, "mastery_unlock_node")
local animations = {
	on_threshold_reached = {
		{
			end_time = 1.8,
			name = "fade_in",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local next_rarity = params.next_rarity < 4 and params.next_rarity + 1 or 4
				local progress_anim = math.easeInCubic(progress)
				local new_intensity = 1 + math.easeInCubic(progress)

				widgets.mastery_unlock_bar.style.progress_bar.material_values.tier_icon_intensity = new_intensity
				widgets.mastery_unlock_bar.style.tier_rarity.material_values.tier_icon_intensity = new_intensity

				if parent._node_widgets then
					for i = 1, #parent._node_widgets do
						local widget = parent._node_widgets[i]

						widget.style.mastery_unlock_node.material_values.tier_icon_intensity = new_intensity
					end
				end

				if params.traits then
					for i = 1, #params.traits do
						local widget = params.traits[i]
						local style = widget.style["tier_animation_" .. next_rarity]

						if style then
							style.color[1] = 255 * progress_anim
						end
					end
				end
			end,
		},
		{
			end_time = 4,
			name = "fade_out",
			start_time = 2.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local next_rarity = params.next_rarity < 4 and params.next_rarity + 1 or 4

				widgets.mastery_unlock_bar.content.max_unlocked_rarity = next_rarity
				widgets.mastery_unlock_bar.style.progress_bar.uvs = {
					{
						1,
						0,
					},
					{
						0,
						1,
					},
				}

				if next_rarity == 4 then
					parent:_play_sound(UISoundEvents.mastery_traits_rank_up_max)
				else
					parent:_play_sound(UISoundEvents.mastery_traits_rank_up)
				end
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local next_rarity = params.next_rarity < 4 and params.next_rarity + 1 or 4
				local progress_anim = math.easeInCubic(1 - progress)
				local new_intensity = 2 * progress_anim

				widgets.mastery_unlock_bar.style.progress_bar.material_values.tier_icon_intensity = 1 + progress_anim
				widgets.mastery_unlock_bar.style.progress_bar.material_values.progress = progress_anim
				widgets.mastery_unlock_bar.style.tier_rarity.material_values.tier_icon_intensity = 1 + progress_anim

				if parent._node_widgets then
					for i = 1, #parent._node_widgets do
						local widget = parent._node_widgets[i]

						widget.style.mastery_unlock_node.material_values.tier_icon_intensity = 1 + progress_anim
						widget.alpha_multiplier = progress_anim
					end
				end

				if params.traits then
					for i = 1, #params.traits do
						local widget = params.traits[i]
						local style = widget.style["tier_animation_" .. params.next_rarity + 1]

						if style then
							style.color[1] = 255 * progress_anim
						end
					end
				end

				if next_rarity == 4 then
					widgets.mastery_unlock_bar.style.progress_bar.color[1] = 255 * progress_anim
				end
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent:_setup_node_widgets()

				widgets.mastery_unlock_bar.style.progress_bar.uvs = {
					{
						0,
						0,
					},
					{
						1,
						1,
					},
				}

				if parent._node_widgets then
					for i = 1, #parent._node_widgets do
						local widget = parent._node_widgets[i]

						widget.alpha_multiplier = 0
						widget.style.mastery_unlock_node.material_values.tier_icon_intensity = 0
					end
				end
			end,
		},
		{
			end_time = 4.5,
			name = "fade_new_nodes",
			start_time = 4,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local progress_anim = math.easeInCubic(progress)

				if parent._node_widgets then
					for i = 1, #parent._node_widgets do
						local widget = parent._node_widgets[i]

						widget.alpha_multiplier = progress_anim
					end
				end
			end,
		},
	},
}
local loading_definitions = UIWidget.create_definition({
	{
		pass_type = "rect",
		style = {
			color = Color.black(127.5, true),
		},
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/loading/loading_icon",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				256,
				256,
			},
			offset = {
				0,
				0,
				1,
			},
		},
	},
}, "loading")

return {
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	legend_inputs = legend_inputs,
	tooltip_widget_definition = tooltip_widget_definition,
	node_widgets_definitions = node_widgets_definitions,
	animations = animations,
	loading_definitions = loading_definitions,
}
