-- chunkname: @scripts/ui/views/mission_voting_view/mission_voting_view_blueprints.lua

local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local MissionTypes = require("scripts/settings/mission/mission_types")
local MutatorTemplates = require("scripts/settings/mutator/mutator_templates")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ViewStyles = require("scripts/ui/views/mission_voting_view/mission_voting_view_styles")
local blueprint_styles = ViewStyles.blueprints
local icons = {
	loot = "content/ui/materials/icons/generic/loot",
}
local quickplay_data = {
	icon = "content/ui/materials/icons/mission_types/mission_type_quick",
	mission_title = "loc_mission_board_quickplay_header",
	mission_type = "loc_mission_board_view_header_tertium_hive",
}
local button_strings = {
	hide_details = "loc_mission_voting_view_hide_details",
	show_details = "loc_mission_voting_view_show_details",
	selectable_buttons = {
		accept_button = "loc_mission_voting_view_accept_mission",
		decline_button = "loc_mission_voting_view_decline_mission",
	},
}

local function has_side_mission(mission_data)
	if not mission_data.sideMission then
		return false
	end

	local side_missions = MissionObjectiveTemplates.side_mission.objectives
	local side_mission = mission_data.sideMission
	local side_mission_template = side_missions[side_mission]

	if not side_mission_template then
		Log.warning("MissionVotingUI", "No objective template for side mission \"%s\"", side_mission)

		return false
	end

	return true
end

local function calculate_text_size(widget, text_and_style_id, ui_renderer)
	local text = widget.content[text_and_style_id]
	local text_style = widget.style[text_and_style_id]
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local size = text_style.size or widget.content.size

	return UIRenderer.text_size(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)
end

local function circumstance_init_function(widget, content, ui_renderer)
	local circumstance_name = content.circumstance
	local circumstance_template = CircumstanceTemplates[circumstance_name]
	local descriptors = {}
	local mutators = circumstance_template.mutators or {}

	for i = 1, #mutators do
		local mutator_name = mutators[i]
		local mutator = MutatorTemplates[mutator_name]
		local descriptions = mutator.description

		for j = 1, #descriptions do
			descriptors[#descriptors + 1] = Localize(descriptions[j])
		end
	end

	local formatted_description = ""

	for i = 1, #descriptors do
		formatted_description = formatted_description .. string.format("· %s\n", descriptors[i])
	end

	local widget_content = widget.content

	widget_content.icon = circumstance_template.ui.icon
	widget_content.title = Localize(circumstance_template.ui.display_name)
	widget_content.description = formatted_description

	local widget_size = widget.content.size
	local _, title_height = calculate_text_size(widget, "title", ui_renderer)
	local _, description_height = calculate_text_size(widget, "description", ui_renderer)
	local description_offset = widget.style.description.offset

	description_offset[2] = description_offset[2] + title_height + widget.style.title.offset[2]

	local bottom_margin = 10
	local total_text_height = description_offset[2] + description_height + bottom_margin

	if total_text_height > widget_size[2] then
		widget_size[2] = total_text_height
	end
end

local details_widgets_blueprints = {
	templates = {
		main_objective = {
			size = {
				475,
				100,
			},
			pass_template = {
				{
					pass_type = "text",
					style_id = "objective_header",
					value = "",
					value_id = "objective_header",
				},
				{
					pass_type = "texture",
					style_id = "main_objective_icon",
					value_id = "main_objective_icon",
				},
				{
					pass_type = "text",
					style_id = "body_text",
					value = "BODY TEXT",
					value_id = "body_text",
				},
				{
					pass_type = "text",
					style_id = "rewards_text",
					value = "",
					value_id = "rewards_text",
				},
			},
			style = blueprint_styles.main_objective,
			init = function (widget, data, ui_renderer)
				local mission_template = MissionTemplates[data.map]
				local mission_type = MissionTypes[mission_template.mission_type]
				local mission_type_name = mission_type and mission_type.name
				local mission_type_header = Localize(mission_type_name)
				local widget_content = widget.content

				widget_content.objective_header = mission_type_header
				widget_content.main_objective_icon = mission_type.icon

				local experience = math.floor(data.xp)
				local experience_text = string.format(" %d", tostring(experience))
				local salary = math.floor(data.credits)
				local salary_text = string.format(" %d", tostring(salary))

				widget_content.body_text = Localize(mission_template.mission_description) or "n/a"
				widget_content.rewards_text = string.format("%s \t %s", salary_text, experience_text)

				local style = widget.style
				local text_x_offset = 60
				local text_padding = 10
				local header_text_style = style.objective_header

				header_text_style.offset[1] = text_x_offset

				local _, header_text_height = calculate_text_size(widget, "objective_header", ui_renderer)
				local body_text_style = style.body_text
				local body_text_y_offset = header_text_height + text_padding

				body_text_style.offset = {
					text_x_offset,
					body_text_y_offset,
					1,
				}

				local rewards_text_style = style.rewards_text
				local _, body_text_height = calculate_text_size(widget, "body_text", ui_renderer)
				local rewards_y_offset = body_text_y_offset + body_text_height + text_padding

				rewards_text_style.offset = {
					text_x_offset,
					rewards_y_offset + 5,
					10,
				}
			end,
		},
		side_mission = {
			size = {
				475,
				100,
			},
			pass_template = {
				{
					pass_type = "text",
					style_id = "objective_header",
					value_id = "objective_header",
				},
				{
					pass_type = "texture",
					style_id = "objective_icon",
					value_id = "objective_icon",
				},
				{
					pass_type = "text",
					style_id = "body_text",
					value_id = "body_text",
				},
				{
					pass_type = "text",
					style_id = "rewards_text",
					value = "",
					value_id = "rewards_text",
				},
			},
			style = blueprint_styles.side_mission,
			init = function (widget, data, ui_renderer)
				local side_missions = MissionObjectiveTemplates.side_mission.objectives
				local side_mission = data.side_mission
				local side_mission_template = side_missions[side_mission]

				if not side_mission_template then
					return
				end

				local widget_content = widget.content

				widget_content.objective_header = Localize(side_mission_template.header)
				widget_content.objective_icon = side_mission_template.icon
				widget_content.body_text = Localize(side_mission_template.description)

				local rewards = data.extraRewards and data.extraRewards.sideMission

				if rewards then
					local has_xp_reward = rewards.xp and true or false
					local has_salary_rewards = rewards.credits and true or false
					local experience = has_xp_reward and tostring(math.floor(rewards.xp)) or ""
					local experience_text = has_xp_reward and string.format(" %s", experience) or ""
					local salary = has_salary_rewards and tostring(math.floor(rewards.credits)) or ""
					local salary_text = has_salary_rewards and string.format(" %s", salary) or ""

					widget_content.rewards_text = string.format("%s \t %s", salary_text, experience_text)
				end

				local style = widget.style
				local text_x_offset = 60
				local text_padding = 10
				local objective_header_style = style.objective_header
				local body_text_style = style.body_text
				local rewards_text_style = style.rewards_text

				objective_header_style.offset = {
					text_x_offset,
					0,
					1,
				}

				local _, objective_header_height = calculate_text_size(widget, "objective_header", ui_renderer)
				local body_text_y_offset = objective_header_height + text_padding

				body_text_style.offset = {
					text_x_offset,
					body_text_y_offset,
					1,
				}

				local _, body_text_height = calculate_text_size(widget, "body_text", ui_renderer)
				local reward_text_y_offset = body_text_y_offset + text_padding + body_text_height

				rewards_text_style.offset = {
					text_x_offset,
					reward_text_y_offset,
					1,
				}
			end,
		},
		circumstance = {
			size = {
				475,
				100,
			},
			pass_template = {
				{
					pass_type = "text",
					style_id = "circumstance_title",
					value_id = "circumstance_title",
				},
				{
					pass_type = "texture",
					style_id = "circumstance_icon",
					value_id = "circumstance_icon",
				},
				{
					pass_type = "text",
					style_id = "body_text",
					value_id = "body_text",
				},
			},
			style = blueprint_styles.circumstance,
			init = function (widget, data, ui_renderer)
				local circumstance = data.circumstance
				local circumstance_template = CircumstanceTemplates[circumstance]

				if not circumstance_template then
					return
				end

				local circumstance_ui_settings = circumstance_template.ui

				if not circumstance_ui_settings then
					return
				end

				local widget_content = widget.content

				widget_content.circumstance_title = Localize(circumstance_ui_settings.display_name)
				widget_content.circumstance_icon = circumstance_ui_settings.icon
				widget_content.body_text = circumstance_ui_settings.description and Localize(circumstance_ui_settings.description) or "n/a"

				local style = widget.style
				local text_x_offset = 60
				local text_y_offset = 30
				local text_padding = 10
				local circumstance_title_style = style.circumstance_title
				local body_text_style = style.body_text

				circumstance_title_style.offset = {
					text_x_offset,
					text_y_offset,
					1,
				}

				local _, circumstance_title_height = calculate_text_size(widget, "circumstance_title", ui_renderer)
				local _, body_text_height = calculate_text_size(widget, "body_text", ui_renderer)
				local body_text_y_offset = circumstance_title_height + text_padding + text_y_offset

				body_text_style.offset = {
					text_x_offset,
					body_text_y_offset,
					1,
				}
				widget.style.circumstance_icon.offset[2] = text_y_offset
				widget.size[2] = body_text_y_offset + body_text_height
			end,
		},
		category_name = {
			size = {
				515,
				50,
			},
			pass_template = {
				{
					pass_type = "text",
					style_id = "text",
					value_id = "text",
				},
			},
			style = blueprint_styles.category_name,
			init = function (widget, content)
				local title_text = content.title_text

				if Managers.localization:exists(title_text) then
					title_text = Managers.localization:localize(title_text)
				end

				widget.content.text = title_text
			end,
		},
		bonus = {
			size = {
				450,
				64,
			},
			pass_template = {
				{
					pass_type = "texture",
					style_id = "icon",
					value_id = "icon",
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
			style = blueprint_styles.detail,
		},
	},
	utility_functions = {},
}

local function get_havoc_mutators(mission_data)
	local mutators = {}

	for k, _ in pairs(mission_data.flags) do
		if string.find(k, "havoc%-circ%-") then
			mutators[#mutators + 1] = k
		end
	end

	if #mutators > 0 then
		return mutators
	else
		return nil
	end
end

details_widgets_blueprints.utility_functions.prepare_details_data = function (mission_data, include_mission_header)
	local details_data = {}
	local has_side_mission = has_side_mission(mission_data)

	details_data[#details_data + 1] = {
		template = "main_objective",
		widget_data = {
			map = mission_data.map,
			xp = mission_data.xp,
			credits = mission_data.credits,
		},
	}

	if has_side_mission then
		details_data[#details_data + 1] = {
			template = "side_mission",
			widget_data = {
				side_mission = mission_data.sideMission,
				extraRewards = mission_data.extraRewards,
			},
		}
	end

	do
		local circumstance = mission_data.circumstance
		local circumstance_ui_settings = CircumstanceTemplates[circumstance].ui

		if circumstance and circumstance ~= "default" and circumstance_ui_settings then
			details_data[#details_data + 1] = {
				template = "circumstance",
				widget_data = {
					circumstance = circumstance,
				},
			}
		end
	end

	do
		local havoc_mutators = get_havoc_mutators(mission_data)

		if havoc_mutators then
			for _, v in ipairs(havoc_mutators) do
				local circumstance = string.sub(v, 12)
				local circumstance_ui_settings = CircumstanceTemplates[circumstance].ui

				if circumstance_ui_settings then
					details_data[#details_data + 1] = {
						template = "circumstance",
						widget_data = {
							circumstance = circumstance,
						},
					}
				end
			end
		end
	end

	return details_data
end

details_widgets_blueprints.icons = icons
details_widgets_blueprints.button_strings = button_strings
details_widgets_blueprints.quickplay_data = quickplay_data

return details_widgets_blueprints
