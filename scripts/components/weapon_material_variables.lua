-- chunkname: @scripts/components/weapon_material_variables.lua

local WeaponMaterialVariables = component("WeaponMaterialVariables")

WeaponMaterialVariables.init = function (self, unit)
	self._material_variables = self:get_data(unit, "material_variables")
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

WeaponMaterialVariables.toggle_on_off = function (self, is_on, unit)
	local material_variables = self._material_variables

	for ii = 1, #material_variables do
		local material_variable = material_variables[ii]
		local material_slot_name = material_variable.material_slot_name
		local on_off_variable_name = material_variable.on_off_variable_name

		if on_off_variable_name then
			Unit.set_scalar_for_material(unit, material_slot_name, on_off_variable_name, is_on and 1 or 0)
		end
	end
end

WeaponMaterialVariables.set_start_time = function (self, t, unit)
	local material_variables = self._material_variables

	for ii = 1, #material_variables do
		local material_variable = material_variables[ii]
		local material_slot_name = material_variable.material_slot_name
		local on_off_variable_name = material_variable.on_off_variable_name
		local start_time_variable_name = material_variable.start_time_variable_name

		if on_off_variable_name then
			Unit.set_scalar_for_material(unit, material_slot_name, on_off_variable_name, 1)
		end

		if start_time_variable_name then
			Unit.set_scalar_for_material(unit, material_slot_name, start_time_variable_name, t)
		end
	end
end

WeaponMaterialVariables.set_stop_time = function (self, t, unit)
	local material_variables = self._material_variables

	for ii = 1, #material_variables do
		local material_variable = material_variables[ii]
		local material_slot_name = material_variable.material_slot_name
		local on_off_variable_name = material_variable.on_off_variable_name
		local stop_time_variable_name = material_variable.stop_time_variable_name

		if on_off_variable_name then
			Unit.set_scalar_for_material(unit, material_slot_name, on_off_variable_name, 0)
		end

		if stop_time_variable_name then
			Unit.set_scalar_for_material(unit, material_slot_name, stop_time_variable_name, t)
		end
	end
end

WeaponMaterialVariables.set_intensity = function (self, intensity, unit)
	local material_variables = self._material_variables

	for ii = 1, #material_variables do
		local material_variable = material_variables[ii]
		local material_slot_name = material_variable.material_slot_name
		local intensity_variable_name = material_variable.intensity_variable_name

		if intensity_variable_name then
			Unit.set_scalar_for_material(unit, material_slot_name, intensity_variable_name, intensity)
		end
	end
end

WeaponMaterialVariables.set_charge_level = function (self, charge_level, unit)
	local material_variables = self._material_variables

	for ii = 1, #material_variables do
		local material_variable = material_variables[ii]
		local material_slot_name = material_variable.material_slot_name
		local charge_level_variable_name = material_variable.charge_level_variable_name

		if charge_level_variable_name then
			Unit.set_scalar_for_material(unit, material_slot_name, charge_level_variable_name, charge_level)
		end
	end
end

WeaponMaterialVariables.toggle_direction = function (self, toggle_direction, unit)
	local material_variables = self._material_variables

	for ii = 1, #material_variables do
		local material_variable = material_variables[ii]
		local material_slot_name = material_variable.material_slot_name
		local direction_variable_name = material_variable.direction_variable_name

		if direction_variable_name then
			Unit.set_scalar_for_material(unit, material_slot_name, direction_variable_name, toggle_direction and 1 or 0)
		end
	end
end

WeaponMaterialVariables.set_stance_trigger = function (self, value, unit)
	local material_variables = self._material_variables

	for ii = 1, #material_variables do
		local material_variable = material_variables[ii]
		local material_slot_name = material_variable.material_slot_name
		local stance_trigger_variable_name = material_variable.stance_trigger_variable_name

		if stance_trigger_variable_name then
			Unit.set_scalar_for_material(unit, material_slot_name, stance_trigger_variable_name, value)
		end
	end
end

WeaponMaterialVariables.component_data = {
	material_variables = {
		ui_name = "Material Variables",
		ui_type = "struct_array",
		definition = {
			material_slot_name = {
				ui_name = "Material Slot Name",
				ui_type = "text_box",
				value = "",
			},
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
			charge_level_variable_name = {
				ui_name = "Charge Level Variable",
				ui_type = "text_box",
				value = "",
			},
			intensity_variable_name = {
				ui_name = "Intensity Variable",
				ui_type = "text_box",
				value = "",
			},
			direction_variable_name = {
				ui_name = "Direction Variable",
				ui_type = "text_box",
				value = "",
			},
			stance_trigger_variable_name = {
				ui_name = "Stance Trigger Variable",
				ui_type = "text_box",
				value = "",
			},
		},
		control_order = {
			"material_slot_name",
			"start_time_variable_name",
			"stop_time_variable_name",
			"on_off_variable_name",
			"charge_level_variable_name",
			"intensity_variable_name",
			"direction_variable_name",
			"stance_trigger_variable_name",
		},
	},
}

return WeaponMaterialVariables
