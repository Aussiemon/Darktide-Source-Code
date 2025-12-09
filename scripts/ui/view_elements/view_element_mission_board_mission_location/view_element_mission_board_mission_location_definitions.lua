-- chunkname: @scripts/ui/view_elements/view_element_mission_board_mission_location/view_element_mission_board_mission_location_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local Styles = require("scripts/ui/view_elements/view_element_mission_board_mission_location/view_element_mission_board_mission_location_styles")
local MissionBoardViewSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local MissionBoardSettings = MissionBoardViewSettings
local Definitions = {}
local Dimensions = MissionBoardSettings.dimensions
local screen_width = Dimensions.screen_width
local screen_height = Dimensions.screen_height
local top_buffer = Dimensions.top_buffer
local side_buffer = Dimensions.side_buffer
local widget_buffer = Dimensions.widget_buffer
local details_width = Dimensions.details_width
local sidebar_buffer = Dimensions.sidebar_buffer
local difficulty_selector_height = Dimensions.difficulty_selector_height
local mission_area_width = Dimensions.mission_area_width
local mission_area_height = Dimensions.mission_area_height
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
	_sidebar = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			details_width,
			mission_area_height - 200,
		},
		position = {
			-side_buffer,
			top_buffer,
			0,
		},
	},
	_sidebar_content = {
		horizontal_alignment = "center",
		parent = "_sidebar",
		vertical_alignment = "top",
		size = {
			details_width - 2 * sidebar_buffer,
			mission_area_height - 200,
		},
		position = {
			0,
			0,
			2,
		},
	},
	_mission_area_info = {
		horizontal_alignment = "center",
		parent = "_sidebar_content",
		vertical_alignment = "top",
		size = {
			details_width,
			360,
		},
		position = {
			0,
			0,
			0,
		},
	},
	_mission_area_timer = {
		horizontal_alignment = "center",
		parent = "_mission_area_info",
		vertical_alignment = "top",
		size = {
			details_width,
			20,
		},
		position = {
			0,
			92,
			10,
		},
	},
	_mission_area_circumstance = {
		horizontal_alignment = "center",
		parent = "_mission_area_info",
		vertical_alignment = "bottom",
		size = {
			details_width - 2,
			100,
		},
		position = {
			0,
			-2,
			20,
		},
	},
	_mission_objective_info = {
		horizontal_alignment = "center",
		parent = "_mission_area_info",
		vertical_alignment = "bottom",
		size = {
			details_width,
			250,
		},
		position = {
			0,
			275,
			2,
		},
	},
	_mission_objectives_panel = {
		horizontal_alignment = "center",
		parent = "_mission_objective_info",
		vertical_alignment = "top",
		size = {
			details_width,
			80,
		},
		position = {
			0,
			0,
			10,
		},
	},
	_mission_rewards_panel = {
		horizontal_alignment = "center",
		parent = "_mission_objective_info",
		vertical_alignment = "bottom",
		size = {
			details_width,
			Dimensions.rewards_height,
		},
		position = {
			0,
			0,
			2,
		},
	},
}
local widget_definitions = {}

widget_definitions.mission_area_info = UIWidget.create_definition({
	{
		pass_type = "texture",
		style_id = "image",
		value = "content/ui/materials/mission_board/texture_with_grid_effect",
		value_id = "image",
		style = Styles.mission_area_info.image,
	},
	{
		pass_type = "texture",
		style_id = "inner_shadow",
		value = "content/ui/materials/frames/inner_shadow_medium",
		style = Styles.mission_area_info.inner_shadow,
	},
	{
		pass_type = "texture",
		style_id = "outer_frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		value_id = "outer_frame",
		style = Styles.mission_area_info.outer_frame,
	},
	{
		pass_type = "texture",
		style_id = "location_lock",
		value = "content/ui/materials/mission_board/mission_locked_icon",
		value_id = "lock_texture",
		style = Styles.mission_area_info.lock,
		visibility_function = function (content, style)
			return content.is_locked
		end,
	},
	{
		pass_type = "rect",
		style_id = "title_background",
		style = Styles.mission_area_info.title_background,
	},
	{
		pass_type = "texture",
		style_id = "title_frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		value_id = "title_frame",
		style = Styles.mission_area_info.title_frame,
	},
	{
		pass_type = "text",
		style_id = "mission_title",
		value = "Mission Title",
		value_id = "mission_title",
		style = Styles.mission_area_info.mission_title,
	},
	{
		pass_type = "text",
		style_id = "mission_sub_title",
		value = "Mission Sub Title",
		value_id = "mission_sub_title",
		style = Styles.mission_area_info.mission_sub_title,
	},
}, "_mission_area_info")

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
		value = timer_logic,
	},
	{
		pass_type = "texture",
		style_id = "timer_bar_frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = Styles.mission_area_info.timer.timer_bar_frame,
	},
	{
		pass_type = "texture",
		style_id = "timer_frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = Styles.mission_area_info.timer.timer_frame,
	},
	{
		pass_type = "texture",
		style_id = "timer_bar",
		value = "content/ui/materials/mission_board/timer",
		style = Styles.mission_area_info.timer.timer_bar,
	},
	{
		pass_type = "texture",
		style_id = "timer_text_frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = Styles.mission_area_info.timer.timer_text_frame,
	},
	{
		pass_type = "texture",
		style_id = "timer_icon",
		value = "content/ui/materials/icons/generic/hourglass",
		style = Styles.mission_area_info.timer.timer_icon,
		visibility_function = function (content, style)
			return not content.is_quickplay
		end,
	},
	{
		pass_type = "text",
		style_id = "timer_text",
		value = "00:00",
		value_id = "timer_text",
		style = Styles.mission_area_info.timer.timer_text,
		visibility_function = function (content, style)
			return not content.is_quickplay
		end,
	},
	{
		pass_type = "texture",
		style_id = "infinite_symbol",
		value = "content/ui/materials/symbols/infinite",
		style = Styles.mission_area_info.timer.infinite_symbol,
		visibility_function = function (content, style)
			return content.is_quickplay
		end,
	},
}, "_mission_area_timer")

local animations = {}

animations.mission_area_info_enter = {
	{
		end_time = 0.3,
		name = "mission_info_enter",
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			local widget = widgets.mission_area_info
			local content = widget.content

			content.default_mission_title = content.mission_title
			content.default_mission_sub_title = content.mission_sub_title
			content.mission_title = ""
			content.mission_sub_title = ""
			content.mission_title_num_chars = Utf8.string_length(content.default_mission_title)
			content.mission_sub_title_num_chars = Utf8.string_length(content.default_mission_sub_title)
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			local widget = widgets.mission_area_info
			local content = widget.content
			local mission_title_char_idx = math.ceil(content.mission_title_num_chars * progress)
			local mission_sub_title_char_idx = math.ceil(content.mission_sub_title_num_chars * progress)
			local title_string = Utf8.sub_string(content.default_mission_title, 1, mission_title_char_idx)
			local sub_title_string = Utf8.sub_string(content.default_mission_sub_title, 1, mission_sub_title_char_idx)

			content.mission_title = title_string
			content.mission_sub_title = sub_title_string
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			parent._mission_area_enter_anim_id = nil
		end,
	},
}
Definitions.scenegraph_definition = scenegraph_definition
Definitions.widget_definitions = widget_definitions
Definitions.animations = animations

return settings("ViewElementMissionBoardMissionLocationDefinitions", Definitions)
