-- chunkname: @scripts/components/vector_field_direction.lua

local VectorFieldDirection = component("VectorFieldDirection")

VectorFieldDirection.init = function (self, unit)
	self._unit = unit
	self._speed = self:get_data(unit, "speed")
	self._duration = self:get_data(unit, "duration")
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
	self._vector_field_name = self:get_data(unit, "vector_field_name")

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
	self:update_direction(unit)
	self:update_bounding_volume(unit)
end

VectorFieldDirection.editor_validate = function (self, unit)
	return true, ""
end

VectorFieldDirection.enable = function (self, unit)
	local parameters = self:create_paramaters(unit)
	local vector_field_id = VectorField.add(self._vector_field, self._effect, parameters, self._settings)

	Unit.set_data(unit, "vector_field_id", vector_field_id)
end

VectorFieldDirection.update_direction = function (self, unit)
	if self._speed < 0 then
		Unit.set_visibility(unit, "negative", true)
		Unit.set_visibility(unit, "possitive", false)
	else
		Unit.set_visibility(unit, "negative", false)
		Unit.set_visibility(unit, "possitive", true)
	end
end

VectorFieldDirection.update_bounding_volume = function (self, unit)
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

VectorFieldDirection.disable = function (self, unit)
	self:remove(unit)
end

VectorFieldDirection.destroy = function (self, unit)
	self:remove(unit)
end

VectorFieldDirection.changed = function (self, unit)
	local vector_field_id = Unit.get_data(unit, "vector_field_id")

	if vector_field_id then
		local parameters = self:create_paramaters(unit)

		VectorField.change(self._vector_field, vector_field_id, self._effect, parameters, self._settings)
	else
		Log.info("VectorFieldDirection", "No Vectorfield ID in Unit")
	end
end

VectorFieldDirection.remove = function (self, unit)
	local vector_field_id = Unit.get_data(unit, "vector_field_id")

	if vector_field_id then
		VectorField.remove(self._vector_field, vector_field_id)
	else
		Log.info("VectorFieldDirection", "No Vectorfield ID in Unit")
	end
end

VectorFieldDirection.start_effect = function (self)
	self:disable(self._unit)
	self:enable(self._unit)
end

VectorFieldDirection.stop_effect = function (self)
	self:disable(self._unit)
end

VectorFieldDirection.create_paramaters = function (self, unit)
	local center = Unit.world_position(unit, 1)
	local rotation = Unit.world_rotation(unit, 1)
	local scale = Unit.world_scale(unit, 1)
	local half_extents = Vector3.multiply_elements(Vector3(1, 1, 1), scale)
	local direction = Quaternion.forward(rotation)

	if self._bounding_volume == "box" then
		return {
			speed = self._speed,
			center = center,
			direction = direction,
			rotation = rotation,
			extents = half_extents,
		}
	elseif self._bounding_volume == "sphere" then
		return {
			center = center,
			direction = Vector3.multiply(direction, self._speed),
			radius = scale.x,
		}
	elseif self._bounding_volume == "cylinder" then
		return {
			speed = self._speed,
			bottom = center - direction * scale.y,
			top = center + direction * scale.y,
			direction = direction,
			rotation = rotation,
			radius = scale.x,
		}
	else
		return {
			speed = Vector3.multiply(direction, self._speed),
		}
	end
end

VectorFieldDirection.component_data = {
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
	speed = {
		decimals = 2,
		max = 100,
		min = -100,
		step = 0.01,
		ui_name = "Speed",
		ui_type = "slider",
		value = 5,
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

return VectorFieldDirection
