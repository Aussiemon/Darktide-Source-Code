-- chunkname: @scripts/components/mission_board_outline.lua

local MissionBoardOutline = component("MissionBoardOutline")

MissionBoardOutline.init = function (self, unit)
	self._unit = unit
	self._world = Unit.world(unit)
	self._variable_name = self:get_data(unit, "variable_name")
	self._material_layer_name = self:get_data(unit, "material_layer_name")
	self._material_slot_name = self:get_data(unit, "material_slot_name")
	self._lerp_on = false
end

MissionBoardOutline.editor_validate = function (self, unit)
	return true, ""
end

MissionBoardOutline.enable = function (self, unit)
	return
end

MissionBoardOutline.disable = function (self, unit)
	return
end

MissionBoardOutline.destroy = function (self, unit)
	return
end

MissionBoardOutline.outline_on = function (self)
	Unit.set_material_layer(self._unit, self._material_layer_name, true)
end

MissionBoardOutline.outline_off = function (self)
	Unit.set_material_layer(self._unit, self._material_layer_name, false)
end

MissionBoardOutline.component_data = {
	variable_name = {
		ui_type = "text_box",
		value = "on_off",
		ui_name = "variable name"
	},
	material_slot_name = {
		ui_type = "text_box",
		value = "hologram",
		ui_name = "material slot name"
	},
	material_layer_name = {
		ui_type = "text_box",
		value = "hologram_outline",
		ui_name = "material layer name"
	},
	inputs = {
		outline_on = {
			accessibility = "public",
			type = "event"
		},
		outline_off = {
			accessibility = "public",
			type = "event"
		}
	}
}

return MissionBoardOutline
