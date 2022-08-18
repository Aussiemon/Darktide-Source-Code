-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
local MissionBoardViewSettings = require("scripts/ui/views/mission_board_view_v2/mission_board_view_settings")
local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local ProtoUI = require("scripts/ui/proto_ui/proto_ui")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local Zones = require("scripts/settings/zones/zones")
local MissionBoardView = class("MissionBoardView")

local function noise(s, ...)
	local hash = math.next_random
	local _, x = hash(hash(s), ...)

	return x
end

MissionBoardView.init = function (self, settings)
	local world = Managers.ui._world
	self._gui = World.create_screen_gui(world, "immediate")
	self._world = world
	self._missions_data_expiry_time = 0
	self.view_name = settings.name

	Managers.input:push_cursor(self.__class_name)

	self._has_cursor = true

	Managers.event:register(self, "event_register_camera", "event_register_camera")

	self._mission_widget_units = {}
	self._world_spawner = UIWorldSpawner:new("mission_board_v2", 1, "ui", settings.name)

	self._world_spawner:spawn_level("content/levels/ui/mission_board_v2/mission_board_v2")
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
	if self._gui then
		World.destroy_gui(self._world, self._gui)

		self._gui = nil
	end

	if self._has_cursor then
		Managers.input:pop_cursor(self.__class_name)

		self._has_cursor = false
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end
end

MissionBoardView.event_register_camera = function (self, camera_unit)
	Managers.event:unregister(self, "event_register_camera")

	self._camera_unit = camera_unit

	self._world_spawner:create_viewport(camera_unit, "mission_board_v2_viewport", "default", 1, "content/shading_environments/ui/mission_board_v2")
end

local function get_mission_template_objective_and_zone(mission)
	local mission_template = MissionTemplates[mission.map]
	local zone = Zones[mission_template.zone_id]
	local objectives = mission_template.objectives
	local main_objective = objectives and MissionObjectiveTemplates[objectives].main_objective_type

	return mission_template, main_objective or "default", zone
end

local function calculate_danger_level(mission)
	local danger = mission.challenge

	return danger, MissionBoardViewSettings.difficulty_lookup[danger]
end

local function corners(pos, size, corner_length)
	corner_length = corner_length or 6
	local corner_size = Vector2(corner_length, corner_length)
	local opposite = size - corner_size
	local material = "content/ui/materials/mission_board_v2/corner_01"
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

local function borders(pos, size)
	local color = Color(128, 169, 211, 158)
	local size_x = Vector2(size[1], 1.5)
	local size_y = Vector2(1.5, size[2])
	local opposite = pos + size + Vector2(1, 1)

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
	local size = Vector2(422.4, 201.6)
	local mission_template, main_objective = get_mission_template_objective_and_zone(mission)
	local mission_display_data = MissionBoardViewSettings.mission_lookup[mission.map] or MissionBoardViewSettings.mission_lookup.default
	local objective_display_data = MissionBoardViewSettings.objective_lookup[main_objective] or MissionBoardViewSettings.objective_lookup.default
	local ui_color_green = Color(169, 211, 158)
	local is_clicked = nil

	ProtoUI.begin_group(mission.id, pos)

	local _ = nil
	_, is_clicked = ProtoUI.use_data("button_state", ProtoUI.behaviour_button, Vector3(0, 0, 0), size)

	ProtoUI.draw_bitmap("content/ui/materials/mission_board_v2/hourglass_icon", Vector3(3, -17, 2), Vector2(18.599999999999998, 18.599999999999998), ui_color_green)

	local seconds_left = math.max(0, mission.expiry_game_time - ProtoUI.t)
	local minutes_left = seconds_left / 60

	ProtoUI.draw_text(string.format("%02d:%02d", minutes_left, seconds_left % 60), "content/ui/fonts/itc_novarese_bold", 12, Vector3(20, -13, 2), Vector2(100, 100), ui_color_green)
	ProtoUI.begin_group("timer_bar", Vector3(60, -11, 2))

	local timer_bar_size = Vector2(363, 5)
	local timer_percent = 1 - math.ilerp(mission.start_game_time, mission.expiry_game_time, ProtoUI.t)

	ProtoUI.draw_rect(Vector3(-1, -1, 0), timer_bar_size + Vector2(3, 3), ui_color_green)
	ProtoUI.draw_rect(Vector3(0, 0, 1), timer_bar_size, Color(200, 0, 0, 0))
	ProtoUI.draw_rect(Vector3(0, 0, 2), Vector2(timer_bar_size[1] * timer_percent, timer_bar_size[2]), Color.golden_rod())
	ProtoUI.end_group("timer_bar")
	ProtoUI.begin_group("location", Vector3(0, 0, 1))

	local location_size = Vector2(422.4, 201.6)

	ProtoUI.draw_bitmap(mission_display_data.big_texture, Vector3(0, 0, 0), location_size)

	local title_text = ".//" .. Utf8.lower(Localize(mission_template.mission_name)) .. "//"

	ProtoUI.draw_bitmap("content/ui/materials/mission_board_v2/gradient", Vector3(0, location_size[2] - 36, 1), Vector2(location_size[1], 36), Color(255, 0, 0, 0))
	ProtoUI.draw_text(title_text, "content/ui/fonts/proxima_nova_bold", 22, Vector3(-15, -5, 2), location_size, ui_color_green, "flags", Gui.MultiLine, "horizontal_align_right", "vertical_align_bottom", "shadow", Color(0, 0, 0))
	corners_borders(Vector3(0, 0, 3), location_size)
	ProtoUI.draw_bitmap("content/ui/materials/mission_board_v2/aquila", Vector3(0.5 * (location_size[1] - 60), 5, 5), Vector2(60, 20), ui_color_green)
	ProtoUI.end_group("location")

	if mission.flags.flash then
		ProtoUI.draw_bitmap("content/ui/materials/mission_board_v2/flash_mission_icon", Vector3(-40, -10, 100), Vector2(49.6, 49.6), Color.golden_rod())
	end

	ProtoUI.begin_group("difficulty", Vector3(10, 0, 50))

	local danger_number = calculate_danger_level(mission)
	local difficulty_holder_pos = Vector2(0, 7, 0)
	local difficulty_holder_size = Vector2(113.60000000000002, 37.2)

	ProtoUI.draw_rect(difficulty_holder_pos, difficulty_holder_size, Color(200, 0, 0, 0))
	corners_borders(Vector3(0, 0, 1) + difficulty_holder_pos, difficulty_holder_size)
	ProtoUI.draw_bitmap("content/ui/materials/mission_board_v2/danger_icon", Vector3(0, 0, 3), Vector2(51.2, 51.2), ui_color_green)

	for i = 0, 4, 1 do
		local color = (i < danger_number and ui_color_green) or Color(26, 33, 25)

		ProtoUI.draw_rect(Vector3(50 + i * 11, 14, 3), Vector2(6.4, 24), color)
	end

	ProtoUI.end_group("difficulty")
	ProtoUI.begin_group("objective", Vector3(-30, 55, 10))

	local objective_size = Vector2(96, 110.39999999999999)

	ProtoUI.draw_bitmap(objective_display_data.big_texture, Vector3(0, 0, 0), objective_size)
	corners_borders(Vector3(0, 0, 1), objective_size)
	ProtoUI.end_group("objective")

	local circumstance = mission.circumstance
	local circumstance_ui_data = circumstance and CircumstanceTemplates[circumstance].ui

	if circumstance_ui_data then
		ProtoUI.begin_group("circumstance", Vector3(size[1] + -30, 7, 15))

		local circumstance_size = Vector2(40, 40)

		ProtoUI.draw_rect(Vector3(0, 0, 0), circumstance_size, Color(200, 0, 0, 0))
		corners_borders(Vector3(0, 0, 1), circumstance_size)
		ProtoUI.draw_bitmap(circumstance_ui_data.icon, Vector3(5, 5, 3), Vector2(30, 30), Color.golden_rod())
		ProtoUI.end_group("circumstance")
	end

	ProtoUI.end_group(mission.id)

	return is_clicked
end

MissionBoardView.draw_small_mission_widget = function (self, mission, pos)
	local size = Vector2(80, 120)
	local _, main_objective, _ = get_mission_template_objective_and_zone(mission)
	local mission_display_data = MissionBoardViewSettings.mission_lookup[mission.map] or MissionBoardViewSettings.mission_lookup.default
	local objective_display_data = MissionBoardViewSettings.objective_lookup[main_objective] or MissionBoardViewSettings.objective_lookup.default
	local ui_color_green = Color(169, 211, 158)
	local is_clicked = nil

	ProtoUI.begin_group(mission.id, pos)

	local _ = nil
	_, is_clicked = ProtoUI.use_data("button_state", ProtoUI.behaviour_button, Vector3(0, 0, 0), size)

	ProtoUI.begin_group("difficulty", Vector3(0, 0, 10))
	ProtoUI.draw_rect(Vector3(0, 0, 0), Vector2(80, 28), Color(200, 0, 0, 0))
	borders(Vector3(0, 0, 2), Vector2(80, 28))

	local danger_number = calculate_danger_level(mission)

	ProtoUI.draw_bitmap("content/ui/materials/mission_board_v2/danger_icon", Vector3(0, 0, 3), Vector2(32, 32), ui_color_green)

	for i = 0, 4, 1 do
		local color = (i < danger_number and ui_color_green) or Color(26, 33, 25)

		ProtoUI.draw_rect(Vector3(30 + i * 8.25, 5.5, 3), Vector2(4.8, 18), color)
	end

	ProtoUI.end_group("difficulty")

	local location_pos = Vector3(0, 27, 4)
	local location_size = Vector2(80, 92)

	ProtoUI.draw_bitmap(mission_display_data.small_texture, location_pos, location_size)
	corners_borders(Vector3(0, 0, 1) + location_pos, location_size)
	ProtoUI.begin_group("objective_fluff", location_pos + Vector3(20, 15, -5))
	ProtoUI.draw_bitmap(objective_display_data.big_texture, Vector3(0, 0, 0), location_size, Color(100, 255, 255, 255))
	borders(Vector3(0, 0, 1), location_size)

	local seed = mission.expiry_game_time
	seed = seed + math.floor(noise(seed) + Managers.time:time("main"))
	local lat_lng_fluff = string.format("LAT%03d-LON%03d", noise(seed, 0, 999), noise(seed, 0, 999))

	ProtoUI.draw_text(lat_lng_fluff, "content/ui/fonts/proxima_nova_bold", 8, Vector3(-3, -2, 1), location_size, ui_color_green, "flags", Gui.MultiLine, "horizontal_align_right", "vertical_align_bottom")
	ProtoUI.end_group("objective_fluff")

	local circumstance = mission.circumstance
	local circumstance_ui_data = circumstance and CircumstanceTemplates[circumstance].ui

	if circumstance_ui_data then
		ProtoUI.begin_group("circumstance", Vector3(60, 36, 10))

		local circumstance_size = Vector2(32, 32)

		ProtoUI.draw_rect(Vector3(0, 0, 0), circumstance_size, Color(200, 0, 0, 0))
		borders(Vector3(0, 0, 1), circumstance_size)
		ProtoUI.draw_bitmap(circumstance_ui_data.icon, Vector3(3, 3, 3), Vector2(26, 26), Color.golden_rod())
		ProtoUI.end_group("circumstance")
	end

	ProtoUI.begin_group("objective", Vector3(-16, 68, 10))

	local objective_size = Vector2(32, 32)

	ProtoUI.draw_rect(Vector3(0, 0, 0), objective_size, Color(200, 0, 0, 0))
	borders(Vector3(0, 0, 1), objective_size)
	ProtoUI.draw_bitmap(objective_display_data.icon_texture, Vector3(3, 3, 3), Vector2(26, 26), ui_color_green)
	ProtoUI.end_group("objective")
	ProtoUI.end_group(mission.id)

	return is_clicked
end

local function draw_reward(idx, material, amount, pos)
	local ui_color_green = Color(169, 211, 158)
	local size = Vector2(72, 72)

	ProtoUI.begin_group(idx, pos)
	ProtoUI.draw_rect(Vector3(0, 0, 0), size, Color(200, 0, 0, 0))
	corners(Vector3(0, 0, 1), size)
	ProtoUI.draw_bitmap(material, Vector3(0.5 * (size[1] - 32), 10, 2), Vector2(32, 32), ui_color_green)
	ProtoUI.draw_text(amount, "content/ui/fonts/proxima_nova_bold", 16, Vector3(0, 40, 2), Vector2(size[1], 64), ui_color_green, "flags", Gui.MultiLine, "horizontal_align_center")
	ProtoUI.end_group(idx)
end

MissionBoardView._draw_side_panel = function (self, mission)
	ProtoUI.begin_group("side_panel", Vector3(1170, 50, 500))

	local ui_color_green = Color(169, 211, 158)
	local mission_template, main_objective, zone = get_mission_template_objective_and_zone(mission)
	local mission_display_data = MissionBoardViewSettings.mission_lookup[mission.map] or MissionBoardViewSettings.mission_lookup.default
	local objective_display_data = MissionBoardViewSettings.objective_lookup[main_objective] or MissionBoardViewSettings.objective_lookup.default
	local danger_number, danger_label = calculate_danger_level(mission)
	local header_size = Vector2(680, 100)
	local header_pos = Vector3(0, 0, 30)

	ProtoUI.draw_rect(header_pos, header_size, Color(200, 0, 0, 0))
	corners_borders(Vector3(0, 0, 1) + header_pos, header_size)
	ProtoUI.draw_text(Utf8.upper(Localize(danger_label)), "content/ui/fonts/proxima_nova_bold", 38, Vector3(-20, 44, 2) + header_pos, header_size, ui_color_green, "horizontal_align_right", "flags", Gui.MultiLine)
	ProtoUI.begin_group("difficulty", Vector3(0, 20, 50))
	ProtoUI.draw_bitmap("content/ui/materials/mission_board_v2/danger_icon", Vector3(0, -6, 3), Vector2(100, 100), ui_color_green)

	for i = 0, 4, 1 do
		local color = (i < danger_number and ui_color_green) or Color(26, 33, 25)

		ProtoUI.draw_rect(Vector3(95 + i * 22, 20, 1), Vector2(12.8, 48), color)
	end

	ProtoUI.end_group("difficulty")
	ProtoUI.begin_group("timer", Vector3(0, 0, 5) + header_pos)

	local timer_size = Vector2(680, 20)
	local timer_percent = 1 - math.ilerp(mission.start_game_time, mission.expiry_game_time, ProtoUI.t)

	ProtoUI.draw_rect(Vector3(-5, -5, 0), Vector2(10, 10) + timer_size, Color(0, 0, 0))
	corners_borders(Vector3(-5, -5, 3), Vector2(10, 10) + timer_size)
	ProtoUI.draw_bitmap("content/ui/materials/mission_board_v2/timer_bar", Vector3(0, 0, 1), Vector2(timer_size[1] * timer_percent, timer_size[2]), Color.golden_rod())

	local seconds_left = math.max(0, mission.expiry_game_time - ProtoUI.t)
	local minutes_left = seconds_left / 60

	ProtoUI.draw_text(string.format("%02d:%02d", minutes_left, seconds_left % 60), "content/ui/fonts/itc_novarese_bold", 22, Vector3(-30, 0, 2), timer_size, Color(255, 255, 255), "horizontal_align_right", "flags", Gui.MultiLine, "shadow", Color(0, 0, 0))
	ProtoUI.end_group("timer")
	ProtoUI.begin_group("main", Vector3(10, 110, 0))

	local location_size = Vector2(633.6, 302.40000000000003)

	ProtoUI.draw_bitmap(mission_display_data.big_texture, Vector3(0, 0, 0), location_size)
	borders(Vector3(0, 0, 1), location_size)
	ProtoUI.begin_group("location_name", Vector3(-15, 20, 10))

	local title_size = Vector2(500, 48)
	local title_text = Localize(mission_template.mission_name) .. "\n" .. Localize(zone.name)

	ProtoUI.draw_rect(Vector3(0, 0, 0), title_size, Color(235, 0, 0, 0))
	ProtoUI.draw_text(title_text, "content/ui/fonts/itc_novarese_bold", 22, Vector3(3, 3, 1), title_size, ui_color_green, "flags", Gui.MultiLine)
	ProtoUI.end_group("location_name")
	ProtoUI.end_group("main")
	ProtoUI.begin_group("main_side", Vector3(40, 80, 0))
	ProtoUI.begin_group("main_objective", Vector3(480, 130, 7))

	local objective_fluff_size = Vector2(179.20000000000002, 224)
	local objective_texture = objective_display_data.big_texture

	ProtoUI.draw_bitmap(objective_texture, Vector3(0, 0, 0), objective_fluff_size)
	corners_borders(Vector3(0, 0, 1), objective_fluff_size)
	ProtoUI.end_group("main_objective")

	local side_fluff_position = Vector3(520, 170, 2)
	local side_fluff_size = Vector2(164, 204)

	ProtoUI.begin_group("side_fluff", side_fluff_position)
	ProtoUI.draw_bitmap("content/ui/materials/mission_board_v2/icon_objective_big_fluff", Vector3(0, 0, 0), side_fluff_size)
	corners_borders(Vector3(0, 0, 1), side_fluff_size)
	ProtoUI.end_group("side_fluff")
	ProtoUI.end_group("main_side")

	local circumstance = mission.circumstance or "default"
	local circumstance_ui_data = CircumstanceTemplates[circumstance].ui

	if circumstance_ui_data then
		ProtoUI.begin_group("circumstance", Vector3(10, 351, 1))

		local circumstance_size = Vector2(510, 62)

		ProtoUI.draw_rect(Vector3(0, 0, 0), circumstance_size, Color(150, 0, 0, 0))
		ProtoUI.draw_bitmap(circumstance_ui_data.icon, Vector3(8, 2, 1), Vector2(48, 48), Color.golden_rod())
		ProtoUI.draw_text(Localize(circumstance_ui_data.display_name), "content/ui/fonts/itc_novarese_bold", 20, Vector3(80, 10, 1), circumstance_size, Color.golden_rod())
		ProtoUI.draw_text("Lorem ipsum dolor sit amet.", "content/ui/fonts/proxima_nova_bold", 18, Vector3(80, 35, 1), circumstance_size, Color.golden_rod())
		corners_borders(Vector3(0, 0, 2), circumstance_size)
		ProtoUI.draw_text(Localize("loc_mission_info_circumstance_label"), "content/ui/fonts/proxima_nova_bold", 18, Vector3(-5, 5, 1), circumstance_size, Color(100, 161, 175, 158), "flags", Gui.MultiLine, "vertical_align_top", "horizontal_align_right")
		ProtoUI.end_group("circumstance")
	end

	local objective_icon = objective_display_data.icon_texture
	local main_objective_size = Vector2(460, 160)

	ProtoUI.begin_group("main_objective", Vector3(10, 440, 1))
	ProtoUI.draw_rect(Vector3(0, 0, 0), main_objective_size, Color(230, 0, 0, 0))
	corners(Vector3(0, 0, 1), main_objective_size)
	ProtoUI.draw_bitmap("content/ui/materials/mission_board_v2/aquila", Vector3(0.5 * (main_objective_size[1] - 60), -3, 1), Vector2(60, 20), ui_color_green)
	ProtoUI.draw_bitmap(objective_icon, Vector3(22, 0.5 * (main_objective_size[2] - 78), 1), Vector2(78, 78), ui_color_green)
	ProtoUI.draw_text(Localize(mission_template.mission_name), "content/ui/fonts/itc_novarese_bold", 20, Vector3(120, 30, 1), main_objective_size - Vector2(140, 0), ui_color_green)

	local mission_brief_vo = mission_template.mission_brief_vo

	if mission_brief_vo then
		local vo_profile = mission_brief_vo.vo_profile
		local loc_npc_name = "loc_npc_full_name_" .. vo_profile
		local loc_objective_blurb = "loc_" .. vo_profile .. "__" .. mission_brief_vo.vo_events[1] .. "_01"
		local text = Localize(loc_objective_blurb) .. "\n{#color(161,175,158)}" .. Localize(loc_npc_name)

		ProtoUI.draw_text(text, "content/ui/fonts/proxima_nova_bold", 18, Vector3(120, 55, 1), main_objective_size - Vector2(140, 80), Color(166, 169, 211, 158), "flags", Gui.MultiLine + Gui.FormatDirectives)
	end

	draw_reward("experience", "content/ui/materials/mission_board_v2/icon_rewards_experience", mission.xp, Vector3(468, 40, 4))
	draw_reward("credits", "content/ui/materials/mission_board_v2/icon_rewards_credits", mission.credits, Vector3(548, 40, 4))
	ProtoUI.draw_text(Localize("loc_misison_board_main_objective_title"), "content/ui/fonts/proxima_nova_bold", 18, Vector3(-5, 5, 1), main_objective_size, Color(100, 161, 175, 158), "flags", Gui.MultiLine, "vertical_align_top", "horizontal_align_right")
	ProtoUI.end_group("main_objective")

	local side_objective_display_data = MissionBoardViewSettings.side_objective_lookup[mission.sideMission]

	if mission.flags.side and side_objective_display_data then
		local side_objective_size = Vector2(460, 100)
		local side_objective_pos = Vector3(10, 675, 1)
		local side_objective_color = Color(161, 175, 158)

		ProtoUI.begin_group("side_objective", side_objective_pos)
		ProtoUI.draw_rect(Vector3(0, 0, 0), side_objective_size, Color(230, 0, 0, 0))
		ProtoUI.draw_bitmap("content/ui/materials/mission_board_v2/mission_types/mission_type_icon_side_generic", Vector3(8, 8, 1), Vector2(48, 48), side_objective_color)
		ProtoUI.draw_text(Localize(side_objective_display_data.display_name), "content/ui/fonts/itc_novarese_bold", 20, Vector3(90, 10, 1), side_objective_size, side_objective_color)
		ProtoUI.draw_text(Localize(side_objective_display_data.description), "content/ui/fonts/proxima_nova_bold", 18, Vector3(90, 35, 1), main_objective_size - Vector2(80, 80), side_objective_color, "flags", Gui.MultiLine)
		corners(Vector3(0, 0, 2), side_objective_size)

		local side_objective_rewards = mission.extraRewards.sideMission

		if side_objective_rewards then
			draw_reward("experience", "content/ui/materials/mission_board_v2/icon_rewards_experience", side_objective_rewards.xp, Vector3(468, 0, 4))
			draw_reward("credits", "content/ui/materials/mission_board_v2/icon_rewards_credits", side_objective_rewards.credits, Vector3(548, 0, 4))
		end

		ProtoUI.draw_text(Localize("loc_mission_board_side_objective_title"), "content/ui/fonts/proxima_nova_bold", 18, Vector3(-5, 5, 1), side_objective_size, Color(100, 161, 175, 158), "flags", Gui.MultiLine, "vertical_align_top", "horizontal_align_right")
		ProtoUI.end_group("side_objective")
	end

	local rewards_panel_size = Vector2(396, 276)

	ProtoUI.begin_group("rewards", Vector3(170, 654, 5))

	local play_button_size = Vector2(347, 76)
	local play_button_pos = Vector3(0, -50, 1) + ProtoUI.align_box(ProtoUI.SOUTH, play_button_size, Vector3(0, 0, 0), rewards_panel_size)
	local cannot_start_mission = self.current_player_level < mission.requiredLevel
	local _, play_button_clicked = ProtoUI.bishop_button_primary("play_button", "Play", play_button_pos, cannot_start_mission)

	if cannot_start_mission then
		local pos = play_button_pos + Vector2(0, 10 + play_button_size[2])
		local size = Vector2(347, 32)

		ProtoUI.draw_rect(pos, size, Color(200, 0, 0, 0))
		ProtoUI.draw_text("Lorem ipsum: Required level: " .. mission.required_level, "content/ui/fonts/itc_novarese_bold", 22, Vector3(0, 0, 1) + pos, size, ui_color_green, "flags", Gui.MultiLine, "horizontal_align_center", "vertical_align_center", "shadow", Color(0, 0, 0))
	elseif play_button_clicked or ProtoUI.input_get("confirm_pressed") then
		local party_manager = Managers.party_immaterium

		if party_manager:are_all_members_in_hub() then
			party_manager:wanted_mission_selected(mission.id)
		else
			Managers.event:trigger("event_add_notification_message", "alert", "Can't start mission until all party members are in the Mourningstar")
		end

		Managers.ui:close_view(self.view_name)
	end

	ProtoUI.end_group("rewards")
	ProtoUI.end_group("side_panel")
end

local function get_hour_min_sec(t)
	local sec = t % 60
	t = (t - sec) / 60
	local min = t % 60
	t = (t - min) / 60

	return t, min, sec
end

MissionBoardView.draw = function (self, dt, t, input_service)
	if self._exit_animation_done then
		return
	end

	local local_player = Managers.player:local_player(1)
	local profile = local_player:profile()
	self.current_player_level = profile.current_level

	Profiler.start("MissionBoardView")
	ProtoUI.begin_frame(self._gui, dt, t, input_service)
	ProtoUI.draw_rect(ProtoUI.screen_pos, ProtoUI.screen_size, Color(200, 8, 8, 8))

	local screen_corner_size = Vector2(167, 230)

	ProtoUI.draw_bitmap("content/ui/materials/frames/screen/mission_board_01_upper", ProtoUI.screen_pos + Vector3(0, 0, 10), screen_corner_size)
	ProtoUI.draw_bitmap("content/ui/materials/frames/screen/mission_board_01_lower", ProtoUI.screen_pos + Vector3(0, ProtoUI.screen_size[2] - screen_corner_size[2], 10), screen_corner_size)

	if self._missions_data and t < self._missions_data_expiry_time then
		local missions = self._missions_data.missions

		ProtoUI.begin_group("MissionBoardView")

		if self._world_spawner then
			self._world_spawner:update(dt, t)
		end

		local MEDIUM_PANELS = 2

		for i = 1, math.min(MEDIUM_PANELS, #missions), 1 do
			local mission = missions[i]
			local seed = mission.expiry_game_time
			local pos = Vector3(150 + 500 * (i - 1) + noise(seed, -5, 5), 115 + noise(seed, -15, 15), 100)

			if self:draw_medium_mission_widget(mission, pos) then
				self._selected_mission = mission

				ProtoUI.play_sound(UISoundEvents.default_click)
			end
		end

		local PER_ROW = 5

		for i = 3, #missions, 1 do
			local mission = missions[i]
			local j = i - MEDIUM_PANELS - 1
			local y = math.floor(j / PER_ROW)
			local x = j % PER_ROW + 0.5 * y % 2
			local seed = mission.expiry_game_time
			local pos = Vector3(100 + 200 * x + noise(seed, -10, 10), 430 + 200 * y + noise(seed, -50, 30), 100)

			if self:draw_small_mission_widget(mission, pos) then
				self._selected_mission = mission

				ProtoUI.play_sound(UISoundEvents.default_click)
			end
		end

		local selected_mission = self._selected_mission

		if selected_mission then
			self:_draw_side_panel(selected_mission)

			if ProtoUI.input_get("navigate_right_pressed") then
				local i = table.find(missions, selected_mission)
				self._selected_mission = missions[i % #missions + 1]
			elseif ProtoUI.input_get("navigate_left_pressed") then
				local i = table.find(missions, selected_mission)
				self._selected_mission = missions[(i - 2) % #missions + 1]
			end
		end

		local happening = self._missions_data.happening

		if happening then
			local next_happening = math.max(0, happening.expiry_game_time - ProtoUI.t)
			local text = string.format("Next happening\n%2d hours, %2d minutes, %2d seconds left", get_hour_min_sec(next_happening))

			ProtoUI.draw_text(text, "content/ui/fonts/itc_novarese_bold", 40, Vector3(120, 980, 5), ProtoUI.screen_size, Color(230, 230, 230), "shadow", Color(0, 0, 0))
		end

		ProtoUI.end_group("MissionBoardView")
	else
		self:_fetch_missions(t)
	end

	ProtoUI.end_frame()
	Profiler.stop("MissionBoardView")
end

MissionBoardView._fetch_missions = function (self, t)
	if self._is_fetching_missions then
		return
	end

	self._is_fetching_missions = true
	local missions_future = Managers.data_service.mission_board:fetch(nil, 1)

	missions_future:next(function (data)
		self._missions_data = data
		self._missions_data_expiry_time = data.expiry_game_time
		self._is_fetching_missions = false
		self._selected_mission = data.missions[1]
	end):catch(function (error)
		Log.error("MissionBoardView", "Fetching missions failed %s", error)

		self._missions_data_expiry_time = t + 5
		self._is_fetching_missions = false
	end)
end

MissionBoardView.triggered_on_enter_animation = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return self._triggered_on_enter_animation
	--- END OF BLOCK #0 ---



end

MissionBoardView.trigger_on_enter_animation = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	self._triggered_on_enter_animation = true

	return
	--- END OF BLOCK #0 ---



end

MissionBoardView.trigger_on_exit_animation = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	self._triggered_on_exit_animation = true

	return
	--- END OF BLOCK #0 ---



end

MissionBoardView.on_exit_animation_done = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return self._exit_animation_done
	--- END OF BLOCK #0 ---



end

MissionBoardView.allow_close_hotkey = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return true
	--- END OF BLOCK #0 ---



end

MissionBoardView.is_using_input = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return true
	--- END OF BLOCK #0 ---



end

MissionBoardView.loading = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return false
	--- END OF BLOCK #0 ---



end

MissionBoardView.dialogue_system = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-1, warpins: 1 ---
	return
	--- END OF BLOCK #0 ---



end

MissionBoardView.post_update = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-1, warpins: 1 ---
	return
	--- END OF BLOCK #0 ---



end

MissionBoardView.update = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-4, warpins: 1 ---
	self:_update_exit()

	return
	--- END OF BLOCK #0 ---



end

MissionBoardView.set_render_scale = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-1, warpins: 1 ---
	return
	--- END OF BLOCK #0 ---



end

MissionBoardView.trigger_resolution_update = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-1, warpins: 1 ---
	return
	--- END OF BLOCK #0 ---



end

MissionBoardView.can_exit = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return true
	--- END OF BLOCK #0 ---



end

return MissionBoardView
