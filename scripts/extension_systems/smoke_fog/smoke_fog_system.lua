local SmokeFogSystem = class("SmokeFogSystem", "ExtensionSystemBase")
local DELETE_AFTER_DURATION_TIMER = 8
local SMOKE_EFFECT_DURATION = 4

SmokeFogSystem.init = function (self, context, system_init_data, ...)
	SmokeFogSystem.super.init(self, context, system_init_data, ...)

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	self._broadphase = broadphase_system.broadphase
	self._unit_has_buff_list = {}
	self._unit_los_blocking_list = {}
	self._has_los_blocker = false
	self._stopped_particles_map = {}
end

SmokeFogSystem.hot_join_sync = function (self, sender, channel)
	return
end

SmokeFogSystem.destroy = function (self)
	return
end

SmokeFogSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = SmokeFogSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)

	if extension.has_buffs then
		self._unit_has_buff_list[#self._unit_has_buff_list + 1] = unit
	end

	if extension.block_line_of_sight then
		self._unit_los_blocking_list[#self._unit_los_blocking_list + 1] = unit
		self._has_los_blocker = true
	end

	return extension
end

SmokeFogSystem.on_remove_extension = function (self, removed_unit, extension_name)
	local unit_update_list = self._unit_has_buff_list

	for key, unit in pairs(unit_update_list) do
		if unit == removed_unit then
			table.remove(unit_update_list, key)

			break
		end
	end

	local unit_los_blocking_list = self._unit_los_blocking_list

	for key, unit in pairs(unit_los_blocking_list) do
		if unit == removed_unit then
			table.remove(unit_los_blocking_list, key)

			break
		end
	end

	self._has_los_blocker = #self._unit_los_blocking_list > 0

	SmokeFogSystem.super.on_remove_extension(self, removed_unit, extension_name)
end

SmokeFogSystem.get_extensions_by_owner_unit = function (self, owner_unit)
	local extensions = {}
	local unit_to_extension_map = self._unit_to_extension_map

	for _, extension in pairs(unit_to_extension_map) do
		if extension.owner_unit == owner_unit then
			extensions[#extensions + 1] = extension
		end
	end

	return extensions
end

SmokeFogSystem.update = function (self, context, dt, t, ...)
	local is_server = self._is_server
	local unit_to_extension_map = self._unit_to_extension_map
	local stopped_particles_map = self._stopped_particles_map

	for unit, extension in pairs(unit_to_extension_map) do
		local remaining_duration = extension:remaining_duration(t)
		local remaining_effect_duration = remaining_duration - SMOKE_EFFECT_DURATION

		if remaining_effect_duration <= 0 and not stopped_particles_map[unit] then
			Unit.flow_event(unit, "lua_stop_spawning_particles")
		elseif remaining_effect_duration > 0 and stopped_particles_map[unit] then
			Unit.flow_event(unit, "lua_start_spawning_particles")
		end

		if remaining_duration <= 0 and not extension.is_expired then
			stopped_particles_map[unit] = true
			extension.is_expired = true
		elseif remaining_duration > 0 and extension.is_expired then
			stopped_particles_map[unit] = nil
			extension.is_expired = false
		end

		if is_server and remaining_duration <= -DELETE_AFTER_DURATION_TIMER then
			Managers.state.unit_spawner:mark_for_deletion(unit)
		end
	end

	if is_server then
		self:_check_unit_collisions(t)
	end

	SmokeFogSystem.super.update(self, context, dt, t, ...)
end

local frame_count = 0
local frame_max = 5
local update_index = 1
local temp_check_units = {}

SmokeFogSystem._check_unit_collisions = function (self, t)
	local unit_to_extension_map = self._unit_to_extension_map
	frame_count = frame_count + 1

	if frame_max <= frame_count then
		frame_count = 0
		local num_unit_to_update = #self._unit_has_buff_list

		if num_unit_to_update == 0 then
			return
		end

		update_index = update_index + 1

		if num_unit_to_update < update_index then
			update_index = 1
		end

		local smoke_fog_unit = self._unit_has_buff_list[update_index]
		local extension = unit_to_extension_map[smoke_fog_unit]
		local broadphase = self._broadphase
		local side_names = extension.side_names
		local broadphase_center = Unit.local_position(smoke_fog_unit, 1)
		local broadphase_radius = 5

		table.clear_array(extension.broadphase_results, #extension.broadphase_results)

		extension.num_results = broadphase:query(broadphase_center, broadphase_radius, extension.broadphase_results, side_names)
	end

	for smoke_fog_unit, extension in pairs(unit_to_extension_map) do
		table.clear(temp_check_units)

		local units_inside = extension.units_inside

		for unit, _ in pairs(units_inside) do
			repeat
				temp_check_units[unit] = true

				if not HEALTH_ALIVE[unit] then
					units_inside[unit] = nil
				else
					local unit_pos = POSITION_LOOKUP[unit]
					local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
					local breed = unit_data_extension:breed()
					local unit_radius = (breed.player_locomotion_constrain_radius or 0.5) * 2

					if not extension:is_unit_inside(unit_pos, unit_radius) then
						extension:on_unit_exit(unit, t)

						units_inside[unit] = nil
					end
				end
			until true
		end

		for ii = 1, extension.num_results do
			local unit = extension.broadphase_results[ii]

			if not temp_check_units[unit] and HEALTH_ALIVE[unit] then
				local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
				local breed = unit_data_extension:breed()
				local unit_radius = breed.player_locomotion_constrain_radius * 2
				local unit_pos = POSITION_LOOKUP[unit]

				if not units_inside[unit] and extension:is_unit_inside(unit_pos, unit_radius) then
					extension:on_unit_enter(unit, t)

					units_inside[unit] = true
				end
			end
		end

		local valid_player_units = extension.side.valid_player_units

		for unit, _ in pairs(valid_player_units) do
			local unit_pos = POSITION_LOOKUP[unit]
			local unit_radius = 0.5

			if not temp_check_units[unit] and not units_inside[unit] and extension:is_unit_inside(unit_pos, unit_radius) then
				extension:on_unit_enter(unit, t)

				units_inside[unit] = true
			end
		end
	end
end

local Vector3_dot = Vector3 and Vector3.dot
local Vector3_distance_squared = Vector3 and Vector3.distance_squared
local Vector3_length_squared = Vector3 and Vector3.length_squared

SmokeFogSystem.check_fog_los = function (self, source_position, target_position, source_unit, count_standing_in_smoke)
	if not self._has_los_blocker then
		return false
	end

	local towards_target = target_position - source_position
	local unit_to_extension_map = self._unit_to_extension_map

	for smoke_fog_unit, fog_extension in pairs(unit_to_extension_map) do
		repeat
			if fog_extension.is_expired then
				break
			end

			local smoke_fog_position = POSITION_LOOKUP[smoke_fog_unit]
			local fog_radius_squared = fog_extension.inner_radius_squared
			local closest_point_to_fog = nil
			local towards_smoke_fog = smoke_fog_position - source_position
			local distance_to_smoke_fog_squared = Vector3_length_squared(towards_smoke_fog)

			if distance_to_smoke_fog_squared < fog_radius_squared then
				if count_standing_in_smoke then
					return true
				end

				break
			end

			local dot1 = Vector3_dot(towards_smoke_fog, towards_target)

			if dot1 <= 0 then
				break
			end

			local dot2 = Vector3_dot(towards_target, towards_target)

			if dot2 <= dot1 then
				closest_point_to_fog = target_position
			else
				local t = dot1 / dot2
				closest_point_to_fog = source_position + t * towards_target
			end

			local distance_line_to_fog_squared = Vector3_distance_squared(closest_point_to_fog, smoke_fog_position)

			if distance_line_to_fog_squared < fog_radius_squared then
				return true
			end
		until true
	end

	return false
end

return SmokeFogSystem
