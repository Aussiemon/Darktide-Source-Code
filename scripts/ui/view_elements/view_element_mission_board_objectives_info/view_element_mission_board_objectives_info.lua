-- chunkname: @scripts/ui/view_elements/view_element_mission_board_objectives_info/view_element_mission_board_objectives_info.lua

local Definitions = require("scripts/ui/view_elements/view_element_mission_board_objectives_info/view_element_mission_board_objectives_info_definitions")
local Settings = require("scripts/ui/view_elements/view_element_mission_board_objectives_info/view_element_mission_board_objectives_info_settings")
local Styles = require("scripts/ui/view_elements/view_element_mission_board_objectives_info/view_element_mission_board_objectives_info_styles")
local MissionBoardSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local DialogueSpeakerVoiceSettings = require("scripts/settings/dialogue/dialogue_speaker_voice_settings")
local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local MissionTypes = require("scripts/settings/mission/mission_types")
local PlayerVOStoryStage = require("scripts/utilities/player_vo_story_stage")
local Zones = require("scripts/settings/zones/zones")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local DangerSettings = require("scripts/settings/difficulty/danger_settings")
local CampaignSettings = require("scripts/settings/campaign/campaign_settings")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIResolution = require("scripts/managers/ui/ui_resolution")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UIWidget = require("scripts/managers/ui/ui_widget")
local InputUtils = require("scripts/managers/input/input_utils")
local InputDevice = require("scripts/managers/input/input_device")
local Text = require("scripts/utilities/ui/text")
local ViewElementMissionBoardObjectivesInfo = class("ViewElementMissionBoardObjectivesInfo", "ViewElementBase")

ViewElementMissionBoardObjectivesInfo.init = function (self, parent, draw_layer, start_scale, context)
	ViewElementMissionBoardObjectivesInfo.super.init(self, parent, draw_layer, start_scale, Definitions)

	local ui_renderer = parent._ui_renderer

	self._ui_renderer = ui_renderer
	self._reward_widgets = {}
	self._objectives_tabs = {}
	self._sidebar_key_is_active = {}

	self:set_visibility(false)
end

ViewElementMissionBoardObjectivesInfo.update = function (self, dt, t, input_service)
	ViewElementMissionBoardObjectivesInfo.super.update(self, dt, t, input_service)
	self:_update_panel_tabs_offset(dt, t)
end

ViewElementMissionBoardObjectivesInfo._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ViewElementMissionBoardObjectivesInfo.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	if self._objectives_tabs then
		for i = 1, #self._objectives_tabs do
			local widget = self._objectives_tabs[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	if self._reward_widgets then
		for i = 1, #self._reward_widgets do
			local widget = self._reward_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end
end

ViewElementMissionBoardObjectivesInfo.destroy = function (self)
	ViewElementMissionBoardObjectivesInfo.super.destroy(self)
end

ViewElementMissionBoardObjectivesInfo.set_visibility = function (self, value)
	ViewElementMissionBoardObjectivesInfo.super.set_visibility(self, value)
end

ViewElementMissionBoardObjectivesInfo.on_mission_selected = function (self, mission)
	self._current_selected_mission = mission

	local parent = self:parent()
	local ui_theme = parent:_get_ui_theme()
	local palette_name = ui_theme.view_data.palette_name

	self._current_tab_name = nil

	self:_update_mission_objective_info_panel(mission, palette_name)

	local has_circumstance = mission ~= "qp_mission_widget" and mission.circumstance ~= "default" and mission.circumstance ~= "none"
	local is_story = mission ~= "qp_mission_widget" and mission.category == "story"

	if has_circumstance and is_story then
		self:_set_sidebar_tab("story")
	elseif has_circumstance then
		self:_set_sidebar_tab("circumstance")
	else
		self:_set_sidebar_tab("main_objective")
	end
end

ViewElementMissionBoardObjectivesInfo._update_mission_objective_info_panel = function (self, mission, palette_name)
	if not mission then
		table.clear(self._objectives_tabs)
		table.clear(self._sidebar_key_is_active)

		return
	end

	local title, sub_title, icon

	self._objectives_tabs.palette_name = palette_name

	if mission == "qp_mission_widget" then
		if self._objectives_tabs.mission_id ~= mission then
			table.clear(self._objectives_tabs)
			table.clear(self._sidebar_key_is_active)

			self._objectives_tabs.palette_name = palette_name
			self._objectives_tabs.mission_id = mission
			icon = "content/ui/materials/icons/mission_types_pj/mission_type_quick"
			title = Localize("loc_mission_board_quickplay_header")
			sub_title = Localize("loc_misison_board_main_objective_title")

			local sidebar_width = MissionBoardSettings.dimensions.details_width
			local tab_default_size = Settings.default_tab_size
			local tab_width = tab_default_size[1]
			local active_tab_width = sidebar_width
			local active_tab_size = {
				active_tab_width,
				Settings.panel_height,
			}
			local tab_idx = 1
			local widget = self:_create_panel_widget(title, sub_title, icon, "main_objective", tab_idx, active_tab_size, tab_width)
			local content = widget.content

			content.selection_progress = 1
		end
	elseif self._objectives_tabs.mission_id ~= mission.id then
		table.clear(self._objectives_tabs)
		table.clear(self._sidebar_key_is_active)

		self._objectives_tabs.mission_id = mission.id
		self._objectives_tabs.palette_name = palette_name

		local parent = self:parent()
		local has_side_mission = not not mission.sideMission
		local has_circumstance = mission.circumstance ~= "default" and mission.circumstance ~= "none"
		local tabs = Settings.sidebar_tabs
		local num_tabs = 1

		if has_circumstance then
			num_tabs = num_tabs + 1
		end

		if has_side_mission then
			num_tabs = num_tabs + 1
		end

		local sidebar_width = MissionBoardSettings.dimensions.details_width
		local tab_default_size = Settings.default_tab_size
		local tab_width = tab_default_size[1]
		local active_tab_width = sidebar_width - tab_width * (num_tabs - 1)
		local active_tab_size = {
			active_tab_width,
			68,
		}
		local tab_idx = 1
		local objective_template
		local has_tab = false

		if has_circumstance then
			local category = mission.category
			local is_story = category == "story"
			local unlock_data = parent._mission_board_logic:get_mission_unlock_data(mission.map, category)
			local circumstance = mission.circumstance
			local circumstance_template = CircumstanceTemplates[circumstance]
			local circumstance_ui_data = circumstance_template and circumstance_template.ui

			if is_story then
				local icon_settings = MissionBoardSettings.mission_category_icons[category] or MissionBoardSettings.mission_category_icons.undefined

				icon = icon_settings.mission_board_icon

				if unlock_data and unlock_data.unlocked then
					title = circumstance_ui_data and Localize(circumstance_ui_data.display_name) or "n/a"
					sub_title = ""
				elseif unlock_data and unlock_data.unlocked == false then
					title = Localize("loc_redacted_generic")
					sub_title = ""
				end
			else
				icon = circumstance_ui_data and (circumstance_ui_data.mission_board_icon or circumstance_ui_data.icon) or "content/ui/materials/icons/mission_types_pj/mission_type_undefined"
				title = circumstance_ui_data and Localize(circumstance_ui_data.display_name) or "n/a"
				sub_title = ""
			end

			local widget = self:_create_panel_widget(title, sub_title, icon, is_story and "story" or "circumstance", tab_idx, active_tab_size, tab_width)
			local style = widget.style
			local content = widget.content

			if is_story then
				local icon_style = style.icon
				local gradient_by_category = Styles.gradient_by_category.story or Styles.gradient_by_category.default

				icon_style.material_values = {}
				icon_style.material_values.gradient_map = gradient_by_category.selected_gradient
			end

			style.frame.color = table.shallow_copy(Styles.colors.theme_colors[is_story and "story" or "circumstance"] or Styles.colors.theme_colors.default)
			style.background_gradient.color = table.shallow_copy(Styles.colors.theme_colors[is_story and "story" or "circumstance"] or Styles.colors.theme_colors.default)

			local story_mission_colors = table.shallow_copy(Styles.colors.color_by_mission_type.story)
			local title_text_color = is_story and story_mission_colors.selected_color or MissionBoardSettings.adjust_color(Styles.colors.theme_colors.circumstance, 1)

			style.objectives_panel_title.text_color = title_text_color
			style.objectives_panel_title.horizontal_alignment = "left"
			style.objectives_panel_title.vertical_alignment = "center"
			style.objectives_panel_title.text_horizontal_alignment = "left"
			style.objectives_panel_title.text_vertical_alignment = "center"
			style.objectives_panel_title.offset = {
				68,
				0,
				5,
			}
			tab_idx = tab_idx + 1
		end

		do
			local mission_template = MissionTemplates[mission.map]

			objective_template = MissionTypes[mission_template.mission_type]
			title = Localize(objective_template.name)
			sub_title = Localize("loc_misison_board_main_objective_title")
			icon = objective_template.mission_board_icon or objective_template.icon

			local widget = self:_create_panel_widget(title, sub_title, icon, "main_objective", tab_idx, active_tab_size, tab_width)
			local content = widget.content

			tab_idx = tab_idx + 1
		end

		if has_side_mission then
			local side_mission_name = mission.sideMission

			objective_template = MissionObjectiveTemplates.side_mission.objectives[side_mission_name]
			title = Localize(objective_template.header)
			sub_title = Localize("loc_mission_board_side_objective_title")
			icon = objective_template.mission_board_icon or objective_template.icon

			local widget = self:_create_panel_widget(title, sub_title, icon, "side_objective", tab_idx, active_tab_size, tab_width)
			local content = widget.content

			tab_idx = tab_idx + 1
		end
	end
end

ViewElementMissionBoardObjectivesInfo._create_panel_widget = function (self, title, sub_title, icon, tab_id, tab_idx, active_tab_size, tab_width)
	self._sidebar_key_is_active[tab_id] = not not self._sidebar_key_is_active[tab_id]

	local default_size = Settings.default_tab_size
	local widget_definition = Definitions.create_objectives_panel_widget("_mission_objectives_panel", title, sub_title, icon, default_size, active_tab_size)
	local widget = UIWidget.init("mission_objectives_tab_" .. tab_idx, widget_definition)

	widget.offset[1] = (tab_idx - 1) * tab_width

	local content = widget.content

	content.tab_id = tab_id
	content.tab_index = tab_idx
	content.theme_color = table.shallow_copy(Styles.colors.theme_colors[tab_id] or Styles.colors.theme_colors.default)
	content.hotspot.pressed_callback = callback(self, "_set_sidebar_tab", tab_id)
	self._objectives_tabs[#self._objectives_tabs + 1] = widget

	return widget
end

ViewElementMissionBoardObjectivesInfo._update_mission_objective_info = function (self, mission, palette_name)
	local info_widget = self._widgets_by_name.mission_objective_info

	if not mission then
		if info_widget.visible then
			info_widget.visible = false

			local content = info_widget.content

			content.active_tab = nil
			content.mission_id = nil

			table.clear(self._reward_widgets)
		end

		return
	end

	local tab_id = self._current_tab_name
	local content = info_widget.content
	local style = info_widget.style

	if mission == "qp_mission_widget" then
		table.clear(self._reward_widgets)

		content.mission_id = mission
		content.active_tab = tab_id

		local text = Localize("loc_mission_board_quickplay_description")

		content.objective_description = text
		content.is_quickplay_mission = true
		content.has_mission_giver = false

		local parent = self:parent()
		local bonus_data = parent._mission_board_logic:get_bonus_data("quickplay")

		if bonus_data then
			local offset_mod = 0
			local size_multiplier = 1 / #Settings.currency_order
			local size = {
				MissionBoardSettings.dimensions.details_width * size_multiplier,
				MissionBoardSettings.dimensions.rewards_height,
			}

			for _, currency_type in ipairs(Settings.currency_order) do
				local amount = bonus_data[currency_type]
				local amount_text = "+ " .. amount .. "%"
				local icon = Settings.currency_icons[currency_type]
				local reward_definition = Definitions.create_reward_widget("_mission_rewards_panel", amount_text, icon, size)
				local widget = UIWidget.init("reward_" .. currency_type, reward_definition)

				widget.offset[1] = size[1] * offset_mod
				offset_mod = offset_mod + 1
				self._reward_widgets[#self._reward_widgets + 1] = widget
			end
		end
	else
		table.clear(self._reward_widgets)

		content.active_tab = tab_id
		content.mission_id = mission.id

		local xp, credits

		if tab_id then
			if tab_id == "circumstance" or tab_id == "story" then
				local category = mission.category
				local is_story = category == "story"
				local circumstance = mission.circumstance
				local circumstance_template = CircumstanceTemplates[circumstance]
				local circumstance_ui_data = circumstance_template and circumstance_template.ui
				local parent = self:parent()
				local unlock_data = parent._mission_board_logic:get_mission_unlock_data(mission.map, category)
				local circumstance_description = "???"

				if is_story then
					if unlock_data and unlock_data.unlocked then
						circumstance_description = circumstance_ui_data and Localize(circumstance_ui_data.description) or "n/a"
					elseif unlock_data and unlock_data.unlocked == false then
						circumstance_description = "???"
					end
				else
					circumstance_description = circumstance_ui_data and Localize(circumstance_ui_data.description) or "n/a"
				end

				content.objective_description = circumstance_description
				content.has_mission_giver = false
				content.is_quickplay_mission = false
			elseif tab_id == "main_objective" then
				local mission_template = MissionTemplates[mission.map]
				local objective_template = MissionTypes[mission_template.mission_type]
				local mission_description = Localize(mission_template.mission_description)

				content.objective_description = mission_description
				xp, credits = mission.xp, mission.credits

				local circumstance_rewards = mission.extraRewards.circumstance

				if circumstance_rewards then
					xp, credits = xp + circumstance_rewards.xp, credits + circumstance_rewards.credits
				end

				local vo_profile = mission.missionGiver or mission_template.mission_brief_vo.vo_profile
				local speaker_settings = DialogueSpeakerVoiceSettings[vo_profile]
				local text = string.format(">  %s", Localize(speaker_settings.full_name))
				local speaker_image = speaker_settings.material_small

				content.mission_giver_icon = speaker_image
				content.mission_giver_name = text
				content.has_mission_giver = true
				content.is_quickplay_mission = false
			elseif tab_id == "side_objective" then
				content.has_mission_giver = false
				content.is_quickplay_mission = false

				local side_mission_name = mission.sideMission
				local objective_template = MissionObjectiveTemplates.side_mission.objectives[side_mission_name]

				if not objective_template or not mission.flags.side then
					return
				end

				local text = Localize(objective_template.description)

				content.objective_description = text

				local side_rewards = mission.extraRewards.sideMission

				if side_rewards then
					xp, credits = side_rewards.xp, side_rewards.credits
				end
			end

			if xp or credits then
				local size = {
					MissionBoardSettings.dimensions.details_width * 0.24,
					MissionBoardSettings.dimensions.rewards_height,
				}
				local offset_mod = 0

				if credits then
					local amount = type(credits) == "number" and Text.format_currency(credits) or credits
					local icon = Settings.currency_icons.credits
					local credits_definition = Definitions.create_reward_widget("_mission_rewards_panel", amount, icon, size)
					local widget = UIWidget.init("credits_reward", credits_definition)

					widget.offset[1] = size[1] * offset_mod
					offset_mod = offset_mod + 1
					self._reward_widgets[#self._reward_widgets + 1] = widget
				end

				if xp then
					local amount = type(xp) == "number" and Text.format_currency(xp) or xp
					local icon = Settings.currency_icons.xp
					local xp_definition = Definitions.create_reward_widget("_mission_rewards_panel", amount, icon, size)
					local widget = UIWidget.init("xp_reward", xp_definition)

					widget.offset[1] = size[1] * offset_mod
					offset_mod = offset_mod + 1
					self._reward_widgets[#self._reward_widgets + 1] = widget
				end
			end
		end
	end

	content.theme_color = table.shallow_copy(Styles.colors.theme_colors[tab_id] or Styles.colors.theme_colors.default)

	if not self._description_enter_anim_id then
		self._description_enter_anim_id = self:_start_animation("info_description_enter")
	else
		self:_stop_animation(self._description_enter_anim_id)

		self._description_enter_anim_id = nil
		self._description_enter_anim_id = self:_start_animation("info_description_enter")
	end

	info_widget.visible = true
end

ViewElementMissionBoardObjectivesInfo._set_sidebar_tab = function (self, target_tab_name)
	if self._current_tab_name == target_tab_name then
		return
	end

	local sidebar_key_is_active = self._sidebar_key_is_active

	for _, tab_name in ipairs(Settings.sidebar_tabs) do
		if sidebar_key_is_active[tab_name] ~= nil then
			self:_set_sidebar_key_active(tab_name, target_tab_name == tab_name)
		end
	end

	local objectives_tabs = self._objectives_tabs

	if objectives_tabs then
		for i = 1, #objectives_tabs do
			local widget = objectives_tabs[i]
			local content = widget.content
			local hotspot = content.hotspot
			local is_selected = content.tab_id == target_tab_name

			hotspot.is_selected = is_selected
		end
	end

	self._current_tab_name = target_tab_name

	self:_update_mission_objective_info(self._current_selected_mission, self._objectives_tabs.palette_name)
end

ViewElementMissionBoardObjectivesInfo._set_sidebar_key_active = function (self, key_name, active)
	self._sidebar_key_is_active[key_name] = active
end

ViewElementMissionBoardObjectivesInfo.get_active_sidebar_tab = function (self)
	return self._current_tab_name
end

ViewElementMissionBoardObjectivesInfo.has_sidebar_tabs = function (self)
	local has_a_tab = false
	local sidebar_key_is_active = self._sidebar_key_is_active

	for _, name in ipairs(Settings.sidebar_tabs) do
		local has_entries = sidebar_key_is_active[name] ~= nil and #self._objectives_tabs > 1

		if has_entries and has_a_tab then
			return true
		end

		has_a_tab = has_a_tab or has_entries
	end

	return false
end

ViewElementMissionBoardObjectivesInfo.set_next_sidebar_tab = function (self)
	local sidebar_tabs = Settings.sidebar_tabs
	local current_tab_name = self._current_tab_name
	local current_tab_index = table.index_of(sidebar_tabs, current_tab_name)

	if current_tab_index == -1 then
		current_tab_index = 0
	end

	local sidebar_tab_count = #sidebar_tabs
	local sidebar_key_is_active = self._sidebar_key_is_active

	for i = 1, sidebar_tab_count do
		local tab_index = current_tab_index + i

		if sidebar_tab_count < tab_index then
			tab_index = tab_index - sidebar_tab_count
		end

		local tab_name = sidebar_tabs[tab_index]

		if sidebar_key_is_active[tab_name] ~= nil then
			return self:_set_sidebar_tab(tab_name)
		end
	end

	self:_set_sidebar_tab()
end

ViewElementMissionBoardObjectivesInfo._update_panel_tabs_offset = function (self, dt, t)
	local cumulative_offset = 0
	local tot_size = 0

	for i = 1, #self._objectives_tabs do
		local widget = self._objectives_tabs[i]
		local content = widget.content
		local hotspot = content.hotspot
		local is_selected = hotspot.is_selected
		local selection_progress = content.selection_progress or 0

		if is_selected and selection_progress <= 1 then
			selection_progress = math.min(selection_progress + 8 * dt, 1)
		else
			selection_progress = math.max(selection_progress - 8 * dt, 0)
		end

		local hover_progress = content.hover_progress or 0

		if hotspot.is_hover and not is_selected and hover_progress <= 1 then
			hover_progress = math.min(hover_progress + 6.5 * dt, 1)
		else
			hover_progress = math.max(hover_progress - 6.5 * dt, 0)
		end

		content.hover_progress = hover_progress
		content.selection_progress = selection_progress

		local style = widget.style
		local previous_tab = self._objectives_tabs[i - 1]

		if previous_tab then
			local previous_content = previous_tab.content

			cumulative_offset = cumulative_offset + previous_content.size[1]
		end

		widget.offset[1] = cumulative_offset
		content.size[1] = math.clamp(content.default_size[1] + (content.active_size[1] - content.default_size[1]) * selection_progress, content.default_size[1], content.active_size[1])
		content.size[2] = math.clamp(content.default_size[2] + (content.active_size[2] - content.default_size[2]) * selection_progress, content.default_size[2], content.active_size[2])
		content.size[2] = selection_progress <= 0 and content.default_size[2] + 10 * hover_progress or content.size[2]
		widget.offset[2] = content.active_size[2] - content.size[2]

		local icon_style = style.icon

		icon_style.size[1] = math.clamp(icon_style.inactive_size[1] + (icon_style.active_size[1] - icon_style.inactive_size[1]) * selection_progress, icon_style.inactive_size[1], icon_style.active_size[1])
		icon_style.size[2] = math.clamp(icon_style.inactive_size[2] + (icon_style.active_size[2] - icon_style.inactive_size[2]) * selection_progress, icon_style.inactive_size[2], icon_style.active_size[2])
		icon_style.offset[1] = 10 + (icon_style.active_size[1] - icon_style.inactive_size[1]) * (1 - selection_progress) * 0.5

		if not style.objectives_panel_title.size then
			style.objectives_panel_title.size = {
				0,
				0,
			}
		end

		style.objectives_panel_title.size[1] = content.size[1] - 68
		style.objectives_panel_title.size[2] = content.size[2]

		local num_title_characters = content.title_text_num_characters or Utf8.string_length(content.default_title_text) or 0
		local char_index = math.floor(num_title_characters * selection_progress)

		content.objectives_panel_title = string.sub(content.default_title_text, 1, char_index)

		if content.default_sub_title_text ~= "" then
			local num_subtitle_characters = content.sub_title_text_num_characters or Utf8.string_length(content.default_sub_title_text) or 0
			local sub_char_index = math.floor(num_subtitle_characters * selection_progress)

			content.objectives_panel_sub_title = string.sub(content.default_sub_title_text, 1, sub_char_index)
		else
			content.objectives_panel_sub_title = ""
		end
	end
end

return ViewElementMissionBoardObjectivesInfo
