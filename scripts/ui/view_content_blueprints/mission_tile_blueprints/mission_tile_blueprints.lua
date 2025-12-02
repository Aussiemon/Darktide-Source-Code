-- chunkname: @scripts/ui/view_content_blueprints/mission_tile_blueprints/mission_tile_blueprints.lua

local Styles = require("scripts/ui/views/mission_board_view/mission_board_view_styles")
local Settings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local MissionTypes = require("scripts/settings/mission/mission_types")
local Dimensions = Settings.dimensions
local ColorUtilities = require("scripts/utilities/ui/colors")
local Danger = require("scripts/utilities/danger")
local Text = require("scripts/utilities/ui/text")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local Blueprints = {}
local HOVERED_SIZE_MULTIPLIER = 0.1
local SELECTED_SIZE_MULTIPLIER = 0.2
local LARGE_HOVERED_SIZE_MULTIPLIER = 0.05
local LARGE_SELECTED_SIZE_MULTIPLIER = 0.1
local DETAIL_FRAME_SIZE_MULTYPLIER_BY_CATEGORY = {
	common = 1,
	default = 1,
	event = 1.25,
	maelstrom = 1.25,
	story = 1.15,
}
local DETAIL_FRAME_Y_OFFSET_BY_CATEGORY = {
	common = -6,
	default = 0,
	event = 0,
	maelstrom = -6,
	story = -6,
}
local DETAIL_FRAME_SIZE_ADDITION_BY_CATEGORY = {
	common = 1.6,
	default = 1.25,
	event = 1.85,
	maelstrom = 1.85,
	story = 1.85,
	story_no_bg = 1.25,
}

local function _adjust_color(color, k)
	if not color then
		return {
			255,
			255,
			255,
			255,
		}
	end

	return {
		color[1],
		math.clamp(color[2] * k, 0, 255),
		math.clamp(color[3] * k, 0, 255),
		math.clamp(color[4] * k, 0, 255),
	}
end

local _default_text_width = Dimensions.details_width - 2 * Dimensions.sidebar_buffer
local _internal_text_size = {
	0,
	2000,
}

local function text_size(ui_renderer, text, style, optional_width_delta)
	_internal_text_size[1] = _default_text_width + (optional_width_delta or 0)

	local width, height = Text.text_size(ui_renderer, text, style, _internal_text_size)

	return width, height
end

local math_random = math.random

local function _generate_noise_offset(min, max)
	local noise_x = math_random(min, max)
	local noise_y = math_random(min, max)

	return {
		noise_x,
		noise_y,
	}
end

local function make_blueprint(templates, scenegraph_id, size)
	local definition = UIWidget.create_definition(table.concat_arrays(unpack(table.map(templates, function (v)
		return v.pass_templates
	end))), scenegraph_id, nil, size)

	definition.init = function (self, widget, mission_data, creation_context, optional_scenegraph_id)
		widget.scenegraph_id = optional_scenegraph_id or widget.scenegraph_id

		for _, pass_template in ipairs(templates) do
			pass_template.init(widget, mission_data, creation_context)
		end

		return unpack(widget.content.size)
	end

	return definition
end

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

local function gradient_map_by_category_change_function(content, style, animations, dt)
	local hotspot = content.hotspot
	local is_selected = hotspot.is_selected
	local is_selected_mission_board = hotspot.is_selected_mission_board
	local is_focused = hotspot.is_focused
	local is_locked = content.is_locked
	local was_selected = style.is_selected
	local currently_selected = is_selected or is_focused or is_selected_mission_board

	if was_selected ~= currently_selected then
		style.is_selected = currently_selected

		if currently_selected then
			style.material_values.gradient_map = style.selected_gradient
		elseif is_locked then
			style.material_values.gradient_map = style.disabled_gradient
		else
			style.material_values.gradient_map = style.default_gradient
		end
	end
end

local function _update_size_by_selection_state(content, style, animations, dt)
	local hovered_size_multiplier = content.is_large and LARGE_HOVERED_SIZE_MULTIPLIER or HOVERED_SIZE_MULTIPLIER
	local selected_size_multiplier = content.is_large and LARGE_SELECTED_SIZE_MULTIPLIER or SELECTED_SIZE_MULTIPLIER
	local hotspot = content.hotspot or content.parent.hotspot

	if not hotspot then
		return
	end

	local default_size = style.default_size
	local size = style.size or {}
	local size_x, size_y = 0, 0

	size_x = size_x + default_size[1] * hovered_size_multiplier * (hotspot.anim_hover_progress or 0)
	size_y = size_y + default_size[2] * hovered_size_multiplier * (hotspot.anim_hover_progress or 0)
	size_x = size_x + default_size[1] * selected_size_multiplier * (hotspot.anim_select_progress or 0)
	size_y = size_y + default_size[2] * selected_size_multiplier * (hotspot.anim_select_progress or 0)
	size[1] = default_size[1] + size_x
	size[2] = default_size[2] + size_y
	style.size = size
end

local function _update_offset_by_selection_state(content, style, animations, dt)
	local hovered_size_multiplier = content.is_large and LARGE_HOVERED_SIZE_MULTIPLIER or HOVERED_SIZE_MULTIPLIER
	local selected_size_multiplier = content.is_large and LARGE_SELECTED_SIZE_MULTIPLIER or SELECTED_SIZE_MULTIPLIER
	local hotspot = content.hotspot or content.parent.hotspot
	local default_offset = style.default_offset
	local offset = style.offset or {
		0,
		0,
		1,
	}
	local offset_x, offset_y = 0, 0

	offset_x = offset_x + default_offset[1] * hovered_size_multiplier * (hotspot.anim_hover_progress or 0)
	offset_y = offset_y + default_offset[2] * hovered_size_multiplier * (hotspot.anim_hover_progress or 0)
	offset_x = offset_x + default_offset[1] * selected_size_multiplier * (hotspot.anim_select_progress or 0)
	offset_y = offset_y + default_offset[2] * selected_size_multiplier * (hotspot.anim_select_progress or 0)
	offset[1] = default_offset[1] + offset_x
	offset[2] = default_offset[2] + offset_y
	style.offset = offset
end

local function _center_pass_offset(content, style, animations, dt)
	local hotspot = content.hotspot or content.parent.hotspot
	local default_offset = style.default_offset
	local offset = style.offset or {
		0,
		0,
		1,
	}
	local offset_x, offset_y = 0, 0
	local size = style.size
	local default_size = style.default_size

	offset_x = size[1] - default_size[1]
	offset_y = size[2] - default_size[2]
	offset[1] = default_offset[1] - offset_x * 0.5
	offset[2] = default_offset[2] - offset_y * 0.5
	style.offset = offset
end

local function color_by_selection_state(content, style, animations, dt)
	local hotspot = content.hotspot
	local is_selected = hotspot.is_selected
	local is_selected_mission_board = hotspot.is_selected_mission_board
	local is_focused = hotspot.is_focused
	local is_hover = hotspot.is_hover
	local disabled = hotspot.disabled
	local is_locked = content.is_locked
	local default_color = style.default_color
	local hover_color = style.hover_color
	local selected_color = style.selected_color
	local disabled_color = style.disabled_color
	local color

	if (disabled or is_locked) and disabled_color then
		color = disabled_color
	elseif (is_selected or is_focused or is_selected_mission_board) and selected_color then
		color = selected_color
	elseif is_hover and hover_color then
		color = hover_color
	elseif default_color then
		color = default_color
	end

	if color then
		ColorUtilities.color_copy(color, style.color or style.text_color)
	end
end

do
	local background_hotspot = {
		pass_templates = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				style_id = "hotspot",
				style = {
					anim_hover_speed = 10,
					anim_select_speed = 10,
					horizontal_alignment = "center",
					vertical_alignment = "center",
				},
				content = {
					on_hover_sound = UISoundEvents.mission_board_node_hover,
					on_pressed_sound = UISoundEvents.mission_board_node_pressed,
				},
				change_function = function (content, style, animations, dt)
					_update_size_by_selection_state(content, style, animations, dt)
				end,
			},
			{
				pass_type = "rect",
				style_id = "background",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					offset = {
						0,
						0,
						-1,
					},
					default_offset = {
						0,
						0,
						-1,
					},
				},
				change_function = function (content, style, animations, dt)
					_update_size_by_selection_state(content, style, animations, dt)
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local content, style = widget.content, widget.style
			local category = mission_data and mission_data.category or "common"
			local palette_name = creation_context.palette_name or "default"
			local is_story = creation_context.is_story or category == "story"
			local size_modifier = Settings.mission_widgets_size_multipliers[is_story and "story" or category] or 1
			local is_large = creation_context.is_large
			local tile_size = is_large and Dimensions.large_mission_size or Dimensions.small_mission_size

			style.background.size = {
				tile_size[1] * size_modifier,
				tile_size[2] * size_modifier,
			}
			style.background.default_size = {
				tile_size[1] * size_modifier,
				tile_size[2] * size_modifier,
			}
			style.hotspot.size = {
				tile_size[1] * size_modifier,
				tile_size[2] * size_modifier,
			}
			style.hotspot.default_size = {
				tile_size[1] * size_modifier,
				tile_size[2] * size_modifier,
			}
			style.background.color = Styles.colors[palette_name].main
			content.is_locked = creation_context.is_locked
		end,
	}
	local fluff_frame = {
		pass_templates = {
			{
				pass_type = "texture",
				style_id = "fluff_frame",
				value = "content/ui/materials/fluff/hologram/frames/fluff_frame_01",
				value_id = "fluff_frame",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = {
						80,
						113,
						126,
						103,
					},
					offset = {
						0,
						0,
						-2,
					},
					size_addition = {
						80,
						60,
					},
				},
				change_function = function (content, style, animations, dt)
					_update_size_by_selection_state(content, style, animations, dt)
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local content, style = widget.content, widget.style
			local is_large = creation_context.is_large
			local tile_size = is_large and Dimensions.large_mission_size or Dimensions.small_mission_size
			local category = mission_data and mission_data.category or "common"
			local is_story = creation_context.is_story or category == "story"
			local size_modifier = Settings.mission_widgets_size_multipliers[is_story and "story" or category] or 1

			content.fluff_frame = math.random_array_entry(Settings.fluff_frames)
			style.fluff_frame.size = {
				tile_size[1] * size_modifier,
				tile_size[2] * size_modifier,
			}
			style.fluff_frame.default_size = {
				tile_size[1] * size_modifier,
				tile_size[2] * size_modifier,
			}
			style.fluff_frame.offset = {
				0,
				0,
				-2,
			}
			style.fluff_frame.default_offset = {
				0,
				0,
				-2,
			}
			style.fluff_frame.visible = not content.is_locked
		end,
	}
	local selected_state_details = {
		pass_templates = {
			{
				pass_type = "texture",
				style_id = "frame_glow",
				value = "content/ui/materials/frames/frame_glow_01",
				change_function = color_by_selection_state,
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					visible = false,
					selected_color = {
						255,
						250,
						189,
						73,
					},
					hover_color = {
						255,
						204,
						255,
						204,
					},
					default_color = {
						255,
						0,
						0,
						0,
					},
					offset = {
						0,
						0,
						10,
					},
					size_addition = {
						24,
						24,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "selected_frame_detail",
				value = "content/ui/materials/mission_board/mission_frame_selected_corner",
				style = {
					anim_hover_speed = 2.5,
					anim_select_speed = 2.5,
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					offset = {
						0,
						0,
						-1,
					},
					default_size = Dimensions.small_mission_size,
					material_values = {},
				},
				change_function = function (content, style, animations, dt)
					local hotspot = content.hotspot
					local is_selected = hotspot.is_selected
					local is_selected_mission_board = hotspot.is_selected_mission_board
					local is_focused = hotspot.is_focused

					_update_size_by_selection_state(content, style, animations, dt)

					local was_selected = style.is_selected
					local currently_selected = is_selected or is_focused or is_selected_mission_board

					if was_selected ~= currently_selected then
						style.is_selected = currently_selected

						if currently_selected then
							style.material_values.gradient_map = style.selected_gradient
						else
							style.material_values.gradient_map = style.default_gradient
						end
					end

					style.color[1] = 255 * hotspot.anim_select_progress
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local content, style = widget.content, widget.style
			local is_large = creation_context.is_large
			local tile_size = content.size
			local category = mission_data and mission_data.category or "default"
			local is_story = creation_context.is_story or category == "story"
			local category_data = Styles.gradient_by_category[is_story and "story" or category] or Styles.gradient_by_category.default
			local size_modifier = Settings.mission_widgets_size_multipliers[is_story and "story" or category] or 1
			local slected_frame_size_addition = 0

			if is_story then
				if creation_context.skip_background_frame then
					slected_frame_size_addition = DETAIL_FRAME_SIZE_ADDITION_BY_CATEGORY.story_no_bg
				else
					slected_frame_size_addition = DETAIL_FRAME_SIZE_ADDITION_BY_CATEGORY.story
				end
			else
				slected_frame_size_addition = DETAIL_FRAME_SIZE_ADDITION_BY_CATEGORY[category] or DETAIL_FRAME_SIZE_ADDITION_BY_CATEGORY.default
			end

			local selected_frame_size = {
				tile_size[1] * slected_frame_size_addition,
				tile_size[2] * slected_frame_size_addition,
			}

			style.selected_frame_detail.size = {
				selected_frame_size[1] * size_modifier,
				selected_frame_size[2] * size_modifier,
			}
			style.selected_frame_detail.default_size = {
				selected_frame_size[1] * size_modifier,
				selected_frame_size[2] * size_modifier,
			}
			style.frame_glow.size = {
				tile_size[1] * size_modifier,
				tile_size[2] * size_modifier,
			}
			style.frame_glow.default_size = {
				tile_size[1] * size_modifier,
				tile_size[2] * size_modifier,
			}
			style.selected_frame_detail.offset[2] = DETAIL_FRAME_Y_OFFSET_BY_CATEGORY[is_story and "story" or category] or 0

			if category_data then
				style.selected_frame_detail.default_gradient = category_data.default_gradient
				style.selected_frame_detail.selected_gradient = category_data.selected_gradient
				style.selected_frame_detail.material_values.gradient_map = category_data.selected_gradient
			end
		end,
	}
	local category_background_details = {
		pass_templates = {
			{
				pass_type = "texture",
				style_id = "background_frame",
				value = "content/ui/materials/mission_board/mission_frame_background",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					offset = {
						0,
						0,
						-1,
					},
					color = {
						255,
						255,
						255,
						255,
					},
					material_values = {
						gradient_map = "content/ui/textures/mission_board/gradient_digital_green",
					},
				},
				change_function = function (content, style, animations, dt)
					gradient_map_by_category_change_function(content, style, animations, dt)
					_update_size_by_selection_state(content, style, animations, dt)
				end,
			},
			{
				pass_type = "texture",
				style_id = "selected_frame_glow",
				value = "content/ui/materials/mission_board/mission_frame_selected_glow",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					offset = {
						0,
						0,
						-2,
					},
					color = {
						255,
						255,
						255,
						255,
					},
					material_values = {
						gradient_map = "content/ui/textures/mission_board/gradient_digital_green",
					},
				},
				change_function = function (content, style, animations, dt)
					local hotspot = content.hotspot

					gradient_map_by_category_change_function(content, style, animations, dt)
					_update_size_by_selection_state(content, style, animations, dt)

					style.color[1] = 255 * hotspot.anim_select_progress
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local content, style = widget.content, widget.style
			local category = mission_data and mission_data.category or "common"
			local is_story = creation_context.is_story or category == "story"
			local size_modifier = Settings.mission_widgets_size_multipliers[is_story and "story" or category] or 1
			local is_large = creation_context.is_large
			local tile_size = is_large and Dimensions.large_mission_size or Dimensions.small_mission_size
			local background_tile_size = is_large and {
				600,
				500,
			} or Dimensions.small_mission_background_size
			local selected_frame_multiplier = DETAIL_FRAME_SIZE_MULTYPLIER_BY_CATEGORY[is_story and "story" or category] or DETAIL_FRAME_SIZE_MULTYPLIER_BY_CATEGORY.default
			local selected_frame_size = {
				tile_size[1] + 80 * selected_frame_multiplier,
				tile_size[2] + 80 * selected_frame_multiplier,
			}
			local selected_glow_size_multiplier = category ~= "common" and 0.6 or 0.4
			local selected_glow_size = {
				500 * selected_glow_size_multiplier,
				600 * selected_glow_size_multiplier,
			}

			style.background_frame.size = {
				background_tile_size[1] * size_modifier,
				background_tile_size[2] * size_modifier,
			}
			style.background_frame.default_size = {
				background_tile_size[1] * size_modifier,
				background_tile_size[2] * size_modifier,
			}
			style.selected_frame_glow.size = {
				selected_glow_size[1] * size_modifier,
				selected_glow_size[2] * size_modifier,
			}
			style.selected_frame_glow.default_size = {
				selected_glow_size[1] * size_modifier,
				selected_glow_size[2] * size_modifier,
			}
			content.is_locked = creation_context.is_locked
			content.category = category

			local category_data = Styles.gradient_by_category[is_story and "story" or category] or Styles.gradient_by_category.default

			style.selected_frame_glow.default_gradient = category_data.default_gradient
			style.selected_frame_glow.selected_gradient = category_data.selected_gradient
			style.background_frame.default_gradient = category_data.default_gradient
			style.background_frame.selected_gradient = category_data.selected_gradient
			style.background_frame.disabled_gradient = category_data.disabled_gradient
			style.selected_frame_glow.material_values.gradient_map = category_data.selected_gradient
			style.background_frame.material_values.gradient_map = content.is_locked and category_data.disabled_gradient or category_data.selected_gradient
			style.background_frame.visible = mission_data and mission_data.category ~= "common" or is_story
			style.selected_frame_glow.visible = true
		end,
	}
	local mission_small_timer = {
		pass_templates = {
			{
				pass_type = "logic",
				value = timer_logic,
			},
			{
				pass_type = "rect",
				style_id = "timer_background",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = {
						255,
						0,
						0,
						0,
					},
					size = {
						Dimensions.small_mission_size[1],
						5,
					},
					offset = {
						0,
						-5,
						1,
					},
				},
				change_function = function (content, style, animations, dt)
					_update_size_by_selection_state(content, style, animations, dt)

					local hotspot = content.hotspot
					local offset = style.offset or {
						0,
						0,
						1,
					}
					local offset_y = 0

					offset_y = style.parent_y_size + style.parent_y_size * HOVERED_SIZE_MULTIPLIER * (hotspot.anim_hover_progress or 0)
					offset_y = style.parent_y_size + style.parent_y_size * SELECTED_SIZE_MULTIPLIER * (hotspot.anim_select_progress or 0)
					offset[2] = -style.size[2] - offset_y * 0.5
					style.offset = offset
				end,
			},
			{
				pass_type = "texture",
				style_id = "timer_bar",
				value = "content/ui/materials/mission_board/timer",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					size = {
						Dimensions.small_mission_size[1],
						5,
					},
					offset = {
						0,
						-5,
						1,
					},
					material_values = {
						progress = 0.1,
					},
				},
				change_function = function (content, style, animations, dt)
					color_by_selection_state(content, style, animations, dt)
					_update_size_by_selection_state(content, style, animations, dt)

					local hotspot = content.hotspot
					local offset = style.offset or {
						0,
						0,
						1,
					}
					local offset_y = 0

					offset_y = style.parent_y_size + style.parent_y_size * HOVERED_SIZE_MULTIPLIER * (hotspot.anim_hover_progress or 0)
					offset_y = style.parent_y_size + style.parent_y_size * SELECTED_SIZE_MULTIPLIER * (hotspot.anim_select_progress or 0)
					offset[2] = -style.size[2] - offset_y * 0.5
					style.offset = offset
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local palette_name = creation_context.palette_name or "default"
			local content, style = widget.content, widget.style

			style.timer_bar.color = Styles.colors[palette_name].main
			content.start_game_time = mission_data.start_game_time
			content.expiry_game_time = mission_data.expiry_game_time

			local category = mission_data and mission_data.category or "common"
			local is_story = creation_context.is_story or category == "story"
			local size_multiplier = Settings.mission_widgets_size_multipliers[is_story and "story" or category] or 1
			local default_parent_tile_size = Dimensions.small_mission_size
			local parent_tile_y_size = default_parent_tile_size[2] * size_multiplier
			local timer_bar_offset = {
				style.timer_bar.offset[1],
				style.timer_bar.offset[2],
				style.timer_bar.offset[3],
			}

			style.timer_bar.offset = timer_bar_offset
			style.timer_bar.default_offset = table.shallow_copy(timer_bar_offset)
			style.timer_bar.parent_y_size = parent_tile_y_size
			style.timer_background.parent_y_size = parent_tile_y_size
			style.timer_bar.size = {
				style.timer_bar.size[1] * size_multiplier,
				style.timer_bar.size[2] * size_multiplier,
			}
			style.timer_bar.default_size = table.shallow_copy(style.timer_bar.size)
			style.timer_background.default_size = table.shallow_copy(style.timer_bar.size)

			local mission_type_colors = Styles.colors.color_by_mission_type and Styles.colors.color_by_mission_type[is_story and "story" or category]

			if mission_type_colors then
				style.timer_bar.default_color = content.is_locked and table.shallow_copy(mission_type_colors.disabled_color) or table.shallow_copy(mission_type_colors.default_color)
				style.timer_bar.selected_color = table.shallow_copy(mission_type_colors.selected_color)
				style.timer_bar.hover_color = table.shallow_copy(mission_type_colors.hover_color)
			end

			style.timer_bar.visible = not is_story
		end,
	}
	local large_mission_vertical_spacing = Dimensions.sidebar_small_buffer - 8
	local mission_large_timer = {
		pass_templates = {
			{
				pass_type = "logic",
				value = timer_logic,
			},
			{
				pass_type = "texture",
				style_id = "timer_frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					horizontal_alignment = "right",
					scale_to_material = true,
					vertical_alignment = "top",
					offset = {
						0,
						-(large_mission_vertical_spacing + 13),
						3,
					},
					size = {
						nil,
						6,
					},
					size_addition = {
						-80,
						0,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "timer_bar",
				value = "content/ui/materials/mission_board/timer",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "top",
					offset = {
						0,
						-(large_mission_vertical_spacing + 13),
						3,
					},
					size = {
						nil,
						6,
					},
					size_addition = {
						-80,
						0,
					},
					material_values = {
						progress = 1,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "timer_icon",
				value = "content/ui/materials/icons/generic/hourglass",
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "top",
					size = {
						19,
						19,
					},
					offset = {
						-4,
						-(19 + large_mission_vertical_spacing),
						3,
					},
				},
			},
			{
				pass_type = "text",
				style_id = "timer_text",
				value = "00:00",
				value_id = "timer_text",
				style = {
					drop_shadow = true,
					font_size = 20,
					font_type = "proxima_nova_bold",
					horizontal_alignment = "left",
					text_vertical_alignment = "bottom",
					vertical_alignment = "top",
					size = {
						nil,
						24,
					},
					offset = {
						18,
						-(large_mission_vertical_spacing + 21),
						3,
					},
				},
			},
		},
		init = function (widget, mission_data, creation_context)
			local palette_name = creation_context.palette_name or "default"
			local content, style = widget.content, widget.style

			style.timer_bar.color = Styles.colors[palette_name].main
			style.timer_icon.color = Styles.colors[palette_name].main
			style.timer_text.text_color = Styles.colors[palette_name].main
			style.timer_frame.color = Styles.colors[palette_name].frame
			content.start_game_time = mission_data.start_game_time
			content.expiry_game_time = mission_data.expiry_game_time
		end,
	}
	local mission_location = {
		pass_templates = {
			{
				pass_type = "texture",
				style_id = "location_image",
				value = "content/ui/materials/mission_board/texture_with_grid_effect",
				value_id = "location_image",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					offset = {
						0,
						0,
						1,
					},
					material_values = {
						texture_map = "content/ui/textures/missions/quickplay",
					},
				},
				change_function = function (content, style, animations, dt)
					_update_size_by_selection_state(content, style, animations, dt)

					if content.is_locked then
						style.color[1] = 125
					else
						style.color[1] = 255
					end
				end,
			},
			{
				pass_type = "rect",
				style_id = "location_rect",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					visible = false,
					offset = {
						0,
						0,
						2,
					},
					color = {
						200,
						0,
						0,
						0,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "location_vignette",
				value = "content/ui/materials/frames/inner_shadow_medium",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					color = {
						255,
						0,
						0,
						0,
					},
					offset = {
						0,
						0,
						2,
					},
				},
				change_function = _update_size_by_selection_state,
			},
			{
				pass_type = "texture",
				style_id = "location_frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				change_function = function (content, style, animations, dt)
					color_by_selection_state(content, style, animations, dt)
					_update_size_by_selection_state(content, style, animations, dt)
				end,
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					selected_color = {
						255,
						250,
						189,
						73,
					},
					hover_color = {
						255,
						204,
						255,
						204,
					},
					default_color = {
						255,
						0,
						0,
						0,
					},
					offset = {
						0,
						0,
						3,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "location_corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				change_function = function (content, style, animations, dt)
					color_by_selection_state(content, style, animations, dt)
					_update_size_by_selection_state(content, style, animations, dt)
				end,
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					visible = false,
					selected_color = {
						255,
						250,
						189,
						73,
					},
					hover_color = {
						255,
						204,
						255,
						204,
					},
					default_color = {
						255,
						0,
						0,
						0,
					},
					offset = {
						0,
						0,
						4,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "location_lock",
				value = "content/ui/materials/mission_board/mission_locked_icon",
				value_id = "lock_texture",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					visible = false,
					size = {
						58.8,
						58.8,
					},
					offset = {
						0,
						0,
						5,
					},
					color = {
						125,
						255,
						255,
						255,
					},
				},
				change_function = function (content, style, animations, dt)
					_update_size_by_selection_state(content, style, animations, dt)
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local palette_name = creation_context.palette_name or "default"
			local content, style = widget.content, widget.style
			local category = mission_data and mission_data.category or "common"
			local is_story = creation_context.is_story or category == "story"
			local detail_colors = Styles.colors.color_by_mission_type[is_story and "story" or category] or Styles.colors.color_by_mission_type.default

			style.location_frame.selected_color = table.shallow_copy(detail_colors.selected_color)
			style.location_corner.selected_color = table.shallow_copy(detail_colors.selected_color)
			style.location_frame.hover_color = table.shallow_copy(detail_colors.hover_color)
			style.location_corner.hover_color = table.shallow_copy(detail_colors.hover_color)
			style.location_frame.default_color = content.is_locked and table.shallow_copy(detail_colors.disabled_color) or table.shallow_copy(detail_colors.default_color)
			style.location_corner.default_color = content.is_locked and table.shallow_copy(detail_colors.disabled_color) or table.shallow_copy(detail_colors.default_color)

			local initial_size = creation_context.is_large and Dimensions.large_mission_size or Dimensions.small_mission_size
			local size_modifier = Settings.mission_widgets_size_multipliers[is_story and "story" or category] or 1
			local image_modifier = 1
			local location_lock_size = creation_context.is_large and 75.60000000000001 or 47.040000000000006

			style.location_image.size = {
				initial_size[1] * size_modifier * image_modifier,
				initial_size[2] * size_modifier * image_modifier,
			}
			style.location_image.default_size = {
				initial_size[1] * size_modifier * image_modifier,
				initial_size[2] * size_modifier * image_modifier,
			}
			style.location_rect.size = {
				initial_size[1] * size_modifier,
				initial_size[2] * size_modifier,
			}
			style.location_rect.default_size = {
				initial_size[1] * size_modifier,
				initial_size[2] * size_modifier,
			}
			style.location_vignette.size = {
				initial_size[1] * size_modifier,
				initial_size[2] * size_modifier,
			}
			style.location_vignette.default_size = {
				initial_size[1] * size_modifier,
				initial_size[2] * size_modifier,
			}
			style.location_frame.size = {
				initial_size[1] * size_modifier,
				initial_size[2] * size_modifier,
			}
			style.location_frame.default_size = {
				initial_size[1] * size_modifier,
				initial_size[2] * size_modifier,
			}
			style.location_corner.size = {
				initial_size[1] * size_modifier,
				initial_size[2] * size_modifier,
			}
			style.location_corner.default_size = {
				initial_size[1] * size_modifier,
				initial_size[2] * size_modifier,
			}
			style.location_lock.size = {
				location_lock_size * size_modifier,
				location_lock_size * size_modifier,
			}
			style.location_lock.default_size = {
				location_lock_size * size_modifier,
				location_lock_size * size_modifier,
			}
			style.location_corner.size_addition = category ~= "common" and {
				0,
				0,
			} or {
				8,
				8,
			}
			content.default_size_multiplier = size_modifier

			local texture_map = creation_context.location_texture

			if not texture_map then
				local is_large = creation_context.is_large
				local mission_name = mission_data.map
				local mission_template = MissionTemplates[mission_name]

				texture_map = is_large and mission_template.texture_medium or mission_template.texture_small
			end

			local material_values = style.location_image.material_values

			material_values.texture_map = texture_map

			local is_locked = creation_context.is_locked

			material_values.show_static = is_locked and 1 or 0
			style.location_lock.visible = is_locked
			content.is_large = creation_context.is_large

			local mission_type_colors = Styles.colors.color_by_mission_type[is_story and "story" or category]

			if mission_type_colors then
				style.location_frame.default_color = content.is_locked and table.shallow_copy(mission_type_colors.disabled_color) or table.shallow_copy(mission_type_colors.default_color)
				style.location_frame.selected_color = table.shallow_copy(mission_type_colors.selected_color)
				style.location_frame.hover_color = table.shallow_copy(mission_type_colors.hover_color)
				style.location_corner.default_color = content.is_locked and table.shallow_copy(mission_type_colors.disabled_color) or table.shallow_copy(mission_type_colors.corner_color)
				style.location_corner.selected_color = table.shallow_copy(mission_type_colors.selected_color)
				style.location_corner.hover_color = table.shallow_copy(mission_type_colors.hover_color)
			end
		end,
	}
	local mission_category = {
		pass_templates = {
			{
				pass_type = "texture",
				style_id = "mission_type_frame",
				value = "content/ui/materials/mission_board/mission_type_frame",
				value_id = "mission_type_frame",
				style = {
					horizontal_alignment = "left",
					scale_to_material = true,
					vertical_alignment = "top",
					visible = false,
					size = {
						48,
						48,
					},
					offset = {
						-44,
						-56,
						6,
					},
					material_values = {
						gradient_map = "content/ui/textures/mission_board/gradient_digital_green",
					},
				},
				change_function = function (content, style, animations, dt)
					gradient_map_by_category_change_function(content, style, animations, dt)
					_update_offset_by_selection_state(content, style, animations, dt)
				end,
			},
			{
				pass_type = "texture",
				style_id = "mission_type_icon",
				value = "content/ui/materials/icons/mission_types_pj/mission_type_01",
				value_id = "mission_type_icon",
				style = {
					horizontal_alignment = "left",
					scale_to_material = true,
					vertical_alignment = "top",
					visible = false,
					size = {
						50,
						50,
					},
					size_addition = {
						0,
						0,
					},
					offset = {
						-45,
						-57,
						7,
					},
					material_values = {
						gradient_map = "content/ui/textures/mission_board/gradient_digital_green",
					},
				},
				change_function = function (content, style, animations, dt)
					gradient_map_by_category_change_function(content, style, animations, dt)
					_update_offset_by_selection_state(content, style, animations, dt)
				end,
			},
			{
				pass_type = "texture",
				style_id = "mission_type_banner",
				value = "content/ui/materials/mission_board/mission_tile_banner",
				style = {
					horizontal_alignment = "left",
					scale_to_material = true,
					vertical_alignment = "top",
					visible = false,
					size = {
						202.5,
						54,
					},
					offset = {
						-44,
						-62,
						10,
					},
					material_values = {
						gradient_map = "content/ui/textures/mission_board/gradient_digital_green",
					},
				},
				change_function = _update_offset_by_selection_state,
			},
			{
				pass_type = "text",
				style_id = "mission_type_banner_text",
				value = "n/a",
				value_id = "mission_type_banner_text",
				style = {
					drop_shadow = true,
					font_size = 18,
					font_type = "kode_mono_bold",
					horizontal_alignment = "left",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "center",
					vertical_alignment = "top",
					visible = false,
					size = {
						202.5,
						54,
					},
					offset = {
						-24,
						-62,
						11,
					},
					text_color = {
						255,
						0,
						0,
						0,
					},
				},
				change_function = _update_offset_by_selection_state,
			},
		},
		init = function (widget, mission_data, creation_context)
			local palette_name = creation_context.palette_name or "default"
			local content, style = widget.content, widget.style
			local mission_name = mission_data.map
			local mission_template = MissionTemplates[mission_name]
			local category = mission_data and mission_data.category or "common"
			local is_story = creation_context.is_story or category == "story"
			local icon_settings = Settings.mission_category_icons.undefined

			if category ~= "maelstrom" then
				icon_settings = Settings.mission_category_icons[is_story and "story" or category] or Settings.mission_category_icons.undefined
			else
				icon_settings = Settings.mission_category_icons[is_story and "story" or category] or Settings.mission_category_icons.undefined
			end

			content.mission_type_icon = icon_settings.mission_board_icon

			local is_locked = creation_context.is_locked
			local category_data = Styles.gradient_by_category[is_story and "story" or category] or Styles.gradient_by_category.default
			local noise_offset = _generate_noise_offset(-6, 6)
			local mission_icon_offset = {
				style.mission_type_icon.offset[1] + noise_offset[1],
				style.mission_type_icon.offset[2] + noise_offset[2],
				style.mission_type_icon.offset[3],
			}

			style.mission_type_icon.offset = mission_icon_offset
			style.mission_type_icon.default_offset = table.shallow_copy(mission_icon_offset)

			local mission_type_frame_offset = {
				style.mission_type_frame.offset[1] + noise_offset[1],
				style.mission_type_frame.offset[2] + noise_offset[2],
				style.mission_type_frame.offset[3],
			}

			style.mission_type_frame.offset = mission_type_frame_offset
			style.mission_type_frame.default_offset = table.shallow_copy(mission_type_frame_offset)

			local mission_type_banner_offset = {
				math.abs(style.mission_type_frame.offset[1]) + style.mission_type_banner.offset[1] + noise_offset[1],
				style.mission_type_banner.offset[2],
				style.mission_type_banner.offset[3],
			}

			style.mission_type_banner.offset = mission_type_banner_offset
			style.mission_type_banner.default_offset = table.shallow_copy(mission_type_banner_offset)

			local mission_type_banner_text_offset = {
				math.abs(style.mission_type_frame.offset[1]) + style.mission_type_banner_text.offset[1] + noise_offset[1],
				style.mission_type_banner_text.offset[2],
				style.mission_type_banner_text.offset[3],
			}

			style.mission_type_banner_text.offset = mission_type_banner_text_offset
			style.mission_type_banner_text.default_offset = table.shallow_copy(mission_type_banner_text_offset)
			style.mission_type_icon.default_gradient = category_data.default_gradient
			style.mission_type_icon.selected_gradient = category_data.selected_gradient
			style.mission_type_icon.disabled_gradient = category_data.disabled_gradient
			style.mission_type_frame.default_gradient = category_data.default_gradient
			style.mission_type_frame.selected_gradient = category_data.selected_gradient
			style.mission_type_frame.disabled_gradient = category_data.disabled_gradient
			style.mission_type_banner.default_gradient = category_data.default_gradient
			style.mission_type_banner.material_values.gradient_map = category_data.default_gradient
			style.mission_type_icon.material_values.gradient_map = is_locked and category_data.disabled_gradient or category_data.default_gradient
			style.mission_type_frame.material_values.gradient_map = is_locked and category_data.disabled_gradient or category_data.default_gradient

			local text_key = icon_settings.name or "n/a"
			local localized_text = Localize(text_key)
			local is_story = creation_context.is_story or category == "story"

			if is_story then
				local display_order = creation_context.display_order or ""

				if display_order and display_order ~= "" then
					local roman_numaral = Text.convert_to_roman_numerals(display_order)

					localized_text = string.format("%s %s", localized_text, roman_numaral)
				end
			end

			local text_width = text_size(creation_context.ui_renderer, localized_text, style.mission_type_banner_text)

			style.mission_type_banner_text.size[1] = text_width + 20 + 6
			style.mission_type_banner.size[1] = text_width + 40 + 6
			content.mission_type_banner_text = localized_text

			if category ~= "common" then
				style.mission_type_frame.visible = true
				style.mission_type_icon.visible = true
				style.mission_type_banner.visible = true
				style.mission_type_banner_text.visible = true
			end
		end,
	}
	local mission_main_objective = {
		pass_templates = {
			{
				pass_type = "texture",
				style_id = "main_objective_frame",
				value = "content/ui/materials/base/ui_gradient_color_base",
				style = {
					horizontal_alignment = "left",
					scale_to_material = true,
					vertical_alignment = "center",
					size = {
						48,
						48,
					},
					offset = {
						-40,
						-18,
						21,
					},
					material_values = {
						gradient_map = "content/ui/textures/mission_board/gradient_digital_green",
						texture_map = "content/ui/textures/mission_board/mission_frame_objective",
					},
				},
				change_function = function (content, style, animations, dt)
					gradient_map_by_category_change_function(content, style, animations, dt)
					_update_offset_by_selection_state(content, style, animations, dt)
				end,
			},
			{
				pass_type = "texture",
				style_id = "main_objective_icon",
				value = "content/ui/materials/icons/mission_types_pj/mission_type_01",
				value_id = "main_objective_icon",
				style = {
					horizontal_alignment = "left",
					scale_to_material = true,
					vertical_alignment = "center",
					size = {
						40,
						40,
					},
					offset = {
						-36,
						-18,
						23,
					},
					material_values = {
						gradient_map = "content/ui/textures/mission_board/gradient_digital_green",
					},
					color = {
						165,
						255,
						255,
						255,
					},
				},
				change_function = function (content, style, animations, dt)
					gradient_map_by_category_change_function(content, style, animations, dt)
					_update_offset_by_selection_state(content, style, animations, dt)
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local palette_name = creation_context.palette_name or "default"
			local content, style = widget.content, widget.style
			local mission_name = mission_data.map
			local mission_template = MissionTemplates[mission_name]
			local mission_type = MissionTypes[mission_template.mission_type]

			content.main_objective_icon = mission_type.mission_board_icon or mission_type.icon

			local noise_offset = _generate_noise_offset(-4, 4)
			local main_objective_frame_offset = {
				style.main_objective_frame.offset[1] + noise_offset[1],
				style.main_objective_frame.offset[2] + noise_offset[2],
				style.main_objective_frame.offset[3],
			}

			style.main_objective_frame.offset = main_objective_frame_offset
			style.main_objective_frame.default_offset = table.shallow_copy(main_objective_frame_offset)

			local main_objective_icon_offset = {
				style.main_objective_icon.offset[1] + noise_offset[1],
				style.main_objective_icon.offset[2] + noise_offset[2],
				style.main_objective_icon.offset[3],
			}

			style.main_objective_icon.offset = main_objective_icon_offset
			style.main_objective_icon.default_offset = table.shallow_copy(main_objective_icon_offset)

			local is_locked = creation_context.is_locked
			local mission_category = mission_data.category
			local is_story = creation_context.is_story or mission_category == "story"
			local category_colors = Styles.colors.color_by_mission_type[is_story and "story" or mission_category] or Styles.colors.color_by_mission_type.default
			local category_data = Styles.gradient_by_category[is_story and "story" or mission_category] or Styles.gradient_by_category.default

			style.main_objective_frame.default_gradient = category_data.default_gradient
			style.main_objective_frame.selected_gradient = category_data.selected_gradient
			style.main_objective_frame.disabled_gradient = category_data.disabled_gradient
			style.main_objective_frame.material_values.gradient_map = is_locked and category_data.disabled_gradient or category_data.default_gradient
			style.main_objective_icon.default_gradient = category_data.default_gradient
			style.main_objective_icon.selected_gradient = category_data.selected_gradient
			style.main_objective_icon.disabled_gradient = category_data.disabled_gradient
			style.main_objective_icon.material_values.gradient_map = is_locked and category_data.disabled_gradient or category_data.default_gradient
		end,
	}
	local mission_side_objective = {
		pass_templates = {
			{
				pass_type = "rect",
				style_id = "side_objective_background",
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "bottom",
					visible = false,
					size = {
						32,
						32,
					},
					offset = {
						-32,
						0,
						6,
					},
				},
				change_function = function (content, style, animations, dt)
					_update_offset_by_selection_state(content, style, animations, dt)
				end,
			},
			{
				pass_type = "texture",
				style_id = "side_objective_frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					horizontal_alignment = "left",
					scale_to_material = true,
					vertical_alignment = "bottom",
					visible = false,
					size = {
						32,
						32,
					},
					offset = {
						-32,
						0,
						7,
					},
				},
				change_function = function (content, style, animations, dt)
					color_by_selection_state(content, style, animations, dt)
					_update_offset_by_selection_state(content, style, animations, dt)
				end,
			},
			{
				pass_type = "texture",
				style_id = "side_objective_icon",
				value = "content/ui/materials/icons/mission_types_pj/mission_type_side",
				value_id = "side_objective_icon",
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "bottom",
					visible = false,
					size = {
						36,
						36,
					},
					size_addition = {
						0,
						0,
					},
					offset = {
						-34,
						2,
						7,
					},
					material_values = {
						gradient_map = "content/ui/textures/mission_board/gradient_digital_green",
					},
				},
				change_function = function (content, style, animations, dt)
					_update_offset_by_selection_state(content, style, animations, dt)
					gradient_map_by_category_change_function(content, style, animations, dt)
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local palette_name = creation_context.palette_name or "default"
			local content, style = widget.content, widget.style
			local mission_category = mission_data and mission_data.category or "common"
			local is_story = creation_context.is_story or mission_category == "story"
			local category_colors = Styles.colors.color_by_mission_type[is_story and "story" or mission_category] or Styles.colors.color_by_mission_type.default

			style.side_objective_background.color = Styles.colors[palette_name].background
			style.side_objective_frame.default_color = category_colors.corner_color
			style.side_objective_frame.hover_color = category_colors.hover_color
			style.side_objective_frame.selected_color = category_colors.selected_color

			local is_locked = creation_context.is_locked
			local noise_offset = _generate_noise_offset(-4, 4)
			local side_objective_background_offset = {
				style.side_objective_background.offset[1] + noise_offset[1],
				style.side_objective_background.offset[2] + noise_offset[2],
				style.side_objective_background.offset[3],
			}

			style.side_objective_background.offset = side_objective_background_offset
			style.side_objective_background.default_offset = table.shallow_copy(side_objective_background_offset)

			local side_objective_frame_offset = {
				style.side_objective_frame.offset[1] + noise_offset[1],
				style.side_objective_frame.offset[2] + noise_offset[2],
				style.side_objective_frame.offset[3],
			}

			style.side_objective_frame.offset = side_objective_frame_offset
			style.side_objective_frame.default_offset = table.shallow_copy(side_objective_frame_offset)

			local side_objective_icon_offset = {
				style.side_objective_icon.offset[1] + noise_offset[1],
				style.side_objective_icon.offset[2] + noise_offset[2],
				style.side_objective_icon.offset[3],
			}

			style.side_objective_icon.offset = side_objective_icon_offset
			style.side_objective_icon.default_offset = table.shallow_copy(side_objective_icon_offset)

			local has_side_objective = mission_data.flags.side and mission_data.side_mission

			if has_side_objective then
				local side_mission_template = MissionObjectiveTemplates.side_mission.objectives[mission_data.side_mission]
				local icon = side_mission_template and side_mission_template.mission_board_icon or side_mission_template.icon

				content.side_objective_icon = mission_data.flags.side and side_mission_template and icon

				local category_data = Styles.gradient_by_category[is_story and "story" or mission_category] or Styles.gradient_by_category.default

				style.side_objective_icon.default_gradient = category_data.default_gradient
				style.side_objective_icon.selected_gradient = category_data.selected_gradient
				style.side_objective_icon.disabled_gradient = category_data.disabled_gradient
				style.side_objective_icon.material_values.gradient_map = is_locked and category_data.disabled_gradient or category_data.default_gradient

				local diff = 18

				style.side_objective_background.offset[2] = style.side_objective_background.offset[2] + diff
				style.side_objective_frame.offset[2] = style.side_objective_frame.offset[2] + diff
				style.side_objective_icon.offset[2] = style.side_objective_icon.offset[2] + diff
				style.side_objective_background.visible = true
				style.side_objective_frame.visible = true
				style.side_objective_icon.visible = true
			end

			content.has_side_objective = has_side_objective
		end,
	}
	local mission_circumstance = {
		pass_templates = {
			{
				pass_type = "texture",
				style_id = "circumstance_icon",
				value = "content/ui/materials/icons/circumstances/assault_01",
				value_id = "circumstance_icon",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "bottom",
					visible = false,
					size = {
						42,
						42,
					},
					size_addition = {
						-4,
						-4,
					},
					offset = {
						24,
						31,
						7,
					},
					material_values = {
						gradient_map = "content/ui/textures/mission_board/gradient_digital_circumnstance_default",
					},
				},
				change_function = function (content, style, animations, dt)
					_update_offset_by_selection_state(content, style, animations, dt)
					gradient_map_by_category_change_function(content, style, animations, dt)
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local palette_name = creation_context.palette_name or "default"
			local content, style = widget.content, widget.style
			local is_locked = creation_context.is_locked

			style.circumstance_icon.color = {
				255,
				255,
				255,
				255,
			}

			local noise_offset = _generate_noise_offset(-6, 6)
			local circumstance_icon_offset = {
				style.circumstance_icon.offset[1] + noise_offset[1],
				style.circumstance_icon.offset[2] + noise_offset[2],
				style.circumstance_icon.offset[3],
			}

			style.circumstance_icon.offset = circumstance_icon_offset
			style.circumstance_icon.default_offset = table.shallow_copy(circumstance_icon_offset)

			local is_large = creation_context.is_large

			if is_large then
				local diff = 18

				style.circumstance_icon.offset[2] = style.circumstance_icon.offset[2] + diff
			end

			local circumstance = mission_data.circumstance
			local has_circumstance = circumstance and circumstance ~= "default"

			has_circumstance = has_circumstance and mission_data.category ~= "story"

			if has_circumstance then
				local circumstance_template = CircumstanceTemplates[circumstance]
				local circumstance_ui_data = circumstance_template and circumstance_template.ui

				if circumstance_ui_data then
					content.circumstance_icon = circumstance_ui_data.mission_board_icon or circumstance_ui_data.icon
					style.circumstance_icon.visible = true
				end

				local category_data = Styles.gradient_by_category.circumstance or Styles.gradient_by_category.default

				style.circumstance_icon.default_gradient = category_data.default_gradient
				style.circumstance_icon.selected_gradient = category_data.selected_gradient
				style.circumstance_icon.disabled_gradient = category_data.disabled_gradient
				style.circumstance_icon.material_values.gradient_map = is_locked and category_data.disabled_gradient or category_data.default_gradient
			end
		end,
	}
	local mission_line = {
		pass_templates = {
			{
				pass_type = "texture",
				style_id = "mission_line",
				value = "content/ui/materials/mission_board/mission_line",
				value_id = "mission_line",
				style = {
					anim_select_speed = 0.5,
					horizontal_alignment = "center",
					vertical_alignment = "bottom",
					default_color = Color.terminal_frame(130, true),
					offset = {
						0,
						0,
						-5,
					},
					size = {
						2,
						300,
					},
					default_size = {
						2,
						300,
					},
				},
				change_function = function (content, style, animations, dt)
					local hotspot = content.hotspot
					local is_selected = hotspot and hotspot.is_selected
					local is_selected_mission_board = hotspot and hotspot.is_selected_mission_board
					local is_focused = hotspot and hotspot.is_focused
					local is_parent_selected = is_selected or is_focused or is_selected_mission_board
					local progress = content.line_progress or 0
					local height = style.default_size[2] or 300
					local line_delay = content.line_delay or 0

					if is_parent_selected then
						line_delay = math.min(line_delay + dt, 1)

						if line_delay >= 1 then
							progress = math.min(progress + dt, 1)
						end

						height = style.default_size[2] * math.easeInCubic(progress)
					else
						line_delay = math.max(line_delay - dt, 0)
						progress = math.max(progress - dt * 5, 0)
						height = style.default_size[2] * progress
					end

					content.line_progress = progress
					content.line_delay = line_delay
					style.size[2] = height
					style.offset[2] = height
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local palette_name = creation_context.palette_name or "default"
			local content, style = widget.content, widget.style
			local slot = content.slot
			local position = slot.position
			local height = slot[3] or 800 - position[2]

			style.mission_line.offset[2] = height
			style.mission_line.size[2] = height
			style.mission_line.default_size[2] = height
		end,
	}
	local mission_completed = {
		pass_templates = {
			{
				pass_type = "texture",
				style_id = "mission_completed_icon_back",
				value = "content/ui/materials/mission_board/difficulty_completed_back",
				value_id = "mission_completed_icon_back",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					visible = false,
					color = Color.white(115, true),
					offset = {
						0,
						-100,
						-14,
					},
					size = {
						161.28000000000003,
						107.52000000000001,
					},
				},
				change_function = function (content, style, animations, dt)
					local hotspot = content.hotspot or content.parent.hotspot

					if not hotspot then
						return
					end

					local default_size = style.default_size
					local size = style.size or {}
					local size_x, size_y = 0, 0

					size_x = size_x + default_size[1] * HOVERED_SIZE_MULTIPLIER * 0.5 * (hotspot.anim_hover_progress or 0)
					size_y = size_y + default_size[2] * HOVERED_SIZE_MULTIPLIER * 0.5 * (hotspot.anim_hover_progress or 0)
					size_x = size_x + default_size[1] * SELECTED_SIZE_MULTIPLIER * 0.5 * (hotspot.anim_select_progress or 0)
					size_y = size_y + default_size[2] * SELECTED_SIZE_MULTIPLIER * 0.5 * (hotspot.anim_select_progress or 0)
					size[1] = default_size[1] + size_x
					size[2] = default_size[2] + size_y
					style.size = size

					local offset = style.offset or {
						0,
						0,
						1,
					}
					local offset_y = 0

					offset_y = style.parent_y_size + style.parent_y_size * HOVERED_SIZE_MULTIPLIER * (hotspot.anim_hover_progress or 0)
					offset_y = style.parent_y_size + style.parent_y_size * SELECTED_SIZE_MULTIPLIER * (hotspot.anim_select_progress or 0)
					offset[2] = -50 + style.size[2] * 0.5 + offset_y * 0.5
					style.offset = offset
				end,
			},
			{
				pass_type = "texture",
				style_id = "mission_completed_icon_front",
				value = "content/ui/materials/mission_board/difficulty_completed_front",
				value_id = "mission_completed_icon_front",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					visible = false,
					color = Color.white(255, true),
					offset = {
						0,
						-100,
						4,
					},
					size = {
						115.2,
						76.80000000000001,
					},
				},
				change_function = function (content, style, animations, dt)
					local hotspot = content.hotspot or content.parent.hotspot

					if not hotspot then
						return
					end

					local default_size = style.default_size
					local size = style.size or {}
					local size_x, size_y = 0, 0

					size_x = size_x + default_size[1] * HOVERED_SIZE_MULTIPLIER * (hotspot.anim_hover_progress or 0)
					size_y = size_y + default_size[2] * HOVERED_SIZE_MULTIPLIER * (hotspot.anim_hover_progress or 0)
					size_x = size_x + default_size[1] * SELECTED_SIZE_MULTIPLIER * (hotspot.anim_select_progress or 0)
					size_y = size_y + default_size[2] * SELECTED_SIZE_MULTIPLIER * (hotspot.anim_select_progress or 0)
					size[1] = default_size[1] + size_x
					size[2] = default_size[2] + size_y
					style.size = size

					local offset = style.offset or {
						0,
						0,
						1,
					}
					local offset_y = 0

					offset_y = style.parent_y_size + style.parent_y_size * HOVERED_SIZE_MULTIPLIER * (hotspot.anim_hover_progress or 0)
					offset_y = style.parent_y_size + style.parent_y_size * SELECTED_SIZE_MULTIPLIER * (hotspot.anim_select_progress or 0)
					offset[2] = -30 + style.size[2] * 0.5 + offset_y * 0.5
					style.offset = offset
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local palette_name = creation_context.palette_name or "default"
			local content, style = widget.content, widget.style
			local mission_name = mission_data.map
			local key = "__m_" .. mission_name .. "_md"
			local completed_danger = Managers.stats:read_user_stat(1, key)
			local mission_danger = Danger.danger_by_mission(mission_data)
			local difficulty = mission_danger and mission_danger.difficulty or math.huge

			if completed_danger and difficulty <= completed_danger then
				style.mission_completed_icon_back.visible = true
				style.mission_completed_icon_front.visible = true
			end

			local category = mission_data and mission_data.category or "common"
			local is_story = creation_context.is_story or category == "story"
			local size_multiplier = Settings.mission_widgets_size_multipliers[is_story and "story" or category] or 1
			local default_parent_tile_size = Dimensions.small_mission_size
			local parent_tile_y_size = default_parent_tile_size[2] * size_multiplier

			style.mission_completed_icon_back.parent_y_size = parent_tile_y_size
			style.mission_completed_icon_front.parent_y_size = parent_tile_y_size
			style.mission_completed_icon_back.size = {
				style.mission_completed_icon_back.size[1] * size_multiplier,
				style.mission_completed_icon_back.size[2] * size_multiplier,
			}
			style.mission_completed_icon_back.default_size = {
				style.mission_completed_icon_back.size[1] * size_multiplier,
				style.mission_completed_icon_back.size[2] * size_multiplier,
			}
			style.mission_completed_icon_front.size = {
				style.mission_completed_icon_front.size[1] * size_multiplier,
				style.mission_completed_icon_front.size[2] * size_multiplier,
			}
			style.mission_completed_icon_front.default_size = {
				style.mission_completed_icon_front.size[1] * size_multiplier,
				style.mission_completed_icon_front.size[2] * size_multiplier,
			}
		end,
	}
	local decorative_eagle = {
		pass_templates = {
			{
				pass_type = "texture",
				style_id = "decorative_eagle",
				value = "content/ui/materials/base/ui_gradient_color_base",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "top",
					size = {
						90,
						30,
					},
					offset = {
						14,
						-2,
						5,
					},
					material_values = {
						gradient_map = "content/ui/textures/mission_board/gradient_digital_green",
						texture_map = "content/ui/textures/mission_board/aquilla_digital",
					},
				},
				change_function = function (content, style, animations, dt)
					gradient_map_by_category_change_function(content, style, animations, dt)

					local hotspot = content.hotspot or content.parent.hotspot
					local default_offset = style.default_offset
					local offset = style.offset or {
						0,
						0,
						1,
					}
					local offset_x, offset_y = 0, 0
					local parent_size = style.parent.background and style.parent.background.size
					local parent_default_size = style.parent.background and style.parent.background.default_size

					if parent_size and parent_default_size then
						offset_x = parent_size[1] - parent_default_size[1]
						offset_y = parent_size[2] - parent_default_size[2]
						offset[1] = default_offset[1] + offset_x * 0.5
						offset[2] = default_offset[2] - offset_y * 0.5
						style.offset = offset
					end
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local palette_name = creation_context.palette_name or "default"
			local content, style = widget.content, widget.style
			local mission_type_colors = Styles.colors.color_by_mission_type.default
			local category_data = Styles.gradient_by_category.default

			style.decorative_eagle.selected_gradient = category_data.selected_gradient
			style.decorative_eagle.default_gradient = category_data.default_gradient
			style.decorative_eagle.disabled_gradient = category_data.disabled_gradient
			style.decorative_eagle.offset = {
				14,
				-2,
				5,
			}
			style.decorative_eagle.default_offset = {
				14,
				-2,
				5,
			}
		end,
	}
	local banner = {
		pass_templates = {
			{
				pass_type = "rect",
				style_id = "banner_background",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "bottom",
					visible = false,
					size = {
						nil,
						36,
					},
					offset = {
						0,
						0,
						2,
					},
				},
				change_function = function (content, style, animations, dt)
					_update_size_by_selection_state(content, style, animations, dt)

					local hotspot = content.hotspot or content.parent.hotspot
					local default_offset = style.default_offset
					local offset = style.offset or {
						0,
						0,
						1,
					}
					local offset_x, offset_y = 0, 0
					local parent_size = style.parent.background and style.parent.background.size
					local parent_default_size = style.parent.background and style.parent.background.default_size

					if parent_size and parent_default_size then
						offset_y = parent_size[2] - parent_default_size[2]
						offset[2] = default_offset[2] + offset_y * 0.5
						style.offset = offset
					end
				end,
			},
			{
				pass_type = "text",
				style_id = "banner_text",
				value = "",
				value_id = "banner_text",
				style = {
					font_size = 14,
					font_type = "kode_mono_bold",
					horizontal_alignment = "center",
					text_horizontal_alignment = "right",
					text_vertical_alignment = "bottom",
					vertical_alignment = "bottom",
					visible = false,
					offset = {
						-10,
						-8,
						5,
					},
					text_color = {
						255,
						167,
						190,
						151,
					},
				},
				change_function = function (content, style, animations, dt)
					local hotspot = content.hotspot or content.parent.hotspot
					local default_offset = style.default_offset
					local offset = style.offset or {
						0,
						0,
						1,
					}
					local offset_x, offset_y = 0, 0
					local parent_size = style.parent.background and style.parent.background.size
					local parent_default_size = style.parent.background and style.parent.background.default_size

					if parent_size and parent_default_size then
						offset_x = parent_size[1] - parent_default_size[1]
						offset_y = parent_size[2] - parent_default_size[2]
						offset[1] = default_offset[1] + offset_x * 0.5
						offset[2] = default_offset[2] + offset_y * 0.5
						style.offset = offset
					end
				end,
			},
			{
				pass_type = "texture",
				style_id = "banner_icon",
				value = "content/ui/materials/icons/mission_types_pj/mission_type_quick",
				style = {
					horizontal_alignment = "left",
					scale_to_material = true,
					vertical_alignment = "bottom",
					visible = false,
					size = {
						32,
						32,
					},
					offset = {
						6,
						-3,
						5,
					},
					material_values = {
						gradient_map = "content/ui/textures/mission_board/gradient_digital_green",
					},
				},
				change_function = function (content, style, animations, dt)
					gradient_map_by_category_change_function(content, style, animations, dt)

					local hotspot = content.hotspot or content.parent.hotspot
					local default_offset = style.default_offset
					local offset = style.offset or {
						0,
						0,
						1,
					}
					local offset_x, offset_y = 0, 0
					local parent_size = style.parent.background and style.parent.background.size
					local parent_default_size = style.parent.background and style.parent.background.default_size

					if parent_size and parent_default_size then
						offset_x = parent_size[1] - parent_default_size[1]
						offset_y = parent_size[2] - parent_default_size[2]
						offset[1] = default_offset[1] - offset_x * 0.5
						offset[2] = default_offset[2] + offset_y * 0.5
						style.offset = offset
					end
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local palette_name = creation_context.palette_name or "default"
			local content, style = widget.content, widget.style
			local banner_text = creation_context.banner_text

			if not banner_text then
				return
			end

			local large_mission_size = Dimensions.large_mission_size

			style.banner_background.visible = true
			style.banner_background.color = Styles.colors.default.background
			style.banner_background.size = {
				large_mission_size[1],
				36,
			}
			style.banner_background.default_size = {
				large_mission_size[1],
				36,
			}
			style.banner_background.offset = {
				0,
				0,
				2,
			}
			style.banner_background.default_offset = {
				0,
				0,
				2,
			}
			style.banner_text.offset = {
				-10,
				-8,
				5,
			}
			style.banner_text.default_offset = {
				-10,
				-8,
				5,
			}
			style.banner_icon.offset = {
				6,
				-3,
				5,
			}
			style.banner_icon.default_offset = {
				6,
				-3,
				5,
			}
			content.banner_text = banner_text
			style.banner_text.visible = true

			local mission_type_colors = Styles.colors.color_by_mission_type.default

			style.banner_text.text_color = creation_context.is_locked and table.shallow_copy(Styles.colors.default.terminal_text_darker) or table.shallow_copy(Styles.colors.default.terminal_text_dark)

			if creation_context.banner_icon then
				local category_data = Styles.gradient_by_category.default

				content.banner_icon = creation_context.banner_icon
				style.banner_icon.selected_gradient = category_data.selected_gradient
				style.banner_icon.default_gradient = category_data.default_gradient
				style.banner_icon.disabled_gradient = category_data.disabled_gradient
				style.banner_icon.visible = true
			end
		end,
	}
	local header_text = {
		pass_templates = {
			{
				pass_type = "text",
				style_id = "header_text",
				value = "",
				value_id = "header_text",
				style = {
					font_size = 14,
					font_type = "kode_mono_medium",
					horizontal_alignment = "center",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "top",
					vertical_alignment = "top",
					visible = false,
					offset = {
						8,
						3,
						5,
					},
				},
				change_function = function (content, style, animations, dt)
					local hotspot = content.hotspot or content.parent.hotspot
					local default_offset = style.default_offset
					local offset = style.offset or {
						0,
						0,
						1,
					}
					local offset_x, offset_y = 0, 0
					local parent_size = style.parent.background and style.parent.background.size
					local parent_default_size = style.parent.background and style.parent.background.default_size

					if parent_size and parent_default_size then
						offset_x = parent_size[1] - parent_default_size[1]
						offset_y = parent_size[2] - parent_default_size[2]
						offset[1] = default_offset[1] - offset_x * 0.5
						offset[2] = default_offset[2] - offset_y * 0.5
						style.offset = offset
					end
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local palette_name = creation_context.palette_name or "default"
			local content, style = widget.content, widget.style
			local header_text = creation_context.header_text

			if not header_text then
				return
			end

			style.header_text.offset = {
				8,
				3,
				5,
			}
			style.header_text.default_offset = {
				8,
				3,
				5,
			}
			content.header_text = header_text

			local mission_type_colors = Styles.colors.color_by_mission_type.default

			style.header_text.text_color = creation_context.is_locked and table.shallow_copy(Styles.colors.default.terminal_text_darker) or table.shallow_copy(Styles.colors.default.terminal_text_dark)
			style.header_text.visible = true
		end,
	}
	local display_order_text = {
		pass_templates = {
			{
				pass_type = "rect",
				style_id = "display_order_background",
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "top",
					offset = {
						0,
						0,
						10,
					},
					default_offset = {
						0,
						0,
						10,
					},
					color = {
						255,
						0,
						0,
						0,
					},
				},
				change_function = function (content, style, animations, dt)
					local hotspot = content.hotspot or content.parent.hotspot
					local default_offset = style.default_offset
					local offset = style.offset or {
						0,
						0,
						1,
					}
					local offset_x, offset_y = 0, 0
					local parent_size = style.parent.background and style.parent.background.size
					local parent_default_size = style.parent.background and style.parent.background.default_size

					if parent_size and parent_default_size then
						offset_x = parent_size[1] - parent_default_size[1]
						offset_y = parent_size[2] - parent_default_size[2]
						offset[1] = default_offset[1] - offset_x * 0.5
						offset[2] = default_offset[2] - offset_y * 0.5
						style.offset = offset
					end

					_update_size_by_selection_state(content, style, animations, dt)
				end,
			},
			{
				pass_type = "text",
				style_id = "display_order_text",
				value = "XXXX",
				value_id = "display_order_text",
				style = {
					font_size = 16,
					font_type = "kode_mono_medium",
					horizontal_alignment = "left",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					vertical_alignment = "top",
					offset = {
						0,
						0,
						12,
					},
					default_offset = {
						0,
						0,
						12,
					},
					text_color = {
						255,
						255,
						255,
						255,
					},
				},
				change_function = function (content, style, animations, dt)
					color_by_selection_state(content, style, animations, dt)

					local hotspot = content.hotspot or content.parent.hotspot
					local default_offset = style.default_offset
					local offset = style.offset or {
						0,
						0,
						1,
					}
					local offset_x, offset_y = 0, 0
					local parent_size = style.parent.background and style.parent.background.size
					local parent_default_size = style.parent.background and style.parent.background.default_size

					if parent_size and parent_default_size then
						offset_x = parent_size[1] - parent_default_size[1]
						offset_y = parent_size[2] - parent_default_size[2]
						offset[1] = default_offset[1] - offset_x * 0.5
						offset[2] = default_offset[2] - offset_y * 0.5
						style.offset = offset
					end

					_update_size_by_selection_state(content, style, animations, dt)
				end,
			},
			{
				pass_type = "texture",
				style_id = "display_order_text_frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					horizontal_alignment = "left",
					scale_to_material = true,
					vertical_alignment = "top",
					offset = {
						0,
						0,
						13,
					},
					default_offset = {
						0,
						0,
						13,
					},
				},
				change_function = function (content, style, animations, dt)
					color_by_selection_state(content, style, animations, dt)

					local hotspot = content.hotspot or content.parent.hotspot
					local default_offset = style.default_offset
					local offset = style.offset or {
						0,
						0,
						1,
					}
					local offset_x, offset_y = 0, 0
					local parent_size = style.parent.background and style.parent.background.size
					local parent_default_size = style.parent.background and style.parent.background.default_size

					if parent_size and parent_default_size then
						offset_x = parent_size[1] - parent_default_size[1]
						offset_y = parent_size[2] - parent_default_size[2]
						offset[1] = default_offset[1] - offset_x * 0.5
						offset[2] = default_offset[2] - offset_y * 0.5
						style.offset = offset
					end

					_update_size_by_selection_state(content, style, animations, dt)
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local content, style = widget.content, widget.style
			local display_order = creation_context.display_order or 0
			local widget_size = widget.size or content.size or {}

			style.display_order_background.size = {
				widget_size[1] - 6,
				24,
			}
			style.display_order_background.default_size = {
				widget_size[1] - 6,
				24,
			}
			style.display_order_background.offset = {
				3,
				-22,
				10,
			}
			style.display_order_background.default_offset = {
				3,
				-22,
				10,
			}
			style.display_order_text.size = {
				widget_size[1] - 6,
				24,
			}
			style.display_order_text.default_size = {
				widget_size[1] - 6,
				24,
			}
			style.display_order_text.offset = {
				3,
				-22,
				12,
			}
			style.display_order_text.default_offset = {
				3,
				-22,
				12,
			}
			style.display_order_text_frame.size = {
				widget_size[1] - 6,
				24,
			}
			style.display_order_text_frame.default_size = {
				widget_size[1] - 6,
				24,
			}
			style.display_order_text_frame.offset = {
				3,
				-22,
				13,
			}
			style.display_order_text_frame.default_offset = {
				3,
				-22,
				13,
			}

			local category = mission_data.category or "default"
			local is_story = creation_context.is_story or category == "story"
			local size_multiplier = Settings.mission_widgets_size_multipliers[is_story and "story" or category] or 1
			local default_parent_tile_size = Dimensions.small_mission_size
			local parent_tile_y_size = default_parent_tile_size[2] * size_multiplier
			local roman_numeral = Text.convert_to_roman_numerals(display_order)

			content.display_order_text = roman_numeral
			content.default_display_order_text = roman_numeral
			style.display_order_background.visible = is_story
			style.display_order_text_frame.visible = is_story
			style.display_order_text.visible = is_story

			local mission_type_colors = Styles.colors.color_by_mission_type[is_story and "story" or category] or Styles.colors.color_by_mission_type.default

			style.display_order_text.text_color = table.shallow_copy(mission_type_colors.default_color)
			style.display_order_text_frame.color = table.shallow_copy(mission_type_colors.default_color)
			style.display_order_text.selected_color = table.shallow_copy(mission_type_colors.selected_color)
			style.display_order_text_frame.selected_color = table.shallow_copy(mission_type_colors.selected_color)
			style.display_order_text.hover_color = table.shallow_copy(mission_type_colors.hover_color)
			style.display_order_text_frame.hover_color = table.shallow_copy(mission_type_colors.hover_color)
			style.display_order_text.default_color = content.is_locked and table.shallow_copy(mission_type_colors.disabled_color) or table.shallow_copy(mission_type_colors.default_color)
			style.display_order_text_frame.default_color = content.is_locked and table.shallow_copy(mission_type_colors.disabled_color) or table.shallow_copy(mission_type_colors.default_color)
		end,
	}
	local highest_difficulty_completed_icon = {
		pass_templates = {},
		init = function (widget, mission_data, creation_context)
			return
		end,
	}
	local tile_button_background_hotspot = {
		pass_templates = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				style_id = "hotspot",
				style = {
					anim_hover_speed = 10,
					anim_select_speed = 10,
					horizontal_alignment = "center",
					vertical_alignment = "center",
				},
				content = {
					on_hover_sound = UISoundEvents.mission_board_node_hover,
					on_pressed_sound = UISoundEvents.mission_board_node_pressed,
				},
			},
			{
				pass_type = "rect",
				style_id = "background",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					offset = {
						0,
						0,
						-1,
					},
					default_offset = {
						0,
						0,
						-1,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "background_frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				value_id = "background_frame",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					offset = {
						0,
						0,
						2,
					},
					default_offset = {
						0,
						0,
						2,
					},
				},
				change_function = function (content, style, animations, dt)
					color_by_selection_state(content, style, animations, dt)
				end,
			},
			{
				pass_type = "texture",
				style_id = "selected_frame_detail",
				value = "content/ui/materials/mission_board/mission_frame_selected_corner",
				style = {
					anim_hover_speed = 2.5,
					anim_select_speed = 2.5,
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					offset = {
						0,
						0,
						-1,
					},
					default_size = Dimensions.small_mission_size,
					material_values = {},
				},
				change_function = function (content, style, animations, dt)
					local hotspot = content.hotspot
					local is_selected = hotspot.is_selected
					local is_selected_mission_board = hotspot.is_selected_mission_board
					local is_focused = hotspot.is_focused

					_update_size_by_selection_state(content, style, animations, dt)

					local was_selected = style.is_selected
					local currently_selected = is_selected or is_focused or is_selected_mission_board

					if was_selected ~= currently_selected then
						style.is_selected = currently_selected

						if currently_selected then
							style.material_values.gradient_map = style.selected_gradient
						else
							style.material_values.gradient_map = style.default_gradient
						end
					end

					style.color[1] = 255 * hotspot.anim_select_progress
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local content, style = widget.content, widget.style
			local category = mission_data and mission_data.category or "common"
			local palette_name = creation_context.palette_name or "default"
			local is_story = creation_context.is_story or category == "story"
			local size_modifier = Settings.mission_widgets_size_multipliers[is_story and "story" or category] or 1
			local is_large = creation_context.is_large
			local tile_size = content.size or Dimensions.static_widget_size

			style.background.size = {
				tile_size[1],
				tile_size[2],
			}
			style.background.default_size = {
				tile_size[1],
				tile_size[2],
			}
			style.hotspot.size = {
				tile_size[1],
				tile_size[2],
			}
			style.hotspot.default_size = {
				tile_size[1],
				tile_size[2],
			}
			style.background_frame.size = {
				tile_size[1],
				tile_size[2],
			}
			style.background_frame.default_size = {
				tile_size[1],
				tile_size[2],
			}

			local mission_type_colors = Styles.colors.color_by_mission_type.default

			style.background_frame.color = table.shallow_copy(mission_type_colors.default_color)
			style.background_frame.default_color = content.is_locked and table.shallow_copy(mission_type_colors.disabled_color) or table.shallow_copy(mission_type_colors.default_color)
			style.background_frame.selected_color = table.shallow_copy(mission_type_colors.selected_color)
			style.background_frame.hover_color = table.shallow_copy(mission_type_colors.hover_color)
			style.background_frame.disabled_color = table.shallow_copy(mission_type_colors.disabled_color)
			style.selected_frame_detail.size = {
				tile_size[1],
				tile_size[2] + 32,
			}
			style.selected_frame_detail.default_size = {
				tile_size[1],
				tile_size[2] + 32,
			}
			style.selected_frame_detail.offset[2] = 0

			local category_data = Styles.gradient_by_category.default

			if category_data then
				style.selected_frame_detail.default_gradient = category_data.default_gradient
				style.selected_frame_detail.selected_gradient = category_data.selected_gradient
				style.selected_frame_detail.material_values.gradient_map = category_data.selected_gradient
			end

			style.background.color = {
				255,
				0,
				0,
				0,
			}
			content.is_locked = creation_context.is_locked
		end,
	}
	local tile_button_icon = {
		pass_templates = {
			{
				pass_type = "texture",
				style_id = "static_button_icon",
				value = "content/ui/materials/base/ui_gradient_color_base",
				value_id = "static_button_icon",
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "center",
					size = {
						60,
						60,
					},
					default_size = {
						60,
						60,
					},
					offset = {
						0,
						0,
						4,
					},
					default_offset = {
						0,
						0,
						4,
					},
					material_values = {
						gradient_map = "content/ui/textures/mission_board/gradient_digital_green",
						texture_map = "content/ui/textures/icons/mission_types_pj/mission_type_quick",
					},
				},
				change_function = function (content, style, animations, dt)
					gradient_map_by_category_change_function(content, style, animations, dt)
				end,
			},
			{
				pass_type = "rotated_texture",
				style_id = "static_button_icon_frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				value_id = "static_button_icon_frame",
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "center",
					angle = math.degrees_to_radians(180),
					size = {
						60,
						60,
					},
					default_size = {
						60,
						60,
					},
					offset = {
						0,
						0,
						5,
					},
					default_offset = {
						0,
						0,
						5,
					},
				},
				change_function = function (content, style, animations, dt)
					color_by_selection_state(content, style, animations, dt)
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local content, style = widget.content, widget.style
			local category = mission_data and mission_data.category or "common"
			local palette_name = creation_context.palette_name or "default"
			local is_story = creation_context.is_story or category == "story"

			style.static_button_icon.material_values.texture_map = creation_context.icon or "content/ui/textures/icons/mission_types_pj/mission_type_quick"
			style.static_button_icon.size = {
				content.size[2],
				content.size[2],
			}
			style.static_button_icon.default_size = {
				content.size[2],
				content.size[2],
			}
			style.static_button_icon_frame.size = {
				content.size[2],
				content.size[2],
			}
			style.static_button_icon_frame.default_size = {
				content.size[2],
				content.size[2],
			}

			local mission_type_colors = Styles.colors.color_by_mission_type.default

			style.static_button_icon_frame.color = table.shallow_copy(mission_type_colors.default_color)
			style.static_button_icon_frame.default_color = content.is_locked and table.shallow_copy(mission_type_colors.disabled_color) or table.shallow_copy(mission_type_colors.default_color)
			style.static_button_icon_frame.selected_color = table.shallow_copy(mission_type_colors.selected_color)
			style.static_button_icon_frame.hover_color = table.shallow_copy(mission_type_colors.hover_color)

			local category_data = Styles.gradient_by_category[is_story and "story" or category] or Styles.gradient_by_category.default

			if category_data then
				style.static_button_icon.selected_gradient = category_data.selected_gradient
				style.static_button_icon.default_gradient = category_data.default_gradient
				style.static_button_icon.disabled_gradient = category_data.disabled_gradient
				style.static_button_icon.material_values.gradient_map = category_data.default_gradient
			end
		end,
	}
	local tile_button_header_text = {
		pass_templates = {
			{
				pass_type = "text",
				style_id = "static_header_text",
				value = "",
				value_id = "static_header_text",
				style = {
					font_size = 16,
					font_type = "kode_mono_bold",
					horizontal_alignment = "left",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "bottom",
					vertical_alignment = "center",
					offset = {
						70,
						-4,
						5,
					},
					text_color = table.shallow_copy(Styles.colors.default.terminal_text_dark),
				},
				change_function = function (content, style, animations, dt)
					color_by_selection_state(content, style, animations, dt)

					local hotspot = content.hotspot or content.parent.hotspot
					local is_hovered = hotspot and hotspot.is_hover
					local is_selected = hotspot and hotspot.is_selected

					style.font_size = 16 + 1 * (hotspot.anim_hover_progress or 0) + 2 * (hotspot.anim_select_progress or 0)
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local content, style = widget.content, widget.style
			local category = mission_data and mission_data.category or "common"
			local palette_name = creation_context.palette_name or "default"
			local is_story = creation_context.is_story or category == "story"
			local header_text = creation_context.header_text

			if not header_text then
				style.static_header_text.visible = false

				return
			end

			style.static_header_text.size = {
				content.size[1] - content.size[2] + 4,
				content.size[2],
			}
			style.static_header_text.offset[1] = content.size[2] + 4
			content.static_header_text = header_text

			local text_color = Styles.colors.default.terminal_text_dark

			style.static_header_text.text_color = table.shallow_copy(text_color)
			style.static_header_text.default_color = content.is_locked and _adjust_color(text_color, 0.5) or table.shallow_copy(text_color)
			style.static_header_text.selected_color = _adjust_color(text_color, 1.35)
			style.static_header_text.hover_color = _adjust_color(text_color, 1.15)
			style.static_header_text.disabled_color = _adjust_color(text_color, 0.5)
		end,
	}
	local tile_button_sub_header_text = {
		pass_templates = {
			{
				pass_type = "text",
				style_id = "static_sub_header_text",
				value = "",
				value_id = "static_sub_header_text",
				style = {
					font_size = 12,
					font_type = "kode_mono_regular",
					horizontal_alignment = "left",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "top",
					vertical_alignment = "center",
					offset = {
						70,
						4,
						5,
					},
					text_color = table.shallow_copy(Styles.colors.color_by_mission_type.default.default_color),
				},
				change_function = function (content, style, animations, dt)
					color_by_selection_state(content, style, animations, dt)

					local hotspot = content.hotspot or content.parent.hotspot
					local is_hovered = hotspot and hotspot.is_hover
					local is_selected = hotspot and hotspot.is_selected

					style.font_size = 12 + 1 * (hotspot.anim_hover_progress or 0) + 2 * (hotspot.anim_select_progress or 0)
				end,
			},
		},
		init = function (widget, mission_data, creation_context)
			local content, style = widget.content, widget.style
			local category = mission_data and mission_data.category or "common"
			local palette_name = creation_context.palette_name or "default"
			local is_story = creation_context.is_story or category == "story"
			local sub_header_text = creation_context.sub_header_text

			if not sub_header_text then
				style.static_sub_header_text.visible = false

				return
			end

			style.static_sub_header_text.size = {
				content.size[1] - content.size[2] + 4,
				content.size[2],
			}
			style.static_sub_header_text.offset[1] = content.size[2] + 4
			content.static_sub_header_text = sub_header_text

			local text_color = table.shallow_copy(Styles.colors.color_by_mission_type.default.default_color)

			style.static_sub_header_text.text_color = table.shallow_copy(text_color)
			style.static_sub_header_text.default_color = content.is_locked and _adjust_color(text_color, 0.5) or table.shallow_copy(text_color)
			style.static_sub_header_text.selected_color = _adjust_color(text_color, 1.35)
			style.static_sub_header_text.hover_color = _adjust_color(text_color, 1.15)
			style.static_sub_header_text.disabled_color = _adjust_color(text_color, 0.5)
		end,
	}

	Blueprints.small_mission_tile_pass_templates = {
		background_hotspot,
		fluff_frame,
		selected_state_details,
		category_background_details,
		mission_small_timer,
		mission_location,
		mission_category,
		mission_main_objective,
		mission_side_objective,
		mission_circumstance,
		mission_line,
		mission_completed,
	}
	Blueprints.replay_mission_tile_pass_templates = {
		background_hotspot,
		selected_state_details,
		mission_location,
		mission_main_objective,
		mission_side_objective,
		mission_circumstance,
		display_order_text,
	}
	Blueprints.replay_mission_upsell_tile_pass_templates = {
		background_hotspot,
		fluff_frame,
		category_background_details,
		selected_state_details,
		mission_location,
	}
	Blueprints.static_mission_pass_templates = {
		background_hotspot,
		fluff_frame,
		selected_state_details,
		mission_location,
		decorative_eagle,
		banner,
		header_text,
	}
	Blueprints.small_static_tile_pass_templates = {
		tile_button_background_hotspot,
		tile_button_icon,
		tile_button_header_text,
		tile_button_sub_header_text,
	}
end

Blueprints.make_blueprint = make_blueprint

return settings("MissionBoardViewBlueprints", Blueprints)
