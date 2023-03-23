local ChunkLodUnits = class("ChunkLodUnits")

ChunkLodUnits.init = function (self, level)
	self._units = {}
	self._level = level
	self._visible = true
end

ChunkLodUnits.register_unit = function (self, unit, callback_function)
	self._units[unit] = callback_function

	if not self._visible then
		callback_function(false)
	end
end

ChunkLodUnits.unregister_unit = function (self, unit)
	self._units[unit] = nil
end

ChunkLodUnits.set_visibility_state = function (self, is_visible)
	if self._visible ~= is_visible then
		for _, callback_function in pairs(self._units) do
			callback_function(is_visible)
		end

		self._visible = is_visible
	end
end

return ChunkLodUnits
