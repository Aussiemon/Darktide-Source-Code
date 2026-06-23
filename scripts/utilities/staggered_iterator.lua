-- chunkname: @scripts/utilities/staggered_iterator.lua

local StaggeredIterator = class("StaggeredIterator")
local Profiler_start, Profiler_stop = Profiler.start, Profiler.stop

StaggeredIterator.init = function (self, callback)
	self._callback = callback
	self._arrays = {}
	self._iteration_time_by_value = {}
	self._array_free_list = {}
	self._value_free_list = {}
	self._internal_t = 0
	self._pending_removal = {}
	self._pending_move = {}
end

StaggeredIterator.has_element = function (self, value)
	return self._iteration_time_by_value[value] ~= nil
end

StaggeredIterator.add_element = function (self, value, iteration_time)
	self._iteration_time_by_value[value] = iteration_time

	if iteration_time == math.huge then
		return
	end

	local array = self._arrays[iteration_time]

	if not array then
		local free_list = self._array_free_list

		array = free_list[#free_list]

		if array then
			array.size = 0
			array.last_index = 0
			array.budget = 0
		else
			array = {
				budget = 0,
				last_index = 0,
				size = 0,
			}
		end

		free_list[#free_list] = nil
		self._arrays[iteration_time] = array
	end

	local num_values = array.size + 1

	array.size = num_values

	local value_free_list = self._value_free_list
	local value_data = value_free_list[#value_free_list]

	if value_data then
		value_free_list[#value_free_list] = nil
		value_data.value = value
		value_data.last_tick_t = self._internal_t
		value_data.base_iteration_time = iteration_time
	else
		value_data = {
			value = value,
			last_tick_t = self._internal_t,
			base_iteration_time = iteration_time,
		}
	end

	array[num_values] = value_data
end

StaggeredIterator.remove_element = function (self, value)
	self._pending_move[value] = nil

	if self._iterating then
		self._pending_removal[value] = true

		return
	end

	local iteration_time_by_value = self._iteration_time_by_value
	local iteration_time = iteration_time_by_value[value]

	iteration_time_by_value[value] = nil

	if iteration_time == math.huge then
		return
	end

	local array = self._arrays[iteration_time]

	for i = 1, array.size do
		local value_data = array[i]

		if value_data.value == value then
			table.swap_delete(array, i)

			array.size = array.size - 1

			local value_free_list = self._value_free_list

			value_free_list[#value_free_list + 1] = value_data

			break
		end
	end

	if array.size == 0 then
		local array_free_list = self._array_free_list

		array_free_list[#array_free_list + 1] = array
		self._arrays[iteration_time] = nil
	end
end

StaggeredIterator.set_update_timer = function (self, value, update_timer)
	if self._iteration_time_by_value[value] == update_timer then
		return
	end

	if self._iterating then
		if self._pending_removal[value] then
			return
		end

		self._pending_move[value] = update_timer

		return
	end

	self:remove_element(value)
	self:add_element(value, update_timer)
end

StaggeredIterator.prioritize = function (self, value)
	self:set_update_timer(value, 0)
end

StaggeredIterator.iterate = function (self, dt, t, ...)
	local internal_t = self._internal_t + dt

	self._internal_t = internal_t
	self._iterating = true

	local pending_removal = self._pending_removal
	local pending_move = self._pending_move
	local callback = self._callback

	for iteration_time, array in pairs(self._arrays) do
		local iteration_cost = iteration_time / array.size
		local budget = array.budget + dt
		local index = array.last_index
		local first_element

		while iteration_cost < budget do
			index = index + 1

			if index > array.size then
				index = 1
			end

			local value_data = array[index]

			if value_data == first_element then
				index = index - 1

				break
			end

			first_element = first_element or value_data

			local value = value_data.value

			if not pending_removal[value] then
				local cumulative_dt = internal_t - value_data.last_tick_t
				local override_iteration_time = callback(value, cumulative_dt, t, ...) or value_data.base_iteration_time

				if override_iteration_time ~= iteration_time then
					pending_move[value] = override_iteration_time
				end
			end

			value_data.last_tick_t = internal_t
			budget = budget - iteration_cost
		end

		array.last_index = index
		array.budget = budget
	end

	self._iterating = false

	for value, iteration_time in pairs(pending_move) do
		self:set_update_timer(value, iteration_time)

		pending_move[value] = nil
	end

	for value in pairs(pending_removal) do
		self:remove_element(value)

		pending_removal[value] = nil
	end
end

return StaggeredIterator
