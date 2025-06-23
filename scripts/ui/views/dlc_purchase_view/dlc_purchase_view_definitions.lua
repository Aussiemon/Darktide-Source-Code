-- chunkname: @scripts/ui/views/dlc_purchase_view/dlc_purchase_view_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local Colors = require("scripts/utilities/ui/colors")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local background_icon_size = 1250
local group_header_font_style = table.clone(UIFontSettings.header_3)

group_header_font_style.offset = {
	0,
	0,
	3
}
group_header_font_style.text_horizontal_alignment = "center"
group_header_font_style.text_vertical_alignment = "center"
group_header_font_style.text_color = Color.ui_grey_light(255, true)

local sub_header_font_style = table.clone(UIFontSettings.header_3)

sub_header_font_style.offset = {
	0,
	0,
	3
}
sub_header_font_style.font_size = 18
sub_header_font_style.text_horizontal_alignment = "center"
sub_header_font_style.text_vertical_alignment = "center"
sub_header_font_style.text_color = Color.ui_grey_medium(255, true)

local item_header_text_style = table.clone(UIFontSettings.body)

item_header_text_style.text_horizontal_alignment = "left"
item_header_text_style.text_vertical_alignment = "bottom"
item_header_text_style.horizontal_alignment = "center"
item_header_text_style.vertical_alignment = "center"
item_header_text_style.offset = {
	10,
	-55,
	4
}
item_header_text_style.size_addition = {
	-20,
	0
}
item_header_text_style.text_color = Color.terminal_text_header(255, true)
item_header_text_style.font_size = 24

local aquila_header_text_style = table.clone(item_header_text_style)

aquila_header_text_style.text_vertical_alignment = "top"
aquila_header_text_style.text_horizontal_alignment = "center"
aquila_header_text_style.vertical_alignment = "top"
aquila_header_text_style.font_size = 36
aquila_header_text_style.offset = {
	0,
	3,
	4
}
aquila_header_text_style.size_addition = {
	0,
	0
}

local item_header_premium_text_style = table.clone(UIFontSettings.header_1)

item_header_premium_text_style.material = "content/ui/materials/font_gradients/slug_font_gradient_plasteel"
item_header_premium_text_style.text_color = Color.white(255, true)
item_header_premium_text_style.text_horizontal_alignment = "right"
item_header_premium_text_style.text_vertical_alignment = "bottom"
item_header_premium_text_style.horizontal_alignment = "center"
item_header_premium_text_style.vertical_alignment = "center"
item_header_premium_text_style.offset = {
	-20,
	-50,
	4
}
item_header_premium_text_style.size_addition = {
	-20,
	0
}
item_header_premium_text_style.font_size = 48

local item_sub_header_text_style = table.clone(UIFontSettings.body_small)

item_sub_header_text_style.text_horizontal_alignment = "right"
item_sub_header_text_style.text_vertical_alignment = "bottom"
item_sub_header_text_style.horizontal_alignment = "center"
item_sub_header_text_style.vertical_alignment = "center"
item_sub_header_text_style.offset = {
	-20,
	-25,
	4
}
item_sub_header_text_style.size_addition = {
	-20,
	0
}
item_sub_header_text_style.text_color = Color.ui_grey_light(255, true)
item_sub_header_text_style.font_size = 32

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

local timer_text_style = table.clone(UIFontSettings.body_small)

timer_text_style.text_horizontal_alignment = "left"
timer_text_style.text_vertical_alignment = "bottom"
timer_text_style.text_color = Color.ui_grey_light(255, true)
timer_text_style.default_text_color = Color.ui_grey_light(255, true)
timer_text_style.hover_color = {
	255,
	255,
	255,
	255
}
timer_text_style.offset = {
	30,
	-15,
	5
}
timer_text_style.horizontal_alignment = "center"
timer_text_style.vertical_alignment = "center"

local wait_reason_style = table.clone(UIFontSettings.header_1)

wait_reason_style.font_size = 30
wait_reason_style.text_horizontal_alignment = "center"
wait_reason_style.text_vertical_alignment = "center"
wait_reason_style.offset = {
	0,
	100,
	0
}

local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	top_panel = UIWorkspaceSettings.top_panel,
	canvas = UIWorkspaceSettings.area_wide,
	background_icon = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			background_icon_size,
			background_icon_size
		},
		position = {
			0,
			0,
			1
		}
	},
	center = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			300,
			300
		},
		position = {
			0,
			0,
			0
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
	category_panel_pivot = {
		vertical_alignment = "top",
		parent = "screen",
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
	standard_dlc_button_area = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			688,
			632
		},
		position = {
			-377,
			0,
			2
		}
	},
	deluxe_dlc_button_area = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			688,
			632
		},
		position = {
			377,
			0,
			2
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
	}
}
local dlc_button_pass_template = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		content = {
			use_is_focused = true
		},
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_click
		}
	},
	{
		pass_type = "texture",
		style_id = "highlight",
		value = "content/ui/materials/frames/dropshadow_medium",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = Color.ui_terminal(255, true),
			offset = {
				0,
				0,
				0
			},
			size_addition = {
				20,
				20
			}
		},
		change_function = function (content, style, _, dt)
			local hotspot = content.hotspot
			local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)

			style.color[1] = 255 * math.easeOutCubic(progress)

			local style_size_additon = style.size_addition

			style_size_additon[1] = 20 + 20 * math.easeInCubic(1 - progress)
			style_size_additon[2] = 20 + 20 * math.easeInCubic(1 - progress)
		end
	},
	{
		pass_type = "texture",
		style_id = "line",
		value = "content/ui/materials/frames/line_medium",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.black(0, true),
			color = Color.black(255, true),
			hover_color = Color.terminal_corner_selected(255, true),
			offset = {
				0,
				0,
				5
			},
			size_addition = {
				0,
				-8
			}
		},
		change_function = function (content, style, _, dt)
			local hotspot = content.hotspot
			local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
			local default_color = style.default_color
			local hover_color = style.hover_color
			local color = style.color

			Colors.color_lerp(default_color, hover_color, progress, color)
		end
	},
	{
		value_id = "title_background",
		style_id = "title_background",
		pass_type = "texture",
		value = "content/ui/materials/masks/gradient_horizontal",
		style = {
			vertical_alignment = "top",
			scale_to_material = true,
			horizontal_alignment = "top",
			color = Color.black(153, true),
			size = {
				nil,
				0
			},
			offset = {
				0,
				20,
				3
			}
		}
	},
	{
		value_id = "title",
		pass_type = "text",
		style_id = "title",
		value = "<Title>",
		style = item_header_premium_text_style
	},
	{
		value_id = "sub_title",
		pass_type = "text",
		style_id = "sub_title",
		value = "<Sub Title>",
		style = item_sub_header_text_style
	},
	{
		value_id = "divider_top",
		style_id = "divider_top",
		pass_type = "texture",
		value = "content/ui/materials/frames/premium_store/offer_card_upper_special_1",
		style = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			scale_to_material = true,
			size = {
				nil,
				46.199999999999996
			},
			offset = {
				0,
				-20,
				6
			},
			size_addition = {
				8,
				0
			},
			material_values = {
				gunge_size = {
					147,
					46.199999999999996
				}
			}
		}
	},
	{
		value_id = "divider_bottom",
		style_id = "divider_bottom",
		pass_type = "texture",
		value = "content/ui/materials/frames/premium_store/offer_card_lower_special_1",
		style = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			scale_to_material = true,
			size = {
				nil,
				42
			},
			offset = {
				0,
				14,
				6
			},
			size_addition = {
				8,
				0
			}
		}
	},
	{
		value_id = "background",
		style_id = "background",
		pass_type = "texture",
		value = "content/ui/materials/backgrounds/terminal_basic",
		style = {
			vertical_alignment = "center",
			hdr = false,
			scale_to_material = true,
			horizontal_alignment = "center",
			offset = {
				0,
				0,
				0
			},
			color = Color.terminal_frame(255, true),
			size_addition = {
				25,
				20
			}
		},
		visibility_function = function (content, style)
			return not content.has_media
		end
	},
	{
		style_id = "texture",
		pass_type = "texture_uv",
		value = "content/ui/materials/icons/offer_cards/offer_card_container",
		value_id = "texture",
		style = {
			vertical_alignment = "center",
			hdr = false,
			horizontal_alignment = "center",
			offset = {
				0,
				0,
				1
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
			},
			material_values = {
				shine = 0
			}
		},
		visibility_function = function (content, style)
			return not not style.material_values and not not style.material_values.main_texture
		end,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
			local min_uv = 0.95
			local max_uv = 1
			local start_uv = 0
			local end_uv = 1
			local current_uv = (max_uv - min_uv) * progress * 0.5

			style.uvs[1][1] = start_uv + current_uv
			style.uvs[1][2] = start_uv + current_uv
			style.uvs[2][1] = end_uv - current_uv
			style.uvs[2][2] = end_uv - current_uv
		end
	},
	{
		value_id = "icon",
		style_id = "icon",
		pass_type = "texture",
		value = "content/ui/materials/icons/items/containers/item_container_landscape_no_rarity",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			material_values = {
				use_placeholder_texture = 1
			},
			offset = {
				0,
				0,
				1
			},
			size = {
				192,
				128
			},
			size_addition = {
				0,
				0
			}
		},
		visibility_function = function (content, style)
			return content.item
		end
	}
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				size_addition = {
					40,
					40
				},
				offset = {
					0,
					0,
					0
				},
				color = Color.terminal_grid_background_gradient(255, true)
			}
		}
	}, "screen"),
	background_icon = UIWidget.create_definition({
		{
			value = "content/ui/vector_textures/symbols/cog_skull_01",
			pass_type = "slug_icon",
			style = {
				offset = {
					0,
					0,
					1
				},
				color = {
					40,
					0,
					0,
					0
				}
			}
		}
	}, "background_icon"),
	corner_top_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_upper_left"
		}
	}, "corner_top_left"),
	corner_top_right = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/premium_upper_left",
			pass_type = "texture_uv",
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
			}
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
	dlc_name_title = UIWidget.create_definition({
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
			value = "content/ui/materials/effects/terminal_header_glow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.terminal_frame(255, true)
			}
		},
		{
			value = "DLC NAME",
			value_id = "text",
			pass_type = "text",
			style = emporium_font_style
		}
	}, "screen"),
	standard_dlc_button = UIWidget.create_definition(table.clone(dlc_button_pass_template), "standard_dlc_button_area"),
	deluxe_dlc_button = UIWidget.create_definition(table.clone(dlc_button_pass_template), "deluxe_dlc_button_area"),
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
		},
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = wait_reason_style
		}
	}, "loading", {
		visible = false
	})
}
local legend_inputs = {
	{
		input_action = "back",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment",
		on_pressed_callback = "_cb_on_back_pressed",
		visibility_function = function (parent)
			return true
		end
	},
	{
		input_action = "confirm_pressed",
		display_name = "loc_dlc_store_popup_confirm",
		alignment = "left_alignment",
		visibility_function = function (parent)
			return not parent._using_cursor_navigation
		end
	}
}
local animations = {
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
