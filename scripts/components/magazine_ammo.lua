local MagazineAmmo = component("MagazineAmmo")

MagazineAmmo.editor_init = function (self, unit)
	self.max_ammo = self:get_data(unit, "max_ammo")
	self.ammo = self:get_data(unit, "ammo")
	self.anim_speed = self:get_data(unit, "anim_speed")
	self.use_simple_animation_length = self:get_data(unit, "use_simple_animation_length")
	self.dismantled = self:get_data(unit, "dismantled")
	self.dismantled_ammo_mask = self:get_data(unit, "dismantled_ammo_mask")
	self.ammo_offset = self:get_data(unit, "ammo_offset")
	self._unit = unit

	self:update_ammo_representation(unit, true)
end

MagazineAmmo.init = function (self, unit)
	self.max_ammo = self:get_data(unit, "max_ammo")
	self.ammo = self:get_data(unit, "ammo")
	self.anim_speed = self:get_data(unit, "anim_speed")
	self.use_simple_animation_length = self:get_data(unit, "use_simple_animation_length")
	self.dismantled = self:get_data(unit, "dismantled")
	self.dismantled_ammo_mask = self:get_data(unit, "dismantled_ammo_mask")
	self.ammo_offset = self:get_data(unit, "ammo_offset")
	self._unit = unit

	self:enable(unit)
end

MagazineAmmo.enable = function (self, unit)
	self:update_ammo_representation(unit, false)
end

MagazineAmmo.disable = function (self, unit)
	return
end

MagazineAmmo.destroy = function (self, unit)
	return
end

MagazineAmmo.update_ammo_representation = function (self, unit, is_animated)
	local inmag_ammo = self.ammo - self.ammo_offset
	local inmag_max_ammo = self.max_ammo - self.ammo_offset

	if inmag_ammo > inmag_max_ammo then
		inmag_ammo = inmag_max_ammo
	end

	local fraction = 1 - inmag_ammo / inmag_max_ammo
	local anim_time_step, anim_time = nil

	if self.use_simple_animation_length then
		local anim_length = Unit.simple_animation_length(unit)
		anim_time_step = anim_length * 1 / inmag_max_ammo
		anim_time = fraction * anim_length
	else
		anim_time_step = 1 / inmag_max_ammo
		anim_time = fraction
	end

	if self.dismantled then
		Unit.play_simple_animation(unit, 0, nil, false, 0)

		local ammo_mask = math.max(self.dismantled_ammo_mask, fraction)

		Unit.set_scalar_for_materials(unit, "ammo_mask", ammo_mask)

		return
	end

	local start_anim_time = tonumber(string.format("%.4f", anim_time - anim_time_step))

	if is_animated and start_anim_time >= 0 then
		Unit.play_simple_animation(unit, start_anim_time, anim_time, false, self.anim_speed)
	else
		Unit.play_simple_animation(unit, anim_time, nil, false, 0)
	end

	Unit.set_scalar_for_materials(unit, "ammo_mask", fraction)

	if self.ammo == 0 and Unit.has_visibility_group(unit, "bullet") then
		Unit.set_visibility(unit, "bullet", false)
	end
end

MagazineAmmo.set_dismantled = function (self, unit, dismantled)
	self.dismantled = dismantled

	self:update_ammo_representation(unit, false)
end

MagazineAmmo.set_ammo = function (self, unit, ammo, max_ammo)
	self.ammo = ammo
	self.max_ammo = max_ammo

	self:update_ammo_representation(unit, false)
end

MagazineAmmo.set_anim_speed = function (self, anim_speed)
	self.anim_speed = anim_speed
end

MagazineAmmo.shoot = function (self, unit)
	if self.ammo > 0 and self.ammo <= self.max_ammo then
		self.ammo = self.ammo - 1

		self:update_ammo_representation(unit, true)
	end
end

MagazineAmmo.component_data = {
	max_ammo = {
		ui_type = "slider",
		decimals = 0,
		value = 30,
		ui_name = "Max Ammo",
		step = 1
	},
	ammo = {
		ui_type = "slider",
		decimals = 0,
		value = 30,
		ui_name = "Ammo",
		step = 1
	},
	ammo_offset = {
		ui_type = "slider",
		decimals = 0,
		value = 2,
		ui_name = "Ammo Offset",
		step = 1
	},
	anim_speed = {
		ui_type = "slider",
		min = 0.1,
		step = 0.1,
		decimals = 1,
		value = 1,
		ui_name = "Animation Speed",
		max = 10
	},
	use_simple_animation_length = {
		ui_type = "check_box",
		value = false,
		ui_name = "Use Anim Length"
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

return MagazineAmmo
