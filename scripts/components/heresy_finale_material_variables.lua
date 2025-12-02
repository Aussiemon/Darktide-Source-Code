-- chunkname: @scripts/components/heresy_finale_material_variables.lua

local HeresyFinaleMaterialVariables = component("HeresyFinaleMaterialVariables")

HeresyFinaleMaterialVariables.init = function (self, unit)
	self._unit = unit
	self._world = Unit.world(unit)
	self._start_effect_time_variable_name = self:get_data(unit, "start_effect_time_variable_name")
	self._material_slot_name = self:get_data(unit, "material_slot_name")
	self._start_effect_duration = self:get_data(unit, "start_effect_duration")
	self._start_effect_duration_variable_name = self:get_data(unit, "start_effect_variable_name")
	self._stage2_effect_time_variable_name = self:get_data(unit, "stage2_time_variable_name")
	self._stage2_effect_duration = self:get_data(unit, "stage2_effect_duration")
	self._stage2_effect_duration_variable_name = self:get_data(unit, "stage2_effect_variable_name")
	self._stage3_effect_time_variable_name = self:get_data(unit, "stage3_time_variable_name")
	self._stage3_effect_duration = self:get_data(unit, "stage3_effect_duration")
	self._stage3_effect_duration_variable_name = self:get_data(unit, "stage3_effect_variable_name")
	self._stage4_effect_time_variable_name = self:get_data(unit, "stage4_time_variable_name")
	self._stage4_effect_duration = self:get_data(unit, "stage4_effect_duration")
	self._stage4_effect_duration_variable_name = self:get_data(unit, "stage4_effect_variable_name")
end

HeresyFinaleMaterialVariables.editor_validate = function (self, unit)
	return true, ""
end

HeresyFinaleMaterialVariables.enable = function (self, unit)
	return
end

HeresyFinaleMaterialVariables.disable = function (self, unit)
	return
end

HeresyFinaleMaterialVariables.destroy = function (self, unit)
	return
end

HeresyFinaleMaterialVariables.start_effect = function (self)
	local t = World.time(self._world)

	Unit.set_scalar_for_material(self._unit, self._material_slot_name, self._start_effect_time_variable_name, t)
	Unit.set_scalar_for_material(self._unit, self._material_slot_name, self._start_effect_duration_variable_name, self._start_effect_duration)
end

HeresyFinaleMaterialVariables.stage2_effect = function (self)
	local t = World.time(self._world)

	Unit.set_scalar_for_material(self._unit, self._material_slot_name, self._stage2_effect_time_variable_name, t)
	Unit.set_scalar_for_material(self._unit, self._material_slot_name, self._stage2_effect_duration_variable_name, self._stage2_effect_duration)
end

HeresyFinaleMaterialVariables.stage3_effect = function (self)
	local t = World.time(self._world)

	Unit.set_scalar_for_material(self._unit, self._material_slot_name, self._stage3_effect_time_variable_name, t)
	Unit.set_scalar_for_material(self._unit, self._material_slot_name, self._stage3_effect_duration_variable_name, self._stage3_effect_duration)
end

HeresyFinaleMaterialVariables.stage4_effect = function (self)
	local t = World.time(self._world)

	Unit.set_scalar_for_material(self._unit, self._material_slot_name, self._stage4_effect_time_variable_name, t)
	Unit.set_scalar_for_material(self._unit, self._material_slot_name, self._stage4_effect_duration_variable_name, self._stage4_effect_duration)
end

HeresyFinaleMaterialVariables.component_data = {
	start_effect_time_variable_name = {
		ui_name = "Start Effect Start Time Variable",
		ui_type = "text_box",
		value = "",
	},
	material_slot_name = {
		ui_name = "Material Slot Name",
		ui_type = "text_box",
		value = "",
	},
	start_effect_variable_name = {
		ui_name = "Start Effect Duration Variable",
		ui_type = "text_box",
		value = "",
	},
	start_effect_duration = {
		decimals = 2,
		step = 0.01,
		ui_name = "Start Effect Duration",
		ui_type = "number",
		value = 1,
	},
	stage2_time_variable_name = {
		ui_name = "Stage 2 Effect Start Time Variable",
		ui_type = "text_box",
		value = "",
	},
	stage2_effect_variable_name = {
		ui_name = "Stage 2 Effect Duration Variable",
		ui_type = "text_box",
		value = "",
	},
	stage2_effect_duration = {
		decimals = 2,
		step = 0.01,
		ui_name = "Stage 2 Effect Duration",
		ui_type = "number",
		value = 1,
	},
	stage3_time_variable_name = {
		ui_name = "Stage 2 Effect Start Time Variable",
		ui_type = "text_box",
		value = "",
	},
	stage3_effect_variable_name = {
		ui_name = "Stage 3 Effect Duration Variable",
		ui_type = "text_box",
		value = "",
	},
	stage3_effect_duration = {
		decimals = 2,
		step = 0.01,
		ui_name = "Stage 3 Effect Duration",
		ui_type = "number",
		value = 1,
	},
	stage4_time_variable_name = {
		ui_name = "Stage 2 Effect Start Time Variable",
		ui_type = "text_box",
		value = "",
	},
	stage4_effect_variable_name = {
		ui_name = "Stage 4 Effect Duration Variable",
		ui_type = "text_box",
		value = "",
	},
	stage4_effect_duration = {
		decimals = 2,
		step = 0.01,
		ui_name = "Stage 4 Effect Duration",
		ui_type = "number",
		value = 1,
	},
	inputs = {
		start_effect = {
			accessibility = "public",
			type = "event",
		},
		stage2_effect = {
			accessibility = "public",
			type = "event",
		},
		stage3_effect = {
			accessibility = "public",
			type = "event",
		},
		stage4_effect = {
			accessibility = "public",
			type = "event",
		},
	},
}

return HeresyFinaleMaterialVariables
