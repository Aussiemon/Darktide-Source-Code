-- chunkname: @scripts/components/vector_field_sine.lua

local VectorFieldSine = component("VectorFieldSine")

VectorFieldSine.init = function (self, unit)
	self._index_offset = Script.index_offset()
	self._unit = unit
	self._duration = self:get_data(unit, "duration")
	self._vector_field_name = self:get_data(unit, "vector_field_name")
	self._bounding_volume = self:get_data(unit, "bounding_volume")

	local effect_resource = "effect_global"

	if self._bounding_volume == "box" then
		effect_resource = "effect_box"
	elseif self._bounding_volume == "sphere" then
		effect_resource = "effect_sphere"
	elseif self._bounding_volume == "cylinder" then
		effect_resource = "effect_cylinder"
	end

	self._effect = self:get_data(unit, effect_resource)

	if tonumber(self._duration) <= 0 then
		self._duration = nil
	end

	self._settings = {
		duration = self._duration,
	}

	local world = Unit.world(unit)

	self._vector_field = World.vector_field(world, self._vector_field_name)

	self:disable(unit)
	self:enable(unit)
	self:update_bounding_volume(unit)
end

VectorFieldSine.editor_validate = function (self, unit)
	return true, ""
end

VectorFieldSine.update_bounding_volume = function (self, unit)
	if rawget(_G, "UnitEditor") then
		return
	end

	Unit.set_visibility(unit, "bounding_cylinder", false)
	Unit.set_visibility(unit, "bounding_box", false)
	Unit.set_visibility(unit, "bounding_sphere", false)

	if self._bounding_volume == "box" then
		Unit.set_visibility(unit, "bounding_box", true)
	elseif self._bounding_volume == "sphere" then
		Unit.set_visibility(unit, "bounding_sphere", true)
	elseif self._bounding_volume == "cylinder" then
		Unit.set_visibility(unit, "bounding_cylinder", true)
	end
end

VectorFieldSine.enable = function (self, unit)
	local parameters = self:create_paramaters(unit)
	local vector_field_id = VectorField.add(self._vector_field, self._effect, parameters, self._settings)

	Unit.set_data(unit, "vector_field_id", vector_field_id)
end

VectorFieldSine.disable = function (self, unit)
	self:remove(unit)
end

VectorFieldSine.destroy = function (self, unit)
	self:remove(unit)
end

VectorFieldSine.changed = function (self, unit)
	local vector_field_id = Unit.get_data(unit, "vector_field_id")

	if vector_field_id then
		local parameters = self:create_paramaters(unit)

		VectorField.change(self._vector_field, vector_field_id, self._effect, parameters, self._settings)
	else
		Log.info("VectorFieldSine", "No Vectorfield ID in Unit")
	end
end

VectorFieldSine.remove = function (self, unit)
	local vector_field_id = Unit.get_data(unit, "vector_field_id")

	if vector_field_id then
		VectorField.remove(self._vector_field, vector_field_id)
	else
		Log.info("VectorFieldSine", "No Vectorfield ID in Unit")
	end
end

VectorFieldSine.start_effect = function (self)
	self:disable(self._unit)
	self:enable(self._unit)
end

VectorFieldSine.stop_effect = function (self)
	self:disable(self._unit)
end

VectorFieldSine.create_paramaters = function (self, unit)
	local amplitude = self:get_data(unit, "amplitude")
	local frequency = self:get_data(unit, "frequency")
	local phase = self:get_data(unit, "phase")
	local rotation = Unit.world_rotation(unit, 1)
	local rotated_amplitude = Quaternion.rotate(rotation, amplitude:unbox())
	local center = Unit.world_position(unit, 1)
	local scale = Unit.world_scale(unit, 1)
	local half_extents = Vector3.multiply_elements(Vector3(1, 1, 1), scale)
	local direction = Quaternion.forward(rotation)

	if self._bounding_volume == "box" then
		return {
			amplitude = rotated_amplitude,
			direction = direction,
			frequency = frequency,
			phase = phase,
			center = center,
			rotation = rotation,
			extents = half_extents,
		}
	elseif self._bounding_volume == "sphere" then
		return {
			amplitude = rotated_amplitude,
			direction = direction,
			frequency = frequency,
			phase = phase,
			center = center,
			radius = scale.x,
		}
	elseif self._bounding_volume == "cylinder" then
		return {
			amplitude = rotated_amplitude,
			direction = direction,
			frequency = frequency,
			phase = phase,
			bottom = center - direction * scale.y,
			top = center + direction * scale.y,
			rotation = rotation,
			radius = scale.x,
		}
	else
		return {
			amplitude = rotated_amplitude,
			direction = direction,
			frequency = frequency,
			phase = phase,
		}
	end
end

VectorFieldSine.component_data = {
	vector_field_name = {
		ui_name = "Vector Field Name",
		ui_type = "text_box",
		value = "wind",
	},
	duration = {
		decimals = 2,
		min = 0,
		step = 0.01,
		ui_name = "Duration",
		ui_type = "number",
		value = 0,
	},
	amplitude = {
		ui_name = "Amplitude",
		ui_type = "vector",
		value = Vector3Box(0, 0, 1),
	},
	frequency = {
		decimals = 2,
		step = 0.01,
		ui_name = "Frequency",
		ui_type = "slider",
		value = 5,
	},
	phase = {
		decimals = 2,
		step = 0.01,
		ui_name = "Phase",
		ui_type = "slider",
		value = 0,
	},
	bounding_volume = {
		ui_name = "Bounding Volume",
		ui_type = "combo_box",
		value = "global_direction",
		options = {
			"none",
			"box",
			"sphere",
			"cylinder",
		},
	},
	effect_global = {
		filter = "vector_field",
		ui_name = "Effect Global Resource",
		ui_type = "resource",
	},
	effect_box = {
		filter = "vector_field",
		ui_name = "Effect Box Resource",
		ui_type = "resource",
	},
	effect_sphere = {
		filter = "vector_field",
		ui_name = "Effect Sphere Resource",
		ui_type = "resource",
	},
	effect_cylinder = {
		filter = "vector_field",
		ui_name = "Effect Cylinder Resource",
		ui_type = "resource",
	},
	inputs = {
		start_effect = {
			accessibility = "public",
			type = "event",
		},
		stop_effect = {
			accessibility = "public",
			type = "event",
		},
	},
}

return VectorFieldSine
