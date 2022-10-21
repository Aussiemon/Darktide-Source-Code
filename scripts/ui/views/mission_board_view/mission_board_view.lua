local MissionBoardViewDefinitions = require("scripts/ui/views/mission_board_view/mission_board_view_definitions")
local MissionBoardViewSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local DangerSettings = require("scripts/settings/difficulty/danger_settings")
local DialogueSpeakerVoiceSettings = require("scripts/settings/dialogue/dialogue_speaker_voice_settings")
local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local PlayerVOStoryStage = require("scripts/utilities/player_vo_story_stage")
local Zones = require("scripts/settings/zones/zones")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local MissionBoardView = class("MissionBoardView", "BaseView")

MissionBoardView.init = function (self, settings)
	MissionBoardView.super.init(self, MissionBoardViewDefinitions, settings)

	self._mission_widgets = {}
	MissionBoardViewSettings.resource_renderer_enabled = false
	self._free_widget_positions = table.merge({}, MissionBoardViewSettings.mission_positions)
	self._allow_close_hotkey = true
	self._backend_data_expiry_time = -1
	self._cb_fetch_success = callback(self, "_fetch_success")
	self._cb_fetch_failure = callback(self, "_fetch_failure")
end

MissionBoardView.on_enter = function (self)
	MissionBoardView.super.on_enter(self)

	local narrative_manager = Managers.narrative
	local narrative_event_name = "onboarding_step_mission_board_introduction"

	if narrative_manager:can_complete_event(narrative_event_name) then
		narrative_manager:complete_event(narrative_event_name)
	end

	Managers.event:register(self, "event_register_camera", "event_register_camera")

	local world_spawner_settings = MissionBoardViewSettings.world_spawner_settings
	self._world_spawner = UIWorldSpawner:new(world_spawner_settings.world_name, world_spawner_settings.world_layer, world_spawner_settings.world_timer_name, self.view_name)

	self._world_spawner:spawn_level(world_spawner_settings.level_name)

	self._ui_resource_renderer = Managers.ui:create_renderer(MissionBoardViewSettings.resource_renderer_name, nil, true, self._ui_renderer.gui, self._ui_renderer.gui_retained, MissionBoardViewSettings.resource_renderer_material)

	self:on_resolution_modified(self._render_scale)

	local player = self:_player()
	local profile = player:profile()
	self._player_level = profile.current_level
	local party_manager = Managers.party_immaterium
	self._party_manager = party_manager
	self._selected_mission_id = nil
	local narrative_manager = Managers.narrative
	local narrative_event_name = "onboarding_step_mission_board_introduction"

	if narrative_manager:can_complete_event(narrative_event_name) then
		narrative_manager:complete_event(narrative_event_name)
	end
end

MissionBoardView.on_exit = function (self)
	MissionBoardView.super.on_exit(self)

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:destroy()

		self._world_spawner = nil
	end

	if self._ui_resource_renderer then
		Managers.ui:destroy_renderer(MissionBoardViewSettings.resource_renderer_name)

		self._ui_resource_renderer = nil
	end
end

MissionBoardView.update = function (self, dt, t, input_service)
	MissionBoardView.super.update(self, dt, t, input_service)
	self:_update_fetch_missions(t)
	self:_update_happening(t)

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end
end

MissionBoardView._handle_input = function (self, input_service, dt, t)
	MissionBoardView.super._handle_input(self, input_service, dt, t)

	local mission_widgets = self._mission_widgets

	for i = 1, #mission_widgets do
		local widget = mission_widgets[i]
		local hotspot = widget.content.hotspot

		if hotspot.on_pressed then
			self:_set_selected_mission(widget.content.mission)

			break
		end
	end

	if self._selected_mission_id and self._widgets_by_name.play_button.content.hotspot.on_released then
		self:_start_mission(self._selected_mission_id)
	end
end

MissionBoardView._set_selected_mission = function (self, mission)
	self._selected_mission_id = mission.id
	local mission_widgets = self._mission_widgets

	for i = 1, #mission_widgets do
		local content = mission_widgets[i].content
		content.hotspot.is_selected = content.mission.id == mission.id
	end

	local mission_template = MissionTemplates[mission.map]
	local danger = DangerSettings.calculate_danger(mission.challenge, mission.resistance)
	local is_locked = self._player_level < mission.requiredLevel
	local widget = self._widgets_by_name.detail
	widget.dirty = true
	local content = widget.content
	content.header_title = Utf8.upper(Localize(mission_template.mission_name))
	content.header_subtitle = Localize(Zones[mission_template.zone_id].name)
	content.danger = danger
	content.is_locked = is_locked
	content.start_game_time = mission.start_game_time
	content.expiry_game_time = mission.expiry_game_time - MissionBoardViewSettings.mission_time_grace_period
	local location_image_material_values = widget.style.location_image.material_values
	location_image_material_values.texture_map = mission_template.texture_big
	location_image_material_values.show_static = is_locked and 1 or 0
	local vo_profile = mission.missionGiver or mission_template.mission_brief_vo.vo_profile
	local speaker_settings = DialogueSpeakerVoiceSettings[vo_profile]
	local widget = self._widgets_by_name.objective_1
	widget.dirty = true
	local content = widget.content
	content.header_icon = mission_template.mission_type_icon
	content.header_subtitle = Localize(mission_template.mission_type_name)
	content.body_text = Localize(mission_template.mission_description)
	content.speaker_icon = speaker_settings.material_small
	content.speaker_text = Localize(speaker_settings.short_name)
	content.xp = mission.xp
	content.credits = mission.credits
	local side_mission_template = MissionObjectiveTemplates.side_mission.objectives[mission.sideMission]
	local widget = self._widgets_by_name.objective_2
	widget.dirty = true
	widget.visible = mission.flags.side and side_mission_template

	if widget.visible then
		local extraRewards = mission.extraRewards.sideMission
		local content = widget.content
		content.header_icon = side_mission_template.icon
		content.header_subtitle = Localize(side_mission_template.header)
		content.body_text = Localize(side_mission_template.description)
		content.speaker_text = nil
		content.speaker_icon = nil
		content.xp = extraRewards.xp
		content.credits = extraRewards.credits
	end
end

MissionBoardView._start_mission = function (self, backend_key)
	self._party_manager:wanted_mission_selected(backend_key)

	if Managers.narrative:complete_event(Managers.narrative.EVENTS.mission_board) then
		PlayerVOStoryStage.refresh_hub_story_stage()
	end

	Managers.ui:close_view(self.view_name)
end

MissionBoardView.draw = function (self, dt, t, input_service, layer)
	local ui_renderer = self:_begin_render_offscreen()

	UIRenderer.begin_pass(ui_renderer, self._ui_scenegraph, input_service, dt, self._render_settings)

	local mission_widgets = self._mission_widgets

	for i = 1, #mission_widgets do
		UIWidget.draw(mission_widgets[i], ui_renderer)
	end

	UIRenderer.end_pass(ui_renderer)
	self:_end_render_offscreen()
	MissionBoardView.super.draw(self, dt, t, input_service, layer)
end

MissionBoardView._begin_render_offscreen = function (self, dt, input_service)
	if not MissionBoardViewSettings.resource_renderer_enabled then
		return self._ui_renderer
	end

	local gui = self._ui_renderer.gui
	local ui_resource_renderer = self._ui_resource_renderer

	Gui.render_pass(gui, 0, ui_resource_renderer.base_render_pass, true, ui_resource_renderer.render_target)
	Gui.render_pass(gui, 1, "to_screen", false)

	return self._ui_resource_renderer
end

MissionBoardView._end_render_offscreen = function (self)
	if not MissionBoardViewSettings.resource_renderer_enabled then
		return
	end

	local gui = self._ui_renderer.gui
	local material = self._ui_resource_renderer.render_target_material

	Gui.bitmap(gui, material, "render_pass", "to_screen", Vector3(0, 0, 100), Vector2(Gui.resolution()))
end

MissionBoardView._destroy_mission_widget = function (self, widget)
	local content = widget.content
	local id = content.mission.id
	local mission_widgets = self._mission_widgets
	self._free_widget_positions[content.position.index] = content.position

	UIWidget.destroy(self._ui_resource_renderer, widget)
	table.swap_delete(mission_widgets, table.find(mission_widgets, widget))
	self:_unregister_widget_name(id)
end

MissionBoardView._join_mission_data = function (self, missions)
	local widgets_by_name = self._widgets_by_name
	local mission_widgets = self._mission_widgets

	for i = #mission_widgets, 1, -1 do
		local widget = mission_widgets[i]
		local id = widget.content.mission.id

		if not table.find_by_key(missions, "id", id) then
			self:_destroy_mission_widget(widget)
		end
	end

	local mission_S_widget_definition = MissionBoardViewDefinitions.mission_S_widget_definition

	for i = 1, #missions do
		local mission = missions[i]

		if widgets_by_name[mission.id] then
			-- Nothing
		else
			local position = self:_get_free_position(mission.displayIndex or math.random(#self._free_widget_positions))

			if position then
				local widget = self:_create_widget(mission.id, mission_S_widget_definition)

				if self:_populate_mission_widget(widget, mission, position) then
					mission_widgets[#mission_widgets + 1] = widget
				end
			else
				Log.warning("MissionBoardView", "Received more missions than can be shown on the mission board")
			end
		end
	end

	self:_set_selected_mission(missions[1])
end

MissionBoardView._get_free_position = function (self, preferred_index)
	local free_widget_positions = self._free_widget_positions
	local index = preferred_index
	local free_widget_positions_len = #free_widget_positions

	for i = 0, free_widget_positions_len do
		index = (index - 1 + 7 * i) % free_widget_positions_len + 1
		local position = free_widget_positions[index]

		if position then
			free_widget_positions[index] = false

			return position
		end
	end

	return false
end

MissionBoardView._populate_mission_widget = function (self, widget, mission, position)
	local mission_template = MissionTemplates[mission.map]

	if not mission_template then
		return false
	end

	widget.offset[1] = position[1]
	widget.offset[2] = position[2]
	local content = widget.content
	local style = widget.style
	content.mission = mission
	content.position = position
	local seed = math.floor(3511 * mission.start_game_time) + 68927 * math.floor(mission.expiry_game_time)
	local is_locked = self._player_level < mission.requiredLevel
	local location_image_material_values = style.location_image.material_values
	location_image_material_values.texture_map = mission_template.texture_small
	location_image_material_values.show_static = is_locked and 1 or 0
	local danger = DangerSettings.calculate_danger(mission.challenge, mission.resistance)
	local danger_settings = DangerSettings.by_index[danger]
	content.danger = danger
	content.is_locked = is_locked
	local circumstance = "assault_01"

	if mission.resistance ~= danger_settings.expected_resistance then
		if circumstance == "default" then
			if danger_settings.expected_resistance < mission.resistance then
				circumstance = "dummy_more_resistance_01"
			else
				circumstance = "dummy_less_resistance_01"
			end
		elseif circumstance ~= "dummy_less_resistance_01" and circumstance ~= "dummy_more_resistance_01" then
			Log.warning("MissionBoardView", "Mission with id %q has both a circumstance and a resistance change", mission.id)
		end
	end

	if circumstance ~= "default" then
		local circumstance_template = CircumstanceTemplates[circumstance]
		local circumstance_ui_data = circumstance_template and circumstance_template.ui

		if not circumstance_ui_data then
			return false
		end

		content.has_circumstance = true
		content.circumstance_name = Localize(circumstance_ui_data.display_name)
		content.circumstance_description = Localize(circumstance_ui_data.description)
		content.circumstance_icon = circumstance_ui_data.icon
	end

	content.objective_1_icon = mission_template.mission_type_icon
	local side_mission_template = MissionObjectiveTemplates.side_mission.objectives[mission.sideMission]
	content.objective_2_icon = mission.flags.side and side_mission_template and side_mission_template.icon
	content.start_game_time = mission.start_game_time
	content.expiry_game_time = mission.expiry_game_time - MissionBoardViewSettings.mission_time_grace_period
	content.fluff_frame = math.random_array_entry(MissionBoardViewSettings.fluff_frames, seed)

	return true
end

MissionBoardView.on_resolution_modified = function (self, scale)
	MissionBoardView.super.on_resolution_modified(self, scale)

	for _, widget in pairs(self._widgets_by_name) do
		widget.dirty = true
	end

	local material = self._ui_resource_renderer.render_target_material

	Material.set_scalar(material, "scanline_intensity", math.max(0.1, math.ilerp(0.6666666666666666, 1, scale)))
end

MissionBoardView.event_register_camera = function (self, camera_unit)
	Managers.event:unregister(self, "event_register_camera")

	local world_spawner_settings = MissionBoardViewSettings.world_spawner_settings
	self._camera_unit = camera_unit

	self._world_spawner:create_viewport(camera_unit, world_spawner_settings.viewport_name, world_spawner_settings.viewport_type, world_spawner_settings.viewport_layer, world_spawner_settings.viewport_shading_environment)
end

MissionBoardView._update_fetch_missions = function (self, t)
	if self._do_widget_refresh then
		self._do_widget_refresh = false

		self:_join_mission_data(self._backend_data.missions)

		return
	elseif t < self._backend_data_expiry_time or self._is_fetching_missions then
		return
	end

	self._is_fetching_missions = true
	local missions_future = Managers.data_service.mission_board:fetch(nil, 1)

	missions_future:next(self._cb_fetch_success):catch(self._cb_fetch_failure)
end

MissionBoardView._fetch_success = function (self, data)
	self._backend_data = data
	self._backend_data_expiry_time = data.expiry_game_time
	self._is_fetching_missions = false
	self._do_widget_refresh = true
end

MissionBoardView._fetch_failure = function (self, error_message)
	Log.error("MissionBoardView", "Fetching missions failed %s", error_message)

	self._backend_data_expiry_time = Managers.time:time("main") + MissionBoardViewSettings.fetch_retry_cooldown
	self._is_fetching_missions = false
end

local _time_table = {
	minutes = 12,
	seconds = 34
}

MissionBoardView._update_happening = function (self, t)
	local happening = self._backend_data and self._backend_data.happening
	local widget = self._widgets_by_name.happening
	widget.visible = not not happening

	if not happening then
		return
	end

	local time_left = math.max(0, happening.expiry_game_time - t)
	_time_table.seconds = time_left % 60
	_time_table.minutes = math.floor(time_left / 60)
	local content = widget.content
	content.subtitle = Localize("loc_mission_board_view_time_til_next_sync", true, _time_table)
end

return MissionBoardView
