local DruglabTank = component("DruglabTank")

DruglabTank.init = function (self, unit)
	self._unit = unit
	self._glass_material_slot_name = self:get_data(unit, "glass_material_slot_name")
	self._glass_damage_amount_variable_name = self:get_data(unit, "glass_damage_amount_variable_name")
	local has_liquid = self:get_data(unit, "has_liquid")

	if has_liquid then
		self._has_liquid = has_liquid
		self._liquid_material_slot_name = self:get_data(unit, "liquid_material_slot_name")
		self._liquid_drain_time = self:get_data(unit, "liquid_drain_time")
		local liquid_levels = self:get_data(unit, "liquid_levels")
		local liquid_level_variable_name = self:get_data(unit, "liquid_level_variable_name")

		table.sort(liquid_levels, function (a, b)
			return b.health_threshold < a.health_threshold
		end)

		self._liquid_levels = liquid_levels
		self._liquid_level_variable_name = liquid_level_variable_name
		self._wanted_liquid_level = liquid_levels[1].liquid_level
		self._current_liquid_level = liquid_levels[1].liquid_level
		self._drain_timer = -1

		Unit.set_scalar_for_material(unit, self._liquid_material_slot_name, self._liquid_level_variable_name, self._current_liquid_level)
	end

	self._current_health_percent = -1

	return true
end

DruglabTank.extensions_ready = function (self, world, unit)
	self._health_extension = ScriptUnit.has_extension(unit, "health_system")
end

DruglabTank.editor_validate = function (self, unit)
	return true, ""
end

DruglabTank.enable = function (self, unit)
	return
end

DruglabTank.disable = function (self, unit)
	return
end

DruglabTank.destroy = function (self, unit)
	return
end

DruglabTank.update = function (self, unit, dt, t)
	local health_extension = self._health_extension

	if health_extension then
		local last_health_percent = self._current_health_percent
		local current_health_percent = health_extension:current_health_percent()

		if current_health_percent ~= last_health_percent then
			local material_value = 1 - current_health_percent
			material_value = 0

			Unit.set_scalar_for_material(unit, self._glass_material_slot_name, self._glass_damage_amount_variable_name, material_value)

			self._current_health_percent = current_health_percent
		end

		if self._has_liquid then
			local liquid_levels = self._liquid_levels
			local wanted_liquid_level = self._wanted_liquid_level

			if current_health_percent ~= last_health_percent then
				for ii = #liquid_levels, 1, -1 do
					local stage = liquid_levels[ii]
					local next_stage = liquid_levels[ii + 1]
					local liquid_level = stage.liquid_level
					local update_liquid_level = nil

					if next_stage then
						update_liquid_level = current_health_percent <= stage.health_threshold and next_stage.health_threshold < current_health_percent
					else
						update_liquid_level = current_health_percent <= stage.health_threshold
					end

					if update_liquid_level and liquid_level ~= wanted_liquid_level then
						wanted_liquid_level = liquid_level
						self._drain_start_t = t
					end
				end
			end

			local current_liquid_level = self._current_liquid_level

			if self._drain_start_t then
				local time_draining = t - self._drain_start_t
				local lerp_t = time_draining / self._liquid_drain_time
				current_liquid_level = math.lerp(current_liquid_level, wanted_liquid_level, math.ease_in_quad(lerp_t))

				Unit.set_scalar_for_material(unit, self._liquid_material_slot_name, self._liquid_level_variable_name, current_liquid_level)

				if t >= self._drain_start_t + self._liquid_drain_time then
					self._drain_start_t = nil
				end
			end

			self._wanted_liquid_level = wanted_liquid_level
			self._current_liquid_level = current_liquid_level
		end

		return health_extension:is_alive() or self._has_liquid and self._liquid_levels[#self._liquid_levels].liquid_level < self._current_liquid_level
	end

	return true
end

DruglabTank.component_data = {
	glass_material_slot_name = {
		ui_type = "text_box",
		value = "broken_glass_01",
		ui_name = "Material Slot Name",
		category = "Glass"
	},
	glass_damage_amount_variable_name = {
		ui_type = "text_box",
		value = "damage_amount",
		ui_name = "Damage Variable Name",
		category = "Glass"
	},
	has_liquid = {
		ui_type = "check_box",
		value = false,
		ui_name = "Has Liquid",
		category = "Liquid"
	},
	liquid_material_slot_name = {
		ui_type = "text_box",
		value = "goo",
		ui_name = "Material Slot Name",
		category = "Liquid"
	},
	liquid_level_variable_name = {
		ui_type = "text_box",
		value = "fluid_level",
		ui_name = "Variable Name",
		category = "Liquid"
	},
	liquid_drain_time = {
		ui_type = "number",
		min = 0,
		decimals = 3,
		category = "Liquid",
		value = 1,
		ui_name = "Drain Time",
		max = 10
	},
	liquid_levels = {
		ui_type = "struct_array",
		category = "Liquid",
		ui_name = "Drain Levels",
		definition = {
			health_threshold = {
				ui_type = "number",
				min = 0,
				decimals = 3,
				value = 1,
				ui_name = "Health Threshold",
				max = 1
			},
			liquid_level = {
				ui_type = "number",
				min = 0,
				decimals = 3,
				value = 1,
				ui_name = "Liquid Level",
				max = 1
			}
		},
		control_order = {
			"health_threshold",
			"liquid_level"
		}
	}
}

return DruglabTank
