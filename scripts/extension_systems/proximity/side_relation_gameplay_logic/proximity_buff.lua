-- chunkname: @scripts/extension_systems/proximity/side_relation_gameplay_logic/proximity_buff.lua

local JobInterface = require("scripts/managers/unit_job/job_interface")
local ProximityBuff = class("ProximityBuff")

ProximityBuff.init = function (self, logic_context, init_data, owner_unit_or_nil)
	local unit = logic_context.unit

	self._unit = unit
	self._owner_unit_or_nil = owner_unit_or_nil
	self._units_in_proximity = {}

	local settings = init_data

	self._buff_to_add = settings.buff_to_add
	self._start_time = nil
	self._current_t = nil
	self._life_time = settings.life_time or math.huge
end

ProximityBuff.destroy = function (self)
	local units_in_proximity = self._units_in_proximity

	for unit in pairs(units_in_proximity) do
		self:_remove_buff_from_unit(unit)
	end
end

ProximityBuff.unit_entered_proximity = function (self, t, unit)
	self._units_in_proximity[unit] = {}

	self:_add_buff_to_unit(t, unit)
end

ProximityBuff.unit_left_proximity = function (self, t, unit)
	self:_remove_buff_from_unit(unit)
end

ProximityBuff.unit_in_proximity_deleted = function (self, unit)
	self._units_in_proximity[unit] = nil
end

ProximityBuff.update = function (self, dt, t)
	self._current_t = t
end

ProximityBuff.start_job = function (self, is_job)
	if self:is_job_completed() or self:is_job_canceled() then
		return
	end

	local t = Managers.time:time("gameplay")

	self._start_time = t
	self._current_t = t
	self._started = true

	local units_in_proximity = self._units_in_proximity

	for unit in pairs(units_in_proximity) do
		self:_add_buff_to_unit(t, unit)
	end
end

ProximityBuff.is_job_completed = function (self)
	if not self._started then
		return false
	end

	local life_span = self._current_t - self._start_time

	return life_span >= self._life_time
end

ProximityBuff.cancel_job = function (self)
	self._is_canceled = true
end

ProximityBuff.is_job_canceled = function (self)
	return not not self._is_canceled
end

ProximityBuff._add_buff_to_unit = function (self, t, unit)
	if not self._started then
		return
	end

	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if not buff_extension or not HEALTH_ALIVE[unit] then
		return
	end

	local _, index, component_index

	if self._buff_to_add then
		_, index, component_index = buff_extension:add_externally_controlled_buff(self._buff_to_add, t, "owner_unit", self._owner_unit_or_nil)
	end

	self._units_in_proximity[unit] = {
		buff_extension = buff_extension,
		local_index = index,
		component_index = component_index,
	}
end

ProximityBuff._remove_buff_from_unit = function (self, unit)
	if not self._started then
		self._units_in_proximity[unit] = nil

		return
	end

	local units_in_proximity = self._units_in_proximity
	local unit_settings = units_in_proximity[unit]

	if not unit_settings then
		return
	end

	if HEALTH_ALIVE[unit] then
		local index = unit_settings.local_index
		local buff_extension = unit_settings.buff_extension

		if index and buff_extension then
			local component_index = unit_settings.component_index

			buff_extension:remove_externally_controlled_buff(index, component_index)
		end
	end

	units_in_proximity[unit] = nil
end

implements(ProximityBuff, JobInterface)

return ProximityBuff
