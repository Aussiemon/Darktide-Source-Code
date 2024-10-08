-- chunkname: @scripts/ui/views/crafting_mechanicus_barter_items_view/crafting_mechanicus_barter_items_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local CraftingSettings = require("scripts/settings/item/crafting_mechanicus_settings")
local Items = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local weapon_stats_context = CraftingSettings.weapon_stats_context
local weapon_stats_grid_size = weapon_stats_context.grid_size
local mastery_pattern_display_name_text_style = table.clone(UIFontSettings.header_3)

mastery_pattern_display_name_text_style.horizontal_alignment = "center"
mastery_pattern_display_name_text_style.text_horizontal_alignment = "center"
mastery_pattern_display_name_text_style.text_vertical_alignment = "bottom"
mastery_pattern_display_name_text_style.vertical_alignment = "top"
mastery_pattern_display_name_text_style.size = {
	nil,
	40,
}
mastery_pattern_display_name_text_style.size_addition = {
	-20,
}
mastery_pattern_display_name_text_style.offset = {
	10,
	-40,
	6,
}
mastery_pattern_display_name_text_style.font_size = 40

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
	20,
	6,
}
mastery_pattern_mastery_level_text_style.font_size = 24

local area_size = {
	470,
	250,
}
local bar_offset = 20
local mastery_pattern_mastery_experience_text_style = table.clone(UIFontSettings.header_4)

mastery_pattern_mastery_experience_text_style.horizontal_alignment = "right"
mastery_pattern_mastery_experience_text_style.text_horizontal_alignment = "right"
mastery_pattern_mastery_experience_text_style.text_vertical_alignment = "top"
mastery_pattern_mastery_experience_text_style.vertical_alignment = "bottom"
mastery_pattern_mastery_experience_text_style.size = {
	nil,
	40,
}
mastery_pattern_mastery_experience_text_style.size_addition = {
	-20,
}
mastery_pattern_mastery_experience_text_style.offset = {
	-bar_offset,
	-30,
	6,
}
mastery_pattern_mastery_experience_text_style.font_size = 24

local mastery_added_experience_text_style = table.clone(mastery_pattern_mastery_experience_text_style)

mastery_added_experience_text_style.text_color = Color.ui_blue_light(255, true)
mastery_added_experience_text_style.horizontal_alignment = "left"
mastery_added_experience_text_style.text_horizontal_alignment = "left"
mastery_added_experience_text_style.offset = {
	bar_offset,
	-30,
	6,
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

local weapon_stats_grid_settings = {
	use_parent_ui_renderer = true,
}
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
	patterns_grid_pivot = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			640,
			850,
		},
		position = {
			100,
			100,
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
	item_grid_pivot = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			518,
			920,
		},
		position = {
			100,
			50,
			1,
		},
	},
	selection_count = {
		horizontal_alignment = "center",
		parent = "item_grid_pivot",
		vertical_alignment = "top",
		size = {
			518,
			100,
		},
		position = {
			0,
			-50,
			1,
		},
	},
	crafting_recipe_pivot = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			430,
			400,
		},
		position = {
			-150,
			-102,
			3,
		},
	},
	weapon_stats_pivot = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			765,
			60,
			1,
		},
	},
	weapon_discard_pivot = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			1320,
			320,
			1,
		},
	},
	mastery_info = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			650,
			280,
		},
		position = {
			790,
			315,
			1,
		},
	},
	mastery_info_details = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			650,
			250,
		},
		position = {
			790,
			-200,
			1,
		},
	},
	confirm_button = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = ButtonPassTemplates.default_button.size,
		position = {
			900,
			920,
			1,
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
			pass_type = "texture",
			style_id = "candles_1",
			value = "content/ui/materials/effects/masteries/panel_main_lower_frame_candles",
			value_id = "candles_1",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				offset = {
					0,
					67,
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
					40,
					20,
				},
				size = {
					656,
					66,
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
	confirm_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "confirm_button", {
		gamepad_action = "secondary_action_pressed",
		visible = false,
		original_text = Utf8.upper(Localize("loc_continue")),
		hotspot = {
			on_pressed_sound = UISoundEvents.crafting_view_sacrifice_weapon,
		},
	}),
	mastery_info = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "display_name",
			value = "",
			value_id = "display_name",
			style = mastery_pattern_display_name_text_style,
		},
		{
			pass_type = "text",
			style_id = "mastery_level",
			value = "",
			value_id = "mastery_level",
			style = mastery_pattern_mastery_level_text_style,
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/contracts/contracts_store/uknown_melee_weapon",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_text_body(255, true),
				default_color = Color.terminal_text_body(nil, true),
				selected_color = Color.terminal_icon(nil, true),
				original_offset = {
					0,
					0,
					5,
				},
				offset = {
					0,
					0,
					5,
				},
				original_size = {
					358.4,
					134.39999999999998,
				},
				size = {
					358.4,
					134.39999999999998,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "mastery_experience",
			value = "",
			value_id = "mastery_experience",
			style = mastery_pattern_mastery_experience_text_style,
		},
		{
			pass_type = "rect",
			style_id = "experience_bar",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				color = Color.terminal_icon(255, true),
				size = {
					nil,
					10,
				},
				offset = {
					bar_offset,
					-20,
					5,
				},
				size_addition = {
					-(bar_offset * 2),
					0,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "experience_bar_new",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				color = Color.ui_blue_light(255, true),
				size = {
					nil,
					10,
				},
				offset = {
					bar_offset,
					-20,
					4,
				},
				size_addition = {
					-(bar_offset * 2),
					0,
				},
			},
			change_function = function (content, style, animations, dt)
				local pulse_frequency = 5
				local pulse = 0.5 * (1 + math.sin(Application.time_since_launch() * pulse_frequency))

				style.color[1] = pulse * 255
			end,
		},
		{
			pass_type = "rect",
			style_id = "experience_bar_background",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				color = Color.black(255, true),
				size = {
					nil,
					10,
				},
				offset = {
					bar_offset,
					-20,
					3,
				},
				size_addition = {
					-(bar_offset * 2),
					0,
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
					nil,
					10,
				},
				offset = {
					bar_offset - 2,
					-18,
					2,
				},
				size_addition = {
					-(bar_offset * 2) + 4,
					4,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "added_exp",
			value = "",
			value_id = "added_exp",
			style = mastery_added_experience_text_style,
		},
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
	}, "mastery_info", {
		visible = false,
	}),
	sacrifice_intro = UIWidget.create_definition({
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
			pass_type = "text",
			style_id = "display_name",
			value_id = "display_name",
			value = Localize("loc_mastery_crafting_sacrifice_weapon_title"),
			style = table.merge(table.clone(mastery_pattern_display_name_text_style), {
				text_vertical_alignment = "top",
				offset = {
					mastery_pattern_display_name_text_style.offset[1],
					20,
					mastery_pattern_display_name_text_style.offset[3],
				},
			}),
		},
		{
			pass_type = "text",
			style_id = "description",
			value = "",
			value_id = "description",
			style = table.merge(table.clone(mastery_pattern_mastery_experience_text_style), {
				text_horizontal_alignment = "left",
				text_vertical_alignment = "bottom",
				vertical_alignment = "bottom",
				offset = {
					0,
					-20,
					mastery_pattern_mastery_experience_text_style.offset[3],
				},
			}),
		},
	}, "mastery_info_details", {
		visible = false,
	}),
}

return {
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
}
