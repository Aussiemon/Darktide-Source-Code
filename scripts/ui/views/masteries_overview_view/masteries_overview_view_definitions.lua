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
	grid_height,
}
local grid_spacing = {
	10,
	10,
}
local mask_size = {
	grid_width + 40,
	grid_height - 40,
}
local patterns_grid_settings = {
	hide_top_divider = true,
	scroll_start_margin = 80,
	scrollbar_horizontal_offset = -8,
	scrollbar_vertical_margin = 80,
	scrollbar_vertical_offset = 33,
	scrollbar_width = 7,
	show_loading_overlay = true,
	title_height = 0,
	top_padding = 80,
	use_is_focused_for_navigation = false,
	use_item_categories = false,
	use_select_on_focused = false,
	use_terminal_background = true,
	widget_icon_load_margin = 0,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	edge_padding = edge_padding,
	bottom_divider_passes = {
		{
			pass_type = "texture",
			style_id = "candles_1",
			value = "content/ui/materials/effects/masteries/panel_main_lower_frame_candles",
			value_id = "candles_1",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				offset = {
					0,
					57,
					21,
				},
				size = {
					750,
					200,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "bottom",
			value = "content/ui/materials/frames/masteries/panel_main_lower_frame",
			value_id = "bottom",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				offset = {
					0,
					30,
					20,
				},
				size = {
					656,
					66,
				},
			},
		},
	},
}
local patterns_tab_menu_settings = {
	button_spacing = 4,
	fixed_button_size = false,
	horizontal_alignment = "center",
	layer = 80,
	button_size = {
		70,
		60,
	},
	button_offset = {
		0,
		2,
	},
	icon_size = {
		60,
		60,
	},
	button_template = ButtonPassTemplates.item_category_sort_button,
	input_label_offset = {
		50,
		5,
	},
}
local patterns_category_tabs_content = {
	{
		hide_display_name = true,
		icon = "content/ui/materials/icons/item_types/melee_weapons",
		display_name = Localize("loc_glossary_term_melee_weapons"),
		slot_types = {
			"slot_primary",
		},
	},
	{
		hide_display_name = true,
		icon = "content/ui/materials/icons/item_types/ranged_weapons",
		display_name = Localize("loc_glossary_term_ranged_weapons"),
		slot_types = {
			"slot_secondary",
		},
	},
}
local pattern_title_text_style = table.clone(UIFontSettings.terminal_header_3)

pattern_title_text_style.text_horizontal_alignment = "center"
pattern_title_text_style.horizontal_alignment = "center"
pattern_title_text_style.text_vertical_alignment = "top"
pattern_title_text_style.vertical_alignment = "top"
pattern_title_text_style.offset = {
	0,
	50,
	20,
}

local mastery_pattern_display_name_text_style = table.clone(UIFontSettings.header_3)

mastery_pattern_display_name_text_style.horizontal_alignment = "center"
mastery_pattern_display_name_text_style.text_horizontal_alignment = "center"
mastery_pattern_display_name_text_style.text_vertical_alignment = "center"
mastery_pattern_display_name_text_style.size_addition = {
	-80,
}
mastery_pattern_display_name_text_style.offset = {
	0,
	-10,
	6,
}
mastery_pattern_display_name_text_style.font_size = 40
mastery_pattern_display_name_text_style.line_spacing = 1

local mastery_pattern_info_title = table.clone(mastery_pattern_display_name_text_style)

mastery_pattern_info_title.font_size = 30
mastery_pattern_info_title.offset = {
	0,
	40,
	6,
}
mastery_pattern_info_title.size_addition = {
	-40,
}
mastery_pattern_info_title.text_vertical_alignment = "top"
mastery_pattern_info_title.size = nil

local expertise_info = table.clone(mastery_pattern_display_name_text_style)

expertise_info.font_size = 30
expertise_info.size = nil
expertise_info.offset = {
	0,
	15,
	6,
}
expertise_info.size_addition = {
	-40,
}

local expertise_description = table.clone(expertise_info)

expertise_description.font_size = 18
expertise_description.text_vertical_alignment = "bottom"
expertise_description.offset = {
	0,
	-35,
	6,
}
expertise_description.size = nil

local mastery_level_bar = table.clone(UIFontSettings.body_small)

mastery_level_bar.text_horizontal_alignment = "left"
mastery_level_bar.horizontal_alignment = "right"
mastery_level_bar.text_vertical_alignment = "bottom"
mastery_level_bar.offset = {
	0,
	-70,
	6,
}
mastery_level_bar.font_size = 18
mastery_level_bar.size = {
	50,
}

local mastery_pattern_description_text_style = table.clone(UIFontSettings.body_small)

mastery_pattern_description_text_style.horizontal_alignment = "center"
mastery_pattern_description_text_style.text_horizontal_alignment = "center"
mastery_pattern_description_text_style.text_vertical_alignment = "top"
mastery_pattern_description_text_style.size = {
	nil,
	40,
}
mastery_pattern_description_text_style.size_addition = {
	-20,
}
mastery_pattern_description_text_style.offset = {
	10,
	100,
	6,
}

local mastery_pattern_mastery_level_text_style = table.clone(UIFontSettings.header_4)

mastery_pattern_mastery_level_text_style.horizontal_alignment = "center"
mastery_pattern_mastery_level_text_style.text_horizontal_alignment = "center"
mastery_pattern_mastery_level_text_style.text_vertical_alignment = "top"
mastery_pattern_mastery_level_text_style.size = {
	nil,
	40,
}
mastery_pattern_mastery_level_text_style.size_addition = {
	-20,
}
mastery_pattern_mastery_level_text_style.offset = {
	10,
	65,
	6,
}
mastery_pattern_mastery_level_text_style.font_size = 24

local bar_offset = 20
local mastery_pattern_mastery_experience_text_style = table.clone(UIFontSettings.header_4)

mastery_pattern_mastery_experience_text_style.horizontal_alignment = "right"
mastery_pattern_mastery_experience_text_style.text_horizontal_alignment = "right"
mastery_pattern_mastery_experience_text_style.text_vertical_alignment = "top"
mastery_pattern_mastery_experience_text_style.size = {
	nil,
	40,
}
mastery_pattern_mastery_experience_text_style.size_addition = {
	-20,
}
mastery_pattern_mastery_experience_text_style.offset = {
	-bar_offset,
	220,
	6,
}
mastery_pattern_mastery_experience_text_style.font_size = 24

local area_size = {
	470,
	250,
}
local mastery_level_size = 310
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
	patterns_grid_pivot = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			grid_width,
			grid_height,
		},
		position = {
			100,
			200,
			1,
		},
	},
	patterns_grid_tab_panel = {
		horizontal_alignment = "center",
		parent = "patterns_grid_pivot",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			-42,
			2,
		},
	},
	mastery_info = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			760,
			842,
		},
		position = {
			-170,
			-80,
			1,
		},
	},
	mastery_info_area = {
		horizontal_alignment = "center",
		parent = "mastery_info",
		vertical_alignment = "bottom",
		size = {
			700,
			398,
		},
		position = {
			2,
			-60,
			1,
		},
	},
	pattern_info = {
		horizontal_alignment = "center",
		parent = "mastery_info_area",
		vertical_alignment = "top",
		size = {
			760,
			160,
		},
		position = {
			0,
			0,
			1,
		},
	},
	expertise_level = {
		horizontal_alignment = "left",
		parent = "mastery_info_area",
		vertical_alignment = "bottom",
		size = {
			310,
			238,
		},
		position = {
			20,
			-30,
			1,
		},
	},
	mastery_level = {
		horizontal_alignment = "right",
		parent = "mastery_info_area",
		vertical_alignment = "bottom",
		size = {
			mastery_level_size,
			238,
		},
		position = {
			-20,
			-30,
			1,
		},
	},
	button = {
		horizontal_alignment = "center",
		parent = "mastery_info",
		vertical_alignment = "bottom",
		size = {
			288,
			50,
		},
		position = {
			0,
			-20,
			2,
		},
	},
}
local widget_definitions = {
	patterns_grid_panels = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "candles_2",
			value = "content/ui/materials/effects/masteries/panel_main_top_frame_candles",
			value_id = "candles_2",
			style = {
				offset = {
					-55,
					-149,
					21,
				},
				size = {
					750,
					200,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "top",
			value = "content/ui/materials/frames/masteries/panel_main_top_frame",
			value_id = "top",
			style = {
				horizontal_alignment = "center",
				offset = {
					0,
					-54,
					20,
				},
				size = {
					656,
					90,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "display_name",
			value = "Ranged",
			value_id = "display_name",
			style = pattern_title_text_style,
		},
		{
			pass_type = "texture",
			style_id = "divider_bottom",
			value = "content/ui/materials/dividers/skull_center_02",
			value_id = "divider_bottom",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					468,
					22,
				},
				offset = {
					0,
					90,
					20,
				},
				color = Color.terminal_text_body_sub_header(255, true),
			},
		},
	}, "patterns_grid_pivot", {
		visible = false,
	}),
	mastery_info = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "background",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "bottom",
				offset = {
					0,
					-60,
					0,
				},
				size = {
					700,
					398,
				},
				color = Color.terminal_grid_background(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "candles",
			value = "content/ui/materials/effects/masteries/pattern_panel_frame_candles",
			value_id = "candles",
			style = {
				size = {
					950,
					350,
				},
				offset = {
					-95,
					114,
					2,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/effects/masteries/pattern_panel_flare",
			style = {
				size = {
					82,
					82,
				},
				offset = {
					190,
					30,
					11,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/effects/masteries/pattern_panel_flare_1",
			style = {
				size = {
					82,
					82,
				},
				offset = {
					580,
					40,
					11,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/effects/masteries/pattern_panel_flare_2",
			style = {
				size = {
					82,
					82,
				},
				offset = {
					90,
					190,
					11,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/effects/masteries/pattern_panel_flare_3",
			style = {
				size = {
					82,
					82,
				},
				offset = {
					595,
					135,
					11,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/effects/masteries/pattern_panel_flare_4",
			style = {
				size = {
					82,
					82,
				},
				offset = {
					360,
					235,
					11,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/effects/masteries/pattern_panel_flare_5",
			style = {
				size = {
					82,
					82,
				},
				offset = {
					580,
					150,
					11,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "mastery_info",
			value = "content/ui/materials/frames/masteries/pattern_panel_frame",
			value_id = "mastery_info",
			style = {
				size = {
					760,
					842,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "melee",
			value = "content/ui/materials/frames/masteries/pattern_panel_frame_melee",
			value_id = "melee",
			style = {
				horizontal_alignment = "center",
				size = {
					572,
					348,
				},
			},
			visibility_function = function (content, style)
				return content.weapon_panel and content.weapon_panel == "slot_primary"
			end,
		},
		{
			pass_type = "texture",
			style_id = "ranged",
			value = "content/ui/materials/frames/masteries/pattern_panel_frame_ranged",
			value_id = "ranged",
			style = {
				horizontal_alignment = "center",
				size = {
					572,
					348,
				},
			},
			visibility_function = function (content, style)
				return content.weapon_panel and content.weapon_panel == "slot_secondary"
			end,
		},
		{
			pass_type = "texture",
			style_id = "pattern_icon",
			value = "content/ui/materials/icons/weapons/masteries/pattern_panel_container",
			value_id = "pattern_icon",
			style = {
				horizontal_alignment = "center",
				size = {
					370,
					320,
				},
				offset = {
					0,
					29,
					2,
				},
				material_values = {
					lerp_t = 1,
					weapon_texture_complete = nil,
					weapon_texture_incomplete = nil,
					weapon_texture_mask = nil,
				},
			},
			visibility_function = function (content, style)
				local material_values = style.material_values

				return not not material_values.weapon_texture_complete and not not material_values.weapon_texture_incomplete and not not material_values.weapon_texture_mask
			end,
		},
	}, "mastery_info", {
		visible = false,
	}),
	pattern_info = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "pattern_name",
			value = "",
			value_id = "pattern_name",
			style = mastery_pattern_display_name_text_style,
		},
		{
			pass_type = "text",
			style_id = "pattern_description",
			value = "",
			value_id = "pattern_description",
			style = mastery_pattern_description_text_style,
		},
		{
			pass_type = "texture",
			style_id = "divider_bottom",
			value = "content/ui/materials/dividers/skull_center_02",
			value_id = "divider_bottom",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					468,
					22,
				},
				offset = {
					0,
					70,
					20,
				},
				color = Color.terminal_text_body_sub_header(0, true),
			},
		},
	}, "pattern_info", {
		visible = true,
	}),
	expertise_level = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "title",
			value_id = "title",
			value = Localize("loc_mastery_max_power"),
			style = mastery_pattern_info_title,
		},
		{
			pass_type = "text",
			style_id = "info",
			value_id = "info",
			value = "{#size(" .. expertise_info.font_size * 2 .. ")} 999{#reset()} / 999",
			style = expertise_info,
		},
	}, "expertise_level", {
		visible = false,
	}),
	mastery_level = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "title",
			value_id = "title",
			value = Localize("loc_mastery_mastery"),
			style = mastery_pattern_info_title,
		},
		{
			pass_type = "text",
			style_id = "info",
			value_id = "info",
			value = "{#size(" .. expertise_info.font_size * 2 .. ")} 15{#reset()} / 20",
			style = expertise_info,
		},
		{
			pass_type = "rect",
			style_id = "experience_bar",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				color = Color.terminal_icon(255, true),
				size = {
					mastery_level_size - bar_offset * 2,
					10,
				},
				offset = {
					bar_offset,
					-65,
					4,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "experience_bar_background",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				color = Color.black(255, true),
				size = {
					mastery_level_size - bar_offset * 2,
					10,
				},
				offset = {
					bar_offset,
					-65,
					3,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "experience_bar_line",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				color = Color.terminal_text_body(255, true),
				size = {
					mastery_level_size - bar_offset * 2 + 4,
					14,
				},
				offset = {
					bar_offset - 2,
					-63,
					2,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "description",
			value = "",
			value_id = "description",
			style = expertise_description,
		},
	}, "mastery_level", {
		visible = false,
	}),
	mastery_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "button", {
		gamepad_action = "confirm_pressed",
		visible = false,
		original_text = Utf8.upper(Localize("loc_mastery_button_mastery_unlocks")),
		hotspot = {
			on_pressed_sound = nil,
		},
	}),
}

return {
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	patterns_grid_settings = patterns_grid_settings,
	patterns_tab_menu_settings = patterns_tab_menu_settings,
	patterns_category_tabs_content = patterns_category_tabs_content,
}
