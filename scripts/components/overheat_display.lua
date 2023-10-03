local OverheatDisplay = component("OverheatDisplay")

OverheatDisplay.editor_init = function (self, unit)
	local overheat = self:get_data(unit, "overheat")
	local overheat_display_steps = self:get_data(unit, "overheat_display_steps")
	local warning_threshold = self:get_data(unit, "warning_threshold")
	self._overheat = overheat
	self._overheat_display_steps = overheat_display_steps
	self._warning_threshold = warning_threshold

	self:enable(unit)
end

OverheatDisplay.editor_validate = function (self, unit)
	return true, ""
end

OverheatDisplay.init = function (self, unit)
	local overheat = self:get_data(unit, "overheat")
	local overheat_display_steps = self:get_data(unit, "overheat_display_steps")
	local warning_threshold = self:get_data(unit, "warning_threshold")
	self._overheat = overheat
	self._overheat_display_steps = overheat_display_steps
	self._warning_threshold = warning_threshold

	self:enable(unit)
end

OverheatDisplay.enable = function (self, unit)
	self:_update_charge(unit)
end

OverheatDisplay.disable = function (self, unit)
	return
end

OverheatDisplay.destroy = function (self, unit)
	return
end

OverheatDisplay.set_overheat_level = function (self, unit, overheat, warning_threshold)
	if overheat ~= self._overheat or warning_threshold ~= self._warning_threshold then
		self._overheat = overheat
		self._warning_threshold = warning_threshold

		self:_update_charge(unit)
	end
end

OverheatDisplay._update_charge = function (self, unit)
	local charge_value = self._overheat
	local warning_value = self._warning_threshold

	Unit.set_vector2_for_material(unit, "display_01", "charge_warning", Vector2(1, charge_value))
end

OverheatDisplay.component_data = {
	overheat_display_steps = {
		ui_type = "slider",
		step = 1,
		decimals = 0,
		value = 10,
		ui_name = "Overheat Steps",
		max = 10
	},
	overheat = {
		ui_type = "slider",
		step = 1,
		decimals = 2,
		value = 0,
		ui_name = "Overheat",
		max = 1
	},
	warning_threshold = {
		ui_type = "slider",
		step = 1,
		decimals = 2,
		value = 0.9,
		ui_name = "Warning Threshold",
		max = 1
	}
}

return OverheatDisplay
