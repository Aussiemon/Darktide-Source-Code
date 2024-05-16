-- chunkname: @scripts/ui/view_elements/view_element_mission_info_panel/view_element_mission_info_panel_blueprints.lua

local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local MissionBoardSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local MissionInfoStyles = require("scripts/ui/view_elements/view_element_mission_info_panel/view_element_mission_info_panel_styles")
local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local MutatorTemplates = require("scripts/settings/mutator/mutator_templates")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local blueprint_styles = MissionInfoStyles.blueprints
local side_mission_templates = MissionObjectiveTemplates.side_mission.objectives

local function _calculate_text_size(widget, text_and_style_id, ui_renderer)
	local text = widget.content[text_and_style_id]
	local text_style = widget.style[text_and_style_id]
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local size = text_style.size or widget.content.size

	return UIRenderer.text_size(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)
end

local details_widgets_blueprints = {}

details_widgets_blueprints.templates = {}

local blueprint_templates = details_widgets_blueprints.templates

blueprint_templates.report_header = {
	size = blueprint_styles.report_header.size,
	pass_template = {
		{
			pass_type = "text",
			style_id = "headline",
			value = "Situation Report",
			value_id = "headline",
		},
		{
			pass_type = "text",
			style_id = "time_left",
			value = " 40:30",
			value_id = "time_left",
			change_function = function (content, style)
				content.time_left = content.time_left_update()
			end,
		},
	},
	style = blueprint_styles.report_header,
	init = function (widget, widget_data)
		local widget_content = widget.content

		widget_content.headline = widget_data.headline
		widget_content.time_left_update = widget_data.time_left_update
	end,
}
blueprint_templates.negative_circumstance_header = {
	size = blueprint_styles.negative_circumstance_header.size,
	pass_template = {
		{
			pass_type = "texture",
			style_id = "icon",
			value_id = "icon",
		},
		{
			pass_type = "text",
			style_id = "label",
			value_id = "label",
			value = Localize("loc_mission_info_circumstance_label"),
		},
		{
			pass_type = "text",
			style_id = "title",
			value_id = "title",
		},
	},
	style = blueprint_styles.negative_circumstance_header,
	init = function (widget, widget_data, ui_renderer)
		local circumstance_template = widget_data.circumstance_template
		local widget_content = widget.content

		widget_content.icon = circumstance_template.ui.icon
		widget_content.title = Localize(circumstance_template.ui.display_name)

		local _, title_text_height = _calculate_text_size(widget, "title", ui_renderer)
		local widget_style = widget.style
		local total_widget_height = widget_style.title.offset[2] + title_text_height + widget_style.bottom_margin

		if total_widget_height > widget_content.size[2] then
			widget_content.size[2] = total_widget_height
		end
	end,
}
blueprint_templates.positive_circumstance_header = table.clone(blueprint_templates.negative_circumstance_header)
blueprint_templates.positive_circumstance_header.size = blueprint_styles.positive_circumstance_header.size
blueprint_templates.positive_circumstance_header.style = blueprint_styles.positive_circumstance_header
blueprint_templates.circumstance_bullet_point = {
	size = blueprint_styles.circumstance_bullet_point.size,
	pass_template = {
		{
			pass_type = "text",
			style_id = "bullet",
			value = "•",
			value_id = "bullet",
		},
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
		},
	},
	style = blueprint_styles.circumstance_bullet_point,
	init = function (widget, widget_data, ui_renderer)
		local widget_content = widget.content

		widget_content.text = Localize(widget_data.bullet_point)

		local widget_size = widget_content.size
		local _, text_height = _calculate_text_size(widget, "text", ui_renderer)
		local style = widget.style
		local text_offset = style.text.offset
		local bottom_margin = style.bottom_margin
		local total_text_height = text_offset[2] + text_height + bottom_margin

		if total_text_height > widget_size[2] then
			widget_size[2] = total_text_height
		end
	end,
}
blueprint_templates.list_spacing = {
	size = {
		MissionInfoStyles.panel.size[1],
		blueprint_styles.list_spacing,
	},
}
blueprint_templates.side_mission = {
	size = blueprint_styles.side_mission.size,
	pass_template = {
		{
			pass_type = "text",
			style_id = "label",
			value_id = "label",
			value = Localize("loc_mission_info_side_mission_label"),
		},
		{
			pass_type = "text",
			style_id = "title",
			value_id = "title",
		},
		{
			pass_type = "text",
			style_id = "description",
			value_id = "description",
		},
	},
	style = blueprint_styles.side_mission,
	init = function (widget, widget_data, ui_renderer)
		local side_mission_template = widget_data.side_mission_template
		local widget_content = widget.content

		widget_content.title = Localize(side_mission_template.header)
		widget_content.description = Localize(side_mission_template.description)

		local style = widget.style
		local _, title_height = _calculate_text_size(widget, "title", ui_renderer)
		local bottom_margin = style.bottom_margin
		local total_text_height = style.title.offset[2] + title_height + bottom_margin
		local description_offset = style.description.offset

		if total_text_height > description_offset[2] then
			description_offset[2] = total_text_height
		else
			total_text_height = description_offset[2]
		end

		local widget_size = widget_content.size
		local _, description_height = _calculate_text_size(widget, "description", ui_renderer)

		total_text_height = total_text_height + description_height + bottom_margin

		if total_text_height > widget_size[2] then
			widget_size[2] = total_text_height
		end

		style.description.size[2] = description_height + bottom_margin
	end,
}
blueprint_templates.bonus = {
	size = blueprint_styles.bonus.size,
	pass_template = {
		{
			pass_type = "texture",
			style_id = "icon",
			value_id = "icon",
		},
		{
			pass_type = "text",
			style_id = "category",
			value_id = "category",
		},
		{
			pass_type = "text",
			style_id = "title",
			value_id = "title",
		},
	},
	style = blueprint_styles.bonus,
	init = function (widget, widget_data)
		local widget_content = widget.content

		widget_content.category = widget_data.category
		widget_content.title = widget_data.title

		if widget_data.icon then
			widget_content.icon = widget_data.icon
		else
			widget.style.icon.visible = false
		end
	end,
}
details_widgets_blueprints.utility_functions = {}

local blueprint_utility_functions = details_widgets_blueprints.utility_functions

blueprint_utility_functions.base_xp_calculation = function (resistance_level, challenge_level)
	return MissionBoardSettings.base_mission_xp + MissionBoardSettings.challenge_xp * challenge_level + MissionBoardSettings.resistance_xp * resistance_level
end

local _widget_data = {}

local function _next_element(index)
	local details_data = _widget_data

	index = index + 1

	local next_element = details_data[index]

	if next_element then
		table.clear(next_element.widget_data)
	else
		next_element = {
			widget_data = {},
		}
		details_data[index] = next_element
	end

	return next_element, index
end

local function _prepare_circumstance_data(circumstance, num_elements)
	if circumstance and circumstance ~= "default" then
		local circumstance_template = CircumstanceTemplates[circumstance]
		local circumstance_ui_data = circumstance_template.ui

		if not circumstance_ui_data then
			return num_elements
		end

		local circumstance_header_data

		circumstance_header_data, num_elements = _next_element(num_elements)

		local is_positive_circumstance = circumstance_template.ui.favourable_to_players

		circumstance_header_data.template = is_positive_circumstance and "positive_circumstance_header" or "negative_circumstance_header"
		circumstance_header_data.widget_data.circumstance_template = circumstance_template

		local mutators = circumstance_template.mutators

		if mutators then
			for i = 1, #mutators do
				local mutator_name = mutators[i]
				local mutator = MutatorTemplates[mutator_name]
				local descriptions = mutator.description
				local circumstance_bullet_point_data

				for j = 1, #descriptions do
					circumstance_bullet_point_data, num_elements = _next_element(num_elements)
					circumstance_bullet_point_data.template = "circumstance_bullet_point"
					circumstance_bullet_point_data.widget_data.bullet_point = descriptions[j]
				end
			end
		end

		local spacing

		spacing, num_elements = _next_element(num_elements)
		spacing.template = "list_spacing"
	end

	return num_elements
end

blueprint_utility_functions.prepare_details_data = function (mission_data, map_data)
	local num_elements = 0
	local risk_reward_data

	risk_reward_data, num_elements = _next_element(num_elements)
	risk_reward_data.template = "risk_and_reward"
	risk_reward_data.widget_data.mission_data = mission_data

	local circumstance = mission_data.circumstance

	num_elements = _prepare_circumstance_data(circumstance, num_elements)

	local side_mission = mission_data.side_mission

	if side_mission then
		local template = side_mission_templates[side_mission]

		if template then
			local side_mission_data

			side_mission_data, num_elements = _next_element(num_elements)
			side_mission_data.template = "side_mission"
			side_mission_data.widget_data.side_mission_template = side_mission_templates[side_mission]

			local spacing

			spacing, num_elements = _next_element(num_elements)
			spacing.template = "list_spacing"
		end
	end

	return _widget_data, num_elements
end

blueprint_utility_functions.prepare_report_data = function (happening_data, time_left_callback)
	local num_elements = 0
	local header_data

	header_data, num_elements = _next_element(num_elements)
	header_data.template = "report_header"

	local header_widget_data = header_data.widget_data

	header_widget_data.headline = happening_data.name and happening_data.name or Localize("loc_mission_board_event_panel_label")
	header_widget_data.time_left_update = time_left_callback

	local circumstances = happening_data.circumstances

	for i = 1, #circumstances do
		num_elements = _prepare_circumstance_data(circumstances[i], num_elements)
	end

	return _widget_data, num_elements
end

return details_widgets_blueprints
