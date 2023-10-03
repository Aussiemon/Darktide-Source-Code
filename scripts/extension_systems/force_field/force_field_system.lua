require("scripts/extension_systems/force_field/force_field_extension")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local ForceFieldSystem = class("ForceFieldSystem", "ExtensionSystemBase")
local proc_events = BuffSettings.proc_events
local DELETE_AFTER_DURATION_TIMER = 2

ForceFieldSystem.init = function (self, context, system_init_data, ...)
	ForceFieldSystem.super.init(self, context, system_init_data, ...)

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	self._broadphase = broadphase_system.broadphase
	self._extension_data = {}
	self._unit_update_list = {}
end

ForceFieldSystem.destroy = function (self)
	return
end

ForceFieldSystem.update = function (self, context, dt, t, ...)
	ForceFieldSystem.super.update(self, context, dt, t, ...)

	if self._is_server then
		local unit_to_extension_map = self._unit_to_extension_map
		local extension_data = self._extension_data

		for unit, extension in pairs(unit_to_extension_map) do
			local unit_extension_data = extension_data[unit]
			local remove_t = unit_extension_data.remove_t

			if not remove_t then
				local owner_unit = extension.owner_unit
				local owner_is_dead = not HEALTH_ALIVE[owner_unit]
				local remaining_duration = extension:remaining_duration()
				local is_dead = extension:is_dead()

				if remaining_duration <= 0 or is_dead or owner_is_dead and not unit_extension_data.marked_for_deletion then
					if ALIVE[owner_unit] then
						local buff_extension = ScriptUnit.has_extension(owner_unit, "buff_system")

						if buff_extension then
							local param_table = extension.buff_extension:request_proc_event_param_table()

							if param_table then
								param_table.force_field_unit = unit

								buff_extension:add_proc_event(proc_events.on_force_field_death, param_table)
							end
						end
					end

					extension:on_death(t)

					extension.is_expired = true
					unit_extension_data.remove_t = t + DELETE_AFTER_DURATION_TIMER
				end
			elseif remove_t < t then
				unit_extension_data.marked_for_deletion = true

				Managers.state.unit_spawner:mark_for_deletion(unit)
			end
		end

		self:_check_unit_collisions(t)
	end
end

ForceFieldSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = ForceFieldSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)
	local extension_data = {
		marked_for_deletion = false,
		num_results = 0,
		units_inside = {},
		broadphase_results = {}
	}
	self._extension_data[unit] = extension_data
	extension.extension_data = extension_data
	self._unit_update_list[#self._unit_update_list + 1] = unit

	return extension
end

ForceFieldSystem.on_remove_extension = function (self, removed_unit, extension_name)
	if self._is_server then
		local unit_extension_data = self._extension_data[removed_unit]
		self._extension_data[removed_unit] = nil
		local extension = self._unit_to_extension_map[removed_unit]
		local units_inside = unit_extension_data.units_inside
		local valid_player_units = extension.side.valid_player_units
		local t = FixedFrame.get_latest_fixed_time()

		for unit, _ in pairs(valid_player_units) do
			if units_inside[unit] then
				extension:on_player_exit(unit, t)
			end
		end
	end

	self._extension_data[removed_unit] = nil
	local unit_update_list = self._unit_update_list

	for key, unit in pairs(unit_update_list) do
		if unit == removed_unit then
			table.remove(unit_update_list, key)

			break
		end
	end

	ForceFieldSystem.super.on_remove_extension(self, removed_unit, extension_name)
end

ForceFieldSystem.get_extension_by_owner_unit = function (self, owner_unit)
	local unit_to_extension_map = self._unit_to_extension_map

	for _, extension in pairs(unit_to_extension_map) do
		if extension.owner_unit == owner_unit then
			return extension
		end
	end
end

ForceFieldSystem.get_extensions_by_owner_unit = function (self, owner_unit)
	local extensions = {}
	local unit_to_extension_map = self._unit_to_extension_map

	for _, extension in pairs(unit_to_extension_map) do
		if extension.owner_unit == owner_unit then
			extensions[#extensions + 1] = extension
		end
	end

	return extensions
end

ForceFieldSystem.get_extensions_by_owner_unit_keyword = function (self, keyword)
	local extensions = {}
	local unit_to_extension_map = self._unit_to_extension_map

	for _, extension in pairs(unit_to_extension_map) do
		local buff_extension = extension.buff_extension

		if buff_extension:has_keyword(keyword) then
			extensions[#extensions + 1] = extension
		end
	end
end

local frame_count = 0
local frame_max = 5
local update_index = 1

ForceFieldSystem._check_unit_collisions = function (self, t)
	local unit_to_extension_map = self._unit_to_extension_map
	frame_count = frame_count + 1

	if frame_max <= frame_count then
		frame_count = 0
		local num_units_to_update = #self._unit_update_list

		if num_units_to_update == 0 then
			return
		end

		update_index = update_index + 1

		if num_units_to_update < update_index then
			update_index = 1
		end

		local force_field_unit = self._unit_update_list[update_index]
		local extension_data = self._extension_data[force_field_unit]
		local extension = unit_to_extension_map[force_field_unit]
		local broadphase = self._broadphase
		local enemy_side_names = extension.enemy_side_names
		local broadphase_center = Unit.local_position(force_field_unit, 1)
		local broadphase_radius = 5

		table.clear_array(extension_data.broadphase_results, #extension_data.broadphase_results)

		extension_data.num_results = broadphase:query(broadphase_center, broadphase_radius, extension_data.broadphase_results, enemy_side_names)
	end

	local extension_data = self._extension_data

	for force_field_unit, extension in pairs(unit_to_extension_map) do
		local unit_extension_data = extension_data[force_field_unit]
		local units_inside = unit_extension_data.units_inside
		local owner_unit = extension.owner_unit
		local is_owner_alive = ALIVE[owner_unit]
		local is_owner_health_alive = HEALTH_ALIVE[extension.owner_unit]
		local marked_for_deletion = unit_extension_data.marked_for_deletion

		if is_owner_alive and is_owner_health_alive and not marked_for_deletion then
			local buff_extension = extension.buff_extension

			for ii = 1, unit_extension_data.num_results do
				local unit = unit_extension_data.broadphase_results[ii]
				local unit_pos = POSITION_LOOKUP[unit]

				if ALIVE[unit] and HEALTH_ALIVE[unit] then
					local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
					local breed = unit_data_extension:breed()
					local unit_radius = breed.player_locomotion_constrain_radius * 2

					if buff_extension and extension:is_unit_colliding(unit_pos, unit_radius) then
						if not units_inside[unit] then
							local param_table = buff_extension:request_proc_event_param_table()

							if param_table then
								param_table.passing_unit = unit
								param_table.force_field_unit = force_field_unit
								param_table.force_field_owner_unit = extension.owner_unit
								param_table.is_player_unit = false

								buff_extension:add_proc_event(proc_events.on_unit_touch_force_field, param_table)
							end

							units_inside[unit] = true
						end
					elseif units_inside[unit] then
						units_inside[unit] = nil
					end
				end
			end

			local valid_player_units = extension.side.valid_player_units

			for unit, _ in pairs(valid_player_units) do
				local unit_pos = POSITION_LOOKUP[unit]
				local unit_radius = 0.5
				local is_colliding = extension:is_unit_colliding(unit_pos, unit_radius)

				if is_colliding and not units_inside[unit] then
					local param_table = buff_extension and buff_extension:request_proc_event_param_table()

					if param_table then
						param_table.passing_unit = unit
						param_table.force_field_unit = force_field_unit
						param_table.force_field_owner_unit = extension.owner_unit
						param_table.is_player_unit = true

						buff_extension:add_proc_event(proc_events.on_unit_touch_force_field, param_table)
					end

					units_inside[unit] = true

					extension:on_player_enter(unit, t)
				elseif not is_colliding and units_inside[unit] then
					units_inside[unit] = nil

					extension:on_player_exit(unit, t)
				end
			end
		else
			local valid_player_units = extension.side.valid_player_units

			for unit, _ in pairs(valid_player_units) do
				if units_inside[unit] then
					extension:on_player_exit(unit, t)
				end
			end
		end
	end
end

ForceFieldSystem.is_object_inside_force_field = function (self, position, radius, handle_height)
	radius = radius or 0.1
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		if extension:is_unit_colliding(position, radius, handle_height) then
			return true, unit, extension
		end
	end

	return false, nil, nil
end

ForceFieldSystem.hot_join_sync = function (self, sender, channel)
	return
end

return ForceFieldSystem
