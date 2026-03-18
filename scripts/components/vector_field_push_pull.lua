-- chunkname: @scripts/components/vector_field_push_pull.lua

local VectorFieldPushPull = component("VectorFieldPushPull")

VectorFieldPushPull.init = function (self, unit)
	self._effect = self:get_data(unit, "effect_resource_01")
	self._unit = unit
	self._speed = self:get_data(unit, "speed")
	self._duration = self:get_data(unit, "duration")
	self._bounding_volume = self:get_data(unit, "bounding_volume")
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

VectorFieldPushPull.editor_validate = function (self, unit)
	return true, ""
end

VectorFieldPushPull.enable = function (self, unit)
	local parameters = self:create_paramaters(unit)
	local vector_field_id = VectorField.add(self._vector_field, self._effect, parameters, self._settings)

	Unit.set_data(unit, "vector_field_id", vector_field_id)
end

VectorFieldPushPull.update_direction = function (self, unit)
	if self._speed < 0 then
		Unit.set_visibility(unit, "negative", true)
		Unit.set_visibility(unit, "possitive", false)
	else
		Unit.set_visibility(unit, "negative", false)
		Unit.set_visibility(unit, "possitive", true)
	end
end

VectorFieldPushPull.update_bounding_volume = function (self, unit)
	if self._bounding_volume == "none" then
		Unit.set_visibility(unit, "bounding", false)
	end
end

VectorFieldPushPull.disable = function (self, unit)
	self:remove(unit)
end

VectorFieldPushPull.destroy = function (self, unit)
	self:remove(unit)
end

VectorFieldPushPull.changed = function (self, unit)
	local vector_field_id = Unit.get_data(unit, "vector_field_id")

	if vector_field_id then
		local parameters = self:create_paramaters(unit)

		VectorField.change(self._vector_field, vector_field_id, self._effect, parameters, self._settings)
	else
		Log.info("VectorFieldPushPull", "No Vectorfield ID in Unit")
	end
end

VectorFieldPushPull.remove = function (self, unit)
	local vector_field_id = Unit.get_data(unit, "vector_field_id")

	if vector_field_id then
		VectorField.remove(self._vector_field, vector_field_id)
	else
		Log.info("VectorFieldPushPull", "No Vectorfield ID in Unit")
	end
end

VectorFieldPushPull.start_effect = function (self)
	self:disable(self._unit)
	self:enable(self._unit)
end

VectorFieldPushPull.stop_effect = function (self)
	self:disable(self._unit)
end

VectorFieldPushPull.create_paramaters = function (self, unit)
	local pose, extents = Unit.box(unit)
	local rotation = Matrix4x4.rotation(pose)
	local center = Unit.world_position(unit, 1)
	local scale = Unit.local_scale(unit, 1)

	return {
		center = center,
		radius = scale.x * 0.5,
		speed = self._speed,
	}
end

VectorFieldPushPull.component_data = {
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
			"sphere",
		},
	},
	effect_resource_01 = {
		filter = "vector_field",
		ui_name = "Effect Resource",
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

return VectorFieldPushPull
