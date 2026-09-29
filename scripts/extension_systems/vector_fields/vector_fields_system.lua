-- chunkname: @scripts/extension_systems/vector_fields/vector_fields_system.lua

local VectorFieldDefinitions = require("scripts/settings/vector_fields/vector_fields_definitions")
local VectorFieldsSystem = class("VectorFieldsSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_clients_vector_field_wake_actors",
	"rpc_add_vector_field_effect",
	"rpc_remove_active_vector_field_effect",
}
local SERVER_RPCS = {}

VectorFieldsSystem.init = function (self, extension_system_creation_context, ...)
	VectorFieldsSystem.super.init(self, extension_system_creation_context, ...)

	self._vector_fields_data = {}
	self._active_vector_fields_effects = {}

	local connection_manager = Managers.connection
	local network_event_delegate = connection_manager:network_event_delegate()

	self._network_event_delegate = network_event_delegate

	if self._is_server then
		network_event_delegate:register_session_events(self, unpack(SERVER_RPCS))
	else
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

VectorFieldsSystem.destroy = function (self)
	if self._is_server then
		self._network_event_delegate:unregister_events(unpack(SERVER_RPCS))
		MinionLocomotion.destroy()
	else
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
		MinionHuskLocomotion.destroy()
	end
end

VectorFieldsSystem.pre_update = function (self, unit, dt, t)
	if VectorFieldsSystem.super.pre_update then
		VectorFieldsSystem.super.pre_update(self, unit, dt, t)
	end

	local should_apply_wind = false

	for name, data in pairs(self._vector_fields_data) do
		if World.physics_world(self._world) then
			if t > data.time_left then
				self._vector_fields_data[name] = nil
			else
				local position = data.position:unbox()
				local rotation = data.rotation and data.rotation:unbox() or Quaternion.identity()
				local half_size = data.width
				local extends = Vector3(half_size, half_size, half_size)
				local vf_wind = World.vector_field(self._world, "wind")
				local actors, actor_count = PhysicsWorld.immediate_overlap(self._physics_world, "position", position, "rotation", rotation, "size", extends, "shape", "oobb", "types", "dynamics", "collision_filter", "filter_vector_field_wind")

				for i = 1, actor_count do
					local actor = actors[i]

					if Actor.is_dynamic(actor) and not Actor.is_kinematic(actor) then
						Actor.wake_up(actor)
					end
				end

				should_apply_wind = true
			end
		end
	end

	if should_apply_wind then
		local vf_wind = World.vector_field(self._world, "wind")

		PhysicsWorld.apply_wind(self._physics_world, vf_wind, "filter_vector_field_wind")
	end
end

local temp_args = {}
local temp_params = {}
local ARGS = VectorFieldDefinitions.ARGS
local NUM_ARGS = VectorFieldDefinitions.NUM_ARGS

VectorFieldsSystem.add_vector_field_effect = function (self, ...)
	table.clear(temp_args)
	table.clear(temp_params)

	local num_args = select("#", ...)

	for i = 1, num_args, 2 do
		local arg, val = select(i, ...)

		temp_args[ARGS[arg]] = val
	end

	for i = 1, NUM_ARGS do
		local val = temp_args[i]

		temp_args[i] = val
	end

	for arg_index, val in pairs(temp_args) do
		local name = ARGS[arg_index].name

		temp_params[name] = val
	end

	for name, val in pairs(temp_params) do
		if name ~= ("shape" or "vector_type") and type(val) == "string" and val == "none" then
			temp_params[name] = nil
		end
	end

	local vector_type = temp_params.vector_type
	local shape = temp_params.shape
	local position = temp_params.position
	local rotation = temp_params.rotation
	local extents = temp_params.extents
	local direction = temp_params.direction
	local speed = temp_params.speed
	local amplitude = temp_params.amplitude
	local frequency = temp_params.frequency
	local phase = temp_params.phase
	local pull_speed = temp_params.pull_speed
	local whirl_speed = temp_params.whirl_speed
	local launch_speed = temp_params.launch_speed
	local launch_radius = temp_params.launch_radius
	local duration = temp_params.duration

	if not vector_type then
		-- Nothing
	end

	if self._is_server then
		Managers.state.game_session:send_rpc_clients("rpc_add_vector_field_effect", vector_type, shape, position, rotation, extents, direction, speed, amplitude, frequency, phase, pull_speed, whirl_speed, launch_speed, launch_radius, duration)
	end

	local choosen_effect = VectorFieldDefinitions[vector_type][shape]

	if choosen_effect then
		for i = 1, #choosen_effect.required_paramters do
			local required_parameter = choosen_effect.required_paramters[i]

			if not temp_params[required_parameter] then
				-- Nothing
			end
		end

		for i = 1, #choosen_effect.required_settings do
			local required_setting = choosen_effect.required_settings[i]

			if not temp_params[required_setting] then
				-- Nothing
			end
		end

		local params, settings = choosen_effect.create_parameter(temp_params)
		local vector_field = World.vector_field(self._world, "wind")
		local effect_id = VectorField.add(vector_field, choosen_effect.effect_resource, params, settings)

		self._active_vector_fields_effects[effect_id] = Vector3Box(temp_params.position)

		return effect_id
	end
end

VectorFieldsSystem.rpc_clients_vector_field_wake_actors = function (self, channel_id, name, time, position, rotation, width, height, collision_filter)
	self:_awake_vector_field(name, time, position, rotation, width, height, collision_filter)
end

VectorFieldsSystem._awake_vector_field = function (self, name, time, position, rotation, width, height, collision_filter)
	local t = Managers.time:time("gameplay")
	local time_left = time + t

	self._vector_fields_data[name] = {
		is_new = true,
		time_left = time_left,
		position = self._is_server and position or not self._is_server and Vector3Box(position),
		width = width,
		height = height,
		collision_filter = collision_filter,
	}
end

VectorFieldsSystem.awake_vector_field = function (self, name, time, position, rotation, width, height, collision_filter)
	if not DEDICATED_SERVER then
		self:_awake_vector_field(name, time, position, rotation, width, height, collision_filter)
	end

	Managers.state.game_session:send_rpc_clients("rpc_clients_vector_field_wake_actors", name, time, position:unbox(), rotation, width, height, collision_filter)
end

VectorFieldsSystem.stop_vector_field_effect = function (self, effect_id)
	if self._is_server then
		Managers.state.game_session:send_rpc_clients("rpc_remove_active_vector_field_effect", effect_id)

		if not DEDICATED_SERVER and self._active_vector_fields_effects[effect_id] then
			local vector_field = World.vector_field(self._world, "wind")

			VectorField.remove(vector_field, effect_id)
		end
	elseif self._active_vector_fields_effects[effect_id] then
		local vector_field = World.vector_field(self._world, "wind")

		VectorField.remove(vector_field, effect_id)
	end
end

VectorFieldsSystem.rpc_remove_active_vector_field_effect = function (self, channel_id, effect_id, optional_vector_field_name)
	self:stop_vector_field_effect(effect_id, optional_vector_field_name)
end

local EMPTY_REPLACEMENT = "none"

VectorFieldsSystem.rpc_add_vector_field_effect = function (self, channel_id, vector_type, shape, position, rotation, extents, direction, speed, amplitude, frequency, phase, pull_speed, whirl_speed, launch_speed, launch_radius, duration)
	self:add_vector_field_effect("vector_type", vector_type, "shape", shape, "position", position or EMPTY_REPLACEMENT, "rotation", rotation or EMPTY_REPLACEMENT, "extents", extents or EMPTY_REPLACEMENT, "direction", direction or EMPTY_REPLACEMENT, "speed", speed or EMPTY_REPLACEMENT, "amplitude", amplitude or EMPTY_REPLACEMENT, "frequency", frequency or EMPTY_REPLACEMENT, "phase", phase or EMPTY_REPLACEMENT, "pull_speed", pull_speed or EMPTY_REPLACEMENT, "whirl_speed", whirl_speed or EMPTY_REPLACEMENT, "launch_speed", launch_speed or EMPTY_REPLACEMENT, "launch_radius", launch_radius or EMPTY_REPLACEMENT, "duration", duration)
end

return VectorFieldsSystem
