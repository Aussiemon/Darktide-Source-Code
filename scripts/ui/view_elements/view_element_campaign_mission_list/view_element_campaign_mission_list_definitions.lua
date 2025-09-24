-- chunkname: @scripts/ui/view_elements/view_element_campaign_mission_list/view_element_campaign_mission_list_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local MissionBoardViewSettings = require("scripts/ui/views/mission_board_view_pj/mission_board_view_settings")
local Settings = require("scripts/ui/view_elements/view_element_campaign_mission_list/view_element_campaign_mission_list_settings")
local Styles = require("scripts/ui/view_elements/view_element_campaign_mission_list/view_element_campaign_mission_list_styles")
local UIResolution = require("scripts/managers/ui/ui_resolution")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local InputDevice = require("scripts/managers/input/input_device")
local InputUtils = require("scripts/managers/input/input_utils")
local ColorUtilities = require("scripts/utilities/ui/colors")
local Definitions = {}
local Dimensions = MissionBoardViewSettings.dimensions
local top_buffer = Dimensions.top_buffer
local side_buffer = Dimensions.side_buffer
local mission_area_width = 1120
local mission_area_height = 760
local debrief_settings = Settings.debrief_settings
local debrief_size = debrief_settings.size
local scenegraph_definition = {
	screen = {
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			200,
		},
	},
	canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			0,
		},
	},
	test = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			540,
			200,
		},
		position = {
			50,
			0,
			1,
		},
	},
	list_background = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			mission_area_width,
			mission_area_height,
		},
		position = {
			side_buffer + 60,
			top_buffer + 60,
			0,
		},
	},
	list_mask = {
		horizontal_alignment = "center",
		parent = "list_background",
		vertical_alignment = "center",
		size = {
			mission_area_width,
			mission_area_height,
		},
		position = {
			0,
			0,
			1,
		},
	},
	list_anchor = {
		horizontal_alignment = "left",
		parent = "list_mask",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			100,
			250,
			10,
		},
	},
	campaign_header = {
		horizontal_alignment = "center",
		parent = "list_background",
		vertical_alignment = "top",
		size = {
			mission_area_width,
			50,
		},
		position = {
			0,
			0,
			2,
		},
	},
	top_detail = {
		horizontal_alignment = "center",
		parent = "list_background",
		vertical_alignment = "top",
		size = {
			mission_area_width,
			100,
		},
		position = {
			0,
			-100,
			2,
		},
	},
	bottom_detail = {
		horizontal_alignment = "center",
		parent = "list_background",
		vertical_alignment = "bottom",
		size = {
			mission_area_width,
			38,
		},
		position = {
			0,
			38,
			2,
		},
	},
	scrollbar_horizontal = {
		horizontal_alignment = "center",
		parent = "list_background",
		vertical_alignment = "bottom",
		size = {
			mission_area_width,
			20,
		},
		position = {
			0,
			0,
			10,
		},
	},
	scrollbar_vertical = {
		horizontal_alignment = "right",
		parent = "list_background",
		vertical_alignment = "center",
		size = {
			20,
			mission_area_height,
		},
		position = {
			0,
			0,
			10,
		},
	},
}

local function scrollbar_visibility_function(content)
	if content.parent then
		content = content.parent
	end

	return not content.thumb_disabled
end

local function create_scrollbar_widget(orientation)
	local scenegraph_id = orientation == "horizontal" and "scrollbar_horizontal" or "scrollbar_vertical"
	local scrollbar_height = orientation == "horizontal" and 20 or mission_area_height
	local scrollbar_width = orientation == "horizontal" and mission_area_width or 20
	local thumb_size = {
		0,
		0,
	}
	local tot_size = 4000

	if orientation == "horizontal" then
		thumb_size[1] = scrollbar_width / tot_size * scrollbar_width
		thumb_size[2] = scrollbar_height - 8
	elseif orientation == "vertical" then
		thumb_size[1] = scrollbar_width - 8
		thumb_size[2] = scrollbar_height / tot_size * scrollbar_height
	end

	local thumb_horizontal_alignment = orientation == "horizontal" and "left" or "center"
	local thumb_vertical_alignment = orientation == "horizontal" and "center" or "top"
	local scrollbar_horizontal_offset = 0
	local axis = orientation == "horizontal" and 1 or 2
	local scrollbar_travel = 0

	if orientation == "horizontal" then
		scrollbar_travel = scrollbar_width - thumb_size[1]
	else
		scrollbar_travel = scrollbar_height - thumb_size[2]
	end

	local scrollbar_widget = UIWidget.create_definition({
		{
			content_id = "scrollbar_hotspot",
			pass_type = "hotspot",
			style_id = "scrollbar_hotspot",
			style = {
				vertical_alignment = thumb_vertical_alignment,
				horizontal_alignment = thumb_horizontal_alignment,
				size = thumb_size,
				offset = {
					scrollbar_horizontal_offset,
					0,
					0,
				},
			},
			visibility_function = scrollbar_visibility_function,
		},
		{
			pass_type = "texture",
			style_id = "scrollbar_track",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					scrollbar_width,
					scrollbar_height,
				},
				size_addition = {
					0,
					0,
				},
				offset = {
					scrollbar_horizontal_offset,
					0,
					12,
				},
				color = {
					255,
					255,
					88,
					27,
				},
			},
			visibility_function = scrollbar_visibility_function,
		},
		{
			pass_type = "rect",
			style_id = "thumb",
			style = {
				size = thumb_size,
				size_addition = {
					0,
					0,
				},
				offset = {
					scrollbar_horizontal_offset,
					0,
					11,
				},
				vertical_alignment = thumb_vertical_alignment,
				horizontal_alignment = thumb_horizontal_alignment,
				color = {
					255,
					140.25,
					110.55000000000001,
					68.2,
				},
				default_color = {
					255,
					140.25,
					110.55000000000001,
					68.2,
				},
				hover_color = {
					255,
					255,
					201,
					124,
				},
			},
			visibility_function = scrollbar_visibility_function,
			change_function = function (content, style, animations, dt)
				local is_hover = content.scrollbar_hotspot.is_hover or content.drag_active
				local anim_speed = 5
				local color_change_progress = content.color_change_progress or 0

				if is_hover then
					color_change_progress = math.min(color_change_progress + dt * anim_speed, 1)
				else
					color_change_progress = math.max(color_change_progress - dt * anim_speed, 0)
				end

				content.color_change_progress = color_change_progress

				local default_color = style.default_color
				local hover_color = style.hover_color

				ColorUtilities.color_lerp(default_color, hover_color, color_change_progress, style.color)
			end,
		},
		{
			pass_type = "logic",
			style_id = "bar_logic",
			value = function (pass, renderer, style, content, position, size)
				if InputDevice.gamepad_active then
					return
				end

				local style_parent = style.parent
				local hotspot = content.scrollbar_hotspot
				local on_pressed = hotspot.on_pressed

				if not content.drag_active then
					if on_pressed then
						content.drag_active = true
					else
						return
					end
				end

				local input_service = renderer.input_service
				local input_action = content.input_action or "left_hold"
				local left_hold = input_service and input_service:get(input_action)

				if not left_hold then
					content.drag_active = nil
					content.input_offset = nil

					return
				else
					content.scroll_value = nil
					content.scroll_add = nil
				end

				if content.drag_active then
					local track_axis_offset = style_parent.scrollbar_track.offset[axis]
					local scrollbar_length = style_parent.scrollbar_track.size[axis]
					local hotspot_style = style_parent.scrollbar_hotspot
					local thumb_length = thumb_size[axis]
					local inverse_scale = renderer.inverse_scale
					local base_cursor = input_service:get("cursor")
					local cursor = (IS_XBS or IS_PLAYSTATION) and base_cursor or UIResolution.inverse_scale_vector(base_cursor, inverse_scale)
					local cursor_direction = cursor[axis]
					local input_coordinate = math.clamp(cursor_direction - (position[axis] + track_axis_offset), 0, scrollbar_length)
					local input_offset = content.input_offset

					if not input_offset then
						input_offset = input_coordinate - (hotspot_style.offset[axis] - track_axis_offset)
						content.input_offset = input_offset
					end

					local start_position = 0
					local end_position = scrollbar_length - thumb_length
					local current_position = input_coordinate - input_offset

					current_position = math.clamp(current_position, start_position, end_position)

					local percentage = current_position / end_position

					content.scroll_percentage = percentage
					content.scroll_value = percentage
				end
			end,
		},
		{
			pass_type = "logic",
			style_id = "scroll_wheel_logic",
			value = function (pass, renderer, style, content, position, size)
				if content.drag_active then
					return
				end

				local scroll_length = content.scroll_length or 0

				if scroll_length <= 0 then
					return
				end

				local gamepad_active = InputDevice.gamepad_active
				local dt = renderer.dt
				local input_service = renderer.input_service
				local scroll_action = gamepad_active and "navigate_controller_right" or "scroll_axis"
				local scroll_axis = input_service:get(scroll_action)
				local position = content.scroll_area_position or position
				local size = content.scroll_area_size or size
				local axis = gamepad_active and 1 or 2
				local axis_input = gamepad_active and math.clamp(scroll_axis[axis], -0.1, 0.1) or scroll_axis[axis] * -1
				local scroll_amount = content.scroll_amount or 0.1
				local inverse_scale = renderer.inverse_scale
				local cursor = input_service:get("cursor")
				local cursor_position = UIResolution.inverse_scale_vector(cursor, inverse_scale)
				local is_hover = math.point_is_inside_2d_box(cursor_position, position, size)

				if is_hover then
					local a = 1
				end

				if axis_input ~= 0 and (is_hover or gamepad_active) then
					content.axis_input = axis_input

					local previous_scroll_add = content.scroll_add or 0

					content.scroll_add = previous_scroll_add + axis_input * scroll_amount
				end

				local scroll_add = content.scroll_add

				if scroll_add then
					local speed = gamepad_active and 2.5 or 5
					local step = scroll_add * (dt * speed)

					if math.abs(scroll_add) > scroll_amount / 500 then
						content.scroll_add = scroll_add - step
					else
						content.scroll_add = nil
					end

					local current_scroll_value = content.scroll_value or content.scroll_percentage or 0

					if current_scroll_value then
						content.scroll_value = math.clamp(current_scroll_value + step, 0, 1)
					end

					content.scroll_percentage = content.scroll_value or content.scroll_percentage or 0
				end
			end,
		},
		{
			pass_type = "logic",
			style_id = "bar_offsets_logic",
			value = function (pass, renderer, style, content, position, size)
				local style_parent = style.parent
				local track_axis_offset = style_parent.scrollbar_track.offset[axis]
				local hotspot_style = style_parent.scrollbar_hotspot
				local thumb_style = style_parent.thumb
				local scrollbar_length = style_parent.scrollbar_track.size[axis]
				local thumb_length = thumb_size[axis]
				local end_position = scrollbar_length - thumb_length
				local scroll_percentage = content.scroll_percentage or 0
				local current_position = end_position * scroll_percentage
				local scroll_thumb_offset = math.clamp(current_position, 4, end_position - 4)

				hotspot_style.offset[axis] = scroll_thumb_offset
				thumb_style.offset[axis] = scroll_thumb_offset
			end,
		},
	}, scenegraph_id)

	return scrollbar_widget
end

local function _update_debrief_button_size_by_selection_state(content, style, animation, dt)
	local hotspot = content.hotspot or content.parent.hotspot
	local anim_hover_progress = hotspot.anim_hover_progress or 0

	style.size[1] = style.default_size[1] + 10 * anim_hover_progress
	style.size[2] = style.default_size[2] + 10 * anim_hover_progress
end

local function create_debrief_widget(scenegraph_id, is_locked)
	local frame_style = Styles.debrief_video.frame

	frame_style.color = is_locked and frame_style.disabled_color or frame_style.default_color

	local icon_style = Styles.debrief_video.debrief_icon

	icon_style.color = is_locked and icon_style.disabled_color or icon_style.default_color

	local line_style = Styles.debrief_video.line

	line_style.color = is_locked and line_style.disabled_color or line_style.default_color

	local widget_definition = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background",
			style = Styles.debrief_video.background,
			change_function = _update_debrief_button_size_by_selection_state,
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/mission_board/frame_with_corner_detail",
			value_id = "frame",
			style = frame_style,
			change_function = _update_debrief_button_size_by_selection_state,
		},
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			style_id = "hotspot",
			style = Styles.debrief_video.hotspot,
			change_function = _update_debrief_button_size_by_selection_state,
		},
		{
			pass_type = "texture",
			style_id = "debrief_icon",
			value = "content/ui/materials/mission_board/soundwave_icon",
			value_id = "debrief_icon",
			style = icon_style,
			change_function = function (content, style, animation, dt)
				_update_debrief_button_size_by_selection_state(content, style, animation, dt)
			end,
		},
		{
			pass_type = "rect",
			style_id = "line",
			style = line_style,
		},
		{
			pass_type = "text",
			style_id = "gamepad_input_hint",
			value = "X",
			value_id = "gamepad_input_hint",
			style = Styles.debrief_video.gamepad_input_hint,
			visibility_function = function (content, style)
				local hotspot = content.hotspot

				return InputDevice.gamepad_active and hotspot.is_selected
			end,
			change_function = function (content, style, animation, dt)
				if not InputDevice.gamepad_active then
					return
				end

				local input_service_name = "View"
				local action_name = "mission_board_play_debrief"
				local alias_key = Managers.ui:get_input_alias_key(action_name, input_service_name)
				local input_text = InputUtils.input_text_for_current_input_device(input_service_name, alias_key)

				content.gamepad_input_hint = input_text
			end,
		},
	}, scenegraph_id)

	widget_definition.content.is_locked = is_locked

	return widget_definition
end

local widget_definitions = {
	list_mask = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur_02",
		},
	}, "list_mask"),
	list_background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "list_background",
			style = {
				color = {
					160,
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "rotated_texture",
			style_id = "list_background_fade",
			value = "content/ui/materials/hud/backgrounds/fade_horizontal",
			value_id = "list_background_fade",
			style = Styles.list_background.list_background_fade,
		},
	}, "list_background"),
	list_frame = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "list_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				color = {
					255,
					255,
					88,
					27,
				},
				offset = {
					0,
					0,
					2,
				},
				size_addition = {
					0,
					0,
				},
			},
		},
	}, "list_background"),
	top_detail = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "detail_texture",
			value = "content/ui/materials/icons/mission_types_pj/mission_type_story",
			value_id = "detail_texture",
			style = Styles.top_detail.detail_texture,
		},
	}, "top_detail"),
	bottom_detail = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "flavor_text_1",
			value = "",
			value_id = "flavor_text_1",
			style = Styles.bottom_detail.flavor_text_1,
			change_function = function (content, style, animations, dt)
				local entry_animation_done = content.entry_animation_done

				if not entry_animation_done then
					return
				end

				local progress = content.progress or 0

				if progress < 0.33 then
					content.flavor_text_1 = content.default_flavor_text .. "."
				elseif progress < 0.66 then
					content.flavor_text_1 = content.default_flavor_text .. ".."
				elseif progress < 1 then
					content.flavor_text_1 = content.default_flavor_text .. "..."
				else
					progress = 0
				end

				content.progress = progress + dt
			end,
		},
	}, "bottom_detail"),
	campaign_header = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "header_text",
			value = "",
			value_id = "header_text",
			style = Styles.campaign_header.header_text,
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			value_id = "frame",
			style = Styles.bottom_detail.frame,
		},
	}, "campaign_header"),
}
local animations = {}

animations.title_enter = {
	{
		end_time = 0.05,
		name = "setup",
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			local scrollbar_widget = parent._scrollbar_widget

			scrollbar_widget.visible = false
			widgets.top_detail.visible = false
			widgets.bottom_detail.visible = false
			widgets.campaign_header.visible = false
			widgets.list_background.visible = false
			widgets.list_background.style.list_background_fade.color[1] = 0
			widgets.list_frame.visible = false
			ui_scenegraph.list_background.size[1] = 0
			ui_scenegraph.list_background.size[2] = 0
			parent._background_entry_done = false
		end,
	},
	{
		end_time = 0.35,
		name = "background_entry",
		start_time = 0.05,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			widgets.list_background.visible = true
			widgets.list_frame.visible = true
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			local width = mission_area_width * math.easeOutCubic(progress)
			local height = mission_area_height * math.easeOutCubic(progress)

			ui_scenegraph.list_background.size[1] = width
			ui_scenegraph.list_background.size[2] = height
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			widgets.top_detail.visible = true
			widgets.bottom_detail.visible = true
			widgets.campaign_header.visible = true

			local scrollbar_widget = parent._scrollbar_widget

			scrollbar_widget.visible = true
			parent._background_entry_done = true

			parent:_start_mission_list_entry_animation()
		end,
	},
	{
		end_time = 0.5,
		name = "fade_in",
		start_time = 0.35,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			return
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			widgets.list_background.style.list_background_fade.color[1] = 90 * progress
		end,
	},
	{
		end_time = 1.15,
		name = "title_enter",
		start_time = 0.35,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			local campaign_header = widgets.campaign_header
			local campaign_header_content = campaign_header.content
			local default_header_text = campaign_header_content.default_header_text
			local campaign_header_num_characters = campaign_header_content.num_characters or Utf8.string_length(default_header_text)

			campaign_header_content.num_characters = campaign_header_num_characters

			local bottom_detail = widgets.bottom_detail

			bottom_detail.content.default_flavor_text = Utf8.upper(Localize("loc_mission_board_campaign_playlist_flavor_text_1"))

			local bottom_detail_style = bottom_detail.style
			local text_style = bottom_detail_style.flavor_text_1
			local text_options = UIFonts.get_font_options_by_style(text_style)
			local text_width = UIRenderer.text_size(params.ui_renderer, bottom_detail.content.default_flavor_text, text_style.font_type, text_style.font_size, {
				mission_area_width,
				0,
			}, text_options)

			text_style.size[1] = text_width + 60
			text_style.offset[1] = mission_area_width - (text_width + 60)
			bottom_detail.content.entry_animation_done = false

			local bottom_detail_num_characters = bottom_detail.content.num_characters or Utf8.string_length(bottom_detail.content.default_flavor_text)

			bottom_detail.content.num_characters = bottom_detail_num_characters
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			local campaign_header = widgets.campaign_header
			local campaign_header_content = campaign_header.content

			campaign_header_content.header_text = Utf8.sub_string(campaign_header_content.default_header_text, 1, math.floor(campaign_header_content.num_characters * progress))

			local bottom_detail = widgets.bottom_detail
			local bottom_detail_content = bottom_detail.content

			bottom_detail_content.flavor_text_1 = Utf8.sub_string(bottom_detail_content.default_flavor_text, 1, math.floor(bottom_detail_content.num_characters * progress))
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			local bottom_detail = widgets.bottom_detail

			bottom_detail.content.entry_animation_done = true
		end,
	},
}
animations.mission_tile_entry = {
	{
		end_time = 0.05,
		name = "mission_tile_entry_setup",
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			local cell_data = params.cell_data
			local mission_tile_widget = cell_data.widget

			if not mission_tile_widget then
				return
			end

			local style = mission_tile_widget.style
			local content = mission_tile_widget.content

			style.background.visible = false
			style.selected_frame_detail.visible = false
			style.display_order_background.visible = false
			style.display_order_text.visible = false
			style.display_order_text_frame.visible = false
			style.location_frame.visible = false
			style.location_image.visible = false
			style.location_lock.visible = false
			style.location_vignette.visible = false
			style.location_rect.visible = false
			style.main_objective_icon.visible = false
			style.main_objective_frame.visible = false
			style.side_objective_icon.visible = false
			style.side_objective_frame.visible = false
			style.side_objective_background.visible = false
		end,
	},
	{
		end_time = 0.35,
		name = "mission_tile_entry_location",
		start_time = 0.05,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			local cell_data = params.cell_data
			local mission_tile_widget = cell_data.widget

			if not mission_tile_widget then
				return
			end

			local style = mission_tile_widget.style
			local content = mission_tile_widget.content

			style.background.color[1] = 0
			style.selected_frame_detail.color[1] = 0
			style.location_frame.color[1] = 0
			style.location_image.color[1] = 0
			style.location_lock.color[1] = 0
			style.location_vignette.color[1] = 0
			style.location_rect.color[1] = 0
			mission_tile_widget.visible = true
			style.background.visible = true
			style.selected_frame_detail.visible = true
			style.location_frame.visible = true
			style.location_image.visible = true
			style.location_lock.visible = content.is_locked
			style.location_vignette.visible = true
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			local cell_data = params.cell_data
			local mission_tile_widget = cell_data.widget

			if not mission_tile_widget then
				return
			end

			local style = mission_tile_widget.style
			local content = mission_tile_widget.content
			local ease_progress = math.easeOutCubic(progress)

			style.background.color[1] = 255 * ease_progress
			style.selected_frame_detail.color[1] = 255 * ease_progress
			style.location_frame.color[1] = 255 * ease_progress
			style.location_image.color[1] = 255 * ease_progress
			style.location_lock.color[1] = 255 * ease_progress
			style.location_vignette.color[1] = 255 * ease_progress
			style.location_rect.color[1] = 255 * ease_progress
		end,
	},
	{
		end_time = 0.35,
		name = "mission_tile_entry_display_order",
		start_time = 0.05,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			local cell_data = params.cell_data
			local mission_tile_widget = cell_data.widget

			if not mission_tile_widget then
				return
			end

			local style = mission_tile_widget.style
			local content = mission_tile_widget.content

			style.display_order_background.color[1] = 0
			style.display_order_text.text_color[1] = 0
			style.display_order_text_frame.color[1] = 0
			style.display_order_background.visible = true
			style.display_order_text.visible = true
			style.display_order_text_frame.visible = true

			local num_characters = Utf8.string_length(content.default_display_order_text)

			content.display_order_text_num_characters = num_characters
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			local cell_data = params.cell_data
			local mission_tile_widget = cell_data.widget

			if not mission_tile_widget then
				return
			end

			local style = mission_tile_widget.style
			local content = mission_tile_widget.content

			style.display_order_background.color[1] = 255 * math.easeOutCubic(progress)
			style.display_order_text.text_color[1] = 255 * math.easeOutCubic(progress)
			style.display_order_text_frame.color[1] = 255 * math.easeOutCubic(progress)
			content.display_order_text = Utf8.sub_string(content.default_display_order_text, 1, math.floor(content.display_order_text_num_characters * progress))
		end,
	},
	{
		end_time = 0.35,
		name = "mission_tile_entry_objectives",
		start_time = 0.05,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			local cell_data = params.cell_data
			local mission_tile_widget = cell_data.widget

			if not mission_tile_widget then
				return
			end

			local style = mission_tile_widget.style
			local content = mission_tile_widget.content

			style.main_objective_icon.color[1] = 0
			style.main_objective_frame.color[1] = 0
			style.side_objective_icon.color[1] = 0
			style.side_objective_frame.color[1] = 0
			style.side_objective_background.color[1] = 0
			style.main_objective_icon.visible = true
			style.main_objective_frame.visible = true

			local has_side_objective = not not content.has_side_objective

			style.side_objective_icon.visible = has_side_objective
			style.side_objective_frame.visible = has_side_objective
			style.side_objective_background.visible = has_side_objective
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			local cell_data = params.cell_data
			local mission_tile_widget = cell_data.widget

			if not mission_tile_widget then
				return
			end

			local style = mission_tile_widget.style
			local content = mission_tile_widget.content

			style.main_objective_icon.color[1] = 255 * math.easeOutCubic(progress)
			style.main_objective_frame.color[1] = 255 * math.easeOutCubic(progress)

			if content.has_side_objective then
				style.side_objective_icon.color[1] = 255 * math.easeOutCubic(progress)
				style.side_objective_frame.color[1] = 255 * math.easeOutCubic(progress)
				style.side_objective_background.color[1] = 255 * math.easeOutCubic(progress)
			end
		end,
	},
	{
		end_time = 0.05,
		name = "line_entry_setup",
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			local cell_data = params.cell_data
			local line_widgets = cell_data.line_widgets

			if not line_widgets then
				return
			end
		end,
	},
	{
		end_time = 0.35,
		name = "line_entry",
		start_time = 0.05,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			local cell_data = params.cell_data
			local line_widgets = cell_data.line_widgets

			if not line_widgets then
				return
			end

			for i = 1, #line_widgets do
				local line_widget = line_widgets[i]
				local style = line_widget.style
				local content = line_widget.content
				local direction = content.direction or "horizontal"

				if direction == "horizontal" then
					style.line_rect.size[1] = 0
				else
					style.line_rect.size[2] = 0
				end

				line_widget.visible = true
			end
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			local cell_data = params.cell_data
			local line_widgets = cell_data.line_widgets

			if not line_widgets then
				return
			end

			for i = 1, #line_widgets do
				local line_widget = line_widgets[i]
				local style = line_widget.style
				local content = line_widget.content
				local direction = content.direction or "horizontal"
				local default_size = content.default_size

				if direction == "horizontal" then
					style.line_rect.size[1] = default_size[1] * math.easeOutCubic(progress)
				else
					style.line_rect.size[2] = default_size[2] * math.easeOutCubic(progress)
				end
			end
		end,
	},
	{
		end_time = 0.05,
		name = "debrief_entry_setup",
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			local cell_data = params.cell_data
			local debrief_widget = cell_data.debrief_widget

			if not debrief_widget then
				return
			end

			local style = debrief_widget.style
			local content = debrief_widget.content

			style.background.color[1] = 0
			style.frame.color[1] = 0
			style.debrief_icon.color[1] = 0
			style.line.color[1] = 0
			style.gamepad_input_hint.text_color[1] = 0
		end,
	},
	{
		end_time = 0.2,
		name = "debrief_entry_background",
		start_time = 0.05,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			local cell_data = params.cell_data
			local debrief_widget = cell_data.debrief_widget

			if not debrief_widget then
				return
			end

			local style = debrief_widget.style

			style.background.color[1] = 0
			style.frame.color[1] = 0
			style.line.color[1] = 0
			debrief_widget.visible = true
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			local cell_data = params.cell_data
			local debrief_widget = cell_data.debrief_widget

			if not debrief_widget then
				return
			end

			local style = debrief_widget.style
			local content = debrief_widget.content
			local is_locked = content.is_locked

			style.background.color[1] = 255 * math.easeOutCubic(progress)
			style.frame.color[1] = (is_locked and style.frame.disabled_color[1] or style.frame.default_color[1]) * math.easeOutCubic(progress)
			style.line.color[1] = (is_locked and style.line.disabled_color[1] or style.line.default_color[1]) * math.easeOutCubic(progress)
		end,
	},
	{
		end_time = 0.35,
		name = "debrief_entry_foreground",
		start_time = 0.2,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			local cell_data = params.cell_data
			local debrief_widget = cell_data.debrief_widget

			if not debrief_widget then
				return
			end

			local style = debrief_widget.style
			local content = debrief_widget.content

			style.debrief_icon.color[1] = 0
			style.gamepad_input_hint.text_color[1] = 0
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			local cell_data = params.cell_data
			local debrief_widget = cell_data.debrief_widget

			if not debrief_widget then
				return
			end

			local style = debrief_widget.style
			local content = debrief_widget.content
			local is_locked = content.is_locked

			style.debrief_icon.color[1] = (is_locked and style.debrief_icon.disabled_color[1] or style.debrief_icon.default_color[1]) * math.easeOutCubic(progress)
			style.gamepad_input_hint.text_color[1] = 255 * math.easeOutCubic(progress)
		end,
	},
}
Definitions.scenegraph_definition = scenegraph_definition
Definitions.widget_definitions = widget_definitions
Definitions.create_scrollbar_widget = create_scrollbar_widget
Definitions.create_debrief_widget = create_debrief_widget
Definitions.animations = animations

return settings("ViewElementCampaignMissionListDefinitions", Definitions)
