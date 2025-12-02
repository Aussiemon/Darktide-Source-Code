-- chunkname: @scripts/ui/view_elements/view_element_mission_board_mission_location/view_element_mission_board_mission_location.lua

local Definitions = require("scripts/ui/view_elements/view_element_mission_board_mission_location/view_element_mission_board_mission_location_definitions")
local Settings = require("scripts/ui/view_elements/view_element_mission_board_mission_location/view_element_mission_board_mission_location_settings")
local Style = require("scripts/ui/view_elements/view_element_mission_board_mission_location/view_element_mission_board_mission_location_styles")
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
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIResolution = require("scripts/managers/ui/ui_resolution")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UIWidget = require("scripts/managers/ui/ui_widget")
local InputUtils = require("scripts/managers/input/input_utils")
local InputDevice = require("scripts/managers/input/input_device")
local Text = require("scripts/utilities/ui/text")
local ViewElementMissionBoardMissionLocation = class("ViewElementMissionBoardMissionLocation", "ViewElementBase")

ViewElementMissionBoardMissionLocation.init = function (self, parent, draw_layer, start_scale, context)
	ViewElementMissionBoardMissionLocation.super.init(self, parent, draw_layer, start_scale, Definitions)

	local ui_renderer = parent._ui_renderer

	self._ui_renderer = ui_renderer

	self:set_visibility(false)
end

ViewElementMissionBoardMissionLocation.update = function (self, dt, t, input_service)
	ViewElementMissionBoardMissionLocation.super.update(self, dt, t, input_service)
end

ViewElementMissionBoardMissionLocation._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ViewElementMissionBoardMissionLocation.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

ViewElementMissionBoardMissionLocation.destroy = function (self)
	ViewElementMissionBoardMissionLocation.super.destroy(self)
end

ViewElementMissionBoardMissionLocation.set_visibility = function (self, value)
	ViewElementMissionBoardMissionLocation.super.set_visibility(self, value)
end

ViewElementMissionBoardMissionLocation.on_mission_selected = function (self, mission)
	self._current_selected_mission = mission

	local parent = self:parent()
	local ui_theme = parent:_get_ui_theme()
	local palette_name = ui_theme.view_data.palette_name

	self:_update_mission_location(mission, palette_name)
end

ViewElementMissionBoardMissionLocation._update_mission_location = function (self, mission, palette_name)
	local mission_area_info = self._widgets_by_name.mission_area_info
	local mission_timer_bar = self._widgets_by_name.large_timer_bar
	local content = mission_area_info.content

	if not mission then
		if mission_area_info.visible then
			mission_area_info.visible = false
			mission_timer_bar.visible = false
			content.mission_id = nil
		end

		return
	end

	local title, sub_title, texture, is_locked, banner_text

	if mission == "qp_mission_widget" then
		content.mission_id = mission
		title = Localize("loc_mission_board_quickplay_header")
		sub_title = Localize("loc_mission_board_view_header_tertium_hive")
		texture = "content/ui/textures/pj_missions/quickplay_medium"
		is_locked = false
	else
		content.mission_id = mission.id

		local mission_template = MissionTemplates[mission.map]

		title = Localize(mission_template.mission_name)
		sub_title = Localize(Zones[mission_template.zone_id].name)
		texture = mission_template.texture_medium

		local parent = self:parent()

		is_locked = parent._mission_board_logic:is_mission_locked(mission)

		local flags = mission.flags
		local is_flash = not not flags.flash

		banner_text = is_flash and Localize("loc_mission_board_maelstrom_header") or nil
	end

	local style = mission_area_info.style

	content.mission_title = title
	content.mission_sub_title = sub_title
	content.is_locked = not not is_locked
	content.banner_text = banner_text
	style.image.material_values = {
		texture_map = texture,
		show_static = is_locked and 1 or 0,
	}

	if not mission_area_info.visible then
		mission_area_info.visible = true
	end

	local timer_bar_content = mission_timer_bar.content

	if mission_timer_bar and mission ~= "qp_mission_widget" then
		timer_bar_content.is_quickplay = false
		timer_bar_content.start_game_time = mission.start_game_time
		timer_bar_content.expiry_game_time = mission.expiry_game_time
	elseif mission_timer_bar and mission == "qp_mission_widget" then
		timer_bar_content.start_game_time = nil
		timer_bar_content.expiry_game_time = nil
		timer_bar_content.is_quickplay = true
		mission_timer_bar.style.timer_bar.material_values = {
			progress = 1,
		}
	end

	if not mission_timer_bar.visible then
		mission_timer_bar.visible = true
	end

	if not self._mission_area_enter_anim_id then
		self._mission_area_enter_anim_id = self:_start_animation("mission_area_info_enter")
	end
end

return ViewElementMissionBoardMissionLocation
