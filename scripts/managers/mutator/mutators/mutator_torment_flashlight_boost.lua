-- chunkname: @scripts/managers/mutator/mutators/mutator_torment_flashlight_boost.lua

require("scripts/managers/mutator/mutators/mutator_base")

local MutatorTormentFlashlightBoost = class("MutatorTormentFlashlightBoost", "MutatorBase")

MutatorTormentFlashlightBoost.update = function (self, dt, t)
	MutatorTormentFlashlightBoost.super.update(self, dt, t)

	if self._is_server then
		return
	end

	local boosted = self._boosted

	if boosted then
		if Unit.alive(boosted.unit) then
			local intensity_scale, falloff_scale = self:_scales()

			if boosted.intensity_scale ~= intensity_scale or boosted.falloff_scale ~= falloff_scale then
				self:_apply_scales(boosted, intensity_scale, falloff_scale)
			end

			return
		end

		self:_restore_boost()
	end

	local player = Managers.player:local_player(1)

	if not player or not player:unit_is_alive() then
		return
	end

	self:_apply_boost(player)
end

MutatorTormentFlashlightBoost.deactivate = function (self)
	if not self._is_server then
		self:_restore_boost()
	end

	MutatorTormentFlashlightBoost.super.deactivate(self)
end

MutatorTormentFlashlightBoost.destroy = function (self)
	if not self._is_server then
		self:_restore_boost()
	end

	MutatorTormentFlashlightBoost.super.destroy(self)
end

MutatorTormentFlashlightBoost._scales = function (self)
	local settings = self._template.player_light

	return settings.intensity_scale, settings.falloff_scale
end

MutatorTormentFlashlightBoost._apply_boost = function (self, player)
	local first_person_unit = ScriptUnit.extension(player.player_unit, "first_person_system"):first_person_unit()

	if not first_person_unit or not Unit.alive(first_person_unit) then
		return
	end

	local num_lights = Unit.num_lights(first_person_unit)

	if num_lights == 0 then
		return
	end

	local lights = {}

	for i = 1, num_lights do
		local light = Unit.light(first_person_unit, i)

		lights[i] = {
			light = light,
			intensity = Light.intensity(light),
			falloff_end = Light.falloff_end(light),
		}
	end

	local boosted = {
		unit = first_person_unit,
		lights = lights,
	}

	self:_apply_scales(boosted, self:_scales())

	self._boosted = boosted
end

MutatorTormentFlashlightBoost._apply_scales = function (self, boosted, intensity_scale, falloff_scale)
	boosted.intensity_scale = intensity_scale
	boosted.falloff_scale = falloff_scale

	for i = 1, #boosted.lights do
		local entry = boosted.lights[i]

		Light.set_intensity(entry.light, entry.intensity * intensity_scale)
		Light.set_falloff_end(entry.light, entry.falloff_end * falloff_scale)
	end
end

MutatorTormentFlashlightBoost._restore_boost = function (self)
	local boosted = self._boosted

	if not boosted then
		return
	end

	self._boosted = nil

	if not Unit.alive(boosted.unit) then
		return
	end

	for i = 1, #boosted.lights do
		local entry = boosted.lights[i]

		Light.set_intensity(entry.light, entry.intensity)
		Light.set_falloff_end(entry.light, entry.falloff_end)
	end
end

return MutatorTormentFlashlightBoost
