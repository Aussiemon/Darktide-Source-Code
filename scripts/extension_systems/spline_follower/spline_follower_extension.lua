-- chunkname: @scripts/extension_systems/spline_follower/spline_follower_extension.lua

local SplineCurve = require("scripts/utilities/spline/spline_curve")
local LevelEventSettings = require("scripts/settings/level_event/level_event_settings")
local SplineFollowerExtension = class("SplineFollowerExtension")
local STATES = table.enum("waiting", "moving", "end_of_spline", "finished")
local ERROR_RECOUP_TIME = 0.5

SplineFollowerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._is_server = extension_init_context.is_server
	self._unit = unit
	self._current_state = STATES.waiting
	self._current_spline_index = 1
	self._world = extension_init_context.world
	self._side_system = Managers.state.extension:system("side_system")
	self._spline_follower_system = Managers.state.extension:system("spline_follower_system")
	self._is_moving = false
	self._objective_name = nil
	self._connect_spline_distance = nil
	self._follow_unit_default_speed = 0
	self._follow_unit_default_acceleration = 0
	self._proximity_check_distance_squared = 0

	if self._is_server then
		self._game_session = nil
		self._game_object_id = nil
	else
		self._game_session = Managers.state.game_session:game_session()

		local unit_spawner_manager = Managers.state.unit_spawner

		self._game_object_id = unit_spawner_manager:game_object_id(unit)
	end

	self._last_synced_spline_values = {
		error_compensation_speed = 0,
		last_sync_time = 0,
		spline_index = 0,
		spline_t = 0,
		subdivision_index = 0,
	}
end

SplineFollowerExtension.extensions_ready = function (self, world, unit)
	self._servo_skull_extension = ScriptUnit.has_extension(self._unit, "servo_skull_system")
	self._follow_unit_is_servo_skull = self._servo_skull_extension ~= nil

	self:_setup_level_event_settings()
end

SplineFollowerExtension._setup_level_event_settings = function (self)
	if self._follow_unit_is_servo_skull then
		self._follow_unit_default_speed = LevelEventSettings.spline_follower.servo_skull.servo_skull_default_speed
		self._follow_unit_default_acceleration = LevelEventSettings.spline_follower.servo_skull.acceleration_to_max_speed
		self._follow_unit_default_deceleration = LevelEventSettings.spline_follower.servo_skull.deceleration_to_min_speed
		self._proximity_check_distance_squared = LevelEventSettings.spline_follower.servo_skull.proximity_check_distance_squared
	end

	self._connect_spline_distance = LevelEventSettings.spline_follower.connect_spline_distance
end

SplineFollowerExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id
end

SplineFollowerExtension.update = function (self, unit, dt, t)
	if self._current_state == STATES.waiting then
		return
	elseif self._current_state == STATES.moving then
		local new_speed = 0
		local movement = self._spline_curve:movement()
		local go_id = self._game_object_id
		local game_session = self._game_session

		if self._is_server then
			local player_speed = 0
			local ground_speed = self._follow_unit_default_speed
			local target_speed = ground_speed
			local acceleration = self._follow_unit_default_acceleration
			local deceleration = self._follow_unit_default_deceleration

			if self._follow_unit_is_servo_skull then
				local closest_player = self:_players_in_proximity()

				if closest_player then
					local unit_data_extension = ScriptUnit.extension(closest_player, "unit_data_system")
					local locomotion_component = unit_data_extension:read_component("locomotion")
					local velocity_current = locomotion_component.velocity_current
					local velocity_current_flat = Vector3.flat(velocity_current)
					local speed = Vector3.length(velocity_current_flat)

					player_speed = speed
				end

				local player_nearby = closest_player ~= nil

				self._servo_skull_extension:player_nearby(player_nearby)

				target_speed = player_speed == 0 and ground_speed or player_speed
			end

			local old_speed = movement:speed()
			local wanted_speed_change = target_speed - old_speed

			if wanted_speed_change > 0 then
				new_speed = math.min(old_speed + acceleration * dt, target_speed)
			elseif wanted_speed_change < 0 then
				new_speed = math.max(old_speed - deceleration * dt, target_speed)
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
			local position = movement:current_position()

			Unit.set_local_position(unit, 1, position)

			local dir = movement:current_tangent_direction()
			local rot = Quaternion.look(dir, Vector3.up())

			Unit.set_local_rotation(unit, 1, rot)

			if self._is_server and go_id then
				GameSession.set_game_object_field(game_session, go_id, "position", position)
				GameSession.set_game_object_field(game_session, go_id, "rotation", rot)
			end
		else
			self:_set_state(STATES.end_of_spline)
		end
	elseif self._current_state == STATES.end_of_spline then
		local last_spline = self._last_spline

		self._is_moving = false

		local state = last_spline and STATES.finished or STATES.waiting

		self:_set_state(state)

		if self._is_server then
			local servo_skull_extension = ScriptUnit.has_extension(self._unit, "servo_skull_system")

			if servo_skull_extension then
				servo_skull_extension:at_end_of_spline(last_spline)
			end
		end

		Unit.flow_event(self._unit, "lua_end_of_spline")
	elseif self._current_state == STATES.finished then
		Unit.flow_event(self._unit, "lua_finished")
		self:_set_state(STATES.waiting)
	end
end

SplineFollowerExtension._position_rotation_from_game_object = function (self)
	local session = self._game_session
	local object_id = self._game_object_id
	local go_field = GameSession.game_object_field
	local position = go_field(session, object_id, "position")
	local rotation = go_field(session, object_id, "rotation")

	return position, rotation
end

SplineFollowerExtension._error_speed_calculation = function (self, dt, t, game, id, movement)
	local spline_index = GameSession.game_object_field(game, id, "spline_index")
	local splines = self._spline_curve:splines()
	local subdivision_index = GameSession.game_object_field(game, id, "subdivision_index")
	local spline_t = GameSession.game_object_field(game, id, "spline_t")
	local old_values = self._last_synced_spline_values

	if spline_index <= #splines and (old_values.spline_index ~= spline_index or old_values.subdivision_index ~= subdivision_index or old_values.spline_t ~= spline_t) then
		local current_spline_index = movement:current_spline_index()
		local current_subdivision_index = movement:current_subdivision_index()
		local current_spline_t = movement:current_t()
		local error_distance = movement:distance(current_spline_index, current_subdivision_index, current_spline_t, spline_index, subdivision_index, spline_t)

		old_values.spline_index = spline_index
		old_values.subdivision_index = subdivision_index
		old_values.spline_t = spline_t
		old_values.error_compensation_speed = error_distance / ERROR_RECOUP_TIME
		old_values.last_sync_time = t
	elseif t - old_values.last_sync_time >= ERROR_RECOUP_TIME then
		old_values.error_compensation_speed = 0
	end

	return old_values.error_compensation_speed
end

SplineFollowerExtension._players_in_proximity = function (self)
	local side_system = self._side_system
	local side = side_system:get_side_from_name("heroes")
	local valid_player_units = side.valid_player_units
	local follow_unit_position = Unit.world_position(self._unit, 1)
	local proximity_check_distance_squared = self._proximity_check_distance_squared
	local closest_player, closest_distance

	for i = 1, #valid_player_units do
		local unit = valid_player_units[i]
		local position = POSITION_LOOKUP[unit]
		local distance_squared = Vector3.distance_squared(position, follow_unit_position)

		if distance_squared < proximity_check_distance_squared and (not closest_distance or distance_squared < closest_distance) then
			closest_distance = distance_squared
			closest_player = unit
		end
	end

	return closest_player
end

SplineFollowerExtension._set_state = function (self, state)
	self._current_state = state
end

SplineFollowerExtension._init_movement_spline = function (self, world, unit, spline_points, spline_name)
	local spline_curve = SplineCurve:new(spline_points, "Bezier", "SplineMovementHermiteInterpolatedMetered", spline_name, 10)

	return spline_curve
end

SplineFollowerExtension.follow_spline = function (self, name)
	self._objective_name = name

	local current_spline_index = self._current_spline_index
	local spline_follower_system = self._spline_follower_system

	if spline_follower_system:has_connected_spline(name, current_spline_index) then
		local spline = spline_follower_system:get_connected_spline(name, current_spline_index)

		current_spline_index = current_spline_index + 1
		self._last_spline = not spline_follower_system:has_connected_spline(name, current_spline_index)

		local unit = self._unit
		local follower_unit_position = Unit.world_position(unit, 1)
		local spline_start_position = spline[1]:unbox()
		local distance_squared = Vector3.distance_squared(follower_unit_position, spline_start_position)

		if self._connect_spline_distance and distance_squared > self._connect_spline_distance then
			spline[1] = Vector3Box(follower_unit_position)
		end

		self._spline_curve = self:_init_movement_spline(self._world, unit, spline)

		self:_set_state(STATES.moving)

		self._is_moving = true
		self._current_spline_index = current_spline_index

		local servo_skull_extension = ScriptUnit.has_extension(unit, "servo_skull_system")

		if servo_skull_extension then
			servo_skull_extension:at_start_of_spline()
		end

		Unit.flow_event(unit, "lua_start_of_spline")
	end
end

SplineFollowerExtension.current_spline_index = function (self)
	return self._current_spline_index
end

SplineFollowerExtension.is_moving = function (self)
	return self._is_moving
end

SplineFollowerExtension.objective_name = function (self)
	return self._objective_name
end

SplineFollowerExtension.hot_join_sync = function (self, current_spline_index, is_moving, objective_name)
	if current_spline_index > 1 then
		local position, rotation = self:_position_rotation_from_game_object()
		local unit = self._unit

		Unit.set_local_position(unit, 1, position)
		Unit.set_local_rotation(unit, 1, rotation)

		self._current_spline_index = is_moving and current_spline_index - 1 or current_spline_index

		if is_moving then
			self:follow_spline(objective_name)
		end
	end
end

return SplineFollowerExtension
