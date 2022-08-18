local unit_alive = Unit.alive
local self = {
	total_time = 120,
	max_size = 8,
	trigger_time = 0,
	ids = {}
}

local function _test_movement_modifier(dt, t)
	local unit = Debug.selected_unit

	if not unit_alive(unit) then
		return
	end

	if self.current_unit ~= Debug.selected_unit then
		self.current_unit = Debug.selected_unit

		table.clear(self.ids)

		self.trigger_time = 0
		self.total_time = 120
		self.max_size = 8
	end

	local extension = ScriptUnit.extension(unit, "navigation_system")
	self.start_time = self.start_time or t
	local ids = self.ids

	if self.total_time < t - self.start_time then
		for _, id in ipairs(ids) do
			extension:remove_movement_modifier(id)
		end

		Log.debug("MinionNavigationExtension", "TEST COMPLETE")
		table.dump(extension._movement_modifiers, "modifiers", 2)
		Log.debug("MinionNavigationExtension", "num modifiers %i", extension._num_movement_modifiers)
		Log.debug("MinionNavigationExtension", "max size %i", extension._movement_modifier_table_size)
		Log.debug("MinionNavigationExtension", "last_movement_modifier_index %i", extension._last_movement_modifier_index)
	elseif self.trigger_time <= 0 then
		self.trigger_time = 0.1 + math.random() * 0.4

		for i = 1, math.random(1, 3), 1 do
			local num_ids = #ids
			local p = (self.max_size - num_ids) / self.max_size

			if math.random() < p then
				Log.debug("MinionNavigationExtension", "add")

				local id = extension:add_movement_modifier(0.5 + math.random())
				ids[num_ids + 1] = id
			else
				Log.debug("MinionNavigationExtension", "remove")

				local index = math.random(1, num_ids)

				extension:remove_movement_modifier(ids[index])
				table.remove(ids, index)
			end
		end
	else
		self.trigger_time = self.trigger_time - dt
	end
end

local function _init_and_run_tests(minion_navigation_object)
	minion_navigation_object.test_movement_modifier = _test_movement_modifier
end

return _init_and_run_tests
