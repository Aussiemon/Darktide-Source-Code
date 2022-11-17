local Decal = component("Decal")

Decal.init = function (self, unit)
	local sort_order = self:get_data(unit, "sort_order")

	if sort_order ~= 0 then
		Unit.set_sort_order(unit, sort_order)
	end
end

Decal.enable = function (self, unit)
	return
end

Decal.disable = function (self, unit)
	return
end

Decal.destroy = function (self, unit)
	return
end

Decal.component_data = {
	sort_order = {
		value = 0,
		min = 0,
		ui_type = "number",
		decimals = 0,
		ui_name = "Sort Order",
		max = 2900000
	}
}

return Decal
