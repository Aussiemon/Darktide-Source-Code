-- chunkname: @scripts/ui/views/mission_board_view_pj/mission_board_view_definitions.lua

local MissionBoardViewStyles = require("scripts/ui/views/mission_board_view_pj/mission_board_view_styles")
local Styles = MissionBoardViewStyles
local MissionBoardViewSettings = require("scripts/ui/views/mission_board_view_pj/mission_board_view_settings")
local Settings = MissionBoardViewSettings
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ColorUtilities = require("scripts/utilities/ui/colors")
local StepperPassTemplates = require("scripts/ui/pass_templates/stepper_pass_templates")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local MissionBoardViewDefinitions = {}
local Dimensions = Settings.dimensions
local top_buffer = Dimensions.top_buffer
local side_buffer = Dimensions.side_buffer
local widget_buffer = Dimensions.widget_buffer
local details_width = Dimensions.details_width
local sidebar_buffer = Dimensions.sidebar_buffer
local difficulty_selector_height = Dimensions.difficulty_selector_height
local mission_area_width = 1920 - 2 * side_buffer - details_width - widget_buffer
local mission_area_height = 1080 - 2 * top_buffer - widget_buffer

MissionBoardViewDefinitions.scenegraph_definition = {
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
	mission_area = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			mission_area_width,
			mission_area_height
		},
		position = {
			side_buffer + 100,
			top_buffer,
			0
		}
	},
	page_selection_area = {
		vertical_alignment = "top",
		parent = "mission_area",
		horizontal_alignment = "center",
		size = {
			mission_area_width,
			difficulty_selector_height
		},
		position = {
			0,
			0,
			0
		}
	},
	page_selection_pivot = {
		vertical_alignment = "top",
		parent = "page_selection_area",
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
	gamepad_cursor_pivot = {
		vertical_alignment = "top",
		parent = "mission_area",
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
	corner_top_left = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			172,
			230
		},
		position = {
			0,
			0,
			0
		}
	},
	corner_top_right = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			172,
			230
		},
		position = {
			0,
			0,
			0
		}
	},
	corner_bottom_left = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			220,
			268
		},
		position = {
			0,
			0,
			63
		}
	},
	corner_bottom_right = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			220,
			268
		},
		position = {
			0,
			0,
			63
		}
	},
	sidebar = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			details_width,
			mission_area_height - 200
		},
		position = {
			-side_buffer,
			top_buffer,
			0
		}
	},
	sidebar_content = {
		vertical_alignment = "top",
		parent = "sidebar",
		horizontal_alignment = "center",
		size = {
			details_width - 2 * sidebar_buffer,
			mission_area_height - 200
		},
		position = {
			0,
			0,
			2
		}
	},
	mission_area_info = {
		vertical_alignment = "top",
		parent = "sidebar_content",
		horizontal_alignment = "center",
		size = {
			details_width,
			360
		},
		position = {
			0,
			0,
			0
		}
	},
	mission_area_timer = {
		vertical_alignment = "top",
		parent = "mission_area_info",
		horizontal_alignment = "center",
		size = {
			details_width,
			20
		},
		position = {
			0,
			92,
			10
		}
	},
	mission_area_circumstance = {
		vertical_alignment = "bottom",
		parent = "mission_area_info",
		horizontal_alignment = "center",
		size = {
			details_width - 2,
			100
		},
		position = {
			0,
			-2,
			20
		}
	},
	mission_objective_info = {
		vertical_alignment = "bottom",
		parent = "mission_area_info",
		horizontal_alignment = "center",
		size = {
			details_width,
			250
		},
		position = {
			0,
			275,
			2
		}
	},
	mission_objectives_panel = {
		vertical_alignment = "top",
		parent = "mission_objective_info",
		horizontal_alignment = "center",
		size = {
			details_width,
			80
		},
		position = {
			0,
			0,
			1
		}
	},
	mission_rewards_panel = {
		vertical_alignment = "bottom",
		parent = "mission_objective_info",
		horizontal_alignment = "center",
		size = {
			details_width,
			Dimensions.rewards_height
		},
		position = {
			0,
			0,
			2
		}
	},
	info_box = {
		vertical_alignment = "bottom",
		parent = "sidebar_content",
		horizontal_alignment = "center",
		size = {
			380,
			60
		},
		position = {
			0,
			60 + Dimensions.sidebar_buffer + 76 + 10 + 60,
			0
		}
	},
	play_button = {
		vertical_alignment = "bottom",
		parent = "sidebar_content",
		horizontal_alignment = "center",
		size = Dimensions.play_button,
		position = {
			0,
			200,
			100
		}
	},
	difficulty_stepper = {
		vertical_alignment = "top",
		parent = "play_button",
		horizontal_alignment = "center",
		size = {
			Dimensions.difficulty_stepper_width,
			94
		},
		position = {
			0,
			-130,
			100
		}
	},
	difficulty_stepper_tooltip = {
		vertical_alignment = "top",
		parent = "difficulty_stepper",
		horizontal_alignment = "center",
		size = Dimensions.threat_tooltip_size,
		position = {
			0,
			-100,
			-10
		}
	},
	difficulty_stepper_indicators = {
		vertical_alignment = "top",
		parent = "difficulty_stepper",
		horizontal_alignment = "center",
		size = {
			Dimensions.difficulty_stepper_width - 56,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	difficulty_progress_bar = {
		vertical_alignment = "bottom",
		parent = "difficulty_stepper",
		horizontal_alignment = "center",
		size = Dimensions.threat_level_progress_bar_size,
		position = {
			0,
			-10,
			1
		}
	}
}

local widget_definitions = {}

MissionBoardViewDefinitions.widget_definitions = widget_definitions
widget_definitions.loading = UIWidget.create_definition({
	{
		pass_type = "rect",
		style = {
			color = Color.black(127.5, true)
		}
	},
	{
		value = "content/ui/materials/loading/loading_icon",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				256,
				256
			},
			offset = {
				0,
				0,
				1
			}
		}
	}
}, "screen", {
	visible = true
})
widget_definitions.gamepad_cursor = UIWidget.create_definition({
	{
		value = "content/ui/materials/frames/frame_glow_01",
		style_id = "glow",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			scale_to_material = true,
			color = Styles.colors.default.cursor,
			offset = {
				0,
				0,
				5
			},
			size_addition = {
				24,
				24
			}
		}
	},
	{
		style_id = "rect",
		pass_type = "rect",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			scale_to_material = true,
			color = Styles.colors.default.cursor,
			offset = {
				0,
				0,
				1
			}
		}
	},
	{
		value = "content/ui/materials/icons/generic/light_arrow",
		style_id = "arrow",
		pass_type = "rotated_texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			angle = -math.pi / 2,
			color = Styles.colors.default.cursor,
			offset = {
				0,
				0,
				2
			},
			size = {
				16,
				28
			}
		}
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "frame",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			color = Styles.colors.default.cursor,
			offset = {
				0,
				0,
				3
			},
			size_addition = {
				0,
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
			scale_to_material = true,
			horizontal_alignment = "center",
			color = Styles.colors.default.cursor,
			offset = {
				0,
				0,
				4
			},
			size_addition = {
				15,
				15
			}
		}
	}
}, "gamepad_cursor")
widget_definitions.play_button_legend = UIWidget.create_definition({
	{
		value_id = "text",
		style_id = "text",
		pass_type = "text",
		value = "",
		style = {
			horizontal_alignment = "center"
		}
	}
}, "play_button", nil, nil, {
	text = {
		font_type = "proxima_nova_medium",
		font_size = 16,
		text_vertical_alignment = "center",
		text_horizontal_alignment = "center",
		text_color = Styles.colors.default.text_body,
		offset = {
			0,
			58,
			2
		}
	}
})
widget_definitions.difficulty_stepper = UIWidget.create_definition(StepperPassTemplates.mission_board_stepper, "difficulty_stepper")

MissionBoardViewDefinitions.create_objectives_panel_widget = function (scenegraph_id, title, sub_title, icon, size)
	return UIWidget.create_definition({
		{
			style_id = "frame",
			pass_type = "texture",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = Styles.objectives_panel.frame,
			visibility_function = function (content, style)
				return not content.hotspot.is_selected
			end
		},
		{
			value_id = "objectives_panel_title",
			style_id = "objectives_panel_title",
			pass_type = "text",
			value = title,
			style = Styles.objectives_panel.title
		},
		{
			value_id = "objectives_panel_sub_title",
			style_id = "objectives_panel_sub_title",
			pass_type = "text",
			value = sub_title,
			style = Styles.objectives_panel.sub_title
		},
		{
			value_id = "icon",
			style_id = "icon",
			pass_type = "texture",
			value = icon,
			style = Styles.objectives_panel.icon
		},
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot",
			style = Styles.objectives_panel.hotspot
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/gradients/gradient_horizontal",
			style = Styles.objectives_panel.background_gradient,
			change_function = function (content, style)
				if not content.hotspot.is_selected then
					style.color[1] = 100 + 65 * content.hotspot.anim_hover_progress
				else
					style.color[1] = 100 * (1 - content.hotspot.anim_select_progress)
				end
			end
		}
	}, scenegraph_id, nil, size, {
		objectives_panel_title = {
			text_color = Styles.colors.default.terminal_header_text
		}
	})
end

MissionBoardViewDefinitions.create_reward_widget = function (scenegraph_id, amount, icon, size)
	return UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "frame",
			pass_type = "texture",
			style = Styles.mission_objective_info.reward.frame
		},
		{
			value_id = "amount",
			style_id = "amount",
			pass_type = "text",
			value = amount,
			style = Styles.mission_objective_info.reward.amount
		},
		{
			value_id = "icon",
			style_id = "icon",
			pass_type = "texture",
			value = icon,
			style = Styles.mission_objective_info.reward.icon
		}
	}, scenegraph_id, nil, size)
end

widget_definitions.mission_board_screen_frame = UIWidget.create_definition({
	{
		value = "content/ui/materials/mission_board/mission_board_screen_frame",
		style_id = "screen_frame",
		pass_type = "texture",
		style = Styles.screen_frame
	},
	{
		value = "content/ui/materials/mission_board/mission_board_screen_frame_glow",
		style_id = "screen_frame_glow",
		pass_type = "texture",
		style = Styles.screen_frame_glow
	},
	{
		style_id = "frame_right_rect",
		pass_type = "rect",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			color = {
				145,
				0,
				0,
				0
			},
			size = {
				2500,
				1080
			},
			offset = {
				2500,
				0,
				-1
			}
		}
	},
	{
		style_id = "frame_left_rect",
		pass_type = "rect",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			color = {
				145,
				0,
				0,
				0
			},
			size = {
				2500,
				1080
			},
			offset = {
				-2500,
				0,
				-1
			}
		}
	}
}, "canvas")
widget_definitions.mission_objective_info = UIWidget.create_definition({
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "frame",
		pass_type = "texture",
		style = Styles.mission_objective_info.frame
	},
	{
		style_id = "background",
		pass_type = "rect",
		style = Styles.mission_objective_info.background
	},
	{
		value_id = "objective_description",
		style_id = "objective_description",
		pass_type = "text",
		value = "Objective Description",
		style = Styles.mission_objective_info.objective_description
	},
	{
		style_id = "mission_giver_frame",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = Styles.mission_objective_info.mission_giver_frame,
		visibility_function = function (content, style)
			return not content.is_quickplay_mission
		end
	},
	{
		value_id = "mission_giver_name",
		style_id = "mission_giver_name",
		pass_type = "text",
		value = "Mission Giver Name",
		style = Styles.mission_objective_info.mission_giver_name,
		visibility_function = function (content, style)
			return content.has_mission_giver
		end
	},
	{
		value_id = "mission_giver_icon",
		pass_type = "texture",
		style_id = "mission_giver_icon",
		style = Styles.mission_objective_info.mission_giver_icon,
		visibility_function = function (content, style)
			return content.has_mission_giver
		end
	}
}, "mission_objective_info")
widget_definitions.mission_area_info = UIWidget.create_definition({
	{
		value_id = "image",
		style_id = "image",
		pass_type = "texture",
		value = "content/ui/materials/mission_board/texture_with_grid_effect",
		style = Styles.mission_area_info.image
	},
	{
		value = "content/ui/materials/frames/inner_shadow_medium",
		style_id = "inner_shadow",
		pass_type = "texture",
		style = Styles.mission_area_info.inner_shadow
	},
	{
		value_id = "outer_frame",
		style_id = "outer_frame",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = Styles.mission_area_info.outer_frame
	},
	{
		value_id = "lock_texture",
		style_id = "location_lock",
		pass_type = "texture",
		value = "content/ui/materials/mission_board/mission_locked_icon",
		style = Styles.mission_area_info.lock,
		visibility_function = function (content, style)
			return content.is_locked
		end
	},
	{
		style_id = "title_background",
		pass_type = "rect",
		style = Styles.mission_area_info.title_background
	},
	{
		value_id = "title_frame",
		style_id = "title_frame",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = Styles.mission_area_info.title_frame
	},
	{
		value_id = "mission_title",
		style_id = "mission_title",
		pass_type = "text",
		value = "Mission Title",
		style = Styles.mission_area_info.mission_title
	},
	{
		value_id = "mission_sub_title",
		style_id = "mission_sub_title",
		pass_type = "text",
		value = "Mission Sub Title",
		style = Styles.mission_area_info.mission_sub_title
	}
}, "mission_area_info")

local function timer_logic(pass, ui_renderer, logic_style, content, position, size)
	local t0, t1 = content.start_game_time, content.expiry_game_time

	if t0 and t1 then
		local style = logic_style.parent
		local t = math.clamp(Managers.time:time("main"), t0, t1)
		local time_left = t1 - t

		style.timer_bar.material_values.progress = time_left / (t1 - t0)

		if content.timer_text then
			local seconds = time_left % 60
			local minutes = math.floor(time_left / 60)

			content.timer_text = string.format("%02d:%02d", minutes, seconds)
		end
	end
end

local large_mission_vertical_spacing = Dimensions.sidebar_small_buffer - 8

widget_definitions.large_timer_bar = UIWidget.create_definition({
	{
		pass_type = "logic",
		value = timer_logic
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "timer_bar_frame",
		pass_type = "texture",
		style = Styles.mission_area_info.timer.timer_bar_frame
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "timer_frame",
		pass_type = "texture",
		style = Styles.mission_area_info.timer.timer_frame
	},
	{
		value = "content/ui/materials/mission_board/timer",
		style_id = "timer_bar",
		pass_type = "texture",
		style = Styles.mission_area_info.timer.timer_bar
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "timer_text_frame",
		pass_type = "texture",
		style = Styles.mission_area_info.timer.timer_text_frame
	},
	{
		style_id = "timer_icon",
		pass_type = "texture",
		value = "content/ui/materials/icons/generic/hourglass",
		style = Styles.mission_area_info.timer.timer_icon,
		visibility_function = function (content, style)
			return not content.is_quickplay
		end
	},
	{
		value_id = "timer_text",
		style_id = "timer_text",
		pass_type = "text",
		value = "00:00",
		style = Styles.mission_area_info.timer.timer_text,
		visibility_function = function (content, style)
			return not content.is_quickplay
		end
	},
	{
		style_id = "infinite_symbol",
		pass_type = "texture",
		value = "content/ui/materials/symbols/infinite",
		style = Styles.mission_area_info.timer.infinite_symbol,
		visibility_function = function (content, style)
			return content.is_quickplay
		end
	}
}, "mission_area_timer")
widget_definitions.circumstance_details = UIWidget.create_definition({
	{
		style_id = "circumstance_background",
		pass_type = "rect",
		style = Styles.mission_area_info.circumstance.background
	},
	{
		value_id = "circumstance_icon",
		style_id = "circumstance_icon",
		pass_type = "texture",
		value = "content/ui/materials/icons/circumstances/assault_01",
		style = Styles.mission_area_info.circumstance.icon
	},
	{
		value_id = "story_circumstance_icon",
		style_id = "story_circumstance_icon",
		pass_type = "texture",
		value = "content/ui/materials/icons/mission_types_pj/mission_type_story",
		style = Styles.mission_area_info.circumstance.story_icon
	},
	{
		value_id = "circumstance_title",
		style_id = "circumstance_title",
		pass_type = "text",
		value = "Circumstance Title",
		style = Styles.mission_area_info.circumstance.circumstance_title
	},
	{
		value_id = "circumstance_description",
		style_id = "circumstance_description",
		pass_type = "text",
		value = "Circumstance Description",
		style = Styles.mission_area_info.circumstance.circumstance_description
	},
	{
		style_id = "circumstance_rect_detail",
		value_id = "circumstance_rect_detail",
		pass_type = "rect",
		style = Styles.mission_area_info.circumstance.rect_detail
	}
}, "mission_area_circumstance")

local function _progress_bar_change_function(content, style, animations, dt)
	local color = style.color
	local from_color = style.color
	local to_color = content.target_color

	if from_color and to_color then
		ColorUtilities.color_lerp(from_color, to_color, 0.1, color, false)
	end
end

widget_definitions.difficulty_progress_bar = UIWidget.create_definition({
	{
		style_id = "difficulty_progress_frame",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_tile_2px",
		value_id = "difficulty_progress_frame",
		style = Styles.difficulty_progress_bar.frame,
		change_function = _progress_bar_change_function,
		visibility_function = function (content, style)
			return content.progress ~= 1
		end
	},
	{
		pass_type = "rect",
		style_id = "progress_bar",
		style = Styles.difficulty_progress_bar.progress_bar,
		change_function = function (content, style, animations, dt)
			local progress = content.progress or 0.68

			style.size[1] = style.default_size[1] * progress

			_progress_bar_change_function(content, style, animations, dt)
		end,
		visibility_function = function (content, style)
			return content.progress ~= 1
		end
	}
}, "difficulty_progress_bar")

local play_button_content_overrides = {
	gamepad_action = "confirm_pressed"
}
local play_button_style_overrides = {
	text = {
		line_spacing = 0.7
	}
}

widget_definitions.play_button = UIWidget.create_definition({
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		style = Styles.play_button.hotspot
	},
	{
		style_id = "play_button_default",
		pass_type = "texture",
		value = "content/ui/materials/buttons/mb_play_button",
		style = Styles.play_button.default,
		visibility_function = function (content, style)
			return not content.hotspot.disabled
		end
	},
	{
		pass_type = "texture",
		style_id = "play_button_hover",
		value = "content/ui/materials/buttons/mb_play_button_selected",
		style = Styles.play_button.hover,
		change_function = function (content, style, animations, dt)
			local hotspot_data = content.hotspot

			style.color[1] = 255 * hotspot_data.anim_hover_progress
		end,
		visibility_function = function (content, style)
			return not content.hotspot.disabled
		end
	},
	{
		pass_type = "text",
		style_id = "default_text",
		value = Utf8.upper(Localize("loc_mission_board_view_accept_mission")),
		style = Styles.play_button.default_text,
		visibility_function = function (content, style)
			return not content.hotspot.disabled
		end,
		change_function = function (content, style, animations, dt)
			local hotspot_data = content.hotspot

			style.font_size = 28 + 4 * hotspot_data.anim_hover_progress
		end
	},
	{
		Styles.play_button.disabled,
		value = "content/ui/materials/buttons/mb_play_button_disabled",
		style_id = "play_button_disable",
		pass_type = "texture",
		visibility_function = function (content, style)
			return content.hotspot.disabled
		end
	},
	{
		value_id = "disabled_text",
		style_id = "disabled_text",
		pass_type = "text",
		value = "n/a",
		style = Styles.play_button.disabled_text,
		visibility_function = function (content, style)
			return content.hotspot.disabled
		end
	}
}, "play_button", play_button_content_overrides, nil, play_button_style_overrides)

local animations = {}

MissionBoardViewDefinitions.animations = animations
animations.mission_enter = {
	{
		name = "setup",
		end_time = 0.05,
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, mission_board_view)
			widget.visible = true

			local style = widget.style

			for _, pass_style in pairs(style) do
				pass_style._visible = pass_style.visible
				pass_style.visible = false
			end

			style.location_rect.visible = true
			style.location_frame.visible = true
			style.location_corner.visible = true

			local full_size = widget.content.size
			local size = {
				full_size[1] / 8,
				full_size[2] / 8
			}

			style.location_rect.size = size
			style.location_frame.size = size
			style.location_corner.size = size

			mission_board_view:_play_sound(UISoundEvents.mission_board_show_icon)
		end
	},
	{
		name = "grow_height",
		end_time = 0.15,
		start_time = 0.05,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, mission_board_view)
			local full_size = widget.content.size

			widget.style.location_rect.size[2] = full_size[2] * (math.ease_in_quad(progress) * 7 / 8 + 0.125)
		end
	},
	{
		name = "grow_width",
		end_time = 0.25,
		start_time = 0.15,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, mission_board_view)
			local full_size = widget.content.size

			widget.style.location_rect.size[1] = full_size[1] * (math.ease_in_quad(progress) * 7 / 8 + 0.125)
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widget, mission_board_view)
			widget.style.location_rect.visible = false
			widget.style.location_image.visible = true
		end
	},
	{
		name = "finish",
		end_time = 0.3,
		start_time = 0.25,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widget, mission_board_view)
			local style = widget.style

			for _, pass_style in pairs(style) do
				pass_style.visible = pass_style._visible
				pass_style._visible = nil
			end

			style.location_rect.visible = false
			style.location_frame.size = nil
			style.location_corner.size = nil
			widget.content.enter_anim_id = nil
		end
	}
}
animations.mission_exit = {
	{
		name = "exit",
		end_time = 0.3,
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, mission_board_view)
			local style = widget.style

			for _, pass_style in pairs(style) do
				pass_style.visible = false
			end

			local full_size = widget.content.size
			local size = {
				full_size[1],
				full_size[2]
			}

			style.location_rect.visible = true
			style.location_image.visible = true
			style.location_frame.visible = true
			style.location_corner.visible = true
			style.location_rect.size = size
			style.location_image.size = size
			style.location_frame.size = size
			style.location_corner.size = size
			style.location_rect.color = {
				0,
				255,
				255,
				255
			}

			mission_board_view:_play_sound(UISoundEvents.mission_board_hide_icon)
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, mission_board_view)
			local style = widget.style
			local growing, shrinking = math.ease_in_quad(progress), 1 - math.ease_out_quad(progress)

			style.location_rect.color[1] = 255 * shrinking
			style.location_image.color[1] = 255 * shrinking
			style.location_frame.color[1] = 255 * shrinking
			style.location_corner.color[1] = 255 * shrinking

			local full_size = widget.content.size
			local size = style.location_rect.size

			size[2] = full_size[2] * shrinking
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widget, mission_board_view)
			mission_board_view:_remove_mission_widget(widget)
		end
	}
}
MissionBoardViewDefinitions.legend_inputs = {
	{
		on_pressed_callback = "_on_back_pressed",
		input_action = "back",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	},
	{
		input_action = "hotkey_menu_special_2",
		display_name = "loc_mission_board_switch_tab",
		alignment = "right_alignment",
		on_pressed_callback = "_set_next_sidebar_tab",
		visibility_function = function (parent)
			return parent:_has_sidebar_tabs()
		end
	},
	{
		input_action = "hotkey_menu_special_1",
		display_name = "loc_mission_board_view_options",
		alignment = "right_alignment",
		on_pressed_callback = "_callback_open_options",
		visibility_function = function (parent, id)
			local mission_board_logic = parent._mission_board_logic

			return mission_board_logic._regions_latency and not parent._mission_board_options
		end
	},
	{
		on_pressed_callback = "_on_group_finder_pressed",
		input_action = "mission_board_group_finder_open",
		display_name = "loc_group_finder_menu_title",
		alignment = "right_alignment"
	}
}

return settings("MissionBoardViewDefinitions", MissionBoardViewDefinitions)
