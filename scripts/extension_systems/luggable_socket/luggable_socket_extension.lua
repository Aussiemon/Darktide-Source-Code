local LuggableSocketExtension = class("LuggableSocketExtension")

LuggableSocketExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._is_server = extension_init_context.is_server
	self._unit = unit
	self._physics_world = extension_init_context.physics_world
	local mesh_id, size = self:_fetch_actor_size(unit, "g_slot")
	self._actor_mesh_id = mesh_id
	self._actor_size = Vector3Box(size)
	self._overlapping_units = {}
	self._locked_luggable = nil
	self._is_temp_locked = false
	self._temp_locked_timer = 0
	self._lock_offset_node = nil
	self._socket_objective_target_ext = ScriptUnit.has_extension(unit, "mission_objective_target_system")
end

LuggableSocketExtension.setup_from_component = function (self, consume_luggable, is_side_mission_socket, lock_offset_node)
	self._consume_luggable = consume_luggable
	self._lock_offset_node = lock_offset_node

	if is_side_mission_socket then
		local mission_manager = Managers.state.mission
		local side_mission = mission_manager:side_mission()
		local socket_unit = self._unit

		if side_mission and mission_manager:side_mission_is_luggable() then
			local mission_objective_system = Managers.state.extension:system("mission_objective_system")

			mission_objective_system:register_objective_unit(side_mission.name, socket_unit)
			self._socket_objective_target_ext:set_objective_name(side_mission.name)
		else
			Unit.set_visibility(socket_unit, "main", false)

			local interactee_extension = ScriptUnit.has_extension(socket_unit, "interactee_system")

			if interactee_extension then
				interactee_extension:set_active(false)
			end
		end
	end
end

LuggableSocketExtension._fetch_actor_size = function (self, unit, actor_name)
	local actor_id = Unit.find_actor(unit, actor_name)
	local actor = Unit.actor(unit, actor_id)
	local node = Actor.node(actor)
	local meshes = Unit.get_node_meshes(unit, node, true, false)
	local mesh_id = meshes[1]
	local mesh = Unit.mesh(unit, mesh_id)
	local _, box_half_extents = Mesh.box(mesh)

	return mesh_id, box_half_extents
end

LuggableSocketExtension.hot_join_sync = function (self, socketed_unit)
	if socketed_unit then
		self:socket_luggable(socketed_unit)
	end
end

LuggableSocketExtension.update = function (self, unit, dt, t)
	if self._is_server and self._is_temp_locked then
		self:_check_temp_locked_socket(dt)
	end
end

LuggableSocketExtension._retrieve_overlapping_with_luggables = function (self)
	table.clear(self._overlapping_units)

	local physics_world = self._physics_world
	local unit = self._unit
	local node_id = self._actor_mesh_id
	local position = Unit.world_position(unit, node_id)
	local rotation = Unit.world_rotation(unit, node_id)
	local size = self._actor_size:unbox()
	local hit_actors, actor_count = PhysicsWorld.immediate_overlap(physics_world, "shape", "oobb", "position", position, "rotation", rotation, "size", size, "collision_filter", "filter_dynamic")

	if actor_count > 0 then
		for i = 1, actor_count do
			local hit_actor = hit_actors[i]
			local hit_unit = Actor.unit(hit_actor)

			if hit_unit ~= self._unit and self:_has_same_mission_objective(hit_unit) then
				self._overlapping_units[hit_unit] = true
			end
		end
	end
end

LuggableSocketExtension.is_overlapping_with_luggable = function (self, luggable_unit)
	if luggable_unit then
		return self._overlapping_units[luggable_unit] == true, luggable_unit
	else
		for overlapping_unit, _ in pairs(self._overlapping_units) do
			local luggable_ext = ScriptUnit.has_extension(overlapping_unit, "luggable_system")

			if luggable_ext then
				return true, overlapping_unit
			end
		end
	end

	return false, nil
end

LuggableSocketExtension.add_overlapping_unit = function (self, luggable_unit)
	self._overlapping_units[luggable_unit] = true
end

LuggableSocketExtension._has_same_mission_objective = function (self, unit)
	local same_mission_objective = false
	local mission_objective_target_extension = ScriptUnit.has_extension(unit, "mission_objective_target_system")

	if mission_objective_target_extension then
		local socket_objective_target_ext = self._socket_objective_target_ext
		local socket_objective_name = socket_objective_target_ext:objective_name()
		local unit_objective_name = mission_objective_target_extension:objective_name()

		if socket_objective_name == unit_objective_name then
			same_mission_objective = true
		end
	end

	return same_mission_objective
end

LuggableSocketExtension.socket_luggable = function (self, luggable, socket_lock_time)
	local socket_unit = self._unit

	if self._consume_luggable then
		self._temp_locked_timer = socket_lock_time or 0
		self._is_temp_locked = true
	end

	self:_lock_socket(luggable)
	Unit.flow_event(socket_unit, "lua_socketed")

	local luggable_objective_target_ext = ScriptUnit.has_extension(luggable, "mission_objective_target_system")

	if luggable_objective_target_ext then
		luggable_objective_target_ext:remove_unit_marker()
	end

	if self._is_server then
		local interactee_extension = ScriptUnit.has_extension(luggable, "interactee_system")

		interactee_extension:set_active(false)

		local slot_position, slot_rotation = nil
		local lock_offset_node = self._lock_offset_node

		if lock_offset_node then
			local node_index = Unit.node(socket_unit, lock_offset_node)
			slot_position = Unit.world_position(socket_unit, node_index)
			slot_rotation = Unit.world_rotation(socket_unit, node_index)
		else
			slot_position = Unit.world_position(socket_unit, 1)
			slot_rotation = Unit.world_rotation(socket_unit, 1)
		end

		local locomotion_extension = ScriptUnit.extension(luggable, "locomotion_system")

		locomotion_extension:switch_to_socket_lock(slot_position, slot_rotation)

		local unit_spawner_manager = Managers.state.unit_spawner
		local socket_is_level_unit, socket_id = unit_spawner_manager:game_object_id_or_level_index(socket_unit)
		local luggable_is_level_unit, luggable_id = unit_spawner_manager:game_object_id_or_level_index(luggable)

		Managers.state.game_session:send_rpc_clients("rpc_luggable_socket_luggable", socket_id, socket_is_level_unit, luggable_id, luggable_is_level_unit)
	end
end

LuggableSocketExtension._check_temp_locked_socket = function (self, dt)
	local timer = self._temp_locked_timer
	timer = timer - dt
	timer = math.max(0, timer)

	if timer == 0 then
		self:unlock_socket()

		self._is_temp_locked = false
		self._temp_locked_timer = 0
	else
		self._temp_locked_timer = timer
	end
end

LuggableSocketExtension._lock_socket = function (self, luggable)
	self._locked_luggable = luggable

	if self._is_server then
		self:set_socket_visibility(false)
	end

	local socket_objective_target_ext = self._socket_objective_target_ext

	if socket_objective_target_ext then
		socket_objective_target_ext:remove_unit_marker()
	end
end

LuggableSocketExtension.unlock_socket = function (self)
	self._locked_luggable = nil
	local socket_objective_target_ext = self._socket_objective_target_ext

	if socket_objective_target_ext then
		socket_objective_target_ext:add_unit_marker()
	end

	if self._is_server then
		local socket_unit = self._unit
		local unit_spawner_manager = Managers.state.unit_spawner
		local socket_is_level_unit, socket_id = unit_spawner_manager:game_object_id_or_level_index(socket_unit)

		Managers.state.game_session:send_rpc_clients("rpc_luggable_socket_unlock", socket_id, socket_is_level_unit)
		self:set_socket_visibility(true)
	end
end

LuggableSocketExtension.is_socketable = function (self, unit)
	return self._locked_luggable == nil and self:_has_same_mission_objective(unit)
end

LuggableSocketExtension.is_occupied = function (self)
	return self._locked_luggable ~= nil
end

LuggableSocketExtension.socketed_unit = function (self)
	return self._locked_luggable
end

LuggableSocketExtension.consume_luggable = function (self)
	return self._consume_luggable
end

LuggableSocketExtension.set_socket_visibility = function (self, value)
	local socket_unit = self._unit

	Unit.set_visibility(socket_unit, "main", value)

	if self._is_server then
		local unit_spawner_manager = Managers.state.unit_spawner
		local socket_is_level_unit, socket_id = unit_spawner_manager:game_object_id_or_level_index(socket_unit)

		Managers.state.game_session:send_rpc_clients("rpc_luggable_socket_set_visibility", socket_id, socket_is_level_unit, value)
	end
end

return LuggableSocketExtension
