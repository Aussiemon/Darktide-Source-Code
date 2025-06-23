-- chunkname: @scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay_definitions.lua

local ElementSettings = require("scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local WalletSettings = require("scripts/settings/wallet_settings")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local element_styles = ElementSettings.styles
local line_width = ElementSettings.line_width
local buffer = ElementSettings.buffer
local details_panel_size = {
	600,
	1080
}
local mission_info_size = {
	details_panel_size[1] - 50,
	160
}
local circumstance_info_size = {
	details_panel_size[1] - 50,
	120
}
local currency_info_size = {
	110,
	33
}
local havoc_info_size = {
	details_panel_size[1] - 50,
	180
}
local screen_size = UIWorkspaceSettings.screen.size
local right_content_size = {
	ElementSettings.right_grid_width,
	550
}
local right_header_size = {
	ElementSettings.right_grid_width,
	ElementSettings.right_header_height
}
local left_panel_x_position = 25
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
	background = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = screen_size,
		position = {
			0,
			0,
			0
		}
	},
	left_panel = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "left",
		size = details_panel_size,
		position = {
			left_panel_x_position,
			25,
			0
		}
	},
	mission_info_panel = {
		vertical_alignment = "top",
		parent = "left_panel",
		horizontal_alignment = "left",
		size = mission_info_size,
		position = {
			0,
			0,
			1
		}
	},
	circumstance_info_panel = {
		vertical_alignment = "top",
		parent = "left_panel",
		horizontal_alignment = "left",
		size = circumstance_info_size,
		position = {
			420,
			220,
			1
		}
	},
	crafting_pickup_pivot = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			50,
			1
		}
	},
	crafting_pickup_panel = {
		vertical_alignment = "top",
		parent = "crafting_pickup_pivot",
		horizontal_alignment = "center",
		size = currency_info_size,
		position = {
			0,
			0,
			1
		}
	},
	right_panel = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "right",
		size = details_panel_size,
		position = {
			0,
			0,
			0
		}
	},
	right_panel_content = {
		vertical_alignment = "center",
		parent = "right_panel",
		horizontal_alignment = "right",
		size = right_content_size,
		position = {
			-15,
			0,
			0
		}
	},
	right_panel_header = {
		vertical_alignment = "top",
		parent = "right_panel_content",
		horizontal_alignment = "center",
		size = right_header_size,
		position = {
			0,
			-(right_header_size[2] + ElementSettings.section_buffer),
			0
		}
	},
	buff_pivot = {
		vertical_alignment = "top",
		parent = "left_panel",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			180,
			1
		}
	},
	buff_panel_background = {
		vertical_alignment = "top",
		parent = "buff_pivot",
		horizontal_alignment = "left",
		size = {
			400,
			800
		},
		position = {
			0,
			0,
			1
		}
	},
	buff_panel = {
		vertical_alignment = "top",
		parent = "buff_pivot",
		horizontal_alignment = "left",
		size = {
			400,
			760
		},
		position = {
			0,
			20,
			1
		}
	},
	buff_panel_content = {
		vertical_alignment = "left",
		parent = "buff_panel",
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
	buff_panel_mask = {
		vertical_alignment = "center",
		parent = "buff_panel",
		horizontal_alignment = "center",
		size = {
			440,
			800
		},
		position = {
			0,
			0,
			2
		}
	},
	buff_panel_scrollbar = {
		vertical_alignment = "center",
		parent = "buff_panel",
		horizontal_alignment = "right",
		size = {
			8,
			760
		},
		position = {
			0,
			0,
			3
		}
	}
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/hud/tactical_overlay_background",
			pass_type = "texture",
			style = {
				color = {
					255,
					0,
					0,
					0
				}
			}
		}
	}, "background"),
	buff_panel_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "buff_panel_scrollbar", {
		using_custom_gamepad_navigation = true
	}),
	buff_panel_scrollbar_input_icon = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = table.merge(table.clone(UIFontSettings.input_legend_button), {
				text_vertical_alignment = "bottom",
				text_horizontal_alignment = "right",
				offset = {
					-15,
					40,
					0
				},
				text_color = {
					255,
					169,
					191,
					153
				}
			})
		}
	}, "buff_panel_mask", {
		visible = false
	}),
	buff_panel_background = UIWidget.create_definition({
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				color = Color.black(127.5, true)
			}
		}
	}, "buff_panel_background", {
		visible = false
	})
}

local function generate_currency_passes(currency_texture)
	local default_texture = "content/ui/materials/icons/currencies/credits_small"

	return {
		{
			style_id = "reward_background",
			pass_type = "rect",
			style = {
				color = {
					200,
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/gradients/gradient_vertical",
			style_id = "reward_gradient",
			pass_type = "texture",
			style = {
				color = {
					32,
					169,
					211,
					158
				},
				offset = {
					0,
					0,
					1
				}
			}
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "reward_frame",
			pass_type = "texture",
			style = {
				scale_to_material = true,
				color = Color.terminal_frame(255, true),
				offset = {
					0,
					0,
					2
				}
			}
		},
		{
			style_id = "reward_icon",
			pass_type = "texture",
			value = currency_texture or default_texture,
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					28,
					20
				},
				offset = {
					0,
					0,
					3
				}
			}
		},
		{
			value_id = "amount_id",
			style_id = "reward_text",
			pass_type = "text",
			value = "0",
			style = {
				font_type = "proxima_nova_bold",
				font_size = 20,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "right",
				text_color = Color.terminal_text_body(255, true),
				offset = {
					-28,
					0,
					3
				}
			}
		}
	}
end

local left_panel_widgets_definitions = {
	danger_info = UIWidget.create_definition({
		{
			value = "content/ui/materials/buttons/rhombus",
			style_id = "difficulty_background",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = {
					255,
					169,
					191,
					153
				},
				offset = {
					-6.399999999999999,
					-2,
					5
				},
				size = {
					72.8,
					72.8
				}
			}
		},
		{
			value_id = "difficulty_icon",
			style_id = "difficulty_icon",
			pass_type = "texture",
			value = "content/ui/materials/icons/difficulty/difficulty_skull_uprising",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = Color.white(255, true),
				offset = {
					-0.8000000000000043,
					2,
					7
				},
				size = {
					61.599999999999994,
					61.599999999999994
				}
			}
		},
		{
			style_id = "difficulty_name",
			value_id = "difficulty_name",
			pass_type = "text",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				text_vertical_alignment = "top",
				font_size = 34,
				text_horizontal_alignment = "left",
				offset = {
					65,
					-40,
					10
				},
				size = {
					mission_info_size[1] + 100,
					50
				},
				text_color = {
					255,
					169,
					191,
					153
				}
			}
		}
	}, "mission_info_panel", nil, nil, element_styles.difficulty),
	mission_info = UIWidget.create_definition({
		{
			value = "content/ui/materials/icons/generic/danger",
			value_id = "icon",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Color.terminal_text_header(255, true),
				offset = {
					0,
					25,
					2
				},
				size = {
					60,
					60
				}
			}
		},
		{
			style_id = "mission_name",
			value_id = "mission_name",
			pass_type = "text",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				text_vertical_alignment = "top",
				font_size = 34,
				text_horizontal_alignment = "left",
				offset = {
					65,
					15,
					10
				},
				size = {
					mission_info_size[1] + 100,
					50
				},
				text_color = {
					255,
					169,
					191,
					153
				}
			}
		},
		{
			style_id = "mission_type",
			value_id = "mission_type",
			pass_type = "text",
			style = {
				vertical_alignment = "bottom",
				text_vertical_alignment = "top",
				horizontal_alignment = "center",
				text_horizontal_alignment = "left",
				offset = {
					65,
					0,
					10
				},
				size = {
					mission_info_size[1],
					50
				},
				text_color = {
					255,
					169,
					191,
					153
				}
			}
		}
	}, "mission_info_panel"),
	circumstance_info = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/backgrounds/fade_horizontal",
			pass_type = "texture_uv",
			style = {
				color = Color.terminal_background(160, true),
				offset = {
					0,
					0,
					-3
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
			value = "content/ui/materials/backgrounds/default_square",
			pass_type = "rect",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				size = {
					3
				},
				color = Color.golden_rod(255, true)
			}
		},
		{
			pass_type = "text",
			value = Utf8.upper(Localize("loc_glossary_term_circumstance_hazard")),
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				offset = {
					0,
					-40,
					10
				},
				size = {
					nil,
					30
				},
				text_color = {
					255,
					169,
					191,
					153
				}
			}
		},
		{
			value_id = "icon",
			style_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/icons/generic/danger",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = Color.golden_rod(255, true),
				offset = {
					25,
					20,
					2
				},
				size = {
					40,
					40
				}
			}
		},
		{
			style_id = "circumstance_name",
			value_id = "circumstance_name",
			pass_type = "text",
			style = {
				vertical_alignment = "top",
				text_vertical_alignment = "center",
				horizontal_alignment = "left",
				text_horizontal_alignment = "left",
				offset = {
					75,
					20,
					10
				},
				size = {
					circumstance_info_size[1] - 75,
					40
				},
				text_color = Color.golden_rod(255, true)
			}
		},
		{
			style_id = "circumstance_description",
			value_id = "circumstance_description",
			pass_type = "text",
			style = {
				vertical_alignment = "top",
				text_vertical_alignment = "top",
				horizontal_alignment = "left",
				text_horizontal_alignment = "left",
				offset = {
					25,
					60,
					10
				},
				size = {
					circumstance_info_size[1] - 25,
					60
				},
				text_color = {
					255,
					169,
					191,
					153
				}
			}
		}
	}, "circumstance_info_panel"),
	plasteel_info = UIWidget.create_definition(generate_currency_passes("content/ui/materials/icons/currencies/plasteel_small"), "crafting_pickup_panel", nil, currency_info_size),
	diamantine_info = UIWidget.create_definition(generate_currency_passes("content/ui/materials/icons/currencies/diamantine_small"), "crafting_pickup_panel", nil, currency_info_size),
	havoc_rank_info = UIWidget.create_definition({
		{
			value = "content/ui/materials/icons/generic/havoc",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = {
					255,
					169,
					191,
					153
				},
				offset = {
					5,
					5,
					2
				},
				size = {
					50,
					50
				}
			}
		},
		{
			style_id = "havoc_text",
			value_id = "havoc_text",
			pass_type = "text",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				text_vertical_alignment = "top",
				font_size = 34,
				text_horizontal_alignment = "left",
				offset = {
					60,
					-45,
					2
				},
				size = {
					mission_info_size[1] + 100,
					50
				},
				text_color = {
					255,
					169,
					191,
					153
				}
			}
		},
		{
			style_id = "havoc_rank",
			value_id = "havoc_rank",
			pass_type = "text",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				text_vertical_alignment = "top",
				font_size = 34,
				text_horizontal_alignment = "left",
				offset = {
					420,
					-45,
					2
				},
				size = {
					mission_info_size[1] + 100,
					50
				},
				text_color = Color.golden_rod(255, true)
			}
		}
	}, "mission_info_panel", nil, nil, element_styles.difficulty),
	havoc_circumstance_info = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/backgrounds/fade_horizontal",
			pass_type = "texture_uv",
			style = {
				color = Color.terminal_background(160, true),
				offset = {
					0,
					0,
					-3
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
			value = "content/ui/materials/backgrounds/default_square",
			pass_type = "rect",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				size = {
					3
				},
				color = Color.golden_rod(255, true)
			}
		},
		{
			pass_type = "text",
			value = Utf8.upper(Localize("loc_havoc_mutators")),
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				offset = {
					0,
					-40,
					10
				},
				size = {
					nil,
					30
				},
				text_color = {
					255,
					169,
					191,
					153
				}
			}
		},
		{
			value_id = "icon_01",
			style_id = "icon_01",
			pass_type = "texture",
			value = "content/ui/materials/icons/generic/danger",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = Color.golden_rod(255, true),
				offset = {
					25,
					0,
					2
				},
				size = {
					40,
					40
				}
			}
		},
		{
			value_id = "icon_02",
			style_id = "icon_02",
			pass_type = "texture",
			value = "content/ui/materials/icons/generic/danger",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = Color.golden_rod(255, true),
				offset = {
					25,
					115,
					2
				},
				size = {
					40,
					40
				}
			}
		},
		{
			value_id = "icon_03",
			style_id = "icon_03",
			pass_type = "texture",
			value = "content/ui/materials/icons/generic/danger",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = Color.golden_rod(255, true),
				offset = {
					25,
					230,
					2
				},
				size = {
					40,
					40
				}
			}
		},
		{
			value_id = "icon_04",
			style_id = "icon_04",
			pass_type = "texture",
			value = "content/ui/materials/icons/generic/danger",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = Color.golden_rod(255, true),
				offset = {
					25,
					345,
					2
				},
				size = {
					40,
					40
				}
			}
		},
		{
			style_id = "circumstance_name_01",
			value_id = "circumstance_name_01",
			pass_type = "text",
			style = {
				vertical_alignment = "top",
				text_vertical_alignment = "center",
				horizontal_alignment = "left",
				text_horizontal_alignment = "left",
				offset = {
					75,
					0,
					10
				},
				size = {
					400,
					40
				},
				text_color = Color.golden_rod(255, true)
			}
		},
		{
			style_id = "circumstance_name_02",
			value_id = "circumstance_name_02",
			pass_type = "text",
			style = {
				vertical_alignment = "top",
				text_vertical_alignment = "center",
				horizontal_alignment = "left",
				text_horizontal_alignment = "left",
				offset = {
					75,
					115,
					10
				},
				size = {
					400,
					40
				},
				text_color = Color.golden_rod(255, true)
			}
		},
		{
			style_id = "circumstance_name_03",
			value_id = "circumstance_name_03",
			pass_type = "text",
			style = {
				vertical_alignment = "top",
				text_vertical_alignment = "center",
				horizontal_alignment = "left",
				text_horizontal_alignment = "left",
				offset = {
					75,
					230,
					10
				},
				size = {
					400,
					40
				},
				text_color = Color.golden_rod(255, true)
			}
		},
		{
			style_id = "circumstance_name_04",
			value_id = "circumstance_name_04",
			pass_type = "text",
			style = {
				vertical_alignment = "top",
				text_vertical_alignment = "center",
				horizontal_alignment = "left",
				text_horizontal_alignment = "left",
				offset = {
					75,
					345,
					10
				},
				size = {
					400,
					40
				},
				text_color = Color.golden_rod(255, true)
			}
		},
		{
			style_id = "circumstance_description_01",
			value_id = "circumstance_description_01",
			pass_type = "text",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = 20,
				text_vertical_alignment = "top",
				text_horizontal_alignment = "left",
				offset = {
					80,
					40,
					10
				},
				size = {
					500,
					25
				},
				text_color = {
					255,
					169,
					191,
					153
				}
			}
		},
		{
			style_id = "circumstance_description_02",
			value_id = "circumstance_description_02",
			pass_type = "text",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = 20,
				text_vertical_alignment = "top",
				text_horizontal_alignment = "left",
				offset = {
					80,
					155,
					10
				},
				size = {
					500,
					25
				},
				text_color = {
					255,
					169,
					191,
					153
				}
			}
		},
		{
			style_id = "circumstance_description_03",
			value_id = "circumstance_description_03",
			pass_type = "text",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = 20,
				text_vertical_alignment = "top",
				text_horizontal_alignment = "left",
				offset = {
					80,
					270,
					10
				},
				size = {
					500,
					25
				},
				text_color = {
					255,
					169,
					191,
					153
				}
			}
		},
		{
			style_id = "circumstance_description_04",
			value_id = "circumstance_description_04",
			pass_type = "text",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = 20,
				text_vertical_alignment = "top",
				text_horizontal_alignment = "left",
				offset = {
					80,
					385,
					10
				},
				size = {
					500,
					25
				},
				text_color = {
					255,
					169,
					191,
					153
				}
			}
		}
	}, "circumstance_info_panel")
}
local right_panel_widgets_definitions = {
	right_header_title = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				text_vertical_alignment = "center",
				font_size = 24,
				text_horizontal_alignment = "left",
				offset = {
					buffer,
					0,
					1
				},
				size = {
					ElementSettings.right_grid_width,
					ElementSettings.right_header_height
				},
				text_color = Color.terminal_text_header(255, true)
			}
		}
	}, "right_panel_header"),
	right_header_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/masks/gradient_vignette",
			style_id = "rect",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					ElementSettings.right_grid_width + ElementSettings.right_header_height,
					ElementSettings.right_header_height
				},
				offset = {
					-ElementSettings.right_header_height / 2,
					0,
					0
				},
				color = {
					100,
					0,
					0,
					0
				}
			}
		}
	}, "right_panel_header"),
	right_header_stick = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "rect",
			pass_type = "rect",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				offset = {
					line_width,
					0,
					0
				},
				size = {
					line_width,
					ElementSettings.right_header_height
				},
				color = Color.terminal_corner_hover(255, true)
			}
		}
	}, "right_panel_header"),
	right_grid_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/gradients/gradient_horizontal",
			style_id = "rect",
			pass_type = "texture",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					ElementSettings.right_grid_width,
					0
				},
				color = Color.terminal_grid_background_gradient(100, true)
			}
		}
	}, "right_panel_content"),
	right_grid_stick = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "rect",
			pass_type = "rect",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				offset = {
					line_width,
					0,
					0
				},
				size = {
					line_width,
					0
				},
				color = Color.terminal_corner_hover(255, true)
			}
		}
	}, "right_panel_content"),
	right_input_hint = UIWidget.create_definition({
		{
			value_id = "hint",
			style_id = "hint",
			pass_type = "text",
			value = "<UNDEFINED>",
			style = {
				vertical_alignment = "top",
				text_vertical_alignment = "top",
				font_size = 18,
				horizontal_alignment = "right",
				text_horizontal_alignment = "right",
				size = {
					ElementSettings.right_grid_width,
					100
				},
				text_color = Color.text_default(255, true)
			}
		}
	}, "right_panel_content"),
	right_timer = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "stick",
			pass_type = "rect",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				offset = {
					line_width,
					-(ElementSettings.right_timer_height + ElementSettings.section_buffer),
					0
				},
				size = {
					line_width,
					ElementSettings.right_timer_height
				},
				color = Color.terminal_corner_hover(255, true)
			}
		},
		{
			value = "content/ui/materials/gradients/gradient_horizontal",
			style_id = "background",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				offset = {
					0,
					-(ElementSettings.right_timer_height + ElementSettings.section_buffer),
					0
				},
				size = {
					ElementSettings.right_grid_width / 2,
					ElementSettings.right_timer_height
				},
				color = Color.terminal_grid_background_gradient(100, true)
			}
		},
		{
			value_id = "time_left",
			style_id = "time_left",
			pass_type = "text",
			value = "<UNDEFINED>",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				text_vertical_alignment = "top",
				font_size = 18,
				text_horizontal_alignment = "right",
				offset = {
					-ElementSettings.buffer,
					5 - (ElementSettings.right_timer_height + ElementSettings.section_buffer),
					1
				},
				size = {
					ElementSettings.right_grid_width / 2,
					ElementSettings.right_timer_height
				},
				text_color = Color.ui_input_color(255, true)
			}
		},
		{
			value_id = "time_name",
			style_id = "time_name",
			pass_type = "text",
			value = "<UNDEFINED>",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				text_vertical_alignment = "top",
				font_size = 18,
				text_horizontal_alignment = "right",
				offset = {
					0,
					5 - (ElementSettings.right_timer_height + ElementSettings.section_buffer),
					1
				},
				size = {
					ElementSettings.right_grid_width / 2,
					ElementSettings.right_timer_height
				},
				text_color = Color.terminal_text_header(255, true)
			}
		}
	}, "right_panel_header")
}

local function for_all_left_widgets(parent, func)
	local left_panel_widgets = parent._left_panel_widgets

	for _, widget in ipairs(left_panel_widgets) do
		func(widget)
	end
end

local function for_all_right_widgets(parent, func)
	local right_panel_widgets = parent._right_panel_widgets

	for _, widget in ipairs(right_panel_widgets) do
		func(widget)
	end

	local right_panel_entries = parent._right_panel_entries

	for _, widgets in pairs(right_panel_entries) do
		for _, widget in ipairs(widgets) do
			func(widget)
		end
	end

	local tab_bar_widgets = parent._tab_bar_widgets
	local tab_bar_widgets_size = tab_bar_widgets and #tab_bar_widgets or 0

	for i = 1, tab_bar_widgets_size do
		local widget = tab_bar_widgets[i]

		func(widget)
	end
end

local animations = {
	enter = {
		{
			name = "reset",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local start_pos = left_panel_x_position - details_panel_size[1]

				parent:set_scenegraph_position("left_panel", start_pos)
				for_all_left_widgets(parent, function (widget)
					widget.alpha_multiplier = 0
				end)
				for_all_right_widgets(parent, function (widget)
					widget.alpha_multiplier = 0
				end)
			end
		},
		{
			name = "left_panel_enter",
			end_time = 0.5,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local new_pos = left_panel_x_position - details_panel_size[1] + details_panel_size[1] * math.easeOutCubic(progress)

				parent:set_scenegraph_position("left_panel", new_pos)
				for_all_left_widgets(parent, function (widget)
					widget.alpha_multiplier = progress
				end)

				return true
			end
		},
		{
			name = "right_panel_enter",
			end_time = 0.5,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local panel_width = ElementSettings.right_grid_width
				local new_pos = panel_width * (1 - math.easeOutCubic(progress))

				parent:set_scenegraph_position("right_panel", new_pos)
				for_all_right_widgets(parent, function (widget)
					widget.alpha_multiplier = progress
				end)

				return true
			end
		}
	},
	exit = {
		{
			name = "left_panel_exit",
			end_time = 0.5,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local new_pos = left_panel_x_position - details_panel_size[1] * math.easeOutCubic(progress)

				parent:set_scenegraph_position("left_panel", new_pos)
				for_all_left_widgets(parent, function (widget)
					widget.alpha_multiplier = 1 - progress
				end)

				return true
			end
		},
		{
			name = "right_panel_exit",
			end_time = 0.5,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local panel_width = ElementSettings.right_grid_width
				local new_pos = panel_width * math.easeOutCubic(progress)

				parent:set_scenegraph_position("right_panel", new_pos)
				for_all_right_widgets(parent, function (widget)
					widget.alpha_multiplier = 1 - progress
				end)

				return true
			end
		}
	}
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	left_panel_widgets_definitions = left_panel_widgets_definitions,
	right_panel_widgets_definitions = right_panel_widgets_definitions
}
