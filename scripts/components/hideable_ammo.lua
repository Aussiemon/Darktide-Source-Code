-- chunkname: @scripts/components/hideable_ammo.lua

local HideableAmmo = component("HideableAmmo")

HideableAmmo.init = function (self, unit)
	self._unit = unit

	local start_hidden = self:get_data(unit, "start_hidden")

	if start_hidden then
		self:hide()
	else
		self:show()
	end
end

HideableAmmo.enable = function (self, unit)
	return
end

HideableAmmo.disable = function (self, unit)
	return
end

HideableAmmo.destroy = function (self, unit)
	return
end

local TWO_PI = math.pi * 2

HideableAmmo.show = function (self)
	local random_rotation = Quaternion.axis_angle(Vector3.forward(), math.random() * TWO_PI)

	Unit.set_local_rotation(self._unit, 1, random_rotation)
	Unit.set_unit_visibility(self._unit, true, true)
end

HideableAmmo.hide = function (self)
	Unit.set_unit_visibility(self._unit, false, true)
end

HideableAmmo.component_data = {
	start_hidden = {
		ui_type = "check_box",
		value = false,
		ui_name = "Start Hidden"
	}
}

return HideableAmmo
