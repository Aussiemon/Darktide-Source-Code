-- chunkname: @scripts/components/magazine_ammo.lua

local MagazineAmmo = component("MagazineAmmo")

MagazineAmmo.editor_init = function (self, unit)
	self._top_bullet_visibility_group_name = self:get_data(unit, "top_bullet_visibility_group_name")
	self._is_animated = self:get_data(unit, "is_animated")
	self._anim_speed = self:get_data(unit, "anim_speed")
	self._use_simple_animation_length = self:get_data(unit, "use_simple_animation_length")
	self._dismantled = self:get_data(unit, "dismantled")
	self._dismantled_ammo_mask = self:get_data(unit, "dismantled_ammo_mask")

	local ammo_in_unit = self:get_data(unit, "ammo_in_unit") - 1
	local max_ammo = self:get_data(unit, "max_ammo") - 1
	local ammo = self:get_data(unit, "ammo") - 1
	local ammo_offset = self:get_data(unit, "ammo_offset")

	self._ammo_in_unit = ammo_in_unit
	self._max_ammo = max_ammo
	self._ammo = math.min(ammo, max_ammo)
	self._ammo_offset = ammo_offset < max_ammo and ammo_offset or max_ammo - 1
	self._unit = unit

	self:_update_ammo_representation(unit, true)
end

MagazineAmmo.editor_validate = function (self, unit)
	local success = true
	local error_message = ""
	local top_bullet_visibility_group_name = self:get_data(unit, "top_bullet_visibility_group_name")

	if rawget(_G, "LevelEditor") and not Unit.has_visibility_group(unit, top_bullet_visibility_group_name) then
		success = false
		error_message = error_message .. "\nCouldn't find visibility group '" .. top_bullet_visibility_group_name .. "'"
	end

	return success, error_message
end

MagazineAmmo.init = function (self, unit)
	self._top_bullet_visibility_group_name = self:get_data(unit, "top_bullet_visibility_group_name")
	self._is_animated = self:get_data(unit, "is_animated")
	self._anim_speed = self:get_data(unit, "anim_speed")
	self._use_simple_animation_length = self:get_data(unit, "use_simple_animation_length")
	self._dismantled = self:get_data(unit, "dismantled")
	self._dismantled_ammo_mask = self:get_data(unit, "dismantled_ammo_mask")

	local ammo_in_unit = self:get_data(unit, "ammo_in_unit") - 1
	local max_ammo = self:get_data(unit, "max_ammo") - 1
	local ammo = self:get_data(unit, "ammo") - 1
	local ammo_offset = self:get_data(unit, "ammo_offset")

	self._ammo_in_unit = ammo_in_unit
	self._max_ammo = max_ammo
	self._ammo = math.min(ammo, max_ammo)
	self._ammo_offset = ammo_offset < max_ammo and ammo_offset or max_ammo - 1
	self._unit = unit

	self:enable(unit)
end

MagazineAmmo.enable = function (self, unit)
	self:_update_ammo_representation(unit, false)
end

MagazineAmmo.disable = function (self, unit)
	return
end

MagazineAmmo.destroy = function (self, unit)
	return
end

MagazineAmmo._update_ammo_representation = function (self, unit, animate)
	local ammo = self._ammo
	local ammo_offset = self._ammo_offset
	local remaining_ammo = ammo - ammo_offset
	local max_ammo = self._max_ammo - ammo_offset
	local ammo_in_unit = self._ammo_in_unit - ammo_offset

	if max_ammo < ammo_in_unit then
		max_ammo = ammo_in_unit
	end

	if max_ammo < remaining_ammo then
		remaining_ammo = max_ammo
	end

	if self._is_animated then
		local inv_max_ammo = 1 / max_ammo
		local fraction = ammo > 0 and 1 - remaining_ammo / max_ammo or 1
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

		if animate and start_anim_time >= 0 then
			Unit.play_simple_animation(unit, start_anim_time, anim_time, false, self._anim_speed)
		else
			Unit.play_simple_animation(unit, anim_time, nil, false, 0)
		end

		Unit.set_scalar_for_materials(unit, "ammo_mask", fraction)
	end

	Unit.set_visibility(unit, self._top_bullet_visibility_group_name, remaining_ammo > 0)
end

MagazineAmmo.set_ammo = function (self, unit, ammo, max_ammo)
	ammo = math.max(0, ammo - 1)
	max_ammo = math.max(0, max_ammo - 1)

	if self._max_ammo ~= max_ammo then
		self._max_ammo = max_ammo
	end

	if self._ammo ~= ammo then
		self._ammo = ammo

		self:_update_ammo_representation(unit, true)
	end
end

MagazineAmmo.component_data = {
	top_bullet_visibility_group_name = {
		ui_name = "Top Bullet Visibility Group Name",
		ui_type = "text_box",
		value = "bullet",
	},
	ammo_in_unit = {
		decimals = 0,
		max = 40,
		min = 1,
		step = 1,
		ui_name = "Ammo in Unit",
		ui_type = "slider",
		value = 30,
	},
	max_ammo = {
		decimals = 0,
		max = 40,
		min = 1,
		step = 1,
		ui_name = "Max Ammo",
		ui_type = "slider",
		value = 30,
	},
	ammo = {
		decimals = 0,
		max = 40,
		min = 0,
		step = 1,
		ui_name = "Ammo",
		ui_type = "slider",
		value = 30,
	},
	ammo_offset = {
		decimals = 0,
		step = 1,
		ui_name = "Ammo Offset",
		ui_type = "slider",
		value = 2,
	},
	anim_speed = {
		decimals = 1,
		max = 10,
		min = 0.1,
		step = 0.1,
		ui_name = "Animation Speed",
		ui_type = "slider",
		value = 1,
	},
	use_simple_animation_length = {
		ui_name = "Use Anim Length",
		ui_type = "check_box",
		value = false,
	},
	is_animated = {
		ui_name = "Is Animatable",
		ui_type = "check_box",
		value = true,
	},
	dismantled = {
		ui_name = "Dismantled",
		ui_type = "check_box",
		value = false,
	},
	dismantled_ammo_mask = {
		decimals = 3,
		max = 1,
		min = 0,
		step = 0.001,
		ui_name = "Dismantled Mask",
		ui_type = "slider",
		value = 1,
	},
}

return MagazineAmmo
