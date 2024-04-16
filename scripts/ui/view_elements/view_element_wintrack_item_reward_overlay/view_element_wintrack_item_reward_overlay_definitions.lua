local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	pivot = {
		vertical_alignment = "center",
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
	title_text = {
		vertical_alignment = "center",
		parent = "divider",
		horizontal_alignment = "center",
		size = {
			900,
			50
		},
		position = {
			0,
			1,
			3
		}
	},
	divider = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "center",
		size = {
			700,
			76
		},
		position = {
			0,
			-500,
			0
		}
	},
	input_text = {
		vertical_alignment = "bottom",
		parent = "pivot",
		horizontal_alignment = "center",
		size = {
			900,
			50
		},
		position = {
			0,
			500,
			3
		}
	},
	weapon_stats_pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			530,
			0
		},
		position = {
			0,
			0,
			300
		}
	},
	element = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			544,
			598
		},
		position = {
			0,
			-100,
			15
		}
	},
	rarity_glow = {
		vertical_alignment = "center",
		parent = "element",
		horizontal_alignment = "center",
		size = {
			500,
			500
		},
		position = {
			0,
			0,
			-5
		}
	},
	display_name = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1700,
			50
		},
		position = {
			0,
			-180,
			3
		}
	},
	sub_display_name = {
		vertical_alignment = "top",
		parent = "display_name",
		horizontal_alignment = "center",
		size = {
			1700,
			50
		},
		position = {
			0,
			35,
			4
		}
	}
}
local sub_title_style = table.clone(UIFontSettings.terminal_header_3)
sub_title_style.text_horizontal_alignment = "left"
sub_title_style.horizontal_alignment = "left"
sub_title_style.text_vertical_alignment = "top"
sub_title_style.vertical_alignment = "top"
sub_title_style.offset = {
	0,
	0,
	1
}
sub_title_style.font_size = 24
sub_title_style.text_color = Color.terminal_text_body_sub_header(255, true)
local sub_display_name_style = table.clone(sub_title_style)
sub_display_name_style.text_color = Color.terminal_text_body(255, true)
sub_display_name_style.text_horizontal_alignment = "center"
sub_display_name_style.text_vertical_alignment = "center"
local display_name_style = table.clone(UIFontSettings.header_1)
display_name_style.font_size = 40
display_name_style.offset = {
	0,
	0,
	1
}
display_name_style.text_horizontal_alignment = "center"
display_name_style.text_vertical_alignment = "center"
display_name_style.material = "content/ui/materials/font_gradients/slug_font_gradient_header"
local header_sub_title_text_style = table.clone(UIFontSettings.header_5)
header_sub_title_text_style.text_horizontal_alignment = "center"
header_sub_title_text_style.text_vertical_alignment = "top"
header_sub_title_text_style.offset = {
	0,
	0,
	0
}
header_sub_title_text_style.text_color = Color.terminal_text_body(255, true)
local title_text_style = table.clone(UIFontSettings.header_1)
title_text_style.text_horizontal_alignment = "center"
title_text_style.text_vertical_alignment = "top"
local input_text_style = table.clone(UIFontSettings.header_3)
input_text_style.text_horizontal_alignment = "center"
input_text_style.text_vertical_alignment = "bottom"
input_text_style.font_size = 20

local function bottom_particle_change_function(content, style, animations, dt)
	local material_values = style.material_values
	local progress = material_values.progress
	local progress_speed = material_values.progress_speed or 0.7
	local new_progress = (progress + dt * progress_speed) % 1

	if progress > new_progress then
		material_values.rotation = math.random_range(0, 0.5)
		material_values.intensity = math.random_range(0, 1)
		material_values.progress_speed = math.random_range(0.25, 1)
	end

	material_values.progress = new_progress
end

local function top_particle_change_function(content, style, animations, dt)
	local material_values = style.material_values
	local progress = material_values.progress
	local progress_speed = material_values.progress_speed or 0.7
	local new_progress = (progress + dt * progress_speed) % 1

	if progress > new_progress then
		material_values.rotation = math.random_range(0.5, 1)
		material_values.intensity = math.random_range(0, 1)
		material_values.progress_speed = math.random_range(0.25, 1)
	end

	material_values.progress = new_progress
end

local widget_definitions = {
	overlay = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = {
					200,
					0,
					0,
					0
				}
			}
		}
	}, "screen"),
	title_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = Localize("loc_item_result_overlay_title"),
			style = title_text_style
		}
	}, "title_text"),
	input_text = UIWidget.create_definition({
		{
			value = "n/a",
			value_id = "text",
			pass_type = "text",
			style = input_text_style
		}
	}, "input_text"),
	display_name = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = display_name_style
		}
	}, "display_name"),
	sub_display_name = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = sub_display_name_style
		}
	}, "sub_display_name"),
	element = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_body",
			style_id = "main_frame",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					544,
					598
				},
				default_size = {
					544,
					598
				},
				offset = {
					0,
					0,
					10
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
			value = "content/ui/materials/gradients/gradient_circular",
			style_id = "background_gradient",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				default_color = {
					100,
					33,
					35,
					37
				},
				color = {
					100,
					33,
					35,
					37
				},
				size = {
					282.5,
					282.5
				},
				default_size = {
					282.5,
					282.5
				},
				offset = {
					0,
					117,
					1
				},
				default_offset = {
					0,
					117,
					1
				}
			}
		},
		{
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_reward_background",
			style_id = "icon_background",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					282.5,
					282.5
				},
				default_size = {
					282.5,
					282.5
				},
				offset = {
					0,
					117,
					0
				},
				default_offset = {
					0,
					117,
					0
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
			value_id = "icon",
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/items/containers/item_container_square",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					282.5,
					282.5
				},
				default_size = {
					282.5,
					282.5
				},
				offset = {
					0,
					117,
					2
				},
				default_offset = {
					0,
					117,
					2
				},
				material_values = {},
				color = {
					255,
					255,
					255,
					255
				}
			},
			visibility_function = function (content, style)
				local use_placeholder_texture = content.use_placeholder_texture

				if use_placeholder_texture and use_placeholder_texture == 0 then
					return true
				end

				return false
			end
		},
		{
			pass_type = "texture_uv",
			style_id = "icon_door_left",
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_reward_door_left",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					142,
					283
				},
				default_size = {
					142,
					283
				},
				offset = {
					-272,
					117,
					3
				},
				default_offset = {
					-272,
					117,
					3
				},
				material_values = {},
				color = {
					255,
					255,
					255,
					255
				}
			},
			change_function = function (content, style)
				local style_progress = style.progress

				if style_progress then
					style.material_values.mask_progress = style_progress
				end
			end
		},
		{
			pass_type = "texture_uv",
			style_id = "icon_door_right",
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_reward_door_right",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = {
					142,
					283
				},
				default_size = {
					142,
					283
				},
				offset = {
					272,
					117,
					3
				},
				default_offset = {
					272,
					117,
					3
				},
				material_values = {},
				color = {
					255,
					255,
					255,
					255
				}
			},
			change_function = function (content, style)
				local style_progress = style.progress

				if style_progress then
					style.material_values.mask_progress = style_progress
				end
			end
		},
		{
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_wing_1_1",
			style_id = "wing_upper_left",
			pass_type = "rotated_texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					304,
					178
				},
				offset = {
					-342,
					-170,
					9
				},
				color = {
					255,
					255,
					255,
					255
				},
				pivot = {
					304,
					178
				}
			}
		},
		{
			pass_type = "rotated_texture",
			style_id = "wing_lower_left_1",
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_wing_1_2_feather_1",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					384,
					44
				},
				default_size = {
					384,
					44
				},
				offset = {
					-432,
					-225,
					8
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			change_function = function (content, style)
				local style_progress = style.progress or 0
				local progress = style_progress * 1
				style.uvs[2][1] = progress
				style.size[1] = style.default_size[1] * progress
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "wing_lower_left_2",
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_wing_1_2_feather_2",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					384,
					44
				},
				default_size = {
					384,
					44
				},
				offset = {
					-392,
					-190,
					7
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			change_function = function (content, style)
				local style_progress = style.progress or 0
				local progress = style_progress * 1
				style.uvs[2][1] = progress
				style.size[1] = style.default_size[1] * progress
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "wing_lower_left_3",
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_wing_1_2_feather_3",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					384,
					44
				},
				default_size = {
					384,
					44
				},
				offset = {
					-352,
					-155,
					6
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			change_function = function (content, style)
				local style_progress = style.progress or 0
				local progress = style_progress * 1
				style.uvs[2][1] = progress
				style.size[1] = style.default_size[1] * progress
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "wing_lower_left_4",
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_wing_1_2_feather_4",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					384,
					44
				},
				default_size = {
					384,
					44
				},
				offset = {
					-312,
					-120,
					5
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			change_function = function (content, style)
				local style_progress = style.progress or 0
				local progress = style_progress * 1
				style.uvs[2][1] = progress
				style.size[1] = style.default_size[1] * progress
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "wing_lower_left_5",
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_wing_1_2_feather_5",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					384,
					44
				},
				default_size = {
					384,
					44
				},
				offset = {
					-272,
					-85,
					4
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			change_function = function (content, style)
				local style_progress = style.progress or 0
				local progress = style_progress * 1
				style.uvs[2][1] = progress
				style.size[1] = style.default_size[1] * progress
			end
		},
		{
			pass_type = "texture_uv",
			style_id = "banner_left",
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_banner_1",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				size = {
					166,
					360
				},
				default_size = {
					166,
					360
				},
				offset = {
					-397,
					355,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			change_function = function (content, style)
				local style_progress = style.progress or 0
				style.uvs[1][2] = 1 - style_progress
				style.size[2] = style.default_size[2] * style_progress
			end
		},
		{
			pass_type = "texture_uv",
			style_id = "banner_right",
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_banner_2",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				size = {
					166,
					360
				},
				default_size = {
					166,
					360
				},
				offset = {
					397,
					355,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			change_function = function (content, style)
				local style_progress = style.progress or 0
				style.uvs[1][2] = 1 - style_progress
				style.size[2] = style.default_size[2] * style_progress
			end
		},
		{
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_wing_2_1",
			style_id = "wing_upper_right",
			pass_type = "rotated_texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = {
					304,
					178
				},
				offset = {
					342,
					-170,
					9
				},
				color = {
					255,
					255,
					255,
					255
				},
				pivot = {
					0,
					178
				}
			}
		},
		{
			pass_type = "rotated_texture",
			style_id = "wing_lower_right_1",
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_wing_2_2_feather_1",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = {
					384,
					44
				},
				default_size = {
					384,
					44
				},
				offset = {
					432,
					-225,
					8
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			change_function = function (content, style)
				local style_progress = style.progress or 0
				local progress = style_progress * 1
				style.uvs[1][1] = 1 - progress
				style.size[1] = style.default_size[1] * progress
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "wing_lower_right_2",
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_wing_2_2_feather_2",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = {
					384,
					44
				},
				default_size = {
					384,
					44
				},
				offset = {
					392,
					-190,
					7
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			change_function = function (content, style)
				local style_progress = style.progress or 0
				local progress = style_progress * 1
				style.uvs[1][1] = 1 - progress
				style.size[1] = style.default_size[1] * progress
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "wing_lower_right_3",
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_wing_2_2_feather_3",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = {
					384,
					44
				},
				default_size = {
					384,
					44
				},
				offset = {
					352,
					-155,
					6
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			change_function = function (content, style)
				local style_progress = style.progress or 0
				local progress = style_progress * 1
				style.uvs[1][1] = 1 - progress
				style.size[1] = style.default_size[1] * progress
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "wing_lower_right_4",
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_wing_2_2_feather_4",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = {
					384,
					44
				},
				default_size = {
					384,
					44
				},
				offset = {
					312,
					-120,
					5
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			change_function = function (content, style)
				local style_progress = style.progress or 0
				local progress = style_progress * 1
				style.uvs[1][1] = 1 - progress
				style.size[1] = style.default_size[1] * progress
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "wing_lower_right_5",
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_wing_2_2_feather_5",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = {
					384,
					44
				},
				default_size = {
					384,
					44
				},
				offset = {
					272,
					-85,
					4
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			change_function = function (content, style)
				local style_progress = style.progress or 0
				local progress = style_progress * 1
				style.uvs[1][1] = 1 - progress
				style.size[1] = style.default_size[1] * progress
			end
		}
	}, "element"),
	rarity_glow = UIWidget.create_definition({
		{
			value_id = "glow",
			style_id = "glow",
			pass_type = "texture",
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_background_glow",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					500,
					500
				},
				color = Color.ui_terminal(255, true)
			}
		},
		{
			style_id = "particle_1",
			pass_type = "texture",
			value = "content/ui/materials/effects/item_aquisition/particles_rarity_01",
			value_id = "particle",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					340,
					350
				},
				material_values = {
					intensity = 0,
					progress = 1
				}
			},
			change_function = bottom_particle_change_function
		},
		{
			pass_type = "texture",
			style_id = "particle_2",
			value_id = "particle",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					340,
					350
				},
				material_values = {
					intensity = 0,
					progress = 1
				}
			},
			change_function = bottom_particle_change_function
		},
		{
			pass_type = "texture",
			style_id = "particle_3",
			value_id = "particle",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					340,
					350
				},
				material_values = {
					intensity = 0,
					progress = 1
				}
			},
			change_function = bottom_particle_change_function
		},
		{
			pass_type = "texture",
			style_id = "particle_4",
			value_id = "particle",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					340,
					350
				},
				material_values = {
					intensity = 0,
					progress = 1
				}
			},
			change_function = bottom_particle_change_function
		},
		{
			pass_type = "texture",
			style_id = "particle_5",
			value_id = "particle",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					340,
					350
				},
				material_values = {
					intensity = 0,
					progress = 1
				}
			},
			change_function = top_particle_change_function
		},
		{
			pass_type = "texture",
			style_id = "particle_6",
			value_id = "particle",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					340,
					350
				},
				material_values = {
					intensity = 0,
					progress = 1
				}
			},
			change_function = top_particle_change_function
		},
		{
			pass_type = "texture",
			style_id = "particle_7",
			value_id = "particle",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					340,
					350
				},
				material_values = {
					intensity = 0,
					progress = 1
				}
			},
			change_function = top_particle_change_function
		},
		{
			pass_type = "texture",
			style_id = "particle_8",
			value_id = "particle",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					340,
					350
				},
				material_values = {
					intensity = 0,
					progress = 1
				}
			},
			change_function = top_particle_change_function
		}
	}, "rarity_glow")
}
local anim_start_delay = 0
local element_anim_start_delay = 0.5
local animations = {
	present_element = {
		{
			name = "delay",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local widget = widgets.element
				local style = widget.style

				for _, pass_style in pairs(style) do
					pass_style.color[1] = 0
				end

				widgets.rarity_glow.alpha_multiplier = 0
				widgets.display_name.alpha_multiplier = 0
				widgets.sub_display_name.alpha_multiplier = 0
				widgets.title_text.alpha_multiplier = 0
			end
		},
		{
			name = "init",
			start_time = element_anim_start_delay + 0,
			end_time = element_anim_start_delay + 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local widget = widgets.element
				local style = widget.style

				for _, pass_style in pairs(style) do
					pass_style.color[1] = 0
				end

				style.wing_upper_left.angle = math.degrees_to_radians(90)
				style.wing_upper_right.angle = math.degrees_to_radians(-90)
			end
		},
		{
			name = "main_frame_entry",
			start_time = element_anim_start_delay + 0,
			end_time = element_anim_start_delay + 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local widget = widgets.element
				local style = widget.style
				local anim_progress = math.ease_in_exp(progress)
				local main_frame_style = style.main_frame
				local size = main_frame_style.size
				local default_size = main_frame_style.default_size
				size[1] = default_size[1] * 0.8 + default_size[1] * 0.2 * anim_progress
				size[2] = default_size[2] * 0.8 + default_size[2] * 0.2 * anim_progress
				main_frame_style.color[1] = 255 * anim_progress
			end
		},
		{
			name = "icon_door_left_entry",
			start_time = element_anim_start_delay + 0,
			end_time = element_anim_start_delay + 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local widget = widgets.element
				local style = widget.style
				local anim_progress = math.ease_in_exp(progress)
				local icon_door_left_style = style.icon_door_left
				local size = icon_door_left_style.size
				local default_size = icon_door_left_style.default_size
				local anim_size_fraction = 0.2
				size[1] = default_size[1] * (1 - anim_size_fraction) + default_size[1] * anim_size_fraction * anim_progress
				size[2] = default_size[2] * (1 - anim_size_fraction) + default_size[2] * anim_size_fraction * anim_progress
				icon_door_left_style.color[1] = 255 * anim_progress
				icon_door_left_style.offset[2] = icon_door_left_style.default_offset[2] * (1 - anim_size_fraction) + icon_door_left_style.default_offset[2] * anim_size_fraction * anim_progress
			end
		},
		{
			name = "icon_door_right_entry",
			start_time = element_anim_start_delay + 0,
			end_time = element_anim_start_delay + 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local widget = widgets.element
				local style = widget.style
				local anim_progress = math.ease_in_exp(progress)
				local icon_door_right_style = style.icon_door_right
				local size = icon_door_right_style.size
				local default_size = icon_door_right_style.default_size
				local anim_size_fraction = 0.2
				size[1] = default_size[1] * (1 - anim_size_fraction) + default_size[1] * anim_size_fraction * anim_progress
				size[2] = default_size[2] * (1 - anim_size_fraction) + default_size[2] * anim_size_fraction * anim_progress
				icon_door_right_style.color[1] = 255 * anim_progress
				icon_door_right_style.offset[2] = icon_door_right_style.default_offset[2] * (1 - anim_size_fraction) + icon_door_right_style.default_offset[2] * anim_size_fraction * anim_progress
			end
		},
		{
			name = "icon_background_entry",
			start_time = element_anim_start_delay + 0.2,
			end_time = element_anim_start_delay + 0.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local widget = widgets.element
				local style = widget.style
				local anim_progress = math.ease_in_exp(progress)
				local icon_background_style = style.icon_background
				local gradient_background_style = style.background_gradient
				icon_background_style.color[1] = 255 * anim_progress
			end
		},
		{
			name = "pass_fade_in",
			start_time = element_anim_start_delay + 0.3,
			end_time = element_anim_start_delay + 0.4,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local widget = widgets.element
				local style = widget.style
				local anim_progress = math.easeOutCubic(progress)

				for _, pass_style in pairs(style) do
					pass_style.color[1] = math.max(pass_style.color[1], 255 * anim_progress)
				end
			end
		},
		{
			name = "move_upper_wings",
			start_time = element_anim_start_delay + 0.3,
			end_time = element_anim_start_delay + 0.6,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local widget = widgets.element
				local style = widget.style
				local wing_anim_progress = math.ease_in_exp(1 - progress)
				style.wing_upper_left.angle = math.degrees_to_radians(wing_anim_progress * 90)
				style.wing_upper_right.angle = math.degrees_to_radians(-wing_anim_progress * 90)
			end
		},
		{
			name = "move_lower_wings_1",
			start_time = element_anim_start_delay + 0.1 + 0.4,
			end_time = element_anim_start_delay + 0.1 + 0.5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local widget = widgets.element
				local style = widget.style
				local wing_anim_progress = math.ease_out_exp(progress)
				style.wing_lower_left_1.progress = wing_anim_progress
				style.wing_lower_right_1.progress = wing_anim_progress
			end
		},
		{
			name = "move_lower_wings_2",
			start_time = element_anim_start_delay + 0.1 + 0.45,
			end_time = element_anim_start_delay + 0.1 + 0.55,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local widget = widgets.element
				local style = widget.style
				local wing_anim_progress = math.ease_out_exp(progress)
				style.wing_lower_left_2.progress = wing_anim_progress
				style.wing_lower_right_2.progress = wing_anim_progress
			end
		},
		{
			name = "move_lower_wings_3",
			start_time = element_anim_start_delay + 0.1 + 0.5,
			end_time = element_anim_start_delay + 0.1 + 0.6,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local widget = widgets.element
				local style = widget.style
				local wing_anim_progress = math.ease_out_exp(progress)
				style.wing_lower_left_3.progress = wing_anim_progress
				style.wing_lower_right_3.progress = wing_anim_progress
			end
		},
		{
			name = "move_lower_wings_4",
			start_time = element_anim_start_delay + 0.1 + 0.55,
			end_time = element_anim_start_delay + 0.1 + 0.65,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local widget = widgets.element
				local style = widget.style
				local wing_anim_progress = math.ease_out_exp(progress)
				style.wing_lower_left_4.progress = wing_anim_progress
				style.wing_lower_right_4.progress = wing_anim_progress
			end
		},
		{
			name = "rarity_glow_fade_in",
			start_time = element_anim_start_delay + 0.2,
			end_time = element_anim_start_delay + 1.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local widget = widgets.rarity_glow
				local style = widget.style
				local anim_progress = math.easeOutCubic(progress)
				widgets.rarity_glow.alpha_multiplier = anim_progress
				widgets.rarity_glow.style.glow.size_addition[1] = 500 * anim_progress
				widgets.rarity_glow.style.glow.size_addition[2] = 500 * anim_progress
			end
		},
		{
			name = "text_fade_in",
			start_time = element_anim_start_delay + 0.8,
			end_time = element_anim_start_delay + 1.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local widget = widgets.rarity_glow
				local style = widget.style
				local anim_progress = math.easeOutCubic(progress)
				widgets.display_name.alpha_multiplier = anim_progress
				widgets.sub_display_name.alpha_multiplier = anim_progress
				widgets.title_text.alpha_multiplier = anim_progress
			end
		},
		{
			name = "icon_doors_open",
			start_time = element_anim_start_delay + 0.8,
			end_time = element_anim_start_delay + 1.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local widget = widgets.element
				local style = widget.style
				local wing_anim_progress = math.easeOutCubic(progress)
				style.icon_door_left.progress = wing_anim_progress
				style.icon_door_right.progress = wing_anim_progress
			end
		},
		{
			name = "move_lower_wings_5",
			start_time = element_anim_start_delay + 0.1 + 0.6,
			end_time = element_anim_start_delay + 0.1 + 0.7,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local widget = widgets.element
				local style = widget.style
				local wing_anim_progress = math.ease_out_exp(progress)
				style.wing_lower_left_5.progress = wing_anim_progress
				style.wing_lower_right_5.progress = wing_anim_progress
			end
		},
		{
			name = "banners_fold_out",
			start_time = element_anim_start_delay + 0.8,
			end_time = element_anim_start_delay + 1.1,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local widget = widgets.element
				local style = widget.style
				local wing_anim_progress = math.ease_out_quad(progress)
				style.banner_left.progress = wing_anim_progress
				style.banner_right.progress = wing_anim_progress
			end
		}
	},
	on_enter = {
		{
			name = "init",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent._alpha_multiplier = 0
			end
		},
		{
			name = "fade_in",
			start_time = anim_start_delay + 0,
			end_time = anim_start_delay + 0.5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				parent._alpha_multiplier = anim_progress
			end
		},
		{
			name = "move_pivot",
			start_time = anim_start_delay + 0,
			end_time = anim_start_delay + 0.5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local scenegraph_id = "weapon_stats_pivot"
				local y = 80 - 80 * anim_progress

				parent:_set_scenegraph_position(scenegraph_id, nil, y)
			end
		}
	}
}

return {
	animations = animations,
	background_widget_definition = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					0
				},
				color = Color.black(30, true)
			}
		}
	}, "screen"),
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
