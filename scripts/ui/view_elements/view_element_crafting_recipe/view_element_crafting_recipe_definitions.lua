-- chunkname: @scripts/ui/view_elements/view_element_crafting_recipe/view_element_crafting_recipe_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local scenegraph_definition = {
	grid_divider_top_border = {
		horizontal_alignment = "center",
		parent = "grid_divider_top",
		vertical_alignment = "top",
		size = {
			480,
			140,
		},
		position = {
			0,
			-100,
			12,
		},
	},
	grid_divider_bottom = {
		horizontal_alignment = "center",
		parent = "grid_background",
		vertical_alignment = "bottom",
		size = {
			480,
			124,
		},
		position = {
			0,
			100,
			15,
		},
	},
	crafting_recipe_background = {
		horizontal_alignment = "center",
		parent = "grid_divider_top_border",
		vertical_alignment = "top",
		size = {
			890,
			620,
		},
		position = {
			5,
			-400,
			-50,
		},
	},
	continue_button_background = {
		horizontal_alignment = "center",
		parent = "grid_divider_bottom",
		vertical_alignment = "bottom",
		size = {
			440,
			65,
		},
		position = {
			0,
			-38,
			-12,
		},
	},
	continue_button = {
		horizontal_alignment = "center",
		parent = "grid_divider_bottom",
		vertical_alignment = "bottom",
		size = {
			420,
			50,
		},
		position = {
			0,
			-47,
			30,
		},
	},
	cost_background = {
		horizontal_alignment = "center",
		parent = "grid_divider_bottom",
		vertical_alignment = "bottom",
		size = {
			200,
			36,
		},
		position = {
			0,
			6,
			30,
		},
	},
	cost_pivot = {
		horizontal_alignment = "center",
		parent = "cost_background",
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
}
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

local widget_definitions = {
	grid_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					18,
					16,
				},
				color = Color.terminal_grid_background(255, true),
			},
		},
		{
			pass_type = "texture",
			scenegraph_id = "crafting_recipe_background",
			style_id = "crafting_recipe_background",
			value = "content/ui/materials/effects/crafting_recipe_background",
			style = {
				material_values = {
					intensity = 0,
					intensity_boost = 0,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "screen",
			style = {
				offset = {
					0,
					0,
					-1,
				},
				color = Color.terminal_frame(50, true),
			},
		},
	}, "grid_background"),
	grid_divider_top = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "texture",
			value = "content/ui/materials/frames/crafting_recipe_top",
			value_id = "texture",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
			},
		},
		{
			pass_type = "texture",
			style_id = "texture_effect",
			value = "content/ui/materials/effects/crafting_recipe_top_candles",
			value_id = "texture_effect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				offset = {
					0,
					0,
					1,
				},
			},
		},
	}, "grid_divider_top_border"),
	grid_divider_bottom = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "texture",
			value = "content/ui/materials/frames/crafting_recipe_bottom",
			value_id = "texture",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
			},
		},
	}, "grid_divider_bottom"),
	cost_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/pricetag",
			value_id = "currency_background",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.white(255, true),
				offset = {
					0,
					0,
					0,
				},
				size_addition = {
					130,
					0,
				},
			},
		},
	}, "cost_background"),
	continue_button = UIWidget.create_definition(continue_button_pass_template, "continue_button", {
		gamepad_action = "hotkey_menu_special_2",
		hotspot = {
			on_pressed_sound = UISoundEvents.default_click,
		},
	}),
	continue_button_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					25,
					25,
				},
				color = Color.terminal_grid_background(255, true),
			},
		},
	}, "continue_button_background"),
}
local cost_text_font_style = table.clone(UIFontSettings.currency_title)

cost_text_font_style.text_horizontal_alignment = "left"
cost_text_font_style.text_vertical_alignment = "center"
cost_text_font_style.font_size = 20

local cost_definitions = UIWidget.create_definition({
	{
		pass_type = "texture",
		style_id = "texture",
		value = "content/ui/materials/icons/currencies/marks_small",
		value_id = "texture",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			size = {
				28,
				20,
			},
			offset = {
				0,
				0,
				1,
			},
		},
	},
	{
		pass_type = "text",
		style_id = "text",
		value = "0",
		value_id = "text",
		style = cost_text_font_style,
	},
}, "cost_pivot")
local animations = {
	activate_continue_button = {
		{
			end_time = 0.2,
			name = "fade_in",
			start_time = 0,
			init = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				widgets.continue_button.style.inner_frame_glow.play_pulse = true
				widgets.continue_button.style.button_attention.play_pulse = true
			end,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				widgets.continue_button.style.button_attention.color[1] = 255 * progress
			end,
		},
		{
			end_time = 1,
			name = "intensity",
			start_time = 0,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				widgets.continue_button.style.button_attention.material_values.intensity = 1 - math.ease_sine(progress)
			end,
		},
		{
			end_time = 2,
			name = "fade_out",
			start_time = 0.8,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				widgets.continue_button.style.button_attention.color[1] = 255 - 255 * math.easeOutCubic(progress)
			end,
		},
	},
	deactivate_continue_button = {
		{
			end_time = 0.1,
			name = "disable_pulse",
			start_time = 0,
			init = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				widgets.continue_button.style.inner_frame_glow.play_pulse = false
				widgets.continue_button.style.button_attention.play_pulse = true
			end,
		},
	},
	on_enter = {
		{
			end_time = 0.75,
			name = "intensity",
			start_time = 0,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				widgets.grid_background.style.crafting_recipe_background.material_values.intensity = math.ease_sine(progress)
			end,
		},
	},
	on_craft = {
		{
			end_time = 0.5,
			name = "intensity_boost_increase",
			start_time = 0,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				widgets.grid_background.style.crafting_recipe_background.material_values.intensity_boost = math.ease_sine(progress)
			end,
		},
		{
			end_time = 4,
			name = "intensity_boost_decrease",
			start_time = 1,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				widgets.grid_background.style.crafting_recipe_background.material_values.intensity_boost = 1 - math.ease_sine(progress)
			end,
		},
	},
}

return {
	cost_definitions = cost_definitions,
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	animations = animations,
}
