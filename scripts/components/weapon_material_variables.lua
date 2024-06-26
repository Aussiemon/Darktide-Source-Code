﻿-- chunkname: @scripts/components/weapon_material_variables.lua

local WeaponMaterialVariables = component("WeaponMaterialVariables")

WeaponMaterialVariables.init = function (self, unit)
	self._start_time_variable_name = self:get_data(unit, "start_time_variable_name")
	self._stop_time_variable_name = self:get_data(unit, "stop_time_variable_name")
	self._on_off_variable_name = self:get_data(unit, "on_off_variable_name")
	self._material_slot_name = self:get_data(unit, "material_slot_name")
	self._intensity_variable_names = self:get_data(unit, "intensity_variable_names")
end

WeaponMaterialVariables.editor_validate = function (self, unit)
	return true, ""
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

WeaponMaterialVariables.set_intensity = function (self, intensity, unit)
	local intensity_variable_names = self._intensity_variable_names
	local material_slot_name = self._material_slot_name

	for ii = 1, #intensity_variable_names do
		local variable_name = intensity_variable_names[ii].variable_name

		Unit.set_scalar_for_material(unit, material_slot_name, variable_name, intensity)
	end
end

WeaponMaterialVariables.component_data = {
	start_time_variable_name = {
		ui_name = "Start Time Variable",
		ui_type = "text_box",
		value = "",
	},
	stop_time_variable_name = {
		ui_name = "Stop Time Variable",
		ui_type = "text_box",
		value = "",
	},
	on_off_variable_name = {
		ui_name = "On/Off Variable",
		ui_type = "text_box",
		value = "",
	},
	material_slot_name = {
		ui_name = "Material Slot Name",
		ui_type = "text_box",
		value = "",
	},
	intensity_variable_names = {
		ui_name = "Intensity Variables",
		ui_type = "struct_array",
		definition = {
			variable_name = {
				ui_name = "Variable Name",
				ui_type = "text_box",
				value = "",
			},
		},
		control_order = {
			"variable_name",
		},
	},
}

return WeaponMaterialVariables
