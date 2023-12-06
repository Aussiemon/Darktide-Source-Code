local LobbyViewSettings = require("scripts/ui/views/lobby_view/lobby_view_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local LobbyViewFontStyle = require("scripts/ui/views/lobby_view/lobby_view_font_style")
local ColorUtilities = require("scripts/utilities/ui/colors")
local item_stats_grid_settings = nil
local padding = 12
local width = 530
local height = 920
item_stats_grid_settings = {
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
	canvas_height = {
		scale = "fit_height",
		horizontal_alignment = "center",
		size = {
			1920,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	grid_background = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = LobbyViewSettings.grid_size,
		position = {
			-275,
			-170,
			1
		}
	},
	grid_start = {
		vertical_alignment = "top",
		parent = "grid_background",
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
	},
	grid_content_pivot = {
		vertical_alignment = "top",
		parent = "grid_start",
		horizontal_alignment = "right",
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
	mission_title = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			1200,
			100
		},
		position = {
			100,
			65,
			1
		}
	},
	panel_pivot = {
		vertical_alignment = "bottom",
		parent = "canvas_height",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			-120,
			1
		}
	},
	panel = {
		vertical_alignment = "bottom",
		parent = "panel_pivot",
		horizontal_alignment = "center",
		size = LobbyViewSettings.panel_size,
		position = {
			0,
			0,
			1
		}
	},
	loading_pivot = {
		vertical_alignment = "bottom",
		parent = "canvas_height",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			-250,
			1
		}
	},
	loading = {
		vertical_alignment = "center",
		parent = "loading_pivot",
		horizontal_alignment = "center",
		size = LobbyViewSettings.loading_size,
		position = {
			0,
			0,
			1
		}
	},
	loadout_pivot = {
		vertical_alignment = "bottom",
		parent = "canvas_height",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			-120,
			1
		}
	},
	loadout = {
		vertical_alignment = "bottom",
		parent = "loadout_pivot",
		horizontal_alignment = "center",
		size = LobbyViewSettings.loadout_size,
		position = {
			0,
			180,
			1
		}
	},
	inspect_button_pivot = {
		vertical_alignment = "bottom",
		parent = "canvas_height",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			-120,
			1
		}
	},
	inspect_button = {
		vertical_alignment = "center",
		parent = "inspect_button_pivot",
		horizontal_alignment = "center",
		size = LobbyViewSettings.inspect_button_size,
		position = {
			0,
			0,
			1
		}
	},
	talent_tooltip = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			400,
			110
		},
		position = {
			0,
			0,
			63
		}
	},
	item_stats_pivot = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			3
		}
	}
}
local widget_definitions = {
	talent_tooltip = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = {
					220,
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "background",
			pass_type = "texture",
			style = {
				color = Color.terminal_background(nil, true)
			}
		},
		{
			value = "content/ui/materials/gradients/gradient_vertical",
			style_id = "background_gradient",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.terminal_background_gradient(180, true),
				offset = {
					0,
					0,
					1
				}
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
					3
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
				color = Color.terminal_frame(nil, true),
				offset = {
					0,
					0,
					2
				}
			}
		},
		{
			value = "content/ui/materials/frames/frame_corner_2px",
			style_id = "corner",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.terminal_corner(nil, true),
				offset = {
					0,
					0,
					3
				}
			}
		},
		{
			value_id = "title",
			pass_type = "text",
			style_id = "title",
			value = "n/a",
			style = {
				text_vertical_alignment = "center",
				horizontal_alignment = "center",
				font_size = 24,
				text_horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_header(255, true),
				color = {
					100,
					255,
					200,
					50
				},
				size = {
					nil,
					0
				},
				offset = {
					0,
					0,
					5
				},
				size_addition = {
					-40,
					0
				}
			}
		},
		{
			value_id = "description",
			pass_type = "text",
			style_id = "description",
			value = "n/a",
			style = {
				font_size = 20,
				text_vertical_alignment = "center",
				horizontal_alignment = "center",
				text_horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_body(255, true),
				size = {
					nil,
					0
				},
				offset = {
					0,
					0,
					5
				},
				color = {
					100,
					100,
					255,
					0
				},
				size_addition = {
					-40,
					0
				}
			}
		},
		{
			value_id = "talent_type_title",
			pass_type = "text",
			style_id = "talent_type_title",
			value = "",
			style = {
				font_size = 16,
				horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_body_sub_header(255, true),
				size = {
					nil,
					0
				},
				offset = {
					0,
					0,
					5
				},
				size_addition = {
					-40,
					0
				}
			}
		}
	}, "talent_tooltip", {
		visible = false
	}),
	mission_title = UIWidget.create_definition({
		{
			value_id = "title",
			style_id = "title",
			pass_type = "text",
			value = "n/a",
			style = LobbyViewFontStyle.title_text_style
		},
		{
			value = "content/ui/materials/dividers/skull_rendered_left_01",
			style_id = "divider",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				size = {
					1200,
					18
				}
			}
		},
		{
			value_id = "sub_title",
			style_id = "sub_title",
			pass_type = "text",
			value = "n/a",
			style = LobbyViewFontStyle.sub_title_text_style
		}
	}, "mission_title"),
	grid_interaction = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		}
	}, "grid_background"),
	metal_corners = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/lobby_01_lower",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "bottom",
				size = {
					120,
					240
				},
				offset = {
					0,
					0,
					62
				},
				color = Color.white(255, true)
			}
		},
		{
			value = "content/ui/materials/frames/screen/lobby_01_lower",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				size = {
					120,
					240
				},
				offset = {
					0,
					0,
					62
				},
				color = Color.white(255, true),
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
			value = "content/ui/materials/frames/screen/lobby_01_upper",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "top",
				size = {
					210,
					390
				},
				offset = {
					0,
					0,
					62
				},
				color = Color.white(255, true)
			}
		},
		{
			value = "content/ui/materials/frames/screen/lobby_01_upper",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				size = {
					210,
					390
				},
				offset = {
					0,
					0,
					62
				},
				color = Color.white(255, true),
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
	}, "screen")
}
local panel_definition = UIWidget.create_definition({
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		content = {
			use_is_focused = true,
			disabled = true
		}
	},
	{
		value_id = "character_portrait",
		style_id = "character_portrait",
		pass_type = "texture",
		value = "content/ui/materials/base/ui_portrait_frame_base",
		style = {
			horizontal_alignment = "center",
			material_values = {
				use_placeholder_texture = 1,
				texture_icon = "content/ui/textures/icons/items/frames/default"
			},
			size = {
				90,
				100
			}
		}
	},
	{
		value = "content/ui/materials/icons/generic/checkmark",
		pass_type = "texture",
		style = {
			vertical_alignment = "top",
			hdr = true,
			horizontal_alignment = "center",
			size = {
				24,
				24
			},
			offset = {
				0,
				35,
				2
			},
			color = Color.ui_terminal(255, true)
		},
		visibility_function = function (content, style)
			return content.is_ready
		end
	},
	{
		value_id = "character_insignia",
		style_id = "character_insignia",
		pass_type = "texture",
		value = "content/ui/materials/base/ui_default_base",
		style = {
			horizontal_alignment = "center",
			size = {
				40,
				100
			},
			offset = {
				-65,
				0,
				2
			},
			material_values = {}
		},
		visibility_function = function (content, style)
			return not not style.material_values.texture_map
		end
	},
	{
		style_id = "character_name",
		pass_type = "text",
		value = "",
		value_id = "character_name",
		style = LobbyViewFontStyle.character_name_style,
		change_function = function (content, style)
			local text_color = style.text_color
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local highlight_color = style.hover_color
			local hover_progress = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress)
			local ignore_alpha = true

			ColorUtilities.color_lerp(default_color, highlight_color, hover_progress, text_color, ignore_alpha)
		end
	},
	{
		style_id = "character_title",
		pass_type = "text",
		value = "",
		value_id = "character_title",
		style = LobbyViewFontStyle.character_title_style,
		change_function = function (content, style)
			local text_color = style.text_color
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local highlight_color = style.hover_color
			local hover_progress = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress)
			local ignore_alpha = true

			ColorUtilities.color_lerp(default_color, highlight_color, hover_progress, text_color, ignore_alpha)
		end
	},
	{
		style_id = "guild_divider",
		pass_type = "texture",
		value = "content/ui/materials/dividers/skull_rendered_center_01",
		style = {
			horizontal_alignment = "center",
			size = {
				140,
				18
			},
			offset = {
				0,
				165,
				0
			}
		},
		visibility_function = function (content, style)
			return content.has_guild
		end
	},
	{
		style_id = "guild_name",
		pass_type = "text",
		value = "",
		value_id = "guild_name",
		style = LobbyViewFontStyle.guild_name_style,
		change_function = function (content, style)
			local text_color = style.text_color
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local highlight_color = style.hover_color
			local hover_progress = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress)
			local ignore_alpha = true

			ColorUtilities.color_lerp(default_color, highlight_color, hover_progress, text_color, ignore_alpha)
		end,
		visibility_function = function (content, style)
			return content.has_guild
		end
	},
	{
		value = "content/ui/materials/frames/hover",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			hdr = true,
			color = Color.ui_terminal(255, true),
			size_addition = {
				30,
				15
			},
			offset = {
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			local anim_progress = math.max(content.hotspot.anim_focus_progress, content.hotspot.anim_select_progress)
			style.color[1] = anim_progress * 255
			local size_addition = style.size_addition
			local size_padding = 30 - math.easeInCubic(anim_progress) * 15
			size_addition[1] = size_padding
			size_addition[2] = size_padding
		end
	},
	{
		style_id = "background_selected",
		pass_type = "texture",
		value = "content/ui/materials/buttons/background_selected",
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
				10,
				5
			}
		},
		visibility_function = function (content, style)
			return content.hotspot.is_focused or content.hotspot.is_hover
		end
	},
	{
		style_id = "character_inspect",
		pass_type = "text",
		value = "",
		value_id = "character_inspect",
		style = LobbyViewFontStyle.inspect_text_style,
		change_function = function (content, style)
			local text_color = style.text_color
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local highlight_color = style.hover_color
			local hover_progress = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress)
			local ignore_alpha = true

			ColorUtilities.color_lerp(default_color, highlight_color, hover_progress, text_color, ignore_alpha)
		end,
		visibility_function = function (content, style)
			return content.hotspot.is_focused or content.hotspot.is_hover
		end
	}
}, "panel")
local loading_definition = UIWidget.create_definition({
	{
		value = "content/ui/materials/symbols/cog_big",
		pass_type = "rotated_texture",
		style = {
			color = Color.ui_chalk_grey(255, true)
		},
		change_function = function (content, style)
			local progress = -(Application.time_since_launch() * 0.3) % 1
			style.angle = math.pi * 2 * progress
		end
	},
	{
		value = "content/ui/materials/symbols/cog_small",
		pass_type = "rotated_texture",
		style = {
			size = {
				51,
				51
			},
			offset = {
				43,
				-40,
				0
			},
			color = Color.ui_chalk_grey(255, true)
		},
		change_function = function (content, style)
			local progress = Application.time_since_launch() * 0.45 % 1
			style.angle = math.pi * 2 * progress
		end
	},
	{
		value_id = "loading_text",
		style_id = "loading_text",
		pass_type = "text",
		value = Managers.localization:localize("loc_lobby_finding_player"),
		style = LobbyViewFontStyle.loading_text_style
	}
}, "loading")
local tooltip_visibility_on = "loc_lobby_legend_tooltip_visibility_on"
local tooltip_visibility_off = "loc_lobby_legend_tooltip_visibility_off"
local show_weapon = "loc_lobby_legend_weapons_show"
local hide_weapon = "loc_lobby_legend_talents_show"
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
		input_action = "lobby_open_inventory",
		on_pressed_callback = "cb_on_inventory_pressed",
		display_name = "loc_input_legend_inventory",
		alignment = "right_alignment"
	},
	{
		input_action = "lobby_switch_loadout",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_loadout_pressed",
		display_name = show_weapon,
		visibility_function = function (parent, id)
			local display_name = parent._show_weapons and hide_weapon or show_weapon

			parent._input_legend_element:set_display_name(id, display_name)

			return true
		end
	},
	{
		input_action = "talents_summery_overview_pressed",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_trigger_gamepad_tooltip_navigation_pressed",
		display_name = tooltip_visibility_on,
		visibility_function = function (parent, id)
			local display_name = parent._use_gamepad_tooltip_navigation and tooltip_visibility_off or tooltip_visibility_on

			parent._input_legend_element:set_display_name(id, display_name)

			return not parent._using_cursor_navigation
		end
	}
}

return {
	legend_inputs = legend_inputs,
	loading_definition = loading_definition,
	panel_definition = panel_definition,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	item_stats_grid_settings = item_stats_grid_settings
}
