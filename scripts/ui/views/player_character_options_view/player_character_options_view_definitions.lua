-- chunkname: @scripts/ui/views/player_character_options_view/player_character_options_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local PlayerCharacterOptionsViewSettings = require("scripts/ui/views/player_character_options_view/player_character_options_view_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local Text = require("scripts/utilities/ui/text")
local anim_start_delay = 0
local window_size = PlayerCharacterOptionsViewSettings.window_size
local grid_size = PlayerCharacterOptionsViewSettings.grid_size
local image_size = PlayerCharacterOptionsViewSettings.image_size
local content_size = PlayerCharacterOptionsViewSettings.content_size
local button_size = {
	420,
	60
}
local scenegraph_definitions = {
	screen = UIWorkspaceSettings.screen,
	background_icon = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1250,
			1250
		},
		position = {
			0,
			0,
			0
		}
	},
	button_pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			470,
			1
		}
	},
	window = {
		vertical_alignment = "center",
		scale = "fit_width",
		size = {
			1920,
			window_size[2]
		},
		position = {
			0,
			30,
			20
		}
	},
	window_content = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = window_size,
		position = {
			0,
			0,
			2
		}
	},
	window_image = {
		vertical_alignment = "bottom",
		parent = "window_content",
		horizontal_alignment = "left",
		size = image_size,
		position = {
			0,
			0,
			15
		}
	},
	player_panel = {
		vertical_alignment = "top",
		parent = "window_content",
		horizontal_alignment = "right",
		size = content_size,
		position = {
			0,
			0,
			2
		}
	},
	class_badge = {
		vertical_alignment = "top",
		parent = "player_panel",
		horizontal_alignment = "left",
		size = {
			400,
			240
		},
		position = {
			button_size[1] * 0.5 - 200 + 40,
			-10,
			1
		}
	},
	player_name = {
		vertical_alignment = "bottom",
		parent = "class_badge",
		horizontal_alignment = "center",
		size = {
			content_size[1],
			50
		},
		position = {
			0,
			0,
			1
		}
	},
	character_title = {
		vertical_alignment = "bottom",
		parent = "class_badge",
		horizontal_alignment = "center",
		size = {
			content_size[1],
			50
		},
		position = {
			0,
			35,
			1
		}
	},
	class_name = {
		vertical_alignment = "bottom",
		parent = "class_badge",
		horizontal_alignment = "center",
		size = {
			content_size[1],
			50
		},
		position = {
			0,
			70,
			1
		}
	},
	inspect_button = {
		vertical_alignment = "bottom",
		parent = "player_panel",
		horizontal_alignment = "left",
		size = {
			380,
			40
		},
		position = {
			60,
			-145,
			13
		}
	},
	invite_button = {
		vertical_alignment = "bottom",
		parent = "player_panel",
		horizontal_alignment = "left",
		size = {
			380,
			40
		},
		position = {
			60,
			-95,
			13
		}
	},
	close_button = {
		vertical_alignment = "bottom",
		parent = "player_panel",
		horizontal_alignment = "left",
		size = {
			380,
			40
		},
		position = {
			60,
			-45,
			13
		}
	}
}
local widget_definitions = {
	class_badge = UIWidget.create_definition({
		{
			value = "content/ui/materials/icons/class_badges/container",
			style_id = "badge",
			pass_type = "texture",
			style = {
				material_values = {
					effect_progress = 0
				}
			}
		}
	}, "class_badge"),
	player_name = UIWidget.create_definition({
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			value = "<TEXT_FIELD>",
			style = {
				vertical_alignment = "bottom",
				font_size = 28,
				horizontal_alignment = "center",
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "bottom",
				text_horizontal_alignment = "center",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "player_name"),
	class_name = UIWidget.create_definition({
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			value = "<TEXT_FIELD>",
			style = {
				vertical_alignment = "bottom",
				font_size = 24,
				horizontal_alignment = "center",
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "bottom",
				text_horizontal_alignment = "center",
				text_color = Color.terminal_text_body_sub_header(255, true),
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "class_name"),
	character_title = UIWidget.create_definition({
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			value = "",
			style = {
				vertical_alignment = "bottom",
				font_size = 24,
				horizontal_alignment = "center",
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "bottom",
				text_horizontal_alignment = "center",
				text_color = Color.terminal_text_body(255, true),
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "character_title"),
	window_image = UIWidget.create_definition({
		{
			style_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/icons/items/containers/item_container_landscape",
			value_id = "texture",
			style = {
				offset = {
					0,
					0,
					0
				},
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				},
				color = {
					0,
					255,
					255,
					255
				},
				material_values = {}
			},
			change_function = function (content, style, _, dt)
				if content.alpha_fraction then
					content.alpha_fraction = math.clamp(content.alpha_fraction + dt * 4, 0, 1)
					style.color[1] = 255 * content.alpha_fraction

					if content.alpha_fraction == 1 then
						content.alpha_fraction = nil
					end
				end
			end
		}
	}, "window_image"),
	window = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size_addition = {
					0,
					0
				},
				offset = {
					0,
					0,
					10
				}
			}
		},
		{
			style_id = "screen_background",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				scenegraph_id = "screen",
				horizontal_alignment = "center",
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					0
				},
				size_addition = {
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/masks/gradient_vignette",
			style_id = "screen_background_vignette",
			pass_type = "texture",
			style = {
				scenegraph_id = "screen",
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					1
				}
			}
		},
		{
			style_id = "window_background",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					-1
				},
				size_addition = {
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			style_id = "background",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					64,
					24
				},
				color = Color.terminal_grid_background(nil, true)
			}
		},
		{
			value = "content/ui/materials/gradients/gradient_vertical",
			style_id = "background_gradient",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.black(200, true),
				offset = {
					0,
					0,
					3
				},
				size_addition = {
					40,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/dropshadow_large",
			style_id = "outer_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.black(200, true),
				size_addition = {
					96,
					96
				},
				offset = {
					0,
					0,
					5
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
					4
				},
				size_addition = {
					40,
					0
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
					5
				},
				size_addition = {
					40,
					0
				}
			}
		},
		{
			value = "content/ui/materials/dividers/horizontal_dynamic_upper",
			style_id = "edge_top",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					nil,
					10
				},
				size_addition = {
					80,
					0
				},
				color = Color.terminal_text_header(255, true),
				offset = {
					0,
					-4,
					14
				}
			}
		},
		{
			value = "content/ui/materials/dividers/horizontal_dynamic_lower",
			style_id = "edge_bottom",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					nil,
					10
				},
				size_addition = {
					80,
					0
				},
				color = Color.terminal_text_header(255, true),
				offset = {
					0,
					4,
					19
				}
			}
		}
	}, "window"),
	inspect_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "inspect_button", {
		visible = true,
		original_text = Localize("loc_lobby_player_inpect_button")
	}),
	invite_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "invite_button", {
		visible = true,
		original_text = Localize("loc_social_menu_invite_to_party")
	}),
	close_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "close_button", {
		visible = true,
		original_text = Localize("loc_action_interaction_close")
	})
}
local animation_definitions = {
	on_enter = {
		{
			name = "init",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local window = widgets.window

				for _, pass_style in pairs(window.style) do
					local color = pass_style.text_color or pass_style.color

					if color then
						color[1] = 0
					end
				end

				widgets.inspect_button.alpha_multiplier = 0
				widgets.invite_button.alpha_multiplier = 0
				widgets.close_button.alpha_multiplier = 0
				widgets.window_image.alpha_multiplier = 0
				widgets.class_badge.alpha_multiplier = 0
				widgets.player_name.alpha_multiplier = 0
				widgets.class_name.alpha_multiplier = 0
				widgets.character_title.alpha_multiplier = 0
				parent._content_alpha_multiplier = 0
			end
		},
		{
			name = "fade_in_background",
			end_time = 1.2,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeCubic(progress)
				local window = widgets.window
				local alpha = 100 * anim_progress

				window.style.screen_background.color[1] = alpha
				window.style.screen_background_vignette.color[1] = alpha
			end
		},
		{
			name = "fade_in_window",
			end_time = 0.2,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local window = widgets.window
				local alpha = 255 * anim_progress
				local window_style = window.style

				window_style.background.color[1] = alpha
				window_style.background_gradient.color[1] = 200 * anim_progress
				window_style.outer_shadow.color[1] = 200 * anim_progress
				window_style.frame.color[1] = alpha
				window_style.corner.color[1] = alpha
				window_style.edge_top.color[1] = alpha
				window_style.edge_bottom.color[1] = alpha
				window_style.window_background.color[1] = alpha
			end
		},
		{
			name = "fade_in_content",
			end_time = 0.7,
			start_time = 0.4,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				parent._content_alpha_multiplier = anim_progress
				widgets.inspect_button.alpha_multiplier = anim_progress
				widgets.invite_button.alpha_multiplier = anim_progress
				widgets.close_button.alpha_multiplier = anim_progress
				widgets.window_image.alpha_multiplier = anim_progress
				widgets.class_badge.alpha_multiplier = anim_progress
				widgets.player_name.alpha_multiplier = anim_progress
				widgets.class_name.alpha_multiplier = anim_progress
				widgets.character_title.alpha_multiplier = anim_progress
			end
		},
		{
			name = "move",
			end_time = 0.4,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent:_set_scenegraph_size("window", nil, 100)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeCubic(progress)

				parent:_set_scenegraph_size("window", nil, 100 + (scenegraph_definition.window.size[2] - 100) * anim_progress)
			end
		}
	},
	on_exit = {
		{
			name = "fade_out_content",
			end_time = 0.3,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(1 - progress)

				parent._content_alpha_multiplier = anim_progress
				widgets.inspect_button.alpha_multiplier = anim_progress
				widgets.invite_button.alpha_multiplier = anim_progress
				widgets.close_button.alpha_multiplier = anim_progress
				widgets.window_image.alpha_multiplier = anim_progress
				widgets.class_badge.alpha_multiplier = anim_progress
				widgets.player_name.alpha_multiplier = anim_progress
				widgets.class_name.alpha_multiplier = anim_progress
				widgets.character_title.alpha_multiplier = anim_progress
			end
		},
		{
			name = "move",
			end_time = 0.7,
			start_time = 0.3,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent:_set_scenegraph_size("window", nil, 100)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeCubic(1 - progress)

				parent:_set_scenegraph_size("window", nil, 100 + (scenegraph_definition.window.size[2] - 100) * anim_progress)
			end
		},
		{
			name = "fade_out_window",
			end_time = 0.5,
			start_time = 0.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(1 - progress)
				local window = widgets.window
				local alpha = 255 * anim_progress
				local window_style = window.style

				window_style.background.color[1] = alpha
				window_style.background_gradient.color[1] = 200 * anim_progress
				window_style.outer_shadow.color[1] = 200 * anim_progress
				window_style.frame.color[1] = alpha
				window_style.corner.color[1] = alpha
				window_style.edge_top.color[1] = alpha
				window_style.edge_bottom.color[1] = alpha
				window_style.window_background.color[1] = alpha
			end
		},
		{
			name = "delay",
			end_time = 0.6,
			start_time = 0.5
		}
	}
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definitions,
	animations = animation_definitions
}
