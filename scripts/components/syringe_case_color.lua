-- chunkname: @scripts/components/syringe_case_color.lua

local SyringeCaseColor = component("SyringeCaseColor")
local COLORS = {
	syringe_corruption_pocketable = {
		emissive_multiplier = 1,
		trim_color = Vector3Box(0, 0.5, 0),
		emissive_color = Vector3Box(0.15, 0.8, 0.1)
	},
	syringe_ability_boost_pocketable = {
		emissive_multiplier = 1,
		trim_color = Vector3Box(1, 0.2, 0),
		emissive_color = Vector3Box(0.9, 0.75, 0.05)
	},
	syringe_power_boost_pocketable = {
		emissive_multiplier = 1,
		trim_color = Vector3Box(0.75, 0, 0),
		emissive_color = Vector3Box(0.8, 0.2, 0.1)
	},
	syringe_speed_boost_pocketable = {
		emissive_multiplier = 1,
		trim_color = Vector3Box(0, 0, 0.3),
		emissive_color = Vector3Box(0, 0.5, 0.85)
	}
}

SyringeCaseColor.init = function (self, unit)
	self._unit = unit
	self._trim_material_slot_name = self:get_data(unit, "trim_material_slot_name")
	self._trim_color_variable_name = self:get_data(unit, "trim_color_variable_name")

	local trim_color = self:get_data(unit, "trim_color")

	self._emissive_material_slot_name = self:get_data(unit, "emissive_material_slot_name")
	self._emissive_color_variable_name = self:get_data(unit, "emissive_color_variable_name")

	local emissive_color = self:get_data(unit, "emissive_color")

	self._emissive_multiplier_variable_name = self:get_data(unit, "emissive_multiplier_variable_name")

	local emissive_multiplier = self:get_data(unit, "emissive_multiplier")

	self:_set_colors(unit, trim_color:unbox(), emissive_color:unbox(), emissive_multiplier)
end

SyringeCaseColor.editor_init = function (self, unit)
	self:init(unit)
end

SyringeCaseColor.editor_validate = function (self, unit)
	return true, ""
end

SyringeCaseColor.enable = function (self, unit)
	return
end

SyringeCaseColor.disable = function (self, unit)
	return
end

SyringeCaseColor.destroy = function (self, unit)
	return
end

SyringeCaseColor._set_colors = function (self, unit, trim_color, emissive_color, emissive_multiplier)
	Unit.set_vector3_for_material(unit, self._trim_material_slot_name, self._trim_color_variable_name, trim_color)
	Unit.set_vector3_for_material(unit, self._emissive_material_slot_name, self._emissive_color_variable_name, emissive_color)
	Unit.set_scalar_for_material(unit, self._emissive_material_slot_name, self._emissive_multiplier_variable_name, emissive_multiplier)
end

SyringeCaseColor.events.set_colors = function (self, pickup_settings)
	local syringe_type = pickup_settings.name
	local colors = COLORS[syringe_type]

	self:_set_colors(self._unit, colors.trim_color:unbox(), colors.emissive_color:unbox(), colors.emissive_multiplier)
end

SyringeCaseColor.component_data = {
	trim_material_slot_name = {
		ui_type = "text_box",
		value = "syringe_case",
		ui_name = "Material Slot Name",
		category = "Trim"
	},
	trim_color_variable_name = {
		ui_type = "text_box",
		value = "tint_color",
		ui_name = "Color Variable Name",
		category = "Trim"
	},
	trim_color = {
		ui_type = "vector",
		category = "Trim",
		ui_name = "Color",
		step = 0.001,
		value = Vector3Box(0, 0.5, 0)
	},
	emissive_material_slot_name = {
		ui_type = "text_box",
		value = "syringe_case",
		ui_name = "Material Slot Name",
		category = "Emissive"
	},
	emissive_color_variable_name = {
		ui_type = "text_box",
		value = "emissive_color",
		ui_name = "Color Variable Name",
		category = "Emissive"
	},
	emissive_color = {
		ui_type = "vector",
		category = "Emissive",
		ui_name = "Color",
		step = 0.001,
		value = Vector3Box(0.15, 0.8, 0.1)
	},
	emissive_multiplier_variable_name = {
		ui_type = "text_box",
		value = "emissive_multiplier",
		ui_name = "Emissive Variable Name",
		category = "Emissive"
	},
	emissive_multiplier = {
		ui_type = "slider",
		step = 0.1,
		category = "Emissive",
		value = 0.25,
		ui_name = "Multiplier",
		max = 10
	}
}

return SyringeCaseColor
