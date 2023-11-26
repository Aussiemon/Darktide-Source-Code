-- chunkname: @scripts/ui/views/store_view/store_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ColorUtilities = require("scripts/utilities/ui/colors")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	grid_background = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			1700,
			800
		},
		position = {
			0,
			30,
			1
		}
	},
	grid_mask = {
		vertical_alignment = "center",
		parent = "grid_background",
		horizontal_alignment = "center",
		size = {
			1700,
			800
		},
		position = {
			0,
			0,
			10
		}
	},
	grid_interaction = {
		vertical_alignment = "center",
		parent = "grid_background",
		horizontal_alignment = "center",
		size = {
			1700,
			800
		},
		position = {
			0,
			0,
			1
		}
	},
	grid_content_pivot = {
		vertical_alignment = "left",
		parent = "grid_background",
		horizontal_alignment = "top",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	category_panel_pivot = {
		vertical_alignment = "top",
		parent = "grid_background",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-70,
			1
		}
	},
	category_panel_background = {
		vertical_alignment = "top",
		parent = "category_panel_pivot",
		horizontal_alignment = "center",
		size = {
			500,
			61
		},
		position = {
			0,
			-12,
			1
		}
	},
	page_panel_pivot = {
		vertical_alignment = "bottom",
		parent = "grid_background",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	corner_top_left = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			84,
			224
		},
		position = {
			0,
			0,
			62
		}
	},
	corner_top_right = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			120,
			224
		},
		position = {
			0,
			0,
			62
		}
	},
	corner_bottom_left = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			84,
			224
		},
		position = {
			0,
			0,
			62
		}
	},
	corner_bottom_right = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			84,
			224
		},
		position = {
			0,
			0,
			62
		}
	},
	aquila_button = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = ButtonPassTemplates.aquila_button.size,
		position = {
			-100,
			5,
			62
		}
	},
	navigation_arrow_left = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			70,
			70
		},
		position = {
			20,
			0,
			0
		}
	},
	navigation_arrow_right = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			70,
			70
		},
		position = {
			-20,
			0,
			0
		}
	},
	grid_aquilas_pivot = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			30,
			1
		}
	},
	aquilas_background = {
		vertical_alignment = "center",
		parent = "grid_aquilas_pivot",
		horizontal_alignment = "center",
		size = {
			1920,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	grid_aquilas_content = {
		vertical_alignment = "center",
		parent = "grid_aquilas_pivot",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	loading = {
		vertical_alignment = "center",
		scale = "fit",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			200
		}
	},
	wallet_element_pivot = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-50,
			105,
			0
		}
	}
}
local emporium_font_style = table.clone(UIFontSettings.header_1)

emporium_font_style.text_horizontal_alignment = "center"
emporium_font_style.text_vertical_alignment = "center"
emporium_font_style.offset = {
	0,
	0,
	1
}
emporium_font_style.size = {
	nil,
	85
}

local required_aquilas_title_style = table.clone(UIFontSettings.header_1)

required_aquilas_title_style.font_size = 40
required_aquilas_title_style.offset = {
	0,
	0,
	1
}
required_aquilas_title_style.text_horizontal_alignment = "center"
required_aquilas_title_style.text_vertical_alignment = "top"
required_aquilas_title_style.offset = {
	0,
	-55,
	2
}

local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					0
				},
				color = {
					180,
					0,
					0,
					0
				}
			}
		}
	}, "screen", {
		visible = false
	}),
	aquilas_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				color = Color.terminal_frame(255, true),
				size = {
					700,
					120
				},
				size_addition = {
					0,
					0
				},
				offset = {
					0,
					-120,
					0
				}
			}
		},
		{
			style_id = "title",
			pass_type = "text",
			value_id = "",
			style = required_aquilas_title_style,
			value = Utf8.upper(Localize("loc_premium_store_purchase_credits_storefront_button"))
		},
		{
			value_id = "top",
			style_id = "top",
			pass_type = "texture",
			value = "content/ui/materials/frames/premium_store/currency_upper",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					954,
					152
				},
				offset = {
					0,
					-152,
					1
				}
			}
		},
		{
			value_id = "bottom",
			style_id = "bottom",
			pass_type = "texture",
			value = "content/ui/materials/frames/premium_store/currency_lower",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					354,
					78
				},
				offset = {
					0,
					78,
					1
				}
			}
		}
	}, "aquilas_background", {
		visible = false
	}),
	category_panel_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				color = Color.terminal_frame(255, true),
				size_addition = {
					400,
					15
				},
				offset = {
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/premium_store/tabs",
			pass_type = "texture",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				size_addition = {
					490,
					0
				},
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "category_panel_background", {
		visible = false
	}),
	grid_interaction = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		}
	}, "grid_interaction"),
	grid_mask = UIWidget.create_definition({
		{
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
			pass_type = "texture",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = {
					255,
					255,
					255,
					255
				},
				size_addition = {
					40,
					40
				}
			}
		}
	}, "grid_mask"),
	corner_top_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_upper_left"
		}
	}, "corner_top_left"),
	corner_top_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_upper_right"
		}
	}, "corner_top_right"),
	corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_lower_left"
		}
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_lower_right"
		}
	}, "corner_bottom_right"),
	emporium = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				scale_to_material = true,
				horizontal_alignment = "center",
				color = Color.terminal_frame(255, true),
				size_addition = {
					0,
					30
				},
				size = {
					nil,
					85
				},
				offset = {
					0,
					-15,
					0
				}
			}
		},
		{
			pass_type = "text",
			value = Localize("loc_premium_store_main_title"),
			style = emporium_font_style
		}
	}, "screen"),
	aquila_button = UIWidget.create_definition(ButtonPassTemplates.aquila_button, "aquila_button", {
		gamepad_action = "hotkey_menu_special_1",
		original_text = Utf8.upper(Localize("loc_premium_store_purchase_credits_storefront_button"))
	}),
	navigation_arrow_left = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			value_id = "arrow",
			style_id = "arrow",
			pass_type = "texture_uv",
			value = "content/ui/materials/buttons/premium_store_button_next_page",
			style = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				}
			},
			visibility_function = function (content, style)
				local hotspot = content.hotspot

				return not hotspot.is_selected and not hotspot.is_hover and not hotspot.is_focused
			end
		},
		{
			value_id = "arrow_active",
			style_id = "arrow_active",
			pass_type = "texture_uv",
			value = "content/ui/materials/buttons/premium_store_button_next_page_hover",
			style = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				}
			},
			visibility_function = function (content, style)
				local hotspot = content.hotspot

				return hotspot.is_selected or hotspot.is_hover or hotspot.is_focused
			end
		}
	}, "navigation_arrow_left"),
	navigation_arrow_right = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			value_id = "arrow",
			style_id = "arrow",
			pass_type = "texture",
			value = "content/ui/materials/buttons/premium_store_button_next_page",
			visibility_function = function (content, style)
				local hotspot = content.hotspot

				return not hotspot.is_selected and not hotspot.is_hover and not hotspot.is_focused
			end
		},
		{
			value_id = "arrow_active",
			style_id = "arrow_active",
			pass_type = "texture",
			value = "content/ui/materials/buttons/premium_store_button_next_page_hover",
			visibility_function = function (content, style)
				local hotspot = content.hotspot

				return hotspot.is_selected or hotspot.is_hover or hotspot.is_focused
			end
		}
	}, "navigation_arrow_right"),
	loading = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = Color.black(127.5, true)
			}
		},
		{
			value = "content/ui/materials/loading/loading_icon",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					256,
					256
				},
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "loading", {
		visible = false
	})
}
local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "cb_on_back_pressed",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	}
}
local anim_start_delay = 0
local animations = {
	on_enter = {
		{
			name = "init",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent._alpha_multiplier = 0
			end
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
			end
		}
	},
	grid_entry = {
		{
			name = "fade_in",
			end_time = 0.5,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				for i = 1, #widgets do
					widgets[i].alpha_multiplier = anim_progress
				end
			end
		}
	},
	on_hover = {
		{
			name = "init",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				params.widget.style.texture.material_values.shine = 0
			end
		},
		{
			name = "shine",
			end_time = 2,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				params.widget.style.texture.material_values.shine = anim_progress
			end
		}
	}
}

return {
	animations = animations,
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
