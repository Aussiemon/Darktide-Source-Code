-- chunkname: @scripts/ui/views/group_finder_view/group_finder_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local ProfileUtils = require("scripts/utilities/profile_utils")
local group_window_size = {
	1000,
	600
}
local group_list_height = 0
local group_list_spacing_top = 0
local group_list_spacing_bottom = 55
local group_grid_size = {
	group_window_size[1] - 40,
	group_window_size[2] - (0 + group_list_height + group_list_spacing_top + group_list_spacing_bottom)
}
local GroupFinderBlueprintsGenerateFunction = require("scripts/ui/views/group_finder_view/group_finder_blueprints")
local groups_blueprints = GroupFinderBlueprintsGenerateFunction(group_grid_size)
local tag_window_size = {
	600,
	905
}
local tag_window_header_height = 180
local tag_list_height = 40
local tag_list_spacing_top = 10
local tag_list_spacing_bottom = 220
local tag_grid_size = {
	tag_window_size[1] - 40,
	tag_window_size[2] - (tag_window_header_height + tag_list_height + tag_list_spacing_top + tag_list_spacing_bottom)
}
local preview_window_size = {
	800,
	905
}
local preview_grid_size = {
	preview_window_size[1],
	preview_window_size[2] - 40
}
local player_window_size = {
	800,
	530
}
local player_grid_height_spacing = 0
local player_grid_bottom_spacing = 60
local player_grid_size = {
	player_window_size[1] - 40,
	player_window_size[2] - (player_grid_height_spacing + player_grid_bottom_spacing)
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
			3
		}
	},
	page_header = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			1300,
			80
		},
		position = {
			0,
			20,
			0
		}
	},
	tag_window = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = tag_window_size,
		position = {
			30,
			20,
			10
		}
	},
	tags_grid = {
		vertical_alignment = "bottom",
		parent = "tag_window",
		horizontal_alignment = "center",
		size = tag_grid_size,
		position = {
			-5,
			-(20 + tag_list_spacing_bottom + 60 - 40),
			1
		}
	},
	category_description = {
		vertical_alignment = "top",
		parent = "tag_window",
		horizontal_alignment = "center",
		size = {
			tag_grid_size[1],
			70
		},
		position = {
			0,
			85,
			1
		}
	},
	previous_filter_button = {
		vertical_alignment = "bottom",
		parent = "tag_window",
		horizontal_alignment = "center",
		size = {
			220,
			40
		},
		position = {
			0,
			-160,
			1
		}
	},
	start_group_header = {
		vertical_alignment = "top",
		parent = "tag_window",
		horizontal_alignment = "center",
		size = {
			player_window_size[1],
			100
		},
		position = {
			0,
			0,
			1
		}
	},
	start_group_button = {
		vertical_alignment = "bottom",
		parent = "tag_window",
		horizontal_alignment = "center",
		size = {
			300,
			40
		},
		position = {
			0,
			5,
			1
		}
	},
	start_group_button_header = {
		vertical_alignment = "top",
		parent = "start_group_button",
		horizontal_alignment = "center",
		size = {
			player_window_size[1],
			40
		},
		position = {
			0,
			-60,
			1
		}
	},
	start_group_button_level_warning = {
		vertical_alignment = "bottom",
		parent = "start_group_button",
		horizontal_alignment = "center",
		size = {
			player_window_size[1] - 140,
			40
		},
		position = {
			0,
			75,
			1
		}
	},
	start_group_button_party_full_warning = {
		vertical_alignment = "bottom",
		parent = "start_group_button",
		horizontal_alignment = "center",
		size = {
			player_window_size[1] - 140,
			40
		},
		position = {
			0,
			75,
			1
		}
	},
	filter_page_divider_bottom = {
		vertical_alignment = "bottom",
		parent = "tags_grid",
		horizontal_alignment = "center",
		size = {
			468,
			16
		},
		position = {
			0,
			35,
			1
		}
	},
	filter_page_divider_top = {
		vertical_alignment = "top",
		parent = "tags_grid",
		horizontal_alignment = "center",
		size = {
			468,
			16
		},
		position = {
			0,
			-10,
			1
		}
	},
	created_group_party_title = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			player_window_size[1],
			40
		},
		position = {
			110,
			300,
			1
		}
	},
	own_group_presentation = {
		vertical_alignment = "bottom",
		parent = "created_group_party_title",
		horizontal_alignment = "center",
		size = groups_blueprints.group.size,
		position = {
			0,
			-90,
			1
		}
	},
	team_member_1 = {
		vertical_alignment = "top",
		parent = "created_group_party_title",
		horizontal_alignment = "center",
		size = {
			player_window_size[1] - 40,
			110
		},
		position = {
			0,
			60,
			1
		}
	},
	team_member_2 = {
		vertical_alignment = "bottom",
		parent = "team_member_1",
		horizontal_alignment = "center",
		size = {
			player_window_size[1] - 40,
			110
		},
		position = {
			0,
			140,
			1
		}
	},
	team_member_3 = {
		vertical_alignment = "bottom",
		parent = "team_member_2",
		horizontal_alignment = "center",
		size = {
			player_window_size[1] - 40,
			110
		},
		position = {
			0,
			140,
			1
		}
	},
	team_member_4 = {
		vertical_alignment = "bottom",
		parent = "team_member_3",
		horizontal_alignment = "center",
		size = {
			player_window_size[1] - 40,
			110
		},
		position = {
			0,
			140,
			1
		}
	},
	player_request_grid_title = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			player_window_size[1],
			40
		},
		position = {
			-110,
			300,
			1
		}
	},
	player_request_window = {
		vertical_alignment = "top",
		parent = "player_request_grid_title",
		horizontal_alignment = "center",
		size = player_window_size,
		position = {
			0,
			60,
			1
		}
	},
	player_request_grid = {
		vertical_alignment = "top",
		parent = "player_request_window",
		horizontal_alignment = "center",
		size = player_grid_size,
		position = {
			0,
			player_grid_height_spacing,
			1
		}
	},
	player_request_button_accept = {
		vertical_alignment = "bottom",
		parent = "player_request_window",
		horizontal_alignment = "right",
		size = {
			400,
			40
		},
		position = {
			-10,
			0,
			1
		}
	},
	player_request_button_decline = {
		vertical_alignment = "bottom",
		parent = "player_request_window",
		horizontal_alignment = "right",
		size = {
			400,
			40
		},
		position = {
			-10,
			0,
			1
		}
	},
	cancel_group_button = {
		vertical_alignment = "bottom",
		parent = "team_member_4",
		horizontal_alignment = "center",
		size = {
			340,
			45
		},
		position = {
			0,
			90,
			1
		}
	},
	player_searching_indication = {
		vertical_alignment = "bottom",
		parent = "player_request_grid_title",
		horizontal_alignment = "center",
		size = {
			800,
			500
		},
		position = {
			0,
			-30,
			1
		}
	},
	group_window = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "right",
		size = group_window_size,
		position = {
			-45,
			205,
			10
		}
	},
	group_grid = {
		vertical_alignment = "bottom",
		parent = "group_window",
		horizontal_alignment = "center",
		size = group_grid_size,
		position = {
			-5,
			-(group_list_spacing_bottom + 5),
			3
		}
	},
	group_window_info = {
		vertical_alignment = "center",
		parent = "group_window",
		horizontal_alignment = "center",
		size = {
			group_window_size[1] - 40,
			group_window_size[2]
		},
		position = {
			0,
			2,
			1
		}
	},
	group_loading = {
		vertical_alignment = "center",
		parent = "group_window",
		horizontal_alignment = "center",
		size = group_window_size,
		position = {
			0,
			0,
			50
		}
	},
	join_button = {
		vertical_alignment = "bottom",
		parent = "group_window",
		horizontal_alignment = "right",
		size = {
			300,
			60
		},
		position = {
			0,
			80,
			1
		}
	},
	join_button_level_warning = {
		vertical_alignment = "top",
		parent = "join_button",
		horizontal_alignment = "right",
		size = {
			560,
			100
		},
		position = {
			0,
			90,
			1
		}
	},
	preview_input_text = {
		vertical_alignment = "bottom",
		parent = "group_window",
		horizontal_alignment = "left",
		size = {
			400,
			40
		},
		position = {
			10,
			40,
			1
		}
	},
	refresh_button = {
		vertical_alignment = "bottom",
		parent = "group_window",
		horizontal_alignment = "right",
		size = {
			400,
			40
		},
		position = {
			-10,
			0,
			1
		}
	},
	group_list_time_stamp = {
		vertical_alignment = "bottom",
		parent = "group_window",
		horizontal_alignment = "left",
		size = {
			800,
			40
		},
		position = {
			10,
			0,
			1
		}
	},
	preview_window = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "left",
		size = preview_window_size,
		position = {
			30,
			0,
			60
		}
	},
	preview_grid = {
		vertical_alignment = "center",
		parent = "preview_window",
		horizontal_alignment = "center",
		size = preview_grid_size,
		position = {
			0,
			-15,
			1
		}
	}
}
local terminal_button_highlighted_pass_template = table.clone_instance(ButtonPassTemplates.terminal_button)

terminal_button_highlighted_pass_template[#terminal_button_highlighted_pass_template + 1] = {
	pass_type = "texture",
	style_id = "outer_highlight",
	value = "content/ui/materials/frames/dropshadow_heavy",
	style = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		scale_to_material = true,
		color = Color.terminal_text_body(200, true),
		size_addition = {
			20,
			20
		},
		offset = {
			0,
			0,
			4
		}
	},
	change_function = function (content, style, _, dt)
		local hotspot = content.hotspot
		local disabled = hotspot.disabled
		local highlighted = content.highlighted
		local anim_speed = 2

		if anim_speed then
			local anim_highlight_progress = content.anim_highlight_progress or 0

			if highlighted and not disabled then
				anim_highlight_progress = math.min(anim_highlight_progress + dt * anim_speed, 1)
			else
				anim_highlight_progress = math.max(anim_highlight_progress - dt * anim_speed, 0)
			end

			content.anim_highlight_progress = anim_highlight_progress

			local pulse_speed = 3
			local pulse_progress = 1 - (0.5 + math.sin(Application.time_since_launch() * pulse_speed) * 0.5)

			style.color[1] = (50 + 100 * pulse_progress) * anim_highlight_progress
		end
	end
}

local function team_member_definition(scenegraph_id)
	return UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot",
			content = {}
		},
		{
			pass_type = "rect",
			style = {
				color = Color.black(100, true),
				offset = {
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					2
				},
				default_color = Color.terminal_frame(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				hover_color = Color.terminal_frame_hover(nil, true)
			},
			change_function = ButtonPassTemplates.default_button_hover_change_function
		},
		{
			value = "content/ui/materials/frames/frame_corner_2px",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					3
				},
				default_color = Color.terminal_corner(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true),
				hover_color = Color.terminal_corner_hover(nil, true)
			},
			change_function = ButtonPassTemplates.default_button_hover_change_function
		},
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.black(200, true),
				size_addition = {
					20,
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
			pass_type = "texture",
			value = "content/ui/materials/masks/gradient_horizontal_sides_dynamic_02",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					3
				},
				default_color = Color.terminal_corner(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true),
				hover_color = Color.terminal_corner_hover(nil, true)
			},
			change_function = ButtonPassTemplates.default_button_hover_change_function,
			visibility_function = function (content, style)
				return content.slot_filled
			end
		},
		{
			style_id = "empty_slot_text",
			value_id = "empty_slot_text",
			pass_type = "text",
			value = Localize("loc_group_finder_player_host_party_list_empty_slot"),
			style = {
				text_horizontal_alignment = "center",
				font_size = 30,
				vertical_alignment = "center",
				text_vertical_alignment = "center",
				horizontal_alignment = "center",
				font_type = "proxima_nova_bold",
				text_color = {
					255,
					70,
					70,
					70
				},
				disabled_color = {
					255,
					70,
					70,
					70
				},
				default_color = Color.terminal_frame(nil, true),
				hover_color = Color.terminal_frame_hover(nil, true),
				offset = {
					0,
					0,
					6
				}
			},
			visibility_function = function (content, style)
				return not content.slot_filled
			end
		},
		{
			value_id = "character_insignia",
			style_id = "character_insignia",
			pass_type = "texture",
			value = "content/ui/materials/base/ui_default_base",
			style = {
				vertical_alignment = "center",
				size = {
					40,
					100
				},
				offset = {
					20,
					0,
					5
				},
				material_values = {},
				color = {
					0,
					255,
					255,
					255
				}
			},
			visibility_function = function (content, style)
				return content.slot_filled
			end
		},
		{
			value_id = "character_portrait",
			style_id = "character_portrait",
			pass_type = "texture",
			value = "content/ui/materials/base/ui_portrait_frame_base",
			style = {
				vertical_alignment = "center",
				size = {
					90,
					100
				},
				offset = {
					60,
					0,
					6
				},
				material_values = {
					use_placeholder_texture = 1
				}
			},
			visibility_function = function (content, style)
				return content.slot_filled
			end
		},
		{
			style_id = "archetype_icon",
			pass_type = "texture",
			value = "content/ui/materials/icons/classes/veteran",
			value_id = "archetype_icon",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "right",
				size = {
					120,
					120
				},
				offset = {
					-15,
					0,
					4
				},
				default_color = Color.terminal_frame(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				hover_color = Color.terminal_frame_hover(nil, true)
			},
			change_function = ButtonPassTemplates.default_button_hover_change_function,
			visibility_function = function (content, style)
				return content.slot_filled
			end
		},
		{
			style_id = "character_name",
			pass_type = "text",
			value = "",
			value_id = "character_name",
			style = {
				text_horizontal_alignment = "left",
				font_size = 26,
				vertical_alignment = "center",
				text_vertical_alignment = "top",
				horizontal_alignment = "left",
				font_type = "proxima_nova_bold",
				text_color = {
					255,
					255,
					255,
					255
				},
				disabled_color = {
					255,
					120,
					120,
					120
				},
				default_color = Color.terminal_text_header(nil, true),
				hover_color = Color.terminal_text_header_selected(nil, true),
				size = {
					nil,
					30
				},
				offset = {
					180,
					-30,
					3
				}
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local default_color = hotspot.disabled and style.disabled_color or style.default_color
				local hover_color = style.hover_color
				local text_color = style.text_color
				local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

				ColorUtilities.color_lerp(default_color, hover_color, progress, text_color)
			end,
			visibility_function = function (content, style)
				return content.slot_filled
			end
		},
		{
			style_id = "character_title",
			pass_type = "text",
			value = "",
			value_id = "character_title",
			style = {
				text_horizontal_alignment = "left",
				font_size = 18,
				vertical_alignment = "center",
				text_vertical_alignment = "bottom",
				horizontal_alignment = "left",
				font_type = "proxima_nova_bold",
				text_color = {
					255,
					255,
					255,
					255
				},
				disabled_color = {
					255,
					120,
					120,
					120
				},
				default_color = Color.terminal_text_body(nil, true),
				hover_color = Color.terminal_text_header(nil, true),
				size = {
					nil,
					54
				},
				offset = {
					180,
					-16,
					3
				}
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local default_color = hotspot.disabled and style.disabled_color or style.default_color
				local hover_color = style.hover_color
				local text_color = style.text_color
				local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

				ColorUtilities.color_lerp(default_color, hover_color, progress, text_color)
			end,
			visibility_function = function (content, style)
				return content.slot_filled
			end
		},
		{
			style_id = "character_archetype_title",
			pass_type = "text",
			value = "text",
			value_id = "character_archetype_title",
			style = {
				text_horizontal_alignment = "left",
				font_size = 18,
				vertical_alignment = "center",
				text_vertical_alignment = "bottom",
				horizontal_alignment = "left",
				font_type = "proxima_nova_bold",
				text_color = {
					255,
					255,
					255,
					255
				},
				disabled_color = {
					255,
					120,
					120,
					120
				},
				default_color = Color.terminal_text_body(nil, true),
				hover_color = Color.terminal_text_body_sub_header(nil, true),
				size = {
					nil,
					54
				},
				offset = {
					180,
					12,
					3
				}
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local default_color = hotspot.disabled and style.disabled_color or style.default_color
				local hover_color = style.hover_color
				local text_color = style.text_color
				local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

				ColorUtilities.color_lerp(default_color, hover_color, progress, text_color)
			end,
			visibility_function = function (content, style)
				return content.slot_filled
			end
		},
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "outer_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.black(200, true),
				size_addition = {
					20,
					20
				},
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, scenegraph_id)
end

local widget_definitions = {
	own_group_presentation = UIWidget.create_definition(groups_blueprints.group.pass_template, "own_group_presentation"),
	page_header = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			style = {
				font_type = "machine_medium",
				font_size = 55,
				material = "content/ui/materials/font_gradients/slug_font_gradient_header",
				drop_shadow = true,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				text_color = Color.white(nil, true),
				offset = {
					0,
					0,
					1
				}
			},
			value = Localize("loc_group_finder_menu_title")
		}
	}, "page_header"),
	background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/panel_horizontal_half",
			pass_type = "texture",
			style = {
				offset = {
					0,
					0,
					1
				},
				color = {
					160,
					0,
					0,
					0
				}
			}
		},
		{
			scenegraph_id = "screen",
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					0
				},
				color = {
					60,
					0,
					0,
					0
				}
			}
		}
	}, "screen"),
	previous_filter_button = UIWidget.create_definition(terminal_button_highlighted_pass_template, "previous_filter_button", {
		gamepad_action = "back",
		original_text = Utf8.upper(Localize("loc_group_finder_navigation_back_button")),
		hotspot = {}
	}, nil, {
		text = {
			line_spacing = 1
		}
	}),
	join_button = UIWidget.create_definition(terminal_button_highlighted_pass_template, "join_button", {
		gamepad_action = "confirm_pressed",
		highlighted = true,
		original_text = Utf8.upper(Localize("loc_group_finder_join_request_button")),
		hotspot = {}
	}, nil, {
		text = {
			line_spacing = 1
		}
	}),
	refresh_button = UIWidget.create_definition(ButtonPassTemplates.input_legend_button, "refresh_button", {
		text = "",
		visible = true
	}),
	preview_input_text = UIWidget.create_definition(ButtonPassTemplates.input_legend_button, "preview_input_text", {
		text = "",
		visible = true
	}),
	player_request_button_accept = UIWidget.create_definition(ButtonPassTemplates.input_legend_button, "player_request_button_accept", {
		visible = true,
		text = Localize("loc_group_finder_player_request_action_accept")
	}),
	player_request_button_decline = UIWidget.create_definition(ButtonPassTemplates.input_legend_button, "player_request_button_decline", {
		visible = true,
		text = Localize("loc_group_finder_player_request_action_decline")
	}),
	group_list_time_stamp = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			value = "",
			style = {
				font_type = "proxima_nova_bold",
				font_size = 16,
				drop_shadow = true,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "left",
				text_color = {
					255,
					120,
					120,
					120
				},
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "group_list_time_stamp"),
	cancel_group_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button_hold_small, "cancel_group_button", {
		gamepad_action = "hotkey_menu_special_2",
		original_text = Utf8.upper(Localize("loc_group_finder_cancel_group_button")),
		hotspot = {}
	}, scenegraph_definition.cancel_group_button.size, {
		text = {
			line_spacing = 1
		}
	}),
	start_group_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "start_group_button", {
		gamepad_action = "hotkey_menu_special_2",
		original_text = Utf8.upper(Localize("loc_group_finder_create_group_button")),
		hotspot = {}
	}, nil, {
		text = {
			line_spacing = 1
		}
	}),
	start_group_button_header = UIWidget.create_definition({
		{
			value = "content/ui/materials/dividers/skull_center_01",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					380,
					30
				},
				color = Color.terminal_corner(255, true),
				offset = {
					0,
					25,
					0
				}
			}
		},
		{
			value_id = "header_1",
			style_id = "header_1",
			pass_type = "text",
			value = Localize("loc_group_finder_create_group_button_header"),
			style = {
				vertical_alignment = "center",
				font_size = 24,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				text_color = Color.terminal_text_body(255, true),
				offset = {
					0,
					-10,
					3
				}
			}
		}
	}, "start_group_button_header"),
	start_group_button_level_warning = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = Localize("loc_group_finder_party_member_failed_level_requirements"),
			style = {
				vertical_alignment = "center",
				font_size = 24,
				horizontal_alignment = "center",
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				text_color = {
					255,
					159,
					67,
					67
				},
				offset = {
					0,
					0,
					3
				}
			},
			visibility_function = function (content, style)
				return not content.level_requirement_met
			end
		}
	}, "start_group_button_level_warning"),
	start_group_button_party_full_warning = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = Localize("loc_social_party_join_rejection_reason_party_full"),
			style = {
				vertical_alignment = "center",
				font_size = 24,
				horizontal_alignment = "center",
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				text_color = {
					255,
					159,
					67,
					67
				},
				offset = {
					0,
					0,
					3
				}
			},
			visibility_function = function (content, style)
				return content.is_party_full
			end
		}
	}, "start_group_button_party_full_warning"),
	join_button_level_warning = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = Localize("loc_group_finder_tag_level_requirement_warning"),
			style = {
				vertical_alignment = "center",
				font_size = 24,
				horizontal_alignment = "center",
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "top",
				text_horizontal_alignment = "right",
				text_color = {
					255,
					159,
					67,
					67
				},
				offset = {
					0,
					0,
					3
				}
			}
		}
	}, "join_button_level_warning"),
	category_description = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			value = "n/a",
			style = {
				font_type = "proxima_nova_bold",
				font_size = 28,
				drop_shadow = true,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "category_description"),
	filter_page_divider_top = UIWidget.create_definition({
		{
			value = "content/ui/materials/dividers/skull_center_03",
			style_id = "texture",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				color = Color.terminal_corner(255, true),
				offset = {
					0,
					0,
					0
				}
			}
		}
	}, "filter_page_divider_top"),
	filter_page_divider_bottom = UIWidget.create_definition({
		{
			value = "content/ui/materials/dividers/skull_center_03",
			style_id = "texture",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				},
				color = Color.terminal_corner(255, true),
				offset = {
					0,
					0,
					0
				}
			}
		}
	}, "filter_page_divider_bottom"),
	group_window_info = UIWidget.create_definition({
		{
			value_id = "header",
			pass_type = "text",
			style_id = "header",
			style = {
				horizontal_alignment = "center",
				font_size = 36,
				text_vertical_alignment = "bottom",
				text_horizontal_alignment = "center",
				vertical_alignment = "center",
				drop_shadow = true,
				font_type = "machine_medium",
				text_color = Color.terminal_text_header(nil, true),
				offset = {
					0,
					-(group_grid_size[2] / 2 + 25),
					1
				}
			},
			value = Localize("loc_group_finder_no_groups_found_title")
		},
		{
			value_id = "sub_header",
			pass_type = "text",
			style_id = "sub_header",
			style = {
				font_size = 22,
				text_vertical_alignment = "top",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				vertical_alignment = "center",
				drop_shadow = true,
				line_spacing = 1.2,
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_body(255, true),
				offset = {
					0,
					group_grid_size[2] / 2 + 25,
					1
				}
			},
			value = Localize("loc_group_finder_no_groups_found_desc")
		}
	}, "group_window_info"),
	group_window = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.black(100, true),
				offset = {
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					2
				},
				color = Color.terminal_frame(nil, true)
			}
		},
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "outer_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.black(200, true),
				size_addition = {
					20,
					20
				},
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "group_window"),
	preview_window = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.black(100, true),
				offset = {
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "frame",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					9
				},
				color = Color.terminal_frame(nil, true)
			}
		},
		{
			value = "content/ui/materials/frames/frame_corner_2px",
			style_id = "corner",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					10
				},
				color = Color.terminal_corner(nil, true)
			}
		},
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "outer_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.black(200, true),
				size_addition = {
					20,
					20
				},
				offset = {
					0,
					0,
					1
				}
			}
		},
		{
			value = "content/ui/materials/frames/dropshadow_heavy",
			style_id = "outer_highlight",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.terminal_text_body(200, true),
				size_addition = {
					20,
					20
				},
				offset = {
					0,
					0,
					4
				}
			}
		},
		{
			value = "content/ui/materials/gradients/gradient_vertical",
			style_id = "background_gradient",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.terminal_grid_background_gradient(nil, true),
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "preview_window"),
	player_request_window = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.black(100, true),
				offset = {
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					2
				},
				color = Color.terminal_frame(nil, true)
			}
		},
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "outer_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.black(200, true),
				size_addition = {
					20,
					20
				},
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "player_request_window"),
	created_group_party_title = UIWidget.create_definition({
		{
			style_id = "players_title",
			value_id = "players_title",
			pass_type = "text",
			value = Localize("loc_group_finder_player_host_party_list_title"),
			style = {
				font_size = 30,
				text_vertical_alignment = "center",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				vertical_alignment = "top",
				font_type = "machine_medium",
				text_color = Color.terminal_text_body(255, true),
				size = {
					nil,
					40
				},
				offset = {
					0,
					0,
					3
				}
			}
		}
	}, "created_group_party_title"),
	player_request_grid_title = UIWidget.create_definition({
		{
			style_id = "players_title",
			value_id = "players_title",
			pass_type = "text",
			value = Localize("loc_group_finder_player_requests_title"),
			style = {
				font_size = 30,
				text_vertical_alignment = "center",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				vertical_alignment = "top",
				font_type = "machine_medium",
				text_color = Color.terminal_text_body(255, true),
				size = {
					nil,
					40
				},
				offset = {
					0,
					0,
					3
				}
			}
		}
	}, "player_request_grid_title"),
	team_member_1 = team_member_definition("team_member_1"),
	team_member_2 = team_member_definition("team_member_2"),
	team_member_3 = team_member_definition("team_member_3"),
	team_member_4 = team_member_definition("team_member_4")
}
local item_category_tabs_content = {
	{
		icon = "content/ui/materials/icons/categories/melee",
		hide_display_name = true,
		slot_types = {
			"slot_primary"
		}
	},
	{
		icon = "content/ui/materials/icons/categories/ranged",
		hide_display_name = true,
		slot_types = {
			"slot_secondary"
		}
	},
	{
		icon = "content/ui/materials/icons/categories/devices",
		hide_display_name = true,
		slot_types = {
			"slot_attachment_1",
			"slot_attachment_2",
			"slot_attachment_3"
		}
	}
}

local function player_request_terminal_button_change_function_accept(content, style)
	local optional_hotspot_id = "accept_hotspot"

	ButtonPassTemplates.terminal_button_change_function(content, style, optional_hotspot_id)
end

local function player_request_terminal_button_change_function_decline(content, style)
	local optional_hotspot_id = "decline_hotspot"

	ButtonPassTemplates.terminal_button_change_function(content, style, optional_hotspot_id)
end

local function player_request_terminal_button_hover_change_function_accept(content, style)
	local optional_hotspot_id = "accept_hotspot"

	ButtonPassTemplates.terminal_button_hover_change_function(content, style, optional_hotspot_id)
end

local function player_request_terminal_button_hover_change_function_decline(content, style)
	local optional_hotspot_id = "decline_hotspot"

	ButtonPassTemplates.terminal_button_hover_change_function(content, style, optional_hotspot_id)
end

local terminal_button_text_style = table.clone(UIFontSettings.button_primary)

terminal_button_text_style.offset = {
	70,
	0,
	6
}
terminal_button_text_style.size_addition = {
	-90,
	0
}
terminal_button_text_style.text_horizontal_alignment = "left"
terminal_button_text_style.text_vertical_alignment = "center"
terminal_button_text_style.text_color = {
	255,
	216,
	229,
	207
}
terminal_button_text_style.default_color = {
	255,
	216,
	229,
	207
}

local grid_blueprints = {
	player_request_entry = {
		size = {
			player_grid_size[1],
			110
		},
		pass_template = {
			{
				pass_type = "hotspot",
				content_id = "hotspot",
				content = {}
			},
			{
				pass_type = "rect",
				style = {
					color = Color.black(100, true),
					offset = {
						0,
						0,
						0
					}
				}
			},
			{
				value = "content/ui/materials/frames/frame_tile_2px",
				pass_type = "texture",
				style = {
					vertical_alignment = "center",
					scale_to_material = true,
					horizontal_alignment = "right",
					offset = {
						0,
						0,
						2
					},
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					hover_color = Color.terminal_frame_hover(nil, true)
				},
				change_function = ButtonPassTemplates.default_button_hover_change_function
			},
			{
				value = "content/ui/materials/frames/frame_corner_2px",
				pass_type = "texture",
				style = {
					vertical_alignment = "center",
					scale_to_material = true,
					horizontal_alignment = "right",
					offset = {
						0,
						0,
						3
					},
					default_color = Color.terminal_corner(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true),
					hover_color = Color.terminal_corner_hover(nil, true)
				},
				change_function = ButtonPassTemplates.default_button_hover_change_function
			},
			{
				value = "content/ui/materials/frames/dropshadow_medium",
				pass_type = "texture",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					scale_to_material = true,
					color = Color.black(200, true),
					size_addition = {
						20,
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
				value_id = "character_insignia",
				style_id = "character_insignia",
				pass_type = "texture",
				value = "content/ui/materials/base/ui_default_base",
				style = {
					vertical_alignment = "center",
					size = {
						40,
						100
					},
					offset = {
						20,
						0,
						5
					},
					material_values = {},
					color = {
						0,
						255,
						255,
						255
					}
				}
			},
			{
				value_id = "character_portrait",
				style_id = "character_portrait",
				pass_type = "texture",
				value = "content/ui/materials/base/ui_portrait_frame_base",
				style = {
					vertical_alignment = "center",
					size = {
						90,
						100
					},
					offset = {
						60,
						0,
						6
					},
					material_values = {
						use_placeholder_texture = 1
					}
				}
			},
			{
				style_id = "archetype_icon",
				pass_type = "texture",
				value = "content/ui/materials/icons/classes/veteran",
				value_id = "archetype_icon",
				style = {
					vertical_alignment = "center",
					scale_to_material = true,
					horizontal_alignment = "right",
					size = {
						120,
						120
					},
					offset = {
						-130,
						0,
						4
					},
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					hover_color = Color.terminal_frame_hover(nil, true)
				},
				change_function = ButtonPassTemplates.default_button_hover_change_function
			},
			{
				style_id = "character_name",
				pass_type = "text",
				value = "",
				value_id = "character_name",
				style = {
					text_horizontal_alignment = "left",
					font_size = 26,
					vertical_alignment = "center",
					text_vertical_alignment = "top",
					horizontal_alignment = "left",
					font_type = "proxima_nova_bold",
					text_color = {
						255,
						255,
						255,
						255
					},
					disabled_color = {
						255,
						120,
						120,
						120
					},
					default_color = Color.terminal_text_header(nil, true),
					hover_color = Color.terminal_text_header_selected(nil, true),
					size = {
						nil,
						30
					},
					offset = {
						180,
						-30,
						5
					}
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local default_color = hotspot.disabled and style.disabled_color or style.default_color
					local hover_color = style.hover_color
					local text_color = style.text_color
					local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

					ColorUtilities.color_lerp(default_color, hover_color, progress, text_color)
				end
			},
			{
				style_id = "character_title",
				pass_type = "text",
				value = "",
				value_id = "character_title",
				style = {
					text_horizontal_alignment = "left",
					font_size = 18,
					vertical_alignment = "center",
					text_vertical_alignment = "bottom",
					horizontal_alignment = "left",
					font_type = "proxima_nova_bold",
					text_color = {
						255,
						255,
						255,
						255
					},
					disabled_color = {
						255,
						120,
						120,
						120
					},
					default_color = Color.terminal_text_body(nil, true),
					hover_color = Color.terminal_text_header(nil, true),
					size = {
						nil,
						54
					},
					offset = {
						180,
						-16,
						5
					}
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local default_color = hotspot.disabled and style.disabled_color or style.default_color
					local hover_color = style.hover_color
					local text_color = style.text_color
					local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

					ColorUtilities.color_lerp(default_color, hover_color, progress, text_color)
				end
			},
			{
				style_id = "character_archetype_title",
				pass_type = "text",
				value = "",
				value_id = "character_archetype_title",
				style = {
					text_horizontal_alignment = "left",
					font_size = 18,
					vertical_alignment = "center",
					text_vertical_alignment = "bottom",
					horizontal_alignment = "left",
					font_type = "proxima_nova_bold",
					text_color = {
						255,
						255,
						255,
						255
					},
					disabled_color = {
						255,
						120,
						120,
						120
					},
					default_color = Color.terminal_text_body(nil, true),
					hover_color = Color.terminal_text_body_sub_header(nil, true),
					size = {
						nil,
						54
					},
					offset = {
						180,
						12,
						5
					}
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local default_color = hotspot.disabled and style.disabled_color or style.default_color
					local hover_color = style.hover_color
					local text_color = style.text_color
					local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

					ColorUtilities.color_lerp(default_color, hover_color, progress, text_color)
				end
			},
			{
				pass_type = "texture",
				style_id = "outer_highlight",
				value = "content/ui/materials/frames/dropshadow_heavy",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					scale_to_material = true,
					color = Color.terminal_text_body(200, true),
					size_addition = {
						20,
						20
					},
					offset = {
						0,
						0,
						4
					}
				},
				change_function = function (content, style, _, dt)
					local hotspot = content.hotspot
					local disabled = hotspot.disabled
					local anim_speed = 2

					if anim_speed then
						local anim_highlight_progress = content.anim_highlight_progress or 0

						if not disabled then
							anim_highlight_progress = math.min(anim_highlight_progress + dt * anim_speed, 1)
						else
							anim_highlight_progress = math.max(anim_highlight_progress - dt * anim_speed, 0)
						end

						content.anim_highlight_progress = anim_highlight_progress

						local pulse_speed = 3
						local pulse_progress = 1 - (0.5 + math.sin(Application.time_since_launch() * pulse_speed) * 0.5)

						style.color[1] = (50 + 100 * pulse_progress) * anim_highlight_progress
					end
				end,
				visibility_function = function (content, style)
					return not content.element.is_preview
				end
			},
			{
				value = "content/ui/materials/frames/dropshadow_medium",
				style_id = "outer_shadow",
				pass_type = "texture",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					scale_to_material = true,
					color = Color.black(200, true),
					size_addition = {
						20,
						20
					},
					offset = {
						0,
						0,
						1
					}
				}
			},
			{
				pass_type = "texture",
				style_id = "background_gradient",
				value = "content/ui/materials/gradients/gradient_vertical",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					disabled_color = Color.ui_grey_medium(255, true),
					offset = {
						0,
						0,
						1
					}
				},
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_change_function(content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style)
				end
			},
			{
				style_id = "accept_hotspot",
				pass_type = "hotspot",
				content_id = "accept_hotspot",
				content = {},
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					offset = {
						-80,
						0,
						5
					},
					size = {
						40,
						40
					}
				},
				visibility_function = function (content, style)
					return not content.parent.element.is_preview and Managers.ui:using_cursor_navigation()
				end
			},
			{
				pass_type = "texture",
				style_id = "accept_background",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					offset = {
						-80,
						0,
						5
					},
					size = {
						40,
						40
					},
					default_color = Color.terminal_background(nil, true),
					selected_color = Color.terminal_background_selected(nil, true)
				},
				change_function = player_request_terminal_button_change_function_accept,
				visibility_function = function (content, style)
					return not content.element.is_preview and Managers.ui:using_cursor_navigation()
				end
			},
			{
				pass_type = "texture",
				style_id = "accept_background_gradient",
				value = "content/ui/materials/gradients/gradient_vertical",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					offset = {
						-80,
						0,
						6
					},
					size = {
						40,
						40
					},
					color = Color.terminal_background_gradient(nil, true)
				},
				change_function = player_request_terminal_button_hover_change_function_accept,
				visibility_function = function (content, style)
					return not content.element.is_preview and Managers.ui:using_cursor_navigation()
				end
			},
			{
				style_id = "accept_icon",
				pass_type = "texture",
				value = "content/ui/materials/icons/list_buttons/check",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					offset = {
						-80,
						0,
						7
					},
					size = {
						40,
						40
					}
				},
				visibility_function = function (content, style)
					return not content.element.is_preview and Managers.ui:using_cursor_navigation()
				end
			},
			{
				pass_type = "texture",
				style_id = "accept_frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					vertical_alignment = "center",
					scale_to_material = true,
					horizontal_alignment = "right",
					offset = {
						-80,
						0,
						7
					},
					size = {
						40,
						40
					},
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true)
				},
				change_function = player_request_terminal_button_change_function_accept,
				visibility_function = function (content, style)
					return not content.element.is_preview and Managers.ui:using_cursor_navigation()
				end
			},
			{
				pass_type = "texture",
				style_id = "accept_corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					vertical_alignment = "center",
					scale_to_material = true,
					horizontal_alignment = "right",
					offset = {
						-80,
						0,
						8
					},
					size = {
						40,
						40
					},
					default_color = Color.terminal_corner(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true)
				},
				change_function = player_request_terminal_button_change_function_accept,
				visibility_function = function (content, style)
					return not content.element.is_preview and Managers.ui:using_cursor_navigation()
				end
			},
			{
				style_id = "accept_outer_shadow",
				pass_type = "texture",
				value = "content/ui/materials/frames/dropshadow_medium",
				style = {
					vertical_alignment = "center",
					scale_to_material = true,
					horizontal_alignment = "right",
					offset = {
						-70,
						0,
						8
					},
					size = {
						40,
						40
					},
					size_addition = {
						20,
						20
					},
					color = Color.black(200, true)
				},
				visibility_function = function (content, style)
					return not content.element.is_preview and Managers.ui:using_cursor_navigation()
				end
			},
			{
				style_id = "decline_hotspot",
				pass_type = "hotspot",
				content_id = "decline_hotspot",
				content = {},
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					offset = {
						-20,
						0,
						5
					},
					size = {
						40,
						40
					}
				},
				visibility_function = function (content, style)
					return not content.parent.element.is_preview and Managers.ui:using_cursor_navigation()
				end
			},
			{
				pass_type = "texture",
				style_id = "decline_background",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					offset = {
						-20,
						0,
						5
					},
					size = {
						40,
						40
					},
					default_color = Color.terminal_background(nil, true),
					selected_color = Color.terminal_background_selected(nil, true)
				},
				change_function = player_request_terminal_button_change_function_decline,
				visibility_function = function (content, style)
					return not content.element.is_preview and Managers.ui:using_cursor_navigation()
				end
			},
			{
				pass_type = "texture",
				style_id = "decline_background_gradient",
				value = "content/ui/materials/gradients/gradient_vertical",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					offset = {
						-20,
						0,
						6
					},
					size = {
						40,
						40
					},
					color = Color.terminal_background_gradient(nil, true)
				},
				change_function = player_request_terminal_button_hover_change_function_decline,
				visibility_function = function (content, style)
					return not content.element.is_preview and Managers.ui:using_cursor_navigation()
				end
			},
			{
				style_id = "decline_icon",
				pass_type = "texture",
				value = "content/ui/materials/icons/list_buttons/cross",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					offset = {
						-20,
						0,
						7
					},
					size = {
						40,
						40
					}
				},
				visibility_function = function (content, style)
					return not content.element.is_preview and Managers.ui:using_cursor_navigation()
				end
			},
			{
				pass_type = "texture",
				style_id = "decline_frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					vertical_alignment = "center",
					scale_to_material = true,
					horizontal_alignment = "right",
					offset = {
						-20,
						0,
						7
					},
					size = {
						40,
						40
					},
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true)
				},
				change_function = player_request_terminal_button_change_function_decline,
				visibility_function = function (content, style)
					return not content.element.is_preview and Managers.ui:using_cursor_navigation()
				end
			},
			{
				pass_type = "texture",
				style_id = "decline_corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					vertical_alignment = "center",
					scale_to_material = true,
					horizontal_alignment = "right",
					offset = {
						-20,
						0,
						8
					},
					size = {
						40,
						40
					},
					default_color = Color.terminal_corner(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true)
				},
				change_function = player_request_terminal_button_change_function_decline,
				visibility_function = function (content, style)
					return not content.element.is_preview and Managers.ui:using_cursor_navigation()
				end
			},
			{
				style_id = "decline_outer_shadow",
				pass_type = "texture",
				value = "content/ui/materials/frames/dropshadow_medium",
				style = {
					vertical_alignment = "center",
					scale_to_material = true,
					horizontal_alignment = "right",
					offset = {
						-10,
						0,
						8
					},
					size = {
						40,
						40
					},
					size_addition = {
						20,
						20
					},
					color = Color.black(200, true)
				},
				visibility_function = function (content, style)
					return not content.element.is_preview and Managers.ui:using_cursor_navigation()
				end
			}
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content

			content.element = element

			local social_service_manager = Managers.data_service.social
			local presence_info = element.presence_info
			local profile = presence_info.profile
			local player_info = social_service_manager and social_service_manager:get_player_info_by_account_id(element.account_id)

			if profile and player_info then
				local character_archetype_title = ProfileUtils.character_archetype_title(profile)
				local character_level = tostring(profile.current_level) .. " "
				local havoc_rank_cadence_high = presence_info.havoc_rank_cadence_high

				if havoc_rank_cadence_high ~= nil and profile.current_level ~= nil and profile.current_level >= 30 then
					local havoc_prefix_text = Localize("loc_havoc_highest_order_reached")
					local havoc_highest_cadence_rank = "- " .. havoc_prefix_text .. " " .. tostring(havoc_rank_cadence_high) .. " "

					content.character_archetype_title = string.format("%s %s", character_archetype_title, havoc_highest_cadence_rank)
				else
					content.character_archetype_title = string.format("%s %s", character_archetype_title, character_level)
				end

				local platform = player_info:platform()

				if IS_PLAYSTATION and (platform == "psn" or platform == "ps5") then
					content.character_name = player_info:user_display_name()
				else
					content.character_name = player_info:character_name()
				end

				local archetype = profile.archetype

				content.archetype_icon = archetype.archetype_icon_selection_large_unselected

				local player_title = ProfileUtils.character_title(profile)

				if player_title then
					content.character_title = player_title
				end

				if not player_title or player_title == "" then
					style.character_name.offset[2] = -12
					style.character_archetype_title.offset[2] = -1
				else
					style.character_name.offset[2] = -30
					style.character_archetype_title.offset[2] = 12
				end
			end

			content.accept_hotspot.pressed_callback = element.accept_callback
			content.decline_hotspot.pressed_callback = element.decline_callback
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			widget.style.archetype_icon.offset[1] = (widget.content.element.is_preview or Managers.ui:using_cursor_navigation()) and -130 or -30
		end,
		load_icon = function (parent, widget, element, ui_renderer, dummy_profile, prioritize)
			local style = widget.style
			local content = widget.content

			content.element = element

			local presence_info = element.presence_info
			local profile = presence_info.profile

			if profile then
				local material_values = widget.style.character_portrait.material_values

				material_values.use_placeholder_texture = 1

				local load_cb = callback(function (widget, grid_index, rows, columns, render_target)
					local material_values = widget.style.character_portrait.material_values

					widget.content.character_portrait = "content/ui/materials/base/ui_portrait_frame_base"
					material_values.use_placeholder_texture = 0
					material_values.rows = rows
					material_values.columns = columns
					material_values.grid_index = grid_index - 1
					material_values.texture_icon = render_target
				end, widget)
				local unload_cb = callback(function (widget, grid_index, rows, columns, render_target)
					local material_values = widget.style.character_portrait.material_values

					material_values.use_placeholder_texture = nil
					material_values.rows = nil
					material_values.columns = nil
					material_values.grid_index = nil
					material_values.texture_icon = nil
					widget.content.character_portrait = "content/ui/materials/base/ui_portrait_frame_base_no_render"
				end, widget)

				widget.content.icon_load_id = Managers.ui:load_profile_portrait(profile, load_cb, nil, unload_cb)

				local loadout = profile.loadout
				local frame_item = loadout and loadout.slot_portrait_frame

				if frame_item then
					local cb = callback(function (item)
						local material_values = style.character_portrait.material_values

						material_values.portrait_frame_texture = item.icon
					end, frame_item)

					content.frame_load_id = Managers.ui:load_item_icon(frame_item, cb)
				end

				local insignia_item = loadout and loadout.slot_insignia

				if insignia_item then
					local cb = callback(function (item)
						local icon_style = style.character_insignia
						local material_values = icon_style.material_values

						if item.icon_material and item.icon_material ~= "" then
							if material_values.texture_map then
								material_values.texture_map = nil
							end

							content.character_insignia = item.icon_material
						else
							material_values.texture_map = item.icon
						end

						icon_style.color[1] = 255
					end, insignia_item)

					content.insignia_load_id = Managers.ui:load_item_icon(insignia_item, cb)
				end
			end
		end,
		unload_icon = function (parent, widget, element, ui_renderer)
			UIWidget.set_visible(widget, ui_renderer, false)

			local content = widget.content
			local style = widget.style
			local icon_load_id = content.icon_load_id
			local frame_load_id = content.frame_load_id
			local insignia_load_id = content.insignia_load_id

			if icon_load_id then
				Managers.ui:unload_profile_portrait(icon_load_id)

				content.icon_load_id = nil
			end

			if frame_load_id then
				Managers.ui:unload_item_icon(frame_load_id)

				content.frame_load_id = nil
			end

			if insignia_load_id then
				Managers.ui:unload_item_icon(insignia_load_id)

				content.insignia_load_id = nil

				local icon_style = style.character_insignia

				icon_style.color[1] = 0
			end
		end,
		destroy = function (parent, widget, element, ui_renderer)
			UIWidget.set_visible(widget, ui_renderer, false)

			local content = widget.content
			local style = widget.style
			local icon_load_id = content.icon_load_id
			local frame_load_id = content.frame_load_id
			local insignia_load_id = content.insignia_load_id

			if icon_load_id then
				Managers.ui:unload_profile_portrait(icon_load_id)

				content.icon_load_id = nil
			end

			if frame_load_id then
				Managers.ui:unload_item_icon(frame_load_id)

				content.frame_load_id = nil
			end

			if insignia_load_id then
				Managers.ui:unload_item_icon(insignia_load_id)

				content.insignia_load_id = nil

				local icon_style = style.character_insignia

				icon_style.color[1] = 0
			end
		end
	}
}

table.merge_recursive(grid_blueprints, groups_blueprints)

local animations = {
	update_widget_text_fade = {
		{
			name = "fade_out",
			end_time = 0.2,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = 1 - math.easeInCubic(progress)

				widget.alpha_multiplier = math.min(anim_progress, widget.alpha_multiplier or 1)
			end
		},
		{
			name = "update_text",
			end_time = 0.2,
			start_time = 0.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local new_text = params.new_text

				if widget.content.original_text then
					widget.content.original_text = new_text
				else
					widget.content.text = new_text
				end
			end
		},
		{
			name = "fade_in",
			end_time = 0.5,
			start_time = 0.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				widget.alpha_multiplier = math.max(anim_progress, widget.alpha_multiplier or 0)
			end
		}
	},
	tag_grid_entry = {
		{
			name = "fade_in_and_move",
			end_time = 0.4,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = 0
				end
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeInCubic(progress)

				for index, widget in ipairs(widgets) do
					widget.alpha_multiplier = anim_progress

					local x_anim_distance_max = 5 * index
					local x_anim_distance = -x_anim_distance_max + x_anim_distance_max * anim_progress

					widget.offset[1] = x_anim_distance
				end
			end
		}
	},
	on_enter = {
		{
			name = "fade_in",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent.animation_alpha_multiplier = 0

				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = 0
				end
			end
		},
		{
			name = "move",
			end_time = 0.45,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = anim_progress
				end

				parent.animation_alpha_multiplier = anim_progress

				local x_anim_distance_max = 50
				local x_anim_distance = x_anim_distance_max - x_anim_distance_max * anim_progress

				parent:_set_scenegraph_position("player_request_window", scenegraph_definition.player_request_window.position[1] - x_anim_distance)
				parent:_set_scenegraph_position("group_window", nil, scenegraph_definition.group_window.position[2] + x_anim_distance)
				parent:_set_scenegraph_position("preview_window", scenegraph_definition.preview_window.position[1] + x_anim_distance)
			end
		}
	}
}
local background_world_params = {
	shading_environment = "content/shading_environments/ui/group_finder",
	world_layer = 1,
	total_blur_duration = 0.5,
	timer_name = "ui",
	viewport_type = "default",
	register_camera_event = "event_register_camera",
	viewport_name = "group_finder_world_viewport",
	viewport_layer = 1,
	level_name = "content/levels/ui/group_finder/group_finder",
	world_name = "group_finder_world"
}
local input_legend_params = {
	buttons_params = {
		{
			on_pressed_callback = "cb_handle_back_pressed",
			input_action = "back",
			display_name = "loc_settings_menu_close_menu",
			alignment = "left_alignment"
		},
		{
			input_action = "group_finder_group_clear_tags",
			display_name = "loc_social_menu_notifications_clear_all_notifications",
			alignment = "right_alignment",
			on_pressed_callback = "cb_on_clear_pressed",
			visibility_function = function (parent)
				local state = parent._state

				if state == "browsing" then
					return #parent._selected_tags > 0
				end

				return false
			end
		}
	}
}

return {
	input_legend_params = input_legend_params,
	groups_blueprints = groups_blueprints,
	background_world_params = background_world_params,
	animations = animations,
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	grid_blueprints = grid_blueprints,
	item_category_tabs_content = item_category_tabs_content
}
