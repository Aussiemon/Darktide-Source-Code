-- chunkname: @scripts/components/networked_unique_randomize.lua

local Component = require("scripts/utilities/component")
local NetworkedUniqueRandomize = component("NetworkedUniqueRandomize")

NetworkedUniqueRandomize.init = function (self, unit, is_server)
	self:enable(unit)

	self._is_server = is_server
	self._unit = unit

	if is_server then
		self._min_rand = self:get_data(unit, "min_rand")
		self._max_rand = self:get_data(unit, "max_rand")
		self._queue_loop = self:get_data(unit, "queue_loop")
		self._pointer = 0
		self._rand_table = table.generate_random_table(self._min_rand, self._max_rand)

		self:reset()
	end
end

NetworkedUniqueRandomize.editor_init = function (self, unit)
	self:enable(unit)
end

NetworkedUniqueRandomize.editor_validate = function (self, unit)
	return true, ""
end

NetworkedUniqueRandomize.enable = function (self, unit)
	return
end

NetworkedUniqueRandomize.disable = function (self, unit)
	return
end

NetworkedUniqueRandomize.destroy = function (self, unit)
	return
end

NetworkedUniqueRandomize.get_next = function (self)
	if self._is_server then
		local index = self._pointer
		local result = 0

		if index == 0 then
			if self._queue_loop then
				self:reset()

				result = self._rand_table[self._pointer]
				self._pointer = self._pointer - 1
			end
		else
			result = self._rand_table[index]
			self._pointer = self._pointer - 1
		end

		local unit = self._unit

		Unit.set_flow_variable(unit, "lua_roll_output", result)
		Unit.flow_event(unit, "lua_rolled")
		Component.trigger_event_on_clients(self, "rpc_networked_unique_randomize_roll", "rpc_networked_unique_randomize_roll", result)
	else
		Log.info("NetworkedUniqueRandomize", "[get_next] Flow node effective on server only.")
	end
end

NetworkedUniqueRandomize.events.rpc_networked_unique_randomize_roll = function (self, result)
	local unit = self._unit

	Unit.set_flow_variable(unit, "lua_roll_output", result)
	Unit.flow_event(unit, "lua_rolled")
end

NetworkedUniqueRandomize.reset = function (self)
	if self._is_server then
		self._pointer = #self._rand_table
	else
		Log.info("NetworkedUniqueRandomize", "[reset] Flow node effective on server only.")
	end
end

NetworkedUniqueRandomize.new_table = function (self)
	if self._is_server then
		self._rand_table = table.generate_random_table(self._min_rand, self._max_rand)
	else
		Log.info("NetworkedUniqueRandomize", "[new_table] Flow node effective on server only.")
	end
end

NetworkedUniqueRandomize.component_data = {
	min_rand = {
		max = 18,
		min = 1,
		step = 1,
		ui_name = "Min Randomize",
		ui_type = "number",
		value = 1,
	},
	max_rand = {
		max = 18,
		min = 1,
		step = 1,
		ui_name = "Max Randomize",
		ui_type = "number",
		value = 18,
	},
	queue_loop = {
		ui_name = "Queue Loop",
		ui_type = "check_box",
		value = true,
	},
	inputs = {
		get_next = {
			accessibility = "public",
			type = "event",
		},
		reset = {
			accessibility = "public",
			type = "event",
		},
		new_table = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {},
}

return NetworkedUniqueRandomize
