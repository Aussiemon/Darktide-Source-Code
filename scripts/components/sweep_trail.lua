local SweepTrail = component("SweepTrail")

SweepTrail.init = function (self, unit)
	self._critical_strike_variable_name = self:get_data(unit, "critical_strike_variable_name")
	self._powered_variable_name = self:get_data(unit, "powered_variable_name")
	self._critical_material_slot_names = {}
	local critical_material_slot_names = self:get_data(unit, "critical_material_slot_name")

	if critical_material_slot_names then
		for index, array_data in ipairs(critical_material_slot_names) do
			self._critical_material_slot_names[#self._critical_material_slot_names + 1] = array_data.slot_name
		end
	end

	self._is_powered = self:get_data(unit, "powered")
	self._powered_material_slot_names = {}
	local powered_material_slot_name = self:get_data(unit, "powered_material_slot_name")

	if powered_material_slot_name then
		for index, array_data in ipairs(powered_material_slot_name) do
			self._powered_material_slot_names[#self._powered_material_slot_names + 1] = array_data.slot_name
		end
	end

	self:enable(unit)
end

SweepTrail.editor_init = function (self, unit)
	self._in_editor = true

	self:init(unit)
end

SweepTrail.enable = function (self, unit)
	self:set_critical_strike(unit, false)
	self:set_powered(unit, false)
end

SweepTrail.disable = function (self, unit)
	return
end

SweepTrail.destroy = function (self, unit)
	return
end

SweepTrail.set_critical_strike = function (self, unit, is_enabled, in_3p)
	if self._critical_strike_trail_enabled ~= is_enabled then
		local critical_strike_variable_name = self._critical_strike_variable_name
		local critical_material_slot_names = self._critical_material_slot_names
		local value = is_enabled and (in_3p and 0.2 or 1) or 0

		for i = 1, #critical_material_slot_names do
			local material_slot_name = critical_material_slot_names[i]

			Unit.set_scalar_for_material(unit, material_slot_name, critical_strike_variable_name, value)
		end

		self._critical_strike_trail_enabled = is_enabled
	end
end

SweepTrail.set_powered = function (self, unit, is_enabled)
	if not self._is_powered then
		return
	end

	if self._powered_trail_enabled ~= is_enabled then
		local powered_variable_name = self._powered_variable_name
		local powered_material_slot_names = self._powered_material_slot_names
		local value = is_enabled and 1 or 0

		for i = 1, #powered_material_slot_names do
			local material_slot_name = powered_material_slot_names[i]

			Unit.set_scalar_for_material(unit, material_slot_name, powered_variable_name, value)
		end

		self._powered_trail_enabled = is_enabled
	end
end

SweepTrail.component_data = {
	critical_strike_variable_name = {
		ui_type = "text_box",
		value = "",
		ui_name = "Critical Variable"
	},
	powered_variable_name = {
		ui_type = "text_box",
		value = "",
		ui_name = "Powered Variable"
	},
	critical_material_slot_name = {
		ui_type = "struct_array",
		ui_name = "Critical Material Slot Name",
		definition = {
			slot_name = {
				ui_type = "text_box",
				value = "",
				ui_name = "Slot Name"
			}
		},
		control_order = {
			"slot_name"
		}
	},
	powered_material_slot_name = {
		ui_type = "struct_array",
		ui_name = "Powered Material Slot Name",
		definition = {
			slot_name = {
				ui_type = "text_box",
				value = "",
				ui_name = "Slot Name"
			}
		},
		control_order = {
			"slot_name"
		}
	},
	powered = {
		ui_type = "check_box",
		value = false,
		ui_name = "Powered"
	}
}

return SweepTrail
