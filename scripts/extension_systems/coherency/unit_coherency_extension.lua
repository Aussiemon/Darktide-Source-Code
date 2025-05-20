-- chunkname: @scripts/extension_systems/coherency/unit_coherency_extension.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local buff_keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local STAT_REPORT_TIME = 1
local UnitCoherencyExtension = class("UnitCoherencyExtension")

UnitCoherencyExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._player = extension_init_data.player
	self._unit = unit
	self._in_coherence_units = {}
	self._num_units_in_coherence = 0
	self._num_units_in_coherence_last_check = 0
	self._coherency_buff_indexes = {}
	self._free_external_buff_indexes = {}
	self._external_buff_template_names = {}
	self._valid_buff_owners = {}
	self.side = ScriptUnit.extension(unit, "side_system").side
	self._buff_extension = ScriptUnit.has_extension(self._unit, "buff_system")
	self._fx_extension = ScriptUnit.has_extension(self._unit, "fx_system")
	self._coherency_settings = extension_init_data.coherency_settings
	self._stat_record_timer = 0
end

UnitCoherencyExtension.destroy = function (self)
	self._in_coherence_units = {}
	self._num_units_in_coherence = 0
	self._coherency_buff_indexes = {}
	self._buff_extension = nil
	self._fx_extension = nil
end

UnitCoherencyExtension.fixed_update = function (self, unit, dt, t)
	local player = self._player

	if Managers.stats and player then
		local new_time = self._stat_record_timer + dt

		if new_time >= STAT_REPORT_TIME then
			Managers.stats:record_private("hook_coherency_update", player, new_time, self._num_units_in_coherence)

			new_time = 0
		end

		self._stat_record_timer = new_time
	end
end

UnitCoherencyExtension.in_coherence_units = function (self)
	return self._in_coherence_units
end

UnitCoherencyExtension.is_unit_in_coherency = function (self, unit_to_check)
	return self._in_coherence_units[unit_to_check]
end

UnitCoherencyExtension.num_units_in_coherency = function (self)
	return self._num_units_in_coherence
end

UnitCoherencyExtension._get_valid_buff_owners = function (self, buff_id)
	table.clear(self._valid_buff_owners)

	for coherency_unit, _ in pairs(self._in_coherence_units) do
		local talent_extension = ScriptUnit.has_extension(coherency_unit, "talent_system")

		if talent_extension then
			local player_current_talents = talent_extension:talents()

			if player_current_talents[buff_id] then
				local player = Managers.state.player_unit_spawn:owner(coherency_unit)

				table.insert(self._valid_buff_owners, player)
			end
		end
	end

	return self._valid_buff_owners
end

UnitCoherencyExtension.evaluate_and_send_achievement_data = function (self, buff_id, hook_name, optional_data)
	local current_num_in_coherency = self:num_units_in_coherency()
	local valid_player_units = self:_get_valid_buff_owners(buff_id)

	for _, current_player in pairs(valid_player_units) do
		Managers.stats:record_private(hook_name, current_player, optional_data)
	end

	return current_num_in_coherency
end

UnitCoherencyExtension.add_external_buff = function (self, buff_name)
	local free_external_buff_indexes = self._free_external_buff_indexes
	local index
	local num_free_external_buff_indexes = #free_external_buff_indexes

	if num_free_external_buff_indexes == 0 then
		index = 1
	else
		for i = 1, num_free_external_buff_indexes do
			local is_free = free_external_buff_indexes[i]

			if is_free == true then
				index = i

				break
			end
		end
	end

	index = index or num_free_external_buff_indexes + 1
	self._free_external_buff_indexes[index] = false
	self._external_buff_template_names[index] = buff_name

	return index
end

UnitCoherencyExtension.remove_external_buff = function (self, index)
	self._free_external_buff_indexes[index] = true
	self._external_buff_template_names[index] = nil
end

UnitCoherencyExtension.coherency_data = function (self)
	return self._coherency_data
end

UnitCoherencyExtension.coherency_settings = function (self)
	local radius, limit = self:current_radius()
	local stickiness_time = self:current_stickiness_time()

	return radius, limit, stickiness_time
end

UnitCoherencyExtension.buff_template_names = function (self)
	return self._coherency_settings.buff_template_names
end

UnitCoherencyExtension.external_buff_template_names = function (self)
	return self._external_buff_template_names
end

UnitCoherencyExtension.base_radius = function (self)
	return self._coherency_settings.radius, self._coherency_settings.stickiness_limit
end

UnitCoherencyExtension.current_radius = function (self)
	local modifier = 1

	if self._buff_extension then
		local buffs = self._buff_extension:stat_buffs()
		local buff_modifier = buffs.coherency_radius_modifier or 1
		local buff_multiplier = buffs.coherency_radius_multiplier or 1

		modifier = buff_modifier * buff_multiplier
	end

	local radius, stickiness_limit = self:base_radius()

	radius = radius * modifier

	if self._buff_extension then
		local no_stickiness_limit = self._buff_extension:has_keyword(buff_keywords.no_coherency_stickiness_limit)

		if no_stickiness_limit then
			stickiness_limit = nil
		end
	end

	stickiness_limit = stickiness_limit and stickiness_limit * modifier or nil

	return radius, stickiness_limit
end

UnitCoherencyExtension.current_stickiness_time = function (self)
	local stickiness_time = self._coherency_settings.stickiness_time

	if self._buff_extension then
		local buffs = self._buff_extension:stat_buffs()
		local stickiness_time_value = buffs.coherency_stickiness_time_value or 0

		stickiness_time = stickiness_time + stickiness_time_value
	end

	return stickiness_time
end

UnitCoherencyExtension.hot_join_sync = function (self, unit, sender, channel_id)
	local unit_spawner_manager = Managers.state.unit_spawner
	local unit_id = unit_spawner_manager:game_object_id(unit)

	for coherence_unit, _ in pairs(self._in_coherence_units) do
		local coherence_unit_go_id = unit_spawner_manager:game_object_id(coherence_unit)

		RPC.rpc_player_unit_enter_coherency(channel_id, unit_id, coherence_unit_go_id)
	end
end

UnitCoherencyExtension.on_coherency_enter = function (self, coherency_unit, coherency_extension, t)
	self._in_coherence_units[coherency_unit] = coherency_extension

	local prev_num_units_in_coherency = self._num_units_in_coherence

	self._num_units_in_coherence = prev_num_units_in_coherency + 1

	if prev_num_units_in_coherency == 1 and self._fx_extension then
		self._fx_extension:spawn_exclusive_particle("content/fx/particles/screenspace/screen_coherence_enter", Vector3(0, 0, 1))
		self._fx_extension:trigger_exclusive_wwise_event("wwise/events/ui/play_hud_coherency_on")
	end

	self:update_active_buffs(t)

	local buff_extension = self._buff_extension
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.enter_unit = coherency_unit
		param_table.number_of_unit_in_coherency = self._num_units_in_coherence

		buff_extension:add_proc_event(proc_events.on_coherency_enter, param_table)
	end

	self:_send_rpc("rpc_player_unit_enter_coherency", coherency_unit)
end

UnitCoherencyExtension.on_coherency_exit = function (self, coherency_unit, coherency_extension, t)
	self._num_units_in_coherence = self._num_units_in_coherence - 1
	self._in_coherence_units[coherency_unit] = nil

	if self._num_units_in_coherence == 0 and self._fx_extension then
		self._fx_extension:trigger_exclusive_wwise_event("wwise/events/ui/play_hud_coherency_off")
	end

	self:update_active_buffs(t)

	local buff_extension = self._buff_extension
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.exit_unit = coherency_unit
		param_table.number_of_unit_in_coherency = self._num_units_in_coherence

		buff_extension:add_proc_event(proc_events.on_coherency_exit, param_table)
	end

	self:_send_rpc("rpc_player_unit_exit_coherency", coherency_unit)
end

UnitCoherencyExtension.update_buffs_for_unit = function (self, unit, extension)
	local t = Managers.time:time("gameplay")

	self:update_active_buffs(t)
end

local function _add_buff_to_lists(buff_name, should_be_active_buffs, unique_coherency_buffs)
	local buff_template = BuffTemplates[buff_name]
	local coherency_id = buff_template.coherency_id

	if not coherency_id then
		local stack_number = should_be_active_buffs[buff_name] or 0

		should_be_active_buffs[buff_name] = stack_number + 1
	else
		local coherency_priority = buff_template.coherency_priority or math.huge
		local current_hightest_name = unique_coherency_buffs[coherency_id]
		local current_hightest_buff = current_hightest_name and BuffTemplates[current_hightest_name]
		local current_hightest_priority = current_hightest_buff and current_hightest_buff.coherency_priority or math.huge

		if coherency_priority < current_hightest_priority then
			unique_coherency_buffs[coherency_id] = buff_name
		end
	end
end

local should_be_active_buffs = {}
local unique_coherency_buffs = {}

UnitCoherencyExtension._calculate_should_be_active_buffs = function (self, t)
	local in_coherence_units = self._in_coherence_units

	table.clear(should_be_active_buffs)
	table.clear(unique_coherency_buffs)

	for _, coherency_extension in pairs(in_coherence_units) do
		local inherent_buffs = coherency_extension:buff_template_names()
		local external_buffs = coherency_extension:external_buff_template_names()

		for _, buff_name in pairs(inherent_buffs) do
			_add_buff_to_lists(buff_name, should_be_active_buffs, unique_coherency_buffs)
		end

		for _, buff_name in pairs(external_buffs) do
			_add_buff_to_lists(buff_name, should_be_active_buffs, unique_coherency_buffs)
		end
	end

	for _, buff_name in pairs(unique_coherency_buffs) do
		should_be_active_buffs[buff_name] = 1
	end

	return should_be_active_buffs
end

UnitCoherencyExtension.update_active_buffs = function (self, t)
	local should_be_active_buffs = self:_calculate_should_be_active_buffs(t)
	local coherency_buff_indexes = self._coherency_buff_indexes

	for buff_name, buff_indices in pairs(coherency_buff_indexes) do
		local number_that_should_be_active = should_be_active_buffs[buff_name] or 0
		local current_number = #buff_indices

		if current_number < number_that_should_be_active then
			local _, local_index, component_index = self._buff_extension:add_externally_controlled_buff(buff_name, t)
			local indices = {
				local_index = local_index,
				component_index = component_index,
			}

			table.insert(buff_indices, indices)
		elseif number_that_should_be_active < current_number then
			for i = current_number, number_that_should_be_active + 1, -1 do
				local indices = buff_indices[i]
				local local_index = indices.local_index
				local component_index = indices.component_index

				self._buff_extension:remove_externally_controlled_buff(local_index, component_index)

				buff_indices[i] = nil
			end
		end

		should_be_active_buffs[buff_name] = nil
	end

	for buff_name, number in pairs(should_be_active_buffs) do
		local buff_indices = coherency_buff_indexes[buff_name] or {}

		for i = 1, number do
			local _, local_index, component_index = self._buff_extension:add_externally_controlled_buff(buff_name, t)
			local indices = {
				local_index = local_index,
				component_index = component_index,
			}

			table.insert(buff_indices, indices)
		end

		coherency_buff_indexes[buff_name] = buff_indices
	end
end

UnitCoherencyExtension._send_rpc = function (self, rpc_name, other_unit)
	local my_game_object_id = Managers.state.unit_spawner:game_object_id(self._unit)
	local other_game_object_id = Managers.state.unit_spawner:game_object_id(other_unit)

	Managers.state.game_session:send_rpc_clients(rpc_name, my_game_object_id, other_game_object_id)
end

return UnitCoherencyExtension
