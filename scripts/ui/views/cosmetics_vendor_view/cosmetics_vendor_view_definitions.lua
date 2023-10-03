local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local title_height = 70
local edge_padding = 44
local grid_width = 448
local grid_height = 780
local grid_size = {
	grid_width - edge_padding,
	grid_height
}
local grid_spacing = {
	10,
	10
}
local mask_size = {
	grid_width + 40,
	grid_height
}
local grid_settings = {
	scrollbar_width = 7,
	widget_icon_load_margin = 4000,
	use_select_on_focused = true,
	cache_loaded_icons = true,
	use_is_focused_for_navigation = false,
	use_terminal_background = true,
	top_padding = 85,
	scrollbar_vertical_margin = 91,
	scrollbar_horizontal_offset = -7,
	scrollbar_vertical_offset = 48,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding
}
local weapon_stats_grid_settings = nil
local padding = 12
local width = 530
local height = 920
weapon_stats_grid_settings = {
	scrollbar_width = 7,
	ignore_blur = true,
	title_height = 70,
	grid_spacing = {
		0,
		0
	},
	grid_size = {
		width - padding,
		height
	},
	mask_size = {
		width + 40,
		height
	},
	edge_padding = padding
}
local category_button_size = {
	100,
	100
}
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
	item_grid_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			grid_width,
			grid_height
		},
		position = {
			category_button_size[1] + 50 + 50,
			170,
			1
		}
	},
	grid_tab_panel = {
		vertical_alignment = "top",
		parent = "item_grid_pivot",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-50,
			1
		}
	},
	button_pivot = {
		vertical_alignment = "top",
		parent = "item_grid_pivot",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			-120,
			40,
			3
		}
	},
	button_pivot_background = {
		vertical_alignment = "top",
		parent = "button_pivot",
		horizontal_alignment = "left",
		size = {
			120,
			520
		},
		position = {
			-20,
			-20,
			3
		}
	},
	weapon_stats_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-1140,
			40,
			3
		}
	},
	weapon_compare_stats_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-1140 + grid_size[1] - 50,
			40,
			3
		}
	},
	item_name_pivot = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-80,
			-220,
			3
		}
	},
	purchase_button = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			374,
			76
		},
		position = {
			-80,
			-90,
			1
		}
	},
	item_restrictions_background = {
		vertical_alignment = "bottom",
		parent = "item_grid_pivot",
		horizontal_alignment = "right",
		size = {
			350,
			0
		},
		position = {
			400,
			-90,
			1
		}
	},
	item_restrictions = {
		vertical_alignment = "center",
		parent = "item_restrictions_background",
		horizontal_alignment = "left",
		size = {
			500,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	set_item_parts_representation = {
		vertical_alignment = "bottom",
		parent = "item_restrictions",
		horizontal_alignment = "left",
		size = {
			50,
			50
		},
		position = {
			0,
			80,
			1
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "item_grid_pivot",
		horizontal_alignment = "left",
		size = {
			grid_size[1] + edge_padding,
			90
		},
		position = {
			0,
			8,
			15
		}
	},
	divider = {
		vertical_alignment = "bottom",
		parent = "title_text",
		horizontal_alignment = "left",
		size = {
			grid_size[1] + edge_padding,
			50
		},
		position = {
			0,
			17,
			1
		}
	},
	info_text = {
		vertical_alignment = "center",
		parent = "purchase_button",
		horizontal_alignment = "right",
		size = {
			grid_width,
			50
		},
		position = {
			-70,
			0,
			0
		}
	}
}
local item_restrictions_title_style = {
	font_size = 18,
	text_vertical_alignment = "top",
	horizontal_alignment = "left",
	text_horizontal_alignment = "left",
	vertical_alignment = "top",
	drop_shadow = true,
	font_type = "proxima_nova_bold",
	text_color = Color.terminal_text_body_sub_header(255, true),
	offset = {
		0,
		0,
		1
	}
}
local owned_item_text_style = table.clone(UIFontSettings.body)
owned_item_text_style.text_horizontal_alignment = "right"
owned_item_text_style.text_vertical_alignment = "center"
owned_item_text_style.horizontal_alignment = "center"
owned_item_text_style.vertical_alignment = "center"
owned_item_text_style.offset = {
	0,
	0,
	2
}
owned_item_text_style.text_color = Color.terminal_text_header(255, true)
local item_restrictions_body_style = {
	font_size = 20,
	text_vertical_alignment = "top",
	horizontal_alignment = "left",
	text_horizontal_alignment = "left",
	vertical_alignment = "top",
	drop_shadow = true,
	font_type = "proxima_nova_bold",
	text_color = Color.terminal_text_body(255, true),
	offset = {
		0,
		0,
		1
	}
}
local widget_definitions = {
	button_pivot_background = UIWidget.create_definition({
		{
			value_id = "background",
			style_id = "background",
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				color = Color.terminal_grid_background(255, true),
				size_addition = {
					30,
					20
				},
				offset = {
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/tab_frame_upper",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				color = Color.white(255, true),
				size = {
					136,
					14
				},
				offset = {
					0,
					-5,
					1
				}
			}
		},
		{
			value = "content/ui/materials/frames/tab_frame_lower",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				color = Color.white(255, true),
				size = {
					135,
					14
				},
				offset = {
					0,
					5,
					1
				}
			}
		}
	}, "button_pivot_background"),
	title_text = UIWidget.create_definition({
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			value = "",
			style = {
				horizontal_alignment = "center",
				font_size = 28,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					0,
					1
				},
				size = {
					grid_size[1],
					10
				}
			}
		}
	}, "title_text"),
	divider = UIWidget.create_definition({
		{
			value = "content/ui/materials/dividers/skull_center_02",
			pass_type = "texture",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_text_body_dark(255, true),
				size = {
					468,
					22
				}
			}
		}
	}, "divider"),
	item_restrictions = UIWidget.create_definition({
		{
			value_id = "title",
			style_id = "title",
			pass_type = "text",
			value = Utf8.upper(Localize("loc_item_equippable_on_header")),
			style = item_restrictions_title_style
		},
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = item_restrictions_body_style
		}
	}, "item_restrictions", {
		visible = true
	}),
	owned_info_text = UIWidget.create_definition({
		{
			style_id = "text",
			pass_type = "text",
			value_id = "text",
			style = owned_item_text_style,
			value = string.format("%s ", Localize("loc_premium_store_owned_note"))
		}
	}, "info_text", {
		visible = false
	}),
	no_class_info_text = UIWidget.create_definition({
		{
			style_id = "text",
			pass_type = "text",
			value_id = "text",
			style = owned_item_text_style,
			value = Localize("loc_cosmetic_vendor_no_operative_of_class")
		}
	}, "info_text", {
		visible = false
	})
}
local animations = {
	on_enter = {
		{
			name = "fade_in",
			end_time = 0.6,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				parent.animated_alpha_multiplier = 0
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				return
			end
		},
		{
			name = "move",
			end_time = 0.8,
			start_time = 0.35,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeOutCubic(progress)
				parent.animated_alpha_multiplier = anim_progress
				local x_anim_distance_max = 50
				local x_anim_distance = x_anim_distance_max - x_anim_distance_max * anim_progress

				parent:_set_scenegraph_position("button_pivot", scenegraph_definition.button_pivot.position[1] - x_anim_distance)
				parent:_set_scenegraph_position("item_grid_pivot", scenegraph_definition.item_grid_pivot.position[1] - x_anim_distance)
				parent:_force_update_scenegraph()
			end
		},
		{
			name = "done",
			end_time = 0.8,
			start_time = 0.8,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				parent.enter_animation_done = true
			end
		}
	}
}

return {
	grid_settings = grid_settings,
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
