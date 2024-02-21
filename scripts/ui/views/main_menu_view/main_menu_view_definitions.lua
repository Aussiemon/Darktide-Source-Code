local UIWidget = require("scripts/managers/ui/ui_widget")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local TextUtils = require("scripts/utilities/ui/text")
local DefaultViewInputSettings = require("scripts/settings/input/default_view_input_settings")
local ColorUtilities = require("scripts/utilities/ui/colors")
local text_style = table.clone(UIFontSettings.body_small)
text_style.vertical_alignment = "center"
text_style.text_horizontal_alignment = "left"
text_style.text_vertical_alignment = "center"
text_style.offset = {
	0,
	0,
	0
}
text_style.text_color = Color.terminal_text_body(255, true)
local friends_online_text = table.clone(UIFontSettings.symbol)
friends_online_text.vertical_alignment = "center"
friends_online_text.text_horizontal_alignment = "left"
friends_online_text.text_vertical_alignment = "center"
friends_online_text.offset = {
	0,
	0,
	0
}
friends_online_text.font_size = 24
friends_online_text.text_color = Color.terminal_text_body(255, true)
local strike_team_text = table.clone(UIFontSettings.symbol)
strike_team_text.vertical_alignment = "center"
strike_team_text.text_horizontal_alignment = "left"
strike_team_text.text_vertical_alignment = "center"
strike_team_text.offset = {
	0,
	0,
	0
}
strike_team_text.font_size = 24
strike_team_text.text_color = Color.terminal_text_body(255, true)
local symbol_style = table.clone(UIFontSettings.symbol)
symbol_style.text_vertical_alignment = "center"
symbol_style.offset = {
	0,
	-2,
	0
}
symbol_style.font_size = 24
symbol_style.text_color = Color.terminal_text_body(255, true)
local character_name = table.clone(UIFontSettings.header_2)
character_name.text_horizontal_alignment = "center"
character_name.offset = {
	0,
	220,
	1
}
local archetype_name = table.clone(UIFontSettings.body)
archetype_name.text_horizontal_alignment = "center"
archetype_name.offset = {
	0,
	260,
	1
}
archetype_name.text_color = Color.terminal_text_body_sub_header(255, true)
local overlay_text_style = table.clone(UIFontSettings.header_2)
overlay_text_style.offset = {
	0,
	0,
	204
}
overlay_text_style.text_vertical_alignment = "center"
overlay_text_style.text_horizontal_alignment = "center"
local new_button_text_style = table.clone(UIFontSettings.button_primary)
new_button_text_style.offset = {
	0,
	0,
	6
}
local new_character_intro = table.clone(UIFontSettings.body)
new_character_intro.text_horizontal_alignment = "center"
new_character_intro.offset = {
	0,
	30,
	0
}
local slots_count_text_style = table.clone(UIFontSettings.body_small)
slots_count_text_style.vertical_alignment = "top"
slots_count_text_style.text_horizontal_alignment = "center"
slots_count_text_style.text_vertical_alignment = "top"
slots_count_text_style.offset = {
	0,
	0,
	0
}
local gamertag_style = table.clone(UIFontSettings.header_2)
gamertag_style.text_horizontal_alignment = "right"
gamertag_style.text_vertical_alignment = "top"
gamertag_style.text_color = Color.terminal_text_body_sub_header(255, true)
gamertag_style.font_size = 24
local gamertag_input_style = table.clone(UIFontSettings.body)
gamertag_input_style.text_horizontal_alignment = "right"
gamertag_input_style.text_vertical_alignment = "top"
gamertag_input_style.text_color = {
	255,
	255,
	255,
	255
}
gamertag_input_style.font_size = 20
local wallet_title = table.clone(UIFontSettings.header_1)
wallet_title.offset = {
	-10,
	-20,
	1
}
wallet_title.text_vertical_alignment = "bottom"
wallet_title.text_horizontal_alignment = "right"
wallet_title.horizontal_alignment = "right"
wallet_title.font_size = 24
wallet_title.size = {
	300,
	0
}
local scenegraph_definition = {
	screen = {
		scale = "fit",
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
	character_list_background = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			600,
			700
		},
		position = {
			100,
			-60,
			1
		}
	},
	character_grid_background = {
		vertical_alignment = "top",
		parent = "character_list_background",
		horizontal_alignment = "left",
		size = {
			560,
			490
		},
		position = {
			15,
			185,
			1
		}
	},
	character_grid_start = {
		vertical_alignment = "top",
		parent = "character_grid_background",
		horizontal_alignment = "left",
		size = {
			560,
			490
		},
		position = {
			0,
			0,
			0
		}
	},
	character_grid_mask = {
		vertical_alignment = "center",
		parent = "character_grid_start",
		horizontal_alignment = "center",
		size = {
			600,
			510
		},
		position = {
			0,
			0,
			1
		}
	},
	character_grid_content_pivot = {
		vertical_alignment = "top",
		parent = "character_grid_start",
		horizontal_alignment = "left",
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
	character_grid_scrollbar = {
		vertical_alignment = "top",
		parent = "character_grid_start",
		horizontal_alignment = "right",
		size = {
			8,
			495
		},
		position = {
			13,
			0,
			2
		}
	},
	character_grid_interaction = {
		vertical_alignment = "top",
		parent = "character_grid_start",
		horizontal_alignment = "left",
		size = {
			550,
			490
		},
		position = {
			0,
			0,
			2
		}
	},
	counts_background = {
		vertical_alignment = "top",
		parent = "character_list_background",
		horizontal_alignment = "left",
		size = {
			600,
			55
		},
		position = {
			0,
			132,
			2
		}
	},
	party_count = {
		vertical_alignment = "top",
		parent = "counts_background",
		horizontal_alignment = "left",
		size = {
			220,
			60
		},
		position = {
			80,
			-4,
			1
		}
	},
	strike_team_count = {
		vertical_alignment = "top",
		parent = "counts_background",
		horizontal_alignment = "right",
		size = {
			220,
			60
		},
		position = {
			-80,
			-4,
			1
		}
	},
	character_selected_background = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			500,
			220
		},
		position = {
			-100,
			-160,
			1
		}
	},
	character_info_pivot = {
		vertical_alignment = "bottom",
		parent = "character_selected_background",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-100,
			1
		}
	},
	character_info = {
		vertical_alignment = "bottom",
		parent = "character_info_pivot",
		horizontal_alignment = "center",
		size = {
			500,
			300
		},
		position = {
			0,
			0,
			1
		}
	},
	button_pivot = {
		vertical_alignment = "bottom",
		parent = "character_selected_background",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			40,
			2
		}
	},
	play_button = {
		vertical_alignment = "bottom",
		parent = "button_pivot",
		horizontal_alignment = "center",
		size = ButtonPassTemplates.ready_button.size,
		position = {
			250,
			0,
			2
		}
	},
	create_button = {
		vertical_alignment = "bottom",
		parent = "character_list_background",
		horizontal_alignment = "center",
		size = {
			412,
			54
		},
		position = {
			0,
			73,
			2
		}
	},
	slots_count = {
		vertical_alignment = "bottom",
		parent = "character_list_background",
		horizontal_alignment = "center",
		size = {
			600,
			30
		},
		position = {
			0,
			150,
			2
		}
	},
	gamertag = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			600,
			40
		},
		position = {
			-200,
			30,
			2
		}
	},
	gamertag_input = {
		vertical_alignment = "top",
		parent = "gamertag",
		horizontal_alignment = "right",
		size = {
			600,
			40
		},
		position = {
			0,
			40,
			2
		}
	},
	wallet_element_pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			0,
			-90,
			0
		}
	},
	wallet_element_background = {
		vertical_alignment = "center",
		parent = "wallet_element_pivot",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	wallet_merge_data_pivot = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	}
}
local widget_definitions = {
	background_left = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/panel_horizontal_half",
			pass_type = "texture",
			style = {
				offset = {
					0,
					0,
					0
				},
				color = Color.black(50, true)
			}
		}
	}, "screen"),
	counts_background = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot",
			content = {
				use_is_focused = true
			},
			style = {
				offset = {
					0,
					-3,
					1
				},
				size = {
					600,
					55
				}
			}
		}
	}, "counts_background"),
	friends_online = UIWidget.create_definition({
		{
			value_id = "icon",
			pass_type = "text",
			style_id = "icon",
			value = "",
			style = symbol_style
		},
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = Localize("loc_main_menu_friends_online_count"),
			style = text_style
		},
		{
			value_id = "text_count",
			style_id = "text_count",
			pass_type = "text",
			value = "0",
			style = friends_online_text
		}
	}, "party_count"),
	strike_team = UIWidget.create_definition({
		{
			value_id = "icon",
			pass_type = "text",
			style_id = "icon",
			value = "",
			style = symbol_style
		},
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = Localize("loc_main_menu_warband_count"),
			style = text_style
		},
		{
			value_id = "text_count",
			style_id = "text_count",
			pass_type = "text",
			value = "",
			style = strike_team_text
		}
	}, "strike_team_count"),
	character_info = UIWidget.create_definition({
		{
			value = "",
			value_id = "archetype_icon",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				color = {
					255,
					255,
					255,
					255
				},
				size = {
					400,
					240
				},
				offset = {
					0,
					0,
					1
				}
			}
		},
		{
			value_id = "character_name",
			style_id = "text_character",
			pass_type = "text",
			value = "Character Name",
			style = character_name
		},
		{
			value_id = "character_title",
			style_id = "text_archetype",
			pass_type = "text",
			value = "Archetype name - 00",
			style = archetype_name
		}
	}, "character_info"),
	character_list_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			style_id = "background",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				scale_to_material = true,
				size_addition = {
					10,
					30
				},
				offset = {
					0,
					112,
					0
				},
				size = {
					600,
					580
				},
				color = Color.terminal_grid_background(nil, true)
			}
		},
		{
			value = "content/ui/materials/frames/character_selection_top",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					600,
					156
				},
				offset = {
					0,
					0,
					6
				}
			}
		},
		{
			value = "content/ui/materials/frames/character_selection_bottom",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					600,
					134
				},
				offset = {
					0,
					114,
					50
				}
			}
		}
	}, "character_list_background"),
	character_grid_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "character_grid_scrollbar"),
	character_grid_mask = UIWidget.create_definition({
		{
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
			pass_type = "texture",
			style = {
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	}, "character_grid_mask"),
	character_grid_interaction = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		}
	}, "character_grid_interaction"),
	play_button = UIWidget.create_definition(ButtonPassTemplates.ready_button, "play_button", {
		gamepad_action = "confirm_pressed",
		original_text = Utf8.upper(Localize("loc_main_menu_play_button"))
	}),
	create_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "create_button", {
		gamepad_action = "hotkey_menu_special_1",
		original_text = Utf8.upper(Localize("loc_main_menu_create_button"))
	}),
	slots_count = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = slots_count_text_style
		}
	}, "slots_count"),
	gamertag = IS_XBS and UIWidget.create_definition({
		{
			value_id = "gamertag",
			style_id = "gamertag_style",
			pass_type = "text",
			value = Managers.account:gamertag(),
			style = gamertag_style
		}
	}, "gamertag") or nil,
	gamertag_input = IS_XBS and UIWidget.create_definition({
		{
			value_id = "gamertag_input",
			style_id = "gamertag_style",
			pass_type = "text",
			value = TextUtils.localize_with_button_hint("cycle_list_secondary", "loc_switch_profile", nil, DefaultViewInputSettings.service_type, Localize("loc_input_legend_text_template")),
			style = gamertag_input_style
		}
	}, "gamertag_input") or nil,
	metal_corners = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/metal_01_lower",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "bottom",
				size = {
					180,
					120
				},
				offset = {
					0,
					0,
					62
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		{
			value = "content/ui/materials/frames/screen/metal_01_lower",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				size = {
					180,
					120
				},
				offset = {
					0,
					0,
					62
				},
				color = {
					255,
					255,
					255,
					255
				},
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
		},
		{
			value = "content/ui/materials/frames/screen/metal_01_upper",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "top",
				size = {
					180,
					310
				},
				offset = {
					0,
					0,
					62
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		{
			value = "content/ui/materials/frames/screen/metal_01_upper",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				size = {
					180,
					310
				},
				offset = {
					0,
					0,
					62
				},
				color = {
					255,
					255,
					255,
					255
				},
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
	}, "screen"),
	overlay = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					200
				},
				color = {
					200,
					0,
					0,
					0
				}
			}
		},
		{
			pass_type = "text",
			value = Localize("loc_main_menu_fetching_profiles"),
			style = overlay_text_style
		}
	}, "screen"),
	wallet_element_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			style_id = "background",
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
				color = Color.terminal_grid_background(255, true)
			}
		},
		{
			pass_type = "text",
			value = Localize("loc_main_menu_account_wallet_title"),
			style = wallet_title
		},
		{
			value_id = "top_divider",
			style_id = "top_divider",
			pass_type = "texture_uv",
			value = "content/ui/materials/dividers/horizontal_frame_big_lower",
			style = {
				vertical_alignment = "top",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					30,
					0
				},
				size = {
					nil,
					36
				},
				offset = {
					0,
					-20,
					2
				},
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			}
		},
		{
			value_id = "bottom_divider",
			style_id = "bottom_divider",
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_frame_big_lower",
			style = {
				vertical_alignment = "bottom",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					30,
					0
				},
				size = {
					nil,
					36
				},
				offset = {
					0,
					20,
					2
				}
			}
		}
	}, "wallet_element_background", {
		visible = false
	})
}
local legend_inputs = {
	{
		input_action = "close_view",
		display_name = "loc_main_menu",
		alignment = "left_alignment",
		on_pressed_callback = "cb_on_open_main_menu_pressed",
		visibility_function = function (parent)
			return not parent._is_main_menu_open
		end
	},
	{
		input_action = "hotkey_character_delete",
		display_name = "loc_main_menu_delete_button",
		alignment = "right_alignment",
		on_pressed_callback = "_on_delete_selected_character_pressed",
		visibility_function = function (parent)
			return not parent._is_main_menu_open and parent._character_details_active
		end
	}
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
