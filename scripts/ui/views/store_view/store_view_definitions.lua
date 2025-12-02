-- chunkname: @scripts/ui/views/store_view/store_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
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
			0,
		},
	},
	grid_background = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			1700,
			800,
		},
		position = {
			0,
			30,
			1,
		},
	},
	grid_mask = {
		horizontal_alignment = "center",
		parent = "grid_background",
		vertical_alignment = "center",
		size = {
			1700,
			800,
		},
		position = {
			0,
			0,
			10,
		},
	},
	grid_interaction = {
		horizontal_alignment = "center",
		parent = "grid_background",
		vertical_alignment = "center",
		size = {
			1700,
			800,
		},
		position = {
			0,
			0,
			1,
		},
	},
	grid_content_pivot = {
		horizontal_alignment = "top",
		parent = "grid_background",
		vertical_alignment = "left",
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
	category_panel_pivot = {
		horizontal_alignment = "center",
		parent = "grid_background",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			-70,
			1,
		},
	},
	category_panel_background = {
		horizontal_alignment = "center",
		parent = "category_panel_pivot",
		vertical_alignment = "top",
		size = {
			500,
			61,
		},
		position = {
			0,
			-12,
			1,
		},
	},
	page_panel_pivot = {
		horizontal_alignment = "center",
		parent = "grid_background",
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
	corner_top_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			84,
			224,
		},
		position = {
			0,
			0,
			12,
		},
	},
	corner_top_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			120,
			224,
		},
		position = {
			0,
			0,
			12,
		},
	},
	corner_bottom_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			84,
			224,
		},
		position = {
			0,
			0,
			12,
		},
	},
	corner_bottom_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			84,
			224,
		},
		position = {
			0,
			0,
			12,
		},
	},
	aquila_button = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = ButtonPassTemplates.aquila_button.size,
		position = {
			-100,
			5,
			12,
		},
	},
	get_dlc_button = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = ButtonPassTemplates.aquila_button.size,
		position = {
			100,
			5,
			12,
		},
	},
	navigation_arrow_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			70,
			70,
		},
		position = {
			20,
			0,
			0,
		},
	},
	navigation_arrow_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			70,
			70,
		},
		position = {
			-20,
			0,
			0,
		},
	},
	grid_aquilas_pivot = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			0,
			30,
			1,
		},
	},
	aquilas_background = {
		horizontal_alignment = "center",
		parent = "grid_aquilas_pivot",
		vertical_alignment = "center",
		size = {
			1920,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
	grid_aquilas_content = {
		horizontal_alignment = "center",
		parent = "grid_aquilas_pivot",
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
	wallet_element_pivot = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-50,
			105,
			0,
		},
	},
}
local emporium_font_style = table.clone(UIFontSettings.header_1)

emporium_font_style.text_horizontal_alignment = "center"
emporium_font_style.text_vertical_alignment = "center"
emporium_font_style.offset = {
	0,
	0,
	1,
}
emporium_font_style.size = {
	nil,
	85,
}

local required_aquilas_title_style = table.clone(UIFontSettings.header_1)

required_aquilas_title_style.font_size = 40
required_aquilas_title_style.text_horizontal_alignment = "center"
required_aquilas_title_style.text_vertical_alignment = "top"
required_aquilas_title_style.offset = {
	0,
	-55,
	2,
}

local wait_reason_style = table.clone(UIFontSettings.header_1)

wait_reason_style.font_size = 30
wait_reason_style.text_horizontal_alignment = "center"
wait_reason_style.text_vertical_alignment = "center"
wait_reason_style.offset = {
	0,
	100,
	0,
}

local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					0,
				},
				color = {
					180,
					0,
					0,
					0,
				},
			},
		},
	}, "screen", {
		visible = false,
	}),
	aquilas_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				color = Color.terminal_frame(255, true),
				size = {
					680,
					90,
				},
				size_addition = {
					0,
					0,
				},
				offset = {
					0,
					-100,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "title",
			value_id = "",
			style = required_aquilas_title_style,
			value = Utf8.upper(Localize("loc_premium_store_purchase_credits_storefront_button")),
		},
		{
			pass_type = "texture",
			style_id = "top",
			value = "content/ui/materials/frames/premium_store/currency_upper",
			value_id = "top",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					954,
					152,
				},
				offset = {
					0,
					-152,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "bottom",
			value = "content/ui/materials/frames/premium_store/currency_lower",
			value_id = "bottom",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					354,
					78,
				},
				offset = {
					0,
					78,
					1,
				},
			},
		},
	}, "aquilas_background", {
		visible = false,
	}),
	category_panel_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.terminal_frame(255, true),
				size_addition = {
					400,
					12,
				},
				offset = {
					0,
					-3,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/premium_store/tabs",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				size_addition = {
					490,
					0,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
	}, "category_panel_background", {
		visible = false,
	}),
	grid_interaction = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
		},
	}, "grid_interaction"),
	grid_mask = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = {
					255,
					255,
					255,
					255,
				},
				size_addition = {
					40,
					40,
				},
			},
		},
	}, "grid_mask"),
	corner_top_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_upper_left",
		},
	}, "corner_top_left"),
	corner_top_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_upper_right",
		},
	}, "corner_top_right"),
	corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_lower_left",
		},
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_lower_right",
		},
	}, "corner_bottom_right"),
	emporium = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "top",
				color = Color.terminal_frame(255, true),
				size_addition = {
					0,
					30,
				},
				size = {
					nil,
					85,
				},
				offset = {
					0,
					-15,
					0,
				},
			},
		},
		{
			pass_type = "text",
			value = Localize("loc_premium_store_main_title"),
			style = emporium_font_style,
		},
	}, "screen"),
	aquila_button = UIWidget.create_definition(ButtonPassTemplates.aquila_button, "aquila_button", {
		gamepad_action = "hotkey_menu_special_1",
		original_text = Utf8.upper(Localize("loc_premium_store_purchase_credits_storefront_button")),
	}),
	get_dlc_button = UIWidget.create_definition(ButtonPassTemplates.aquila_button, "get_dlc_button", {
		gamepad_action = "hotkey_menu_special_2",
		visible = false,
		original_text = Utf8.upper(Localize("loc_dlc_cta")),
	}),
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
	loading = UIWidget.create_definition({
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
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = wait_reason_style,
		},
	}, "loading", {
		visible = false,
	}),
}
local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_settings_menu_close_menu",
		input_action = "back",
		on_pressed_callback = "cb_on_back_pressed",
		visibility_function = nil,
	},
}
local anim_start_delay = 0
local animations = {
	on_enter = {
		{
			end_time = 0,
			name = "init",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent._alpha_multiplier = 0
			end,
		},
		{
			name = "fade_in",
			start_time = anim_start_delay + 1.5,
			end_time = anim_start_delay + 2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				parent._alpha_multiplier = anim_progress
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent:_blur_fade_in(0.9, math.easeOutCubic)
				parent:_initialize_opening_page()
			end,
		},
	},
	grid_entry = {
		{
			end_time = 0.5,
			name = "fade_in",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				for i = 1, #widgets do
					widgets[i].alpha_multiplier = anim_progress
				end
			end,
		},
	},
	grid_exit = {
		{
			end_time = 0.25,
			name = "fade_out",
			start_time = 0,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				local anim_progress = 1 - math.easeOutCubic(progress)

				for i = 1, #widgets do
					widgets[i].alpha_multiplier = anim_progress
				end
			end,
		},
	},
	on_hover = {
		{
			end_time = 0,
			name = "init",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				params.widget.style.texture.material_values.shine = 0
			end,
		},
		{
			end_time = 2,
			name = "shine",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				params.widget.style.texture.material_values.shine = anim_progress
			end,
		},
	},
}

return {
	animations = animations,
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
