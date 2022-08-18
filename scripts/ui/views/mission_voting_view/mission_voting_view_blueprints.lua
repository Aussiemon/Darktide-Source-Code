local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local ViewStyles = require("scripts/ui/views/mission_voting_view/mission_voting_view_styles")
local MissionBoardSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local MissionSettings = require("scripts/settings/mission/mission_templates")
local MutatorTemplates = require("scripts/settings/mutator/mutator_templates")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ZoneSettings = require("scripts/settings/zones/zones")
local Localizer = Managers.localization
local blueprint_styles = ViewStyles.blueprints

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

	for i = 1, #mutators, 1 do
		local mutator_name = mutators[i]
		local mutator = MutatorTemplates[mutator_name]
		local descriptions = mutator.description

		for j = 1, #descriptions, 1 do
			descriptors[#descriptors + 1] = Localizer:localize(descriptions[j])
		end
	end

	local formatted_description = ""

	for i = 1, #descriptors, 1 do
		formatted_description = formatted_description .. string.format("· %s\n", descriptors[i])
	end

	local widget_content = widget.content
	widget_content.icon = circumstance_template.ui.icon
	widget_content.title = Localizer:localize(circumstance_template.ui.display_name)
	widget_content.description = formatted_description
	local widget_size = widget.content.size
	local _, title_height = calculate_text_size(widget, "title", ui_renderer)
	local _, description_height = calculate_text_size(widget, "description", ui_renderer)
	local description_offset = widget.style.description.offset
	description_offset[2] = description_offset[2] + title_height + widget.style.title.offset[2]
	local bottom_margin = 10
	local total_text_height = description_offset[2] + description_height + bottom_margin

	if widget_size[2] < total_text_height then
		widget_size[2] = total_text_height
	end
end

local details_widgets_blueprints = {
	templates = {
		mission_header = {
			size = {
				515,
				75
			},
			pass_template = {
				{
					style_id = "mission_name",
					value_id = "mission_name",
					pass_type = "text"
				},
				{
					style_id = "type_and_zone",
					value_id = "type_and_zone",
					pass_type = "text"
				}
			},
			style = blueprint_styles.mission_header,
			init = function (widget, data)
				local mission_settings = MissionSettings[data.map]
				local zone_settings = ZoneSettings[mission_settings.zone_id]
				local mission_title = (mission_settings.mission_name and Localizer:localize(mission_settings.mission_name)) or data.map
				local zone_name = Localizer:localize(zone_settings.name)
				local main_objective_type = (mission_settings.objectives and MissionObjectiveTemplates[mission_settings.objectives].main_objective_type) or "default"
				local main_objective_type_header_key = MissionBoardSettings.main_objective_type_name[main_objective_type]
				local main_objective_type_header = Managers.localization:localize(main_objective_type_header_key)
				local widget_content = widget.content
				widget_content.mission_name = mission_title
				widget_content.type_and_zone = string.format("%s · %s", main_objective_type_header, zone_name)
			end
		},
		base_reward = {
			size = {
				515,
				60
			},
			pass_template = {
				{
					style_id = "header",
					pass_type = "text",
					value = Managers.localization:localize("loc_mission_board_details_view_base_reward")
				},
				{
					value = "content/ui/materials/icons/generic/experience_rendered",
					value_id = "experience_icon",
					pass_type = "texture",
					style_id = "experience_icon"
				},
				{
					style_id = "experience_text",
					value_id = "experience_text",
					pass_type = "text"
				},
				{
					value = "content/ui/materials/icons/generic/credits_rendered",
					value_id = "credits_icon",
					pass_type = "texture",
					style_id = "credits_icon"
				},
				{
					style_id = "credits_text",
					value_id = "credits_text",
					pass_type = "text"
				}
			},
			style = blueprint_styles.base_reward,
			init = function (widget, content, ui_renderer)
				local widget_content = widget.content
				widget_content.experience_text = tostring(content.xp)
				widget_content.credits_text = tostring(content.credits)
				local style = widget.style
				local xp_text_width = calculate_text_size(widget, "experience_text", ui_renderer)
				local xp_text_style = style.experience_text
				local credits_icon_style = style.credits_icon
				credits_icon_style.offset[1] = xp_text_style.offset[1] + xp_text_width + credits_icon_style.base_margin_left
				local credits_text_style = style.credits_text
				credits_text_style.offset[1] = credits_icon_style.offset[1] + credits_icon_style.size[1] + credits_icon_style.base_margin_right
			end
		},
		circumstance = {
			size = {
				515,
				50
			},
			pass_template = {
				{
					style_id = "header",
					pass_type = "text",
					value = Managers.localization:localize("loc_mission_board_details_view_circumstance")
				},
				{
					style_id = "icon",
					value_id = "icon",
					pass_type = "texture"
				},
				{
					style_id = "title",
					value_id = "title",
					pass_type = "text"
				},
				{
					style_id = "description",
					value_id = "description",
					pass_type = "text"
				}
			},
			style = blueprint_styles.circumstance,
			init = circumstance_init_function
		},
		category_name = {
			size = {
				515,
				50
			},
			pass_template = {
				{
					style_id = "text",
					value_id = "text",
					pass_type = "text"
				}
			},
			style = blueprint_styles.category_name,
			init = function (widget, content)
				local title_text = content.title_text

				if Managers.localization:exists(title_text) then
					title_text = Managers.localization:localize(title_text)
				end

				widget.content.text = title_text
			end
		},
		bonus = {
			size = {
				450,
				64
			},
			pass_template = {
				{
					style_id = "icon",
					value_id = "icon",
					pass_type = "texture"
				},
				{
					style_id = "title",
					value_id = "title",
					pass_type = "text"
				},
				{
					style_id = "description",
					value_id = "description",
					pass_type = "text"
				}
			},
			style = blueprint_styles.detail
		}
	},
	utility_functions = {}
}

details_widgets_blueprints.utility_functions.prepare_details_data = function (mission_data, include_mission_header)
	local details_data = {}

	if include_mission_header then
		details_data[1] = {
			template = "mission_header",
			widget_data = {
				map = mission_data.map
			}
		}
	end

	details_data[#details_data + 1] = {
		template = "base_reward",
		widget_data = {
			xp = mission_data.xp,
			credits = mission_data.credits
		}
	}
	local circumstance = mission_data.circumstance

	if circumstance and circumstance ~= "default" then
		details_data[#details_data + 1] = {
			template = "circumstance",
			widget_data = {
				circumstance = circumstance
			}
		}
	end

	return details_data
end

return details_widgets_blueprints
