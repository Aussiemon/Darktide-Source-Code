local PlayerVisibilityExtension = class("PlayerVisibilityExtension")

PlayerVisibilityExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._is_visible = true
	self._has_snapshot = false
	self._was_visible = true
	self._unit = unit
	self._first_person_unit = nil
	local first_person_extension = ScriptUnit.has_extension(unit, "first_person_system")

	if first_person_extension then
		self._first_person_unit = first_person_extension:first_person_unit()
	end
end

PlayerVisibilityExtension.visible = function (self)
	return self._is_visible
end

PlayerVisibilityExtension.snapshot_stored = function (self)
	return self._has_snapshot
end

PlayerVisibilityExtension.hide = function (self)
	self:_restore_snapshot()

	local units = Unit.get_child_units(self._unit)

	Unit.take_visibility_snapshot(units)

	if self._first_person_unit then
		local first_person_units = Unit.get_child_units(self._first_person_unit)

		Unit.take_visibility_snapshot(first_person_units)
	end

	self._has_snapshot = true
	self._was_visible = self._is_visible
	self._is_visible = false

	Unit.set_unit_visibility(self._unit, false, true)

	if self._first_person_unit then
		Unit.set_unit_visibility(self._first_person_unit, false, true)
	end
end

PlayerVisibilityExtension.show = function (self)
	self:_restore_snapshot()

	self._is_visible = true

	Unit.set_unit_visibility(self._unit, true, false)
end

PlayerVisibilityExtension._restore_snapshot = function (self)
	if self._has_snapshot then
		self._is_visible = self._was_visible
		local units = Unit.get_child_units(self._unit)

		Unit.restore_visibility_snapshot(units)
		Unit.set_unit_visibility(self._unit, self._is_visible)

		if self._first_person_unit then
			local first_person_units = Unit.get_child_units(self._first_person_unit)

			Unit.restore_visibility_snapshot(first_person_units)
			Unit.set_unit_visibility(self._first_person_unit, self._is_visible)
		end

		self._has_snapshot = false
	end
end

PlayerVisibilityExtension.visibility_updated = function (self)
	if self._has_snapshot then
		self:hide()
	end
end

return PlayerVisibilityExtension
