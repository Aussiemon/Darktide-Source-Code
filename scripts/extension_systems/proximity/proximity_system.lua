-- chunkname: @scripts/extension_systems/proximity/proximity_system.lua

local ProximitySystem = class("ProximitySystem", "ExtensionSystemBase")

ProximitySystem.init = function (self, ...)
	self._owner_unit_lut = {}

	return ProximitySystem.super.init(self, ...)
end

ProximitySystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local owner_unit_or_nil = extension_init_data.owner_unit_or_nil

	if owner_unit_or_nil then
		local lut = self._owner_unit_lut

		lut[unit] = owner_unit_or_nil

		local by_owner = lut[owner_unit_or_nil] or {}

		by_owner[#by_owner + 1] = unit
		lut[owner_unit_or_nil] = by_owner
	end

	return ProximitySystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)
end

ProximitySystem.on_remove_extension = function (self, unit, extension_name)
	local owner_unit = self._owner_unit_lut[unit]

	if owner_unit then
		local lut = self._owner_unit_lut

		lut[unit] = nil

		local by_owner = lut[owner_unit]
		local idx = table.index_of(by_owner, unit)

		table.swap_delete(by_owner, idx)

		if not next(by_owner) then
			lut[owner_unit] = nil
		end
	end

	return ProximitySystem.super.on_remove_extension(self, unit, extension_name)
end

ProximitySystem.owner_by_proximity_unit = function (self, proximity_unit)
	return self._owner_unit_lut[proximity_unit]
end

ProximitySystem.proximity_units_by_owner = function (self, owner_unit)
	return self._owner_unit_lut[owner_unit]
end

return ProximitySystem
