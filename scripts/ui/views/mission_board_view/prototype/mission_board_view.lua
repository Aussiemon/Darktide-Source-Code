local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local DangerSettings = require("scripts/settings/difficulty/danger_settings")
local DialogueSpeakerVoiceSettings = require("scripts/settings/dialogue/dialogue_speaker_voice_settings")
local InputDevice = require("scripts/managers/input/input_device")
local MissionBoardViewSettings = require("scripts/ui/views/mission_board_view/prototype/mission_board_view_settings")
local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local PlayerVOStoryStage = require("scripts/utilities/player_vo_story_stage")
local ProtoUI = require("scripts/ui/proto_ui/proto_ui")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local Zones = require("scripts/settings/zones/zones")
local MissionBoardView = class("MissionBoardView")

MissionBoardView.init = function (self, settings)
	self.view_name = settings.name
	local world = Managers.ui._world
	self._gui = World.create_screen_gui(world, "immediate")
	self._rt = Renderer.create_resource("render_target", "R8G8B8A8", "back_buffer", 1, 1, "mission_board_view_render_target")
	self._mat = Gui.create_material(self._gui, "content/ui/materials/mission_board/render_target_scanlines", GuiMaterialFlag.GUI_RENDER_PASS_LAYER)

	Material.set_resource(self._mat, "source", self._rt)
	self:trigger_resolution_update()

	self._world = world
	local free_widget_positions = {}

	for i = 1, #MissionBoardViewSettings.mission_positions do
		free_widget_positions[i] = true
	end

	self._free_widget_positions = free_widget_positions
	self._mission_widgets_by_id = {}
	self._backend_data_expiry_time = 0

	self:_select_mission("quickplay")
	Managers.input:push_cursor(self.__class_name)

	self._has_cursor = true
	local qp_pos = MissionBoardViewSettings.quickplay_fake_mission.position
	local qp_size = Vector2(281.6, 134.4)
	self._cursor_box = Vector3Box(qp_pos[1] + qp_size[1] * 0.5, qp_pos[2] + qp_size[2] * 0.5, 0)
	self._cursor_size_box = Vector3Box(qp_size[1] * 0.5, qp_size[2] * 0.5, qp_size[3])
	self._cursor_closest_pos = Vector3Box(qp_pos[1] + qp_size[1] * 0.5, qp_pos[2] + qp_size[2] * 0.5, 0)
	self._cursor_closest_size = Vector3Box(qp_size[1] * 0.5, qp_size[2] * 0.5, qp_size[3])
	self._cursor_state = "standing"

	self:_gamepad_cursor_item("quickplay", qp_pos, qp_size)
	Managers.event:register(self, "event_register_camera", "event_register_camera")

	self._world_spawner = UIWorldSpawner:new("mission_board", 1, "ui", settings.name)

	self._world_spawner:spawn_level("content/levels/ui/mission_board/mission_board")

	local local_player = Managers.player:local_player(1)
	local profile = local_player:profile()
	self._local_player_level = profile.current_level
	local party_manager = Managers.party_immaterium
	self._party_manager = party_manager
	local narrative_manager = Managers.narrative
	local narrative_event_name = "onboarding_step_mission_board_introduction"

	if narrative_manager:can_complete_event(narrative_event_name) then
		narrative_manager:complete_event(narrative_event_name)
	end

	ProtoUI.play_sound(UISoundEvents.mission_board_enter)
end

MissionBoardView._update_exit = function (self)
	if self._exit_animation_done then
		return true
	elseif self._triggered_on_exit_animation then
		self:destroy()

		self._exit_animation_done = true

		return true
	end
end

MissionBoardView.on_exit = function (self)
	self:_update_exit()
end

MissionBoardView.destroy = function (self)
	ProtoUI.play_sound(UISoundEvents.mission_board_exit)

	if self._gui then
		Gui.destroy_material(self._gui, self._mat)

		self._mat = nil

		Renderer.destroy_resource(self._rt)

		self._rt = nil

		World.destroy_gui(self._world, self._gui)

		self._gui = nil
	end

	if self._has_cursor then
		Managers.input:pop_cursor(self.__class_name)

		self._has_cursor = false
	end

	if self._world_spawner then
		if self._gui_world then
			local world = self._world_spawner:world()

			World.destroy_gui(world, self._gui_world)

			self._gui_world = nil
		end

		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	ProtoUI._INTERNAL_reset_data_tree()
end

MissionBoardView.event_register_camera = function (self, camera_unit)
	Managers.event:unregister(self, "event_register_camera")

	self._camera_unit = camera_unit

	self._world_spawner:create_viewport(camera_unit, "mission_board_viewport", "default", 1, "content/shading_environments/ui/mission_board")

	self._gui_world = World.create_world_gui(self._world_spawner:world(), Matrix4x4.identity(), 1, 1, "immediate")
end

local function corners(pos, size, corner_length)
	corner_length = corner_length or 6
	local corner_size = Vector2(corner_length, corner_length)
	local opposite = size - corner_size
	local material = "content/ui/materials/frames/corner_01"
	local uv00 = Vector2(0, 0)
	local uv10 = Vector2(1, 0)
	local uv11 = Vector2(1, 1)
	local uv01 = Vector2(0, 1)
	local color = Color(200, 255, 255, 255)

	ProtoUI.draw_bitmap_uv(material, uv00, uv11, pos, corner_size, color)
	ProtoUI.draw_bitmap_uv(material, uv10, uv01, pos + Vector2(opposite[1], 0), corner_size, color)
	ProtoUI.draw_bitmap_uv(material, uv01, uv10, pos + Vector2(0, opposite[2]), corner_size, color)
	ProtoUI.draw_bitmap_uv(material, uv11, uv00, pos + opposite, corner_size, color)
end

local function outer_glow(pos, size, color)
	local corner_size = Vector2(14, 14)
	pos = pos - corner_size
	size = size + 2 * corner_size
	local opposite = size - corner_size

	ProtoUI.draw_bitmap("content/ui/materials/frames/dropshadow_heavy", pos, size, color)
end

local function borders(pos, size)
	local color = Color(128, 169, 211, 158)
	local size_x = Vector2(size[1], 2)
	local size_y = Vector2(2, size[2])
	local opposite = pos + size

	ProtoUI.draw_rect(pos, size_x, color)
	ProtoUI.draw_rect(pos, size_y, color)
	ProtoUI.draw_rect(opposite, -size_y, color)
	ProtoUI.draw_rect(opposite, -size_x, color)
end

local function corners_borders(pos, size, corner_length)
	borders(pos, size)
	corners(pos + Vector2(0, 0, 1), size, corner_length)
end

MissionBoardView.draw_medium_mission_widget = function (self, mission, pos)
	if mission.play_enter_animation then
		local start_t = mission.play_enter_animation_start_t

		if not start_t then
			start_t = ProtoUI.t + math.random_range(0, 0.5)
			mission.play_enter_animation_start_t = start_t

			ProtoUI.play_sound(UISoundEvents.mission_board_show_icon)
		end

		local s = ProtoUI.t - start_t
		s = s * 5

		if s < 0 then
			return
		elseif s > 2 then
			mission.play_enter_animation = false
		end

		local width = math.lerp(80, 281.6, ProtoUI.anim_delay(s, 1))
		local height = math.lerp(82, 134.4, ProtoUI.anim_delay(s, 0.5))
		local size = Vector2(width, height)

		ProtoUI.draw_rect(pos, size, Color(200, 0, 0, 0))
		corners(Vector3(0, 0, 3) + pos, size)

		if ProtoUI.anim_interval(s, 1, 0.2) > 0.5 or ProtoUI.anim_delay(s, 1.4) > 0.5 then
			borders(Vector3(0, 0, 2) + pos, size)
			ProtoUI.draw_bitmap(mission.material_big, Vector3(0, 0, 1) + pos, size)
		end

		local fluff_frame = mission.fluff_frame

		if fluff_frame and s > 1.3 then
			ProtoUI.draw_bitmap(fluff_frame, Vector3(-40, -47, -15) + pos, Vector2(160, 184), Color(180, 255, 255, 255))
		end

		return
	end

	if mission.play_exit_animation then
		local start_t = mission.play_exit_animation_start_t

		if not start_t then
			start_t = ProtoUI.t
			mission.play_exit_animation_start_t = start_t

			ProtoUI.play_sound(UISoundEvents.mission_board_hide_icon)
		end

		local s = ProtoUI.t - start_t

		if s > 0.3 then
			return
		end

		local size = Vector2(281.6, 134.4)

		ProtoUI.draw_bitmap(mission.material_big, Vector3(0, 0, 1) + pos, size)
		ProtoUI.draw_rect(Vector3(0, 0, 2) + pos, size, Color(255 * (1 - ProtoUI.anim_lerp(s, 0, 0.3)), 255, 255, 255))
		borders(Vector3(0, 0, 3) + pos, size)

		return
	elseif mission.expiry_game_time - ProtoUI.t < 0.3 then
		mission.play_exit_animation = true
	end

	local size = Vector2(281.6, 134.4)
	local ui_color_green = Color(169, 211, 158)
	local button, is_clicked = nil

	ProtoUI.begin_group(mission.id)
	ProtoUI.begin_group("inner", pos)

	button, is_clicked = ProtoUI.use_data("button_state", ProtoUI.behaviour_button, Vector3(0, 0, 0), size)

	if is_clicked then
		ProtoUI.play_sound(UISoundEvents.mission_board_node_pressed)
	elseif button.state == "hover" and button.last_state == "default" then
		ProtoUI.play_sound(UISoundEvents.mission_board_node_hover)
	end

	if is_clicked then
		self._cursor = pos
	end

	local is_intersecting, was_nearest = self:_gamepad_cursor_item(mission, pos, size)

	if is_intersecting then
		is_clicked = true
	elseif was_nearest then
		button.state = "hover"
	end

	ProtoUI.begin_group("timer_bar", Vector3(60, -18, 2))

	local expiry_game_time = mission.expiry_game_time - 0.3
	local seconds_left = math.max(0, expiry_game_time - ProtoUI.t)
	local minutes_left = seconds_left / 60

	ProtoUI.draw_rect(Vector3(-60, -8, 0), Vector2(55, 20), Color(200, 0, 0, 0))
	borders(Vector3(-60, -10, 1), Vector2(55, 24))
	ProtoUI.draw_bitmap("content/ui/materials/icons/generic/hourglass", Vector3(-57, -7, 2), Vector2(18.599999999999998, 18.599999999999998), ui_color_green)
	ProtoUI.draw_text(string.format("%02d:%02d", minutes_left, seconds_left % 60), ProtoUI.fonts.itc_novarese_bold, 12, Vector3(-40, -3, 2), Vector2(100, 100), ui_color_green)

	local timer_bar_size = Vector2(220, 5)
	local timer_percent = 1 - math.ilerp(mission.start_game_time, expiry_game_time, ProtoUI.t)
	local timer_color = seconds_left > 30 and ui_color_green or Color.golden_rod()

	ProtoUI.draw_rect(Vector3(-1, -1, 0), timer_bar_size + Vector2(3, 3), ui_color_green)
	ProtoUI.draw_rect(Vector3(0, 0, 1), timer_bar_size, Color(200, 0, 0, 0))
	ProtoUI.draw_rect(Vector3(0, 0, 2), Vector2(timer_bar_size[1] * timer_percent, timer_bar_size[2]), timer_color)
	ProtoUI.end_group("timer_bar")
	ProtoUI.begin_group("location", Vector3(0, 0, 1))

	local location_size = size

	ProtoUI.draw_bitmap(mission.material_big, Vector3(0, 0, 0), location_size)
	corners_borders(Vector3(0, 0, 3), location_size)
	ProtoUI.draw_bitmap("content/ui/materials/icons/generic/aquila", Vector3(0.5 * (location_size[1] - 60), 5, 5), Vector2(60, 20), ui_color_green)
	ProtoUI.draw_text(Utf8.upper(Localize("loc_mission_board_flash_mission")), ProtoUI.fonts.proxima_nova_bold, 22, Vector3(-15, -1, 2), location_size, ui_color_green, "flags", Gui.MultiLine, "horizontal_align_right", "vertical_align_bottom")
	ProtoUI.draw_bitmap("content/ui/materials/gradients/gradient_horizontal", Vector3(0, location_size[2] - 30, 1), Vector2(location_size[1], 30), Color(0, 0, 0))

	if mission.is_locked then
		ProtoUI.draw_text("", "content/ui/fonts/darktide_custom_regular", 160, Vector3(0, 0, 10), location_size, Color(184, 184, 184), "flags", Gui.MultiLine, "horizontal_align_center", "vertical_align_center")
	end

	ProtoUI.end_group("location")

	if mission.is_flash then
		ProtoUI.draw_bitmap("content/ui/materials/icons/generic/flash", Vector3(-40, -10, 100), Vector2(49.6, 49.6), Color.golden_rod())
	end

	ProtoUI.begin_group("difficulty", Vector3(10, 10, 50))
	ProtoUI.draw_rect(Vector3(0, 0, 0), Vector2(80, 28), Color(200, 0, 0, 0))
	corners(Vector3(0, 0, 2), Vector2(80, 28))
	ProtoUI.draw_bitmap("content/ui/materials/icons/generic/danger", Vector3(2, 2, 3), Vector2(25.6, 25.6), ui_color_green)

	local danger = mission.danger

	for i = 0, 4 do
		local color = i < danger and ui_color_green or Color(26, 33, 25)

		ProtoUI.draw_rect(Vector3(30 + i * 8.25, 5.5, 3), Vector2(4.8, 18), color)
	end

	ProtoUI.end_group("difficulty")
	ProtoUI.begin_group("objective", Vector3(-10, 80, 10))

	local objective_size = Vector2(30, 30)

	ProtoUI.draw_rect(Vector3(0, 0, 0), objective_size, Color(200, 0, 0, 0))
	ProtoUI.draw_bitmap(mission.main_objective.icon, Vector3(0, 0, 1), objective_size, ui_color_green)
	corners(Vector3(0, 0, 2), objective_size)
	ProtoUI.end_group("objective")

	local circumstance = mission.circumstance

	if circumstance then
		ProtoUI.begin_group("circumstance", Vector3(size[1] + -30, 7, 15))

		local circumstance_size = Vector2(40, 40)

		ProtoUI.draw_rect(Vector3(0, 0, 0), circumstance_size, Color(200, 0, 0, 0))
		corners_borders(Vector3(0, 0, 1), circumstance_size)
		ProtoUI.draw_bitmap(circumstance.icon, Vector3(5, 5, 3), Vector2(30, 30), Color.golden_rod())
		ProtoUI.end_group("circumstance")
	end

	local draw_glow_color = nil

	if self._selected_mission == mission then
		self._selected_alpha = 255
		draw_glow_color = Color(self._selected_alpha, 0, 204, 0)
	elseif button.state == "hover" then
		draw_glow_color = Color(self._selected_alpha, 204, 255, 204)
	elseif button.state == "hot" then
		draw_glow_color = Color(self._selected_alpha, 0, 119, 0)
	else
		draw_glow_color = Color(255, 0, 0, 0)
	end

	if draw_glow_color then
		outer_glow(Vector3(0, 0, -20), location_size, draw_glow_color)
	end

	ProtoUI.end_group("inner")
	ProtoUI.end_group(mission.id)

	return is_clicked
end

MissionBoardView.draw_quickplay_widget = function (self, pos)
	local size = Vector2(281.6, 134.4)
	local ui_color_green = Color(169, 211, 158)
	local button, is_clicked = nil

	ProtoUI.begin_group("quickplay")
	ProtoUI.begin_group("inner", pos)

	button, is_clicked = ProtoUI.use_data("button_state", ProtoUI.behaviour_button, Vector3(0, 0, 0), size)

	if is_clicked then
		ProtoUI.play_sound(UISoundEvents.mission_board_node_pressed)
	elseif button.state == "hover" and button.last_state == "default" then
		ProtoUI.play_sound(UISoundEvents.mission_board_node_hover)
	end

	if is_clicked then
		self._cursor = pos
	end

	local is_intersecting, was_nearest = self:_gamepad_cursor_item("quickplay", pos, size)

	if is_intersecting then
		is_clicked = true
	elseif was_nearest then
		button.state = "hover"
	end

	ProtoUI.begin_group("location", Vector3(0, 0, 1))

	local location_size = size

	ProtoUI.draw_bitmap("content/ui/materials/missions/quickplay", Vector3(0, 0, 0), location_size)
	corners_borders(Vector3(0, 0, 3), location_size)
	ProtoUI.draw_bitmap("content/ui/materials/icons/generic/aquila", Vector3(0.5 * (location_size[1] - 60), 5, 5), Vector2(60, 20), ui_color_green)
	ProtoUI.draw_text(Utf8.upper(Localize("loc_mission_board_quickplay_header")), ProtoUI.fonts.proxima_nova_bold, 22, Vector3(-15, -1, 2), location_size, ui_color_green, "flags", Gui.MultiLine, "horizontal_align_right", "vertical_align_bottom")
	ProtoUI.draw_bitmap("content/ui/materials/gradients/gradient_horizontal", Vector3(0, location_size[2] - 30, 1), Vector2(location_size[1], 30), Color(0, 0, 0))
	ProtoUI.end_group("location")
	ProtoUI.begin_group("objective", Vector3(-10, 80, 10))

	local objective_size = Vector2(30, 30)

	ProtoUI.draw_rect(Vector3(0, 0, 0), objective_size, Color(200, 0, 0, 0))
	ProtoUI.draw_bitmap("content/ui/materials/icons/mission_types/mission_type_09", Vector3(0, 0, 1), objective_size, ui_color_green)
	corners(Vector3(0, 0, 2), objective_size)
	ProtoUI.end_group("objective")

	local draw_glow_color = nil

	if self._selected_mission == "quickplay" then
		self._selected_alpha = 255
		draw_glow_color = Color(self._selected_alpha, 250, 189, 73)
	elseif button.state == "hover" then
		draw_glow_color = Color(self._selected_alpha, 204, 255, 204)
	elseif button.state == "hot" then
		draw_glow_color = Color(self._selected_alpha, 0, 119, 0)
	else
		draw_glow_color = Color(255, 0, 0, 0)
	end

	if draw_glow_color then
		outer_glow(Vector3(0, 0, -20), location_size, draw_glow_color)
	end

	ProtoUI.end_group("inner")
	ProtoUI.end_group("quickplay")

	return is_clicked
end

MissionBoardView.draw_small_mission_widget = function (self, mission, pos, line_height)
	if mission.play_enter_animation then
		local start_t = mission.play_enter_animation_start_t

		if not start_t then
			start_t = ProtoUI.t + math.random_range(0, 0.5)
			mission.play_enter_animation_start_t = start_t

			ProtoUI.play_sound(UISoundEvents.mission_board_show_icon)
		end

		local s = ProtoUI.t - start_t
		s = s * 5

		if s < 0 then
			return
		elseif s > 2 then
			mission.play_enter_animation = false
		end

		pos = pos + Vector3(0, 27, 0)
		local width = math.lerp(20, 80, ProtoUI.anim_delay(s, 1))
		local height = math.lerp(20, 92, ProtoUI.anim_delay(s, 0.5))
		local size = Vector2(width, height)

		ProtoUI.draw_rect(pos, size, Color(200, 0, 0, 0))
		corners(Vector3(0, 0, 3) + pos, size)

		if ProtoUI.anim_delay(s, 1, 0.2) > 0.5 or ProtoUI.anim_delay(s, 1.4) > 0.5 then
			borders(Vector3(0, 0, 2) + pos, size)
			ProtoUI.draw_bitmap(mission.material_big, Vector3(0, 0, 1) + pos, size)
		end

		local fluff_frame = mission.fluff_frame

		if fluff_frame and s > 1.3 then
			ProtoUI.draw_bitmap(fluff_frame, Vector3(-40, -47, -15) + pos, Vector2(160, 184), Color(180, 255, 255, 255))
		end

		return
	end

	if mission.play_exit_animation then
		local start_t = mission.play_exit_animation_start_t

		if not start_t then
			start_t = ProtoUI.t
			mission.play_exit_animation_start_t = start_t

			ProtoUI.play_sound(UISoundEvents.mission_board_hide_icon)
		end

		local s = ProtoUI.t - start_t

		if s > 0.3 then
			return
		end

		pos = pos + Vector3(0, 27, 0)
		local size = Vector2(80, 92)

		ProtoUI.draw_bitmap(mission.material_small, Vector3(0, 0, 1) + pos, size)
		ProtoUI.draw_rect(Vector3(0, 0, 2) + pos, size, Color(255 * (1 - ProtoUI.anim_lerp(s, 0, 0.3)), 255, 255, 255))
		borders(Vector3(0, 0, 3) + pos, size)

		return
	elseif mission.expiry_game_time - ProtoUI.t < 0.3 then
		mission.play_exit_animation = true
	end

	local size = Vector2(80, 120)
	local ui_color_green = Color(169, 211, 158)
	local button, is_clicked = nil

	ProtoUI.begin_group(mission.id)
	ProtoUI.begin_group("inner", pos)

	button, is_clicked = ProtoUI.use_data("button", ProtoUI.behaviour_button, Vector3(0, 0, 0), size)

	if is_clicked then
		ProtoUI.play_sound(UISoundEvents.mission_board_node_pressed)
	elseif button.state == "hover" and button.last_state == "default" then
		ProtoUI.play_sound(UISoundEvents.mission_board_node_hover)
	end

	if is_clicked then
		self._cursor = pos
	end

	local is_intersecting, was_nearest = self:_gamepad_cursor_item(mission, pos, size)

	if is_intersecting then
		is_clicked = true
	elseif was_nearest then
		button.state = "hover"
	end

	ProtoUI.begin_group("difficulty", Vector3(0, -5, 10))
	ProtoUI.draw_rect(Vector3(0, 0, 0), Vector2(80, 28), Color(200, 0, 0, 0))
	corners(Vector3(0, 0, 2), Vector2(80, 28))
	ProtoUI.draw_bitmap("content/ui/materials/icons/generic/danger", Vector3(2, 2, 3), Vector2(25.6, 25.6), ui_color_green)

	local danger = mission.danger

	for i = 0, 4 do
		local color = i < danger and ui_color_green or Color(26, 33, 25)

		ProtoUI.draw_rect(Vector3(30 + i * 8.25, 5.5, 3), Vector2(4.8, 18), color)
	end

	ProtoUI.end_group("difficulty")
	ProtoUI.begin_group("timer_bar", Vector3(0, 23, 3))

	local expiry_game_time = mission.expiry_game_time - 0.3
	local timer_bar_size = Vector2(80, 4)
	local timer_percent = 1 - math.ilerp(expiry_game_time - 30, expiry_game_time, ProtoUI.t)

	ProtoUI.draw_rect(Vector3(0, 0, 1), timer_bar_size, Color(200, 0, 0, 0))

	local timer_color = timer_percent == 1 and Color(200, 0, 0, 0) or Color.golden_rod()

	ProtoUI.draw_rect(Vector3(0, 0, 2), Vector2(timer_bar_size[1] * timer_percent, timer_bar_size[2]), timer_color)
	ProtoUI.end_group("timer_bar")

	local location_pos = Vector3(0, 27, 5)
	local location_size = Vector2(80, 92)

	ProtoUI.draw_bitmap(mission.material_small, location_pos, location_size)
	ProtoUI.draw_bitmap("content/ui/materials/frames/inner_shadow_medium", Vector3(0, 0, 1) + location_pos, location_size, Color(255, 16, 32, 16))
	corners_borders(Vector3(0, 0, 3) + location_pos, location_size)

	local fluff_frame = mission.fluff_frame

	if fluff_frame then
		ProtoUI.draw_bitmap(fluff_frame, Vector2(-40, -20, -5), Vector2(160, 184), Color(180, 255, 255, 255))
	end

	if mission.is_locked then
		ProtoUI.draw_text("", "content/ui/fonts/darktide_custom_regular", 80, Vector3(0, 0, 10) + location_pos, location_size, Color(184, 184, 184), "flags", Gui.MultiLine, "horizontal_align_center", "vertical_align_center", "shadow", Color(100, 255, 100, 20))
	end

	local gradient_length = 30
	local line_color = Color(178.5, 169, 211, 158)

	ProtoUI.draw_rect(Vector3(40, 119, -20), Vector2(2, line_height - gradient_length), line_color)
	ProtoUI.draw_bitmap_uv("content/ui/materials/gradients/gradient_vertical", Vector2(0, 1), Vector2(1, 0), Vector3(40, 119 + line_height - gradient_length, -20), Vector2(2, gradient_length), line_color)

	if self._selected_mission == mission then
		ProtoUI.draw_bitmap_uv("content/ui/materials/mission_board/mission_line", Vector2(0, 1), Vector2(1, 0), Vector3(40, 119, -9), Vector2(2, line_height), ui_color_green)

		local t = 0.2 * ProtoUI.t
		local circle_size_a = Vector2(60, 30) * (0.1 + 2 * (t % 1))

		ProtoUI.draw_bitmap("content/ui/materials/hud/tagging/frame_item_outer", Vector3(40 - 0.5 * circle_size_a[1], 119 - 0.5 * circle_size_a[2] + line_height, -11), circle_size_a, Color(255 - 255 * (t % 1), 169, 211, 158))

		t = t + 0.5
		local circle_size_b = Vector2(60, 30) * (0.1 + 2 * (t % 1))

		ProtoUI.draw_bitmap("content/ui/materials/hud/tagging/frame_item_outer", Vector3(40 - 0.5 * circle_size_b[1], 119 - 0.5 * circle_size_b[2] + line_height, -11), circle_size_b, Color(255 - 255 * (t % 1), 169, 211, 158))
	end

	local circumstance = mission.circumstance

	if circumstance then
		ProtoUI.begin_group("circumstance", Vector3(75, 36, 10))

		local circumstance_size = Vector2(32, 32)

		ProtoUI.draw_rect(Vector3(0, 0, 0), circumstance_size, Color(200, 0, 0, 0))
		corners(Vector3(0, 0, 1), circumstance_size)
		ProtoUI.draw_bitmap(circumstance.icon, Vector3(3, 3, 2), Vector2(26, 26), Color.golden_rod())
		ProtoUI.end_group("circumstance")
	end

	ProtoUI.begin_group("objective", Vector3(-15, 68, 10))

	local objective_size = Vector2(30, 30)

	ProtoUI.draw_rect(Vector3(0, 0, 0), objective_size, Color(200, 0, 0, 0))
	corners(Vector3(0, 0, 1), objective_size)
	ProtoUI.draw_bitmap(mission.main_objective.icon, Vector3(0, 0, 2), objective_size, ui_color_green)
	ProtoUI.end_group("objective")

	local draw_glow_color = nil

	if self._selected_mission == mission then
		self._selected_alpha = 255
		draw_glow_color = Color(self._selected_alpha, 250, 189, 73)
	elseif button.state == "hover" then
		draw_glow_color = Color(self._selected_alpha, 204, 255, 204)
	elseif button.state == "hot" then
		draw_glow_color = Color(self._selected_alpha, 0, 119, 0)
	else
		draw_glow_color = Color(255, 0, 0, 0)
	end

	if draw_glow_color then
		outer_glow(Vector3(0, 27, -2), location_size, draw_glow_color)
	end

	ProtoUI.end_group("inner")
	ProtoUI.end_group(mission.id)

	return is_clicked
end

local function draw_reward(idx, glyph, label, pos)
	local ui_color_green = Color(169, 211, 158)
	local size = Vector2(110, 33)

	ProtoUI.begin_group(idx, pos)
	ProtoUI.draw_rect(Vector3(0, 0, 0), size, Color(255, 0, 0, 0))
	ProtoUI.draw_bitmap("content/ui/materials/gradients/gradient_vertical", Vector3(0, 0, 1), size, Color(32, 169, 211, 158))
	borders(Vector3(0, 0, 2), size)
	ProtoUI.draw_text(glyph, ProtoUI.fonts.proxima_nova_bold, 22, Vector3(10, 0, 3), size, ui_color_green, "flags", Gui.MultiLine, "horizontal_align_left", "vertical_align_center")
	ProtoUI.draw_text(label, ProtoUI.fonts.proxima_nova_bold, 22, Vector3(-10, 0, 3), size, ui_color_green, "flags", Gui.MultiLine, "horizontal_align_right", "vertical_align_center")
	ProtoUI.end_group(idx)
end

local function play_button(idx, pos, disabled)
	ProtoUI.begin_group(idx, pos)

	local size = Vector2(347, 76)
	local data, is_clicked = ProtoUI.use_data("button_data", ProtoUI.behaviour_button, Vector3(0, 0, 0), size, disabled)
	local state = data.state
	local bg_color, text_color = nil
	local invert_gradient = false

	if state == "default" then
		text_color = Color(169, 211, 158)
		bg_color = Color(200, 0, 0, 0)
	elseif state == "hover" then
		text_color = Color(216, 237, 190)
		bg_color = Color(0, 255, 0)
	elseif state == "warm" then
		text_color = Color(158, 178, 133)
		bg_color = Color(255, 0, 0)
	elseif state == "hot" then
		text_color = Color(158, 178, 133)
		bg_color = Color(0, 255, 0)
		invert_gradient = true
	elseif state == "disabled" then
		text_color = Color.ui_disabled_text_color()
		bg_color = Color(200, 0, 0, 0)
	end

	ProtoUI.draw_rect(Vector3(0, 0, 0), size, Color.ui_hud_green_medium())

	if state == "hover" or state == "warm" or state == "hot" then
		ProtoUI.draw_bitmap("content/ui/materials/buttons/background_selected", Vector3(0, 0, 1), size, bg_color)
	end

	if invert_gradient then
		ProtoUI.draw_bitmap_uv("content/ui/materials/gradients/gradient_vertical", Vector2(0, 0), Vector2(1, 1), Vector3(0, 0, 2), size, Color(32, 169, 211, 158))
	else
		ProtoUI.draw_bitmap_uv("content/ui/materials/gradients/gradient_vertical", Vector2(0, 1), Vector2(1, 0), Vector3(0, 0, 2), size, Color(32, 169, 211, 158))
	end

	corners_borders(Vector3(0, 0, 3), size)

	local play_label = Utf8.upper(Localize("loc_mission_board_view_accept_mission"))

	ProtoUI.draw_text(play_label, "content/ui/fonts/proxima_nova_bold", 24, Vector3(0, -2, 5), size, text_color, "flags", Gui.MultiLine, "character_spacing", 0.1, "vertical_align_center", "horizontal_align_center", "shadow", Color(0, 0, 0))
	ProtoUI.end_group(idx)

	return data, not disabled and is_clicked
end

local function draw_objective_panel(idx, objective_data, title, is_main, position)
	local ui_color_green = Color(169, 211, 158)
	local ui_color_grey = Color(161, 175, 158)
	local header_gradient_color = is_main and Color(100, 169, 211, 158) or Color(100, 66, 79, 64)

	ProtoUI.begin_group(idx, position)
	ProtoUI.begin_group("header", Vector3(0, 5, 1))

	local main_objective_header_size = Vector2(480, 50)

	ProtoUI.draw_rect(Vector3(0, 0, 0), main_objective_header_size, Color(230, 0, 0, 0))
	ProtoUI.draw_bitmap("content/ui/materials/gradients/gradient_horizontal", Vector3(0, 0, 1), main_objective_header_size, header_gradient_color)
	borders(Vector3(0, 0, 2), main_objective_header_size)
	ProtoUI.draw_bitmap(objective_data.icon, Vector3(10, 5, 2), Vector2(40, 40), ui_color_green)
	ProtoUI.draw_text(Localize(title), ProtoUI.fonts.proxima_nova_bold, 18, Vector3(60, 5, 2), main_objective_header_size, ui_color_grey)
	ProtoUI.draw_text(Localize(objective_data.name), ProtoUI.fonts.itc_novarese_bold, 20, Vector3(60, 25, 2), main_objective_header_size, ui_color_green)
	ProtoUI.end_group("header")
	ProtoUI.begin_group("body", Vector3(0, 53, 10))

	local main_objective_body_size = Vector2(480, 85)

	ProtoUI.draw_rect(Vector3(0, 0, 0), main_objective_body_size, Color(230, 0, 0, 0))
	borders(Vector3(0, 0, 1), main_objective_body_size)
	ProtoUI.draw_text(Localize(objective_data.text), ProtoUI.fonts.proxima_nova_bold, 18, Vector3(20, 5, 1), main_objective_body_size - Vector2(40, 0), Color(166, 169, 211, 158), "flags", Gui.MultiLine + Gui.FormatDirectives)

	if objective_data.npc_name then
		ProtoUI.draw_text(objective_data.npc_name, ProtoUI.fonts.proxima_nova_bold, 18, Vector3(-45, -3, 1), main_objective_body_size, Color(166, 161, 175, 158), "flags", Gui.MultiLine, "vertical_align_bottom", "horizontal_align_right")
		ProtoUI.begin_group("mission_giver", Vector3(-30, -38, 10) + main_objective_body_size)
		ProtoUI.draw_bitmap(objective_data.npc_image, Vector3(0, 0, 0), Vector2(40, 48))
		corners_borders(Vector3(0, 0, 1), Vector2(40, 48))
		ProtoUI.end_group("mission_giver")
	end

	ProtoUI.end_group("body")

	if objective_data.rewards then
		ProtoUI.begin_group("footer", Vector3(-10, 125, 20))
		draw_reward("credits", "", objective_data.rewards.credits, Vector3(0, 0, 0))
		draw_reward("experience", "", objective_data.rewards.xp, Vector3(115, 0, 0))
		ProtoUI.end_group("footer")
	end

	ProtoUI.end_group(idx)
end

MissionBoardView._draw_mission_detail_side_panel = function (self, mission)
	ProtoUI.begin_group("side_panel", Vector3(1170, 50, 500))

	local ui_color_green = Color(169, 211, 158)

	ProtoUI.begin_group("header", Vector3(0, 20, 30))

	local header_size = Vector2(680, 80)

	ProtoUI.draw_rect(Vector3(0, 0, 0), header_size, Color(200, 0, 0, 0))
	borders(Vector3(0, 0, 1), header_size)
	ProtoUI.draw_text(Utf8.upper(Localize(mission.template.mission_name)), ProtoUI.fonts.proxima_nova_bold, 28, Vector3(12, 12, 2), header_size, ui_color_green)
	ProtoUI.draw_text(Localize(mission.zone.name), ProtoUI.fonts.proxima_nova_medium, 24, Vector3(12, 42, 2), header_size, ui_color_green)
	ProtoUI.begin_group("difficulty", Vector3(454, 0, 5))
	ProtoUI.draw_bitmap("content/ui/materials/icons/generic/danger", Vector3(10, 4, 3), Vector2(70, 70), ui_color_green)

	local danger = mission.danger

	for i = 0, 4 do
		local color = i < danger and ui_color_green or Color(26, 33, 25)

		ProtoUI.draw_rect(Vector3(95 + i * 22, 20, 1), Vector2(12.8, 48), color)
	end

	ProtoUI.end_group("difficulty")

	if mission.is_flash then
		ProtoUI.draw_bitmap("content/ui/materials/icons/generic/flash", Vector3(-70, -5, 10), Vector2(74.39999999999999, 74.39999999999999), Color.golden_rod())
	end

	ProtoUI.begin_group("timer", Vector3(5, -25, 5))

	local timer_size = Vector2(670, 20)
	local timer_percent = 1 - math.ilerp(mission.start_game_time, mission.expiry_game_time, ProtoUI.t)

	ProtoUI.draw_rect(Vector3(-5, -5, 0), Vector2(10, 10) + timer_size, Color(0, 0, 0))
	borders(Vector3(-5, -5, 3), Vector2(10, 10) + timer_size)
	ProtoUI.draw_rect(Vector3(0, 0, 1), Vector2(timer_size[1] * timer_percent, timer_size[2]), Color.golden_rod())

	local seconds_left = math.max(0, mission.expiry_game_time - ProtoUI.t)
	local minutes_left = seconds_left / 60

	ProtoUI.draw_text(string.format("%02d:%02d", minutes_left, seconds_left % 60), ProtoUI.fonts.itc_novarese_bold, 22, Vector3(-30, 0, 2), timer_size, Color(255, 255, 255), "horizontal_align_right", "flags", Gui.MultiLine, "shadow", Color(0, 0, 0))
	ProtoUI.end_group("timer")
	ProtoUI.end_group("header")
	ProtoUI.begin_group("main", Vector3(0, 99, 0))

	local location_size = Vector2(679.9999999936, 324.5454545424)

	ProtoUI.draw_bitmap(mission.material_big, Vector3(0, 0, 0), location_size)
	ProtoUI.draw_bitmap("content/ui/materials/frames/inner_shadow_medium", Vector3(0, 0, 1), location_size, Color(255, 16, 32, 16))
	borders(Vector3(0, 0, 2), location_size)
	outer_glow(Vector3(0, 0, -3), location_size, Color(255, 16, 32, 16))

	if mission.is_locked then
		ProtoUI.draw_text("", "content/ui/fonts/darktide_custom_regular", 200, Vector3(0, 0, 10), location_size, Color(184, 184, 184), "flags", Gui.MultiLine, "horizontal_align_center", "vertical_align_center", "shadow", Color(100, 255, 100, 20))
	end

	ProtoUI.end_group("main")
	ProtoUI.begin_group("main_side", Vector3(40, 50, 1))
	ProtoUI.begin_group("main_objective", Vector3(480, 130, 7))

	local objective_fluff_size = Vector2(179.20000000000002, 224)

	ProtoUI.draw_bitmap(mission.main_objective.image, Vector3(0, 0, 0), objective_fluff_size)
	corners_borders(Vector3(0, 0, 1), objective_fluff_size)
	ProtoUI.end_group("main_objective")

	local side_fluff_position = Vector3(520, 170, 2)
	local side_fluff_size = Vector2(164, 204)

	ProtoUI.begin_group("side_fluff", side_fluff_position)
	corners_borders(Vector3(0, 0, 1), side_fluff_size)
	ProtoUI.end_group("side_fluff")
	ProtoUI.end_group("main_side")

	local circumstance = mission.circumstance

	if circumstance then
		ProtoUI.begin_group("circumstance", Vector3(10, 351, 1))

		local circumstance_size = Vector2(510, 62)

		ProtoUI.draw_rect(Vector3(0, 0, 0), circumstance_size, Color(150, 0, 0, 0))
		ProtoUI.draw_bitmap(circumstance.icon, Vector3(8, 7, 1), Vector2(48, 48), Color.golden_rod())
		ProtoUI.draw_text(Localize(circumstance.display_name), ProtoUI.fonts.itc_novarese_bold, 20, Vector3(80, 10, 1), circumstance_size, Color.golden_rod())
		ProtoUI.draw_text(Localize(circumstance.description), ProtoUI.fonts.proxima_nova_bold, 18, Vector3(80, 35, 1), circumstance_size, Color.golden_rod())
		corners_borders(Vector3(0, 0, 2), circumstance_size)
		ProtoUI.draw_text(Localize("loc_mission_info_circumstance_label"), ProtoUI.fonts.proxima_nova_bold, 18, Vector3(-5, 5, 1), circumstance_size, Color(100, 161, 175, 158), "flags", Gui.MultiLine, "vertical_align_top", "horizontal_align_right")
		ProtoUI.end_group("circumstance")
	end

	ProtoUI.begin_group("objectives", Vector3(110, 420, 1))
	draw_objective_panel("main_objective", mission.main_objective, "loc_misison_board_main_objective_title", true, Vector3(20, 42, 1))

	if mission.side_objective then
		draw_objective_panel("main_objective", mission.side_objective, "loc_mission_board_side_objective_title", false, Vector3(20, 220, 1))
	end

	ProtoUI.draw_rect(Vector3(260, 0, -5), Vector2(2, 480), Color(128, 169, 211, 158))
	ProtoUI.draw_bitmap_uv("content/ui/materials/mission_board/mission_line", Vector2(0, 1), Vector2(1, 0), Vector3(260, 0, -5), Vector2(2, 480), ui_color_green)
	ProtoUI.end_group("objectives")

	local play_button_panel_size = Vector2(396, 276)

	ProtoUI.begin_group("play_button", Vector3(170, 684, 5))

	local play_button_size = Vector2(347, 76)
	local play_button_pos = Vector3(0, -50, 1) + ProtoUI.align_box(ProtoUI.SOUTH, play_button_size, Vector3(0, 0, 0), play_button_panel_size)
	local party_manager = self._party_manager
	local _, play_button_clicked = play_button("play_button", play_button_pos, mission.is_locked or not party_manager:are_all_members_in_hub())

	if mission.is_locked then
		local pos = play_button_pos + Vector2(-50, 10 + play_button_size[2])
		local size = Vector2(447, 32)

		ProtoUI.draw_rect(pos, size, Color(200, 0, 0, 0))

		local label = Localize("loc_mission_board_view_required_level", true, mission)

		ProtoUI.draw_text(label, ProtoUI.fonts.itc_novarese_bold, 22, Vector3(0, 0, 1) + pos, size, ui_color_green, "flags", Gui.MultiLine, "horizontal_align_center", "vertical_align_center", "shadow", Color(0, 0, 0))
	elseif play_button_clicked or ProtoUI.input_get("confirm_pressed") then
		self:_start_mission(mission.id)
	end

	ProtoUI.end_group("play_button")
	ProtoUI.end_group("side_panel")
end

local function stepper_button(idx, label, pos, size)
	ProtoUI.begin_group(idx, pos)

	local button, is_clicked = ProtoUI.use_data("step_left", ProtoUI.behaviour_button, Vector3(0, 0, 0), size)

	ProtoUI.draw_rect(Vector3(0, 0, 0), size, Color(200, 0, 0, 0))
	ProtoUI.draw_text(label, ProtoUI.fonts.proxima_nova_bold, 50, Vector3(-10, -10, 2), Vector2(20, 20) + size, Color(169, 211, 158), "flags", Gui.MultiLine, "horizontal_align_center", "vertical_align_center")

	if is_clicked then
		ProtoUI.play_sound(UISoundEvents.default_click)
	elseif button.state == "hover" and button.last_state == "default" then
		ProtoUI.play_sound(UISoundEvents.default_mouse_hover)
	end

	ProtoUI.end_group(idx)

	return is_clicked
end

MissionBoardView._draw_quickplay_side_panel = function (self)
	ProtoUI.begin_group("side_panel", Vector3(1170, 50, 500))

	local ui_color_green = Color(169, 211, 158)

	ProtoUI.begin_group("header", Vector3(0, 20, 30))

	local header_size = Vector2(680, 80)

	ProtoUI.draw_rect(Vector3(0, 0, 0), header_size, Color(200, 0, 0, 0))
	borders(Vector3(0, 0, 1), header_size)
	ProtoUI.draw_text(Utf8.upper(Localize("loc_mission_board_quickplay_header")), ProtoUI.fonts.proxima_nova_bold, 48, Vector3(30, 0, 2), header_size, ui_color_green, "flags", Gui.MultiLine, "vertical_align_center")
	ProtoUI.end_group("header")
	ProtoUI.begin_group("main", Vector3(0, 99, 0))

	local location_size = Vector2(679.9999999936, 324.5454545424)

	ProtoUI.draw_bitmap("content/ui/materials/missions/quickplay", Vector3(0, 0, 0), location_size)
	ProtoUI.draw_bitmap("content/ui/materials/frames/inner_shadow_medium", Vector3(0, 0, 1), location_size, Color(255, 16, 32, 16))
	borders(Vector3(0, 0, 2), location_size)
	outer_glow(Vector3(0, 0, -3), location_size, Color(255, 16, 32, 16))
	ProtoUI.end_group("main")
	ProtoUI.begin_group("line_down", Vector3(370, 420, 1))
	ProtoUI.draw_rect(Vector3(-1, 0, -5), Vector2(2, 480), Color(128, 169, 211, 158))
	ProtoUI.draw_bitmap_uv("content/ui/materials/mission_board/mission_line", Vector2(0, 1), Vector2(1, 0), Vector3(-1, 0, -5), Vector2(2, 480), ui_color_green)
	ProtoUI.end_group("line_down")
	draw_objective_panel("objective", MissionBoardViewSettings.quickplay_fake_mission.objective, "loc_misison_board_main_objective_title", true, Vector3(130, 462, 2))
	ProtoUI.begin_group("difficulty_selector", Vector3(180, 620, 1))

	local difficulty_selector_size = Vector2(380, 180)

	ProtoUI.draw_rect(Vector3(0, 0, 0), difficulty_selector_size, Color(230, 0, 0, 0))
	borders(Vector3(0, 0, 1), difficulty_selector_size)
	ProtoUI.begin_group("header", Vector3(0, 0, 3))

	local difficulty_header_size = Vector2(difficulty_selector_size[1], 40)

	ProtoUI.draw_rect(Vector3(0, 0, 0), difficulty_header_size, Color(200, 0, 0, 0))
	borders(Vector3(0, 0, 1), difficulty_header_size)
	ProtoUI.draw_text(Localize("loc_mission_board_select_difficulty"), ProtoUI.fonts.proxima_nova_medium, 28, Vector3(15, 3, 2), difficulty_header_size, ui_color_green)
	ProtoUI.draw_bitmap("content/ui/materials/gradients/gradient_horizontal", Vector3(0, 0, 1), difficulty_header_size, Color(100, 66, 79, 64))
	ProtoUI.end_group("header")
	ProtoUI.begin_group("body", Vector3(0, 40, 3))

	local danger = ProtoUI.get_data("danger") or 1
	local last_danger = ProtoUI.get_data("last_danger") or danger
	local gamepad_active = InputDevice.gamepad_active
	local stepper_size = Vector2(50, 50)

	if (gamepad_active and stepper_button("stepper_left", "", Vector3(20, 19, 3), stepper_size) or ProtoUI.input_get("navigate_primary_left_pressed")) and danger > 1 then
		danger = danger - 1
	end

	if (gamepad_active and stepper_button("stepper_right", "", Vector3(305, 19, 3), stepper_size) or ProtoUI.input_get("navigate_primary_right_pressed")) and danger < 5 then
		danger = danger + 1
	end

	ProtoUI.begin_group("difficulty", Vector3(90, 10, 5))
	corners(Vector3(0, 0, 0), Vector2(200, 70))
	ProtoUI.draw_bitmap("content/ui/materials/icons/generic/danger", Vector3(0, 10, 3), Vector2(50, 50), ui_color_green)

	local is_hovered = false
	local rect_size = Vector2(22, 48)

	for i = 1, 5 do
		local rect_pos = Vector3(55 + (i - 1) * 28, 10, 1)
		local button, is_clicked = ProtoUI.use_data(i, ProtoUI.behaviour_button, rect_pos - Vector2(3, 5), rect_size + Vector2(6, 10))
		local color = nil

		if is_clicked then
			danger = i
			last_danger = i

			ProtoUI.play_sound(UISoundEvents.default_click)
		elseif button.state == "hover" or button.state == "hot" then
			is_hovered = true
			last_danger = i
		end

		if i <= math.min(last_danger, danger) then
			color = ui_color_green
		elseif i <= math.max(last_danger, danger) then
			color = Color(83, 104, 78)
		else
			color = Color(26, 33, 25)
		end

		ProtoUI.draw_rect(rect_pos, rect_size, color)
	end

	ProtoUI.end_group("difficulty")

	local danger_settings = DangerSettings.by_index[last_danger]

	ProtoUI.draw_text(Utf8.upper(Localize(danger_settings.display_name)), ProtoUI.fonts.proxima_nova_medium, 28, Vector3(0, 20, 2), difficulty_selector_size, ui_color_green, "flags", Gui.MultiLine, "horizontal_align_center", "vertical_align_center")

	if not is_hovered then
		last_danger = danger
	end

	ProtoUI.set_data("danger", danger)
	ProtoUI.set_data("last_danger", last_danger)
	ProtoUI.end_group("body")
	ProtoUI.end_group("difficulty_selector")

	local play_button_panel_size = Vector2(396, 276)

	ProtoUI.begin_group("play_button", Vector3(170, 684, 5))

	local play_button_size = Vector2(347, 76)
	local play_button_pos = Vector3(0, -50, 1) + ProtoUI.align_box(ProtoUI.SOUTH, play_button_size, Vector3(0, 0, 0), play_button_panel_size)
	local party_manager = self._party_manager
	local selected_danger_settings = DangerSettings.by_index[danger]
	local is_locked = self._local_player_level < selected_danger_settings.required_level
	local _, play_button_clicked = play_button("play_button", play_button_pos, is_locked or not party_manager:are_all_members_in_hub())

	if is_locked then
		local pos = play_button_pos + Vector2(-50, 10 + play_button_size[2])
		local size = Vector2(447, 32)

		ProtoUI.draw_rect(pos, size, Color(200, 0, 0, 0))

		local label = Localize("loc_mission_board_view_required_level", true, selected_danger_settings)

		ProtoUI.draw_text(label, ProtoUI.fonts.itc_novarese_bold, 22, Vector3(0, 0, 1) + pos, size, ui_color_green, "flags", Gui.MultiLine, "horizontal_align_center", "vertical_align_center", "shadow", Color(0, 0, 0))
	elseif play_button_clicked or ProtoUI.input_get("confirm_pressed") then
		self:_start_mission("qp:challenge=" .. danger)
	end

	ProtoUI.end_group("play_button")
	ProtoUI.end_group("side_panel")
end

MissionBoardView._start_mission = function (self, backend_id)
	self._party_manager:wanted_mission_selected(backend_id)

	if Managers.narrative:complete_event(Managers.narrative.EVENTS.mission_board) then
		PlayerVOStoryStage.refresh_hub_story_stage()
	end

	Managers.ui:close_view(self.view_name)
	ProtoUI.play_sound(UISoundEvents.mission_board_start_mission)
end

local _time_table = {
	minutes = 0,
	seconds = 0
}

local function get_time_table(t)
	local seconds = t % 60
	_time_table.minutes = (t - seconds) / 60
	_time_table.seconds = seconds

	return _time_table
end

MissionBoardView._draw_happening_widget = function (self, happening, position)
	local next_happening = math.max(0, happening.expiry_game_time - ProtoUI.t)
	local main_circumstance = happening.circumstances[1]
	local main_circumstance_template = CircumstanceTemplates[main_circumstance]
	local happening_icon, happening_text = nil
	local circumstance_ui_data = main_circumstance_template and main_circumstance_template.ui

	if circumstance_ui_data then
		happening_text = Localize(circumstance_ui_data and circumstance_ui_data.display_name or "loc_mission_speaker_title_text")
		happening_icon = circumstance_ui_data and circumstance_ui_data.icon or "content/ui/materials/icons/generic/transmission"
	elseif next_happening < 3600 then
		local tt = get_time_table(next_happening)
		happening_text = Localize("loc_mission_board_view_time_til_next_sync", true, tt)
		happening_icon = "content/ui/materials/icons/generic/transmission"
	end

	if math.floor(next_happening) == 3 then
		if not self._play_happening_refresh_sound then
			ProtoUI.play_sound(UISoundEvents.mission_board_receiving_soon)

			self._play_happening_refresh_sound = true
		end
	elseif next_happening >= 4 and self._play_happening_refresh_sound then
		ProtoUI.play_sound(UISoundEvents.mission_board_receiving)

		self._play_happening_refresh_sound = false
	end

	if happening_icon then
		local ui_color_green = Color(169, 211, 158)
		local ui_color_grey = Color(161, 175, 158)

		ProtoUI.begin_group("happening", position)
		ProtoUI.begin_group("header", Vector3(0, 5, 1))

		local header_size = Vector2(480, 50)

		ProtoUI.draw_rect(Vector3(0, 0, 0), header_size, Color(230, 0, 0, 0))
		borders(Vector3(0, 0, 1), header_size)
		ProtoUI.draw_bitmap(happening_icon, Vector3(5, 5, 1), Vector2(40, 40), ui_color_green)
		ProtoUI.draw_text(Localize("loc_mission_info_happening_label"), ProtoUI.fonts.proxima_nova_bold, 18, Vector3(60, 5, 1), header_size, ui_color_grey)
		ProtoUI.draw_text(happening_text, ProtoUI.fonts.itc_novarese_bold, 20, Vector3(60, 25, 1), header_size, ui_color_green)
		ProtoUI.end_group("header")
		ProtoUI.end_group("happening")
	end
end

MissionBoardView._select_mission = function (self, mission)
	if mission ~= self._selected_mission then
		self._selected_mission = mission
		self._selected_alpha = 0
	end
end

MissionBoardView._gamepad_cursor_begin = function (self)
	local last_pressed_device = InputDevice.last_pressed_device
	local cursor_active = last_pressed_device and last_pressed_device:type() ~= "mouse"
	self._cursor_active = cursor_active

	if not cursor_active then
		return
	end

	self._cursor_closest_score = 0
	self._cursor_slow_down = false
	local cursor_input = ProtoUI.input_get("navigate_controller")
	self._cursor_input = cursor_input
	cursor_input[2] = -cursor_input[2]
	self._cursor_state = Vector3.length_squared(cursor_input) > 0.01 and "walking" or "standing"
	local cursor_state = self._cursor_state

	if cursor_state == "walking" then
		self._cursor_input = Vector3.normalize(self._cursor_input)
	else
		self._cursor_input = Vector3.zero()
	end

	self._cursor = Vector3Box.unbox(self._cursor_box)
end

local function point_inside_box(point, box_pos, box_size)
	local delta = point - box_pos

	return delta[1] >= 0 and delta[1] <= box_size[1] and delta[2] >= 0 and delta[2] <= box_size[2]
end

MissionBoardView._gamepad_cursor_item = function (self, mission, pos, size)
	if not self._cursor_active then
		return
	end

	local half_size = 0.5 * size
	local center = pos + half_size
	center[3] = 0
	local is_intersecting = point_inside_box(self._cursor, pos, size)
	local was_nearest = self._cursor_closest_mission == mission

	if is_intersecting then
		self._cursor_slow_down = true
	end

	local delta_dir, delta_len = Vector3.direction_length(center - self._cursor)
	local dot = Vector3.dot(self._cursor_input, delta_dir)
	local score = self._cursor_state ~= "standing" and dot * 1 / delta_len or 0

	if self._cursor_closest_score < score then
		self._cursor_closest_score = score
		self._cursor_closest_mission = mission

		Vector3Box.store(self._cursor_closest_pos, center)
		Vector3Box.store(self._cursor_closest_size, half_size)
	end

	return is_intersecting, was_nearest
end

MissionBoardView._gamepad_cursor_end = function (self)
	if not self._cursor_active then
		return
	end

	local dt = ProtoUI.dt
	local speed = self._cursor_slow_down and 550 or 550
	local dir = self._cursor_input * speed * dt
	local cursor = self._cursor
	local cursor_size = Vector3Box.unbox(self._cursor_size_box)
	local closest_pos = Vector3Box.unbox(self._cursor_closest_pos)
	local closest_size = Vector3Box.unbox(self._cursor_closest_size)
	local target_size = closest_size

	if self._cursor_state == "standing" then
		dir = dir + 10 * dt * (closest_pos - cursor)
	else
		target_size = Vector2(50, 50)
	end

	cursor_size = cursor_size + 5 * dt * (target_size - cursor_size)
	cursor[1] = math.clamp(cursor[1] + dir[1], 150, 1200)
	cursor[2] = math.clamp(cursor[2] + dir[2], 200, 950)

	outer_glow(Vector3(cursor[1] - cursor_size[1], cursor[2] - cursor_size[2], 901), 2 * cursor_size, Color(255, 250, 189, 73))
	Vector3Box.store(self._cursor_box, cursor)
	Vector3Box.store(self._cursor_size_box, cursor_size)
end

MissionBoardView.draw = function (self, dt, t, input_service)
	if self._exit_animation_done then
		return
	end

	ProtoUI.begin_frame(self._gui, dt, t, input_service)
	ProtoUI.draw_rect(ProtoUI.screen_pos, ProtoUI.screen_size, Color(64, 0, 0, 0))

	local screen_width = ProtoUI.screen_size[1]

	if screen_width > 1920 then
		ProtoUI.draw_bitmap_uv("content/ui/materials/gradients/gradient_horizontal", Vector2(1, 0), Vector2(0, 1), ProtoUI.screen_pos + Vector3(0, 0, 3), Vector2(0.5 * (ProtoUI.screen_size[1] - 1920), ProtoUI.screen_size[2]), Color(255, 0, 0, 0))
		ProtoUI.draw_bitmap("content/ui/materials/gradients/gradient_horizontal", Vector3(1920, 0, 3), Vector2(0.5 * (ProtoUI.screen_size[1] - 1920), ProtoUI.screen_size[2]), Color(255, 0, 0, 0))
	end

	local screen_corner_size = Vector2(167, 230)

	ProtoUI.draw_bitmap("content/ui/materials/frames/screen/mission_board_01_upper", ProtoUI.screen_pos + Vector3(0, 0, 10), screen_corner_size)
	ProtoUI.draw_bitmap("content/ui/materials/frames/screen/mission_board_01_lower", ProtoUI.screen_pos + Vector3(0, ProtoUI.screen_size[2] - screen_corner_size[2], 10), screen_corner_size)
	ProtoUI.draw_bitmap_uv("content/ui/materials/frames/screen/mission_board_01_lower", Vector2(1, 0), Vector2(0, 1), ProtoUI.screen_pos + Vector3(ProtoUI.screen_size[1] - screen_corner_size[1], ProtoUI.screen_size[2] - screen_corner_size[2], 10), screen_corner_size)
	ProtoUI.make_render_pass(0, "mission_board_render_target", true, self._rt)

	ProtoUI.render_pass = "mission_board_render_target"

	if self._world_spawner then
		self._world_spawner:update(dt, t)
	end

	self:_update_fetch_missions(t)

	if self._backend_data then
		ProtoUI.begin_group("MissionBoardView")

		local happening = self._backend_data.happening

		if happening then
			self:_draw_happening_widget(happening, Vector3(200, 50, 100))
		end

		ProtoUI.begin_group("missions")
		self:_gamepad_cursor_begin()

		local qp_pos = MissionBoardViewSettings.quickplay_fake_mission.position

		if self:draw_quickplay_widget(Vector3(qp_pos[1], qp_pos[2], 100)) then
			self:_select_mission("quickplay")
		end

		local flash_mission = self._flash_mission_widget

		if flash_mission then
			local position = flash_mission.position
			local widget_pos = Vector3(position[1], position[2], 100)

			if self:draw_medium_mission_widget(flash_mission, widget_pos) then
				self:_select_mission(flash_mission)
			end
		end

		for id, mission in pairs(self._mission_widgets_by_id) do
			local position = mission.position
			local widget_pos = Vector3(position[1], position[2], 100)

			if self:draw_small_mission_widget(mission, widget_pos, position.length) then
				self:_select_mission(mission)
			end
		end

		self:_gamepad_cursor_end()
		ProtoUI.end_group("missions")

		local selected_mission = self._selected_mission

		if selected_mission then
			if selected_mission == "quickplay" then
				self:_draw_quickplay_side_panel()
			else
				self:_draw_mission_detail_side_panel(selected_mission)
			end
		end

		ProtoUI.end_group("MissionBoardView")
	end

	Gui.bitmap(self._gui, self._mat, "render_pass", "to_screen", Vector3(0, 0, 1), ProtoUI.resolution)
	ProtoUI.end_frame()
end

MissionBoardView._update_fetch_missions = function (self, t)
	if t < self._backend_data_expiry_time or self._is_fetching_missions then
		return
	end

	self._is_fetching_missions = true
	local missions_future = Managers.data_service.mission_board:fetch(nil, 1)

	missions_future:next(function (data)
		self._backend_data = data
		self._backend_data_expiry_time = data.expiry_game_time
		self._is_fetching_missions = false

		self:_join_mission_data(data.missions)
	end):catch(function (error)
		Log.error("MissionBoardView", "Fetching missions failed %s", error)

		self._backend_data_expiry_time = t + 5
		self._is_fetching_missions = false
	end)
end

MissionBoardView._get_free_position = function (self, preferred_index)
	local free_widget_positions = self._free_widget_positions
	local index = preferred_index
	local free_widget_positions_len = #free_widget_positions

	for i = 0, free_widget_positions_len do
		index = (index - 1 + 23 * i) % free_widget_positions_len + 1

		if free_widget_positions[index] then
			free_widget_positions[index] = false

			return MissionBoardViewSettings.mission_positions[index]
		end
	end

	return false
end

MissionBoardView._join_mission_data = function (self, missions)
	local free_widget_positions = self._free_widget_positions
	local mission_widgets_by_id = self._mission_widgets_by_id

	for id, mission in pairs(mission_widgets_by_id) do
		if not table.find_by_key(missions, "id", id) then
			free_widget_positions[mission.position.index] = true
			mission_widgets_by_id[id] = nil
		end
	end

	local has_flash_mission_changed = false

	for i = 1, #missions do
		local backend_mission = missions[i]

		if self._mission_widgets_by_id[backend_mission.id] then
			-- Nothing
		elseif backend_mission.flags.flash and not has_flash_mission_changed and (not self._flash_mission_widget or self._flash_mission_widget.id ~= backend_mission.id) then
			self._flash_mission_widget = self:_make_mission_data(backend_mission, MissionBoardViewSettings.flash_position)
			has_flash_mission_changed = true
		else
			local position = self:_get_free_position(backend_mission.displayIndex or math.random(#self._free_widget_positions))

			if position then
				self._mission_widgets_by_id[backend_mission.id] = self:_make_mission_data(backend_mission, position)
			else
				Log.warning("MissionBoardView", "Received more missions than can be shown on the mission board")
			end
		end
	end
end

MissionBoardView._make_mission_data = function (self, mission, position)
	local mission_template = MissionTemplates[mission.map]

	if not mission_template then
		Log.warning("MissionBoardView", "Mission with id %q has map %q not present in MissionTemplates", mission.id, mission.map)

		return false
	end

	local danger = DangerSettings.calculate_danger(mission.challenge, mission.resistance)
	local danger_settings = DangerSettings.by_index[danger]
	local circumstance = mission.circumstance

	if mission.resistance ~= danger_settings.expected_resistance then
		if not circumstance or circumstance == "default" then
			if danger_settings.expected_resistance < mission.resistance then
				circumstance = "dummy_more_resistance_01"
			else
				circumstance = "dummy_less_resistance_01"
			end
		elseif circumstance ~= "dummy_less_resistance_01" and circumstance ~= "dummy_more_resistance_01" then
			Log.warning("MissionBoardView", "Mission with id %q has both a circumstance and a resistance change", mission.id)
		end
	end

	local xp = mission.xp
	local credits = mission.credits
	local extraRewards = mission.extraRewards

	if extraRewards and extraRewards.circumstance then
		xp = xp + extraRewards.circumstance.xp
		credits = credits + mission.extraRewards.circumstance.credits
	end

	local main_objective_type = MissionObjectiveTemplates[mission_template.objectives].main_objective_type
	local objective_fluff = MissionBoardViewSettings.objective_fluff[main_objective_type]
	local mission_brief_vo = mission_template.mission_brief_vo
	local vo_profile = mission.missionGiver or mission_brief_vo and mission_brief_vo.vo_profile
	local npc_settings = DialogueSpeakerVoiceSettings[vo_profile]
	local main_objective = {
		image = math.random_array_entry(objective_fluff),
		name = mission_template.mission_type_name,
		text = mission_template.mission_description,
		icon = mission_template.mission_type_icon,
		npc_name = npc_settings and "// " .. Localize(npc_settings.full_name),
		npc_image = npc_settings and npc_settings.material_small or "content/ui/materials/base/ui_default_base",
		rewards = {
			xp = xp,
			credits = credits
		}
	}
	local side_objective = nil
	local side_mission_template = MissionObjectiveTemplates.side_mission.objectives[mission.sideMission]

	if mission.flags.side and side_mission_template then
		side_objective = {
			name = side_mission_template.header,
			text = side_mission_template.description,
			icon = side_mission_template.icon,
			rewards = extraRewards and extraRewards.sideMission
		}
	end

	local mission_widget = {
		play_enter_animation = true,
		backend = mission,
		template = mission_template,
		zone = Zones[mission_template.zone_id],
		material_big = mission_template.texture_big:gsub("/textures/", "/materials/"),
		material_small = mission_template.texture_big:gsub("/textures/", "/materials/"),
		position = position,
		danger = danger,
		challenge = mission.challenge,
		resistance = mission.resistance,
		id = mission.id,
		start_game_time = mission.start_game_time,
		expiry_game_time = mission.expiry_game_time,
		is_flash = mission.flags.flash,
		is_locked = self._local_player_level < mission.requiredLevel,
		required_level = mission.requiredLevel,
		main_objective = main_objective,
		side_objective = side_objective,
		circumstance = circumstance and CircumstanceTemplates[circumstance].ui,
		fluff_frame = math.random_array_entry(MissionBoardViewSettings.fluff_frames),
		seed = math.next_random(math.next_random(mission.start_game_time))
	}

	return mission_widget
end

MissionBoardView.trigger_resolution_update = function (self)
	local _, gui_height = Gui.resolution()

	Material.set_scalar(self._mat, "scanline_intensity", math.max(0.1, math.ilerp(720, 1080, gui_height)))
end

MissionBoardView.triggered_on_enter_animation = function (self)
	return self._triggered_on_enter_animation
end

MissionBoardView.trigger_on_enter_animation = function (self)
	self._triggered_on_enter_animation = true
end

MissionBoardView.trigger_on_exit_animation = function (self)
	self._triggered_on_exit_animation = true
end

MissionBoardView.on_exit_animation_done = function (self)
	return self._exit_animation_done
end

MissionBoardView.allow_close_hotkey = function (self)
	return true
end

MissionBoardView.is_using_input = function (self)
	return true
end

MissionBoardView.loading = function (self)
	return false
end

MissionBoardView.dialogue_system = function (self)
	return
end

MissionBoardView.post_update = function (self)
	return
end

MissionBoardView.update = function (self)
	self:_update_exit()
end

MissionBoardView.set_render_scale = function (self)
	return
end

MissionBoardView.can_exit = function (self)
	return true
end

return MissionBoardView
