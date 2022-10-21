local AmmoDisplay = component("AmmoDisplay")

AmmoDisplay.editor_init = function (self, unit)
	self._max_ammo = self:get_data(unit, "max_ammo")
	self._ammo = self:get_data(unit, "ammo")
	self._ammo_display_steps = self:get_data(unit, "ammo_display_steps")
	self._critical_threshold = self:get_data(unit, "critical_threshold")

	self:enable(unit)
end

AmmoDisplay.init = function (self, unit)
	self._max_ammo = self:get_data(unit, "max_ammo")
	self._ammo = self:get_data(unit, "ammo")
	self._ammo_display_steps = self:get_data(unit, "ammo_display_steps")
	self._critical_threshold = self:get_data(unit, "critical_threshold")

	self:enable(unit)
end

AmmoDisplay.enable = function (self, unit)
	self:_update_charge(unit)
end

AmmoDisplay.disable = function (self, unit)
	return
end

AmmoDisplay.destroy = function (self, unit)
	return
end

AmmoDisplay.set_ammo = function (self, unit, ammo, max_ammo, critical_threshold)
	if ammo == 0 then
		ammo = 1
	end

	if max_ammo == 0 then
		max_ammo = 1
	end

	if max_ammo ~= self._max_ammo then
		self._max_ammo = max_ammo
	end

	if ammo ~= self._ammo or critical_threshold ~= self._critical_threshold then
		self._ammo = ammo
		self._critical_threshold = critical_threshold

		self:_update_charge(unit)
	end
end

AmmoDisplay._update_charge = function (self, unit)
	local max_ammo = self._max_ammo
	local charge_value = self._ammo / max_ammo
	local critical_value = self._critical_threshold / max_ammo

	Unit.set_scalar_for_material(unit, "display_01", "charge", charge_value)

	local is_critical = charge_value <= critical_value

	Unit.set_scalar_for_material(unit, "display_01", "warning", is_critical and 1 or 0)
	Unit.set_scalar_for_material(unit, "display_01", "steps", 30)

	if is_critical then
		Unit.set_vector3_for_material(unit, "display_01", "color", Vector3(0.5, 0, 0))
	else
		Unit.set_vector3_for_material(unit, "display_01", "color", Vector3(0, 0.5, 0))
	end
end

AmmoDisplay.component_data = {
	ammo_display_steps = {
		ui_type = "slider",
		decimals = 0,
		value = 6,
		ui_name = "Ammo Steps",
		step = 1
	},
	max_ammo = {
		ui_type = "slider",
		decimals = 0,
		value = 30,
		ui_name = "Max Ammo",
		step = 1
	},
	ammo = {
		ui_type = "slider",
		step = 1,
		decimals = 0,
		value = 30,
		ui_name = "Ammo",
		max = 30
	},
	critical_threshold = {
		ui_type = "slider",
		step = 1,
		decimals = 0,
		value = 3,
		ui_name = "Critical Threshold",
		max = 30
	}
}

return AmmoDisplay
