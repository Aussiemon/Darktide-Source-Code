local ForceFieldSystem = class("ForceFieldSystem", "ExtensionSystemBase")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSetting.special_rules
local CLIENT_RPCS = {}

ForceFieldSystem.init = function (self, context, system_init_data, ...)
	ForceFieldSystem.super.init(self, context, system_init_data, ...)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	self._broadphase = broadphase_system.broadphase
	self._extension_data = {}
	self._unit_update_list = {}
end

ForceFieldSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

ForceFieldSystem.update = function (self, context, dt, t, ...)
	ForceFieldSystem.super.update(self, context, dt, t, ...)

	if self._is_server then
		local unit_to_extension_map = self._unit_to_extension_map

		for unit, extension in pairs(unit_to_extension_map) do
			local remaining_duration = extension:remaining_duration()

			if remaining_duration <= 0 then
				Managers.state.unit_spawner:mark_for_deletion(unit)
			end
		end

		self:_check_unit_collisions()
	end
end

ForceFieldSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = ForceFieldSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)
	self._extension_data[unit] = {
		num_results = 0,
		units_inside = {},
		broadphase_results = {}
	}
	self._unit_update_list[#self._unit_update_list + 1] = unit
	local owner_unit = extension.owner_unit
	local specialization_extension = ScriptUnit.extension(owner_unit, "specialization_system")
	local should_remove_previous_shields = specialization_extension:has_special_rule(special_rules.psyker_protectorate_shield_lasts_indefinetely)

	if should_remove_previous_shields then
		local extensions = self:get_extensions_by_owner_unit(owner_unit)

		for i = 1, #extensions do
			local previous_extension = extensions[i]

			if previous_extension ~= extension then
				local previous_unit = previous_extension:force_field_unit()

				Managers.state.unit_spawner:mark_for_deletion(previous_unit)
			end
		end
	end

	return extension
end

ForceFieldSystem.on_remove_extension = function (self, removed_unit, extension_name)
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

ForceFieldSystem._check_unit_collisions = function (self)
	local unit_to_extension_map = self._unit_to_extension_map
	frame_count = frame_count + 1

	if frame_max <= frame_count then
		frame_count = 0
		local num_unit_to_update = #self._unit_update_list

		if num_unit_to_update == 0 then
			return
		end

		update_index = update_index + 1

		if num_unit_to_update < update_index then
			update_index = 1
		end

		local force_field_unit = self._unit_update_list[update_index]
		local extension_data = self._extension_data[force_field_unit]
		local extension = unit_to_extension_map[force_field_unit]
		local broadphase = self._broadphase
		local side_names = extension.side_names
		local broadphase_center = Unit.local_position(force_field_unit, 1)
		local broadphase_radius = 5

		table.clear_array(extension_data.broadphase_results, #extension_data.broadphase_results)

		extension_data.num_results = broadphase:query(broadphase_center, broadphase_radius, extension_data.broadphase_results, side_names)
	end

	for force_field_unit, extension in pairs(unit_to_extension_map) do
		local extension_data = self._extension_data[force_field_unit]
		local units_inside = extension_data.units_inside

		for i = 1, extension_data.num_results do
			local unit = extension_data.broadphase_results[i]
			local unit_pos = POSITION_LOOKUP[unit]

			if ALIVE[unit] and HEALTH_ALIVE[unit] then
				local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
				local breed = unit_data_extension:breed()
				local unit_radius = breed.player_locomotion_constrain_radius * 2
				local buff_extension = extension.buff_extension

				if extension:is_unit_inside(unit_pos, unit_radius) then
					if not units_inside[unit] then
						local param_table = extension.buff_extension:request_proc_event_param_table()
						param_table.passing_unit = unit
						param_table.force_field_unit = force_field_unit
						param_table.force_field_owner_unit = extension.owner_unit
						param_table.is_player_unit = false

						buff_extension:add_proc_event(proc_events.on_unit_enter_force_field, param_table)

						units_inside[unit] = true
					end
				elseif units_inside[unit] then
					local param_table = extension.buff_extension:request_proc_event_param_table()
					param_table.passing_unit = unit
					param_table.force_field_unit = force_field_unit
					param_table.force_field_owner_unit = extension.owner_unit
					param_table.is_player_unit = false

					buff_extension:add_proc_event(proc_events.on_unit_leave_force_field, param_table)

					units_inside[unit] = nil
				end
			end
		end

		local valid_player_units = extension.side.valid_player_units

		for unit, _ in pairs(valid_player_units) do
			local unit_pos = POSITION_LOOKUP[unit]
			local unit_radius = 0.5

			if extension:is_unit_inside(unit_pos, unit_radius) then
				if not units_inside[unit] then
					local buff_extension = extension.buff_extension
					local param_table = extension.buff_extension:request_proc_event_param_table()
					param_table.passing_unit = unit
					param_table.force_field_unit = force_field_unit
					param_table.force_field_owner_unit = extension.owner_unit
					param_table.is_player_unit = true

					buff_extension:add_proc_event(proc_events.on_unit_enter_force_field, param_table)

					units_inside[unit] = true
				end
			elseif units_inside[unit] then
				local buff_extension = extension.buff_extension
				local param_table = extension.buff_extension:request_proc_event_param_table()
				param_table.passing_unit = unit
				param_table.force_field_unit = force_field_unit
				param_table.force_field_owner_unit = extension.owner_unit
				param_table.is_player_unit = true

				buff_extension:add_proc_event(proc_events.on_unit_leave_force_field, param_table)

				units_inside[unit] = nil
			end
		end
	end
end

ForceFieldSystem.hot_join_sync = function (self, sender, channel)
	return
end

return ForceFieldSystem
