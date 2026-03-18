-- chunkname: @scripts/components/expedition_opportunity_counter.lua

local ExpeditionOpportunityCounter = component("ExpeditionOpportunityCounter")

ExpeditionOpportunityCounter.init = function (self, unit, is_server, nav_world)
	self._is_server = is_server

	if not is_server then
		return
	end

	self._unit = unit
	self._alive_units = {}
	self._num_alive_units = 0
	self._max_units = 0
	self._amount_destroyed = 0

	local trigger_points = self:get_data(unit, "trigger_points")

	self._trigger_points = {}

	for i = 1, #trigger_points do
		local value = tonumber(trigger_points[i])

		self._trigger_points[#self._trigger_points + 1] = {
			triggered = false,
			value = value,
		}
	end

	local run_update = true

	return run_update
end

ExpeditionOpportunityCounter.update = function (self, unit, dt, t)
	local is_server = self._is_server

	if not is_server then
		return
	end

	if not self._first_unit_initalized then
		return true
	end

	if self._num_alive_units == 0 then
		return true
	end

	local alive_units = self._alive_units

	for i, alive_unit in ripairs(alive_units) do
		if not HEALTH_ALIVE[alive_unit] then
			self._amount_destroyed = self._amount_destroyed + 1
			self._num_alive_units = self._num_alive_units - 1

			table.swap_delete(alive_units, i)
		end
	end

	local should_update = false
	local trigger_points = self._trigger_points

	for i = 1, #trigger_points do
		local trigger_threshold = 0
		local trigger_point_data = trigger_points[i]
		local trigger_point_value = trigger_point_data.value

		if trigger_point_value then
			trigger_threshold = trigger_point_value
		elseif not trigger_point_value then
			trigger_threshold = self._max_units
		end

		if self._amount_destroyed == trigger_threshold and not trigger_point_data.triggered then
			trigger_point_data.triggered = true

			self:_send_end_event()
		end

		if not trigger_point_data.triggered then
			should_update = true
		end
	end

	return should_update
end

ExpeditionOpportunityCounter._send_end_event = function (self)
	local is_server = self._is_server

	if not is_server then
		return
	end

	Unit.flow_event(self._unit, "event_counter_end")
end

ExpeditionOpportunityCounter.add_new_unit = function (self, unit)
	local is_server = self._is_server

	if not is_server then
		return
	end

	if not unit then
		return
	end

	self._num_alive_units = self._num_alive_units + 1
	self._max_units = self._max_units + 1
	self._alive_units[#self._alive_units + 1] = unit
	self._first_unit_initalized = true
end

ExpeditionOpportunityCounter.editor_init = function (self, unit)
	return
end

ExpeditionOpportunityCounter.editor_validate = function (self, unit)
	return true, ""
end

ExpeditionOpportunityCounter.enable = function (self, unit)
	return
end

ExpeditionOpportunityCounter.disable = function (self, unit)
	return
end

ExpeditionOpportunityCounter.destroy = function (self, unit)
	return
end

ExpeditionOpportunityCounter.component_data = {
	trigger_points = {
		category = "Trigger Points",
		size = 1,
		ui_name = "trigger points",
		ui_type = "text_box_array",
		values = {
			"",
		},
	},
}

return ExpeditionOpportunityCounter
