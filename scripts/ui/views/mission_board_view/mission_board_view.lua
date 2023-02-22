local MissionBoardViewDefinitions = require("scripts/ui/views/mission_board_view/mission_board_view_definitions")
local MissionBoardViewSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local DangerSettings = require("scripts/settings/difficulty/danger_settings")
local DialogueSpeakerVoiceSettings = require("scripts/settings/dialogue/dialogue_speaker_voice_settings")
local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local MissionTypes = require("scripts/settings/mission/mission_types")
local PlayerVOStoryStage = require("scripts/utilities/player_vo_story_stage")
local Zones = require("scripts/settings/zones/zones")
local InputDevice = require("scripts/managers/input/input_device")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local Promise = require("scripts/foundation/utilities/promise")
local MissionBoardView = class("MissionBoardView", "BaseView")

MissionBoardView.init = function (self, settings)
	MissionBoardView.super.init(self, MissionBoardViewDefinitions, settings)

	self._mission_widgets = {}
	self.can_start_mission = false
	self._free_widget_positions = table.merge({}, MissionBoardViewSettings.mission_positions)
	self._allow_close_hotkey = true
	self._backend_data_expiry_time = -1
	self._has_queued_missions = false
	self._queued_mission_show_time = math.huge
	self._game_settings_visible = false
	self._gamepad_cursor_current_pos = Vector3Box(960, 540)
	self._gamepad_cursor_current_vel = Vector3Box()
	self._gamepad_cursor_target_pos = Vector3Box()
	self._gamepad_cursor_average_vel = Vector3Box()
	self._gamepad_cursor_snap_delay = 0
	self._cb_fetch_success = callback(self, "_fetch_success")
	self._cb_fetch_failure = callback(self, "_fetch_failure")
end

MissionBoardView.on_enter = function (self)
	MissionBoardView.super.on_enter(self)
	Managers.event:register(self, "event_register_camera", "event_register_camera")

	local world_spawner_settings = MissionBoardViewSettings.world_spawner_settings
	self._world_spawner = UIWorldSpawner:new(world_spawner_settings.world_name, world_spawner_settings.world_layer, world_spawner_settings.world_timer_name, self.view_name)

	self._world_spawner:spawn_level(world_spawner_settings.level_name)

	self._ui_resource_renderer = Managers.ui:create_renderer(MissionBoardViewSettings.resource_renderer_name, nil, true, self._ui_renderer.gui, self._ui_renderer.gui_retained, MissionBoardViewSettings.resource_renderer_material)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 40)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end

	self:on_resolution_modified(self._render_scale)

	local player = self:_player()
	local profile = player:profile()
	self._player_level = profile.current_level
	local party_manager = Managers.party_immaterium
	self._party_manager = party_manager
	local narrative_manager = Managers.narrative
	local narrative_event_name = "onboarding_step_mission_board_introduction"

	if narrative_manager:can_complete_event(narrative_event_name) then
		narrative_manager:complete_event(narrative_event_name)
	end

	self._quickplay_widget = self:_create_widget("quickplay", MissionBoardViewDefinitions.mission_medium_widget_template)
	self._quickplay_widget.offset[1] = MissionBoardViewSettings.quickplay_mission_position[1]
	self._quickplay_widget.offset[2] = MissionBoardViewSettings.quickplay_mission_position[2]
	local quickplay_content = self._quickplay_widget.content
	quickplay_content.objective_icon = "content/ui/materials/icons/mission_types/mission_type_09"
	quickplay_content.objective_2_icon = nil
	quickplay_content.circumstance_icon = nil
	quickplay_content.is_quickplay = true
	self._mission_widgets[-1] = self._quickplay_widget
	self._flash_mission_widget = self:_create_widget("flash", MissionBoardViewDefinitions.mission_medium_widget_template)
	self._flash_mission_widget.offset[1] = MissionBoardViewSettings.flash_mission_position[1]
	self._flash_mission_widget.offset[2] = MissionBoardViewSettings.flash_mission_position[2]
	self._flash_mission_widget.content.title = Localize("loc_mission_board_flash_mission")
	self._flash_mission_widget.visible = false
	self._mission_widgets[0] = self._flash_mission_widget
	local save_data = Managers.save:account_data()
	save_data.mission_board = save_data.mission_board or {}
	self._mission_board_save_data = save_data.mission_board
	save_data.mission_board.quickplay_difficulty = save_data.mission_board.quickplay_difficulty or 1
	self._quickplay_difficulty = save_data.mission_board.quickplay_difficulty
	self._widgets_by_name.difficulty_stepper.content.danger = save_data.mission_board.quickplay_difficulty
	self._widgets_by_name.difficulty_stepper.content.on_changed_callback = callback(self, "_callback_on_danger_changed")
	save_data.mission_board.private_matchmaking = save_data.mission_board.private_matchmaking or false
	self._private_match = save_data.mission_board.private_matchmaking
	local gamepad_cursor = self._widgets_by_name.gamepad_cursor
	gamepad_cursor.visible = InputDevice.gamepad_active
	self._widgets_by_name.game_settings.visible = false
	self._widgets_by_name.play_team_button.content.hotspot.pressed_callback = callback(self, "_callback_start_selected_mission")

	self:_set_selected_quickplay(true)
	self:_set_play_button_game_mode_text(self._solo_play, self._private_match)
end

MissionBoardView.on_exit = function (self)
	local mission_board_save_data = self._mission_board_save_data

	if mission_board_save_data and (self._quickplay_difficulty ~= mission_board_save_data.quickplay_difficulty or self._private_match ~= mission_board_save_data.private_matchmaking) then
		mission_board_save_data.quickplay_difficulty = self._quickplay_difficulty
		mission_board_save_data.private_matchmaking = self._private_match

		Managers.save:queue_save()
	end

	if self._input_legend_element then
		self:_remove_element("input_legend")

		self._input_legend_element = nil
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:destroy()

		self._world_spawner = nil
	end

	if self._ui_resource_renderer then
		Managers.ui:destroy_renderer(MissionBoardViewSettings.resource_renderer_name)

		self._ui_resource_renderer = nil
	end

	MissionBoardView.super.on_exit(self)
end

MissionBoardView.update = function (self, dt, t, input_service)
	MissionBoardView.super.update(self, dt, t, input_service)
	self:_update_fetch_missions(t)
	self:_update_happening(t)
	self:_update_can_start_mission()

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end
end

MissionBoardView._handle_input = function (self, input_service, dt, t)
	MissionBoardView.super._handle_input(self, input_service, dt, t)

	local mission_widgets = self._mission_widgets

	for i = 1, #mission_widgets do
		local widget_content = mission_widgets[i].content

		if widget_content.hotspot.on_pressed then
			self:_set_selected_mission(widget_content.mission, true)

			break
		end
	end

	local quickplay_widget = self._quickplay_widget

	if quickplay_widget.content.hotspot.on_pressed then
		self:_set_selected_quickplay(true)
	end

	local flash_mission_widget = self._flash_mission_widget

	if flash_mission_widget.visible and flash_mission_widget.content.hotspot.on_pressed then
		self:_set_selected_mission(flash_mission_widget.content.mission, true)
	end

	local last_pressed_device = InputDevice.last_pressed_device
	local gamepad_cursor = self._widgets_by_name.gamepad_cursor
	local cursor_active = last_pressed_device and last_pressed_device:type() ~= "mouse"
	gamepad_cursor.visible = cursor_active

	if cursor_active then
		local input = input_service:get("navigation_keys_virtual_axis") + input_service:get("navigate_controller")
		input[2] = -input[2]
		local input_len = Vector3.length(input)

		if input_len > 1 then
			input = input / input_len
			input_len = 1
		end

		local settings = MissionBoardViewSettings.gamepad_cursor_settings
		local pos = Vector3Box.unbox(self._gamepad_cursor_current_pos)
		local vel = Vector3Box.unbox(self._gamepad_cursor_current_vel)
		local avg_vel = Vector3Box.unbox(self._gamepad_cursor_average_vel)
		local tar_pos = Vector3Box.unbox(self._gamepad_cursor_target_pos)
		local norm_avg_vel, len_avg_vel = Vector3.direction_length(avg_vel)

		if settings.snap_input_length_threshold < input_len then
			self._gamepad_cursor_snap_delay = math.max(self._gamepad_cursor_snap_delay, t + settings.snap_delay)
		elseif self._gamepad_cursor_snap_delay < t then
			pos = Vector3.lerp(tar_pos, pos, settings.snap_movement_rate^dt)
		end

		local drag_coefficient = 1
		local scenegraph = self._ui_scenegraph
		local cursor_size = Vector3.from_array_flat(scenegraph.gamepad_cursor.size)
		local wanted_size = Vector2(settings.default_size_x, settings.default_size_y)
		local best_pos = nil
		local best_score = -math.huge
		local is_sticky = len_avg_vel < settings.stickiness_speed_threshold
		local cursor_center = pos
		local cursor_pos = cursor_center - 0.5 * cursor_size

		for i = -1, #mission_widgets do
			local widget = mission_widgets[i]

			if widget.visible then
				local widget_pos = Vector2(widget.offset[1], widget.offset[2])
				local widget_size = Vector3.from_array_flat(scenegraph[widget.scenegraph_id].size)
				local widget_center = widget_pos + 0.5 * widget_size
				local delta_dir, delta_len = Vector3.direction_length(widget_center - cursor_center)
				local dot = math.max(1e-06, Vector3.dot(norm_avg_vel, delta_dir))
				local score = math.sqrt(dot) / math.max(1, delta_len)

				if is_sticky then
					score = score + 10 * math.max(0, settings.stickiness_radius - delta_len * delta_len)
				end

				local has_overlap = math.box_overlap_box(widget_pos, widget_size, cursor_pos, cursor_size)

				if has_overlap then
					if widget.content.is_quickplay then
						self:_set_selected_quickplay()
					elseif self._selected_mission ~= widget.content.mission then
						self:_set_selected_mission(widget.content.mission)
						self:_play_sound(UISoundEvents.mission_board_node_hover)
					end

					drag_coefficient = settings.widget_drag_coefficient

					if delta_len < settings.stickiness_radius then
						wanted_size = widget_size
						score = score + 1000
					end
				end

				if best_score < score then
					best_score = score
					best_pos = widget_center
				end
			end
		end

		if settings.snap_selection_speed_threshold < len_avg_vel and best_pos then
			Vector3Box.store(self._gamepad_cursor_target_pos, best_pos)
		end

		pos = pos + vel * dt
		vel = vel * settings.cursor_friction_coefficient^dt + settings.cursor_acceleration * drag_coefficient * dt * input

		if Vector3.length_squared(vel) < settings.cursor_minimum_speed then
			Vector3.set_xyz(vel, 0, 0, 0)
		end

		avg_vel = math.lerp(avg_vel, vel, settings.average_speeed_smoothing^dt)
		pos[1] = math.clamp(pos[1], settings.bounds_min_x, settings.bounds_max_x)
		pos[2] = math.clamp(pos[2], settings.bounds_min_y, settings.bounds_max_y)

		Vector3Box.store(self._gamepad_cursor_current_pos, pos)
		Vector3Box.store(self._gamepad_cursor_current_vel, vel)
		Vector3Box.store(self._gamepad_cursor_average_vel, avg_vel)

		local x, y = Vector3.to_elements(pos)

		self:_set_scenegraph_position("gamepad_cursor_pivot", x, y)
		self:_set_scenegraph_size("gamepad_cursor", Vector3.to_elements(math.lerp(wanted_size, cursor_size, settings.size_resize_rate^dt)))

		local arrow_style = gamepad_cursor.style.arrow
		arrow_style.angle = math.radian_lerp(math.pi + math.atan2(tar_pos[2] - pos[2], pos[1] - tar_pos[1]), arrow_style.angle, settings.arrow_rotate_rate^dt)
		local alpha = 255 * (1 - math.clamp(t - self._gamepad_cursor_snap_delay, 0, 1))
		gamepad_cursor.style.glow.color[1] = alpha
		gamepad_cursor.style.rect.color[1] = alpha * 0.12549019607843137
		gamepad_cursor.style.arrow.color[1] = alpha
		gamepad_cursor.style.frame.color[1] = alpha
		gamepad_cursor.style.corner.color[1] = alpha
	end
end

local _required_level_loc_table = {
	required_level = -1
}

MissionBoardView._update_can_start_mission = function (self)
	local selected_mission = self._selected_mission
	local required_level = nil

	if selected_mission then
		required_level = selected_mission.requiredLevel
	else
		local danger = self._quickplay_difficulty
		required_level = DangerSettings.by_index[danger].required_level
	end

	local widgets_by_name = self._widgets_by_name
	local is_locked = false

	if self._player_level < required_level then
		_required_level_loc_table.required_level = required_level

		self:_set_info_text("warning", Localize("loc_mission_board_view_required_level", true, _required_level_loc_table))

		is_locked = true
	elseif not self._party_manager:are_all_members_in_hub() then
		self:_set_info_text("warning", Localize("loc_mission_board_team_mate_not_available"))

		is_locked = true
	elseif self._private_match then
		if self._party_manager:num_other_members() < 1 then
			self:_set_info_text("warning", Localize("loc_mission_board_cannot_private_match"))

			is_locked = true
		end
	else
		self:_set_info_text("info", nil)
	end

	widgets_by_name.play_team_button.content.hotspot.disabled = is_locked
	self.can_start_mission = not is_locked

	return is_locked
end

MissionBoardView._set_info_text = function (self, level, text)
	local info_box = self._widgets_by_name.info_box
	info_box.visible = not not text

	if text then
		info_box.content.text = text
		info_box.style.frame.color = info_box.style.frame["color_" .. level]
	end
end

MissionBoardView._set_gamepad_cursor = function (self, widget)
	local offset = widget.offset
	local size_x, size_y = self:_scenegraph_size(widget.scenegraph_id)
	local x = offset[1] + 0.5 * size_x
	local y = offset[2] + 0.5 * size_y
	self._gamepad_cursor_target_pos[1] = x
	self._gamepad_cursor_target_pos[2] = y
	self._gamepad_cursor_current_pos[1] = x
	self._gamepad_cursor_current_pos[2] = y
end

MissionBoardView._set_selected_quickplay = function (self, move_gamepad_cursor)
	self._selected_mission = nil
	local mission_widgets = self._mission_widgets

	for i = 1, #mission_widgets do
		mission_widgets[i].content.hotspot.is_selected_mission_board = false
	end

	self._quickplay_widget.content.hotspot.is_selected_mission_board = true

	if move_gamepad_cursor then
		self:_set_gamepad_cursor(self._quickplay_widget)
	end

	local widget = self._widgets_by_name.detail
	widget.dirty = true
	local content = widget.content
	content.header_subtitle = Localize("loc_mission_board_view_header_tertium_hive")
	content.header_title = Localize("loc_mission_board_quickplay_header")
	content.danger = nil
	content.is_locked = false
	content.start_game_time = nil
	content.circumstance_icon = nil
	local location_image_material_values = widget.style.location_image.material_values
	location_image_material_values.texture_map = "content/ui/textures/missions/quickplay"
	location_image_material_values.show_static = 0
	local vo_profile = MissionBoardViewSettings.quickplay_vo_profile
	local speaker_settings = DialogueSpeakerVoiceSettings[vo_profile]
	local widget = self._widgets_by_name.objective_1
	widget.dirty = true
	local content = widget.content
	content.header_icon = "content/ui/materials/icons/mission_types/mission_type_09"
	content.header_subtitle = Localize("loc_mission_board_quickplay_header")
	content.body_text = Localize("loc_mission_board_quickplay_description")
	content.speaker_icon = speaker_settings.material_small
	content.speaker_text = Localize(speaker_settings.full_name)
	content.xp = nil
	content.credits = nil
	self._widgets_by_name.objective_2.visible = false
	self._widgets_by_name.difficulty_stepper.visible = true
	self._widgets_by_name.difficulty_stepper_window.visible = true
end

MissionBoardView._set_selected_mission = function (self, mission, move_gamepad_cursor)
	self._selected_mission = mission
	local selected_mission_id = mission.id
	local mission_widgets = self._mission_widgets

	for i = 1, #mission_widgets do
		local widget = mission_widgets[i]
		local content = widget.content
		local widget_mission = content.mission
		local is_selected = widget_mission.id == selected_mission_id
		content.hotspot.is_selected_mission_board = is_selected

		if is_selected and move_gamepad_cursor then
			self:_set_gamepad_cursor(widget)
		end
	end

	self._quickplay_widget.content.hotspot.is_selected_mission_board = false
	local is_locked = self._player_level < mission.requiredLevel
	local xp = mission.xp
	local credits = mission.credits
	local mission_template = MissionTemplates[mission.map]
	local danger = DangerSettings.calculate_danger(mission.challenge, mission.resistance)
	local widget = self._widgets_by_name.detail
	widget.dirty = true
	local content = widget.content
	local mission_type = MissionTypes[mission_template.mission_type]
	content.header_icon = mission_type.icon
	content.header_subtitle = Localize(Zones[mission_template.zone_id].name)
	content.header_title = Localize(mission_template.mission_name)
	content.danger = danger
	content.is_locked = is_locked
	content.start_game_time = mission.start_game_time
	content.expiry_game_time = mission.expiry_game_time
	local circumstance = mission.circumstance

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
		local style = widget.style
		local description_text_box_size = self._ui_scenegraph.detail_circumstance.size
		local text_height = UIRenderer.text_height(self._ui_renderer, Localize(circumstance_ui_data.description), style.circumstance_description.font_type, style.circumstance_description.font_size, description_text_box_size)

		if text_height > 30 then
			self:_set_scenegraph_size("detail_circumstance", nil, text_height + 60)
		end

		local extraRewards = mission.extraRewards.circumstance

		if extraRewards and extraRewards.xp then
			xp = extraRewards.xp + xp or xp
		end

		if extraRewards and extraRewards.credits then
			credits = extraRewards.credits + credits or credits
		end
	else
		content.circumstance_icon = nil
	end

	local location_image_material_values = widget.style.location_image.material_values
	location_image_material_values.texture_map = mission_template.texture_big
	location_image_material_values.show_static = is_locked and 1 or 0
	local vo_profile = mission.missionGiver or mission_template.mission_brief_vo.vo_profile
	local speaker_settings = DialogueSpeakerVoiceSettings[vo_profile]
	local mission_type = MissionTypes[mission_template.mission_type]
	local widget = self._widgets_by_name.objective_1
	widget.dirty = true
	local content = widget.content
	content.header_icon = mission_type.icon
	content.header_subtitle = Localize(mission_type.name)
	content.body_text = Localize(mission_template.mission_description)
	content.speaker_icon = speaker_settings.material_small
	content.speaker_text = Localize(speaker_settings.full_name)
	content.xp = xp
	content.credits = credits
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
		content.xp = extraRewards and extraRewards.xp or 0
		content.credits = extraRewards and extraRewards.credits or 0
	end

	self._widgets_by_name.difficulty_stepper.visible = false
	self._widgets_by_name.difficulty_stepper_window.visible = false
end

MissionBoardView.draw = function (self, dt, t, input_service, layer)
	if not _hide_help_debug_message then
		-- Nothing
	end

	local ui_renderer = self:_begin_render_offscreen()

	UIRenderer.begin_pass(ui_renderer, self._ui_scenegraph, input_service, dt, self._render_settings)

	local mission_widgets = self._mission_widgets

	for i = 1, #mission_widgets do
		local widget = mission_widgets[i]

		UIWidget.draw(widget, ui_renderer)
	end

	UIWidget.draw(self._quickplay_widget, ui_renderer)
	UIWidget.draw(self._flash_mission_widget, ui_renderer)
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

MissionBoardView._clean_backend_data = function (self, backend_data)
	local missions = self._backend_data.missions

	for ii = #missions, 1, -1 do
		local mission_config = missions[ii]

		if not rawget(MissionTemplates, mission_config.map) then
			Log.exception("MissionBoardView", "Got mission from backend that doesn't exist locally '%s'", mission_config.map)
			table.remove(missions, ii)
		end
	end
end

MissionBoardView._join_mission_data = function (self)
	self:_clean_backend_data(self._backend_data)

	local missions = self._backend_data.missions
	local widgets_by_name = self._widgets_by_name
	local mission_widgets = self._mission_widgets

	for i = #mission_widgets, 1, -1 do
		local widget = mission_widgets[i]
		local id = widget.content.mission.id

		if not table.find_by_key(missions, "id", id) and not widget.content.exit_anim_id then
			widget.content.exit_anim_id = self:_start_animation("mission_small_exit", widget, self, nil, 1, math.random_range(0, 0.5))
		end
	end

	self._has_queued_missions = false
	local earliest_queued_mission_show_time = math.huge
	local t = Managers.time:time("main")
	local mission_small_widget_template = MissionBoardViewDefinitions.mission_small_widget_template
	local has_flash_mission_changed = false

	for i = 1, #missions do
		local mission = missions[i]

		if widgets_by_name[mission.id] then
			-- Nothing
		elseif t < mission.start_game_time then
			self._has_queued_missions = true
			earliest_queued_mission_show_time = math.min(mission.start_game_time, earliest_queued_mission_show_time)
		elseif mission.flags.flash and not has_flash_mission_changed and (not self._flash_mission_widget or self._flash_mission_widget.id ~= mission.id) then
			self:_populate_mission_widget(self._flash_mission_widget, mission, self._flash_mission_widget.offset, true)

			self._flash_mission_widget.visible = true
			has_flash_mission_changed = true
		else
			local position = self:_get_free_position(mission.displayIndex or math.random(#self._free_widget_positions))

			if position then
				local widget = self:_create_widget(mission.id, mission_small_widget_template)

				if self:_populate_mission_widget(widget, mission, position) then
					widget.visible = false

					self:_start_animation("mission_small_enter", widget, self, nil, 1, math.random_range(0, 0.5))

					mission_widgets[#mission_widgets + 1] = widget
				end
			else
				self._has_queued_missions = true
			end
		end
	end

	self._queued_mission_show_time = earliest_queued_mission_show_time
end

MissionBoardView._get_free_position = function (self, preferred_index)
	local free_widget_positions = self._free_widget_positions
	local index = preferred_index
	local free_widget_positions_len = #free_widget_positions

	for i = 0, free_widget_positions_len do
		local rand_index = (index - 1 + 47 * i) % free_widget_positions_len + 1
		local position = free_widget_positions[rand_index]

		if position then
			free_widget_positions[rand_index] = false

			return position
		end
	end

	return false
end

MissionBoardView._populate_mission_widget = function (self, widget, mission, position, is_medium_widget)
	local map = mission.map
	local mission_template = MissionTemplates[map]
	widget.offset[1] = position[1]
	widget.offset[2] = position[2]
	local content = widget.content
	local style = widget.style
	content.mission = mission
	content.position = position
	style.mission_line.size[2] = position.length or 800 - position[2]
	local seed = math.floor(3511 * mission.start_game_time) + 68927 * math.floor(mission.expiry_game_time)
	local is_locked = self._player_level < mission.requiredLevel
	local location_image_material_values = style.location_image.material_values
	location_image_material_values.texture_map = is_medium_widget and mission_template.texture_medium or mission_template.texture_small
	location_image_material_values.show_static = is_locked and 1 or 0
	local danger = DangerSettings.calculate_danger(mission.challenge, mission.resistance)
	content.danger = danger
	content.is_locked = is_locked
	local completed_danger = self:_mission_highest_completed_danger(map)

	if completed_danger and completed_danger > 0 then
		local mission_difficulty_complete_icons = MissionBoardViewSettings.mission_difficulty_complete_icons
		local material = mission_difficulty_complete_icons[completed_danger]

		if material then
			content.completed_danger = completed_danger
			content.mission_completed_icon = material
		end
	end

	local circumstance = mission.circumstance

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
	else
		content.circumstance_icon = nil
	end

	local mission_type = MissionTypes[mission_template.mission_type]
	content.objective_1_icon = mission_type.icon
	local side_mission_template = MissionObjectiveTemplates.side_mission.objectives[mission.sideMission]
	content.objective_2_icon = mission.flags.side and side_mission_template and side_mission_template.icon
	content.start_game_time = mission.start_game_time
	content.expiry_game_time = mission.expiry_game_time
	content.is_flash = mission.flags.flash
	content.fluff_frame = math.random_array_entry(MissionBoardViewSettings.fluff_frames, seed)

	return true
end

MissionBoardView._mission_highest_completed_danger = function (self, mission_name)
	local key = "__m_" .. mission_name .. "_md"
	local achievements_data = self._achievements_data

	if achievements_data then
		return Managers.data_service.account:read_stat(achievements_data, key)
	end
end

MissionBoardView.on_resolution_modified = function (self, scale)
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

		self:_join_mission_data()

		return
	elseif self._has_queued_missions and self._queued_mission_show_time <= t then
		self:_join_mission_data()

		return
	elseif t < self._backend_data_expiry_time or self._is_fetching_missions then
		return
	end

	self._is_fetching_missions = true
	local missions_future = Managers.data_service.mission_board:fetch(nil, 1)

	missions_future:next(function (mission_data)
		local achievement_data_promise = Managers.data_service.account:pull_achievement_data()

		return achievement_data_promise:next(function (achievements_data)
			self._achievements_data = achievements_data

			return Promise.resolved(mission_data)
		end)
	end):next(self._cb_fetch_success):catch(self._cb_fetch_failure)
end

MissionBoardView._fetch_success = function (self, data)
	self._backend_data = data
	self._backend_data_expiry_time = data.expiry_game_time
	self._is_fetching_missions = false
	self._do_widget_refresh = true
end

MissionBoardView._fetch_failure = function (self, error_message)
	Log.error("MissionBoardView", "Fetching missions failed %s %s", error_message[1], error_message[2])

	self._backend_data_expiry_time = Managers.time:time("main") + MissionBoardViewSettings.fetch_retry_cooldown
	self._is_fetching_missions = false
end

MissionBoardView._update_happening = function (self, t)
	local happening = self._backend_data and self._backend_data.happening
	local widget = self._widgets_by_name.happening

	if happening and not happening.dynamic then
		local circumstances = happening.circumstances

		for i = 1, #circumstances do
			local circumstance_name = circumstances[i]
			local circumstance_template = CircumstanceTemplates[circumstance_name]
			local circumstance_ui = circumstance_template and circumstance_template.ui
			local happening_display_name = circumstance_ui and circumstance_ui.happening_display_name

			if happening_display_name then
				widget.content.subtitle = Localize(happening_display_name)
				widget.visible = true

				return
			end
		end
	end

	widget.visible = false
end

MissionBoardView._callback_close_view = function (self)
	Managers.ui:close_view(self.view_name)
end

MissionBoardView._callback_start_selected_mission = function (self)
	if not self.can_start_mission then
		return
	end

	Managers.ui:close_view(self.view_name)

	if Managers.narrative:complete_event(Managers.narrative.EVENTS.mission_board) then
		PlayerVOStoryStage.refresh_hub_story_stage()
	end

	local selected_mission = self._selected_mission
	local quickplay_difficulty = self._quickplay_difficulty

	if self._selected_mission then
		self._party_manager:wanted_mission_selected(self._selected_mission.id, self._private_match)
	else
		self._party_manager:wanted_mission_selected("qp:challenge=" .. quickplay_difficulty, self._private_match)
	end
end

MissionBoardView._callback_toggle_game_settings_visibility = function (self)
	local previous_animation_id = self._game_settings_animation_id

	if previous_animation_id then
		self:_stop_animation(previous_animation_id)
	end

	local new_state = not self._game_settings_visible
	local animation_name = new_state and "game_settings_enter" or "game_settings_exit"
	self._game_settings_animation_id = self:_start_animation(animation_name, self._widgets_by_name, self)
	self._game_settings_visible = new_state
end

MissionBoardView._callback_on_danger_changed = function (self)
	self._quickplay_difficulty = self._widgets_by_name.difficulty_stepper.content.danger
end

MissionBoardView._callback_toggle_private_matchmaking = function (self)
	self._private_match = not self._private_match

	if self._solo_play then
		self._solo_play = false
	end

	self:_set_play_button_game_mode_text(self._solo_play, self._private_match)
end

MissionBoardView._set_play_button_game_mode_text = function (self, is_solo_play, is_private_match)
	local play_button_content = self._widgets_by_name.play_team_button.content
	local play_button_text = Utf8.upper(Localize("loc_mission_board_view_accept_mission"))
	local sub_text_color = Color.terminal_text_body_sub_header(255, true)

	if not is_solo_play and not is_private_match then
		play_button_content.original_text = string.format("%s\n{#color(%d,%d,%d);size(15)}[%s]{#reset()}", play_button_text, sub_text_color[2], sub_text_color[3], sub_text_color[4], Utf8.upper(Localize("loc_mission_board_play_public")))
	elseif is_solo_play then
		play_button_content.original_text = string.format("%s\n{#color(%d,%d,%d);size(15)}[%s]{#reset()}", play_button_text, sub_text_color[2], sub_text_color[3], sub_text_color[4], Utf8.upper(Localize("loc_mission_board_toggle_solo_play")))
	else
		play_button_content.original_text = string.format("%s\n{#color(%d,%d,%d);size(15)}[%s]{#reset()}", play_button_text, sub_text_color[2], sub_text_color[3], sub_text_color[4], Utf8.upper(Localize("loc_mission_board_play_private")))
	end
end

MissionBoardView._callback_mission_widget_exit_done = function (self, widget)
	self:_destroy_mission_widget(widget)

	if self._selected_mission == widget.content.mission then
		self:_set_selected_quickplay()
	end

	if self._has_queued_missions then
		self:_join_mission_data()
	end
end

return MissionBoardView
