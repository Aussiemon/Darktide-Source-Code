-- chunkname: @scripts/components/vector_field_effect.lua

local VectorFieldEffect = component("VectorFieldEffect")

VectorFieldEffect.init = function (self, unit)
	self._index_offset = Script.index_offset()
	self._effect = self:get_data(unit, "effect")
	self._speed = self:get_data(unit, "speed")
	self._duration = self:get_data(unit, "duration")

	if tonumber(self._duration) <= 0 then
		self._duration = nil
	end

	self._settings = {
		duration = self._duration,
	}

	local world = Unit.world(unit)

	self._vector_field = World.vector_field(world, "wind")
	self._effect_path = "content/vector_fields/" .. self._effect

	self:disable(unit)
	self:enable(unit)
end

VectorFieldEffect.editor_validate = function (self, unit)
	return true, ""
end

VectorFieldEffect.enable = function (self, unit)
	local parameters = self:create_paramaters(unit, self._effect, self._speed, self._duration)
	local vector_field_id = VectorField.add(self._vector_field, self._effect_path, parameters, self._settings)

	Unit.set_data(unit, "vector_field_id", vector_field_id)
end

VectorFieldEffect.disable = function (self, unit)
	self:remove(unit)
end

VectorFieldEffect.destroy = function (self, unit)
	self:remove(unit)
end

VectorFieldEffect.changed = function (self, unit)
	local vector_field_id = Unit.get_data(unit, "vector_field_id")

	if vector_field_id then
		local parameters = self:create_paramaters(unit, self._effect, self._speed, self._duration)

		VectorField.change(self._vector_field, vector_field_id, self._effect_path, parameters, self._settings)
	else
		Log.info("VectorFieldEffect", "No Vectorfield ID in Unit")
	end
end

VectorFieldEffect.remove = function (self, unit)
	local vector_field_id = Unit.get_data(unit, "vector_field_id")

	if vector_field_id then
		VectorField.remove(self._vector_field, vector_field_id)
	else
		Log.info("VectorFieldEffect", "No Vectorfield ID in Unit")
	end
end

VectorFieldEffect.create_paramaters = function (self, unit, effect, speed)
	local pose, extents = Unit.box(unit)
	local rotation = Matrix4x4.rotation(pose)
	local direction = Quaternion.forward(rotation)
	local center = Unit.world_position(unit, self._index_offset)
	local world_extents = Quaternion.rotate(rotation, extents)

	if effect == "box_direction" then
		return {
			speed = Vector3.multiply(direction, speed),
			world_extents = world_extents,
		}
	elseif effect == "global_direction" then
		return {
			speed = Vector3.multiply(direction, speed),
		}
	elseif effect == "global_sine" then
		local amplitude = self:get_data(unit, "amplitude")
		local frequency = self:get_data(unit, "frequency")
		local phase = self:get_data(unit, "phase")
		local rotation = Unit.world_rotation(unit, self._index_offset)
		local wave_vector = Quaternion.forward(rotation)
		local rotated_amplitude = Quaternion.rotate(rotation, amplitude:unbox())

		return {
			amplitude = rotated_amplitude,
			wave_vector = wave_vector,
			frequency = frequency,
			phase = phase,
		}
	elseif effect == "push_pull" then
		local scale = Unit.local_scale(unit, self._index_offset)

		return {
			center = center,
			radius = scale.x * 0.5,
			speed = speed,
		}
	elseif effect == "whirl" then
		local whirl_speed = self:get_data(unit, "whirl_speed")
		local pull_speed = self:get_data(unit, "pull_speed")
		local scale = Unit.local_scale(unit, self._index_offset)

		return {
			whirl_speed = whirl_speed,
			pull_speed = pull_speed,
			center = center,
			radius = scale.x * 0.5,
			up = Quaternion.up(rotation),
		}
	else
		Log.info("VectorFieldEffect", "Can not find effect: %s", effect)

		return nil
	end
end

local effects = {
	"box_direction",
	"global_direction",
	"global_sine",
	"push_pull",
	"whirl",
}

VectorFieldEffect.component_data = {
	effect = {
		ui_name = "Effect",
		ui_type = "combo_box",
		value = "global_direction",
		options = {
			"box_direction",
			"global_direction",
			"global_sine",
			"push_pull",
			"whirl",
		},
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
	whirl_speed = {
		decimals = 2,
		max = 100,
		min = -100,
		step = 0.01,
		ui_name = "Whirl Speed",
		ui_type = "slider",
		value = 30,
	},
	pull_speed = {
		decimals = 2,
		max = 100,
		min = -100,
		step = 0.01,
		ui_name = "Pull Speed",
		ui_type = "slider",
		value = 10,
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
	effect_resource_01 = {
		filter = "vector_field",
		ui_name = "Effect Resource",
		ui_type = "resource",
	},
	effect_resource_02 = {
		filter = "vector_field",
		ui_name = "Effect Resource",
		ui_type = "resource",
	},
	effect_resource_03 = {
		filter = "vector_field",
		ui_name = "Effect Resource",
		ui_type = "resource",
	},
	effect_resource_04 = {
		filter = "vector_field",
		ui_name = "Effect Resource",
		ui_type = "resource",
	},
	effect_resource_05 = {
		filter = "vector_field",
		ui_name = "Effect Resource",
		ui_type = "resource",
	},
}

return VectorFieldEffect
