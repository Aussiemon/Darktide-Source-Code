-- chunkname: @scripts/ui/view_elements/view_element_item_result_overlay_mastery/view_element_item_result_overlay_mastery_definitions.lua

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
	rarity_glow = {
		vertical_alignment = "center",
		parent = "weapon_stats_pivot",
		horizontal_alignment = "center",
		size = {
			500,
			500
		},
		position = {
			0,
			15,
			50
		}
	}
}
local title_text_style = table.clone(UIFontSettings.header_1)

title_text_style.text_horizontal_alignment = "center"
title_text_style.text_vertical_alignment = "top"

local input_text_style = table.clone(UIFontSettings.header_3)

input_text_style.text_horizontal_alignment = "center"
input_text_style.text_vertical_alignment = "bottom"

local item_display_name_text_style = table.clone(UIFontSettings.header_3)

item_display_name_text_style.text_horizontal_alignment = "left"
item_display_name_text_style.text_vertical_alignment = "top"
item_display_name_text_style.horizontal_alignment = "right"
item_display_name_text_style.vertical_alignment = "top"
item_display_name_text_style.offset = {
	-20,
	10,
	5
}
item_display_name_text_style.font_size = 24
item_display_name_text_style.size = {
	560,
	40
}
item_display_name_text_style.text_color = Color.terminal_text_header(255, true)
item_display_name_text_style.default_color = Color.terminal_text_header(255, true)
item_display_name_text_style.unlock_color = Color.terminal_text_key_value(255, true)
item_display_name_text_style.locked_color = Color.terminal_text_header(100, true)

local text_icon_style = table.clone(UIFontSettings.header_2)

text_icon_style.text_horizontal_alignment = "center"
text_icon_style.text_vertical_alignment = "center"
text_icon_style.horizontal_alignment = "center"
text_icon_style.vertical_alignment = "center"
text_icon_style.text_color = Color.terminal_text_header(255, true)
text_icon_style.default_color = Color.terminal_text_header(255, true)
text_icon_style.unlock_color = Color.terminal_text_key_value(255, true)
text_icon_style.locked_color = Color.terminal_text_header(100, true)

local mark_display_name_text_style = table.clone(item_display_name_text_style)

mark_display_name_text_style.text_vertical_alignment = "top"
mark_display_name_text_style.vertical_alignment = "top"
mark_display_name_text_style.horizontal_alignment = "center"
mark_display_name_text_style.text_horizontal_alignment = "center"
mark_display_name_text_style.size = {
	nil,
	40
}
mark_display_name_text_style.size_addition = {
	-20
}
mark_display_name_text_style.offset = {
	10,
	0,
	6
}

local unlocked_level_text_style = table.clone(mark_display_name_text_style)

unlocked_level_text_style.vertical_alignment = "bottom"

local function bottom_particle_change_function(content, style, animations, dt)
	local material_values = style.material_values
	local progress = material_values.progress
	local progress_speed = material_values.progress_speed or 0.7
	local new_progress = (progress + dt * progress_speed) % 1

	if new_progress < progress then
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

	if new_progress < progress then
		material_values.rotation = math.random_range(0.5, 1)
		material_values.intensity = math.random_range(0, 1)
		material_values.progress_speed = math.random_range(0.25, 1)
	end

	material_values.progress = new_progress
end

local widget_definitions = {
	overlay = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/default_square",
			pass_type = "texture",
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
	rarity_glow = UIWidget.create_definition({
		{
			value_id = "glow",
			style_id = "glow",
			pass_type = "texture",
			value = "content/ui/materials/effects/item_aquisition/glow_rarity_01",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					340,
					350
				}
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
	}, "rarity_glow"),
	divider = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/premium_store/tabs",
			value_id = "texture",
			pass_type = "texture",
			style = {
				offset = {
					0,
					0,
					1
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "lower_glow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.terminal_grid_background(255, true),
				offset = {
					0,
					-3,
					0
				},
				size_addition = {
					-320,
					9
				}
			}
		}
	}, "divider"),
	reward = UIWidget.create_definition({
		{
			value_id = "icon",
			pass_type = "texture",
			style_id = "icon",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				unlock_color = Color.terminal_text_key_value(255, true),
				locked_color = Color.white(100, true),
				default_color = Color.white(255, true),
				color = Color.white(255, true),
				offset = {
					0,
					0,
					5
				}
			},
			visibility_function = function (content, style)
				return not not content.icon
			end
		},
		{
			value_id = "text_icon",
			style_id = "text_icon",
			pass_type = "text",
			value = "",
			style = text_icon_style
		},
		{
			value_id = "display_name",
			style_id = "display_name",
			pass_type = "text",
			value = "",
			style = mark_display_name_text_style
		},
		{
			value_id = "unlock_level",
			style_id = "unlock_level",
			pass_type = "text",
			value = "",
			style = unlocked_level_text_style
		}
	}, "weapon_stats_pivot")
}
local anim_start_delay = 0
local animations = {
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
			value = "content/ui/materials/backgrounds/default_square",
			pass_type = "texture",
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
