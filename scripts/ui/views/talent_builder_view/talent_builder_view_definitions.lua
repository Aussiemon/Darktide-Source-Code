local ColorUtilities = require("scripts/utilities/ui/colors")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local TalentBuilderViewSettings = require("scripts/ui/views/talent_builder_view/talent_builder_view_settings")
local summary_window_size = TalentBuilderViewSettings.summary_window_size
local summary_grid_size = TalentBuilderViewSettings.summary_grid_size
local tutorial_window_size = TalentBuilderViewSettings.tutorial_window_size
local tutorial_grid_size = TalentBuilderViewSettings.tutorial_grid_size
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
	layout_background = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			256,
			256
		},
		position = {
			0,
			0,
			1
		}
	},
	talent = {
		vertical_alignment = "top",
		parent = "layout_background",
		horizontal_alignment = "left",
		size = {
			110,
			110
		},
		position = {
			0,
			0,
			5
		}
	},
	gamepad_cursor_pivot = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			1,
			1
		},
		position = {
			0,
			0,
			500
		}
	},
	gamepad_cursor = {
		vertical_alignment = "center",
		parent = "gamepad_cursor_pivot",
		horizontal_alignment = "center",
		size = {
			80,
			125
		},
		position = {
			0,
			0,
			0
		}
	},
	summary_window = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = summary_window_size,
		position = {
			0,
			30,
			170
		}
	},
	summary_grid = {
		vertical_alignment = "bottom",
		parent = "summary_window",
		horizontal_alignment = "center",
		size = summary_grid_size,
		position = {
			-5,
			-20,
			1
		}
	},
	tutorial_window = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = tutorial_window_size,
		position = {
			0,
			30,
			170
		}
	},
	tutorial_grid = {
		vertical_alignment = "bottom",
		parent = "tutorial_window",
		horizontal_alignment = "right",
		size = tutorial_grid_size,
		position = {
			-60,
			-120,
			2
		}
	},
	tutorial_button_1 = {
		vertical_alignment = "bottom",
		parent = "tutorial_window",
		horizontal_alignment = "center",
		size = {
			300,
			40
		},
		position = {
			-170,
			-40,
			3
		}
	},
	tutorial_button_2 = {
		vertical_alignment = "bottom",
		parent = "tutorial_window",
		horizontal_alignment = "center",
		size = {
			300,
			40
		},
		position = {
			170,
			-40,
			3
		}
	}
}
local overlay_scenegraph_definition = {
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
	tooltip = {
		vertical_alignment = "left",
		parent = "screen",
		horizontal_alignment = "top",
		size = {
			400,
			400
		},
		position = {
			0,
			0,
			130
		}
	},
	info_banner = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			402,
			658
		},
		position = {
			60,
			270,
			10
		}
	},
	talent_points = {
		vertical_alignment = "top",
		parent = "info_banner",
		horizontal_alignment = "center",
		size = {
			400,
			50
		},
		position = {
			0,
			130,
			10
		}
	},
	summary_header = {
		vertical_alignment = "top",
		parent = "info_banner",
		horizontal_alignment = "center",
		size = {
			300,
			50
		},
		position = {
			0,
			320,
			10
		}
	},
	summary_button = {
		vertical_alignment = "bottom",
		parent = "info_banner",
		horizontal_alignment = "center",
		size = {
			300,
			50
		},
		position = {
			0,
			-90,
			1
		}
	},
	loadout_slot_ability = {
		vertical_alignment = "top",
		parent = "summary_header",
		horizontal_alignment = "center",
		size = {
			80,
			80
		},
		position = {
			-90,
			80,
			1
		}
	},
	loadout_slot_tactical = {
		vertical_alignment = "top",
		parent = "summary_header",
		horizontal_alignment = "center",
		size = {
			80,
			80
		},
		position = {
			0,
			80,
			1
		}
	},
	loadout_slot_aura = {
		vertical_alignment = "top",
		parent = "summary_header",
		horizontal_alignment = "center",
		size = {
			80,
			80
		},
		position = {
			90,
			80,
			1
		}
	},
	talent_points_total = {
		vertical_alignment = "bottom",
		parent = "talent_points",
		horizontal_alignment = "center",
		size = {
			400,
			50
		},
		position = {
			0,
			130,
			1
		}
	}
}

local function node_highligt_change_function(content, style, _, dt)
	local alpha_anim_progress = content.alpha_anim_progress or 0
	local alpha_fraction = nil

	if content.highlighted and content.has_points_spent then
		local alpha_speed = 2
		alpha_anim_progress = math.min(alpha_anim_progress + dt * alpha_speed, 1)
		local bounce_amount = 3.14
		local bounce_value = math.abs(math.sin(bounce_amount * (alpha_anim_progress + 1) * (alpha_anim_progress + 1)) * (1 - alpha_anim_progress))
		alpha_fraction = 1 - bounce_value
	else
		local alpha_speed = 8
		alpha_anim_progress = math.max(alpha_anim_progress - dt * alpha_speed, 0)
		alpha_fraction = alpha_anim_progress
	end

	content.alpha_anim_progress = alpha_anim_progress
	style.color[1] = 255 * alpha_fraction
end

local function node_icon_change_function(content, style, _, dt)
	local node_data = content.node_data

	if node_data then
		local material_values = style.material_values
		material_values.saturation = content.locked and 1 or 1
		local intensity_speed = 8

		if intensity_speed then
			local intensity_anim_progress = content.intensity_anim_progress or 0

			if content.has_points_spent or content.hotspot.is_hover then
				intensity_anim_progress = math.min(intensity_anim_progress + dt * intensity_speed, 1)
			else
				intensity_anim_progress = math.max(intensity_anim_progress - dt * intensity_speed, 0)
			end

			content.intensity_anim_progress = intensity_anim_progress
			local highlight_intensity_anim_progress = content.highlight_intensity_anim_progress or 0
			local highlight_intensity_speed = 0.8
			local highlight_intensity = 0

			if content.highlighted then
				highlight_intensity_anim_progress = math.min(highlight_intensity_anim_progress + dt * highlight_intensity_speed, 1)
				highlight_intensity = (1 - math.ease_out_quad(highlight_intensity_anim_progress)) * 0.5
			else
				highlight_intensity_anim_progress = 0
			end

			content.highlight_intensity_anim_progress = highlight_intensity_anim_progress

			if content.locked then
				material_values.intensity = -0.65 + highlight_intensity + 0.65 * intensity_anim_progress
			else
				local pulse_speed = 5.5
				local pulse_progress = 0.5 + math.sin(Application.time_since_launch() * pulse_speed) * 0.5
				material_values.intensity = -0.25 + highlight_intensity + math.max(0.15 * pulse_progress, 0.25 * intensity_anim_progress)
			end
		end

		local icon = node_data.icon

		if icon and icon ~= content.icon_texture then
			content.icon_texture = icon
			material_values.icon = icon
		end
	end
end

local widget_definitions = {
	input_surface = UIWidget.create_definition({
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size_addition = {
					0,
					-160
				},
				offset = {
					0,
					100,
					10
				}
			}
		}
	}, "screen"),
	tooltip = UIWidget.create_definition({
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
		},
		{
			value_id = "level_counter",
			pass_type = "text",
			style_id = "level_counter",
			value = "",
			style = {
				font_size = 16,
				horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_horizontal_alignment = "right",
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
		},
		{
			value_id = "next_level_title",
			pass_type = "text",
			style_id = "next_level_title",
			value = "",
			style = {
				font_size = 16,
				text_vertical_alignment = "center",
				horizontal_alignment = "center",
				text_horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_body_sub_header(255, true),
				size = {
					nil,
					0
				},
				color = {
					100,
					0,
					0,
					255
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
			value_id = "next_level_description",
			pass_type = "text",
			style_id = "next_level_description",
			value = "",
			style = {
				font_size = 20,
				horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_body(200, true),
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
			value_id = "exculsive_group_description",
			pass_type = "text",
			style_id = "exculsive_group_description",
			value = "",
			style = {
				font_size = 18,
				horizontal_alignment = "center",
				text_vertical_alignment = "center",
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
				size_addition = {
					-40,
					0
				}
			}
		},
		{
			value_id = "requirement_title",
			pass_type = "text",
			style_id = "requirement_title",
			value = "n/a",
			style = {
				font_size = 16,
				text_vertical_alignment = "center",
				horizontal_alignment = "center",
				text_horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "proxima_nova_bold",
				text_color = {
					255,
					142,
					60,
					60
				},
				size = {
					nil,
					0
				},
				color = {
					100,
					0,
					0,
					255
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
			value_id = "requirement_description",
			pass_type = "text",
			style_id = "requirement_description",
			value = "n/a",
			style = {
				font_size = 18,
				text_vertical_alignment = "center",
				horizontal_alignment = "center",
				text_horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "proxima_nova_bold",
				text_color = {
					255,
					198,
					83,
					83
				},
				size = {
					nil,
					0
				},
				color = {
					255,
					159,
					67,
					67
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
			value_id = "input_text",
			pass_type = "text",
			style_id = "input_text",
			value = "",
			style = {
				font_size = 18,
				horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "proxima_nova_bold",
				text_color = Color.text_default(255, true),
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
			style_id = "requirement_background",
			pass_type = "rect",
			style = {
				vertical_alignment = "top",
				size = {
					nil,
					0
				},
				offset = {
					0,
					0,
					1
				},
				color = {
					150,
					35,
					0,
					0
				}
			}
		},
		{
			style_id = "input_background",
			pass_type = "rect",
			style = {
				vertical_alignment = "top",
				size = {
					nil,
					0
				},
				offset = {
					0,
					0,
					1
				},
				color = {
					100,
					0,
					0,
					0
				}
			}
		}
	}, "tooltip"),
	info_banner = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "badge",
			value = "content/ui/materials/icons/class_badges/container",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				material_values = {
					effect_progress = 0
				},
				size = {
					380,
					228
				},
				offset = {
					0,
					-300,
					5
				},
				size_addition = {
					0,
					0
				}
			},
			change_function = function (content, style, _, dt)
				local material_values = style.material_values
				local effect_progress = material_values.effect_progress

				if content.play_badge_effect_anim then
					content.play_badge_effect_anim = false
					effect_progress = 0
				end

				if effect_progress < 1 then
					local selection_anim_speed = 1.5
					effect_progress = effect_progress + dt * selection_anim_speed
					material_values.effect_progress = math.min(effect_progress, 1)
					local size_addition = style.size_addition
					local size_increase_value = 5
					local size_anim_value = -size_increase_value + math.min(math.ease_pulse(effect_progress), 1) * size_increase_value
					size_addition[1] = size_anim_value
					size_addition[2] = size_anim_value
				end
			end
		},
		{
			value = "content/ui/materials/frames/talents/info_banner",
			style_id = "background_2",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				scale_to_material = true,
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					1
				},
				color = Color.white(255, true),
				size_addition = {
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				scale_to_material = true,
				size = {
					310,
					560
				},
				offset = {
					0,
					40,
					0
				},
				size_addition = {
					24,
					24
				},
				color = Color.terminal_grid_background(nil, true)
			}
		},
		{
			value = "content/ui/materials/frames/talents/info_banner_separator",
			style_id = "separator",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				scale_to_material = true,
				size = {
					254,
					14
				},
				offset = {
					0,
					280,
					0
				},
				color = Color.white(255, true),
				size_addition = {
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/effects/talents_info_banner_candles",
			style_id = "background_3",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				scale_to_material = true,
				size = {
					402,
					116
				},
				offset = {
					0,
					-36,
					3
				},
				color = Color.white(255, true),
				size_addition = {
					0,
					0
				}
			}
		}
	}, "info_banner"),
	summary_button = UIWidget.create_definition(ButtonPassTemplates.input_legend_button, "summary_button", {
		text = "",
		visible = true
	}),
	summary_header = UIWidget.create_definition({
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			style = {
				vertical_alignment = "bottom",
				font_size = 24,
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
			},
			value = Localize("loc_alias_talent_builder_view_title_summary")
		}
	}, "summary_header"),
	talent_points = UIWidget.create_definition({
		{
			style_id = "title_text",
			value_id = "title_text",
			pass_type = "text",
			style = {
				vertical_alignment = "center",
				font_size = 24,
				horizontal_alignment = "center",
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					0,
					1
				}
			},
			value = Localize("loc_talent_talent_points")
		},
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			value = "000",
			style = {
				vertical_alignment = "center",
				font_size = 62,
				horizontal_alignment = "center",
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				text_color = Color.terminal_text_header_selected(255, true),
				offset = {
					0,
					50,
					1
				}
			}
		}
	}, "talent_points"),
	loadout_slot_ability = UIWidget.create_definition({
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot",
			content = {
				hover_type = "circle"
			},
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
					0
				}
			}
		},
		{
			value_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/frames/talents/talent_icon_container",
			style_id = "icon",
			style = {
				material_values = {
					intensity = 0,
					saturation = 1,
					frame = "content/ui/textures/frames/talents/hex_frame",
					icon_mask = "content/ui/textures/frames/talents/hex_frame_mask"
				},
				offset = {
					0,
					0,
					1
				}
			},
			change_function = node_icon_change_function
		},
		{
			pass_type = "texture",
			style_id = "frame_selected",
			value = "content/ui/materials/frames/talents/hex_filled",
			style = {
				offset = {
					0,
					0,
					5
				},
				color = Color.white(255, true),
				material_values = {
					fill_color = ColorUtilities.format_color_to_material({
						255,
						234,
						255,
						255
					}),
					blur_color = ColorUtilities.format_color_to_material({
						255,
						73,
						161,
						242
					})
				}
			},
			change_function = node_highligt_change_function
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/talents/hex_frame_selected",
			style = {
				offset = {
					0,
					0,
					3
				},
				color = Color.ui_terminal(255, true)
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local anim_progress = math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress)
				local hover_alpha = anim_progress * 255
				style.color[1] = hover_alpha
			end
		}
	}, "loadout_slot_ability"),
	loadout_slot_aura = UIWidget.create_definition({
		{
			style_id = "hotspot",
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
					0
				}
			}
		},
		{
			value_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/frames/talents/talent_icon_container",
			style_id = "icon",
			style = {
				material_values = {
					intensity = 0,
					saturation = 1,
					frame = "content/ui/textures/frames/talents/circular_frame",
					icon_mask = "content/ui/textures/frames/talents/circular_frame_mask"
				},
				offset = {
					0,
					0,
					1
				}
			},
			change_function = node_icon_change_function
		},
		{
			pass_type = "texture",
			style_id = "frame_selected",
			value = "content/ui/materials/frames/talents/circular_filled",
			style = {
				offset = {
					0,
					0,
					5
				},
				color = Color.white(255, true),
				material_values = {
					fill_color = ColorUtilities.format_color_to_material({
						255,
						234,
						255,
						255
					}),
					blur_color = ColorUtilities.format_color_to_material({
						255,
						73,
						161,
						242
					})
				}
			},
			change_function = node_highligt_change_function
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/talents/circular_frame_selected",
			style = {
				offset = {
					0,
					0,
					3
				},
				color = Color.ui_terminal(255, true)
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local anim_progress = math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress)
				local hover_alpha = anim_progress * 255
				style.color[1] = hover_alpha
			end
		}
	}, "loadout_slot_aura"),
	loadout_slot_tactical = UIWidget.create_definition({
		{
			style_id = "hotspot",
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
					0
				}
			}
		},
		{
			value_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/frames/talents/talent_icon_container",
			style_id = "icon",
			style = {
				material_values = {
					intensity = 0,
					saturation = 1,
					frame = "content/ui/textures/frames/talents/square_frame",
					icon_mask = "content/ui/textures/frames/talents/square_frame_mask"
				},
				offset = {
					0,
					0,
					1
				}
			},
			change_function = node_icon_change_function
		},
		{
			pass_type = "texture",
			style_id = "frame_selected",
			value = "content/ui/materials/frames/talents/square_filled",
			style = {
				offset = {
					0,
					0,
					5
				},
				color = Color.white(255, true),
				material_values = {
					fill_color = ColorUtilities.format_color_to_material({
						255,
						234,
						255,
						255
					}),
					blur_color = ColorUtilities.format_color_to_material({
						255,
						73,
						161,
						242
					})
				}
			},
			change_function = node_highligt_change_function
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/talents/square_frame_selected",
			style = {
				offset = {
					0,
					0,
					3
				},
				color = Color.ui_terminal(255, true)
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local anim_progress = math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress)
				local hover_alpha = anim_progress * 255
				style.color[1] = hover_alpha
			end
		}
	}, "loadout_slot_tactical")
}
local color_cursor = {
	255,
	255,
	255,
	255
}
local layout_widget_definitions = {
	layout_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/talents/talents_bg",
			pass_type = "texture",
			style = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					-1
				}
			}
		},
		{
			value = "content/ui/materials/frames/talents/talent_bg_top_gradient_zealot",
			value_id = "image",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					1696,
					1074
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					138,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/masks/gradient_vignette",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				scenegraph_id = "screen",
				horizontal_alignment = "center",
				size = {
					1920
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					2
				}
			}
		},
		{
			value = "content/ui/materials/base/ui_gradient_base",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				scenegraph_id = "screen",
				horizontal_alignment = "center",
				size = {
					nil,
					130
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					-20,
					25
				},
				material_values = {
					uv_rotation = 0.25,
					offset = 0.8,
					color_2 = {
						0,
						0,
						0,
						0
					}
				}
			}
		},
		{
			value = "content/ui/materials/base/ui_gradient_base",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				scenegraph_id = "screen",
				horizontal_alignment = "center",
				size = {
					nil,
					60
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					25
				},
				material_values = {
					uv_rotation = 0.75,
					offset = 0.8,
					color_2 = {
						0,
						0,
						0,
						0
					}
				}
			}
		}
	}, "layout_background"),
	gamepad_cursor = UIWidget.create_definition({
		{
			value = "content/ui/materials/cursors/talent_tree_gamepad_cursor",
			style_id = "glow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = color_cursor,
				offset = {
					0,
					0,
					5
				},
				size_addition = {
					20,
					20
				}
			}
		}
	}, "gamepad_cursor"),
	summary_window = UIWidget.create_definition({
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
					169
				},
				size_addition = {
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/masks/gradient_vignette",
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
					168
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					24,
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
				}
			}
		},
		{
			value_id = "title",
			pass_type = "text",
			style_id = "title",
			style = {
				text_vertical_alignment = "center",
				horizontal_alignment = "center",
				font_size = 32,
				text_horizontal_alignment = "center",
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
					35,
					7
				},
				size_addition = {
					-40,
					0
				}
			},
			value = Localize("loc_alias_talent_builder_view_popup_title_summary")
		},
		{
			value = "content/ui/materials/dividers/skull_center_02",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					468,
					22
				},
				color = Color.terminal_text_header(255, true),
				offset = {
					0,
					60,
					3
				}
			}
		},
		{
			value = "content/ui/materials/dividers/horizontal_dynamic_upper",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					nil,
					10
				},
				size_addition = {
					10,
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
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					nil,
					10
				},
				size_addition = {
					10,
					0
				},
				color = Color.terminal_text_header(255, true),
				offset = {
					0,
					4,
					14
				}
			}
		}
	}, "summary_window"),
	tutorial_window = UIWidget.create_definition({
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
			value_id = "image",
			style_id = "image",
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				size = {
					tutorial_window_size[1] - (tutorial_grid_size[1] + 60),
					tutorial_window_size[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					2
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
					169
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
					168
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
					24,
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
				}
			}
		},
		{
			value_id = "title",
			pass_type = "text",
			style_id = "title",
			style = {
				font_size = 28,
				horizontal_alignment = "right",
				text_vertical_alignment = "top",
				text_horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_header(255, true),
				size = {
					tutorial_grid_size[1],
					0
				},
				offset = {
					-60,
					35,
					7
				},
				size_addition = {
					0,
					0
				}
			},
			value = Localize("loc_alias_talent_builder_view_popup_title_summary")
		},
		{
			value_id = "page_counter",
			pass_type = "text",
			style_id = "page_counter",
			value = "0/0",
			style = {
				font_size = 20,
				horizontal_alignment = "right",
				text_vertical_alignment = "top",
				text_horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_body_sub_header(255, true),
				size = {
					tutorial_grid_size[1],
					0
				},
				offset = {
					-60,
					70,
					7
				},
				size_addition = {
					0,
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
					10,
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
					10,
					0
				},
				color = Color.terminal_text_header(255, true),
				offset = {
					0,
					4,
					14
				}
			}
		}
	}, "tutorial_window"),
	tutorial_button_1 = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "tutorial_button_1", {
		text = "tutorial_button_1",
		visible = true
	}),
	tutorial_button_2 = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "tutorial_button_2", {
		text = "tutorial_button_2",
		visible = true
	})
}
local tutorial_window_open_delay = 0.5
local animations = {
	tutorial_window_open = {
		{
			name = "init",
			start_time = 0,
			end_time = tutorial_window_open_delay,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				local tutorial_window = widgets.tutorial_window

				for _, pass_style in pairs(tutorial_window.style) do
					local color = pass_style.text_color or pass_style.color

					if color then
						color[1] = 0
					end
				end

				widgets.tutorial_button_1.alpha_multiplier = 0
				widgets.tutorial_button_2.alpha_multiplier = 0
				local tutorial_grid = parent._tutorial_grid
				local grid_widgets = tutorial_grid and tutorial_grid:widgets()

				if grid_widgets then
					for i = 1, #grid_widgets do
						grid_widgets[i].alpha_multiplier = 0
					end
				end
			end
		},
		{
			name = "fade_in_background",
			end_time = 1.2,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeCubic(progress)
				local tutorial_window = widgets.tutorial_window
				local alpha = 100 * anim_progress
				tutorial_window.style.screen_background.color[1] = alpha
				tutorial_window.style.screen_background_vignette.color[1] = alpha
			end
		},
		{
			name = "fade_in_window",
			start_time = tutorial_window_open_delay,
			end_time = tutorial_window_open_delay + 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeOutCubic(progress)
				local tutorial_window = widgets.tutorial_window
				local alpha = 255 * anim_progress
				local window_style = tutorial_window.style
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
			start_time = tutorial_window_open_delay + 0.4,
			end_time = tutorial_window_open_delay + 0.7,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeOutCubic(progress)
				local tutorial_grid = parent._tutorial_grid
				local grid_widgets = tutorial_grid and tutorial_grid:widgets()

				if grid_widgets then
					for i = 1, #grid_widgets do
						grid_widgets[i].alpha_multiplier = anim_progress
					end
				end

				widgets.tutorial_button_1.alpha_multiplier = anim_progress
				widgets.tutorial_button_2.alpha_multiplier = anim_progress
				local alpha = 255 * anim_progress
				local tutorial_window = widgets.tutorial_window
				tutorial_window.style.title.text_color[1] = alpha
				tutorial_window.style.page_counter.text_color[1] = alpha
				tutorial_window.style.image.color[1] = alpha
			end
		},
		{
			name = "move",
			start_time = tutorial_window_open_delay + 0,
			end_time = tutorial_window_open_delay + 0.4,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				parent:_set_scenegraph_size("tutorial_window", nil, 100)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeCubic(progress)
				local y_anim_distance_max = 50
				local y_anim_distance = y_anim_distance_max - y_anim_distance_max * anim_progress

				parent:_set_scenegraph_size("tutorial_window", nil, 100 + (scenegraph_definition.tutorial_window.size[2] - 100) * anim_progress)
			end
		}
	}
}
local definitions = {
	animations = animations,
	widget_definitions = widget_definitions,
	layout_widget_definitions = layout_widget_definitions,
	scenegraph_definition = scenegraph_definition,
	overlay_scenegraph_definition = overlay_scenegraph_definition
}
local node_definitions = require("scripts/ui/views/talent_builder_view/talent_builder_view_node_definitions")

table.merge(definitions, node_definitions)

return definitions
