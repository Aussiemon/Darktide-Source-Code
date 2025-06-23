-- chunkname: @scripts/extension_systems/scanning_event/scanning_device_extension.lua

local LevelEventSettings = require("scripts/settings/level_event/level_event_settings")
local SplineCurve = require("scripts/utilities/spline/spline_curve")
local ScanningDeviceExtension = class("ScanningDeviceExtension")
local STATES = table.enum("none", "moving", "scanning", "finished")
local ERROR_RECOUP_TIME = 0.5

ScanningDeviceExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._is_server = extension_init_context.is_server
	self._unit = unit
	self._attached_devices = {}
	self._current_state = STATES.none
	self._past_spline_start_position = false
	self._update_position_to_end_splin_position = false
	self._place_unit_at_end_position = false
	self._at_end_position = false
	self._scanning_active = false
	self._world = extension_init_context.world
	self._side_system = Managers.state.extension:system("side_system")
	self._game_session = Managers.state.game_session:game_session()

	self:_setup_level_event_settings()
	self:disable()

	self._last_synched_spline_values = {
		last_synch_time = 0,
		error_compensation_speed = 0,
		spline_index = 1,
		subdivision_index = 1,
		spline_t = 0
	}
end

ScanningDeviceExtension._setup_level_event_settings = function (self)
	self._max_speed_player_close = LevelEventSettings.scanning_device.max_speed_player_close
	self._max_speed_no_player_close = LevelEventSettings.scanning_device.max_speed_no_player_close
	self._bonus_speed_per_close_player = LevelEventSettings.scanning_device.bonus_speed_per_close_player
	self._acceleration_to_max_speed = LevelEventSettings.scanning_device.acceleration_to_max_speed
	self._proximity_check_radius = LevelEventSettings.scanning_device.proximity_check_radius
	self._should_move_to_start_spline = LevelEventSettings.scanning_device.should_move_to_start_spline
	self._to_start_spline_speed = LevelEventSettings.scanning_device.to_start_spline_speed
	self._should_move_to_end_position = LevelEventSettings.scanning_device.should_move_to_end_position
	self._to_end_position_speed = LevelEventSettings.scanning_device.to_end_position_speed
	self._end_position_height = LevelEventSettings.scanning_device.end_position_height
end

ScanningDeviceExtension.extensions_ready = function (self, world, unit)
	if self._is_server then
		self:_create_game_object()
	end
end

ScanningDeviceExtension._create_game_object = function (self)
	local unit = self._unit
	local level_unit_id = Managers.state.unit_spawner:level_index(unit)
	local go_data_table = {
		speed = 0,
		spline_index = 1,
		subdivision_index = 1,
		spline_t = 0,
		game_object_type = NetworkLookup.game_object_types.scanning_device,
		level_unit_id = level_unit_id
	}
	local game_session = self._game_session

	self._go_id = GameSession.create_game_object(game_session, "scanning_device", go_data_table)
end

ScanningDeviceExtension.on_game_object_created = function (self, game_object_id)
	self._go_id = game_object_id
end

ScanningDeviceExtension.on_game_object_destroyed = function (self)
	self._go_id = nil
end

ScanningDeviceExtension.enable = function (self)
	Unit.flow_event(self._unit, "lua_enable")
end

ScanningDeviceExtension.disable = function (self)
	Unit.flow_event(self._unit, "lua_disable")
	self:_set_state(STATES.none)
end

ScanningDeviceExtension._enable_engine_fx = function (self)
	Unit.flow_event(self._unit, "lua_enable_engine_fx")
end

ScanningDeviceExtension._enable_scanning_fx = function (self)
	self._scanning_active = true

	Unit.flow_event(self._unit, "lua_enable_scanning_fx")
end

ScanningDeviceExtension._disable_scanning_fx = function (self)
	self._scanning_active = false

	Unit.flow_event(self._unit, "lua_disable_scanning_fx")
end

ScanningDeviceExtension.travel_along_spline = function (self, spline, spline_name, end_position, end_rotation)
	if not self._engine_fx_enabled then
		self:_enable_engine_fx()

		self._engine_fx_enabled = true
	end

	if self._scanning_active then
		self:_disable_scanning_fx()
	end

	local world = self._world
	local unit = self._unit

	self._spline_curve = self:_init_movement_spline(world, unit, spline)
	self._end_position = end_position
	self._end_rotation = end_rotation
	self._past_spline_start_position = false
	self._at_end_position = false
	self._place_unit_at_end_position = false

	if self._hot_join_sync then
		self._hot_join_sync = false

		local past_spline_start_position = self._hot_join_sync_past_spline_start_position
		local at_end_position = self._hot_join_sync_at_end_position

		if past_spline_start_position and not at_end_position then
			self:_update_game_object()
		end

		self._past_spline_start_position = past_spline_start_position
		self._at_end_position = at_end_position
		self._place_unit_at_end_position = at_end_position
	end

	self:_set_state(STATES.moving)
end

ScanningDeviceExtension._update_game_object = function (self)
	local game_session = self._game_session
	local go_id = self._go_id

	if go_id then
		local spline_index = GameSession.game_object_field(game_session, go_id, "spline_index")
		local subdivision_index = GameSession.game_object_field(game_session, go_id, "subdivision_index")
		local spline_t = GameSession.game_object_field(game_session, go_id, "spline_t")
		local speed = GameSession.game_object_field(game_session, go_id, "speed")
		local movement = self._spline_curve:movement()

		movement:set_spline_index(spline_index, subdivision_index, spline_t)
		movement:set_speed(speed)
	end
end

ScanningDeviceExtension.update = function (self, unit, dt, t)
	if self._current_state == STATES.none then
		-- Nothing
	elseif self._current_state == STATES.moving then
		if self._should_move_to_start_spline and not self._past_spline_start_position then
			self:_move_to_spline(dt)
		else
			local new_speed = 0
			local movement = self._spline_curve:movement()
			local go_id = self._go_id
			local game_session = self._game_session

			if self._is_server then
				local num_players_in_proximity, _ = self:_players_in_proximity()
				local has_players_in_proximity = num_players_in_proximity > 0
				local speed_settings = has_players_in_proximity and self._max_speed_player_close or self._max_speed_no_player_close
				local bonus_speed = self._bonus_speed_per_close_player * num_players_in_proximity
				local target_speed = speed_settings + bonus_speed
				local acceleration = self._acceleration_to_max_speed
				local old_speed = movement:speed()
				local wanted_speed_change = target_speed - old_speed

				if wanted_speed_change > 0 then
					new_speed = math.min(old_speed + acceleration * dt, target_speed)
				elseif wanted_speed_change < 0 then
					new_speed = math.max(old_speed - acceleration * dt, target_speed)
				else
					new_speed = target_speed
				end

				if go_id then
					GameSession.set_game_object_field(game_session, go_id, "speed", new_speed)

					local current_subdivision_index = movement:current_subdivision_index()
					local current_t = movement:current_t()
					local current_spline_index = movement:current_spline_index()

					GameSession.set_game_object_field(game_session, go_id, "spline_index", current_spline_index)
					GameSession.set_game_object_field(game_session, go_id, "subdivision_index", current_subdivision_index)
					GameSession.set_game_object_field(game_session, go_id, "spline_t", current_t)
				end
			elseif go_id and GameSession.game_object_exists(game_session, go_id) then
				local error_compensation_speed = self:_error_speed_calculation(dt, t, game_session, go_id, movement)
				local network_speed = GameSession.game_object_field(game_session, go_id, "speed")

				new_speed = network_speed + error_compensation_speed
			end

			movement:set_speed(new_speed)

			local movement_status = movement:update(dt, t)

			self._current_movment_status = movement_status

			if movement_status ~= "end" then
				Unit.set_local_position(unit, 1, movement:current_position())

				local dir = movement:current_tangent_direction()
				local rot = Quaternion.look(dir, Vector3.up())

				Unit.set_local_rotation(unit, 1, rot)
			end

			local should_move_to_end_position = self._should_move_to_end_position

			if should_move_to_end_position and movement_status == "end" and not self._at_end_position then
				if self._update_position_to_end_splin_position then
					self._update_position_to_end_splin_position = false

					local end_position = self._end_position:unbox()

					Unit.set_local_position(unit, 1, end_position)
				else
					local direct_to_end_position = false

					self:_move_to_end_position(dt, direct_to_end_position)
				end
			end

			if self._at_end_position or not should_move_to_end_position and movement_status == "end" then
				if self._place_unit_at_end_position and should_move_to_end_position then
					local direct_to_end_position = true

					self:_move_to_end_position(dt, direct_to_end_position)
				end

				self:_set_state(STATES.scanning)
			end
		end
	elseif self._current_state == STATES.scanning then
		if not self._scanning_active then
			self:_enable_scanning_fx()
		end
	elseif self._current_state == STATES.finished then
		Unit.flow_event(self._unit, "lua_event_finished")

		if self._scanning_active then
			self:_disable_scanning_fx()
		end

		self:disable()
	end
end

ScanningDeviceExtension._move_to_spline = function (self, dt)
	local splines = self._spline_curve:splines()
	local spline_start_position = splines[1].points[1]:unbox()
	local movement = self._spline_curve:movement()
	local dir = movement:current_tangent_direction()
	local rotation = Quaternion.look(dir, Vector3.up())
	local delta = dt * self._to_start_spline_speed
	local direct_to_end_position = false

	self._past_spline_start_position = self:_move_towards_position(delta, spline_start_position, rotation, direct_to_end_position)
end

ScanningDeviceExtension._move_to_end_position = function (self, dt, direct_to_end_position)
	local end_position = self._end_position:unbox()
	local end_rotation = self._end_rotation:unbox()

	end_position = Vector3(end_position.x, end_position.y, end_position.z + self._end_position_height)

	local delta = dt * self._to_end_position_speed

	self._at_end_position = self:_move_towards_position(delta, end_position, end_rotation, direct_to_end_position)
end

ScanningDeviceExtension._move_towards_position = function (self, delta, end_position, end_rotation, direct_to_end_position)
	local unit = self._unit
	local current_position = POSITION_LOOKUP[unit]
	local current_rotation = Unit.world_rotation(unit, 1)

	if not direct_to_end_position then
		end_position = Vector3.lerp(current_position, end_position, delta)
		end_rotation = Quaternion.lerp(current_rotation, end_rotation, delta)
	end

	Unit.set_local_position(unit, 1, end_position)
	Unit.set_local_rotation(unit, 1, end_rotation)

	local distance_to_target = Vector3.distance(current_position, end_position)
	local reached_position = direct_to_end_position and true or false

	if distance_to_target < 0.0001 then
		reached_position = true
	end

	return reached_position
end

ScanningDeviceExtension._error_speed_calculation = function (self, dt, t, game, id, movement)
	local spline_index = GameSession.game_object_field(game, id, "spline_index")
	local subdiv = GameSession.game_object_field(game, id, "subdivision_index")
	local spline_t = GameSession.game_object_field(game, id, "spline_t")
	local old_vals = self._last_synched_spline_values

	if old_vals.spline_index ~= spline_index or old_vals.subdivision_index ~= subdiv or old_vals.spline_t ~= spline_t then
		local curr_spline_index = movement:current_spline_index()
		local curr_subdivision_index = movement:current_subdivision_index()
		local curr_spline_t = movement:current_t()
		local error_distance = movement:distance(curr_spline_index, curr_subdivision_index, curr_spline_t, spline_index, subdiv, spline_t)

		old_vals.spline_index = spline_index
		old_vals.subdivision_index = subdiv
		old_vals.spline_t = spline_t
		old_vals.error_compensation_speed = error_distance / ERROR_RECOUP_TIME
		old_vals.last_synch_time = t
	elseif t - old_vals.last_synch_time >= ERROR_RECOUP_TIME then
		old_vals.error_compensation_speed = 0
	end

	return old_vals.error_compensation_speed
end

local PLAYERS_IN_PROXIMITY = {}

ScanningDeviceExtension._players_in_proximity = function (self)
	local side_system = self._side_system
	local side = side_system:get_side_from_name("heroes")
	local valid_player_units = side.valid_player_units
	local positions = POSITION_LOOKUP
	local device_position = Unit.world_position(self._unit, 1)
	local num_players_in_proximity = 0
	local radius = self._proximity_check_radius

	table.clear(PLAYERS_IN_PROXIMITY)

	for i = 1, #valid_player_units do
		local unit = valid_player_units[i]
		local position = positions[unit]
		local distance_squared = Vector3.distance_squared(position, device_position)

		if distance_squared < radius then
			num_players_in_proximity = num_players_in_proximity + 1
			PLAYERS_IN_PROXIMITY[num_players_in_proximity] = unit
		end
	end

	return num_players_in_proximity, PLAYERS_IN_PROXIMITY
end

ScanningDeviceExtension._set_state = function (self, state)
	self._current_state = state
end

ScanningDeviceExtension.current_state = function (self)
	return self._current_state
end

ScanningDeviceExtension.reached_end_of_spline = function (self)
	return self._current_movment_status == "end"
end

ScanningDeviceExtension.finished_event = function (self)
	if self._is_server then
		local unit_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_scanning_device_finished", unit_id)
	end

	self:_set_state(STATES.finished)
end

ScanningDeviceExtension._init_movement_spline = function (self, world, unit, spline_points, spline_name)
	local spline_curve = SplineCurve:new(spline_points, "Bezier", "SplineMovementHermiteInterpolatedMetered", spline_name, 10)

	return spline_curve
end

ScanningDeviceExtension.past_spline_start_position = function (self)
	return self._past_spline_start_position
end

ScanningDeviceExtension.at_end_position = function (self)
	return self._at_end_position
end

ScanningDeviceExtension.hot_join_sync = function (self, past_spline_start_position, at_end_position, reached_end_of_spline)
	self._hot_join_sync_past_spline_start_position = past_spline_start_position
	self._hot_join_sync_at_end_position = at_end_position
	self._hot_join_sync = true
	self._update_position_to_end_splin_position = reached_end_of_spline
end

return ScanningDeviceExtension
