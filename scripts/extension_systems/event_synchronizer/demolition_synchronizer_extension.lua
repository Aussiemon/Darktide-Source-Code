-- chunkname: @scripts/extension_systems/event_synchronizer/demolition_synchronizer_extension.lua

local Component = require("scripts/utilities/component")
local DemolitionSynchronizerExtension = class("DemolitionSynchronizerExtension", "EventSynchronizerBaseExtension")

DemolitionSynchronizerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	DemolitionSynchronizerExtension.super.init(self, extension_init_context, unit, extension_init_data, ...)

	self._active_stage_unit_num = 0
	self._target_units = nil
	self._segment_trigger_unit = nil
	self._override_objective_markers = nil
	self._segment_units = nil
	self._total_segments = 1
	self._shuffle_segments = true
	self._lock_last_segment = true
	self._stage_order = nil
	self._stage_delay = nil
	self._segment_by_start_stage = nil
	self._stage_end_delay = 0
	self._segment_end_delay = 0
end

DemolitionSynchronizerExtension.setup_from_component = function (self, objective_name, total_segments, shuffle_segments, lock_last_segment, stage_end_delay, segment_end_delay, auto_start)
	self._objective_name = objective_name
	self._total_segments = total_segments
	self._shuffle_segments = shuffle_segments
	self._lock_last_segment = lock_last_segment
	self._stage_end_delay = stage_end_delay
	self._segment_end_delay = segment_end_delay
	self._auto_start = auto_start

	self._mission_objective_system:register_objective_synchronizer(objective_name, self._unit)
end

DemolitionSynchronizerExtension.hot_join_sync = function (self, sender, channel)
	if self._override_objective_markers then
		local level_unit_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_event_synchronizer_demolition_target_override", level_unit_id, true)
	end
end

DemolitionSynchronizerExtension._seperate_objective_units = function (self, units)
	local target_units = {}

	for i = 1, #units do
		local unit = units[i]
		local target_extension = ScriptUnit.has_extension(unit, "mission_objective_target_system")

		if target_extension then
			target_units[#target_units + 1] = unit
		end
	end

	return target_units
end

DemolitionSynchronizerExtension.register_connected_units = function (self, stage_units, registered_units, stage)
	stage_units = registered_units[self._stage_order[stage]]

	local target_units = self:_seperate_objective_units(stage_units)

	self._target_units = target_units
	self._active_stage_unit_num = #target_units

	local segment_stages = self._segment_by_start_stage[self._stage_order[stage]]

	if segment_stages then
		local unit_list = {}

		for i = 1, #segment_stages do
			table.append(unit_list, registered_units[segment_stages[i]])
		end

		self._segment_units = unit_list
		self._segment_trigger_unit = nil

		for i = 1, #unit_list do
			local trigger_unit = unit_list[i]

			if ScriptUnit.has_extension(trigger_unit, "trigger_system") then
				local corruptor_extension = ScriptUnit.has_extension(trigger_unit, "corruptor_system")

				if not corruptor_extension or corruptor_extension:use_trigger() then
					self._segment_trigger_unit = trigger_unit
				end
			end
		end

		if self._segment_trigger_unit and self._override_objective_markers then
			self._override_objective_markers[self._segment_trigger_unit] = true
		end
	end

	return target_units
end

DemolitionSynchronizerExtension.setup_stages = function (self, registered_units)
	local segments = {}
	local stage = #registered_units

	while stage >= 1 do
		if self:_stage_contains_corruptor(registered_units[stage]) then
			local p = stage

			while p > 1 and not self:_stage_contains_corruptor(registered_units[p - 1]) do
				p = p - 1
			end

			local length = stage - p + 1

			stage = stage - length

			local segment = {}

			for i = 1, length do
				segment[i] = stage + i
			end

			segments[#segments + 1] = segment
		else
			segments[#segments + 1] = {
				stage
			}
			stage = stage - 1
		end
	end

	local last_segment

	if self._lock_last_segment then
		last_segment = segments[1]

		table.swap_delete(segments, 1)
	end

	if self._shuffle_segments then
		table.shuffle(segments, self._setup_seed)
	end

	if last_segment then
		table.insert(segments, 1, last_segment)
	end

	local stage_order = {}
	local stage_delay = {}
	local segments_sorted = {}

	for s = math.min(#segments, self._total_segments), 1, -1 do
		local segment = segments[s]

		for i = 1, #segment do
			stage_order[#stage_order + 1] = segment[i]
			stage_delay[#stage_delay + 1] = self._stage_end_delay
		end

		stage_delay[#stage_delay] = self._segment_end_delay
		segments_sorted[segment[1]] = segments[s]
	end

	stage_delay[#stage_delay] = 0
	self._stage_order = stage_order
	self._stage_delay = stage_delay
	self._segment_by_start_stage = segments_sorted

	return #stage_order
end

DemolitionSynchronizerExtension._stage_contains_corruptor = function (self, stage_units)
	for i = 1, #stage_units do
		if ScriptUnit.has_extension(stage_units[i], "corruptor_system") then
			return true
		end
	end

	return false
end

DemolitionSynchronizerExtension.start_stage = function (self, stage)
	if self._segment_trigger_unit then
		Unit.flow_event(self._segment_trigger_unit, "lua_event_trigger_enabled")

		if self._is_server then
			self:set_override_objective_markers(true)
		end

		Unit.flow_event(self._unit, "lua_event_trigger_enabled")
	else
		self:activate_units()
	end
end

DemolitionSynchronizerExtension.finished_stage = function (self)
	if self._is_server then
		local target_units = self._target_units

		for i = 1, #target_units do
			local target_unit = target_units[i]

			Component.event(target_unit, "demolition_stage_finished")
		end
	end
end

DemolitionSynchronizerExtension.activate_units = function (self)
	self._override_objective_markers = nil

	if self._is_server then
		local level_unit_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_event_synchronizer_demolition_target_override", level_unit_id, false)

		local segment_units = self._segment_units

		if segment_units then
			for i = 1, #segment_units do
				local target_unit = segment_units[i]

				Component.event(target_unit, "demolition_segment_start")
			end

			self._segment_units = nil
		end

		local target_units = self._target_units

		for i = 1, #target_units do
			local target_unit = target_units[i]

			Component.event(target_unit, "demolition_stage_start")
			Component.event(target_unit, "destructible_enable", target_unit)
			Component.event(target_unit, "visibility_enable", target_unit)
		end
	end

	Unit.flow_event(self._unit, "lua_event_activate_units")
end

DemolitionSynchronizerExtension.override_objective_markers = function (self)
	return self._override_objective_markers
end

DemolitionSynchronizerExtension.set_override_objective_markers = function (self, override)
	if override then
		self._override_objective_markers = {}

		if self._segment_trigger_unit then
			self._override_objective_markers[self._segment_trigger_unit] = true
		end

		self._segment_trigger_unit = nil
	else
		self._override_objective_markers = nil
	end

	if self._is_server then
		local level_unit_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_event_synchronizer_demolition_target_override", level_unit_id, override)
	end
end

DemolitionSynchronizerExtension.active_objective = function (self)
	self._mission_objective_system:is_current_active_objective(self._objective_name)
end

DemolitionSynchronizerExtension.active_stage_unit_num = function (self)
	return self._active_stage_unit_num
end

DemolitionSynchronizerExtension.stage_end_delay = function (self, stage)
	return self._stage_delay[stage]
end

return DemolitionSynchronizerExtension
