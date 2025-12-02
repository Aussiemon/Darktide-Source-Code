-- chunkname: @scripts/components/weapon_special_display.lua

local WeaponSpecialDisplay = component("WeaponSpecialDisplay")

WeaponSpecialDisplay.editor_init = function (self, unit)
	self._material_slot_name = self:get_data(unit, "material_slot_name")
	self._material_variable_name = self:get_data(unit, "material_variable_name")

	self:enable(unit)
end

WeaponSpecialDisplay.editor_validate = function (self, unit)
	return true, ""
end

WeaponSpecialDisplay.init = function (self, unit)
	self._material_slot_name = self:get_data(unit, "material_slot_name")
	self._material_variable_name = self:get_data(unit, "material_variable_name")
	self._material_update_delay = self:get_data(unit, "material_update_delay")
	self._update_material_values_t = nil
	self._is_special_active = false

	self:enable(unit)

	return true
end

WeaponSpecialDisplay.enable = function (self, unit)
	self:_update_material_values(unit, 0, false)
end

WeaponSpecialDisplay.disable = function (self, unit)
	return
end

WeaponSpecialDisplay.destroy = function (self, unit)
	return
end

WeaponSpecialDisplay.set_special_active = function (self, unit, is_special_active, t, optional_skip_delay)
	self._is_special_active = is_special_active

	if optional_skip_delay or self._material_update_delay <= 0 then
		self:_update_material_values(unit, is_special_active)

		self._update_material_values_t = nil
	else
		self._update_material_values_t = t + self._material_update_delay
	end
end

WeaponSpecialDisplay.update = function (self, unit, dt, t)
	if self._update_material_values_t and t >= self._update_material_values_t then
		self:_update_material_values(unit, self._is_special_active)

		self._update_material_values_t = nil
	end

	return true
end

WeaponSpecialDisplay._update_material_values = function (self, unit, is_special_active)
	local material_slot_name = self._material_slot_name
	local material_variable_name = self._material_variable_name

	Unit.set_scalar_for_material(unit, material_slot_name, material_variable_name, is_special_active and 1 or 0)
end

WeaponSpecialDisplay.component_data = {
	material_slot_name = {
		ui_name = "Material Slot Name",
		ui_type = "text_box",
		value = "display_01",
	},
	material_variable_name = {
		ui_name = "Material Variable Name (Scalar)",
		ui_type = "text_box",
		value = "is_special_active",
	},
	material_update_delay = {
		decimals = 2,
		ui_name = "Material Update Delay",
		ui_type = "number",
		value = 0,
	},
}

return WeaponSpecialDisplay
