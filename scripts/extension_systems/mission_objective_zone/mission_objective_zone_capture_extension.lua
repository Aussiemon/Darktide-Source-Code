-- chunkname: @scripts/extension_systems/mission_objective_zone/mission_objective_zone_capture_extension.lua

local MissionObjectiveZoneCaptureExtension = class("MissionObjectiveZoneCaptureExtension", "MissionObjectiveZoneBaseExtension")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local SERVER_STATES = table.enum("progress_inactive", "progress_active", "progress_finished")
local NETWORK_TIMER_STATES = table.enum("pause", "play")
local PROGRESSION_PER_PLAYER_AMOUNT = {
	0.5,
	0.75,
	0.875,
	1,
}

MissionObjectiveZoneCaptureExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	MissionObjectiveZoneCaptureExtension.super.init(self, extension_init_context, unit, extension_init_data, ...)

	self._zone_type = "capture"
	self._progress_ui_type = "bar"
	self._time_progress = 0
	self._required_number_of_players = 1
	self._networked_timer_extension = ScriptUnit.extension(unit, "networked_timer_system")
	self._current_server_state = SERVER_STATES.progress_inactive
	self._network_timer_state = NETWORK_TIMER_STATES.pause

	local side_system = Managers.state.extension:system("side_system")

	self._side_system = side_system
	self._uses_border = false
	self._border_offset = 0.5
	self._border_height_scale = 1
	self._border_triangles = {}
	self._border_active = nil
	self._is_local_objective_marker_enabled = true
	self._time_with_not_full_team = 0
	self._use_vo = false
end

MissionObjectiveZoneCaptureExtension.setup_from_component = function (self, return_to_skull, num_player_in_zone, require_half_playes, time_in_zone, uses_border, border_offset, border_height_scale)
	self._return_to_skull = return_to_skull
	self._required_number_of_players = num_player_in_zone
	self._require_half_playes = require_half_playes
	self._uses_border = uses_border
	self._border_offset = border_offset
	self._border_height_scale = border_height_scale

	self._networked_timer_extension:setup_from_component(time_in_zone, nil, 1, false)
end

MissionObjectiveZoneCaptureExtension.on_gameplay_post_init = function (self, world, unit)
	MissionObjectiveZoneCaptureExtension.super.on_gameplay_post_init(self, world, unit)

	if self._uses_border then
		self:_create_border()
		self:set_border_visible(false)
	end
end

MissionObjectiveZoneCaptureExtension.destroy = function (self)
	self:_destroy_border()
end

local function volume_points_rounded_corners(volume_points, radius, segments)
	local new_points = {}

	for j = 1, #volume_points do
		local a = volume_points[(j - 1) % #volume_points + 1]
		local b = volume_points[(j + 1 - 1) % #volume_points + 1]
		local c = volume_points[(j + 2 - 1) % #volume_points + 1]
		local ba = Vector3.subtract(a, b)
		local bc = Vector3.subtract(c, b)
		local angle = (math.atan2(ba.y, ba.x) - math.atan2(bc.y, bc.x)) / 2
		local tan = math.abs(math.tan(angle))
		local segment_length = radius / tan
		local length_ba = math.sqrt(ba.x * ba.x, ba.y * ba.y)
		local length_bc = math.sqrt(bc.x * bc.x, bc.y * bc.y)
		local length = math.min(length_ba, length_bc)

		if length < segment_length then
			segment_length = length
			radius = length * tan
		end

		local bf = Vector3.multiply(Vector3.normalize(ba), segment_length)
		local f = Vector3.add(b, bf)
		local bh = Vector3.multiply(Vector3.normalize(bc), segment_length)
		local h = Vector3.add(b, bh)
		local sign = math.sign(ba.x * bc.y - ba.y * bc.x)
		local r = Vector3.multiply(Quaternion.rotate(Quaternion.from_euler_angles_xyz(0, 0, 90), Vector3.normalize(ba)), sign * radius)
		local c = Vector3.add(f, r)
		local start_angle = math.atan2(f.y - c.y, f.x - c.x)
		local end_angle = math.atan2(h.y - c.y, h.x - c.x)
		local diff = end_angle - start_angle

		if diff < 0 then
			diff = -diff
		end

		if diff > math.pi then
			diff = math.pi * 2 - math.abs(end_angle - start_angle)
		end

		local point_count = segments
		local interval = diff / point_count

		for i = 0, point_count do
			local change = interval * i * -sign
			local nx = c.x + radius * math.cos(start_angle + change)
			local ny = c.y + radius * math.sin(start_angle + change)

			new_points[#new_points + 1] = Vector3(nx, ny, b.z)
		end
	end

	return new_points
end

local function create_border(volume_points, volume_height)
	local points = {}

	for i = 1, #volume_points do
		local a = volume_points[(i - 1) % #volume_points + 1]
		local b = volume_points[(i + 1 - 1) % #volume_points + 1]
		local c = a + Vector3(0, 0, volume_height)
		local d = b + Vector3(0, 0, volume_height)

		points[#points + 1] = Vector3Box(a)
		points[#points + 1] = Vector3Box(b)
		points[#points + 1] = Vector3Box(c)
		points[#points + 1] = Vector3Box(d)
	end

	return points
end

MissionObjectiveZoneCaptureExtension._draw_border = function (self, color)
	local world_gui = self._world_gui
	local border_triangles = self._border_triangles

	for i = 1, #border_triangles do
		Gui.destroy_triangle(world_gui, border_triangles[i])
	end

	table.clear(border_triangles)

	local auv = Vector2(0, 0)
	local buv = Vector2(1, 0)
	local cuv = Vector2(0, 1)
	local duv = Vector2(1, 1)
	local points = self._border_points

	for i = 1, #points, 4 do
		local a = points[i]:unbox()
		local b = points[i + 1]:unbox()
		local c = points[i + 2]:unbox()
		local d = points[i + 3]:unbox()

		border_triangles[#border_triangles + 1] = Gui.triangle(world_gui, a, b, c, 1, color, "content/environment/gameplay/expedition_capture_zone/capture_zone", auv, buv, cuv)
		border_triangles[#border_triangles + 1] = Gui.triangle(world_gui, c, b, d, 1, color, "content/environment/gameplay/expedition_capture_zone/capture_zone", cuv, buv, duv)
	end
end

MissionObjectiveZoneCaptureExtension._create_border = function (self)
	local radius = 0.2
	local segments = 5
	local volume_points = Unit.volume_points(self._unit, "g_mission_objective_zone_volume")
	local volume_height = Unit.volume_height(self._unit, "g_mission_objective_zone_volume")
	local scale = Unit.local_scale(self._unit, 1)

	volume_height = volume_height * scale.z * self._border_height_scale

	local offset = self._border_offset
	local offseted_points = {}

	for j = 1, #volume_points do
		local a = volume_points[(j - 1) % #volume_points + 1]
		local b = volume_points[(j + 1 - 1) % #volume_points + 1]
		local c = volume_points[(j + 2 - 1) % #volume_points + 1]
		local ba = Vector3.subtract(a, b)
		local bc = Vector3.subtract(b, c)
		local ba_cross = Vector3.cross(ba, Vector3.up())
		local bc_cross = Vector3.cross(bc, Vector3.up())
		local normal = Vector3.normalize(ba_cross + bc_cross)

		offseted_points[#offseted_points + 1] = b + normal * offset
	end

	self._border_points = create_border(volume_points_rounded_corners(offseted_points, radius, segments), volume_height)
	self._world = Unit.world(self._unit)
	self._world_gui = World.create_world_gui(self._world, Matrix4x4.identity(), 1, 1)
end

MissionObjectiveZoneCaptureExtension._destroy_border = function (self)
	if self._world_gui then
		World.destroy_gui(self._world, self._world_gui)

		self._world_gui = nil
	end
end

MissionObjectiveZoneCaptureExtension.activate_zone = function (self)
	MissionObjectiveZoneCaptureExtension.super.activate_zone(self)
	self._networked_timer_extension:start_paused()
end

MissionObjectiveZoneCaptureExtension.reset = function (self)
	MissionObjectiveZoneCaptureExtension.super.reset(self)
	self._networked_timer_extension:stop()
end

MissionObjectiveZoneCaptureExtension.set_active = function (self, active)
	if active == self._activated then
		return
	end

	self:set_border_visible(active)
	MissionObjectiveZoneCaptureExtension.super.set_active(self, active)
end

MissionObjectiveZoneCaptureExtension.update = function (self, ...)
	MissionObjectiveZoneCaptureExtension.super.update(self, ...)

	if not self._activated then
		return
	end

	if self._is_server then
		self:_update_server(...)
	end

	if not DEDICATED_SERVER then
		self:_update_client(...)
	end
end

MissionObjectiveZoneCaptureExtension._update_server = function (self, unit, dt, t)
	local fulfill_in_zone_check, players_in_zone = self:players_inside_status()
	local new_state

	if self._current_server_state == SERVER_STATES.progress_inactive then
		if fulfill_in_zone_check then
			new_state = SERVER_STATES.progress_active
		else
			self:_progress_inactive(dt)
		end
	elseif self._current_server_state == SERVER_STATES.progress_active then
		if not fulfill_in_zone_check then
			new_state = SERVER_STATES.progress_inactive
		else
			self:_progress_active(players_in_zone, dt)
		end
	elseif self._current_server_state == SERVER_STATES.progress_finished and not self._start_finish_zone_timer then
		if self._synchronizer_extension:uses_servo_skull() then
			self:_inform_skull_of_completion()
		else
			self:zone_finished()
		end
	end

	if new_state then
		self:_set_server_state(new_state)
	end
end

MissionObjectiveZoneCaptureExtension._update_client = function (self)
	if self._mission_objective_target_extension then
		local is_local_player_in_zone = self:_is_local_player_in_zone()
		local is_local_objective_marker_enabled = self._is_local_objective_marker_enabled

		if is_local_player_in_zone and is_local_objective_marker_enabled then
			self._mission_objective_target_extension:remove_unit_marker()

			self._is_local_objective_marker_enabled = false
		elseif not is_local_player_in_zone and not is_local_objective_marker_enabled then
			self._mission_objective_target_extension:add_unit_marker()

			self._is_local_objective_marker_enabled = true
		end
	end

	if self._uses_border then
		local active = self._networked_timer_extension:is_counting()

		if self._border_active ~= active then
			if active then
				self:_draw_border(Color(255, 90.015, 76.755, 0))
			else
				self:_draw_border(Color(255, 0, 20, 255))
			end

			self._border_active = active
		end
	end
end

MissionObjectiveZoneCaptureExtension._progress_active = function (self, players_in_zone, dt)
	if self._network_timer_state ~= NETWORK_TIMER_STATES.play then
		self:_set_network_timer_state(NETWORK_TIMER_STATES.play)
	end

	if players_in_zone < GameParameters.max_players then
		self._time_with_not_full_team = self._time_with_not_full_team + dt
	end

	if self._players_in_area ~= players_in_zone then
		self._networked_timer_extension:set_speed_modifier(math.min(PROGRESSION_PER_PLAYER_AMOUNT[players_in_zone], #PROGRESSION_PER_PLAYER_AMOUNT))

		self._players_in_area = players_in_zone
	end

	local remaining_time = self._networked_timer_extension:get_remaining_time()

	if remaining_time == 0 then
		if self._time_with_not_full_team < 1 then
			if self._objective_name == "objective_expedition_clear_exit" then
				local players = Managers.player:players()

				for peer_id, player in pairs(players) do
					Managers.achievements:unlock_achievement(player, "expeditions_complete_exit_within")
				end
			elseif self._objective_name == "objective_expedition_clear_extraction" then
				local players = Managers.player:players()

				for peer_id, player in pairs(players) do
					Managers.achievements:unlock_achievement(player, "expeditions_complete_extract_within")
				end
			end
		end

		self:_set_server_state(SERVER_STATES.progress_finished)
	end
end

MissionObjectiveZoneCaptureExtension._progress_inactive = function (self, dt)
	if self._network_timer_state ~= NETWORK_TIMER_STATES.pause then
		self:_set_network_timer_state(NETWORK_TIMER_STATES.pause)
	end

	self._time_with_not_full_team = self._time_with_not_full_team + dt
end

MissionObjectiveZoneCaptureExtension.players_inside_status = function (self)
	local players_in_zone = 0
	local total_players = 0
	local player_manager = Managers.player
	local players = player_manager:players()

	for _, player in pairs(players) do
		local valid_player = player:is_human_controlled()
		local player_unit = player.player_unit

		if valid_player and player_unit and ALIVE[player_unit] then
			local player_position = POSITION_LOOKUP[player_unit]
			local dead = false
			local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

			if unit_data_extension then
				local character_state_component = unit_data_extension:read_component("character_state")

				if PlayerUnitStatus.is_dead_for_mission_failure(character_state_component) then
					dead = true
				end
			end

			if not dead and self:point_in_zone(player_position) then
				players_in_zone = players_in_zone + 1
			end

			total_players = total_players + 1
		end
	end

	local num_players_needed = self._required_number_of_players

	if self._require_half_playes then
		num_players_needed = math.max(num_players_needed, math.ceil(total_players / 2))
	end

	return num_players_needed <= players_in_zone, players_in_zone, num_players_needed
end

MissionObjectiveZoneCaptureExtension._is_local_player_in_zone = function (self)
	local local_player = Managers.player:local_player(1)
	local player_unit = local_player.player_unit

	if not player_unit or not ALIVE[player_unit] then
		return false
	end

	local player_position = POSITION_LOOKUP[player_unit]
	local in_zone = self:point_in_zone(player_position)

	return in_zone
end

MissionObjectiveZoneCaptureExtension._set_server_state = function (self, state)
	self._current_server_state = state
end

MissionObjectiveZoneCaptureExtension._set_network_timer_state = function (self, timer_state)
	if self._is_server then
		if timer_state == NETWORK_TIMER_STATES.pause then
			self._networked_timer_extension:pause()
		elseif timer_state == NETWORK_TIMER_STATES.play then
			self._networked_timer_extension:start()
		end

		self._network_timer_state = timer_state
	end
end

MissionObjectiveZoneCaptureExtension.set_is_waiting_for_player_confirmation = function (self)
	MissionObjectiveZoneCaptureExtension.super.set_is_waiting_for_player_confirmation(self)
end

MissionObjectiveZoneCaptureExtension.current_progression = function (self)
	local progression = self._activated and self._networked_timer_extension:progression() or 0

	return progression
end

MissionObjectiveZoneCaptureExtension.max_progression = function (self)
	return 1
end

MissionObjectiveZoneCaptureExtension.set_border_visible = function (self, enable)
	if not self._uses_border then
		return
	end

	Gui.set_visible(self._world_gui, enable)
end

return MissionObjectiveZoneCaptureExtension
