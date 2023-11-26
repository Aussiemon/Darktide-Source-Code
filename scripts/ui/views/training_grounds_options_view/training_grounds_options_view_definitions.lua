-- chunkname: @scripts/ui/views/training_grounds_options_view/training_grounds_options_view_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local StepperPassTemplates = require("scripts/ui/pass_templates/stepper_pass_templates")
local TrainingGroundsOptionsViewStyles = require("scripts/ui/views/training_grounds_options_view/training_grounds_options_view_styles")
local TrainingGroundsOptionsViewSettings = require("scripts/ui/views/training_grounds_options_view/training_grounds_options_view_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local get_hud_color = UIHudSettings.get_hud_color
local view_styles = TrainingGroundsOptionsViewStyles
local left_panel_size = TrainingGroundsOptionsViewSettings.panel_size.default
local reward_size = {
	288,
	153.6
}
local weapon_size = {
	288,
	153.6
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	left_panel = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "left",
		size = left_panel_size,
		position = {
			100,
			-60,
			10
		}
	},
	header = {
		vertical_alignment = "top",
		parent = "left_panel",
		horizontal_alignment = "center",
		size = {
			600,
			50
		},
		position = {
			0,
			40,
			10
		}
	},
	sub_header = {
		vertical_alignment = "top",
		parent = "left_panel",
		horizontal_alignment = "center",
		size = {
			600,
			50
		},
		position = {
			0,
			70,
			10
		}
	},
	header_separator = {
		vertical_alignment = "top",
		parent = "left_panel",
		horizontal_alignment = "center",
		size = {
			600,
			50
		},
		position = {
			0,
			125,
			10
		}
	},
	body = {
		vertical_alignment = "top",
		parent = "left_panel",
		horizontal_alignment = "center",
		size = {
			600,
			250
		},
		position = {
			0,
			155,
			10
		}
	},
	separator = {
		vertical_alignment = "bottom",
		parent = "body",
		horizontal_alignment = "center",
		size = {
			600,
			3
		},
		position = {
			0,
			-100,
			10
		}
	},
	rewards_header = {
		vertical_alignment = "bottom",
		parent = "body",
		horizontal_alignment = "center",
		size = {
			600,
			40
		},
		position = {
			0,
			-40,
			10
		}
	},
	reward_one = {
		vertical_alignment = "bottom",
		parent = "left_panel",
		horizontal_alignment = "center",
		size = reward_size,
		position = {
			-160,
			-120,
			10
		}
	},
	reward_two = {
		vertical_alignment = "bottom",
		parent = "left_panel",
		horizontal_alignment = "center",
		size = reward_size,
		position = {
			160,
			-120,
			10
		}
	},
	play_button = {
		vertical_alignment = "bottom",
		parent = "left_panel",
		horizontal_alignment = "center",
		size = {
			300,
			60
		},
		position = {
			0,
			60,
			10
		}
	},
	difficulty_stepper = {
		vertical_alignment = "bottom",
		parent = "separator",
		horizontal_alignment = "center",
		size = {
			600,
			60
		},
		position = {
			0,
			130,
			10
		}
	}
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			value_id = "background",
			style_id = "background",
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				scale_to_material = true,
				size = {
					left_panel_size[1] - 40,
					left_panel_size[2] + 135
				},
				offset = {
					-10,
					0,
					0
				},
				size_addition = {
					60,
					6
				},
				color = Color.terminal_grid_background(nil, true)
			}
		}
	}, "left_panel", nil, nil),
	header = UIWidget.create_definition({
		{
			style_id = "header",
			value_id = "header",
			pass_type = "text",
			style = view_styles.header_font_style
		},
		{
			style_id = "sub_header",
			value_id = "sub_header",
			pass_type = "text",
			style = view_styles.sub_header_font_style
		}
	}, "header"),
	header_separator = UIWidget.create_definition({
		{
			value_id = "divider",
			style_id = "divider",
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_center_02",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					400,
					18
				},
				offset = {
					0,
					-6,
					1
				},
				color = Color.terminal_frame(255, true)
			}
		}
	}, "header_separator"),
	body = UIWidget.create_definition({
		{
			style_id = "body_text",
			value_id = "body_text",
			pass_type = "text",
			style = view_styles.body_font_style
		}
	}, "body"),
	separator = UIWidget.create_definition({
		{
			value_id = "separator",
			style_id = "separator",
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				color = {
					50,
					255,
					255,
					255
				}
			}
		}
	}, "separator"),
	rewards_header = UIWidget.create_definition({
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			style = view_styles.rewards_header_font_style
		}
	}, "rewards_header"),
	reward_1 = UIWidget.create_definition({
		{
			value_id = "icon",
			style_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/icons/items/containers/item_container_landscape_no_rarity",
			style = {
				horizontal_alignment = "center",
				size = weapon_size,
				default_size = weapon_size,
				offset = {
					0,
					0,
					2
				},
				color = {
					255,
					255,
					255,
					255
				},
				material_values = {
					use_placeholder_texture = 1
				}
			}
		},
		{
			value_id = "reward_1",
			style_id = "reward_1",
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				color = Color.black(60, true)
			}
		},
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "text",
			style = view_styles.reward_font_style
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "diffulty_icon_background_frame",
			pass_type = "texture",
			style = {
				offset = {
					0,
					0,
					10
				},
				color = Color.terminal_text_body_dark(255, true)
			}
		},
		{
			value = "content/ui/materials/frames/frame_corner_2px",
			style_id = "diffulty_icon_background_frame_corner",
			pass_type = "texture",
			style = {
				offset = {
					0,
					0,
					11
				},
				color = Color.terminal_text_body(255, true)
			}
		}
	}, "reward_one"),
	reward_2 = UIWidget.create_definition({
		{
			value_id = "reward_2",
			style_id = "reward_2",
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				color = Color.black(60, true)
			}
		},
		{
			value_id = "icon",
			style_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/icons/items/containers/item_container_landscape_no_rarity",
			style = {
				horizontal_alignment = "center",
				size = weapon_size,
				default_size = weapon_size,
				offset = {
					0,
					0,
					2
				},
				color = {
					255,
					255,
					255,
					255
				},
				material_values = {
					use_placeholder_texture = 1
				}
			}
		},
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "text",
			style = view_styles.reward_font_style
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "diffulty_icon_background_frame",
			pass_type = "texture",
			style = {
				offset = {
					0,
					0,
					10
				},
				color = Color.terminal_text_body_dark(255, true)
			}
		},
		{
			value = "content/ui/materials/frames/frame_corner_2px",
			style_id = "diffulty_icon_background_frame_corner",
			pass_type = "texture",
			style = {
				offset = {
					0,
					0,
					11
				},
				color = Color.terminal_text_body(255, true)
			}
		}
	}, "reward_two"),
	play_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "play_button", {
		original_text = "PLAY BASIC"
	}),
	edge_top = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/training_grounds_upper",
			style_id = "texture",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size_addition = {
					0,
					0
				},
				offset = {
					0,
					-116,
					11
				},
				size = {
					840,
					200
				}
			}
		}
	}, "left_panel"),
	edge_bottom = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/training_grounds_lower",
			style_id = "texture",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size_addition = {
					0,
					0
				},
				offset = {
					0,
					185,
					11
				},
				size = {
					740,
					120
				}
			}
		}
	}, "left_panel"),
	select_difficulty_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = view_styles.select_difficulty_text_style
		}
	}, "difficulty_stepper"),
	difficulty_stepper = UIWidget.create_definition(StepperPassTemplates.difficulty_stepper, "difficulty_stepper")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
