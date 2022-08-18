local LobbyViewSettings = require("scripts/ui/views/lobby_view/lobby_view_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local LobbyViewFontStyle = require("scripts/ui/views/lobby_view/lobby_view_font_style")
local ColorUtilities = require("scripts/utilities/ui/colors")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
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
		parent = "screen",
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
		parent = "screen",
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
		parent = "screen",
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
			0,
			1
		}
	},
	inspect_button_pivot = {
		vertical_alignment = "bottom",
		parent = "screen",
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
	}
}
local widget_definitions = {
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
			use_is_focused = true
		}
	},
	{
		value = "content/ui/materials/base/ui_portrait_frame_base",
		style_id = "character_portrait",
		pass_type = "texture",
		style = {
			horizontal_alignment = "center",
			material_values = {
				texture_frame = "content/ui/textures/icons/items/frames/default",
				use_placeholder_texture = 1
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
				62
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
local weapon_text_definition = UIWidget.create_definition({
	{
		pass_type = "hotspot",
		content_id = "hotspot"
	},
	{
		value_id = "weapon_text",
		style_id = "weapon_text",
		pass_type = "text",
		value = "",
		style = LobbyViewFontStyle.weapon_text_style
	},
	{
		style_id = "weapon_hover_text",
		pass_type = "text",
		value = "",
		value_id = "weapon_text",
		style = LobbyViewFontStyle.weapon_hover_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local focused_progress = hotspot.anim_focus_progress
			style.text_color[1] = focused_progress * 255
		end
	}
}, "loadout")
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
		input_action = "hotkey_inventory",
		on_pressed_callback = "cb_on_inventory_pressed",
		display_name = "loc_input_legend_inventory",
		alignment = "right_alignment"
	},
	{
		input_action = "hotkey_loadout",
		display_name = "loc_input_legend_loadout_show",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_loadout_pressed",
		visibility_function = function (parent)
			return not parent._show_loadout
		end
	},
	{
		input_action = "hotkey_loadout",
		display_name = "loc_input_legend_loadout_hide",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_loadout_pressed",
		visibility_function = function (parent)
			return parent._show_loadout
		end
	}
}

return {
	legend_inputs = legend_inputs,
	loading_definition = loading_definition,
	panel_definition = panel_definition,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	weapon_text_definition = weapon_text_definition
}
