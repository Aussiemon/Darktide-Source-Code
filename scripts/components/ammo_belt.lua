﻿-- chunkname: @scripts/components/ammo_belt.lua

local AmmoBelt = component("AmmoBelt")

AmmoBelt.editor_init = function (self, unit)
	self._anim_speed = self:get_data(unit, "anim_speed")
	self._use_simple_animation_length = self:get_data(unit, "use_simple_animation_length")
	self._num_belts = self:get_data(unit, "num_belts")
	self._dismantled = self:get_data(unit, "dismantled")
	self._dismantled_ammo_mask = self:get_data(unit, "dismantled_ammo_mask")

	local ammo_in_unit = self:get_data(unit, "ammo_in_unit")
	local max_ammo = self:get_data(unit, "max_ammo")
	local ammo = self:get_data(unit, "ammo")

	self._ammo_in_unit = ammo_in_unit
	self._max_ammo = max_ammo
	self._ammo = math.min(ammo, max_ammo)
	self._unit = unit

	self:_update_ammo_representation(unit, true)
end

AmmoBelt.editor_validate = function (self, unit)
	return true, ""
end

AmmoBelt.init = function (self, unit)
	self._anim_speed = self:get_data(unit, "anim_speed")
	self._use_simple_animation_length = self:get_data(unit, "use_simple_animation_length")
	self._num_belts = self:get_data(unit, "num_belts")
	self._dismantled = self:get_data(unit, "dismantled")
	self._dismantled_ammo_mask = self:get_data(unit, "dismantled_ammo_mask")

	local ammo_in_unit = self:get_data(unit, "ammo_in_unit")
	local max_ammo = self:get_data(unit, "max_ammo")
	local ammo = self:get_data(unit, "ammo")

	self._ammo_in_unit = ammo_in_unit
	self._max_ammo = max_ammo
	self._ammo = math.min(ammo, max_ammo)
	self._unit = unit

	self:enable(unit)
end

AmmoBelt.enable = function (self, unit)
	self:_update_ammo_representation(unit, false)
end

AmmoBelt.disable = function (self, unit)
	return
end

AmmoBelt.destroy = function (self, unit)
	return
end

AmmoBelt._update_ammo_representation = function (self, unit, is_animated)
	local remaining_ammo = self._ammo
	local max_ammo = self._max_ammo
	local ammo_in_unit = self._ammo_in_unit
	local num_belts = self._num_belts
	local above_cutoff = ammo_in_unit <= remaining_ammo

	if above_cutoff then
		local spent_ammo = max_ammo - remaining_ammo

		remaining_ammo = ammo_in_unit - spent_ammo % num_belts - 1
		max_ammo = ammo_in_unit
	else
		max_ammo = ammo_in_unit
	end

	local inv_max_ammo = 1 / max_ammo
	local fraction = 1 - remaining_ammo / max_ammo
	local anim_time_step, anim_time

	if self._use_simple_animation_length then
		local anim_length = Unit.simple_animation_length(unit)

		anim_time_step = anim_length * inv_max_ammo
		anim_time = fraction * anim_length
	else
		anim_time_step = inv_max_ammo
		anim_time = fraction
	end

	if self._dismantled then
		Unit.play_simple_animation(unit, 0, nil, false, 0)

		local ammo_mask = math.max(self._dismantled_ammo_mask, fraction)

		Unit.set_scalar_for_materials(unit, "ammo_mask", ammo_mask)

		return
	end

	local start_anim_time = math.round_with_precision(anim_time - anim_time_step, 4)

	if is_animated and start_anim_time >= 0 then
		Unit.play_simple_animation(unit, start_anim_time, anim_time, false, self._anim_speed)
	else
		Unit.play_simple_animation(unit, anim_time, nil, false, 0)
	end

	Unit.set_scalar_for_materials(unit, "ammo_mask", fraction)
end

AmmoBelt.set_ammo = function (self, unit, ammo, max_ammo)
	if self._max_ammo ~= max_ammo then
		self._max_ammo = max_ammo
	end

	if self._ammo ~= ammo then
		self._ammo = ammo

		self:_update_ammo_representation(unit, true)
	end
end

AmmoBelt.component_data = {
	ammo_in_unit = {
		ui_type = "slider",
		min = 1,
		max = 150,
		decimals = 0,
		value = 53,
		ui_name = "Ammo in Unit",
		step = 1
	},
	max_ammo = {
		ui_type = "slider",
		min = 1,
		max = 150,
		decimals = 0,
		value = 50,
		ui_name = "Max Ammo",
		step = 1
	},
	ammo = {
		ui_type = "slider",
		min = 0,
		max = 150,
		decimals = 0,
		value = 50,
		ui_name = "Ammo",
		step = 1
	},
	anim_speed = {
		ui_type = "slider",
		min = 0.1,
		step = 0.1,
		decimals = 1,
		value = 2,
		ui_name = "Animation Speed",
		max = 10
	},
	use_simple_animation_length = {
		ui_type = "check_box",
		value = false,
		ui_name = "Use Anim Length"
	},
	num_belts = {
		ui_type = "slider",
		min = 1,
		step = 1,
		decimals = 0,
		value = 1,
		ui_name = "Number of Ammo Belts",
		max = 4
	},
	dismantled = {
		ui_type = "check_box",
		value = false,
		ui_name = "Dismantled"
	},
	dismantled_ammo_mask = {
		ui_type = "slider",
		min = 0,
		step = 0.001,
		decimals = 3,
		value = 1,
		ui_name = "Dismantled Mask",
		max = 1
	}
}

return AmmoBelt
