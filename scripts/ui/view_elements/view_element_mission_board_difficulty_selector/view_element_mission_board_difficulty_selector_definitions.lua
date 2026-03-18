-- chunkname: @scripts/ui/view_elements/view_element_mission_board_difficulty_selector/view_element_mission_board_difficulty_selector_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local MissionBoardViewSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local Styles = require("scripts/ui/view_elements/view_element_mission_board_difficulty_selector/view_element_mission_board_difficulty_selector_styles")
local StepperPassTemplates = require("scripts/ui/pass_templates/stepper_pass_templates")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ColorUtilities = require("scripts/utilities/ui/colors")
local Dimensions = MissionBoardViewSettings.dimensions
local top_buffer = Dimensions.top_buffer
local side_buffer = Dimensions.side_buffer
local details_width = Dimensions.details_width
local sidebar_buffer = Dimensions.sidebar_buffer
local mission_area_width = Dimensions.mission_area_width
local mission_area_height = Dimensions.mission_area_height
local Definitions = {}
local widget_definitions = {}
local difficulty_progress_tooltip = UIWidget.create_definition({
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = Styles.difficulty_progress_tooltip.frame,
	},
	{
		pass_type = "rect",
		style_id = "background",
		value_id = "background",
		style = Styles.difficulty_progress_tooltip.background,
	},
	{
		pass_type = "text",
		style_id = "text",
		value = "TOOLTIP TEXT",
		value_id = "text",
		style = Styles.difficulty_progress_tooltip.text,
	},
}, "difficulty_stepper_tooltip")

widget_definitions.difficulty_stepper = UIWidget.create_definition(StepperPassTemplates.mission_board_stepper, "difficulty_stepper")

local function _progress_bar_change_function(content, style, animations, dt)
	local color = style.color
	local from_color = style.color
	local to_color = content.target_color

	if from_color and to_color then
		ColorUtilities.color_lerp(from_color, to_color, 0.1, color, false)
	end
end

local difficulty_progress_bar = UIWidget.create_definition({
	{
		pass_type = "texture",
		style_id = "difficulty_progress_frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		value_id = "difficulty_progress_frame",
		style = Styles.difficulty_progress_bar.frame,
		change_function = _progress_bar_change_function,
		visibility_function = function (content, style)
			return content.progress ~= 1
		end,
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
		end,
	},
}, "difficulty_progress_bar")

Definitions.widget_definitions = widget_definitions

return settings("ViewElementMissionBoardDifficultySelectorDefinitions", Definitions)
