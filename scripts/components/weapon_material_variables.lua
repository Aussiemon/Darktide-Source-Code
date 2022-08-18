local WeaponMaterialVariables = component("WeaponMaterialVariables")

WeaponMaterialVariables.init = function (self, unit)
	self._start_time_variable_name = self:get_data(unit, "start_time_variable_name")
	self._stop_time_variable_name = self:get_data(unit, "stop_time_variable_name")
	self._on_off_variable_name = self:get_data(unit, "on_off_variable_name")
	self._material_slot_name = self:get_data(unit, "material_slot_name")
end

WeaponMaterialVariables.enable = function (self, unit)
	return
end

WeaponMaterialVariables.disable = function (self, unit)
	return
end

WeaponMaterialVariables.destroy = function (self, unit)
	return
end

WeaponMaterialVariables.set_start_time = function (self, t, unit)
	Unit.set_scalar_for_material(unit, self._material_slot_name, self._start_time_variable_name, t)
	Unit.set_scalar_for_material(unit, self._material_slot_name, self._on_off_variable_name, 1)
end

WeaponMaterialVariables.set_stop_time = function (self, t, unit)
	Unit.set_scalar_for_material(unit, self._material_slot_name, self._stop_time_variable_name, t)
	Unit.set_scalar_for_material(unit, self._material_slot_name, self._on_off_variable_name, 0)
end

WeaponMaterialVariables.component_data = {
	start_time_variable_name = {
		ui_type = "text_box",
		value = "",
		ui_name = "Start Time Variable"
	},
	stop_time_variable_name = {
		ui_type = "text_box",
		value = "",
		ui_name = "Stop Time Variable"
	},
	on_off_variable_name = {
		ui_type = "text_box",
		value = "",
		ui_name = "On/Off Variable"
	},
	material_slot_name = {
		ui_type = "text_box",
		value = "",
		ui_name = "Material Slot Name"
	}
}

return WeaponMaterialVariables
