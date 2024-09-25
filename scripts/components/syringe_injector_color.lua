-- chunkname: @scripts/components/syringe_injector_color.lua

local SyringeInjectorColor = component("SyringeInjectorColor")

SyringeInjectorColor.init = function (self, unit)
	self._glass_material_slot_name = self:get_data(unit, "glass_material_slot_name")
	self._glass_color_variable_name = self:get_data(unit, "glass_color_variable_name")

	local glass_color = self:get_data(unit, "glass_color")

	self._liquid_material_slot_name = self:get_data(unit, "liquid_material_slot_name")
	self._liquid_color_variable_name = self:get_data(unit, "liquid_color_variable_name")

	local liquid_color = self:get_data(unit, "liquid_color")

	self._decal_material_slot_name = self:get_data(unit, "decal_material_slot_name")
	self._decal_index_variable_name = self:get_data(unit, "decal_index_variable_name")

	local decal_index = self:get_data(unit, "decal_index")

	self:set_colors(unit, glass_color:unbox(), liquid_color:unbox())
	self:set_decal(unit, decal_index)
end

SyringeInjectorColor.editor_init = function (self, unit)
	self:init(unit)
end

SyringeInjectorColor.editor_validate = function (self, unit)
	return true, ""
end

SyringeInjectorColor.enable = function (self, unit)
	return
end

SyringeInjectorColor.disable = function (self, unit)
	return
end

SyringeInjectorColor.destroy = function (self, unit)
	return
end

SyringeInjectorColor.set_colors = function (self, unit, glass_color, liquid_color)
	Unit.set_vector3_for_material(unit, self._glass_material_slot_name, self._glass_color_variable_name, glass_color)
	Unit.set_vector3_for_material(unit, self._liquid_material_slot_name, self._liquid_color_variable_name, liquid_color)
end

SyringeInjectorColor.set_decal = function (self, unit, decal_index)
	Unit.set_scalar_for_material(unit, self._decal_material_slot_name, self._decal_index_variable_name, decal_index)
end

SyringeInjectorColor.component_data = {
	glass_material_slot_name = {
		category = "Glass",
		ui_name = "Material Slot Name",
		ui_type = "text_box",
		value = "pup_syringe_glass",
	},
	glass_color_variable_name = {
		category = "Glass",
		ui_name = "Color Variable Name",
		ui_type = "text_box",
		value = "color",
	},
	glass_color = {
		category = "Glass",
		step = 0.001,
		ui_name = "Color",
		ui_type = "vector",
		value = Vector3Box(0.3, 0.6, 0.4),
	},
	liquid_material_slot_name = {
		category = "Liquid",
		ui_name = "Material Slot Name",
		ui_type = "text_box",
		value = "pup_syringe_liquid",
	},
	liquid_color_variable_name = {
		category = "Liquid",
		ui_name = "Color Variable Name",
		ui_type = "text_box",
		value = "emissive_color",
	},
	liquid_color = {
		category = "Liquid",
		step = 0.001,
		ui_name = "Color",
		ui_type = "vector",
		value = Vector3Box(0.117, 0.6, 0.197),
	},
	decal_material_slot_name = {
		category = "Decal",
		ui_name = "Material Slot Name",
		ui_type = "text_box",
		value = "pup_syringe_decal",
	},
	decal_index_variable_name = {
		category = "Decal",
		ui_name = "Index Variable Name",
		ui_type = "text_box",
		value = "wpn_decal_index",
	},
	decal_index = {
		category = "Decal",
		step = 1,
		ui_name = "Index",
		ui_type = "number",
		value = 1,
	},
}

return SyringeInjectorColor
