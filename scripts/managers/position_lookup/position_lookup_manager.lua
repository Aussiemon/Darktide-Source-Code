local unit_alive = Unit.alive
local PositionLookupManager = class("PositionLookupManager")
local DEFAULT_NUM_KEYS = 4096

PositionLookupManager.init = function (self, optional_num_keys)
	Profiler.start("PositionLookup_init")

	local num_keys = optional_num_keys or DEFAULT_NUM_KEYS
	self._position_lookup_system = PositionLookup.init()
	self._position_lookup = Script.new_map(num_keys)

	rawset(_G, "POSITION_LOOKUP", self._position_lookup)
	rawset(_G, "ALIVE", self._position_lookup)
	Profiler.stop("PositionLookup_init")
end

PositionLookupManager.destroy = function (self)
	Profiler.start("PositionLookup_destroy")

	ALIVE = nil
	POSITION_LOOKUP = nil

	PositionLookup.destroy(self._position_lookup_system)
	Profiler.stop("PositionLookup_destroy")
end

PositionLookupManager.register = function (self, unit, position)
	Profiler.start("PositionLookup_register")
	PositionLookup.register_unit(self._position_lookup_system, unit)

	self._position_lookup[unit] = position

	Profiler.stop("PositionLookup_register")
end

PositionLookupManager.unregister = function (self, unit)
	Profiler.start("PositionLookup_unregister")

	self._position_lookup[unit] = nil

	PositionLookup.unregister_unit(self._position_lookup_system, unit)
	Profiler.stop("PositionLookup_unregister")
end

PositionLookupManager.pre_update = function (self)
	Profiler.start("PositionLookup_pre_update")

	local position_lookup = self._position_lookup

	table.clear(position_lookup)
	PositionLookup.update(self._position_lookup_system, position_lookup)
	Profiler.stop("PositionLookup_pre_update")
end

PositionLookupManager.post_update = function (self)
	Profiler.start("PositionLookup_post_update")
	Profiler.stop("PositionLookup_post_update")
end

return PositionLookupManager
