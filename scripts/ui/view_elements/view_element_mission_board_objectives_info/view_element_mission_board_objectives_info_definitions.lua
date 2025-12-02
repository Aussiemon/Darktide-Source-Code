-- chunkname: @scripts/ui/view_elements/view_element_mission_board_objectives_info/view_element_mission_board_objectives_info_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local ColorUtilities = require("scripts/utilities/ui/colors")
local Styles = require("scripts/ui/view_elements/view_element_mission_board_objectives_info/view_element_mission_board_objectives_info_styles")
local Settings = require("scripts/ui/view_elements/view_element_mission_board_objectives_info/view_element_mission_board_objectives_info_settings")
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
			200,
		},
		position = {
			0,
			280,
			2,
		},
	},
	_mission_objectives_panel = {
		horizontal_alignment = "center",
		parent = "_mission_objective_info",
		vertical_alignment = "top",
		size = {
			details_width,
			Settings.panel_height,
		},
		position = {
			0,
			-Settings.panel_height,
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

function panel_element_visibility_function(content, style)
	return content.hotspot.is_selected
end

function change_size_by_selection_state(content, style, animations, dt)
	local hotspot = content.hotspot or content.parent.hotspot
	local is_selected = hotspot.is_selected
	local selection_progress = hotspot.anim_select_progress or 0

	style.size[1] = style.default_size[1] + (style.active_size[1] - style.default_size[1]) * selection_progress
	style.size[2] = style.default_size[2] + (style.active_size[2] - style.default_size[2]) * selection_progress
end

Definitions.create_objectives_panel_widget = function (scenegraph_id, title, sub_title, icon, default_size, active_size)
	return UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background",
			style = Styles.objectives_panel.background,
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = Styles.objectives_panel.frame,
		},
		{
			pass_type = "text",
			style_id = "objectives_panel_title",
			value_id = "objectives_panel_title",
			value = title,
			style = Styles.objectives_panel.title,
			visibility_function = panel_element_visibility_function,
		},
		{
			pass_type = "text",
			style_id = "objectives_panel_sub_title",
			value_id = "objectives_panel_sub_title",
			value = sub_title,
			style = Styles.objectives_panel.sub_title,
			visibility_function = panel_element_visibility_function,
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value_id = "icon",
			value = icon,
			style = Styles.objectives_panel.icon,
		},
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			style_id = "hotspot",
			style = Styles.objectives_panel.hotspot,
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/gradients/gradient_horizontal",
			style = Styles.objectives_panel.background_gradient,
			change_function = function (content, style, animations, dt)
				if not content.hotspot.is_selected then
					style.color[1] = 100 + 65 * content.hotspot.anim_hover_progress
				else
					style.color[1] = 100 * (1 - content.hotspot.anim_select_progress)
				end
			end,
		},
	}, scenegraph_id, {
		default_size = default_size,
		active_size = active_size,
		default_title_text = title,
		default_sub_title_text = sub_title,
	}, default_size, {
		objectives_panel_title = {
			text_color = Styles.colors.default.terminal_header_text,
		},
	})
end

Definitions.create_reward_widget = function (scenegraph_id, amount, icon, size)
	return UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = Styles.mission_objective_info.reward.frame,
		},
		{
			pass_type = "text",
			style_id = "amount",
			value_id = "amount",
			value = amount,
			style = Styles.mission_objective_info.reward.amount,
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value_id = "icon",
			value = icon,
			style = Styles.mission_objective_info.reward.icon,
		},
	}, scenegraph_id, nil, size)
end

local widget_definitions = {}

widget_definitions.mission_objective_info = UIWidget.create_definition({
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = Styles.mission_objective_info.frame,
	},
	{
		pass_type = "rect",
		style_id = "background",
		style = Styles.mission_objective_info.background,
	},
	{
		pass_type = "text",
		style_id = "objective_description",
		value = "Objective Description",
		value_id = "objective_description",
		style = Styles.mission_objective_info.objective_description,
	},
	{
		pass_type = "texture",
		style_id = "mission_giver_frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = Styles.mission_objective_info.mission_giver_frame,
		visibility_function = function (content, style)
			return not content.is_quickplay_mission and content.has_mission_giver
		end,
	},
	{
		pass_type = "text",
		style_id = "mission_giver_name",
		value = "Mission Giver Name",
		value_id = "mission_giver_name",
		style = Styles.mission_objective_info.mission_giver_name,
		visibility_function = function (content, style)
			return content.has_mission_giver
		end,
	},
	{
		pass_type = "texture",
		style_id = "mission_giver_icon",
		value_id = "mission_giver_icon",
		style = Styles.mission_objective_info.mission_giver_icon,
		visibility_function = function (content, style)
			return content.has_mission_giver
		end,
	},
	{
		pass_type = "rotated_texture",
		style_id = "background_fade",
		value = "content/ui/materials/hud/backgrounds/fade_horizontal",
		value_id = "background_fade",
		style = Styles.mission_objective_info.background_fade,
	},
}, "_mission_objective_info")

local animations = {}

animations.info_description_enter = {
	{
		end_time = 0.3,
		name = "info_description_enter",
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			local objective_info_widget = widgets.mission_objective_info
			local content = objective_info_widget.content
			local style = objective_info_widget.style

			content.default_description = content.objective_description
			content.description_num_characters = Utf8.string_length(content.default_description)
			style.objective_description.from_color = table.shallow_copy(style.objective_description.text_color)
			style.background_fade.from_color = table.shallow_copy(style.background_fade.color)
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			local objective_info_widget = widgets.mission_objective_info
			local content = objective_info_widget.content
			local style = objective_info_widget.style
			local char_index = math.floor(content.description_num_characters * progress)

			content.objective_description = string.sub(content.default_description, 1, char_index)

			local od_from_color = style.objective_description.from_color
			local frame_from_color = style.frame.color
			local fade_from_color = style.background_fade.color
			local to_color = content.theme_color or Style.colors.theme_colors.default
			local color = style.objective_description.text_color
			local ignore_alpha = true

			style.objective_description.text_color = ColorUtilities.color_lerp(od_from_color, to_color, progress, color, ignore_alpha)

			local frame_color = style.frame.color

			style.frame.color = ColorUtilities.color_lerp(frame_from_color, to_color, progress, frame_color, ignore_alpha)

			local should_show = content.active_tab and (content.active_tab == "circumstance" or content.active_tab == "story")

			style.background_fade.color[1] = 80 * progress * (should_show and 1 or 0)

			local fade_color = style.background_fade.color

			style.background_fade.color = ColorUtilities.color_lerp(fade_from_color, to_color, progress, fade_color, ignore_alpha)
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			parent._description_enter_anim_id = nil
		end,
	},
	{
		end_time = 0.3,
		name = "enter_rewards",
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			local reward_widgets = parent._reward_widgets

			if reward_widgets then
				for i = 1, #reward_widgets do
					local widget = reward_widgets[i]
					local content = widget.content

					content.default_text = content.amount
					content.amount = ""
					content.amount_num_characters = Utf8.string_length(content.default_text)
				end
			end

			local objective_info_widget = widgets.mission_objective_info
			local objective_info_content = objective_info_widget.content

			if objective_info_content.has_mission_giver then
				objective_info_content.mission_giver_default_text = objective_info_content.mission_giver_name
				objective_info_content.mission_giver_name = ""
				objective_info_content.mission_giver_num_characters = Utf8.string_length(objective_info_content.mission_giver_default_text)
			end
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			local reward_widgets = parent._reward_widgets

			if reward_widgets then
				for i = 1, #reward_widgets do
					local widget = reward_widgets[i]
					local content = widget.content
					local style = widget.style
					local char_index = math.floor(content.amount_num_characters * progress)

					content.amount = string.sub(content.default_text, 1, char_index)
				end
			end

			local objective_info_widget = widgets.mission_objective_info
			local objective_info_content = objective_info_widget.content

			if objective_info_content.has_mission_giver then
				local char_index = math.floor(objective_info_content.mission_giver_num_characters * progress)

				objective_info_content.mission_giver_name = string.sub(objective_info_content.mission_giver_default_text, 1, char_index)
			end
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			return
		end,
	},
}
Definitions.scenegraph_definition = scenegraph_definition
Definitions.widget_definitions = widget_definitions
Definitions.animations = animations

return settings("ViewElementMissionBoardObjectivesInfoDefinitions", Definitions)
