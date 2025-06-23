-- chunkname: @scripts/ui/views/penance_overview_view/penance_overview_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local PenanceOverviewViewSettings = require("scripts/ui/views/penance_overview_view/penance_overview_view_settings")
local PenanceBlueprints = require("scripts/ui/views/penance_overview_view/penance_overview_view_blueprints")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local AchievementUIHelper = require("scripts/managers/achievements/utility/achievement_ui_helper")
local ColorUtilities = require("scripts/utilities/ui/colors")
local carousel_penance_size = PenanceOverviewViewSettings.carousel_penance_size
local penance_grid_background_size = PenanceOverviewViewSettings.penance_grid_background_size
local penance_grid_size = PenanceOverviewViewSettings.penance_grid_size
local tooltip_grid_size = PenanceOverviewViewSettings.tooltip_grid_size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	corner_top_left = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			112,
			230
		},
		position = {
			0,
			0,
			62
		}
	},
	corner_top_right = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			112,
			230
		},
		position = {
			0,
			0,
			62
		}
	},
	corner_bottom_left = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			128,
			184
		},
		position = {
			0,
			0,
			62
		}
	},
	corner_bottom_right = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			128,
			184
		},
		position = {
			0,
			0,
			62
		}
	},
	penance_points_panel = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			290,
			118
		},
		position = {
			0,
			10,
			63
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
			3
		}
	},
	penance_grid_background = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = penance_grid_background_size,
		position = {
			170,
			185,
			1
		}
	},
	penance_grid = {
		vertical_alignment = "top",
		parent = "penance_grid_background",
		horizontal_alignment = "left",
		size = penance_grid_size,
		position = {
			0,
			-13,
			1
		}
	},
	page_header = {
		vertical_alignment = "top",
		parent = "penance_grid_background",
		horizontal_alignment = "center",
		size = {
			penance_grid_background_size[1],
			75
		},
		position = {
			0,
			15,
			30
		}
	},
	total_completed = {
		vertical_alignment = "top",
		parent = "penance_grid_background",
		horizontal_alignment = "center",
		size = {
			penance_grid_size[1],
			50
		},
		position = {
			0,
			10,
			0
		}
	},
	page_category_pivot = {
		vertical_alignment = "top",
		parent = "penance_grid_background",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-43,
			1
		}
	},
	tooltip_grid = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "right",
		size = tooltip_grid_size,
		position = {
			-170,
			173,
			1
		}
	},
	wintrack = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			5,
			2
		}
	},
	carousel_card = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = carousel_penance_size,
		position = {
			0,
			-90,
			1
		}
	},
	carousel_header = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			penance_grid_background_size[1],
			55
		},
		position = {
			0,
			115,
			30
		}
	},
	carousel_footer = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			penance_grid_background_size[1],
			55
		},
		position = {
			0,
			765,
			30
		}
	}
}
local carousel_header_style = table.clone(UIFontSettings.terminal_header_3)

carousel_header_style.text_horizontal_alignment = "center"
carousel_header_style.horizontal_alignment = "center"
carousel_header_style.text_vertical_alignment = "top"
carousel_header_style.vertical_alignment = "top"

local page_header_style = table.clone(carousel_header_style)

page_header_style.offset = {
	0,
	20,
	1
}
carousel_header_style.font_size = 24
carousel_header_style.offset = {
	0,
	0,
	1
}

local carousel_footer_style = table.clone(carousel_header_style)
local widget_definitions = {
	penance_points_panel = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/achievements/achievements_label",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.white(255, true),
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
			style_id = "outer_glow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				scale_to_material = true,
				color = Color.terminal_text_key_value(0, true),
				size = {
					290,
					77
				},
				size_addition = {
					20,
					20
				},
				offset = {
					20,
					-12,
					0
				}
			}
		},
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			value = "0 ",
			style = {
				default_font_size = 40,
				horizontal_alignment = "left",
				font_size = 40,
				font_size_anim_increase = 10,
				text_horizontal_alignment = "center",
				vertical_alignment = "center",
				text_vertical_alignment = "center",
				drop_shadow = true,
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_header(nil, true),
				default_text_color = Color.terminal_text_header(nil, true),
				anim_text_color = Color.terminal_text_key_value(nil, true),
				offset = {
					0,
					-14,
					2
				}
			}
		}
	}, "penance_points_panel"),
	background = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/achievements_02_upper",
			scenegraph_id = "corner_top_left",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/effects/screen/achievements_02_upper_candles",
			scenegraph_id = "corner_top_left",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/frames/screen/achievements_02_upper",
			pass_type = "texture_uv",
			scenegraph_id = "corner_top_right",
			style = {
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
			value = "content/ui/materials/effects/screen/achievements_02_upper_candles",
			pass_type = "texture_uv",
			scenegraph_id = "corner_top_right",
			style = {
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
			value = "content/ui/materials/frames/screen/achievements_02_lower",
			pass_type = "texture",
			scenegraph_id = "corner_bottom_left",
			style = {
				offset = {
					0,
					0,
					16
				}
			}
		},
		{
			value = "content/ui/materials/effects/screen/achievements_02_lower_candles",
			pass_type = "texture",
			scenegraph_id = "corner_bottom_left",
			style = {
				offset = {
					0,
					0,
					16
				}
			}
		},
		{
			value = "content/ui/materials/frames/screen/achievements_02_lower_right",
			pass_type = "texture",
			scenegraph_id = "corner_bottom_right",
			style = {
				offset = {
					0,
					0,
					16
				}
			}
		},
		{
			value = "content/ui/materials/effects/screen/achievements_02_lower_right_candles",
			pass_type = "texture",
			scenegraph_id = "corner_bottom_right",
			style = {
				offset = {
					0,
					0,
					16
				}
			}
		}
	}, "screen"),
	page_header = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			value = "",
			style = page_header_style
		},
		{
			value_id = "divider_bottom",
			style_id = "divider_bottom",
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_center_02",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					468,
					22
				},
				offset = {
					0,
					0,
					2
				},
				color = Color.terminal_text_body_sub_header(nil, true)
			}
		},
		{
			value_id = "top_divider",
			style_id = "top_divider",
			pass_type = "texture",
			value = "content/ui/materials/frames/achievements/panel_main_top_frame",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					1080,
					76
				},
				offset = {
					0,
					-64,
					2
				},
				color = Color.white(nil, true)
			}
		},
		{
			value_id = "candles_1",
			style_id = "candles_1",
			pass_type = "texture",
			value = "content/ui/materials/effects/achievements/panel_main_top_frame_candles_left",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					100,
					100
				},
				offset = {
					-450,
					-98,
					2
				}
			}
		},
		{
			value_id = "candles_2",
			style_id = "candles_2",
			pass_type = "texture",
			value = "content/ui/materials/effects/achievements/panel_main_top_frame_candles_right",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					100,
					100
				},
				offset = {
					455,
					-101,
					2
				}
			}
		},
		{
			value_id = "top_bar",
			style_id = "top_bar",
			pass_type = "texture",
			value = "content/ui/materials/frames/achievements/tab_frame_horizontal",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					850,
					88
				},
				offset = {
					0,
					-75,
					3
				},
				color = Color.white(nil, true)
			}
		}
	}, "page_header"),
	carousel_header = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			style = carousel_header_style,
			value = Localize("loc_penance_menu_carousel_title")
		},
		{
			value_id = "divider_bottom",
			style_id = "divider_bottom",
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_center_02",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					468,
					22
				},
				offset = {
					0,
					-8,
					2
				},
				color = Color.terminal_text_body_sub_header(nil, true)
			}
		}
	}, "carousel_header"),
	carousel_footer = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			value = "1 / 10",
			style = carousel_footer_style
		}
	}, "carousel_footer"),
	screen = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.black(100, true)
			}
		}
	}, "screen")
}
local animations = {
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
			end_time = 2,
			start_time = 1,
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
			end
		},
		{
			name = "carousel_move",
			end_time = 2,
			start_time = 1,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				parent._carousel_entry_anim_progress = anim_progress
			end
		}
	},
	on_carousel_claimed = {
		{
			name = "fade_out",
			end_time = 0.3,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local scrollbar = params.grid:grid_scrollbar()

				scrollbar.alpha_multiplier = 0
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				for _, widget in ipairs(widgets) do
					widget.alpha_multiplier = 1 - anim_progress
				end
			end
		},
		{
			name = "size_shrink",
			end_time = 0.5,
			start_time = 0.1,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local pivot_offset = params.start_pivot_offset or 0

				if progress < 0.99 then
					local total_height = params.start_height

					if total_height then
						local half_height = total_height * 0.5
						local current_half_height = half_height * anim_progress

						params.grid:update_grid_height(total_height - total_height * anim_progress)

						params.parent._claim_animation_new_pivot = pivot_offset + current_half_height
					end
				else
					params.grid:update_grid_height(18)
				end
			end
		},
		{
			name = "divider_fade_out",
			end_time = 0.5,
			start_time = 0.4,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local divider_top = params.additional_widgets and params.additional_widgets.divider_top
				local divider_bottom = params.additional_widgets and params.additional_widgets.divider_bottom
				local background = params.additional_widgets and params.additional_widgets.background
				local total_height = params.start_height

				if progress < 0.99 then
					if background then
						background.alpha_multiplier = 1 - anim_progress
					end

					if divider_top then
						divider_top.alpha_multiplier = 1 - anim_progress
					end

					if divider_bottom then
						divider_bottom.alpha_multiplier = 1 - anim_progress
					end
				else
					params.grid:set_visibility(false)
				end
			end
		}
	},
	on_points_added = {
		{
			name = "in",
			end_time = 0.15,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local widget = widgets.penance_points_panel
				local style = widget.style
				local text_style = style.text
				local default_font_size = text_style.default_font_size or 0
				local font_size_anim_increase = text_style.font_size_anim_increase or 0

				text_style.font_size = default_font_size + font_size_anim_increase * anim_progress
				style.outer_glow.color[1] = anim_progress * 255

				local ignore_alpha = true

				ColorUtilities.color_lerp(text_style.default_text_color, text_style.anim_text_color, anim_progress, text_style.text_color, ignore_alpha)
			end
		},
		{
			name = "out",
			end_time = 1.1,
			start_time = 0.4,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.ease_out_exp(1 - progress)
				local widget = widgets.penance_points_panel
				local style = widget.style
				local text_style = style.text
				local default_font_size = text_style.default_font_size or 0
				local font_size_anim_increase = text_style.font_size_anim_increase or 0

				text_style.font_size = default_font_size + font_size_anim_increase * anim_progress
				style.outer_glow.color[1] = anim_progress * 255

				local ignore_alpha = true

				ColorUtilities.color_lerp(text_style.default_text_color, text_style.anim_text_color, anim_progress, text_style.text_color, ignore_alpha)
			end
		}
	}
}

local function format_favorites(_)
	local curr, max = AchievementUIHelper.favorite_achievement_count()

	return string.format(" (%d / %d)", curr, max)
end

local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	},
	{
		input_action = "hotkey_item_inspect",
		display_name = "loc_achievements_view_button_hint_favorite_achievement",
		on_pressed_callback = "_on_favorite_pressed",
		visibility_function = function (parent)
			return not parent._using_cursor_navigation and parent:_cb_favorite_legend_visibility(true)
		end,
		suffix_function = format_favorites
	},
	{
		input_action = "hotkey_item_inspect",
		display_name = "loc_achievements_view_button_hint_unfavorite_achievement",
		on_pressed_callback = "_on_favorite_pressed",
		visibility_function = function (parent)
			return not parent._using_cursor_navigation and parent:_cb_favorite_legend_visibility(false)
		end,
		suffix_function = format_favorites
	},
	{
		input_action = "secondary_action_pressed",
		display_name = "loc_achievements_view_button_hint_favorite_achievement",
		on_pressed_callback = "_on_favorite_pressed",
		visibility_function = function (parent)
			return parent._using_cursor_navigation and parent:_cb_favorite_legend_visibility(true)
		end,
		suffix_function = format_favorites
	},
	{
		input_action = "secondary_action_pressed",
		display_name = "loc_achievements_view_button_hint_unfavorite_achievement",
		on_pressed_callback = "_on_favorite_pressed",
		visibility_function = function (parent)
			return parent._using_cursor_navigation and parent:_cb_favorite_legend_visibility(false)
		end,
		suffix_function = format_favorites
	},
	{
		input_action = "hotkey_menu_special_1",
		display_name = "",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_toggle_penance_appearance",
		visibility_function = function (parent, id)
			local display_name = parent._use_large_penance_entries and "loc_penance_menu_input_desc_show_grid" or "loc_penance_menu_input_desc_show_list"

			parent._input_legend_element:set_display_name(id, display_name)

			return parent._selected_top_option_key == "browser" and not parent._wintracks_focused and parent._enter_animation_complete
		end
	},
	{
		input_action = "cycle_list_primary",
		display_name = "",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_switch_focus",
		visibility_function = function (parent, id)
			local display_name = parent._wintracks_focused and "loc_penance_menu_input_desc_focus_penances" or "loc_penance_menu_input_desc_focus_track"

			parent._input_legend_element:set_display_name(id, display_name)

			return not parent._using_cursor_navigation and parent._wintrack_element and parent._enter_animation_complete
		end
	}
}
local bottom_divider_passes = {
	{
		value_id = "candles_3",
		style_id = "candles_3",
		pass_type = "texture",
		value = "content/ui/materials/effects/achievements/panel_main_lower_frame_candles_left",
		style = {
			vertical_alignment = "bottom",
			scale_to_material = true,
			horizontal_alignment = "left",
			size = {
				100,
				100
			},
			offset = {
				-12,
				-4,
				1
			}
		}
	},
	{
		value_id = "candles_4",
		style_id = "candles_4",
		pass_type = "texture",
		value = "content/ui/materials/effects/achievements/panel_main_lower_frame_candles_right",
		style = {
			vertical_alignment = "bottom",
			scale_to_material = true,
			horizontal_alignment = "right",
			size = {
				100,
				100
			},
			offset = {
				8,
				0,
				1
			}
		}
	}
}

return {
	animations = animations,
	legend_inputs = legend_inputs,
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	grid_blueprints = PenanceBlueprints,
	bottom_divider_passes = bottom_divider_passes
}
