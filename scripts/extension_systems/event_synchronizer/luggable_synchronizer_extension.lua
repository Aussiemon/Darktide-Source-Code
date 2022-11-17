local LuggableSynchronizerExtension = class("LuggableSynchronizerExtension", "EventSynchronizerBaseExtension")
local VOLUME_NAME = "g_luggable_spawn_volume"

LuggableSynchronizerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	LuggableSynchronizerExtension.super.init(self, extension_init_context, unit, extension_init_data, ...)

	self._spawners = {}
	self._sockets = {}
	self._volumes = {}
	self._spawner_to_luggable = {}
	self._socket_to_luggable = {}
	self._manual_luggable_spawn = false
	self._keep_unused_sockets = false
	self._luggable_should_respawn = true
	self._luggable_respawn_timer = 0
	self._luggable_reset_timer = 0
	self._luggable_consume_timer = 0
	self._spawner_respawn_timers = {}
	self._luggable_reset_timers = {}
	self._luggable_consume_timers = {}
	self._spawners_with_marker_on_start = {}
	self._objective_stages = 1
	self._is_side_mission_synchronizer = false
end

LuggableSynchronizerExtension.setup_from_component = function (self, objective_name, objective_stages, auto_start, manual_luggable_spawn, max_socket_target, keep_unused_sockets, luggable_should_respawn, luggable_respawn_timer, luggable_reset_timer, luggable_consume_timer, is_side_mission_synchronizer, automatic_start_on_level_spawned)
	local mission_manager = Managers.state.mission
	local side_mission = mission_manager:side_mission()
	local should_register_side_mission_unit = is_side_mission_synchronizer and side_mission and mission_manager:side_mission_is_luggable()

	if not is_side_mission_synchronizer or should_register_side_mission_unit then
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")
		local unit = self._unit

		if is_side_mission_synchronizer then
			objective_name = side_mission.name or objective_name
		end

		mission_objective_system:register_objective_synchronizer(objective_name, unit)
	end

	self._objective_name = objective_name
	self._objective_stages = objective_stages
	self._auto_start = auto_start
	self._manual_luggable_spawn = manual_luggable_spawn
	self._max_socket_target = max_socket_target
	self._keep_unused_sockets = keep_unused_sockets
	self._luggable_should_respawn = luggable_should_respawn
	self._luggable_respawn_timer = luggable_respawn_timer
	self._luggable_reset_timer = luggable_reset_timer
	self._luggable_consume_timer = luggable_consume_timer
	self._is_side_mission_synchronizer = is_side_mission_synchronizer
end

LuggableSynchronizerExtension.fixed_update = function (self, unit, dt, t)
	if self._is_server and self._mission_active then
		if self._luggable_should_respawn then
			self:_check_reset_timer(dt)
			self:_check_boundaries()
		end

		self:_check_luggable_to_respawn(dt)

		local consumed_num = self:_check_luggable_to_consume(dt)
		local has_consumed = consumed_num > 0
		local has_socketed = self:_check_sockets()

		if has_socketed or has_consumed then
			local additional_plugged_socket = has_consumed and consumed_num or 1

			self:_update_mission_increment(dt, additional_plugged_socket)
			Unit.flow_event(self._unit, "lua_luggable_socketed")
		end
	end
end

local function _retrieve_units_by_system(units, system_name)
	local result = {}

	for i = 1, #units do
		local unit = units[i]
		local extension = ScriptUnit.has_extension(unit, system_name)

		if extension then
			result[#result + 1] = unit
		end
	end

	return result
end

local function _retrieve_units_by_zone(units, volume_name)
	local result = {}

	for i = 1, #units do
		local unit = units[i]
		local extension = Unit.has_volume(unit, volume_name)

		if extension then
			result[#result + 1] = unit
		end
	end

	return result
end

LuggableSynchronizerExtension.register_connected_units = function (self, stage_units)
	local old_sockets = self._sockets
	self._volumes = _retrieve_units_by_zone(stage_units, VOLUME_NAME)
	self._spawners = _retrieve_units_by_system(stage_units, "pickup_system")
	self._sockets = _retrieve_units_by_system(stage_units, "luggable_socket_system")

	if old_sockets and self._keep_unused_sockets then
		local sockets = self._sockets

		for _, socket_unit in ipairs(old_sockets) do
			if not self._socket_to_luggable[socket_unit] then
				sockets[#sockets + 1] = socket_unit
			end
		end
	end

	if self._is_server then
		self:_enable_sockets_visibility()
	end

	return stage_units
end

LuggableSynchronizerExtension._check_boundaries = function (self)
	local spawner_to_luggable = self._spawner_to_luggable
	local unit = self._unit

	for _, luggable_unit in pairs(spawner_to_luggable) do
		local unit_pos = Unit.world_position(luggable_unit, 1)
		local is_inside = Unit.is_point_inside_volume(unit, "g_luggable_safe_zone", unit_pos)

		if not is_inside then
			local respawn_at_spawner = true

			self:_despawn_luggable(luggable_unit, respawn_at_spawner)
		end
	end
end

LuggableSynchronizerExtension._check_reset_timer = function (self, dt)
	local luggable_reset_timers = self._luggable_reset_timers

	for luggable_unit, timer in pairs(luggable_reset_timers) do
		timer = timer - dt
		timer = math.max(0, timer)

		if timer == 0 then
			local respawn_at_spawner = true

			self:_despawn_luggable(luggable_unit, respawn_at_spawner)
		else
			self._luggable_reset_timers[luggable_unit] = timer
		end
	end
end

LuggableSynchronizerExtension._check_luggable_to_respawn = function (self, dt)
	local spawner_respawn_timers = self._spawner_respawn_timers

	for spawner_unit, timer in pairs(spawner_respawn_timers) do
		timer = timer - dt
		timer = math.max(0, timer)

		if timer == 0 then
			self:spawn_luggable(spawner_unit)

			self._spawner_respawn_timers[spawner_unit] = nil
		else
			self._spawner_respawn_timers[spawner_unit] = timer
		end
	end
end

LuggableSynchronizerExtension._check_luggable_to_consume = function (self, dt)
	local luggable_consume_timers = self._luggable_consume_timers
	local consume_num = 0

	for luggable_unit, timer in pairs(luggable_consume_timers) do
		timer = timer - dt
		timer = math.max(0, timer)

		if timer == 0 then
			local respawn_at_spawner = false

			self:_despawn_luggable(luggable_unit, respawn_at_spawner)

			consume_num = consume_num + 1
		else
			self._luggable_consume_timers[luggable_unit] = timer
		end
	end

	return consume_num
end

LuggableSynchronizerExtension._check_sockets = function (self)
	local sockets = self._sockets
	local spawner_to_luggable = self._spawner_to_luggable

	for _, socket_unit in ipairs(sockets) do
		local is_socketed = self._socket_to_luggable[socket_unit] ~= nil

		if not is_socketed then
			local socket_ext = ScriptUnit.extension(socket_unit, "luggable_socket_system")

			for spawner_unit, luggable_unit in pairs(spawner_to_luggable) do
				local has_overlap = socket_ext:is_overlapping_with_luggable(luggable_unit)

				if has_overlap then
					local consume_luggable = socket_ext:consume_luggable()
					local socket_lock_time = consume_luggable and self._luggable_consume_timer or nil

					socket_ext:socket_luggable(luggable_unit, socket_lock_time)

					self._luggable_reset_timers[luggable_unit] = nil

					if not consume_luggable then
						self._socket_to_luggable[socket_unit] = luggable_unit
						self._spawner_to_luggable[spawner_unit] = nil

						return true
					else
						self._luggable_consume_timers[luggable_unit] = self._luggable_consume_timer
					end
				end
			end
		end
	end

	return false
end

LuggableSynchronizerExtension._update_mission_increment = function (self, dt, increment)
	local objective_name = self._objective_name
	local mission_objective_system = Managers.state.extension:system("mission_objective_system")

	if mission_objective_system:is_current_active_objective(objective_name) then
		mission_objective_system:external_update_mission_objective(objective_name, dt, increment)
	end
end

LuggableSynchronizerExtension.start_event = function (self)
	LuggableSynchronizerExtension.super.start_event(self)
end

LuggableSynchronizerExtension.start_stage = function (self)
	if self._is_server then
		self:_configure_spawner_markers()

		if not self._manual_luggable_spawn then
			self:_spawn_all_luggables()
		end
	end

	Unit.flow_event(self._unit, "lua_stage_started")
end

LuggableSynchronizerExtension.finished_stage = function (self)
	table.clear(self._spawners_with_marker_on_start)
end

LuggableSynchronizerExtension._configure_spawner_markers = function (self)
	local spawners = self._spawners
	local spawners_with_marker_on_start = self._spawners_with_marker_on_start

	for i = 1, #spawners do
		local spawner_unit = spawners[i]
		local objective_target_ext = ScriptUnit.extension(spawner_unit, "mission_objective_target_system")

		if objective_target_ext:should_add_marker_on_objective_start() then
			objective_target_ext:remove_unit_marker()
			objective_target_ext:set_add_marker_on_objective_start(false)

			spawners_with_marker_on_start[spawner_unit] = true
		end
	end
end

LuggableSynchronizerExtension.spawn_luggable = function (self, spawner_unit)
	if self._mission_active then
		local pickup_extension = ScriptUnit.extension(spawner_unit, "pickup_system")
		local mission_target_extension = ScriptUnit.has_extension(spawner_unit, "mission_objective_system")
		local luggable_unit, _ = nil
		local objective_name = self._objective_name
		local objective_stage = 1

		if mission_target_extension then
			objective_name = mission_target_extension:objective_name()
			objective_stage = mission_target_extension:objective_stage()
		end

		if self._is_side_mission_synchronizer then
			local side_mission = Managers.state.mission:side_mission()
			local pickup_name = side_mission.unit_name
			objective_name = side_mission.name
			luggable_unit, _ = pickup_extension:spawn_specific_item(nil, pickup_name)
		else
			luggable_unit, _ = pickup_extension:spawn_item()
		end

		local luggable_objective_target_extension = ScriptUnit.extension(luggable_unit, "mission_objective_target_system")
		local sync = true

		luggable_objective_target_extension:set_objective_name(objective_name, sync)

		local luggable_extension = ScriptUnit.extension(luggable_unit, "luggable_system")

		luggable_extension:set_synchronizer(self)
		self:_register_spawned_luggable(luggable_unit, spawner_unit, objective_name, objective_stage)

		self._spawner_to_luggable[spawner_unit] = luggable_unit
	end
end

LuggableSynchronizerExtension._despawn_luggable = function (self, luggable_unit_to_del, respawn_at_spawner)
	local spawner_to_luggable = self._spawner_to_luggable
	local spawner_unit = nil

	for spawner, luggable in pairs(spawner_to_luggable) do
		if luggable_unit_to_del == luggable then
			spawner_unit = spawner

			break
		end
	end

	self._spawner_to_luggable[spawner_unit] = nil
	self._luggable_reset_timers[luggable_unit_to_del] = nil
	self._luggable_consume_timers[luggable_unit_to_del] = nil
	local pickup_extension = ScriptUnit.has_extension(spawner_unit, "pickup_system")

	pickup_extension:unspawn_item(luggable_unit_to_del)

	if respawn_at_spawner then
		if self._spawner_respawn_timers[spawner_unit] then
			Log.error("LuggableSynchronizerExtension", "Spawner is already occupied")

			spawner_unit = self:_get_free_spawner()
		end

		self._spawner_respawn_timers[spawner_unit] = self._luggable_respawn_timer
	end
end

LuggableSynchronizerExtension._register_spawned_luggable = function (self, luggable_unit, spawner_unit, objective_name, objective_stage)
	local luggable_objective_target_ext = ScriptUnit.extension(luggable_unit, "mission_objective_target_system")

	luggable_objective_target_ext:set_objective_name(objective_name)

	local should_spawn_with_marker = self._spawners_with_marker_on_start[spawner_unit]

	if should_spawn_with_marker then
		luggable_objective_target_ext:add_unit_marker()
	end

	local mission_objective_system = self._mission_objective_system

	mission_objective_system:register_objective_unit(objective_name, luggable_unit, objective_stage)
end

LuggableSynchronizerExtension.add_marker_on_luggable = function (self, spawner_unit)
	local luggable_unit = self._spawner_to_luggable[spawner_unit]

	if luggable_unit then
		local luggable_objective_target_ext = ScriptUnit.extension(luggable_unit, "mission_objective_target_system")

		luggable_objective_target_ext:add_unit_marker()
	end
end

local free_units = {}

LuggableSynchronizerExtension._find_free_random_unit = function (self, all_units, reserved_units)
	table.clear(free_units)

	local volumes = self._volumes

	if #volumes > 0 then
		local new_seed, rnd_num = math.next_random(self._seed, 1, #volumes)
		self._seed = new_seed
		local volume_index = rnd_num
		local volume_unit = volumes[volume_index]

		for i = 1, #all_units do
			local unit = all_units[i]

			if reserved_units[unit] == nil and Unit.is_point_inside_volume(volume_unit, VOLUME_NAME, POSITION_LOOKUP[unit]) then
				free_units[#free_units + 1] = unit
			end
		end

		if #free_units ~= 0 then
			table.remove(volumes, volume_index)
		end
	end

	if #free_units == 0 then
		for i = 1, #all_units do
			local unit = all_units[i]

			if reserved_units[unit] == nil then
				free_units[#free_units + 1] = unit
			end
		end
	end

	local num_free_units = #free_units
	local free_unit = nil

	if num_free_units > 0 then
		local new_seed, rnd_num = math.next_random(self._seed, 1, num_free_units)
		self._seed = new_seed
		free_unit = free_units[rnd_num]
	end

	return free_unit
end

LuggableSynchronizerExtension._get_free_spawner = function (self)
	local spawners = self._spawners
	local occuiped = self._spawner_to_luggable
	local spawner = self:_find_free_random_unit(spawners, occuiped)

	while self._spawner_respawn_timers[spawner] do
		spawner = self:_find_free_random_unit(spawners, occuiped)
	end

	return self:_find_free_random_unit(self._spawners, self._spawner_to_luggable)
end

LuggableSynchronizerExtension.get_free_socket = function (self)
	return self:_find_free_random_unit(self._sockets, self._socket_to_luggable)
end

LuggableSynchronizerExtension.sockets_to_fill = function (self)
	return math.min(#self._sockets, self._max_socket_target)
end

LuggableSynchronizerExtension.total_sockets = function (self)
	return #self._sockets
end

LuggableSynchronizerExtension.active_socket_units = function (self)
	return self._sockets
end

LuggableSynchronizerExtension.get_objective_stages = function (self)
	return self._objective_stages
end

LuggableSynchronizerExtension.spawn_single_luggable = function (self)
	local free_spawner = self:_get_free_spawner()
	local free_socket = self:get_free_socket()

	if free_spawner and free_socket then
		self:spawn_luggable(free_spawner)
	end
end

LuggableSynchronizerExtension._spawn_all_luggables = function (self)
	local num_sockets = self:sockets_to_fill()
	local spawners = self._spawners
	local num_spawners = #spawners
	local num_luggables = math.min(num_sockets, num_spawners)

	for i = 1, num_luggables do
		local random_free_spawner = self:_get_free_spawner()

		if random_free_spawner then
			self:spawn_luggable(random_free_spawner)
		end
	end
end

LuggableSynchronizerExtension._enable_sockets_visibility = function (self)
	local sockets = self._sockets

	for _, socket_unit in ipairs(sockets) do
		local socket_ext = ScriptUnit.extension(socket_unit, "luggable_socket_system")

		socket_ext:set_socket_visibility(true)
	end
end

LuggableSynchronizerExtension.set_carried_by = function (self, luggable_unit, player_unit_or_nil)
	if player_unit_or_nil then
		self._luggable_reset_timers[luggable_unit] = nil
	else
		local spawner_unit = nil

		for spawner, luggable in pairs(self._spawner_to_luggable) do
			if luggable_unit == luggable then
				spawner_unit = spawner

				break
			end
		end

		if spawner_unit then
			self._luggable_reset_timers[luggable_unit] = self._luggable_reset_timer
		end
	end
end

LuggableSynchronizerExtension.hide_all_luggables = function (self)
	local level_unit_id = Managers.state.unit_spawner:level_index(self._unit)
	local luggable_list = {}
	local ALIVE = ALIVE

	for _, luggable_unit in pairs(self._spawner_to_luggable) do
		if ALIVE[luggable_unit] then
			Unit.set_unit_visibility(luggable_unit, false, true)

			luggable_list[#luggable_list + 1] = Managers.state.unit_spawner:game_object_id(luggable_unit)
		end
	end

	for _, luggable_unit in pairs(self._socket_to_luggable) do
		if ALIVE[luggable_unit] then
			Unit.set_unit_visibility(luggable_unit, false, true)

			luggable_list[#luggable_list + 1] = Managers.state.unit_spawner:game_object_id(luggable_unit)
		end
	end

	Managers.state.game_session:send_rpc_clients("rpc_event_synchronizer_luggable_hide_luggable", level_unit_id, luggable_list)
end

LuggableSynchronizerExtension.hide_luggable = function (self, luggable_unit)
	Unit.set_unit_visibility(luggable_unit, false, true)
end

return LuggableSynchronizerExtension
