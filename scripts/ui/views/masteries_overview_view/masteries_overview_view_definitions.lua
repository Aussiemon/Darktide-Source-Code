-- chunkname: @scripts/ui/views/masteries_overview_view/masteries_overview_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local edge_padding = 44
local grid_width = 640
local grid_height = 750
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
	grid_height - 40
}
local patterns_grid_settings = {
	scrollbar_width = 7,
	use_item_categories = false,
	use_select_on_focused = false,
	scrollbar_horizontal_offset = -8,
	scroll_start_margin = 80,
	hide_dividers = true,
	top_padding = 80,
	scrollbar_vertical_offset = 33,
	show_loading_overlay = true,
	scrollbar_vertical_margin = 80,
	widget_icon_load_margin = 0,
	use_is_focused_for_navigation = false,
	use_terminal_background = true,
	title_height = 0,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	edge_padding = edge_padding
}
local patterns_tab_menu_settings = {
	layer = 80,
	button_spacing = 4,
	horizontal_alignment = "center",
	fixed_button_size = false,
	button_size = {
		70,
		60
	},
	button_offset = {
		0,
		2
	},
	icon_size = {
		60,
		60
	},
	button_template = ButtonPassTemplates.item_category_sort_button,
	input_label_offset = {
		50,
		5
	}
}
local patterns_category_tabs_content = {
	{
		icon = "content/ui/materials/icons/item_types/melee_weapons",
		hide_display_name = true,
		display_name = Localize("loc_glossary_term_melee_weapons"),
		slot_types = {
			"slot_primary"
		}
	},
	{
		icon = "content/ui/materials/icons/item_types/ranged_weapons",
		hide_display_name = true,
		display_name = Localize("loc_glossary_term_ranged_weapons"),
		slot_types = {
			"slot_secondary"
		}
	}
}
local pattern_title_text_style = table.clone(UIFontSettings.terminal_header_3)

pattern_title_text_style.text_horizontal_alignment = "center"
pattern_title_text_style.horizontal_alignment = "center"
pattern_title_text_style.text_vertical_alignment = "top"
pattern_title_text_style.vertical_alignment = "top"
pattern_title_text_style.offset = {
	0,
	50,
	20
}

local mastery_pattern_display_name_text_style = table.clone(UIFontSettings.header_3)

mastery_pattern_display_name_text_style.horizontal_alignment = "center"
mastery_pattern_display_name_text_style.text_horizontal_alignment = "center"
mastery_pattern_display_name_text_style.text_vertical_alignment = "top"
mastery_pattern_display_name_text_style.size_addition = {
	-40
}
mastery_pattern_display_name_text_style.offset = {
	0,
	40,
	6
}
mastery_pattern_display_name_text_style.font_size = 40

local mastery_pattern_info_title = table.clone(mastery_pattern_display_name_text_style)

mastery_pattern_info_title.font_size = 30
mastery_pattern_info_title.offset = {
	0,
	40,
	6
}
mastery_pattern_info_title.size = nil

local expertise_info = table.clone(mastery_pattern_display_name_text_style)

expertise_info.font_size = 30
expertise_info.size = nil
expertise_info.offset = {
	0,
	15,
	6
}
expertise_info.text_vertical_alignment = "center"

local expertise_description = table.clone(expertise_info)

expertise_description.font_size = 18
expertise_description.text_vertical_alignment = "bottom"
expertise_description.offset = {
	0,
	-35,
	6
}
expertise_description.size = nil

local mastery_level_bar = table.clone(UIFontSettings.body_small)

mastery_level_bar.text_horizontal_alignment = "left"
mastery_level_bar.horizontal_alignment = "right"
mastery_level_bar.text_vertical_alignment = "bottom"
mastery_level_bar.offset = {
	0,
	-70,
	6
}
mastery_level_bar.font_size = 18
mastery_level_bar.size = {
	50
}

local mastery_pattern_description_text_style = table.clone(UIFontSettings.body_small)

mastery_pattern_description_text_style.horizontal_alignment = "center"
mastery_pattern_description_text_style.text_horizontal_alignment = "center"
mastery_pattern_description_text_style.text_vertical_alignment = "top"
mastery_pattern_description_text_style.size = {
	nil,
	40
}
mastery_pattern_description_text_style.size_addition = {
	-20
}
mastery_pattern_description_text_style.offset = {
	10,
	100,
	6
}

local mastery_pattern_mastery_level_text_style = table.clone(UIFontSettings.header_4)

mastery_pattern_mastery_level_text_style.horizontal_alignment = "center"
mastery_pattern_mastery_level_text_style.text_horizontal_alignment = "center"
mastery_pattern_mastery_level_text_style.text_vertical_alignment = "top"
mastery_pattern_mastery_level_text_style.size = {
	nil,
	40
}
mastery_pattern_mastery_level_text_style.size_addition = {
	-20
}
mastery_pattern_mastery_level_text_style.offset = {
	10,
	65,
	6
}
mastery_pattern_mastery_level_text_style.font_size = 24

local bar_offset = 20
local mastery_pattern_mastery_experience_text_style = table.clone(UIFontSettings.header_4)

mastery_pattern_mastery_experience_text_style.horizontal_alignment = "right"
mastery_pattern_mastery_experience_text_style.text_horizontal_alignment = "right"
mastery_pattern_mastery_experience_text_style.text_vertical_alignment = "top"
mastery_pattern_mastery_experience_text_style.size = {
	nil,
	40
}
mastery_pattern_mastery_experience_text_style.size_addition = {
	-20
}
mastery_pattern_mastery_experience_text_style.offset = {
	-bar_offset,
	220,
	6
}
mastery_pattern_mastery_experience_text_style.font_size = 24

local area_size = {
	470,
	250
}
local mastery_level_size = 310
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
			3
		}
	},
	patterns_grid_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			grid_width,
			grid_height
		},
		position = {
			100,
			200,
			1
		}
	},
	patterns_grid_tab_panel = {
		vertical_alignment = "top",
		parent = "patterns_grid_pivot",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-42,
			2
		}
	},
	mastery_info = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			760,
			842
		},
		position = {
			-170,
			-80,
			1
		}
	},
	mastery_info_area = {
		vertical_alignment = "bottom",
		parent = "mastery_info",
		horizontal_alignment = "center",
		size = {
			700,
			398
		},
		position = {
			2,
			-60,
			1
		}
	},
	pattern_info = {
		vertical_alignment = "top",
		parent = "mastery_info_area",
		horizontal_alignment = "center",
		size = {
			760,
			160
		},
		position = {
			0,
			0,
			1
		}
	},
	expertise_level = {
		vertical_alignment = "bottom",
		parent = "mastery_info_area",
		horizontal_alignment = "left",
		size = {
			310,
			238
		},
		position = {
			20,
			-30,
			1
		}
	},
	mastery_level = {
		vertical_alignment = "bottom",
		parent = "mastery_info_area",
		horizontal_alignment = "right",
		size = {
			mastery_level_size,
			238
		},
		position = {
			-20,
			-30,
			1
		}
	},
	button = {
		vertical_alignment = "bottom",
		parent = "mastery_info",
		horizontal_alignment = "center",
		size = {
			288,
			50
		},
		position = {
			0,
			-20,
			2
		}
	}
}
local widget_definitions = {
	patterns_grid_panels = UIWidget.create_definition({
		{
			value_id = "candles_2",
			style_id = "candles_2",
			pass_type = "texture",
			value = "content/ui/materials/effects/masteries/panel_main_top_frame_candles",
			style = {
				offset = {
					-55,
					-149,
					21
				},
				size = {
					750,
					200
				}
			}
		},
		{
			value_id = "top",
			style_id = "top",
			pass_type = "texture",
			value = "content/ui/materials/frames/masteries/panel_main_top_frame",
			style = {
				horizontal_alignment = "center",
				offset = {
					0,
					-54,
					20
				},
				size = {
					656,
					90
				}
			}
		},
		{
			value_id = "candles_1",
			style_id = "candles_1",
			pass_type = "texture",
			value = "content/ui/materials/effects/masteries/panel_main_lower_frame_candles",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				offset = {
					0,
					67,
					21
				},
				size = {
					750,
					200
				}
			}
		},
		{
			value_id = "bottom",
			style_id = "bottom",
			pass_type = "texture",
			value = "content/ui/materials/frames/masteries/panel_main_lower_frame",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				offset = {
					0,
					40,
					20
				},
				size = {
					656,
					66
				}
			}
		},
		{
			value_id = "display_name",
			style_id = "display_name",
			pass_type = "text",
			value = "Ranged",
			style = pattern_title_text_style
		},
		{
			value_id = "divider_bottom",
			style_id = "divider_bottom",
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_center_02",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					468,
					22
				},
				offset = {
					0,
					90,
					20
				},
				color = Color.terminal_text_body_sub_header(255, true)
			}
		}
	}, "patterns_grid_pivot", {
		visible = false
	}),
	mastery_info = UIWidget.create_definition({
		{
			value_id = "background",
			style_id = "background",
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				vertical_alignment = "bottom",
				scale_to_material = true,
				horizontal_alignment = "center",
				offset = {
					0,
					-60,
					0
				},
				size = {
					700,
					398
				},
				color = Color.terminal_grid_background(255, true)
			}
		},
		{
			value_id = "candles",
			style_id = "candles",
			pass_type = "texture",
			value = "content/ui/materials/effects/masteries/pattern_panel_frame_candles",
			style = {
				size = {
					950,
					350
				},
				offset = {
					-95,
					114,
					2
				}
			}
		},
		{
			value = "content/ui/materials/effects/masteries/pattern_panel_flare",
			pass_type = "texture",
			style = {
				size = {
					82,
					82
				},
				offset = {
					190,
					30,
					11
				}
			}
		},
		{
			value = "content/ui/materials/effects/masteries/pattern_panel_flare_1",
			pass_type = "texture",
			style = {
				size = {
					82,
					82
				},
				offset = {
					580,
					40,
					11
				}
			}
		},
		{
			value = "content/ui/materials/effects/masteries/pattern_panel_flare_2",
			pass_type = "texture",
			style = {
				size = {
					82,
					82
				},
				offset = {
					90,
					190,
					11
				}
			}
		},
		{
			value = "content/ui/materials/effects/masteries/pattern_panel_flare_3",
			pass_type = "texture",
			style = {
				size = {
					82,
					82
				},
				offset = {
					595,
					135,
					11
				}
			}
		},
		{
			value = "content/ui/materials/effects/masteries/pattern_panel_flare_4",
			pass_type = "texture",
			style = {
				size = {
					82,
					82
				},
				offset = {
					360,
					235,
					11
				}
			}
		},
		{
			value = "content/ui/materials/effects/masteries/pattern_panel_flare_5",
			pass_type = "texture",
			style = {
				size = {
					82,
					82
				},
				offset = {
					580,
					150,
					11
				}
			}
		},
		{
			value_id = "mastery_info",
			style_id = "mastery_info",
			pass_type = "texture",
			value = "content/ui/materials/frames/masteries/pattern_panel_frame",
			style = {
				size = {
					760,
					842
				},
				offset = {
					0,
					0,
					1
				}
			}
		},
		{
			value_id = "melee",
			style_id = "melee",
			pass_type = "texture",
			value = "content/ui/materials/frames/masteries/pattern_panel_frame_melee",
			style = {
				horizontal_alignment = "center",
				size = {
					572,
					348
				}
			},
			visibility_function = function (content, style)
				return content.weapon_panel and content.weapon_panel == "slot_primary"
			end
		},
		{
			value_id = "ranged",
			style_id = "ranged",
			pass_type = "texture",
			value = "content/ui/materials/frames/masteries/pattern_panel_frame_ranged",
			style = {
				horizontal_alignment = "center",
				size = {
					572,
					348
				}
			},
			visibility_function = function (content, style)
				return content.weapon_panel and content.weapon_panel == "slot_secondary"
			end
		},
		{
			value_id = "pattern_icon",
			style_id = "pattern_icon",
			pass_type = "texture",
			value = "content/ui/materials/icons/weapons/masteries/pattern_panel_container",
			style = {
				horizontal_alignment = "center",
				size = {
					370,
					320
				},
				offset = {
					0,
					29,
					2
				},
				material_values = {
					lerp_t = 1
				}
			},
			visibility_function = function (content, style)
				local material_values = style.material_values

				return not not material_values.weapon_texture_complete and not not material_values.weapon_texture_incomplete and not not material_values.weapon_texture_mask
			end
		}
	}, "mastery_info", {
		visible = false
	}),
	pattern_info = UIWidget.create_definition({
		{
			value_id = "pattern_name",
			style_id = "pattern_name",
			pass_type = "text",
			value = "",
			style = mastery_pattern_display_name_text_style
		},
		{
			value_id = "pattern_description",
			style_id = "pattern_description",
			pass_type = "text",
			value = "",
			style = mastery_pattern_description_text_style
		},
		{
			value_id = "divider_bottom",
			style_id = "divider_bottom",
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_center_02",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					468,
					22
				},
				offset = {
					0,
					70,
					20
				},
				color = Color.terminal_text_body_sub_header(0, true)
			}
		}
	}, "pattern_info", {
		visible = true
	}),
	expertise_level = UIWidget.create_definition({
		{
			value_id = "title",
			style_id = "title",
			pass_type = "text",
			value = Localize("loc_mastery_max_power"),
			style = mastery_pattern_info_title
		},
		{
			value_id = "info",
			style_id = "info",
			pass_type = "text",
			value = "{#size(" .. expertise_info.font_size * 2 .. ")} 999{#reset()} / 999",
			style = expertise_info
		}
	}, "expertise_level", {
		visible = false
	}),
	mastery_level = UIWidget.create_definition({
		{
			value_id = "title",
			style_id = "title",
			pass_type = "text",
			value = Localize("loc_mastery_mastery"),
			style = mastery_pattern_info_title
		},
		{
			value_id = "info",
			style_id = "info",
			pass_type = "text",
			value = "{#size(" .. expertise_info.font_size * 2 .. ")} 15{#reset()} / 20",
			style = expertise_info
		},
		{
			style_id = "experience_bar",
			pass_type = "rect",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				color = Color.terminal_icon(255, true),
				size = {
					mastery_level_size - bar_offset * 2,
					10
				},
				offset = {
					bar_offset,
					-65,
					4
				}
			}
		},
		{
			style_id = "experience_bar_background",
			pass_type = "rect",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				color = Color.black(255, true),
				size = {
					mastery_level_size - bar_offset * 2,
					10
				},
				offset = {
					bar_offset,
					-65,
					3
				}
			}
		},
		{
			style_id = "experience_bar_line",
			pass_type = "rect",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				color = Color.terminal_text_body(255, true),
				size = {
					mastery_level_size - bar_offset * 2 + 4,
					14
				},
				offset = {
					bar_offset - 2,
					-63,
					2
				}
			}
		},
		{
			value_id = "description",
			style_id = "description",
			pass_type = "text",
			value = "",
			style = expertise_description
		}
	}, "mastery_level", {
		visible = false
	}),
	mastery_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "button", {
		gamepad_action = "confirm_pressed",
		visible = false,
		original_text = Utf8.upper(Localize("loc_mastery_button_mastery_unlocks")),
		hotspot = {}
	})
}

return {
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	patterns_grid_settings = patterns_grid_settings,
	patterns_tab_menu_settings = patterns_tab_menu_settings,
	patterns_category_tabs_content = patterns_category_tabs_content
}
