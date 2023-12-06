local DruglabTankShield = component("DruglabTankShield")

DruglabTankShield.init = function (self, unit)
	self._unit = unit
	self._material_slot_name = self:get_data(unit, "material_slot_name")
	self._shield_strength_variable_name = self:get_data(unit, "shield_strength_variable_name")
	self._shield_min_strength_variable_name = self:get_data(unit, "shield_min_strength_variable_name")
	self._overload_variable_name = self:get_data(unit, "overload_variable_name")
	self._overload_duration = self:get_data(unit, "overload_duration")
	self._current_health_percent = 1
	self._is_alive = true

	return true
end

DruglabTankShield.extensions_ready = function (self, world, unit)
	self._health_extension = ScriptUnit.has_extension(unit, "health_system")
end

DruglabTankShield.editor_validate = function (self, unit)
	return true, ""
end

DruglabTankShield.enable = function (self, unit)
	return
end

DruglabTankShield.disable = function (self, unit)
	return
end

DruglabTankShield.destroy = function (self, unit)
	return
end

DruglabTankShield.update = function (self, unit, dt, t)
	local health_extension = self._health_extension

	if health_extension then
		local was_alive = self._is_alive
		local is_alive = health_extension:is_alive()

		if self._overload_timer and self._overload_timer >= 0 then
			local lerp_t = (self._overload_duration - self._overload_timer) / self._overload_duration
			local health_variable_value = math.lerp(self._current_health_percent, 0.25, lerp_t)

			Unit.set_scalar_for_material(unit, self._material_slot_name, self._shield_strength_variable_name, health_variable_value)

			local overload_variable_value = math.ease_in_exp(math.lerp(0, 1, lerp_t))

			Unit.set_scalar_for_material(unit, self._material_slot_name, self._overload_variable_name, overload_variable_value)

			self._overload_timer = self._overload_timer - dt

			if self._overload_timer <= 0 then
				self._overload_timer = nil
			end

			return not not self._overload_timer
		elseif is_alive and was_alive then
			local last_health_percent = self._current_health_percent
			local current_health_percent = health_extension:current_health_percent()

			if last_health_percent ~= current_health_percent then
				Unit.set_scalar_for_material(unit, self._material_slot_name, self._shield_strength_variable_name, current_health_percent)

				self._current_health_percent = current_health_percent
			end
		end

		return health_extension:is_alive()
	end

	return true
end

DruglabTankShield.druglab_tank_shield_start_overload = function (self)
	self._overload_timer = self._overload_duration
end

DruglabTankShield.component_data = {
	material_slot_name = {
		ui_type = "text_box",
		value = "lambert1",
		ui_name = "Material Slot Name"
	},
	shield_strength_variable_name = {
		ui_type = "text_box",
		value = "shield_power",
		ui_name = "Shield Strength",
		category = "Material Variable Names"
	},
	shield_min_strength_variable_name = {
		ui_type = "text_box",
		value = "min_shield_power",
		ui_name = "Min Shield Strength",
		category = "Material Variable Names"
	},
	overload_variable_name = {
		ui_type = "text_box",
		value = "overload",
		ui_name = "Overload",
		category = "Material Variable Names"
	},
	overload_duration = {
		ui_type = "number",
		min = 0.5,
		decimals = 3,
		value = 2,
		ui_name = "Overload Duration",
		max = 10
	},
	inputs = {
		druglab_tank_shield_start_overload = {
			accessibility = "public",
			type = "event"
		}
	}
}

return DruglabTankShield
