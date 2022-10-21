local Luggable = require("scripts/utilities/luggable")
local ProjectileHuskLocomotion = require("scripts/extension_systems/locomotion/utilities/projectile_husk_locomotion")
local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local ProjectileLocomotionUtility = require("scripts/extension_systems/locomotion/utilities/projectile_locomotion_utility")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local locomotion_states = ProjectileLocomotionSettings.states
local MAX_SYNCHRONIZE_COUNTER = ProjectileLocomotionSettings.MAX_SYNCHRONIZE_COUNTER
local NUM_BUFFERED_SNAPSHOTS = ProjectileLocomotionSettings.NUM_BUFFERED_SNAPSHOTS
local MAX_SNAPSHOT_ID = NetworkConstants.max_projectile_locomotion_snapshot_id
local SNAPSHOT_ID = "snapshot_id"
local _snapshot_id_diff, _snapshot_id_add = nil
local ProjectileHuskLocomotionExtension = class("ProjectileHuskLocomotionExtension")

ProjectileHuskLocomotionExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id)
	self._projectile_unit = unit
	self._world = extension_init_context.world
	self._physics_world = extension_init_context.physics_world
	self._game_session = game_session
	self._game_object_id = game_object_id
	self._fx_extension = ScriptUnit.has_extension(unit, "fx_system")
	local projectile_template_name = extension_init_data.projectile_template_name
	local projectile_template = ProjectileTemplates[projectile_template_name]
	self._projectile_template = projectile_template
	local projectile_locomotion_template = projectile_template.locomotion_template
	self._projectile_locomotion_template = projectile_locomotion_template
	local item_or_nil = extension_init_data.optional_item

	if item_or_nil then
		self._item = item_or_nil
	end

	self._mass, self._radius, self._dynamic_actor_id = self:_initialize_projectile_info(unit, projectile_locomotion_template)
	self._snapshot_ring_buffer, self._snapshot_game_object_return_data, self._interpolation_data = self:_initialize_interpolation_data()
	local snapshot_id = GameSession.game_object_field(game_session, game_object_id, SNAPSHOT_ID)
	local snapshot = self._snapshot_ring_buffer[snapshot_id]
	local time_manager = Managers.time
	local init_t = time_manager:has_timer("gameplay") and time_manager:time("gameplay") or 0

	self:_read_snapshot(snapshot, init_t, self._snapshot_game_object_return_data)

	self._latest_received_snapshot_id = snapshot_id
	local dynamic_actor_id = self._dynamic_actor_id

	if dynamic_actor_id then
		ProjectileLocomotionUtility.set_kinematic(unit, dynamic_actor_id, true)
	end

	if projectile_template.always_hidden then
		Unit.set_unit_visibility(unit, false)
	elseif extension_init_data.hide_until_initial_interpolation_start then
		Unit.set_unit_visibility(unit, false)

		self._hidden_until_initial_interpolation_start = true
	end

	self:_switch_locomotion_state(snapshot.locomotion_state, unit)
	self:_hide_pin()
end

ProjectileHuskLocomotionExtension.current_state = function (self)
	return self._current_locomotion_state
end

ProjectileHuskLocomotionExtension.locomotion_template = function (self)
	return self._projectile_locomotion_template
end

ProjectileHuskLocomotionExtension.mass = function (self)
	return self._mass
end

ProjectileHuskLocomotionExtension.radius = function (self)
	return self._radius
end

ProjectileHuskLocomotionExtension.current_speed = function (self)
	return self._current_speed
end

ProjectileHuskLocomotionExtension.pre_update = function (self, unit, dt, t)
	self:_read_latest_snapshot(unit, dt, t)
end

ProjectileHuskLocomotionExtension.update = function (self, unit, dt, t)
	local old_position = POSITION_LOOKUP[unit]
	local current_position = self:_update_interpolation(unit, dt, t)
	local distance = current_position and Vector3.distance(current_position, old_position) or 0
	local speed = distance / dt
	self._current_speed = speed
	local fx_extension = self._fx_extension

	if fx_extension then
		fx_extension:set_speed_paramater(speed)
	end
end

ProjectileHuskLocomotionExtension._num_snapshots_buffered = function (self, initial_received_snapshot_id, t)
	local snapshot_ring_buffer = self._snapshot_ring_buffer
	local iteration_times = 0

	repeat
		local snapshot_id = _snapshot_id_add(initial_received_snapshot_id, -iteration_times)
		local snapshot = snapshot_ring_buffer[snapshot_id]

		if ProjectileHuskLocomotion.snapshot_is_outdated(snapshot, t) then
			return iteration_times
		end

		iteration_times = iteration_times + 1
	until MAX_SNAPSHOT_ID <= iteration_times

	return MAX_SNAPSHOT_ID
end

ProjectileHuskLocomotionExtension._update_interpolation = function (self, unit, dt, t)
	local interpolation_data = self._interpolation_data

	if not interpolation_data.is_interpolating then
		local latest_received_snapshot_id = self._latest_received_snapshot_id
		local num_snapshots_buffered = self:_num_snapshots_buffered(latest_received_snapshot_id, t)

		if NUM_BUFFERED_SNAPSHOTS <= num_snapshots_buffered then
			self:_start_interpolating(unit, interpolation_data, latest_received_snapshot_id, t)
		else
			return
		end
	end

	local snapshot_ring_buffer = self._snapshot_ring_buffer
	local snapshot_t = self:_update_interpolation_time(interpolation_data, snapshot_ring_buffer, unit, dt, t)

	return self:_interpolate(unit, interpolation_data, snapshot_ring_buffer, snapshot_t)
end

ProjectileHuskLocomotionExtension._update_interpolation_time = function (self, interpolation_data, snapshot_ring_buffer, unit, dt, t)
	local snapshot_time = (MAX_SYNCHRONIZE_COUNTER + 1) * GameParameters.fixed_time_step
	local old_interpolation_t = interpolation_data.t
	local time_left_in_current_snapshot = snapshot_time - old_interpolation_t
	local num_buffered_snapshots = _snapshot_id_diff(interpolation_data.target_snapshot_id, self._latest_received_snapshot_id)
	local buffer_snapshot_time = num_buffered_snapshots * snapshot_time
	local time_until_reached_latest_snapshot = time_left_in_current_snapshot + buffer_snapshot_time
	local wanted_buffered_time = NUM_BUFFERED_SNAPSHOTS * snapshot_time

	if time_until_reached_latest_snapshot > wanted_buffered_time then
		interpolation_data.time_scale = 1.05
	else
		interpolation_data.time_scale = 0.95
	end

	local new_interpolation_t = old_interpolation_t + dt * interpolation_data.time_scale
	interpolation_data.t = new_interpolation_t
	local snapshot_t = new_interpolation_t / snapshot_time

	if snapshot_t > 1 then
		snapshot_t = self:_step_interpolation_snapshots(interpolation_data, snapshot_ring_buffer, snapshot_t, snapshot_time, unit, t)
	end

	return snapshot_t
end

ProjectileHuskLocomotionExtension._step_interpolation_snapshots = function (self, interpolation_data, snapshot_ring_buffer, snapshot_t, snapshot_time, unit, t)
	local num_snapshots_to_jump = math.floor(snapshot_t)
	local old_start_snapshot_id = interpolation_data.start_snapshot_id
	local start_snapshot_id = _snapshot_id_add(old_start_snapshot_id, num_snapshots_to_jump)
	local target_snapshot_id = _snapshot_id_add(start_snapshot_id, 1)
	local target_snapshot = snapshot_ring_buffer[target_snapshot_id]
	local new_snapshot_t = nil

	if not ProjectileHuskLocomotion.snapshot_is_outdated(target_snapshot, t) then
		new_snapshot_t = snapshot_t - num_snapshots_to_jump
		interpolation_data.t = snapshot_time * new_snapshot_t
		interpolation_data.start_snapshot_id = start_snapshot_id
		interpolation_data.target_snapshot_id = target_snapshot_id
		local start_snapshot = snapshot_ring_buffer[start_snapshot_id]
		local loc_state = start_snapshot.locomotion_state

		if self._current_locomotion_state ~= loc_state then
			self:_switch_locomotion_state(loc_state, unit)
		end
	else
		local new_target_snapshot_id = self._latest_received_snapshot_id
		local new_start_snapshot_id = _snapshot_id_add(new_target_snapshot_id, -1)
		interpolation_data.start_snapshot_id = new_start_snapshot_id
		interpolation_data.target_snapshot_id = new_target_snapshot_id
		interpolation_data.t = snapshot_time
		interpolation_data.is_interpolating = false
		new_snapshot_t = 1
		local new_target_snapshot = snapshot_ring_buffer[new_target_snapshot_id]
		local loc_state = new_target_snapshot.locomotion_state

		if self._current_locomotion_state ~= loc_state then
			self:_switch_locomotion_state(loc_state, unit)
		end
	end

	return new_snapshot_t
end

ProjectileHuskLocomotionExtension._switch_locomotion_state = function (self, new_loc_state, unit)
	local old_loc_state = self._current_locomotion_state

	if old_loc_state == locomotion_states.carried then
		local carrier_unit = self._carrier_unit

		if ALIVE[carrier_unit] then
			Luggable.unlink_from_player_unit(self._world, unit)
		end
	end

	if new_loc_state == locomotion_states.carried then
		local carrier_unit_id = GameSession.game_object_field(self._game_session, self._game_object_id, "carrier_unit_id")
		local carrier_unit = Managers.state.unit_spawner:unit(carrier_unit_id)

		if ALIVE[carrier_unit] then
			self._carrier_unit = carrier_unit

			Luggable.link_to_player_unit(self._world, carrier_unit, unit, self._item)
		end
	end

	self._current_locomotion_state = new_loc_state
end

ProjectileHuskLocomotionExtension._interpolate = function (self, unit, interpolation_data, snapshot_ring_buffer, snapshot_t)
	local start_snapshot_id = interpolation_data.start_snapshot_id
	local target_snapshot_id = interpolation_data.target_snapshot_id
	local start_snapshot = snapshot_ring_buffer[start_snapshot_id]
	local target_snapshot = snapshot_ring_buffer[target_snapshot_id]
	local start_pos, start_rot, _, start_loc_state = self:_unbox_snapshot(start_snapshot)
	local target_pos, target_rot = self:_unbox_snapshot(target_snapshot)
	local current_pos = Vector3.lerp(start_pos, target_pos, snapshot_t)
	local current_rot = Quaternion.lerp(start_rot, target_rot, snapshot_t)

	Unit.set_local_position(unit, 1, current_pos)
	Unit.set_local_rotation(unit, 1, current_rot)

	return current_pos
end

ProjectileHuskLocomotionExtension._initialize_projectile_info = function (self, unit, projectile_locomotion_template)
	local mass = nil
	local dynamic_actor_id = Unit.find_actor(unit, "dynamic")

	if dynamic_actor_id then
		local dynamic_actor = Unit.actor(unit, dynamic_actor_id)
		mass = Actor.mass(dynamic_actor)
	else
		mass = projectile_locomotion_template.integrator_parameters.mass
	end

	local _, half_extents = Unit.box(unit, true)
	local radius = math.max(half_extents.x, half_extents.y, half_extents.z)

	return mass, radius, dynamic_actor_id
end

ProjectileHuskLocomotionExtension._initialize_interpolation_data = function (self)
	local snapshot_ring_buffer = Script.new_array(MAX_SNAPSHOT_ID)

	for i = 1, MAX_SNAPSHOT_ID do
		snapshot_ring_buffer[i] = self:_new_snapshot()
	end

	local snapshot_game_object_return_data = {
		projectile_locomotion_state_id = 1,
		position = {},
		rotation = {}
	}
	local interpolation_data = {
		time_scale = 1,
		is_interpolating = false,
		start_snapshot_id = math.huge,
		target_snapshot_id = math.huge,
		t = math.huge
	}

	return snapshot_ring_buffer, snapshot_game_object_return_data, interpolation_data
end

ProjectileHuskLocomotionExtension._new_snapshot = function (self)
	local snapshot = {
		approximated = false,
		read_time = 0,
		position = Vector3Box(Vector3.zero()),
		rotation = QuaternionBox(Quaternion.identity()),
		locomotion_state = locomotion_states.none
	}

	return snapshot
end

ProjectileHuskLocomotionExtension._read_snapshot = function (self, snapshot, t, game_object_return_data)
	GameSession.game_object_fields(self._game_session, self._game_object_id, game_object_return_data)

	local locomotion_state = NetworkLookup.projectile_locomotion_states[game_object_return_data.projectile_locomotion_state_id]
	local approximated = false

	self:_fill_snapshot(snapshot, t, game_object_return_data.position, game_object_return_data.rotation, locomotion_state, approximated)
end

ProjectileHuskLocomotionExtension._fill_snapshot = function (self, snapshot, read_time, position, rotation, locomotion_state, approximated)
	snapshot.read_time = read_time

	snapshot.position:store(position)
	snapshot.rotation:store(rotation)

	snapshot.locomotion_state = locomotion_state
	snapshot.approximated = approximated
end

ProjectileHuskLocomotionExtension._read_latest_snapshot = function (self, unit, dt, t)
	local game_session = self._game_session
	local game_object_id = self._game_object_id
	local latest_received_snapshot_id = self._latest_received_snapshot_id
	local snapshot_id = GameSession.game_object_field(game_session, game_object_id, SNAPSHOT_ID)

	if snapshot_id == latest_received_snapshot_id then
		return
	end

	local num_snapshots_ahead_of_latest = _snapshot_id_diff(latest_received_snapshot_id, snapshot_id)
	local snapshot_ring_buffer = self._snapshot_ring_buffer
	local snapshot = snapshot_ring_buffer[snapshot_id]

	self:_read_snapshot(snapshot, t, self._snapshot_game_object_return_data)

	if num_snapshots_ahead_of_latest > 1 then
		local base_snapshot = snapshot_ring_buffer[latest_received_snapshot_id]
		local base_pos, base_rot = self:_unbox_snapshot(base_snapshot)
		local target_pos, target_rot, target_loc_state = self:_unbox_snapshot(snapshot)
		local approximation_timeline = GameParameters.fixed_time_step * num_snapshots_ahead_of_latest
		local approximated = true

		for i = 1, num_snapshots_ahead_of_latest - 1 do
			local approx_snapshot_id = _snapshot_id_add(snapshot_id, -i)
			local approx_snapshot = snapshot_ring_buffer[approx_snapshot_id]
			local approx_t = i / num_snapshots_ahead_of_latest
			local approx_t_inv = 1 - approx_t
			local approx_read_t_delta = approximation_timeline * approx_t
			local approx_read_t = t - approx_read_t_delta
			local approx_pos = Vector3.lerp(base_pos, target_pos, approx_t_inv)
			local approx_rot = Quaternion.lerp(base_rot, target_rot, approx_t_inv)

			self:_fill_snapshot(approx_snapshot, approx_read_t, approx_pos, approx_rot, target_loc_state, approximated)
		end
	end

	self._latest_received_snapshot_id = snapshot_id
end

ProjectileHuskLocomotionExtension._start_interpolating = function (self, unit, interpolation_data, latest_received_snapshot_id, t)
	local start_snapshot_id = _snapshot_id_add(latest_received_snapshot_id, -(NUM_BUFFERED_SNAPSHOTS - 1))
	local target_snapshot_id = _snapshot_id_add(start_snapshot_id, 1)
	local snapshot_ring_buffer = self._snapshot_ring_buffer
	local start_snapshot = snapshot_ring_buffer[start_snapshot_id]
	interpolation_data.is_interpolating = true
	interpolation_data.t = 0
	interpolation_data.start_snapshot_id = start_snapshot_id
	interpolation_data.target_snapshot_id = target_snapshot_id
	local loc_state = start_snapshot.locomotion_state

	if self._current_locomotion_state ~= loc_state then
		self:_switch_locomotion_state(loc_state, unit)
	end

	if self._hidden_until_initial_interpolation_start then
		self._hidden_until_initial_interpolation_start = nil

		Unit.set_unit_visibility(unit, true)
	end
end

ProjectileHuskLocomotionExtension._unbox_snapshot = function (self, snapshot)
	local position = snapshot.position:unbox()
	local rotation = snapshot.rotation:unbox()
	local locomotion_state = snapshot.locomotion_state

	return position, rotation, locomotion_state
end

function _snapshot_id_diff(snapshot_start, snapshot_end)
	if snapshot_start <= snapshot_end then
		return snapshot_end - snapshot_start
	else
		return MAX_SNAPSHOT_ID - snapshot_start + snapshot_end
	end
end

function _snapshot_id_add(snapshot_id, number_to_add)
	return (snapshot_id + number_to_add - 1) % MAX_SNAPSHOT_ID + 1
end

ProjectileHuskLocomotionExtension._hide_pin = function (self)
	local projectile_unit = self._projectile_unit
	local has_visibility_group = Unit.has_visibility_group(projectile_unit, "pin")

	if has_visibility_group then
		Unit.set_visibility(projectile_unit, "pin", false)
	end
end

return ProjectileHuskLocomotionExtension
