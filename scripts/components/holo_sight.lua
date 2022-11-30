local HoloSight = component("HoloSight")

HoloSight.editor_init = function (self, unit)
	self._glass_visibility_group_name = self:get_data(unit, "glass_visibility_group_name")
	self._unit = unit
	self._glass_visible = nil

	self:set_glass_visibility(true)
end

HoloSight.init = function (self, unit)
	self._glass_visibility_group_name = self:get_data(unit, "glass_visibility_group_name")
	self._unit = unit
	self._glass_visible = nil

	self:set_glass_visibility(true)
end

HoloSight.enable = function (self, unit)
	return
end

HoloSight.disable = function (self, unit)
	return
end

HoloSight.destroy = function (self, unit)
	return
end

HoloSight.set_glass_visibility = function (self, is_visible)
	local glass_visibility_group_name = self._glass_visibility_group_name

	if glass_visibility_group_name and self._glass_visible ~= is_visible then
		Unit.set_visibility(self._unit, glass_visibility_group_name, is_visible)

		self._glass_visible = is_visible
	end
end

HoloSight.component_data = {
	glass_visibility_group_name = {
		ui_type = "text_box",
		value = "",
		ui_name = "Glass Visibility Group"
	}
}

return HoloSight
