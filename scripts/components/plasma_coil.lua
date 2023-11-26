-- chunkname: @scripts/components/plasma_coil.lua

local PlasmaCoil = component("PlasmaCoil")

PlasmaCoil.init = function (self, unit)
	self._coil_variable_name = self:get_data(unit, "coil_variable_name")
	self._coil_material_slot_name = self:get_data(unit, "coil_material_slot_name")
	self._overheat_percentage = nil

	self:enable(unit)
end

PlasmaCoil.editor_init = function (self, unit)
	self:init(unit)
end

PlasmaCoil.editor_validate = function (self, unit)
	return true, ""
end

PlasmaCoil.enable = function (self, unit)
	self:set_overheat(unit, 0)
end

PlasmaCoil.disable = function (self, unit)
	return
end

PlasmaCoil.destroy = function (self, unit)
	return
end

PlasmaCoil.set_overheat = function (self, unit, overheat_percentage)
	if self._overheat_percentage ~= overheat_percentage then
		Unit.set_scalar_for_material(unit, self._coil_material_slot_name, self._coil_variable_name, overheat_percentage)

		self._overheat_percentage = overheat_percentage
	end
end

PlasmaCoil.component_data = {
	coil_material_slot_name = {
		ui_type = "text_box",
		value = "",
		ui_name = "Material Slot Name"
	},
	coil_variable_name = {
		ui_type = "text_box",
		value = "external_overheat_glow",
		ui_name = "Material Variable Name"
	}
}

return PlasmaCoil
