-- chunkname: @scripts/components/barrel_overheat.lua

local BarrelOverheat = component("BarrelOverheat")
local BARREL_OVERHEAT_MATERIAL_VARIABLE = "overheat"

BarrelOverheat.editor_validate = function (self, unit)
	return true, ""
end

BarrelOverheat.init = function (self, unit)
	self:enable(unit)

	self._unit = unit
	self._overheat_min = self:get_data(unit, "overheat_min")
	self._overheat_max = self:get_data(unit, "overheat_max")

	self:_set_barrel_overheat(0)
end

BarrelOverheat._set_barrel_overheat = function (self, value)
	local overheat_value = math.lerp(self._overheat_min, self._overheat_max, value)

	Unit.set_scalar_for_materials(self._unit, BARREL_OVERHEAT_MATERIAL_VARIABLE, overheat_value, true)
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
		decimals = 2,
		max = 3,
		min = 0,
		step = 0.01,
		ui_name = "Blur min",
		ui_type = "slider",
		value = 0,
	},
	overheat_max = {
		decimals = 2,
		max = 1,
		min = 0,
		step = 0.01,
		ui_name = "Blur max",
		ui_type = "slider",
		value = 1,
	},
	inputs = {
		set_barrel_overheat = {
			accessibility = "public",
			type = "event",
		},
	},
}

return BarrelOverheat
