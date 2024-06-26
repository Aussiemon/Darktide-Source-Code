﻿-- chunkname: @scripts/components/decal.lua

local Decal = component("Decal")

Decal.init = function (self, unit)
	local sort_order = self:get_data(unit, "sort_order")

	if sort_order ~= 0 then
		Unit.set_sort_order(unit, sort_order)
	end
end

Decal.editor_validate = function (self, unit)
	return true, ""
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
		decimals = 0,
		max = 2900000,
		min = 0,
		ui_name = "Sort Order",
		ui_type = "number",
		value = 0,
	},
}

return Decal
