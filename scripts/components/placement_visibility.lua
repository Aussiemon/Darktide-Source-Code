local PlacementVisibility = component("PlacementVisibility")

PlacementVisibility.init = function (self, unit)
	self._unit = unit
	self._placed = false
	self._enabled = true
	local material_slot = self:get_data(unit, "material_slot")
	self._material_slot_name = material_slot
	local main_material = self:get_data(unit, "main_material")
	local ghost_material = self:get_data(unit, "ghost_material")

	if main_material == "" or ghost_material == "" then
		Log.error("PlacementVisibility", "Missing materials. material_slot(%q), main_material(%q), ghost_material(%q),", material_slot, main_material, ghost_material)
	end

	self:_update_visibility()
end

PlacementVisibility.editor_init = function (self, unit)
	return
end

PlacementVisibility.enable = function (self, unit)
	self._enabled = true

	self:_update_visibility()
end

PlacementVisibility.disable = function (self, unit)
	if self._placed then
		Log.warning("PlacementVisibility", "Trying to disable when already placed, not possible")

		return
	end

	self._enabled = false

	self:_update_visibility()
end

PlacementVisibility.destroy = function (self, unit)
	return
end

PlacementVisibility._update_visibility = function (self)
	local unit = self._unit
	local material_slot_name = self._material_slot_name

	if self._placed then
		Unit.set_unit_visibility(unit, true)
		Unit.set_material(unit, material_slot_name, self:get_data(unit, "main_material"))
	elseif self._enabled then
		Unit.set_unit_visibility(unit, true)
		Unit.set_material(unit, material_slot_name, self:get_data(unit, "ghost_material"))
	else
		Unit.set_unit_visibility(unit, false)
	end
end

PlacementVisibility.place = function (self)
	if not self._enabled then
		Log.warning("PlacementVisibility", "Placed while disabled")

		return
	end

	self._placed = true

	self:_update_visibility()
end

PlacementVisibility.remove = function (self)
	self._placed = false
	self._enabled = false

	self:_update_visibility()
end

PlacementVisibility.events.interaction_success = function (self, type, unit)
	self:place(unit)
end

PlacementVisibility.component_data = {
	material_slot = {
		ui_type = "text_box",
		value = "",
		ui_name = "Material Slot",
		category = "Material"
	},
	main_material = {
		ui_type = "resource",
		category = "Material",
		value = "",
		ui_name = "Main Material",
		filter = "material"
	},
	ghost_material = {
		ui_type = "resource",
		category = "Material",
		value = "",
		ui_name = "Ghost Material",
		filter = "material"
	},
	inputs = {
		place = {
			accessibility = "public",
			type = "event"
		},
		remove = {
			accessibility = "public",
			type = "event"
		}
	}
}

return PlacementVisibility
