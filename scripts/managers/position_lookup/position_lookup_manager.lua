-- chunkname: @scripts/managers/position_lookup/position_lookup_manager.lua

local unit_alive = Unit.alive
local unit_world_position = Unit.world_position
local position_lookup_register_unit = PositionLookup.register_unit
local PositionLookupManager = class("PositionLookupManager")
local UNIT_STATE_PEDNING_REGISTRATION = 1
local UNIT_STATE_REGISTERED = 2
local DEFAULT_NUM_KEYS = 1024
local temp_pos_lookup = Script.new_map(512)

PositionLookupManager.init = function (self, optional_num_keys)
	local num_keys = optional_num_keys or DEFAULT_NUM_KEYS
	local position_lookup_system = PositionLookup.init()

	self._position_lookup_system = position_lookup_system

	local unit_state_lookup = Script.new_map(num_keys)

	self._unit_state_lookup = unit_state_lookup
	self._position_lookup = setmetatable(Script.new_map(num_keys), {
		__index = function (t, unit)
			local state = unit_state_lookup[unit]

			if state then
				if state == UNIT_STATE_PEDNING_REGISTRATION then
					position_lookup_register_unit(position_lookup_system, unit)

					unit_state_lookup[unit] = UNIT_STATE_REGISTERED
				end

				return temp_pos_lookup[unit] or unit_world_position(unit, 1)
			end

			return nil
		end
	})

	rawset(_G, "POSITION_LOOKUP", self._position_lookup)
	rawset(_G, "ALIVE", unit_state_lookup)
end

PositionLookupManager.destroy = function (self)
	ALIVE = nil
	POSITION_LOOKUP = nil

	PositionLookup.destroy(self._position_lookup_system)
end

PositionLookupManager.register = function (self, unit, position)
	temp_pos_lookup[unit] = position
	self._unit_state_lookup[unit] = self._unit_state_lookup[unit] or UNIT_STATE_PEDNING_REGISTRATION
end

PositionLookupManager.unregister = function (self, unit)
	if self._unit_state_lookup[unit] == UNIT_STATE_REGISTERED then
		PositionLookup.unregister_unit(self._position_lookup_system, unit)

		self._position_lookup[unit] = nil
	end

	temp_pos_lookup[unit] = nil
	self._unit_state_lookup[unit] = nil
end

PositionLookupManager.pre_update = function (self)
	local position_lookup = self._position_lookup

	table.clear(temp_pos_lookup)
	table.clear(position_lookup)
	PositionLookup.update(self._position_lookup_system, position_lookup)
end

PositionLookupManager.post_update = function (self)
	return
end

return PositionLookupManager
