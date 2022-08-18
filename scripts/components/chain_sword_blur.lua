local ChainSwordBlur = component("ChainSwordBlur")
local BLUR_NODE_NAME = "fx_chain_blur"
local BLUR_VISIBILITY_GROUP = "chain_blur"
local FRESNEL_VARIABLE_NAME = "fresnel_max"
local BLUR_VARIABLE_NAME = "blur_amount"

ChainSwordBlur.init = function (self, unit)
	self:enable(unit)

	self._unit = unit
	local blur_mesh = Unit.mesh(unit, BLUR_NODE_NAME)
	self._chain_blur_material = Mesh.material(blur_mesh, 1)
	self._max_speed = self:get_data(unit, "max_speed")
	self._min_speed = self:get_data(unit, "min_speed")
	self._fresnel_max = self:get_data(unit, "fresnel_max")
	self._fresnel_min = self:get_data(unit, "fresnel_min")
	self._blur_amount_max = self:get_data(unit, "blur_amount_max")
	self._blur_amount_min = self:get_data(unit, "blur_amount_min")

	self:_set_visibility(false)
end

ChainSwordBlur._set_speed = function (self, speed)
	local min_speed = self._min_speed
	local max_speed = self._max_speed
	local visible = min_speed < speed

	self:_set_visibility(visible)

	local normalized_speed = math.clamp01(math.ilerp(min_speed, max_speed, speed))
	local fresnel = math.lerp(self._fresnel_min, self._fresnel_max, normalized_speed)
	local blur = math.lerp(self._blur_amount_min, self._blur_amount_max, normalized_speed)
	local chain_blur_material = self._chain_blur_material

	Material.set_scalar(chain_blur_material, FRESNEL_VARIABLE_NAME, fresnel)
	Material.set_scalar(chain_blur_material, BLUR_VARIABLE_NAME, blur)
end

ChainSwordBlur._set_visibility = function (self, visibility)
	local unit = self._unit

	if Unit.has_visibility_group(unit, BLUR_VISIBILITY_GROUP) then
		Unit.set_visibility(unit, BLUR_VISIBILITY_GROUP, visibility)
	end
end

ChainSwordBlur.enable = function (self, unit)
	return
end

ChainSwordBlur.disable = function (self, unit)
	return
end

ChainSwordBlur.destroy = function (self, unit)
	return
end

ChainSwordBlur.update = function (self, unit, dt, t)
	return
end

ChainSwordBlur.changed = function (self, unit)
	return
end

ChainSwordBlur.events.set_speed = function (self, speed)
	self:_set_speed(speed)
end

ChainSwordBlur.component_data = {
	min_speed = {
		ui_type = "slider",
		min = 0,
		step = 0.1,
		decimals = 2,
		value = 5,
		ui_name = "Min speed",
		max = 60
	},
	max_speed = {
		ui_type = "slider",
		min = 0,
		step = 0.1,
		decimals = 2,
		value = 30,
		ui_name = "Max speed",
		max = 60
	},
	fresnel_min = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		decimals = 2,
		value = 0,
		ui_name = "Fresnel min",
		max = 1
	},
	fresnel_max = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		decimals = 2,
		value = 0.47,
		ui_name = "Fresnel max",
		max = 1
	},
	blur_amount_min = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		decimals = 2,
		value = 0.23,
		ui_name = "Blur min",
		max = 1
	},
	blur_amount_max = {
		ui_type = "slider",
		min = 0,
		step = 0.01,
		decimals = 2,
		value = 0.23,
		ui_name = "Blur max",
		max = 1
	},
	inputs = {
		set_speed = {
			accessibility = "public",
			type = "event"
		}
	}
}

return ChainSwordBlur
