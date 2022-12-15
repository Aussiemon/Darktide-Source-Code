local BarrelOverheat = component("BarrelOverheat")
local BARREL_OVERHEAT_MATERIAL_VARIABLE = "overheat"

BarrelOverheat.init = function (self, unit)
	self:enable(unit)

	self._unit = unit
	self._overheat_min = self:get_data(unit, "overheat_min")
	self._overheat_max = self:get_data(unit, "overheat_max")
	self._overheat_color = self:get_data(unit, "overheat_color")

	self:_set_barrel_overheat(0)
end

BarrelOverheat._set_barrel_overheat = function (self, value)
	return
end

BarrelOverheat.enable = function (self, unit)
	return
end

BarrelOverheat.disable = function (self, unit)
	return
end

BarrelOverheat.destroy = function (self, unit)
	return
end

BarrelOverheat.events.set_barrel_overheat = function (self, value)
	if self._set_barrel_overheat then
		self:_set_barrel_overheat(value)
	end
end

BarrelOverheat.component_data = {
	overheat_min = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		decimals = 2,
		value = 0,
		ui_name = "Blur min",
		max = 3
	},
	overheat_max = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		decimals = 2,
		value = 3,
		ui_name = "Blur max",
		max = 3
	},
	overheat_color = {
		ui_type = "color",
		ui_name = "Value",
		value = QuaternionBox(1, 0.35, 0.2, 0)
	},
	inputs = {
		set_barrel_overheat = {
			accessibility = "public",
			type = "event"
		}
	}
}

return BarrelOverheat
