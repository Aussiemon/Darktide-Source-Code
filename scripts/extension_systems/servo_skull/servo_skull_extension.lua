-- chunkname: @scripts/extension_systems/servo_skull/servo_skull_extension.lua

local MissionObjectiveScanning = require("scripts/settings/mission_objective/mission_objective_scanning")
local MissionSoundEvents = require("scripts/settings/sound/mission_sound_events")
local Vo = require("scripts/utilities/vo")
local ServoSkullExtension = class("ServoSkullExtension")
local SCANNING_VO_LINES = MissionObjectiveScanning.vo_trigger_ids
local STATES = table.enum("inactive", "traveling", "scanning", "idle")

ServoSkullExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._is_server = extension_init_context.is_server
	self._unit = unit
	self._scannable_units = {}
	self._scannable_units_distance = {}
	self._pulse_interval = 0
	self._pulse_timer = 0
	self._scannable_check_interval = MissionObjectiveScanning.servo_skull.scannable_check_interval
	self._scannable_check_timer = 0
	self._activate_scannable_indicator_particle = false
	self._pulse_fx_timer = 0
	self._pulse_fx_interval = MissionObjectiveScanning.servo_skull.pulse_fx_interval
	self._pulse_meter_counter = 0
	self._next_time_goal = 0
	self._pulse_fx_travel_time_per_meter = MissionObjectiveScanning.servo_skull.pulse_fx_travel_time_per_meter
	self._units_to_ignore = {}
	self._servo_skull_state = STATES.inactive
	self._player_close = false
	self._wandering_distance = MissionObjectiveScanning.servo_skull.wandering_distance
	self._mission_objective_system = Managers.state.extension:system("mission_objective_system")
	self._mission_objective_zone_system = Managers.state.extension:system("mission_objective_zone_system")
	self._vo_line_interval = MissionObjectiveScanning.servo_skull.vo_trigger_time
	self._vo_line_timer = 0
	self._scanning_active = false
end

ServoSkullExtension.setup_from_component = function (self, pulse_interval)
	self._pulse_interval = pulse_interval
end

ServoSkullExtension.hot_join_sync = function (self, unit, sender)
	local channel = Managers.state.game_session:peer_to_channel(sender)
	local go_id = Managers.state.unit_spawner:game_object_id(unit)

	RPC.rpc_servo_skull_player_nearby(channel, go_id, self._player_close)
end

ServoSkullExtension.update = function (self, unit, dt, t)
	if not self._is_server or self._servo_skull_state == STATES.inactive then
		-- Nothing
	elseif self._servo_skull_state == STATES.traveling then
		if not self._player_close then
			if self:_servo_skull_is_wandering() then
				self:_vo_timer(dt)
			elseif self._vo_line_timer ~= 0 then
				self._vo_line_timer = 0
			end
		end
	elseif self._servo_skull_state == STATES.scanning then
		local pulse_timer = self._pulse_timer

		if pulse_timer > 0 then
			pulse_timer = math.max(pulse_timer - dt, 0)
		else
			pulse_timer = self._pulse_interval

			if self:_zone_has_active_scannables() then
				self:do_pulse_fx()

				self._activate_scannable_indicator_particle = true

				table.clear(self._units_to_ignore)

				self._pulse_fx_timer = self._pulse_fx_travel_time_per_meter
			else
				self:set_servo_skull_state(STATES.idle)

				self._pulse_timer = 0
			end
		end

		self._pulse_timer = pulse_timer
	elseif self._servo_skull_state == STATES.idle then
		local scannable_check_timer = self._scannable_check_timer

		if scannable_check_timer > 0 then
			scannable_check_timer = math.max(scannable_check_timer - dt, 0)
		else
			scannable_check_timer = self._scannable_check_interval

			if self:_zone_has_active_scannables() then
				self:set_servo_skull_state(STATES.scanning)
				self._mission_objective_system:music_event(MissionSoundEvents.scanning_scan_start)

				self._scannable_check_timer = 0
			end
		end

		self._scannable_check_timer = scannable_check_timer
	end

	if not DEDICATED_SERVER and self._scanning_active then
		local local_player = Managers.player:local_player(1)
		local set_marker = false

		if local_player and local_player.player_unit then
			local skull_position = POSITION_LOOKUP[self._unit]
			local player_position = POSITION_LOOKUP[local_player.player_unit]

			if Vector3.distance(skull_position, player_position) >= MissionObjectiveScanning.go_to_marker_activation_range then
				set_marker = true
			end
		end

		local objective = self:_objective()

		if objective then
			if set_marker then
				objective:set_go_to_marker(self._unit)
			else
				objective:set_go_to_marker(nil)
			end
		end
	end
end

ServoSkullExtension._zone_has_active_scannables = function (self)
	local scannable_units = self._scannable_units

	for i = 1, #scannable_units do
		local scannable_unit = scannable_units[i]
		local script = ScriptUnit.has_extension(scannable_unit, "mission_objective_zone_scannable_system")

		if script and script:is_active() then
			return true
		end
	end

	return false
end

ServoSkullExtension._recieve_scannables_from_active_zone = function (self)
	local mission_objective_zone_system = self._mission_objective_zone_system
	local current_active_zone = mission_objective_zone_system:current_active_zone()

	if current_active_zone.selected_scannable_units then
		local scannable_units = current_active_zone:selected_scannable_units()

		return scannable_units
	end
end

ServoSkullExtension.at_start_of_spline = function (self)
	self._pulse_timer = 0

	self:set_servo_skull_state(STATES.traveling)
	self._mission_objective_system:sound_event(MissionSoundEvents.scanning_travel_start)
end

ServoSkullExtension.at_end_of_spline = function (self, last_spline)
	if self._is_server then
		local mission_objective_zone_system = self._mission_objective_zone_system

		mission_objective_zone_system:at_end_of_spline(last_spline)

		local scannable_units = self:_recieve_scannables_from_active_zone()

		if scannable_units then
			self._scannable_units = scannable_units

			local scannable_units_distance = self._scannable_units_distance
			local servo_skull_position = POSITION_LOOKUP[self._unit]

			for i = 1, #scannable_units do
				local scannable_unit = scannable_units[i]

				scannable_units_distance[scannable_unit] = Vector3.distance(POSITION_LOOKUP[scannable_unit], servo_skull_position)
			end

			self._scannable_units_distance = scannable_units_distance

			self:set_servo_skull_state(STATES.scanning)
			self._mission_objective_system:sound_event(MissionSoundEvents.scanning_scan_start)
		end
	end
end

ServoSkullExtension.player_nearby = function (self, player_nearby)
	if self._player_close ~= player_nearby then
		self._player_close = player_nearby

		local flow_event_name = player_nearby and "lua_player_close" or "lua_no_player_close"

		Unit.flow_event(self._unit, flow_event_name)

		if self._is_server then
			local unit = self._unit
			local go_id = Managers.state.unit_spawner:game_object_id(unit)

			Managers.state.game_session:send_rpc_clients("rpc_servo_skull_player_nearby", go_id, player_nearby)
		end
	end
end

ServoSkullExtension.do_pulse_fx = function (self)
	Unit.flow_event(self._unit, "lua_trigger_pulse_effect")

	if self._is_server then
		local unit = self._unit
		local go_id = Managers.state.unit_spawner:game_object_id(unit)

		Managers.state.game_session:send_rpc_clients("rpc_servo_skull_do_pulse_fx", go_id)
	end
end

ServoSkullExtension._do_pulse_feedback_fx_on_scannable = function (self, scannable_unit)
	if self._is_server then
		local script = ScriptUnit.has_extension(scannable_unit, "mission_objective_zone_scannable_system")

		if script and script:is_active() then
			script:activate_indicator_particle()
		end
	end
end

ServoSkullExtension.set_servo_skull_state = function (self, servo_skull_state)
	if self._is_server then
		self._servo_skull_state = servo_skull_state

		self:set_scanning_active(servo_skull_state == STATES.scanning)
	end
end

ServoSkullExtension._vo_timer = function (self, dt)
	local vo_line_timer = self._vo_line_timer

	if vo_line_timer > 0 then
		vo_line_timer = math.max(vo_line_timer - dt, 0)
	else
		self:_play_vo(SCANNING_VO_LINES.cmd_wandering_skull)

		vo_line_timer = self._vo_line_interval
	end

	self._vo_line_timer = vo_line_timer
end

ServoSkullExtension._play_vo = function (self, scanning_vo_line)
	local current_objective_name = self._mission_objective_zone_system:current_objective_name()
	local mission_objective = self._mission_objective_system:active_objective(current_objective_name)
	local voice_profile = mission_objective:mission_giver_voice_profile()

	if voice_profile then
		local concept = MissionObjectiveScanning.vo_settings.concept

		Vo.mission_giver_vo_event(voice_profile, concept, scanning_vo_line)
	else
		Vo.mission_giver_mission_info_vo("rule_based", nil, scanning_vo_line)
	end
end

ServoSkullExtension.set_scanning_active = function (self, active)
	if self._scanning_active == active then
		return
	end

	self._scanning_active = active

	if self._is_server then
		local unit = self._unit
		local go_id = Managers.state.unit_spawner:game_object_id(unit)

		Managers.state.game_session:send_rpc_clients("rpc_servo_skull_set_scanning_active", go_id, active)
	end

	if not active then
		local objective = self:_objective()

		if objective then
			objective:set_go_to_marker(nil)
		end
	end
end

ServoSkullExtension._objective = function (self)
	local current_objective_name = self._mission_objective_zone_system:current_objective_name()

	self._mission_objective = self._mission_objective_system:active_objective(current_objective_name)

	return self._mission_objective
end

ServoSkullExtension.get_scanning_active = function (self)
	return self._scanning_active
end

ServoSkullExtension._servo_skull_is_wandering = function (self)
	local player_manager = Managers.player
	local players = player_manager:players()
	local servo_skull_position = Unit.world_position(self._unit, 1)
	local wandering_distance = self._wandering_distance
	local closest_distance
	local ALIVE = ALIVE

	for k, player in pairs(players) do
		local unit = player.player_unit

		if ALIVE[unit] then
			local position = POSITION_LOOKUP[unit]
			local distance = Vector3.distance(position, servo_skull_position)

			if not closest_distance or distance < closest_distance then
				closest_distance = distance
			end
		end
	end

	return closest_distance and wandering_distance < closest_distance or false
end

return ServoSkullExtension
